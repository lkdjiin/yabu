require "fileutils"

class TC_Copier < Test::Unit::TestCase

	def test_copy
		c = Yabu::Copier.new([])
		c.copy('configuration', 'temp/tests/configuration')
		assert_equal(true, File.exist?('temp/tests/configuration'))
		assert_equal(true, File.exist?('temp/tests/configuration/directories.conf.test'))
		FileUtils.remove_dir 'temp/tests/'
	end
	
	### BUGS #########
	
  # Bug 5
  #
  # in 0.6, cannot save:
  #   /home/USER/folder/file
  # if this line comes before a line like:
  #   /home/USER/folder
	def test_bug5
		filename = 'configuration/yabu.conf'
		c = Yabu::Copier.new([])
		c.copy(filename, 'temp/tests/' + filename)
		assert_equal true, File.exist?('temp/tests/' + filename), 'Bug 5 appeared again'
	ensure
		FileUtils.remove_dir 'temp/tests/' if File.exist?('temp/tests/')
	end
	
end
