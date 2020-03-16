;解析一个文件夹是否是联接文件夹（非真实文件夹），真返回1，否则返回0
IsReparsePoint(File) 
{
    attributes := DllCall("GetFileAttributes", "str", File)
    return (attributes != -1 && attributes & 0x400)     ; FILE_ATTRIBUTE_REPARSE_POINT = 0x400
}