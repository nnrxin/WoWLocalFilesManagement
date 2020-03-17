;文件夹复制增强,多种模式(目前无链接文件夹复制时的细节优化)
;mod := "normal" 普通模式,简单复制,不会覆盖已有文件,但会创建全部子文件夹
;mod := "overWrite" 覆盖模式,会创建全部子文件夹,会覆盖已有文件. !!!存在数据丢失风险
;mod := "exactal" 完全一致模式,会先删除目标文件夹,然后拷贝过去全部的文件(文件夹). !!!存在数据丢失风险
FolderCopyEx(path, targetPath, mod := "normal")
{
	if not InStr(FileExist(path), "D")
		return
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
	;先只保留互不包含的目录
	for i, m in folders
	{
		for j, n in folders
		{
			if (i == j)
				continue
			if instr("\/" m, "\/" n)
			{
				folders.Delete(j)
				continue
			}
			else if instr("\/" n, "\/" m)
			{
				folders.Delete(i)
				break
			}
			
		}
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
    ;先创建文件夹
    FileCreateDir, % targetPath
	for i, v in folders
        FileCreateDir, % targetPath . v    ;创建文件夹
	;再安装文件
	for i, v in files
        FileCopy, % path . v, % targetPath . v, % overWrite    ;复制文件
}