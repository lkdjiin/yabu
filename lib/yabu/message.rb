module Yabu

	# I contain class methods that displays messages on the screen.
	class Message

		# I print a little banner that state I'm a free software.
		def Message.printLicense
			license = <<END_OF_LICENSE
			
	"Yeah! Another Backup Utility" Copyright (C) 2010, 2011 Xavier Nayrac
	This program comes with ABSOLUTELY NO WARRANTY. This is free software, and you
	are welcome to redistribute it under certain conditions.
	See COPYING for license details.
			
END_OF_LICENSE
			puts license
		end

		def Message.printEndOfBackup
			puts "Backup is done."
		end
		
		def Message.searchingOldBackups
			puts "Searching for old backups to remove."
		end
		
		def Message.endOfRemovingOldBackups
			puts "Old backups removed."
		end
		
		def Message.noBackupsToRemove
			puts "No backup to remove."
		end
		
	end

end
