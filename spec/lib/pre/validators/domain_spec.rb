require 'spec_helper'
require 'ostruct'
describe Pre::Validators::Domain do
  let (:validator) do 
    class << fake_validator = Object.new
      include Pre::Cache::Fake 
      define_method(:domain) { "gmail.com" }
      define_method(:cache_key) { |key| key }
    end
    fake_validator.extend Pre::Validators::Domain
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

  it "caches mx lookups" do
    result = validator.valid_domain?(stub(:getresources => ["mx"]))
    result.should be_true
  end
end


