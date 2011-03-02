module Yabu

  # I parse a line of the diretories config file.
  class LineParser
  
    def parse line
      @action, @filename = line.split(' ', 2)
			process_action
      process_filename
      [@action, @filename]
    end
    
    private
    
    def process_action
      return if @action.nil?
      @action.strip!
      if @action == '+'
        @action = :include
      elsif @action == '-'
        @action = :exclude
      else
        nil
      end
    end
    
    def process_filename
      return if @filename.nil?
      @filename.strip!
      @filename = File.expand_path @filename
    end
    
  end
  
end
