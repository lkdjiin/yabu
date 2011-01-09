#!/usr/bin/env ruby

# ="Yeah! Another Backup Utility"
#
# Copyright 2010, 2011 Xavier Nayrac
# GNU General Public License version 3
#
# ==Overview
# "Yeah! Another Backup Utility" is a command line utility to make daily backup.
#
# @note "Yeah! Another Backup Utility" is in it's development stage. Try it, hack it, learn from
# 	it, but DON'T USE IT right now in a production environment.

require "lib/options"
require "lib/backup"
require "lib/backup-deletor"
require "lib/version"
require "lib/log"
require "lib/message"
require "lib/copier"
require "lib/yabu-config"
require "lib/dir-config"
require "lib/recovery"

# I am the main class of the Yabu application.
# @example Start the application
#		main = Yabu.new
#		main.run
class Yabu

	# Default constructor
	def initialize
		opt = Options.new
		Message.printLicense
		generalConfig = YabuConfig.new
		@log = Log.instance('yabu.log', generalConfig['logRotation'])
		@log.level = Log::INFO unless opt[:test]
	end
	
	# Start the backup process or the recover process.
	def run
		if ARGV.size == 1 and ARGV[0] == 'recover'
			startToRecover
		else
			startToBackup
		end
	end

private

	# Start the backup process.
	def startToBackup
		backup
		deleteOldBackup
	end
	
	# Start the recovery process.
	def startToRecover
		Recovery.new.run
	end

	# Do the backup.
	def backup
		Backup.new.run
	end
	
	# Remove the oldest backups if they exist.
	def deleteOldBackup
		BackupDeletor.new.run
	end
end

# time of program start
t1 = Time.now

# Backup (or recover)
main = Yabu.new
main.run

# End of program, calculate and write elapsed time.
seconds = Time.now.to_i - t1.to_i
minutes = (seconds / 60).to_i
seconds %= 60
puts "Done in #{minutes} minutes #{seconds} seconds"
