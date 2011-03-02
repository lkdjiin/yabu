# -*- encoding: utf-8 -*-
require './spec/helper'

describe LineParser do

  before :all do
    @parser = LineParser.new
  end
  
  it "must return action and filename" do
    action, filename = @parser.parse '+ the/file'
    action.should == :include
    filename.should == File.expand_path('the/file')
  end
  
  it "must recognize include" do
    action, filename = @parser.parse '+ the/file'
    action.should == :include
  end
  
  it "must recognize exclude" do
    action, filename = @parser.parse '- the/file'
    action.should == :exclude
  end
  
  it "must not crash" do
    action, filename = @parser.parse ''
    action.should == nil
    filename.should == nil
  end
  
end
