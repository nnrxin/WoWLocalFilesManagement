;魔兽世界配置文件操作类
class WowConfigWtf
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
			if InStr(line, "SET " key " """)
				return Trim(SubStr(line,InStr(line,"""")),"""")	;简单的处理 可能会多切掉"
		}
		return Default
	}

	;设置key值为Value
	Set(key, Value)
	{
		newContents := ""
		for i, line in this.lines
		{
			if InStr(line, "SET " key " """)
			{
				line := RegExReplace(line, "i)(?<=" key ").*", " """ Value """")
				isfound := true
			}
			newContents .= line "`r`n"
		}
		this.FileRewrite(newContents)
		if not isfound
		{
			newLine := "SET " key " """ Value """"
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
			if InStr(line, "SET " key " """)
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