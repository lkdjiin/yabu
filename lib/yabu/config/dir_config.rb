module Yabu

	# I'm parsing the 'configuration/directories.conf' which contains files and directories
	# to add (or remove) to the backups.
  # My job is to dispatch that files/directories in two lists :
	# 1. files/directories to include to the backup
	# 2. files/directories to exclude from the backup
	#
	# @example :
	#		c = DirConfig.new 'configuration/directories.conf'
	#		includes = c.files
	#		excludes = c.files_to_exclude
	# @todo rename method the ruby way
	class DirConfig
		attr_reader :files, :files_to_exclude
		
		# @param [String] name The name of the configuration file
		def initialize(name)
			@name = name
			@log = Log.instance
			@files = []
			@files_to_exclude = []
      @parser = LineParser.new
      
			begin
				IO.foreach(@name) { |line| 
					line.strip!
					next if skip_line? line
					parse line
				}
			rescue
				@log.fatal "Cannot parse #{@name}"
			end
      
			@log.debug "Parsed #{@name}"
		end
		
	private
		
		# @return [true] if the line is a commentary or is empty.
		# @return [false] in other cases.
		def skip_line? line
			return true if (line =~ /^#/) or (line =~ /^$/)
			false
		end
		
		# I parse a line of the config file.
		def parse line
      action, filename = @parser.parse line
      return false if missing_filename? filename
			dispatch action, filename
		end
    
    def missing_filename? filename
      if filename == nil # could happen if user forgot to write + or -.
				@log.error "file name missing when parsing #{@name}"
				true
			end
    end
		
		# Decide if this is a file to include or to exclude.
		# @param [String] action can be "+" or "-"
		# @param [String] filename name of file to include/exclude
		def dispatch action, filename
			if action == :include
				include_file filename 
			elsif action == :exclude
				exclude_file filename
			else
				@log.error "bad action in #{@name}. Not archived. action is <#{action}> and file is <#{filename}>"
			end
		end
		
		# Add +filename+ to the list of files to include.
		def include_file filename
			if File.exist? filename
				@files.push filename
			else
				@log.error "when parsing #{@name} file <#{filename}> doesn't exist"
			end
		end
		
		# Add +filename+ to the list of files to exclude.
		def exclude_file filename
			if File.exist? filename
				@files_to_exclude.push filename
			else
				@log.error "when parsing #{@name} file <#{filename}> doesn't exist"
			end
		end
		
	end

end
