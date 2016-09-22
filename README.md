#Projectname=symantec_swv_sws_tools
#Fileversion=1.0.0.826
#Filename=psexec_vir_eng.exe

It was made for use with free tools like psexec, psloggedon from sysinternals, notepad and vnc. The goal is to make administrative tasks of computers with symantec virtual programs simpler. Hope you enjoy it as much as i do!
Can be modified under GLP as long as my name is mentioned!

psexec, psloggedon must be downloaded from microsoft: https://technet.microsoft.com/en-us/sysinternals/pxexec.aspx & https://technet.microsoft.com/en-us/sysinternals/psloggedon.aspx

Vnc must be downloaded from: https://www.realvnc.com/download/vnc

Just drop the files in the same directory as the executable and play around. 
You have to start the program as an adminuser with access to the c$ on the remote computers you work with.

All outputs are shown in notepad from log files, and so they can be copyed and edited on all windows machines.

Latest features are:
- Check if the computer/ip you want to access is on, and the reply time in ms. Warn us it may not excist if it is turned of. Check if your user has the needed admin access to c$ drive and warns if you don't have

- Show reboot time on computer if streaming agent is installed.

- Start psexec shell for work on remote computer

- Start vnc (can also show if someone is loggedon remotely using psloggedon before vnc is optionally started

- Pc info: normally using info from _ac folder for streaming agent. If that is not found it uses systeminfo

- Shows all running processes on computer, arranged by alphabet a-x and using notepad as viewer for output from logfile

- Show virtual packages and using notepad as viewer for output from logfile

- Show package properties and using notepad as viewer (also supports wildcards * if you want to do operation on all layers)

- Reset virtual packages and using notepad as viewer  (also supports wildcards * if you want to do operation on all layers)

- Deactivate virtual packages and using notepad as viewer (also supports wildcards * if you want to do operation on all layers)

- Reactivate virtual packages and using notepad as viewer (also supports wildcards * if you want to do operation on all layers)

- Show streaming packages and using notepad as viewer for output from logfile

- Fix streaming packages shortcuts and using notepad as viewer for output from logfile

- Remove all streaming packages and using notepad as viewer for output from logfile

- Open c$

- Open logfiles from operations done on computers with this program (all operations on layers are logged)

I have also put a lot of error handling if req. programfiles is missing, or you don't have access to remote computer resources, if it can't be pinged etc.

The translations from Norwegian may be a little bit bad, but it should be understandable :P

* Known limitations: It's programmed in autoit, so all the functions is executed in serial, it means that if you push a button, we have to wait for the function to do it's purpose or time out and fail before the next will be exectuted.
