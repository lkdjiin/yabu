# I'm parsing the 'configuration/directories.conf' which contains files and directories
# to add (or remove) to the backups.
# From me you can get two lists :
# 1. files/directories to include to the backup
# 2. files/directories to exclude from the backup
#
# @example :
#		c = DirConfig.new 'configuration/directories.conf'
#		includeList = c.files
#		excludeList = c.filesToExclude
class DirConfig
	attr_reader :files, :filesToExclude
	
	# @param [String] name The name of the configuration file
	# @param [true|false] test Set to true when testing this class
	def initialize(name, test = false)
		@name = name
		@test = test
		@log = Log.instance
		@files = []
		@filesToExclude = []
		fillArrays
		@log.debug "Parsed #{@name}"
	end
	
private

	# My job is to parse the configuration file to fill some lists with information found
	# in that file.
	def fillArrays
		begin
			IO.foreach(@name) { |line| 
				line.strip!
				next if skipLine? line
				parse line
			}
		rescue
			@log.fatal "Cannot parse #{@name}"
		end
	end
	
	# @return [true] if the line is a commentary or is empty.
	# @return [false] in other cases.
	def skipLine? line
		return true if (line =~ /^#/) or (line =~ /^$/)
		false
	end
	
	# I parse a line of the config file.
	def parse line
		action, filename = line.split(' ', 2)
		action.strip!
		if filename == nil # could be nil if user forgot to write + or -.
			@log.error "file name missing when parsing #{@name}"
			return false
		end
		filename.strip!
		return false if not legal? filename
		filename = File.expand_path(filename) if filename[0, 1] == '~'
		dispatch action, filename
	end
	
	# Be sure that filename begins by a slash
	def legal? filename
		return true if filename[0, 1] == "/" or filename[0, 1] == '~'
		@log.error "Bad file name <#{filename}> in #{@name}. Not archived"
		false
	end
	
	# Decide if this is a file to include or to exclude.
	# @param [String] action can be "+" or "-"
	# @param [String] filename name of file to include/exclude
	def dispatch action, filename
		if action == "+"
			includeFile filename 
		elsif action == "-"
			excludeFile filename
		else
			@log.error "bad action in #{@name}. Not archived. action is <#{action}> and file is <#{filename}>"
		end
	end
	
	# Add +filename+ to the list of files to include.
	def includeFile filename
		if File.exist? filename or @test
			@files.push filename
		else
			@log.error "when parsing #{@name} file <#{filename}> doesn't exist"
		end
	end
	
	# Add +filename+ to the list of files to exclude.
	def excludeFile filename
		if File.exist? filename or @test
			@filesToExclude.push filename
		else
			@log.error "when parsing #{@name} file <#{filename}> doesn't exist"
		end
	end
	
end
