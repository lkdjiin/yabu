module Yabu

	# I deliver messages for the help command
	class Help
	
		def Help.help
			"----------------------------------------
Command: help

Description:
  Display some help about a Yabu command.

Usage:
  yabu help command_name
  
  where command_name is the command name for which you seek help.

Example:
  yabu help recover
"
		end
		
		def Help.recover
			"----------------------------------------
Command: recover

Description:
  Restore your data from the repository.
	
Usage:
  yabu recover [option]

Options:
  TODO

Example:
  yabu recover
"
		end
		
		def Help.backup
			"----------------------------------------
Command: backup

Description:
  Backup your data in the repository. This is the default command for Yabu, so
  you don't need to type it explicitly.
	
Usage:
  yabu backup

Example:
  yabu
"
		end
		
	end
	
end
