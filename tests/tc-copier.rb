require "fileutils"

class TC_Copier < Test::Unit::TestCase

	def testCopy
		c = Copier.new([])
		c.copy('tests/configuration', 'tests/temp/tests/configuration')
		assert_equal(true, File.exist?('tests/temp/tests/configuration'))
		assert_equal(true, File.exist?('tests/temp/tests/configuration/directories.conf.test'))
		FileUtils.remove_dir 'tests/temp/tests/'
	end
	
end
