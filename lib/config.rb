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
		@log.info "Parsed #{name}"
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
		@log = Log.instance
		@files = []
		@filesToExclude = []
		fillArrays name
		@log.info "Parsed #{name}"
	end
	
private

	# My job is to parse the configuration file to fill some lists with the information found
	# in that file.
	# @param [String] name the name of the configuration's file
	def fillArrays name
		# @todo catching read exception
		IO.foreach(name) { |line| 
			next if line.strip! =~ /^#/
			next if line =~ /^$/
			a, b = line.split(' ', 2)
			@files.push b.strip if a.strip == "+"
			@filesToExclude.push b.strip if a.strip == "-"
		}
	end
	
end
