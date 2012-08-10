require 'spec_helper'
require 'pre/server_validator'
describe Pre::ServerValidator do
  subject { described_class.new("gmail.com") }
  describe "when dns resolution returns no mx records" do
    it "returns false" do
      result = subject.valid?(stub(:new => stub(:getresources => [])))
      result.should be_false
    end
  end

  describe "when dns resolution returns mx records" do
    it "returns true" do
      result = subject.valid?(stub(:new => stub(:getresources => ["mx"])))
      result.should be_true
    end
  end
end


