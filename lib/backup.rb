
require "fileutils"


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
		Message.printLicense
		@log = Log.instance
		@log.level = Log::INFO
		@generalConfig = YabuConfig.new 'configuration/yabu.conf'
		@savingPath = getSavingPath		
		@dirConfig = DirConfig.new 'configuration/directories.conf'
	end
	
	# I start the backup.
	def run
		@log.info "Backup started with " + Version.get
		createSavingDirectory
		copy
		Message.printEnd
		@log.info "Backup is in #{@savingPath}"
	end
	
private
	
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
