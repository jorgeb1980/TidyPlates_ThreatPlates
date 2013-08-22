-----------------------
-- Class Icon Widget --
-----------------------
local path = "Interface\\AddOns\\TidyPlates_ThreatPlates\\Widgets\\ClassIconWidget\\"

local function enabled()
	local db = TidyPlatesThreat.db.profile.classWidget
	return db.ON
end

local function UpdateClassIconWidget(frame, unit)
	local db = TidyPlatesThreat.db.profile
	if not enabled() then frame:Hide(); return end
	if unit.class and (unit.class ~= "UNKNOWN") then
		frame.class = unit.class
	elseif db.cache[unit.name] and db.friendlyClassIcon then
		frame.class = db.cache[unit.name]
	elseif unit.guid and not db.cache[unit.name] and db.friendlyClassIcon then
		local _, engClass = GetPlayerInfoByGUID(unit.guid)
		if engClass then
			db.cache[unit.name] = engClass
			frame.class = engClass
		end
	end
	if frame.class then
		frame.Icon:SetTexture(path..db.classWidget.theme.."\\"..frame.class)
		frame:Show()
	else
		frame:Hide()	
	end
end

local function CreateClassIconWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetHeight(64)
	frame:SetWidth(64)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)
	frame:Hide()
	frame.Update = UpdateClassIconWidget
	return frame
end

ThreatPlatesWidgets.RegisterWidget("ClassIconWidget",CreateClassIconWidget,false,enabled)

ThreatPlatesWidgets.CreateClassIconWidget = CreateClassIconWidget
