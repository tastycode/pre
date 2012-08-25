require 'treetop'
require 'pre/validators/format'
require 'pre/validators/domain'
require 'pre/cache_store'

module Pre
  class Validator
    include Validators::Format
    include Validators::Domain

    attr_accessor :raw_address

    def initialize options = {}
      @options = defaults options
    end

    def valid? address, options = {}
      self.address= address
      validators(options[:validators]).all? do |strategy|
        validate strategy
      end
    end

    def address= new_address
      @parsed = nil
      @raw_address = new_address
    end

    def cache_read key
      @options[:cache_store].read key
    end

    def cache_write key, value
      @options[:cache_store].write key, value
    end

    def cache_fetch key, &block
      @options[:cache_store].fetch key, &block
    end

    private

    def domain
      parsed.domain.text_value
    end

    def address
      @raw_address
    end

    def validators validators
      Array(validators || @options[:validators])
    end

    def validate strategy
      internal_method = "valid_#{strategy}?".to_sym
      return send(internal_method) if respond_to? internal_method
      return strategy.call @raw_address if strategy.respond_to? :call
      return delegated strategy if strategy.respond_to? :delegate=
      return strategy.valid? @raw_address if strategy.respond_to? :valid?
      raise ArgumentError, "Could not identify strategy #{strategy}"
    end

    def delegated strategy
      strategy.delegate = self
      strategy.valid? address
    end

    def defaults options
      options[:validators] ||= [:format, :domain]
      options[:cache_store] ||= Pre::CacheStore::Null.new
      @options = options
    end

    def rfc2822_parser(treetop = Treetop)
      ['rfc2822_obsolete', 'rfc2822'].each do |grammar|
        treetop.require File.join(File.dirname(__FILE__), grammar)
      end
      RFC2822Parser.new
    end

    def parsed
      return @parsed if @parsed
      @parser = rfc2822_parser
      @parser.parse @raw_address
      @parsed = @parser._nt_address#.tap {|t| binding.pry}
    end

  end
end
