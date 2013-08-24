------------------------
-- Social Icon Widget --
------------------------
-- This widget is designed to show a single icon to display the relationship of a player's nameplate by name (regardless of faction if a bnet friend).
-- To-Do:
-- Possibly change the method to show 3 icons.
-- Change the 'guildicon' to use the emblem and border method used by blizzard frames.

local UpdateSocialWidget -- Necessary to have the function available to the Event_Handler function

local ListTable = {
	g = {},
	b = {},
	f = {}
}

local function UpdateGlist()
	wipe(ListTable.g)
	for i=1,GetNumGuildMembers() do
		local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(i)
		tinsert(ListTable.g, name)
	end
end

local function UpdateFlist()
	wipe(ListTable.f)
	local friendsTotal, friendsOnline = GetNumFriends()
	for i=1,friendsOnline do
		local name, level, class, area, connected, status, note = GetFriendInfo(i)
		tinsert(ListTable.f, name)
	end
end

local function UpdateBnetList()
	wipe(ListTable.b)
	local BnetTotal, BnetOnline = BNGetNumFriends()
	for i=1, BnetOnline do
		local presenceID, givenName, surname, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, broadcastText, noteText, isFriend, broadcastTime  = BNGetFriendInfo(i)
		if isOnline and toonID and client == "WoW" then
			local _,name, _, realmName, faction, race, class, guild, area, lvl = BNGetToonInfo(toonID)
			tinsert(ListTable.b, name)
		end
	end
end

local function Event_Handler(self,event,...)
	if event == "GUILD_ROSTER_UPDATE" then
		UpdateGlist()
	elseif event == "FRIENDLIST_UPDATE" then
		UpdateFlist()
	elseif event == "BN_FRIEND_LIST_SIZE_CHANGED" or event == "BN_CONNECTED" or event == "BN_FRIEND_ACCOUNT_ONLINE" or event == "BN_FRIEND_ACCOUNT_OFFLINE" then
		UpdateBnetList()
	end
	for k,v in pairs(WidgetList) do -- Force update 
		UpdateSocialWidget(k,v)
	end
end

local WatcherFrame = CreateFrame("frame")
WatcherFrame:RegisterEvent("FRIENDLIST_UPDATE")
WatcherFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
WatcherFrame:RegisterEvent("BN_CONNECTED")
WatcherFrame:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
WatcherFrame:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
WatcherFrame:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
local isEnabled = false
local function EnableWatcherFrame(arg)
	isEnabled = arg
	if arg then
		WatcherFrame:SetScript("OnEvent",Event_Handler(self,event,...)
	else
		WatcherFrame:SetScript("OnEvent",nil)
	end
end

--[[
-- Might make a custom texture to use these values
-- Completely untested
local function SetGuildIcon(unit)
	local bkgR, bkgG, bkgB, borderR, borderG, borderB, emblemR, emblemG, emblemB, emblemFilename = GetGuildLogoInfo(unit)
end
]]

local path = "Interface\\AddOns\\TidyPlates_ThreatPlates\\Widgets\\SocialWidget\\"

local function enabled()
	local db = TidyPlatesThreat.db.profile.socialWidget
	return db.ON
end

local function UpdateSettings(frame)
	local db = TidyPlatesThreat.db.profile.socialWidget
	frame:SetFrameLevel(plate:GetFrameLevel()+2)
	frame:SetSize(db.scale,db.scale)
	frame:SetPoint("CENTER",plate,db.anchor, db.x, db.y)
end

local UpdateSocialWidget = function(frame, unit)
	if not WidgetList[frame] then WidgetList[frame] = unit end
	if enabled then 
		if not isEnabled then 
			EnableWatcherFrame(true)
		end
		-- I will probably expand this to a table with 'friend = true','guild = true', and 'bnet = true' and have 3 textuers show.
		local texture
		if tContains(ListTable.f, unit.name) then
			texture = path.."friendicon"
		elseif tContains(ListTable.b, unit.name) then
			texture = "Interface\\FriendsFrame\\PlusManz-BattleNet"
		elseif tContains(ListTable.g, unit.name) then
			texture = path.."guildicon"
		end
		if texture then
			UpdateSettings(frame)
			frame.Icon:SetTexture(texture)
			frame:Show()
		else
			frame:Hide()
		end		
	else		
		if isEnabled then
			EnableWatcherFrame(false)
		end
		frame:Hide()
	end
end	

local function CreateSocialWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetHeight(32)
	frame:SetWidth(32)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)
	frame:Hide()
	frame.Update = UpdateSocialWidget
	return frame
end

ThreatPlatesWidgets.RegisterWidget("SocialWidget",CreateSocialWidget,false,enabled)