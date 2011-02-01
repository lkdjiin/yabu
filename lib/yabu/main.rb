module Yabu
	
	# I am the main class of the Yabu application.
	# @example Start the application
	#		main = Main.new
	#		main.run
	class Main

		# Default constructor
		def initialize
			opt = Options.new
			yabu_config = YabuConfig.new
			@log = Log.instance('yabu.log', yabu_config['logRotation'])
			@log.level = Log::INFO unless opt[:test]
			check_if_user_seeking_help
		end
		
		# Start the backup process or the recover process.
		def run
			if ARGV.size == 1 and ARGV[0] == 'recover'
				startToRecover
			elsif ARGV.size == 1 and ARGV[0] == 'backup'
				startToBackup
			elsif ARGV.size == 0
				startToBackup
			else
				puts "Unknown command"
				exit
			end
		end

	private
	
		def check_if_user_seeking_help
			return if ARGV.empty?
			if ARGV[0] == 'help'
				case ARGV[1]
					when nil then exit
					when 'help' then puts Help.help
					when 'recover' then puts Help.recover
					when 'backup' then puts Help.backup
					else
						puts "Unknown command #{ARGV[1]}"
				end
				exit
			end
		end

		# Start the backup process.
		def startToBackup
			backup
			deleteOldBackup
		end
		
		# Start the recovery process.
		def startToRecover
			Recovery.new.run
		end

		# Do the backup.
		def backup
			Backup.new.run
		end
		
		# Remove the oldest backups if they exist.
		def deleteOldBackup
			BackupDeletor.new.run
		end
	end

end
