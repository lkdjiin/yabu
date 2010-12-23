

class TC_YabuConfig < Test::Unit::TestCase

	def setup
    @config = YabuConfig.new
  end

	def testInstance
		assert_instance_of(YabuConfig, @config)
	end
	
	def testPath
		assert_instance_of(String, @config['path'])
	end
	
	def testRemoveAfterXDays
		value = @config['removeAfterXDays']
		assert_instance_of(Fixnum, value)
	end
	
	def testSavesToKeep
		value = @config['savesToKeep']
		assert_instance_of(Fixnum, value)
	end
end
