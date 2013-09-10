--[[TidyPlatesUtility:EnableGroupWatcher()
TidyPlatesWidgets:EnableAuraWatcher()
TidyPlatesWidgets:EnableTankWatch()

local isTanked = TidyPlatesWidgets.IsTankedByAnotherTank

]]

local isTanked

local function GetMarkedColor(unit,a,var)
	local db = TidyPlatesThreat.db.profile
	local c
	if ((var and var == "false") or (not db.settings.raidicon.hpColor)) and a then
		c = a
	else
		c = db.settings.raidicon.hpMarked[unit.raidIcon]
	end	
	if c then
		return c.r, c.g, c.b
	else
		return unit.red, unit.green, unit.blue
	end
end

local function GetClassColor(unit)
	local db = TidyPlatesThreat.db.profile
	local c, class
	if unit.class and (unit.class ~= "UNKNOWN") then
		class = unit.class
	elseif db.friendlyClass then
		if unit.guid then
			local _, Class = GetPlayerInfoByGUID(unit.guid)
			if not db.cache[unit.name] then
				if db.cacheClass then
					db.cache[unit.name] = Class
				end
				class = Class
			else
				class = db.cache[unit.name]
			end
		end
	end
	if class then
		c = RAID_CLASS_COLORS[class]
	end
	return c
end

local function GetThreatColor(unit,style)
	local db = TidyPlatesThreat.db.profile
	local c
	if db.threat.ON and db.threat.useHPColor and InCombatLockdown() then
		if not isTanked then -- This value is going to be determined in the SetStyles function.
			if style ~= "dps" or style ~= "tank" then
				if TidyPlatesThreat.db.char.spec[t.Active()] then
					c = db.settings.tank.threatcolor[unit.threatSituation]
				else
					c = db.settings.dps.threatcolor[unit.threatSituation]
				end
			else
				c = db.settings[style].threatcolor[unit.threatSituation]
			end
		else
			c = db.tHPbarColor
		end
	else
		c = GetClassColor(unit)
	end
	return c
end

local function SetHealthbarColor(unit)
	local db = TidyPlatesThreat.db.profile
	local style = TidyPlatesThreat.SetStyle(unit)
	local c, allowMarked
	if style == "totem" then
		local tS = db.totemSettings[ThreatPlates_Totems[unit.name]]
		if tS[2] then
			c = tS.color
		end
	elseif style == "unique" then
		for k_c,k_v in pairs(db.uniqueSettings.list) do
			if k_v == unit.name then
				local u = db.uniqueSettings[k_c]
				allowMarked = u.allowMarked
				if u.useColor then
					c = u.color
				else
					c = GetThreatColor(unit,style)
				end
			end
		end
	else
		if db.healthColorChange then
			local pct = unit.health / unit.healthmax
				--local r,g,b
				--local color1 = db.aHPbarColor
				--local color2 = db.bHPbarColor
				--if pct < 0.5 then
					--return (color1.r + ((1 - pct) * 2 * (color1.g - color1.r))), color1.g, color1.b
				--else
					--return color2.r, (color1.g - ((0.5 - pct) * 2 * color1.g)), color2.b
				--end
			c = {r = (1 - pct),g =(0 + pct), b = 0}
		else
			local reference = {
				["FRIENDLY"] = "fHPbarColor",
				["NEUTRAL"] = "nHPbarColor",
				["TAPPED"] = "tapHPbarColor",
				["HOSTILE"] = "HPbarColor",
				["UNKNOWN"] = "HPbarColor"
			}
			if reference[unit.reaction] then -- check probably isn't needed here
				if db.customColor then
					c = db[reference[unit.reaction]]
				else
					c = GetThreatColor(unit,style)
				end
			end
		end
	end
	if unit.isMarked then
		c = GetMarkedColor(unit,c,allowMarked) -- c will set itself back to c if marked color is disabled
	end
	if c then
		return c.r, c.g, c.b
	else
		return unit.red, unit.green, unit.blue
	end	
end

TidyPlatesThreat.SetHealthbarColor = SetHealthbarColor