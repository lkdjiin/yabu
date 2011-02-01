module Yabu

	# I restore your data
	# @since 0.6
	class Recovery

		# Default constructor.
		# @param [String] Config The 'yabu.conf' file path. To use only during testing.
		def initialize yabu_conf = ''
			@backup = ''
			@log = Log.instance
			if yabu_conf.empty?
				@yabu_config = YabuConfig.new
			else
				@yabu_config = YabuConfig.new yabu_conf
			end
		end
		
		# I start the recovery process
		# @since 0.6
		def run options={}
			options = {force: false}.merge(options)
			find_newest_backup
			# @todo diplay message and exit if there is no backup
			restore_backup options
		end
		
	private

		# Find the newest backup in the repository.
		def find_newest_backup
			backups = []
			Dir.foreach(@yabu_config['path']) do |file|
				next if (file == ".") or (file == "..")
				backups.push(file)
			end
			return false if backups.empty?
			backups.sort!.reverse!
			@backup = backups[0]
		end
		
		def restore_backup options
			baseDir = File.join(@yabu_config['path'], @backup)
			puts "Recovering from #{baseDir}"
			@log.info "Recovering from #{baseDir}"
			files = File.join(baseDir, "**", "*")
			Dir.glob(files).each {|file_in_repo|
				file_on_computer = file_in_repo.sub(Regexp.new(baseDir), '')
				putc(?.)
				# Let's restore this file if it doesn't exist on the computer
				# or if user force the recovery
				if options[:force]
					if File.file?(file_in_repo)
						FileUtils.cp(file_in_repo, file_on_computer)
						@log.info "Forced restore #{file_on_computer}"
					end
				end
				unless File.exists?(file_on_computer)
					if File.directory?(file_in_repo)
						FileUtils.mkdir file_on_computer
						@log.info "Create dir #{file_on_computer}"
					else
						FileUtils.cp(file_in_repo, file_on_computer)
						@log.info "Restoring #{file_on_computer}"
					end
				end
			}
		end
		
	end

end
