require 'spec_helper'
require 'pre/validator'
require 'pre/server_validator'
require 'pre/fake_validation'
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

    it "allows delegated valid? method for validator" do
      validating_stub = stub(:valid? => false)
      @validator = test_validator :validators => validating_stub
      @validator.valid?("info@revolution.gov").should be_false
    end
  end
end
