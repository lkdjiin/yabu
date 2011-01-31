# You cannot test the Backup class (tests in tc-backup.rb)
# because this test refers on some files on my local computer.
# Hack it if you wish (and have time) : this is free software !


$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require "yabu"

require "test/unit"

require "../tests/tc-yabu-config"
require "../tests/tc-dir-config"
require "../tests/tc-copier"
require "../tests/tc-backup-deletor"
require "../tests/tc-backup"
require "../tests/tc-recovery"
