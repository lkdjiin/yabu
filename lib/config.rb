# There is two classes that holds the configuration.
#
# * YabuConfig, for the "yabu.conf" file
# * DirConfig, for the "directories.conf" file


# I'm parsing a the general configuration file of Yabu : 'configuration/yabu.conf'.
class YabuConfig

	# @param [String] name the name of the configuration's file
	def initialize name
		@log = Log.getInstance
		@dico = Hash.new
		fillArray name
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

	def fillArray name
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
class DirConfig
	attr_reader :files, :filesToExclude
	
	# @param [String] name the name of the configuration's file
	def initialize name
		@log = Log.getInstance
		@files = []
		@filesToExclude = []
		fillArrays name
		@log.info "Parsed #{name}"
	end
	
private

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
