require "singleton"

# I'm parsing a the general (ini like) configuration file of Yabu : 'configuration/yabu.conf'.
# From version 0.1, there is only one used key :
# @example
#		c = YabuConfig.new
#		pathToBackupDir = c.get 'path'
class YabuConfig
	include Singleton
	
	def initialize
		@NAME = 'configuration/yabu.conf'
		@log = Log.instance
		@dico = Hash.new
		fillHash
		@log.debug "Parsed #{@NAME}"
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
	def fillHash
		IO.foreach(@NAME) { |line| 
			next if line.strip! =~ /^#/
			next if line =~ /^$/
			a, b = line.split '='
			@dico[a.strip] = b.strip
		}
	end
	
end
