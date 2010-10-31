----------------------------------------------------------------------------------------
-- aSettings 
-- by ALZA - 2010
----------------------------------------------------------------------------------------

local module = {}
module.name = "Tweaker"
module.Init = function()

----------------------------------------------------------------------------------------
-- Clear UIErrors frame(ncError by Nightcracker)
----------------------------------------------------------------------------------------
if ThunderDB["Tweaker"]["HideErrors"] then
	local f, o, ncErrorDB = CreateFrame("Frame"), L_ERRORS, {
	["Inventory is full."] = true,
	["Your quest log is full"] = true,
	["Нет места."] = true,
	["У вас слишком много таких предметов."] = true,
	["У вас недостаточно денег."] = true,
	["Предмет не найден."] = true,
	}
	f:SetScript("OnEvent", function(self, event, error)
		if ncErrorDB[error] then
			UIErrorsFrame:AddMessage(error, 1, 0, 0)
		else
			o = error
		end
	end)
	SLASH_NCERROR1 = "/error"
	function SlashCmdList.NCERROR() print(o) end
	UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	f:RegisterEvent("UI_ERROR_MESSAGE")
end

----------------------------------------------------------------------------------------
-- Auto decline duels
----------------------------------------------------------------------------------------
if ThunderDB["Tweaker"]["DeclineDuels"] then
	local dd = CreateFrame("Frame")
	dd:RegisterEvent("DUEL_REQUESTED")
	dd:SetScript("OnEvent", function(self, event, name)
		HideUIPanel(StaticPopup1)
		CancelDuel()
		aInfoText_ShowText(L_DUEL..name)
		print(format("|cff00ffff"..L_DUEL..name))
	end)
end

----------------------------------------------------------------------------------------
-- Auto Accept Invites
----------------------------------------------------------------------------------------
if ThunderDB["Tweaker"]["AcceptPartyInvite"] then
	local IsFriend = function(name)
		for i = 1, GetNumFriends() do if(GetFriendInfo(i) == name) then return true end end
		if(IsInGuild()) then for i = 1, GetNumGuildMembers() do if(GetGuildRosterInfo(i) == name) then return true end end end
	end

	local ai = CreateFrame("Frame")
	ai:RegisterEvent("PARTY_INVITE_REQUEST")
	ai:SetScript("OnEvent", function(frame, event, name)
		if(IsFriend(name)) then
			aInfoText_ShowText(L_INVITE..name)
			print(format("|cffffff00"..L_INVITE..name.."."))
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if(frame:IsVisible() and frame.which == "PARTY_INVITE") then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE")
					return
				end
			end
		else
			SendWho(name)
		end
	end)
end

----------------------------------------------------------------------------------------
--	Grab mail in 1 button(OpenAll by Kemayo)
----------------------------------------------------------------------------------------
if ThunderDB["Tweaker"]["GrabMail"] then

if (IsAddOnLoaded("QuickAuctions") or IsAddOnLoaded("OpenAll")) then return end

local deletedelay, t = 0.5, 0
local takingOnlyCash = false
local button, button2, waitForMail, doNothing, openAll, openAllCash, openMail, lastopened, stopOpening, onEvent, needsToWait, copper_to_pretty_money, total_cash
local _G = _G
local baseInboxFrame_OnClick
function doNothing() end

function openAll()
	if GetInboxNumItems() == 0 then return end
	button:SetScript("OnClick", nil)
	button2:SetScript("OnClick", nil)
	baseInboxFrame_OnClick = InboxFrame_OnClick
	InboxFrame_OnClick = doNothing
	button:RegisterEvent("UI_ERROR_MESSAGE")
	openMail(GetInboxNumItems())
end

function openAllCash()
	takingOnlyCash = true
	openAll()
end

function openMail(index)
	if not InboxFrame:IsVisible() then return stopOpening("|cffffff00Need a mailbox.") end
	if index == 0 then MiniMapMailFrame:Hide() stopOpening("|cffffff00"..L_DONE) return end
	local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(index)
	if money > 0 then
		TakeInboxMoney(index)
		needsToWait = true
		if total_cash then total_cash = total_cash - money end
	elseif (not takingOnlyCash) and numItems and (numItems > 0) and COD <= 0 then
		TakeInboxItem(index)
		needsToWait = true
	end
	local items = GetInboxNumItems()
	if (numItems and numItems > 1) or (items > 1 and index <= items) then
		lastopened = index
		t = 0
		button:SetScript("OnUpdate", waitForMail)
	else
		stopOpening("|cffffff00"..L_DONE)
		MiniMapMailFrame:Hide()
	end
end

function waitForMail(self, elapsed)
	t = t + elapsed
	if (not needsToWait) or (t > deletedelay) then
		needsToWait = false
		button:SetScript("OnUpdate", nil)
		local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(lastopened)
		if money > 0 or ((not takingOnlyCash) and COD <= 0 and numItems and (numItems > 0)) then
			openMail(lastopened)
		else
			openMail(lastopened - 1)
		end
	end
end

function stopOpening(msg, ...)
	button:SetScript("OnUpdate", nil)
	button:SetScript("OnClick", openAll)
	button2:SetScript("OnClick", openAllCash)
	if baseInboxFrame_OnClick then
		InboxFrame_OnClick = baseInboxFrame_OnClick
	end
	button:UnregisterEvent("UI_ERROR_MESSAGE")
	takingOnlyCash = false
	total_cash = nil
	if msg then DEFAULT_CHAT_FRAME:AddMessage(msg, ...) end
end

function onEvent(frame, event, arg1, arg2, arg3, arg4)
	if event == "UI_ERROR_MESSAGE" then
		if arg1 == ERR_INV_FULL then
			stopOpening("|cffffff00"..L_STOPPED)
		end
	end
end

local function makeButton(id, text, w, h, x, y)
	local button = CreateFrame("Button", id, InboxFrame, "UIPanelButtonTemplate")
	button:SetWidth(w)
	button:SetHeight(h)
	button:SetPoint("CENTER", InboxFrame, "TOP", x, y)
	button:SetText(text)
	return button
end
button = makeButton("OpenAllButton", L_ALL, 70, 25, -45, -408)
button:SetScript("OnClick", openAll)
button:SetScript("OnEvent", onEvent)
button2 = makeButton("OpenAllButton2", L_CASH, 70, 25, 28, -408)
button2:SetScript("OnClick", openAllCash)

button:SetScript("OnEnter", function()
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	GameTooltip:AddLine(string.format("%d ".."messages", GetInboxNumItems()), 1, 1, 1)
	GameTooltip:Show()
end)
button:SetScript("OnLeave", function() GameTooltip:Hide() end)

function copper_to_pretty_money(c)
	if c > 10000 then
		return ("%d|cffffd700g|r %d|cffc7c7cfs|r %d|cffeda55fc|r"):format(c/10000, (c/100)%100, c%100)
	elseif c > 100 then
		return ("%d|cffc7c7cfs|r %d|cffeda55fc|r"):format((c/100)%100, c%100)
	else
		return ("%d|cffeda55fc|r"):format(c%100)
	end
end

button2:SetScript("OnEnter", function()
	if not total_cash then
		total_cash = 0
		for index=0, GetInboxNumItems() do
			total_cash = total_cash + select(5, GetInboxHeaderInfo(index))
		end
	end
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	GameTooltip:AddLine(copper_to_pretty_money(total_cash), 1, 1, 1)
	GameTooltip:Show()
end)

button2:SetScript("OnLeave", function()	GameTooltip:Hide() end)
end

----------------------------------------------------------------------------------------
-- Mob marking(by ALZA)
----------------------------------------------------------------------------------------
if ThunderDB["Tweaker"]["MobMarking"] then
	local menuFrame = CreateFrame("Frame", "aSettingsMarkingFrame", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = L_CLEAR,
		func = function() SetRaidTarget("target", 0) end},
		{text = L_SKULL,
		func = function() SetRaidTarget("target", 8) end},
		{text = "|cffff0000"..L_CROSS.."|r",
		func = function() SetRaidTarget("target", 7) end},
		{text = "|cff00ffff"..L_SQUARE.."|r",
		func = function() SetRaidTarget("target", 6) end},
		{text = "|cffC7C7C7"..L_MOON.."|r",
		func = function() SetRaidTarget("target", 5) end},
		{text = "|cff00ff00"..L_TRIANGLE.."|r",
		func = function() SetRaidTarget("target", 4) end},
		{text = "|cff912CEE"..L_DIAMOND.."|r",
		func = function() SetRaidTarget("target", 3) end},
		{text = "|cffFF8000"..L_CIRCLE.."|r",
		func = function() SetRaidTarget("target", 2) end},
		{text = "|cffffff00"..L_STAR.."|r",
		func = function() SetRaidTarget("target", 1) end},
	}

	WorldFrame:HookScript("OnMouseDown", function(self, button)
		if(button=="LeftButton" and IsShiftKeyDown() and UnitExists("mouseover")) then --IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown()
			local inParty = (GetNumPartyMembers() > 0)
			local inRaid = (GetNumRaidMembers() > 0)
			if(inRaid and (IsRaidLeader() or IsRaidOfficer()) or (inParty and not inRaid)) then
				EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1)
			end
		end
	end)
end

----------------------------------------------------------------------------------------
--	Merchant ( tukui part )
----------------------------------------------------------------------------------------
if ThunderDB["Tweaker"]["AutoMerchant"] then
	local f = CreateFrame("Frame")
	f:SetScript("OnEvent", function()

		local c = 0
		for b=0,4 do
			for s=1,GetContainerNumSlots(b) do
				local l = GetContainerItemLink(b, s)
				if l then
					local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
					if select(3, GetItemInfo(l))==0 then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
					end
				end
			end
		end
		if c>0 then
			local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
			DEFAULT_CHAT_FRAME:AddMessage("All trash selled |cffffffff"..g.."g |cffffffff"..s.."s |cffffffff"..c.."c.",255,255,0)
		end

		if not IsShiftKeyDown() then
			if CanMerchantRepair() then
				cost, possible = GetRepairAllCost()
				if cost>0 then
					if possible then
						RepairAllItems()
						local c = cost%100
						local s = math.floor((cost%10000)/100)
						local g = math.floor(cost/10000)
						DEFAULT_CHAT_FRAME:AddMessage("Repair cost: |cffffffff"..g.."g |cffffffff"..s.."s |cffffffff"..c.."c.",255,255,0)
					else
						DEFAULT_CHAT_FRAME:AddMessage("No money for repair",255,0,0)
					end
				end
			end
		end
		
	end)
	f:RegisterEvent("MERCHANT_SHOW")

	-- buy max number value with alt
	local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	function MerchantItemButton_OnModifiedClick(self, ...)
		if ( IsAltKeyDown() ) then
			local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))
			local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(self:GetID())
			if ( maxStack and maxStack > 1 ) then
				BuyMerchantItem(self:GetID(), floor(maxStack / quantity))
			end
		end
		savedMerchantItemButton_OnModifiedClick(self, ...)
	end
end

----------------------------------------------------------------------------------------
-- Universal Mount macro : /script Mountz ("your_ground_mount","your_flying_mount") by MonoLIT
----------------------------------------------------------------------------------------
function Mountz(groundmount, flyingmount)
    local num = GetNumCompanions("MOUNT")
    if not num or IsMounted() then
        Dismount()
        return
    end
    if CanExitVehicle() then 
        VehicleExit()
        return
    end
    local x, y = GetPlayerMapPosition("player")
    local wgtime = GetWintergraspWaitTime()
    local flyablex = (IsFlyableArea() and (not (GetZoneText() == L_DALARAN or (GetZoneText() == L_WINTERGRASP and wgtime == nil)) or GetSubZoneText() == L_KRASUS or (GetSubZoneText() == L_UNDERBELLY and ((x*100)<32)) or (GetSubZoneText() == L_VC and (x*100)<33))) and (UnitLevel("player")>67 or (GetCurrentMapContinent()==3 and UnitLevel("player")>59))
    if IsAltKeyDown() then
        flyablex = not flyablex
    end
    for i=1, num, 1 do
        local _, info = GetCompanionInfo("MOUNT", i)
        if flyingmount and info == flyingmount and flyablex then
            CallCompanion("MOUNT", i)
            return
        elseif groundmount and info == groundmount and not flyablex then
            CallCompanion("MOUNT", i)
            return
        end
    end
end

----------------------------------------------------------------------------------------
-- Moving Battlefield score frame and CaptureBar
----------------------------------------------------------------------------------------

if (WorldStateAlwaysUpFrame) then
    WorldStateAlwaysUpFrame:ClearAllPoints()
    WorldStateAlwaysUpFrame:SetPoint("TOPLEFT", UIParent, 300, -50)
    WorldStateAlwaysUpFrame:SetScale(0.9)
    WorldStateAlwaysUpFrame.SetPoint = function() end
end 
--[[
local function CaptureUpdate()
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local cb = _G["WorldStateCaptureBar"..i]
		if cb and cb:IsShown() then
			cb:ClearAllPoints()
			cb:SetPoint("TOP", UIParent, "TOP", 0, fixscale(-120))
		end
	end
end
hooksecurefunc("WorldStateAlwaysUpFrame_Update", CaptureUpdate)]] 

----------------------------------------------------------------------------------------
-- Quest tracker(by Tukz)
----------------------------------------------------------------------------------------
local wf = WatchFrame
local wfmove = false 

wf:SetMovable(true);
wf:SetClampedToScreen(false); 
wf:ClearAllPoints()
wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -150, -150)
wf:SetWidth(250)
wf:SetHeight(500)
wf:SetUserPlaced(true)
wf.SetPoint = function() end

local function WATCHFRAMELOCK()
	if wfmove == false then
		wfmove = true
		print("WatchFrame unlocked for drag")
		wf:EnableMouse(true);
		wf:RegisterForDrag("LeftButton"); 
		wf:SetScript("OnDragStart", wf.StartMoving); 
		wf:SetScript("OnDragStop", wf.StopMovingOrSizing);
	elseif wfmove == true then
		wf:EnableMouse(false);
		wfmove = false
		print("WatchFrame locked")
	end
end

SLASH_WATCHFRAMELOCK1 = "/wf"
SlashCmdList["WATCHFRAMELOCK"] = WATCHFRAMELOCK

----------------------------------------------------------------------------------------
-- Quest level(yQuestLevel by yleaf)
----------------------------------------------------------------------------------------
local function update()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

hooksecurefunc("QuestLog_Update", update)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", update)

----------------------------------------------------------------------------------------
-- Slash commands
----------------------------------------------------------------------------------------

SlashCmdList["FRAME"] = function() print(GetMouseFocus():GetName()) end
SLASH_FRAME1 = "/gn"
SLASH_FRAME2 = "/frame"

SlashCmdList["SC"] = function() print(GetMouseFocus():GetEffectiveScale()) end
SLASH_SK1 = "/sc"

SlashCmdList["GETPARENT"] = function() print(GetMouseFocus():GetParent():GetName()) end
SLASH_GETPARENT1 = "/gp"
SLASH_GETPARENT2 = "/parent"

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"
SLASH_RELOADUI2 = "/кд"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"
SLASH_RCSLASH2 = "/кс"

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/ticket"
SLASH_TICKET2 = "/gm"
SLASH_TICKET3 = "/гм"

SlashCmdList["DISABLE_ADDON"] = function(s) DisableAddOn(s) end
SLASH_DISABLE_ADDON1 = "/dis"

SlashCmdList["ENABLE_ADDON"] = function(s) EnableAddOn(s) end
SLASH_ENABLE_ADDON1 = "/en"

SlashCmdList['THUNDER'] = function()
		InterfaceOptionsFrame_OpenToCategory'|cff9DC7CCThe Thunder UI|r'
end
SLASH_THUNDER1 = '/thunder'

----------------------------------------------------------------------------------------
-- fix the fucking combatlog after a crash (a wow 2.4 and 3.3.2 bug)... thx Tukz xD 
----------------------------------------------------------------------------------------

local function CLFIX()
	CombatLogClearEntries()
end

SLASH_CLFIX1 = "/clfix"
SlashCmdList["CLFIX"] = CLFIX

----------------------------------------------------------------------------------------
-- Info text or other(Do not change or delete!!!)
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame", nil, UIParent)
frame:SetScript("OnUpdate", FadingFrame_OnUpdate)
frame.fadeInTime = 0.5
frame.fadeOutTime = 2
frame.holdTime = 3
frame:Hide()

local text = frame:CreateFontString("aInfoText", "OVERLAY")
text:SetFont("Fonts\\NIM_____.TTF", 32, "THICKOUTLINE")
text:SetPoint("CENTER", UIParent, "CENTER")
text:SetTextColor(0.41, 0.8, 0.94)

aInfoText_ShowText = function(s)
    text:SetText(s)
    FadingFrame_Show(frame)
end

CreateBG = function(parent, offset, r, g, b, a)
    local bg = parent:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("TOPLEFT", parent, -offset, offset)
    bg:SetPoint("BOTTOMRIGHT", parent, offset, -offset)
    bg:SetTexture(r, g, b, a)
    return bg
end

CreateFS = function(parent, size, justify)
    local f = parent:CreateFontString(nil, "OVERLAY")
    f:SetFont(main_font, main_font_size, main_font_style)
    f:SetShadowColor(0, 0, 0, 0)
    if(justify) then f:SetJustifyH(justify) end
    return f
end

end
tinsert(ThunderUI.modules, module) -- finish him!