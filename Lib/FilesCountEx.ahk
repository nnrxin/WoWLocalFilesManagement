;获取文件数量(默认遍历所有子文件)
FilesCountEx(path, mod := "FR")
{
	BatchLines := A_BatchLines 
	SetBatchLines, -1
	count := 0
	Loop, Files, % InStr(FileExist(path), "D") ? (path "\*") : path, % mod
		count++
	SetBatchLines, %BatchLines%
	return count
}