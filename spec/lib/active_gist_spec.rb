require 'spec_helper'
require 'test/unit'

describe ActiveGist do
  describe "validation" do
    before { subject.valid? }
    
    it "should not validate presence of description" do
      subject.errors[:description].should_not include("can't be blank")
    end
    
    it "should not validate presence of public" do
      # github requires this but we're just going to default it to false
      subject.errors[:public].should_not include("can't be blank")
    end
    
    it "should validate presence of files" do
      subject.errors[:files].should include("can't be blank")
    end
  end
  
  describe "creating a valid gist with arrays and hashes" do
    subject { ActiveGist.create!(:files => [{ "file1.txt" => { :content => 'String file contents' } }]) }
    
    it "should return the new gist" do
      subject.id.should == '1'
      subject.url.should == 'https://api.github.com/gists/1'
      subject.should be_public # this would default to false but our fake response returns true
    end
  end
  
  it "should have a count of all gists" do
    ActiveGist.count.should == 3
  end
  
  it "should have a count of public gists" do
    ActiveGist.count(:public).should == 2
  end
  
  it "should have a count of starred gists" do
    ActiveGist.count(:starred).should == 1
  end
  
  it "should return the last gist" do
    ActiveGist.last.id.should == '3'
  end
  
  it "should return the first gist" do
    ActiveGist.first.id.should == '1'
  end
  
  it "should find a gist by id" do
    ActiveGist.find(2).should == ActiveGist.all[1]
  end
  
  describe "a gist returned by github" do
    subject { ActiveGist.first }
    it { should respond_to(:url) }
    it { should respond_to(:id) }
    it { should respond_to(:description) }
    it { should respond_to(:public?) }
    it { should respond_to(:user) }
    it { should respond_to(:files) }
    it { should respond_to(:comments) }
    it { should respond_to(:html_url) }
    it { should respond_to(:git_pull_url) }
    it { should respond_to(:git_push_url) }
    it { should respond_to(:created_at) }
  end
  
  describe "fetching all gists" do
    # before { FakeWeb.register_uri  }
    subject { ActiveGist.all }
    
    it { should have(3).gists }
  end
  
  describe "active model lint tests" do
    include Test::Unit::Assertions
    include ActiveModel::Lint::Tests

    def model
      subject
    end

    # to_s is to support ruby-1.9
    ActiveModel::Lint::Tests.public_instance_methods.map{|m| m.to_s}.grep(/^test/).each do |m|
      example m.gsub('_',' ') do
        send m
      end
    end
  end
end
