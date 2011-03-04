module Yabu
	
	# I am the main class of the Yabu application.
  # @todo define better the goal of this class
	class Main

		# Default constructor
		def initialize
			@opt = Options.new
			yabu_config = YabuConfig.new
      @log = Log.instance('yabu.log', yabu_config['logRotation'])
			@log.level = Log::INFO unless @opt[:test]
      @command = CommandParser.new
			check_if_user_seeking_help
		end
		
		# Start the backup process or the recover process.
		def run
			if @command.recover?
				start_to_recover
			elsif @command.backup?
				start_to_backup
			else
				puts "Unknown command"
				exit
			end
		end

	private
	
		def check_if_user_seeking_help
      if @command.help?
        case @command.sub_command
          when :help then puts Help.help
					when :recover then puts Help.recover
					when :backup then puts Help.backup
					else
						puts "yabu: unknown sub-command"
        end
        exit
      end
		end

		# Start the backup process.
		def start_to_backup
			errors = Backup.new.run
			BackupDeletor.new.run
			unless errors.zero?
				puts "!!! #{errors} error(s) during copy process. See the log file !!!"
			end
		end
		
		# Start the recovery process.
		def start_to_recover
			Recovery.new.run @opt.options
		end

	end

end
