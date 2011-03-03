require "fileutils"

module Yabu

	# Copy one regular file, not a directory, not a symbolic link, etc.
	class FileCopier
    include Loggable
    
    def initialize
    end
    
		# @param [String] source the source path
		# @param [String] dest the destination path
		def copy source, dest
			if File.file?(source)
				copy_regular source, dest
			else
				log_error "Yabu do not know what to do with #{source}"
        false
			end
		end
    
    private
    
    def copy_regular source, dest
      begin
        FileUtils.cp(source, dest)
        log_debug "Copied #{source} to #{dest}"
        true
      rescue
        log_error "Cannot copy #{source} to #{dest}"
        false
      end
    end
    
  end
  
end
