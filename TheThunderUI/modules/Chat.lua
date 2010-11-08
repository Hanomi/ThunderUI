----------------------------------------------------------------------------------------
-- Based on idChat
-- credits Industrial, Tukz, Shestak
----------------------------------------------------------------------------------------

local module = {}
module.name = l_chat
module.Init = function()
	if not ThunderDB.modules[module.name] then return end
	local settings = ThunderDB

local AddOn = CreateFrame("Frame")
local OnEvent = function(self, event, ...) self[event](self, event, ...) end
AddOn:SetScript("OnEvent", OnEvent)

local replace = string.gsub
local find = string.find
local _G = _G

local replaceschan = {
	['Гильдия'] = '[Г]',
	['Группа'] = '[Гр]',
	['Рейд'] = '[Р]',
	['Лидер рейда'] = '[ЛР]',
	['Объявление рейду'] = '[ОР]',
	['Офицер'] = '[О]',
	['Поле боя'] = '[ПБ]',
	['Лидер поля боя'] = '[ЛПБ]',
	['Прохождение подземелий'] = "[ЛГр]",
	["Лидер группы"] = "[ЛГр]",	
	["Лидер"] = "[ЛГр]",
	['Guilde'] = '[G]',
	['Groupe'] = '[GR]',
	['Chef de raid'] = '[RL]',
	['Avertissement Raid'] = '[AR]',
	['Officier'] = '[O]',
	['Champs de bataille'] = '[CB]',
	['Chef de bataille'] = '[CDB]',
	['Guild'] = '[G]',
	['Party'] = '[P]',
	['Party Leader'] = '[PL]',
	['Raid'] = '[R]',
	['Raid Leader'] = '[RL]',
	['Raid Warning'] = '[RW]',
	['Officer'] = '[O]',
	['Battleground'] = '[B]',
	['Battleground Leader'] = '[BL]',
	['(%d+)%. .-'] = '[%1]',
}

CHAT_FLAG_AFK = "[AFK] "
CHAT_FLAG_DND = "[DND] "
CHAT_FLAG_GM = "[GM] "

for i = 1, 10 do
	local x=({_G["ChatFrame"..i.."EditBox"]:GetRegions()})
	x[9]:SetAlpha(0)
	x[10]:SetAlpha(0)
	x[11]:SetAlpha(0)
end

FriendsMicroButton:SetScript("OnShow", FriendsMicroButton.Hide)
FriendsMicroButton:Hide()

GeneralDockManagerOverflowButton:SetScript("OnShow", GeneralDockManagerOverflowButton.Hide)
GeneralDockManagerOverflowButton:Hide()

--hide some chat option, it's fixed in core.lua
--InterfaceOptionsSocialPanelChatStyle:Hide()
--InterfaceOptionsSocialPanelConversationMode:Hide()

-- Player entering the world
local function PLAYER_ENTERING_WORLD()
	ChatFrameMenuButton:SetAlpha(0)
	ChatFrameMenuButton:SetScale(0.8)
	ChatFrameMenuButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -6, 100)
	ChatFrameMenuButton:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
	ChatFrameMenuButton:HookScript("OnLeave", function(self) self:SetAlpha(0) end)
	
	--edit all chat windows
	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame"..i]:SetClampRectInsets(0,0,0,0)
		_G["ChatFrame"..i]:SetWidth(ThunderDB[l_chat][l_cwidth]-5)
		_G["ChatFrame"..i]:SetHeight(ThunderDB[l_chat][l_cheight]-3)	

		_G["ChatFrame"..i]:SetClampedToScreen(false)
	
		-- Hide chat buttons
		_G["ChatFrame"..i.."ButtonFrameUpButton"]:Hide()
		_G["ChatFrame"..i.."ButtonFrameDownButton"]:Hide()
		_G["ChatFrame"..i.."ButtonFrameBottomButton"]:Hide()
		_G["ChatFrame"..i.."ButtonFrameMinimizeButton"]:Hide()
		_G["ChatFrame"..i.."ResizeButton"]:Hide()
		_G["ChatFrame"..i.."ButtonFrame"]:Hide()

		_G["ChatFrame"..i.."ButtonFrameUpButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."ButtonFrameDownButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."ButtonFrameBottomButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."ButtonFrameMinimizeButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."ResizeButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."ButtonFrame"]:SetScript("OnShow", function(self) self:Hide() end)
		
		-- Hide chat textures backdrop
		for j = 1, #CHAT_FRAME_TEXTURES do
			_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
		end

		-- Stop the chat frame from fading out
		_G["ChatFrame"..i]:SetFading(false)
		
		-- Change the chat frame font
		local id = _G["ChatFrame"..i]:GetID()
		local _, fontSize = FCF_GetChatWindowInfo(id)

		_G["ChatFrame"..i]:SetFont(ThunderDB[l_chat][l_cfont], fontSize or 11)
		
		_G["ChatFrame"..i]:SetFrameStrata("LOW")
		_G["ChatFrame"..i]:SetMovable(true)
		_G["ChatFrame"..i]:SetUserPlaced(true)
		
		-- Texture and align the chat edit box
		local editbox = _G["ChatFrame"..i.."EditBox"]
		local left, mid, right = select(6, editbox:GetRegions())
		left:Hide(); mid:Hide(); right:Hide()
		editbox:ClearAllPoints();
		editbox:SetPoint("TOPLEFT", ChatFrame1, "TOPLEFT", -10, 42)
		editbox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 10, 22)			
		
		-- Disable alt key usage
		editbox:SetAltArrowKeyMode(false)		
	end
	
	--Remember last channel
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
	ChatTypeInfo.SAY.sticky = 1
	ChatTypeInfo.EMOTE.sticky = 1
	ChatTypeInfo.YELL.sticky = 1
	ChatTypeInfo.PARTY.sticky = 1
	ChatTypeInfo.GUILD.sticky = 1
	ChatTypeInfo.RAID.sticky = 1
	ChatTypeInfo.BATTLEGROUND.sticky = 1
	
	-- Position the general chat frame
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 20, 25)
end

AddOn:RegisterEvent("PLAYER_ENTERING_WORLD")
AddOn["PLAYER_ENTERING_WORLD"] = PLAYER_ENTERING_WORLD

-- Hook into the AddMessage function
local function AddMessageHook(frame, text, ...)
	-- chan text smaller or hidden
	for k,v in pairs(replaceschan) do
		text = text:gsub('|h%['..k..'%]|h', '|h'..v..'|h')
	end
	text = replace(text, "has come online.", "is now |cff298F00online|r !")
	text = replace(text, "|Hplayer:(.+)|h%[(.+)%]|h has earned", "|Hplayer:%1|h%2|h has earned")
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h whispers:", "From [|Hplayer:%1:%2|h%3|h]:")
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h says:", "[|Hplayer:%1:%2|h%3|h]:")	
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h yells:", "[|Hplayer:%1:%2|h%3|h]:")
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h говорит:", "[|Hplayer:%1:%2|h%3|h]:")
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h кричит:", "[|Hplayer:%1:%2|h%3|h]:")
	text = replace(text, "|Hplayer:(.+)|h%[(.+)%]|h заслужил достижение", "|Hplayer:%1|h%2|h заслужил достижение")
	text = replace(text, "|Hplayer:(.+)|h%[(.+)%]|h заслужила достижение", "|Hplayer:%1|h%2|h заслужила достижение")
	return AddMessageOriginal(frame, text, ...)
end

function ChannelsEdits()
	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local frame = _G["ChatFrame"..i]
			AddMessageOriginal = frame.AddMessage
			frame.AddMessage = AddMessageHook
		end
	end
end
ChannelsEdits()

-----------------------------------------------------------------------------
-- Copy URL
-----------------------------------------------------------------------------
if ThunderDB[l_chat][l_curl] then
local color = "8A9DDE"
local pattern = "[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]"

function string.color(text, color)
	return "|cff"..color..text.."|r"
end

function string.link(text, type, value, color)
	return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
end

StaticPopupDialogs["LINKME"] = {
	text = "URL COPY",
	button2 = CANCEL,
	hasEditBox = true,
    editBoxWidth = 400,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

local function f(url)
	return string.link("["..url.."]", "url", url, color)
end

local function hook(self, text, ...)
	self:f(text:gsub(pattern, f), ...)
end

for i = 1, NUM_CHAT_WINDOWS do
	if ( i ~= 2 ) then
		local lframe = _G["ChatFrame"..i]
		lframe.f = lframe.AddMessage
		lframe.AddMessage = hook
	end
end

local ur = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(self, link, text, button)
	local type, value = link:match("(%a+):(.+)")
	if ( type == "url" ) then
		local dialog = StaticPopup_Show("LINKME")
		local editbox1 = _G[dialog:GetName().."EditBox"]  
		editbox1:SetText(value)
		editbox1:SetFocus()
		editbox1:HighlightText()
		local button = _G[dialog:GetName().."Button2"]
            
		button:ClearAllPoints()
           
		button:SetPoint("CENTER", editbox1, "CENTER", 0, -30)
	else
		ur(self, link, text, button)
	end
end
end

-----------------------------------------------------------------------------
-- Copy Chat (by Shestak)
-----------------------------------------------------------------------------
if ThunderDB[l_chat][l_ccopy] then
local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	frame:SetBackdrop({
			bgFile = ThunderDB[l_main][l_blank], 
			edgeFile = ThunderDB[l_main][l_blank], 
			tile = 0, tileSize = 0, edgeSize = 1, 
			insets = { left = -1, right = -1, top = -1, bottom = -1 }
	})
	frame:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
	frame:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor])) 
	frame:SetWidth(500)
	frame:SetHeight(300)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(500)
	editBox:SetHeight(300)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

	isf = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	frame:Show()
	editBox:SetText(text)
	editBox:HighlightText(0)
end

function ChatCopyButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]
		local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
		button:SetPoint("BOTTOMLEFT", -26, -27)
		button:SetHeight(24)
		button:SetWidth(24)
		button:SetAlpha(0)
		button:SetNormalTexture("Interface\\Chatframe\\UI-ChatIcon-ScrollUp-Up")
		button:SetScript("OnClick", function() Copy(cf) end)
		button:SetScript("OnEnter", function() 
			button:SetAlpha(1) 
		end)
		button:SetScript("OnLeave", function() button:SetAlpha(0) end)
		
		local tab = _G[format("ChatFrame%dTab", i)]
		tab:SetScript("OnShow", function() button:Show() end)
		tab:SetScript("OnHide", function() button:Hide() end)
	end
end
ChatCopyButtons()

end

local ScrollLines = 3 -- set the jump when a scroll is done !
function FloatingChatFrame_OnMouseScroll(self, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i = 1, ScrollLines do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i = 1, ScrollLines do
				self:ScrollUp()
			end
		end
	end
end

--Tempwindows skin function by Tukz
function TempChatSkin()
	local chatFrame, chatTab, conversationIcon
	for _, chatFrameName in pairs(CHAT_FRAMES) do
		local frame = _G[chatFrameName]
		if frame.isTemporary then
				chatFrame = frame
				chatTab = _G[chatFrame:GetName().."Tab"]
				
				chatTab.noMouseAlpha = 0
				
				_G[chatFrame:GetName()]:SetClampRectInsets(0,0,0,0)
				_G[chatFrame:GetName()]:SetWidth(ThunderDB[l_chat][l_cwidth]-5)
				_G[chatFrame:GetName()]:SetHeight(ThunderDB[l_chat][l_cheight]-3)	
				_G[chatFrame:GetName()]:ClearAllPoints()
				_G[chatFrame:GetName()]:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 20, 25)

				_G[chatFrame:GetName()]:SetClampedToScreen(false)
				
				_G[chatFrame:GetName().."ButtonFrameUpButton"]:Hide()
				_G[chatFrame:GetName().."ButtonFrameDownButton"]:Hide()
				_G[chatFrame:GetName().."ButtonFrameBottomButton"]:Hide()
				_G[chatFrame:GetName().."ButtonFrameMinimizeButton"]:Hide()
				_G[chatFrame:GetName().."ResizeButton"]:Hide()

				_G[chatFrame:GetName().."ButtonFrameUpButton"]:SetScript("OnShow", function(self) self:Hide() end)
				_G[chatFrame:GetName().."ButtonFrameDownButton"]:SetScript("OnShow", function(self) self:Hide() end)
				_G[chatFrame:GetName().."ButtonFrameBottomButton"]:SetScript("OnShow", function(self) self:Hide() end)
				_G[chatFrame:GetName().."ButtonFrameMinimizeButton"]:SetScript("OnShow", function(self) self:Hide() end)
				_G[chatFrame:GetName().."ResizeButton"]:SetScript("OnShow", function(self) self:Hide() end)
				_G[chatFrame:GetName().."ButtonFrame"]:SetScript("OnShow", function(self) self:SetScale(0.8) end)

				_G[chatFrame:GetName().."TabLeft"]:SetTexture(nil)
				_G[chatFrame:GetName().."TabMiddle"]:SetTexture(nil)
				_G[chatFrame:GetName().."TabRight"]:SetTexture(nil)
				
				_G[chatFrame:GetName().."TabSelectedLeft"]:SetTexture(nil)
				_G[chatFrame:GetName().."TabSelectedMiddle"]:SetTexture(nil)
				_G[chatFrame:GetName().."TabSelectedRight"]:SetTexture(nil)
				
				_G[chatFrame:GetName().."TabHighlightLeft"]:SetTexture(nil)
				_G[chatFrame:GetName().."TabHighlightMiddle"]:SetTexture(nil)
				_G[chatFrame:GetName().."TabHighlightRight"]:SetTexture(nil)

				-- Stop the chat frame from fading out
				_G[chatFrame:GetName()]:SetFading(false)
				
				-- Change the chat frame font
				local id = _G[chatFrame:GetName()]:GetID()
				local _, fontSize = FCF_GetChatWindowInfo(id)

				_G[chatFrame:GetName()]:SetFont(ThunderDB[l_chat][l_cfont], fontSize or 11)
				
				-- Set random stuff
				_G[chatFrame:GetName()]:SetFrameStrata("LOW")
				_G[chatFrame:GetName()]:SetMovable(true)
				_G[chatFrame:GetName()]:SetUserPlaced(true)
				
				-- Hide tab texture
				for j = 1, #CHAT_FRAME_TEXTURES do
					_G[chatFrame:GetName()..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
				end
				break

		end
	end
end
hooksecurefunc("FCF_OpenTemporaryWindow", TempChatSkin)

--[[
	Fane
	
	All credits of this chattabs script is by Fane and his author Haste.
	

	Copyright (c) 2007-2010 Trond A Ekseth

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
--]]

local Fane = CreateFrame'Frame'
local inherit = GameFontNormalSmall

local updateFS = function(self, inc, flags, ...)
	local fstring = self:GetFontString()

	local font, fontSize = inherit:GetFont()
	if(inc) then
		fstring:SetFont(font, fontSize + 1, flags)
	else
		fstring:SetFont(font, fontSize, flags)
	end

	if((...)) then
		fstring:SetTextColor(...)
	end
end

local OnEnter = function(self)
	local emphasis = _G["ChatFrame"..self:GetID()..'TabFlash']:IsShown()
	updateFS(self, emphasis, nil, 1, 1, 1, 1)
end

local OnLeave = function(self)
	local r, g, b, al
	local id = self:GetID()
	local emphasis = _G["ChatFrame"..id..'TabFlash']:IsShown()

	if (_G["ChatFrame"..id] == SELECTED_CHAT_FRAME) then
		r, g, b, al = 1, 0.7, 0.7, 0.5
	elseif emphasis then
		r, g, b, al = 1, 0, 0, 1
	else
		r, g, b, al = 1, 1, 1, 0.5
	end

	updateFS(self, emphasis, nil, r, g, b, al)
end

local ChatFrame2_SetAlpha = function(self, alpha)
	if(CombatLogQuickButtonFrame_Custom) then
		CombatLogQuickButtonFrame_Custom:SetAlpha(alpha)
	end
end

local ChatFrame2_GetAlpha = function(self)
	if(CombatLogQuickButtonFrame_Custom) then
		return CombatLogQuickButtonFrame_Custom:GetAlpha()
	end
end

local faneifyTab = function(frame, sel)
	local i = frame:GetID()

	if(not frame.Fane) then
		frame.leftTexture:Hide()
		frame.middleTexture:Hide()
		frame.rightTexture:Hide()

		frame.leftSelectedTexture:Hide()
		frame.middleSelectedTexture:Hide()
		frame.rightSelectedTexture:Hide()

		frame.leftSelectedTexture.Show = frame.leftSelectedTexture.Hide
		frame.middleSelectedTexture.Show = frame.middleSelectedTexture.Hide
		frame.rightSelectedTexture.Show = frame.rightSelectedTexture.Hide

		frame.leftHighlightTexture:Hide()
		frame.middleHighlightTexture:Hide()
		frame.rightHighlightTexture:Hide()

		frame:HookScript('OnEnter', OnEnter)
		frame:HookScript('OnLeave', OnLeave)

		frame:SetAlpha(1)

		if(i ~= 2) then
			-- Might not be the best solution, but we avoid hooking into the UIFrameFade
			-- system this way.
			frame.SetAlpha = UIFrameFadeRemoveFrame
		else
			frame.SetAlpha = ChatFrame2_SetAlpha
			frame.GetAlpha = ChatFrame2_GetAlpha

			-- We do this here as people might be using AddonLoader together with Fane.
			if(CombatLogQuickButtonFrame_Custom) then
				CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
			end
		end

		frame.Fane = true
	end

	-- We can't trust sel. :(
	if(i == SELECTED_CHAT_FRAME:GetID()) then
		updateFS(frame, nil, nil, 1, 0.7, 0.7, 0.5)
	else
		updateFS(frame, nil, nil, 1, 1, 1, 0.5)
	end
end

hooksecurefunc('FCF_StartAlertFlash', function(frame)
	local tab = _G['ChatFrame' .. frame:GetID() .. 'Tab']
	updateFS(tab, true, nil, 1, 0, 0)
end)

hooksecurefunc('FCFTab_UpdateColors', faneifyTab)

for i=1,7 do
	faneifyTab(_G['ChatFrame' .. i .. 'Tab'])
end

function Fane:ADDON_LOADED(event, addon)
	if(addon == 'Blizzard_CombatLog') then
		self:UnregisterEvent(event)
		self[event] = nil

		return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
	end
end
Fane:RegisterEvent'ADDON_LOADED'

Fane:SetScript('OnEvent', function(self, event, ...)
	return self[event](self, event, ...)
end)

end
tinsert(ThunderUI.modules, module) -- finish him!