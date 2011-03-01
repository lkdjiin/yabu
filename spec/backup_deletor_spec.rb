# -*- encoding: utf-8 -*-
require './spec/helper'

# There is two rules
# * We should delete backup directories that are too old.
# * We must always keep a minimum number of backup directories.
# @example
#		There is 10 backup directories. This 10 backup directories are too old. We must keep a minimum
#		of 3 directories. So we have to delete the 7 oldest directories and keep the 3 newest.
describe BackupDeletor do

  
  TIME_FORMAT = "%Y%m%d-%H%M"
  
  after :each do
		Dir.foreach(TEST_REPOSITORY) do |file|
			next if (file == ".") or (file == "..")
			filename = File.join(TEST_REPOSITORY, file)
			FileUtils.remove_dir(filename) if File.directory?(filename)
			FileUtils.remove_file(filename) if File.file?(filename)
		end
  end
  
  it "must be created with a default config" do
    BackupDeletor.new.is_a?(BackupDeletor).should == true
  end
  
  # removeAfterXDays = 10
	# savesToKeep = 3
	it "must delete backups given rules" do
		now = Time.now
		# create 10 directories too old
		create_old_directories(now, 11, 10)
		
		BackupDeletor.new(YABU_CONF).run
		
		# Is the 3 newest dirs always exist ?
		newest_always_exist?(now, 11, 3)
		
		# Is the 7 oldest dirs was deleted ?
		oldest_deleted?(now, 14, 7)
	end
  
  # Create a certain number of backup directories. 
	# From (now - day_base) to (now - (day_base + how_many)).
	#@param [Time] now The now time
	#@param [Fixnum] day_base Such as now - day_base equals the newest directory
	#@param [Fixnum] how_many How many directories to create
	def create_old_directories(now, day_base, how_many)
		
		for e in day_base...(day_base + how_many)
			dir_time = now - (e * 60 * 60 * 24)
			begin
				Dir.mkdir File.join(TEST_REPOSITORY, dir_time.strftime(TIME_FORMAT))
			rescue SystemCallError
				puts "Cannot create dir #{dir_time.strftime(TIME_FORMAT)}"
			end
		end
	end
  
  def newest_always_exist?(now, day_base, how_many)
		for e in day_base...(day_base + how_many)
			dir_time = now - (e * 60 * 60 * 24)
			file = File.join(TEST_REPOSITORY, dir_time.strftime(TIME_FORMAT))
			File.exist?(file).should == true
		end
	end
  
  def oldest_deleted?(now, day_base, how_many)
		for e in day_base...(day_base + how_many)
			dir_time = now - (e * 60 * 60 * 24)
			file = File.join(TEST_REPOSITORY, dir_time.strftime(TIME_FORMAT))
			File.exist?(file).should == false
		end
	end
  
end
