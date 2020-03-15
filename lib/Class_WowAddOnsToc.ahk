;魔兽世界插件Toc文件操作类 toc文件内容结构见末尾
class WowAddOnsToc
{
	__New(filePath)
	{
		if !FileExist(filePath)
			return
		this.filePath := filePath
		this.lines := []
		this.Encoding := "UTF-8"
		NowFileEncoding := A_FileEncoding     ;保存当前编码
		FileEncoding, % this.Encoding    ;lua的写入需要UTF-8
		Loop, read, %filePath%
			this.lines.push(A_LoopReadLine)
		FileEncoding, %NowFileEncoding%     ;恢复之前的编码
	}
	
	__Delete()
	{
		this.lines := ""
	}
	
	;获取key的设定值
	Get(key, Default := "")
	{
		for i, line in this.lines
		{
			if InStr(line, "## " key ":")
				return SubStr(line, InStr(line,":") + 1)
		}
		return Default
	}

	;设置key值为Value
	Set(key, Value)
	{
		newContents := ""
		for i, line in this.lines
		{
			if InStr(line, "## " key ":")
			{
				line := RegExReplace(line, "i)(?<=## " key ": ).*", Value)
				isfound := true
			}
			newContents .= line "`r`n"
		}
		this.FileRewrite(newContents)
		if not isfound
		{
			newLine := "## " key ": " Value
			this.lines.push(newLine)    ;新增
			FileAppend, % newLine "`r`n", % this.filePath, % this.Encoding
		}
	}
	
	;删除key的那行
	Del(key)
	{
		newContents := ""
		for i, line in this.lines
		{
			if InStr(line, "## " key ":")
			{
				this.lines.Delete(i)    ;删除
				continue
			}
			newContents .= line "`r`n"
		}
		this.FileRewrite(newContents)
	}
	
	;不删除原文件的情况下重写文件
	FileRewrite(Content)
	{
		File := FileOpen(this.filePath, "rw", this.Encoding)
		File.Length := 0
		File.Write(Content)
		File.Close()
	}
}


/* 账号配置
https://wowwiki.fandom.com/wiki/TOC_format

## Interface: 80205


*/