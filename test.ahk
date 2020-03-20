

#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1  
SetControlDelay, -1
SendMode Input
SetWorkingDir, % A_ScriptDir

;~ WoWLocalFilesManagement.ahk

Loop, Files, % "WoWLocalFilesManagement.ahk"  ;文件夹内循环
{
	MsgBox % A_LoopFileLongPath
}
	