require 'fileutils'

module Yabu
  
  # Install config files and version file
  class Installer
  
    def initialize base_dir = ENV['HOME']
      @yabu_dir = File.join(base_dir, '.config/yabu')
      @configuration_dir = File.join(base_dir, '.config/yabu/configuration')
    end
  
    def install_needed?
      not File.exists?(@yabu_dir)
    end
    
    # @return true if version installed is different of this version of Yabu.
    # @note I don't take any account of higher or lower version, just difference.
    def upgrade_needed?
      my_version = Yabu.version
      installed_version = File.read(File.join(@yabu_dir, 'VERSION')).strip
      my_version != installed_version
    end
    
    # Copy version file in yabu hidden config folder.
    def upgrade
      FileUtils.cp(File.join($YABU_PATH, 'VERSION'), @yabu_dir)
    end
    
    # Install config files in user's home folder
    # List of copied files:
    # * VERSION
    # * configuration/directories.conf
    # * configuration/yabu.conf
    def install
      copy_files
      display_message
      exit
    end
    
    private
    
    def copy_files
      FileUtils.makedirs(@configuration_dir)
      copy_version
      copy_config
    end
    
    def copy_version
      FileUtils.cp("#{$YABU_PATH}/VERSION", @yabu_dir)
    end
    
    def copy_config
      FileUtils.cp("#{$YABU_PATH}/configuration/directories.conf", @configuration_dir)
      FileUtils.cp("#{$YABU_PATH}/configuration/yabu.conf", @configuration_dir)
    end
    
    def display_message
      puts "This is your first installation of yabu."
      puts "Some files have been copied in #{@yabu_dir}"
      puts "Please, look at the documentation to modify those files, in order to suit your needs."
      puts "Restart yabu when you are ready."
    end
  
  end
end
