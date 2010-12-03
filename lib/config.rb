# There is two classes that holds the configuration.
#
# * YabuConfig, for the "yabu.conf" file
# * DirConfig, for the "directories.conf" file


# I'm parsing a the general 'ini like) configuration file of Yabu : 'configuration/yabu.conf'.
# From version 0.1, there is only one used key :
# @example
#		c = YabuConfig.new configuration/yabu.conf'
#		pathToBackupDir = c.get 'path'
class YabuConfig

	# @param [String] name the name of the configuration's file
	def initialize name
		@log = Log.instance
		@dico = Hash.new
		fillHash name
		@log.debug "Parsed #{name}"
	end
	
	# @param [String] key a key of the 'configuration/yabu.conf'
	# @return [String] the value for the given key
	def get key
		@dico[key]
	end
	
	# @param [String] key a key of the 'configuration/yabu.conf'
	# @return [Fixnum] the value for the given key
	def getInt key
		@dico[key].to_i
	end
	
private

	# My job is to parse the configuration file to fill an Hash with the key/value pairs found
	# in that file.
	# @param [String] name the name of the configuration's file
	def fillHash name
		IO.foreach(name) { |line| 
			next if line.strip! =~ /^#/
			next if line =~ /^$/
			a, b = line.split '='
			@dico[a.strip] = b.strip
		}
	end
	
end

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
	
	# @param [String] name the name of the configuration's file
	def initialize name
		@name = name
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
	
	def parse line
		action, filename = line.split(' ', 2)
		action.strip!
		filename.strip!
		dispatch action, filename
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
			@log.error "when parsing #{@name} action is <#{action}> and file is <#{filename}>"
		end
	end
	
	def includeFile filename
		if File.exist? filename
			@files.push filename
		else
			@log.error "when parsing #{@name} file <#{filename}> doesn't exist"
		end
	end
	
	def excludeFile filename
		if File.exist? filename
			@filesToExclude.push filename
		else
			@log.error "when parsing #{@name} file <#{filename}> doesn't exist"
		end
	end
	
end
