ExitApp
;=======================================================================================================================
;WoWLocalFilesManagement模块:
;Mod = WTFbackup
;控件前缀: WTFBak_
;需修改下面三个线程名称: AddMod_, GuiSize_, GuiInit_
;=======================================================================================================================
;新增模块所需函数库 |
;==================

;=======================================================================================================================
;新增模块线程 |
;=============
AddMod_WTFbackup:
	;模块部署
	
	;在MainGui的TAB上:
	Gui, MainGui:Add, Text, xm+10 ym+33 w60 h22 Center Section, 备份路径
	Gui, MainGui:Add, Edit, x+0 yp-3 w660 h22 ReadOnly vvWTFBak_EDbackupPath, 备份路径
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvWTFBak_BTopenPath1 hwndhWTFBak_BTopenPath1 ggWTFBak_BTopenPath, ; 打开目录
	IB_Opts_OpenFile := [[0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"]]    ;ImageButton配色(打开文件夹)
	ImageButton.Create(hWTFBak_BTopenPath1, IB_Opts_OpenFile*)
	Gui, MainGui:Add, Button, xs y+5 w80 h45 Disabled vvWTFBak_BTrestore ggWTFBak_BTrestore, 还原
	Gui, MainGui:Add, Button, x+5 yp wp hp Disabled vvWTFBak_BTdelete ggWTFBak_BTdelete, 删除
	Gui, MainGui:Add, GroupBox, x+5 yp w500 h55, 批量删除
	Gui, MainGui:Add, Button, xp+10 yp+20 h25 vvWTFBak_BTdelete7 Disabled, 删除一周之前的
	Gui, MainGui:Add, Button, x+5 yp hp vvWTFBak_BTdelete30 Disabled, 删除一个月之前的
	Gui, MainGui:Add, Button, x+5 yp hp vvWTFBak_BTdelete365 Disabled, 删除一年之前的
	Gui, MainGui:Add, Button, x+5 yp hp vvWTFBak_BTdelete0 Disabled, 删除全部
	Gui, MainGui:Add, ListView, xm+10 y+15 w740 h505 Section Count100 -Multi Grid AltSubmit vvWTFBak_LV hwndhWTFBak_LV ggWTFBak_LV, 序号|备份时间|文件大小|来源地
	;~ Gui, MainGui:Add, 
	
	global BakGui := new WTFBakGUIGroup(WTFBak, hWTFBak_LV)
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_WTFbackup:
	GuiControl,, vWTFBak_EDbackupPath, % BACKUP_PATH "\" WOW_EDITION "\WTF\"     ;WTF备份路径
	gosub, scanBackupPath
return

scanBackupPath:
	BakGui.WTFBakIndex := WTFBak.AddPath(BACKUP_PATH "\" WOW_EDITION "\WTF\", 1)    ;新建WTF类,路径扫描
	BakGui.UpdataLV()
return



;=======================================================================================================================
;Tab进此模块时执行的命令 |
;=======================
GuiTabIn_WTFbackup:
	gosub, GuiInit_WTFbackup
return


;=======================================================================================================================
;打开路径按钮 |
;==============
gWTFBak_BTopenPath:
	Gui, MainGui:Submit, NoHide
	Switch A_GuiControl
	{
	Case "vWTFBak_BTopenPath1": Run % vWTFBak_EDbackupPath
	}
return

;=======================================================================================================================
;模块上控件动作 |
;==============
;LV列表
gWTFBak_LV:
{
	if (A_GuiEvent == "F") or ((rowIndex := LV_GetNext()) <> lastRowIndex)
	{
		lastRowIndex := rowIndex
		if rowIndex
		{
			LV_GetText(i, rowIndex,1)
			LV_GetText(t, rowIndex,2)
			LV_GetText(players, rowIndex,3)
			LV_GetText(account, rowIndex,4)
			LV_GetText(wtfPath, rowIndex,5)
			LV_GetText(path, rowIndex,6)
			BULVs := {i:i, t:t, players:players, account:account, wtfPath:wtfPath, path:path}
			GuiControl, Enable, vWTFBak_BTrestore
			GuiControl, Enable, vWTFBak_BTdelete
		}
		else
		{
			BULVs := {}
			GuiControl, Disable, vWTFBak_BTrestore
			GuiControl, Disable, vWTFBak_BTdelete
		}
	}
}
return

;还原
gWTFBak_BTrestore:
	if not (BULVs.Count() > 0)
		return
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	MsgBox, 52,, % "确定还原?`n`n序号: " BULVs.i "`n备份时间: " BULVs.t "`n角色: " BULVs.players "`n账号: " BULVs.account "`n`n" BULVs.path "`n还原至:`r`n" BULVs.wtfPath
	IfMsgBox Yes
	{
		FolderCopyEx(BULVs.path, BULVs.wtfPath, "overWrite", true)    ;覆盖写入(先移除其中的链接目录)
		FilesDeleteEx(BULVs.wtfPath "\BackUpInfo.ini")    ;删除复制过去的ini
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 52,, % "是否保留备份文件?"
		IfMsgBox No
		{
			FilesDeleteEx(BULVs.path, 1)
		}
		gosub, scanBackupPath
		BULVs := {}
		GuiControl, Disable, vWTFBak_BTrestore
		GuiControl, Disable, vWTFBak_BTdelete
		;申请深度刷新wtf页的两个LV
		NEED_DEEP_SCAN_WTF := 1   
	}
return

;删除
gWTFBak_BTdelete:
	if not (BULVs.Count() > 0)
		return
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	MsgBox, 52,, % "确定删除?`n`n" BULVs.i "`n" BULVs.t "`n" BULVs.players "`n" BULVs.account "`n" BULVs.wtfPath "`n" BULVs.path
	IfMsgBox Yes
	{
		FilesDeleteEx(BULVs.path, 1)
		gosub, scanBackupPath
		BULVs := {}
		GuiControl, Disable, vWTFBak_BTrestore
		GuiControl, Disable, vWTFBak_BTdelete
	}
return



;=======================================================================================================================
;模块GUI附属 |
;============


;=======================================================================================================================
;模块GUI附属动作$函数 |
;====================

;=======================================================================================================================
;WTF的GUI控件类 |
;================
Class WTFBakGUIGroup
{
	static wowWTFPath := ""         ;魔兽wtf路径
	static savedWTFPath := ""       ;自定义存储wtf路径
	static backupWTFPath := ""      ;备份wtf路径
	static switchLVColor := true    ;列表颜色显隐开关
	static classIndex := 0          ;职业筛选
	
	__New(WTFBak, hLV)
	{
		this.WTFBak := WTFBak
		, this.hLV := hLV
		, this.WTFpath         := WTFpath          ;当前选取WTF路径
		, this.WTFBakIndex        := 0                ;当前WTF表序号
		, this.lastWTFBakIndex    := 0
	}
	
	;更新LV
	UpdataLV()
	{
		if (this.WTFBakIndex = lastWTFBakIndex)    ;WTF和之前一样
			return
		else
			this.lastWTFBakIndex := this.WTFBakIndex
		Gui, ListView, % this.hLV    ;选择操作表
		GuiControl, -Redraw, % this.hLV
		LV_Delete()
		for i, item in this.WTFBak.WTFBakItems[this.WTFBakIndex].items
		{
			LV_Add(
			, item.index
			, item.time
			, item.fileSize
			, item.fromPath)
		}
		LV_ModifyCol(1, "AutoHdr")
		LV_ModifyCol(2, "AutoHdr")
		GuiControl, +Redraw, % this.hLV
	}
}

;=======================================================================================================================
;WTF备份文件操作类 |
;==================
Class WTFBak
{
	static WTFBakItems := {}    ;历史WTF成员集合
	static WTFBakIndex := 0     ;当前WTF的index
	
	;新增WTFBak, 返回当前的WTFBakIndex
	AddPath(WTFBakPath, force := false)
	{
		for i, WTFBakItem in this.WTFBakItems    ;在WTFBak历史中寻找
		{
			if (WTFBakItem.WTFBakPath == WTFBakPath)    ;这是历史中的WTFBak,则直接调用历史
			{
				this.WTFBakIndex := i
				this.ScanWTFBak(this.WTFBakIndex, WTFBakPath, force)
				return this.WTFBakIndex
			}
		}
		;历史中没有时就新建
		this.WTFBakIndex++
		this.WTFBakItems[this.WTFBakIndex] := {}
		this.ScanWTFBak(this.WTFBakIndex, WTFBakPath, force)
		return this.WTFBakIndex
	}
	
	;扫描给定的WTF目录,返回items
	ScanWTFBak(WTFBakIndex, WTFBakPath, force := false)
	{
		WTFBakItem := this.WTFBakItems[WTFBakIndex]    ;当前操作的WTFBak
		if (WTFBakPath = WTFBakItem.WTFBakPath and force = false)    ;与上次输入的相同时返回
			return
		WTFBakItem.WTFBakPath := WTFBakPath
		, WTFBakItem.items := {}
		if not InStr(FileExist(WTFBakPath), "D")    ;目录错误时
			return
		i := 0
		Loop, Files, % WTFBakPath "\Account@*", D    ;在备份文件夹WTF\内循环
		{
			FormatTime, time, % SubStr(A_LoopFileName, 9), yyyy/MM/dd HH:mm:ss  ;时间格式
			IniRead, fromPath, % A_LoopFileLongPath "\BackUpInfo.ini", Info, wtfPath, %A_Space%
			;~ IniRead, Accounts, % A_LoopFileLongPath "\BackUpInfo.ini", Account
			;~ IniRead, Players, % A_LoopFileLongPath "\BackUpInfo.ini", Player	
			i++
			WTFBakItem.items[i] := {index     : i                                   ;序号
								  , time      : time                                ;日期
								  , fileSize  : A_LoopFileSize                      ;文件大小
								  , fromPath  : fromPath "\Account"}                ;来自路径
		}
	}
}