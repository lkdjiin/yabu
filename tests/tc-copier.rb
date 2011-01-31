require "fileutils"

class TC_Copier < Test::Unit::TestCase

	def testCopy
		c = Yabu::Copier.new([])
		c.copy('configuration', 'temp/tests/configuration')
		assert_equal(true, File.exist?('temp/tests/configuration'))
		assert_equal(true, File.exist?('temp/tests/configuration/directories.conf.test'))
		FileUtils.remove_dir 'temp/tests/'
	end
	
end
