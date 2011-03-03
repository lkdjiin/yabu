module Yabu
	
	# I am the main class of the Yabu application.
	class Main

		# Default constructor
		def initialize
			@opt = Options.new
      @log = Log.instance('yabu.log', yabu_config['logRotation'])
			yabu_config = YabuConfig.new
			@log.level = Log::INFO unless @opt[:test]
			check_if_user_seeking_help
		end
		
		# Start the backup process or the recover process.
		def run
			if command_recover?
				start_to_recover
			elsif command_backup?
				start_to_backup
			else
				puts "Unknown command"
				exit
			end
		end

	private
  
    def command_recover?
      ARGV.size == 1 and ARGV[0] == 'recover'
    end
    
    def command_backup?
      size = ARGV.size
      (size == 0) or (size == 1 and ARGV[0] == 'backup')
    end
	
		def check_if_user_seeking_help
			return if ARGV.empty?
      which_cmd = ARGV[1]
			if ARGV[0] == 'help'
				case which_cmd
					when 'help' then puts Help.help
					when 'recover' then puts Help.recover
					when 'backup' then puts Help.backup
					else
						puts "yabu: unknown command #{which_cmd}"
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
