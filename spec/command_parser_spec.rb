# -*- encoding: utf-8 -*-
require './spec/helper'

describe CommandParser do

  it "must respond to backup?" do
    instance = CommandParser.new ["backup"]
    instance.backup?.should == true
    instance = CommandParser.new ["recover"]
    instance.backup?.should == false
  end
  
  it "must say true to backup? if command line is empty" do
    instance = CommandParser.new []
    instance.backup?.should == true
  end
  
  it "must respond to recover?" do
    instance = CommandParser.new ["recover"]
    instance.recover?.should == true
    instance = CommandParser.new ["help"]
    instance.recover?.should == false
  end
  
  it "must say false to recover? if command line is empty" do
    instance = CommandParser.new []
    instance.recover?.should == false
  end
  
  it "must respond to help?" do
    instance = CommandParser.new ["help"]
    instance.help?.should == true
    instance = CommandParser.new ["backup"]
    instance.help?.should == false
  end
  
  it "must say false to help? if command line is empty" do
    instance = CommandParser.new []
    instance.help?.should == false
  end
  
  it "must give sub-command help>backup" do
    instance = CommandParser.new ["help", "backup"]
    instance.sub_command.should == :backup
  end
  
  it "must give sub-command help>recover" do
    instance = CommandParser.new ["help", "recover"]
    instance.sub_command.should == :recover
  end
  
  it "must give sub-command help>help" do
    instance = CommandParser.new ["help", "help"]
    instance.sub_command.should == :help
  end
  
  it "must give nil sub-command if command is not help" do
    instance = CommandParser.new ["recover", "help"]
    instance.sub_command.should == nil
  end
  
  it "must give nil sub-command if it doesnt exist" do
    instance = CommandParser.new ["help"]
    instance.sub_command.should == nil
  end
  
end
