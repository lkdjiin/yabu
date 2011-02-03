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
		# @param [Hash] options
		# @option options [Boolean] :force Force to recover all files
		def run options={}
			options = {force: false}.merge(options)
			log_the_options options
			find_newest_backup
			# @todo diplay message and exit if there is no backup
			restore options
		end
		
	private
	
		def log_the_options options
			@log.info "Recover mode with following options: force=#{options[:force]}"
		end

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
		
		def restore options
			repository = File.join(@yabu_config['path'], @backup)
			log_and_display "Recovering from #{repository}"
			files = File.join(repository, "**", "*")
			Dir.glob(files).each {|file_in_repo|
				file_on_computer = file_in_repo.sub(Regexp.new(repository), '')
				putc(?.)
				if options[:force]
					copy_file_to_computer(file_in_repo, file_on_computer) if File.file?(file_in_repo)
				elsif (not File.exists?(file_on_computer))
					copy_item_to_computer file_in_repo, file_on_computer
				end
			}
		end
		
		def log_and_display message
			puts message
			@log.info message
		end
		
		def copy_item_to_computer from, to
			if File.directory?(from)
				create_dir_on_computer to
			else
				copy_file_to_computer(from, to)
			end
		end
		
		def copy_file_to_computer from, to
			FileUtils.cp from, to
			@log.info "Restored #{to}"
		end
		
		def create_dir_on_computer name
			FileUtils.mkdir name
			@log.info "Created dir #{name}"
		end
		
	end

end
