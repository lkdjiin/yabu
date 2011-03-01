# -*- encoding: utf-8 -*-
require './spec/helper'

describe Recovery do
  
  after :each do
		Dir.foreach(BACKED_UP_DIR) do |file|
			next if (file == ".") or (file == "..")
			filename = File.join(BACKED_UP_DIR, file)
			FileUtils.remove_dir(filename) if File.directory?(filename)
			FileUtils.remove_file(filename) if File.file?(filename)
		end
    
    Dir.foreach(TEST_REPOSITORY) do |file|
			next if (file == ".") or (file == "..")
			filename = File.join(TEST_REPOSITORY, file)
			FileUtils.remove_dir(filename) if File.directory?(filename)
			FileUtils.remove_file(filename) if File.file?(filename)
		end
  end
  
  # Lets say that folder 'tests/backed_up' should contains 2 files: foo.txt and bar.txt
  # foo.txt will be the missing one, we have to check it will be restored.
  # bar.txt will be zero length to prove it has not been restored (cause we create a backup
  # with a lengthy bar.txt, see #create_little_backup).
  it "must recover one missing file" do
    create_little_backup
		FileUtils.touch 'tests/backed_up/bar.txt'
    
    restore
    
		File.exist?('tests/backed_up/foo.txt').should == true
		File.zero?('tests/backed_up/bar.txt').should == true
  end
  
  it "must recover a missing dir and its content" do
    create_little_backup_2
    
    restore
    
    File.exist?('tests/backed_up/missing_dir/foo.txt').should == true
		File.exist?('tests/backed_up/missing_dir/bar.txt').should == true
  end
  
  # Lets say that folder 'tests/backed_up' should contains 2 files: foo.txt and bar.txt
  # foo.txt will be the missing one, we have to check it will be restored.
  # bar.txt will be present but will be zero length to prove it has really been restored.
  it "must recover all files when forced" do
    create_little_backup
		FileUtils.touch 'tests/backed_up/bar.txt'
    
    restore force: true
    
		File.exist?('tests/backed_up/foo.txt').should == true
    File.exist?('tests/backed_up/bar.txt').should == true
		File.zero?('tests/backed_up/bar.txt').should == false
  end
  
  def create_little_backup 
    bk_dir = File.expand_path(TEST_REPOSITORY)
    bk_dir = File.join(bk_dir, '20110101-1234')
    bk_dir = File.join(bk_dir, File.expand_path(BACKED_UP_DIR))
		FileUtils.makedirs(bk_dir)
		FileUtils.cp('tests/store/lengthy/foo.txt', bk_dir)
		FileUtils.cp('tests/store/lengthy/bar.txt', bk_dir)
	end
  
  def create_little_backup_2
    bk_dir = File.expand_path(TEST_REPOSITORY)
    bk_dir = File.join(bk_dir, '20110101-1234')
    bk_dir = File.join(bk_dir, File.expand_path(BACKED_UP_DIR))
    bk_dir = File.join(bk_dir, 'missing_dir')
		FileUtils.makedirs(bk_dir)
		FileUtils.cp('tests/store/lengthy/foo.txt', bk_dir)
		FileUtils.cp('tests/store/lengthy/bar.txt', bk_dir)
	end
  
  def restore options={}
		rec = Recovery.new YABU_CONF
		rec.run options
	end
  
  
end
