module Pre
  module FakeValidation
    
    def stub_validator strategy, result
      stubed_validators[strategy] = result 
    end

    def stub_validators *stubs
      stubs.each_slice(2) do |strategy, result|
        stub_validator strategy, result
      end
    end

    def stubed_validators
      @stubed_validators ||= {}
    end
    
    def validates strategy
      return super unless stubed_validators.has_key? strategy
      result = stubed_validators[strategy]
      return result.call self if result.respond_to? :call
      result
    end
  end
end
