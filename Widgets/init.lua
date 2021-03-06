---------------------
-- Widget Handling --
---------------------

ThreatPlatesWidgets = {}
ThreatPlatesWidgets.list = {}

local function RegisterWidget(name,create,isContext,enabled)
	if not ThreatPlatesWidgets.list[name] then
		ThreatPlatesWidgets.list[name] = {
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
	for k,v in pairs(ThreatPlatesWidgets.list) do
		if v.enabled() then
			if not w[k] then
				local widget
				widget = v.create(plate)
				w[k] = widget
			end
		else
			if w[k] then
				w[k]:Hide()
				w[k] = nil
			end
		end
	end		
end

local function UpdatePlate(plate, unit)
	local w = plate.widgets
	for k,v in pairs(ThreatPlatesWidgets.list) do
		if v.enabled() then
			if not w[k] then CreateWidgets(plate) end
			w[k]:Update(unit)
			if v.isContext then
				w[k]:UpdateContext(unit)
			end
		end
	end	
end
ThreatPlatesWidgets.RegisterWidget = RegisterWidget
ThreatPlatesWidgets.CreateWidgets = CreateWidgets
ThreatPlatesWidgets.UpdatePlate = UpdatePlate