module Pre
  module FakeValidation
    
    def stub_validator strategy, result
      stubbed_validators[strategy] = result 
    end

    def stub_validators *stubs
      stubs.each_slice(2) do |strategy, result|
        stub_validator strategy, result
      end
    end

    def stubbed_validators
      @stubbed_validators ||= {}
    end
    
    def validate strategy
      return super unless stubbed_validators.has_key? strategy
      result = stubbed_validators[strategy]
      return result.call self if result.respond_to? :call
      result
    end
  end
end
