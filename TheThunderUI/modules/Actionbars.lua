----------------------------------------------------------------------------------------
-- rActionBarStyler
-- All credits of this - Zork
----------------------------------------------------------------------------------------

local module = {}
module.name = "ActionBars"
module.Init = function()
	if not ThunderDB.modules[module.name] then return end
	local settings = ThunderDB

----------------------------------------------------------------------------------------
-- Hide blizz menu
----------------------------------------------------------------------------------------

InterfaceOptionsActionBarsPanelBottomLeft:Hide()
InterfaceOptionsActionBarsPanelBottomRight:Hide()
InterfaceOptionsActionBarsPanelRight:Hide()
InterfaceOptionsActionBarsPanelRightTwo:Hide()
InterfaceOptionsActionBarsPanelAlwaysShowActionBars:Hide()

----------------------------------------------------------------------------------------
-- Set points
----------------------------------------------------------------------------------------

local _, class = UnitClass("player")

if ThunderDB["ActionBars"]["RightBars"] > 2 then
	ThunderDB["ActionBars"]["RightBars"] = 2
end

local RABSpositions = {
	[1] = { a = "BOTTOM",		x = fixscale(ThunderDB["ActionBars"]["Bar123_X"]),	y = fixscale(ThunderDB["ActionBars"]["Bar123_Y"])},--fbar123
	[2] = { a = "BOTTOMRIGHT",	x = fixscale(ThunderDB["ActionBars"]["Bar3_X"]),	y = fixscale(ThunderDB["ActionBars"]["Bar3_Y"])},--fbar3
	[3] = { a = "RIGHT",		x = fixscale(ThunderDB["ActionBars"]["Bar4_X"]),	y = fixscale(ThunderDB["ActionBars"]["Bar4_Y"])},--fbar4
	[6] = { a = "BOTTOM",		x = fixscale(ThunderDB["ActionBars"]["BarTotem_X"]),y = fixscale(ThunderDB["ActionBars"]["BarTotem_Y"])},--totem
	[9] = { a = "BOTTOM",		x = fixscale(ThunderDB["ActionBars"]["BarPet_X"]),	y = fixscale(ThunderDB["ActionBars"]["BarPet_Y"])},--petbar
	[10]= { a = "TOPLEFT",		x = fixscale(ThunderDB["ActionBars"]["BarClass_X"]),y = fixscale(ThunderDB["ActionBars"]["BarClass_Y"])},--shapeshift
	[11]= { a = "BOTTOM",		x = fixscale(ThunderDB["ActionBars"]["BarExit_X"]),	y = fixscale(ThunderDB["ActionBars"]["BarExit_Y"])},--my own vehicle exit button
}

----------------------------------------------------------------------------------------
-- hide blizzard stuff
----------------------------------------------------------------------------------------

local FramesToHide = {
	MainMenuBar, 
	MainMenuBarArtFrame, 
	BonusActionBarFrame, 
	VehicleMenuBar,
	PossessBarFrame,
}  
  
for _, f in pairs(FramesToHide) do
	if f:GetObjectType() == "Frame" then
		f:UnregisterAllEvents()
	end
	f:Hide()
	f:SetAlpha(0)
	f:SetWidth(0.001)
	if f:IsShown() then
		f:Hide()
	end
end

------------------------------------------------------------------------
--	Show button grid and all action bars
------------------------------------------------------------------------

local GridOnLogon = CreateFrame("Frame")
GridOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
GridOnLogon:SetScript("OnEvent", function()
	GridOnLogon:UnregisterEvent("PLAYER_ENTERING_WORLD")
	GridOnLogon:SetScript("OnEvent", nil)
		
	-- enable action bars
		SetActionBarToggles( 1, 1, 1, 1, 0 )
		ActionButton_HideGrid = function() end
		SetCVar("alwaysShowActionBars", 0)
		
	for i = 1, 12 do
		local button = _G[format("ActionButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("BonusActionButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("MultiBarRightButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("MultiBarBottomRightButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("MultiBarLeftButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("MultiBarBottomLeftButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
	end
end)

----------------------------------------------------------------------------------------
-- fBar 1
-- MAJOR props to tukz for the RegisterStateDriver
-- settings for actionbar1/bonusactionbar -- zork
----------------------------------------------------------------------------------------

local fbar1 = CreateFrame("Frame","rABS_MainMenuBar",UIParent, "SecureHandlerStateTemplate")
fbar1:SetWidth(ThunderDB["ActionBars"]["ButtonSize"]*12+ThunderDB["ActionBars"]["Offset"]*11)
fbar1:SetHeight(ThunderDB["ActionBars"]["ButtonSize"])
if ThunderDB["ActionBars"]["InvertBars"] then
	if ThunderDB["ActionBars"]["ThirdPanel"] then
		fbar1:SetPoint(RABSpositions[1].a,RABSpositions[1].x,RABSpositions[1].y+ThunderDB["ActionBars"]["ButtonSize"]*2+ThunderDB["ActionBars"]["Offset"]*2)
	else
		fbar1:SetPoint(RABSpositions[1].a,RABSpositions[1].x,RABSpositions[1].y+ThunderDB["ActionBars"]["ButtonSize"]+ThunderDB["ActionBars"]["Offset"])
	end
else
	fbar1:SetPoint(RABSpositions[1].a,RABSpositions[1].x,RABSpositions[1].y)
end

if ThunderDB["ActionBars"]["TestMode"] then
	fbar1:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
fbar1:SetScale(1)

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] %s; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [form:3] 7;",
	["WARLOCK"] = "[form:2] 7;",
	["DEFAULT"] = "[bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6; [bonusbar:5] 11;",
}

local function GetBar()
	local condition = Page["DEFAULT"]
	local _, class = UnitClass("player")
	local page = Page[class]
	if page then
		if class == "DRUID" then
			-- Handles prowling, prowling has no real stance, so this is a hack which utilizes the Tree of Life bar for non-resto druids.
			if IsSpellKnown(33891) then -- Tree of Life form
				page = page:format(7)
			else
				page = page:format(8)
			end
		end
		condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end

fbar1:RegisterEvent("PLAYER_LOGIN")
fbar1:RegisterEvent("PLAYER_ENTERING_WORLD")
fbar1:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
fbar1:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
fbar1:RegisterEvent("BAG_UPDATE")
fbar1:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local bu1
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			bu1 = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, bu1)
		end	

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		]])

		self:SetAttribute("_onstate-page", [[ 
			for i, bu1 in ipairs(buttons) do
				bu1:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
		
		RegisterStateDriver(self, "page", GetBar())
	elseif event == "PLAYER_ENTERING_WORLD" then
		MainMenuBar_UpdateKeyRing()
		local bu1
		for i = 1, 12 do
			bu1 = _G["ActionButton"..i]
			bu1:SetSize(ThunderDB["ActionBars"]["ButtonSize"], ThunderDB["ActionBars"]["ButtonSize"])
			bu1:ClearAllPoints()
			bu1:SetParent(self)
			if i == 1 then
				bu1:SetPoint("BOTTOMLEFT", fbar1, 0,0)
			else
				local previous = _G["ActionButton"..i-1]
				bu1:SetPoint("LEFT", previous, "RIGHT", ThunderDB["ActionBars"]["Offset"], 0)
			end
		end
	else
		 MainMenuBar_OnEvent(self, event, ...)
	end
end)

----------------------------------------------------------------------------------------
-- fbar2
----------------------------------------------------------------------------------------

local fbar2 = CreateFrame("Frame","rABS_MultiBarBottomLeft",UIParent, "SecureHandlerStateTemplate")
fbar2:SetWidth(ThunderDB["ActionBars"]["ButtonSize"]*12+ThunderDB["ActionBars"]["Offset"]*11)
fbar2:SetHeight(ThunderDB["ActionBars"]["ButtonSize"])
if ThunderDB["ActionBars"]["InvertBars"] and ThunderDB["ActionBars"]["ThirdPanel"] ~= true then
	fbar2:SetPoint(RABSpositions[1].a,RABSpositions[1].x,RABSpositions[1].y)
else
	fbar2:SetPoint(RABSpositions[1].a,RABSpositions[1].x,RABSpositions[1].y+ThunderDB["ActionBars"]["ButtonSize"]+ThunderDB["ActionBars"]["Offset"])
end

if ThunderDB["ActionBars"]["TestMode"] then
	fbar2:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
fbar2:SetScale(1)

MultiBarBottomLeft:SetParent(fbar2)

for i=1, 12 do
	local bu2 = _G["MultiBarBottomLeftButton"..i]
	bu2:SetSize(ThunderDB["ActionBars"]["ButtonSize"], ThunderDB["ActionBars"]["ButtonSize"])
	bu2:ClearAllPoints()
	if i == 1 then
		bu2:SetPoint("BOTTOMLEFT", fbar2, 0,0)
	else
		local previous = _G["MultiBarBottomLeftButton"..i-1]
		bu2:SetPoint("LEFT", previous, "RIGHT", ThunderDB["ActionBars"]["Offset"], 0)
	end
end

----------------------------------------------------------------------------------------
-- thunder bar3 - 8 button
----------------------------------------------------------------------------------------

local vis = 8

local fbar3 = CreateFrame("Frame","rABS_MultiBarBottomRight",UIParent, "SecureHandlerStateTemplate")
fbar3:SetHeight(fixscale(124))
fbar3:SetWidth(fixscale(60))
fbar3:SetPoint(RABSpositions[2].a,RABSpositions[2].x,RABSpositions[2].y)

if ThunderDB["ActionBars"]["TestMode"] then
	fbar3:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
fbar3:SetScale(1)

MultiBarBottomRight:SetParent(fbar3)

for i=1, 12 do
	local bu3 = _G["MultiBarBottomRightButton"..i]
	bu3:SetSize(fixscale(28), fixscale(28))
	bu3:ClearAllPoints()
	if i == 1 then
		bu3:SetPoint("TOPLEFT", fbar3, 0,0)
	else
		local previous = _G["MultiBarBottomRightButton"..i-1]			
		if i == 5 then
			previous = _G["MultiBarBottomRightButton1"]
			bu3:SetPoint("TOPLEFT", previous, "TOPRIGHT", fixscale(4), 0)
		else
			bu3:SetPoint("TOP", previous, "BOTTOM", 0, -fixscale(4))
		end
	if i > vis then
			bu3:UnregisterAllEvents()
			bu3:SetScale(0.00001)
			bu3:SetAlpha(0)
			bu3:Hide()
	end
	end
end

----------------------------------------------------------------------------------------
-- fbar4
----------------------------------------------------------------------------------------

if ThunderDB["ActionBars"]["ThirdPanel"] or ThunderDB["ActionBars"]["RightBars"] > 0 then	
	local fbar4 = CreateFrame("Frame","rABS_MultiBarRight",UIParent, "SecureHandlerStateTemplate")
	if ThunderDB["ActionBars"]["ThirdPanel"] then
		fbar4:SetHeight(ThunderDB["ActionBars"]["ButtonSize"])
		fbar4:SetWidth(ThunderDB["ActionBars"]["ButtonSize"]*12+ThunderDB["ActionBars"]["Offset"]*11)
		if ThunderDB["ActionBars"]["InvertBars"] then
			fbar4:SetPoint(RABSpositions[1].a,RABSpositions[1].x,RABSpositions[1].y)
		else
			fbar4:SetPoint(RABSpositions[1].a,RABSpositions[1].x,RABSpositions[1].y+ThunderDB["ActionBars"]["ButtonSize"]*2+ThunderDB["ActionBars"]["Offset"]*2)
		end
	else
		fbar4:SetHeight(ThunderDB["ActionBars"]["ButtonSize"]*12+ThunderDB["ActionBars"]["Offset"]*11)
		fbar4:SetWidth(ThunderDB["ActionBars"]["ButtonSize"])
		fbar4:SetPoint(RABSpositions[3].a,RABSpositions[3].x,RABSpositions[3].y)
	end
	
	if ThunderDB["ActionBars"]["TestMode"] then
		fbar4:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	end
	fbar4:SetScale(1)

	MultiBarRight:SetParent(fbar4)
	
	for i=1, 12 do
		local bu4 = _G["MultiBarRightButton"..i]
		bu4:ClearAllPoints()
		bu4:SetSize(ThunderDB["ActionBars"]["ButtonSize"], ThunderDB["ActionBars"]["ButtonSize"])
		if i == 1 then
			bu4:SetPoint("TOPLEFT", fbar4, 0,0)
		else
			local previous = _G["MultiBarRightButton"..i-1]
			if ThunderDB["ActionBars"]["ThirdPanel"] then
				bu4:SetPoint("LEFT", previous, "RIGHT", ThunderDB["ActionBars"]["Offset"], 0)
			else
				bu4:SetPoint("TOP", previous, "BOTTOM", 0, -ThunderDB["ActionBars"]["Offset"])
			end
		end
	end
else
	for i=1, 12 do
		local bu4 = _G["MultiBarRightButton"..i]
		bu4:UnregisterAllEvents()
		bu4:SetScale(0.00001)
		bu4:SetAlpha(0)
		bu4:Hide()
	end
end

----------------------------------------------------------------------------------------
-- fbar5
----------------------------------------------------------------------------------------

if (ThunderDB["ActionBars"]["ThirdPanel"] and ThunderDB["ActionBars"]["RightBars"] > 0) or (ThunderDB["ActionBars"]["RightBars"] > 1)then 
local fbar5 = CreateFrame("Frame","rABS_MultiBarLeft",UIParent, "SecureHandlerStateTemplate")
fbar5:SetHeight(ThunderDB["ActionBars"]["ButtonSize"]*12+ThunderDB["ActionBars"]["Offset"]*11)
fbar5:SetWidth(ThunderDB["ActionBars"]["ButtonSize"])
if ThunderDB["ActionBars"]["ThirdPanel"] then
	fbar5:SetPoint(RABSpositions[3].a,RABSpositions[3].x,RABSpositions[3].y)
else
	fbar5:SetPoint(RABSpositions[3].a,RABSpositions[3].x-ThunderDB["ActionBars"]["ButtonSize"]-ThunderDB["ActionBars"]["Offset"],RABSpositions[3].y)
end

local mousebar = CreateFrame("Frame","rABS_MultiBarMouseLeftRight",UIParent, "SecureHandlerStateTemplate")
mousebar:SetHeight(ThunderDB["ActionBars"]["ButtonSize"]*12+ThunderDB["ActionBars"]["Offset"]*11)
mousebar:SetWidth(ThunderDB["ActionBars"]["ButtonSize"]*2+ThunderDB["ActionBars"]["Offset"])
mousebar:SetPoint(RABSpositions[3].a,RABSpositions[3].x,RABSpositions[3].y)


if ThunderDB["ActionBars"]["TestMode"] then
	fbar5:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
fbar5:SetScale(1)

MultiBarLeft:SetParent(fbar5)
  
for i=1, 12 do
	local bu5 = _G["MultiBarLeftButton"..i]
	bu5:ClearAllPoints()
	bu5:SetSize(ThunderDB["ActionBars"]["ButtonSize"], ThunderDB["ActionBars"]["ButtonSize"])
	if i == 1 then
		bu5:SetPoint("TOPLEFT", fbar5, 0,0)
	else
		local previous = _G["MultiBarLeftButton"..i-1]
		bu5:SetPoint("TOP", previous, "BOTTOM", 0, -ThunderDB["ActionBars"]["Offset"])
	end
end

if ThunderDB["ActionBars"]["MouseoverRight"] then
	if ThunderDB["ActionBars"]["ThirdPanel"] then
		local function lighton(alpha)
		  if MultiBarLeft:IsShown() then
			for i=1, 12 do
			  local pb = _G["MultiBarLeftButton"..i]
			  pb:SetAlpha(alpha)
			end
		  end
		end    
		fbar5:EnableMouse(true)
		fbar5:SetScript("OnEnter", function(self) lighton(1) end)
		fbar5:SetScript("OnLeave", function(self) lighton(0) end)  
		for i=1, 12 do
		  local pb = _G["MultiBarLeftButton"..i]
		  pb:SetAlpha(0)
		  pb:HookScript("OnEnter", function(self) lighton(1) end)
		  pb:HookScript("OnLeave", function(self) lighton(0) end)
		end
	else
		local function lighton(alpha)
		  if MultiBarLeft:IsShown() then
			for i=1, 12 do
			  local pb = _G["MultiBarLeftButton"..i]
			  pb:SetAlpha(alpha)
			end
		  end
			if MultiBarRight:IsShown() then
				for i=1, 12 do
					local pb = _G["MultiBarRightButton"..i]
					pb:SetAlpha(alpha)
				end
			end
		end    
		mousebar:EnableMouse(true)
		mousebar:SetScript("OnEnter", function(self) lighton(1) end)
		mousebar:SetScript("OnLeave", function(self) lighton(0) end)  
		for i=1, 12 do
		  local pb = _G["MultiBarLeftButton"..i]
		  pb:SetAlpha(0)
		  pb:HookScript("OnEnter", function(self) lighton(1) end)
		  pb:HookScript("OnLeave", function(self) lighton(0) end)
		end
		for i=1, 12 do
			local pb = _G["MultiBarRightButton"..i]
			pb:SetAlpha(0)
			pb:HookScript("OnEnter", function(self) lighton(1) end)
			pb:HookScript("OnLeave", function(self) lighton(0) end)
		end	
	end
end

else
	for i=1, 12 do
		local bu5 = _G["MultiBarLeftButton"..i]
		bu5:UnregisterAllEvents()
		bu5:SetScale(0.00001)
		bu5:SetAlpha(0)
		bu5:Hide()
	end
end

----------------------------------------------------------------------------------------
-- Class Bar - Stances, Auras and etc
----------------------------------------------------------------------------------------

if not ThunderDB["ActionBars"]["HideClassBar"] then
  
	local shapenum = NUM_SHAPESHIFT_SLOTS
    
    local classbar = CreateFrame("Frame","rABS_StanceBar",UIParent, "SecureHandlerStateTemplate")
    classbar:SetWidth(ThunderDB["ActionBars"]["ClassButtonSize"]*shapenum+ThunderDB["ActionBars"]["Offset"]*(shapenum-1))
    classbar:SetHeight(ThunderDB["ActionBars"]["ClassButtonSize"])
    classbar:SetPoint(RABSpositions[10].a,RABSpositions[10].x,RABSpositions[10].y)
    
if ThunderDB["ActionBars"]["TestMode"] then
	classbar:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
classbar:SetScale(1)
  
    ShapeshiftBarFrame:SetParent(classbar)
    
    for i=1, shapenum do
      local classbu = _G["ShapeshiftButton"..i]
      classbu:SetSize(ThunderDB["ActionBars"]["ClassButtonSize"], ThunderDB["ActionBars"]["ClassButtonSize"])
      classbu:ClearAllPoints()
      if i == 1 then
        classbu:SetPoint("BOTTOMLEFT", classbar, 0,0)
      else
        local previous = _G["ShapeshiftButton"..i-1]      
        classbu:SetPoint("LEFT", previous, "RIGHT", ThunderDB["ActionBars"]["Offset"], 0)
      end
    end
    
    local function rABS_MoveShapeshift()
      ShapeshiftButton1:SetPoint("BOTTOMLEFT", classbar, 0,0)
    end
    hooksecurefunc("ShapeshiftBar_Update", rABS_MoveShapeshift);
    
    
    if ThunderDB["ActionBars"]["MouseoverClassBar"] then    
      local function lighton(alpha)
        if ShapeshiftBarFrame:IsShown() then
          for i=1, shapenum do
            local pb = _G["ShapeshiftButton"..i]
            pb:SetAlpha(alpha)
          end
        end
      end    
      classbar:EnableMouse(true)
      classbar:SetScript("OnEnter", function(self) lighton(1) end)
      classbar:SetScript("OnLeave", function(self) lighton(0) end)  
      for i=1, shapenum do
        local pb = _G["ShapeshiftButton"..i]
        pb:SetAlpha(0)
        pb:HookScript("OnEnter", function(self) lighton(1) end)
        pb:HookScript("OnLeave", function(self) lighton(0) end)
      end    
    end
end

----------------------------------------------------------------------------------------
-- Totem Bar
----------------------------------------------------------------------------------------

if class == "SHAMAN" then

    local tbar = _G['MultiCastActionBarFrame']

    if tbar then

      local holder = CreateFrame("Frame","rABS_TotemBar",UIParent, "SecureHandlerStateTemplate")
      holder:SetWidth(tbar:GetWidth())
      holder:SetHeight(tbar:GetHeight())
if ThunderDB["ActionBars"]["TestMode"] then
	tbar:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
            
      tbar:SetParent(holder)
      tbar:SetAllPoints(holder)
      
      local function moveTotem(self,a1,af,a2,x,y,...)
        if x ~= RABSpositions[6].x then
    --      print('doing')
          tbar:SetAllPoints(holder)
        end
      end
            
      hooksecurefunc(tbar, "SetPoint", moveTotem)
	if ThunderDB["ActionBars"]["ThirdPanel"] then
		holder:SetPoint(RABSpositions[6].a,RABSpositions[6].x,RABSpositions[6].y+44)
	else
		holder:SetPoint(RABSpositions[6].a,RABSpositions[6].x,RABSpositions[6].y)
	end

      holder:SetScale(0.8)
      
      tbar:SetMovable(true)
      tbar:SetUserPlaced(true)
      tbar:EnableMouse(false)

    end
  
end

----------------------------------------------------------------------------------------
-- Pet Bar
----------------------------------------------------------------------------------------

local petnum = NUM_PET_ACTION_SLOTS

local fbarpet = CreateFrame("Frame","rABS_PetBar",UIParent, "SecureHandlerStateTemplate")
fbarpet:SetWidth(ThunderDB["ActionBars"]["ClassButtonSize"]*petnum+ThunderDB["ActionBars"]["Offset"]*(petnum-1))
fbarpet:SetHeight(ThunderDB["ActionBars"]["ClassButtonSize"])
if ThunderDB["ActionBars"]["ThirdPanel"] then
	fbarpet:SetPoint(RABSpositions[9].a,RABSpositions[9].x,RABSpositions[9].y+ThunderDB["ActionBars"]["ButtonSize"]+ThunderDB["ActionBars"]["Offset"])
else
	fbarpet:SetPoint(RABSpositions[9].a,RABSpositions[9].x,RABSpositions[9].y)
end
	
if ThunderDB["ActionBars"]["TestMode"] then
	fbarpet:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
fbarpet:SetScale(1)
  
PetActionBarFrame:SetParent(fbarpet)

for i=1, petnum do
	local petbu = _G["PetActionButton"..i]
	local cd = _G["PetActionButton"..i.."Cooldown"]
	petbu:SetSize(ThunderDB["ActionBars"]["ClassButtonSize"], ThunderDB["ActionBars"]["ClassButtonSize"])
	petbu:ClearAllPoints()
	if i == 1 then
		petbu:SetPoint("BOTTOMLEFT", fbarpet, 0,0)
	else
		local previous = _G["PetActionButton"..i-1]      
		petbu:SetPoint("LEFT", previous, "RIGHT", ThunderDB["ActionBars"]["Offset"], 0)
	end
	cd:SetAllPoints(petbu)
end

if ThunderDB["ActionBars"]["MouseoverPet"] then    
	local function lighton(alpha)
	if PetActionBarFrame:IsShown() then
	for i=1, petnum do
	local pb = _G["PetActionButton"..i]
	pb:SetAlpha(alpha)
	end
	end
	end    
	fbarpet:EnableMouse(true)
	fbarpet:SetScript("OnEnter", function(self) lighton(1) end)
	fbarpet:SetScript("OnLeave", function(self) lighton(0) end)  
	for i=1, petnum do
	local pb = _G["PetActionButton"..i]
	pb:SetAlpha(0)
	pb:HookScript("OnEnter", function(self) lighton(1) end)
	pb:HookScript("OnLeave", function(self) lighton(0) end)
	end    
end

----------------------------------------------------------------------------------------
-- Vehicle Exit
----------------------------------------------------------------------------------------

local fbarveb = CreateFrame("Frame","rABS_VehicleExit",UIParent, "SecureHandlerStateTemplate")
fbarveb:SetHeight(ThunderDB["ActionBars"]["ClassButtonSize"])
fbarveb:SetWidth(ThunderDB["ActionBars"]["ClassButtonSize"])
fbarveb:SetPoint(RABSpositions[11].a,RABSpositions[11].x,RABSpositions[11].y)
  
if ThunderDB["ActionBars"]["TestMode"] then
	fbarveb:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
fbarveb:SetScale(1)
  
local veb = CreateFrame("BUTTON", nil, fbarveb, "SecureActionButtonTemplate");
veb:SetAllPoints(fbarveb)
veb:RegisterForClicks("AnyUp")
veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
veb:SetScript("OnClick", function(self) VehicleExit() end)
veb:RegisterEvent("UNIT_ENTERING_VEHICLE")
veb:RegisterEvent("UNIT_ENTERED_VEHICLE")
veb:RegisterEvent("UNIT_EXITING_VEHICLE")
veb:RegisterEvent("UNIT_EXITED_VEHICLE")
veb:SetScript("OnEvent", function(self,event,...)
local arg1 = ...;
	if(((event=="UNIT_ENTERING_VEHICLE") or (event=="UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
		veb:SetAlpha(1)
	elseif(((event=="UNIT_EXITING_VEHICLE") or (event=="UNIT_EXITED_VEHICLE")) and arg1 == "player") then
		veb:SetAlpha(0)
	end
end)  
veb:SetAlpha(0)

end
tinsert(ThunderUI.modules, module) -- finish him!