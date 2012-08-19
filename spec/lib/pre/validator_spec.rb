require 'spec_helper'
require 'pre/validator'
require 'pre/server_validator'
require 'pre/fake_validation'

describe Pre::Validator do
  before do
    @validator = described_class.new
    @validator.extend Pre::FakeValidation
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
      @validator.stub_validators(
        :format, -> validator do
          raise "Should not have called format"  
        end,
        :server, true
      )
      @validator = described_class.new(:validators => :format)
      @validator.valid?("support@revolution.gov").should be_true
    end
  end
end
