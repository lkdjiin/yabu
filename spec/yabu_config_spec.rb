# -*- encoding: utf-8 -*-
require './spec/helper'

describe YabuConfig do

  before :each do
    @config = YabuConfig.new
  end
	
	it "must give a path" do
		@config['path'].is_a?(String).should == true
	end
	
	it "must give removeAfterXDays" do
		@config['removeAfterXDays'].is_a?(Fixnum).should == true
	end
	
	it "must give savesToKeep" do
		@config['savesToKeep'].is_a?(Fixnum).should == true
	end
  
end
