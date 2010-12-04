
require "fileutils"
require "date"


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
	def initialize
		@log = Log.instance
		@generalConfig = YabuConfig.new
		@savingPath = getSavingPath		
		@dirConfig = DirConfig.new 'configuration/directories.conf'
	end
	
	# I start the backup.
	def run
		doBackup
		deleteOldBackup
	end
	
private

	def doBackup
		@log.info "Backup started with " + Version.get
		createSavingDirectory
		copy
		Message.printEndOfBackup
		@log.info "Backup is in #{@savingPath}"
	end
	
	# @todo This deserves its own class
	def deleteOldBackup
		backupToRemove = []
		numberOfBackups = 0
		Message.searchingOldBackups
		Dir.foreach(@generalConfig.get 'path') do |file|
			next if file == "."
			next if file == ".."
			numberOfBackups += 1
			today = Date.today
			filedate = Date.new file[0, 4].to_i, file[4, 2].to_i, file[6, 2].to_i
			x = today - filedate
			if x > @generalConfig.getInt('removeAfterXDays')
				backupToRemove.push file
			end
		end
		
		if backupToRemove == []
			Message.noBackupsToRemove
			@log.debug "No old backup to remove"
		else
			backupToRemove.sort!
			numberOfBackupToKeep = @generalConfig.getInt('savesToKeep')
			backupToRemove.each do |file|
				if numberOfBackups > numberOfBackupToKeep
					aDirectory = File.join(@generalConfig.get('path'), file)
					@log.info "Removing backup #{aDirectory}"
					begin
						FileUtils.remove_dir aDirectory, true
					rescue
						@log.warn "Old backup <#{aDirectory}> maybe not removed"
					end
					numberOfBackups -= 1
				end
			end
			Message.endOfRemovingOldBackups
		end
		
	end
	
	# @return [String] the backup sub-directory full path.
	#		Example : '/media/usb-disk/20101231-1438'
	def getSavingPath
		baseSavingPath = @generalConfig.get 'path'
		@log.fatal "#{baseSavingPath} doesnt exist" if not File.exist?(baseSavingPath)
		@log.fatal "#{baseSavingPath} is not writable" if not File.stat(baseSavingPath).writable?
		@savingPath = File.join(baseSavingPath, getSavingName)
		@log.fatal "#{@savingPath} exist" if File.exist?(@savingPath)
		@savingPath
	end
	
	# The backup sub-directory name is made by the concatenation of date and time.
	# The pattern is 'YYYYmmdd-hhmm' : year, month, day, hours and minutes.
	# @return [String] the backup sub-directory name. Example : '20101231-1438'
	def getSavingName
		t = Time.now
		t.strftime("%Y%m%d-%H%M")
	end
	
	# I am trying to create the backup sub-directory.
	# If I can't do this, the program will terminate.
	def createSavingDirectory
		begin
			Dir.mkdir @savingPath
		rescue SystemCallError
			@log.fatal "Cannot create #{@savingPath}"
		end
		@log.debug "Created #{@savingPath}"
	end
	
	# I do the effective backup.
	def copy
		copier = Copier.new @dirConfig.filesToExclude
		@dirConfig.files.each do |source| 
			copier.copy(source, File.join(@savingPath, source))
		end
	end
	
end
