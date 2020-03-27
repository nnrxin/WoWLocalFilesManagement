ExitApp
;=======================================================================================================================
;WoWLocalFilesManagement模块:
;Mod = AddOns
;控件前缀: AO_
;需修改下面三个线程名称: AddMod_, GuiSize_, GuiInit_
;=======================================================================================================================
;新增模块所需函数库 |
;==================

;=======================================================================================================================
;新增模块线程 |
;=============
AddMod_AddOns:
	;模块部署
	
	;在MainGui的TAB上:
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Text, xm+10 ym+33 w310 h22 Center Section, 魔兽世界目录内插件列表
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, xp y+0 w288 h22 ReadOnly vvAO_EDwowAddOnsPath, 
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvAO_BTopenPath1 hwndhAO_BTopenPath1 ggAO_BTopenPath, ; 打开目录
	IB_Opts_OpenFile := [[0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"]]    ;ImageButton配色(打开文件夹)
	ImageButton.Create(hAO_BTopenPath1, IB_Opts_OpenFile*)

	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, Text, x+120 ys w310 h22 Center Section, 自定义存储目录内插件列表
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, xp y+0 w288 h22 ReadOnly vvAO_EDsavedAddOnsPath, 
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvAO_BTopenPath2 hwndhAO_BTopenPath2 ggAO_BTopenPath, ; 打开目录
	IB_Opts_OpenFile := [[0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"]]    ;ImageButton配色(打开文件夹)
	ImageButton.Create(hAO_BTopenPath2, IB_Opts_OpenFile*)
	
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+325 ym+60 w110 h50 Section, % "筛选"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, xp+10 yp+20 w90 h22 vini_AO_include hwndhAO_EDinclude ggAO_EDfilter, % INI.Init("AO", "include")    ;包含
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xs y+15 w110 h90 Section, % "选项"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Button, xp+10 yp+20 w90 h22 vvAO_BTreScan ggAO_BTreScan, % "深度刷新"
	Gui, MainGui:Add, Checkbox, xp y+4 h20 AltSubmit vini_AO_cLV ggAO_CBcLV, % "彩色列表"
	GuiControl,, ini_AO_cLV, % INI.Init("AO", "cLV", 1)
	Gui, MainGui:Add, Checkbox, xp y+0 hp AltSubmit vini_AO_generateLog , % "生成过程清单"
	GuiControl,, ini_AO_generateLog, % INI.Init("AO", "generateLog", 1)
	
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xs y+15 w110 h113 Section, % "复制"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Button, xp+10 yp+20 w90 h40 vvAO_BTcopyToL ggAO_BTcopyOrSyn Disabled, % "复制`n< < < <"
	Gui, MainGui:Add, Button, xp y+4 wp hp vvAO_BTcopyToR ggAO_BTcopyOrSyn Disabled, % "复制`n> > > >"
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xs y+15 w110 h113, % "目录链接mklink"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Button, xp+10 yp+20 w90 h40 vvAO_BTlinkAll ggAO_BTcopyOrSyn, % "整体链接`n> > > >"
	Gui, MainGui:Add, Button, xp y+4 wp hp vvAO_BTlink ggAO_BTcopyOrSyn Disabled, % "链接`n> > > >"


	Gui, MainGui:Add, ListView, xm+10 ym+80 w310 h450 Section Count500 Grid AltSubmit vvAO_LVwow hwndhAO_LVwow ggAO_LV, |dataIndex|序号|名称|大小|最后修改时间
	;为LV增加图片列表
	
	Gui, MainGui:Add, ListView, x+120 yp wp hp Section Count500 Grid AltSubmit vvAO_LVsaved hwndhAO_LVsaved ggAO_LV, |dataIndex|序号|名称|大小|最后修改时间
	;为LV增加图片列表
	
	;选取LV的详细信息列表
	Gui, MainGui:Add, ListView, xm+10 y+2 w740 h80 Count100 Grid hwndhAO_LVSel, 序号|名称|大小|最后修改时间|真实地址|J
	
	
	global AddOns := new AddOnsDataStorage()
	;左边控件封装进类
	global wowAOGui := new AddOnsGUIListView(AddOns                                 ;AddOns类
									  , hAO_LVwow                                   ;LV句柄
									  , ""                                          ;ED已选择句柄
									  , hAO_EDinclude                               ;ED筛选包含
									  , ""                                          ;ED筛选排除
									  , ""                                          ;开启了额外筛选 
									  , 1)                                          ;开启了颜色
	wowAOGui.cLVSwitch := ini_AO_cLV    ;颜色开关
	;右边控件封装进类
	global savedAOGui := new AddOnsGUIListView(AddOns                               ;AddOns类
									  , hAO_LVsaved                                 ;LV句柄
									  , ""                                          ;ED已选择句柄
									  , hAO_EDinclude                               ;ED筛选包含
									  , ""                                          ;ED筛选排除
									  , ""                                          ;开启了额外筛选 
									  , 1)                                          ;开启了颜色
	savedAOGui.cLVSwitch := ini_AO_cLV    ;颜色开关
return

;=======================================================================================================================
;模块初始化 |
;===========
GuiInit_AddOns:
	AddOnsGUIListView.wowAddOnsPath   := WOW_EDITION ? (WOW_PATH   "\" WOW_EDITION "\Interface\AddOns") : ""    ;魔兽AddOns路径
	AddOnsGUIListView.savedAddOnsPath := WOW_EDITION ? (SAVED_PATH "\" WOW_EDITION "\Interface\AddOns") : ""    ;自定义AddOns路径
	GuiControl,, vAO_EDwowAddOnsPath,   % AddOnsGUIListView.wowAddOnsPath       ;魔兽AddOns路径
	GuiControl,, vAO_EDsavedAddOnsPath, % AddOnsGUIListView.savedAddOnsPath     ;自定义AddOns路径
	gosub, scanWowAddOnsPath
	gosub, scanSavedAddOnsPath
return

scanWowAddOnsPath:
	wowAOGui.dataIndex := AddOns.AddData(AddOnsGUIListView.wowAddOnsPath)       ;扫描wow插件目录
	wowAOGui.UpdateLV()
return

scanSavedAddOnsPath:
	savedAOGui.dataIndex := AddOns.AddData(AddOnsGUIListView.savedAddOnsPath)   ;扫描自定义插件目录
	savedAOGui.UpdateLV()
return

;=======================================================================================================================
;Tab进此模块时执行的命令 |
;=======================
GuiTabIn_AddOns:
	gosub, GuiInit_AddOns
return

;=======================================================================================================================
;打开目录 |
;==========
gAO_BTopenPath:
	Gui, MainGui:Submit, NoHide
	Switch A_GuiControl
	{
	Case "vAO_BTopenPath1": GuiControlGet, path,, vAO_EDwowAddOnsPath
	Case "vAO_BTopenPath2": GuiControlGet, path,, vAO_EDsavedAddOnsPath
	Default: return
	}
	if InStr(FileExist(path), "D")
		try Run % path
return


;=======================================================================================================================
;中间控件 |
;==========
;筛选
gAO_EDfilter:
	Gui MainGui:+Disabled
	wowAOGui.UpdateLV()
	savedAOGui.UpdateLV()
	Gui MainGui:-Disabled
return

;LV颜色开关
gAO_CBcLV:
	Gui MainGui:Submit, NoHide
	wowAOGui.cLVSwitch := savedAOGui.cLVSwitch := ini_AO_cLV   ;颜色开关
	wowAOGui.UpdateLVColor()
	savedAOGui.UpdateLVColor()
return

;深度刷新
gAO_BTreScan:
	wowAOGui.dataIndex := AddOns.AddData(AddOnsGUIListView.wowAddOnsPath, 1)       ;重新扫描wow插件目录
	wowAOGui.UpdateLV(1)
	savedAOGui.dataIndex := AddOns.AddData(AddOnsGUIListView.savedAddOnsPath, 1)   ;重新扫描自定义插件目录
	savedAOGui.UpdateLV(1)
return


;=======================================================================================================================
;LV控件 |
;========
;LV控件
gAO_LV:
	Gui MainGui:+Disabled
	Gui, ListView, % A_GuiControl
	if (A_GuiEvent = "ColClick")    ;点击了标题栏
	{
		if (A_GuiControl == "vAO_LVwow")
			wowAOGui.UpdateLVColor()
		else if (A_GuiControl == "vAO_LVsaved")
			savedAOGui.UpdateLVColor()
	}
	else if ((A_GuiEvent == "F") or (A_GuiEvent == "I")) and InStr(ErrorLevel, "S")    ;所选发生变化
	{
		if (A_GuiControl == "vAO_LVwow" and wowAOGui.UpdateLVSelected())
		{
			AddOns.Selected := wowAOGui.LVselected
			selL := 1
			AddOns.srcPath := AddOnsGUIListView.wowAddOnsPath      ;源地址
			AddOns.tarPath := AddOnsGUIListView.savedAddOnsPath    ;目标地址
			gosub, DoAfterAddOnsSelected
		}
		else if (A_GuiControl == "vAO_LVsaved" and savedAOGui.UpdateLVSelected())
		{
			AddOns.Selected := savedAOGui.LVselected
			selL := 0
			AddOns.srcPath := AddOnsGUIListView.savedAddOnsPath    ;源地址
			AddOns.tarPath := AddOnsGUIListView.wowAddOnsPath      ;目标地址
			gosub, DoAfterAddOnsSelected
		}
	}
	Gui MainGui:-Disabled
return
;插件选择后
DoAfterAddOnsSelected:
	;显示LV刷新
	ShowInLVAOSel(hAO_LVSel, AddOns.Selected)
	;按钮激活控制 覆盖/同步/向左复制
	hasSelected := AddOns.Selected.Count() ? 1 : 0
	GuiControl, % "Enable" hasSelected * !selL, vAO_BTcopyToL                  ;向左复制
	GuiControl, % "Enable" hasSelected * selL, vAO_BTcopyToR                   ;向右复制
	GuiControl, % "Enable" 1, vAO_BTlinkAll                      ;向右链接*
	GuiControl, % "Enable" hasSelected * !selL, vAO_BTlink                  ;向右链接*
return

;将items展示到LVSel中
ShowInLVAOSel(hLV, items)
{
	Gui, ListView, % hLV    ;选择操作表
	GuiControl, -Redraw, % hLV
	LV_Delete()
	for name, item in items
	{
		LV_Add(
		, item.index                ;序号
		, item.name                 ;名称
		, item.fileSize             ;大小
		, item.timeModified			;修改时间
		, item.AddOnRealPath	    ;真实地址
		, item.dataIndex)           ;序号        
	}
	LV_ModifyCol(1, "AutoHdr")
	LV_ModifyCol(2, "AutoHdr")
	LV_ModifyCol(3, "AutoHdr")
	LV_ModifyCol(4, "AutoHdr")
	LV_ModifyCol(5, "AutoHdr")
	GuiControl, +Redraw, % hLV
}

;=======================================================================================================================
;复制/链接动作(核心)|
;====================
;插件覆盖/同步
gAO_BTcopyOrSyn:
	Switch A_GuiControl    ;模式确认
	{
	Case "vAO_BTcopyToL","vAO_BTcopyToR" : AddOns.options.cmd := "copy"
	Case "vAO_BTlink"    : AddOns.options.cmd := "syn"
	Case "vAO_BTlinkAll" : 
		AddOns.options.cmd := "synAll"
		AddOns.tarPath := AddOnsGUIListView.wowAddOnsPath      ;魔兽AddOns路径
		AddOns.srcPath := AddOnsGUIListView.savedAddOnsPath    ;自定义AddOns路径
	Default: return
	}
	Gui, MainGui:Submit, NoHide
	if !A_IsAdmin and (AddOns.options.cmd = "synAll" or AddOns.options.cmd = "syn")     ;同步需要管理员身份
	{
		Gui, MainGui:+OwnDialogs    ;各种对话框的从属
		MsgBox, 16,, % "目录联接需要管理员身份!`n请右键软件以管理员身份重新运行"
		return
	}
	AddOns.tarRealPath := AddOns.GetFolderMklinkInfo(AddOns.tarPath).realPath    ;获取目标真实路径
	AddOns.srcRealPath := AddOns.GetFolderMklinkInfo(AddOns.srcPath).realPath    ;获取来源真实路径
	;两边真实目录相同时
	if (AddOns.srcRealPath = AddOns.tarRealPath)    ;两边目录相同时返回(可通过按钮控制避免)
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 16,, % "错误! 左右两侧真实路径为同一路径,操作终止"
		return
	}
	OldBatchLines := A_BatchLines
	SetBatchLines -1
	;数据刷新
	AddOns.status.count := 0                             ;进度指示
	, AddOns.status.AddOnName := ""                      ;当前操作插件名称
	, AddOns.status.log := ""                            ;当前动作
	, AddOns.status.logs := ""                           ;指令清单
	, AddOns.options.timestamp := A_Now                  ;当前时间戳
	, AddOns.options.generateLog := ini_AO_generateLog   ;是否生成日志 
	, AddOns.options.logsPath := USER_DATA_PATH          ;日志保存文件夹路径
	, AddOns.options.lastLogPath := ""                   ;上次日志路径
	, AddOns.UpdateStatus(AddOns.status, AddOns.options) ;更新计数
	;目标目录已存在警告
	if (AddOns.status.pathCrashStr)
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 52,, % "警告！在目标文件夹" AddOns.tarPath "中下列插件已存在,继续将会时该文件夹内下列插件被完全覆盖!`n`n" AddOns.status.pathCrashStr "`n`n是否继续?"
		IfMsgBox No
		{
			SetBatchLines %OldBatchLines%
			return
		}
	}
	;确认信息
	Switch AddOns.options.cmd    ;模式确认
	{
	Case "copy"   : MsgTxt := "将复制" AddOns.srcPath "中的插件" AddOns.status.SelectedStr "到" AddOns.tarPath "`n`n是否继续?"
	Case "syn"    : MsgTxt := "将执行软链接 mklink /d`n`n链接地址:" AddOns.tarPath "中的插件" AddOns.status.SelectedStr "`n`n真实地址:" AddOns.srcPath "中的对应插件`n`n是否继续?"
	Case "synAll" : MsgTxt := "将执行软链接 mklink /d`n`n链接地址:" AddOns.tarPath "`n`n真实地址:" AddOns.srcPath "`n`n是否继续?"
	}
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	MsgBox, 68,, % MsgTxt "`n`n操作前最好对重要文件手动备份,以免数据丢失!!!"
	IfMsgBox Yes
	{
		Gui MainGui:+Disabled
		
		;状态栏修改
		SB_SetParts(200, 150)                                           ;状态栏分3部分
		SB_SetProgress(0, 1, "show Range0-" AddOns.status.countAll)     ;状态栏上增加计时条
		SetTimer, AOUpdateSB, 50, 10000                                 ;状态栏更新线程开启
		
		;执行动作
		AddOns.CopyOrSynAddOns()                                       ;执行复制或同步指令
		
		;底层重新扫描,刷新列表
		if selL
		{
			savedAOGui.dataIndex := AddOns.AddPath(AddOnsGUIListView.savedAddOnsPath, 1)   ;重新扫描自定义插件目录
			savedAOGui.UpdateLV(1)
		}
		else
		{
			wowAOGui.dataIndex := AddOns.AddPath(AddOnsGUIListView.wowAddOnsPath, 1)       ;重新扫描wow插件目录
			wowAOGui.UpdateLV(1)
		}
		
		;状态栏恢复,输出结论
		SetTimer, AOUpdateSB, Off                                       ;状态栏更新线程开启
		SB_SetParts()
		SB_SetProgress(0, 1, "hide")                                    ;状态栏上计时条隐藏
		if FileExist(AddOns.options.lastLogPath)
			Run, % AddOns.options.lastLogPath
		MsgBox 完成
		
		SetBatchLines %OldBatchLines%
		Gui MainGui:-Disabled	
	}
return
;状态栏更新
AOUpdateSB:
	Gui, MainGui:Default
	SB_SetProgress(AddOns.status.count, 1)       ;进度条变更
	SB_SetText(AddOns.status.AddOnName, 2)    ;当前角色
	SB_SetText(AddOns.status.log, 3)          ;当前动作
return

;=======================================================================================================================
;AddOns的GUI控件类 |
;===================
Class AddOnsGUIListView extends GUIListView
{
	static wowAddOnsPath := ""            ;魔兽AddOns路径
	static wowAddOnsRealPath := ""        ;魔兽AddOns真实路径
	static savedAddOnsPath := ""          ;自定义AddOns路径
	static savedAddOnsRealPath := ""      ;自定义AddOns真实路径
	
	;更新规则,需要自设
	UpdateLVAdd(items)
	{
		for name, item in items
		{
			if (this.include <> "" and !InStr(name, this.include))    ;筛选文字
				continue
			LV_Add(
			, 
			, item.dataIndex            ;AddOns序号
			, item.index                ;序号
			, name                      ;名称
			, item.fileSize             ;魔兽中大小
			, item.timeModified)        ;魔兽中修改时间
		}
		LV_ModifyCol(1, 0)
		LV_ModifyCol(2, 0)
		LV_ModifyCol(3, "AutoHdr Logical")
		LV_ModifyCol(4, "AutoHdr Logical")
		LV_ModifyCol(5, "AutoHdr Logical Right")
		LV_ModifyCol(6, "AutoHdr Logical")
	}
	
	;颜色规则,需要自设
	cLVRule(item, rowIndex, items)    
	{
		if items.isReparse
			this.cLV.Cell(rowIndex, 4, 0x9C9C9C)
		else if item.isReparse    ;是否为链接
			this.cLV.Cell(rowIndex, 4, 0xCFCFCF)
	}
}

;=======================================================================================================================
;魔兽世界AddOns插件文件管理类 |
;==============================
Class AddOnsDataStorage extends FileDataStorage
{
	static Selected      := {}    ;wow选择的项目
	static srcPath       := ""    ;源地址
	static tarPath       := ""    ;目标地址
	static status        := {}    ;状态
	static options       := {}    ;选项

	;扫描给定的AddOns目录
	UpdateData(dataIndex, dataPath)
	{
		dataItem := this.dataItems[dataIndex]    ;当前操作的AddOns
		dataPathMklinkInfo := this.GetMklinkInfo(dataPath)    ;链接信息
		dataItem.realDataPath := dataPathMklinkInfo.realPath  ;真实地址
		dataItem.isReparse := dataPathMklinkInfo.isReparse    ;地址为链接
		dataItem.items := {}
		i := 0
		Loop, Files, % dataPath "\*", D
		{
			mklinkInfo := this.GetMklinkInfo(A_LoopFileLongPath)
			dataItem.items[A_LoopFileName] := {dataIndex    : dataIndex                                                ;AddOns路径序号
											, index         : ++i                                                      ;序号
											, name          : A_LoopFileName                                           ;插件名称
											, timeModified  : A_LoopFileTimeModified                                   ;修改日期
											, fileSize      : FilesSizeEx(A_LoopFileLongPath, "KB", "{1:0.1f} KB")     ;文件大小
											, AddOnPath     : A_LoopFileLongPath                                       ;当前路径
											, isReparse     : mklinkInfo.isReparse                                     ;是否为链接
											, AddOnRealPath : mklinkInfo.realPath}                                     ;获取真实路径
		}
	}
	
	;更新选中两边文件的数量(需要先更新好控制信息switch):
	;status.pathCrashStr := ""       ;地址碰撞记录str
	;status.countAll
	UpdateStatus(status, options)
	{
		status.SelectedStr := ""    ;选中目标的str拼合
		status.pathCrashStr := ""    ;目标已存在记录str
		for name, src in this.Selected
		{
			status.SelectedStr .= name "; "
			if (FileExist(this.tarPath "\" name))
				status.pathCrashStr .= name "; "    ;增加目标已存在记录
		}
		;模拟运行一次, 计算出操作的文件量
		status.countAll := 0
		if (options.cmd = "synAll")    ;联接整个文件夹
		{
			status.countAll += 1
		}
		else    ;复制/链接子文件夹
		{
			for name, src in this.Selected
			{
				if (options.cmd = "copy")    ;复制
					status.countAll += FilesCountEx(src.AddOnPath)
				else if (options.cmd = "syn")    ;链接
					status.countAll += 1
			}
		}
	}
	
	;复制/链接插件
	CopyOrSynAddOns()
	{
		if (this.srcRealPath = this.tarRealPath)    ;两边目录相同时返回(可通过按钮控制避免)
		or (this.Selected.Count() == 0 and this.options.cmd <> "synAll")    ;无选择时返回(可通过按钮控制避免)
			return
		if (this.options.cmd = "synAll")    ;链接整个文件夹
			this.Mklink(this.tarPath, this.srcPath, this.status)
		else
		{
			for name, src in this.Selected
			{
				this.status.AddOnName := name
				tarPath := this.tarPath "\" name
				if (src.AddOnRealPath = this.GetFolderMklinkInfo(tarPath).realPath)
					continue
				if (this.options.cmd = "copy")
					this.FilesCopy(src.AddOnPath, tarPath, this.status, "复制", "exactal")    ;复制单个子文件夹
				else if (this.options.cmd = "syn")
					this.Mklink(tarPath, src.AddOnPath, this.status)    ;链接单个子文件夹
			}
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


