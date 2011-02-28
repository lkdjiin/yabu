# -*- encoding: utf-8 -*-

$YABU_PATH = File.expand_path(File.join(File.expand_path(File.dirname(__FILE__)), '..'))

require './lib/yabu'
include Yabu

YABU_CONF = 'tests/configuration/yabu.conf.test1'
TEST_REPOSITORY = 'tests/temp'
