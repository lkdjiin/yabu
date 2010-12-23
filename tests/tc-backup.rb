require "fileutils"

class TC_Backup < Test::Unit::TestCase

	CONF_TEST_1 = 'tests/configuration/yabu.conf.test1'
	DIR_TEST = 'tests/configuration/directories.conf.test'
	
	def testBackup
		bk = Backup.new(CONF_TEST_1, DIR_TEST)
		bk.run
		
		# Find name of the just created repository and count # of dir/files
		name = ''
		number = 0
		Dir.foreach('tests/temp') do |file|
			next if (file == ".") or (file == "..")
			name = file
			number += 1
		end
		# There must be only one directory created
		assert_equal(1, number)
		
		name = File.join('tests/temp', name)
		
		toCheck = File.join(name, 'home/xavier/local/test')
		assert_equal(true, File.exist?(toCheck))
		
		fichier1 = File.join(toCheck, 'fichier1')
		fichier2 = File.join(toCheck, 'fichier2')
		
		assert_equal(true, File.exist?(fichier2))
		assert_equal(false, File.exist?(fichier1))
		
		# finally clean the backup
		FileUtils.remove_dir name, true
		
		number = 0
		Dir.foreach('tests/temp') do |file|
			next if (file == ".") or (file == "..")
			name = file
			number += 1
		end
		# It must remains nothing
		assert_equal(0, number)

	end
end
