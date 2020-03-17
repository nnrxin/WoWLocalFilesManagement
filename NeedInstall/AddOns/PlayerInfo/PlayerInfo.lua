local frm = CreateFrame("Frame") 
frm:SetScript("OnEvent", function(self, event, ...) 
    if type(self[event]) == "function" then 
		return self[event](self, ...)
	end 
end)


frm:RegisterEvent("PLAYER_LOGOUT")   --退出游戏(返回角色选择界面)
function frm:PLAYER_LOGOUT()  
	local SAVED = _G.PLAYER_INFO_SAVED or {}

	local name_realm = tostring(UnitName'player') .. "-" .. tostring(GetRealmName())
	SAVED[name_realm] = SAVED[name_realm] or {}
	SAVED[name_realm].class = select(2,UnitClass'player')

	_G.PLAYER_INFO_SAVED = SAVED
end