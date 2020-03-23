;文件夹复制增强,多种模式(目前无链接文件夹复制时的细节优化)
;mod := "normal" 普通模式,简单复制,不会覆盖已有文件,但会创建全部子文件夹
;mod := "overWrite" 覆盖模式,会创建全部子文件夹,会覆盖已有文件. !!!存在数据丢失风险
;mod := "exactal" 完全一致模式,会先删除目标文件夹,然后拷贝过去全部的文件(文件夹). !!!存在数据丢失风险
FolderCopyEx(path, targetPath, mod := "normal", removeReparsePoint := false)
{
	;简单处理文件
	if not InStr(FileExist(path), "D")
	{
		SplitPath, targetPath,, OutDir
		FileCreateDir, % OutDir
		FileCopy, % path, % targetPath, % (mod = "normal") ? 0 : 1   ;复制文件
		return 1
	}
	pathLength := StrLen(path)
	files := []
	folders := []
	;获取源path内全部文件信息
	Loop, Files, % path "\*", FDR
	{
		subPath := SubStr(A_LoopFilePath, pathLength + 1)
		if InStr(FileExist(A_LoopFilePath), "D")
			folders.push(subPath)
		else
			files.push(subPath)
	}
    ;模式选择
    if (mod = "exactal")    ;完全一致模式
    {
        FileRemoveDir, % targetPath, 1
        overWrite := 1
    }
    else if (mod = "overWrite")    ;完全一致模式
        overWrite := 1
    else
        overWrite := 0 
	;是否先移除链接目录
	if removeReparsePoint
	{
		if FolderCopyEx_IsReparsePoint(targetPath)                 ;先检查目标文件夹本身
			FileRemoveDir, % targetPath, 1
		for i, v in folders                           ;检查目标文件夹子文件夹
		{
			if FolderCopyEx_IsReparsePoint(targetPath . v)
				FileRemoveDir, % targetPath . v, 1
		}
		for i, v in files                             ;最后检查文件
		{
			if FolderCopyEx_IsReparsePoint(targetPath . v)
				FileRemoveDir, % targetPath . v, 1
		}
	}
    ;先创建文件夹
    FileCreateDir, % targetPath
	for i, v in folders
        FileCreateDir, % targetPath . v    ;创建文件夹
	;再安装文件
	count := 0
	for i, v in files
	{
        FileCopy, % path . v, % targetPath . v, % overWrite    ;复制文件
		count++
	}
	return count
}

; 文件是否是真实文件夹
FolderCopyEx_IsReparsePoint(FilePath)
{
    attributes := DllCall("GetFileAttributes", "str", FilePath)
    return (attributes != -1 && attributes & 0x400)
}