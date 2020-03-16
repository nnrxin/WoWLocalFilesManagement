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
;=======================================================================================================================
;新增模块线程 |
;=============
AddMod_WTF:
	;模块部署
	global WTF_ITEMS := []    ;储存硬盘扫描后全部的数据
	global WTF_ITEMS_SELECTED := []    ;从列表中选择的
	global WTF_ITEMS_SOURCE := []    ;从源角色
	global WTF_ITEMS_TARGET := []    ;从目标角色
	
	;开关模式起始值
	global SWITCH_PATHSCAN := 0   ;起始扫描位置
	global SWITCH_LVADD := 0    ;起始LV添加位置
	
	;在MainGui的TAB上:
	;路径切换
	Gui, MainGui:Font, bold     ;粗体
	Gui, MainGui:Add, Button, xm+10 ym+32 w95 h22 Section vvWTF_BTwowPath hwndhWTF_BTwowPath ggWTF_BTscanPath, 魔兽世界路径
	IB_Opts := [[0,0xCCCCCC,,0x838383],[,0xCCE8CF],[,0xCCE8CF],[,0xCCE8CF,,"black"]]    ;ImageButton配色(激活时灰色,未激活时绿色)
	ImageButton.Create(hWTF_BTWoWPath, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, norm     ;恢复
	Gui, MainGui:Add, Edit, x+0 yp hp w540 ReadOnly vvWTF_EDwowPath, 
	
	Gui, MainGui:Font, bold     ;粗体
	Gui, MainGui:Add, Button, xs y+5 w95 h22 vvWTF_BTrealPath hwndhWTF_BTrealPath ggWTF_BTscanPath, 自定义存储路径
	ImageButton.Create(hWTF_BTrealPath, IB_Opts*)   ;彩色按钮
	Gui, MainGui:Font, norm     ;恢复
	Gui, MainGui:Add, Edit, x+0 yp hp w540 ReadOnly vvWTF_EDrealPath, 
	
	
	;筛选
	Gui, MainGui:Font, bold     ;粗体
	Gui, MainGui:Add, GroupBox, xm+10 y+5 w720 h54, % "列表筛选"
	Gui, MainGui:Font, norm     ;恢复
	Gui, MainGui:Add, Text, xp+10 yp+22 w30 h22, 包含:
	Gui, MainGui:Add, Edit, x+0 yp-2 w80 hp vini_WTF_include ggWTF_EDfilter, 包含
	Gui, MainGui:Add, Text, x+10 yp+2 w30 hp , 不含:
	Gui, MainGui:Add, Edit, x+0 yp-2 w80 hp vini_WTF_notInclude ggWTF_EDfilter, 不含
	;筛选框职业图片按钮:
	picPath := "pic\classicon"
	Gui, MainGui:Add, Button, x+10 yp-6 w34 h34 ggBTSetPassed hwndhBTSetPassed1 vvBTSetPassed1 ,
	ImageButton.Create(hBTSetPassed1, [0,picPath "\1.ico"], [,picPath "\L1.png"],, [,picPath "\G1.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed2 vvBTSetPassed2 ,
	ImageButton.Create(hBTSetPassed2, [0,picPath "\2.ico"], [,picPath "\L2.png"],, [,picPath "\G2.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed3 vvBTSetPassed3 ,
	ImageButton.Create(hBTSetPassed3, [0,picPath "\3.ico"], [,picPath "\L3.png"],, [,picPath "\G3.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed4 vvBTSetPassed4 ,
	ImageButton.Create(hBTSetPassed4, [0,picPath "\4.ico"], [,picPath "\L4.png"],, [,picPath "\G4.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed5 vvBTSetPassed5 ,
	ImageButton.Create(hBTSetPassed5, [0,picPath "\5.ico"], [,picPath "\L5.png"],, [,picPath "\G5.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed6 vvBTSetPassed6 ,
	ImageButton.Create(hBTSetPassed6, [0,picPath "\6.ico"], [,picPath "\L6.png"],, [,picPath "\G6.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed7 vvBTSetPassed7 ,
	ImageButton.Create(hBTSetPassed7, [0,picPath "\7.ico"], [,picPath "\L7.png"],, [,picPath "\G7.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed8 vvBTSetPassed8 ,
	ImageButton.Create(hBTSetPassed8, [0,picPath "\8.ico"], [,picPath "\L8.png"],, [,picPath "\G8.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed9 vvBTSetPassed9 ,
	ImageButton.Create(hBTSetPassed9, [0,picPath "\9.ico"], [,picPath "\L9.png"],, [,picPath "\G9.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed10 vvBTSetPassed10 ,
	ImageButton.Create(hBTSetPassed10, [0,picPath "\10.ico"], [,picPath "\L10.png"],, [,picPath "\G10.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed11 vvBTSetPassed11 ,
	ImageButton.Create(hBTSetPassed11, [0,picPath "\11.ico"], [,picPath "\L11.png"],, [,picPath "\G11.png"])
	Gui, MainGui:Add, Button, x+1 yp wp hp ggBTSetPassed hwndhBTSetPassed12 vvBTSetPassed12 ,
	ImageButton.Create(hBTSetPassed12, [0,picPath "\12.ico"], [,picPath "\L12.png"],, [,picPath "\G12.png"])
	Gui, MainGui:Add, Button, x+6 yp w34 h34 ggWTF_BTclean hwndhWTF_BTclean, 重置    ;清空全部
	ImageButton.Create(hWTF_BTclean, [0,0xE1E1E1,,"red",,,0xADADAD],[,0xE5F1FB],[,0xCCE4F7])
	
	;主体
	Gui, MainGui:Font, bold     ;粗体
	Gui, MainGui:Add, Edit, xm+10 y+18 w310 h22 ReadOnly Section vvWTF_EDsource,
	Gui, MainGui:Add, Button, xp y+0 wp hp vvWTF_BTaddSource hwndhWTF_BTaddSource ggWTF_BTaddTo, 源角色    ;添加到源角色
	ImageButton.Create(hWTF_BTaddSource, IB_Opts*)   ;彩色按钮
	
	Gui, MainGui:Add, Button, x+0 ys w100 h22 vvBT_WTFcopy Disabled, >>配置覆盖>>
	Gui, MainGui:Add, Button, xp y+0 wp hp vvBT_WTFsyn Disabled, <<配置同步<<
	
	Gui, MainGui:Add, Edit, x+0 ys w310 h22 ReadOnly vvWTF_EDtarget,
	Gui, MainGui:Add, Button, xp y+0 wp hp vvWTF_BTaddTarget hwndhWTF_BTaddTarget ggWTF_BTaddTo, 目标角色    ;添加到目标角色(默认禁用)
	ImageButton.Create(hWTF_BTaddTarget, IB_Opts*)   ;彩色按钮
	
	
	Gui, MainGui:Font, norm     ;恢复
	Gui, MainGui:Add, ListView, xm+10 y+0 h300 w720 Count300 -Multi Grid AltSubmit vvLVWTF HwndhLVWTF ggLVWTF, 账号|服务器|角色|职业|插件账号共享配置文件夹(SavedVariables)链接地址|角色文件夹链接地址
	;~ global LVWTF_COLOR := New LV_Colors(hLVWTF)    ;LV上色(弊端:无法拖动排序了)
	;~ Gui, MainGui:Add, 
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_WTF:
	;目录位置刷新
	GuiControl,, vWTF_EDwowPath, % WOW_PATH "\" WOW_EDITION    ;wow目录刷新
	GuiControl,, vWTF_EDrealPath, % REAL_PATH "\" WOW_EDITION    ;wow目录确定
	;路径选择
	GuiControl, Enable%SWITCH_PATHSCAN%, vWTF_BTwowPath    ;魔兽路径
	GuiControl, Disable%SWITCH_PATHSCAN%, vWTF_BTrealPath    ;真实存档路径
	;筛选选项
	GuiControl,, ini_WTF_include, % INI.Init("WTF", "include")    ;包含
	GuiControl,, ini_WTF_notInclude, % INI.Init("WTF", "notInclude")    ;包含
	;LV添加位置按钮控制
	GuiControl, Enable%SWITCH_LVADD%, vWTF_BTaddSource    ;源角色
	GuiControl, Disable%SWITCH_LVADD%, vWTF_BTaddTarget    ;目标角色

	gosub, scanNewPath
return

;=======================================================================================================================
;Tab进此模块时执行的命令 |
;=======================
GuiTabIn_WTF:
	if (vWTF_EDwowPath <> WOW_PATH "\" WOW_EDITION)    ;魔兽地址发生变化时,重新初始化
	or (vWTF_EDrealPath <> REAL_PATH "\" WOW_EDITION)    ;自定义地址发生变化时,重新初始化
	{
		gosub, GuiInit_WTF
	}
return


;=======================================================================================================================
;路径切换及扫描 |
;==============
;选择魔兽/自定义存储路径
gWTF_BTscanPath:
	Gui, MainGui:Submit, NoHide
	;开关切换
	SWITCH_PATHSCAN := 1 - SWITCH_PATHSCAN    
	GuiControl, Enable%SWITCH_PATHSCAN%, vWTF_BTwowPath    ;魔兽路径
	GuiControl, Disable%SWITCH_PATHSCAN%, vWTF_BTrealPath    ;真实存档路径
	;扫描新路径
	gosub, scanNewPath
return
;扫描路径
scanNewPath:
	WTF_ITEMS := ScanWTF((SWITCH_PATHSCAN ? REAL_PATH : WOW_PATH) "\" WOW_EDITION "\WTF")    ;路径扫描
	gosub, gWTF_EDfilter    ;筛选动作
	SB_SetText("WTF目录扫描完毕,列表已刷新")
	gosub, gLVWTF   ;刷新已选择
return

;=======================================================================================================================
;筛选 |
;=====
;筛选框
gWTF_EDfilter:
	Gui, MainGui:Submit, NoHide
	RenewWTFLV(hLVWTF, LVWTF_COLOR, WTF_ITEMS, ini_WTF_include, ini_WTF_notInclude)    ;LV刷新
return

;清空
gWTF_BTclean:

return


;角色筛选按钮
gBTSetPassed:

return

;=======================================================================================================================
;LV刷新,点击输入ED等 |
;====================
;添加到源角色/目标角色
gWTF_BTaddTo:
	SWITCH_LVADD := 1 - SWITCH_LVADD    ;开关切换
	GuiControl, Enable%SWITCH_LVADD%, vWTF_BTaddSource
	GuiControl, Disable%SWITCH_LVADD%, vWTF_BTaddTarget
	GuiControl, % (SWITCH_LVADD?"+":"-") "Multi", vLVWTF   ;LV启用/禁用多行
return

;LV列表动作
gLVWTF:
	;未选择行时返回
	if (A_EventInfo == 0)
		return
	;添加到已选择数组
	WTF_ITEMS_SELECTED := []
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(Account, RowNumber, 1)      ;账号
		LV_GetText(Realm, RowNumber, 2)        ;服务器
		LV_GetText(Player, RowNumber, 3)    ;角色
		WTF_ITEMS_SELECTED.push({Account:Account,Realm:Realm,Player:Player})
	}
	;添加到编辑框
	if (SWITCH_LVADD == 0)    ;添加到源 
	{
		WTF_ITEMS_SOURCE := CopyArray(WTF_ITEMS_SELECTED)
		GuiControl,, vWTF_EDsource, % showTxt := GetShowStrFromWTFItems(WTF_ITEMS_SOURCE)    ;编辑框
		SB_SetText("已选择源角色:" showTxt)
	}
	else    ;添加到目标
	{
		WTF_ITEMS_TARGET := CopyArray(WTF_ITEMS_SELECTED)
		GuiControl,, vWTF_EDTarget, % showTxt := GetShowStrFromWTFItems(WTF_ITEMS_TARGET)    ;编辑框
		SB_SetText("已选择目标角色(" WTF_ITEMS_TARGET.Count() "):" showTxt)
	}
	;覆盖/同步按钮的激活控制
	GuiControl, % "Enable" (WTF_ITEMS_TARGET[1] && WTF_ITEMS_SOURCE[1]), vBT_WTFcopy ;列表同时选取了两侧的选择了文件，按钮才会显示出来
	GuiControl, % "Enable" (WTF_ITEMS_TARGET[1] && WTF_ITEMS_SOURCE[1]), vBT_WTFsyn ;列表同时选取了两侧的选择了文件，按钮才会显示出来
return

;由数组获取显示的字符串
GetShowStrFromWTFItems(items)
{
	if (items.count() == 0)
		return ""
	showStr := ""
	for i, item in items
	{
		showStr .= item.Player "-" item.Realm "(" item.Account (SWITCH_PATHSCAN?"@自定义存储":"@魔兽世界") "); `n"
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
				items.push({Account:Account,Realm:Realm,Player:Player,PlayerRealPath:PlayerRealPath})
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

;根据数组数据刷新LV列表
RenewWTFLV(LVHwnd, cLV, items, include := "", notInclude:= "")
{
	Gui, ListView, %LVHwnd%    ;选择操作表
	LV_Delete()
	cLV.Clear()
	GuiControl, -Redraw, %LVHwnd%    ;在加载时禁用重绘来提升性能.
	for i, item in items
	{
		Account         := item.Account           ;账号
		Realm           := item.Realm             ;服务器
		Player          := item.Player            ;角色
		PlayerClass     := WoW_GetClassInfo(item.PlayerClass).nameCNShort        ;职业
		AccountRealPath := item.AccountRealPath   ;账号链接
		PlayerRealPath  := item.PlayerRealPath    ;角色链接
		;筛选
		str := Account "`n" Realm "`n" Player "`n" PlayerClass    ;拼合成字串
		if (include <> "" and !InStr(str, include)) or (notInclude <> "" and InStr(str, notInclude))
			continue
		;LV新增行
		LV_Add(, Account, Realm, Player, PlayerClass, AccountRealPath, PlayerRealPath)
		;单元格染色
		if (cLV and rowIndex := LV_GetCount())
		{
			BCol := WoW_GetClassInfo(item.PlayerClass).color    ;默认背景颜色=职业颜色
			TCol := 0x1A0F09    ;默认文字颜色=深棕
			cLV.Cell(rowIndex, 2, BCol, TCol)
			cLV.Cell(rowIndex, 3, BCol, TCol)
			cLV.Cell(rowIndex, 4, BCol, TCol)
		}
	}
	
	
	LV_ModifyCol(1,"AutoHdr")
	LV_ModifyCol(2,"AutoHdr")
	LV_ModifyCol(3,"AutoHdr")
	LV_ModifyCol(4,"AutoHdr")
	LV_ModifyCol(5,"AutoHdr")
	LV_ModifyCol(6,"AutoHdr")
	GuiControl, +Redraw, %LVHwnd%  ; 重新启用重绘 (上面把它禁用了).
}

;=======================================================================================================================
;复制/同步动作|
;=============










;=======================================================================================================================
;模块GUI附属 |
;============

;GUI尺寸控制:
GuiSize_WTF:
	AutoXYWH("wh", "vLVWTF")
return