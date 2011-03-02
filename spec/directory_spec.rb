# -*- encoding: utf-8 -*-
require './spec/helper'

describe Directory do

  before :all do
    @dir_name = File.expand_path "tests/this_is_a_dir"
  end
  
  after :each do
    FileUtils.remove_dir @dir_name if File.exist? @dir_name
  end
  
  it "must create a needed dir if it doesnt exist" do
    Directory.new.create_if_needed @dir_name
    File.directory?(@dir_name).should == true
  end
  
  it "must create a dir" do
    Directory.new.create @dir_name
    File.directory?(@dir_name).should == true
  end
  
  it "must return false if it cannot create the dir" do
    dir_name = File.expand_path "tests/this_is_a_dir/and_this_is_another"
    Directory.new.create(dir_name).should == false
  end
  
  it "must return true if it can create the dir" do
    Directory.new.create(@dir_name).should == true
  end
  
  it "must exit if it cannot create the needed dir" do
    lambda{Directory.new.create_if_needed '/forbidden/dir'}.should raise_error(SystemExit)
  end
  
end
