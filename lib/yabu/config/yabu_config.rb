require "yaml"

module Yabu

	# I'm parsing the general (YAML) configuration file of Yabu : 'configuration/yabu.conf'.
	# @example
	#		c = YabuConfig.new
	#		path_to_repository = c['path']
	# See the file configuration/yabu.conf for a description of all keys.
	class YabuConfig
    include Loggable
		
		# @param [String] filename The 'yabu.conf' file path. To use only during testing.
		def initialize filename = File.join(ENV['HOME'], '.config/yabu/configuration/yabu.conf')
			@dico = YAML.load_file(filename)
			log_info "Parsed #{filename}"
		end
		
		# Get a value from the config.
		# @param [String] key the key in the config file
		# @return [Object]
		def [](key)
			@dico[key]
		end
		
	end

end
