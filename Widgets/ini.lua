----------------------------
-- General Initialization --
----------------------------

ThreatPlatesWidgets = {}
ThreatPlatesWidgets.list = {}
local media = LibStub("LibSharedMedia-3.0")
local db

local function RegisterWidget(name,create,isContext,enabled)
	if not ThreatPlatesWidgets.list[name] then
		ThreatPlatesWidget.list[name] = {
			name = name,
			create = create,
			isContext = isContext,
			enabled = enabled
		}
	else
		print("TPTP: Widget '"..name.."' already Registered.")
	end
end

local function CreateWidgets(plate)
	local w = plate.widgets
	for k,v in ThreatPlatesWidgets.list do
		if v.enabled() then
			local widget
			widget = v.create(plate)
			w[k] = widget
		else
			w[k]:Hide()
			w[k] = nil
		end
	end		
end

local function UpdatePlate(plate, unit)
	local w = plate.widgets
	for k,v in ThreatPlatesWidgets.list do
		if v.enabled() then
			if not w[k] then w[k] = v.create(plate) end
			w[k]:Update(unit)
			if v.isContext then
				w[k]:ContextUpdate(unit)
			end
		else
			w[k]:Hide()
			w[k] = nil
		end
	end	
end
ThreatPlatesWidgets.RegisterWidget = RegisterWidget
ThreatPlatesWidgets.CreateWidgets = CreateWidgets
ThreatPlatesWidgets.UpdatePlate = UpdatePlate