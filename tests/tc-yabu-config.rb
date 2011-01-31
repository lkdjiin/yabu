

class TC_YabuConfig < Test::Unit::TestCase

	def setup
    @config = Yabu::YabuConfig.new
  end

	def test_instance
		assert_instance_of(Yabu::YabuConfig, @config)
	end
	
	def test_path
		assert_instance_of(String, @config['path'])
	end
	
	def test_remove_after_X_days
		value = @config['removeAfterXDays']
		assert_instance_of(Fixnum, value)
	end
	
	def test_saves_to_teep
		value = @config['savesToKeep']
		assert_instance_of(Fixnum, value)
	end
end
