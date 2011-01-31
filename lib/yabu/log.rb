require "logger"

module Yabu

	# Little wrapper over the Logger class.
	# I do what the Logger class do, with two more things :
	# * singleton pattern
	# * fatal level of logging acts normaly but then puts its message to the screen and exit. 
	class Log < Logger
		private_class_method :new
		
		@@logger = nil
		
		# @param [String] fileName (Optional) log's file name
		# @param [String] frequencyRotation (Optional) 'daily', 'weekly' or 'monthly'
		# @return [Log] always the same instance.
		def Log.instance(fileName = 'yabu.log', frequencyRotation = 'monthly')
			@@logger = new(fileName, frequencyRotation) unless @@logger
			@@logger
		end
		
		# First, I do like Logger#fatal. Then I terminate the program.
		# @param [String] message The message to be logged.
		def fatal message
			super message
			puts "FATAL : #{message}"
			puts 'Exit...'
			exit 1
		end
	end

end
