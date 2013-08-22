local function SetAlpha(unit)
	local db = TidyPlatesThreat.db.profile
	local T =  TPTP_UnitType(unit)
	local style = SetStyleThreatPlates(unit)
	local alpha = 1
	local nonTargetAlpha = 0
	if UnitExists("target") then
		if unit.isTarget then
			if db.nameplate.toggle["TargetA"] then
				alpha = db.nameplate.alpha["Target"]
			end
		else
			if db.blizzFade.toggle then
				nonTargetAlpha = db.blizzFade.amount
			else
				alpha = db.nameplate.alpha["NoTarget"]
			end
		end
	end
	if style == "unique" then
		for k_c,k_v in pairs(db.uniqueSettings.list) do
			if k_v == unit.name then
				u = db.uniqueSettings[k_c]
				if not u.overrideAlpha then
					alpha =(u.alpha)
				elseif db.threat.ON and InCombatLockdown() and db.threat.useAlpha and u.overrideAlpha then
					if unit.isMarked and TidyPlatesThreat.db.profile.threat.marked.alpha then
						alpha =(db.nameplate.alpha["Marked"])
					else
						if TidyPlatesThreat.db.char.threat.tanking then
							alpha =(db.threat["tank"].alpha[unit.threatSituation])
						else
							alpha = (db.threat["dps"].alpha[unit.threatSituation])
						end
					end
				elseif not InCombatLockdown() and u.overrideAlpha then
					if (unit.isDangerous and (unit.reaction == "FRIENDLY" or unit.reaction == "HOSTILE")) then
						alpha = db.nameplate.alpha["Boss"]
					elseif (unit.isElite and not unit.isDangerous and (unit.reaction == "FRIENDLY" or unit.reaction == "HOSTILE")) then
						alpha = db.nameplate.alpha["Elite"]
					elseif (not unit.isElite and not unit.isDangerous and (unit.reaction == "FRIENDLY" or unit.reaction == "HOSTILE"))then
						alpha = db.nameplate.alpha["Normal"]
					elseif unit.reaction == "NEUTRAL" then
						alpha = db.nameplate.alpha["Neutral"]
					elseif unit.reaction == "TAPPED" then
						alpha = db.nameplate.alpha["Tapped"]
					end
				end
			end
		end
	elseif style == "normal" then
		if T then alpha = (db.nameplate.alpha[T]) else alpha = 1 end
	elseif style == "empty" then
		alpha = 0
	elseif ((style == "tank" or style == "dps") and db.threat.useAlpha) then
		if unit.isMarked and TidyPlatesThreat.db.profile.threat.marked.alpha then
			alpha = (db.nameplate.alpha["Marked"])
		else
			alpha = (db.threat[style].alpha[unit.threatSituation])
		end
	else 
		if T then 
			alpha = (db.nameplate.alpha[T]) 
		else 
			alpha = 1 
		end
	end
	--
	return alpha + nonTargetAlpha	
	--
end

TidyPlatesThreat.SetAlpha = SetAlpha