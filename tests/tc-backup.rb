require "fileutils"

# You cannot run these tests on your computer because they refer on some files
# on my local computer.
# Hack it, this is free software !
class TC_Backup < Test::Unit::TestCase

	CONF_TEST_1 = 'configuration/yabu.conf.test1'
	DIR_TEST = 'configuration/directories.conf.test'
	DIR_TEST_2 = 'configuration/directories.conf.test2'
	
	def test_backup
		bk = Yabu::Backup.new(CONF_TEST_1, DIR_TEST)
		bk.run
		
		# Find name of the just created repository and count # of dir/files
		name = ''
		number = 0
		Dir.foreach('temp') do |file|
			next if (file == ".") or (file == "..")
			name = file
			number += 1
		end
		# There must be only one directory created
		assert_equal(1, number)
		
		name = File.join('temp', name)
		
		to_check = File.join(name, 'home/xavier/local/test')
		assert_equal(true, File.exist?(to_check))
		
		fichier1 = File.join(to_check, 'fichier1')
		fichier2 = File.join(to_check, 'fichier2')
		
		assert_equal(true, File.exist?(fichier2))
		assert_equal(false, File.exist?(fichier1))
		
		# finally clean the backup
		FileUtils.remove_dir name, true
		
		number = 0
		Dir.foreach('temp') do |file|
			next if (file == ".") or (file == "..")
			name = file
			number += 1
		end
		# It must remains nothing
		assert_equal(0, number)

	end
	
	# Test of expand_path
	def test_backup2
		bk = Yabu::Backup.new(CONF_TEST_1, DIR_TEST_2)
		bk.run
		
		# Find name of the just created repository and count # of dir/files
		name = ''
		number = 0
		Dir.foreach('temp') do |file|
			next if (file == ".") or (file == "..")
			name = file
			number += 1
		end
		# There must be only one directory created
		assert_equal(1, number)
		
		name = File.join('temp', name)
		
		to_check = File.join(name, 'home/xavier/local/wallpaper')
		assert_equal(true, File.directory?(to_check))
		
		# finally clean the backup
		FileUtils.remove_dir name, true
		
		number = 0
		Dir.foreach('temp') do |file|
			next if (file == ".") or (file == "..")
			name = file
			number += 1
		end
		# It must remains nothing
		assert_equal(0, number)
	end
	
end
