;需要函数 
class WowAddOnSavedLua_Fast
{
	static FILE_ENCODING := "CP65001"    ;常用文件编码ID, UTF-8:65001, GB18030(XP及更高版本简体中文):54936
	
	;新建
	__New(filePath)
	{
		OldBatchLines := A_BatchLines   ;保存当前运行速度设置
		SetBatchLines -1   ;全速运行
		Try FileRead, text, % (this.FILE_ENCODING ? StrReplace(this.FILE_ENCODING, "C", "*") " " : "") . filePath
		catch
			return "ERROR"    ;失败时返回 "ERROR"
		this.filePath := filePath
		this.text := text
		VarSetCapacity(text, 0)
		SetBatchLines %OldBatchLines%   ;恢复速度
	}
	
	;删除
    __Delete()
	{
		VarSetCapacity(this.text, 0)
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
	
	;批量的字串替换, 输入:指令对象[["目标1", "替换1", Limit1],["目标2", "替换2", Limit2]], 返回:替换的数量对象
	StrReplaceBatch(o)
	{
		replaceCount := 0
		for i, options in o
			replaceCount += this.StrReplace(options*)
		return replaceCount
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