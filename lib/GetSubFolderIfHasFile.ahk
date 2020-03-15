;获取含有指定文件(文件夹)的子目录  ,直接控制DDL列表的
GetSubFolderIfHasFile(path, flieName)
{
	r := ""
	Loop, Files, % path "\*", D
	{
		if FileExist(A_LoopFileFullPath "\" flieName)
		{
			r .= "|" A_LoopFileName
		}		
	}
	return r
}