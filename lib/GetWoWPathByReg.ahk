;通过注册表获取wow路径
GetWoWPathByReg()
{
	RegKey:=A_Is64bitOS?"HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Blizzard Entertainment\World of Warcraft"		;64位系统
						:"HKEY_LOCAL_MACHINE\SOFTWARE\Blizzard Entertainment\World of Warcraft"		;32位系统
	RegRead, WoWPath, %RegKey%, InstallPath	;值的名字为 InstallPath
	IfExist, % WoWPath "Wow.exe"		;校验存在wow.exe时输出结果
		return SubStr(WoWPath,1,instr(WoWPath,"\",,-1)-1)   ;结果去除\retail\
}