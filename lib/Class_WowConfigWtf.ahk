;魔兽世界配置文件操作类
class WowConfigWtf
{
	static FILE_ENCODING := "CP65001"    ;常用文件编码ID, UTF-8:65001, GB18030(XP及更高版本简体中文):54936
	
	__New(filePath)
	{
		this.filePath := filePath
		this.UpdateText()
	}

	;删除
    __Delete()
	{
		VarSetCapacity(this.text, 0)
	}
	
	;更新文本
	UpdateText()
	{
		Try FileRead, text, % (this.FILE_ENCODING ? StrReplace(this.FILE_ENCODING, "C", "*") " " : "") . this.filePath
		catch
			return 0    ;失败时返回 0
		this.text := text
		VarSetCapacity(text, 0)
		return 1
	}
	
	;解析文件内容,输出详细数组
	GetAllValue()
	{
		OldBatchLines := A_BatchLines   ;保存当前运行速度设置
		SetBatchLines -1   ;全速运行
		items := {}
		Loop, Read, % this.filePath
		{
			if  RegExMatch(A_LoopReadLine, "i)(?<=SET ).*(?= )", key)
			and RegExMatch(A_LoopReadLine, "i)(?<= "").*(?="")", value)
				items.push({key:key, value:value})
		}
		return items
		SetBatchLines %OldBatchLines%   ;恢复速度
	}
	
	;写入文件(默认写入this.text)
	WriteToFile(text := "S_T_R_I_N_V_A_R")
	{
		if (text == "S_T_R_I_N_V_A_R")
			this.FileRewrite(this.text)
		else
			this.FileRewrite(text)
	}
	
	;在文本中查找字串SearchText,返回发现位置 options可选:CaseSensitive := false, StartingPos := 1, Occurrence := 1
	InStr(SearchText, options*)
	{
		return InStr(this.text, SearchText, options*)
	}

	;字串替换, 返回替换的数量
	StrReplace(SearchText, ReplaceText, Limit := -1)
	{
		this.text := StrReplace(this.text, SearchText, ReplaceText, replaceCount, Limit)
		return replaceCount
	}

	;批量的字串替换, 输入:指令对象[["目标1", "替换1", Limit1],["目标2", "替换2", Limit2]], 返回:替换的数量
	StrReplaceBatch(o)
	{
		replaceCount := 0
		for i, options in o
			replaceCount += this.StrReplace(options*)
		return replaceCount
	}

	;获取key的设定值
	Get(key, Default := "")
	{
		if RegExMatch(this.text, "i)(?<=SET " key " "").*(?="")", value)
			return value
		else
			return Default
	}

	;设置key值为Value
	Set(key, value, writeToFile := false)
	{
		if this.InStr("SET " key " """)
			this.text := RegExReplace(this.text, "i)(?<=SET " key " "").*(?="")", value)    ;替换原有的
		else
			this.text .= "SET " key " """ value """`r`n"    ;新增一行
		if writeToFile
			this.WriteToFile()
	}
	
	;删除key的那行
	Del(key, writeToFile := false)
	{
		this.text := RegExReplace(this.text, "i)SET " key " "".*""\r\n", "", count)
		if writeToFile and count 
			this.WriteToFile()
	}
	
	;不删除原文件的情况下重写文件
	FileRewrite(text)
	{
		File := FileOpen(this.filePath, "rw", this.FILE_ENCODING)
		File.Length := 0
		File.Write(text)
		File.Close()
	}
}

/* 账号配置
synchronizeSettings "0"	;本地化 0:本地  1:
maxFPS "60"	;前台最高帧数  0-199 "0"=200
maxFPSBk "60"	;后台最高帧数  0-199 "0"=200
checkAddonVersion "1"	;检查插件版本  0:过期不会禁止   1:过期将被禁止
gxWindow = "0"		;窗口模式
gxMaximize = "0"	;0:窗口模式   1:窗口最大化
gxApi = "D3D11"	;渲染方式 DirectX 11
realmName "夏维安"	;服务器名
lastCharacterIndex "1"	;最后登陆角色位置
*/

/*



*/