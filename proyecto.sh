#!/bin/bash


while true; do

##fin
option=$(zenity --list --height=400 --title "Proyecto Linux 2013" --text="Welcome to the Dropbox Uploader GUI please select one of the following" --column="Actions" "Upload a file or directory" "Download a file or directory" "Delete a file or directory" "Move or rename a file or directory" "Copy a file or directory" "Create a new directory" "List the contents of your Dropbox" "Get a public Share Link" "Get info about your Dropbox" "Unlink from Dropbox" )
 

if [ "$option" = "Upload a file or directory" ]; then # ya
	if var=$(zenity --file-selection  --filename=FILENAME)
	then
	xpath=${var%/*}
	xfext=${var##*/}
	xpref=${xbase##*.}
	xpref=${xbase%.*}

	pref=${xpref}
	ext=${xfext}

	echo "$pref""$ext"
	bash -e ./dropbox_uploader.sh "upload" "$pref""$ext"
	else
		zenity --info --text="There's been an error, Try again please"
	fi

elif [ "$option" = "" ]; then # ya
	exit 0

elif [ "$option" = "Download a file or directory" ]; then # ya
	a=$(bash -e ./dropbox_uploader.sh "list")
	b=$(echo $a | sed -e 's/> Listing \"\/\"... DONE//g')
	
	IFS='[]' read -a array <<< "$b"
	final=()
	for index in "${!array[@]}"
	do
		mod=$(($index%2))
		if [ $mod -eq "0" ]; then
			final+=("${array[index]}") 
		fi
			
	done
	#se muestra una lista con los elementos del dropbox
	if c=$(zenity --list --title="Dropbox Contents" --text="  	" --width=400 --column "Content"   "${final[@]:2}")  
	then bash -e ./dropbox_uploader.sh "download" $c
	zenity --info --text="Download completed!!"
	else
		zenity --info --text="There's been an error, Try again please"
	fi


## Delete a file
elif [ "$option" = "Delete a file or directory" ]; then #ya
	a=$(bash -e ./dropbox_uploader.sh "list")
	b=$(echo $a | sed -e 's/> Listing \"\/\"... DONE//g')
	
	IFS='[]' read -a array <<< "$b"
	final=()
	desc=()
	for index in "${!array[@]}"
	do
		mod=$(($index%2))
 		
		if [ $mod -eq "0" ]; then
			final+=("${array[index]}") 
		fi
			
	done
	#se muestra una lista con los elementos del dropbox
	if c=$(zenity --list --title="Dropbox Contents" --text="" --width=400 --column "Content"   "${final[@]:2}" )  
	then bash -e ./dropbox_uploader.sh "delete" $c
		zenity --info --text="Directory deleted sucessfully"
	else 
		zenity --info --text="There's been an error, Try again please"
	fi


elif [ "$option" = "Move or rename a file or directory" ]; then
	#se almacena la lista de elementos del dropbox en la variable a
	a=$(bash -e ./dropbox_uploader.sh "list")
	#se le quita la primera parte del string
	b=$(echo $a | sed -e 's/> Listing \"\/\"... DONE//g')
	
	IFS='[]' read -a array <<< "$b"
	#se corta el string y se almacena en una lista
	final=()
	for index in "${!array[@]}"
	do
		mod=$(($index%2))
		if [ $mod -eq "0" ]; then
			#se cortan los datos "basura" y se almacenan solo lo que nos sirve
			final+=("${array[index]}") 
		fi
			
	done
	#se muestra una lista con los elementos del dropbox
	if c=$(zenity --list --title="Dropbox Contents" --text="  	" --width=400 --column "Content"   "${final[@]:2}")  
	then
	if d=$(zenity --entry --title="Move to??" --text="Directory where you want to move to")
	then
	bash -e ./dropbox_uploader.sh "move" "$c" "$d"
	else
		zenity --info --text="There's been an error, Try again please"
	fi
	else
		zenity --info --text="There's been an error, Try again please"
	fi

elif [ "$option" = "Copy a file or directory" ]; then
	#se almacena la lista de elementos del dropbox en la variable a
	a=$(bash -e ./dropbox_uploader.sh "list")
	#se le quita la primera parte del string
	b=$(echo $a | sed -e 's/> Listing \"\/\"... DONE//g')
	
	IFS='[]' read -a array <<< "$b"
	#se corta el string y se almacena en una lista
	final=()
	for index in "${!array[@]}"
	do
		mod=$(($index%2))
		if [ $mod -eq "0" ]; then
			#se cortan los datos "basura" y se almacenan solo lo que nos sirve
			final+=("${array[index]}") 
		fi
			
	done
	#se muestra una lista con los elementos del dropbox
	if c=$(zenity --list --title="Dropbox Contents" --text="  	" --width=400 --column "Content"   "${final[@]:2}")  
	then
	if d=$(zenity --entry --title="Copy to??" --text="Directory where you want to copy to")
	then
	bash -e ./dropbox_uploader.sh "copy" "$c" "$d"
	else
		zenity --info --text="There's been an error, Try again please"
	fi
	else
		zenity --info --text="There's been an error, Try again please"
	fi

elif [ "$option" = "Create a new directory" ]; then # ya

	if var=$(zenity --forms --title="Create a directory"\
		--add-entry="Type name"	)
	then bash -e ./dropbox_uploader.sh "mkdir" $var
	zenity --info --text="Directory created sucessfully"
	else 
		zenity --info --text="There's been an error, Try again please"
	fi

elif [ "$option" = "List the contents of your Dropbox" ]; then

	#se almacena la lista de elementos del dropbox en la variable a
	a=$(bash -e ./dropbox_uploader.sh "list")
	#se le quita la primera parte del string
	b=$(echo $a | sed -e 's/> Listing \"\/\"... DONE//g')
	
	IFS='[]' read -a array <<< "$b"
	#se corta el string y se almacena en una lista
	final=()
	for index in "${!array[@]}"
	do
		mod=$(($index%2))
		if [ $mod -eq "0" ]; then
			#se cortan los datos "basura" y se almacenan solo lo que nos sirve
			final+=("${array[index]}") 
		fi
			
	done
	#se muestra una lista con los elementos del dropbox
	zenity --list --title="Dropbox Contents" --text="  	" --width=400 --column "Content"   "${final[@]:2}"	
	

elif [ "$option" = "Get a public Share Link" ]; then

	a=$(bash -e ./dropbox_uploader.sh "list")
	b=$(echo $a | sed -e 's/> Listing \"\/\"... DONE//g')
	
	IFS='[]' read -a array <<< "$b"
	final=()
	for index in "${!array[@]}"
	do
		mod=$(($index%2))
		if [ $mod -eq "0" ]; then
			final+=("${array[index]}") 
		fi
			
	done
	#se muestra una lista con los elementos del dropbox
	c=$(zenity --list --title="Dropbox Contents" --text="  	" --width=400 --column "Content"   "${final[@]:2}")  
	a=$(bash -e ./dropbox_uploader.sh "share" $c)
	zenity --info --title="Share Link" --text="This is your share link" --text="$a"

elif [ "$option" = "Get info about your Dropbox" ]; then # ya
	a=$(bash -e ./dropbox_uploader.sh "info") 
	zenity --info --title="Account Information" --text="$a"

elif [ "$option" = "Unlink from Dropbox" ]; then # ya
	bash -e ./dropbox_uploader.sh "unlink"
	zenity --info --title="Account Information" --text="You've been succesfully unlinked from your account"

fi 

## nuevo 
done 

