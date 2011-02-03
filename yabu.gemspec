# -*- encoding: utf-8 -*-

require 'rake'

Gem::Specification.new do |s|
  s.name = 'yabu'
  s.version = File.read('VERSION').strip
  s.authors = ['Xavier Nayrac']
  s.email = 'xavier.nayrac@gmail.com'
  s.summary = 'Command line utility for daily backup.'
  s.homepage = 'https://github.com/lkdjiin/Yabu/wiki'
  s.description = %q{"Yeah! Another Backup Utility" (Yabu) is a backup and recovery 
command line utility for linux. It should run on other unixes as well.}
	
	readmes = FileList.new('*') do |list|
		list.exclude(/(^|[^.a-z])[a-z]+/)
		list.exclude('TODO')
	end.to_a
  s.files = FileList['lib/**/*.rb', 'bin/*', 'configuration/*', '[A-Z]*'].to_a + readmes
	s.executables = ['yabu']
	s.license = 'GPL-3'
	s.required_ruby_version = '>= 1.9.2'
end
