---------------
-- Unique Icon Widget
---------------

local function enabled()
	local db = TidyPlatesThreat.db.profile.uniqueWidget
	return db.ON
end

local function UpdateUniqueIconWidget(frame, unit)
	local db = TidyPlatesThreat.db.profile.uniqueSettings
	local isShown = false
	if enabled then
		if tContains(db.list, unit.name) then
			local s
			for k,v in pairs(db.list) do
				if v == unit.name then
					s = db[k]
					break
				end
			end
			if s and s.showIcon then
				local icon
				if tonumber(s.icon) == nil then
					icon = s.icon
				else
					icon = select(3, GetSpellInfo(tonumber(s.icon)))
				end
				if icon then
					frame.Icon:SetTexture(icon)
				else
					frame.Icon:SetTexture("Interface\\Icons\\Temp")
				end
				isShown = true
			end
		end
	end
	if isShown then
		frame:Show()
	else
		frame:Hide()
	end
end

local function CreateUniqueIconWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetWidth(64)
	frame:SetHeight(64)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetPoint("CENTER",frame)
	frame.Icon:SetAllPoints(frame)
	frame:Hide()
	frame.Update = UpdateUniqueIconWidget
	return frame
end

ThreatPlatesWidgets.RegisterWidget("UniqueIconWidget",CreateUniqueIconWidget,false,enabled)