require "yabu/log"
require "yabu/message"
require "yabu/options"

require "yabu/backup/backup"
require "yabu/backup/backup_deletor"
require "yabu/backup/backup_finder"
require "yabu/backup/full_backup"


require "yabu/copier/copier"
require "yabu/copier/directory"
require "yabu/copier/file_copier"

require "yabu/config/yabu_config"
require "yabu/config/dir_config"
require "yabu/config/line_parser"

require "yabu/recovery/recovery"
require "yabu/recovery/files_restorer"

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
	
	# A backup folder name is made by the concatenation of date and time.
	# The pattern is 'YYYYmmdd-hhmm' : year, month, day, hours and minutes.
	# @return [String] the backup folder name. Example : '20101231-1438'
	def Yabu.backup_folder_name
		time = Time.now
		time.strftime("%Y%m%d-%H%M")
	end
	
	# Raised when we try to do an incremental backup without having a full backup.
	# @since 0.6
	class NoFullBackupError < StandardError
	end
	
end
