module Yabu

  # Copy files from repository to local folders given user's options
	class FilesRestorer
  
    def initialize backup_dir, options={}
      backup_dir = File.expand_path backup_dir
      raise ArgumentError unless File.directory? backup_dir
      @backup_dir = backup_dir
      @log = Log.instance
      @options = {force: false}.merge(options)
      @files = File.join(@backup_dir, "**", "*")
    end
    
    def run
      Dir.glob(@files).each do |file_in_repo|
				file_on_computer = file_in_repo.sub(Regexp.new(@backup_dir), '')
				putc(?.)
				if @options[:force]
					copy_file_to_computer(file_in_repo, file_on_computer) if File.file?(file_in_repo)
				elsif (not File.exists?(file_on_computer))
					copy_item_to_computer file_in_repo, file_on_computer
				end
			end
    end
    
    private
    
    def copy_item_to_computer from, to
			if File.directory?(from)
				create_dir_on_computer to
			else
				copy_file_to_computer(from, to)
			end
		end
		
		def copy_file_to_computer from, to
			FileUtils.cp from, to
			@log.info "Restored #{to}"
		end
		
		def create_dir_on_computer name
			FileUtils.mkdir name
			@log.info "Created dir #{name}"
		end
    
  end
  
end
