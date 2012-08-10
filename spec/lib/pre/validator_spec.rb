require 'spec_helper'
require 'pre/validator'
require 'pre/server_validator'

describe Pre::Validator do
  it "indicates a basic email address is valid" do
    @validator = described_class.new("vajrapani666@gmail.com")
    @validator.should be_valid
  end

  it "invalidates email for non-matching regex" do
    @validator = described_class.new("vajrapani666-gmail.com")
    @validator.should_not be_valid
  end

  it "invalidates email for non-existent server" do
    @validator = described_class.new("support@revolution.gov")
    @validator.should_receive(:valid_domain?).and_return(false)
    @validator.should_not be_valid
  end
end
