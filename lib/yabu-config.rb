require "yaml"

# I'm parsing the general (YAML) configuration file of Yabu : 'configuration/yabu.conf'.
# @example
#		c = YabuConfig.new
#		pathToBackupDir = c.['path']
# @see configuration/yabu.conf for a description of all keys
class YabuConfig
	
	# @param [String] filename The 'yabu.conf' file path. To use only during testing.
	def initialize filename = 'configuration/yabu.conf'
		@log = Log.instance
		@dico = YAML.load_file(filename)
		@log.info "Parsed #{filename}"
	end
	
	# Get a value from the config.
	# @param [String] k the key in the config file
	def [](k)
		@dico[k]
	end
	
end
