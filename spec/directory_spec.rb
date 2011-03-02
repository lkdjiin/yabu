# -*- encoding: utf-8 -*-
require './spec/helper'

describe Directory do

  before :all do
    @dir_name = File.expand_path "tests/this_is_a_dir"
  end
  
  after :each do
    FileUtils.remove_dir DEST_CONFIGURATION if File.exist? DEST_CONFIGURATION
  end
  
  it "must create a dir if it doesnt exist" do
    Directory.new.create_if_needed @dir_name
    File.directory?(@dir_name).should == true
  end
  
  it "must exit if it cannot create the dir" do
    lambda{Directory.new.create_if_needed '/forbidden/dir'}.should raise_error(SystemExit)
  end
  
end
