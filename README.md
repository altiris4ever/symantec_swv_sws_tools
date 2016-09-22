# symantec_swv_sws_tools
#Fileversion=1.0.0.826
#symantec_swv_sws_tools

It was made for use with free tools like psexec, psloggedon from sysinternals and vnc. The goal is to administrate task of computers with symantec virtual programs simpler. Hope you enjoy it as much as i do!
Can be modified under GLP as long as my name is mentioned!

psexec, psloggedon must be downloaded from microsoft: https://technet.microsoft.com/en-us/sysinternals/pxexec.aspx & https://technet.microsoft.com/en-us/sysinternals/psloggedon.aspx

Vnc must be downloaded from: https://www.realvnc.com/download/vnc

Just drop the files in the same directory as the executable and play around. 
You have to start the program as an adminuser with access to the c$ on the remote computers you work with.

Latest features are:
- Check if the computer/ip you want to access is on, and the reply time in ms. Warn us it may not excist if it is turned of. Check if your user has the needed admin access to c$ drive and warns if you don't have

- Show reboot time on computer if streaming agent is installed.

- Start psexec shell for work on remote computer

- Start vnc (can also show if someone is loggedon remotely using psloggedon before vnc is optionally started

- Pc info: normally using info from _ac folder for streaming agent. If that is not found it uses systeminfo

- Shows all running processes on computer, arranged by alphabet a-x

- Show virtual packages and using notepad as viewer 

- Show package properties and using notepad as viewer (also supports wildcards * if you want to do operation on all layers)

- Reset virtual packages and using notepad as viewer  (also supports wildcards * if you want to do operation on all layers)

- Deactivate virtual packages and using notepad as viewer (also supports wildcards * if you want to do operation on all layers)

- Reactivate virtual packages and using notepad as viewer (also supports wildcards * if you want to do operation on all layers)

- Show streaming packages and using notepad as viewer 

- Fix streaming packages and using notepad as viewer 

- Remove all streaming packages and using notepad as viewer 

- Open c$

- Open logfiles from operations done on computers with this program (all operations on layers are logged)

I have also put a lot of error handling if req. programfiles is missing, or you don't have access to remote computer resources, if it can't be pinged etc.

The translations from Norwegian may be a little bit bad, but it should be understandable :P

