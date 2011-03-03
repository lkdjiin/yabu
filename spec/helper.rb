# -*- encoding: utf-8 -*-
require 'coco'
$YABU_PATH = File.expand_path(File.join(File.expand_path(File.dirname(__FILE__)), '..'))

require './lib/yabu'
include Yabu

YABU_CONF = 'tests/configuration/yabu.conf.test1'
DIR_CONF = 'tests/configuration/directories.conf.test'
TEST_REPOSITORY = 'tests/temp'
BACKED_UP_DIR = 'tests/backed_up'

def clean_test_repository
  Dir.foreach(TEST_REPOSITORY) do |file|
    next if (file == ".") or (file == "..")
    filename = File.join(TEST_REPOSITORY, file)
    FileUtils.remove_dir(filename) if File.directory?(filename)
    FileUtils.remove_file(filename) if File.file?(filename)
  end
end
