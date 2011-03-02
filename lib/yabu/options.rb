
require 'optparse'

# I parse the command line.
# Currently, there's only options that display messages and exit. So you can instanciate me before
# dealing with class Backup and the like.
# @example
#		opt = Options.new # Exit if there are an option
#		bk = Backup.new # But do this if there are not.
class Options
	attr_reader :options
	# Here is a list of command line options :
	# * --force
	# * --version
	# * --license
	# * --help
	# * --test
	# @todo refactoring
	def initialize
		@options = {}
		optparse = OptionParser.new do|opts|
		 	opts.banner = "Usage: yabu [options] [command]\n\n"
			opts.banner += "Where command is\n"
			opts.banner += "  backup : start the backup (default command)\n"
			opts.banner += "  recover: restore missing files from the most recent backup\n"
			opts.banner += "  help command_name: display help on command_name\n\n"
			opts.banner += "And options are\n"

   		@options[:version] = false
   		opts.on( '-v', '--version', 'Print version number and exit' ) do
     		@options[:version] = true
   		end
   		
   		@options[:license] = false
   		opts.on( '-l', '--license', 'Print program\'s license and exit' ) do
     		@options[:license] = true
   		end
   		
   		@options[:test] = false
   		opts.on( '-t', '--test', 'Log all' ) do
     		@options[:test] = true
   		end
			
			@options[:force] = false
   		opts.on( '-f', '--force', 'Force to recover ALL files' ) do
     		@options[:force] = true
   		end
   		
   		opts.on( '-h', '--help', 'Display this screen' ) do
     		puts opts
     		exit
   		end
		end
		begin
			optparse.parse!
		rescue OptionParser::InvalidOption => ex
			puts ex.to_s
			exit 1
		end
		print_version if @options[:version]
		print_license if @options[:license]
	end
	
	def [](key)
		@options[key]
	end
	
private

	def print_version
		puts Yabu.version
		exit
	end
	
	def print_license
		Yabu::Message.print_license
		exit
	end
end
