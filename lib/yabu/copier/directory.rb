require "fileutils"

module Yabu

  # Directory maker
	class Directory
  
    def initialize
      @log = Log.instance
    end
    
    # I am trying to create the dest directory, along with its parent's directories if they doesn't
		# exist.
		def create_if_needed dest
			return if File.exist?(dest)
			begin
				FileUtils.makedirs dest
				@log.debug "Created #{dest}"
			rescue SystemCallError
				@log.fatal "Cannot create #{dest}"
			end
		end
    
  end
  
end
