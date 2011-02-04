
require "date"
require "fileutils"

module Yabu

	# My job is to delete old backups according to certain rules.
	# See the rules in the user guide.
	class BackupDeletor

		# @param [String] yabu_conf The 'yabu.conf' file path. Only used during testing.
		def initialize yabu_conf = ''
			@backups_to_remove = []
			@number_of_backups = 0
			@log = Log.instance
			if yabu_conf.empty?
				@yabu_config = YabuConfig.new
			else
				@yabu_config = YabuConfig.new yabu_conf
			end
		end
		
		# Start the process of deleting old backups
		def run
			search_old_backup
			remove_old_backup
		end

	private

		# I look in the backup directory to find all the backups older than X days.
		# X is given by the 'removeAfterXDays' key in the config file.
		def search_old_backup
			Message.searching_old_backups
			Dir.foreach(@yabu_config['path']) do |file|
				next if (file == ".") or (file == "..")
				@number_of_backups += 1
				filedate = Date.new file[0, 4].to_i, file[4, 2].to_i, file[6, 2].to_i
				days = Date.today - filedate
				@backups_to_remove.push(file) if days > @yabu_config['removeAfterXDays']
			end
		end
		
		def remove_old_backup
			if @backups_to_remove == []
				dont_remove
			else
				try_to_remove
			end
		end
		
		def dont_remove
			Message.no_backups_to_remove
			@log.debug "No old backup to remove"
		end
		
		# I try to remove the oldest backups. But I always keep a number of backup in the repository.
		def try_to_remove
			@backups_to_remove.sort!
			number_of_backup_to_keep = @yabu_config['savesToKeep']
			@backups_to_remove.each do |file|
				remove file if @number_of_backups > number_of_backup_to_keep
			end
			Message.end_of_removing_old_backups
		end
		
		# Remove one backup directory and its content.
		#
		# @param [String] a_backup Path of the backup to remove
		def remove a_backup
			a_directory = File.join(@yabu_config['path'], a_backup)
			@log.info "Removing backup #{a_directory}"
			begin
				FileUtils.remove_dir a_directory, true
			rescue
				@log.warn "Old backup <#{a_directory}> maybe not removed"
			end
			@number_of_backups -= 1
		end
		
	end

end
