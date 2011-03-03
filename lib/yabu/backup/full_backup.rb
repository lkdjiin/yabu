# -*- encoding: utf-8 -*-

require "fileutils"

module Yabu

  # I make a backup of all directories and files.
  class FullBackup
    include Loggable
    
    def initialize backup_folder, dir_config
      log_fatal "#{backup_folder} is not writable" unless File.writable?(backup_folder)
      @backup_folder = backup_folder
      @dir_config = dir_config
    end
    
    # @return nil if there is no full backup in the repository, otherwise returns
		#   the most recent full backup folder name
		def FullBackup.most_recent repository
			full_marks = Dir.glob(File.join(repository, '*.full'))
			return nil if full_marks.empty?
			name = full_marks.sort!.reverse!.first
			File.basename name, '.full'
		end
    
    # @return [Fixnum] Number of errors occured
    def backup
      create_full_backup_mark
      copy
    end
    
    private
    
    def create_full_backup_mark
			begin
				FileUtils.touch "#{@backup_folder}.full"
				log_debug "Created #{@backup_folder}.full"
			rescue SystemCallError
				log_fatal "Cannot create #{@backup_folder}.full"
			end
		end
    
    # I do the effective backup.
		# @return [Fixnum] Number of errors occured
		def copy
			copier = Copier.new @dir_config.files_to_exclude
			@dir_config.files.each do |item_on_computer| 
				copier.copy(item_on_computer, File.join(@backup_folder, item_on_computer))
			end
			copier.errors
		end
    
  end
  
end
