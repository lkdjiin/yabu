# -*- encoding: utf-8 -*-

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
    include Loggable

		# I set the configuration. Remember you have to edit 'configuration/yabu.conf' and
		# 'configuration/directories.conf' by hand. With this two config files I know where
		# and what to backup.
		# @param [String] yabu_config The 'yabu.conf' file path. Only used during testing.
		# @param [String] dir_config The 'directories.conf' file path. Only used during testing.
		def initialize yabu_config = '', dir_config = ''
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
		
		# I start the full backup process.
		# @return [Fixnum] Number of errors occured
		def full
			log_info_and_display "Full backup started with #{Yabu.version}"
			create_backup_folder
      errors = FullBackup.new(@backup_folder, @dir_config).backup
			log_info_and_display "Full backup done in #{@backup_folder}"
			errors
		end
		
		def incremental
			full_marks = Dir.glob(File.join(@yabu_config['path'], '*.full'))
			raise NoFullBackupError if full_marks.empty?
		end
		
	private
		
		# @return [String] Full path name of the backup folder in the repository.
		#		Example : '/media/usb-disk/20101231-1438'
		def build_backup_folder_name
			repository_path = @yabu_config['path']
			ensure_we_have_full_access_to(repository_path)
			backup_folder = File.join(repository_path, Yabu.backup_folder_name)
			log_fatal "#{backup_folder} exist" if File.exist?(backup_folder)
			backup_folder
		end
		
		# Fatal error if repository doesn't exist or if we can't write to it.
		def ensure_we_have_full_access_to repository_path
			log_fatal "#{repository_path} doesnt exist" if not File.exist?(repository_path)
			log_fatal "#{repository_path} is not writable" if not File.stat(repository_path).writable?
		end
		
		# I am trying to create the backup folder in the repository.
		# If I can't do this, the program will terminate.
		def create_backup_folder
			begin
				Dir.mkdir @backup_folder
				log_debug "Created #{@backup_folder}"
			rescue SystemCallError
				log_fatal "Cannot create #{@backup_folder}"
			end
		end
		
	end

end
