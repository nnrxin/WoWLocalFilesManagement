class IniSaved
{
	__New(filePath)
	{
		SplitPath, filePath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		if OutDir and !FileExist(OutDir)
			FileCreateDir, % OutDir
		if !FileExist(filePath)
		{
			file:=FileOpen(filePath, "rw")
			file.Close()
		}
		this.filePath := filePath
		this.VarList := []
	}
	
	;初始化
	Init(Section := "", Key := "", Default := "")
	{
		global
		IniRead, OutputVar, % this.filePath, % Section, % Key, % (Default = "") ? A_Space : Default
		iniVarName := "ini_" Section "_" Key    ;创建多个类时注意Section不能重复
		%iniVarName% := OutputVar
		this.VarList.push({iniVarName:iniVarName, Section:Section, Key:Key})
		return OutputVar
	}
	
	;仅读取
	Read(Section := "", Key := "", Default := "")
	{
		IniRead, OutputVar, % this.filePath, % Section, % Key, % (Default = "") ? A_Space : Default
		return OutputVar
	}
	
	;保存全部
	SaveAll()
	{	
		for i, v in this.VarList
		{
			iniVarName := v.iniVarName
			IniWrite, % %iniVarName%, % this.filePath, % v.Section, % v.Key
		}
	}
}













