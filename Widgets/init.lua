---------------------
-- Widget Handling --
---------------------

ThreatPlatesWidgets = {}
ThreatPlatesWidgets.list = {}

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
		if v.enabled then
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
		if not w[k] then CreateWidgets(plate) end
		if v.isContext then
			w[k]:UpdateContext(unit)
		else
			w[k]:Update(unit)
		end
	end	
end
ThreatPlatesWidgets.RegisterWidget = RegisterWidget
ThreatPlatesWidgets.CreateWidgets = CreateWidgets
ThreatPlatesWidgets.UpdatePlate = UpdatePlate