require 'treetop'
module Pre
  class Validator
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


    def valid_format?
      return false unless parsed.respond_to? :domain
      parsed.domain.dot_atom_text.elements.size > 1
    end

    def valid_domain?(validator = Pre::ServerValidator)
      validator = validator.new(parsed.domain.text_value)
      validator.valid?
    end

    private

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
      @parsed = @parser._nt_address
    end

  end
end
