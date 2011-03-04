module Yabu
	
	# I am the main class of the Yabu application.
  # @todo define better the goal of this class.
	class Main

		# Default constructor
		def initialize options, command
			@options = options
      @command = command
			check_if_user_want_help
		end
		
		# Start the backup process or the recover process.
		def run
			if @command.recover?
				Recovery.new.run @options
			elsif @command.backup?
				start_to_backup
			else
				puts "Unknown command"
				exit
			end
		end

	private
	
		def check_if_user_want_help
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
			errors = Backup.new.full
			BackupDeletor.new.run
			unless errors.zero?
				puts "!!! #{errors} error(s) during copy process. See the log file !!!"
			end
		end

	end

end
