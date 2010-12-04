
require "date"
require "fileutils"

class BackupDeletor

	def initialize
		@backupToRemove = []
		@numberOfBackups = 0
	end
	
	def run
		searchOldBackup
		removeOldBackup
	end

private

	def searchOldBackup
		Message.searchingOldBackups
		Dir.foreach(@generalConfig.get 'path') do |file|
			next if file == "."
			next if file == ".."
			@numberOfBackups += 1
			today = Date.today
			filedate = Date.new file[0, 4].to_i, file[4, 2].to_i, file[6, 2].to_i
			x = today - filedate
			if x > @generalConfig.getInt('removeAfterXDays')
				@backupToRemove.push file
			end
		end
	end
	
	def removeOldBackup
		if @backupToRemove == []
			Message.noBackupsToRemove
			@log.debug "No old backup to remove"
		else
			@backupToRemove.sort!
			numberOfBackupToKeep = @generalConfig.getInt('savesToKeep')
			@backupToRemove.each do |file|
				if @numberOfBackups > numberOfBackupToKeep
					aDirectory = File.join(@generalConfig.get('path'), file)
					@log.info "Removing backup #{aDirectory}"
					begin
						FileUtils.remove_dir aDirectory, true
					rescue
						@log.warn "Old backup <#{aDirectory}> maybe not removed"
					end
					@numberOfBackups -= 1
				end
			end
			Message.endOfRemovingOldBackups
		end
	end
	
end
