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
	
	;在MainGui的TAB上:
	;备份设置
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 ym+25 w590 h75, % "设定"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light

	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Button, xp+10 yp+20 w95 h22 Disabled Section, WTF备份路径
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, x+0 yp hp w455 ReadOnly vvWTF_EDbackupPath, 
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvWTF_BTopenPath3 hwndhWTF_BTopenPath3 ggWTF_BTopenPath, ; 打开目录
	ImageButton.Create(hWTF_BTopenPath3, [0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"])
	
	Gui, MainGui:Add, Checkbox, xs y+5 hp AltSubmit vini_WTF_ifBackUp, % "备份目标角色文件"
	GuiControl,, ini_WTF_ifBackUp, % INI.Init("WTF", "ifBackUp", 1)    ;初始化
	
	Gui, MainGui:Add, Checkbox, x+5 yp hp AltSubmit Section vini_WTF_ifModLua, % "替换文件中的角色名"
	GuiControl,, ini_WTF_ifModLua, % INI.Init("WTF", "ifModLua", 1)    ;初始化
	
	Gui, MainGui:Add, Checkbox, x+5 yp hp AltSubmit vini_WTF_cLV ggWTF_CBcLV, % "彩色列表"    ;是否开启颜色
	GuiControl,, ini_WTF_cLV, % INI.Init("WTF", "cLV", 1)    ;颜色开始初始化
	
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
	ImageButton.Create(hWTF_BTopenPath1, [0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"])
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Button, x+0 yp w95 hp vvWTF_BTtarWowPath hwndhWTF_BTtarWowPath ggWTF_BTtarScanPath, 魔兽世界路径
	ImageButton.Create(hWTF_BTtarWowPath, IB_Opts*)   ;彩色按钮
	
	
	
	Gui, MainGui:Add, Button, xs y+2 w95 h22 Section vvWTF_BTsrcSavedPath hwndhWTF_BTsrcSavedPath ggWTF_BTsrcScanPath, 自定义存储路径
	ImageButton.Create(hWTF_BTsrcSavedPath, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, x+0 yp hp w528 ReadOnly vvWTF_EDsavedPath, 
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvWTF_BTopenPath2 hwndhWTF_BTopenPath2 ggWTF_BTopenPath, ;"打开目录"
	ImageButton.Create(hWTF_BTopenPath2, [0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"])
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
	Gui, MainGui:Add, Text, xs y+5 w40 hp Center, 源角色
	Gui, MainGui:Add, Edit, x+0 yp-2 w270 hp ReadOnly vvWTF_EDSrcSelected hwndhWTF_EDSrcSelected,
	Gui, MainGui:Add, Edit, x+120 yp w260 hp ReadOnly vvWTF_EDTarSelected hwndhWTF_EDTarSelected,
	Gui, MainGui:Add, Text, x+0 yp+2 w50 hp Center, 目标角色
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	
	

	;左侧 LV
	Gui, MainGui:Add, ListView, xm+10 y+1 w310 h330 Section Count500 -Multi Grid AltSubmit HwndhWTF_LVSrc ggLVSrc, ❤|职业|角色|服务器|账号|Index|WTFIndex
	global cLVSrc := New LV_Colors(hWTF_LVSrc,,0)    ;LV上色(弊端:无法拖动排序了,需要拦截点击标题栏动作,然后重新绘色)
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
	Gui, MainGui:Add, Button, x+5 ys-25 w110 h22 vvWTF_BTclean ggWTF_BTclean hwndhWTF_BTclean Disabled, 全 职 业    ;恢复全部职业
	ImageButton.Create(hWTF_BTclean, [0,0xE1E1E1,,"red",,,0xADADAD],[,0xE5F1FB],[,0xCCE4F7],[,0xCCCCCC,,0x838383])   ;红字的默认按钮
	
	;配置覆盖选项
	Gui, MainGui:Add, GroupBox, xp y+5 w110 h245, % "复制模式"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Checkbox, xp+10 yp+20 w90 h20 AltSubmit vini_WTF_optionA1, % "账号插件配置"
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
	Gui, MainGui:Add, Button, xp y+5 w90 h50 vvWTF_BTcopy hwndhWTF_BTcopy ggWTF_BTCopyOrSyn Disabled, % "配置复制`n> > > >"
	ImageButton.Create(hWTF_BTcopy, IB_Opts2*)   ;彩色按钮
	
	Gui, MainGui:Add, GroupBox, xp-10 y+15 w110 h85, % "同步模式"
	
	Gui, MainGui:Add, Button, xp+10 yp+23 w90 h50 vvWTF_BTsyn hwndhWTF_BTsyn ggWTF_BTCopyOrSyn Disabled, % "配置同步`n< < < <"
	ImageButton.Create(hWTF_BTsyn, IB_Opts2*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	
	
	;右侧 LV
	Gui, MainGui:Add, ListView, x+15 ys w310 h330 Count500 Grid AltSubmit hwndhWTF_LVTar ggLVTar , ❤|职业|角色|服务器|账号|Index|WTFIndex
	global cLVTar := New LV_Colors(hWTF_LVTar,,0)    ;LV上色(弊端:无法拖动排序了,需要拦截点击标题栏动作,然后重新绘色)
	;为LV增加图片列表
	ImageListID := IL_Create(12)  ; 创建加载 12 个小图标的图像列表.
	LV_SetImageList(ImageListID)  ; 把上面的图像列表指定给当前的 ListView.
	;加载ico图标成位图并加载图片到图像列表里
	Loop 12
	{
		IL_Add(ImageListID, "HBITMAP:*" hBitMapClass%A_Index%)	
	}
	
	;左边控件封装进类
	global SRCGui := new WTFGUIGroup(WTF                                          ;WTF类
									, hWTF_LVSrc                                  ;LV句柄
									, cLVSrc                                      ;LV颜色
									, hWTF_EDSrcSelected                          ;ED已选择句柄
									, hWTF_EDsrcInclude                           ;ED筛选包含
									, hWTF_EDSrcExclude                           ;ED筛选排除
									, INI.Init("WTF", "srcScanPathSwitch", 0))    ;路径选择开关状态
	
	;右边控件封装进类
	global TARGui := new WTFGUIGroup(WTF                                          ;WTF类
									, hWTF_LVTar                                  ;LV句柄
									, cLVTar                                      ;LV颜色
									, hWTF_EDTarSelected                          ;ED已选择句柄
									, hWTF_EDtarInclude                           ;ED筛选包含
									, hWTF_EDtarExclude                           ;ED筛选排除
									, INI.Init("WTF", "tarScanPathSwitch", 0))    ;路径选择开关状态
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_WTF:
	;当前WTF目录刷新
	WTFGUIGroup.wowWTFPath    := WOW_EDITION ? (WOW_PATH    "\" WOW_EDITION "\WTF") : ""         ;魔兽wtf路径
	WTFGUIGroup.savedWTFPath  := WOW_EDITION ? (SAVED_PATH  "\" WOW_EDITION "\WTF") : ""         ;自定义存储wtf路径
	WTFGUIGroup.backupWTFPath := WOW_EDITION ? (BACKUP_PATH "\" WOW_EDITION "\WTF") : ""         ;备份wtf路径
	GuiControl,, vWTF_EDwowPath,    % WTFGUIGroup.wowWTFPath        ;wow路径
	GuiControl,, vWTF_EDsavedPath,  % WTFGUIGroup.savedWTFPath      ;自定义存储路径
	GuiControl,, vWTF_EDbackupPath, % WTFGUIGroup.backupWTFPath     ;WTF备份路径
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
	if (vWTF_EDwowPath <> WOW_PATH "\" WOW_EDITION)    ;魔兽地址发生变化时,重新初始化
	or (vWTF_EDsavedPath <> SAVED_PATH "\" WOW_EDITION)    ;自定义地址发生变化时,重新初始化
	{
		gosub, CleanItems
		gosub, GuiInit_WTF
	}
return

;清空源项目与目标项目
CleanItems:
	WTF.WTFpath := ""        ;当前扫描的WTF路径
	WTF.items := {}          ;WTF内全部角色集合
	WTF.itemsFilter := {}    ;WTF内筛选的角色集合(与items同对象)
	WTF.src := {}            ;源集合
	WTF.tars := {}           ;多目标集合
	GuiControl,, vWTF_EDSrcSelected,    ;左编辑框
	GuiControl,, vWTF_EDTarSelected,    ;右编辑框
	GuiControl, Disable, vWTF_BTcopy    ;复制按钮
	GuiControl, Disable, vWTF_BTsyn    ;同步按钮
return

;=======================================================================================================================
;路径切换及扫描 |
;================
;切换路径 左
gWTF_BTsrcScanPath:
	Gui MainGui:+Disabled	;主窗口禁用
	Gui, MainGui:Submit, NoHide
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
	SRCGui.WTFIndex := WTF.AddPath(SRCGui.WTFpathSwitch ? WTFGUIGroup.savedWTFPath : WTFGUIGroup.wowWTFPath)    ;新建WTF类,路径扫描
	gosub, gWTF_EDsrcFilter    ;筛选动作
	Gui MainGui:-Disabled	;主窗口启用
return


;切换路径 右
gWTF_BTtarScanPath:
	Gui MainGui:+Disabled	;主窗口禁用
	Gui, MainGui:Submit, NoHide
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
	TARGui.WTFIndex := WTF.AddPath(TARGui.WTFpathSwitch ? WTFGUIGroup.savedWTFPath : WTFGUIGroup.wowWTFPath)    ;新建WTF类,路径扫描
	gosub, gWTF_EDtarFilter    ;筛选动作
	Gui MainGui:-Disabled	;主窗口启用
return


;打开路径
gWTF_BTopenPath:
	Switch A_GuiControl
	{
	Case "vWTF_BTopenPath1":
		GuiControlGet, path,, vWTF_EDwowPath    ;wow路径
	Case "vWTF_BTopenPath2":
		GuiControlGet, path,, vWTF_EDsavedPath    ;自定义存储路径
	Case "vWTF_BTopenPath3":
		GuiControlGet, path,, vWTF_EDbackupPath    ;WTF备份路径
	Default:
	}
	if InStr(FileExist(path), "D")
		Run % path
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
;筛选 |
;=====
;筛选框左
gWTF_EDsrcFilter:
	Gui MainGui:+Disabled
	SRCGui.UpdataLV()    ;LV刷新
	Gui MainGui:-Disabled
return

;筛选框右
gWTF_EDtarFilter:
	Gui MainGui:+Disabled	
	TARGui.UpdataLV()    ;LV刷新
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
	WTFGUIGroup.classIndex := SubStr(A_GuiControl, 13)
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
	WTFGUIGroup.classIndex := 0
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
	WTFGUIGroup.switchLVColor := ini_WTF_cLV   ;颜色开关
	SRCGui.UpdataLVColor()
	TARGui.UpdataLVColor()
return

;=======================================================================================================================
;LV控件 |
;========
;LV列表动作 左
gLVSrc:
	Gui MainGui:+Disabled	;主窗口禁用
	Switch A_GuiEvent
	{
	;点击了标题栏
	Case "ColClick":
		if (A_EventInfo == 1)
			LV_ModifyCol(2, "SortDesc")
		SRCGui.UpdataLVColor()
	;项目发生了变化
	Case "I":
		WTF.src := SRCGui.UpdataLVSelected()[1]
		;覆盖/同步按钮的激活控制
		GuiControl, % "Enable" (WTF.src && WTF.tars[1]), vWTF_BTcopy ;列表同时选取了两侧的选择了文件，按钮才会显示出来
		GuiControl, % "Enable" (WTF.src && WTF.tars[1]), vWTF_BTsyn ;列表同时选取了两侧的选择了文件，按钮才会显示出来
	;其他情况
	Default:
	}
	Gui MainGui:-Disabled	;主窗口启用
return


;LV列表动作 右
gLVTar:
	Gui MainGui:+Disabled	;主窗口禁用
	Switch A_GuiEvent
	{
	;点击了标题栏
	Case "ColClick":
		if (A_EventInfo == 1)
			LV_ModifyCol(2, "SortDesc")
		TARGui.UpdataLVColor()
	;项目发生了变化
	Case "I":
		WTF.tars := TARGui.UpdataLVSelected()
		;覆盖/同步按钮的激活控制
		GuiControl, % "Enable" (WTF.src && WTF.tars[1]), vWTF_BTcopy ;列表同时选取了两侧的选择了文件，按钮才会显示出来
		GuiControl, % "Enable" (WTF.src && WTF.tars[1]), vWTF_BTsyn ;列表同时选取了两侧的选择了文件，按钮才会显示出来
	;其他情况
	Default:
	}
	Gui MainGui:-Disabled	;主窗口启用
return

;=======================================================================================================================
;复制/同步动作(核心)|
;====================

;配置复制/同步
gWTF_BTCopyOrSyn:
	;发现魔兽窗口时返回
	if WinExist("ahk_exe Wow.exe") or WinExist("ahk_exe WowClassic.exe")
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 16,, 启动失败: 请关闭魔兽窗口后重试
		return
	}
	;向两者相同时错误返回
	if (WTF.tars.Count() == 1 and WTF.src.index == WTF.tars[1].index and WTF.src.WTFIndex == WTF.tars[1].WTFIndex)
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 16,, 错误！源角色与目标角色不能相同
		return
	}
	;职业匹配警告
	if WTF.src.playerClassCNShort
	{
		msgStr := ""
		for i, tar in WTF.tars
		{
			if (tar.playerClassCNShort and tar.playerClassCNShort <> src.playerClassCNShort)    ;职业不同
				msgStr .= tar.playerClassCNShort " " tar.Player "-" tar.Realm "(" tar.Account ")`r`n"
		}
		if msgStr
		{
			Gui, MainGui:+OwnDialogs ;各种对话框的从属
			MsgBox, 36,, % "警告！下列目标角色与源角色职业不一致,是否继续?`n`n" msgStr
			IfMsgBox No
				return
		}
	}
	;确认信息
	Gui, MainGui:Submit, NoHide
	MsgBoxTxt1 := "源角色:`n" vWTF_EDSrcSelected "`n`n目标角色:`n" vWTF_EDTarSelected "`n`n是否进行<<文件复制>>来实现配置的覆盖?`n`n请对重要设置进行备份!!!"
	MsgBoxTxt2 := "源角色:`n" vWTF_EDSrcSelected "`n`n目标角色:`n" vWTF_EDTarSelected "`n`n是否进行<<文件链接>>来实现配置的同步?`n`n请对重要设置进行备份!!!"
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	MsgBox, 52,, % (A_GuiControl = "vWTF_BTcopy") ? MsgBoxTxt1 : MsgBoxTxt2
	IfMsgBox Yes
	{
		Gui MainGui:+Disabled	;主窗口禁用
		OldBatchLines := A_BatchLines   ;保存当前运行速度设置
		SetBatchLines -1   ;全速运行
		
		;数据刷新
		WTF.status.index := 0                        ;进度指示
		, WTF.status.player_realm := ""              ;当前操作角色
		, WTF.status.playerClassIndex := 0           ;当前操作角色职业序号
		, WTF.status.action := ""                    ;当前动作
		, WTF.status.cmdList := ""                   ;指令清单
		, WTF.switch.modifyLua := ini_WTF_ifModLua   ;修改lua
		, WTF.switch.backup := ini_WTF_ifBackUp      ;备份
		, WTF.switch.SWp1 := ini_WTF_optionP1        ;账号控制
		, WTF.switch.SWp2 := ini_WTF_optionP2
		, WTF.switch.SWp3 := ini_WTF_optionP3
		, WTF.switch.SWp4 := ini_WTF_optionP4
		, WTF.switch.SWa1 := ini_WTF_optionA1        ;角色控制
		, WTF.switch.SWa2 := ini_WTF_optionA2
		, WTF.switch.SWa3 := ini_WTF_optionA3
		, WTF.switch.SWa4 := ini_WTF_optionA4
		, WTF.UpdataStatusCount()                    ;更新计数
		, WTF.AddBackUpInfoFile(BACKUP_PATH "\" WOW_EDITION "\WTF")          ;增加备份信息文件夹\文件
		;状态栏修改
		SB_SetParts(200, 150)                                                ;状态栏分3部分
		WTF.status.countForAllTarget
		SB_SetProgress(0, 1, "show Range0-" WTF.status.countForAllTarget)    ;状态栏上增加计时条
		SetTimer, UpdataSB, 50, 10000                                        ;状态栏更新线程开启
		;执行动作
		if (A_GuiControl = "vWTF_BTcopy")
		{
			WTF.CopyPlayers()    ;复制
		}
		else
			gosub, DoSyn         ;同步
		;状态栏恢复,输出结论
		SB_SetParts()
		SB_SetText("完成")
		SB_SetProgress(0, 1, "hide")                                         ;状态栏上计时条隐藏
		Clipboard :=  "index:" WTF_RECORD.index "`n`n" WTF.status.cmdList
		
		SetBatchLines %OldBatchLines%   ;恢复速度
		Gui MainGui:-Disabled	;主窗口启用
	}
return
;状态栏更新
UpdataSB:
	Gui, MainGui:Default
	SB_SetProgress(WTF.status.index, 1)       ;进度条变更
	classI := WTF.status.playerClassIndex
	SB_SetIcon("HBITMAP:*" hBitMapClass%classI%, 1, 2)
	SB_SetText(WTF.status.player_realm, 2)    ;当前角色
	SB_SetText(WTF.status.action, 3)          ;当前动作
return


;同步
DoSyn:
	;~ for i, tar in WTF_ITEMS_TARGETS    ;多目标
	;~ {
		;~ ;状态栏信息变更
		;~ WTF_RECORD.i := WTF_RECORD.countFull * (i - 1)    ;每个新角色重新校准
		;~ classI := GetWoWClass(tar.playerClass).index
		;~ SB_SetIcon("HBITMAP:*" hBitMapClass%classI%, 1, 2)
		;~ SB_SetText(tar.Player "-" tar.Realm, 2)    ;状态栏2显示变更
		;~ ;跳过完全相同的角色
		;~ if (src.PlayerPath = tar.PlayerPath)
		;~ {
			;~ WTF_RECORD.SBtext3 := "与源角色重复,跳过..."
			;~ continue
		;~ }
		;~ ;信息提示
		;~ SB_SetText("正在同步到" CharacterL "-" RealmL "...",2)
		;~ ;角色部分
		;~ IfNotEqual, ini_Settings_BackUPMod, 1, FileCopyDir, % AccountR[i] "\" RealmR[i] "\" CharacterR[i], % NowBakPath "\" RealmR[i] "\" CharacterR[i], 1    ;备份
		;~ FileRemoveDir, % AccountR[i] "\" RealmR[i] "\" CharacterR[i], 1    ;删除目标 账号\服务器\角色 文件夹
		;~ FileAppend, % "mklink /j " AccountR[i] "\" RealmR[i] "\" CharacterR[i] " " AccountL "\" RealmL "\" CharacterL, ahkmklink.bat    ;账号\服务器\角色  的目录联接
		;~ ;账号部分
		;~ if (AccountL!=AccountR[i])    ;不在同一账号下时
		;~ {	
			;~ IfNotEqual, ini_Settings_BackUPMod, 1, FileCopyDir, % AccountR[i] "\SavedVariables", % NowBakPath "\SavedVariables", 1    ;备份账号插件
			;~ IfNotEqual, ini_Settings_BackUPMod, 1, FileCopy, % AccountR[i] "\config-cache.wtf", % NowBakPath "\config-cache.wtf", 1    ;备份账号设置
			;~ IfNotEqual, ini_Settings_BackUPMod, 1, FileCopy, % AccountR[i] "\bindings-cache.wtf", % NowBakPath "\bindings-cache.wtf", 1    ;备份账号按键
			;~ IfNotEqual, ini_Settings_BackUPMod, 1, FileCopy, % AccountR[i] "\macros-cache.txt", % NowBakPath "\macros-cache.txt", 1    ;备份账号宏
			;~ FileRemoveDir, % AccountR[i] "\SavedVariables", 1    ;删除目标 账号\SavedVariables 文件夹（账号插件配置）
			;~ FileDelete, % AccountR[i] "\config-cache.wtf"    ;删除目标 账号设置
			;~ FileDelete, % AccountR[i] "\bindings-cache.wtf"    ;删除目标 按键设置
			;~ FileDelete, % AccountR[i] "\macros-cache.txt"    ;删除目标 宏设置
			;~ FileAppend, % "`r`nmklink /j " AccountR[i] "\SavedVariables " AccountL "\SavedVariables", ahkmklink.bat    ;账号\SavedVariables  的目录联接
			;~ FileAppend, % "`r`nmklink /h " AccountR[i] "\config-cache.wtf " AccountL "\config-cache.wtf", ahkmklink.bat    ;账号设置  的文件硬连接
			;~ FileAppend, % "`r`nmklink /h " AccountR[i] "\bindings-cache.wtf " AccountL "\bindings-cache.wtf", ahkmklink.bat    ;账号按键  的文件硬连接
			;~ FileAppend, % "`r`nmklink /h " AccountR[i] "\macros-cache.txt " AccountL "\macros-cache.txt", ahkmklink.bat    ;账号宏  的文件硬连接
		;~ }
		;~ ;生成联接文件（夹）
		;~ RunWait, ahkmklink.bat,, Hide    ;运行批处理文件(隐藏)
		;~ sleep, 1000
		;~ FileDelete, ahkmklink.bat    ;删除该批处理文件
		;~ ;LUA配置变更
		;~ WoW_ChgLuaProfileKeys(AccountL "\SavedVariables", CharacterR[i] " - " RealmR[i], CharacterL " - " RealmL) ;账号配置档变更
	;~ }
	MsgBox 同步完成
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
Class WTFGUIGroup
{
	static wowWTFPath := ""         ;魔兽wtf路径
	static savedWTFPath := ""       ;自定义存储wtf路径
	static backupWTFPath := ""      ;备份wtf路径
	static switchLVColor := true    ;列表颜色显隐开关
	static classIndex := 0          ;职业筛选
	
	__New(WTF, hLV, cLV, hEDselected, hEDinclude, hEDexclude, WTFpathSwitch := 1)
	{
		this.WTF := WTF
		, this.hLV := hLV
		, this.cLV := cLV
		, this.hEDselected     := hEDselected
		, this.hEDinclude      := hEDinclude
		, this.hEDexclude      := hEDexclude
		, this.WTFpathSwitch   := WTFpathSwitch    ;路径选取
		, this.WTFIndex        := 0    ;当前WTF表序号
		, this.lastWTFIndex    := 0
		, this.lastInclude     := ""
		, this.lastExclude     := ""
		, this.lastClassIndex  := -9999    ;保证首次使用时正常运行
	}
	
	;更新LV
	UpdataLV()
	{
		GuiControlGet, include,, % this.hEDinclude
		GuiControlGet, exclude,, % this.hEDexclude
		if (this.WTFIndex = lastWTFIndex)    ;WTF和之前一样
		and (include = this.lastInclude and exclude = this.lastExclude and this.classIndex = this.lastClassIndex)    ;筛选与上次相同直接不刷新返回0
			return
		else
			this.lastWTFIndex := this.WTFIndex, this.lastInclude := include, this.lastExclude := exclude, this.lastClassIndex := this.classIndex
		Gui, ListView, % this.hLV    ;选择操作表
		GuiControl, -Redraw, % this.hLV
		LV_Delete()
		for i, item in this.WTF.WTFItems[this.WTFIndex].items
		{
			if (this.classIndex and item.playerClassIndex and this.classIndex <> item.playerClassIndex)    ;筛选职业
				continue
			str := item.Account "`n" item.Realm "`n" item.Player    ;拼合成字串
			if (include <> "" and !InStr(str, include)) or (exclude <> "" and InStr(str, exclude))    ;筛选文字
				continue
			LV_Add("Icon" . item.playerClassIndex
			, 
			, item.playerClassCNShort
			, item.Player
			, item.Realm
			, item.Account
			, item.index
			, item.WTFIndex)
		}
		LV_ModifyCol(1, "AutoHdr NoSort")
		LV_ModifyCol(2, 0)
		LV_ModifyCol(3, "AutoHdr")
		LV_ModifyCol(4, "AutoHdr")
		LV_ModifyCol(5, "AutoHdr")
		LV_ModifyCol(6, 0)
		LV_ModifyCol(7, 0)
		if this.classIndex    ;职业筛选时进排序
			LV_ModifyCol(2, "SortDesc")
		this.UpdataLVColor()    ;更新列表颜色
		GuiControl, +Redraw, % this.hLV
	}
	
	;更新LV颜色
	UpdataLVColor()
	{
		this.cLV.OnMessage(False)
		if not WTFGUIGroup.switchLVColor
			return
		;开始绘色
		Gui, ListView, % this.hLV    ;选择操作表
		GuiControl, -Redraw, % this.hLV
		this.cLV.Clear()    ;先清空颜色
		Loop, % LV_GetCount()
		{
			LV_GetText(index,    A_index, 6)    ;序号
			LV_GetText(WTFIndex, A_index, 7)    ;WTF序号
			item := this.WTF.WTFItems[WTFIndex].items[index]
			;职业染色
			BCol := GetWoWClass(item.playerClass).color    ;默认背景颜色=职业颜色
			TCol := GetWoWClass(item.playerClass).colorBG    ;默认背景颜色=职业颜色背景色
			this.cLV.Cell(A_index, 3, BCol, TCol)
			this.cLV.Cell(A_index, 4, BCol, TCol)
			;链接染色
			if item.playerRealPath
				this.cLV.Cell(A_index, 5, 0x9C9C9C)
			else if item.accountRealPath
				this.cLV.Cell(A_index, 5, 0xCFCFCF)
			else
				this.cLV.Cell(A_index, 5, 0xE8E8E8)
		}
		this.cLV.OnMessage()
		GuiControl, +Redraw, % this.hLV
	}
	
	;添加LV信息到指定的编辑框中的动作
	UpdataLVSelected()
	{
		Gui, ListView, % this.hLV    ;选择操作表
		selected := []
		Loop
		{
			rowIndex := LV_GetNext(rowIndex)  ; 在前一次找到的位置后继续搜索.
			if not rowIndex  ; 上面返回零, 所以选择的行已经都找到了.
				break
			LV_GetText(index,    rowIndex, 6)    ;序号
			LV_GetText(WTFIndex, rowIndex, 7)    ;WTF序号
			selected.push(this.WTF.WTFItems[WTFIndex].items[index])
		}
		showStr := ""
		if (selected.Count() > 0)
		{
			for i, item in selected
			{
				showStr .= item.Player "-" item.Realm "(" item.Account (this.WTFpathSwitch ? "@自定义存储" : "@魔兽世界") "); `n"
			}
			Trim(showStr, "; `n")
		}
		GuiControl,, % this.hEDselected, % showStr    ;编辑框
		return selected    ;返回所选
	}	
}

;=======================================================================================================================
;WTF文件操作类 |
;===============
Class WTF
{
	static WTFItems := {}    ;历史WTF成员集合
	static WTFIndex := 0     ;当前WTF的index
	static src := {}         ;源集合
	static tars := {}        ;多目标集合
	static switch := {}      ;WTF开关集合
	static status := {}      ;WTF状态控制集合
	
	;新增WTF, 返回当前的WTFindex
	AddPath(WTFpath, force := false)
	{
		for i, WTFItem in this.WTFItems    ;在WTF历史中寻找
		{
			if (WTFItem.WTFpath == WTFpath)    ;这是历史中的WTF,则直接调用历史
			{
				this.WTFIndex := i
				this.ScanWTF(this.WTFIndex, WTFpath, force)
				return this.WTFIndex
			}
		}
		;历史中没有时就新建
		this.WTFIndex++
		this.WTFitems[this.WTFIndex] := {}
		this.ScanWTF(this.WTFIndex, WTFpath, force)
		return this.WTFIndex
	}
	
	;扫描给定的WTF目录,返回items
	ScanWTF(WTFIndex, WTFpath, force := false)
	{
		WTFItem := this.WTFItems[WTFIndex]    ;当前操作的WTF
		if (WTFpath = WTFItem.WTFpath and force = false)    ;与上次输入的相同时返回
			return
		WTFItem.WTFpath := WTFpath
		, WTFItem.items := {}
		if not InStr(FileExist(WTFpath "\Account"), "D")    ;目录错误时
			return
		i := 0
		Loop, Files, % WTFpath "\Account\*", D    ;在文件夹WTF\Account内循环
		{
			account := A_LoopFileName    ;账号文件夹名称
			accountRealPath := GetFolderMklinkInfo(A_LoopFileLongPath "\SavedVariables")    ;账号真实地址
			lua := new WowAddOnSavedLua(A_LoopFileLongPath "\SavedVariables\PlayerInfo.lua", "Obj")    ;加载职业信息lua
			Loop, Files, % A_LoopFileLongPath "\*", D    ;某账号内循环
			{
				if ((realm := A_LoopFileName) = "SavedVariables")    ;账号的
					continue
				Loop, Files, % A_LoopFileLongPath "\*", D    ;某服务器内循环
				{
					if ((player := A_LoopFileName) = "(null)")    ;角色
						continue
					i++
					WTFItem.items[i] := {index        :i          ;序号
									, account         :account    ;账号
									, realm           :realm      ;服务器
									, player          :player     ;角色
									, playerClass     :lua.Get([player "-" realm, "class"]).Value           ;职业
									, WTFpath         :WTFpath                                              ;wtf路径
									;~ , accountPath     :WTFpath "\Account\" account                          ;账号路径  留到解析里做
									;~ , playerPath      :WTFpath "\Account\" account "\" realm "\" player     ;角色路径  留到解析里做
									, accountRealPath :accountRealPath                                      ;账号真实路径
									, playerRealPath  :GetFolderMklinkInfo(A_LoopFileLongPath)              ;角色真实路径
									, WTFIndex        :this.WTFIndex}                                       ;所在WTF编号(隐藏属性)
					, WTFItem.items[i].playerClassIndex   := GetWoWClass(WTFItem.items[i].playerClass).index       ;职业序号
					, WTFItem.items[i].playerClassCNShort := GetWoWClass(WTFItem.items[i].PlayerClass).nameCNShort ;职业
				}
			}
			lua := ""    ;释放
		}
	}
	
	;复制账号(不含角色)
	CopyAccount(src, tar)
	{
		if (src.AccountPath <> tar.AccountPath) and not InStr(this.status.copiedAccountList, tar.AccountPath)    ;目标账号与源账号不同 且 首次复制该目录时
		{
			this.status.copiedAccountList .= tar.AccountPath "`r`n"    ;添加进记录
			Loop, Files, % src.AccountPath "\*", DF    ;源账号文件夹内循环
			{
				if (Instr(A_LoopFileAttrib, "D") and A_LoopFileName <> "SavedVariables")       ;跳过"服务器"文件夹
				or (this.switch.SWa1 <> 1 and A_LoopFileName = "SavedVariables")               ;账号插件
				or (this.switch.SWa2 <> 1 and InStr(A_LoopFileName, "config-cache."))          ;账号系统
				or (this.switch.SWa3 <> 1 and InStr(A_LoopFileName, "bindings-cache."))        ;账号按键
				or (this.switch.SWa4 <> 1 and InStr(A_LoopFileName, "macros-cache."))          ;账号宏
					continue    ;跳过
				if (this.switch.backup == 1)    ;备份
					this.FilesCopy(tar.AccountPath "\" A_LoopFileName, this.status.backupPath "\" tar.Account "\" A_LoopFileName, this.status, "备份")    ;强力复制
				this.FilesCopy(A_LoopFileLongPath, tar.AccountPath "\" A_LoopFileName, this.status, "复制")    ;强力复制
			}
		}
		if (this.switch.modifyLua == 1 and this.switch.SWa1 == 1)    ;账号Lua修改
			ChangeLuaProfileKeys(tar.AccountPath "\SavedVariables\*.lua", [src.Player, src.Realm, tar.Player, tar.Realm], this.status)    ;文件修改
	}
	
	;复制角色
	CopyPlayer(src, tar)
	{
		if (this.switch.backup == 1)    ;备份
			this.FilesCopy(tar.PlayerPath, this.status.backupPath "\" tar.Account "\" tar.Realm "\" tar.Player, this.status, "备份")    ;强力复制
		Loop, Files, % src.PlayerPath "\*", DF    ;角色文件夹内循环
		{
			if (this.switch.SWp1 <> 1 and A_LoopFileName = "SavedVariables")           ;角色插件
			or (this.switch.SWp1 <> 1 and A_LoopFileName = "AddOns.txt")               ;角色插件 开关状态
			or (this.switch.SWp2 <> 1 and InStr(A_LoopFileName, "config-cache."))      ;角色系统	
			or (this.switch.SWp2 <> 1 and A_LoopFileName = "layout-local.txt")         ;角色系统 头像位置
			or (this.switch.SWp2 <> 1 and A_LoopFileName = "chat-cache.txt")           ;角色系统 聊天框
			or (this.switch.SWp2 <> 1 and InStr(A_LoopFileName, "CUFProfiles.txt"))    ;角色系统 团队框架
			or (this.switch.SWp3 <> 1 and InStr(A_LoopFileName, "bindings-cache."))    ;角色按键
			or (this.switch.SWp4 <> 1 and InStr(A_LoopFileName, "macros-cache."))      ;角色宏
				continue    ;跳过
			this.FilesCopy(A_LoopFileLongPath, tar.PlayerPath "\" A_LoopFileName, this.status, "复制")    ;强力复制
		}
		if (this.switch.modifyLua == 1 and this.switch.SWp1 == 1)    ;角色Lua修改
			ChangeLuaPlayerName(tar.PlayerPath "\SavedVariables\*.lua", [src.Player, src.Realm, tar.Player, tar.Realm], this.status)    ;修改Lua
	}
	
	;批量复制角色
	CopyPlayers()
	{
		src := WTF.src
		this.status.copiedAccountList := ""    ;账号列表清空
		for i, tar in WTF.tars
		{
			this.status.index := this.status.countForOneTarget * (i - 1)    ;进度重新校准
			this.status.player_realm := tar.Player "-" tar.Realm
			this.status.playerClassIndex := tar.playerClassIndex
			if (src.PlayerPath = tar.PlayerPath)    ;跳过完全相同的角色
			{
				this.status.action := "与源角色重复,跳过..."
				continue
			}
			this.CopyAccount(src, tar)    ;复制账号
			this.CopyPlayer(src, tar)     ;复制角色
		}
	}
	
	;生成备份信息文件
	AddBackUpInfoFile(backupWTFPath)
	{
		if (this.switch.backup == 1)    ;开启了备份
		{
			FileCreateDir, % this.status.backupPath := backupWTFPath "\Account@" A_Now    ;当前备份文件夹
			FileAppend, % this.tars[1].WTFPath, % this.status.backupPath "\BackUpInfo.txt", UTF-8    ;保存目标所在WTF位置
		}
	}
	
	;更新选中两边文件的数量(需要先更新好控制信息switch):
	;this.status.countAccount
	;this.status.countPlayer
	;this.status.countForOneTarget
	;this.status.countForAllTarget
	UpdataStatusCount()
	{
		;源 地址补齐
		this.src.accountPath := this.src.WTFpath "\Account\" this.src.Account    ;源账号完整地址
		this.src.playerPath := this.src.accountPath "\" this.src.realm "\" this.src.player   ;源角色完整地址
		;目标 地址补齐
		for i, tar in this.tars
		{
			tar.AccountPath := tar.WTFPath "\Account\" tar.Account    ;目标账号完整地址
			tar.PlayerPath := tar.AccountPath "\" tar.Realm "\" tar.Player   ;目标角色完整地址
		}
		
		;模拟运行一次, 计算出单次"复制"操作的文件量
		;账号
		this.status.countAccount := 0
		Loop, Files, % this.src.AccountPath "\*", DF    ;源账号文件夹内循环
		{
			if (Instr(A_LoopFileAttrib, "D") and A_LoopFileName <> "SavedVariables")       ;跳过"服务器"文件夹
			or (this.switch.SWa1 <> 1 and A_LoopFileName = "SavedVariables")               ;账号插件
			or (this.switch.SWa2 <> 1 and InStr(A_LoopFileName, "config-cache."))          ;账号系统
			or (this.switch.SWa3 <> 1 and InStr(A_LoopFileName, "bindings-cache."))        ;账号按键
			or (this.switch.SWa4 <> 1 and InStr(A_LoopFileName, "macros-cache."))          ;账号宏
				continue    ;跳过
			this.status.countAccount += ((A_LoopFileName = "SavedVariables") ? FilesCount(A_LoopFileLongPath "\*") : 1) * (1 + this.switch.backup)
		}
		if (this.switch.modifyLua == 1 and this.switch.SWa1 == 1)    ;账号Lua修改
			this.status.countAccount += FilesCount(this.src.AccountPath "\SavedVariables\*.lua")	
		;角色
		this.status.countPlayer := 0
		if (this.switch.backup == 1)    ;备份
			this.status.countPlayer += FilesCount(this.src.PlayerPath "\*")
		Loop, Files, % src.PlayerPath "\*", DF    ;角色文件夹内循环
		{
			if (this.switch.SWp1 <> 1 and A_LoopFileName = "SavedVariables")           ;角色插件
			or (this.switch.SWp1 <> 1 and A_LoopFileName = "AddOns.txt")               ;角色插件 开关状态
			or (this.switch.SWp2 <> 1 and InStr(A_LoopFileName, "config-cache."))      ;角色系统	
			or (this.switch.SWp2 <> 1 and A_LoopFileName = "layout-local.txt")         ;角色系统 头像位置
			or (this.switch.SWp2 <> 1 and A_LoopFileName = "chat-cache.txt")           ;角色系统 聊天框
			or (this.switch.SWp2 <> 1 and InStr(A_LoopFileName, "CUFProfiles.txt"))    ;角色系统 团队框架
			or (this.switch.SWp3 <> 1 and InStr(A_LoopFileName, "bindings-cache."))    ;角色按键
			or (this.switch.SWp4 <> 1 and InStr(A_LoopFileName, "macros-cache."))      ;角色宏
				continue    ;跳过
			this.status.countPlayer += (A_LoopFileName = "SavedVariables") ? FilesCount(A_LoopFileLongPath "\*") : 1
		}
		if (this.switch.modifyLua == 1 and this.switch.SWp1 == 1)    ;角色Lua修改
			this.status.countPlayer += FilesCount(this.src.PlayerPath "\SavedVariables\*.lua")
		;单次复制总量
		this.status.countForOneTarget := this.status.countAccount + this.status.countPlayer
		;全部复制的总量
		this.status.countForAllTarget := this.status.countForOneTarget * this.tars.Count()
	}
	
	
	;文件(文件夹)复制, 带有状态变更
	FilesCopy(srcPath, tarPath, status, str := "复制", overWrite := "overWrite")
	{
		status.action := str "文件到:" tarPath
		status.cmdList .= "[" str "]文件复制`t源地址:" srcPath "`t目标地址:" tarPath "`r`n"
		status.index += FolderCopyEx(srcPath, tarPath, overWrite)    ;强力复制文件
	}
}

;获取文件数量(默认遍历所有子文件)
FilesCount(path, mod := "FR")
{
	count := 0
	Loop, Files, % path, % mod
		count++
	return count
}

;获取某文件夹的链接信息,链接失效时删除链接恢复为普通文件夹
GetFolderMklinkInfo(path)
{
	if not InStr(FileExist(path), "D")
		return
	if (isReparse := IsReparsePoint(path))    ;是否是联接目录 
	{
		if not (realPath := GetRealPath(path))    ;获取不到真实路径时删除链接,同时恢复成普通文件夹
		{
			FileDelete, % path
			FileCreateDir, % path
		}
	}
	return realPath
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
		try status.index++
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
			try status.action := "修改文件:" A_LoopFileLongPath    ;记录更新
			try status.cmdList := "[修改]文件修改`t地址:" A_LoopFileLongPath "`r`n"    ;记录更新
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
		try status.index++   
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
			try status.action := "修改文件:" A_LoopFileLongPath    ;记录更新
			try status.cmdList := "[修改]文件修改`t地址:" A_LoopFileLongPath "`r`n"    ;记录更新
		}
		lua := midText := newMidText := ""    ;释放内存
    }
	lua := midText := newMidText := ""    ;释放内存
	SetBatchLines %OldBatchLines%   ;恢复速度
}