;需要函数 
;文件重写函数 FileRewrite(FliePath,Content,Encoding:="")
;生成key-value函数 ObjSetKeys(ByRef Obj,k,v)
;~ ???????正则匹配全部：RegExMatchGlobal()?????
class WowAddOnSaveLua
{
	static FILE_ENCODING := "UTF-8"    ;文件所用编码
	
	__New(FilePath,mod:="Obj")   ;默认快速模式,不存储位置信息
	{
		OldBatchLines:=A_BatchLines   ;保存当前运行速度设置
		SetBatchLines -1   ;全速运行
		OldFileEncoding:=A_FileEncoding     ;保存当前编码
		FileEncoding % this.FILE_ENCODING    ;设置编码
		this.mod:=mod   ;模式信息
		;保存整体内容到变量
		FileRead, OutputVar, % this.FilePath:=FilePath
		this.file:=OutputVar, OutputVar:=""
		;读取每行内容到数组
		this.line:={}   ;行信息
		,this.Obj:={}   ;整体数组
		,this.Range:={}   ;位置信息
		,keyList:={}  
		,tabbefore:=0
		,ArrayIndex:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		Loop, Read, %FilePath%
		{
			tabnumber:=instr(A_LoopReadLine,A_Tab,,0)
			,lineflag:=SubStr(A_LoopReadLine,tabnumber+1,1)
			,endflag:=instr(A_LoopReadLine,",")
			,key:=Trim((lineflag="[")?SubStr(A_LoopReadLine,tabnumber+2,InStr(A_LoopReadLine,"] = ")-tabnumber-2):"","""")
			,value := (key!="" and endflag)
						?RegExReplace(A_LoopReadLine,"S)(.*\] = ""?)|(""?,.*)","")  
					:(lineflag!="}" and endflag)
						?RegExReplace(A_LoopReadLine,"S)(\t""?)|(""?,.*)","")  
					:(lineflag="{")
						?{}
					:""
			,this.line[A_index]:=   {txt     :A_LoopReadLine
									,level   :tabnumber
									,endflag :endflag
									,lineflag:lineflag
									,key     :key
									,value   :value}
			if (Mod!="Obj" or tabnumber=0)   ;非Obj模式或首位行时跳过
				continue
			;由增减改变keylist
			if (tabnumber>tabbefore)   ;增
			{
				if (key!="")   ;含键
					keyList.push(key)
				else           ;无键
				{
					ArrayIndex[tabnumber]:=1
					keyList.push(ArrayIndex[tabnumber])
				}
				this.Range[Array2Str(keyList)]:={Start:A_index}   ;写入key起始行位置
			}
			else if (tabnumber=tabbefore)   ;平
			{
				if (key!="")   ;含键
				{
					keyList.pop()
					keyList.push(key)
					this.Range[Array2Str(keyList)]:={Start:A_index}   ;写入key起始行位置
				}
				else if (lineflag!="}")   ;非右括号
				{
					keyList.pop()
					ArrayIndex[tabnumber]++
					keyList.push(ArrayIndex[tabnumber])
					this.Range[Array2Str(keyList)]:={Start:A_index}   ;写入key起始行位置
				}
				else ;if (lineflag="}")   ;右括号
					this.Range[Array2Str(keyList)].End:=A_index   ;写入key结束行位置
			}
			else ;if (tabnumber<tabbefore)   ;减
			{
				ArrayIndex[tabbefore]:=0
				keyList.pop()
				this.Range[Array2Str(keyList)].End:=A_index   ;写入key结束行位置
			}
			;写入信息
			if (value!="")
				ObjSetKeys(this.Obj,keyList,value)   ;写入整体数组
			;下一循环前
			tabbefore:=tabnumber
		}
		FileEncoding %OldFileEncoding%     ;恢复之前的编码
		SetBatchLines %OldBatchLines%   ;全速运行
	}
	
    __Delete()
	{
		this.line:=this.FilePath:=this.file:=this.Obj:=""
	}

	;逐行合并this.line, 重写文件
	FileRewriteByLine()
	{
		loop % this.line.MaxIndex()
			NewContent.=this.line[A_index].txt "`r`n"
		FileRewrite(this.FilePath,NewContent,this.FILE_ENCODING)    ;文件重写
	}

	;文件用NewContent的内容覆盖
	FileRewriteByValue(NewContent)
	{
		if not NewContent
			return
		FileRewrite(this.FilePath,NewContent,this.FILE_ENCODING)    ;文件重写
	}

	;如果发现存在str，发现返回真,否则假  ；简单强大！
	IfGet(str)
	{
		StringGetPos, OutputVar, % this.file, %str%
		return (OutputVar=-1)?false:true
	}

	;(优先)Obj对象模式获取key的值,key为精准数组,结果为多信息数组
	;普通模式获取key的值,key为模糊数组,结果为数组
	Get(key,OnlyFirst:=true)
	{
		;Obj对象模式(速度更快):
		if (this.mod="Obj")
		{
			Range:=this.Range[Array2Str(key)]   ;位置信息
			,txt:=this.GetLinesTxtByRange(Range)   ;文本信息
			,Obj:=ObjGetKeys(this.Obj,key)   ;Obj数组信息
			,Value:=(Range.End="")?Obj:txt   ;单行时输出值,多行时输出txt
			,SubKeys:={}   ;子键列表
			for k in ObjGetKeys(this.Obj,key)
				SubKeys.push(k)
			return {Range:Range,txt:txt,Obj:Obj,Value:Value,SubKeys:SubKeys}
		}
		;普通模式:
		KeyIndex:=1
		,KeyMaxIndex:=key.Length()
		,ResultIndex:=1
		,Result:={}
		for k, v in this.line
		{
			if (v.key=key[KeyIndex])   ;发现符合
			{
				if (KeyIndex<KeyMaxIndex)   ;发现符合，但是不是最后的key
				{
					KeyIndex++
					continue
				}
				else if (KeyIndex=KeyMaxIndex)   ;发现符合，是最后的key
				{
					Result[ResultIndex]:={Range:{start:A_index}}
					,Startlevel:=v.level
				}
			} 
			if (v.level=Startlevel and v.endflag)  ;结束行
			{
				Result[ResultIndex].Range.end:=A_index
				Result[ResultIndex].txt:=this.GetLinesTxtByRange(Result[ResultIndex].Range)   ;文本信息
				if (ResultIndex=1 and OnlyFirst=true)   ;快速模式只输出第一个找到的
					break
				ResultIndex++   ;结果序号+1
				KeyIndex:=1   ;重新搜索
				,Startlevel:=-1   ;起始行置-1
			}
		}
		return Result   ;Result[1]:={Range:{start:1,end:10},txt:"XXXX"}
	}

	;需要this.mod=Obj
	;设置数组key值,并将影响传递到this.line上,生成文件可以被改变
	Set(key,value,type:="Str",ifRewrite:=false)
	{
		if (this.mod!="Obj")   ;非Obj对象模式无法使用
			return
		Range:=this.Range[Array2Str(key)]
		if (Range.End!="")   ;多行
			return
		P:=Range.Start   ;获取位置信息
		ObjSetKeys(this.Obj,key,value)   ;this.Obj设置
		this.line[P].value:=value
		if (this.line[P].key!="")   ;存在key
			this.line[P].txt:=RegExReplace(this.line[P].txt,"(?<=] = ).*(?=,)",(type="Str")?"""" value """":value) 
		else
			this.line[P].txt:=RegExReplace(this.line[P].txt,"(?<=\t{" this.line[P].level "}).*(?=,)",(type="Str")?"""" value """":value) 
		if (ifRewrite)
			this.FileRewriteByLine()
	}

	;(优先)Obj对象模式时,删除数组key(精准)值,并将影响传递到this.line上,生成文件可以被改变
	;普通模式时.从this.line中移除key(模糊)的内容行，key为数组,Sequence为删除的第几个结果(默认第一个,速度更快),0时全部删除
	Del(key,ifRewrite:=false,Sequence:=1)
	{
		;Obj对象模式(速度更快):
		if (this.mod="Obj")
		{
			Range:=this.Range[Array2Str(key)]   ;获取起止位置
			if (Range.End!="")   ;多行
				this.line.RemoveAt(Range.Start,Range.End-Range.Start+1)   ;行删除
			else   ;单行
				this.line.RemoveAt(Range.Start)   ;行删除
			ObjDelKeys(this.Obj,key)   ;this.Obj设置
			if (ifRewrite)
				this.FileRewriteByLine()
			return
		}
		;普通模式:
		KeyIndex:=1
		,KeyMaxIndex:=key.Length()
		,RangeIndex:=1
		,Range:={}
		for k, v in this.line
		{
			if (v.key=key[KeyIndex])   ;发现符合
			{
				if (KeyIndex<KeyMaxIndex)   ;发现符合，但是不是最后的key
				{
					KeyIndex++
					continue
				}
				else if (KeyIndex=KeyMaxIndex)   ;发现符合，是最后的key
				{
					Range[RangeIndex]:={start:A_index}
					,Startlevel:=v.level
				}
			} 
			if (v.level=Startlevel and v.endflag)  ;结束行
			{
				Range[RangeIndex].end:=A_index
				if (RangeIndex=Sequence)   ;指定模式时终止
					break
				RangeIndex++   ;结果序号+1
				KeyIndex:=1   ;重新搜索
				,Startlevel:=-1   ;起始行置-1
			}
		}
		Loop % MaxI:=Range.Length()   ;移除行
		{
			I:=MaxI-A_index+1
			this.line.RemoveAt(Range[I].start,Range[I].end-Range[I].start+1)
			if (I=Sequence)   ;指定模式时终止
				break
		}
		if (ifRewrite)
			this.FileRewriteByLine()
	}

	;将内容插入到this.line包含key(默认第一个)的下一行,key为数组,默认慢速插入,快速插入会this.line中会出现多行
	Insert(key,Contents,ifRewrite:=false,Pos:="End",Speed:="slow",Sequence:=1) 
	{
		if not Contents   ;空值时无动作
			return 0
		;Obj对象模式确定key行位置(速度更快,也可以选择插入位置是前还是后,默认后):
		if (this.mod="Obj")
			InsertLine:=(Pos="End")?this.Range[Array2Str(key)].end:this.Range[Array2Str(key)].start+1
		else   ;普通模式确定key行位置(速度稍慢,只能在前端插入)
		{
			KeyIndex:=1
			,KeyMaxIndex:=key.Length()
			,ResultIndex:=1
			for k, v in this.line
			{
				if (v.key=key[KeyIndex])   ;发现符合
				{
					if (KeyIndex<KeyMaxIndex)   ;发现符合，但是不是最后的key
					{
						KeyIndex++
						continue
					}
					else if (KeyIndex=KeyMaxIndex)   ;发现符合，是最后的key
					{
						if (ResultIndex=Sequence)   ;是指定key
						{
							InsertLine:=A_index+1   ;插入到目标行的后面
							break
						}
						else
						{
							ResultIndex++   ;结果序号+1
							KeyIndex:=1   ;重新搜索
						}
					}
				}
			}
		}
		if not InsertLine   ;未发现key值时返回
			return 0
		;下面是两种方式的插入
		if (Speed="slow")
		{
			Newline:={}
			Loop, Parse, % StrReplace(RTrim(Contents,"`r`n"),"`r`n","￠"), ￠   ; 使用￠替换`r`n后使用￠解析字符串.
			{
				tabnumber:=instr(A_LoopField,A_Tab,,0)
				lineflag:=SubStr(A_LoopField,tabnumber+1,1)
				key:=(lineflag="[")?SubStr(A_LoopField,tabnumber+2,InStr(A_LoopField,"] = ")-tabnumber-2):""   
				Newline[A_index]:={txt:A_LoopField
					,level:tabnumber
					,endflag:instr(A_LoopField,",")
					,lineflag:lineflag
					,key:Trim(key,"""")}
			}
			this.line.InsertAt(InsertLine, Newline*)   ;插入到this.line的后面,line需要+1;插入可变参数后面加*
		}
		else   ;快速插入后this.line中会出现多行,无法再用!!!!!!!!!!!!!!!!!!!
			this.line.InsertAt(InsertLine, {txt:RTrim(Contents,"`r`n")})   ;插入到this.line的后面,line需要+1;内容需要将末尾换行符去除
		;是否写入文件
		if (ifRewrite)
			this.FileRewriteByLine()
		return 1
	}

	;内部函数=====================================================================================================================
	;由行范围获取内容
	GetLinesTxtByRange(Range)
	{
		LineIndex:=Range.start
		Result.=this.line[LineIndex++].txt 
		loop % Range.end-Range.start
			Result.="`r`n" this.line[LineIndex++].txt 
		return Result
	}
}