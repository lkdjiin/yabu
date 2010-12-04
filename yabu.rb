#!/usr/bin/env ruby

require "lib/options"
require "lib/backup"
require "lib/version"
require "lib/log"
require "lib/message"
require "lib/copier"
require "lib/config"

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
#
# ==Running
# Create an instance of the Backup class and call it's run method.
# 
# @example Start the backup
#		bk = Backup.new
#		bk.run
class Yabu
	def initialize
		opt = Options.new
		Message.printLicense
		@log = Log.instance
		@log.level = Log::INFO
		backup = Backup.new
		backup.run
	end
end

Yabu.new
