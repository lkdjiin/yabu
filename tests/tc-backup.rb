require "fileutils"

# You cannot run these tests on your computer because they refer on some files
# on my local computer.
# Hack it, this is free software !
class TC_Backup < Test::Unit::TestCase
	include Yabu
	
	CONF_TEST_1 = 'configuration/yabu.conf.test1'
	DIR_TEST = 'configuration/directories.conf.test'
	DIR_WITH_TILDE_TEST = 'configuration/directories.conf.test2'
	
	TEST_DIR = '/home/xavier/devel/ruby/yabu/tests/temp/'
	
	### FULL BACKUP ######################
	
	# Find name of the just created backup folder. Assume there is only one folder in TEST_DIR.
	# @return [String] name of the backup folder
	def find_name_of_just_created_backup
		name = ''
		Dir.foreach(TEST_DIR) do |file|
			next if (file == ".") or (file == "..")
			name = file if File.directory?(TEST_DIR + file)
		end
		name
	end
	
	# Delete content of temp folder
	def delete_temp_content
		Dir.foreach(TEST_DIR) do |file|
			next if (file == ".") or (file == "..")
			filename = TEST_DIR + file
			FileUtils.remove_dir(filename) if File.directory?(filename)
			FileUtils.remove_file(filename) if File.file?(filename)
		end
	end
	
	def test_full_create_one_and_only_one_folder
		Backup.new(CONF_TEST_1, DIR_TEST).full
		number = 0
		Dir.foreach(TEST_DIR) do |file|
			next if (file == ".") or (file == "..")
			number += 1 if File.directory?(TEST_DIR + file)
		end
		assert_equal 1, number, "must be only one backup folder at this point"
	ensure
		delete_temp_content
	end
	
	def test_full_backup_mark
		Backup.new(CONF_TEST_1, DIR_TEST).full
		name = TEST_DIR + find_name_of_just_created_backup
		assert_equal true, File.exist?(name +  '.full'), 'A xxxxx.full file must exist'
	ensure
		delete_temp_content
	end
	
	def test_full_backup
		bk = Backup.new(CONF_TEST_1, DIR_TEST)
		bk.full
		
		name = TEST_DIR + find_name_of_just_created_backup
		
		to_check = File.join(name, 'home/xavier/local/test')
		assert_equal(true, File.exist?(to_check))
		
		fichier1 = File.join(to_check, 'fichier1')
		fichier2 = File.join(to_check, 'fichier2')
		
		assert_equal(true, File.exist?(fichier2))
		assert_equal(false, File.exist?(fichier1))
	ensure
		delete_temp_content
	end
	
	def test_full_backup_with_tilde_in_directories_conf
		bk = Backup.new(CONF_TEST_1, DIR_WITH_TILDE_TEST)
		bk.full
		
		name = TEST_DIR + find_name_of_just_created_backup
		
		to_check = File.join(name, 'home/xavier/local/wallpaper')
		assert_equal(true, File.directory?(to_check))
	ensure
		delete_temp_content
	end
	
	### INCREMENTAL BACKUP ###############
	
	def test_incremental_without_full_mark
		bk = Backup.new(CONF_TEST_1, DIR_TEST)
		assert_raise(NoFullBackupMarkError) do
			bk.incremental
		end
	end
	
	def test_most_recent_full_returns_nil_when_no_full_exist
		bk = Backup.new(CONF_TEST_1, DIR_TEST)
		assert_equal nil, bk.most_recent_full?
	end
	
	def test_incremental_must_use_most_recent_full
		FileUtils.touch TEST_DIR + '20110101-1234.full'
		FileUtils.touch TEST_DIR + '20110122-1234.full'
		bk = Backup.new(CONF_TEST_1, DIR_TEST)
		assert_equal '20110122-1234', bk.most_recent_full?
	ensure
		delete_temp_content
	end
	
	def test_first_incremental_with_nothing_changed
		assert false
	end
	
	def test_first_incremental_with_one_file_added
		assert false
	end
	
	def test_first_incremental_with_one_file_modified
		assert false
	end
	
	def test_first_incremental_with_one_folder_added
		assert false
	end
	
	def test_first_incremental_with_one_file_deleted
		assert false
	end
	
	def test_first_incremental_with_one_folder_deleted
		assert false
	end
	
end
