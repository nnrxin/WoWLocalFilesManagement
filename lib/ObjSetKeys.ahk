;为目标数组指定键(多级键,可以不存在)设定值
;最多支持15级键
ObjSetKeys(ByRef Obj,k,v)
{
	if !IsObject(Obj)
		Obj:={}
	Loop % Maxi:=k.MaxIndex()
	{
		if (A_index=1)
		{
			if (Maxi=A_index)
				Obj[k[1]]:=v
			else if !IsObject(Obj[k[1]])
				Obj[k[1]]:={}
		}
		else if (A_index=2)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2]]:=v
			else if !IsObject(Obj[k[1],k[2]])
				Obj[k[1],k[2]]:={}
		}
		else if (A_index=3)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3]])
				Obj[k[1],k[2],k[3]]:={}
		}
		else if (A_index=4)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4]])
				Obj[k[1],k[2],k[3],k[4]]:={}
		}
		else if (A_index=5)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5]])
				Obj[k[1],k[2],k[3],k[4],k[5]]:={}
		}
		else if (A_index=6)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6]]:={}
		}
		else if (A_index=7)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7]]:={}
		}
		else if (A_index=8)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8]]:={}
		}
		else if (A_index=9)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9]]:={}
		}
		else if (A_index=10)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10]]:={}
		}
		else if (A_index=11)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11]]:={}
		}
		else if (A_index=12)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12]]:={}
		}
		else if (A_index=13)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13]]:={}
		}
		else if (A_index=14)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13],k[14]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13],k[14]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13],k[14]]:={}
		}
		else if (A_index=15)
		{
			if (Maxi=A_index)
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13],k[14],k[15]]:=v
			else if !IsObject(Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13],k[14],k[15]])
				Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13],k[14],k[15]]:={}
		}
		
	}
}