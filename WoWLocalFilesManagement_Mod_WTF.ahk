ExitApp
;=======================================================================================================================
;WoWLocalFilesManagement模块:
;Mod = WTF
;控件前缀: WTF_
;需修改下面三个线程名称: AddMod_, GuiSize_, GuiInit_
;=======================================================================================================================
;新增模块所需函数库 |
;==================

;=======================================================================================================================
;新增模块线程 |
;=============
AddMod_WTF:
	;模块部署
	global WTF_ITEMS := []    ;储存硬盘扫描后全部的数据
	global WTF_ITEMS_SELECTED := []    ;从列表中选择的
	global WTF_ITEMS_SOURCE := []    ;从源角色
	global WTF_ITEMS_TARGET := []    ;从目标角色
	
	;在MainGui的TAB上:
	Gui, MainGui:Add, Text, xm+10 ym+32 h22 w57 Section, 游戏路径:
	Gui, MainGui:Add, Edit, x+0 yp-2 hp w560 ReadOnly vvWTF_EDnowPath, 当前目录
	Gui, MainGui:Add, Button, x+0 yp w100 hp vvWTF_BTreScan ggWTF_BTreScan, 重新扫描硬盘
	
	Gui, MainGui:Add, Text, xs y+10 w30 h22, 包含:
	Gui, MainGui:Add, Edit, x+0 yp-2 w100 hp vini_WTF_include ggWTF_EDfilter, 包含
	Gui, MainGui:Add, Text, x+10 yp+2 w30 hp , 不含:
	Gui, MainGui:Add, Edit, x+0 yp-2 w100 hp vini_WTF_notInclude ggWTF_EDfilter, 不含
	
	Gui, MainGui:Add, Edit, xm+10 y+8 w310 h22 ReadOnly Section vvWTF_EDsource,
	Gui, MainGui:Add, Button, xp y+0 wp hp vvWTF_EDaddSource ggWTF_EDaddSource, 源角色↑    ;添加到源角色
	
	Gui, MainGui:Font, bold     ;粗体
	Gui, MainGui:Add, Button, x+0 ys w100 h22, 配置覆盖>>
	Gui, MainGui:Add, Button, xp y+0 wp hp, <<配置同步
	Gui, MainGui:Font, norm     ;恢复
	
	Gui, MainGui:Add, Edit, x+0 ys w310 h22 ReadOnly vvWTF_EDtarget,
	Gui, MainGui:Add, Button, xp y+0 wp hp vvWTF_EDaddTarget ggWTF_EDaddTarget, 目标角色↑    ;添加到目标角色
	
	;~ Gui, MainGui:Add, Button, x+0 yp w100 hp Section ggWTF_EDremoveAll, X    ;清空全部
	
	
	Gui, MainGui:Add, ListView, xm+10 y+0 h300 w720 Grid AltSubmit vvLVWTF HwndhLVWTF ggLVWTF, 账号|服务器|角色|角色信息
	
	;~ Gui, MainGui:Add, 
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_WTF:
	;筛选
	GuiControl,, ini_WTF_include, % INI.Init("WTF", "include")    ;包含
	GuiControl,, ini_WTF_notInclude, % INI.Init("WTF", "notInclude")    ;包含
	;扫描目录
	GuiControl,, vWTF_EDnowPath, % WOW_PATH "\" WOW_EDITION    ;当前目录
	gosub, gWTF_BTreScan
return

;=======================================================================================================================
;Tab进此模块时执行的命令 |
;=======================
GuiTabIn_WTF:
	if (vWTF_EDnowPath <> WOW_PATH "\" WOW_EDITION)    ;地址发生变化时,重新初始化
	{
		gosub, GuiInit_WTF
	}
return


;=======================================================================================================================
;模块上控件动作 |
;==============
;按钮动作:重新扫描
gWTF_BTreScan:
	WTF_ITEMS := ScanWTF(WOW_PATH "\" WOW_EDITION "\WTF")
	RenewWTFLV(hLVWTF, WTF_ITEMS, ini_WTF_include, ini_WTF_notInclude)    ;LV刷新
	SB_SetText("WTF目录扫描完毕,列表已刷新")
	gosub, gLVWTF   ;刷新已选择
return

;筛选动作
gWTF_EDfilter:
	Gui, MainGui:Submit, NoHide
	RenewWTFLV(hLVWTF, WTF_ITEMS, ini_WTF_include, ini_WTF_notInclude)    ;LV刷新
return

;按钮动作:将选中添加到源角色
gWTF_EDaddSource:
	Gui, MainGui:Submit, NoHide
	WTF_ITEMS_SOURCE := CopyArray(WTF_ITEMS_SELECTED)
	GuiControl,, vWTF_EDsource, % GetShowStrFromWTFItems(WTF_ITEMS_SOURCE)
	WTF_ITEMS_SELECTED := []
	gosub, gWTF_EDaddSeleted
return

;按钮动作:将选中添加到目标角色
gWTF_EDaddTarget:
	Gui, MainGui:Submit, NoHide
	WTF_ITEMS_TARGET := CopyArray(WTF_ITEMS_SELECTED)
	GuiControl,, vWTF_GBtarget, % "目标角色 " c := WTF_ITEMS_TARGET.count()
	GuiControl,, vWTF_EDtarget, % GetShowStrFromWTFItems(WTF_ITEMS_TARGET)
	WTF_ITEMS_SELECTED := []
	gosub, gWTF_EDaddSeleted
return

;隐藏按钮动作:刷新selected
gWTF_EDaddSeleted:
	;界面文字变动
	GuiControl,, vWTF_GBseleted, % "已选择 " c := WTF_ITEMS_SELECTED.count()
	GuiControl,, vWTF_EDseleted, % GetShowStrFromWTFItems(WTF_ITEMS_SELECTED)
	;按钮控制:添加到源角色
	v := (c == 1) ? 1 : 0
	GuiControl, Enable%v%, vWTF_EDaddSource
	v := (c > 0) ? 1 : 0
	GuiControl, Enable%v%, vWTF_EDaddTarget
return

;按钮动作:删除三个
gWTF_EDremoveAll:
	WTF_ITEMS_SELECTED := []    ;从列表中选择的
	WTF_ITEMS_SOURCE := []    ;从源角色
	WTF_ITEMS_TARGET := []    ;从目标角色
	gosub, gWTF_EDaddSource
	gosub, gWTF_EDaddTarget
return

;LV列表动作
gLVWTF:
	;添加到已选择数组
	WTF_ITEMS_SELECTED := []
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(Account, RowNumber, 1)      ;账号
		LV_GetText(Realm, RowNumber, 2)        ;服务器
		LV_GetText(Character, RowNumber, 3)    ;角色
		WTF_ITEMS_SELECTED.push([Account,Realm,Character])
	}
	gosub, gWTF_EDaddSeleted
return

;由数组获取显示的字符串
GetShowStrFromWTFItems(items)
{
	showStr := ""
	loop % c := items.count()
	{
		showStr .= items[A_index][3] "-" items[A_index][2] "`n"
	}
	return Trim(showStr, "`n")
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
		playerInfoLua := ""    ;清空角色信息obj
		;文件夹WTF\Account\某账号内循环
		Loop, Files, % A_LoopFileLongPath "\*", D    
		{
			Realm := A_LoopFileName    ;服务器名称
			if (Realm = "SavedVariables")    ;账号信息保存位置
			{
				;获取角色信息
				if FileExist(A_LoopFileLongPath "\PlayerInfo.lua")
					playerInfoLua := new WowAddOnSaveLua(A_LoopFileLongPath "\PlayerInfo.lua")
				continue
			}
			;文件夹WTF\Account\某账号\某服务器内循环
			Loop, Files, % A_LoopFileLongPath "\*", D    
			{
				Character := A_LoopFileName    ;角色名称
				if (Character = "(null)")    ;排除(null)
					continue
				;向数组内添加信息[账号，服务器，角色]
				items.push({Account:Account,Realm:Realm,Character:Character})
			}
		}
		;账号内循环结束后,将玩家信息添加进items
		if (playerInfoLua == "")
			continue
		loop % items.Count() - index
		{
			index++
			items[index].Character "-" items[index].Realm
			if (info := playerInfoLua.Get([items[index].Character "-" items[index].Realm,"class"]).Value)
				items[index].PlayerClass := info
		}
	}
	return items
}



;根据数组数据刷新LV列表
RenewWTFLV(LVHwnd, items, include := "", notInclude:= "")
{
	Gui, ListView, %LVHwnd%    ;选择操作表
	LV_Delete()
	GuiControl, -Redraw, %LVHwnd%    ;在加载时禁用重绘来提升性能.
	for i, item in items
	{
		Account     := item.Account      ;账号
		Realm       := item.Realm        ;服务器
		Character   := item.Character    ;角色
		PlayerClass := item.PlayerClass  ;职业
		;筛选
		str := Account "`n" Realm "`n" Character "`n" PlayerClass    ;拼合成字串
		if (include <> "" and !InStr(str, include)) or (notInclude <> "" and InStr(str, notInclude))
			continue
		;LV新增行
		LV_Add(, Account, Realm, Character, PlayerClass)
	}
	LV_ModifyCol(1,"AutoHdr")
	LV_ModifyCol(2,"AutoHdr")
	LV_ModifyCol(3,"AutoHdr")
	LV_ModifyCol(4,"AutoHdr")
	GuiControl, +Redraw, %LVHwnd%  ; 重新启用重绘 (上面把它禁用了).
}







;=======================================================================================================================
;模块GUI附属 |
;============

;GUI尺寸控制:
GuiSize_WTF:
	AutoXYWH("wh", "vLVWTF")
	AutoXYWH("x", "vWTF_BTreScan")
	AutoXYWH("w", "vWTF_EDnowPath")
return


;=======================================================================================================================
;模块GUI附属动作$函数 |
;====================
