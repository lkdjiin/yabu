require "fileutils"

module Yabu

	# I'm doing the hard work of copying recursivly the files and directories to backup.
	# I'm hacked from an article found on http://iamneato.com/2009/07/28/copy-folders-recursively
	class Copier
		# Get the number of non-fatal errors occured during copy
		attr_reader :errors

		# @param [Array<String>] excludeFileList List of directories and files 
		#		to exclude from the backups.
		def initialize(excludeFileList)
			@log = Log.instance
			@exclude = excludeFileList
			@errors = 0
		end

		# I try to recursively copy src to dest.
		# @param [String] src the source file or directory
		# @param [String] dest the destination file or directory
		def copy src, dest
			createIfNeeded dest if File.directory? src
			if File.directory? src
				copyDirectory src, dest
			else
				copyFile src, dest
			end
		end

	private

		# I am trying to create the dest directory, along with its parent's directories if they doesn't
		# exist.
		def createIfNeeded dest
			return if File.exist?(dest)
			begin
				FileUtils.makedirs dest
				@log.debug "Created #{dest}"
			rescue SystemCallError
				@log.fatal "Cannot create #{dest}"
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
		
		# Copy one file, not a directory.
		# @param [String] source the source path
		# @param [String] dest the destination path
		def copyFile source, dest
			begin
				FileUtils.cp(source, dest)
				@log.debug "Copied #{source} to #{dest}"
			rescue
				record_error "Cannot copy #{source} to #{dest}"
			end
		end
		
		# Copy a directory and its content (recursive).
		# @param [String] source the source path
		# @param [String] dest the destination path
		def copyDirectory source, dest
			begin
				loopCopy source, dest
			rescue SystemCallError
				record_error "Cannot read #{source}"
			end
		end
		
		# Copy a directory and its content (recursive). Compare the files to the list of exclusions.
		# @param [String] source the source path
		# @param [String] dest the destination path
		def loopCopy source, dest
			Dir.foreach(source) do |file|
				next if skip? source, file
				decideHowToCopy(File.join(source, file), File.join(dest, file))
			end
		end
		
		# If +source+ is a file, copy this file. If +source+ is a directory, copy this directory.
		# @param [String] source the source path
		# @param [String] dest the destination path
		def decideHowToCopy source, dest
			if File.directory?(source)
				mkdir dest
				copy source, dest
			else
				copyFile source, dest
			end
		end
		
		# Do we have to skip a file ?
		# @param [String] dir path of the directory file
		# @param [String] file the filename
		# @return [true|false] true if the file is part of the exclude list
		def skip? dir, file
			if exclude?(File.join(dir, file))
				@log.debug("Exclude from saving : " + File.join(dir, file))
				return true
			end
			return true if (file == ".") or (file == "..")
			false
		end
		
		# Create a directory.
		# @param [String] dir the path
		def mkdir dir
			begin
				FileUtils.mkdir(dir)
				@log.debug "Created " + dir
			rescue SystemCallError
				record_error "Cannot create directory #{dir}"
			end
		end
		
		def record_error message
			@log.error message
			@errors += 1
		end
		
	end

end
