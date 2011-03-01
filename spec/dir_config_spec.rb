# -*- encoding: utf-8 -*-
require './spec/helper'

describe DirConfig do

  before :all do
    @config = DirConfig.new("tests/configuration/directories.conf.test", true)
  end
  
  it "must return an array of files to backup" do
		@config.files.is_a?(Array).should == true
  end
  
  it "must return the right files" do
    part_expected = File.expand_path 'tests/dir1'
    @config.files.include?(part_expected).should == true
  end
  
  it "must return an array of files to excludes from backup" do
		@config.files_to_exclude.is_a?(Array).should == true
  end
  
  it "must return the right excluded files" do
    part_expected = File.expand_path 'tests/dir1/dir2'
    @config.files_to_exclude.include?(part_expected).should == true
  end
  
  it "must not crash on bad written config files" do
    lambda{DirConfig.new("tests/configuration/directories.conf.test3", true)}.should_not raise_error
  end
  
end
