;获取目标数组指定键(多级键)的值
;最多支持15级键
ObjGetKeys(ByRef Obj,k)
{
	Loop % Maxi:=k.MaxIndex()
	{
		if (A_index<Maxi)
			continue
		if (A_index=1)
			return Obj[k[1]]
		else if (A_index=2)
			return Obj[k[1],k[2]]
		else if (A_index=3)
			return Obj[k[1],k[2],k[3]]
		else if (A_index=4)
			return Obj[k[1],k[2],k[3],k[4]]
		else if (A_index=5)
			return Obj[k[1],k[2],k[3],k[4],k[5]]
		else if (A_index=6)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6]]
		else if (A_index=7)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7]]
		else if (A_index=8)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8]]
		else if (A_index=9)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9]]
		else if (A_index=10)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10]]
		else if (A_index=11)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11]]
		else if (A_index=12)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12]]
		else if (A_index=13)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13]]
		else if (A_index=14)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13],k[14]]
		else if (A_index=15)
			return Obj[k[1],k[2],k[3],k[4],k[5],k[6],k[7],k[8],k[9],k[10],k[11],k[12],k[13],k[14],k[15]]
	}
}