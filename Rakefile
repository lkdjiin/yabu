# -*- encoding: utf-8 -*-

desc 'Tests'
task :default => :test

desc 'Test Yabu'
task :test do 
  puts 'Testing Yabu...'
  sh "rspec --color spec"
end

desc 'Generate yard documentation'
task :doc do 
	exec 'yardoc --title "Yeah! Another Backup Utility Documentation" - NEWS COPYING'
end

desc 'Check for code smells'
task :reek do
  puts 'Checking for code smells...'
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
