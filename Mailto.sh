#!/bin/bash
########################################################################
# Mailto - Version 1.3 - Send files/folders via email with thunderbird.#
# Found at http://www.soft.freem2.fr                                   #
########################################################################
# 1. Place this file in ~/.gnome2/nautilus-scripts                     #
# 2. Make it executable chmod u+x Mailto                               #
# 3. Do not work in command line.                                      #
########################################################################

args=$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
prefix="file://"; 
suffix="_mailto.rar";
title="Select files to send";

if [ -Z $args ]; # if no args then pop-up select window
then	
	args=$prefix`zenity --file-selection --multiple --title="$title" --separator=",$prefix"`;	
	# Send the email
	if [ $PIPESTATUS -eq 0 ]; then thunderbird -compose "attachment='$args'"; fi
else	
	IFS=$'\n' && for i in $args
	do
		if [ -d $i ]; 
		then 	
			rar a ${i##*/}$suffix `basename $i`;
			app+=$prefix/$i$suffix",";
			tmp+=$i$suffix" ";
		else	
			app+=$prefix/$i","; 
		fi
	done

	# Delete final separators
	length=${#app};	app=${app:0:$length-1};
	length=${#tmp};	tmp=${tmp:0:$length-1};

	# Send the email & remove .rar files
	thunderbird -compose "attachment='$app'";	
	IFS=$' ' && for f in $tmp 
	do rm $f; done
fi
exit(0);
