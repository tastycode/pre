require 'treetop'
require 'pry'
require 'resolv'
module Pre
  class Validator
    attr_accessor :raw_address
    def initialize(address, options = {})
      @raw_address = address
    end

    def valid?
      parse unless @parsed
      valid_format? && valid_domain?
    end

    private

    def parse
      Treetop.load File.join(File.dirname(__FILE__), 'rfc2822_obsolete')
      Treetop.load File.join(File.dirname(__FILE__), 'rfc2822')
      @parser = RFC2822Parser.new  
      @parser.parse @raw_address
      @parsed = @parser._nt_address
    end

    def valid_format?
      return false unless @parsed.respond_to? :domain
      @parsed.domain.dot_atom_text.elements.size > 1
    end

    def valid_domain?(validator = Pre::ServerValidator)
      validator = validator.new(@parsed.domain.text_value)
      validator.valid?
    end
  end
end
