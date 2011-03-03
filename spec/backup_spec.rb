# -*- encoding: utf-8 -*-
require './spec/helper'

describe Backup do
  
  after :each do
		clean_test_repository
  end
  
  # Find name of the just created backup folder. Assume there is only one folder in TEST_REPOSITORY.
	# @return [String] name of the backup folder
	def find_name_of_just_created_backup
		name = ''
		Dir.foreach(TEST_REPOSITORY) do |file|
			next if (file == ".") or (file == "..")
			name = file if File.directory?(File.join(TEST_REPOSITORY, file))
		end
		name
	end
  
  it "must exit when cannot create backup folder" do
    lambda {Backup.new('tests/configuration/yabu.conf.test2')}.should raise_error(SystemExit)
  end
  
  it "must create one and only one folder for a full backup" do
		Backup.new(YABU_CONF, DIR_CONF).full
    
		number = 0
		Dir.foreach(TEST_REPOSITORY) do |file|
			next if (file == ".") or (file == "..")
			number += 1 if File.directory?(File.join(TEST_REPOSITORY, file))
		end
    
    number.should == 1
	end
  
  it "must create a full backup mark" do
		Backup.new(YABU_CONF, DIR_CONF).full
		name = File.join(TEST_REPOSITORY, find_name_of_just_created_backup)
		File.exist?(name +  '.full').should == true
  end
  
  it "must backup" do
		Backup.new(YABU_CONF, DIR_CONF).full
		name = File.join(TEST_REPOSITORY, find_name_of_just_created_backup)
		
		to_check = File.join(name, File.expand_path('tests/dir1'))
		File.exist?(to_check).should == true
		
		bar = File.join(to_check, 'bar.txt')
		foo = File.join(to_check, 'foo.txt')
		
		File.exist?(bar).should == false
		File.exist?(foo).should == true
  end
  
  ### INCREMENTAL BACKUP ###############
	
	it "must not create incremental without full mark" do
		bk = Backup.new(YABU_CONF, DIR_CONF)
    lambda { bk.incremental }.should raise_error(NoFullBackupError)
	end
	
	#~ def test_first_incremental_with_nothing_changed
		#~ assert false
	#~ end
	#~ 
	#~ def test_first_incremental_with_one_file_added
		#~ assert false
	#~ end
	#~ 
	#~ def test_first_incremental_with_one_file_modified
		#~ assert false
	#~ end
	#~ 
	#~ def test_first_incremental_with_one_folder_added
		#~ assert false
	#~ end
	#~ 
	#~ def test_first_incremental_with_one_file_deleted
		#~ assert false
	#~ end
	#~ 
	#~ def test_first_incremental_with_one_folder_deleted
		#~ assert false
	#~ end
  
end
