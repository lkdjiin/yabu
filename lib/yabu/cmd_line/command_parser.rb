module Yabu

  # I parse the command line arguments (not the options).
  # In facts, I should failed if command line still has options in it.
  class CommandParser
  
    def initialize args = ARGV
      @args = args
    end
    
    def backup?
      return true if command? "backup"
      default_command?
    end
    
    def default_command?
      @args.empty?
    end
    private :"default_command?"
    
    def recover?
      command? "recover"
    end
    
    def help?
      command? "help"
    end
    
    def sub_command
      return nil unless command? "help"
      sub = @args[1]
      sub.to_sym unless sub.nil?
    end
    
    private
    
    def command? command
      if @args[0] == command
        true
      else
        false
      end
    end
    
  end
  
end
