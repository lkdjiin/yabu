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
