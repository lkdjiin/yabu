# -*- encoding: utf-8 -*-
require './lib/yabu'

describe Yabu::Help do

  before :all do
    @commands = ['help', 'recover', 'backup']
  end
  
  it "should respond to each command" do
    @commands.each do |cmd|
      Yabu::Help.respond_to?(cmd).should == true
		end
  end
  
  it "should return string" do
		@commands.each do |cmd|
      Yabu::Help.send(cmd).class.should == String
		end
	end
  
end