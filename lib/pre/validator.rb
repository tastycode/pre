require 'treetop'
require 'pre/validators/format'
require 'pre/validators/domain'
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

    private

    def domain
      parsed.domain.text_value
    end

    def validators validators
      Array(validators || @options[:validators])
    end

    def validate strategy
      internal_method = "valid_#{strategy}?".to_sym
      return send(internal_method) if respond_to? internal_method
      return strategy.call @raw_address if strategy.respond_to? :call
      return strategy.valid? @raw_address if strategy.respond_to? :valid?
      raise ArgumentError, "Could not identify strategy #{strategy}"
    end

    def defaults options
      options[:validators] ||= [:format, :domain]
      @options = options
    end

    def parsed
      return @parsed if @parsed
      Treetop.load File.join(File.dirname(__FILE__), 'rfc2822_obsolete')
      Treetop.load File.join(File.dirname(__FILE__), 'rfc2822')
      @parser = RFC2822Parser.new  
      @parser.parse @raw_address
      @parsed = @parser._nt_address#.tap {|t| binding.pry}
    end

  end
end
