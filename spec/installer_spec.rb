# -*- encoding: utf-8 -*-
require './spec/helper'

describe Message do

  before :each do
    @installer = Installer.new
  end

  #~ # @todo Capture output to make this test useful
  #~ it "must  print message to console" do
    #~ Install.message
  #~ end
  
  it "must tell if install is needed" do
    result = Install.needed?
    if File.exists?(File.join(ENV['HOME'], '.config/yabu'))
      result.should == false
    else
      result.should == true
    end
  end
  
  it "must tell if install is needed" do
    result = Install.new.needed?
    if File.exists?(File.join(ENV['HOME'], '.config/yabu'))
      result.should == false
    else
      result.should == true
    end
  end
  
  #~ it "must tell if upgrade is needed" do
    #~ my_version = Yabu.version
    #~ installed_version = File.read(File.join(ENV['HOME'], '.config/yabu/VERSION')).strip
    #~ result = Install.upgrade?
    #~ if my_version == installed_version
      #~ result.should == false
    #~ else
      #~ result.should == true
    #~ end
  #~ end
  
end
