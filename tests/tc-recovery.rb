require "fileutils"

class TC_Recovery < Test::Unit::TestCase

	CONF_TEST_1 = 'configuration/yabu.conf.test1'
	
	def create_little_backup dir = ''
		bkDir = '/home/xavier/devel/ruby/yabu/tests/temp/20110101-1234/home/xavier/devel/ruby/yabu/tests/' + dir
		FileUtils.makedirs(bkDir)
		FileUtils.cp('/home/xavier/devel/ruby/yabu/NEWS', bkDir)
		FileUtils.cp('/home/xavier/devel/ruby/yabu/README.rdoc', bkDir)
	end
	
	def restore
		rec = Yabu::Recovery.new CONF_TEST_1
		rec.run
	end
	
	def test_recover_one_missing_file
		# We use the folder /tests. Lets say this folder should contains 2 files backed up :
		# README.rdoc and NEWS. README.rdoc is the missing one.
		FileUtils.cp('/home/xavier/devel/ruby/yabu/NEWS', '/home/xavier/devel/ruby/yabu/tests/')
		
		create_little_backup
		
		# Be sure README doesn't stand here from another test run
		assert_equal(false, File.exist?('/home/xavier/devel/ruby/yabu/tests/README.rdoc'))
		
		# Must restore the README file in '/home/xavier/devel/ruby/yabu/tests/'
		restore
		
		# Check if README has been restored
		assert_equal(true, File.exist?('/home/xavier/devel/ruby/yabu/tests/README.rdoc'))
	ensure
		# Clean things
		FileUtils.remove_dir 'temp/20110101-1234'
		FileUtils.remove_file 'README.rdoc'
		FileUtils.remove_file 'NEWS'
	end
	
	def test_recover_old_files
		# We use the folder /tests. Lets say this folder contains 2 files backed up :
		# README.rdoc and NEWS. This 2 files have got a modification time oldest than
		# there counterpart in backup respository.
		FileUtils.cp('/home/xavier/devel/ruby/yabu/NEWS', '/home/xavier/devel/ruby/yabu/tests/')
		FileUtils.cp('/home/xavier/devel/ruby/yabu/README.rdoc', '/home/xavier/devel/ruby/yabu/tests/')
		# Wait 2 seconds to be sure time will be different
		sleep 2
		create_little_backup
		
		# Be sure the modification time are not the same
		dir = '/home/xavier/devel/ruby/yabu/tests/temp/20110101-1234/home/xavier/devel/ruby/yabu/tests/'
		repo1 = File.stat(dir + 'README.rdoc').mtime
		repo2 = File.stat(dir + 'NEWS').mtime
		
		folder1 = File.stat('/home/xavier/devel/ruby/yabu/tests/README.rdoc').mtime
		folder2 = File.stat('/home/xavier/devel/ruby/yabu/tests/NEWS').mtime

		assert repo1 > folder1, "Files in repository must be newer"
		assert repo2 > folder2, "Files in repository must be newer"
		
		# Must restore the files in '/home/xavier/devel/ruby/yabu/tests/'
		restore
		
		# Check if files have been restored
		folder1 = File.stat('/home/xavier/devel/ruby/yabu/tests/README.rdoc').mtime
		folder2 = File.stat('/home/xavier/devel/ruby/yabu/tests/NEWS').mtime
		assert repo1 <= folder1, "Files just recovered must be newer"
		assert repo2 <= folder2, "Files just recovered must be newer"
		
	ensure
		# Clean things
		FileUtils.remove_dir 'temp/20110101-1234'
		FileUtils.remove_file 'README.rdoc'
		FileUtils.remove_file 'NEWS'
	end
	
	def test_recover_one_missing_dir
		create_little_backup 'missingdir'
		
		# Be sure missingdir doesn't stand here from another test run
		assert_equal(false, File.exist?('/home/xavier/devel/ruby/yabu/tests/missingdir'))
		
		# Must restore the README and NEWS files in '/home/xavier/devel/ruby/yabu/tests/missingdir'
		restore
		
		# Check
		assert_equal(true, File.exist?('/home/xavier/devel/ruby/yabu/tests/missingdir/README.rdoc'))
		assert_equal(true, File.exist?('/home/xavier/devel/ruby/yabu/tests/missingdir/NEWS'))
	ensure
		# Clean things
		FileUtils.remove_dir 'temp/20110101-1234'
		FileUtils.remove_dir 'missingdir'
	end
	
end
