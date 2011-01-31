module Yabu

	# I restore your data
	# @since 0.6
	class Recovery

		# Default constructor.
		# @param [String] Config The 'yabu.conf' file path. To use only during testing.
		def initialize config = ''
			@backup = ''
			@log = Log.instance
			if config == ''
				@generalConfig = YabuConfig.new
			else
				@generalConfig = YabuConfig.new config
			end
		end
		
		# I start the recovery process
		# @since 0.6
		def run
			find_newest_backup
			restore_backup
		end
		
	private

		# Find the newest backup in the repository.
		def find_newest_backup
			backups = []
			Dir.foreach(@generalConfig['path']) do |file|
				next if (file == ".") or (file == "..")
				backups.push(file)
			end
			return false if backups.size == 0
			backups.sort!.reverse!
			@backup = backups[0]
		end
		
		def restore_backup
			baseDir = File.join(@generalConfig['path'], @backup)
			puts "Recovering from #{baseDir}"
			@log.info "Recovering from #{baseDir}"
			files = File.join(baseDir, "**", "*")
			Dir.glob(files).each {|file_in_repo|
				to_check = file_in_repo.sub(Regexp.new(baseDir), '')
				putc(?.)
				# Let's restore this file if it doesn't exist on the computer.
				unless File.exists?(to_check)
					if File.directory?(file_in_repo)
						FileUtils.mkdir to_check
						@log.info "Create dir #{to_check}"
					else
						FileUtils.cp(file_in_repo, to_check)
						@log.info "Restoring #{to_check}"
					end
				end
			}
		end
		
	end

end
