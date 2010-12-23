#!/usr/bin/env ruby

# ="Yeah! Another Backup Utility"
#
# Author:: Xavier Nayrac (mailto:xavier.nayrac@gmail.com)
# Copyright:: Copyright 2010 Xavier Nayrac
# License::   GNU General Public License version 3
#
# ==Overview
# "Yeah! Another Backup Utility" is a command line utility to make daily backup.
# See the user's guide at http://sources.xavier.free.fr/ruby.php#yabu to know
# how to configure it and how to use it.
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

# I am the main class of the Yabu application.
# @example Start the application
#		main = Yabu.new
#		main.run
class Yabu

	def initialize
		opt = Options.new
		Message.printLicense
		@log = Log.instance
		@log.level = Log::INFO
	end
	
	def run
		backup
		deleteOldBackup
	end

private

	def backup
		backup = Backup.new
		backup.run
	end
	
	def deleteOldBackup
		bkDeletor = BackupDeletor.new
		bkDeletor.run
	end
end

t1 = Time.now

main = Yabu.new
main.run

seconds = Time.now.to_i - t1.to_i
minutes = (seconds / 60).to_i
seconds %= 60
puts "Backed up in #{minutes} minutes #{seconds} seconds"
