;=======================================================================================================================
;文件数据存储库类|
;=================
;文件数据存储库类
;无法单独使用,只能派生成特定的类使用
Class FileDataStorage
{
	__New()
	{
		this.dataItems := {}    ;数据组集合
		this.dataIndex := 0     ;当前数据组序号
		this.status := {}       ;数据整体状态
		this.options := {}      ;数据控制选项
	}
	
	;新增数据组dataItem, 返回当前的dataIndex
	AddData(dataPath, force := false)
	{
		if !FileExist(dataPath)    ;路径不存在时
			return
		for i, dataItem in this.dataItems    ;在现在dataItems中寻找
		{
			if (dataItem.dataPath == dataPath)    ;发现是现有的dataItem
			{
				dataIndex := i
				if !force
					return dataIndex
				else
					break
			}
		}
		if !dataIndex
		{
			dataIndex := ++this.dataIndex
			this.dataItems[dataIndex] := {dataPath:dataPath}
		}
		this.UpdateData(dataIndex, dataPath)    ;更新数据
		return dataIndex
	}
	
	;更新数据
	UpdateData(dataIndex, dataPath)    ;***派生的类的次函数必须是这两个参数
	{
		dataItem := this.dataItems[dataIndex]
		;需要派生类自定义
	}
	
	;文件(文件夹)复制, 带有状态变更
	FilesCopy(srcPath, tarPath, str := "复制", overWrite := "overWrite")
	{
		this.status.log := str "文件到:" tarPath
		this.status.logs .= "[" str "]文件复制`t源地址:" srcPath "`t目标地址:" tarPath "`r`n"
		this.status.count += FolderCopyEx(srcPath, tarPath, overWrite)    ;强力复制文件
	}
	
	;文件(文件夹)链接, 带有状态变更
	Mklink(linkPath, realPath, str := "软链接", mod := "/d")
	{
		if FilesDeleteEx(linkPath, true)   ;操作前先删除源目录
			this.status.logs .= "[删除]文件删除`t地址:" linkPath "`r`n"
		if RunMklink(mod, linkPath, realPath, true)    ;目录联接,成功返回1
		{
			this.status.log := str ":" linkPath
			this.status.logs .= "[" str "]mklink " mod "`t链接地址:" linkPath "`t真实地址:" realPath "`r`n"
			this.status.count += 1
		}
	}
	
	;获取某文件夹的链接信息,链接失效时删除链接恢复为普通文件夹
	GetMklinkInfo(path, Encoding := "UTF-8")
	{
		if !FileExist(path)
			return
		realPath := path
		if (isReparse := IsReparsePoint(path))    ;是链接
		and !(realPath := GetRealPath(path))      ;且获取不到真实路径时
		{
			if InStr(FileExist(path), "D")    ;重建文件夹
			{
				FileRemoveDir, % path ,1
				FileCreateDir, % path
			}
			else    ;重建文件
			{
				FileDelete, % path
				FileAppend,, % path, % Encoding
			}
		}
		return {isReparse:isReparse, realPath:realPath}
	}
}