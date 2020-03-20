;通过注册表获取wow路径
GetWoWPathByReg()
{
	RegKey:=A_Is64bitOS?"HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Blizzard Entertainment\World of Warcraft"		;64位系统
						:"HKEY_LOCAL_MACHINE\SOFTWARE\Blizzard Entertainment\World of Warcraft"		;32位系统
	RegRead, WoWPath, %RegKey%, InstallPath	;值的名字为 InstallPath
	IfExist, % WoWPath "BlizzardError.exe"		;校验存在BlizzardError.exe时输出结果
		return RegExReplace(WoWPath, "(\\_((retail)|(classic)|(ptr)|(beta))_)?\\$")    ;结果去除\_retail_\等后缀
}

;~ D:\World of Warcraft\_retail_\
;~ D:\World of Warcraft\_classic_\
;~ D:\World of Warcraft\_ptr_\
;~ D:\World of Warcraft\_beta_\