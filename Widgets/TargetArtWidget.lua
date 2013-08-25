-----------------------
-- Target Art Widget --
-----------------------
local path = "Interface\\AddOns\\TidyPlates_ThreatPlates\\Widgets\\TargetArtWidget\\"
-- Target Art

local function enabled()
	local db = TidyPlatesThreat.db.profile.targetWidget
	return db.ON
end

local function UpdateTargetFrameArt(frame, unit)
	if enabled and unit.isTarget then
		local style = SetStyleThreatPlates(unit)
		if style and style ~= "etotem" then
			local db = TidyPlatesThreat.db.profile.targetWidget
			frame.Icon:SetTexture(path..db.theme)
			frame.Icon:SetVertexColor(db.r,db.g,db.b,db.a)
			frame:Show()
		else
			frame:Hide()
		end
	else
		frame:Hide()
	end
end

local function CreateTargetFrameArt(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetFrameLevel(parent.bars.healthbar:GetFrameLevel())
	frame:SetWidth(256)
	frame:SetHeight(64)	
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)
	frame:Hide()
	frame.Update = UpdateTargetFrameArt
	return frame
end

ThreatPlatesWidgets.RegisterWidget("TargetArtWidget",CreateTargetFrameArt,false,enabled)