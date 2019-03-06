Author: Fredrik Leemann

Links:
------
WebPage: http://www.leemann.se/fredrik
Donate: https://www.paypal.me/freddan88
YouTube: https://www.youtube.com/user/FreLee54
GitHub: https://github.com/freddan88

Steamcmd - Valve Developers Community
https://developer.valvesoftware.com/wiki/SteamCMD

Download:
http://www.leemann.se/fredrik/file_downloads/srcds_linux-css-script.zip

Description:
Script to manage/install/update SRCDS for Counter-Strike Source

Tested: Ubuntu/Debian/CentOS Linux

I take no responsibility for this script, use at your own risk
--------------------------------------------------------------

----------------------------------------------------
License MIT: https://choosealicense.com/licenses/mit
----------------------------------------------------

Actions in script:

// Force start (Shall be used when autostarting)
#srcds_css.sh force_start

// Start the server in a new Gnu-Screen
#srcds_css.sh start

// Start the server in Terminal
#srcds_css.sh debug

// Stop the server in Gnu-Screen
#srcds_css.sh stop

// Restart the server in Gnu-Screen
#srcds_css.sh restart
or:
#srcds_css.sh reload

// Backup the servers gamefolder (cstrike)
#srcds_css.sh backup

// Update the SRCDS for Counter-Strike Source
#srcds_css.sh update

// Install the SRCDS for Counter-Strike Source in the folder configured in 'folder='
#srcds_css.sh install
