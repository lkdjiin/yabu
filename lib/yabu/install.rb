require 'fileutils'

module Yabu
	module Install
	
		# Do we need to install some config files in the user's home folder ? 
		def Install.needed?
			not File.exists?(File.join(ENV['HOME'], '.config/yabu'))
		end
		
		# Install config files in user's home folder
		# List of copied files:
		# * VERSION
		# * configuration/directories.conf
		# * configuration/yabu.conf
		def Install.run
			conf = File.join(ENV['HOME'], '.config/yabu/configuration')
			yab = File.join(ENV['HOME'], '.config/yabu')
			FileUtils.makedirs(conf)
			FileUtils.cp("#{$YABU_PATH}/VERSION", yab)
			FileUtils.cp("#{$YABU_PATH}/configuration/directories.conf", conf)
			FileUtils.cp("#{$YABU_PATH}/configuration/yabu.conf", conf)
		end
		
		def Install.message
			puts "This is your first installation of yabu."
			puts "Some files have been copied in #{ENV['HOME']}/.config/yabu/"
			puts "Please, look at the documentation to modify those files, in order to suit your needs."
			puts "Restart yabu when you are ready."
		end
	
	end
end
