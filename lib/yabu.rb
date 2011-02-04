require "yabu/options"
require "yabu/backup"
require "yabu/backup-deletor"
require "yabu/log"
require "yabu/message"
require "yabu/copier"
require "yabu/yabu-config"
require "yabu/dir-config"
require "yabu/recovery"
require "yabu/main"
require "yabu/install"
require "yabu/help"

# Main module of the Yabu application.
# I contain (or will contain):
# * Some widely used constants
# * Little helper methods (like Yabu.version)
# * Exceptions classes
module Yabu

	DIR_CONFIG_FILE_PATH = File.join(ENV['HOME'], '.config/yabu/configuration/directories.conf')
	
	# Get version of this Yabu application
	# @return [String]
	def Yabu.version
		File.read($YABU_PATH + '/VERSION').strip
	end
	
	class NoFullBackupMarkError < StandardError
	end
	
end
