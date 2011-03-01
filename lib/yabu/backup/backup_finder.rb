module Yabu

	# I find backup of interest from a repository
	class BackupFinder
  
    def initialize repository
      raise ArgumentError unless File.directory?(repository)
      @repository = repository
      @backups = []
      Dir.foreach(@repository) do |file|
				next if (file == ".") or (file == "..")
				@backups << file if File.directory?(File.expand_path(File.join(@repository, file)))
			end
    end
    
    def newest
      return false if @backups.empty?
			@backups.sort!.reverse!
			@backups[0]
    end
    
    def all
			@backups
    end
    
  end

end
