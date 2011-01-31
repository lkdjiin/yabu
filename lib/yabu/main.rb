module Yabu
	
	# I am the main class of the Yabu application.
	# @example Start the application
	#		main = Main.new
	#		main.run
	class Main

		# Default constructor
		def initialize
			opt = Options.new
			Message.printLicense
			generalConfig = YabuConfig.new
			@log = Log.instance('yabu.log', generalConfig['logRotation'])
			@log.level = Log::INFO unless opt[:test]
		end
		
		# Start the backup process or the recover process.
		def run
			if ARGV.size == 1 and ARGV[0] == 'recover'
				startToRecover
			else
				startToBackup
			end
		end

	private

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