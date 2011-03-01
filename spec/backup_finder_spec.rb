# -*- encoding: utf-8 -*-
require './spec/helper'

describe BackupFinder do

  after :each do
		Dir.foreach(TEST_REPOSITORY) do |file|
			next if (file == ".") or (file == "..")
			filename = File.join(TEST_REPOSITORY, file)
			FileUtils.remove_dir(filename) if File.directory?(filename)
			FileUtils.remove_file(filename) if File.file?(filename)
		end
  end

  it "must raise error if repository doesnt exist" do
    lambda{BackupFinder.new('path/to/the/repository')}.should raise_error(ArgumentError)
  end
  
  it "must be created with a repository" do
    inst = BackupFinder.new(TEST_REPOSITORY)
  end
  
  it "must return false to #newest if there is no backups" do
    inst = BackupFinder.new(TEST_REPOSITORY)
    inst.newest.should == false
  end
  
  it "must return empty array to #all if there is no backups" do
    inst = BackupFinder.new(TEST_REPOSITORY)
    inst.all.should == []
  end
  
  it "must give the newest backup of the repository" do
    create_some_fake_backups
    inst = BackupFinder.new(TEST_REPOSITORY)
    inst.newest.should == '20110204-1200'
  end
  
  it "must give a list of all backups in the repository" do
    create_some_fake_backups
    inst = BackupFinder.new(TEST_REPOSITORY)
    list = inst.all
    
    list.include?('20110102-1200').should == true
    list.include?('20110103-1200').should == true
    list.include?('20110204-1200').should == true
  end
  
  def create_some_fake_backups
    FileUtils.mkdir File.join(TEST_REPOSITORY, '20110102-1200')
    FileUtils.mkdir File.join(TEST_REPOSITORY, '20110103-1200')
    FileUtils.mkdir File.join(TEST_REPOSITORY, '20110204-1200')
  end
  
end
