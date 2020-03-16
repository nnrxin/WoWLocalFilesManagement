; 获取由命令行工具 mklink 创建的文件的原始路径
GetRealPath(FileName) 
{
    hFile := DllCall("CreateFile"
        , "str", FileName
        , "uint", 0x80000000 ; GENERIC_READ = 0x80000000
        , "uint", 0x00000001 ; FILE_SHARE_READ = 0x00000001
        , "ptr", 0
        , "uint", 3 ; OPEN_EXISTING = 3
        , "uint", 0x02000000 ; FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
        , "ptr", 0
        , "ptr")
    if (hFile > 0) 
    {
        VarSetCapacity(outPath, 260 * (A_IsUnicode ? 2 : 1))
        DllCall("GetFinalPathNameByHandle", "ptr", hFile, "str", outPath, "uint", 260, "uint", 0x0)
        return LTrim(outPath, "\?")
            ,DllCall("CloseHandle", "ptr", hFile)
    }
}