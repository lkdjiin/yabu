# -*- encoding: utf-8 -*-
require './spec/helper'

describe FileCopier do

  before :all do
    @regular_file = File.expand_path('tests/store/lengthy/foo.txt')
    @symlink = File.expand_path('tests/store/lengthy/symbolic')
    @target = File.expand_path(File.join(TEST_REPOSITORY, 'foo.txt'))
    @instance = FileCopier.new
  end
  
  after :each do
    FileUtils.remove_file(@target) if File.exist?(@target)
  end
  
  it "must copy a regular file" do
    @instance.copy @regular_file, TEST_REPOSITORY
    File.exist?(@target).should == true
  end
  
  it "must return true if copy succeded" do
    @instance.copy(@regular_file, TEST_REPOSITORY).should == true
  end
  
  it "must return false when trying to copy a folder" do
    @instance.copy(TEST_REPOSITORY, TEST_REPOSITORY).should == false
  end
  
  it "must return false when trying to copy to a bad folder" do
    @instance.copy(@regular_file, '/bad/folder/name').should == false
  end
  
  it "must return false when trying to copy a symlink" do
    @instance.copy(@symlink, TEST_REPOSITORY).should == false
  end
  
end
