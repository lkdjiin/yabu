# -*- encoding: utf-8 -*-
require './spec/helper'

describe Options do

  it "must respond to version and exit" do
    lambda{Options.new(["--version"])}.should raise_error(SystemExit)
    lambda{Options.new(["-v"])}.should raise_error(SystemExit)
  end
  
  it "must respond to license and exit" do
    lambda{Options.new(["--license"])}.should raise_error(SystemExit)
    lambda{Options.new(["-l"])}.should raise_error(SystemExit)
  end
  
  it "must respond to help and exit" do
    lambda{Options.new(["--help"])}.should raise_error(SystemExit)
    lambda{Options.new(["-h"])}.should raise_error(SystemExit)
  end
  
  it "must respond to test" do
    opt = Options.new([])
    opt[:test].should == false
    
    opt = Options.new(["--test"])
    opt[:test].should == true
    
    opt = Options.new(["-t"])
    opt[:test].should == true
  end
  
  it "must respond to force" do
    opt = Options.new([])
    opt[:force].should == false
    
    opt = Options.new(["--force"])
    opt[:force].should == true
    
    opt = Options.new(["-f"])
    opt[:force].should == true
  end
end
