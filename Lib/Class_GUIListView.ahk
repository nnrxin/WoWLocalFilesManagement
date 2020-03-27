;=======================================================================================================================
;GUI LV控制类 |
;==============
;无法单独使用,只能派生成特定的类使用
;需要类:LV_Colors
Class GUIListView
{
	__New(data, hLV, hEDselected := "" , hEDinclude := "", hEDexclude := "", hSpec := "", cLV := false)
	{
		this.data                := data
		, this.dataIndex         := 0              ;当前数据组的dataIndex
		, this.lastDataIndex     := 0              ;之前数据组的lastDataIndex
		, this.hLV               := hLV
		, this.LVselected        := []             ;当前LV所选项目
		, this.LVselCount        := 0              ;选择的数目
		, this.LVlastRowIndexStr := ""             ;LV上次所选行的拼接str
		
		if hEDselected
		{
			this.hEDselected := hEDselected
		}
		if hEDinclude    ;包括
		{
			this.hEDinclude  := hEDinclude
			this.lastInclude := "@@##"
		}
		if hEDexclude    ;排除
		{
			this.hEDexclude  := hEDexclude
			this.lastExclude := "@@##"
		}
		if hSpec
		{
			this.hSpec  := hSpec
			this.lastSpec := "@@##"
		}
		if cLV
		{
			Gui, ListView, % this.hLV    ;选择操作表
			this.cLV := New LV_Colors(this.hLV,,0)    ;LV上色(弊端:无法拖动排序了,需要拦截点击标题栏动作,然后重新绘色)
			this.cLVSwitch := 1
		}
	}
	
	;更新LV
	UpdateLV(force := false)
	{
		if this.hEDinclude
			GuiControlGet, include,, % this.hEDinclude
		if this.hEDexclude
			GuiControlGet, exclude,, % this.hEDexclude
		this.include := include
		, this.exclude := exclude
		if !force and (this.dataIndex = this.lastDataIndex)    ;dataIndex和之前一样
		and (!this.hEDinclude or this.include = this.lastInclude)   ;包含和上次一样
		and (!this.hEDexclude or this.exclude = this.lastExclude)   ;排除和上次一样
		and (!this.hSpec or this.Spec = this.lastSpec)              ;特殊和上次一样
			return
		this.lastDataIndex := this.dataIndex
		, this.lastInclude := this.include
		, this.lastExclude := this.exclude
		, this.lastSpec := this.Spec
		
		Gui, ListView, % this.hLV    ;选择操作表
		GuiControl, -Redraw, % this.hLV
		LV_Delete()
		
		this.UpdateLVAdd(this.data.dataItems[this.dataIndex].items)
		
		this.UpdateLVColor()    ;更新列表颜色
		GuiControl, +Redraw, % this.hLV
	}
	
	;更新规则,需要自设
	UpdateLVAdd(items)
	{
		/* 示例
		for i, item in items
		{
			if (this.Spec and item.spec and this.Spec <> item.spec)    ;筛选特殊 自定义
				continue
			str := item.Account "`n" item.Realm "`n" item.Player    ;拼合成字串 自定义
			if (this.include <> "" and !InStr(str, this.include)) or (this.exclude <> "" and InStr(str, this.exclude))    ;筛选文字
				continue
			LV_Add("Icon" . item.playerClassIndex
			, 
			, item.playerClassCNShort
			, item.Player
			, item.Realm
			, item.Account
			, item.index
			, item.WTFIndex)
		}
		LV_ModifyCol(1, "AutoHdr NoSort")
		LV_ModifyCol(2, 0)
		LV_ModifyCol(3, 0)
		LV_ModifyCol(4, 0)
		LV_ModifyCol(5, "AutoHdr Logical")
		LV_ModifyCol(6, "AutoHdr Logical")
		LV_ModifyCol(7, "AutoHdr Logical")
		if this.Spec    ;职业筛选时进排序
			LV_ModifyCol(2, "SortDesc")
		*/
	}	
	
	;更新LV颜色
	UpdateLVColor()
	{
		if !this.cLV
			return
		this.cLV.OnMessage(False)
		if !this.cLVSwitch    ;颜色开关关闭时
			return
		Gui, ListView, % this.hLV    ;选择操作表
		GuiControl, -Redraw, % this.hLV
		this.cLV.Clear()    ;先清空颜色
		LV_GetText(dataIndex, 1, 2)    ;dataIndex序号
		
		Loop, % LV_GetCount()
		{
			LV_GetText(index, A_index, 3)    ;序号
			item := this.data.dataItems[dataIndex].items[index]
			items := this.data.dataItems[dataIndex]
			this.cLVRule(item, A_index, items)    ;颜色规则,需要自设
		}
		this.cLV.OnMessage()
		GuiControl, +Redraw, % this.hLV
	}
	
	;颜色规则,需要自设
	cLVRule(item, rowIndex)    
	{
		;颜色规则,需要自设
	}
	
	;添加LV信息到指定的编辑框中的动作 (发生变化时返回1, 未发生变化时返回0)
	UpdateLVSelected()
	{
		Gui, ListView, % this.hLV    ;选择操作表
		;哨兵, 发现选择与上次相同时直接返回上次所选
		rowIndex := 0
		, rowIndexStr := ""
		Loop 
		{
			rowIndexStr .= ";" (rowIndex := LV_GetNext(rowIndex))  ; 在前一次找到的位置后继续搜索.
		} until !rowIndex
		if (rowIndexStr = this.LVlastRowIndexStr)
		{
			this.LVlastRowIndexStr := rowIndexStr
			return 0
		}
		;重新获取LVselected
		this.LVselected := []
		Loop
		{
			rowIndex := LV_GetNext(rowIndex)  ; 在前一次找到的位置后继续搜索.
			if not rowIndex  ; 上面返回零, 所以选择的行已经都找到了.
				break
			LV_GetText(dataIndex, rowIndex, 2)    ;data序号
			LV_GetText(index,     rowIndex, 3)    ;序号
			this.LVselected.push(this.data.dataItems[dataIndex].items[index])
		}
		this.LVselCount := this.LVselected.Count()
		;控件控制
		this.UpdateGUIAfterSelected()
		return 1
	}
	
	;控件更新,需要自设
	UpdateGUIAfterSelected()
	{
		;
	}
	
	;清空已经选择
	ClearSelected()
	{
		this.LVselected          := []          ;当前LV所选项目
		, this.LVlastRowIndexStr := ""          ;LV上次所选行的拼接str
		GuiControl,, % this.hEDselected,        ;编辑框清空
	}
}