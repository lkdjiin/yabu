
require "fileutils"
require "date"

module Yabu

	# I know how to do backups of your data !
	# I initialize all the stuff on instanciation and start the backup with my run method.
	# It's really simple to doing backup :
	# @example How to backup ?
	#		backup = Backup.new
	#		backup.run
	class Backup

		# I set the configuration. Remember you have to edit 'configuration/yabu.conf' and
		# 'configuration/directories.conf' by hand. With this two config files I know where
		# and what to backup.
		# @param [String] yabu_config The 'yabu.conf' file path. Only used during testing.
		# @param [String] dir_config The 'directories.conf' file path. Only used during testing.
		def initialize yabu_config = '', dir_config = ''
			@log = Log.instance
			if yabu_config == ''
				@yabu_config = YabuConfig.new
			else
				@yabu_config = YabuConfig.new yabu_config
			end
			@saving_path = get_saving_path		
			if dir_config == ''
				@dir_config = DirConfig.new(File.join(ENV['HOME'], '.config/yabu/configuration/directories.conf'))
			else
				@dir_config = DirConfig.new dir_config
			end
		end
		
		# I start the backup process.
		# @return [Fixnum] Number of errors occured
		def run
			puts "Backup started"
			@log.info "Backup started with " + Yabu.version
			create_saving_directory
			errors = copy
			Message.printEndOfBackup
			@log.info "Backup is in #{@saving_path}"
			errors
		end
		
	private
		
		# @return [String] the backup sub-directory full path.
		#		Example : '/media/usb-disk/20101231-1438'
		def get_saving_path
			base_saving_path = @yabu_config['path']
			@log.fatal "#{base_saving_path} doesnt exist" if not File.exist?(base_saving_path)
			@log.fatal "#{base_saving_path} is not writable" if not File.stat(base_saving_path).writable?
			@saving_path = File.join(base_saving_path, get_saving_name)
			@log.fatal "#{@saving_path} exist" if File.exist?(@saving_path)
			@saving_path
		end
		
		# The backup sub-directory name is made by the concatenation of date and time.
		# The pattern is 'YYYYmmdd-hhmm' : year, month, day, hours and minutes.
		# @return [String] the backup sub-directory name. Example : '20101231-1438'
		def get_saving_name
			t = Time.now
			t.strftime("%Y%m%d-%H%M")
		end
		
		# I am trying to create the backup sub-directory.
		# If I can't do this, the program will terminate.
		def create_saving_directory
			begin
				Dir.mkdir @saving_path
			rescue SystemCallError
				@log.fatal "Cannot create #{@saving_path}"
			end
			@log.debug "Created #{@saving_path}"
		end
		
		# I do the effective backup.
		# @return [Fixnum] Number of errors occured
		def copy
			copier = Copier.new @dir_config.filesToExclude
			@dir_config.files.each do |item_on_computer| 
				copier.copy(item_on_computer, File.join(@saving_path, item_on_computer))
			end
			copier.errors
		end
		
	end

end
