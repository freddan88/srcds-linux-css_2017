#!/bin/sh
# Date: 2018-06-02
# Author: Fredrik Leemann
# YouTube: https://www.youtube.com/user/FreLee54

# WebPage: http://www.leemann.se/fredrik
# Donate: https://www.paypal.me/freddan88
# GitHub: https://github.com/freddan88

# Script to manage Counter-Strike Source Dedicated Servers.
# Installation instructions can be found here:
# https://developer.valvesoftware.com/wiki/SteamCMD#Running_SteamCMD
# List of available app_id´s (Linux Dedicated Servers):
# https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
# Command Line Options and Arguments for SRCDS and more...
# https://developer.valvesoftware.com/wiki/Command_Line_Options
# Debug will start the server in terminal and log to console.log
# Debug will also default the server to lanmode. 
# Start will start the server in a new screensession with the name of the "screen-parameter".
# Use lowercase letters for foldernames and paths. Capital letters may bug the gameserver...

### Installation - configuration:
# "folder" = Installationfolder for Counter-Strike Source Dedicated Server
# "steam" = Installationfolder for SRCDS updatetool (steamcmd)
# "screen" = Screen name for gameserver
# "backup" = Filename for backups (using rsync)

backup=cstrike_backup_$(date +"%Y%m%d").tar.gz
folder=$HOME/bin/srcds/css
steam=$HOME/bin/srcds/steamcmd
screen=css

### Gameserver - configuration:
players=12
port=27015
map=de_dust2
ip=0.0.0.0

## Don´t edit below this line:
##############################
case "$1" in

force_start)
	rm $folder/lock 2> /dev/null && touch $folder/lock
	echo "Starting SRCDS for Counter-Strike Source in $folder"
	servercommands="-game cstrike +map $map +maxplayers $players +ip $ip -port $port"
	screen -A -m -d -S $screen $folder/srcds_run $servercommands
;;

start)
	if [ -f $folder/lock ] ; then
		echo "lockfile exist, is srcds runnig ?"
		echo "Please use: ($0 stop) before using this command"
	else
		touch $folder/lock
		echo "Starting SRCDS for Counter-Strike Source:"
		echo "Type screen -x $screen to view console, press CTRL+A+D togheter to detatch" && sleep 0.5
	# More command-line parameters: -insecure -nobots -nohltv -norestart -dumplongticks -timeout
		servercommands="-game cstrike +map $map +maxplayers $players +ip $ip -port $port -nohltv -norestart"
		screen -A -m -d -S $screen $folder/srcds_run $servercommands
		sleep 0.5 && screen -list
	fi
;;

debug)
	if [ -f $folder/lock ] ; then
		echo "lockfile exist, is srcds runnig ?"
		echo "Please use: ($0 stop) before using this command"
	else
		echo "Starting SRCDS for Counter-Strike Source in debugmode"
		echo "Debuging to console.log in $folder/cstrike/console.log"
		$folder/srcds_run -game cstrike +map $map +maxplayers $players +ip $ip -port $port +sv_lan 1 -debug -condebug -nohltv -norestart
	fi
;;

stop)
	rm $folder/lock 2> /dev/null
	echo "Stopping Counter-Strike Source server ($screen)" && sleep 0.5
	screen -S $screen -X quit
	sleep 0.5 && screen -list
;;

restart|reload)
	$0 stop
	$0 start
;;

backup)
	if [ -f $folder/lock ] ; then
		echo "lockfile exist, is srcds runnig ?"
		echo "Please use: ($0 stop) before using this command"
	else
		rm -rf $folder/backups && mkdir -p $folder/backups
		rsync -vr --exclude *.vpk --exclude *.cache --exclude gameinfo.txt --exclude steam.inf --exclude bin --exclude download --exclude downloadlists --exclude media --exclude resource $folder/cstrike $folder/backups/
		cd $folder/backups && tar -pczf $backup cstrike
		rm -rf cstrike
		echo ""
		echo "Backups can be found in $folder/backups"
		echo "Done creating backup. Untar this file using: tar -zxvf $backup"
	fi
;;

update)
	if [ -f $folder/lock ] ; then
		echo "lockfile exist, is srcds runnig ?"
		echo "Please use: ($0 stop) before using this command"
	else
		echo "Updating CSS Dedicated server in $folder" && sleep 1
		$steam/steamcmd.sh +login anonymous +force_install_dir $folder +app_update 232330 +quit
		echo "Update complete, you can now start the server using:"
		echo "$0 start"
	fi
	echo ""
	echo "Scripted by: www.leemann.se/fredrik"
;;

install)
	if [ -f $folder/lock ] ; then
		echo "lockfile exist, is srcds runnig ?"
		echo "Please use: ($0 stop) before using this command"
	else
		echo "Updatetool (Steamcmd) will be downloaded and installed to $steam"
		echo "Gameserver (SRCDS) will be downloaded and installed to $folder"
		sleep 2
		$0 install1
	fi
;;

install1)
		if [ ! -d $steam ] ; then 
		mkdir -p $steam
		$0 install2
		else
		$0 install2
	fi
;;

install2)
	cd $steam
	if [ ! -f steamcmd_linux.tar.gz ] ; then
		wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
		tar -xvzf steamcmd_linux.tar.gz
		./steamcmd.sh +login anonymous +force_install_dir $folder +app_update 232330 validate +quit
		echo "Installation complete, you can now start the server using:"
		echo "$0 start"
	else
		./steamcmd.sh +login anonymous +force_install_dir $folder +app_update 232330 validate +quit
		echo "Installation complete, you can now start the server using:"
		echo "$0 start"
	fi
	echo ""
	echo "Scripted by: www.leemann.se/fredrik"
;;

*)
echo "Usage: $0 {start|stop|restart/reload|debug|backup|install|update}"
;;

esac
exit 0