----------------------------------------------------------------------------------------
-- aMinimap
-- ALZA - 2010
----------------------------------------------------------------------------------------

local module = {}
module.name = "Minimap"
module.Init = function()
	if not ThunderDB.modules[module.name] then return end
	local settings = ThunderDB
	
local minimap_scale = 0.855								-- Mini Map scale
local minimap_position = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -24/minimap_scale, 28/minimap_scale}

----------------------------------------------------------------------------------------
-- Shape, location and scale
----------------------------------------------------------------------------------------
Minimap:ClearAllPoints()
Minimap:SetPoint(unpack(minimap_position))
Minimap:SetMaskTexture(ThunderDB["Main"]["BlankText"])
MinimapCluster:SetScale(minimap_scale)
Minimap:SetFrameStrata("LOW")

----------------------------------------------------------------------------------------
-- Mask texture
----------------------------------------------------------------------------------------
local hint = CreateFrame("Frame")
local total = 0
local SetTextureTrick = function(self, elapsed)
    total = total + elapsed
    if(total > 2) then
        Minimap:SetMaskTexture(ThunderDB["Main"]["BlankText"])
        hint:SetScript("OnUpdate", nil)
    end
end

hint:RegisterEvent("PLAYER_LOGIN")
hint:SetScript("OnEvent", function()
    hint:SetScript("OnUpdate", SetTextureTrick)
end)

----------------------------------------------------------------------------------------
-- Mousewheel zoom
----------------------------------------------------------------------------------------
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)

----------------------------------------------------------------------------------------
-- Hide ugly icons
----------------------------------------------------------------------------------------
local dummy = function() end
local _G = getfenv(0)

local frames = {
    "GameTimeFrame",
    "MinimapBorderTop",
    "MinimapNorthTag",
    "MinimapBorder",
    "MinimapZoneTextButton",
    "MinimapZoomOut",
    "MinimapZoomIn",
    "MiniMapVoiceChatFrame",
    "MiniMapWorldMapButton",
    "MiniMapMailBorder",
    "MiniMapBattlefieldBorder",
}

for i in pairs(frames) do
    _G[frames[i]]:Hide()
    _G[frames[i]].Show = dummy
end
MinimapCluster:EnableMouse(false)

----------------------------------------------------------------------------------------
-- Tracking text and icon
----------------------------------------------------------------------------------------

MiniMapTrackingBackground:SetAlpha(0)
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap, -5, -4)
MiniMapTrackingButtonBorder:SetTexture(nil)
MiniMapTrackingBackground:Hide()
MiniMapTrackingIconOverlay:SetTexture(nil)
MiniMapTracking:SetScale(1)

----------------------------------------------------------------------------------------
-- BG icon
----------------------------------------------------------------------------------------
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("TOP", Minimap, "TOP", 1, 6)

----------------------------------------------------------------------------------------
-- Feedback Beta Button
----------------------------------------------------------------------------------------
--[[FeedbackUIButton:ClearAllPoints()
FeedbackUIButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", 3, 5)
FeedbackUIButton:SetAlpha(0.5)]]

----------------------------------------------------------------------------------------
-- Random Group icon
----------------------------------------------------------------------------------------
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrameBorder:SetAlpha(0)
MiniMapLFGFrame:SetPoint("TOP", Minimap, "TOP", 1, 8)

LFDSearchStatus:SetClampedToScreen(true)
LFDSearchStatus:SetFrameStrata("TOOLTIP")

----------------------------------------------------------------------------------------
-- Instance Difficulty icon
----------------------------------------------------------------------------------------
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 3, 2)
MiniMapInstanceDifficulty:SetFrameStrata("TOOLTIP")

----------------------------------------------------------------------------------------
-- Guild Instance Difficulty icon
----------------------------------------------------------------------------------------
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 2)
GuildInstanceDifficulty:SetFrameStrata("TOOLTIP")
GuildInstanceDifficulty:SetScale(0.85)

----------------------------------------------------------------------------------------
-- Mail icon
----------------------------------------------------------------------------------------
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 6, -8)
MiniMapMailIcon:SetTexture("Interface\\AddOns\\!ThunderConfig\\media\\mail")

----------------------------------------------------------------------------------------
-- Invites Icon
----------------------------------------------------------------------------------------
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetAlpha(0)
GameTimeCalendarInvitesTexture:Hide()
GameTimeCalendarInvitesTexture.Show = dummy --not tested
--GameTimeCalendarInvitesTexture:SetParent("Minimap")
--GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")

----------------------------------------------------------------------------------------
-- Right click menu
----------------------------------------------------------------------------------------
local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = CHARACTER_BUTTON,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
    func = function() ToggleSpellBook("spell") end},
    {text = TALENTS_BUTTON,
    func = function() ToggleTalentFrame() end},
    {text = ACHIEVEMENT_BUTTON,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON,
    func = function() ToggleFriendsFrame(1) end},
	{text = "Guild",
    func = function() ToggleGuildFrame(1) end},
    {text = PLAYER_V_PLAYER,
    func = function() ToggleFrame(PVPFrame) end},
    {text = LFG_TITLE,
    func = function() ToggleFrame(LFDParentFrame) end},
    {text = L_LFRAID,
    func = function() ToggleFrame(LFRParentFrame) end},
    {text = HELP_BUTTON,
    func = function() ToggleHelpFrame() end},
    {text = L_CALENDAR,
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
}

----------------------------------------------------------------------------------------
-- Click function
----------------------------------------------------------------------------------------
Minimap:SetScript("OnMouseUp", function(_, button)
    if(button=="RightButton") then
        EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(_,click)
    end
end)

--------------------------------------------------------------------
-- Minimap Location mousover
--------------------------------------------------------------------

local ZZFramE = CreateFrame("Frame")

ZOMGTEXT = UIParent:CreateFontString(nil, "OVERLAY")
ZOMGTEXT:SetFont(ThunderDB["Main"]["Font"], ThunderDB["Main"]["FontSize"], "OUTLINE")
ZOMGTEXT:SetPoint("TOP", Minimap, 0, -20)
ZOMGTEXT:SetWidth((Minimap:GetWidth() - 25))
ZOMGTEXT:SetAlpha(0)

	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local x, y = GetPlayerMapPosition("player")
				if (x == 0 and y == 0) then
				ZOMGTEXT:SetText("|cff9DC7CC"..GetZoneText());
			else
				ZOMGTEXT:SetText("|cff9DC7CC"..GetZoneText().."\n"..string.format("%.1f | %.1f",x * 100,y * 100));
			end
			int = 1
		end
	end
		
Minimap:SetScript("OnEnter", function()
	UIFrameFadeIn(ZOMGTEXT, 0.15, ZOMGTEXT:GetAlpha(), 1)
	end)
Minimap:SetScript("OnLeave", function()
	UIFrameFadeIn(ZOMGTEXT, 0.15, ZOMGTEXT:GetAlpha(), 0)
	end)
	
ZZFramE:SetScript("OnUpdate", Update)
Update(ZZFramE, 10)

--------------------------------------------------------------------
-- Clock
--------------------------------------------------------------------

if not IsAddOnLoaded("Blizzard_TimeManager") then
	LoadAddOn("Blizzard_TimeManager")
end
TimeManagerClockButton:Hide()

end
tinsert(ThunderUI.modules, module) -- finish him!