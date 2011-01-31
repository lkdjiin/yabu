require "fileutils"

class TC_Recovery < Test::Unit::TestCase

	CONF_TEST_1 = 'configuration/yabu.conf.test1'
	
	def test_recover_one_missing_file
		# We use the folder /tests. This folder should contains 2 files backed up :
		# README and NEWS. README is the missing one.
		FileUtils.cp('/home/xavier/devel/ruby/yabu/NEWS', '/home/xavier/devel/ruby/yabu/tests/')
		
		# Create a little backup by hand
		bkDir = '/home/xavier/devel/ruby/yabu/tests/temp/20110101-1234/home/xavier/devel/ruby/yabu/tests/'
		FileUtils.makedirs(bkDir)
		FileUtils.cp('/home/xavier/devel/ruby/yabu/NEWS', bkDir)
		FileUtils.cp('/home/xavier/devel/ruby/yabu/README', bkDir)
		
		# Be sure README doesn't stand here from another test run
		assert_equal(false, File.exist?('/home/xavier/devel/ruby/yabu/tests/README'))
		
		# Must restore the README file in '/home/xavier/devel/ruby/yabu/tests/'
		rec = Yabu::Recovery.new CONF_TEST_1
		rec.run
		
		# Check if README has been restored
		assert_equal(true, File.exist?('/home/xavier/devel/ruby/yabu/tests/README'))
		
		# Clean things
		FileUtils.remove_dir 'temp/20110101-1234'
		FileUtils.remove_file 'README'
		FileUtils.remove_file 'NEWS'
	end
	
	def test_recover_one_missing_dir
		# Create a little backup by hand
		bkDir = '/home/xavier/devel/ruby/yabu/tests/temp/20110101-1234/home/xavier/devel/ruby/yabu/tests/missingdir'
		FileUtils.makedirs(bkDir)
		FileUtils.cp('/home/xavier/devel/ruby/yabu/NEWS', bkDir)
		FileUtils.cp('/home/xavier/devel/ruby/yabu/README', bkDir)
		
		# Be sure missingdir doesn't stand here from another test run
		assert_equal(false, File.exist?('/home/xavier/devel/ruby/yabu/tests/missingdir'))
		
		# Must restore the README and NEWS files in '/home/xavier/devel/ruby/yabu/tests/missingdir'
		rec = Yabu::Recovery.new CONF_TEST_1
		rec.run
		
		# Check
		assert_equal(true, File.exist?('/home/xavier/devel/ruby/yabu/tests/missingdir/README'))
		assert_equal(true, File.exist?('/home/xavier/devel/ruby/yabu/tests/missingdir/NEWS'))
		
		# Clean things
		FileUtils.remove_dir 'temp/20110101-1234'
		FileUtils.remove_dir 'missingdir'
	end
	
end
