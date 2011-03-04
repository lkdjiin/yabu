# -*- encoding: utf-8 -*-
require './spec/helper'

describe Main do

  before :all do
    class Recovery
      alias old_run run
      def run arg
        "ok"
      end
    end
    
    class Backup
      alias old_full full
      alias old_initialize initialize
      def full
        0
      end
      def initialize; end
    end
    
    class BackupDeletor
      alias old_run run
      alias old_initialize initialize
      def run; end
      def initialize; end
    end
    
  end
  
  after :all do
    class Recovery
      alias run old_run
    end
    
    class Backup
      alias full old_full
      alias initialize old_initialize 
    end
    
    class BackupDeletor
      alias run old_run
      alias initialize old_initialize 
    end
    
  end

  it "must exit after command help" do
    lambda{Main.new({}, CommandParser.new(["help"]))}.should raise_error(SystemExit)
    lambda{Main.new({}, CommandParser.new(["help", "help"]))}.should raise_error(SystemExit)
    lambda{Main.new({}, CommandParser.new(["help", "recover"]))}.should raise_error(SystemExit)
    lambda{Main.new({}, CommandParser.new(["help", "backup"]))}.should raise_error(SystemExit)
  end
  
  it "must start the recovery process" do
    main = Main.new({}, CommandParser.new(["recover"]))
    main.run.should == "ok"
  end
  
  it "must exit on unknow command" do
    main = Main.new({}, CommandParser.new(["azerty"]))
    lambda{main.run}.should raise_error(SystemExit)
  end
  
  it "must start the backup process" do
    main = Main.new({}, CommandParser.new(["backup"]))
    main.run.should == nil
  end
  
end
