--[[
	"cute" oUF_Freebgrid by Freebaster
--]]

if ThunderDB["modules"][l_uf] ~= true or ThunderDB["modules"][l_ufr] ~= true then return end

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

if ThunderDB[l_ufr][l_ufrkblizz] then
	CompactRaidFrameManager:SetScale(0.001)
	CompactRaidFrameManager:SetAlpha(0)
	CompactRaidFrameContainer:SetScale(0.001)
	CompactRaidFrameContainer:SetAlpha(0)
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer:Hide()
end

-- SetPoint of MOTHERFUCKING DOOM!
local function SAP()
	local pos, posRel, spacingX, spacingY, colX, colY, growth, point
	
	if ThunderDB[l_ufr][l_ufrpoint] == "TOP" and ThunderDB[l_ufr][l_ufrgrowth] == "LEFT" then
		pos = "TOPRIGHT"
		posRel = "TOPLEFT"
		growth = "RIGHT"
		spacingX = 0
		spacingY = -(ThunderDB[l_ufr][l_ufroffset])
		colX = -(ThunderDB[l_ufr][l_ufroffset])
		colY = 0
		point = "TOPRIGHT"
	elseif ThunderDB[l_ufr][l_ufrpoint] == "TOP" and ThunderDB[l_ufr][l_ufrgrowth] == "RIGHT" then
		pos = "TOPLEFT"
		posRel = "TOPRIGHT"
		growth = "LEFT"
		spacingX = 0
		spacingY = -(ThunderDB[l_ufr][l_ufroffset])
		colX = ThunderDB[l_ufr][l_ufroffset]
		colY = 0
		point = "TOPLEFT"
	elseif ThunderDB[l_ufr][l_ufrpoint] == "LEFT" and ThunderDB[l_ufr][l_ufrgrowth] == "TOP" then
		pos = "BOTTOMLEFT"
		posRel = "TOPLEFT"
		growth = "BOTTOM"
		spacingX = ThunderDB[l_ufr][l_ufroffset]
		spacingY = 0
		colX = 0
		colY = ThunderDB[l_ufr][l_ufroffset]
		point = "BOTTOMLEFT"
	elseif ThunderDB[l_ufr][l_ufrpoint] == "LEFT" and ThunderDB[l_ufr][l_ufrgrowth] == "BOTTOM" then
		pos = "TOPLEFT"
		posRel = "BOTTOMLEFT"
		growth = "TOP"
		spacingX = ThunderDB[l_ufr][l_ufroffset]
		spacingY = 0
		colX = 0
		colY = -(ThunderDB[l_ufr][l_ufroffset])
		point = "TOPLEFT"
	elseif ThunderDB[l_ufr][l_ufrpoint] == "RIGHT" and ThunderDB[l_ufr][l_ufrgrowth] == "TOP" then
		pos = "BOTTOMRIGHT"
		posRel = "TOPRIGHT"
		growth = "BOTTOM"
		spacingX = -(ThunderDB[l_ufr][l_ufroffset])
		spacingY = 0
		colX = 0
		colY = ThunderDB[l_ufr][l_ufroffset]
		point = "BOTTOMRIGHT"
	elseif ThunderDB[l_ufr][l_ufrpoint] == "RIGHT" and ThunderDB[l_ufr][l_ufrgrowth] == "BOTTOM" then
		pos = "TOPRIGHT"
		posRel = "BOTTOMRIGHT"
		growth = "TOP"
		spacingX = -(ThunderDB[l_ufr][l_ufroffset])
		spacingY = 0
		colX = 0
		colY = -(ThunderDB[l_ufr][l_ufroffset])
		point = "TOPRIGHT"
	elseif ThunderDB[l_ufr][l_ufrpoint] == "BOTTOM" and ThunderDB[l_ufr][l_ufrgrowth] == "LEFT" then
		pos = "BOTTOMRIGHT"
		posRel = "BOTTOMLEFT"
		growth = "RIGHT"
		spacingX = 0
		spacingY = (ThunderDB[l_ufr][l_ufroffset])
		colX = -(ThunderDB[l_ufr][l_ufroffset])
		colY = 0
		point = "BOTTOMRIGHT"
	elseif ThunderDB[l_ufr][l_ufrpoint] == "BOTTOM" and ThunderDB[l_ufr][l_ufrgrowth] == "RIGHT" then
		pos = "BOTTOMLEFT"
		posRel = "BOTTOMRIGHT"
		growth = "LEFT"
		spacingX = 0
		spacingY = (ThunderDB[l_ufr][l_ufroffset])
		colX = (ThunderDB[l_ufr][l_ufroffset])
		colY = 0
		point = "BOTTOMLEFT"
	else -- You failed to equal any of the above. So I give this...
		pos = "TOPLEFT"
		posRel = "TOPRIGHT"
		growth = "LEFT"
		spacingX = 0
		spacingY = -(ThunderDB[l_ufr][l_ufroffset])
		colX = ThunderDB[l_ufr][l_ufroffset]
		colY = 0
		point = "TOPLEFT"
	end
	
	return pos, posRel, spacingX, spacingY, colX, colY, growth, point
end

local fixStatusbar = function(bar)
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
end

local menu = function(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("^%l", string.upper)

    if(cunit == 'Vehicle') then
        cunit = 'Pet'
    end

    if(unit == "party" or unit == "partypet") then
        ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
        ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    else
        ToggleDropDownMenu(1, nil, TargetFrameDropDown, "cursor")
    end
end

local backdrop = {
	bgFile = ThunderDB[l_main][l_blank],
	edgeFile = ThunderDB[l_main][l_blank], 
	tile = false, tileSize = 0, edgeSize = 1, 
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local frameBD = {
	edgeFile = ThunderDB[l_main][l_shadow], edgeSize = 5,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

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

local function utf8sub(str, start, numChars) 
    local currentIndex = start 
    while numChars > 0 and currentIndex <= #str do 
        local char = string.byte(str, currentIndex) 
        if char >= 240 then 
            currentIndex = currentIndex + 4 
        elseif char >= 225 then 
            currentIndex = currentIndex + 3 
        elseif char >= 192 then 
            currentIndex = currentIndex + 2 
        else 
            currentIndex = currentIndex + 1 
        end 
        numChars = numChars - 1 
    end 
    return str:sub(start, currentIndex - 1) 
end
local nameCache = {}

local PostUpdateHealth = function(health, unit, min, max)
    local name = oUF.Tags['thunder:name'](unit)
    local self = health.__owner
    local val = 1
    if ThunderDB[l_ufr][l_ufrpower] then
        val = 8
    end

	if nameCache[name] then 
		self.Info:SetText(nameCache[name]) 
	else 
		local substring 
		for length=#name, 1, -1 do 
			substring = utf8sub(name, 1, length) 
			self.Info:SetText(substring) 
			if self.Info:GetStringWidth() <= ThunderDB[l_ufr][l_ufrwidth] - val then break end 
		end
		nameCache[name] = substring
	end

	local r, g, b, t
	if(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = oUF.colors.class[class]
	else		
		r, g, b = .2, .9, .1
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	if ThunderDB[l_uf][l_ufcc] and not ThunderDB[l_uf][l_uficc] then
		self.Info:SetTextColor(1, 1, 1)
	else
		self.Info:SetTextColor(r, g, b)
	end

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
			local r, g, b, t
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

		if ThunderDB[l_ufr][l_ufrhealdif] and min ~= max then
			health.value:SetFormattedText("-"..siValue(max-min))
		else
			health.value:SetText("")
		end
	end
end

local PostUpdatePower = function(power, unit, min, max)
	local _, ptype = UnitPowerType(unit)
	local self = power:GetParent()

	if ptype == 'MANA' then
		if(ThunderDB[l_ufr][l_ufrorient] == "VERTICAL")then
			power:SetPoint("TOP", 0, -3)
			power:SetWidth(ThunderDB[l_ufr][l_ufrwidth]*ThunderDB[l_ufr][l_ufrpowersize])
			self.Health:SetWidth((1 - ThunderDB[l_ufr][l_ufrpowersize])*ThunderDB[l_ufr][l_ufrwidth]-6)
		else
			power:SetPoint("LEFT", 3, 0)
			power:SetHeight(ThunderDB[l_ufr][l_ufrheight]*ThunderDB[l_ufr][l_ufrpowersize])
			self.Health:SetHeight((1 - ThunderDB[l_ufr][l_ufrpowersize])*ThunderDB[l_ufr][l_ufrheight]-6)
		end
	else
		if(ThunderDB[l_ufr][l_ufrorient] == "VERTICAL")then
			power:SetPoint("TOP", 0, -3)
			power:SetWidth(0.0000001) -- in this case absolute zero is something, rather than nothing
			self.Health:SetWidth(ThunderDB[l_ufr][l_ufrwidth]-6)
		else
			power:SetPoint("LEFT", 3, 0)
			power:SetHeight(0.0000001) -- ^ ditto
			self.Health:SetHeight(ThunderDB[l_ufr][l_ufrheight]-6)
		end
	end
	
	if ThunderDB[l_uf][l_ufcc] then
		local r, g, b = 1, 1, 1
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
		local r, g, b, t
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

local updateThreat = function(self, event, unit)
	if(unit ~= self.unit) then return end
	local threat = self.Threat

	unit = unit or self.unit
	local status = UnitThreatSituation(unit)

	if(status and status > 1) then
		local r, g, b = GetThreatStatusColor(status)
		threat:SetBackdropBorderColor(r, g, b, 1)
	else
		threat:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
		threat:SetAlpha(1)
	end
	threat:Show()
end

local _, class = UnitClass("player")
local dispellClass = {
    PRIEST = {
		Magic = true,
		Disease = true,
	},
    SHAMAN = {
		Curse = true,
	},
    PALADIN = {
		Poison = true,
		Disease = true,
	},
    MAGE = {
		Curse = true,
	},
    DRUID = {
		Curse = true,
		Poison = true,
	},
}
 -- talentchecker, thx for original idea Heckffy
local TalentChecker = CreateFrame("Frame");
TalentChecker:RegisterEvent("PLAYER_ENTERING_WORLD");
TalentChecker:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
TalentChecker:RegisterEvent("CHARACTER_POINTS_CHANGED");
TalentChecker:SetScript("OnEvent", function()
	dispellClass.SHAMAN.Magic = (select(5, GetTalentInfo(3, 12, false, false, nil)) == 1);
	dispellClass.PALADIN.Magic = (select(5, GetTalentInfo(1, 14, false, false, nil)) == 1);
	dispellClass.DRUID.Magic = (select(5, GetTalentInfo(3, 17, false, false, nil)) == 1);
end);

local dispellist = dispellClass[class] or {}
local dispellPriority = {
    Magic = 4,
    Poison = 3,
    Curse = 2,
    Disease = 1,
}

local instDebuffs = {}
local instances = ns.auras.instances
local getzone = function()
    local zone = GetInstanceInfo()
    if instances[zone] then
        instDebuffs = instances[zone]
    else
        instDebuffs = {}
    end
end

local debuffs, buffs = ns.auras.debuffs, ns.auras.buffs 
local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, dtype = ...

    if instDebuffs[name] then
        icon.priority = instDebuffs[name]
        return true
    elseif debuffs[name] then
        icon.priority = debuffs[name]
        return true
    elseif buffs[name] then
        icon.priority = buffs[name]
        icon.buff = true
        return true
    elseif dispellist[dtype] then
        icon.priority = dispellPriority[dtype]
        icon.buff = false
        return true
    else
        icon.priority = 0
    end
end

-- Show Mouseover highlight
local OnEnter = function(self)
    UnitFrame_OnEnter(self)
	self.Highlight:Show()	
end

local OnLeave = function(self)
    UnitFrame_OnLeave(self)
	self.Highlight:Hide()	
end

local sharedstyle = function(self)
    self.menu = menu

	self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetAttribute("*type2", "menu")

----------------------------------------------
-- Фон
----------------------------------------------

	threat = CreateFrame("Frame", nil, self)
	threat:SetPoint("TOPLEFT", 1, -1)
	threat:SetPoint("BOTTOMRIGHT", -1, 1)
	threat:SetBackdrop(backdrop)
	threat:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
	threat:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
	threat:SetAlpha(1)
	threat.Override = updateThreat
	self.Threat = threat
	
----------------------------------------------
-- Тень
----------------------------------------------
	
	self.FrameBackdrop = CreateFrame("Frame", nil, self)
	self.FrameBackdrop:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
	self.FrameBackdrop:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 4, -4)
	self.FrameBackdrop:SetFrameStrata("LOW")
	self.FrameBackdrop:SetBackdrop(frameBD)
	self.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
	self.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)

----------------------------------------------
-- Хп бар
----------------------------------------------

	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetOrientation(ThunderDB[l_ufr][l_ufrorient])
	self.Health:SetPoint("TOP", 0, -3)
	self.Health:SetPoint("LEFT", 3, 0)
	if ThunderDB[l_ufr][l_ufrorient] == "VERTICAL" then
		self.Health:SetPoint("BOTTOM", 0, 3)
	else
		self.Health:SetPoint("RIGHT", -3, 0)
	end
	self.Health:SetStatusBarTexture(ThunderDB[l_main][l_bar])
	fixStatusbar(self.Health)
	self.Health.frequentUpdates = true
	self.Health.Smooth = true

	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints()
	self.Health.bg:SetTexture(ThunderDB[l_main][l_bar])

	self.Health.PostUpdate = PostUpdateHealth

	self.Health.value = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.value:SetFont(ThunderDB[l_ufr][l_ufrfont], ThunderDB[l_ufr][l_ufrufsize]-1)
	self.Health.value:SetJustifyH("RIGHT")
	self.Health.value:SetShadowColor(0, 0, 0)
	self.Health.value:SetShadowOffset(1, -1)
	self.Health.value:SetTextColor(0.1, 0.3, 0.3)
	self.Health.value:SetPoint("BOTTOMRIGHT", -1, 1)

----------------------------------------------
-- Манабары?
----------------------------------------------

if ThunderDB[l_ufr][l_ufrpower] then
	self.Power = CreateFrame("StatusBar", nil, self)
    self.Power:SetOrientation(ThunderDB[l_ufr][l_ufrorient])
	self.Power:SetPoint("BOTTOM", self, 0, 3)
    self.Power:SetPoint("RIGHT", self, -3, 0)
	self.Power:SetStatusBarTexture(ThunderDB[l_main][l_bar])
    fixStatusbar(self.Power)
    
    self.Power.frequentUpdates = true
	self.Power.Smooth = true

    self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
    self.Power.bg:SetAllPoints(self.Power)
    self.Power.bg:SetTexture(ThunderDB[l_main][l_bar])

    self.Power.PostUpdate = PostUpdatePower
end

----------------------------------------------
-- Подсветка
----------------------------------------------

    self.Highlight = self.Health:CreateTexture(nil, "OVERLAY")
    self.Highlight:SetAllPoints(self)
    self.Highlight:SetTexture(ThunderDB[l_main][l_blank])
    self.Highlight:SetVertexColor(1,1,1,.1)
    self.Highlight:SetBlendMode("ADD")
    self.Highlight:Hide()

----------------------------------------------
-- Raid Icons
----------------------------------------------

    self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon:SetPoint("TOP", self, 0, 4)
    self.RaidIcon:SetSize(ThunderDB[l_ufr][l_ufrisize], ThunderDB[l_ufr][l_ufrisize])

----------------------------------------------
-- Leader Icon
----------------------------------------------

    self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
    self.Leader:SetPoint("TOPLEFT", self, 0, 8)
    self.Leader:SetSize(ThunderDB[l_ufr][l_ufrisize], ThunderDB[l_ufr][l_ufrisize])

----------------------------------------------
-- Assistant Icon
----------------------------------------------

    self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
    self.Assistant:SetPoint("TOPLEFT", self, 0, 8)
    self.Assistant:SetSize(ThunderDB[l_ufr][l_ufrisize], ThunderDB[l_ufr][l_ufrisize])

----------------------------------------------
-- Raid Icons
----------------------------------------------    

	self.MasterLooter = self.Health:CreateTexture(nil, 'OVERLAY')
    self.MasterLooter:SetSize(ThunderDB[l_ufr][l_ufrisize], ThunderDB[l_ufr][l_ufrisize])
    self.MasterLooter:SetPoint('LEFT', self.Leader, 'RIGHT')
	
----------------------------------------------
-- LFD Role
----------------------------------------------

if ThunderDB[l_ufr][l_ufrlfdrole] then
	self.LFDRole = self.Health:CreateTexture(nil, 'OVERLAY')
	self.LFDRole:SetSize(ThunderDB[l_ufr][l_ufrisize], ThunderDB[l_ufr][l_ufrisize])
	self.LFDRole:SetPoint('RIGHT', self, 'LEFT', ThunderDB[l_ufr][l_ufrisize]/2, ThunderDB[l_ufr][l_ufrisize]/2)
end

----------------------------------------------
-- Ready Check
----------------------------------------------

	self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
    self.ReadyCheck:SetPoint("TOP", self)
    self.ReadyCheck:SetSize(ThunderDB[l_ufr][l_ufrisize], ThunderDB[l_ufr][l_ufrisize])	
	
----------------------------------------------
-- Имя
----------------------------------------------
	
    self.Info = self.Health:CreateFontString(nil, "OVERLAY")
    self.Info:SetPoint("TOP", 0, -7)
    self.Info:SetJustifyH("CENTER")
    self.Info:SetFont(ThunderDB[l_ufr][l_ufrfont], ThunderDB[l_ufr][l_ufrufsize])
    self.Info:SetShadowOffset(1.25, -1.25)

----------------------------------------------
-- Enable Indicators
----------------------------------------------
 
    self.freebIndicators = true	
	
----------------------------------------------
-- Дальность
----------------------------------------------

	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.5
	}

----------------------------------------------
-- AURAS!
----------------------------------------------

    local auras = CreateFrame("Frame", nil, self)
    auras:SetSize(ThunderDB[l_ufr][l_ufrdsize], ThunderDB[l_ufr][l_ufrdsize])
    auras:SetPoint("BOTTOMLEFT", self.Health, 1, 1)
    auras.size = ThunderDB[l_ufr][l_ufrdsize]
    auras.CustomFilter = CustomFilter
    self.freebAuras = auras

	self:RegisterEvent('PLAYER_ENTERING_WORLD', getzone)
end

oUF:RegisterStyle("Freebgrid", sharedstyle)

oUF:Factory(function(self)
    self:SetActiveStyle"Freebgrid"

	local pos, posRel, spacingX, spacingY, colX, colY, growth, point = SAP()

	raid = {}
	for i = 1, ThunderDB[l_ufr][l_ufrpartyn] do 
		local group = self:SpawnHeader('Raid_Freebgrid'..i, nil, 'raid,party,solo',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(ThunderDB[l_ufr][l_ufrwidth], ThunderDB[l_ufr][l_ufrheight]),
		'showPlayer', true,
		'showSolo', false,
		'showParty', true,
		'showRaid', true,
		'xoffset', spacingX, 
		'yOffset', spacingY,
		'point', ThunderDB[l_ufr][l_ufrpoint],
		'groupFilter', tostring(i),
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', ThunderDB[l_ufr][l_ufrpartyn],
		'unitsPerColumn', 5,
		'columnSpacing', ThunderDB[l_ufr][l_ufroffset],
		'columnAnchorPoint', growth
		)
		if i == 1 then
			group:SetPoint(point, raidzoneframe, point)
		else
			group:SetPoint(pos, raid[i-1], posRel, colX, colY)
		end
		group:SetScale(1)
		raid[i] = group
	end
		
	if ThunderDB[l_ufr][l_ufrPets] then
        local pets = self:SpawnHeader('Pet_Freebgrid', 'SecureGroupPetHeaderTemplate', 'raid,party,solo',
        'oUF-initialConfigFunction', ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
            ]]):format(ThunderDB[l_ufr][l_ufrwidth], ThunderDB[l_ufr][l_ufrheight]),
        'showSolo', false,
        'showParty', true,
        'showRaid', true,
        'xoffset', spacingX,
        'yOffset', spacingY,
        'point', ThunderDB[l_ufr][l_ufrpoint],
        'maxColumns', ThunderDB[l_ufr][l_ufrpartyn],
        'unitsPerColumn', 5,
        'columnSpacing', ThunderDB[l_ufr][l_ufroffset],
        'columnAnchorPoint', growth
        )
        pets:SetPoint(point, raidpetsframe, point, 0, 0)
        pets:SetScale(1)
    end

    if ThunderDB[l_ufr][l_ufrMT] then
        local tank = self:SpawnHeader('MT_Freebgrid', nil, 'raid,party,solo',
        'oUF-initialConfigFunction', ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
            ]]):format(ThunderDB[l_ufr][l_ufrwidth], ThunderDB[l_ufr][l_ufrheight]),
        "showRaid", true,
        "yOffset", -ThunderDB[l_ufr][l_ufroffset]
        )
        tank:SetPoint(point, raidmtframe, point, 0, 0)

        if oRA3 then
            tank:SetAttribute("initial-unitWatch", true)
            tank:SetAttribute("nameList", table.concat(oRA3:GetSortedTanks(), ","))

            local tankhandler = {}
            function tankhandler:OnTanksUpdated(event, tanks) 
                tank:SetAttribute("nameList", table.concat(tanks, ","))
            end
            oRA3.RegisterCallback(tankhandler, "OnTanksUpdated")

        else
            tank:SetAttribute('groupFilter', 'MAINTANK')
        end
        tank:SetScale(1)
    end
end)
