
class TC_DirConfig < Test::Unit::TestCase

	def setup
    @config = Yabu::DirConfig.new("configuration/directories.conf.test", true)
  end

	def testNew
		assert_instance_of(Yabu::DirConfig, @config)
	end
	
	def testFiles
		assert_instance_of(Array, @config.files)
		assert_equal(3, @config.files.length)
		assert_equal('/home/xavier/local/', @config.files[0])
		assert_equal('/home/tagada.txt', @config.files[1])
		assert_equal('/root/.conf', @config.files[2])
	end
	
	def testFilesToExclude
		assert_instance_of(Array, @config.filesToExclude)
		assert_equal(2, @config.filesToExclude.length)
		assert_equal('/home/xavier/local/netbeans-6.9.1', @config.filesToExclude[0])
	end
	
end
