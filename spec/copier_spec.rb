# -*- encoding: utf-8 -*-
require './spec/helper'

describe Copier do

  DEST_CONFIGURATION = File.expand_path 'tests/temp/configuration'
  DEST_FOLDER = File.expand_path 'tests/temp/folder'
  
  before :all do
    @copier = Copier.new([])
  end
  
  after :each do
    FileUtils.remove_dir DEST_CONFIGURATION if File.exist? DEST_CONFIGURATION
    FileUtils.remove_dir DEST_FOLDER if File.exist? DEST_FOLDER
  end
  
  it "must copy directory content" do
    source = File.expand_path 'tests/configuration'
		@copier.copy(source, DEST_CONFIGURATION)
    target = File.join(DEST_CONFIGURATION, 'directories.conf.test')
    File.exist?(target).should == true
  end
  
  it "must exclude the given list from copy" do
    source = File.expand_path 'tests/configuration'
    exclude = File.expand_path 'tests/configuration/yabu.conf'
    must_exist = File.join(DEST_CONFIGURATION, 'directories.conf.test')
    must_not_exist = File.join(DEST_CONFIGURATION, 'yabu.conf')
    copier = Copier.new([exclude])
    
    copier.copy(source, DEST_CONFIGURATION)
    
    File.exist?(must_exist).should == true
    File.exist?(must_not_exist).should == false
  end
  
  it "must report error if source doesn't exist" do
    source = File.expand_path 'tests/configuration'
    source = File.join source, 'unknown'
    @copier.copy(source, DEST_CONFIGURATION)
    @copier.errors.should == 1
  end

  ### BUGS #########
  
  # Bug 5
  #
  # in 0.6, cannot save:
  #   /home/USER/folder/file
  # if this line comes before a line like:
  #   /home/USER/folder
  it "must avoid bug 5" do
    source = File.expand_path 'tests/configuration/yabu.conf'
    dest = File.join DEST_FOLDER, 'yabu.conf'
		
		@copier.copy(source, dest)
		File.exist?(dest).should == true
  end
  
end
