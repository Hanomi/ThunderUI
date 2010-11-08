----------------------------------------------------------------------------------------
-- alTooltip
-- Allez - 2010
----------------------------------------------------------------------------------------

local module = {}
module.name = l_tooltips
module.Init = function()
	if not ThunderDB.modules[module.name] then return end
	local settings = ThunderDB
	
	
local relpoint = "BOTTOMRIGHT"
local point = "BOTTOMRIGHT"
local xpoint = -18
local ypoint = (30 + ThunderDB[l_lpanels][l_lpheight])

local backdrop = {
	bgFile = ThunderDB[l_main][l_blank],
	edgeFile = ThunderDB[l_main][l_blank],
	tile = false, tileSize = 0, edgeSize = 1,
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local tooltips = {
	GameTooltip, 
	ItemRefTooltip, 
	ShoppingTooltip1, 
	ShoppingTooltip2, 
	ShoppingTooltip3, 
	WorldMapTooltip, 
	DropDownList1MenuBackdrop, 
	DropDownList2MenuBackdrop, 
}

local types = {
	rare = " R ",
	elite = " + ",
	worldboss = " B ",
	rareelite = " R+ ",
}

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	local frame = GetMouseFocus()
	if ThunderDB[l_tooltips][l_tcursor] and frame == WorldFrame then
		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	else
		tooltip:SetOwner(parent, "ANCHOR_NONE")	
		tooltip:SetPoint(point, UIParent, relpoint, xpoint, ypoint)
	end
	tooltip.default = 1
end)

GameTooltip:HookScript("OnUpdate",function(self, ...)
	if self:GetAnchorType() == "ANCHOR_CURSOR" then
		-- h4x for world object tooltip border showing last border color 
		-- or showing background sometime ~blue :x by Tukz
		self:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
		self:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
	elseif self:GetAnchorType() == "ANCHOR_NONE" then
		if InCombatLockdown() and ThunderDB[l_tooltips][l_thidecombat] then
			self:SetAlpha(0)
		else
			self:SetAlpha(1)
		end
	end
end)

for _, v in pairs(tooltips) do
	v:SetBackdrop(backdrop)
	v:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
	v:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
	v:SetScript("OnShow", function(self)
		self:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
		local item
		if self.GetItem then
			item = select(2, self:GetItem())
		end
		if item then
			local quality = select(3, GetItemInfo(item))
			if quality and quality > 1 then
				local r, g, b = GetItemQualityColor(quality)
				self:SetBackdropBorderColor(r, g, b, 0.7)
			end
		else
			self:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
		end
	end)
	v:HookScript("OnHide", function(self)
		self:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
	end)
end

local hex = function(r, g, b)
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

local truncate = function(value)
	if value >= 1e6 then
		return string.format('%.2fm', value / 1e6)
	elseif value >= 1e4 then
		return string.format('%.1fk', value / 1e3)
	else
		return string.format('%.0f', value)
	end
end

function GameTooltip_UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			if UnitCanAttack("player", unit) then
				r = FACTION_BAR_COLORS[2].r
				g = FACTION_BAR_COLORS[2].g
				b = FACTION_BAR_COLORS[2].b
			end
		elseif UnitCanAttack("player", unit) then
			r = FACTION_BAR_COLORS[4].r
			g = FACTION_BAR_COLORS[4].g
			b = FACTION_BAR_COLORS[4].b
		elseif UnitIsPVP(unit) then
			r = FACTION_BAR_COLORS[6].r
			g = FACTION_BAR_COLORS[6].g
			b = FACTION_BAR_COLORS[6].b
		end
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			r = FACTION_BAR_COLORS[reaction].r
			g = FACTION_BAR_COLORS[reaction].g
			b = FACTION_BAR_COLORS[reaction].b
		end
	end
	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		if class then
			r = RAID_CLASS_COLORS[class].r
			g = RAID_CLASS_COLORS[class].g
			b = RAID_CLASS_COLORS[class].b
		end
	end
	return r, g, b
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local unit = select(2, self:GetUnit())
	
	if self:GetOwner() ~= UIParent and ThunderDB[l_tooltips][l_thideuf] then self:Hide() return end
	
	if unit then
		local unitClassification = types[UnitClassification(unit)] or " "
		local diffColor = GetQuestDifficultyColor(UnitLevel(unit))
		local creatureType = UnitCreatureType(unit) or ""
		local unitName = UnitName(unit)
		local unitLevel = UnitLevel(unit)
		if unitLevel < 0 then unitLevel = '??' end
		if UnitIsPlayer(unit) then
			local unitRace = UnitRace(unit)
			local unitClass = UnitClass(unit)
			local guild, rank = GetGuildInfo(unit)
			if guild then
				GameTooltipTextLeft2:SetFormattedText(hex(0, 1, 1).."%s|r %s", guild, rank)
			end
			for i=2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft" .. i]:GetText():find(PLAYER) then
					_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r ", unitLevel) .. unitRace)
					break
				end
			end
		else
			for i=2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft" .. i]:GetText():find(LEVEL) or _G["GameTooltipTextLeft" .. i]:GetText():find(creatureType) then
					_G["GameTooltipTextLeft" .. i]:SetText(string.format(hex(diffColor.r, diffColor.g, diffColor.b).."%s|r", unitLevel) .. unitClassification .. creatureType)
					break
				end
			end
		end
		if UnitIsPVP(unit) then
			for i = 2, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText():find(PVP) then
					_G["GameTooltipTextLeft"..i]:SetText(nil)
					break
				end
			end
		end
		if UnitExists(unit.."target") then
			local r, g, b = GameTooltip_UnitColor(unit.."target")
			if UnitName(unit.."target") == UnitName("player") then
				text = hex(1, 0, 0).."<You>|r"
			else
				text = hex(r, g, b)..UnitName(unit.."target").."|r"
			end
			self:AddLine(TARGET..": "..text)
		end
	end
end)

GameTooltipStatusBar:SetStatusBarTexture(ThunderDB[l_main][l_bar])
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 2, 5)
GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -2, 5)
GameTooltipStatusBar:HookScript("OnValueChanged", function(self, value)
	if not value then
		return
	end
	local min, max = self:GetMinMaxValues()
	if value < min or value > max then
		return
	end
	local unit  = select(2, GameTooltip:GetUnit())
	if unit then
		min, max = UnitHealth(unit), UnitHealthMax(unit)
		if not self.text then
			self.text = self:CreateFontString(nil, "OVERLAY")
			self.text:SetPoint("CENTER", GameTooltipStatusBar)
			self.text:SetFont(GameFontNormal:GetFont(), 11, "THINOUTLINE")
		end
		self.text:Show()
		local hp = truncate(min).." / "..truncate(max)
		self.text:SetText(hp)
	else
		self.text:Hide()
	end
end)

GameTooltipStatusBar.bg = CreateFrame("Frame", nil, GameTooltipStatusBar)
GameTooltipStatusBar.bg:SetPoint("TOPLEFT", GameTooltipStatusBar, "TOPLEFT", -2, 2)
GameTooltipStatusBar.bg:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar, "BOTTOMRIGHT", 2, -2)
GameTooltipStatusBar.bg:SetFrameStrata("TOOLTIP")
GameTooltipStatusBar.bg:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel()-1)
GameTooltipStatusBar.bg:SetBackdrop(backdrop)
GameTooltipStatusBar.bg:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
GameTooltipStatusBar.bg:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))

local iconFrame = CreateFrame("Frame", nil, ItemRefTooltip)
iconFrame:SetWidth(30)
iconFrame:SetHeight(30)
iconFrame:SetPoint("TOPRIGHT", ItemRefTooltip, "TOPLEFT", -3, 0)
iconFrame:SetBackdrop(backdrop)
iconFrame:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
iconFrame:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
iconFrame.icon = iconFrame:CreateTexture(nil, "OVERLAY")
iconFrame.icon:SetPoint("TOPLEFT", 2, -2)
iconFrame.icon:SetPoint("BOTTOMRIGHT", -2, 2)
iconFrame.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

hooksecurefunc("SetItemRef", function(link, text, button)
	if iconFrame:IsShown() then
		iconFrame:Hide()
	end
	local type, id = string.match(link, "(%l+):(%d+)") 
	if type == "item" then
		iconFrame.icon:SetTexture(select(10, GetItemInfo(id)))
		iconFrame:Show()
	elseif type == "spell" then
		iconFrame.icon:SetTexture(select(3, GetSpellInfo(id)))
		iconFrame:Show()
	elseif type == "achievement" then
		iconFrame.icon:SetTexture(select(10, GetAchievementInfo(id)))
		iconFrame:Show()
	end
end)

if ThunderDB[l_tooltips][l_thideab] then
	local HideActionButtonsTooltip = function(self)
		if not IsShiftKeyDown() then
			self:Hide()
		end
	end
		 
hooksecurefunc(GameTooltip, "SetAction", HideActionButtonsTooltip)
hooksecurefunc(GameTooltip, "SetPetAction", HideActionButtonsTooltip)
hooksecurefunc(GameTooltip, "SetShapeshift", HideActionButtonsTooltip)
end

if ThunderDB[l_tooltips][l_ttitles] then return end
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local unitName, unit = self:GetUnit()
	if unit and UnitIsPlayer(unit) then
		local title = UnitPVPName(unit)
		if title then
			title = title:gsub(unitName, "")
			name = GameTooltipTextLeft1:GetText()
			name = name:gsub(title, "")
			if name then GameTooltipTextLeft1:SetText(name) end
		end
	end
end)

end
tinsert(ThunderUI.modules, module) -- finish him!