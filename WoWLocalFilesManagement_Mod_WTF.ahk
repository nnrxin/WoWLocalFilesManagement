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
	global WTF_ITEMS := []    ;储存硬盘扫描后全部的数据
	global WTF_ITEMS_SELECTED := []    ;从列表中选择的
	global WTF_ITEMS_SOURCES := []    ;从源角色
	global WTF_ITEMS_TARGETS := []    ;从目标角色
	
	;开关模式起始值
	global WTF_SWITCH_PATHSCAN := 0   ;起始扫描位置
	global WTF_SWITCH_LVADD := 0    ;起始LV添加位置
	
	;职业筛选
	global WTF_FILTER_CLASS := 0    ;职业筛选默认为0
	
	;LV颜色
	global LVWTF_COLOR
	
	;过程记录
	global WTF_RECORD := {}    ;过程记录对象
	
	
	;在MainGui的TAB上:
	;路径切换
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	IB_Opts := [[0,0xCCCCCC,,0x838383,,,0xBFBFBF],[,0xFFFFFF],[,0xFFFFFF],[,0xFFFFFF,,"black",,,0x0078D7]]    ;ImageButton配色(反向win10配色)
	;~ IB_Opts := [[0,0xCCCCCC,,0x838383],[,0xCCE8CF],[,0xCCE8CF],[,0xCCE8CF,,"black"]]    ;ImageButton配色(激活时灰色,未激活时绿色)
	Gui, MainGui:Add, Button, xm+10 ym+32 w95 h22 Section vvWTF_BTwowPath hwndhWTF_BTwowPath ggWTF_BTscanPath, 魔兽世界路径
	ImageButton.Create(hWTF_BTWoWPath, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, x+0 yp hp w564 ReadOnly vvWTF_EDwowPath, 
	Gui, MainGui:Add, Button, x+0 yp hp w60 vvWTF_BTopenPath1 ggWTF_BTopenPath, % "打开目录"
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Button, xs y+2 w95 h22 vvWTF_BTrealPath hwndhWTF_BTrealPath ggWTF_BTscanPath, 自定义存储路径
	ImageButton.Create(hWTF_BTrealPath, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, x+0 yp hp w564 ReadOnly vvWTF_EDrealPath, 
	Gui, MainGui:Add, Button, x+0 yp hp w60 vvWTF_BTopenPath2 ggWTF_BTopenPath, % "打开目录"
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Button, xs y+2 w95 h22 Disabled, WTF备份路径
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, x+0 yp hp w564 ReadOnly vvWTF_EDbackupPath, 
	Gui, MainGui:Add, Button, x+0 yp hp w60 vvWTF_BTopenPath3 ggWTF_BTopenPath, % "打开目录"


	;魔兽版本Logo
	Gui, MainGui:Add, Picture, xm+10 y+2 w195 h65 Section vvWTF_PICwowLogo, 
	
	
	;通用选项
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+210 ys w143 h64, % "通用选项"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Checkbox, xp+10 yp+17 h20 AltSubmit Section vini_WTF_ifModLua, % "替换文件中的角色名"
	GuiControl,, ini_WTF_ifModLua, % INI.Init("WTF", "ifModLua", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+2 hp AltSubmit vini_WTF_ifBackUp, % "备份目标角色文件"
	GuiControl,, ini_WTF_ifBackUp, % INI.Init("WTF", "ifBackUp", 1)    ;初始化
	
	;配置覆盖选项
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xs+138 ys-17 w372 h64, % "配置覆盖选项"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Checkbox, xp+10 yp+17 w100 h20 AltSubmit Section vini_WTF_optionA1, % "账号插件配置"
	GuiControl,, ini_WTF_optionA1, % INI.Init("WTF", "optionA1", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+2 wp hp   AltSubmit vini_WTF_optionP1, % "角色插件配置"
	GuiControl,, ini_WTF_optionP1, % INI.Init("WTF", "optionP1", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, x+0 ys w100 hp AltSubmit vini_WTF_optionA2, % "账号系统配置"
	GuiControl,, ini_WTF_optionA2, % INI.Init("WTF", "optionA2", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+2 wp hp   AltSubmit vini_WTF_optionP2, % "角色系统配置"
	GuiControl,, ini_WTF_optionP2, % INI.Init("WTF", "optionP2", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, x+0 ys w75 hp  AltSubmit vini_WTF_optionA3, % "账号按键"
	GuiControl,, ini_WTF_optionA3, % INI.Init("WTF", "optionA3", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+2 wp hp   AltSubmit vini_WTF_optionP3, % "角色按键"
	GuiControl,, ini_WTF_optionP3, % INI.Init("WTF", "optionP3", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, x+0 ys hp      AltSubmit vini_WTF_optionA4, % "账号共享宏"
	GuiControl,, ini_WTF_optionA4, % INI.Init("WTF", "optionA4", 1)    ;初始化
	Gui, MainGui:Add, Checkbox, xp y+2 hp      AltSubmit vini_WTF_optionP4, % "角色专属宏"
	GuiControl,, ini_WTF_optionP4, % INI.Init("WTF", "optionP4", 1)    ;初始化
	
	;筛选
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 y+7 w720 h64, % "列表筛选"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Text, xp+10 yp+17 w55 h20 Section, 包含字符:
	Gui, MainGui:Add, Edit, x+0 yp-1 w80 hp vini_WTF_include ggWTF_EDfilter, % INI.Init("WTF", "include")    ;包含
	Gui, MainGui:Add, Text, xs y+2 w55 hp , 不含字符:
	Gui, MainGui:Add, Edit, x+0 yp-1 w80 hp vini_WTF_notInclude ggWTF_EDfilter, % INI.Init("WTF", "notInclude")    ;不包含
	Gui, MainGui:Add, Checkbox, x+10 ys-4 w44 hp AltSubmit vini_WTF_cLV ggWTF_CBcLV, 颜色    ;是否开启颜色
	GuiControl,, ini_WTF_cLV, % INI.Init("WTF", "cLV", 1)    ;颜色开始初始化
	Gui, MainGui:Add, Button, xp y+1 w40 hp vvWTF_BTclean ggWTF_BTclean hwndhWTF_BTclean Disabled, 重置    ;恢复全部职业
	ImageButton.Create(hWTF_BTclean, [0,0xE1E1E1,,"red",,,0xADADAD],[,0xE5F1FB],[,0xCCE4F7],[,0xCCCCCC,,0x838383])   ;红字的默认按钮
	;筛选框职业图片按钮:
	picPath := APP_DATA_PATH "\Img\Classicon"
	Gui, MainGui:Add, Button, x+7 ys-2 w41 h41 ggWTF_BTclass hwndhWTF_BTclass1 vvWTF_BTclass1 ,
	ImageButton.Create(hWTF_BTclass1, [0,picPath "\G1.png"], [,picPath "\L1.png"],, [,picPath "\1.ico"])
	loop 11
	{
		i := A_index + 1
		Gui, MainGui:Add, Button, % "x+1 yp wp hp ggWTF_BTclass hwndhWTF_BTclass" i " vvWTF_BTclass" i,
		ImageButton.Create(hWTF_BTclass%i%, [0,picPath "\G" i ".png"], [,picPath "\L" i ".png"],, [,picPath "\" i ".ico"])
	}
	
	
	;主体
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Edit, xm+10 y+8 w310 h22 ReadOnly Section vvWTF_EDsource,
	Gui, MainGui:Add, Button, xp y+0 wp hp vvWTF_BTaddSource hwndhWTF_BTaddSource ggWTF_BTaddTo, % "源角色"    ;添加到源角色
	ImageButton.Create(hWTF_BTaddSource, IB_Opts*)   ;彩色按钮
	
	IB_Opts2 := [[0,0xC7EDCC,,"black",,,0xBFBFBF],[,0x00FF00],[,0x00FF00,,0xFFFFFF],[,0xCCCCCC,,0x838383,,,0xBFBFBF]]    ;ImageButton配色
	Gui, MainGui:Add, Button, x+0 ys w100 h22 vvWTF_BTcopy hwndhWTF_BTcopy ggWTF_BTCopyOrSyn Disabled, % ">>配置覆盖>>"
	ImageButton.Create(hWTF_BTcopy, IB_Opts2*)   ;彩色按钮
	Gui, MainGui:Add, Button, xp y+0 wp hp vvWTF_BTsyn hwndhWTF_BTsyn ggWTF_BTCopyOrSyn Disabled, % "<<配置同步<<"
	ImageButton.Create(hWTF_BTsyn, IB_Opts2*)   ;彩色按钮
	
	Gui, MainGui:Add, Edit, x+0 ys w310 h22 ReadOnly vvWTF_EDtarget,
	Gui, MainGui:Add, Button, xp y+0 wp hp vvWTF_BTaddTarget hwndhWTF_BTaddTarget ggWTF_BTaddTo, % "目标角色"    ;添加到目标角色(默认禁用)
	ImageButton.Create(hWTF_BTaddTarget, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	
	;LV列表创立及准备
	Gui, MainGui:Add, ListView, xm+10 y+0 w720 h230 Count500 -Multi Grid AltSubmit vvLVWTF HwndhLVWTF ggLVWTF, 职业|角色|服务器|账号|插件账号共享配置文件夹(SavedVariables)链接地址|角色文件夹链接地址|所在WTF的路径
	LVWTF_COLOR := New LV_Colors(hLVWTF,,0)    ;LV上色(弊端:无法拖动排序了,需要拦截点击标题栏动作,然后重新绘色)
	LVWTF_COLOR.switch := ini_WTF_cLV    ;颜色开关的初始化
	;为LV增加图片列表
	ImageListID := IL_Create(12)  ; 创建加载 12 个小图标的图像列表.
	LV_SetImageList(ImageListID)  ; 把上面的图像列表指定给当前的 ListView.
	Loop 12  ;加载图片到图像列表里
		IL_Add(ImageListID, APP_DATA_PATH "\Img\Classicon\" A_Index ".ico")	
	
	;加载ico图标成位图
	Loop 12
		hBitMapClass%A_Index% := LoadPicture(APP_DATA_PATH "\Img\Classicon\" A_Index ".ico") 
	
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_WTF:
	;目录位置刷新
	GuiControl,, vWTF_EDwowPath, % WOW_EDITION ? (WOW_PATH "\" WOW_EDITION) : ""        ;wow路径
	GuiControl,, vWTF_EDrealPath, % WOW_EDITION ? (REAL_PATH "\" WOW_EDITION) : ""      ;自定义存储路径
	GuiControl,, vWTF_EDbackupPath, % WOW_EDITION ? (BACKUP_PATH "\" WOW_EDITION) : ""  ;WTF备份路径
	
	;魔兽Logo图片刷新
	gosub, ShowWoWLogo
	;路径选择
	GuiControl, Enable%WTF_SWITCH_PATHSCAN%, vWTF_BTwowPath    ;魔兽路径
	GuiControl, Disable%WTF_SWITCH_PATHSCAN%, vWTF_BTrealPath    ;真实存档路径
	;LV添加位置按钮控制
	GuiControl, Enable%WTF_SWITCH_LVADD%, vWTF_BTaddSource    ;源角色
	GuiControl, Disable%WTF_SWITCH_LVADD%, vWTF_BTaddTarget    ;目标角色
	
	gosub, scanNewPath
return

;=======================================================================================================================
;Tab进此模块时执行的命令 |
;=======================
GuiTabIn_WTF:
	if (vWTF_EDwowPath <> WOW_PATH "\" WOW_EDITION)    ;魔兽地址发生变化时,重新初始化
	or (vWTF_EDrealPath <> REAL_PATH "\" WOW_EDITION)    ;自定义地址发生变化时,重新初始化
	{
		gosub, CleanItems
		gosub, GuiInit_WTF
	}
return


;=======================================================================================================================
;路径切换及扫描 |
;================
;选择魔兽/自定义存储路径
gWTF_BTscanPath:
	Gui MainGui:+Disabled	;主窗口禁用
	Gui, MainGui:Submit, NoHide
	;开关切换
	WTF_SWITCH_PATHSCAN := 1 - WTF_SWITCH_PATHSCAN    
	GuiControl, Enable%WTF_SWITCH_PATHSCAN%, vWTF_BTwowPath    ;魔兽路径
	GuiControl, Disable%WTF_SWITCH_PATHSCAN%, vWTF_BTrealPath    ;真实存档路径
	;扫描新路径
	gosub, scanNewPath
	Gui MainGui:-Disabled	;主窗口启用
return
;扫描路径
scanNewPath:
	Gui MainGui:+Disabled	;主窗口禁用
	WTF_ITEMS := WOW_EDITION ? ScanWTF((WTF_SWITCH_PATHSCAN ? REAL_PATH : WOW_PATH) "\" WOW_EDITION "\WTF") : []    ;路径扫描
	gosub, gWTF_EDfilter    ;筛选动作
	;~ SB_SetText("WTF目录扫描完毕,列表已刷新")
	;~ gosub, gLVWTF   ;刷新已选择
	Gui MainGui:-Disabled	;主窗口启用
return

;打开路径
gWTF_BTopenPath:
	Switch A_GuiControl
	{
	Case "vWTF_BTopenPath1":
		GuiControlGet, path,, vWTF_EDwowPath    ;wow路径
	Case "vWTF_BTopenPath2":
		GuiControlGet, path,, vWTF_EDrealPath    ;自定义存储路径
	Case "vWTF_BTopenPath3":
		GuiControlGet, path,, vWTF_EDbackupPath    ;WTF备份路径
	Default:
	}
	if InStr(FileExist(path), "D")
		Run % path
return

;扫描WTF文件夹,获取详细信息
ScanWTF(WTFpath)
{
	items := []
	;在文件夹WTF\Account内循环
	Loop, Files, % WTFpath "\Account\*", D    
	{
		Account := A_LoopFileName    ;账号文件夹名称
		index := items.Count()    ;记录开始账号循环前items中成员数量
		AccountRealPath := ""    ;账号链接信息
		playerInfoLua := ""    ;清空角色信息obj
		;文件夹WTF\Account\某账号内循环
		Loop, Files, % A_LoopFileLongPath "\*", D    
		{
			Realm := A_LoopFileName    ;服务器名称
			;账号信息保存文件夹 SavedVariables
			if (Realm = "SavedVariables")    
			{
				;账号链接真实地址
				AccountRealPath := GetFolderMklinkInfo(A_LoopFileLongPath)
				;获取角色信息
				if FileExist(A_LoopFileLongPath "\PlayerInfo.lua")
					playerInfoLua := new WowAddOnSavedLua(A_LoopFileLongPath "\PlayerInfo.lua", "Obj")
				continue
			}
			;文件夹WTF\Account\某账号\某服务器内循环
			Loop, Files, % A_LoopFileLongPath "\*", D    
			{
				Player := A_LoopFileName    ;角色名称
				if (Player = "(null)")    ;排除(null)
					continue
				;角色链接的真实地址
				PlayerRealPath := GetFolderMklinkInfo(A_LoopFileLongPath)
				;向数组内添加信息[账号，服务器，角色]
				items.push({Account:Account,Realm:Realm,Player:Player,PlayerRealPath:PlayerRealPath,WTFPath:WTFpath})
			}
		}
		;账号内循环结束后再次循环一次,添加SavedVariables的相关信息
		loop % items.Count() - index
		{
			index++
			;账号真实路径
			items[index].AccountRealPath := AccountRealPath
			;将玩家信息添加进items
			if playerInfoLua
			{
				if (info := playerInfoLua.Get([items[index].Player "-" items[index].Realm,"class"]).Value)
					items[index].PlayerClass := info
			}
		}
	}
	return items
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


;=======================================================================================================================
;魔兽版本Logo |
;==============
;显示魔兽logo图片
ShowWoWLogo:
	Switch WOW_EDITION
	{
	Case "_classic_":
		picPath := APP_DATA_PATH "\Img\GUI\Classic_Logo.png"
	Default:
		if (WOW_EDITION_VERSION >= 90000)
			picPath := APP_DATA_PATH "\Img\GUI\Onion_Logo.png"
		else if (WOW_EDITION_VERSION >= 80000)
			picPath := APP_DATA_PATH "\Img\GUI\BFA_Logo.png"
		else
			picPath := WOW_EDITION " " WOW_EDITION_VERSION
	}
	GuiControl,, vWTF_PICwowLogo, % picPath
return


;=======================================================================================================================
;筛选 |
;=====
;筛选框
gWTF_EDfilter:
	Gui MainGui:+Disabled	;主窗口禁用
	Gui, MainGui:Submit, NoHide
	RenewWTFLV(hLVWTF, LVWTF_COLOR, WTF_ITEMS, ini_WTF_include, ini_WTF_notInclude, WTF_FILTER_CLASS)    ;LV刷新
	sleep 100
	Gui MainGui:-Disabled	;主窗口启用
return

;角色筛选按钮
gWTF_BTclass:
	Gui MainGui:+Disabled	;主窗口禁用
	loop 12
	{
		GuiControl, Enable, vWTF_BTclass%A_Index%
	}
	GuiControl, Disable, % A_GuiControl
	WTF_FILTER_CLASS := SubStr(A_GuiControl, 13)
	gosub, gWTF_EDfilter
	GuiControl, Enable, vWTF_BTclean    ;启用重置键
	Gui MainGui:-Disabled	;主窗口启用
return

;重置筛选
gWTF_BTclean:
	Gui, MainGui:+Disabled	;主窗口禁用
	GuiControl, Disable, vWTF_BTclean    ;禁用重置键
	;按键全部启用
	WTF_FILTER_CLASS := 0
	loop 12
	{
		GuiControl, Enable, vWTF_BTclass%A_Index%
	}
	gosub, gWTF_EDfilter
	Gui, MainGui:-Disabled	;主窗口启用
return

;LV颜色开关
gWTF_CBcLV:
	Gui MainGui:Submit, NoHide
	LVWTF_COLOR.switch := ini_WTF_cLV   ;颜色开关
	gosub, ReColorWTFLV    ;LV重新上色
return

;LV重新上色
ReColorWTFLV:
	ColorWTFLV(LVWTF_COLOR, "ColorLV_ColorRule")
return

;根据数组数据刷新LV列表
RenewWTFLV(LVHwnd, cLV, items, include := "", notInclude:= "", classFilter := 0)
{
	Gui, ListView, %LVHwnd%    ;选择操作表
	LV_Delete()
	GuiControl, -Redraw, %LVHwnd%    ;在加载时禁用重绘来提升性能.
	for i, item in items
	{
		Account          := item.Account           ;账号
		Realm            := item.Realm             ;服务器
		Player           := item.Player            ;角色
		PlayerClass      := GetWoWClass(item.PlayerClass).nameCNShort  ;职业
		PlayerClassIndex := GetWoWClass(item.PlayerClass).index        ;职业序号
		AccountRealPath  := item.AccountRealPath   ;账号链接地址
		PlayerRealPath   := item.PlayerRealPath    ;角色链接地址
		WTFPath          := item.WTFPath           ;所在WTF的地址
		;筛选职业
		if (PlayerClass and classFilter <> 0 and PlayerClassIndex <> classFilter)
			continue
		;筛选文字
		str := Account "`n" Realm "`n" Player "`n" PlayerClass    ;拼合成字串
		if (include <> "" and !InStr(str, include)) or (notInclude <> "" and InStr(str, notInclude))
			continue
		;LV新增行
		LV_Add("Icon" . PlayerClassIndex, PlayerClass, Player, Realm, Account, AccountRealPath, PlayerRealPath, WTFPath)
	}
	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
	LV_ModifyCol(3, "AutoHdr")
	LV_ModifyCol(4, "AutoHdr")
	LV_ModifyCol(5, "AutoHdr")
	LV_ModifyCol(6, "AutoHdr")
	LV_ModifyCol(7, "AutoHdr")
	;职业筛选时进排序
	if classFilter
		LV_ModifyCol(1, "SortDesc")   ;排序
	;为LV列表上色
	ColorWTFLV(cLV, "ColorLV_ColorRule")
	GuiControl, +Redraw, %LVHwnd%  ; 重新启用重绘 (上面把它禁用了).
}
;为LV列表上色
ColorWTFLV(cLV, colorRuleFuncName)
{
	if not (hLV := cLV.HWND)
		return
	;开闭控制
	If cLV.switch
		cLV.OnMessage()
	Else
	{
		cLV.OnMessage(False)
		return
	}
	;开始绘色
	Gui, ListView, %hLV%    ;选择操作表
	GuiControl, -Redraw, %hLV%    ;在加载时禁用重绘来提升性能.
	cLV.Clear()    ;先清空颜色
	Loop, % LV_GetCount()
	{
		%colorRuleFuncName%(cLV, A_index)    ;调用规则函数
	}
	GuiControl, +Redraw, %hLV%  ; 重新启用重绘 (上面把它禁用了).
}
;为LV列表上色规则函数
ColorLV_ColorRule(cLV, rowIndex)
{
	;职业染色
	LV_GetText(PlayerClass, rowIndex , 1)
	BCol := GetWoWClass(PlayerClass).color    ;默认背景颜色=职业颜色
	TCol := GetWoWClass(PlayerClass).colorBG    ;默认背景颜色=职业颜色背景色
	cLV.Cell(rowIndex, 1, BCol, TCol)
	cLV.Cell(rowIndex, 2, BCol, TCol)
	cLV.Cell(rowIndex, 3, BCol, TCol)
	;链接染色
	LV_GetText(AccountRealPath, rowIndex , 5)
	LV_GetText(PlayerRealPath, rowIndex , 6)
	if PlayerRealPath
		cLV.Cell(rowIndex, 4, 0x9C9C9C)
	else if AccountRealPath
		cLV.Cell(rowIndex, 4, 0xCFCFCF)
	else
		cLV.Cell(rowIndex, 4, 0xE8E8E8)
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


;=======================================================================================================================
;LV刷新,点击输入ED等 |
;====================
;添加到源角色/目标角色
gWTF_BTaddTo:
	WTF_SWITCH_LVADD := 1 - WTF_SWITCH_LVADD    ;开关切换
	GuiControl, Enable%WTF_SWITCH_LVADD%, vWTF_BTaddSource
	GuiControl, Disable%WTF_SWITCH_LVADD%, vWTF_BTaddTarget
	GuiControl, % (WTF_SWITCH_LVADD?"+":"-") "Multi", vLVWTF   ;LV启用/禁用多行
return

;LV列表动作
gLVWTF:
	Gui MainGui:+Disabled	;主窗口禁用
	Switch A_GuiEvent
	{
	;点击了标题栏
	Case "ColClick":
		gosub, ReColorWTFLV    ;LV重新上色
	;项目发生了变化
	Case "I":
		gosub, addLVRowsToEdits    ;向ED中添加信息
	;其他情况
	Default:
	}
	Gui MainGui:-Disabled	;主窗口启用
return

;添加LV信息到指定的编辑框中的动作
addLVRowsToEdits:
	;添加到已选择数组
	WTF_ITEMS_SELECTED := []
	Loop
	{
		rowIndex := LV_GetNext(rowIndex)  ; 在前一次找到的位置后继续搜索.
		if not rowIndex  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(PlayerClass,     rowIndex, 1)    ;职业
		LV_GetText(Player,          rowIndex, 2)    ;角色
		LV_GetText(Realm,           rowIndex, 3)    ;服务器
		LV_GetText(Account,         rowIndex, 4)    ;账号
		LV_GetText(AccountRealPath, rowIndex, 5)    ;服务器账号真实地址
		LV_GetText(PlayerRealPath,  rowIndex, 6)    ;角色账号真实地址
		LV_GetText(WTFPath,         rowIndex, 7)    ;WTF文件夹地址
		WTF_ITEMS_SELECTED.push({PlayerClass:PlayerClass
								,Player:Player
								,Realm:Realm
								,Account:Account
								,AccountRealPath:AccountRealPath
								,PlayerRealPath:PlayerRealPath
								,WTFPath:WTFPath})
	}
	;添加到编辑框
	if (WTF_SWITCH_LVADD == 0)    ;添加到源 
	{
		WTF_ITEMS_SOURCES := CopyArray(WTF_ITEMS_SELECTED)
		GuiControl,, vWTF_EDsource, % showTxt := GetShowStrFromWTFItems(WTF_ITEMS_SOURCES)    ;编辑框
		SB_SetText("已选择源角色:" showTxt)
	}
	else    ;添加到目标
	{
		WTF_ITEMS_TARGETS := CopyArray(WTF_ITEMS_SELECTED)
		GuiControl,, vWTF_EDTarget, % showTxt := GetShowStrFromWTFItems(WTF_ITEMS_TARGETS)    ;编辑框
		SB_SetText("已选择目标角色(" WTF_ITEMS_TARGETS.Count() "):" showTxt)
	}
	;覆盖/同步按钮的激活控制
	GuiControl, % "Enable" (WTF_ITEMS_TARGETS[1] && WTF_ITEMS_SOURCES[1]), vWTF_BTcopy ;列表同时选取了两侧的选择了文件，按钮才会显示出来
	GuiControl, % "Enable" (WTF_ITEMS_TARGETS[1] && WTF_ITEMS_SOURCES[1]), vWTF_BTsyn ;列表同时选取了两侧的选择了文件，按钮才会显示出来
return
;由数组获取显示的字符串
GetShowStrFromWTFItems(items)
{
	if (items.count() == 0)
		return ""
	showStr := ""
	for i, item in items
	{
		showStr .= item.Player "-" item.Realm "(" item.Account (WTF_SWITCH_PATHSCAN?"@自定义存储":"@魔兽世界") "); `n"
	}
	return Trim(showStr, "; `n")
}
;数组复制
CopyArray(arr)
{
	newArr := {}
	for k, v in arr
		newArr[k] := v
	return newArr
}

;清空源项目与目标项目
CleanItems:
	WTF_ITEMS_SELECTED := []    ;从列表中选择的
	WTF_ITEMS_SOURCES := []    ;从源角色
	WTF_ITEMS_TARGETS := []    ;从目标角色
	GuiControl,, vWTF_EDsource,    ;左编辑框
	GuiControl,, vWTF_EDTarget,    ;右编辑框
	GuiControl, Disable, vWTF_BTcopy    ;复制按钮
	GuiControl, Disable, vWTF_BTsyn    ;同步按钮
return

;=======================================================================================================================
;复制/同步动作(核心)|
;====================
;解析源item和目标item
AnalyzeItems(sources, targets)
{
	;解析源item
	s := sources[1]
	s.AccountPath := s.WTFPath "\Account\" s.Account    ;源账号完整地址
	s.PlayerPath := s.AccountPath "\" s.Realm "\" s.Player   ;源角色完整地址
	;统计账号内文件数量
	accountFilesCount := 0
	Loop, Files, % s.AccountPath "\SavedVariables\*"
		accountFilesCount++
	;统计角色内文件数量
	playerFilesCount := 0
	Loop, Files, % s.PlayerPath "\*", FR
		playerFilesCount++
	;统计插件Lua数量
	countLua := 0
	Loop, Files, % s.AccountPath "\SavedVariables\*.lua"    ;账号SavedVariables
		countLua++
	Loop, Files, % s.PlayerPath "\SavedVariables\*.lua"    ;角色SavedVariables
		countLua++
	countFull := accountFilesCount + playerFilesCount + countLua    ;一个角色的全部操作数
	
	;解析目标item
	for i, t in targets
	{
		t.AccountPath := t.WTFPath "\Account\" t.Account    ;目标账号完整地址
		t.PlayerPath := t.AccountPath "\" t.Realm "\" t.Player   ;目标角色完整地址
	}
	
	;返回 [源账号文件数量, 源角色文件数量, Lua总数量]
	return {countA:accountFilesCount, countP:playerFilesCount, countLua:countLua, countFull:countFull}
}

;WoW配置快速复制专用函数，快速替换lua中角色名和服务器名
;需要类#Include <Class_WowAddOnSavedLua_Fast>
;filePaths可带通配符, o结构为[源角色名,源服务器名,目标角色名,目标服务器名], record为记录信息对象
ChangeLuaPlayerName(filePaths, o, record := "")  
{
	OldBatchLines := A_BatchLines 
	SetBatchLines, -1  ; 让操作以最快速度运行.
    Loop, Files, % filePaths    ;文件循环
    {
		;记录更新
		record.i++   
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
			lua.WriteToFile()
		lua := ""    ;释放内存
    }
	SetBatchLines %OldBatchLines%   ;恢复速度
}

;WoW插件配置的预设档新增
;filePaths可带通配符, o结构为[源角色名,源服务器名,目标角色名,目标服务器名], record为记录信息对象
ChangeLuaProfileKeys(filePaths, o, record := "")
{
	OldBatchLines := A_BatchLines 
	SetBatchLines, -1  ; 让操作以最快速度运行.
    Loop, Files, % filePaths    ;文件循环
    {
		;记录更新
		record.i++   
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
		}
		lua := midText := newMidText := ""    ;释放内存
    }
	lua := midText := newMidText := ""    ;释放内存
	SetBatchLines %OldBatchLines%   ;恢复速度
}

;配置复制/同步
gWTF_BTCopyOrSyn:
	;发现魔兽窗口时返回
	if WinExist("ahk_exe Wow.exe") or WinExist("ahk_exe WowClassic.exe")
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 16,, 启动失败: 请关闭魔兽窗口后重试
		return
	}
	;解析源item和目标item
	WTF_RECORD := AnalyzeItems(WTF_ITEMS_SOURCES, WTF_ITEMS_TARGETS)
	src := WTF_ITEMS_SOURCES[1]    ;方便后面调用
	;向两者相同时错误返回
	if (src.PlayerPath = WTF_ITEMS_TARGETS[1].PlayerPath and WTF_ITEMS_TARGETS.Count() == 1)
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 16,, 错误！源角色与目标角色不能相同
		return
	}
	;职业匹配警告
	if src.PlayerClass
	{
		msgStr := ""
		for i, tar in WTF_ITEMS_TARGETS
		{
			if (tar.PlayerClass and tar.PlayerClass <> src.PlayerClass)    ;职业不同
				msgStr .= tar.PlayerClass " " tar.Player "-" tar.Realm "(" tar.Account ")`r`n"
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
	MsgBoxTxt1 := "源角色:`n" vWTF_EDsource "`n`n目标角色:`n" vWTF_EDtarget "`n`n是否进行<<文件复制>>来实现配置的覆盖?`n`n请对重要设置进行备份!!!"
	MsgBoxTxt2 := "源角色:`n" vWTF_EDsource "`n`n目标角色:`n" vWTF_EDtarget "`n`n是否进行<<文件链接>>来实现配置的同步?`n`n请对重要设置进行备份!!!"
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	MsgBox, 52,, % (A_GuiControl = "vWTF_BTcopy") ? MsgBoxTxt1 : MsgBoxTxt2
	IfMsgBox Yes
	{
		Gui MainGui:+Disabled	;主窗口禁用
		;状态栏修改
		SB_SetParts(200, 150)    ;状态栏分3部分
		SB_SetProgress(0, 1, "show Range0-" WTF_RECORD.countFull * WTF_ITEMS_TARGETS.Count())    ;状态栏上增加计时条
		SetTimer, UpdataSB, 10, 10000    ;状态栏更新线程开启
		;记录重置
		WTF_RECORD.cmdList := "", WTF_RECORD.i := 0
		;执行动作
		if (A_GuiControl = "vWTF_BTcopy")
			gosub, DoCopy    ;复制
		else
			gosub, DoSyn    ;同步
		;状态栏恢复,输出结论
		SB_SetParts()    ;状态栏进度条恢复
		SB_SetText("完成")
		SB_SetProgress(0, 1, "hide")    ;状态栏上计时条隐藏
		Clipboard := WTF_RECORD.cmdList "`n`n" WTF_RECORD.i " " WTF_RECORD.countFull
		Gui MainGui:-Disabled	;主窗口启用
	}
return

;状态栏更新
UpdataSB:
	Gui, MainGui:Default
	SB_SetProgress(WTF_RECORD.i, 1)
	SB_SetText(SB_Text2, 3)    ;状态栏显示变更
return

;复制
DoCopy:
	;防止重复复制账号文件夹,先做记录
	hasCopyedList := ""
	for i, tar in WTF_ITEMS_TARGETS    ;多目标
	{
		;状态栏信息变更
		classI := GetWoWClass(tar.PlayerClass).index
		SB_SetIcon("HBITMAP:" hBitMapClass%classI%, 1, 2)
		SB_SetText(tar.Player "-" tar.Realm, 2)    ;状态栏1显示变更
		;跳过完全相同的角色
		if (src.PlayerPath = tar.PlayerPath)
		{
			WTF_RECORD.i += WTF_RECORD.countFull
			SB_SetText("与源角色重复,跳过...", 3)
			sleep, 333
			continue
		}
		;账号
		if (src.AccountPath <> tar.AccountPath)    ;目标账号与源账号不同时
		{
			if not InStr(hasCopyedList, tar.AccountPath)    ;首次复制该目录时
			{
				hasCopyedList .= tar.AccountPath "`r`n"    ;添加进记录
				Loop, Files, % src.AccountPath "\*", DF    ;源账号文件夹内循环
				{
					;跳过
					if (Instr(A_LoopFileAttrib,"D") and A_LoopFileName <> "SavedVariables")    ;跳过"服务器"文件夹
					or (A_LoopFileName = "SavedVariables"        and ini_WTF_optionA1 <> 1)    ;账号插件
					or (InStr(A_LoopFileName, "config-cache.")   and ini_WTF_optionA2 <> 1)    ;账号系统
					or (InStr(A_LoopFileName, "bindings-cache.") and ini_WTF_optionA3 <> 1)    ;账号按键
					or (InStr(A_LoopFileName, "macros-cache.")   and ini_WTF_optionA4 <> 1)    ;账号宏
						continue    
					;备份
					if (ini_WTF_ifBackUp == 1)
					{
						SB_Text2 := "备份文件:" tar.AccountPath "\" A_LoopFileName
						WTF_RECORD.cmdList .= "文件备份`t源地址:" tar.AccountPath "\" A_LoopFileName "`r`n"
					}
					;复制
					FolderCopyEx(A_LoopFileLongPath, tar.AccountPath "\" A_LoopFileName, "overWrite")    ;强力复制账号文件
					SB_Text2 := "复制文件到:" tar.AccountPath "\" A_LoopFileName
					WTF_RECORD.cmdList .= "文件复制`t源地址:" A_LoopFileLongPath "`t目标地址:" tar.AccountPath "\" A_LoopFileName "`r`n"
				}
			}
		}
		WTF_RECORD.i += WTF_RECORD.countP   ;账号拷贝完成
		;账号Lua修改
		if (ini_WTF_ifModLua == 1 and ini_WTF_optionA1 == 1)
		{
			SB_Text2 := "修改文件:" tar.AccountPath "\SavedVariables\*.lua" "`r`n"
			WTF_RECORD.cmdList .= "文件修改`t源地址:" tar.AccountPath "\SavedVariables\*.lua" "`r`n"
			ChangeLuaProfileKeys(tar.AccountPath "\SavedVariables\*.lua", [src.Player, src.Realm, tar.Player, tar.Realm], WTF_RECORD)
		}
		else
			WTF_RECORD.i += WTF_RECORD.countLua   ;跳过修改Lua  ! 只跳过一次
		;角色
		;备份
		if (ini_WTF_ifBackUp == 1)
		{
			SB_Text2 := "备份文件:" tar.AccountPath "\" A_LoopFileName
			WTF_RECORD.cmdList .= "文件备份`t源地址:" tar.AccountPath "\" A_LoopFileName "`r`n"
		}
		Loop, Files, % src.PlayerPath "\*", DF    ;角色文件夹内循环
		{
			;跳过
			if (A_LoopFileName = "SavedVariables"        and ini_WTF_optionP1 <> 1)    ;角色插件
			or (A_LoopFileName = "AddOns.txt"            and ini_WTF_optionP1 <> 1)    ;角色插件 开关状态
			or (InStr(A_LoopFileName, "config-cache.")   and ini_WTF_optionP2 <> 1)    ;角色系统	
			or (A_LoopFileName = "layout-local.txt"      and ini_WTF_optionP2 <> 1)    ;角色系统 头像位置
			or (A_LoopFileName = "chat-cache.txt"        and ini_WTF_optionP2 <> 1)    ;角色系统 聊天框
			or (InStr(A_LoopFileName, "CUFProfiles.txt") and ini_WTF_optionP2 <> 1)    ;角色系统 团队框架
			or (InStr(A_LoopFileName, "bindings-cache.") and ini_WTF_optionP3 <> 1)    ;角色按键
			or (InStr(A_LoopFileName, "macros-cache.")   and ini_WTF_optionP4 <> 1)    ;角色宏
				continue
			;复制
			FolderCopyEx(A_LoopFileLongPath, tar.PlayerPath "\" A_LoopFileName, "overWrite")    ;强力复制角色文件
			SB_Text2 := "复制文件到:" tar.PlayerPath "\" A_LoopFileName
			WTF_RECORD.cmdList .= "文件复制`t源地址:" A_LoopFileLongPath "`t目标地址:" tar.PlayerPath "\" A_LoopFileName "`r`n"
		}
		WTF_RECORD.i += WTF_RECORD.countA   ;角色拷贝完成
		;角色Lua修改
		if (ini_WTF_ifModLua == 1 and ini_WTF_optionP1 == 1)
		{
			SB_Text2 := "修改文件:" tar.PlayerPath "\SavedVariables\*.lua" "`r`n"
			WTF_RECORD.cmdList .= "文件修改`t源地址:" tar.PlayerPath "\SavedVariables\*.lua" "`r`n"
			ChangeLuaPlayerName(tar.PlayerPath "\SavedVariables\*.lua", [src.Player, src.Realm, tar.Player, tar.Realm], WTF_RECORD)
		}
	}
return




;同步
DoSyn:
			;~ AltSubmit vini_WTF_optionA1, % "账号插件配置"
			;~ AltSubmit vini_WTF_optionA2, % "账号系统配置"
			;~ AltSubmit vini_WTF_optionA3, % "账号按键"
			;~ AltSubmit vini_WTF_optionA4, % "账号共享宏"
			;~ AltSubmit vini_WTF_optionP1, % "角色插件配置"
			;~ AltSubmit vini_WTF_optionP2, % "角色系统配置"
			;~ AltSubmit vini_WTF_optionP3, % "角色按键"
			;~ AltSubmit vini_WTF_optionP4, % "角色专属宏"
			
			
	MsgBox 同步完成
return




;同步
sssssn:
	/*
	Gui MainGui:+Disabled	;冻结主窗口
	
	;计时条设置
	Maxpp:=pp:=0
	if (A_GuiControl="BTCopy")    ;复制模式
	{
		if (CopyItem1=1)    ;账号插件
		{
			loop, Files, % AccountL "\SavedVariables\*.lua"
				Maxpp++
		}
		if (CopyItem5=1)    ;角色插件
		{
			loop, Files, % AccountL "\" RealmL "\" CharacterL "\SavedVariables\*.lua"
				Maxpp++
		}
	}
	else if (A_GuiControl="BTSyn")    ;同步模式
	{
		loop, Files, % AccountL "\SavedVariables\*.lua"
			Maxpp++
	}
	Maxpp*=AccountR.Length()
	SB_SetParts((MainGui_W-50)*2//10,(MainGui_W-50)*5//10,50,(MainGui_W-50)*3//10)	;状态栏分2部分
	SB_SetProgress(0,4,"show Range0-" Maxpp)
	
	;开始执行复制动作：
	loop % AccountR.Length()    ;多选复制模式
	{
		i:=A_index      ;循环次数
		SB_SetText(CharacterR[i] "-" RealmR[i],1)    ;状态栏1显示变更
		;跳过完全相同的角色
		if (AccountL=AccountR[i] and RealmL=RealmR[i] and CharacterL=CharacterR[i])
		{
			SB_SetText("源角色重复,跳过",2)
			sleep, 500
			continue
		}
		;复制前的备份
		if (ini_Settings_BackUPMod!=1)
			FileCreateDir, % NowBakPath:=BackupFolder "\" AccountR[i] "[" CharacterR[i] "-" RealmR[i]  "] -- " A_Now, 1    ;创建出备份文件夹
		;常规模式复制：
		if (A_GuiControl="BTCopy")    ;复制模式===========================================================================
		{
			;账号文件夹的选择性覆盖
			if (AccountL!=AccountR[i]) ;源账号与目标账号不相同时
			{
				Loop, Files, %AccountL%\*, DF  ;账号文件夹内循环
				{
					if  (A_LoopFileName="SavedVariables" and CopyItem1=0)    ;账号插件
					or (instr(A_LoopFileAttrib,"D") and A_LoopFileName!="SavedVariables")    ;不是"SavedVariables"的文件夹
					or ((A_LoopFileName="macros-cache.txt" or A_LoopFileName="macros-cache.old") and CopyItem4=0)    ;通用宏
					or ((A_LoopFileName="config-cache.wtf" or A_LoopFileName="config-cache.old") and CopyItem2=0)    ;账号设置
					or ((A_LoopFileName="bindings-cache.wtf" or A_LoopFileName="bindings-cache.old") and CopyItem3=0)    ;账号按键
						continue    ;跳过
					if (ini_Settings_BackUPMod!=1)
						FolderCopyEx(A_WorkingDir "\" AccountR[i] "\" A_LoopFileName ,A_WorkingDir "\" NowBakPath "\" A_LoopFileName)     ;备份账号文件
					FolderCopyEx(A_LoopFileLongPath, A_WorkingDir "\" AccountR[i] "\" A_LoopFileName)     ;强力复制复制--账号文件
				}
				;账号配置档变更
				if (CopyItem1=1)
					WoW_ChgLuaProfileKeys(AccountR[i] "\SavedVariables", CharacterR[i] " - " RealmR[i], CharacterL " - " RealmL)    ;账号配置档变更
			}
			;角色文件夹的选择性覆盖
			Loop, Files, % AccountL "\" RealmL "\" CharacterL "\*", DF  ;角色文件夹内循环
			{
				if (A_LoopFileName="SavedVariables" and CopyItem5=0)    ;角色插件配置文件夹
				or ((A_LoopFileName="macros-cache.txt" or A_LoopFileName="macros-cache.old") and CopyItem8=0)    ;角色专用宏
				or ((A_LoopFileName="bindings-cache.wtf" or A_LoopFileName="bindings-cache.old") and CopyItem7=0)    ;角色按键
				or (A_LoopFileName="AddOns.txt" and CopyItem5=0)    ;角色插件--插件开关状态
				or ((A_LoopFileName="config-cache.wtf" or A_LoopFileName="config-cache.old") and CopyItem6=0)    ;角色设置
				or (A_LoopFileName="layout-local.txt" and CopyItem6=0)    ;角色设置--头像位置
				or ((A_LoopFileName="chat-cache.txt" or A_LoopFileName="chat-cache.old") and CopyItem6=0)    ;角色设置--聊天框
				or ((A_LoopFileName="CUFProfiles.txt" or A_LoopFileName="CUFProfiles.txt.bak") and CopyItem6=0)    ;角色设置--团队框架
					continue
				if (ini_Settings_BackUPMod!=1)
					FolderCopyEx(A_WorkingDir "\" AccountR[i] "\" RealmR[i] "\" CharacterR[i] "\" A_LoopFileName
											,A_WorkingDir "\" NowBakPath "\" RealmR[i] "\" CharacterR[i] "\" A_LoopFileName)     ;备份账号文件
				FolderCopyEx(A_LoopFileLongPath, A_WorkingDir "\" AccountR[i] "\" RealmR[i] "\" CharacterR[i] "\" A_LoopFileName)     ;强力复制复制--角色文件
			}
			;角色插件名字替换
			if (CopyItem5=1)    ;开启了角色插件复制时
				WoW_ChgLua(AccountR[i] "\" RealmR[i] "\" CharacterR[i] "\SavedVariables",RealmL,CharacterL,RealmR[i],CharacterR[i])    ;账号配置lua替换
		}
		else if (A_GuiControl="BTSyn")    ;同步模式复制=========================================================================
		{
			;信息提示
			SB_SetText("正在同步到" CharacterL "-" RealmL "...",2)
			;角色部分
			IfNotEqual, ini_Settings_BackUPMod, 1, FileCopyDir, % AccountR[i] "\" RealmR[i] "\" CharacterR[i], % NowBakPath "\" RealmR[i] "\" CharacterR[i], 1    ;备份
			FileRemoveDir, % AccountR[i] "\" RealmR[i] "\" CharacterR[i], 1    ;删除目标 账号\服务器\角色 文件夹
			FileAppend, % "mklink /j " AccountR[i] "\" RealmR[i] "\" CharacterR[i] " " AccountL "\" RealmL "\" CharacterL, ahkmklink.bat    ;账号\服务器\角色  的目录联接
			;账号部分
			if (AccountL!=AccountR[i])    ;不在同一账号下时
			{	
				IfNotEqual, ini_Settings_BackUPMod, 1, FileCopyDir, % AccountR[i] "\SavedVariables", % NowBakPath "\SavedVariables", 1    ;备份账号插件
				IfNotEqual, ini_Settings_BackUPMod, 1, FileCopy, % AccountR[i] "\config-cache.wtf", % NowBakPath "\config-cache.wtf", 1    ;备份账号设置
				IfNotEqual, ini_Settings_BackUPMod, 1, FileCopy, % AccountR[i] "\bindings-cache.wtf", % NowBakPath "\bindings-cache.wtf", 1    ;备份账号按键
				IfNotEqual, ini_Settings_BackUPMod, 1, FileCopy, % AccountR[i] "\macros-cache.txt", % NowBakPath "\macros-cache.txt", 1    ;备份账号宏
				FileRemoveDir, % AccountR[i] "\SavedVariables", 1    ;删除目标 账号\SavedVariables 文件夹（账号插件配置）
				FileDelete, % AccountR[i] "\config-cache.wtf"    ;删除目标 账号设置
				FileDelete, % AccountR[i] "\bindings-cache.wtf"    ;删除目标 按键设置
				FileDelete, % AccountR[i] "\macros-cache.txt"    ;删除目标 宏设置
				FileAppend, % "`r`nmklink /j " AccountR[i] "\SavedVariables " AccountL "\SavedVariables", ahkmklink.bat    ;账号\SavedVariables  的目录联接
				FileAppend, % "`r`nmklink /h " AccountR[i] "\config-cache.wtf " AccountL "\config-cache.wtf", ahkmklink.bat    ;账号设置  的文件硬连接
				FileAppend, % "`r`nmklink /h " AccountR[i] "\bindings-cache.wtf " AccountL "\bindings-cache.wtf", ahkmklink.bat    ;账号按键  的文件硬连接
				FileAppend, % "`r`nmklink /h " AccountR[i] "\macros-cache.txt " AccountL "\macros-cache.txt", ahkmklink.bat    ;账号宏  的文件硬连接
			}
			;生成联接文件（夹）
			RunWait, ahkmklink.bat,, Hide    ;运行批处理文件(隐藏)
			sleep, 1000
			FileDelete, ahkmklink.bat    ;删除该批处理文件
			;LUA配置变更
			WoW_ChgLuaProfileKeys(AccountL "\SavedVariables", CharacterR[i] " - " RealmR[i], CharacterL " - " RealmL) ;账号配置档变更
		}
	}
	
	;状态栏进度条恢复
	SB_SetProgress(0,4,"hide")
	SB_SetParts()	;状态栏合并为1
	
	;刷新列表
	gosub, GetCharacterList    ;从硬盘获取角色信息列表
	sleep 300
	Gui, Submit, NoHide
	RenewWTFLV(hLVL,cLVL,ini_Settings_IncdStrL,ini_Settings_NotIncdStrL) ;左筛选刷新
	RenewWTFLV(hLVR,cLVR,ini_Settings_IncdStrR,ini_Settings_NotIncdStrR) ;右筛选刷新
	;备份开启的时候启用下按钮
	if (ini_Settings_BackUPMod!=1)
	{
		Menu, MUBackUp, Enable, % MUNameBak[9]    ;按钮启用
		Try, Menu, MUBackUp, Rename, % MUNameBak[9], % MUNameBak[9]:="备份库(" FolderGetSize(BackupFolder,"m") "MB)"   ;菜单：备份库重命名
	}
	SB_SetText("覆盖完毕")
	Gui MainGui:-Disabled	;解冻主窗口
	WinActivate, ahk_id %hMainGui%    ;激活主窗口
	*/
return




;=======================================================================================================================
;模块GUI附属 |
;============

;GUI尺寸控制:
GuiSize_WTF:
	AutoXYWH("w h", "vLVWTF")
	gosub, ReColorWTFLV    ;LV重新上色
return