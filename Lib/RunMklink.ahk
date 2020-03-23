;由mklink指令代码执行mklink动作
;会检测指令代码是否可执行
;/d 需要管理员权限  /h /j 不需要管理员权限
;返回值:1 成功; 0 失败; 2 未检测; -1 模式错误
RunMklink(mod, linkPath, RealPath, feedback := false)
{
	Switch mod
	{
	;同mklink /d; 
	;**需要 Windows Vista+，以及管理员权限
	;参数可以使用绝对路径,相对路径;可以使用网络共享路径
	Case "/d":
		dwFlags := InStr(FileExist(RealPath), "D") ? 0x1 : 0x0    ;判断目标是文件(0x0)还是文件夹(0x1)
		return DllCall("CreateSymbolicLinkW", "str", linkPath, "str", RealPath, "uint", dwFlags)   ;失败返回0 成功返回1
	;同mklink /h;
	;参数可以使用绝对路径,相对路径; 两文件需要在NTFS同盘符/卷下
	Case "/h":
		return DllCall("CreateHardLinkW", "str", linkPath, "str", RealPath, "uint", "")    ;失败返回0 成功返回1
	;同mklink /j; ##未找到相关函数,临时使用cmd实现
	;参数可以使用绝对路径,相对路径 ;进行判断时必须使用绝对路径
	Case "/j":
		str := "mklink /j " linkPath " " RealPath
		StrRunAsBat(str)
		if not feedback
			return 2    ;未检测是否成功
		if (IsReparsePoint(linkPath) and GetRealPath(linkPath) == RealPath)
			return 1    ;成功
		else
			return 0    ;失败
	Default:
		return -1    ;模式错误
	}
}


;子函数###################################################################################################
;mklink /d
;需要 Windows Vista+，以及管理员权限
;参数可以使用绝对路径,相对路径;可以使用网络共享路径
;失败返回0 成功返回非0
CreateSymbolicLinkW(SymlinkFilePath, TargetFilePath) 
{
    dwFlags := InStr(FileExist(TargetFilePath), "D") ? 0x1 : 0x0    ;判断目标是文件(0x0)还是文件夹(0x1)
    return DllCall("CreateSymbolicLinkW", "str", SymlinkFilePath, "str", TargetFilePath, "uint", dwFlags)
    /*
    BOOLEAN CreateSymbolicLinkW(
      LPCWSTR lpSymlinkFileName,
      LPCWSTR lpTargetFileName,
      DWORD   dwFlags
    );
    
    dwFlags:
        0x0 链接目标是文件。
        0x1 链接目标是一个目录。
        0x2 指定此标志，以便在进程未提升时创建符号链接。必须先在计算机上启用开发人员模式，此选项才能正常工作。
    */
}

;mklink /h
;不需要管理员权限
;参数可以使用绝对路径,相对路径; 两文件需要在NTFS同盘符/卷下
;失败返回0 成功返回非0
CreateHardLinkW(FilePath, ExistingFilePath) 
{
    return DllCall("CreateHardLinkW", "str", FilePath, "str", ExistingFilePath, "uint", "")
    /*
    BOOL CreateHardLinkW(
      LPCWSTR               lpFileName,
      LPCWSTR               lpExistingFileName,
      LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
    lpSecurityAttributes  保留;必须为NULL。
    */
}

;##未找到相关函数,临时使用cmd实现
;mklink /j
;不需要管理员权限
;参数可以使用绝对路径,相对路径
;进行判断时必须使用绝对路径
;失败返回0 成功返回非0
CreateJunction(JunctionFilePath, TargetFilePath, feedback := false) 
{
    str := "mklink /j " JunctionFilePath " " TargetFilePath
    StrRunAsBat(str)
    if not feedback
        return 2    
    if (IsReparsePoint(JunctionFilePath) and GetRealPath(JunctionFilePath) == TargetFilePath)
        return 1
    else
        return 0
}

; 文件是否是真实文件夹
IsReparsePoint(FilePath)
{
    attributes := DllCall("GetFileAttributes", "str", FilePath)
    return (attributes != -1 && attributes & 0x400)
}

; 获取由命令行工具 mklink 创建的文件的原始路径
GetRealPath(FileName) 
{
    hFile := DllCall("CreateFile"
        , "str", FileName
        , "uint", 0x80000000 ; GENERIC_READ = 0x80000000
        , "uint", 0x00000001 ; FILE_SHARE_READ = 0x00000001
        , "ptr", 0
        , "uint", 3 ; OPEN_EXISTING = 3
        , "uint", 0x02000000 ; FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
        , "ptr", 0
        , "ptr")
    if (hFile > 0) {
        VarSetCapacity(outPath, 260 * (A_IsUnicode ? 2 : 1))
        DllCall("GetFinalPathNameByHandle", "ptr", hFile, "str", outPath, "uint", 260, "uint", 0x0)
        DllCall("CloseHandle", "ptr", hFile)
        return LTrim(outPath, "\?") ; 去掉左侧的 \\?\
    }
}

;执行Bat指令
StrRunAsBat(ByRef str)
{
	tempBatPath := A_ScriptDir "\ahkBat_" A_Now ".bat"
	FileAppend, %str%, %tempBatPath%
	RunWait, %tempBatPath%,, Hide    ;隐藏运行批处理文件
	FileDelete, %tempBatPath%
}