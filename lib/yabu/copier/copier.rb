require "fileutils"

module Yabu

	# I'm doing the hard work of copying recursivly the files and directories to backup.
	# I'm hacked from an article found on http://iamneato.com/2009/07/28/copy-folders-recursively
	class Copier
    include Loggable
		# Get the number of non-fatal errors occured during copy
		attr_reader :errors

		# @param [Array<String>] exclude_files List of directories and files 
		#		to exclude from the backups.
		def initialize(exclude_files)
			@exclude = exclude_files
			@errors = 0
      @directory = Directory.new
      @file_copier = FileCopier.new
		end

		# I try to recursively copy source to dest.
		# @param [String] source Full path name of the file (or directory) on the computer
		# @param [String] dest Full path name of the future file (or directory) in the repository
		def copy source, dest
			if File.directory? source
				@directory.create_if_needed dest 
				copy_directory source, dest
			else
				@directory.create_if_needed File.dirname(dest) if File.directory?(File.dirname(source))
				@errors += 1 unless @file_copier.copy source, dest
			end
		end

	private

		# Copy a directory and its content (recursive).
		# @param [String] source the source path
		# @param [String] dest the destination path
		def copy_directory source, dest
			begin
        Dir.foreach(source) do |file|
          next if skip? source, file
          decide_how_to_copy(File.join(source, file), File.join(dest, file))
        end
			rescue SystemCallError
				record_error "Cannot read #{source}"
			end
		end
    
    # Find if a file is part of the list of files to exclude.
		# @param [String] file a filename to check against the exclude list
		# @return [true | false]
		def exclude? file
			@exclude.each do |element|
				return true if file.match(/#{element}/)
			end
			false
		end
		
		# If +source+ is a file, copy this file. If +source+ is a directory, copy this directory.
		# @param [String] source the source path
		# @param [String] dest the destination path
		def decide_how_to_copy source, dest
			if File.directory?(source)
				success = @directory.create dest
				copy source, dest
			else
				success = @file_copier.copy source, dest
			end
      @errors += 1 unless success
		end
		
		# Do we have to skip a file ?
		# @param [String] dir path of the directory
		# @param [String] file the filename
		# @return [true|false] true if the file is part of the exclude list
		def skip? dir, file
      full_name = File.join(dir, file)
			if exclude?(full_name)
				log_debug("Exclude from saving : " + full_name)
				return true
			end
			return true if (file == ".") or (file == "..")
			false
		end
		
		def record_error message
			log_error message
			@errors += 1
		end
		
	end

end
