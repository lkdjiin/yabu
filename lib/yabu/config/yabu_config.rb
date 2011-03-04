require "yaml"

module Yabu

	# I'm parsing the general (YAML) configuration file of Yabu : 'configuration/yabu.conf'.
	# @example
	#		c = YabuConfig.new
	#		path_to_repository = c['path']
	# See the file configuration/yabu.conf for a description of all keys.
	class YabuConfig < Hash
		
		# @param [String] filename The 'yabu.conf' file path. To use only during testing.
		def initialize filename = File.join(ENV['HOME'], '.config/yabu/configuration/yabu.conf')
      self.merge!(YAML.load_file(filename))
		end
		
	end

end
