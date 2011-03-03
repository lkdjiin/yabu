# -*- encoding: utf-8 -*-
require './spec/helper'

describe Installer do
  
  before :each do
    @base_dir = File.expand_path TEST_REPOSITORY
    # if we don't provide @base_dir in argument, the Installer
    # class set it automatically to ENV['HOME']. We don't want
    # that for our testing purposes !
    @installer = Installer.new @base_dir
  end
  
  after :each do
    clean_test_repository
  end
  
  def make_base_dir
    FileUtils.makedirs File.join(@base_dir, '.config/yabu')
  end
  
  def write_version_file num_as_string
    make_base_dir
    f = File.new(File.join(@base_dir, '.config/yabu', 'VERSION'), "w")
    f.write num_as_string
    f.close
  end
  
  def read_version_file
    File.read(File.join(@base_dir, '.config/yabu', 'VERSION')).strip
  end
  
  it "must tell if install is needed" do
    @installer.install_needed?.should == true
    make_base_dir
    @installer.install_needed?.should == false
  end
  
  it "must tell if upgrade is needed" do
    my_version = Yabu.version
    installed_version = '0.0'
    write_version_file installed_version
    
    @installer.upgrade_needed?.should == true
  end
  
  it "must upgrade" do
    my_version = Yabu.version
    installed_version = '0.0'
    write_version_file installed_version
    @installer.upgrade
    
    read_version_file.should == my_version
  end
  
  it "must install then exit" do
    lambda{@installer.install}.should raise_error(SystemExit)
    
    File.exist?(File.join(@base_dir, '.config/yabu', 'VERSION')).should == true
    File.exist?(File.join(@base_dir, '.config/yabu', 'configuration/directories.conf')).should == true
    File.exist?(File.join(@base_dir, '.config/yabu', 'configuration/yabu.conf')).should == true
  end
  
end
