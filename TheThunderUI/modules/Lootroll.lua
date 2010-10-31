﻿--[[
	this is an edited version of teksLoot (by MonoLiT)
	
	All credits of this lootroll script is by teksLoot and his author tekKub
--]]

local module = {}
module.name = "Lootroll"
module.Init = function()
	if not ThunderDB.modules[module.name] then return end
	local settings = ThunderDB
	
UIParent:UnregisterEvent("START_LOOT_ROLL");
UIParent:UnregisterEvent("CANCEL_LOOT_ROLL");

if not (GetLocale=="enGB" or GetLocale=="enUS") then
	LOOT_ROLL_GREED = "%s has selected Greed for: %s"
	LOOT_ROLL_NEED = "%s has selected Need for: %s"
	LOOT_ROLL_PASSED = "%s passed on: %s"
	LOOT_ROLL_PASSED_AUTO = "%s automatically passed on: %s because he cannot loot that item."
	LOOT_ROLL_PASSED_AUTO_FEMALE = "%s automatically passed on: %s because she cannot loot that item."
	LOOT_ROLL_DISENCHANT = "%s has selected Disenchant for: %s"
end

local position = {"TOPLEFT", 360, -200} -- roll frames positioning

local GFHCName, GFHCHeight = GameFontHighlightCenter:GetFont();
local grouplootlist, grouplootbars, grouplootrolls = {}, {}, {};
local rollstrings = { 
			[(LOOT_ROLL_PASSED_AUTO):gsub("%%1$s", "(.+)"):gsub("%%2$s", "(.+)")] = "pass", 
			[(LOOT_ROLL_PASSED_AUTO_FEMALE):gsub("%%1$s", "(.+)"):gsub("%%2$s", "(.+)")] = "pass", 
			[(LOOT_ROLL_PASSED):gsub("%%s", "(.+)")] = "pass", 
			[(LOOT_ROLL_GREED):gsub("%%s", "(.+)")] = "greed", 
			[(LOOT_ROLL_DISENCHANT):gsub("%%s", "(.+)")] = "disenchant", 
			[(LOOT_ROLL_NEED):gsub("%%s", "(.+)")] = "need" };

local function OnEvent(self, event, ...)
	if ( event == "CHAT_MSG_LOOT" ) then
		local msg = ...;
		for string, roll in pairs(rollstrings) do
			local _, _, player, item = string.find(msg, string);
			if ( player and item ) then
				local rollId;
				for index, value in ipairs(grouplootbars) do
					if ( value.rollId and item == value.rollLink ) then
						rollId = value.rollId;
						if ( not grouplootrolls[rollId] ) then
							grouplootrolls[rollId] = {};
						end
						if ( not grouplootrolls[rollId][roll] ) then
							grouplootrolls[rollId][roll] = {};
							grouplootrolls[rollId][roll].count = 0;
						end
						if ( not grouplootrolls[rollId][roll][player] ) then
							grouplootrolls[rollId][roll].count = grouplootrolls[rollId][roll].count+1;
							grouplootrolls[rollId][roll][player] = true;
						end
						if ( roll == "need" ) then
							value.needtext:SetText(grouplootrolls[rollId][roll].count);
						elseif ( roll == "greed" ) then
							value.greedtext:SetText(grouplootrolls[rollId][roll].count);
						elseif ( roll == "disenchant" ) then
							value.disenchanttext:SetText(grouplootrolls[rollId][roll].count);
						else
							value.passtext:SetText(grouplootrolls[rollId][roll].count);
						end
						return;
					end
				end
			end
		end
		return;
	end
	local rollId, rollTime = ...;
	table.insert(grouplootlist, { rollId = rollId, rollTime = rollTime });
	self:UpdateGroupLoot();
end

local function BarOnUpdate(self, elapsed)
	if ( self.rollId ) then
		local left = GetLootRollTimeLeft(self.rollId);
		local min, max = self:GetMinMaxValues();
		if ( (left < min) or (left > max) ) then
			left = min;
		end
		self:SetValue(left);
		
		if ( GameTooltip:IsOwned(self) ) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
			GameTooltip:SetLootRollItem(self.rollId);
		end
		CursorOnUpdate(self);
	end
end

local function BarOnEvent(self, event, ...)
	local rollId = ...;
	if ( self.rollId and rollId == self.rollId ) then
		for index, value in ipairs(grouplootlist) do
			if ( self.rollId == value.rollId ) then
				tremove(grouplootlist, index);
				break;
			end
		end
		grouplootrolls[self.rollId] = nil;
		StaticPopup_Hide("CONFIRM_LOOT_ROLL", self.rollId);
		self.rollId = nil;
		sGroupLoot:UpdateGroupLoot();
	end
end

local function BarOnClick(self)
	HandleModifiedItemClick(self.rollLink);
end

local function BarOnEnter(self)
	if not self.rollId then return end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetLootRollItem(self.rollId);
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
	CursorUpdate(self);
end

local function BarOnLeave(self)
	GameTooltip:Hide();
	ResetCursor();
end

local function BarButtonOnClick(self, button)
	RollOnLoot(self:GetParent().rollId, self.type);
end

local function BarButtonOnEnter(self)
	local rolltext;
	if ( self.roll == "need" ) then
		rolltext = NEED;
	elseif ( self.roll == "greed" ) then
		rolltext = GREED;
	elseif ( self.roll == "disenchant" ) then
		rolltext = ROLL_DISENCHANT;
	else
		rolltext = PASS;
	end
	local rollId = self:GetParent().rollId;
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:SetText(rolltext);
	if ( grouplootrolls[rollId] and grouplootrolls[rollId][self.roll] ) then
		for index, value in pairs(grouplootrolls[rollId][self.roll]) do
			if ( index ~= "count" ) then
				GameTooltip:AddLine(index, 1, 1, 1);
			end
		end
	end
	GameTooltip:Show();
end

local function BarButtonOnLeave(self)
	GameTooltip:Hide();
end

local frame = CreateFrame("Frame", "sGroupLoot", UIParent);
frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("START_LOOT_ROLL");
frame:SetScript("OnEvent", OnEvent);

function frame:UpdateGroupLoot()
	for index, value in ipairs(grouplootbars) do
		value:Hide();
	end
	table.sort(grouplootlist, function(a, b)
		return a.rollId < b.rollId;
	end);
	local bar, texture, name, count, quality, bindOnPickUp, color;
	for index, value in ipairs(grouplootlist) do
		bar = grouplootbars[index];
		if ( not bar ) then
			bar = CreateFrame("StatusBar", "sGroupLootBar"..index, UIParent);
			bar:EnableMouse(1);
			bar:SetWidth(250);
			bar:SetHeight(20);
			bar:SetStatusBarTexture(ThunderDB["Main"]["BarText"]);
			if ( index == 1 ) then
				bar:SetPoint(position[1], position[2], position[3]);
			else
				bar:SetPoint("TOP", grouplootbars[index-1], "BOTTOM", 0, -17);
			end
			bar:SetScript("OnUpdate", BarOnUpdate);
			bar:RegisterEvent("CANCEL_LOOT_ROLL");
			bar:SetScript("OnEvent", BarOnEvent);
			bar:SetScript("OnMouseUp", BarOnClick);
			bar:SetScript("OnEnter", BarOnEnter);
			bar:SetScript("OnLeave", BarOnLeave);
			
			bar.background = bar:CreateTexture(nil, "BORDER");
			bar.background:SetAllPoints();
			bar.background:SetTexture(ThunderDB["Main"]["BarText"]);
			bar.background:SetVertexColor(0.5, 0.5, 0.5, 0.7);
			
			bar.pass = CreateFrame("Button", "$perentPassButton", bar);
			bar.pass.type = 0;
			bar.pass.roll = "pass";
			bar.pass:SetWidth(20);
			bar.pass:SetHeight(20);
			bar.pass:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up");
			bar.pass:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Down");
			bar.pass:SetPoint("RIGHT", -5, 1);
			bar.pass:SetScript("OnClick", BarButtonOnClick);
			bar.pass:SetScript("OnEnter", BarButtonOnEnter);
			bar.pass:SetScript("OnLeave", BarButtonOnLeave);
			bar.passtext = bar.pass:CreateFontString("$perentText", "ARTWORK");
			bar.passtext:SetFont(GFHCName, GFHCHeight, "OUTLINE");
			bar.passtext:SetShadowColor(1, 1, 1, 0);
			bar.passtext:SetPoint("CENTER");
			
			bar.greed = CreateFrame("Button", "$perentGreedButton", bar);
			bar.greed.type = 2;
			bar.greed.roll = "greed";
			bar.greed:SetWidth(20);
			bar.greed:SetHeight(20);
			bar.greed:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Up");
			bar.greed:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Down");
			bar.greed:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Coin-Highlight");
			bar.greed:SetPoint("RIGHT", bar.pass, "LEFT", -2, -4);
			bar.greed:SetScript("OnClick", BarButtonOnClick);
			bar.greed:SetScript("OnEnter", BarButtonOnEnter);
			bar.greed:SetScript("OnLeave", BarButtonOnLeave);
			bar.greedtext = bar.greed:CreateFontString("$perentText", "ARTWORK");
			bar.greedtext:SetFont(GFHCName, GFHCHeight, "OUTLINE");
			bar.greedtext:SetShadowColor(1, 1, 1, 0);
			bar.greedtext:SetPoint("CENTER", 0, 3);
			
			bar.disenchant = CreateFrame("Button", "$perentGreedButton", bar);
			bar.disenchant.type = 3;
			bar.disenchant.roll = "disenchant";
			bar.disenchant:SetWidth(20);
			bar.disenchant:SetHeight(20);
			bar.disenchant:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-DE-Up");
			bar.disenchant:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-DE-Down");
			bar.disenchant:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-DE-Highlight");
			bar.disenchant:SetPoint("RIGHT", bar.greed, "LEFT", -2, 2);
			bar.disenchant:SetScript("OnClick", BarButtonOnClick);
			bar.disenchant:SetScript("OnEnter", BarButtonOnEnter);
			bar.disenchant:SetScript("OnLeave", BarButtonOnLeave);
			bar.disenchanttext = bar.disenchant:CreateFontString("$perentText", "ARTWORK");
			bar.disenchanttext:SetFont(GFHCName, GFHCHeight, "OUTLINE");
			bar.disenchanttext:SetShadowColor(1, 1, 1, 0);
			bar.disenchanttext:SetPoint("CENTER", 0, 1);

			bar.need = CreateFrame("Button", "$perentNeedButton", bar);
			bar.need.type = 1;
			bar.need.roll = "need";
			bar.need:SetWidth(20);
			bar.need:SetHeight(20);
			bar.need:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up");
			bar.need:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down");
			bar.need:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Highlight");
			bar.need:SetPoint("RIGHT", bar.disenchant, "LEFT", -2, 0);
			bar.need:SetScript("OnClick", BarButtonOnClick);
			bar.need:SetScript("OnEnter", BarButtonOnEnter);
			bar.need:SetScript("OnLeave", BarButtonOnLeave);
			bar.needtext = bar.need:CreateFontString("$perentText", "ARTWORK");
			bar.needtext:SetFont(GFHCName, GFHCHeight, "OUTLINE");
			bar.needtext:SetShadowColor(1, 1, 1, 0);
			bar.needtext:SetPoint("CENTER", 0, 1);
			
			bar.text = bar:CreateFontString("$perentText", "ARTWORK", "GameFontHighlightLeft");
			bar.text:SetPoint("LEFT", 5, 0);
			bar.text:SetPoint("RIGHT", bar.need, "LEFT");
			
			bar.bg = CreateFrame("Frame", nil, bar)
			bar.bg:SetPoint("TOPLEFT", -2, 2)
			bar.bg:SetPoint("BOTTOMRIGHT", 2, -2)
			bar.bg:SetFrameLevel(bar:GetFrameLevel()-1)
			SetTemplate(bar.bg)
			
			bar.hasItem = 1;
			
            bar.icon = bar:CreateTexture(nil, "BACKGROUND")
            bar.icon:SetHeight(28)
            bar.icon:SetWidth(28)
            bar.icon:ClearAllPoints()
            bar.icon:SetPoint("RIGHT", bar, "LEFT", -7,0)
            bar.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
			bar.ibg = CreateFrame("Frame", nil, bar)
			bar.ibg:SetPoint("TOPLEFT", bar.icon, -2, 2)
			bar.ibg:SetPoint("BOTTOMRIGHT", bar.icon, 2, -2)
			bar.ibg:SetFrameLevel(bar:GetFrameLevel()-1)
			SetTemplate(bar.ibg)
			
			tinsert(grouplootbars, bar);
		end

		texture, name, count, quality, bindOnPickUp, Needable, Greedable, Disenchantable = GetLootRollItemInfo(value.rollId);
		color = ITEM_QUALITY_COLORS[quality];
		if Disenchantable then bar.disenchant:Enable() else bar.disenchant:Disable() end
		if Needable then bar.need:Enable() else bar.need:Disable() end
		if Greedable then bar.greed:Enable() else bar.greed:Disable() end
			SetDesaturation(bar.disenchant:GetNormalTexture(), not Disenchantable)
			SetDesaturation(bar.need:GetNormalTexture(), not Needable)
			SetDesaturation(bar.greed:GetNormalTexture(), not Greedable)

		if ( bindOnPickUp ) then
			bar.ibg:SetBackdropBorderColor(unpack(ThunderDB["Main"]["Border color"]))
		else
			bar.ibg:SetBackdropBorderColor(1, 0.8, 0.8, 1)
		end
			
		bar:SetStatusBarColor(color.r, color.g, color.b, 1);
		bar:SetMinMaxValues(0, value.rollTime);
		
		bar.passtext:SetText(grouplootrolls[value.rollId] and grouplootrolls[value.rollId]["pass"] and grouplootrolls[value.rollId]["pass"].count or "");
		bar.disenchanttext:SetText(grouplootrolls[value.rollId] and grouplootrolls[value.rollId]["disenchant"] and grouplootrolls[value.rollId]["disenchant"].count or "");
		bar.greedtext:SetText(grouplootrolls[value.rollId] and grouplootrolls[value.rollId]["greed"] and grouplootrolls[value.rollId]["greed"].count or "");
		bar.needtext:SetText(grouplootrolls[value.rollId] and grouplootrolls[value.rollId]["need"] and grouplootrolls[value.rollId]["need"].count or "");
		bar.text:SetText(count > 1 and name.." x"..count or name);
        bar.icon:SetTexture(texture) 

		bar.rollId = value.rollId;
		bar.rollLink = GetLootRollItemLink(value.rollId);
		
		bar:Show();
	end
end

------> Suppressing detailed loot spamm
-- FFFFFFFFFUUUCKK GODDAMN LOCALIZATION CRAP
if not (GetLocale=="enGB" or GetLocale=="enUS") then
	LOOT_ROLL_ALL_PASSED = "Everyone passed on: %s";
	LOOT_ROLL_DISENCHANT = "%s has selected Disenchant for: %s";
	LOOT_ROLL_DISENCHANT_SELF = "You have selected Disenchant for: %s";
	LOOT_ROLL_GREED = "%s has selected Greed for: %s";
	LOOT_ROLL_GREED_SELF = "You have selected Greed for: %s";
	LOOT_ROLL_NEED = "%s has selected Need for: %s";
	LOOT_ROLL_NEED_SELF = "You have selected Need for: %s";
	LOOT_ROLL_PASSED = "%s passed on: %s";
	LOOT_ROLL_PASSED_AUTO = "%s automatically passed on: %s because he cannot loot that item.";
	LOOT_ROLL_PASSED_AUTO_FEMALE = "%s automatically passed on: %s because she cannot loot that item.";
	LOOT_ROLL_PASSED_SELF = "You passed on: %s";
	LOOT_ROLL_PASSED_SELF_AUTO = "You automatically passed on: %s because you cannot loot that item.";
	LOOT_ROLL_ROLLED_DE = "Disenchant Roll - %d for %s by %s";
	LOOT_ROLL_ROLLED_GREED = "Greed Roll - %d for %s by %s";
	LOOT_ROLL_ROLLED_NEED = "Need Roll - %d for %s by %s";
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", function(self, event, msg)
	if msg:match("(.*) has?v?e? selected (.+) for: (.+)") or msg:match("(.+) Roll . (%d+) for (.+) by (.+)")
		or msg:match("You passed on: ") or msg:match(" automatically passed on: ") or (msg:match(" passed on: ") and not msg:match("Everyone passed on: ")) then
		return true
	end
end)

end
tinsert(ThunderUI.modules, module) -- finish him!