on open location vscode_url
	
	# Defaults.
	set vscoode_path to "/usr/local/bin/code"
	set vscode_opts to " -g -r "
	set vscode_file to ""
	set vscode_line to 0
	
	# Get the args from the end of the URL.
	set x to the offset of "?" in vscode_url
	set vscode_args_string to text from (x + 1) to -1 of vscode_url
	set AppleScript's text item delimiters to "&"
	set vscode_args to every text item of vscode_args_string
	set AppleScript's text item delimiters to ""
	
	# Loop through the args.
	repeat with i from 1 to count of vscode_args
		
		set vscode_pair to item i of vscode_args
		set x to the offset of "=" in vscode_pair
		
		if x > 0 then
			set AppleScript's text item delimiters to "="
			copy every text item of vscode_pair to {vscode_key, vscode_value}
			
			# Decode the value using PHP urldecode()
			set vscode_value to do shell script "php -r 'echo urldecode(\"" & vscode_value & "\");'"
			
			# See if the arg is something we're looking for.
			if vscode_key = "url" then
				set x to offset of "file://" in vscode_value
				if x > 0 then
					set vscode_file to text from (x + 8) to -1 of vscode_value
				else
					set vscode_file to vscode_value
				end if
			else if vscode_key = "line" then
				set vscode_line to vscode_value
			end if
		end if
	end repeat
	
	do shell script vscoode_path & vscode_opts & vscode_file & ":" & vscode_line
	
end open location