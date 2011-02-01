class TC_Help < Test::Unit::TestCase
	
	def setup
		@commands = ['help', 'recover', 'backup']
	end
	
	def test_respond_to_each_command
		@commands.each do |cmd|
			assert Yabu::Help.respond_to?(cmd), "Class Help must respond to #{cmd}()"
		end
	end
	
	def test_command_method_must_return_string
		@commands.each do |cmd|
			assert_equal String, Yabu::Help.send(cmd).class, "#{cmd}() must return a string"
		end
	end
	
end
