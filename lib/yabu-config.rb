require "yaml"

# I'm parsing the general (YAML) configuration file of Yabu : 'configuration/yabu.conf'.
# @example
#		c = YabuConfig.new
#		pathToBackupDir = c.['path']
# @see configuration/yabu.conf for a description of all keys
class YabuConfig
	
	def initialize filename = 'configuration/yabu.conf'
		@log = Log.instance
		@dico = YAML.load_file(filename)
		@log.debug "Parsed #{filename}"
	end
	
	def [](k)
		@dico[k]
	end
	
end
