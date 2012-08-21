module Pre
  module Validators
    module Format
      def valid_format?
        return false unless parsed.respond_to? :domain
        parsed.domain.dot_atom_text.elements.size > 1
      end
    end
  end
end

