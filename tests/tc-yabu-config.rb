

class TC_YabuConfig < Test::Unit::TestCase

	def setup
    @config = YabuConfig.instance
  end

	def testInstance
		assert_instance_of(YabuConfig, @config)
	end
	
	def testNew
		assert_raise(NoMethodError) { YabuConfig.new }
	end
	
	def testPath
		assert_instance_of(String, @config.get('path'))
	end
	
	def testRemoveAfterXDays
		value = @config.get('removeAfterXDays')
		assert_instance_of(String, value)
		assert_match(/\d+/, value)
	end
	
	def testSavesToKeep
		value = @config.get('savesToKeep')
		assert_instance_of(String, value)
		assert_match(/\d+/, value)
	end
end
