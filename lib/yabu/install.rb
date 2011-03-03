require 'fileutils'

module Yabu
  
  # Install config files and version file in user's home
  # @since 0.6
  module Install
  
    # Do we need to install some config files in the user's home folder ? 
    def Install.needed?
      not File.exists?(File.join(ENV['HOME'], '.config/yabu'))
    end
    
    # @return true if version installed is different of this version of Yabu.
    # @since 0.7
    # @note I don't take any account of higher or lower version, just difference.
    def Install.upgrade?
      my_version = Yabu.version
      installed_version = File.read(File.join(ENV['HOME'], '.config/yabu/VERSION')).strip
      my_version != installed_version
    end
    
    # Copy file version in yabu hidden config folder.
    # @since 0.7
    def Install.upgrade
      FileUtils.cp(File.join($YABU_PATH, 'VERSION'), File.join(ENV['HOME'], '.config/yabu'))
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
