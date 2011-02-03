# You cannot test some classes
# because they refer on some files on my local computer.
# Please improve this if you wish and have time : this is free software !


$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$YABU_PATH = File.expand_path(File.dirname(__FILE__)) + '/..'
require "yabu"

require "test/unit"

require "../tests/tc-yabu-config"
require "../tests/tc-dir-config"
require "../tests/tc-copier"
require "../tests/tc-backup-deletor"
require "../tests/tc-backup"
require "../tests/tc-recovery"
require "../tests/tc-help"
