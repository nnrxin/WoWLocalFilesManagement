;文件删除增强 批量删除或删除目录需要带通配符 *
;force := true 时,会修改文件只读属性, 强行删除
FilesDeleteEx(path, force := false)
{
	;先尝试删除文件
	Loop, Files, % path, FR
	{
		if force and InStr(A_LoopFileAttrib, "R")    ;移除只读属性
			FileSetAttrib, -R, % A_LoopFileFullPath
		FileDelete, % A_LoopFileFullPath
	}
	;再删除文件夹
	FileRemoveDir, % path ,1
	return 1    ;成功返回1
}