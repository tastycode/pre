require 'spec_helper'
require 'ostruct'
describe Pre::Validators::Domain do
  let (:validator) do 
    OpenStruct.new(:domain => "gmail.com").extend Pre::Validators::Domain
  end

  describe "when dns resolution returns no mx records" do
    it "returns false" do
      result = validator.valid_domain?(stub(:getresources => []))
      result.should be_false
    end
  end

  describe "when dns resolution returns mx records" do
    it "returns true" do
      result = validator.valid_domain?(stub(:getresources => ["mx"]))
      result.should be_true
    end
  end
end


