;安装文件函数
FileInstallTo(targetPath, cover := 0)
{
	;创建文件夹
	FileCreateDir, % targetPath "\Fonts"
	FileCreateDir, % targetPath "\AddOns\PlayerInfo"
	FileCreateDir, % targetPath "\Img\ClassIcon"
	FileCreateDir, % targetPath "\Img\GUI"
	FileCreateDir, % targetPath "\Img\MacroIcon"
	FileCreateDir, % targetPath "\Img\Spec"
	;安装文件
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\AddOns\PlayerInfo\PlayerInfo.lua, % targetPath "\AddOns\PlayerInfo\PlayerInfo.lua", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\AddOns\PlayerInfo\PlayerInfo.toc, % targetPath "\AddOns\PlayerInfo\PlayerInfo.toc", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\1.ico, % targetPath "\Img\ClassIcon\1.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\10.ico, % targetPath "\Img\ClassIcon\10.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\11.ico, % targetPath "\Img\ClassIcon\11.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\12.ico, % targetPath "\Img\ClassIcon\12.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\2.ico, % targetPath "\Img\ClassIcon\2.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\3.ico, % targetPath "\Img\ClassIcon\3.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\4.ico, % targetPath "\Img\ClassIcon\4.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\5.ico, % targetPath "\Img\ClassIcon\5.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\6.ico, % targetPath "\Img\ClassIcon\6.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\7.ico, % targetPath "\Img\ClassIcon\7.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\8.ico, % targetPath "\Img\ClassIcon\8.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\9.ico, % targetPath "\Img\ClassIcon\9.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G1.png, % targetPath "\Img\ClassIcon\G1.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G10.png, % targetPath "\Img\ClassIcon\G10.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G11.png, % targetPath "\Img\ClassIcon\G11.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G12.png, % targetPath "\Img\ClassIcon\G12.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G2.png, % targetPath "\Img\ClassIcon\G2.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G3.png, % targetPath "\Img\ClassIcon\G3.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G4.png, % targetPath "\Img\ClassIcon\G4.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G5.png, % targetPath "\Img\ClassIcon\G5.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G6.png, % targetPath "\Img\ClassIcon\G6.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G7.png, % targetPath "\Img\ClassIcon\G7.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G8.png, % targetPath "\Img\ClassIcon\G8.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\G9.png, % targetPath "\Img\ClassIcon\G9.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L1.png, % targetPath "\Img\ClassIcon\L1.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L10.png, % targetPath "\Img\ClassIcon\L10.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L11.png, % targetPath "\Img\ClassIcon\L11.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L12.png, % targetPath "\Img\ClassIcon\L12.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L2.png, % targetPath "\Img\ClassIcon\L2.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L3.png, % targetPath "\Img\ClassIcon\L3.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L4.png, % targetPath "\Img\ClassIcon\L4.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L5.png, % targetPath "\Img\ClassIcon\L5.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L6.png, % targetPath "\Img\ClassIcon\L6.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L7.png, % targetPath "\Img\ClassIcon\L7.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L8.png, % targetPath "\Img\ClassIcon\L8.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\ClassIcon\L9.png, % targetPath "\Img\ClassIcon\L9.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\GUI\Folder.png, % targetPath "\Img\GUI\Folder.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\GUI\Folderp.png, % targetPath "\Img\GUI\Folderp.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\GUI\Logo_BFA.png, % targetPath "\Img\GUI\Logo_BFA.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\GUI\Logo_Classic.png, % targetPath "\Img\GUI\Logo_Classic.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\GUI\Logo_Onion.png, % targetPath "\Img\GUI\Logo_Onion.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\GUI\WoW.png, % targetPath "\Img\GUI\WoW.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\GUI\WoWp.png, % targetPath "\Img\GUI\WoWp.png", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\MacroIcon\INV_Misc_QuestionMark.ico, % targetPath "\Img\MacroIcon\INV_Misc_QuestionMark.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Death_Knight_Blood.ico, % targetPath "\Img\Spec\Death_Knight_Blood.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Death_Knight_Frost.ico, % targetPath "\Img\Spec\Death_Knight_Frost.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Death_Knight_Unholy.ico, % targetPath "\Img\Spec\Death_Knight_Unholy.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Demon_Hunter_Havoc.ico, % targetPath "\Img\Spec\Demon_Hunter_Havoc.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Demon_Hunter_Vengeance.ico, % targetPath "\Img\Spec\Demon_Hunter_Vengeance.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Druid_Balance.ico, % targetPath "\Img\Spec\Druid_Balance.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Druid_Feral.ico, % targetPath "\Img\Spec\Druid_Feral.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Druid_Guardian.ico, % targetPath "\Img\Spec\Druid_Guardian.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Druid_Restoration.ico, % targetPath "\Img\Spec\Druid_Restoration.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Hunter_BM.ico, % targetPath "\Img\Spec\Hunter_BM.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Hunter_MM.ico, % targetPath "\Img\Spec\Hunter_MM.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Hunter_SV.ico, % targetPath "\Img\Spec\Hunter_SV.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Mage_Arcane.ico, % targetPath "\Img\Spec\Mage_Arcane.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Mage_Fire.ico, % targetPath "\Img\Spec\Mage_Fire.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Mage_Frost.ico, % targetPath "\Img\Spec\Mage_Frost.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Monk_Brewmaster.ico, % targetPath "\Img\Spec\Monk_Brewmaster.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Monk_Mistweaver.ico, % targetPath "\Img\Spec\Monk_Mistweaver.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Monk_Windwalker.ico, % targetPath "\Img\Spec\Monk_Windwalker.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Paladin_Holy.ico, % targetPath "\Img\Spec\Paladin_Holy.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Paladin_protection.ico, % targetPath "\Img\Spec\Paladin_protection.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Paladin_Retribution.ico, % targetPath "\Img\Spec\Paladin_Retribution.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Priest_Discipline.ico, % targetPath "\Img\Spec\Priest_Discipline.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Priest_Holy.ico, % targetPath "\Img\Spec\Priest_Holy.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Priest_Shadow.ico, % targetPath "\Img\Spec\Priest_Shadow.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Rogue_Assassination.ico, % targetPath "\Img\Spec\Rogue_Assassination.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Rogue_Outlaw.ico, % targetPath "\Img\Spec\Rogue_Outlaw.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Rogue_Subtlety.ico, % targetPath "\Img\Spec\Rogue_Subtlety.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Shaman_Elemental.ico, % targetPath "\Img\Spec\Shaman_Elemental.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Shaman_Enhancement.ico, % targetPath "\Img\Spec\Shaman_Enhancement.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Shaman_Restoration.ico, % targetPath "\Img\Spec\Shaman_Restoration.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Warlock_Affliction.ico, % targetPath "\Img\Spec\Warlock_Affliction.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Warlock_Demonology.ico, % targetPath "\Img\Spec\Warlock_Demonology.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Warlock_Destruction.ico, % targetPath "\Img\Spec\Warlock_Destruction.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Warrior_Arms.ico, % targetPath "\Img\Spec\Warrior_Arms.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Warrior_Fury.ico, % targetPath "\Img\Spec\Warrior_Fury.ico", % cover
	FileInstall, E:\HUI\OneDrive\autohotkey\AHK_9_自编程序\2.WoWLocalFilesManagement(WOW本地文件管理)\WoWLocalFilesManagement\NeedInstall\Img\Spec\Warrior_Protection.ico, % targetPath "\Img\Spec\Warrior_Protection.ico", % cover
}