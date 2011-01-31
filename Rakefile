desc 'Unit tests'
task :default => :unit

desc 'Unit tests'
task :unit do 
	Dir.chdir 'tests'
	exec "ruby test.rb"
end

desc 'Run Yabu'
task :run do
  exec "./bin/yabu"
end

desc 'Generate yard documentation'
task :doc do 
	exec 'yardoc --title "Yeah! Another Backup Utility Documentation" - NEWS COPYING'
end
