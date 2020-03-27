ExitApp
;=======================================================================================================================
;WoWLocalFilesManagement模块:
;Mod = Setting
;控件前缀: SET_
;需修改下面三个线程名称,替换Setting: AddMod_Setting, GuiSize_Setting, GuiInit_Setting
;=======================================================================================================================
;新增模块所需函数库 |
;==================
#Include <Class_IniSaved>    ;加载类(ini自动保存)
#Include <Class_WowConfigWtf>    ;加载类(魔兽世界Config.wtf文件控制)
#Include <Class_WowAddOnsToc>    ;加载类(魔兽世界插件.toc文件控制)
;=======================================================================================================================
;新增模块线程 |
;=============
AddMod_Setting:
	;模块部署
	;配置保存位置
	global APP_INI := new IniSaved(APP_DATA_PATH "\" APP_NAME "_baseConfig.ini")    ;app配置ini
	APP_INI.Init("AppGeneral", "UserDataPos", 1)    ;玩家信息保存位置(1:Local, 2:AppData)
	global USER_DATA_PATH := (ini_AppGeneral_UserDataPos == 2) ? APP_DATA_PATH : A_ScriptDir
	global USER_CONFIG_INI_NAME := APP_NAME "_config.ini"  ;用户配置文件文件名
	global INI := new IniSaved(USER_DATA_PATH "\" USER_CONFIG_INI_NAME)    ;用户配置
	
	;魔兽世界相关
	global WOW_PATH    ;魔兽路径
	global WOW_EDITION    ;魔兽版本
	global WOW_EDITION_CN := {"_classic_":"怀旧服","_retail_":"正式服","_ptr_":"PTR","_beta_":"BETA"}
	global WOW_EDITION_VERSION    ;魔兽版本号
	global WOW_ADDONS_PATH    ;插件目录路径
	global WOW_WTF_PATH    ;WTF路径
	;魔兽相关文件缓存类
	global WOW_WTF_CONFIG    ;WTF/Config.wtf
	
	;插件相关
	global NECESSARY_ADDONS := ["PlayerInfo"]    ;必要的自制插件
	
	;自定义存储/备份路径相关
	global SAVED_PATH    ;真实存储路径
	global BACKUP_PATH    ;WTF备份文件保存路径
	
	;为主TAB增加记忆功能
	INI.Init("MainGui", "MainTab", 1)    ;Tab所选标签(默认选Tab1)
	
	;在MainGui的TAB上:
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 ym+25 w270 h77, % "本程序的配置数据文件"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Radio, xp+13 yp+22 h22 vini_AppGeneral_UserDataPos ggSET_RDDatePos, 保存到程序所在目录
	Gui, MainGui:Add, Radio, xp y+1 hp ggSET_RDDatePos Checked, 保存到AppData目录
	Gui, MainGui:Add, Button, x+2 yp-23 Center w110 h22 vvSET_BTopenPath1 ggSET_BTopenPath, 打开程序所在目录
	Gui, MainGui:Add, Button, xp y+1 Center wp hp vvSET_BTopenPath2 ggSET_BTopenPath, 打开AppData目录
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 y+13 w270 h113, % "WoW游戏路径/版本选择(可拖拽)"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, xp+13 yp+25 w223 h22 ReadOnly Section vini_Setting_WoWPath,
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvSET_BTopenPath3 hwndhSET_BTopenPath3 ggSET_BTopenPath, ; 打开目录
	IB_Opts_OpenFile := [[0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"]]    ;ImageButton配色(打开文件夹)
	ImageButton.Create(hSET_BTopenPath3, IB_Opts_OpenFile*)
	Gui, MainGui:Add, Button, xs y+5 w120 hp ggSET_autoGetWoWFolder, 自动识别
	Gui, MainGui:Add, Button, x+5 yp wp hp ggSET_selectWoWFolder, 手动选择
	Gui, MainGui:Add, Text, xs y+7 w55, 版本选择:
	Gui, MainGui:Add, Text, x+5 yp w94 vvSET_TXEditionInfo,
	Gui, MainGui:Add, DDL, x+0 yp-2 w90 vini_Setting_WoWEdition ggSET_DDLWoWEdition, % INI.Init("Setting", "WoWEdition")
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 y+15 w270 h55, % "WoW相关插件"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Text, xp+13 yp+25 w175 h22 Section, % "PlayerInfo(离线获取角色信息)"
	Gui, MainGui:Add, Button, x+0 yp-2 w70 hp vvSET_BTInstallAddon1 ggSET_BTInstallAddon, 安装
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 y+13 w270 h85, % "自定义储存路径选择(可拖拽)"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, xp+13 yp+25 w223 h22 ReadOnly Section vini_Setting_SavedPath,
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvSET_BTopenPath4 hwndhSET_BTopenPath4 ggSET_BTopenPath, ; 打开目录
	ImageButton.Create(hSET_BTopenPath4, IB_Opts_OpenFile*)
	Gui, MainGui:Add, Button, xs y+5 w245 hp ggSET_selectRealFolder, 选择路径

	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 y+13 w270 h85, % "WTF备份路径选择(可拖拽)"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, xp+13 yp+25 w223 h22 ReadOnly Section vini_Setting_BackUpPath,
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvSET_BTopenPath5 hwndhSET_BTopenPath5 ggSET_BTopenPath, ; 打开目录
	ImageButton.Create(hSET_BTopenPath5, IB_Opts_OpenFile*)
	Gui, MainGui:Add, Button, xs y+5 w245 hp ggSET_selectBackUpFolder, 选择路径
	
	;~ Gui, MainGui:Add, 
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_Setting:
	;MainGui控件:
	GuiControl, Choose, ini_MainGui_MainTab, % ini_MainGui_MainTab    ;恢复上次Tab位置
	;GroupBox<本程序的配置数据文件>:
	GuiControl,, ini_AppGeneral_UserDataPos, % 2 - ini_AppGeneral_UserDataPos    ;单选框
	;GroupBox<魔兽世界游戏路径><自定义存储路径><WTF备份存储路径>:
	INI.Init("Setting", "WoWPath")    ;游戏路径
	INI.Init("Setting", "WoWEdition")    ;游戏版本
	INI.Init("Setting", "SavedPath", A_ScriptDir "\WoW Saved")    ;真实存储位置
	INI.Init("Setting", "BackUpPath", A_ScriptDir "\WoW WTFBackUp")    ;WTF备份存储路径,默认本地
	SAVED_PATH := FileExist(ini_Setting_SavedPath) ? ini_Setting_SavedPath : A_ScriptDir "\WoW Saved"    ;真实存储位置的验证
	BACKUP_PATH := FileExist(ini_Setting_BackUpPath) ? ini_Setting_BackUpPath : A_ScriptDir "\WoW WTFBackUp"    ;WTF备份路径的验证
	if FileExist(ini_Setting_WoWPath "\" ini_Setting_WoWEdition "\WTF")    ;初始化时验证到魔兽地址正确
	{
		GuiControl,, ini_Setting_WoWPath, % WOW_PATH := ini_Setting_WoWPath    ;游戏路径
		GuiControl,, ini_Setting_WoWEdition, % folderList := GetSubFolderIfHasFile(WOW_PATH, "WTF")    ;魔兽版本列表
		GuiControl, ChooseString, ini_Setting_WoWEdition, % WOW_EDITION := ini_Setting_WoWEdition    ;魔兽版本选择上次
		gosub, DoAfterEditionChange
	}
	else    ;验证失败
	{
		gosub, gSET_autoGetWoWFolder
	}
return

;=======================================================================================================================
;Tab进此模块时执行的命令 |
;=======================
;~ GuiTabIn_Setting:
;~ return



;=======================================================================================================================
;打开路径按钮 |
;==============
gSET_BTopenPath:
	Switch A_GuiControl
	{
	Case "vSET_BTopenPath1": path := A_ScriptDir
	Case "vSET_BTopenPath2": path := APP_DATA_PATH
	Case "vSET_BTopenPath3": GuiControlGet, path,, ini_Setting_WoWPath
	Case "vSET_BTopenPath4": GuiControlGet, path,, ini_Setting_SavedPath
	Case "vSET_BTopenPath5": GuiControlGet, path,, ini_Setting_BackUpPath
	Default: return
	}
	if InStr(FileExist(path), "D")
		try Run % path
return

;=======================================================================================================================
;GroupBox<本程序的配置数据文件> |
;==============================
;选择账号保存位置：
gSET_RDDatePos:
	Gui, MainGui:Submit, NoHide
	USER_DATA_PATH := (ini_AppGeneral_UserDataPos == 2) ? APP_DATA_PATH : A_ScriptDir
	INI.filePath := USER_DATA_PATH "\" USER_CONFIG_INI_NAME
return

;=======================================================================================================================
;GroupBox<魔兽世界游戏路径> |
;==========================
;手动选择魔兽世界位置
gSET_selectWoWFolder:
	Gui MainGui:+OwnDialogs    ;对话框出现时禁止操作主GUI
	FileSelectFolder, newWoWFolder,,, 请选择魔兽世界的游戏目录
	if newWoWFolder	;有效值
	{
		WOW_PATH := newWoWFolder
		gosub, DoAfterResetWoWPath
	}
return

;自动选择魔兽世界位置
gSET_autoGetWoWFolder:
	;先查询注册表
	if (WOW_PATH := GetWoWPathByReg())
	{
		gosub, DoAfterResetWoWPath
		return
	}
	;全盘扫描前询问(有些老电脑全盘扫描会卡住)
	Gui MainGui:+OwnDialogs    ;对话框出现时禁止操作主GUI
	MsgBox, 36,, 是否进行全盘扫描定位wow目录?
	IfMsgBox, No
	{
		gosub, gSET_selectWoWFolder
		return
	}
	;开始全盘扫描
	Gui MainGui:+Disabled    ;主窗口禁用
	Progress, m b c01 fs12 fm12 zh0 CTWhite CWBlue w600, 扫描中 . . ., 自动定位WoW游戏目录, , 微软雅黑    ;进度条
	SetTimer, RenewProgress, 50
	WoWFolder_AutoGet := AutoFindPath("WTF","BlizzardError.exe",ProgressSubText)    ;搜索wow的函数
	SetTimer, RenewProgress, Off
	Progress, Off
	;不同数量的可用路径分别处理
	if (WoWFolder_AutoGet.Count() == 0)    ;0个结果时
	{
		MsgBox 自动扫描没有发现wow路径,请手动设置 T_T
		gosub, gSET_selectWoWFolder
	}
	else
	{
		WOW_PATH := WoWFolder_AutoGet[1]    ;直接设定为目录
		WOW_PATH := SubStr(WOW_PATH,1,instr(WOW_PATH,"\",,-1)-1)    ;去除\retail 文件夹
		gosub, DoAfterResetWoWPath
	}
	Gui MainGui:-Disabled    ;主窗口启用
	WinActivate, ahk_id %hMainGui%    ;激活主窗口
return
;进度条更新线程：
RenewProgress: 
	Progress,, %ProgressSubText%    ;变更
return


;成功找到wow路径后
DoAfterResetWoWPath:
	GuiControl,, ini_Setting_WoWPath, % WOW_PATH    ;地址栏变更
	if (folderList := GetSubFolderIfHasFile(WOW_PATH, "WTF"))    ;含版本的路径
	{
		WOW_EDITION := SubStr(folderList,2,StrLen(folderList)-instr(folderList,"|",,2)+1)
		gosub, DoAfterEditionChange
		GuiControl,, ini_Setting_WoWEdition, % folderList    ;魔兽版本列表变更
		GuiControl, ChooseString, ini_Setting_WoWEdition, % WOW_EDITION
	}
	else    ;未找到版本
	{
		WOW_EDITION := ""
		GuiControl,, ini_Setting_WoWEdition, % "|"    ;清空
	}
return

;DDL选择版本(确定版本信息等于开始初始化了)
gSET_DDLWoWEdition:
	Gui MainGui:+Disabled	;主窗口禁用
	Gui, Submit, NoHide
	WOW_EDITION := ini_Setting_WoWEdition
	gosub, DoAfterEditionChange
	Gui MainGui:-Disabled	;主窗口启用
return

;魔兽版本改变后的动作
DoAfterEditionChange:
	if !FileExist(WOW_PATH "\" WOW_EDITION)
		return
	;常用变量重设
	WOW_ADDONS_PATH := WOW_PATH "\" WOW_EDITION "\Interface\AddOns"    ;插件目录路径
	WOW_WTF_PATH := WOW_PATH "\" WOW_EDITION "\WTF"    ;WTF目录路径
	
	;WTF下Config.wtf配置信息导入
	WOW_WTF_CONFIG := new WowConfigWtf(WOW_WTF_PATH "\Config.wtf")
	WOW_EDITION_VERSION := WOW_WTF_CONFIG.Get("lastAddonVersion")    ;获取当前版本号
	GuiControl,, vSET_TXEditionInfo, % WOW_EDITION_CN[WOW_EDITION] "(" WOW_EDITION_VERSION ")"
	
	;自定义存储路径生成对应子文件夹
	gosub, DoAfterResetSavedPath

	;WTF备份存储路径生成对应子文件夹
	gosub, DoAfterResetBackUpPath

	;是否安装了相关插件检测及版本更新
	gosub, AddonsCheckAndUpdate
return

;=======================================================================================================================
;GroupBox<WoW相关插件> |
;======================
;是否安装了相关插件检测及插件版本更新
AddonsCheckAndUpdate:
	if !FileExist(WOW_ADDONS_PATH)
		return
	;检查插件是否安装
	if FileExist(WOW_ADDONS_PATH "\PlayerInfo\PlayerInfo.toc")    ;已安装
	{
		GuiControl, Disable, vSET_BTInstallAddon1
		GuiControl,, vSET_BTInstallAddon1, % "已安装"
		
		;检测插件版本是否需要更新
		toc := new WowAddOnsToc(WOW_ADDONS_PATH "\PlayerInfo\PlayerInfo.toc")
		if (toc.Get("Interface") <> WOW_EDITION_VERSION)
			toc.Set("Interface", WOW_EDITION_VERSION)
	}
	else
	{
		GuiControl, Enable, vSET_BTInstallAddon1
		GuiControl,, vSET_BTInstallAddon1, % "安装"
	}
return

;安装插件
gSET_BTInstallAddon:
	if !FileExist(WOW_ADDONS_PATH)
	{
		SB_SetText("未发现插件目录,插件安装失败")
		return
	}
	Gui MainGui:+Disabled	;主窗口禁用
	FolderCopyEx(APP_DATA_PATH "\AddOns\PlayerInfo", WOW_ADDONS_PATH "\PlayerInfo")
	gosub, AddonsCheckAndUpdate
	Gui MainGui:-Disabled	;主窗口启用
return

;=======================================================================================================================
;GroupBox<自定义存储路径> |
;========================
;自定义安装路径选取
gSET_selectRealFolder:
	Gui MainGui:+OwnDialogs    ;对话框出现时禁止操作主GUI
	FileSelectFolder, newRealFolder,,, 请选择自定义存储目录路径
	if newRealFolder	;有效值
	{
		SAVED_PATH := newRealFolder
		gosub, DoAfterResetSavedPath
	}
return

;成功选择了自定义存储路径后
DoAfterResetSavedPath:
	GuiControl,, ini_Setting_SavedPath, % SAVED_PATH    ;地址栏变更
	;创建当前版本的子文件夹
	if WOW_EDITION
	{
		FileCreateDir, % SAVED_PATH "\" WOW_EDITION "\WTF\Account"        ;自定义WTF路径
		FileCreateDir, % SAVED_PATH "\" WOW_EDITION "\Interface\AddOns"   ;自定义插件路径
	}
return

;=======================================================================================================================
;GroupBox<WTF备份存储路径> |
;===========================
;WTF备份存储路径选取
gSET_selectBackUpFolder:
	Gui MainGui:+OwnDialogs    ;对话框出现时禁止操作主GUI
	FileSelectFolder, newBackUpFolder,,, 请选择自定义存储目录路径
	if newBackUpFolder	;有效值
	{
		BACKUP_PATH := newBackUpFolder
		gosub, DoAfterResetBackUpPath
	}
return

;成功选择了WTF备份存储路径后
DoAfterResetBackUpPath:
	GuiControl,, ini_Setting_BackUpPath, % BACKUP_PATH    ;地址栏变更
	;创建当前版本的子文件夹
	if WOW_EDITION
	{
		FileCreateDir, % BACKUP_PATH "\" WOW_EDITION "\WTF"    ;配置存储路径
	}
return


;=======================================================================================================================
;模块GUI附属 |
;============
;Gui拖拽进来文件
GuiDropFiles_Setting:
	if not InStr(FileExist(A_GuiEvent),"D")
		return
	Switch A_GuiControl
	{
	;魔兽目录
	Case "ini_Setting_WoWPath":
		WOW_PATH := A_GuiEvent
		gosub, DoAfterResetWoWPath
	;自定义目录
	Case "ini_Setting_SavedPath":
		SAVED_PATH := A_GuiEvent
		gosub, DoAfterResetSavedPath
	;WTF备份目录
	Case "ini_Setting_BackUpPath":
		BACKUP_PATH := A_GuiEvent
		gosub, DoAfterResetBackUpPath
	Default:
	}
return

;GUI尺寸控制:
GuiSize_Setting:
	;~ AutoXYWH("w h", "vHK_LVmain")
return

;=======================================================================================================================
;模块GUI附属动作$函数 |
;====================
