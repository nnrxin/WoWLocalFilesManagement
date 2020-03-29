;=======================================================================================================================
;WoWLocalFilesManagement:魔兽世界本地文档管理:角色配置复制或同步;配置及插件的异地存储等
;by:nnrxin
;email:nnrxin@163.com
;=======================================================================================================================
;自动运行段 |
;===========

;运行参数
#NoEnv
#NoTrayIcon
#SingleInstance ignore    ;不能双开
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#MaxMem 1000
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
global APP_NAME      := "WoWLocalFilesManagement"            ;APP名称
global APP_NAME_CN   := "魔兽世界本地文件管理工具WOW-LFM"    ;APP中文名称
global APP_VERSION   := 0.6                                  ;当前版本
global APP_DATA_PATH := A_AppData "\" APP_NAME               ;在系统AppData的保存位置
FileCreateDir, % APP_DATA_PATH                               ;路径不存在时需要新建

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
Gui, MainGui:Add, Tab3, xm ym w760 h630 AltSubmit vini_MainGui_MainTab HwndhMainTab ggMainTab,   ;主标签
Gui, MainGui:Font, cDefault norm, 微软雅黑 Light

;加载各模块及其Tab
global MODS := []
GuiAddTabMod("MainGui", "ini_MainGui_MainTab", MODS, "基本设置", "Setting")
GuiAddTabMod("MainGui", "ini_MainGui_MainTab", MODS, "控制台", "WTFconfig")
GuiAddTabMod("MainGui", "ini_MainGui_MainTab", MODS, "WTF", "WTF")
GuiAddTabMod("MainGui", "ini_MainGui_MainTab", MODS, "WTF备份", "WTFbackup")
GuiAddTabMod("MainGui", "ini_MainGui_MainTab", MODS, "插件", "AddOns")
GuiAddTabMod("MainGui", "ini_MainGui_MainTab", MODS, "关于", "About")

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
#Include WoWLocalFilesManagement_Mod_WTFconfig.ahk
#Include WoWLocalFilesManagement_Mod_WTF.ahk
#Include WoWLocalFilesManagement_Mod_WTFbackup.ahk
#Include WoWLocalFilesManagement_Mod_AddOns.ahk
#Include WoWLocalFilesManagement_Mod_About.ahk



;=======================================================================================================================
;GUI LV控制类 |
;==============
;无法单独使用,只能派生成特定的类使用
;需要类:LV_Colors
Class GUIListView
{
	__New(data, hLV, hEDselected := "" , hEDinclude := "", hEDexclude := "", hSpec := "", cLV := false)
	{
		this.data                := data
		, this.dataIndex         := 0              ;当前数据组的dataIndex
		, this.lastDataIndex     := 0              ;之前数据组的lastDataIndex
		, this.hLV               := hLV
		, this.LVselected        := []             ;当前LV所选项目
		, this.LVselCount        := 0              ;选择的数目
		, this.LVlastRowIndexStr := ""             ;LV上次所选行的拼接str
		
		if hEDselected
		{
			this.hEDselected := hEDselected
		}
		if hEDinclude    ;包括
		{
			this.hEDinclude  := hEDinclude
			this.lastInclude := "@@##"
		}
		if hEDexclude    ;排除
		{
			this.hEDexclude  := hEDexclude
			this.lastExclude := "@@##"
		}
		if hSpec
		{
			this.hSpec  := hSpec
			this.lastSpec := "@@##"
		}
		if cLV
		{
			Gui, ListView, % this.hLV    ;选择操作表
			this.cLV := New LV_Colors(this.hLV,,0)    ;LV上色(弊端:无法拖动排序了,需要拦截点击标题栏动作,然后重新绘色)
			this.cLVSwitch := 1
		}
	}
	
	;更新LV
	UpdateLV(force := false)
	{
		if this.hEDinclude
			GuiControlGet, include,, % this.hEDinclude
		if this.hEDexclude
			GuiControlGet, exclude,, % this.hEDexclude
		this.include := include
		, this.exclude := exclude
		if !force and (this.dataIndex = this.lastDataIndex)    ;dataIndex和之前一样
		and (!this.hEDinclude or this.include = this.lastInclude)   ;包含和上次一样
		and (!this.hEDexclude or this.exclude = this.lastExclude)   ;排除和上次一样
		and (!this.hSpec or this.Spec = this.lastSpec)              ;特殊和上次一样
			return
		this.lastDataIndex := this.dataIndex
		, this.lastInclude := this.include
		, this.lastExclude := this.exclude
		, this.lastSpec := this.Spec
		
		Gui, ListView, % this.hLV    ;选择操作表
		GuiControl, -Redraw, % this.hLV
		LV_Delete()
		
		this.UpdateLVAdd(this.data.dataItems[this.dataIndex].items)
		
		this.UpdateLVColor()    ;更新列表颜色
		GuiControl, +Redraw, % this.hLV
	}
	
	;更新规则,需要自设
	UpdateLVAdd(items)
	{
		/* 示例
		for i, item in items
		{
			if (this.Spec and item.spec and this.Spec <> item.spec)    ;筛选特殊 自定义
				continue
			str := item.Account "`n" item.Realm "`n" item.Player    ;拼合成字串 自定义
			if (this.include <> "" and !InStr(str, this.include)) or (this.exclude <> "" and InStr(str, this.exclude))    ;筛选文字
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
		LV_ModifyCol(3, 0)
		LV_ModifyCol(4, 0)
		LV_ModifyCol(5, "AutoHdr Logical")
		LV_ModifyCol(6, "AutoHdr Logical")
		LV_ModifyCol(7, "AutoHdr Logical")
		if this.Spec    ;职业筛选时进排序
			LV_ModifyCol(2, "SortDesc")
		*/
	}	
	
	;更新LV颜色
	UpdateLVColor()
	{
		if !this.cLV
			return
		this.cLV.OnMessage(False)
		if !this.cLVSwitch    ;颜色开关关闭时
			return
		Gui, ListView, % this.hLV    ;选择操作表
		GuiControl, -Redraw, % this.hLV
		this.cLV.Clear()    ;先清空颜色
		LV_GetText(dataIndex, 1, 2)    ;dataIndex序号
		
		Loop, % LV_GetCount()
		{
			LV_GetText(index, A_index, 3)    ;序号
			item := this.data.dataItems[dataIndex].items[index]
			items := this.data.dataItems[dataIndex]
			this.cLVRule(item, A_index, items)    ;颜色规则,需要自设
		}
		this.cLV.OnMessage()
		GuiControl, +Redraw, % this.hLV
	}
	
	;颜色规则,需要自设
	cLVRule(item, rowIndex)    
	{
		;颜色规则,需要自设
	}
	
	;添加LV信息到指定的编辑框中的动作 (发生变化时返回1, 未发生变化时返回0)
	UpdateLVSelected()
	{
		Gui, ListView, % this.hLV    ;选择操作表
		;哨兵, 发现选择与上次相同时直接返回上次所选
		rowIndex := 0
		, rowIndexStr := ""
		Loop 
		{
			rowIndexStr .= ";" (rowIndex := LV_GetNext(rowIndex))  ; 在前一次找到的位置后继续搜索.
		} until !rowIndex
		if (rowIndexStr = this.LVlastRowIndexStr)
		{
			this.LVlastRowIndexStr := rowIndexStr
			return 0
		}
		;重新获取LVselected
		this.LVselected := []
		Loop
		{
			rowIndex := LV_GetNext(rowIndex)  ; 在前一次找到的位置后继续搜索.
			if not rowIndex  ; 上面返回零, 所以选择的行已经都找到了.
				break
			LV_GetText(dataIndex, rowIndex, 2)    ;data序号
			LV_GetText(index,     rowIndex, 3)    ;序号
			this.LVselected.push(this.data.dataItems[dataIndex].items[index])
		}
		this.LVselCount := this.LVselected.Count()
		;控件控制
		this.UpdateGUIAfterSelected()
		return 1
	}
	
	;控件更新,需要自设
	UpdateGUIAfterSelected()
	{
		;
	}
	
	;清空已经选择
	ClearSelected()
	{
		this.LVselected          := []          ;当前LV所选项目
		, this.LVlastRowIndexStr := ""          ;LV上次所选行的拼接str
		GuiControl,, % this.hEDselected,        ;编辑框清空
	}
}

;=======================================================================================================================
;文件数据存储库类|
;=================
;文件数据存储库类
;无法单独使用,只能派生成特定的类使用
Class FileDataStorage
{
	static status := {}       ;数据整体状态
	static options := {}      ;数据控制选项
	
	__New()
	{
		this.dataItems := {}    ;数据组集合
		this.dataIndex := 0     ;当前数据组序号
	}
	
	;新增数据组dataItem, 返回当前的dataIndex
	AddData(dataPath, force := false)
	{
		if !FileExist(dataPath)    ;路径不存在时
			return
		for i, dataItem in this.dataItems    ;在现在dataItems中寻找
		{
			if (dataItem.dataPath == dataPath)    ;发现是现有的dataItem
			{
				dataIndex := i
				if !force
					return dataIndex
				else
					break
			}
		}
		if !dataIndex
		{
			dataIndex := ++this.dataIndex
			this.dataItems[dataIndex] := {dataPath:dataPath}
		}
		this.UpdateData(dataIndex, dataPath)    ;更新数据
		return dataIndex
	}
	
	;更新数据
	UpdateData(dataIndex, dataPath)    ;***派生的类的次函数必须是这两个参数
	{
		dataItem := this.dataItems[dataIndex]
		dataItem.items := {}
		;需要派生类自定义
	}
	
	;文件(文件夹)复制, 带有状态变更
	FilesCopy(srcPath, tarPath, str := "复制", overWrite := "overWrite")
	{
		this.status.log := str "文件到:" tarPath
		this.status.logs .= "[" str "]文件复制`t源地址:" srcPath "`t目标地址:" tarPath "`r`n"
		this.status.count += FolderCopyEx(srcPath, tarPath, overWrite)    ;强力复制文件
	}
	
	;文件(文件夹)链接, 带有状态变更
	Mklink(linkPath, realPath, str := "软链接", mod := "/d")
	{
		if FilesDeleteEx(linkPath, true)   ;操作前先删除源目录
			this.status.logs .= "[删除]文件删除`t地址:" linkPath "`r`n"
		if RunMklink(mod, linkPath, realPath, true)    ;目录联接,成功返回1
		{
			this.status.log := str ":" linkPath
			this.status.logs .= "[" str "]mklink " mod "`t链接地址:" linkPath "`t真实地址:" realPath "`r`n"
			this.status.count += 1
		}
	}
	
	;获取某文件夹的链接信息,链接失效时删除链接恢复为普通文件夹
	GetMklinkInfo(path, Encoding := "UTF-8")
	{
		if !FileExist(path)
			return
		realPath := path
		if (isReparse := IsReparsePoint(path))    ;是链接
		and !(realPath := GetRealPath(path))      ;且获取不到真实路径时
		{
			if InStr(FileExist(path), "D")    ;重建文件夹
			{
				FileRemoveDir, % path ,1
				FileCreateDir, % path
			}
			else    ;重建文件
			{
				FileDelete, % path
				FileAppend,, % path, % Encoding
			}
		}
		return {isReparse:isReparse, realPath:realPath}
	}
}