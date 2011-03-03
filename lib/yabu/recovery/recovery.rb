module Yabu

	# I restore your data
	class Recovery
    include Loggable

		# Default constructor.
		# @param [String] Config The 'yabu.conf' file path. To use only during testing.
		def initialize yabu_conf = ''
			@backup_name = ''
			if yabu_conf.empty?
				@yabu_config = YabuConfig.new
			else
				@yabu_config = YabuConfig.new yabu_conf
			end
      @options = {force: false}
		end
		
		# I start the recovery process
		# @param [Hash] options
		# @option options [Boolean] :force Force to recover all files
		def run options={}
			@options = @options.merge(options)
			log_info "Recover mode with following options: force=#{@options[:force]}"
      @backup_name = BackupFinder.new(@yabu_config['path']).newest
			# @todo diplay message and exit if there is no backup
			restore
		end
		
	private
		
		def restore
			backup_dir = File.join(@yabu_config['path'], @backup_name)
			log_info_and_display "Recovering from #{backup_dir}"
      restorer = FilesRestorer.new backup_dir, @options
      restorer.run
		end
		
	end

end
