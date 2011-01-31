
require "date"
require "fileutils"

# My job is to delete old backups according to certain rules.
# See the rules in the user guide.
class BackupDeletor

	# @param [String] Config The 'yabu.conf' file path. To use only during testing.
	def initialize config = ''
		@backupToRemove = []
		@numberOfBackups = 0
		@log = Log.instance
		if config == ''
			@generalConfig = YabuConfig.new
		else
			@generalConfig = YabuConfig.new config
		end
	end
	
	def run
		searchOldBackup
		removeOldBackup
	end

private

	# I look in the backup directory to find all the backups older than X days.
	# X is given by the 'removeAfterXDays' key in the config file.
	def searchOldBackup
		Message.searchingOldBackups
		Dir.foreach(@generalConfig['path']) do |file|
			next if (file == ".") or (file == "..")
			@numberOfBackups += 1
			filedate = Date.new file[0, 4].to_i, file[4, 2].to_i, file[6, 2].to_i
			x = Date.today - filedate
			@backupToRemove.push(file) if x > @generalConfig['removeAfterXDays']
		end
	end
	
	def removeOldBackup
		if @backupToRemove == []
			dontRemove
		else
			tryToRemove
		end
	end
	
	def dontRemove
		Message.noBackupsToRemove
		@log.debug "No old backup to remove"
	end
	
	# I try to remove the oldest backups. But I always keep a number of backup in the backup directory.
	def tryToRemove
		@backupToRemove.sort!
		numberOfBackupToKeep = @generalConfig['savesToKeep']
		@backupToRemove.each do |file|
			remove file if @numberOfBackups > numberOfBackupToKeep
		end
		Message.endOfRemovingOldBackups
	end
	
	# Remove one backup.
	#
	# @param [String] aBackup the path of the backup to remove
	def remove aBackup
		aDirectory = File.join(@generalConfig['path'], aBackup)
		@log.info "Removing backup #{aDirectory}"
		begin
			FileUtils.remove_dir aDirectory, true
		rescue
			@log.warn "Old backup <#{aDirectory}> maybe not removed"
		end
		@numberOfBackups -= 1
	end
	
end
