# @example To test Yabu type :
#		ruby ./test.rb
require "lib/yabu-config"
require "lib/dir-config"
require "lib/log"
require "lib/copier"
require "lib/backup"
require "lib/backup-deletor"
require "lib/message"
require "lib/version"

require "test/unit"

require "tests/tc-yabu-config"
require "tests/tc-dir-config"
require "tests/tc-copier"
require "tests/tc-backup-deletor"
require "tests/tc-backup"
