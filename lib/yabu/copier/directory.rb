require "fileutils"

module Yabu

  # Directory maker
	class Directory
    include Loggable
    
    def initialize
    end
    
    # I am trying to create the +dir+ directory, along with its parent's directories if they doesn't
		# exist.
		def create_if_needed dir
			return if File.exist?(dir)
			begin
				FileUtils.makedirs dir
				log_debug "Created #{dir}"
			rescue SystemCallError
				log_fatal "Cannot create #{dir}"
			end
		end
    
    # Create the specified directory.
		# @param [String] dir the path
    # @return true if successful
		def create dir
			begin
				FileUtils.mkdir(dir)
				log_debug "Created " + dir
        true
			rescue SystemCallError
				log_error "Cannot create directory #{dir}"
        false
			end
		end
    
  end
  
end
