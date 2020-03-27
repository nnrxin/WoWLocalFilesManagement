;计算出文件(夹)大小,可分辨链接目录
;path              : 文件路径,可以含有通配符*, 目录会自动识别其下的全部文件
;formatStr         : 输出尺寸的格式,参考String := Format(FormatStr , Values...)  
;checkReparsePoint : 是否检查链接文件

;示例:
;size := 981234767
;FilesSizeEx(path, "KB", "{1:0.2f} KB")  结果: 958237.08 KB   (KB, 小数点后两位)
;FilesSizeEx(path, "B", "{1:i}")         结果: 981234767      (字节数, 不带单位)
;FilesSizeEx(path, "MB", "{1:0.1f}MB")   结果: 935.8MB        (MB, 小数点后一位)
;FilesSizeEx(path, "GB", "{1:0.3f} GB")  结果: 0.914 GB       (MB, 小数点后三位)

FilesSizeEx(path, Units := "auto", formatStr := "auto", mod := "nomal") 
{
	BatchLines := A_BatchLines 
	SetBatchLines, -1
	files := []
	folders := [path]
	size := reparsePointSize := 0
	Loop, Files, % InStr(FileExist(path), "D") ? (path "\*") : path, FDR    ;获取源path内全部文件信息
	{
		if InStr(A_LoopFileAttrib, "D")
			folders.push(A_LoopFileLongPath)
		else
		{
			files.push(A_LoopFileLongPath)
			size += A_LoopFileSize    ;单位:B
		}
	}
	if (mod <> "nomal")    ;需要查看真实大小时
	{
		match := {}
		aaa := 0
		for i, folderI in folders     ;遍历标记出待删除的链接地址
		{
			if FilesSizeEx_IsReparsePoint(folderI)
			{
				for j, folderJ in folders
				{
					aaa++
					if InStr("\/" folderJ, "\/" folderI)
					{
						match[j] := 1
					}
				}
			}
		}
		for i in match    ;删除链接地址
			folders.Delete(i)
		realSize := 0
		for i, folder in folders    ;遍历真实目录,获取真实文件的大小
		{
			Loop, Files, % folder "\*", F
			{
				if !FilesSizeEx_IsReparsePoint(A_LoopFileLongPath)
					realSize += A_LoopFileSize
			}
		}
	}
	Switch Units    ;单位处理
	{
	Default    : dividend := 1
	Case "KB"  : dividend := 1024
	Case "MB"  : dividend := 1048576
	Case "GB"  : dividend := 1073741824
	Case "TB"  : dividend := 1099511627776
	Case "auto": 
		if        (size >= 1099511627776) {
			dividend    := 1099511627776  , formatStr := (formatStr <> "auto") ? formatStr : "{1:0.1f} TB"
		} else if (size >= 1073741824)    {
			dividend    := 1073741824     , formatStr := (formatStr <> "auto") ? formatStr : "{1:0.1f} GB"
		} else if (size >= 1048576)       {
			dividend    := 1048576        , formatStr := (formatStr <> "auto") ? formatStr : "{1:0.1f} MB"
		} else if (size >= 1024)          {
			dividend    := 1024           , formatStr := (formatStr <> "auto") ? formatStr : "{1:0.1f} KB"
		} else                            {
			dividend    := 1              , formatStr := (formatStr <> "auto") ? formatStr : "{1:i} B"
		}
	}
	SetBatchLines, %BatchLines%
	Switch mod    ;输出结果
	{
	Case "real" : return Format(formatStr, realSize / dividend)              ;真实大小
	Case "link" : return Format(formatStr, (size - realSize) / dividend)     ;链接大小
	Case "both" : return [Format(formatStr, size / dividend)
					    , Format(formatStr, realSize / dividend)
						, Format(formatStr, (size - realSize) / dividend)]    ;[全部, 真实, 链接]
	Default     : return Format(formatStr, size / dividend)                   ;一般大小
	}
}



; 文件是否是真实文件夹
FilesSizeEx_IsReparsePoint(FilePath)
{
    attributes := DllCall("GetFileAttributes", "str", FilePath)
    return (attributes != -1 && attributes & 0x400)
}