
require "date"
require "fileutils"

# There is two rules
# * We should delete backup directories that are too old.
# * We must always keep a minimum number of backup directories.
# @example
#		There is 10 backup directories. This 10 backup directories are too old. We must keep a minimum
#		of 3 directories. So we have to delete the 7 oldest directories and keep the 3 newest.
class TC_BackupDeletor < Test::Unit::TestCase

	CONF_TEST_1 = 'configuration/yabu.conf.test1'
	TEST_REPOSITORY = 'temp'
	TIME_FORMAT = "%Y%m%d-%H%M"

	def testNew
		assert_instance_of(Yabu::BackupDeletor, Yabu::BackupDeletor.new(CONF_TEST_1))
	end
	
	# removeAfterXDays = 10
	# savesToKeep = 3
	def test1
		now = Time.now
		# create 10 directories too old
		createOldDirectories(now, 11, 10)
		
		# run the deletor
		bkDeletor = Yabu::BackupDeletor.new(CONF_TEST_1)
		bkDeletor.run
		
		# Is the 3 newest dirs always exist ?
		isDirectoriesAlwaysExist(now, 11, 3)
		
		# Is the 7 oldest dirs was deleted ?
		isDirectoriesDeleted(now, 14, 7)

		# finally clean the tests/temp
		for e in 11...14
			dirTime = now - (e * 60 * 60 * 24)
			file = File.join(TEST_REPOSITORY, dirTime.strftime(TIME_FORMAT))
			FileUtils.remove_dir file, true
		end
	end

private

	# Create a certain number of backup directories. 
	# From (now - dayBase) to (now - (dayBase + howMany)).
	#@param [Time] now The now time
	#@param [Fixnum] dayBase Such as now - dayBase equals the newest directory
	#@param [Fixnum] howMany How many directories to create
	def createOldDirectories(now, dayBase, howMany)
		
		for e in dayBase...(dayBase + howMany)
			dirTime = now - (e * 60 * 60 * 24)
			begin
				Dir.mkdir File.join(TEST_REPOSITORY, dirTime.strftime(TIME_FORMAT))
			rescue SystemCallError
				puts "Cannot create dir #{dirTime.strftime(TIME_FORMAT)}"
			end
		end
	end
	
	def isDirectoriesAlwaysExist(now, dayBase, howMany)
		for e in dayBase...(dayBase + howMany)
			dirTime = now - (e * 60 * 60 * 24)
			file = File.join(TEST_REPOSITORY, dirTime.strftime(TIME_FORMAT))
			assert_equal(true, File.exist?(file))
		end
	end
	
	def isDirectoriesDeleted(now, dayBase, howMany)
		for e in dayBase...(dayBase + howMany)
			dirTime = now - (e * 60 * 60 * 24)
			file = File.join(TEST_REPOSITORY, dirTime.strftime(TIME_FORMAT))
			assert_equal(false, File.exist?(file))
		end
	end
	
end
