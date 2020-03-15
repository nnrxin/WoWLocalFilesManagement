;硬盘范围自动搜索一个文件，返回所有找到的路径，保存在数组里
AutoFindPath(SubFolder, SubFile, ByRef FilePath, Mod:="fast")		;子文件夹名，子文件名
{	
	BatchLines := A_BatchLines 
	SetBatchLines, -1  ; 让操作以最快速度运行.
	DriveGet, DriveList, List, FIXED		;获取硬盘所有盘符
	
	DriveList := StrReplace(DriveList, "C", "")
	
	Result := []	;搜索的结果
	Loop % StrLen(DriveList)	;搜索
	{
		loop, files, % SubStr(DriveList,1-A_Index,1) ":\*", DR
		{
			FilePath := A_LoopFileShortPath		;为外面的计时器读取到信息
			if (A_LoopFileName == SubFolder)
			{
				IfExist % A_LoopFileDir "\" SubFile	;该路径下存在子文件
				{
					Result.push(A_LoopFileDir)	;将自动获取的路径保存到数组
					if (Mod = "fast")	;快速模式下找到就跳出
						break 2
				}
			}
		}
	}
	SetBatchLines, %BatchLines%  ;恢复原有速度
	return Result	;返回搜索到的所有结果（数组）
}