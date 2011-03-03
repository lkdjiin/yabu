require "logger"

module Yabu

	# Little wrapper over the Logger class.
	# I do what the Logger class do, with two more things :
	# * singleton pattern
	# * fatal level of logging acts normaly but then puts its message to the screen and exit. 
	class Log < Logger
		private_class_method :new
		
		@@logger = nil
		# The default path to log file.
		# @note It seems to me that an hidden file in
		#   user's home folder is currently the best idea. Am I right ?
		@@default_filename = File.join(ENV['HOME'], '.yabu.log')
		
		# @param [String] filename (Optional) log's file name
		# @param [String] frequency_rotation (Optional) 'daily', 'weekly' or 'monthly'
		# @return [Log] always the same instance.
		# @todo an options hash would be better than default arguments
		def Log.instance(filename = @@default_filename, frequency_rotation = 'monthly')
			@@logger = new(filename, frequency_rotation) unless @@logger
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
  
  module Loggable
    Uniq_log = Log.instance
    
    def log_info_and_display message
			Uniq_log.info message
			puts message
		end
    
    def log_info message
			Uniq_log.info message
		end
    
    def log_debug message
      Uniq_log.debug message
    end
    
    def log_warn message
      Uniq_log.warn message
    end
    
    def log_error message
      Uniq_log.error message
    end
    
    def log_fatal message
      Uniq_log.fatal message
    end
  end

end
