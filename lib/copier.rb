require "fileutils"

# I'm doing the hard work of copying recursivly the files and directories to backup.
# I'm hacked from an article found on http://iamneato.com/2009/07/28/copy-folders-recursively
class Copier

	# @param [Array<String>] excludeFileList List of directories and files 
	#		to exclude from the backups.
  def initialize(excludeFileList)
  	@log = Log.instance
    @exclude = excludeFileList
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

	# @param [String] file filename to check against the exclude list.
	# @return [true | false]
  def exclude? file
    @exclude.each do |element|
      return true if file.match(/#{element}/)
    end
    false
  end
  
  def copyFile source, dest
  	begin
			FileUtils.cp(source, dest)
			@log.debug "Copied #{source} to #{dest}"
		rescue
			@log.error "Cannot copy #{source} to #{dest}"
		end
  end
  
  def copyDirectory source, dest
  	begin
			loopCopy source, dest
    rescue SystemCallError
    	@log.error "Cannot read #{source}"
    end
  end
  
  def loopCopy source, dest
  	Dir.foreach(source) do |file|
			next if skip? source, file
			decideHowToCopy(File.join(source, file), File.join(dest, file))
		end
  end
  
  def decideHowToCopy source, dest
  	if File.directory?(source)
			mkdir dest
			copy source, dest
		else
			copyFile source, dest
		end
  end
  
  def skip? source, file
  	if exclude?(File.join(source, file))
			@log.debug("Exclude from saving : " + File.join(source, file))
			return true
		end
		return true if (file == ".") or (file == "..")
		false
  end
  
  def mkdir dest
  	begin
			FileUtils.mkdir(dest)
			@log.debug "Created " + dest
		rescue SystemCallError
			@log.error "Cannot create directory #{dest}"
		end
  end
  
end
