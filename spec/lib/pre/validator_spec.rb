require_relative '../../spec_helper'
require 'pry'
describe Pre::Validator do
  def test_validator options={}
    @validator = described_class.new options
    @validator.extend Pre::FakeValidation
  end

  before do
    @validator = test_validator
  end

  context "default configuration" do
    it "indicates a basic email address is valid" do
      @validator.valid?("vajrapani666@gmail.com").should be_true
    end

    it "invalidates email for invalid format" do
      @validator.valid?("vajrapani666-gmail.com").should be_false
    end

    it "invalidates email for non-existent server" do
      @validator.stub_validator :domain, false
      @validator.valid?("support@revolution.gov").should be_false
    end
  end

  context "configuration" do

    it "allows server validation to be toggled" do
      @validator = test_validator :validators => :format
      @validator.stub_validators(
        :server, -> validator do
          raise "Should not have called format"  
        end,
        :format, true
      )
      @validator.valid?("support@revolution.gov").should be_true
    end

    it "allows one-time configuration" do
      @validator = test_validator :validators => []
      @validator.stub_validator :format, false
      @validator.valid?("support@revolution.gov", :validators => :format).should be_false
    end

    it "allows lambda for validators" do
      @validator = test_validator(:validators => -> address do
        address !~ /^i.*gov$/  
      end)
      @validator.valid?("info@revolution.gov").should be_false
      @validator.valid?("contact@revolution.org").should be_true
    end

    it "allows any object responding to valid? method for validator" do
      validating_stub = stub(:valid? => false)
      @validator = test_validator :validators => validating_stub
      @validator.valid?("info@revolution.gov").should be_false
    end

    it "allows a delegate to be specified" do
      validating_delegate = mock()
      @validator = test_validator :validators => validating_delegate
      validating_delegate.expects(:delegate=).with(@validator)
      validating_delegate.expects(:valid?).returns(false)
      @validator.valid?("any@address.com").should be_false
    end

  end
  context "caching config" do
    context "allows a cache store to be configured" do
      it "delegates cache_read to cache store" do
        mock_cache = mock()
        mock_cache.expects(:read).with("test_key")
        @validator = test_validator :validators => [], :cache_store => mock_cache
        @validator.cache_read "test_key"
      end


      it "delegates cache_read to cache store" do
        mock_cache = mock()
        mock_cache.expects(:write).with("test_key", "test_value")
        @validator = test_validator :validators => [], :cache_store => mock_cache
        @validator.cache_write "test_key", "test_value"
      end

      it "exposes caching ability to collaborators" do
        validating_delegate = Object.new
        class << validating_delegate
          
          def delegate=(validator)
            @validator = validator
          end

          def expensive_method
            :expensive_result
          end

          def valid? address
            existing_value = @validator.cache_read "foo"
            return existing_value if existing_value
            result = expensive_method  
            @validator.cache_write "foo", result
            false 
          end
        end

        mock_cache = mock()
        mock_cache.expects(:read).with("foo")
        mock_cache.expects(:write).with("foo", :expensive_result)

        @validator = test_validator :validators => validating_delegate, :cache_store => mock_cache
        @validator.valid? "test@example.com"
      end

    end
  end
end
