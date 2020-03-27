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
	Gui, MainGui:Add, ListView, xm+10 y+15 w740 h505 Section -Multi Count100 Grid AltSubmit vvWTFBak_LV hwndhWTFBak_LV ggWTFBak_LV, 空|dataIndex|序号|备份时间|文件大小|来源地
	
	global WTFBak := new WTFBakDataStorage()
	global BakGui := new WTFBakGUIListView(WTFBak, hWTFBak_LV)
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_WTFbackup:
	WTFBakGUIListView.backupWTFPath := WOW_EDITION ? (BACKUP_PATH "\" WOW_EDITION "\WTF") : ""    ;备份wtf路径
	GuiControl,, vWTFBak_EDbackupPath, % WTFBakGUIListView.backupWTFPath     ;WTF备份路径
	gosub, scanBackupPath
return

scanBackupPath:
	BakGui.dataIndex := WTFBak.AddData(WTFBakGUIListView.backupWTFPath, 1)    ;新建WTF类,路径扫描
	BakGui.UpdateLV(1)
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
	Switch A_GuiControl
	{
	Case "vWTFBak_BTopenPath1": GuiControlGet, path,, vWTFBak_EDbackupPath    ;WTF备份路径
	Default: return
	}
	if InStr(FileExist(path), "D")
		try Run % path
return

;=======================================================================================================================
;模块上控件动作 |
;==============
;LV列表
gWTFBak_LV:
{
	Gui MainGui:+Disabled
	if ((A_GuiEvent == "F") or (A_GuiEvent == "I")) and InStr(ErrorLevel, "S") and BakGui.UpdateLVSelected()    ;哨兵(产生了变化)
	{
		WTFBak.sels := BakGui.LVselected
		;按钮激活控制
		onlyOne := (BakGui.LVselCount == 1) ? 1 : 0
		notEmpty := BakGui.LVselCount ? 1 : 0
		GuiControl, % "Enable" onlyOne, vWTFBak_BTrestore   ;还原(只能一个)
		GuiControl, % "Enable" notEmpty, vWTFBak_BTdelete   ;删除(可以多选)
	}
	Gui MainGui:-Disabled
}
return


;还原
gWTFBak_BTrestore:
	if not (WTFBak.sels.Count() > 0)
		return
	sel := WTFBak.sels[1]
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	MsgBox, 52,, % "确定还原?`n`n序号: " sel.index "`n备份时间: " sel.time "`n角色: "  "`n账号: "  "`n`n" sel.nowPath "`n还原至:`r`n" sel.fromPath
	IfMsgBox Yes
	{
		WTFBak.RestoreBackup()
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 52,, % "是否保留备份文件?"
		IfMsgBox No
		{
			FilesDeleteEx(sel.nowPath, 1)
		}
		gosub, scanBackupPath
		sel := {}
		GuiControl, Disable, vWTFBak_BTrestore
		GuiControl, Disable, vWTFBak_BTdelete
		;申请深度刷新wtf页的两个LV
		NEED_DEEP_SCAN_WTF := 1   
	}
return


;删除
gWTFBak_BTdelete:
	if not (WTFBak.sels.Count() > 0)
		return
	sel := WTFBak.sels[1]
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	MsgBox, 52,, % "确定删除?`n`n序号: " sel.index "`n备份时间: " sel.time "`n角色: "  "`n账号: "  "`n`n删除路径:`n" sel.nowPath
	IfMsgBox Yes
	{
		WTFBak.DeleteBackup([sel])
		gosub, scanBackupPath
		sel := {}
		GuiControl, Disable, vWTFBak_BTrestore
		GuiControl, Disable, vWTFBak_BTdelete
	}
return



;=======================================================================================================================
;模块GUI附属 |
;============


;=======================================================================================================================
;模块GUI附属动作$函数 |
;======================
Class WTFBakGUIListView extends GUIListView
{
	static backupWTFPath := ""      ;备份wtf路径
	
	;更新规则,需要自设
	UpdateLVAdd(items)
	{
		for i, item in items
		{
			LV_Add(
			,
			, item.dataIndex
			, item.index
			, item.time
			, item.fileSize
			, item.fromPath)
		}
		LV_ModifyCol(1, 0)
		LV_ModifyCol(2, 0)
		LV_ModifyCol(3, "AutoHdr Logical")
		LV_ModifyCol(4, "AutoHdr Logical")
		LV_ModifyCol(5, "AutoHdr Logical Right")
		LV_ModifyCol(6, "AutoHdr Logical")
	}
}

;=======================================================================================================================
;WTF备份文件操作类 |
;===================
Class WTFBakDataStorage extends FileDataStorage
{
	static sels := {}                ;当前选择的项目
	static status := {}              ;数据整体状态
	static options := {}  ;数据控制选项
	
	;扫描给定的WTFBak目录,返回items
	UpdateData(dataIndex, dataPath)
	{
		dataItem := this.dataItems[dataIndex]    ;当前操作的WTFBak
		dataItem.items := {}
		i := 0
		Loop, Files, % dataPath "\Account@*", D    ;在备份文件夹WTF\内循环
		{
			FormatTime, time, % SubStr(A_LoopFileName, 9), yyyy/MM/dd HH:mm:ss  ;时间格式
			IniRead, fromPath, % A_LoopFileLongPath "\BackUpInfo.ini", Info, wtfPath, %A_Space%
			;~ IniRead, Accounts, % A_LoopFileLongPath "\BackUpInfo.ini", Account
			;~ IniRead, Players, % A_LoopFileLongPath "\BackUpInfo.ini", Player	
			i++
			dataItem.items[i] := {index     : i                                   ;序号
							    , time      : time                                ;日期
								, fileSize  : FilesSizeEx(A_LoopFileLongPath, "MB", "{1:0.1f} MB")     ;文件大小
								, fromPath  : fromPath "\Account"                 ;来自路径
								, nowPath   : A_LoopFileLongPath                  ;当前路径
								, dataIndex : dataIndex}                          ;数据序号
		}
	}
	
	;还原
	RestoreBackup(item)
	{
		FolderCopyEx(item.nowPath, item.fromPath, "overWrite", true)    ;覆盖写入(先移除其中的链接目录)
		FilesDeleteEx(item.fromPath "\BackUpInfo.ini")    ;删除复制过去的ini 
	}
	
	;删除
	DeleteBackup(items)
	{
		for i, item in items
		{
			FilesDeleteEx(item.nowPath, 1)
		}
	}
}

