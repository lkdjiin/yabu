
class Recovery

	# @param [String] Config The 'yabu.conf' file path. To use only during testing.
	def initialize config = ''
		@backup = ''
		@log = Log.instance
		if config == ''
			@generalConfig = YabuConfig.new
		else
			@generalConfig = YabuConfig.new config
		end
	end
	
	def run
		findNewestBackup
		restoreBackup
	end
	
private

	def findNewestBackup
		backups = []
		Dir.foreach(@generalConfig['path']) do |file|
			next if (file == ".") or (file == "..")
			backups.push(file)
		end
		return false if backups.size == 0
		backups.sort!.reverse!
		@backup = backups[0]
	end
	
	def restoreBackup
		baseDir = File.join(@generalConfig['path'], @backup)
		puts "Recovering from #{baseDir}"
		@log.info "Recovering from #{baseDir}"
		files = File.join(baseDir, "**", "*")
		Dir.glob(files).each {|f|
			toCheck = f.sub(Regexp.new(baseDir), '')
			putc(?.)
			unless File.exists?(toCheck)
				if File.directory?(f)
					mkdir toCheck
					@log.info "Create dir #{toCheck}"
				else
					FileUtils.cp(f, toCheck)
					@log.info "Restoring #{toCheck}"
				end
			end
		}
	end
	
end
