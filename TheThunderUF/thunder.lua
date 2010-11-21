--[[
		Based on oUF_freeb(by freebaster)
		and oUF_Caellian(Caellian, Gotai, Recluse)
--]]

if ThunderDB["modules"][l_uf] ~= true then return end

raidzoneframe = CreateFrame("Frame", nil, UIParent) --ThunderDB[l_ufr][l_ufroffset] ThunderDB[l_ufr][l_ufrwidth] ThunderDB[l_ufr][l_ufrheight]
raidzoneframe:SetWidth(ThunderDB[l_ufr][l_ufrwidth]*5+ThunderDB[l_ufr][l_ufroffset]*4)
raidzoneframe:SetHeight(ThunderDB[l_ufr][l_ufrheight]*5+ThunderDB[l_ufr][l_ufroffset]*4)
if ThunderDB[l_ufr][l_ufrhealmode] and ThunderDB[l_ab][l_abThird] then
	raidzoneframe:SetPoint("BOTTOM", UIParent, -1, 150)
elseif ThunderDB[l_ufr][l_ufrhealmode] then
	raidzoneframe:SetPoint("BOTTOM", UIParent, -1, 120)
else
	raidzoneframe:SetPoint("LEFT", UIParent, 10, 0)
end
raidzoneframe:Show() 
--raidzoneframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})

raidpetsframe = CreateFrame("Frame", nil, UIParent)
raidpetsframe:SetWidth(100)
raidpetsframe:SetHeight(100)
raidpetsframe:SetPoint("TOPLEFT", 10, -100)
raidpetsframe:Show() 
--raidpetsframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})

raidmtframe = CreateFrame("Frame", nil, UIParent)
raidmtframe:SetWidth(100)
raidmtframe:SetHeight(100)
raidmtframe:SetPoint("BOTTOMLEFT", 400, 400)
raidmtframe:Show() 
--raidmtframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})

local _, myclass = UnitClass("player")

if ThunderDB[l_uf][l_ufuicont] > 1 then
	ThunderDB[l_uf][l_ufuicont] = 1
elseif ThunderDB[l_uf][l_ufuicont] < 0 then
	ThunderDB[l_uf][l_ufuicont] = 0
end

local siValue = function(value)
    if value >= 10000000 then 
        return string.format('%.1fm', value / 1000000) 
    elseif value >= 1000000 then
        return string.format('%.2fm', value / 1000000) 
    elseif value >= 100000 then
        return string.format('%.0fk', value / 1000) 
    elseif value >= 10000 then
        return string.format('%.1fk', value / 1000) 
    else
        return value
    end
end

local backdrop = {
	bgFile = ThunderDB[l_main][l_blank],
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local backdrop2 = {
	bgFile = ThunderDB[l_main][l_blank],
	edgeFile = ThunderDB[l_main][l_blank], 
	tile = false, tileSize = 0, edgeSize = 1, 
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local backdrop3 = {
	bgFile = ThunderDB[l_main][l_blank],
	edgeFile = ThunderDB[l_main][l_blank], 
	tile = false, tileSize = 0, edgeSize = 1, 
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local frameBD = {
	edgeFile = ThunderDB[l_main][l_shadow], edgeSize = 5,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local CFS = parent:CreateFontString(nil, "OVERLAY")
	CFS:SetFont(fontName, fontHeight, fontStyle)
	CFS:SetJustifyH("LEFT")
	CFS:SetShadowColor(0, 0, 0)
	CFS:SetShadowOffset(1, -1)
	return CFS
end

local menu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1) 
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

local UpdateReputationColor = function(self, event, unit, bar)
	local name, id = GetWatchedFactionInfo()
	bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
end

local PostUpdateHealth = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		health:SetValue(0)
			
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5".."Offline".."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5".."Dead".."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5".."Ghost".."|r")
		end
		
		if ThunderDB[l_uf][l_ufcc] and (not ThunderDB[l_uf][l_uficc]) then
			local class = select(2, UnitClass(unit))
			local color = UnitIsPlayer(unit) and oUF.colors.class[class] or {0.84, 0.75, 0.65}
			health.bg:SetVertexColor(color[1]*ThunderDB[l_uf][l_ufuicont], color[2]*ThunderDB[l_uf][l_ufuicont], color[3]*ThunderDB[l_uf][l_ufuicont])
		elseif ThunderDB[l_uf][l_ufcc] and ThunderDB[l_uf][l_uficc] then
			local class = select(2, UnitClass(unit))
			local color = UnitIsPlayer(unit) and oUF.colors.class[class] or {0.84, 0.75, 0.65}		
			health.bg:SetVertexColor(color[1], color[2], color[3])
		else
			health.bg:SetVertexColor(0, 0, 0)
		end
	else
		if ThunderDB[l_uf][l_ufcc] then
			local r, g, b = .84, .75, .65
			local t
			local reaction = UnitReaction(unit, "player")
			if(UnitIsPlayer(unit)) then
				local _, class = UnitClass(unit)
				t = oUF.colors.class[class]
			elseif reaction then
				t = oUF.colors.reaction[reaction]
			else
				r, g, b = .2, .9, .1
			end

			if(t) then
				r, g, b = t[1], t[2], t[3]
			end

			if ThunderDB[l_uf][l_uficc] then
				health:SetStatusBarColor(r*ThunderDB[l_uf][l_ufuicont], g*ThunderDB[l_uf][l_ufuicont], b*ThunderDB[l_uf][l_ufuicont])
				health.bg:SetVertexColor(r, g, b)			
			else
				health:SetStatusBarColor(r, g, b)
				health.bg:SetVertexColor(r*ThunderDB[l_uf][l_ufuicont], g*ThunderDB[l_uf][l_ufuicont], b*ThunderDB[l_uf][l_ufuicont])
			end
		else
			local r, g, b
			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.21, 0.21, 0.51, 0.23, 0.14, 0.1, 0.15, 0.1)

			health:SetStatusBarColor(r, g, b)
			health.bg:SetVertexColor(0, 0, 0)
		end

		if min ~= max then
			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", min, r * 255, g * 255, b * 255, floor(min / max * 100))
			elseif unit == "target" then
				health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", siValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
			else
				health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
			end
		else
			if unit ~= "player" and unit ~= "pet" then
				health.value:SetText("|cff559655"..siValue(max).."|r")
			else
				health.value:SetText("|cff559655"..max.."|r")
			end
		end
	end
end

local PreUpdatePower = function(power, unit)
	if ThunderDB[l_uf][l_ufcc] then
		local r, g, b = 1, 1, 1
		local _, ptype = UnitPowerType(unit)
			if(oUF.colors.power[ptype]) then
				r, g, b = unpack(thundercolors.power[ptype])
			end
		
		if ThunderDB[l_uf][l_uficc] then
			power:SetStatusBarColor(r*ThunderDB[l_uf][l_ufuicont], g*ThunderDB[l_uf][l_ufuicont], b*ThunderDB[l_uf][l_ufuicont])
			power.bg:SetVertexColor(r, g, b)
		else
			power:SetStatusBarColor(r, g, b)
			power.bg:SetVertexColor(r*ThunderDB[l_uf][l_ufuicont], g*ThunderDB[l_uf][l_ufuicont], b*ThunderDB[l_uf][l_ufuicont])
		end
	else
		local r, g, b = .84, .75, .65
		local t
		local reaction = UnitReaction(unit, "player")
		if(UnitIsPlayer(unit)) then
			local _, class = UnitClass(unit)
			t = oUF.colors.class[class]
		elseif reaction then
			t = oUF.colors.reaction[reaction]
		else
			r, g, b = .1, .8, .3
		end

		if(t) then
			r, g, b = t[1], t[2], t[3]
		end
		power:SetStatusBarColor(r, g, b)
		power.bg:SetVertexColor(r*ThunderDB[l_uf][l_ufuicont], g*ThunderDB[l_uf][l_ufuicont], b*ThunderDB[l_uf][l_ufuicont])
	end
end

local PostUpdatePower = function(power, unit, min, max)
	
	local self = power:GetParent()

	local pType, pToken = UnitPowerType(unit)
	local color = thundercolors.power[pToken] or {0.84, 0.75, 0.65}

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end
	
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
		
		if ThunderDB[l_uf][l_ufcc] and (not ThunderDB[l_uf][l_uficc]) then
			power.bg:SetVertexColor(color[1] * ThunderDB[l_uf][l_ufuicont], color[2] * ThunderDB[l_uf][l_ufuicont], color[3] * ThunderDB[l_uf][l_ufuicont])
		elseif ThunderDB[l_uf][l_ufcc] and ThunderDB[l_uf][l_uficc] then
			power.bg:SetVertexColor(color[1], color[2], color[3])
		else
			local class = select(2, UnitClass(unit))
			local color = UnitIsPlayer(unit) and oUF.colors.class[class] or {0.84, 0.75, 0.65}
			power.bg:SetVertexColor(color[1] * ThunderDB[l_uf][l_ufuicont], color[2] * ThunderDB[l_uf][l_ufuicont], color[3] * ThunderDB[l_uf][l_ufuicont])
		end
	end

	if unit ~= "player" and unit ~= "pet" and unit ~= "target" then return end

	if min == 0 then
		power.value:SetText()
	elseif not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	elseif min == max and (pType == 2 or pType == 3 and pToken ~= "POWER_TYPE_PYRITE") then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), siValue(max - (max - min)))
				elseif unit == "player" and power:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					power.value:SetFormattedText("%d%%", floor(min / max * 100))
				else
					power.value:SetFormattedText("%d%% |cffD7BEA5-|r %d", floor(min / max * 100), max - (max - min))
				end
			else
				power.value:SetText(max - (max - min))
			end
		else
			if unit == "pet" or unit == "target" then
				power.value:SetText(siValue(min))
			else
				power.value:SetText(min)
			end
		end
	end
end

local UpdateCPoints = function(self, event, unit)
	if unit == PlayerFrame.unit and unit ~= self.CPoints.unit then
		self.CPoints.unit = unit
	end
end

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	end
	return floor(s + 0.5), (s * 100 - floor(s * 100))/100
end

local CreateAuraTimer = function(self,elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local atime = FormatTime(self.timeLeft)
				self.remaining:SetText(atime)
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

local auraIcon = function(auras, button)
	local count = button.count
	count:ClearAllPoints()
	count:SetFont(ThunderDB[l_uf][l_uffont], ThunderDB[l_uf][l_uffsize], "OUTLINE")
	count:SetTextColor(1, 1, 1)
	count:SetPoint("BOTTOMRIGHT", 0, -1)
	
	auras.disableCooldown = true
	button.overlay:Hide()

	button.icon:SetTexCoord(.1, .9, .1, .9)
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", fixscale(2), fixscale(-2))
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", fixscale(-2), fixscale(2))
	
	button.bg = CreateFrame("Frame", nil, button)
	button.bg:SetPoint("TOPLEFT", button, "TOPLEFT", fixscale(-4), fixscale(4))
	button.bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", fixscale(4), fixscale(-4))
	button.bg:SetFrameStrata("BACKGROUND")
	button.bg:SetBackdrop(frameBD)
	button.bg:SetBackdropColor(0, 0, 0, 0)
	button.bg:SetBackdropBorderColor(0, 0, 0)
	
	local bd = CreateFrame("Frame", nil, button)
	bd:SetPoint("TOPLEFT", 0, 0)
	bd:SetPoint("BOTTOMRIGHT", 0, 0)
	bd:SetFrameStrata("LOW")
	SetTemplate(bd)
	button.bd = bd
	
	local remaining = button:CreateFontString(nil, "OVERLAY")
	remaining:SetFont(ThunderDB[l_uf][l_uffont], ThunderDB[l_uf][l_uffsize], "OUTLINE")
	remaining:SetTextColor(1, 1, 1)
	remaining:SetPoint("CENTER", 0, 3)
	button.remaining = remaining
end

local PostUpdateIcon
do
	local playerUnits = {
		player = true,
		pet = true,
		vehicle = true,
	}

	PostUpdateIcon = function(icons, unit, icon, index, offset)
		local name, _, _, _, dtype, duration, expirationTime, unitCaster = UnitAura(unit, index, icon.filter)
		
	if icon.debuff then
	local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
		icon.bd:SetBackdropBorderColor(color.r/2, color.g/2, color.b/2)
	else
		icon.bd:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
	end
 
	if(icon.debuff and unit == 'target') then
		if(not UnitIsFriend('player', unit) and not playerUnits[icon.owner]) then
			icon.bd:SetBackdropBorderColor(0.1, 0.1, 0.1)
			icon.icon:SetDesaturated(true)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			icon.bd:SetBackdropBorderColor(color.r/2, color.g/2, color.b/2)
			icon.icon:SetDesaturated(false)
		end
	end

	if duration and duration > 0 then
		icon.remaining:Show()
	else
		icon.remaining:Hide()
	end

	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	icon:SetScript("OnUpdate", CreateAuraTimer)
	end
end

local CreateEnchantTimer = function(self, icons)
	for i = 1, 2 do
		local icon = icons[i]
		if icon.expTime then
			icon.timeLeft = icon.expTime - GetTime()
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end
end

local UnitSpecific = {
	player = function(self)
		if ThunderDB[l_uf][l_ufclbars] and myclass == "DEATHKNIGHT" then	
			local runeloadcolors = {
					[1] = {0.59, 0.31, 0.31},
					[2] = {0.59, 0.31, 0.31},
					[3] = {0.33, 0.51, 0.33},
					[4] = {0.33, 0.51, 0.33},
					[5] = {0.31, 0.45, 0.53},
					[6] = {0.31, 0.45, 0.53},
					}

			self.Runes = CreateFrame("Frame", nil, self)
			self.Runes:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 3, -4)
			self.Runes:SetSize(ThunderDB[l_uf][l_ufwA]-6, 5)
				
			for i = 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", nil, self.Runes)
				self.Runes[i]:SetSize((ThunderDB[l_uf][l_ufwA]-11)/6, 5)
				self.Runes[i]:SetStatusBarTexture(ThunderDB[l_main][l_bar])
				self.Runes[i]:GetStatusBarTexture():SetHorizTile(false)
				self.Runes[i]:SetStatusBarColor(unpack(runeloadcolors[i]))
				
				if (i == 1) then
					self.Runes[i]:SetPoint("TOPLEFT", self.Runes, "TOPLEFT")
				else
					self.Runes[i]:SetPoint("LEFT", self.Runes[i - 1], "RIGHT", 1, 0)
				end
			end
			
			self.Runes.bg = CreateFrame("Frame", nil, self.Runes)
			self.Runes.bg:SetPoint("TOPLEFT", self.Runes, "TOPLEFT", -2, 2)
			self.Runes.bg:SetPoint("BOTTOMRIGHT", self.Runes, "BOTTOMRIGHT", 2, -2)
			self.Runes.bg:SetFrameStrata("BACKGROUND")
			self.Runes.bg:SetBackdrop(backdrop3)
			self.Runes.bg:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
			self.Runes.bg:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
		end
		
		if ThunderDB[l_uf][l_ufclbars] and myclass == "SHAMAN" then
			self.TotemBar = {}
			self.TotemBar.Destroy = true
			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
				self.TotemBar[i]:SetHeight(8)
				self.TotemBar[i]:SetWidth(ThunderDB[l_uf][l_ufwA]/4 - 3)
				if (i == 1) then
					self.TotemBar[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 1, -1)
				else
					self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 3, 0)
				end
				self.TotemBar[i]:SetStatusBarTexture(ThunderDB[l_main][l_bar])
				self.TotemBar[i]:GetStatusBarTexture():SetHorizTile(false)
				self.TotemBar[i]:SetMinMaxValues(0, 1)

				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints()
				self.TotemBar[i].bg:SetTexture(ThunderDB[l_main][l_bar])
				self.TotemBar[i].bg:SetVertexColor(0.15, 0.15, 0.15)
			end
		end

		if UnitLevel("player") < MAX_PLAYER_LEVEL then
			self.Experience = CreateFrame('StatusBar', nil, self)
			self.Experience:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', -185, 10)
			self.Experience:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', 185, 10)
			self.Experience:SetHeight(6)
			self.Experience:SetStatusBarTexture(ThunderDB[l_main][l_bar])
			self.Experience:SetStatusBarColor(0, 0.7, 1)
			self.Experience.Tooltip = true

			self.Experience.Rested = CreateFrame('StatusBar', nil, self.Experience)
			self.Experience.Rested:SetAllPoints(self.Experience)
			self.Experience.Rested:SetStatusBarTexture(ThunderDB[l_main][l_bar])
			self.Experience.Rested:SetStatusBarColor(0, 0.4, 1, 0.6)
			self.Experience.Rested:SetBackdrop(backdrop)
			self.Experience.Rested:SetBackdropColor(0, 0, 0)

			self.Experience.bg = CreateFrame("Frame", nil, self.Experience)
			self.Experience.bg:SetPoint("TOPLEFT", self.Experience, "TOPLEFT", -2, 2)
			self.Experience.bg:SetPoint("BOTTOMRIGHT", self.Experience, "BOTTOMRIGHT", 2, -2)
			self.Experience.bg:SetFrameStrata("BACKGROUND")
			self.Experience.bg:SetBackdrop(backdrop3)
			self.Experience.bg:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
			self.Experience.bg:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
		end

		if UnitLevel("player") == MAX_PLAYER_LEVEL then
			self.Reputation = CreateFrame('StatusBar', nil, self)
			self.Reputation:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', -185, 10)
			self.Reputation:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', 185, 10)
			self.Reputation:SetHeight(6)
			self.Reputation:SetFrameStrata("LOW")
			self.Reputation:SetStatusBarTexture(ThunderDB[l_main][l_bar])
			self.Reputation:SetStatusBarColor(0, 0.7, 1)
			self.Reputation.PostUpdate = UpdateReputationColor
			self.Reputation.Tooltip = true

			self.Reputation.bg = CreateFrame("Frame", nil, self.Reputation)
			self.Reputation.bg:SetPoint("TOPLEFT", self.Reputation, "TOPLEFT", -2, 2)
			self.Reputation.bg:SetPoint("BOTTOMRIGHT", self.Reputation, "BOTTOMRIGHT", 2, -2)
			self.Reputation.bg:SetFrameStrata("BACKGROUND")
			self.Reputation.bg:SetBackdrop(backdrop3)
			self.Reputation.bg:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
			self.Reputation.bg:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
		end
		
		if ThunderDB[l_uf][l_ufclbars] and myclass == "PALADIN" then
			self.HolyPower = CreateFrame("Frame", nil, self)
			self.HolyPower:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 3, -4)
			self.HolyPower:SetSize((ThunderDB[l_uf][l_ufwA]-20)/3, 5) -- mb need self.HolyPower:SetSize(ThunderDB[l_uf][l_ufwA]-20, 5) ??
			self.HolyPower.anchor = 'BOTTOM'
			self.HolyPower.growth = 'RIGHT'
		
			for i = 1, 3 do
				self.HolyPower[i] = CreateFrame("StatusBar", nil, self.HolyPower)
				self.HolyPower[i]:SetStatusBarTexture(ThunderDB[l_main][l_bar])
				self.HolyPower[i]:SetSize((ThunderDB[l_uf][l_ufwA]-20)/3, 5)
				self.HolyPower[i]:SetStatusBarColor(1,.95,.33)
	
				if i == 1 then
					self.HolyPower[i]:SetPoint("TOPLEFT", self.HolyPower, "TOPLEFT")
				else
					self.HolyPower[i]:SetPoint("LEFT", self.HolyPower[i - 1], "RIGHT", 7, 0)
				end
				
				self.HolyPower[i].bd = CreateFrame("Frame", nil, self.HolyPower[i])
				self.HolyPower[i].bd:SetPoint("TOPLEFT", self.HolyPower[i], "TOPLEFT", -2, 2)
				self.HolyPower[i].bd:SetPoint("BOTTOMRIGHT", self.HolyPower[i], "BOTTOMRIGHT", 2, -2)
				self.HolyPower[i].bd:SetFrameStrata("BACKGROUND")
				self.HolyPower[i].bd:SetBackdrop(backdrop3)
				self.HolyPower[i].bd:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
				self.HolyPower[i].bd:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
			end
		end
		if ThunderDB[l_uf][l_ufclbars] and myclass == "WARLOCK" then
			self.SoulShards = CreateFrame("Frame", nil, self)
			self.SoulShards:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 3, -4)
			self.SoulShards:SetSize((ThunderDB[l_uf][l_ufwA]-20)/3, 5)
			self.SoulShards.anchor = 'BOTTOM'
			self.SoulShards.growth = 'RIGHT'
		
			for i = 1, 3 do
				self.SoulShards[i] = CreateFrame("StatusBar", nil, self.SoulShards)
				self.SoulShards[i]:SetStatusBarTexture(ThunderDB[l_main][l_bar])
				self.SoulShards[i]:SetSize((ThunderDB[l_uf][l_ufwA]-20)/3, 5)
				self.SoulShards[i]:SetStatusBarColor(.75,.33,1)
	
				if i == 1 then
					self.SoulShards[i]:SetPoint("TOPLEFT", self.SoulShards, "TOPLEFT")
				else
					self.SoulShards[i]:SetPoint("LEFT", self.SoulShards[i - 1], "RIGHT", 7, 0)
				end
				
				self.SoulShards[i].bd = CreateFrame("Frame", nil, self.SoulShards[i])
				self.SoulShards[i].bd:SetPoint("TOPLEFT", self.SoulShards[i], "TOPLEFT", -2, 2)
				self.SoulShards[i].bd:SetPoint("BOTTOMRIGHT", self.SoulShards[i], "BOTTOMRIGHT", 2, -2)
				self.SoulShards[i].bd:SetFrameStrata("BACKGROUND")
				self.SoulShards[i].bd:SetBackdrop(backdrop3)
				self.SoulShards[i].bd:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
				self.SoulShards[i].bd:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
			end
		end
		if ThunderDB[l_uf][l_ufclbars] and myclass == "DRUID" then
			self.EclipseBar = CreateFrame('Frame', nil, self)
			self.EclipseBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 3, -4)
			self.EclipseBar:SetSize(ThunderDB[l_uf][l_ufwA]-6, 5)
			
			self.EclipseBar.bd = CreateFrame("Frame", nil, self.EclipseBar)
			self.EclipseBar.bd:SetPoint("TOPLEFT", self.EclipseBar, "TOPLEFT", -2, 2)
			self.EclipseBar.bd:SetPoint("BOTTOMRIGHT", self.EclipseBar, "BOTTOMRIGHT", 2, -2)					
			self.EclipseBar.bd:SetBackdrop(backdrop3)
			self.EclipseBar.bd:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
			self.EclipseBar.bd:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))		

			local lunarBar = CreateFrame("StatusBar", nil, self.EclipseBar)
			lunarBar:SetPoint("LEFT", self.EclipseBar, "LEFT", 0, 0)
			lunarBar:SetSize(self.EclipseBar:GetWidth(), self.EclipseBar:GetHeight())
			lunarBar:SetStatusBarTexture(ThunderDB[l_main][l_bar])
			lunarBar:SetStatusBarColor(0.34, 0.1, 0.86)
			self.EclipseBar.LunarBar = lunarBar

			local solarBar = CreateFrame("StatusBar", nil, self.EclipseBar)
			solarBar:SetPoint("LEFT", lunarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
			solarBar:SetSize(self.EclipseBar:GetWidth(), self.EclipseBar:GetHeight())
			solarBar:SetStatusBarTexture(ThunderDB[l_main][l_bar])
			solarBar:SetStatusBarColor(0.95, 0.73, 0.15)
			self.EclipseBar.SolarBar = solarBar
			
			local eclipseBarText = solarBar:CreateFontString(nil, "OVERLAY")
			eclipseBarText:SetPoint("CENTER", self.EclipseBar, "CENTER")
			eclipseBarText:SetFont(ThunderDB[l_uf][l_uffont], ThunderDB[l_uf][l_ufufsize]-1, "OUTLINE")
			self:Tag(eclipseBarText, '[pereclipse]%')
        end
	end,	

	target = function(self)
		self.CPoints = {}
		self.CPoints.unit = PlayerFrame.unit
			for i = 1, 5 do
				self.CPoints[i] = self.Health:CreateTexture(nil, "OVERLAY")
				self.CPoints[i]:SetHeight(12)
				self.CPoints[i]:SetWidth(12)
				self.CPoints[i]:SetTexture(ThunderDB[l_main][l_cp])
				if i == 1 then
					self.CPoints[i]:SetPoint("TOPLEFT", self, "TOPLEFT", -8, 8)
					self.CPoints[i]:SetVertexColor(1, 0.31, 0.31)
				else
					self.CPoints[i]:SetPoint("TOP", self.CPoints[i-1], "BOTTOM", 0, 0)
				end
			end
		self.CPoints[2]:SetVertexColor(1, 0.31, 0.31)
		self.CPoints[3]:SetVertexColor(1, 1, 0.64)
		self.CPoints[4]:SetVertexColor(1, 1, 0.64)
		self.CPoints[5]:SetVertexColor(0.33, 1, 0.33)
		self:RegisterEvent("UNIT_COMBO_POINTS", UpdateCPoints)
		
	-- mouseover focus script by Munglunch 
		if ThunderDB[l_uf][l_ufmfs] then
		local focuspoint = CreateFrame("BUTTON", "mouseFocus", self.Health, "SecureActionButtonTemplate")
		focuspoint:EnableMouse(true)
		focuspoint:RegisterForClicks("AnyUp")
		focuspoint:SetAttribute("type", "macro")
		focuspoint:SetAttribute("macrotext", "/focus")
		focuspoint:SetHeight(12)
		focuspoint:SetWidth(12)
		focuspoint:SetPoint("BOTTOMRIGHT", self.Health, 0, 0)
		focuspoint:SetFrameStrata("DIALOG")

		local focuspointtext = focuspoint:CreateTexture(nil, "ARTWORK")
		focuspointtext:SetTexture(ThunderDB[l_main][l_cp])
		focuspointtext:SetParent(focuspoint)
		focuspointtext:SetAllPoints(focuspoint)
		focuspointtext:SetVertexColor(0.8, 0.8, 0.3, 1)
		focuspointtext:SetAlpha(0)

		focuspoint:SetScript("OnLeave", function() focuspointtext:SetAlpha(0) end)
		focuspoint:SetScript("OnEnter", function(self) focuspointtext:SetAlpha(1) end)
		end
	end,

	focus = function(self)
		if ThunderDB[l_uf][l_ufmfs] then
		local focuspoint2 = CreateFrame("BUTTON", "mouseFocus", self.Health, "SecureActionButtonTemplate")
		focuspoint2:EnableMouse(true)
		focuspoint2:RegisterForClicks("AnyUp")
		focuspoint2:SetAttribute("type", "macro")
		focuspoint2:SetAttribute("macrotext", "/clearfocus")
		focuspoint2:SetHeight(12)
		focuspoint2:SetWidth(12)
		focuspoint2:SetPoint("BOTTOMRIGHT", self.Health, 0, 0)
		focuspoint2:SetFrameStrata("DIALOG")

		local focuspoint2text = focuspoint2:CreateTexture(nil, "ARTWORK")
		focuspoint2text:SetTexture(ThunderDB[l_main][l_cp])
		focuspoint2text:SetParent(focuspoint2)
		focuspoint2text:SetAllPoints(focuspoint2)
		focuspoint2text:SetVertexColor(0.8, 0.8, 0.3, 1)
		focuspoint2text:SetAlpha(0)

		focuspoint2:SetScript("OnLeave", function() focuspoint2text:SetAlpha(0) end)
		focuspoint2:SetScript("OnEnter", function(self) focuspoint2text:SetAlpha(1) end)
		end
	end,
}

local sharedstyle = function(self, unit)
	self.menu = menu
	
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(unpack(ThunderDB[l_main][l_bgcolor]))
	self:SetAlpha(1)
	
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")
	
	self.FrameBackdrop = CreateFrame("Frame", nil, self)
	self.FrameBackdrop:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
	self.FrameBackdrop:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 4, -4)
	self.FrameBackdrop:SetFrameStrata("LOW")
	self.FrameBackdrop:SetBackdrop(frameBD)
	self.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
	self.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
	
	self.Selfbpanel = CreateFrame("Frame", nil, self)
 	self.Selfbpanel:SetPoint("TOPLEFT")
 	self.Selfbpanel:SetPoint("BOTTOMRIGHT")
	self.Selfbpanel:SetBackdrop(backdrop2)
	self.Selfbpanel:SetBackdropColor(0, 0, 0, 0)
	self.Selfbpanel:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bcolor]))


----------------------------------------------
-- Панелька под имя
----------------------------------------------

if unit == "player" or unit == "target" then	
	self.Namepanel = CreateFrame("Frame", nil, self)
	if ThunderDB[l_uf][l_ufport] and unit == "player" then
		self.Namepanel:SetPoint("TOPLEFT", self, "BOTTOMLEFT", ThunderDB[l_uf][l_ufHA]+27, 16)
		self.Namepanel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
	elseif ThunderDB[l_uf][l_ufport] and unit == "target" then
		self.Namepanel:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 2, 16)
		self.Namepanel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -27-ThunderDB[l_uf][l_ufHA], 2)
	else
		self.Namepanel:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 2, 16)
		self.Namepanel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
	end
	self.Namepanel:SetBackdrop(backdrop2)
	self.Namepanel:SetBackdropColor(0, 0, 0, 0.8)
	self.Namepanel:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bcolor]))
end
	
----------------------------------------------
-- Хп бар
----------------------------------------------

	self.Health = CreateFrame("StatusBar", self:GetName().."_Health", self)
	self.Health:SetHeight(ThunderDB[l_uf][l_ufHA])
	if ThunderDB[l_uf][l_ufport] and unit == "player" then
		self.Health:SetPoint("TOPLEFT", ThunderDB[l_uf][l_ufHA]+28, -3)
		self.Health:SetPoint("TOPRIGHT", -3, -3)
	elseif ThunderDB[l_uf][l_ufport] and unit == "target" then
		self.Health:SetPoint("TOPLEFT", 3, -3)
		self.Health:SetPoint("TOPRIGHT", -28-ThunderDB[l_uf][l_ufHA], -3)
	else
		self.Health:SetPoint("TOPLEFT", 3, -3)
		self.Health:SetPoint("TOPRIGHT", -3, -3)
	end
	self.Health:SetStatusBarTexture(ThunderDB[l_main][l_bar])
	self.Health:GetStatusBarTexture():SetHorizTile(false)

	self.Health.colorTapping = true
	
	self.Health.frequentUpdates = true
	self.Health.Smooth = true

	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints()
	self.Health.bg:SetTexture(ThunderDB[l_main][l_bar])

	self.Health.PostUpdate = PostUpdateHealth
	
	self.Healthpanel = CreateFrame("Frame", nil, self)
 	self.Healthpanel:SetPoint("TOPLEFT", self.Health, "TOPLEFT", -1, 1)
 	self.Healthpanel:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", 1, -1)
	self.Healthpanel:SetBackdrop(backdrop2)
	self.Healthpanel:SetBackdropColor(0, 0, 0, 0)
	self.Healthpanel:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bcolor]))

----------------------------------------------
-- Мана бар
----------------------------------------------	
	
	self.Power = CreateFrame("StatusBar", self:GetName().."_Power", self)
	self.Power:SetHeight(4)
	self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -3)
	self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -3)
	self.Power:SetStatusBarTexture(ThunderDB[l_main][l_bar])
	self.Power:GetStatusBarTexture():SetHorizTile(false)

	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints()
	self.Power.bg:SetTexture(ThunderDB[l_main][l_bar])

	self.Power.frequentUpdates = true
	self.Power.Smooth = true

	self.Power.PreUpdate = PreUpdatePower
	self.Power.PostUpdate = PostUpdatePower
		
	self.Powerpanel = CreateFrame("Frame", nil, self)
 	self.Powerpanel:SetPoint("TOPLEFT", self.Power, "TOPLEFT", -1, 1)
 	self.Powerpanel:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", 1, -1)
	self.Powerpanel:SetBackdrop(backdrop2)
	self.Powerpanel:SetBackdropColor(0, 0, 0, 0)
	self.Powerpanel:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bcolor]))

----------------------------------------------
-- Хп и Мп
----------------------------------------------	
	
	self.Health.value = SetFontString((unit == "player" or unit == "target") and self.Namepanel or self.Health, ThunderDB[l_uf][l_uffont], ThunderDB[l_uf][l_ufufsize])
	self.Power.value = SetFontString((unit == "player" or unit == "target") and self.Namepanel or self.Power, ThunderDB[l_uf][l_uffont], ThunderDB[l_uf][l_ufufsize])
if unit == "player" or unit == "target" then
	self.Health.value:SetPoint("BOTTOMRIGHT", -3, 3)
	self.Power.value:SetPoint("BOTTOMLEFT", 3, 3)
else
	self.Health.value:SetPoint("RIGHT", -1, 0)
	self.Power.value:SetPoint("BOTTOMLEFT", 1, 0)
end

----------------------------------------------
-- Имя
----------------------------------------------	

if unit ~= "player" then
	self.Info = SetFontString(self.Health, ThunderDB[l_uf][l_uffont], ThunderDB[l_uf][l_ufufsize])
	if unit == "target" then
		self:Tag(self.Info, '[thunder:color][thunder:longname] [thunder:lvl]')
		self.Info:SetPoint("LEFT", 1, 0)
	else
		self:Tag(self.Info, '[thunder:color][thunder:name]')
		self.Info:SetPoint("LEFT", 1, 0)
	end 	
end

----------------------------------------------
-- Портерт и рамка
----------------------------------------------	

if ThunderDB[l_uf][l_ufport] and (unit == "player" or unit == "target") then
	self.Portraitpanel = CreateFrame("Frame", nil, self)
	self.Portraitpanel:SetWidth(ThunderDB[l_uf][l_ufHA]+24)
	self.Portraitpanel:SetHeight(ThunderDB[l_uf][l_ufHA]+24)
	if unit == "player" then
		self.Portraitpanel:SetPoint("TOPLEFT", self, "TOPLEFT", fixscale(2), fixscale(-2))
	else
		self.Portraitpanel:SetPoint("TOPRIGHT", self, "TOPRIGHT", fixscale(-2), fixscale(-2))
	end
	self.Portraitpanel:SetBackdrop(backdrop2)
	self.Portraitpanel:SetBackdropColor(0, 0, 0, 0.8)
	self.Portraitpanel:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bcolor]))

	self.Portrait = CreateFrame("PlayerModel", nil, self)
	self.Portrait:SetPoint("TOPLEFT", self.Portraitpanel, "TOPLEFT", fixscale(1), fixscale(-1))
	self.Portrait:SetPoint("BOTTOMRIGHT", self.Portraitpanel, "BOTTOMRIGHT", fixscale(-1), fixscale(1))
end

----------------------------------------------
-- Кастбары
----------------------------------------------	

if (unit == "player" or unit == "target" or unit == "focus") and ThunderDB[l_uf][l_ufcast] then
	self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
	self.Castbar:SetStatusBarTexture(ThunderDB[l_main][l_bar], "OVERLAY")
	self.Castbar:GetStatusBarTexture():SetHorizTile(false)
	self.Castbar:SetStatusBarColor(.95, .95, .95, 0.70)
	
	if unit == "focus" then
		self.Castbar:SetPoint("TOPLEFT", UIParent, "CENTER", fixscale(-150), fixscale(210))
		self.Castbar:SetPoint("BOTTOMRIGHT", UIParent, "CENTER", fixscale(150), fixscale(190))
	elseif unit == "player" and ThunderDB[l_uf][l_ufcastmaxi] then
		self.Castbar:SetPoint("TOPLEFT", UIParent, "BOTTOM", fixscale(-110), fixscale(ThunderDB[l_uf][l_ufcastmaxiYpos]+20))
		self.Castbar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", fixscale(140), fixscale(ThunderDB[l_uf][l_ufcastmaxiYpos]))
	elseif unit == "target" and ThunderDB[l_uf][l_ufcastmaxi] then
		self.Castbar:SetPoint("TOPLEFT", self, "TOPLEFT", 3, ThunderDB[l_uf][l_ufausize]*3+30)
		self.Castbar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -30, ThunderDB[l_uf][l_ufausize]*3+10)	
	else
		self.Castbar:SetParent(self.Namepanel)
		self.Castbar:SetPoint("TOPLEFT", self.Namepanel, "TOPLEFT", 1, -1)
		self.Castbar:SetPoint("BOTTOMRIGHT", self.Namepanel, "BOTTOMRIGHT", -1, 1)
	end
	
	if ThunderDB[l_uf][l_ufcastmaxi] or unit == "focus" then
		self.Castbarbg = CreateFrame("Frame", nil, self.Castbar)
		self.Castbarbg:SetPoint("TOPLEFT", self.Castbar, "TOPLEFT", fixscale(-2), fixscale(2))
		self.Castbarbg:SetPoint("BOTTOMRIGHT", self.Castbar, "BOTTOMRIGHT", fixscale(2), fixscale(-2))
		self.Castbarbg:SetBackdrop(backdrop3)
		self.Castbarbg:SetFrameStrata("BACKGROUND")
		self.Castbarbg:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
		self.Castbarbg:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
	else
		self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
		self.Castbar.bg:SetAllPoints()
		self.Castbar.bg:SetTexture(ThunderDB[l_main][l_bar])
		self.Castbar.bg:SetVertexColor(unpack(ThunderDB[l_main][l_bcolor]))
	end

	self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY')
	self.Castbar.Time:SetFont(ThunderDB[l_uf][l_uffont], ThunderDB[l_uf][l_ufufsize])
	self.Castbar.Time:SetShadowOffset(1, -1)
	self.Castbar.Time:SetPoint("RIGHT", self.Castbar, -1, 1)
	self.Castbar.CustomTimeText = function(self, duration)
		if self.casting then
			self.Time:SetFormattedText("%.1f/%.2f", self.max - duration, self.max)
		elseif self.channeling then
			self.Time:SetFormattedText("%.1f/%.2f", duration, self.max)
		end
	end
	
	self.Castbar.Text = self.Castbar:CreateFontString(nil, "OVERLAY")
	self.Castbar.Text:SetFont(ThunderDB[l_uf][l_uffont], ThunderDB[l_uf][l_ufufsize])
	self.Castbar.Text:SetShadowOffset(1, -1)
	self.Castbar.Text:SetPoint("LEFT", self.Castbar, 1, 1)
	self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT")
	self.Castbar.Text:SetJustifyH"LEFT"
	
if ThunderDB[l_uf][l_ufcasticon] == true and (unit == "player" or unit == "target" or unit == "focus") then
	self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'ARTWORK')
	if unit == "focus" then
		self.Castbar.Icon:SetHeight(25)
		self.Castbar.Icon:SetWidth(25)
	else
		self.Castbar.Icon:SetHeight(20)
		self.Castbar.Icon:SetWidth(20)
	end
	self.Castbar.Icon:SetTexCoord(.1, .9, .1, .9)

	if ThunderDB[l_uf][l_ufcastmaxi] and unit == "player" then
		self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar, "BOTTOMLEFT", -7, 0)
	elseif ThunderDB[l_uf][l_ufcastmaxi] and unit == "target" then
		self.Castbar.Icon:SetPoint("BOTTOMLEFT", self.Castbar, "BOTTOMRIGHT", 7, 0)
	elseif ThunderDB[l_uf][l_ufport] and unit == "player" then
		self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar, "BOTTOMLEFT", -32-ThunderDB[l_uf][l_ufHA], 0)
	elseif ThunderDB[l_uf][l_ufport] and unit == "target" then
		self.Castbar.Icon:SetPoint("BOTTOMLEFT", self.Castbar, "BOTTOMRIGHT", ThunderDB[l_uf][l_ufHA]+32, 0)
	elseif unit == "player" then
		self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar, "BOTTOMLEFT", -7, 0)
	elseif unit == "target" then
		self.Castbar.Icon:SetPoint("BOTTOMLEFT", self.Castbar, "BOTTOMRIGHT", 7, 0)
	elseif unit == "focus" then
		self.Castbar.Icon:SetPoint("BOTTOM", self.Castbar, "TOP", 0, 10)
	else
		self.Castbar.Icon:SetPoint("BOTTOMLEFT", self.Castbar, "BOTTOMRIGHT", 7, 0)
	end	

	self.Castbar.IBackdrop = CreateFrame("Frame", nil, self.Castbar)
	self.Castbar.IBackdrop:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT", -6, 6)
	self.Castbar.IBackdrop:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT", 6, -6)
	self.Castbar.IBackdrop:SetFrameStrata("BACKGROUND")
	self.Castbar.IBackdrop:SetBackdrop(frameBD)
	self.Castbar.IBackdrop:SetBackdropColor(0, 0, 0, 0)
	self.Castbar.IBackdrop:SetBackdropBorderColor(0, 0, 0)
	
	self.Castbar.bd = CreateFrame("Frame", nil, self.Castbar)
	self.Castbar.bd:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT", -2, 2)
	self.Castbar.bd:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT", 2, -2)
	self.Castbar.bd:SetFrameStrata("LOW")
	SetTemplate(self.Castbar.bd)
end	
	
if unit == "player" and ThunderDB[l_uf][l_ufcastlatency] == true then
	self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "ARTWORK")
	self.Castbar.SafeZone:SetPoint('TOPRIGHT')
	self.Castbar.SafeZone:SetPoint('BOTTOMRIGHT')
	self.Castbar.SafeZone:SetTexture(ThunderDB[l_main][l_bar])
	self.Castbar.SafeZone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
end
end

----------------------------------------------
-- Лидер группы
----------------------------------------------	

	self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
	self.Leader:SetHeight(12)
	self.Leader:SetWidth(12)
	self.Leader:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 0, 6)

----------------------------------------------
-- Мастерлутер
----------------------------------------------	

	self.MasterLooter = self.Health:CreateTexture(nil, 'OVERLAY')
	self.MasterLooter:SetHeight(10)
	self.MasterLooter:SetWidth(10)
	self.MasterLooter:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 20, 5)
	
----------------------------------------------
-- ПВП флаг
----------------------------------------------	

if unit == 'player' and ThunderDB[l_uf][l_ufpvp] then
	self.PvP = self.Health:CreateTexture(nil, 'OVERLAY')
	self.PvP:SetSize(24, 24)
	self.PvP:SetPoint('TOPLEFT', self, -5, 5)
end

----------------------------------------------
-- Метки рейда
----------------------------------------------	

	self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetHeight(16)
	self.RaidIcon:SetWidth(16)
	self.RaidIcon:SetPoint("TOP", 0, 7)
	
----------------------------------------------
-- Режим боя
----------------------------------------------	

if unit == 'player' then
	self.Combat = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Combat:SetHeight(14)
	self.Combat:SetWidth(14)
	self.Combat:SetPoint('LEFT', 5, 0)
	self.Combat:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
	self.Combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
	self.Combat:SetVertexColor(1, 0.6, 0.6)
end

----------------------------------------------
-- Пвп тринькет, необходим скин!
----------------------------------------------	
--[[
if IsAddOnLoaded("oUF_Trinkets") and (unit and unit:find('arena%d') and (not unit:find("arena%dtarget")) and (not unit:find("arena%dpet"))) then
	self.Trinket = CreateFrame("Frame", nil, self)
	self.Trinket:SetHeight(30)
	self.Trinket:SetWidth(30)
	self.Trinket:SetPoint("TOPRIGHT", self, "TOPLEFT", -3, 1)
	self.Trinket.trinketUseAnnounce = false
	self.Trinket.trinketUpAnnounce = false
end]]

----------------------------------------------
-- Аур всем и каждому!
----------------------------------------------	

if ThunderDB[l_uf][l_ufauras] then
	if unit == 'player' and ThunderDB[l_uf][l_ufdeb] then
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetHeight(100)
		self.Debuffs:SetWidth(ThunderDB[l_uf][l_ufwA])
		if ThunderDB[l_uf][l_ufautop] then
			self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 2)
			self.Debuffs.initialAnchor = "BOTTOMLEFT"
			self.Debuffs["growth-y"] = "UP"
		else
			if (ThunderDB[l_uf][l_ufclbars] and (myclass == "DEATHKNIGHT" or myclass == "SHAMAN" or myclass == "PALADIN")) then
				self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 1, -12)
			else
				self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 1, -2)
			end
			self.Debuffs.initialAnchor = "TOPLEFT"
			self.Debuffs["growth-y"] = "DOWN"
		end
		self.Debuffs.spacing = 2
		self.Debuffs.size = ThunderDB[l_uf][l_ufausize]
		self.Debuffs.num = ThunderDB[l_uf][l_ufalim]*2
		self.Debuffs.PostCreateIcon = auraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateIcon
	elseif unit == 'target' and ThunderDB[l_uf][l_ufacta] then
		self.Auras = CreateFrame("Frame", nil, self)
		self.Auras:SetHeight(200)
		self.Auras:SetWidth(ThunderDB[l_uf][l_ufwA])
		if ThunderDB[l_uf][l_ufautop] then
			self.Auras:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 2)
			self.Auras['growth-y'] = 'UP'
			self.Auras.initialAnchor = 'BOTTOMLEFT'
		else
			self.Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 1, -2)
			self.Auras['growth-y'] = 'DOWN'
			self.Auras.initialAnchor = 'TOPLEFT'
		end
		self.Auras['growth-x'] = 'RIGHT'
		self.Auras.spacing = 2
		self.Auras.size = ThunderDB[l_uf][l_ufausize]
		self.Auras.gap = true 
		self.Auras.numBuffs = ThunderDB[l_uf][l_ufalim]
		self.Auras.numDebuffs = ThunderDB[l_uf][l_ufalim]*2
		self.Auras.onlyShowPlayer = ThunderDB[l_uf][l_ufospd]
		
		self.Auras.PostCreateIcon = auraIcon
		self.Auras.PostUpdateIcon = PostUpdateIcon
	elseif unit == 'target' and ThunderDB[l_uf][l_ufacta] ~= true then
		self.Buffs = CreateFrame("Frame", nil, self)
		self.Buffs:SetHeight(10)
		self.Buffs:SetWidth(ThunderDB[l_uf][l_ufwA])
		if ThunderDB[l_uf][l_ufautop] then
			self.Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 2)
			self.Buffs.initialAnchor = "BOTTOMLEFT"
			self.Buffs['growth-y'] = 'UP'
		else
			self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 1, -2)
			self.Buffs.initialAnchor = "TOPLEFT"
			self.Buffs['growth-y'] = 'DOWN'
		end
		self.Buffs.spacing = 2
		self.Buffs.size = ThunderDB[l_uf][l_ufausize]
		self.Buffs.num = ThunderDB[l_uf][l_ufalim]
		self.Buffs['growth-x'] = 'RIGHT'
		self.Buffs.PostCreateIcon = auraIcon
		self.Buffs.PostUpdateIcon = PostUpdateIcon
		
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetHeight(100)
		self.Debuffs:SetWidth(ThunderDB[l_uf][l_ufwA])
		if ThunderDB[l_uf][l_ufautop] then
			self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -1, ThunderDB[l_uf][l_ufausize]+4)
			self.Debuffs.initialAnchor = "BOTTOMRIGHT"
			self.Debuffs['growth-y'] = 'UP'
		else
			self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -1, -ThunderDB[l_uf][l_ufausize]-4)
			self.Debuffs.initialAnchor = "TOPRIGHT"
			self.Debuffs['growth-y'] = 'DOWN'
		end
		self.Debuffs.spacing = 2
		self.Debuffs.size = ThunderDB[l_uf][l_ufausize]
		self.Debuffs.num = ThunderDB[l_uf][l_ufalim]*2
		self.Debuffs['growth-x'] = 'LEFT'
		self.Debuffs.onlyShowPlayer = ThunderDB[l_uf][l_ufospd]
		self.Debuffs.PostCreateIcon = auraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateIcon
	elseif unit == 'focus' then
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs.num = 4
		self.Debuffs.size = ThunderDB[l_uf][l_ufausize]
		self.Debuffs.spacing = 2
		self.Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, -2)
		self.Debuffs.initialAnchor = "TOPLEFT"
		self.Debuffs["growth-x"] = "RIGHT"
		self.Debuffs["growth-y"] = "DOWN"
		self.Debuffs:SetHeight(ThunderDB[l_uf][l_ufausize])
		self.Debuffs:SetWidth(200)
		self.Debuffs.PostCreateIcon = auraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateIcon
	elseif unit == "pet" then
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs.num = 4
		self.Debuffs.size = ThunderDB[l_uf][l_ufausize]
		self.Debuffs.spacing = 2
		self.Debuffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -1, -2)
		self.Debuffs.initialAnchor = "TOPRIGHT"
		self.Debuffs["growth-x"] = "LEFT"
		self.Debuffs["growth-y"] = "DOWN"
		self.Debuffs:SetHeight(ThunderDB[l_uf][l_ufausize])
		self.Debuffs:SetWidth(200)
		self.Debuffs.PostCreateIcon = auraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateIcon
	elseif unit == "targettarget" and ThunderDB[l_uf][l_uftotd] then
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetHeight(ThunderDB[l_uf][l_ufausize]-10)
		self.Debuffs:SetWidth(ThunderDB[l_uf][l_ufwC])
		if ThunderDB[l_uf][l_ufautop] then
			self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 2)
			self.Debuffs["growth-y"] = "UP"
			self.Debuffs.initialAnchor = "BOTTOMLEFT"
		else
			self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 1, -2)
			self.Debuffs["growth-y"] = "DOWN"
			self.Debuffs.initialAnchor = "TOPLEFT"
		end
		self.Debuffs.spacing = 2
		self.Debuffs.size = ThunderDB[l_uf][l_ufausize]
		self.Debuffs.num = 6
		self.Debuffs.PostCreateIcon = auraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateIcon
	elseif (unit and unit:find("arena%d")) then
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs.num = 6
		self.Debuffs.size = ThunderDB[l_uf][l_ufausize]
		self.Debuffs.spacing = 2
		self.Debuffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 2, -1)
		self.Debuffs.initialAnchor = "TOPLEFT"
		self.Debuffs["growth-x"] = "RIGHT"
		self.Debuffs["growth-y"] = "DOWN"
		self.Debuffs:SetHeight(ThunderDB[l_uf][l_ufausize])
		self.Debuffs:SetWidth(200)
		self.Debuffs.PostCreateIcon = auraIcon
		self.Debuffs.PostUpdateIcon = PostUpdateIcon
	end
end

----------------------------------------------
-- Задаем размеры
----------------------------------------------	

	if unit == "player" or unit == "target" then
 		self:SetSize(ThunderDB[l_uf][l_ufwA], ThunderDB[l_uf][l_ufHA]+28)
	elseif unit == "focus" or unit == "pet" then
		self:SetSize(ThunderDB[l_uf][l_ufwB], ThunderDB[l_uf][l_ufHA]+13)
	else
		self:SetSize(ThunderDB[l_uf][l_ufwC], ThunderDB[l_uf][l_ufHA]+13)
	end

----------------------------------------------
-- Маштабируем
----------------------------------------------

	self:SetScale(1)
	
----------------------------------------------
-- SpellRange
----------------------------------------------
--[[
if unit == "focus" and IsAddOnLoaded("oUF_SpellRange") then
	self.SpellRange = {
	insideAlpha = 1,
	outsideAlpha = 0.5}
end
]]
----------------------------------------------
-- UnitSpecific
----------------------------------------------

	self.disallowVehicleSwap = true
	
	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle("thunder", sharedstyle)

oUF:Factory(function(self)
	self:SetActiveStyle"thunder"

if ThunderDB[l_ufr][l_ufrhealmode] then
	self:Spawn("player", "oUF_Player"):SetPoint("TOPRIGHT", raidzoneframe, "TOPLEFT", -ThunderDB[l_ufr][l_ufroffset], 0)
	self:Spawn("target", "oUF_Target"):SetPoint("TOPLEFT", raidzoneframe, "TOPRIGHT", ThunderDB[l_ufr][l_ufroffset], 0)
	self:Spawn("targettarget", "oUF_TargetTarget"):SetPoint("TOPLEFT", self.units.target, "BOTTOMLEFT", 0, -ThunderDB[l_ufr][l_ufroffset])
	self:Spawn("focustarget", "oUF_focustarget"):SetPoint("TOPLEFT", self.units.target, "TOPRIGHT", 60, 0)
	self:Spawn("focus", "oUF_Focus"):SetPoint("BOTTOM", self.units.focustarget, "TOP", 0, 20)
	self:Spawn("pet", "oUF_Pet"):SetPoint("TOPRIGHT", self.units.player, "BOTTOMLEFT", -ThunderDB[l_ufr][l_ufroffset], -ThunderDB[l_ufr][l_ufroffset])
else
	if ThunderDB[l_ab][l_abThird] then
		self:Spawn("targettarget", "oUF_TargetTarget"):SetPoint("TOP", UIParent, "BOTTOM", 0, 330)
	else
		self:Spawn("targettarget", "oUF_TargetTarget"):SetPoint("TOP", UIParent, "BOTTOM", 0, 300)
	end
	self:Spawn("player", "oUF_Player"):SetPoint("TOPRIGHT", self.units.targettarget, "TOPLEFT", -10, 0)
	self:Spawn("target", "oUF_Target"):SetPoint("TOPLEFT", self.units.targettarget, "TOPRIGHT", 10, 0)
	self:Spawn("focustarget", "oUF_focustarget"):SetPoint("TOPLEFT", self.units.target, "TOPRIGHT", 60, 0)
	self:Spawn("focus", "oUF_Focus"):SetPoint("BOTTOM", self.units.focustarget, "TOP", 0, 20)
	self:Spawn("pet", "oUF_Pet"):SetPoint("TOPRIGHT", self.units.player, "BOTTOMRIGHT", 0, -10)
end

if ThunderDB[l_uf][l_ufhideparty] then
	--always hide party! :3
	self:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)
end
	
	--[[
	if TheThunderUI.db.bossframes then
		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			local unit = self:Spawn("boss"..i, "oUF_Boss"..i)

			if i==1 then
				unit:SetPoint("BOTTOMRIGHT", UIParent, "TOPRIGHT", -20, -180)
			else
				unit:SetPoint("TOP", boss[i-1], "BOTTOM", 0, -22)
			end
			boss[i] = unit
		end
	end	
	
	if TheThunderUI.db.arenaframes == true then
		if not IsAddOnLoaded("Gladius") then
			local arena = {}
			for i = 1, 5 do
				arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)
				if i == 1 then
					arena[i]:SetPoint("BOTTOM", oUF_Focus, "TOP", 0, 20)
				else
					arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 20)
				end
			end
		end
	end
	
	if TheThunderUI.db.blizzmt == true then
		local tank = self:SpawnHeader('oUF_MainTank', nil, 'raid,party,solo',
			"showRaid", true,
			"yOffset", -5,
			"template", "oUF_tMtt"
		)
		tank:SetPoint("BOTTOM", UIParent, "BOTTOM", 330, 360)
		tank:SetAttribute('groupFilter', 'MAINTANK')
	end]]
end)