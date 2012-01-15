require 'spec_helper'

describe ActiveGist::Files do
  describe "with no files" do
    it "should produce empty json" do
      subject.as_json.should == {}.as_json
    end
  end
  
  describe "with 1 file" do
    before { subject['file1.txt'] = { :content => 'data' } }
    it "should produce json with a file" do
      subject.as_json.should == { 'file1.txt' => { :content => 'data' } }.as_json
    end
  end
end
