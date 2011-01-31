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

module Yabu

	def Yabu.version
		File.read($YABU_PATH + '/VERSION').strip
	end
	
end
