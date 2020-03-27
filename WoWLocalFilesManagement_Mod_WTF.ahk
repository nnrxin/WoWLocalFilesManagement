ExitApp
;=======================================================================================================================
;WoWLocalFilesManagement模块:
;Mod = WTF
;控件前缀: WTF_
;需修改下面三个线程名称: AddMod_, GuiSize_, GuiInit_
;=======================================================================================================================
;新增模块所需函数库 |
;==================
#Include <Class_ImageButton>    ;加载类(GUI彩色按钮)
#Include <Class_LV_Colors>    ;加载类(GUI彩色LV)
#Include <Class_WowAddOnSavedLua>    ;加载类(魔兽世界插件Saved.Lua文件控制)
#Include <Class_WowAddOnSavedLua_Fast>    ;加载类(魔兽世界插件Saved.Lua文件控制) - 简单快速
;=======================================================================================================================
;新增模块线程 |
;=============
AddMod_WTF:
	;模块部署
	NEED_DEEP_SCAN_WTF := 0
	
	;在MainGui的TAB上:
	;备份设置
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 ym+25 w590 h75, % "设置"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light

	Gui, MainGui:Add, Checkbox, xp+10 yp+20 w130 h22 Section AltSubmit vini_WTF_ifBackUp, % "备份目标角色文件至"
	GuiControl,, ini_WTF_ifBackUp, % INI.Init("WTF", "ifBackUp", 1)
	Gui, MainGui:Add, Edit, x+0 yp hp w420 ReadOnly vvWTF_EDbackupPath, 
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvWTF_BTopenPath3 hwndhWTF_BTopenPath3 ggWTF_BTopenPath, ; 打开目录
	IB_Opts_OpenFile := [[0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"]]    ;ImageButton配色(打开文件夹)
	ImageButton.Create(hWTF_BTopenPath3, IB_Opts_OpenFile*)
	
	Gui, MainGui:Add, Checkbox, xs y+5 hp AltSubmit Section vini_WTF_ifModLua, % "替换文件中的角色名"
	GuiControl,, ini_WTF_ifModLua, % INI.Init("WTF", "ifModLua", 1)
	
	Gui, MainGui:Add, Checkbox, x+5 yp hp AltSubmit vini_WTF_generateLog , % "生成过程清单"
	GuiControl,, ini_WTF_generateLog, % INI.Init("WTF", "generateLog", 1)
	
	Gui, MainGui:Add, Checkbox, x+5 yp hp AltSubmit vini_WTF_cLV ggWTF_CBcLV, % "彩色列表"
	GuiControl,, ini_WTF_cLV, % INI.Init("WTF", "cLV", 1)
	
	;魔兽版本Logo
	Gui, MainGui:Add, Picture, xm+605 ym+25 w150 h75 Section vvWTF_PICwowLogo, 
	hBitMapLogoClassic := LoadPicture(APP_DATA_PATH "\Img\GUI\Logo_Classic.png") 
	hBitMapLogoOnion := LoadPicture(APP_DATA_PATH "\Img\GUI\Logo_Onion.png")
	hBitMapLogoBFA := LoadPicture(APP_DATA_PATH "\Img\GUI\Logo_BFA.png")
	
	;路径切换
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	IB_Opts := [[0,0xCCCCCC,,0x838383,,,0xBFBFBF],[,0xFFFFFF],[,0xFFFFFF],[,0xFFFFFF,,"black",,,0x0078D7]]    ;ImageButton配色(反向win10配色)
	;~ IB_Opts := [[0,0xCCCCCC,,0x838383],[,0xCCE8CF],[,0xCCE8CF],[,0xCCE8CF,,"black"]]    ;ImageButton配色(激活时灰色,未激活时绿色)
	Gui, MainGui:Add, Button, xm+10 y+5 w95 h22 Section vvWTF_BTsrcWowPath hwndhWTF_BTsrcWowPath ggWTF_BTsrcScanPath, 魔兽世界路径
	ImageButton.Create(hWTF_BTsrcWowPath, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, x+0 yp hp w528 ReadOnly vvWTF_EDwowPath, 
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvWTF_BTopenPath1 hwndhWTF_BTopenPath1 ggWTF_BTopenPath, ;"打开目录"
	ImageButton.Create(hWTF_BTopenPath1, IB_Opts_OpenFile*)
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Button, x+0 yp w95 hp vvWTF_BTtarWowPath hwndhWTF_BTtarWowPath ggWTF_BTtarScanPath, 魔兽世界路径
	ImageButton.Create(hWTF_BTtarWowPath, IB_Opts*)   ;彩色按钮
	
	Gui, MainGui:Add, Button, xs y+2 w95 h22 Section vvWTF_BTsrcSavedPath hwndhWTF_BTsrcSavedPath ggWTF_BTsrcScanPath, 自定义存储路径
	ImageButton.Create(hWTF_BTsrcSavedPath, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, x+0 yp hp w528 ReadOnly vvWTF_EDsavedPath, 
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvWTF_BTopenPath2 hwndhWTF_BTopenPath2 ggWTF_BTopenPath, ;"打开目录"
	ImageButton.Create(hWTF_BTopenPath2, IB_Opts_OpenFile*)
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Button, x+0 yp w95 hp vvWTF_BTtarSavedPath hwndhWTF_BTtarSavedPath ggWTF_BTtarScanPath, 自定义存储路径
	ImageButton.Create(hWTF_BTtarSavedPath, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	
	;职业选择
	;筛选框职业图片按钮:
	picPath := APP_DATA_PATH "\Img\Classicon"
	Gui, MainGui:Add, Button, xs+114 y+7 w41 h41 ggWTF_BTclass hwndhWTF_BTclass1 vvWTF_BTclass1 ,
	ImageButton.Create(hWTF_BTclass1, [0,picPath "\G1.png"], [,picPath "\L1.png"],, [,picPath "\1.ico"])
	loop 11
	{
		i := A_index + 1
		Gui, MainGui:Add, Button, % "x+1 yp wp hp ggWTF_BTclass hwndhWTF_BTclass" i " vvWTF_BTclass" i,
		ImageButton.Create(hWTF_BTclass%i%, [0,picPath "\G" i ".png"], [,picPath "\L" i ".png"],, [,picPath "\" i ".ico"])
	}
	
	;筛选
	Gui, MainGui:Add, Text, xm+10 ys+30 w30 h22 Section Center, 包含
	Gui, MainGui:Add, Edit, x+0 yp-2 w80 hp vini_WTF_srcInclude hwndhWTF_EDsrcInclude ggWTF_EDsrcFilter, % INI.Init("WTF", "srcInclude")    ;包含
	Gui, MainGui:Add, Edit, x+520 yp wp hp vini_WTF_tarInclude hwndhWTF_EDtarInclude ggWTF_EDtarFilter, % INI.Init("WTF", "tarInclude")    ;包含
	Gui, MainGui:Add, Text, x+0 yp+2 w30 hp Center, 包含
	Gui, MainGui:Add, Text, xs y+1 w30 hp Center, 排除
	Gui, MainGui:Add, Edit, x+0 yp-2 w80 hp vini_WTF_srcExclude hwndhWTF_EDSrcExclude ggWTF_EDsrcFilter, % INI.Init("WTF", "srcExclude")    ;不包含
	Gui, MainGui:Add, Edit, x+520 yp wp hp vini_WTF_tarExclude hwndhWTF_EDtarExclude ggWTF_EDtarFilter, % INI.Init("WTF", "tarExclude")    ;不包含
	Gui, MainGui:Add, Text, x+0 yp+2 w30 hp Center, 排除
	
	;文本框
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Text, xs y+5 w40 hp Center Section, 源角色
	Gui, MainGui:Add, Edit, x+0 yp-2 w270 hp  ReadOnly vvWTF_EDSrcSelected hwndhWTF_EDSrcSelected,
	Gui, MainGui:Add, Edit, xs+430 yp w260 hp ReadOnly vvWTF_EDTarSelected hwndhWTF_EDTarSelected,
	Gui, MainGui:Add, Text, x+0 yp+2 w50 hp Center, 目标角色
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	

	;左侧 LV
	Gui, MainGui:Add, ListView, xm+10 ys+22 w310 h324 Section Count500 -Multi Grid AltSubmit vvWTF_LVSrc hwndhWTF_LVSrc ggLVWTF, ❤|WTFIndex|Index|职业|角色|服务器|账号
	;为LV增加图片列表
	ImageListID := IL_Create(12)  ; 创建加载 12 个小图标的图像列表.
	LV_SetImageList(ImageListID)  ; 把上面的图像列表指定给当前的 ListView.
	;加载ico图标成位图并加载图片到图像列表里
	Loop 12
	{
		hBitMapClass%A_Index% := LoadPicture(APP_DATA_PATH "\Img\Classicon\" A_Index ".ico") 
		IL_Add(ImageListID, "HBITMAP:*" hBitMapClass%A_Index%)	
	}
	
	;中部
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Button, x+5 ys-23 w110 h22 vvWTF_BTclean ggWTF_BTclean hwndhWTF_BTclean Disabled, 全 职 业    ;恢复全部职业
	ImageButton.Create(hWTF_BTclean, [0,0xE1E1E1,,"red",,,0xADADAD],[,0xE5F1FB],[,0xCCE4F7],[,0xCCCCCC,,0x838383])   ;红字的默认按钮
	
	;配置覆盖选项
	Gui, MainGui:Add, GroupBox, xp y+2 w110 h202, % "覆盖模式"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Checkbox, xp+10 yp+17 w90 h16 AltSubmit vini_WTF_optionA1, % "账号插件配置"
	GuiControl,, ini_WTF_optionA1, % INI.Init("WTF", "optionA1", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+0 wp hp AltSubmit vini_WTF_optionA2, % "账号系统配置"
	GuiControl,, ini_WTF_optionA2, % INI.Init("WTF", "optionA2", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+0 wp hp AltSubmit vini_WTF_optionA3, % "账号按键"
	GuiControl,, ini_WTF_optionA3, % INI.Init("WTF", "optionA3", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+0 wp hp AltSubmit vini_WTF_optionA4, % "账号共享宏"
	GuiControl,, ini_WTF_optionA4, % INI.Init("WTF", "optionA4", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+0 wp hp AltSubmit vini_WTF_optionP1, % "角色插件配置"
	GuiControl,, ini_WTF_optionP1, % INI.Init("WTF", "optionP1", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+0 wp hp AltSubmit vini_WTF_optionP2, % "角色系统配置"
	GuiControl,, ini_WTF_optionP2, % INI.Init("WTF", "optionP2", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+0 wp hp AltSubmit vini_WTF_optionP3, % "角色按键"
	GuiControl,, ini_WTF_optionP3, % INI.Init("WTF", "optionP3", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+0 wp hp AltSubmit vini_WTF_optionP4, % "角色专属宏"
	GuiControl,, ini_WTF_optionP4, % INI.Init("WTF", "optionP4", 1)    ;初始化
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	IB_Opts2 := [[0,0xC7EDCC,,"black",,,0xBFBFBF],[,0x00FF00],[,0x00FF00,,0xFFFFFF],[,0xCCCCCC,,0x838383,,,0xBFBFBF]]    ;ImageButton配色
	Gui, MainGui:Add, Button, xp y+3 w90 h45 vvWTF_BTcopy hwndhWTF_BTcopy ggWTF_BTCopyOrSyn Disabled, % "配置覆盖`n> > > >"
	ImageButton.Create(hWTF_BTcopy, IB_Opts2*)   ;彩色按钮
	
	Gui, MainGui:Add, GroupBox, xp-10 y+8 w110 h74, % "同步模式"
	Gui, MainGui:Add, Button, xp+10 yp+20 w90 h45 vvWTF_BTsyn hwndhWTF_BTsyn ggWTF_BTCopyOrSyn Disabled, % "配置同步`n< < < <"
	ImageButton.Create(hWTF_BTsyn, IB_Opts2*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xp-10 y+8 w110 h48, % "自定义账号"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Button, xp+3 yp+16  w28 h28 vvWTF_BTcopyRaw hwndhWTF_BTcopyRaw ggWTF_BTCopyOrSyn Disabled,
	ImageButton.Create(hWTF_BTcopyRaw, [0,APP_DATA_PATH "\Img\GUI\Arrow.png"],[,APP_DATA_PATH "\Img\GUI\Arrowp.png"],,[,APP_DATA_PATH "\Img\GUI\Arrowg.png"])
	Gui, MainGui:Add, Edit, x+0 yp+3 w70 h22 vini_WTF_customName, % INI.Init("WTF", "customName", "根账号") 
	
	
	
	
	;右侧 LV
	Gui, MainGui:Add, ListView, xs+430 ys w310 h324 Count500 Grid AltSubmit vvWTF_LVTar hwndhWTF_LVTar ggLVWTF, ❤|WTFIndex|Index|职业|角色|服务器|账号
	;为LV增加图片列表
	ImageListID := IL_Create(12)  ; 创建加载 12 个小图标的图像列表.
	LV_SetImageList(ImageListID)  ; 把上面的图像列表指定给当前的 ListView.
	;加载ico图标成位图并加载图片到图像列表里
	Loop 12
	{
		IL_Add(ImageListID, "HBITMAP:*" hBitMapClass%A_Index%)	
	}
	
	;选取LV的详细信息列表
	Gui, MainGui:Add, ListView, xm+10 y+2 w740 h60 Count100 Grid AltSubmit hwndhWTF_LVSel, 职业|角色|服务器|账号|WTF路径|账号链接到|角色链接到|I|J
	
	
	
	global WTF := new WTFDataStorage()
	;左边控件封装进类
	global SRCGui := new WTFGUIListView(WTF                                         ;WTF类
									  , hWTF_LVSrc                                  ;LV句柄
									  , hWTF_EDSrcSelected                          ;ED已选择句柄
									  , hWTF_EDsrcInclude                           ;ED筛选包含
									  , hWTF_EDSrcExclude                           ;ED筛选排除
									  , 1                                           ;开启了额外筛选
									  , 1)                                          ;开启了颜色
	SRCGui.WTFpathSwitch := INI.Init("WTF", "srcScanPathSwitch", 0)                 ;路径选择开关状态
	SRCGui.cLVSwitch := ini_WTF_cLV    ;颜色开关
	;右边控件封装进类
	global TARGui := new WTFGUIListView(WTF                                         ;WTF类
									  , hWTF_LVTar                                  ;LV句柄
									  , hWTF_EDTarSelected                          ;ED已选择句柄
									  , hWTF_EDtarInclude                           ;ED筛选包含
									  , hWTF_EDtarExclude                           ;ED筛选排除
									  , 1                                           ;开启了额外筛选 
									  , 1)                                          ;开启了颜色
	TARGui.WTFpathSwitch := INI.Init("WTF", "tarScanPathSwitch", 0)                 ;路径选择开关状态
	TARGui.cLVSwitch := ini_WTF_cLV    ;颜色开关
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_WTF:
	;当前WTF目录刷新
	WTFGUIListView.wowWTFPath    := WOW_EDITION ? (WOW_PATH    "\" WOW_EDITION "\WTF\Account") : ""    ;魔兽wtf路径
	WTFGUIListView.savedWTFPath  := WOW_EDITION ? (SAVED_PATH  "\" WOW_EDITION "\WTF\Account") : ""    ;自定义存储wtf路径
	WTFGUIListView.backupWTFPath := WOW_EDITION ? (BACKUP_PATH "\" WOW_EDITION "\WTF") : ""            ;备份wtf路径
	GuiControl,, vWTF_EDwowPath,    % WTFGUIListView.wowWTFPath        ;wow路径
	GuiControl,, vWTF_EDsavedPath,  % WTFGUIListView.savedWTFPath      ;自定义存储路径
	GuiControl,, vWTF_EDbackupPath, % WTFGUIListView.backupWTFPath     ;WTF备份路径
	;按钮激活 左
	GuiControl, % "Enable"  SRCGui.WTFpathSwitch, vWTF_BTsrcWowPath     ;魔兽路径
	GuiControl, % "Disable" SRCGui.WTFpathSwitch, vWTF_BTsrcSavedPath   ;自定义存储路径
	;按钮激活 右
	GuiControl, % "Enable"  TARGui.WTFpathSwitch, vWTF_BTtarWowPath     ;魔兽路径
	GuiControl, % "Disable" TARGui.WTFpathSwitch, vWTF_BTtarSavedPath   ;自定义存储路径
	
	gosub, ShowWoWLogo    ;魔兽Logo图片刷新
	gosub, srcScanNewPath    ;扫描新路径 左
	gosub, tarScanNewPath    ;扫描新路径 右
return

;=======================================================================================================================
;Tab进此模块时执行的命令 |
;=======================
GuiTabIn_WTF:
	if (WTFGUIListView.wowWTFPath   <> WOW_PATH   "\" WOW_EDITION "\WTF\Account")    ;魔兽地址发生变化时,重新初始化
	or (WTFGUIListView.savedWTFPath <> SAVED_PATH "\" WOW_EDITION "\WTF\Account")    ;自定义地址发生变化时,重新初始化
	or (NEED_DEEP_SCAN_WTF == 1)    ;需要深度刷新列表
	{
		gosub, CleanItems
		gosub, GuiInit_WTF
		NEED_DEEP_SCAN_WTF := 0
	}
return

;清空源项目与目标项目
CleanItems:
	WTF.src := {}                        ;源集合
	WTF.tars := {}                       ;多目标集合
	SRCGui.ClearSelected()               ;左边控件清空
	TARGui.ClearSelected()               ;右边控件清空
	GuiControl, Disable, vWTF_BTcopy     ;复制按钮
	GuiControl, Disable, vWTF_BTsyn      ;同步按钮
	GuiControl, Disable, vWTF_BTcopyRaw  ;向左同步
return

;=======================================================================================================================
;魔兽版本Logo |
;==============
;显示魔兽logo图片
ShowWoWLogo:
	Switch WOW_EDITION
	{
	Case "_classic_":
		picPath := % "HBITMAP:*" hBitMapLogoClassic
	Default:
		if (WOW_EDITION_VERSION >= 90000)
			picPath := % "HBITMAP:*" hBitMapLogoOnion
		else if (WOW_EDITION_VERSION >= 80000)
			picPath := % "HBITMAP:*" hBitMapLogoBFA
		else
			picPath := WOW_EDITION " " WOW_EDITION_VERSION
	}
	GuiControl,, vWTF_PICwowLogo, % picPath
return

;=======================================================================================================================
;路径切换及扫描 |
;================
;切换路径 左
gWTF_BTsrcScanPath:
	Gui MainGui:+Disabled	;主窗口禁用
	;开关切换
	ini_WTF_srcScanPathSwitch := SRCGui.WTFpathSwitch := 1 - SRCGui.WTFpathSwitch    
	GuiControl, % "Enable"  SRCGui.WTFpathSwitch, vWTF_BTsrcWowPath     ;魔兽路径
	GuiControl, % "Disable" SRCGui.WTFpathSwitch, vWTF_BTsrcSavedPath   ;自定义存储路径
	;扫描新路径
	gosub, srcScanNewPath
	Gui MainGui:-Disabled	;主窗口启用
return
;扫描路径 左
srcScanNewPath:
	Gui MainGui:+Disabled	;主窗口禁用
	SRCGui.WTFpath := SRCGui.WTFpathSwitch ? WTFGUIListView.savedWTFPath : WTFGUIListView.wowWTFPath
	SRCGui.dataIndex := WTF.AddData(SRCGui.WTFpath, NEED_DEEP_SCAN_WTF)    ;新建WTF类,路径扫描
	gosub, gWTF_EDsrcFilter    ;筛选动作
	Gui MainGui:-Disabled	;主窗口启用
return


;切换路径 右
gWTF_BTtarScanPath:
	Gui MainGui:+Disabled	;主窗口禁用
	;开关切换
	ini_WTF_tarScanPathSwitch := TARGui.WTFpathSwitch := 1 - TARGui.WTFpathSwitch    
	GuiControl, % "Enable"  TARGui.WTFpathSwitch, vWTF_BTtarWowPath     ;魔兽路径
	GuiControl, % "Disable" TARGui.WTFpathSwitch, vWTF_BTtarSavedPath   ;自定义存储路径
	;扫描新路径
	gosub, tarScanNewPath
	Gui MainGui:-Disabled	;主窗口启用
return
;扫描路径 右
tarScanNewPath:
	Gui MainGui:+Disabled	;主窗口禁用
	TARGui.WTFpath := TARGui.WTFpathSwitch ? WTFGUIListView.savedWTFPath : WTFGUIListView.wowWTFPath
	TARGui.dataIndex := WTF.AddData(TARGui.WTFpath, NEED_DEEP_SCAN_WTF)    ;新建WTF类,路径扫描
	gosub, gWTF_EDtarFilter    ;筛选动作
	Gui MainGui:-Disabled	;主窗口启用
return


;打开路径
gWTF_BTopenPath:
	Switch A_GuiControl
	{
	Case "vWTF_BTopenPath1": GuiControlGet, path,, vWTF_EDwowPath    ;wow路径
	Case "vWTF_BTopenPath2": GuiControlGet, path,, vWTF_EDsavedPath    ;自定义存储路径
	Case "vWTF_BTopenPath3": GuiControlGet, path,, vWTF_EDbackupPath    ;WTF备份路径
	Default: return
	}
	if InStr(FileExist(path), "D")
		try Run % path
return


;=======================================================================================================================
;筛选 |
;=====
;筛选框左
gWTF_EDsrcFilter:
	Gui MainGui:+Disabled
	SRCGui.UpdateLV()    ;LV刷新
	Gui MainGui:-Disabled
return

;筛选框右
gWTF_EDtarFilter:
	Gui MainGui:+Disabled	
	TARGui.UpdateLV()    ;LV刷新
	Gui MainGui:-Disabled
return

;角色筛选按钮
gWTF_BTclass:
	Gui MainGui:+Disabled	;主窗口禁用
	loop 12
	{
		GuiControl, Enable, vWTF_BTclass%A_Index%
	}
	GuiControl, Disable, % A_GuiControl
	SRCGui.Spec := TARGui.Spec := SubStr(A_GuiControl, 13)
	gosub, gWTF_EDsrcFilter
	gosub, gWTF_EDtarFilter
	GuiControl, Enable, vWTF_BTclean    ;启用重置键
	Gui MainGui:-Disabled	;主窗口启用
return

;重置筛选
gWTF_BTclean:
	Gui, MainGui:+Disabled	;主窗口禁用
	GuiControl, Disable, vWTF_BTclean    ;禁用重置键
	;按键全部启用
	SRCGui.Spec := TARGui.Spec := 0
	loop 12
	{
		GuiControl, Enable, vWTF_BTclass%A_Index%
	}
	gosub, gWTF_EDsrcFilter
	gosub, gWTF_EDtarFilter
	Gui, MainGui:-Disabled	;主窗口启用
return

;LV颜色开关
gWTF_CBcLV:
	Gui MainGui:Submit, NoHide
	SRCGui.cLVSwitch := TARGui.cLVSwitch := ini_WTF_cLV   ;颜色开关
	SRCGui.UpdateLVColor()
	TARGui.UpdateLVColor()
return


;=======================================================================================================================
;LV控件 |
;========
;LV列表动作 左 + 右
gLVWTF:
	Gui MainGui:+Disabled
	Gui, ListView, % A_GuiControl
	if (A_GuiEvent = "ColClick")    ;点击了标题栏
	{
		if (A_EventInfo == 1)
			LV_ModifyCol(4, "SortDesc")
		if (A_GuiControl == "vWTF_LVSrc")
			SRCGui.UpdateLVColor()
		else if (A_GuiControl == "vWTF_LVTar")
			TARGui.UpdateLVColor()	
	}
	else if ((A_GuiEvent == "F") or (A_GuiEvent == "I")) and InStr(ErrorLevel, "S")    ;所选发生变化
	{
		if (A_GuiControl == "vWTF_LVSrc" and SRCGui.UpdateLVSelected())
		{
			WTF.src := SRCGui.LVselected[1]
			ShowInLVWTFSel(hWTF_LVSel, SRCGui.LVselected)
			gosub, ControlWTFButtons
		}
		else if (A_GuiControl == "vWTF_LVTar" and TARGui.UpdateLVSelected())
		{
			WTF.tars := TARGui.LVselected
			ShowInLVWTFSel(hWTF_LVSel, WTF.tars)
			gosub, ControlWTFButtons
		}
	}
	Gui MainGui:-Disabled
return

;按钮激活控制 覆盖/同步/向左复制
ControlWTFButtons:
	notEmptyL := SRCGui.selectedCount ? 1 : 0
	notEmptyR := TARGui.selectedCount ? 1 : 0
	notSame := (TARGui.selectedCount == 1 and WTF.src.index == WTF.tars[1].index and WTF.src.WTFIndex == WTF.tars[1].WTFIndex) ? 0 : 1
	GuiControl, % "Enable" notEmptyL * notEmptyR * notSame, vWTF_BTcopy               ;覆盖
	GuiControl, % "Enable" notEmptyL * notEmptyR * notSame, vWTF_BTsyn                ;同步(需要管理员)
	GuiControl, % "Enable" !notEmptyL * notEmptyR, vWTF_BTcopyRaw                     ;向左复制(左边需要留空)
return

;将items展示到LVSel中
ShowInLVWTFSel(hLV, items)
{
	Gui, ListView, % hLV    ;选择操作表
	GuiControl, -Redraw, % hLV
	LV_Delete()
	for i, item in items
	{
		LV_Add("Icon" . item.playerClassInde
		, item.playerClassCNShort
		, item.Player
		, item.Realm
		, item.Account
		, item.WTFPath
		, item.accountRealPath
		, item.playerRealPath
		, item.index
		, item.WTFIndex)
	}
	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
	LV_ModifyCol(3, "AutoHdr")
	LV_ModifyCol(4, "AutoHdr")
	LV_ModifyCol(5, "AutoHdr")
	LV_ModifyCol(6, "AutoHdr")
	LV_ModifyCol(7, "AutoHdr")
	LV_ModifyCol(8, "AutoHdr")
	LV_ModifyCol(9, "AutoHdr")
	GuiControl, +Redraw, % hLV
}
;=======================================================================================================================
;复制/同步动作(核心)|
;====================
;配置覆盖/同步/向左复制
gWTF_BTCopyOrSyn:
	if WinExist("ahk_exe Wow.exe") or WinExist("ahk_exe WowClassic.exe")    ;发现魔兽窗口时返回
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 16,, 启动失败: 请关闭魔兽窗口后重试
		return
	}
	Switch A_GuiControl    ;模式确认
	{
	Case "vWTF_BTcopy"   : WTF.options.cmd := "copy"
	Case "vWTF_BTsyn"    : WTF.options.cmd := "syn"
	Case "vWTF_BTcopyRaw": WTF.options.cmd := "copyRaw"
	Default: return
	}
	Gui, MainGui:Submit, NoHide
	if (WTF.options.cmd = "syn" and !A_IsAdmin)     ;文件名称错误
	{
		Gui, MainGui:+OwnDialogs    ;各种对话框的从属
		MsgBox, 16,, % "同步模式需要管理员身份!`n请右键软件以管理员身份重新运行"
		return
	}
	if (WTF.options.cmd = "copyRaw" and RegExMatch(ini_WTF_customName, "[\\/\|<>?"":\*]"))     ;文件名称错误
	{
		Gui, MainGui:+OwnDialogs    ;各种对话框的从属
		MsgBox, 16,, % "文件名称不能包括下列任何字符:`n\/:*?""<>|"
		return
	}
	OldBatchLines := A_BatchLines
	SetBatchLines -1
	
	;数据刷新
	WTF.status.count := 0                            ;进度指示
	, WTF.status.player_realm := ""                  ;当前操作角色
	, WTF.status.playerClassIndex := 0               ;当前操作角色职业序号
	, WTF.status.log := ""                           ;当前动作
	, WTF.status.logs := ""                          ;指令清单
	, WTF.options.timestamp := A_Now                 ;当前时间戳
	, WTF.options.generateLog := ini_WTF_generateLog ;是否生成日志
	, WTF.options.logsPath := USER_DATA_PATH         ;日志保存文件夹路径
	, WTF.options.lastLogPath := ""                  ;上次日志路径
	, WTF.options.modifyLua := ini_WTF_ifModLua      ;修改lua
	, WTF.options.backup := ini_WTF_ifBackUp         ;备份
	, WTF.options.customName := ini_WTF_customName   ;自定义账号名
	, WTF.options.customWTFPath := SRCGui.WTFpath    ;自定义账号路径(左侧选择的路径)
	, WTF.options.SWp1 := ini_WTF_optionP1           ;账号控制
	, WTF.options.SWp2 := ini_WTF_optionP2
	, WTF.options.SWp3 := ini_WTF_optionP3
	, WTF.options.SWp4 := ini_WTF_optionP4
	, WTF.options.SWa1 := ini_WTF_optionA1           ;角色控制
	, WTF.options.SWa2 := ini_WTF_optionA2
	, WTF.options.SWa3 := ini_WTF_optionA3
	, WTF.options.SWa4 := ini_WTF_optionA4
	, WTF.UpdateStatus(WTF.status, WTF.options) ;更新计数
	;职业匹配警告
	if (WTF.status.pathCrashStr or WTF.status.classNotSameStr)
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 52,, % WTF.status.pathCrashStr 
			? "警告！下列角色的复制目标文件夹已存在,是否继续?`n`n" WTF.status.pathCrashStr 
			: "警告！下列目标角色与源角色职业不一致,是否继续?`n`n" WTF.status.classNotSameStr
		IfMsgBox No
		{
			SetBatchLines %OldBatchLines%
			return
		}
	}
	;确认信息
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	Switch WTF.options.cmd    ;模式确认
	{
	Case "copy"   : MsgTxt := "源角色:`n" vWTF_EDSrcSelected "`n`n目标角色:`n" vWTF_EDTarSelected "`n`n是否进行<<文件复制>>来实现配置的覆盖?"
	Case "syn"    : MsgTxt := "源角色:`n" vWTF_EDSrcSelected "`n`n目标角色:`n" vWTF_EDTarSelected "`n`n是否进行<<文件链接>>来实现配置的同步?"
	Case "copyRaw": MsgTxt := "自定义账号: " WTF.options.customName 
							. "`n`n自定义账号路径:`n" WTF.options.customWTFPath "\" WTF.options.customName 
							. "`n`n将包含角色:`n" vWTF_EDTarSelected  "`n`n是否制作自定义账号?"
	}
	MsgBox, 68,, % MsgTxt "`n`n操作前最好对重要文件手动备份,以免数据丢失!!!"
	IfMsgBox Yes
	{
		Gui MainGui:+Disabled
		
		;状态栏修改
		SB_SetParts(200, 150)                                                ;状态栏分3部分
		WTF.status.countForAllTarget
		SB_SetProgress(0, 1, "show Range0-" WTF.status.countForAllTarget)    ;状态栏上增加计时条
		SetTimer, WTFUpdateSB, 50, 10000                                     ;状态栏更新线程开启
		
		;执行动作
		WTF.AddBackUpInfoFile(BACKUP_PATH "\" WOW_EDITION "\WTF")            ;增加备份信息文件夹\文件
		WTF.CopyOrSynPlayers()                                               ;执行复制或同步指令
		
		;底层重新扫描,刷新列表
		if (WTF.options.cmd = "copyRaw")
			WTF.AddData(SRCGui.WTFpath, 1)                                   ;强制刷新源items
		else
			WTF.AddData(TARGui.WTFpath, 1)                                   ;强制刷新目标items
		SRCGui.UpdateLV(1)                                                   ;LV刷新
		TARGui.UpdateLV(1)                                                   ;LV刷新
		
		;状态栏恢复,输出结论
		SetTimer, WTFUpdateSB, Off                                           ;状态栏更新线程关闭
		SB_SetParts()
		SB_SetProgress(0, 1, "hide")                                         ;状态栏上计时条隐藏
		if FileExist(WTF.options.lastLogPath)
			Run, % WTF.options.lastLogPath
		MsgBox 完成
		
		SetBatchLines %OldBatchLines%
		Gui MainGui:-Disabled	
	}
return
;状态栏更新
WTFUpdateSB:
	Gui, MainGui:Default
	SB_SetProgress(WTF.status.count, 1)       ;进度条变更
	classI := WTF.status.playerClassIndex
	SB_SetIcon("HBITMAP:*" hBitMapClass%classI%, 1, 2)
	SB_SetText(WTF.status.player_realm, 2)    ;当前角色
	SB_SetText(WTF.status.log, 3)          ;当前动作
return

;=======================================================================================================================
;模块GUI附属 |
;============

;GUI尺寸控制:
GuiSize_WTF:
	;~ AutoXYWH("w h", "vLVSrc")
	;~ gosub, ReColorWTFLV    ;LV重新上色
return

;=======================================================================================================================
;WTF的GUI控件类 |
;================
Class WTFGUIListView extends GUIListView
{
	static wowWTFPath := ""         ;魔兽wtf路径
	static savedWTFPath := ""       ;自定义存储wtf路径
	static backupWTFPath := ""      ;备份wtf路径
	Spec := 0                       ;职业筛选
	
	;更新规则,需要自设
	UpdateLVAdd(items)
	{
		for i, item in items
		{
			if (this.Spec and item.playerClassIndex and this.Spec <> item.playerClassIndex)    ;筛选职业
				continue
			str := item.Account "`n" item.Realm "`n" item.Player    ;拼合成字串 自定义
			if (this.include <> "" and !InStr(str, this.include)) or (this.exclude <> "" and InStr(str, this.exclude))    ;筛选文字
				continue
			LV_Add("Icon" . item.playerClassIndex
			, 
			, item.WTFIndex
			, item.index
			, item.playerClassCNShort
			, item.Player
			, item.Realm
			, item.Account)
		}
		LV_ModifyCol(1, "AutoHdr NoSort")
		LV_ModifyCol(2, 0)
		LV_ModifyCol(3, 0)
		LV_ModifyCol(4, 0)
		LV_ModifyCol(5, "AutoHdr Logical")
		LV_ModifyCol(6, "AutoHdr Logical")
		LV_ModifyCol(7, "AutoHdr Logical")
		if this.Spec    ;职业筛选时进排序
			LV_ModifyCol(4, "SortDesc")
	}	

	;颜色规则,需要自设
	cLVRule(item, rowIndex, items)    
	{
		;职业染色
		BCol := GetWoWClass(item.playerClass).color      ;默认背景颜色=职业颜色
		TCol := GetWoWClass(item.playerClass).colorBG    ;默认背景颜色=职业颜色背景色
		this.cLV.Cell(rowIndex, 5, BCol, TCol)
		this.cLV.Cell(rowIndex, 6, BCol, TCol)
		;链接染色
		if item.playerIsReparse
			this.cLV.Cell(rowIndex, 7, 0x9C9C9C)
		else if item.accountRealPath
			this.cLV.Cell(rowIndex, 7, 0xCFCFCF)
		else
			this.cLV.Cell(rowIndex, 7, 0xE8E8E8)
	}
	
	;控件更新,需要自设
	UpdateGUIAfterSelected()
	{
		;控件控制
		showStr := ""
		if (this.selectedCount := this.LVselected.Count())
		{
			for i, item in this.LVselected
			{
				showStr .= item.Player "-" item.Realm "(" item.Account (this.WTFpathSwitch ? "@自定义存储" : "@魔兽世界") "); `n"
			}
			Trim(showStr, "; `n")
		}
		GuiControl,, % this.hEDselected, % showStr    ;编辑框
	}
}

;=======================================================================================================================
;WTF文件操作类 |
;===============
Class WTFDataStorage extends FileDataStorage
{
	static src := {}                 ;源集合
	static tars := {}                ;多目标集合
	static status := {}              ;数据整体状态
	static options := {synMod:"/d"}  ;数据控制选项
	
	;扫描给定的WTF目录,返回items
	UpdateData(dataIndex, dataPath)
	{
		dataItem := this.dataItems[dataIndex]    ;当前操作的WTF
		dataItem.items := {}
		i := 0
		Loop, Files, % dataPath "\*", D    ;在文件夹WTF\Account内循环
		{
			account := A_LoopFileName    ;账号文件夹名称
			accountRealPath := this.GetMklinkInfo(A_LoopFileLongPath "\SavedVariables").realPath    ;账号真实地址
			lua := new WowAddOnSavedLua(A_LoopFileLongPath "\SavedVariables\PlayerInfo.lua", "Obj")    ;加载职业信息lua
			Loop, Files, % A_LoopFileLongPath "\*", D    ;某账号内循环
			{
				if ((realm := A_LoopFileName) = "SavedVariables")    ;账号的
					continue
				Loop, Files, % A_LoopFileLongPath "\*", D    ;某服务器内循环
				{
					if ((player := A_LoopFileName) = "(null)")    ;角色
						continue
					mklinkInfo := this.GetMklinkInfo(A_LoopFileLongPath)
					i++
					dataItem.items[i] := {index            : i                                                       ;序号
									    , account          : account                                                 ;账号
									    , realm            : realm                                                   ;服务器
									    , player           : player                                                  ;角色
									    , playerClass      : lua.Get([player "-" realm, "class"]).Value              ;职业
									    , WTFpath          : dataPath                                                ;wtf路径
									    , accountRealPath  : accountRealPath                                         ;账号真实路径
									    , playerRealPath   : mklinkInfo.realPath                                     ;角色真实路径
										, playerIsReparse  : mklinkInfo.isReparse                                    ;角色是链接
									    , WTFIndex         : this.dataIndex}                                         ;所在WTF编号(隐藏属性)
					, dataItem.items[i].playerClassIndex   := GetWoWClass(dataItem.items[i].playerClass).index       ;职业序号
					, dataItem.items[i].playerClassCNShort := GetWoWClass(dataItem.items[i].PlayerClass).nameCNShort ;职业
				}
			}
			lua := ""    ;释放
		}
	}

	;更新选中两边文件的数量(需要先更新好控制信息switch):
	;status.pathCrashStr := ""       ;地址碰撞记录str
	;status.classNotSameStr := ""    ;职业不一致记录str
	;status.countAccount
	;status.countPlayer
	;status.countForOneTarget
	;status.countForAllTarget
	UpdateStatus(status, options)
	{
		;源 地址补齐
		this.src.accountPath := this.src.WTFpath "\" this.src.Account    ;源账号完整地址
		this.src.playerPath := this.src.accountPath "\" this.src.realm "\" this.src.player   ;源角色完整地址
		;目标 地址补齐
		status.pathCrashStr := ""    ;地址碰撞记录str
		status.classNotSameStr := ""    ;职业不一致记录str
		for i, tar in this.tars
		{
			tar.AccountPath := tar.WTFPath "\" tar.Account    ;目标账号完整地址
			tar.PlayerPath := tar.AccountPath "\" tar.Realm "\" tar.Player   ;目标角色完整地址
			if (options.cmd = "copyRaw")    ;向左复制 检测路径是否重复
			{
				tar.customAccountPath := options.customWTFPath "\" options.customName    ;自定义目标账号完整地址
				tar.customPlayerPath := tar.customAccountPath "\" tar.Realm "\" tar.Player   ;自定义目标角色完整地址
				if FileExist(tar.customPlayerPath)    ;碰撞
					status.pathCrashStr .= tar.Player "-" tar.Realm "@" tar.Account "; "    ;增加到碰撞列表
			}
			else if this.src.playerClassCNShort    ;覆盖/同步 检测职业是否一致
			{
				if (tar.playerClassCNShort and tar.playerClassCNShort <> this.src.playerClassCNShort)    ;职业不同
					status.classNotSameStr .= tar.playerClassCNShort " " tar.Player "-" tar.Realm "(" tar.Account "); "
			}
		}
		
		;模拟运行一次, 计算出单次"复制"操作的文件量
		;账号
		status.countAccount := 0
		if (options.cmd = "copyRaw")    ;向左复制
		{
			tar := this.tars[1]
			Loop, Files, % tar.AccountPath "\*", DF    ;目标文件夹内循环
			{
				if (Instr(A_LoopFileAttrib, "D") and A_LoopFileName <> "SavedVariables")       ;跳过"服务器"文件夹
					continue
				status.countAccount += FilesCountEx(A_LoopFileLongPath)
			}
		}
		else    ;覆盖/同步
		{
			Loop, Files, % this.src.AccountPath "\*", DF    ;源账号文件夹内循环
			{
				if (Instr(A_LoopFileAttrib, "D") and A_LoopFileName <> "SavedVariables")       ;跳过"服务器"文件夹
					continue
				if (options.cmd = "copy")
				and ((options.SWa1 <> 1 and A_LoopFileName = "SavedVariables")             ;账号插件
				or (options.SWa2 <> 1 and InStr(A_LoopFileName, "config-cache."))          ;账号系统
				or (options.SWa3 <> 1 and InStr(A_LoopFileName, "bindings-cache."))        ;账号按键
				or (options.SWa4 <> 1 and InStr(A_LoopFileName, "macros-cache.")))         ;账号宏
					continue    ;跳过
				Switch options.cmd
				{
				Case "copy" : status.countAccount += FilesCountEx(A_LoopFileLongPath) * (options.backup + 1)
				Case "syn"  : status.countAccount += FilesCountEx(A_LoopFileLongPath) * options.backup + 1
				}
			}
			if (options.modifyLua == 1 and (options.SWa1 == 1 or options.cmd = "syn"))    ;账号Lua修改
				status.countAccount += FilesCountEx(this.src.AccountPath "\SavedVariables\*.lua")	
		}
		;角色
		status.countPlayer := 0
		status.countPlayer += (options.cmd = "copyRaw" or options.backup) ? FilesCountEx(this.tars[1].PlayerPath) : 0    ;备份或者向左复制
		if (options.cmd = "syn")    ;同步
			status.countPlayer += 1
		else    ;覆盖
		{
			Loop, Files, % this.src.PlayerPath "\*", DF    ;角色文件夹内循环
			{
				if (options.SWp1 <> 1 and A_LoopFileName = "SavedVariables")           ;角色插件
				or (options.SWp1 <> 1 and A_LoopFileName = "AddOns.txt")               ;角色插件 开关状态
				or (options.SWp2 <> 1 and InStr(A_LoopFileName, "config-cache."))      ;角色系统	
				or (options.SWp2 <> 1 and A_LoopFileName = "layout-local.txt")         ;角色系统 头像位置
				or (options.SWp2 <> 1 and A_LoopFileName = "chat-cache.txt")           ;角色系统 聊天框
				or (options.SWp2 <> 1 and InStr(A_LoopFileName, "CUFProfiles.txt"))    ;角色系统 团队框架
				or (options.SWp3 <> 1 and InStr(A_LoopFileName, "bindings-cache."))    ;角色按键
				or (options.SWp4 <> 1 and InStr(A_LoopFileName, "macros-cache."))      ;角色宏
					continue    ;跳过
				status.countPlayer += FilesCountEx(A_LoopFileLongPath)
			}
			if (options.modifyLua == 1 and options.SWp1 == 1)    ;角色Lua修改
				status.countPlayer += FilesCountEx(this.src.PlayerPath "\SavedVariables\*.lua")
		}
		;单次复制总量
		status.countForOneTarget := status.countAccount + status.countPlayer
		;全部复制的总量
		status.countForAllTarget := status.countForOneTarget * this.tars.Count()
	}
	
	;生成备份信息文件
	AddBackUpInfoFile(backupWTFPath)
	{
		if (this.options.backup == 1 and this.options.cmd <> "copyRaw")    ;开启了备份 同时 非向左复制
		{
			FileCreateDir, % this.options.backupPath := backupWTFPath "\Account@" this.options.timestamp    ;当前备份文件夹
			IniWrite, % this.tars[1].WTFPath, % this.options.backupInfoIniPath := this.options.backupPath "\BackUpInfo.ini", Info, wtfPath    ;写入ini
		}
	}
	
	;复制/同步账号(不含角色)
	CopyOrSynAccount(src, tar, options)
	{
		if not InStr(this.status.doneAccountList, tar.AccountPath)    ;目标账号与源账号不同 且 首次操作该目录时
		{
			this.status.doneAccountList .= tar.AccountPath "`r`n"    ;添加进记录
			;向左复制
			if (options.cmd = "copyRaw")    
			{
				Loop, Files, % tar.AccountPath "\*", DF    ;目标文件夹内循环
				{
					if (Instr(A_LoopFileAttrib, "D") and A_LoopFileName <> "SavedVariables")       ;跳过"服务器"文件夹
						continue
					this.FilesCopy(A_LoopFileLongPath, tar.customAccountPath "\" A_LoopFileName, "复制")    ;强力复制
				}
				return
			}
			;覆盖/同步
			Loop, Files, % src.AccountPath "\*", DF    ;源账号文件夹内循环
			{
				if (Instr(A_LoopFileAttrib, "D") and A_LoopFileName <> "SavedVariables")       ;跳过"服务器"文件夹
					continue
				if (options.cmd = "copy")
				and ((options.SWa1 <> 1 and A_LoopFileName = "SavedVariables")             ;账号插件
				or (options.SWa2 <> 1 and InStr(A_LoopFileName, "config-cache."))          ;账号系统
				or (options.SWa3 <> 1 and InStr(A_LoopFileName, "bindings-cache."))        ;账号按键
				or (options.SWa4 <> 1 and InStr(A_LoopFileName, "macros-cache.")))         ;账号宏
					continue    ;跳过
				if (options.backup == 1)    ;备份
				{
					this.FilesCopy(tar.AccountPath "\" A_LoopFileName, options.backupPath "\" tar.Account "\" A_LoopFileName, "备份")    ;强力复制
					IniWrite, 1, % options.backupInfoIniPath, Account, % tar.Account    ;写入ini 
				}
				Switch options.cmd
				{
				Case "copy": this.FilesCopy(A_LoopFileLongPath, tar.AccountPath "\" A_LoopFileName, "复制")    ;强力复制
				Case "syn" : this.Mklink(tar.AccountPath "\" A_LoopFileName, A_LoopFileLongPath, "软连接", options.synMod)    ;链接目录
				}
			}
		}
		if (options.cmd <> "copyRaw" and options.modifyLua == 1 and (options.SWa1 == 1 or options.cmd = "syn"))    ;账号Lua修改
			ChangeLuaProfileKeys(tar.AccountPath "\SavedVariables\*.lua", [src.Player, src.Realm, tar.Player, tar.Realm], this.status)    ;文件修改
	}
	
	;复制/同步角色
	CopyOrSynPlayer(src, tar, options)
	{
		if (options.cmd = "copyRaw")    ;向左复制 直接返回
			return this.FilesCopy(tar.PlayerPath, tar.customPlayerPath, "复制")    ;强力复制
		if (options.backup == 1)    ;备份
		{
			this.FilesCopy(tar.PlayerPath, options.backupPath "\" tar.Account "\" tar.Realm "\" tar.Player, "备份")    ;强力复制
			IniWrite, 1, % options.backupInfoIniPath, Player, % tar.Player "-" tar.Realm "@" tar.Account    ;写入ini 
		}
		if (options.cmd = "syn")    ;同步
			return this.Mklink(tar.PlayerPath, src.PlayerPath, "软连接", options.synMod)    ;链接目录
		Loop, Files, % src.PlayerPath "\*", DF    ;角色文件夹内循环
		{
			if (options.SWp1 <> 1 and A_LoopFileName = "SavedVariables")           ;角色插件
			or (options.SWp1 <> 1 and A_LoopFileName = "AddOns.txt")               ;角色插件 开关状态
			or (options.SWp2 <> 1 and InStr(A_LoopFileName, "config-cache."))      ;角色系统	
			or (options.SWp2 <> 1 and A_LoopFileName = "layout-local.txt")         ;角色系统 头像位置
			or (options.SWp2 <> 1 and A_LoopFileName = "chat-cache.txt")           ;角色系统 聊天框
			or (options.SWp2 <> 1 and InStr(A_LoopFileName, "CUFProfiles.txt"))    ;角色系统 团队框架
			or (options.SWp3 <> 1 and InStr(A_LoopFileName, "bindings-cache."))    ;角色按键
			or (options.SWp4 <> 1 and InStr(A_LoopFileName, "macros-cache."))      ;角色宏
				continue    ;跳过
			this.FilesCopy(A_LoopFileLongPath, tar.PlayerPath "\" A_LoopFileName, "复制")    ;强力复制
		}
		if (options.modifyLua == 1 and options.SWp1 == 1)    ;角色Lua修改
			ChangeLuaPlayerName(tar.PlayerPath "\SavedVariables\*.lua", [src.Player, src.Realm, tar.Player, tar.Realm], this.status)    ;修改Lua
	}
	
	;批量复制/同步角色
	CopyOrSynPlayers()
	{
		src := WTF.src
		this.status.doneAccountList := ""    ;账号列表清空
		for i, tar in WTF.tars
		{
			this.status.count := this.status.countForOneTarget * (i - 1)    ;进度重新校准
			this.status.player_realm := tar.Player "-" tar.Realm
			this.status.playerClassIndex := tar.playerClassIndex
			if (src.PlayerPath = tar.PlayerPath)    ;跳过完全相同的角色
			{
				this.status.log := "与源角色重复,跳过..."
				continue
			}
			this.CopyOrSynAccount(src, tar, this.options)    ;复制/同步账号
			this.CopyOrSynPlayer(src, tar, this.options)     ;复制/同步角色
			;检查目标账号,角色状态
		}
		if this.options.generateLog    ;生成日志
			this.options.lastLogPath := this.GenerateLogFile("index:" this.status.count "`r`n" this.status.logs)
		else
			this.options.lastLogPath := ""
	}
	
	;生成操作日志文件
	GenerateLogFile(txt := "")
	{
		FileCreateDir, % this.options.logsPath "\Logs"
		FileAppend, % txt, % this.options.lastLogPath := this.options.logsPath "\Logs\" this.options.timestamp ".log", UTF-8
		return this.options.lastLogPath
	}
}

;返回职业有关信息
GetWoWClass(str)
{
	static base := []
	str := (str == "") ? "null" : str   ;空值时补一个null直接返回
	;之前查找过,有存储信息的直接返回
	if base[str]
		return base[str]
	;存储信息里没有的
	static info := {0:{index:0, color:0xE8E8E8, colorBG:0x000000}   ;默认返回
		,1: {index:1,  name:"Warrior",     nameCN:"战士",     nameCNShort:"ZS", color:0xC79C6E, colorBG:0x000000}     ;ZS
		,2: {index:2,  name:"Mage",        nameCN:"法师",     nameCNShort:"FS", color:0x69CCF0, colorBG:0x000000}     ;FS
		,3: {index:3,  name:"Rogue",       nameCN:"潜行者",   nameCNShort:"DZ", color:0xFFF569, colorBG:0x000000}     ;DZ
		,4: {index:4,  name:"Priest",      nameCN:"牧师",     nameCNShort:"MS", color:0xFFFFFF, colorBG:0x000000}     ;MS
		,5: {index:5,  name:"Paladin",     nameCN:"圣骑士",   nameCNShort:"QS", color:0xF58CBA, colorBG:0x000000}     ;QS
		,6: {index:6,  name:"Shaman",      nameCN:"萨满祭司", nameCNShort:"SM", color:0x0070DE, colorBG:0xFFFFFF}     ;SM
		,7: {index:7,  name:"Druid",       nameCN:"德鲁伊",   nameCNShort:"XD", color:0xFF7D0A, colorBG:0x000000}     ;XD
		,8: {index:8,  name:"Hunter",      nameCN:"猎人",     nameCNShort:"LR", color:0xABD473, colorBG:0x000000}     ;LR
		,9: {index:9,  name:"Warlock",     nameCN:"术士",     nameCNShort:"SS", color:0x9482C9, colorBG:0xFFFFFF}     ;SS
		,10:{index:10, name:"DeathKnight", nameCN:"死亡骑士", nameCNShort:"DK", color:0xC41F3B, colorBG:0xFFFFFF}     ;DK
		,11:{index:11, name:"Monk",        nameCN:"武僧",     nameCNShort:"WS", color:0x00FF96, colorBG:0x000000}     ;WS
		,12:{index:12, name:"DemonHunter", nameCN:"恶魔猎手", nameCNShort:"DH", color:0xA330C9, colorBG:0xFFFFFF}}    ;DH
	;null时返回默认值
	if (str = "null")
		return base[str] := info[0]
	;info中搜索信息
	for i, m in info
	{
		for k, n in m
		{
			if (n = str)
			{
				return base[str] := m
			}
		}
	}
}

;WoW配置快速复制专用函数，快速替换lua中角色名和服务器名
;需要类#Include <Class_WowAddOnSavedLua_Fast>
;filePaths可带通配符, o结构为[源角色名,源服务器名,目标角色名,目标服务器名], record为记录信息对象
ChangeLuaPlayerName(filePaths, o, status := "")  
{
	OldBatchLines := A_BatchLines 
	SetBatchLines, -1  ; 让操作以最快速度运行.
    Loop, Files, % filePaths    ;文件循环
    {
		;记录更新
		try status.count++
		;修改文件
		lua := new WowAddOnSavedLua_Fast(A_LoopFileLongPath)
		if (lua = "ERROR")    ;加载错误跳过
			continue
		options := [["""" o[1] """"            , """" o[3] """"           ]    ;"角色"
				   ,["""" o[1]  "-"  o[2] """" , """" o[3]  "-"  o[4] """"]    ;"角色-服务器"
				   ,["""" o[1] " - " o[2] """" , """" o[3] " - " o[4] """"]    ;"角色 - 服务器"
				   ,["""" o[2]  "-"  o[1] """" , """" o[4]  "-"  o[3] """"]    ;"服务器-角色"
				   ,["""" o[2] " - " o[1] """" , """" o[4] " - " o[3] """"]]   ;"服务器 - 角色"
		if lua.StrReplaceBatch(options) > 0    ;批量替换
		{
			lua.WriteToFile()
			try status.log := "修改文件:" A_LoopFileLongPath    ;记录更新
			try status.logs .= "[修改]文件修改`t地址:" A_LoopFileLongPath "`r`n"    ;记录更新
		}
		lua := ""    ;释放内存
    }
	SetBatchLines %OldBatchLines%   ;恢复速度
}

;WoW插件配置的预设档新增    
;需要类#Include <Class_WowAddOnSavedLua_Fast>
;filePaths可带通配符, o结构为[源角色名,源服务器名,目标角色名,目标服务器名], record为记录信息对象
ChangeLuaProfileKeys(filePaths, o, status := "")
{
	OldBatchLines := A_BatchLines 
	SetBatchLines, -1  ; 让操作以最快速度运行.
    Loop, Files, % filePaths    ;文件循环
    {
		;记录更新
		try status.count++   
		;修改文件
		lua := new WowAddOnSavedLua_Fast(A_LoopFileLongPath)
		if (lua = "ERROR")    ;加载错误跳过
			continue
		if not (pos1 := lua.InStr("`r`n`t[""profileKeys""] = {"))    ;不存在key时跳过
			continue
		if not (pos2 := lua.InStr("`r`n`t},",, pos1))    ;不存在},时跳过(正常是不会发生)
			continue
		midText := SubStr(lua.text, pos1, pos2 - pos1 + 4)    ;中间段
		if not RegExMatch(midText, "i)\t\t\[""(" o[1] "|" o[2] ").*(" o[1] "|" o[2] ")""] = .*\r\n", matchLine)    ;匹配出行
			continue
		if RegExMatch(midText, "i)\t\t\[""(" o[3] "|" o[4] ").*(" o[3] "|" o[4] ")""] = .*\r\n", matchLine2)    ;存在目标key
			midText := StrReplace(midText, matchLine2, "")    ;删除目标
		newLine := StrReplace(matchLine, o[1], o[3],,1)   ;替换角色 只替换一次
		newLine := StrReplace(newLine, o[2], o[4],,1)   ;替换服务器 只替换一次
		newMidText := StrReplace(midText, matchLine, matchLine . newLine)    ;返回被替换的值
		if (newMidText <> matchLine)    ;中间段发生变化后
		{
			lua.text := SubStr(lua.text, 1, pos1 - 1) . newMidText . SubStr(lua.text, pos2 + 4)    ;重新拼合
			lua.WriteToFile()
			try status.log := "修改文件:" A_LoopFileLongPath    ;记录更新
			try status.logs .= "[修改]文件修改`t地址:" A_LoopFileLongPath "`r`n"    ;记录更新
		}
		lua := midText := newMidText := ""    ;释放内存
    }
	lua := midText := newMidText := ""    ;释放内存
	SetBatchLines %OldBatchLines%   ;恢复速度
}