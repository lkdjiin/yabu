
require 'optparse'

# I parse the command line.
# Currently, there's only options that display messages and exit. So you can instanciate me before
# dealing with class Backup and the like.
# @example
#		opt = Options.new # Exit if there are an option
#		bk = Backup.new # But do this if there are not.
class Options

	# Here is a list of command line options :
	# * --version
	# * --license
	# * --help
	# * --test
	# @todo refactoring
	def initialize
		@options = {}
		optparse = OptionParser.new do|opts|
		 	opts.banner = "Usage: yabu [options] [command]\n\n"
			opts.banner += "Where command are\n"
			opts.banner += "  backup : start the backup (default command)\n"
			opts.banner += "  recover: restore missing files from the most recent backup\n\n"
			opts.banner += "And options are\n"
		 	# Define the options, and what they do
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
   		
   		opts.on( '-h', '--help', 'Display this screen' ) do
     		puts opts
     		exit
   		end
		end
		begin
			optparse.parse!
		rescue OptionParser::InvalidOption => e
			puts e.to_s
			exit 1
		end
		printVersion if @options[:version]
		printLicense if @options[:license]
	end
	
	def [](k)
		@options[k]
	end
	
private

	def printVersion
		puts Yabu.version
		exit
	end
	
	def printLicense
		puts "\"Yeah! Another Backup Utility\" is licensed under the GPL 3. See the COPYING's file."
		exit
	end
end
