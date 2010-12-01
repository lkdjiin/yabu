
require "fileutils"


# I know how to do backups of your data !
# I initialize all the stuff on instanciation and start the backup with my run method.
class Backup

	# I set the configuration. Remember you have to edit 'configuration/yabu.conf' and
	# 'configuration/directories.conf' by hand. With this two config files I know where
	# and what to backup.
	def initialize
		Message.printLicense
		@generalConfig = YabuConfig.new 'configuration/yabu.conf'
		@log = Log.getInstance
		@savingPath = getSavingPath		
		@dirConfig = DirConfig.new 'configuration/directories.conf'
	end
	
	# I start the backup.
	def run
		createSavingDirectory
		copy
		Message.printEnd
	end
	
private
	
	def getSavingPath
		baseSavingPath = @generalConfig.get 'path'
		@log.fatal "#{baseSavingPath} doesnt exist" if not File.exist?(baseSavingPath)
		@log.fatal "#{baseSavingPath} is not writable" if not File.stat(baseSavingPath).writable?
		@savingPath = File.join(baseSavingPath, getSavingName)
		@log.fatal "#{@savingPath} exist" if File.exist?(@savingPath)
		@savingPath
	end
	
	def getSavingName
		t = Time.now
		t.strftime("%Y%m%d")
	end
	
	def createSavingDirectory
		begin
			Dir.mkdir @savingPath
		rescue SystemCallError
			@log.fatal "Cannot create #{@savingPath}"
		end
		@log.info "Created #{@savingPath}"
	end
	
	def copy
		copier = Copier.new @dirConfig.filesToExclude
		@dirConfig.files.each do |source| 
			dest = @savingPath + File.dirname(source)
			copier.copy source, dest
		end
		@log.info "Saving done"
	end
	
end
