# -*- encoding: utf-8 -*-
require './spec/helper'

describe FilesRestorer do
  
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
  
  it "must raise error if backup folder doesnt exist" do
    lambda{FilesRestorer.new('unknown/backup/dir')}.should raise_error(ArgumentError)
  end
  
  it "must accept a backup folder that exist" do
    lambda{FilesRestorer.new(TEST_REPOSITORY)}.should_not raise_error
  end
  
  it "must restore one missing file" do
    create_little_backup
    inst = FilesRestorer.new(File.join(TEST_REPOSITORY, '20110101-1234'))
    inst.run
		File.exist?('tests/backed_up/foo.txt').should == true
  end
  
  it "must not restore an existing file" do
    create_little_backup
    FileUtils.touch 'tests/backed_up/foo.txt'
    inst = FilesRestorer.new(File.join(TEST_REPOSITORY, '20110101-1234'))
    inst.run
    File.zero?('tests/backed_up/foo.txt').should == true
  end
  
  it "must restore an existing file when forced" do
    create_little_backup
		FileUtils.touch 'tests/backed_up/foo.txt'
    
    inst = FilesRestorer.new(File.join(TEST_REPOSITORY, '20110101-1234'), force: true)
    inst.run
    
		File.exist?('tests/backed_up/foo.txt').should == true
		File.zero?('tests/backed_up/foo.txt').should == false
  end
  
  def create_little_backup 
    bk_dir = File.expand_path(TEST_REPOSITORY)
    bk_dir = File.join(bk_dir, '20110101-1234')
    bk_dir = File.join(bk_dir, File.expand_path(BACKED_UP_DIR))
		FileUtils.makedirs(bk_dir)
		FileUtils.cp('tests/store/lengthy/foo.txt', bk_dir)
	end
  
end
