;=======================================================================================================================
;WoWLocalFilesManagement:魔兽世界本地文档管理:角色配置复制或同步;配置及插件的异地存储等
;by:nnrxin
;email:nnrxin@163.com
;=======================================================================================================================
;自动运行段 |
;===========

;运行参数
#NoEnv
#SingleInstance ignore    ;不能双开
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

;APP基本信息
global APP_NAME      := "WoWLocalFilesManagement"    ;APP名称
global APP_NAME_CN   := "魔兽世界本地文件管理工具WOW-LFM"    ;APP中文名称
global APP_VERSION   := 0.4                          ;当前版本
global APP_DATA_PATH := A_AppData "\" APP_NAME       ;在系统AppData的保存位置
FileCreateDir, % APP_DATA_PATH                       ;路径不存在时需要新建

;发现魔兽窗口时阻止启动
if WinExist("ahk_exe Wow.exe") or WinExist("ahk_exe WowClassic.exe")    ;发现魔兽窗口时退出
{
	MsgBox, 16,, 启动失败: 请关闭魔兽窗口后重试
	ExitApp
}

;安装必要的组件
#Include WoWLocalFilesManagement_InstallFile.ahk
FileInstallTo(APP_DATA_PATH)

;退出时保存设置信息
OnExit, DoBeforeExitApp 



;创建主GUI
Gui, MainGui:New,+HwndhMainGui
Gui, MainGui:Font,, 微软雅黑
Gui, MainGui:Font,, 微软雅黑 Light

Gui, MainGui:Font, c0078D7 bold, 微软雅黑
Gui, MainGui:Add, Tab3, xm ym w760 h600 AltSubmit vini_MainGui_MainTab HwndhMainTab ggMainTab,   ;主标签
Gui, MainGui:Font, cDefault norm, 微软雅黑 Light

;加载各模块及其Tab
global MODS := []
GuiAddTabMod("MainGui", "ini_MainGui_MainTab", MODS, "基本设置", "Setting")
GuiAddTabMod("MainGui", "ini_MainGui_MainTab", MODS, "WTF", "WTF")

Gui, MainGui:Font, italic    ;斜体
Gui, MainGui:Add, StatusBar, hwndhStatusBar
gui, MainGui:Font, norm    ;恢复
Gui, MainGui:Show,, % APP_NAME_CN " ver" APP_VERSION

;GUI初始化
gosub, GuiInit    


;=========================
return    ;自动运行段结束 |
;=======================================================================================================================
;=======================================================================================================================

;=======================================================================================================================
;退出前自动运行段 |
;================
DoBeforeExitApp:
	try Gui, MainGui:Submit, NoHide
	try APP_INI.SaveAll()    ;app配置保存到ini文件
	try INI.SaveAll()    ;用户配置保存到ini文件
ExitApp

;=======================================================================================================================
;MainGUI控制 |
;============
;主标签切换时
gMainTab:
	Gui MainGui:+Disabled
	Gui, MainGui:Submit, NoHide
	subName := "GuiTabIn_" MODS[ini_MainGui_MainTab].modName
	if IsLabel(subName)
		gosub, %subName%
	Gui MainGui:-Disabled
return

;Gui初始化
GuiInit:
	Gui MainGui:+Disabled
	for i, mod in MODS
	{
		subName := "GuiInit_" mod.modName
		if IsLabel(subName)
			gosub, %subName%
	}
	Gui MainGui:-Disabled
return

;Gui拖拽进来文件
MainGuiGuiDropFiles:
	Gui MainGui:+Disabled
	for i, mod in MODS
	{
		subName := "GuiDropFiles_" mod.modName
		if IsLabel(subName)
			gosub, %subName%
	}
	Gui MainGui:-Disabled
return


;Gui重设尺寸
MainGuiGuiSize:
	If (A_EventInfo = 1)
		Return
	AutoXYWH("wh", "ini_MainGui_MainTab") 
	for i, mod in MODS
	{
		subName := "GuiSize_" mod.modName
		if IsLabel(subName)
			gosub, %subName%
	}
return

;退出
MainGuiGuiEscape:
MainGuiGuiClose:
ExitApp

;=======================================================================================================================
;模块 |
;=====
;新增模块函数
GuiAddTabMod(G, tab, ByRef mods, tabName, modName)
{
	static newTabName
	GuiControl,, % tab, % newTabName .= "|" tabName
	mods.push({tabName:tabName, modName:modName})
	Gui, %G%:Tab, % mods.MaxIndex()
	gosub, AddMod_%modName%
}

;加载模块文件：
#Include WoWLocalFilesManagement_Mod_Setting.ahk
#Include WoWLocalFilesManagement_Mod_WTF.ahk