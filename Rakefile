# -*- encoding: utf-8 -*-

desc 'Unit tests'
task :default => :unit

desc 'Unit tests'
task :unit do 
	Dir.chdir 'tests'
	exec "ruby test.rb"
end



desc 'Test Yabu'
task :test do 
  puts 'Testing Yabu...'
  sh "rspec --color --format documentation spec"
end

desc 'Generate yard documentation'
task :doc do 
	exec 'yardoc --title "Yeah! Another Backup Utility Documentation" - NEWS COPYING'
end

desc 'Check for code smells'
task :reek do
  puts 'Checking for code smells...'
  files = Dir.glob 'lib/**/*.rb'
  files.delete 'lib/prunille/prunille.rb'
  args = files.join(' ')
  sh "reek --quiet lib | ./reek.sed"
end

# Build & Install

desc 'Build the gem'
task :build do
  exec "gem build yabu.gemspec"
end

desc 'Install the gem (maybe you have to be root)'
task :install do
	require 'rake'
	f = FileList['yabu*gem'].to_a
	exec "gem install #{f.first}"
end
