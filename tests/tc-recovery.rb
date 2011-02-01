require "fileutils"

class TC_Recovery < Test::Unit::TestCase

	CONF_TEST_1 = 'configuration/yabu.conf.test1'
	
	def create_little_backup dir = ''
		bkDir = '/home/xavier/devel/ruby/yabu/tests/temp/20110101-1234/home/xavier/devel/ruby/yabu/tests/' + dir
		FileUtils.makedirs(bkDir)
		FileUtils.cp('/home/xavier/devel/ruby/yabu/NEWS', bkDir)
		FileUtils.cp('/home/xavier/devel/ruby/yabu/README.rdoc', bkDir)
	end
	
	def restore options={}
		rec = Yabu::Recovery.new CONF_TEST_1
		rec.run options
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
		FileUtils.remove_dir 'temp/20110101-1234' if File.exist?('temp/20110101-1234')
		FileUtils.remove_file 'README.rdoc' if File.exist?('README.rdoc')
		FileUtils.remove_file 'NEWS' if File.exist?('NEWS')
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
		FileUtils.remove_dir 'temp/20110101-1234' if File.exist?('temp/20110101-1234')
		FileUtils.remove_dir 'missingdir' if File.exist?('missingdir')
	end
	
	def test_force_to_recover_all_files
		# We use the folder /tests. Lets say this folder should contains 2 files :
		# README.rdoc and NEWS. README.rdoc is missing. We create an empty NEWS to
		# prove it will be replaced.
		FileUtils.touch '/home/xavier/devel/ruby/yabu/tests/NEWS'
		# Be sure NEWS is zero length
		assert_equal(true, File.zero?('/home/xavier/devel/ruby/yabu/tests/README.rdoc'))
		create_little_backup 
		# Must restore README and NEWS
		restore force: :yes
		# Check
		assert_equal(true, File.exist?('/home/xavier/devel/ruby/yabu/tests/missingdir/README.rdoc'))
		assert_equal(true, File.exist?('/home/xavier/devel/ruby/yabu/tests/missingdir/NEWS'))
		assert_equal(false, File.zero?('/home/xavier/devel/ruby/yabu/tests/missingdir/NEWS'))
	ensure
		# Clean things
		FileUtils.remove_dir 'temp/20110101-1234' if File.exist?('temp/20110101-1234')
		FileUtils.remove_file 'README.rdoc' if File.exist?('README.rdoc')
		FileUtils.remove_file 'NEWS' if File.exist?('NEWS')
	end
	
end
