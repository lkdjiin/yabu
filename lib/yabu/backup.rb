
require "fileutils"
require "date"

module Yabu

	# I know how to do backups of your data !
	# I initialize all the stuff on instanciation and start the backup with one of this two methods:
	# * #full
	# * #incremental
	# It's really simple to doing backup :
	# @example
	#		backup = Backup.new
	#   # Do a full backup
	#		backup.full
	#   # Or do an incremental backup
	#		backup.incremental
	class Backup

		# I set the configuration. Remember you have to edit 'configuration/yabu.conf' and
		# 'configuration/directories.conf' by hand. With this two config files I know where
		# and what to backup.
		# @param [String] yabu_config The 'yabu.conf' file path. Only used during testing.
		# @param [String] dir_config The 'directories.conf' file path. Only used during testing.
		def initialize yabu_config = '', dir_config = ''
			@log = Log.instance
			load_config(yabu_config, dir_config)
			@backup_folder = build_backup_folder_name		
		end
		
		def load_config yabu_config, dir_config
			load_yabu_config(yabu_config)
			load_dir_config(dir_config)
		end
		private :load_config
		
		def load_yabu_config conf
			if conf.empty?
				@yabu_config = YabuConfig.new
			else
				@yabu_config = YabuConfig.new conf
			end
		end
		private :load_yabu_config
		
		def load_dir_config conf
			if conf.empty?
				@dir_config = DirConfig.new(DIR_CONFIG_FILE_PATH)
			else
				@dir_config = DirConfig.new conf
			end
		end
		private :load_dir_config
		
		# @deprecated Since 0.15, use full instead.
		def run
			full
		end
		
		# I start the full backup process.
		# @return [Fixnum] Number of errors occured
		# @since 0.15
		def full
			log_info_and_display "Full backup started with #{Yabu.version}"
			create_backup_folder
			create_full_backup_mark
			errors = copy
			log_info_and_display "Full backup done in #{@backup_folder}"
			errors
		end
		
		# @since 0.15
		def incremental
			full_marks = Dir.glob(File.join(@yabu_config['path'], '*.full'))
			raise NoFullBackupMarkError if full_marks.empty?
		end
		
		# @return nil if there is no full backup in the repository, otherwise returns
		#   the most recent full backup folder name
		# @since 0.15
		def most_recent_full?
			full_marks = Dir.glob(File.join(@yabu_config['path'], '*.full'))
			return nil if full_marks.empty?
			name = full_marks.sort!.reverse!.first
			File.basename name, '.full'
		end
		
	private #####################################################################
		
		def log_info_and_display message
			@log.info message
			puts message
		end
		
		# @return [String] Full path name of the backup folder in the repository.
		#		Example : '/media/usb-disk/20101231-1438'
		def build_backup_folder_name
			repository_path = @yabu_config['path']
			@log.fatal "#{repository_path} doesnt exist" if not File.exist?(repository_path)
			@log.fatal "#{repository_path} is not writable" if not File.stat(repository_path).writable?
			backup_folder = File.join(repository_path, folder_name_from_time)
			@log.fatal "#{backup_folder} exist" if File.exist?(backup_folder)
			backup_folder
		end
		
		# The backup folder name is made by the concatenation of date and time.
		# The pattern is 'YYYYmmdd-hhmm' : year, month, day, hours and minutes.
		# @return [String] the backup folder name. Example : '20101231-1438'
		def folder_name_from_time
			t = Time.now
			t.strftime("%Y%m%d-%H%M")
		end
		
		# I am trying to create the backup folder in the repository.
		# If I can't do this, the program will terminate.
		def create_backup_folder
			begin
				Dir.mkdir @backup_folder
				@log.debug "Created #{@backup_folder}"
			rescue SystemCallError
				@log.fatal "Cannot create #{@backup_folder}"
			end
		end
		
		def create_full_backup_mark
			begin
				FileUtils.touch "#{@backup_folder}.full"
				@log.debug "Created #{@backup_folder}.full"
			rescue SystemCallError
				@log.fatal "Cannot create #{@backup_folder}.full"
			end
		end
		
		# I do the effective backup.
		# @return [Fixnum] Number of errors occured
		def copy
			copier = Copier.new @dir_config.filesToExclude
			@dir_config.files.each do |item_on_computer| 
				copier.copy(item_on_computer, File.join(@backup_folder, item_on_computer))
			end
			copier.errors
		end
		
	end

end
