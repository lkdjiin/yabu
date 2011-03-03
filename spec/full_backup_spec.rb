# -*- encoding: utf-8 -*-
require './spec/helper'

describe FullBackup do

  before :all do
    @backup_folder = File.expand_path(File.join(TEST_REPOSITORY, '20110303-1234'))
    @dir_config = DirConfig.new DIR_CONF
  end
  
  before :each do
    FileUtils.makedirs(@backup_folder)
  end
  
  after :each do
		clean_test_repository
  end
  
  it "must exit if backup folder is not writable" do
    lambda {FullBackup.new('this/is/an/unknown/path', @dir_config)}.should raise_error(SystemExit)
  end
  
  it "must create a full backup mark" do
		instance = FullBackup.new(@backup_folder, @dir_config)
    instance.backup
		File.exist?(@backup_folder +  '.full').should == true
  end
  
  it "must backup" do
		FullBackup.new(@backup_folder, @dir_config).backup
		
		to_check = File.join(@backup_folder, File.expand_path('tests/dir1'))

		File.exist?(to_check).should == true
		
		bar = File.join(to_check, 'bar.txt')
		foo = File.join(to_check, 'foo.txt')
		
		File.exist?(bar).should == false
		File.exist?(foo).should == true
  end
  
  it "must return the most recent full" do
		FileUtils.touch File.join(TEST_REPOSITORY, '20110101-1234.full')
		FileUtils.touch File.join(TEST_REPOSITORY, '20110122-1234.full')
		result = FullBackup.most_recent(File.expand_path(TEST_REPOSITORY))
		result.should == '20110122-1234'
	end
  
  it "must return nil when no full exist" do
		result = FullBackup.most_recent(File.expand_path(TEST_REPOSITORY))
		result.should == nil
	end
end
