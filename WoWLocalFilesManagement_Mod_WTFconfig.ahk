ExitApp
;=======================================================================================================================
;WoWLocalFilesManagement模块:
;Mod = WTFconfig
;控件前缀: WTFcfg_
;需修改下面三个线程名称: AddMod_, GuiSize_, GuiInit_
;=======================================================================================================================
;新增模块所需函数库 |
;==================

;=======================================================================================================================
;新增模块线程 |
;=============
AddMod_WTFconfig:
	;模块部署

	;在MainGui的TAB上:
	Gui, MainGui:Add, Picture, xm+605 ym+25 w150 h75 vvWTFcfg_PICwowLogo,     ;魔兽版本Logo
	
	Gui, MainGui:Add, Text, xm+10 ym+33 w70 h22 Center Section, 控制台路径
	Gui, MainGui:Add, Edit, x+0 yp-3 w500 h22 ReadOnly vvWTFCfg_EDconfigPath, 控制台路径
	Gui, MainGui:Add, Button, x+0 yp h22 w22 vvWTFCfg_BTopenPath1 hwndhWTFCfg_BTopenPath1 ggWTFCfg_BTopenPath, ; 打开目录
	IB_Opts_OpenFile := [[0,APP_DATA_PATH "\Img\GUI\Folder.png"], [,APP_DATA_PATH "\Img\GUI\Folderp.png"]]    ;ImageButton配色(打开文件夹)
	ImageButton.Create(hWTFCfg_BTopenPath1, IB_Opts_OpenFile*)

	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, xm+10 y+3 w100 h50 Section, % "筛选"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, xp+10 yp+20 w80 h22 vini_WTFcfg_include hwndhWTFcfg_EDinclude ggWTFcfg_EDfilter, % INI.Init("WTFcfg", "include")    ;包含
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, x+15 ys w280 h50 Section, % "修改/新增"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, Edit, xp+10 yp+20 w120 h22 vvWTFcfg_EDkey ggTFcfg_EDkeyValue, 
	Gui, MainGui:Add, text, x+0 yp+2 w15 hp Center, % "="
	Gui, MainGui:Add, Edit, x+0 yp-2 w70 hp  vvWTFcfg_EDvalue ggTFcfg_EDkeyValue, 
	Gui, MainGui:Add, Button, x+5 yp-1 w50 h24 vvWTFcfg_BTsetValue ggWTFcfg_BTsetValue Disabled, % "确  定"
	
	Gui, MainGui:Font, c010101 bold, 微软雅黑
	Gui, MainGui:Add, GroupBox, x+15 ys w200 h50 Section, % "链接到自定义存储目录"
	Gui, MainGui:Font, cDefault norm, 微软雅黑 Light
	Gui, MainGui:Add, text, xp+10 yp+23 w90 h22 vvWTFcfg_TXmklinkState,  当前状态
	Gui, MainGui:Add, Button, x+0 yp-3 w90 hp vvWTFcfg_BTmklinkToSaved ggWTFcfg_BTmklinkToSaved Disabled, % "移动并链接"
	
	
	Gui, MainGui:Add, ListView, xm+10 y+15 w740 h400 Count500 -Multi Grid AltSubmit hwndhWTFcfg_LV ggWTFcfg_LV, 序号|dataIndex|名称|数值|备注
	
	global WTFconfig := new WTFconfigDataStorage()
	;左边控件封装进类
	global WTFconfigGui := new WTFconfigGUIListView(WTFconfig             ;WTFconfig类
									              , hWTFcfg_LV            ;LV句柄
									              , ""                    ;ED已选择句柄
									              , hWTFcfg_EDinclude     ;ED筛选包含
												  , ""                    ;ED筛选排除
												  , ""                    ;开启了额外筛选 
												  , 1)                    ;开启了颜色
												  
return

;=======================================================================================================================
;模块初始化 |
;============
GuiInit_WTFconfig:
	WTFconfig.WTFconfigPath := WOW_WTF_PATH "\Config.wtf" ;控制台文件路径
	WTFsavedConfigPath := SAVED_PATH "\" WOW_EDITION "\WTF\Config.wtf"    ;自定义目录config路径
	GuiControl,, vWTFCfg_EDconfigPath, % WOW_WTF_PATH     ;控制台路径
	GuiControl,, vWTFCfg_PICwowLogo, % WOW_LOGO_PATH      ;魔兽Logo图片刷新
	
	gosub, ScanWTFconfigPath
	gosub, CheckConfigMklink
return

;=======================================================================================================================
;Tab进此模块时执行的命令 |
;=======================
GuiTabIn_WTFconfig:
	gosub, GuiInit_WTFconfig
return

ScanWTFconfigPath:
	WTFconfigGui.dataIndex := WTFconfig.AddData(WTFconfig.WTFconfigPath)       ;扫描WTFconfig文件
	WTFconfigGui.UpdateLV()
return
;=======================================================================================================================
;打开路径按钮 |
;==============
gWTFCfg_BTopenPath:
	Switch A_GuiControl
	{
	Case "vWTFCfg_BTopenPath1": GuiControlGet, path,, vWTFCfg_EDconfigPath    ;WTF备份路径
	Default: return
	}
	if InStr(FileExist(path), "D")
		try Run % path
return

;=======================================================================================================================
;模块上控件动作 |
;================
;筛选
gWTFcfg_EDfilter:
	Gui MainGui:+Disabled
	WTFconfigGui.UpdateLV()
	Gui MainGui:-Disabled
return

;修改key和value
gTFcfg_EDkeyValue:
	Gui MainGui:+Disabled
	Gui, MainGui:Submit, NoHide
	if (vWTFcfg_EDkey <> vWTFcfg_EDkey_last or vWTFcfg_EDvalue <> vWTFcfg_EDvalue_last)
	{
		vWTFcfg_EDkey_last := vWTFcfg_EDkey
		vWTFcfg_EDvalue_last := vWTFcfg_EDvalue
		different := (WTFconfig.currentData.items[vWTFcfg_EDkey].index and WTFconfig.currentData.items[vWTFcfg_EDkey].value = vWTFcfg_EDvalue) ? 0 : 1
		GuiControl, % "Enable" different, vWTFcfg_BTsetValue
	}
	Gui MainGui:-Disabled
return

;修改value值
gWTFcfg_BTsetValue:
	;确认信息
	Gui, MainGui:+OwnDialogs ;各种对话框的从属
	WTFconfig.currentData.config.Set(vWTFcfg_EDkey, vWTFcfg_EDvalue, 1)
		
	WTFconfigGui.dataIndex := WTFconfig.AddData(WTFconfig.WTFconfigPath, 1)       ;扫描WTFconfig文件
	WTFconfigGui.UpdateLV(1)
	GuiControl, Disable, vWTFcfg_BTsetValue
return

;链接到自定义存储
CheckConfigMklink:
	if (WTFconfig.currentData.isReparse and WTFconfig.currentData.realDataPath = WTFsavedConfigPath)
	{
		GuiControl,, vWTFcfg_TXmklinkState, % "状态 : 已链接"
		GuiControl, Disable, vWTFcfg_BTmklinkToSaved
	}
	else
	{
		GuiControl,, vWTFcfg_TXmklinkState, % "状态 : 未链接"
		GuiControl, Enable, vWTFcfg_BTmklinkToSaved
	}
return

;动作
gWTFcfg_BTmklinkToSaved:
	if WinExist("ahk_exe Wow.exe") or WinExist("ahk_exe WowClassic.exe")    ;发现魔兽窗口时返回
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 16,, 启动失败: 请关闭魔兽窗口后重试
		return
	}
	if !A_IsAdmin     ;文件名称错误
	{
		Gui, MainGui:+OwnDialogs    ;各种对话框的从属
		MsgBox, 16,, % "同步模式需要管理员身份!`n请右键软件以管理员身份重新运行"
		return
	}
	if FileExist(WTFsavedConfigPath)    ;发现自定义储存路径中已经存在config.wtf
	{
		Gui, MainGui:+OwnDialogs ;各种对话框的从属
		MsgBox, 51,, % WTFsavedConfigPath "`n自定义存储中的config.wtf已经存在`n`n是    :先覆盖自定义存储中的config.wtf,再进行链接(操作后自定义存储的config.wtf会丢失)`n否    :直接进行链接(操作后魔兽世界中的config.wtf会丢失)`n取消:什么也不做" 
		IfMsgBox Cancel    ;取消
			return
		else IfMsgBox No    ;否
		{
			FileDelete, % WTFconfig.currentData.dataPath
			RunMklink("/d", WTFconfig.currentData.dataPath, WTFsavedConfigPath)
			WTFconfigGui.dataIndex := WTFconfig.AddData(WTFconfig.WTFconfigPath, 1)       ;扫描WTFconfig文件
			WTFconfigGui.UpdateLV(1)
			gosub, CheckConfigMklink
			return
		}
	}
	FileMove, % WTFconfig.currentData.dataPath, % WTFsavedConfigPath ,1
	RunMklink("/d", WTFconfig.currentData.dataPath, WTFsavedConfigPath)
	WTFconfigGui.dataIndex := WTFconfig.AddData(WTFconfig.WTFconfigPath, 1)       ;扫描WTFconfig文件
	WTFconfigGui.UpdateLV(1)
	gosub, CheckConfigMklink
return

;=======================================================================================================================
;LV控件 |
;========
;LV控件
gWTFcfg_LV:
	Gui MainGui:+Disabled
	Gui, ListView, % A_GuiControl
	if ((A_GuiEvent == "F") or (A_GuiEvent == "I")) and InStr(ErrorLevel, "S") and WTFconfigGui.UpdateLVSelected()     ;所选发生变化
	{
		WTFconfig.Selected := WTFconfigGui.LVselected[1]
		GuiControl,, vWTFcfg_EDkey  , % WTFconfig.Selected.key
		GuiControl,, vWTFcfg_EDvalue, % WTFconfig.Selected.value
	}
	Gui MainGui:-Disabled
return

;=======================================================================================================================
;模块GUI附属 |
;============

;GUI尺寸控制:
GuiSize_WTFconfig:
	;~ AutoXYWH("w h", "vHK_LVmain")
return


;=======================================================================================================================
;模块GUI附属动作$函数 |
;====================

;=======================================================================================================================
;WTFconfig的GUI控件类 |
;======================
Class WTFconfigGUIListView extends GUIListView
{
	static WTFconfigPath := ""            ;WTFconfig路径
	static WTFconfigRealPath := ""        ;WTFconfig真实路径
	
	;更新规则,需要自设
	UpdateLVAdd(items)
	{
		for key, item in items
		{
			strs := item.key "`n" item.index "`n" item.value "`n" item.remark
			if (this.include <> "" and !InStr(strs, this.include))    ;筛选文字
				continue
			LV_Add(
			, item.index          ;序号 
			, item.dataIndex      ;AddOns序号
			, item.key            ;key名称
			, item.value          ;key值
			, item.remark)        ;备注
		}
		LV_ModifyCol(1, "AutoHdr Logical Sort")
		LV_ModifyCol(2, 0)
		LV_ModifyCol(3, "AutoHdr Logical")
		LV_ModifyCol(4, "AutoHdr Logical")
		LV_ModifyCol(5, "AutoHdr Logical")
	}
	
	;颜色规则,需要自设
	cLVRule(item, rowIndex, items)    
	{
		if items.isReparse
			this.cLV.Cell(rowIndex, 1, 0x9C9C9C)
	}
}

;=======================================================================================================================
;魔兽世界WTFconfig文件管理类 |
;==============================
Class WTFconfigDataStorage extends FileDataStorage
{
	static currentData   := {}    ;wow选择的项目
	static Selected      := {}    ;wow选择的项目
	static status        := {}    ;状态
	static options       := {}    ;选项
	static configKeyRemark := {null:""
	, synchronizeSettings:"同步设置:将UI设置保存到服务器,1为开启,0为关闭"
	, overrideArchive:"模型和谐:1为开启,0为关闭"}


	
	;扫描给定的AddOns目录
	UpdateData(dataIndex, dataPath)
	{
		dataItem := this.dataItems[dataIndex]                 ;当前操作的AddOns
		this.currentData := dataItem
		dataPathMklinkInfo := this.GetMklinkInfo(dataPath)    ;链接信息
		dataItem.realDataPath := dataPathMklinkInfo.realPath  ;真实地址
		dataItem.isReparse := dataPathMklinkInfo.isReparse    ;地址为链接
		dataItem.items := {}
		i := 0
		dataItem.config := new WowConfigWtf(dataPath)
		for i, item in dataItem.config.GetAllValue()
		{
			dataItem.items[item.key] := {dataIndex     : dataIndex                        ;AddOns路径序号
								       , index         : i                                ;序号
								       , key           : item.key                         ;key名称
								       , value         : item.value                       ;key值
								       , remark        : this.configKeyRemark[item.key]}  ;备注
								
		}
	}
}


/*
overrideArchive 模型和谐 - 1为开启,0为关闭

accountList	帐户列表- 为登录屏幕保存多个帐户名称
accountName	帐户名称- 为登录屏幕保存 1 个帐户名称
accounttype	帐户类型- 保存用户正在播放的帐户类型 - 哇，BC，LK 或 CT
blizzcon	暴雪用于防止暴雪电脑篡改
checkAddonVersion	检查添加版本- 禁用加载过期加载项
CinematicJoystick	电影摇杆
coresDetected	检测到内核- 检测到的 CPU 内核的 #
decorateAccountName	装饰帐户名称 -
expansionMovie	扩展电影- 在启动时显示催化简介（显示视频后此变量重置为 0）
forceEnglishNames	力英语名称 -
installType	安装类型- 零售/测试版/PTR
lastCharacterIndex	最后一个字符索引- 用于登录的最后一个字符数（字符屏幕的初始选择）
locale	区域设置- 游戏语言代码（例如"enGB"、"enUS"、"deDE"、"frFR"等）
heapAllocTracking	堆Alloc跟踪- 启用/禁用 SMemMalloc 中的分配跟踪和转储
heapUsage	堆用法
heapUsage2	堆用法2
movie	电影- 在启动时显示介绍电影（在刻录十字军游戏客户端中不起作用）
movieSubtitle	电影字幕- 显示简介电影的字幕
readContest	阅读竞赛- 用户是否接受PTR竞赛规则
readEULA	重新读 -用户是否接受了EULA
readScanning	读取扫描- 用户是否接受系统扫描条款
readTOS	阅读 -用户是否接受使用条款
realmList	realmList - 要使用的 Realm 列表服务器（例如"eu.logon.worldofwarcraft.com"或"us.logon.worldofwarcraft.com"）
realmListbn	realmListbn - Battle.net领域列表服务器使用（默认：""） - 哇仍然使用领域列表
showToolsUI	显示工具UI - 启用 WoW 启动器
timingMethod	计时方法- 设置使用的 CPU 计时方法。0 无，1 是正常精度（fps 限制为 64），2 是高精度
patchlist	补丁列表- 哇补丁服务器的地址
processAffinityMask	进程亲和掩码- 启动 WoW 的处理器内核
ConsoleEdit	控制台编辑
help	帮助- 显示任何命令的帮助和信息。（例如。帮助调试）
fontcolor	字体颜色- 控制台字体颜色
bgcolor	bg 颜色- 背景颜色
highlightcolor	高光颜色- 控制台文本突出显示颜色
fontsize	字体大小- 字体大小
font	字体- 在控制台中使用字体的名称
consolelines	控制台行- 一次在屏幕上显示多少行
clear	清除- 清除所有控制台文本
proportionaltext	比例文本- 空格文本覆盖整个屏幕（E x m p l e ！）
spacing	间距- 指定字符间间距（以像素为单位）
settings	设置- 列出当前控制台设置
default	默认值- 将控制台返回到默认设置
closeconsole	关闭控制台- 关闭控制台
repeat	重复- 输入时重复命令
cvarlist	cvarlist - 列出所有 cvar 及其当前和默认设置
cvar_default	cvar_default - 将所有 cvar 设置为其默认值
cvar_reset	cvar_reset - 将 config.wtf 文件重置为首次登录时使用的设置
CameraEdit	相机编辑
cameraBobbing	相机
cameraBobbingFrequency	相机摆动频率
cameraBobbingLRAmplitude	相机放大缩小字体功能 放大缩小字体功能
cameraBobbingSmoothSpeed	相机摇曳速度
cameraBobbingUDAmplitude	相机放大缩小字体功能 放大缩小字体功能
cameraCustomViewSmoothing	相机自定义平滑
cameraDistance	摄像机距离- 固定值？
cameraDistanceD	摄像机距离- 摄像机距离（变焦）。可能显示或可能不会显示相机与摄像机世界碰撞的强制摄像机移动（未经测试）。
cameraDistanceMax	摄像机距离最大值
cameraDistanceMaxFactor	摄像机距离最大值因子- 设置摄像机距离最大值乘以的因子
cameraDistanceMoveSpeed	摄像机距离移动速度- 默认值为 8.33。
cameraDistanceSmoothSpeed	摄像机距离平稳速度- 默认值为 8.33。值范围为 0.002778-50。更改滚轮放大/缩小的速度。
cameraDive	相机 Dive - 默认值为 1。
cameraFlyingMountHeightSmoothSpeed	相机飞行山高度平滑速度
cameraFoVSmoothSpeed	相机福平滑速度
cameraGroundSmoothSpeed	摄像机地面平滑速度
cameraHeightIgnoreStandState	摄像机高度忽略支架状态
cameraHeightSmoothSpeed	相机高度平滑速度
cameraPitch	相机投球- 固定值？
cameraPitchD	相机间距- 相机间距。似乎没有考虑相机与相机世界碰撞的强制相机移动。
cameraPitchMoveSpeed	相机间距移动速度
cameraPitchSmoothSpeed	相机间距平滑速度
cameraPitchSmoothMin	相机间距平滑明
cameraPitchSmoothMax	相机间距平滑最大值
cameraPivot	相机透视- 默认值为 1。控制相机在撞到地面时是否停止，以便您可以向上查找而不会被角色模型阻止。
cameraPivotDXMax	相机PivotDXMax
cameraPivotDYMin	相机PivotDYMin
camerasmooth	相机平滑
cameraSmoothPitch	相机平滑间距
cameraSmoothStyle	相机平滑样式- 默认值为 0。可能的值 0-2。
cameraSmoothTrackingStyle	相机平滑跟踪样式
cameraSmoothYaw	相机平滑
cameraSmoothTimeMin	相机平滑时间明
cameraSmoothTimeMax	相机平滑时间最大值
cameraSubmergeFinalPitch	相机子合并最终投球
cameraSubmergePitch	相机子合并间距
cameraSurfacePitch	相机表面投球
cameraSurfaceFinalPitch	相机表面最终投球
cameraTargetSmoothSpeed	相机目标平滑速度
cameraTerrainTilt	相机地形倾斜
cameraTerrainTiltTimeMin	相机地形倾斜时间明
cameraTerrainTiltTimeMax	相机地形倾斜时间最大值
cameraView	相机视图
cameraViewBlendStyle	相机视图混合样式- 默认值为 1。可能的值 1-2。摄像机从保存的位置平稳或立即移动。
cameraWaterCollision	相机水碰撞
cameraYaw	相机 Yaw - 固定值？
cameraYawD	相机 YawD - 相机偏航。可能显示或可能不会显示相机与摄像机世界碰撞的强制摄像机移动（未经测试）。
cameraYawMoveSpeed	相机Yaw移动速度- 默认值为230。可能的值 1-360。更改摄像机旋转的速度。
cameraYawSmoothMax	相机Yaw平滑最大
cameraYawSmoothMin	相机YawSmoothmin
cameraYawSmoothSpeed	相机Yaw平滑速度
ControlsEdit	控件编辑
assistAttack	辅助攻击- 使用/辅助后自动开始攻击
autoClearAFK	自动清除AFK - 移动时清除 AFK
autoDismount	自动拆卸- 尝试使用能力时卸载
autoDismountFlying	自动迪斯蒙特飞行- ...即使飞行
AutoInteract	自动交互- 右键单击以移动
autoRangedCombat	自动战斗- 在远程攻击和近战攻击之间自动切换
autoSelfCast	自动自播- 自动自播
autoStand	自动支架- 在尝试使用功能时站起来 [在修补程序 2.3 中介绍]
autoUnshift	自动取消移位- 使用仅可用"未移动"功能时，取消移位/取消隐藏/离开阴影窗体 [在修补程序 2.3 中介绍]
deselectOnClick	取消选择点击- 粘性定位
enableWowMouse	启用WowMouse - 启用钢系列游戏鼠标
Joystick	操纵杆- 启用操纵杆
mouseInvertPitch	鼠标反转间距- 反转向上向下的鼠标运动
mouseInvertYaw	鼠标反转- 反转左-右鼠标运动
mouseSpeed	鼠标速度- 鼠标速度
stopAutoAttackOnTargetChange	停止自动攻击目标更改- 切换目标时停止攻击
EngineEdit	引擎编辑
asyncHandlerTimeout	异步处理程序超时- 引擎测试 - 又名您加载到实例中，点击出哇，点击后退和哇已经停止响应。
asyncThreadSleep	异步线程睡眠- 引擎选项：基于异步处理程序超时设置
dbCompress	db压缩- 数据库压缩 （？）
Errors	错误 -
ErrorFileLog	错误文件日志 -
ErrorLevelMin	错误水平最小值 -
ErrorLevelMax	错误级别最大值 -
ErrorFilter	错误筛选 -
MemUsage	MemUsage -
ShowErrors	显示错误- 启用/禁用显示错误
timingTestError	计时测试错误 -
GraphicsEdit	图形编辑
bspcache	bspcache - 二进制空间分区缓存
componentCompress	组件压缩- 修复了字符完全黑的问题，由坏/旧驱动程序引起。
componentTextureLevel	组件纹理级别- 更改播放器纹理的质量。较旧的纹理似乎没有受到影响。（1：低质量，0：高品质）
componentThread	组件线程 -
DesktopGamma	桌面伽玛- 匹配窗口的伽马设置
detailDoodadAlpha	细节杜达达阿尔法 -
DistCull	分片 -设置距离，用于在远夹附近剔除物体
extShadowQuality	extShadow 质量- 启用动态阴影 （WoW 3.0）
environmentDetail	环境细节- 控件模型绘制距离的 doodads （WoW 3.0）
farclip	远夹- 设置详细的绘制距离;设置雾距离。只有地形才能超过此距离。
farclipoverride	远剪辑覆盖- 允许覆盖远剪辑的预设限制 （WoW 3.0）
ffx	ffx - 启用所有像素影后
ffxDeath	ffx死亡- 启用全屏死亡效果
ffxGlow	ffxGlow - 启用全屏发光效果
ffxNetherWorld	ffxNetherWorld - 启用全屏"下界世界"效果，例如为法师的隐形效果
ffxRectangle	ffx矩形- 启用宽屏框架缓冲器
ffxSpecial	ffx 特别- 启用替代屏幕效果。（WoW 3.0Wrath-Logo-Small)
fixedFunction	固定功能- 强制固定函数像素和顶点处理
footstepBias	脚印 - ？
Gamma	伽玛- 伽玛水平
groundEffectDensity	接地效应密度 -
groundEffectDist	接地效果 -
gxApi	gxApi - 要使用的图形 API
gxAspect	gxAspect - 保留窗口模式的纵横比
gxColorBits	gxColorbits - 颜色位
gxCursor	gxCursor - 启用硬件光标
gxDepthBits	gx 深度位- 深度位
gxFixLag	gxFixLag - 平滑鼠标光标
gxMonitor	gxMonitor - 用于游戏的主监视器的
gxMaximize	gx最大化- 使用窗口模式时，最大化窗口
gxMultisample	gx 多采样- 启用抗锯齿（例如，4x多采样的"4"）
gxMultisampleQuality	gx 多样本质量- 抗锯齿质量 （？）
gxOverride	gx覆盖- ？
gxRefresh	gx刷新- 刷新率（以 Hz 为单位）
gxResolution	gx分辨率- 屏幕分辨率（例如"1280x1024"）
gxRestart	gxRestart - 重新启动图形引擎
gxTextureCacheSize	gxTextureCacheSize - 设置缓存大小
gxTripleBuffer	gx三重缓冲- 启用三重缓冲
gxVSync	gxVSync - 启用 VSync
gxWindow	gx窗口- 窗口模式
horizonfarclip	地平线长距剪辑- 设置地平线（地形）的绘制距离。当大于远剪辑时，将在远处显示地形的"阴影"。
horizonfarclip	地平线长距剪辑- 为最接近您绘制的地形设置绘制距离。
hwDetect	hw检测- 执行硬件检测以获得最佳价值
hwPCF	hwPCF - 使用基于硬件的百分比更近的阴影筛选（默认打开）
lod	lod - 详细级别，切换图形菜单中的细节级别选项
M2BatchDoodads	M2BatchDoodads - 支持分批处理细节斗达（组合斗达以减少批次数量）
M2BatchParticles	M2Batch粒子- 组合粒子发射器以减少批处理计数
M2Faster	M2速度- 最终用户控制场景优化模式 - （0-3）
M2FasterDebug	M2快速调试- 支持开发人员动态控制（场景优化模式的程序员控制）
M2UseClipPlanes	M2UseClipPlanes - 使用剪辑平面对透明对象进行排序
M2UseThreads	M2UseThreads - 多线程模型动画
M2UseZFill	M2UseZFill - 在透明对象上启用 Z 填充
mapObjLightLOD	地图ObjLightLOD - ？
mapShadows	地图阴影- 切换地图阴影
MaxFPS	最大FPS - 帧速率限制
maxFPSBk	最大FPSBk - 帧速率限制，而哇不在焦点
MaxLights	最大灯- 最大硬件灯数
nearclip	近剪辑- 小细节的剪辑范围
objectFade	对象淡入淡出 -
ObjectFadeZFill	对象淡入淡出填充 -
occlusion	遮挡- 禁用被其他图形完全阻止的对象的渲染
particleDensity	粒子密度- 粒子密度
pixelShaders	像素扫描器- 启用像素下线
playerTextureLevels	播放器纹理级别- 弃用并替换为组件纹理级别
PlayerFadeInRate	玩家 FadeInRate - 玩家鼠标悬停率淡入淡出
PlayerFadeOutAlpha	玩家淡入阿尔法- 分钟淡出阿尔法为玩家鼠标悬停
PlayerFadeOutRate	玩家淡入淡出率- 淡出玩家鼠标悬停率
shadowBias	阴影偏差- Blob 阴影透明度级别
shadowcull	影子 - ？
shadowinstancing	阴影 -阴影优化，防止闪烁
shadowLevel	阴影级别- 阴影 mip 贴图的详细级别
shadowLOD	阴影LOD - 启用或禁用 Blob 阴影
shadowscissor	阴影器- ？
showshadow	显示阴影- ？
showfootprints	显示足迹- 启用足迹
showfootprintparticles	显示脚印粒子- ？
showsmartrects	显示智能 -在 WoW 3.0 中弃用
SkyCloudLOD	天空云云.
SmallCull	小库 -影响小对象的隐藏（"隐藏"）。设置为 0 禁用。
specular	镜面- 启用镜面扫描
spellEffectLevel	拼写效果级别- 拼写效果级别
SplineOpt	样条线Opt - 加载屏幕飞溅线旅行
texLodBias	texLodBias - 纹理细节偏差级别 （？）
terrainMipLevel	地形 MipLevel - 地形纹理混合模式。（1：低质量，0：高品质）
textureFilteringMode	纹理筛选模式- 纹理筛选模式 （？）
textureCacheSize	纹理缓存 -在内存纹理中缓存时，它们不用于快速加载。（最小：8388608，最大值：536870912，默认值：33554432）
triangleStrips	三角形条纹- 在 WoW 3.0 中弃用
UIFaster	UI 更快- UI 加速级别
unitDrawDist	单位绘制 -单位绘制距离
unitHighlights	单元突出显示- 在目标单元上切换模型突出显示
useWeatherShaders	使用天气扫描器- 启用天气扫描器
violenceLevel	暴力级别- 更改游戏的暴力级别
waterLOD	水线- 水的详细程度（锁定）
windowResizeLock	窗口调整锁定- 锁定，使游戏无法在窗口模式下调整大小 - 请参阅gxWindow
weatherDensity	天气密度- 天气影响水平
worldBaseMip	worldBaseMip - 环境纹理质量（2：低，1：中等，0：高）
InterfaceEdit	界面编辑
BlockTrades	块交易- 阻止交易请求
ChatBubbles	聊天泡泡- 启用聊天气泡
ChatBubblesParty	聊天泡泡党- 启用派对聊天气泡
colorChatNamesByClass	colorChatNamesByClass - 名称将更改为颜色以匹配其类。默认值为 0。
CombatDamage	战斗伤害- 启用目标上损坏显示
CombatHealing	战斗愈合- 启用在目标上愈合显示
combatLogOn	战斗日志 -启用战斗日志 （？）
CombatLogPeriodicSpells	战斗日志周期 -在战斗日志中启用周期性咒语 （？）
flaggedTutorials	标记教程- 为新玩家启用/禁用教程
gameTip	游戏提示- 确定下一步将显示哪个加载屏幕提示（每个字符登录增量）
guildMemberNotify	公会会员通知- 当公会成员登录或注销时显示通知
lfgSelectedRoles	lfg选择角色- 您当前的 LFG 角色选择信息
minimapZoom	迷你地图Zoom - 迷你地图缩放级别 （？）
minimapInsideZoom	最小贴图内变焦- 放大级别内的迷你贴图（返回与迷你贴图相同的缩放级别：室内时获取Zoom（）
ObjectSelectionCircle	对象选择圈- 目标圈的大小（'0' 禁用）
PetMeleeDamage	宠物梅利损伤- 显示宠物近战损伤
PetSpellDamage	宠物拼写损伤- 显示宠物咒语损伤
predictedHealth	预测健康- 启用平滑填充健康栏（'0' 禁用）
predictedPower	预测功率- 启用平滑填充能量/马纳/拉格/流柱（'0' 禁用）
profanityFilter	亵渎过滤器- 启用亵渎过滤器
rotateMinimap	旋转迷你地图- 旋转迷你地图
secureAbilityToggle	安全可切换- 防止玩家在短（3 秒）的时间内多次按下按钮，从而意外切换掉。
spamFilter	垃圾邮件过滤器- 启用垃圾邮件过滤器
screenshotFormat	屏幕截图格式- 屏幕截图格式
screenshotQuality	屏幕截图质量- 屏幕截图质量 （0-10）
showGameTips	显示游戏提示- 切换显示加载屏幕游戏提示（'0'禁用）
showLootSpam	显示LootSpam - 显示一条消息，在战斗日志与金钱掠夺时自动抢劫
ShowTargetCastbar	显示目标强制栏- 显示目标的演员栏
ShowVKeyCastbar	ShowVKeyCastbar - 在铭牌下显示目标的演员栏
scriptErrors	脚本错误- （0/1） UI 是否显示 Lua 错误
scriptProfile	脚本配置文件- ？
statusBarText	状态栏文本- 将播放器状态栏值显示为普通 HP/MP/能源/愤怒条的顶部的文本
synchronizeSettings	同步设置- 将 UI 设置保存到服务器 （0-1）
UberTooltips	优步工具提示- 显示"扩展"工具提示
uiScale	uiScale - 接口比例
UnitNameRenderMode	单位名称渲染模式- ？
UnitNameOwn	单位名称拥有- （0/1） 切换自己的名称
UnitNameNPC	单位名称NPC - （0/1） 切换 NPC 名称
UnitNamePlayerGuild	单位名称播放器Guild - （0/1） 切换公会标签
UnitNamePlayerPVPTitle	单位名称播放器PVP标题- （0/1） 切换标题
UnitNameFriendlyPlayerName	单位名称友好玩家名称- （0/1） 切换友好玩家名称
UnitNameFriendlyPetName	单位名称友好宠物名称- （0/1） 切换友好宠物名称
UnitNameFriendlyCreationName	单位名称友好创建名称- （0/1） 切换友好创建名称
UnitNameEnemyPlayerName	单位名称敌人玩家名称- （0/1） 切换敌方玩家名称
UnitNameEnemyPetName	单位名称敌人宠物名称- （0/1） 切换敌人的宠物名称
UnitNameEnemyCreationName	单位名称敌人创建名称- （0/1） 切换敌人创建名称
UnitNameCompanionName	单位名称同伴名称- （0/1） 切换同伴名称
useUiScale	使用 UiScale - 启用接口缩放
SoundEdit	声音编辑
ChatAmbienceVolume	聊天音量- 语音聊天时周围环境的音量设置
ChatMusicVolume	聊天音乐音量- 在语音聊天中游戏音乐的音量设置
ChatSoundVolume	聊天音量- 语音聊天的音量设置
EnableMicrophone	启用麦克风- 启用麦克风
EnableVoiceChat	启用语音聊天- 启用语音聊天
FootstepSounds	足迹声音- 启用/禁用足迹声音
InboundChatVolume	入站聊天量
OutboundChatVolume	出站聊天量
Sound_ChaosMode	Sound_ChaosMode - 根据设置为"随机的声音"（需要启用）
Sound_EnableSoftwareHRTF	Sound_EnableSoftwareHRTF - 启用耳机设计的声音子系统
Sound_VoiceChatInputDriverIndex	Sound_VoiceChatInputDriverIndex - 用于语音输入的设备（麦克风）
Sound_VoiceChatOutputDriverIndex	Sound_VoiceChatOutputDriverIndex - 用于语音输出的设备（耳机或辅助扬声器）
Sound_OutputDriverIndex	Sound_OutputDriverIndex - 所选音频设备
Sound_DSPBufferSize	Sound_DSPBufferSize - 声音缓冲区大小
Sound_EnableSFX	Sound_EnableSFX - 启用 SoundFX
Sound_EnableErrorSpeech	Sound_EnableErrorSpeech - 启用错误声音（"还不能强制转换！"
Sound_EnableMusic	Sound_EnableMusic - 启用音乐
Sound_EnableAllSound	Sound_EnableAllSound - 启用所有声音
Sound_ListenerAtCharacter	Sound_ListenerAtCharacter - 将声音中心设置为播放器
Sound_EnableEmoteSounds	Sound_EnableEmoteSounds - 启用表情声音
Sound_EnableArmorFoleySoundForSelf	Sound_EnableArmorFoleySoundForSelf - 为玩家启用盔甲损坏声音
Sound_EnableArmorFoleySoundForOthers	Sound_EnableArmorFoleySoundForOthers - 为 NPC 和其他 PC 启用盔甲损坏声音
Sound_MaxCacheableSizeInBytes	Sound_MaxCacheableSizeInBytes - 将缓存的最大声音大小，较大的文件将改为流式传输
SoundMemoryCache	声音内存缓存- 声音缓存内存大小（MB）
Sound_EnableMode2	Sound_EnableMode2 - 支持备用声音处理
Sound_EnableMixMode2	Sound_EnableMixMode2 - 启用和控制 PCM 音频质量
Sound_EnableHardware	Sound_EnableHardware - 启用音频硬件加速
useEnglishAudio	使用英语音频- 覆盖区域设置并使用英语音频
*/