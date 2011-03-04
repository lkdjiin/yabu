# -*- encoding: utf-8 -*-

require 'optparse'

module Yabu

  # I parse the command line.
  class Options
    # Here is a list of command line options :
    # * --force
    # * --version
    # * --license
    # * --help
    # * --test
    # @todo refactoring
    def initialize args = ARGV
      @options = {}
      @options[:version] = false
      @options[:license] = false
      @options[:test] = false
      @options[:force] = false
      @options[:help] = false
      
      optparse = OptionParser.new do|opts|
        opts.banner =  banner
        define_switches opts
      end
      
      begin
        optparse.parse! args
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

    def define_switches opts
      opts.on( '-v', '--version', 'Print version number and exit' ) { @options[:version] = true }
      opts.on( '-l', '--license', 'Print program\'s license and exit' ) { @options[:license] = true }
      opts.on( '-t', '--test', 'Log all' ) { @options[:test] = true }
      opts.on( '-f', '--force', 'Force to recover ALL files' ) { @options[:force] = true }
      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
    end

    def print_version
      puts Yabu.version
      exit
    end
    
    def print_license
      Yabu::Message.print_license
      exit
    end
    
    def banner
      %q{Usage: yabu [options] [command]

  Where command is...
    backup:            start the backup (default command)
    recover:           restore missing files from the most recent backup
    help command_name: display help on command_name

  And options are...
  }
    end
  end

end
