#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Comment=made by arne.johansen@gmail.com
#AutoIt3Wrapper_Res_Description=Tool for automating work on pc's in domain
#AutoIt3Wrapper_Res_Fileversion=1.0.0.826
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=arne.johansen@gmail.com
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <string.au3>
#include <Array.au3>
#include <file.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <StringConstants.au3>
#include <MsgBoxConstants.au3>

;This program is brought to you by arne.johansen@gmail.com
;It was made using free tools like psexec, psloggedon and vnc to administrate computers with symantec virtual programs simpler Hope you enjoy it as much as i do!
;Can be modified under GLP as long as my name is mentioned!

Global $program ;makes a global variable for use in our Function "check_if_program_exist"
Global $verify1 ;used in yes no part of in our Function "check_if_program_exist"
Global $retVal
Global $file; A global variable for use with our log files in various part of the program
Global $accessbit ;uses to check for adminaccess to folders on remote computer
Dim $stringtest1  ;showing last reboot time in main titlebar
Dim $param = @ScriptDir
Dim $pakke
Dim $enum = " enum" ;svscmd command parameter that shows layers on computer
Dim $reset = " r -f" ;reset virtual layer
Dim $deaktivate = " d -f" ;deactivate package forcefully
Dim $aktivate = " a" ;activate package
Dim $commando = " p -v" ;svscmd command parameter that shows properties of a layer on computer
Dim $commando2 = " -s -res" ;AppMgrCmd.exe command parameter that cleans up streamingshortcuts on computer
Dim $commando3 = " -s -ta -hidden" ;AppMgrCmd.exe command parameter that terminate all streaminglayers on computer
Dim $commando4 = " -s -ra -hidden" ;AppMgrCmd.exe command parameter that remove all streaminglayers on computer
Dim $commando5 = " -ll" ;AppMgrCmd.exe command parameter that shows properties of all streaminglayer on computer
Dim $path = "c:\PROGRA~1\symantec\Worksp~2\Bin\" ;shortpath to the symantec streaming directory
Dim $path1 = "c:\_AC\" ; The default streaminglayers directory
Dim $programname = "AppMgrCmd.exe" ;the filename of streaming tool
Dim $programname1 = "tasklist.exe" ;windows tasklist filename
Dim $programname2 = "notepad.exe" ;notepad exe
;check if psexec is present on system.
$program = "psexec.exe"
Global $exitbit = "1"
check_if_program_exist ()
$exitbit = Null ;reset exitbit. Only needed here
;---------------End check for psexec------------------
;Dim $pcnavn2 = "somecomputer";Hardcoded pc-name for test.
Dim $pcnavn2 = InputBox("Connect to pc", "Input pc-name:") ;inputbox for computername
;remove white spaces in fromt and behind computername
Dim $pcnavn = StringStripWS ($pcnavn2,3)
Dim $pcnavn1 = @ComputerName ;name of the computer we run this program from
Dim $hostlist
;all txt/log files the program use
Dim $file3 = @TempDir&"\Logfiles\"&$pcnavn&".Fix_Streaming_shortcuts.log"
Dim $file4 = @TempDir&"\Logfiles\"&$pcnavn&".Remove_Streaming-packages.log"
;Dim $file5 = @TempDir&"\Logfiles\"&$pcnavn&".tasklist.log"
Dim $file7 = "system_data.txt"
Dim $file8 = @TempDir&"\Logfiles\"&$pcnavn&".Streaming_packages.log"
Dim $file9 = @TempDir&"\Logfiles\"&$pcnavn&".last_reboot.log"
Dim $file10 = @TempDir&"\Logfiles\"&$pcnavn&".test_vnc.log"
Dim $file11 = @TempDir&"\Logfiles\"&$pcnavn&".reset_package.log"
Dim $file12 = @TempDir&"\Logfiles\"&$pcnavn&".deactivate_package.log"
Dim $file13 = @TempDir&"\Logfiles\"&$pcnavn&".reactivate_package.log"
_GetAPPVersion() ;display version number!
checkinput() ;calling the function for inputcheck
Check_access ()


Psexec() ; calls the psexec function

Func Psexec() ;part of the program where the gui is shown and waiting for us to press buttons

#region Main GUI
; Create a GUI with various controls.
    ;Create main GUI and title bar

		Local $hGUI = GUICreate("Administrate pc's - Last reboot time: "  & $stringtest1 , 650, 449, 192, 114)
    ; Create a button control.
	;-------------------- Row 1 of program buttons ------------------
	Local $Label1 = GUICtrlCreateLabel("Pc-name:", 24, 3, 84, 25) ;Create Computername label
	Local $pcnavn1 = GUICtrlCreateInput($pcnavn, 80, 3, 90, 25) ;Create Computername Textbox
	Local $idPsexec = GUICtrlCreateButton("Start Psexec", 200, 3, 90, 25) ;Create show virtual layers button
	Local $vnc_program = GUICtrlCreateButton("Start VNC", 295, 3, 85, 25) ;Check if any1 is logged on to pc before starting vnc.
	Local $pcinfo = GUICtrlCreateButton("Pc-Info ", 385, 3, 75, 25) ;Create lastrestart date Textbox
	Local $tasklist = GUICtrlCreateButton("Show processes on pc", 465, 3, 120, 25) ;Shows all running prosesses on pc, arranged by alphabet a-x
	Local $grpTest = GUICtrlCreateGroup("Tools for Virtual-packages", 4, 30, 645, 55)
	;Local $Label2 = GUICtrlCreateLabel("--------------------------------------------------------------------* Tools for Virtual-packages *-----------------------------------------------------------------------", 8, 30, 630, 15) ;Create Computername label
	;------------ Row 2 of program buttons -----------------
	Local $vis_vir = GUICtrlCreateButton("Show virtual packages", 7, 48, 115, 25) ;Create show virtual layers button
    Local $idshowProp = GUICtrlCreateButton("Show package properties", 123, 48, 135, 25) ;Create virtual layer properties button
	Local $reset_package = GUICtrlCreateButton("Reset virtual package", 258, 48, 120, 25) ;Reset virtual layer button
	Local $deaktivate = GUICtrlCreateButton("Deactivate virtual package", 378, 48, 132, 25) ;Deactivate virtual package button
	Local $aktivate = GUICtrlCreateButton("Reactivate virtual package", 510, 48, 133, 25) ;Create lastrestart date Textbox

	;Local $Label2 = GUICtrlCreateLabel("--------------------------------------------------------------------* Tools for Virtual streaming packages *-----------------------------------------------------------------------", 8, 75, 630, 15) ;Create Computername label
	Local $grpTest1 = GUICtrlCreateGroup("Tools for Virtual streaming packages", 4, 77, 425, 55);   left, top [, width [, height
	;------------ Row 3 part 1 of program buttons -----------------
	Local $visestreamingpakker = GUICtrlCreateButton("Show streaming packages", 8, 95, 131, 25) ;show all Streaming packages on remote computer
	Local $FixStreaming = GUICtrlCreateButton("Fix Streaming shortcuts", 139, 95, 126, 25) ;Fix Streaming shortcuts on remote computer if possible.
	Local $RemoveStreaming = GUICtrlCreateButton("Remove all streaming packages", 265, 95, 155, 25) ;Removes all Streaming packages on remote computer
    Local $grpTest2 = GUICtrlCreateGroup("Open folders", 426, 77, 225, 55)
;------------ Row 3 part 2 of program buttons -----------------
	Local $cshare = GUICtrlCreateButton("Open c$", 429, 95, 80, 25) ;Open up c$ if running with adminuser on remote computer
	Local $tempfolder = GUICtrlCreateButton("Open logfiles", 508, 95, 90, 25) ;Open up @TempDir&"\Logfiles

;------------ Row 5 of program buttons -----------------
	Local $idClose = GUICtrlCreateButton("Exit!", 200, 170, 90, 25) ;exit this program
;------------ Row 6 Stamped -----------------
	Local $author = GUICtrlCreateLabel("Developed by Arne.Johansen@gmail.com,2016! "&" Version: "&$retVal,4, 400, 320, 25) ;show who made this program and version and subversion string

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)
#EndRegion


    Local $iPID = 0 ;psexec
	Local $iPID1 = 0 ;show_enum
	Local $iPID2 = 0 ;aktivate package notepad
	Local $iPID3 = 0 ;psloggedon
	;Local $iPID4 = 0
	Local $iPID5 = 0 ;fix streaming notepad
	Local $iPID6 = 0 ;RemoveStreaming notepad
	Local $iPID7 = 0 ;pcinfo notepad
	Local $iPID8 = 0
	Local $iPID9 = 0
	Local $iPID10 = 0 ;vnc.exe
	Local $iPID11 = 0 ;tasklist notepad
	Local $iPID12 = 0
	Global $iPID13 = 0 ;notepad.exe
	Local $iPID14 = 0 ;notepad.exe from deactivate package
	Local $iPID15 = 0 ;notepad.exe from reset case

	; Loop until the user exits.
#region switch case loop ps_exec
	While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $idClose
                ExitLoop

#region idPsexec
			Case $idPsexec ; Open up a terminalwindow to remote computer with psexecute
				;check if psexec is present on system.
				$program = "psexec.exe"
				check_if_program_exist ()
				If $exitbit = 0 Then
					$exitbit = Null

				Else
					; Run Psexec
					$iPID = Run(@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /K",@ScriptDir,@SW_SHOWDEFAULT)
				EndIf
				$verify1 = Null
				$program = Null
#EndRegion
#region $vis_vir
			Case $vis_vir ; Show all virtual symantec layers on choosed computer with notepad
			;check if psexec is present on system.
				$program = "psexec.exe"
				$file = @TempDir&"\Logfiles\"&$pcnavn&".virtuelleapps.log"
				;-------------------------- Vis virtuelle programmer ---------------------------
				;Kills the notepad.exe layers if exist
				kill_enum ()
				;Run Psexec from function
                $iPID1 = show_enum ()
				If $exitbit = 0 Then
					$exitbit = Null
				Else
					Local $aArray3 = 0
					; Read the current script file into an array using the variable defined previously.
					If Not _FileReadToArray($file, $aArray3, 0) Then
						fileread_error ()
					Else
						;sorting the textfile alfabetical
						_ArraySort($aArray3)
						_FileWriteFromArray($file,$aArray3,0)
						$iPID13 = ShellExecute($programname2," "&$file,@WindowsDir) ;show imported layers on computer
					EndIf
					;---------------------------------------------------------------------------
				EndIf
				$verify1 = Null
				$program = Null
				$file = Null
#EndRegion
#region idshowProp
			Case $idshowProp
				;check if psexec is present on system.
				$program = "psexec.exe"
				$file = @TempDir&"\Logfiles\"&$pcnavn&".virtuelleapps.log"
				;Kills the notepad.exe layers if exist
				kill_enum ()
				if ProcessExists($iPID14) Then
					ProcessClose($iPID14)
				EndIf

				show_enum ()
				If $exitbit = 0 Then
					$exitbit = Null
				Else
					Local $aArray4 = 0
					; Read the current script file into an array using the variable defined previously.
					If Not _FileReadToArray($file, $aArray4, 0) Then
						fileread_error ()
						$file = Null
					Else
						;sorting the textfile alfabetical
						_ArraySort($aArray4)
						_FileWriteFromArray($file,$aArray4,0)
						$iPID13 = ShellExecute($programname2," "&$file,@WindowsDir) ;show imported layers on computer
						; This syntax on the inputbox makes go in front of the notepad, so you don't loose focus :)
						$pakke = InputBox("Package-name", "Copy/Write the package-name you want to show properties for:", '', '', '', '', Default, Default, 0, WinGetHandle(AutoItWinGetTitle()) * WinSetOnTop(AutoItWinGetTitle(), '', 1))
						If $pakke =="" Then
							MsgBox(16+262144, "ERROR!", "Package-name field can't be empty!" &@CRLF& "Exiting",5)
							kill_enum ()
						Else
							package_properties ()
							$file =  @TempDir&"\Logfiles\"&$pcnavn&".prop"&$pakke&".log"
							$iPID14 = ShellExecute($programname2," "&$file,@WindowsDir) ;show imported layers on computer
							kill_enum ()
							$file = Null
						EndIf
					EndIf
				EndIf
				$verify1 = Null
				$program = Null
				$file = Null
#EndRegion

#region FixStreaming
			Case $FixStreaming ; Runs commands for fixing streamed shortcuts
				;check if psexec is present on system.
				$program = "psexec.exe"
				if ProcessExists($iPID5) Then
					ProcessClose($iPID5)
				EndIf
				check_if_program_exist ()
				If $exitbit = 0 Then
					$exitbit = Null
				Else
					Local $verify = MsgBox(48+4+262144, "INFO!", "Would you realy like to cleanup streamingshortcuts?" &@CRLF& "All steamingshortcuts will be removed until you log off and on again on this computer!")
					If $verify = 6 Then
						Local $aArray12 = 0
						RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & $path & $programname & $commando2 & " >"&$file3,@ScriptDir,@SW_HIDE)
						; Read the current script file into an array using the variable defined previously.
						If Not _FileReadToArray($file3, $aArray12, 0) Then
							MsgBox(16+262144, "ERROR!", "Could not read from file:  "& $file3 & " ." &@CRLF& "" & @error,5) ; An error occurred reading the current script file.
						Else
							$iPID5 = ShellExecute($programname2," "&$file3,@WindowsDir) ;show imported layers on computer
						EndIf
					ElseIf $verify = 7 Then
						MsgBox(48+262144, "Canceling!", "You choosed No, canceling!",10)
					EndIf
				EndIf
				$verify1 = Null
				$program = Null
#EndRegion
#region RemoveStreaming
			Case $RemoveStreaming ; Runs commands for terminating and removing streamed virtual packages
				;check if psexec is present on system.
				$program = "psexec.exe"
				if ProcessExists($iPID6) Then
						ProcessClose($iPID6)
				EndIf
				check_if_program_exist ()
				If $exitbit = 0 Then
					$exitbit = Null
				Else
					Local $verify = MsgBox(48+4+262144, "INFO!", "Would you realy like to remove all streamingpackages from this computer?" &@CRLF& "All streamingpackages will be removed until they are reinstalled again!")
					If $verify = 6 Then
						Local $aArray11 = 0
						RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & $path & $programname & $commando3 & " >"&$file4,@ScriptDir,@SW_HIDE)
						RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & $path & $programname & $commando4 & " >>"&$file4,@ScriptDir,@SW_HIDE)
						If Not _FileReadToArray($file4, $aArray11, 0) Then
							MsgBox(16+262144, "ERROR!", "Could not read from file: "& $file4 & " ." &@CRLF& "" & @error,5) ; An error occurred reading the current script file.
						Else
							$iPID6 = ShellExecute($programname2," "&$file4,@WindowsDir)
						EndIf
					ElseIf $verify = 7 Then
						MsgBox(48+262144, "Canceling!", "You choosed No, canceling!",10)
					EndIf
				EndIf
				$verify1 = Null
				$program = Null
#EndRegion
#region tasklist
		Case $tasklist ;Shows running prosesses on remote computer
			if ProcessExists($iPID11) Then
					ProcessClose($iPID11)
			EndIf
			;check if psexec is present on system.
			$program = "psexec.exe"
			$file = @TempDir&"\Logfiles\"&$pcnavn&".tasklist.log"
			check_if_program_exist ()
			RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & $programname1 & " >"&$file,@ScriptDir,@SW_HIDE)
			Local $aArray = 0
			; Read the current script file into an array using the variable defined previously.
			If Not _FileReadToArray($file, $aArray, 0) Then
				fileread_error ()
			Else
				_ArraySort($aArray,0,3)
				_FileWriteFromArray($file,$aArray,0)
				$iPID11 = ShellExecute($programname2," "&$file,@WindowsDir)
			EndIf
			$file = Null
#EndRegion
#region PC-Info
			Case $pcinfo ;Shows systeminfo
				if ProcessExists($iPID7) Then
					ProcessClose($iPID7)
				EndIf
				Local $aArray1 = 0
				$file = @TempDir&"\Logfiles\"&$pcnavn&".pc_info.log"
				If FileExists("\\"&$pcnavn&"\c$\_AC\"&$file7) Then ;Check if the file directory exist.
					FileCopy("\\"&$pcnavn&"\c$\_AC\"&$file7,$file,1)
						If Not FileExists($file) Then
							systeminfo_error ()
							RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & 'systeminfo'  & " >"&$file,@ScriptDir,@SW_HIDE)
							If Not _FileReadToArray($file, $aArray1, 0) Then
								fileread_error ()
							EndIf
							$stringtest3 = _ArrayToString($aArray1,"")
							_FileWriteFromArray($file,$aArray1,0)
						ElseIf FileExists($file) Then ;Check if the file directory exist.
							If Not _FileReadToArray($file, $aArray1, 0) Then
								systeminfo_error ()
								RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & 'systeminfo'  & " >"&$file,@ScriptDir,@SW_HIDE)
								If Not _FileReadToArray($file, $aArray1, 0) Then
									fileread_error ()
								Else
									$stringtest3 = _ArrayToString($aArray1,"")
									_FileWriteFromArray($file,$aArray1,0)
									$iPID7 = ShellExecute($programname2," "&$file,@WindowsDir)
								EndIf
							EndIf
						EndIf

				_FileWriteFromArray($file,$aArray1,0)
				$iPID7 = ShellExecute($programname2," "&$file,@WindowsDir)

				Else
					systeminfo_error ()
					RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & 'systeminfo'  & " >"&$file,@ScriptDir,@SW_HIDE)
					If Not _FileReadToArray($file, $aArray1, 0) Then
						fileread_error ()
					Else
						$stringtest3 = _ArrayToString($aArray1,"")
						_FileWriteFromArray($file,$aArray1,0)
						$iPID7 = ShellExecute($programname2," "&$file,@WindowsDir)
					EndIf
				EndIf
				$file = Null
#EndRegion
#region visestreamingpakker
			Case $visestreamingpakker ; Runs commands for showing streamed packages on computer
				;check if psexec is present on system.
				$program = "psexec.exe"
				if ProcessExists($iPID9) Then
					ProcessClose($iPID9)
				EndIf
				check_if_program_exist ()
				If $exitbit = 0 Then
					$exitbit = Null
				Else
					RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & $path & $programname & $commando5 & " >"&$file8,@ScriptDir,@SW_HIDE)
					Local $aArray10 = 0
					; Read the current script file into an array using the variable defined previously.
					if Not _FileReadToArray($file8,$aArray10,0) Then
						MsgBox(16+262144, "ERROR!", "Could not read from file: "& $file8 & " ." &@CRLF& "" & @error,5) ; An error occurred reading the current script file.
					Else
						$iPID9 = ShellExecute($programname2," "&$file8,@WindowsDir)
					EndIf
				EndIf
				$program = Null
#EndRegion
#region VNC
			Case $vnc_program
				if ProcessExists($iPID8) Then
					ProcessClose($iPID8)
				EndIf
				;check if psloggedon exist on system
				$program = "psloggedon.exe"
				check_if_program_exist ()
				If $exitbit = 0 Then
					$exitbit = Null
				Else
					;check if there is anyone logged on remote computer via psloggedon
					$iPID3 = RunWait(@ComSpec & " /c "& $program &" "&"\\"&$pcnavn & " "& ">"&$file10,@ScriptDir,@SW_HIDE)
					Local $aArray9 = 0
					; Read the current script file into an array using the variable defined previously.
					if Not _FileReadToArray($file10,$aArray9,0) Then
						MsgBox(16+262144, "ERROR!", "Could not read from file: "& $file10 & " ." &@CRLF& "" & @error,5) ; An error occurred reading the current script file.
					Else
					;Shows us who's logged on remote computer in notepad
					$iPID8 = ShellExecute($programname2," "&$file10,@WindowsDir)
					EndIf
				EndIf
					;check if vnc.exe exist
				$program = "vnc.exe"
				check_if_program_exist ()
				If $exitbit = 0 Then
					$exitbit = Null
				Else
					$verify1 = MsgBox(4+262144, "Starting VNC?", "Yes or No?")
					If $verify1 = 6 Then
						$iPID10 = ShellExecute($program,$pcnavn,@SW_HIDE)
					ElseIf $verify1 = 7 Then
						MsgBox(48+262144, "Exiting vnc", "You choosed No, canceling!",5)
					EndIf
				EndIf
				$program = Null
				$verify1 = Null
#EndRegion
#region reset_package
			Case $reset_package
				;check if psexec is present on system.
				$program = "psexec.exe"
				$file = @TempDir&"\Logfiles\"&$pcnavn&".virtuelleapps.log"
				;Kills the notepad.exe layers if exist
				kill_enum ()
				if ProcessExists($iPID14) Then
					ProcessClose($iPID14)
				EndIf
				show_enum ()
				If $exitbit = 0 Then
					$exitbit = Null
				Else
					Local $aArray5 = 0
					; Read the current script file into an array using the variable defined previously.
					If Not _FileReadToArray($file, $aArray5, 0) Then
						fileread_error ()
					Else
						;sorting the textfile alfabetical
						_ArraySort($aArray5)
						_FileWriteFromArray($file,$aArray5,0)
						kill_enum ()
						$iPID13 = ShellExecute($programname2," "&$file,@WindowsDir) ;show imported layers on computer
						; This syntax on the inputbox makes go in front of the notepad, so you don't loose focus :)
						$pakke  = InputBox("Package-name", "Copy/Write the package-name you want to reset:", '', '', '', '', Default, Default, 0, WinGetHandle(AutoItWinGetTitle()) * WinSetOnTop(AutoItWinGetTitle(), '', 1))

						If $pakke =="" Then
							MsgBox(16+262144, "ERROR!", "Package-name field can't be empty!" &@CRLF& "Exiting",5)
							kill_enum ()
						Else
							Local $verify = MsgBox(48+4+262144, "INFO!", "Woud you realy like to reset "& $pakke & "?" &@CRLF& "All userdata in the application will be removed!")
							If $verify = 6 Then
								package_reset ()
								RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & "svscmd "& '"'& $pakke & '"' &$commando & " >>"&$file11,@ScriptDir,@SW_HIDE)
								$iPID14 = ShellExecute($programname2," "&$file11,@WindowsDir)
								kill_enum ()
							ElseIf $verify = 7 Then
								MsgBox(48+262144, "Canceling!", "You choosed No, canceling!",10)
								kill_enum ()
							EndIf
						EndIf
					EndIf
				EndIf
				$verify1 = Null
				$program = Null
				$file = Null
#EndRegion
#region deaktivate
			Case $deaktivate
			;check if psexec is present on system.
			$program = "psexec.exe"
			$file = @TempDir&"\Logfiles\"&$pcnavn&".virtuelleapps.log"
			;Kills the notepad.exe layers if exist
			kill_enum ()
			if ProcessExists($iPID15) Then
				ProcessClose($iPID15)
			EndIf
			show_enum ()
			If $exitbit = 0 Then
				$exitbit = Null
			Else
				Local $aArray7 = 0
				; Read the current script file into an array using the variable defined previously.
				If Not _FileReadToArray($file, $aArray7, 0) Then
					fileread_error ()
				Else
					;sorting the textfile alfabetical
					_ArraySort($aArray7)
					_FileWriteFromArray($file,$aArray7,0)
					$iPID13 = ShellExecute($programname2," "&$file,@WindowsDir) ;show imported layers on computer
					; This syntax on the inputbox makes go in front of the notepad, so you don't loose focus :)
					$pakke  = InputBox("Package-name", "Copy/Write the package-name you want to deactivate:", '', '', '', '', Default, Default, 0, WinGetHandle(AutoItWinGetTitle()) * WinSetOnTop(AutoItWinGetTitle(), '', 1))
					If $pakke =="" Then
					MsgBox(16+262144, "ERROR!", "Package-name field can't be empty!" &@CRLF& "Exiting",5)
					kill_enum ()
					Else
						Local $verify = MsgBox(48+4+262144, "INFO!", "Would you like to deactivate the "& $pakke & " package?" &@CRLF& "The application will now be deactivated until you reactivate it, or until the computer is restarted!")
						If $verify = 6 Then
							package_deactivate ()
							RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & "svscmd "& '"'& $pakke & '"' &$commando & " >>"&$file12,@ScriptDir,@SW_HIDE)
							$iPID15 = ShellExecute($programname2," "&$file12,@WindowsDir)
							kill_enum ()
						ElseIf $verify = 7 Then
							MsgBox(48+262144, "Canceling!", "You choosed No, canceling!",10)
							kill_enum ()
						EndIf
					EndIf
				EndIf
			EndIf
			$verify1 = Null
			$program = Null
			$file = Null
#EndRegion
#region cshare
	Case $cshare ;Opens up c$ folder
				Check_access ()
				$path3 = "\\" & $pcnavn & "\C$"
				If $accessbit = 0 then
					MsgBox(48,"INFO","Opening C"&'$ ' &"on " & $pcnavn,3)
					RunWait('explorer.exe' & " " & $path3)
				EndIf
				$accessbit = Null
#EndRegion
#region tempfolder
	Case $tempfolder ;Opens up temp folder
				;
				$path4 = @TempDir&"\Logfiles"
				;If $accessbit = 0 then
					MsgBox(48,"INFO","Opening the logfile folder",3)
					RunWait('explorer.exe' & " " & $path4)
				;EndIf
				;$accessbit = Null
#EndRegion
#region $aktivate
			Case $aktivate
			;check if psexec is present on system.
			$program = "psexec.exe"
			$file = @TempDir&"\Logfiles\"&$pcnavn&".virtuelleapps.log"
			;Kills the notepad.exe layers if exist
			kill_enum ()
			if ProcessExists($iPID2) Then
				ProcessClose($iPID2)
			EndIf
			show_enum ()
			If $exitbit = 0 Then
				$exitbit = Null
			Else
				Local $aArray8 = 0
				; Read the current script file into an array using the variable defined previously.
				If Not _FileReadToArray($file, $aArray8, 0) Then
					fileread_error ()
				Else
					;sorting the textfile alfabetical
					_ArraySort($aArray8)
					_FileWriteFromArray($file,$aArray8,0)
					$iPID13 = ShellExecute($programname2," "&$file,@WindowsDir) ;show imported layers on computer
					; This syntax on the inputbox makes go in front of the notepad, so you don't loose focus :)
					$pakke  = InputBox("Package-name", "Copy/Write the package-name you want to activate:", '', '', '', '', Default, Default, 0, WinGetHandle(AutoItWinGetTitle()) * WinSetOnTop(AutoItWinGetTitle(), '', 1))

					If $pakke =="" Then
						MsgBox(16+262144, "ERROR!", "Package-name can't be empty" &@CRLF& "Exiting",5)
							kill_enum ()
					Else
						Local $verify = MsgBox(48+4+262144, "INFO!", "Would you like to activate "& $pakke & "?" &@CRLF& "The virtual application will be activated on the remote computer again!")
						If $verify = 6 Then
							package_activate ()
						RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & "svscmd "& '"'& $pakke & '"' &$commando & " >>"&$file13,@ScriptDir,@SW_HIDE)
							$iPID2 = ShellExecute($programname2," "&$file13,@WindowsDir)
							kill_enum ()
						ElseIf $verify = 7 Then
							MsgBox(48+262144, "Canceling!", "You choosed No, canceling!",10)
							kill_enum ()
						EndIf
					EndIf
				EndIf
			EndIf
			$verify1 = Null
			$program = Null
			$file = Null
#EndRegion
		EndSwitch
    WEnd

    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)


EndFunc   ;==>Example
#EndRegion

Func checkinput()
		;checks if computername field is empty and exits if it is.
	If $pcnavn =="" Then
		MsgBox(16+262144, "ERROR", "Pc-name can't be empty" &@CRLF& "Canceling",5)
		Exit
	ElseIf  $pcnavn = $pcnavn1 or $pcnavn="localhost" Then ;Check if the computer you try to remote is the same as your own. Gives you the verbal finger and exit
		MsgBox(48+262144, "USER ERROR!!", "Dummy, you can't connect to your own pc from your own pc... :P" &@CRLF& "Canceling",5)
		Exit
	EndIf

;Check if pc-exist and is connected with Ping to hostname, timeout of 4000ms.
Local $iPing = Ping($pcnavn, 4000)
	If $iPing Then ; If a value greater than 0 was returned then display the following message.
        MsgBox(48+262144, "Connecting", "We made contact with this pc." & @CRLF&"Replytime: " & $iPing& " ms.",3)
    Else
		Local $verify = MsgBox(48+4+262144,"Ping failed with errorcode: "&@error,"Can't find pc "&$pcnavn&"."& @CRLF& "Try anyway?")
			If $verify = 6 Then
				MsgBox(48+262144, "Continuing!", "Can not guarantee that it will work, but trying anyway!",5)
			ElseIf $verify = 7 Then
				MsgBox(48+262144, "CANCELING!", "You choosed No, exiting!",5)
				Exit
			EndIf
    EndIf
EndFunc

Func streaming_error_msg ()
	MsgBox(16+262144,"WARNING!","Streamingagent may be misconfigured, or the remote computer could be turned off. Because of this we can't get the reboot time."&@CRLF& "Try using the button Pc-info in the program to get it.",7)
				$stringtest1 = "Unknown"
EndFunc

Func systeminfo_error ()
	MsgBox(64+262144,"WARNING!","Using Windows systeminfo to get the reboot time"&@CRLF& " This may take some time...please wait!",3)
EndFunc

#region Func checkboot_time
Func checkboot_time ()
;check reboot_time on remote computer


	If FileExists(@TempDir&"\logfiles\") Then

	Else
		DirCreate (@TempDir&"\logfiles\")
		If FileExists(@TempDir&"\logfiles\") Then

		Else
			MsgBox (16+262144,"WARNING!","Can't create tempfiles on this computer!" &@CRLF& "Check that your running user "&@UserName&" has enough access rights to the %temp% folder!" )
		EndIf
	EndIf

	Local $stringtest[3] = ["day,month,daynr,clock", "min","sek, yr"] ;reboot time array
	Local $aArray2 = 0

	If FileExists("\\"&$pcnavn&"\c$\_AC\"&$file7) Then ;Check if the file directory exist.
		FileCopy("\\"&$pcnavn&"\c$\_AC\"&$file7,$file9,1)
			If Not FileExists($file9) Then
				$stringtest1 = "Unknown"
			ElseIf FileExists($file9) Then ;Check if the file directory exist.
				If Not _FileReadToArray($file9, $aArray2, 0) Then
					$stringtest1 = "Unknown"
				EndIf

			EndIf

		$test = _ArrayToString($aArray2,"",5,5) ;searching for the posision in the log file where the reboot time is supposed to be
		;_ArrayDisplay($test,"",5,5)

		if StringInStr($test,"System started at",0) Then ;check for System started text in the expected posistion
		$stringtest = StringSplit($test,":") ; Split the string of days using the delimiter "," and the default flag value.
		$stringtest1 = $stringtest[2]&":"&$stringtest[3]&":"&$stringtest[4]

		Else
			streaming_error_msg ()
		EndIf
	Else
		streaming_error_msg ()
	EndIf

EndFunc

#EndRegion

#Region Funck Check_access
Func Check_access ()
If FileExists("\\"&$pcnavn&"\c$\windows\") Then ;Check if the file directory exist.
			;MsgBox (0,"Ok!","Ser ut til at du har admintilgang til pc "&$pcnavn&"!",3)
			checkboot_time ()
			$accessbit = 0
		Else
			MsgBox (16+262144,"WARNING!","Can't access the harddrive on the remote computer!" &@CRLF& "Check if your running user has admin access to the remote computer "& $pcnavn &"!" &@CRLF& "Can not get reboot time!" )
			$stringtest1 = "Unknown"
			$accessbit = 1
		EndIf
EndFunc

#EndRegion

Func show_enum ()
	;check if psexec is present on system.
	$program = "psexec.exe"
	$file = @TempDir&"\Logfiles\"&$pcnavn&".virtuelleapps.log"
	check_if_program_exist ()
	Runwait(@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & "svscmd"&$enum & " >"&$file,@ScriptDir,@SW_HIDE)
EndFunc

Func package_reset ()
	;check if psexec is present on system.
	$program = "psexec.exe"
	check_if_program_exist ()
	Runwait(@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & "svscmd "& '"'& $pakke & '"' & $reset & " >>"&$file11,@ScriptDir,@SW_HIDE)
EndFunc

Func package_properties ()
	;check if psexec is present on system.
	$program = "psexec.exe"
	$file = @TempDir&"\Logfiles\"&$pcnavn&".prop"&$pakke&".log"
	check_if_program_exist ()
	RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & "svscmd "& '"'& $pakke & '"' & $commando & " >"&$file,@ScriptDir,@SW_HIDE)
	$file = Null
EndFunc

Func package_deactivate ()
	;check if psexec is present on system.
	$program = "psexec.exe"
	check_if_program_exist ()
	RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & "svscmd "& '"'& $pakke & '"' & $deaktivate & " >"&$file12,@ScriptDir,@SW_HIDE)
EndFunc


Func package_activate ()
	;check if psexec is present on system.
	$program = "psexec.exe"
	check_if_program_exist ()
	RunWait (@ComSpec & " /c "& "psexec.exe" & " \\"&$pcnavn & " " & @ComSpec & " /c " & "svscmd "& '"'& $pakke & '"' & $aktivate & " >"&$file13,@ScriptDir,@SW_HIDE)
EndFunc

Func kill_enum ()
;Kills the notepad.exe layers if exist
	if ProcessExists($iPID13) Then
		ProcessClose($iPID13)
	EndIf
EndFunc

Func check_if_program_exist ()
;show error message if needed program is not present on system
	if Not FileExists($param&"\"&$program) Then
		MsgBox(16+262144, "CRITICAL ERROR!","ERROR MESSAGE:"&@CRLF&"The programfile "&"'"& $program & "'" & " is missing. This file must reside in the same folder as this program was started from."&@CRLF& "As of this, many of the functions in this program will normaly not work as it's supposed too!"&@CRLF&"Be kind to copy " &"'"& $program & "'"&" into the same folder as this program is running from and restart this program!'" ,0) ; An error occurred reading the current script file.
		$verify1 = MsgBox(4+262144, "Try to start " & "'"&$program& "'"&" ?", "Yes or No?")
			If $verify1 = 6 Then
			;MsgBox(0,"testing","yes " & $verify1)
			ElseIf $verify1 = 7 Then
				MsgBox(48+262144, "Exiting " &"'"& $program & "'" , "You choosed No, exiting!",5)
			if $exitbit = 1 Then
				Exit
			Else
				;MsgBox(0,"testing","no " & $verify1)
				$exitbit = 0
			EndIf

		EndIf
	EndIf
	$verify1 = Null
	;$program = Null
EndFunc

Func fileread_error ()
	MsgBox(16+262144, "ERROR!", "Could not read from the file: "& $file & "." &@CRLF& "" & @error,5) ; An error occurred reading the current script file.
EndFunc

Func _GetAPPVersion()
	;Gets the current version number from the AutoIt3Wrapper section in the start of the script
    ; author rajesh v r
    ; http://www.autoitscript.com/forum/index.php?showtopic=96654
    $retVal = Null
    If @Compiled Then
        $retVal = FileGetVersion(@ScriptFullPath, "FileVersion")
    Else
        Local $ScriptFileHandle, $Line, $DirectivesNotFound
        $ScriptFileHandle = FileOpen(@ScriptFullPath, 0)
        If $ScriptFileHandle = -1 Then
            SetError(@error, "File Could not be opened for reading")
            $retVal = ""
        Else
            $DirectivesNotFound = True
            While 1
                $Line = FileReadLine($ScriptFileHandle)
                If @error Then ExitLoop ; may never be used, coz we dont loop till end of script!!!

                If $DirectivesNotFound Then
                    If StringInStr(StringStripWS($Line, 3), "#Region ;**** Directives created by AutoIt3Wrapper_GUI ****") Then
                        $DirectivesNotFound = False
                    EndIf
                Else
                    If StringInStr($Line, "#EndRegion") Then ExitLoop
                EndIf
                If StringLeft(StringStripWS($Line, 8), 32) = "#AutoIt3Wrapper_Res_Fileversion=" Then
                    $retVal = StringTrimLeft($Line, 32)
                    ExitLoop
                EndIf
            WEnd
        EndIf
    EndIf
    Return $retVal
	FileClose($ScriptFileHandle)
EndFunc   ;==>_GetAPPVersion