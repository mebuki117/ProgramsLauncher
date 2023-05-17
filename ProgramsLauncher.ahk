; Settings
; Don't Change
#NoEnv
#Persistent
#SingleInstance Force

SetWorkingDir, %A_ScriptDir%

; Settings Sync Check
global ver := "0.5.1.1" ; version
global closeoption

; Main Variable
global ProgramsList
global listb
global LaunchPIDs




; Version Check
UrlDownloadToFile, https://raw.githubusercontent.com/oyamelon/ProgramsLauncher/main/versioncheck.ini, versioncheck.ini
IniRead, vercheck, versioncheck.ini, versioncheck, version
FileDelete, versioncheck.ini
IniRead, thisver, settings.ini, versioncheck, version
If (vercheck > thisver) {
    MsgBox, 4,, found a new version. do you open the download page?
    IfMsgBox, Yes, {
        Run, https://github.com/oyamelon/ProgramsLauncher/releases
    }
    Else
        MsgBox, 4,, do you skip the new version?
        IfMsgBox, Yes, {
            IniDelete, settings.ini, versioncheck, version
            IniWrite, "%vercheck%", settings.ini, versioncheck, version
        }
}


; Utilities Load
IniRead, launchdelay, settings.ini, Utilities, launchdelay
IniRead, closeoption, settings.ini, Utilities, closeoption


; Setting SaveData
versionsettings = `n[versioncheck]`nversion="%vercheck%"
utilitiessettings = `n[Utilities]`nlaunchdelay="%launchdelay%"`ncloseoption="%closeoption%"


; Programs Load
Loop, {
    IniRead, fullpath, settings.ini, Prog, Program%A_Index%, 0
    If (!fullpath) {
        break
    }
    SplitPath, fullpath, filename, dir
    ProgramsList = %fullpath%|%ProgramsList%
}


; Gui
Gui:
    Gui, Add, ListBox, x12 y9 w520 h160 Sort vlistb, %ProgramsList%
    Gui, Add, Button, x542 y9 w60 h20 gAdd, Add
    Gui, Add, Button, x542 y29 w60 h20 gEdit, Edit
    Gui, Add, Button, x542 y49 w60 h20 gRemove, Remove
    Gui, Add, Button, x542 y69 w60 h20 gCheck, Check
    Gui, Add, Button, x612 y9 w60 h20 gCloseApp, Close
    Gui, Add, Button, x542 y139 w60 h30 gAllLaunch, All Launch
    Gui, Add, Button, x542 y109 w60 h30 gLaunch, Launch
    ;Gui, Add, Button, x612 y109 w60 h30 gClose, Close
    Gui, Add, Button, x612 y139 w60 h30 gAllClose, All Close
    ; Generated using SmartGUI Creator 4.0
    Gui, Show, x242 y297 h181 w684, Programs Launcher
Return


; Subs
Add:
    paths := []
    changesettings := ""
    dummy := false
    Gui, Submit, NoHide
    FileSelectFile, addfullpath, 32,, Add Program
    GuiControl, ChooseString, listb, %addfullpath%
    If (!ErrorLevel) {
        MsgBox, 4,, may have already been added. are you sure you want to add?
        IfMsgBox, Yes, {
            dummy := true
        }
    }
    If ((ErrorLevel or dummy) and addfullpath) {      
        Loop {
            IniRead, fullpath, settings.ini, Prog, Program%A_Index%, 0
            If (!fullpath) {
                GuiControl,, listb, |
                for dummy, path in paths {
                    GuiControl,, listb, %path%
                    changesettings = %changesettings%`nProgram%A_Index%="%path%"
                }
                GuiControl,, listb, %addfullpath%
                changesettings = [Prog]%changesettings%`nProgram%A_Index%="%addfullpath%"
                changesettings = % changesettings versionsettings utilitiessettings
                FileDelete, settings.ini
                FileAppend, %changesettings%, settings.ini
                break
            }
            Else
                paths[A_Index] := fullpath
        }
    }
Return


Edit:
    paths := []
    changesettings := ""
    Gui, Submit, NoHide
    GuiControlGet, selectpath,, listb
    If (selectpath) {
        FileSelectFile, editfullpath, 32,, Add Program
    }
    If (editfullpath != selectpath and editfullpath) {
        Loop {
            IniRead, fullpath, settings.ini, Prog, Program%A_Index%, 0
            If (!fullpath) {
                GuiControl,, listb, |
                for dummy, path in paths {
                    GuiControl,, listb, %path%
                    changesettings = %changesettings%`nProgram%A_Index%="%path%"
                }
                changesettings = [Prog]%changesettings%
                changesettings = % changesettings versionsettings utilitiessettings
                FileDelete, settings.ini
                FileAppend, %changesettings%, settings.ini
                break
            }
            If (fullpath != selectpath) {
                paths[A_Index] := fullpath
            }
            Else
                paths[A_Index] := editfullpath
                
        }
    }
Return


Remove:
    selectpath := ""
    paths := []
    changesettings := ""
    Gui, Submit, NoHide
    GuiControlGet, selectpath,, listb
    Loop {
        If (!selectpath)
            break
        IniRead, fullpath, settings.ini, Prog, Program%A_Index%, 0
        If (!fullpath) {
            Guicontrol,, listb, |
            for dummy, path in paths {
                GuiControl,, listb, %path%
                changesettings = %changesettings%`nProgram%A_Index%="%path%"
            }
            changesettings = [Prog]%changesettings%
            changesettings = % changesettings versionsettings utilitiessettings
            FileDelete, settings.ini
            FileAppend, %changesettings%, settings.ini
            break
        }               
        If (fullpath != selectpath) {
            paths[A_Index] := fullpath  
        }
    }
Return


Check:
    paths := []
    changesettings := ""
    Gui, Submit, NoHide
    GuiControlGet, fullpath,, listb
    If (fullpath) {   
        IfNotExist, %fullpath%, {
            MsgBox, 4,, this program is not exist. are you sure you want to delete?
            IfMsgBox, Yes, {
                GuiControlGet, selectpath,, listb
                Loop {
                    IniRead, fullpath, settings.ini, Prog, Program%A_Index%, 0
                    If (!fullpath) {
                        break
                    }
                    GuiControl, ChooseString, listb, %fullpath%
                    If (fullpath = selectpath) {
                        Loop {
                            IniRead, fullpath, settings.ini, Prog, Program%A_Index%, 0
                            If (!fullpath) {
                                GuiControl,, listb, |
                                for dummy, path in paths {
                                    GuiControl,, listb, %path%
                                    changesettings = %changesettings%`nProgram%A_Index%="%path%"
                                }
                                changesettings = [Prog]%changesettings%
                                changesettings = % changesettings versionsettings utilitiessettings
                                FileDelete, settings.ini
                                FileAppend, %changesettings%, settings.ini
                                break
                            }               
                            If (fullpath != selectpath) {
                                paths[A_Index] := fullpath   
                            }                                 
                        }
                    }
                }
            }
        }
    }
Return


Launch:
    GuiControlGet, fullpath,, listb
    If (fullpath) {
        IfExist, %fullpath%, {
            SplitPath, fullpath, filename, dir
            checkexist := false
            for proc in ComObjGet("winmgmts:").ExecQuery(Format("Select * from Win32_Process where CommandLine like ""%{1}%""", filename)) {
                checkexist := True
                MsgBox, this program is already launch
                break
            } 
            if (!checkexist)
                Run, %filename%, %dir%
        }
    }
Return


AllLaunch:
    LaunchPIDs := []
    Loop {
        IniRead, fullpath, settings.ini, Prog, Program%A_Index%, 0
        If (fullpath) {
            IfExist, %fullpath%, {
                SplitPath, fullpath, filename, dir
                checkexist := false
                for proc in ComObjGet("winmgmts:").ExecQuery(Format("Select * from Win32_Process where CommandLine like ""%{1}%""", filename)) {
                    checkexist := True
                    break
                } 
                if (!checkexist)
                    Run, %filename%, %dir%,, PID
                    Sleep, %launchdelay%
                    LaunchPIDs[A_Index] := PID
            }
        }
        Else
            break
    }
Return


Close:
; :(
Return


AllClose:
    MsgBox, 4,, are you sure you want to all programs close?
    IfMsgBox, Yes, {
        for dummy, P in LaunchPIDs {
            Process, Exist, %P%
            If (ErrorLevel <> False)
                Process, Close, %P%
        }
        If (closeoption = True)
            ExitApp
    }
Return


CloseApp:
    ExitApp
Return