# -*- encoding: utf-8 -*-
require './spec/helper'

describe Backup do

  it "must create one and only one folder for a full backup" do
    puts File.expand_path('temp')
		#~ Backup.new(CONF_TEST_1, DIR_TEST).full
		#~ number = 0
		#~ Dir.foreach(TEST_DIR) do |file|
			#~ next if (file == ".") or (file == "..")
			#~ number += 1 if File.directory?(TEST_DIR + file)
		#~ end
		#~ assert_equal 1, number, "must be only one backup folder at this point"
	#~ ensure
		#~ delete_temp_content
	end
  
end
