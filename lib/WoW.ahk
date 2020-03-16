;返回职业有关信息
WoW_GetClassInfo(str)
{
	static base := []
	str := (str == "") ? "null" : str   ;空值时补一个null直接返回
	;之前查找过,有存储信息的直接返回
	if base[str]
		return base[str]
	;存储信息里没有的
	static info := {0:{index:0, color:0xE0E0E0}   ;默认返回
		,1: {index:1,  name:"Warrior",     nameCN:"战士",     nameCNShort:"ZS", color:0xC79C6E}   ;ZS
		,2: {index:2,  name:"Mage",        nameCN:"法师",     nameCNShort:"FS", color:0x69CCF0}   ;FS
		,3: {index:3,  name:"Rogue",       nameCN:"潜行者",   nameCNShort:"DZ", color:0xFFF569}    ;DZ
		,4: {index:4,  name:"Priest",      nameCN:"牧师",     nameCNShort:"MS", color:0xFFFFFF}    ;MS
		,5: {index:5,  name:"Paladin",     nameCN:"圣骑士",   nameCNShort:"QS", color:0xF58CBA}     ;QS
		,6: {index:6,  name:"Shaman",      nameCN:"萨满祭司", nameCNShort:"SM", color:0x0070DE}     ;SM
		,7: {index:7,  name:"Druid",       nameCN:"德鲁伊",   nameCNShort:"XD", color:0xFF7D0A}     ;XD
		,8: {index:8,  name:"Hunter",      nameCN:"猎人",     nameCNShort:"LR", color:0xABD473}     ;LR
		,9: {index:9,  name:"Warlock",     nameCN:"术士",     nameCNShort:"SS", color:0x9482C9}     ;SS
		,10:{index:10, name:"DeathKnight", nameCN:"死亡骑士", nameCNShort:"DK", color:0xC41F3B}     ;DK
		,11:{index:11, name:"Monk",        nameCN:"武僧",     nameCNShort:"WS", color:0x00FF96}     ;WS
		,12:{index:12, name:"DemonHunter", nameCN:"恶魔猎手", nameCNShort:"DH", color:0xA330C9}}    ;DH
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



;WoW配置快速复制专用函数，变更lua中的配置档
;需要类 #Include <Class_WowAddOnSave> ;插件lua存档的操作类
;需要函数 SB
WoW_ChgLuaProfileKeys(Folder,Fullname,SrcFullname,SBProgress:=1)  ;文件夹，角色，源角色 （格式为 "角色 - 服务器"） 默认开启计时条
{
	BatchLines:=A_BatchLines 
	SetBatchLines, -1  ; 让操作以最快速度运行.
    NowFileEncoding:=A_FileEncoding     ;保存当前编码
    FileEncoding, UTF-8     ;lua的写入需要UTF-8

	global pp,Maxpp    ;全局参数
	;配置档Section集合
	Sections=
	(
	profileKeys
	_currentProfile
	)
	
    Loop, Files, % Folder "\*.lua"  ;文件夹内循环
    {
		if SBProgress    ;加入了状态栏进度条的！！！
		{
			SB_SetText("配置档变更: " A_LoopFileName,2)	;名称变更
			SB_SetProgress(++pp,4)	;进度条变更
			if (Percent:=Round(pp*100/Maxpp,1))<=100
				SB_SetText(Percent "%",3)	    ;百分比变化
		}
		lua:=new WowAddOnSave(A_LoopFileLongPath)
		lua.SetAs(Fullname,SrcFullname,Sections)
		lua.__Delete
		VarSetCapacity(lua,0) ;释放
    }
	
    FileEncoding, %NowFileEncoding%     ;恢复之前的编码
	SetBatchLines, %BatchLines%  ;恢复原有速度
}


;WoW配置快速复制专用函数，替换wow的lua
;需要函数 SB
WoW_ChgLua(Folder,Realm,Character,NewRealm,NewCharacter,SBProgress:=1)  ;文件夹，原服务器，原角色，新服务器，新角色
{
	BatchLines:=A_BatchLines 
	SetBatchLines, -1  ; 让操作以最快速度运行.
    NowFileEncoding:=A_FileEncoding     ;保存当前编码
    FileEncoding, UTF-8     ;lua的写入需要UTF-8
	
	global pp,Maxpp    ;全局参数
	
    Loop, Files, % Folder "\*.lua"  ;文件夹内循环
    {
		if SBProgress    ;加入了状态栏进度条的！！！
		{
			SB_SetText("配置档变更: " A_LoopFileName,2)	;名称变更
			SB_SetProgress(++pp,4)	;进度条变更
			if (Percent:=Round(pp*100/Maxpp,1))<=100
				SB_SetText(Percent "%",3)	    ;百分比变化
		}
        FileRead, luatxt, %A_LoopFileLongPath%  ;读取lua
        luatxt := RegExReplace(luatxt, """" Character """", """" NewCharacter """")  ; 替换 "角色"
        luatxt := RegExReplace(luatxt, """" Character " - " Realm """", """" NewCharacter " - " NewRealm """")  ; 替换 "角色 - 服务器"
        luatxt := RegExReplace(luatxt, """" Character "-" Realm """", """" NewCharacter "-" NewRealm """")  ; 替换 "角色-服务器"
        luatxt := RegExReplace(luatxt, """" Realm " - " Character """", """" NewRealm " - " NewCharacter """")  ; 替换 "服务器 - 角色"
        luatxt := RegExReplace(luatxt, """" Realm "-" Character """", """" NewRealm "-" NewCharacter """")  ; 替换 "服务器-角色"
        FileDelete, %A_LoopFileLongPath%    ;删除原lua
        FileAppend, %luatxt%, %A_LoopFileLongPath%  ;创建新lua
    }

    VarSetCapacity(luatxt,0) ;释放
    FileEncoding, %NowFileEncoding%     ;恢复之前的编码
	SetBatchLines, %BatchLines%  ;恢复原有速度
}