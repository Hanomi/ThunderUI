local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "*" or "")
		else
			return string
		end
	end
end

thundercolors = setmetatable({
	power = setmetatable({
		['MANA']            = { 95/255, 155/255, 255/255 }, 
		['RAGE']            = { 250/255,  75/255,  60/255 }, 
		['FOCUS']           = { 255/255, 209/255,  71/255 },
		['ENERGY']          = { 200/255, 255/255, 200/255 }, 
		['RUNIC_POWER']     = {   0/255, 209/255, 255/255 },
		["HAPPINESS"]		 = 	{0.19, 0.58, 0.58},
		["RUNES"]			 = {0.55, 0.57, 0.61},
		["AMMOSLOT"]		= { 200/255, 255/255, 200/255 },
		["FUEL"]			= { 250/255,  75/255,  60/255 },
		["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
		["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},	
		["POWER_TYPE_HEAT"] = {0.55,0.57,0.61},
      	["POWER_TYPE_OOZE"] = {0.75686281919479,1,0},
      	["POWER_TYPE_BLOOD_POWER"] = {0.73725494556129,0,1},
	}, {__index = oUF.colors.power}),
	happiness = setmetatable({
		[1] = {0.80, 0.15, 0.15},
		[2] = {1, 1, 0},
		[3] = {0.67, 0.83, 0.45},
	}, {__index = oUF.colors.happiness}),
}, {__index = oUF.colors})

oUF.TagEvents['thunder:lvl'] = "UNIT_HEALTH"
if (not oUF.Tags['thunder:lvl']) then
	oUF.Tags['thunder:lvl']  = function(unit)
		local r, g, b
		local level = UnitLevel(unit)
		local typ = UnitClassification(unit)
		if (level < 1) then
			level = "??"
			r, g, b = 0.69, 0.31, 0.31
		else
			local DiffColor = UnitLevel("target") - UnitLevel("player")
			if (DiffColor >= 5) then
				r, g, b = 1, 0, 0
			elseif (DiffColor >= 3) then
				r, g, b = 1, 1, 0
			elseif (DiffColor >= -2) then
				r, g, b = 1, 1, 1
			elseif (-DiffColor <= GetQuestGreenRange()) then
				r, g, b = 0, 1, 0
			else
				r, g, b = 0.5, 0.5, 0.5
			end
		end

		if typ=="rareelite" then
			return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)..level..'r+'
		elseif typ=="elite" then
			return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)..level..'+'
		elseif typ=="rare" then
			return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)..level..'r'
		else
			return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)..level
		end
	end
end

oUF.TagEvents['thunder:color'] = 'UNIT_POWER'
if (not oUF.Tags['thunder:color']) then
	oUF.Tags['thunder:color'] = function(unit)
		if ThunderDB[l_uf][l_ufcc] and not ThunderDB[l_uf][l_uficc] then
			if (unit == "pet" and GetPetHappiness()) then
				local c = thundercolors.happiness[GetPetHappiness()]
				return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
			else
				r, g, b = 1,.85,.75
				return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)			
			end
		else
			local _, class = UnitClass(unit)
			local reaction = UnitReaction(unit, "player")
			if (unit == "pet" and GetPetHappiness()) then
				local c = thundercolors.happiness[GetPetHappiness()]
				return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
			elseif (UnitIsPlayer(unit)) then
				local c =  oUF.colors.class[class] or {0.84, 0.75, 0.65}
				return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
			elseif (reaction) then
				local c =  oUF.colors.reaction[reaction]
				return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
			else
				r, g, b = .84,.75,.65
				return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
			end
		end
	end
end

oUF.TagEvents['thunder:name'] = 'UNIT_NAME_UPDATE'
if (not oUF.Tags['thunder:name']) then
	oUF.Tags['thunder:name'] = function(unit)
		local name = UnitName(unit)
		if (unit == "pet" and name == "Unknown") then
			return "Pet"
		elseif (unit == PetFrame.unit and name == UnitName("player")) then
			return
		else
			return utf8sub(name, 8, true)
		end
	end
end

oUF.TagEvents['thunder:longname'] = 'UNIT_NAME_UPDATE'
if (not oUF.Tags['thunder:longname']) then
	oUF.Tags['thunder:longname'] = function(unit)
		local name = UnitName(unit)
		return utf8sub(name, 18, true)
	end
end
