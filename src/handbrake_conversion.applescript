--on adding folder items to this_folder after receiving these_items
with timeout of (720 * 60) seconds
	tell application "Finder"
		--Get all AVI and MKV files that have no label color yet, meaning it hasn't been processed
		set allFiles to every file of entire contents of ("Video:Movies" as alias) whose ((name extension is "avi" or name extension is "mkv") and label index is 0)
		
		--Repeat for all files in above folder
		repeat with i from 1 to number of items in allFiles
			set currentFile to (item i of allFiles)
			
			try
				--Set to gray label to indicate processing
				set label index of currentFile to 7
				
				--Assemble original and new file paths
				set origFilepath to quoted form of POSIX path of (currentFile as alias)
				set newFilepath to (characters 1 thru -5 of origFilepath as string) & "mp4'"
				
				--Start the conversion
				set shellCommand to "/Applications/HandBrakeCLI -i " & origFilepath & " -o " & newFilepath & " --preset='Normal'"
				do shell script shellCommand
				
				--Set the label to green in case file deletion fails
				set label index of currentFile to 6
				
				--Remove the old file
				set shellCommand to "rm -f " & origFilepath
				do shell script shellCommand
			on error errmsg
				--Set the label to red to indicate failure
				set label index of currentFile to 2
			end try
		end repeat
	end tell
end timeout
--end adding folder items to