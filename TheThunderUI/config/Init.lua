----------------------------------------------------------------------------------------
-- Ingame config and modules system by Fernir
----------------------------------------------------------------------------------------

addonName, ns = ...

local media = "Interface\\Addons\\"..addonName.."\\media\\"
local _, playerclass = UnitClass("player")
local settingsChanged = false

DefaultSettings = {
	firstStart = true,

	["Main"] = {
		["Font"] = media.."font.ttf",
		["FontSize"] = 11,
		["AutoUIScale"] = true,
		["UIScale"] = 0.75,
		["BlankText"] = media.."WHITE64X64",
		["BarText"] = media.."bartex1",
		["ShadowText"] = media.."glowTex",
		["bubbleTex"] = media.."bubbleTex",
		["Background color"] = {.05, .05, .05, 1},
		["Border color"] = {.3, .3, .3, 1},
	},

	["ActionBars"] = {
		["TestMode"] = false,
		["InvertBars"] = true,
		["ThirdPanel"] = false,
		["Bar123_X"] = -1,
		["Bar123_Y"] = 26,
		["Bar3_X"] = -304,
		["Bar3_Y"] = 26,
		["Bar4_X"] = -10,
		["Bar4_Y"] = 0,
		["BarTotem_X"] = -1,
		["BarTotem_Y"] = 124,
		["BarPet_X"] = -1,
		["BarPet_Y"] = 102,
		["BarClass_X"] = 10,
		["BarClass_Y"] = -10,
		["BarExit_X"] = 185,
		["BarExit_Y"] = 132,
		["ButtonSize"] = 28,
		["ClassButtonSize"] = 28,
		["Offset"] = 4,
		["RightBars"] = 2,
		["MouseoverRight"] = false,
		["MouseoverClassBar"] = false,
		["HideClassBar"] = false,
		["MouseoverPet"] = false,
	},

	["ButtonStyler"] = {
		["ButtonFont"] = media.."font.ttf",
		["ButtonFontSize"] = 10,
		["HideHotkey"] = false,
		["HighlightText"] = media.."Highlight",
		["PushedText"] = media.."Pushed",
		["CheckedText"] = media.."Checked",
	},

	["Chat"] = {
		["ChatFont"] = media.."font.ttf",
		["CopyURL"] = true,
		["CopyChat"] = true,
		["ChatWidth"] = 348,
		["ChatHeight"] = 130,
	},

	["LitePanels"] = {
		["RightPanelWidth"] = 348,
		["RightPanelHeight"] = 130,
	},

	["Tooltips"] = {
		["CursorAnchor"] = false,
		["HideInCombat"] = false,
		["HideUnitFramesTooltip"] = false,
		["HideActionBarsTooltip"] = false,
		["ShowPlayerTitles"] = true,
	},

	["Datatext"] = {
		["DataFont"] = media.."font.ttf",
		["DataFontSize"] = 10,
		["localtime"] = true,
		["time24"] = true,
		["fps_ms"] = 5,
		["mem"] = 6,
		["armor"] = 4,
		["gold"] = 7,
		["wowtime"] = 1,
		["friends"] = 3,
		["guild"] = 2,
		["bags"] = 8,
	},

	["Buffs"] = {
		["BuffSize"] = 28,
		["BuffsPerRow"] = 16,
		["BuffFont"] = media.."font.ttf",
		["BuffFontSize"] = 11,
		["DurationOffset"] = -11,
		["BuffOffset"] = 4,
	},

	["Loot"] = {
		["LootFontSize"] = 11,
		["LootFont"] = media.."font.ttf",
	},

	["Lootroll"] = {
		["Roll X"] = 340, -- ThunderDB["Lootroll"]["Roll X"]
		["Roll Y"] = -180, -- ThunderDB["Lootroll"]["Roll Y"]
		["BoE color"] =  {1, 0.8, 0.8, 1},
	},

	["Cooldown"] = {
		["CCFont"] = media.."font.ttf",
		["CCFontSize"] = 18,
	},

	["Tweaker"] = {
		["HideErrors"] = true,
		["DeclineDuels"] = false,
		["AcceptPartyInvite"] = false,
		["GrabMail"] = true,
		["MobMarking"] = true,
		["AutoMerchant"] = true,
	},

	["Nameplates"] = {
		["NameplatesFont"] = media.."font.ttf",
		["NameplatesFontSize"] = 9,
	},

	["UnitFrames"] = {
		["ClassColors"] = true,
		["InvertClassColors"] = true,
		["FramesFont"] = media.."font.ttf",
		["AuraFontSize"] = 9,
		["FrameFontSize"] = 10,
		["ClassBars"] = true,
		["WidthA"] = 192,
		["WidthB"] = 110,
		["WidthC"] = 100,
		["Height"] = 20,
		["MouseFocusScript"] = true,
		["Portrait"] = true,
		["Castbars"] = true,
		["CastbarIcon"] = true,
		["LatencyShow"] = true,
		["PVPflag"] = false,
		["Auras"] = true,
		["AuraSize"] = 22,
		["Debuffs"] = true,
		["TopAuras"] = true,
		["AuraLimit"] = 8,
		["CompactTargetAuras"] = true,
		["OnlyShowPlayer"] = false,
		["TargerTargetDebuffs"] = false,
		["UiContrast"] = 0.15,
		["HideParty"] = true,
	},

	["UnitFramesRaid"] = {
		["KillBlizzRaid"] = true,
		["HealModePosition"] = false,
		["GridWidth"] = 60,
		["GridHeight"] = 38,
		["GridOffset"] = 3,
		["Point"] = "TOP",
		["Growth"] = "RIGHT",
		["Orientation"] = "HORIZONTAL",
		["RaidPower"] = true,
		["PowerbarSize"] = 0.06,
		["IconSize"] = 11,
		["DebuffSize"] = 18,
		["ShowLFDRole"] = false,
		["FramesFont"] = media.."font.ttf",
		["FrameFontSize"] = 10,
		["ShowHealDif"] = true,
		["GridParty"] = 5,
		["ShowPets"] = false,
		["ShowMT"] = false,
		["FreqUpdate"] = 0.5,
	},
}

local SetSkada = function()
	if(SkadaDB) then table.wipe(SkadaDB) end

SkadaDB = {
	["profiles"] = {
		["Default"] = {
			["icon"] = {
				["hide"] = true,
			},
		},
	},
}
end

local function setupVars()
	SetCVar("scriptErrors", 0)
	SetCVar("buffDurations", 1)
	SetCVar("consolidateBuffs", 0)
	SetCVar("autoLootDefault", 1)
	SetCVar("lootUnderMouse", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("mapQuestDifficulty", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyPets", 0)
	SetCVar("nameplateShowFriendlyGuardians", 0)
	SetCVar("nameplateShowFriendlyTotems", 0)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowEnemyPets", 0)
	SetCVar("nameplateShowEnemyGuardians", 0)
	SetCVar("nameplateShowEnemyTotems", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("bloattest", 0)
--	SetCVar("bloatnameplates", 0.0)
	SetCVar("spreadnameplates", 0)
	SetCVar("bloatthreat", 0)
	SetCVar("screenshotQuality", 8)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("chatMouseScroll", 1)
--	SetCVar("showTimestamps", "none")
	SetCVar("chatStyle", "classic")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
--	SetCVar("CombatDamage", 1)
--	SetCVar("CombatHealing", 1)
	SetCVar("showTutorials", 0)
	SetCVar("showNewbieTips", 0)
--	SetCVar("Maxfps", 120)
	SetCVar("autoDismountFlying", 1)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoQuestProgress", 1)
	SetCVar("showLootSpam", 1)
	SetCVar("guildMemberNotify", 1)
	SetCVar("chatBubblesParty", 1)
	SetCVar("chatBubbles", 1)
	SetCVar("UnitNameOwn", 0)
	SetCVar("UnitNameNPC", 1)
	SetCVar("UnitNameNonCombatCreatureName", 1)
	SetCVar("UnitNamePlayerGuild", 1)
	SetCVar("UnitNamePlayerPVPTitle", 1)
	SetCVar("UnitNameFriendlyPlayerName", 1)
	SetCVar("UnitNameFriendlyPetName", 1)
	SetCVar("UnitNameFriendlyGuardianName", 1)
	SetCVar("UnitNameFriendlyTotemName", 1)
	SetCVar("UnitNameEnemyPlayerName", 1)
	SetCVar("UnitNameEnemyPetName", 1)
	SetCVar("UnitNameEnemyGuardianName", 1)
	SetCVar("UnitNameEnemyTotemName", 1)

	SetSkada();
end

local function SetValue(group, option, value, parent)
	if parent then
		ThunderDB[parent][group][option] = value
		settingsChanged = true
	else
		ThunderDB[group][option] = value
		settingsChanged = true
	end
end

local NewButton = function(text,parent)
	local result = CreateFrame("Button", "btn_"..parent:GetName(), parent, "UIPanelButtonTemplate")
	result:SetText(text)
	return result
end

parseOptions = function(mainframe, group, opt, parent)
	if not opt then return end

	local scrollf = CreateFrame("ScrollFrame", "interface_scrollf"..group, mainframe, "UIPanelScrollFrameTemplate")
	local frame = CreateFrame("frame", group, scrollf)
	scrollf:SetScrollChild(frame)
	scrollf:SetPoint("TOPLEFT", mainframe, "TOPLEFT", 20, -40)
	scrollf:SetPoint("BOTTOMRIGHT", mainframe, "BOTTOMRIGHT", -40, 45)
	frame:SetPoint("TOPLEFT")
	frame:SetWidth(130)
	frame:SetHeight(130)

	local offset=5
	local tmparr = {}
	for option, value in pairs(opt) do
		table.insert(tmparr, { ["option"] = option, ["value"] = value })
	end
	table.sort(tmparr, function(a,b) return tostring(a.option) < tostring(b.option) end)

	for index, array in ipairs(tmparr) do
		local option, value = array.option, array.value
		if type(value) == "boolean" then
			local button = CreateFrame("CheckButton", "config_"..option, frame, "InterfaceOptionsCheckButtonTemplate")
			_G["config_"..option.."Text"]:SetText(option)
			_G["config_"..option.."Text"]:SetFontObject("GameFontNormal")
			button:SetChecked(value)
			button:SetScript("OnClick", function(self) SetValue(group,option,(self:GetChecked() and true or false), parent); _G[self:GetName().."Text"]:SetTextColor(.1,1,.1); end)
			button:SetPoint("TOPLEFT", 15, -(offset))
			offset = offset+25
		elseif type(value) == "number" or type(value) == "string" and not value:find("function") then
			local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			label:SetText(option)
			label:SetWidth(220)
			label:SetHeight(20)
			label:SetJustifyH("LEFT")
			label:SetPoint("TOPLEFT", 15, -(offset))

			local editbox = CreateFrame("EditBox", "editbox_"..option, frame)
			editbox:SetAutoFocus(false)
			editbox:SetMultiLine(false)
			editbox:SetWidth(220)
			editbox:SetHeight(20)
			editbox:SetMaxLetters(255)
			editbox:SetTextInsets(3,0,0,0)
			editbox:SetJustifyH("LEFT")
			editbox:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8x8",
				tiled = false,
			})
			editbox:SetBackdropColor(0,0,0,0.5)
			editbox:SetBackdropBorderColor(0,0,0,1)
			editbox:SetFontObject("GameFontHighlight")
			editbox:SetPoint("TOPLEFT", 15, -(offset+20))
			editbox:SetText(value)

			local save = CreateFrame("button", option.."SaveButton", frame)
			save:SetNormalTexture("Interface\\Buttons\\UI-Panel-SmallerButton-Up")
			save:SetPushedTexture("Interface\\Buttons\\UI-Panel-SmallerButton-Down")
			save:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
			save:SetWidth(32)
			save:SetHeight(32)
			save:SetPoint("LEFT", editbox, "RIGHT", 5, 0)
			save:SetScript("OnClick", function(self)
				editbox:ClearFocus()
				editbox:SetBackdropBorderColor(.2,1,.2)
				if type(value) == "number" then
					SetValue(group,option,tonumber(editbox:GetText()), parent)
				else
					SetValue(group,option,tostring(editbox:GetText()), parent)
				end
			end)

			offset = offset+45
		elseif type(value) == "table" then
			if table.getn(value) <= 4 and type(value[1]) == "number" and value[1] <= 1 and value[2] <= 1 and value[3] <= 1 then
				local label = frame:CreateFontString(nil,"OVERLAY", "GameFontNormal")
				label:SetText(option)
				label:SetWidth(220)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")

				local but = CreateFrame("Button", "btnt_"..option, frame)
				but:SetWidth(20)
				but:SetHeight(20)
				but:SetPoint("TOPLEFT", 15, -(offset))

				label:SetPoint("LEFT", but, "RIGHT", 5, 0)

				but.tex = but:CreateTexture(nil)
				but.tex:SetTexture(value[1], value[2], value[3], value[4] or 1)
				but.tex:SetPoint("TOPLEFT", 2, -2)
				but.tex:SetPoint("BOTTOMRIGHT", -2, 2)
				offset = offset+25

				but:SetScript("OnClick", function(self)
					self = self.tex

					local function ColorCallback(self,r,g,b,a,isAlpha)
						but.tex:SetTexture(r, g, b, a)

						if ColorPickerFrame:IsVisible() then
							--colorpicker is still open
						else
							--colorpicker is closed, color callback is first, ignore it,
							--alpha callback is the final call after it closes so confirm now
							if isAlpha then
								value = {r, g, b, a}
								if parent then
									ThunderDB[parent][group][option] = {r, g, b, a}
								else
									ThunderDB[group][option] = {r, g, b, a}
								end
								but:SetBackdropBorderColor(.1, 1, .1)
							end
						end
					end

					HideUIPanel(ColorPickerFrame)
					ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")

					ColorPickerFrame.func = function()
						local r,g,b = ColorPickerFrame:GetColorRGB()
						local a = 1 - OpacitySliderFrame:GetValue()
						ColorCallback(self,r,g,b,a, true)
					end

					ColorPickerFrame.hasOpacity = value[4] or false
					ColorPickerFrame.opacityFunc = function()
						local r,g,b = ColorPickerFrame:GetColorRGB()
						local a = 1 - OpacitySliderFrame:GetValue()
						ColorCallback(self,r,g,b,a,true)
					end

					local r, g, b, a = value[1], value[2], value[3], value[4]
					ColorPickerFrame.opacity = 1 - (a or 0)
					ColorPickerFrame:SetColorRGB(r, g, b)

					ColorPickerFrame.cancelFunc = function()
						ColorCallback(self,r,g,b,a,true)
					end
					ShowUIPanel(ColorPickerFrame)
				end)
			end
		elseif type(value) == "string" and value:find("function") then
			local button = NewButton(option, frame)
			button:SetHeight(20)
			button:SetWidth(90)
			local func = value:gsub("function(.+)", "%1")
			button:SetScript("OnClick", function(self) RunScript(func) end)
			button:SetPoint("TOPLEFT", 15, -(offset))
			offset = offset+25
		end
	end

   frame:SetHeight(offset)
	mainframe:Hide()
end


local LaunchMain = function(ThunderDB)

----------------------------------------------------------------------------------------
-- Disable blizz menu scale
----------------------------------------------------------------------------------------

Advanced_UseUIScale:Hide()
Advanced_UIScaleSlider:Hide()

----------------------------------------------------------------------------------------
-- Auto scale if enable
----------------------------------------------------------------------------------------

if ThunderDB["Main"]["AutoUIScale"] == true then
	ThunderDB["Main"]["UIScale"] = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
end

----------------------------------------------------------------------------------------
-- Pixel size
----------------------------------------------------------------------------------------

local fixx = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/ThunderDB["Main"]["UIScale"]
function fixscale(x)
    return fixx*math.floor(x/fixx+.5)
end

----------------------------------------------------------------------------------------
-- Set Scale
----------------------------------------------------------------------------------------

local scalefix = CreateFrame("Frame")
scalefix:RegisterEvent("PLAYER_LOGIN")
scalefix:SetScript("OnEvent", function()
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", ThunderDB["Main"]["UIScale"])
end)

----------------------------------------------------------------------------------------
-- Border and Background function
----------------------------------------------------------------------------------------

function SetTemplate(f)
	f:SetBackdrop({
		bgFile = ThunderDB["Main"]["BlankText"],
		edgeFile = ThunderDB["Main"]["BlankText"],
		tile = false, tileSize = 0, edgeSize = fixscale(1),
		insets = {left = fixscale(-1), right = fixscale(-1), top = fixscale(-1), bottom = fixscale(-1)}
	})
	f:SetBackdropColor(unpack(ThunderDB["Main"]["Background color"]))
	f:SetBackdropBorderColor(unpack(ThunderDB["Main"]["Border color"]))
end

----------------------------------------------------------------------------------------
-- Option check
----------------------------------------------------------------------------------------

if ThunderDB["UnitFramesRaid"]["PowerbarSize"] > 0.1 then
	ThunderDB["UnitFramesRaid"]["PowerbarSize"] = 0.1
elseif ThunderDB["UnitFramesRaid"]["PowerbarSize"] < 0.0000001 then
	ThunderDB["UnitFramesRaid"]["PowerbarSize"] = 0.0000001
end

end

StaticPopupDialogs["INSTALL"] = {
	text = "Thunder UI Install.|nNeed to reload ui for save all settings.|n In future you can change settings in |cffaaaaff\"Settings - Interface - Addons - Thunder UI\"|r by press a key |cffaaffaa\"Save\"|r",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ThunderDB.firstStart = false; setupVars(); ReloadUI(); end,
	OnCancel = function() ThunderDB.firstStart = true end,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["SAVEOPTS"] = {
	text = "Settings changed.|nReload UI?",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ReloadUI(); end,
	OnCancel = function() end,
	timeout = 0,
	whileDead = 1,
}


ThunderUI = CreateFrame("frame", "ThunderUI", UIParent)
ThunderUI.modules = {}
ThunderUI:RegisterEvent("VARIABLES_LOADED")
ThunderUI:SetScript("OnEvent", function()
	if not ThunderDB or ThunderDB.firstStart then
		 StaticPopup_Show("INSTALL")
	end
   ThunderDB = ThunderDB or DefaultSettings

	for k,v in pairs(DefaultSettings) do
		if ThunderDB[k] == nil then
			ThunderDB[k] = v
			if type(v) == "table" then
				for n,m in pairs(v) do
					if ThunderDB[k][n] == nil then
						ThunderDB[k][n] = m
						print("|cffaaffaaRestored|r "..k.." |cffaaffaaoption."..n.."|r value")
					end
				end
			end
			print("|cffaaffaaRestored|r "..k.." |cffaaffaaoption|r")
		end
	end

	InterfaceOptionsFrameOkay:HookScript("OnClick", function()
		if settingsChanged then
			StaticPopup_Show("SAVEOPTS")
		end
	end)

   if not ThunderDB.modules then ThunderDB.modules = {} end
   ThunderUI.main = CreateFrame("frame", "|cff9DC7CCThe Thunder UI|r", InterfaceOptionsFramePanelContainer)
   ThunderUI.main.name = "|cff9DC7CCThe Thunder UI|r"
   InterfaceOptions_AddCategory(ThunderUI.main)

	parseOptions(ThunderUI.main, "Main", ThunderDB["Main"])

	LaunchMain(ThunderDB)

	local resetm = NewButton("|cffff0000Reset All|r", ThunderUI.main)
	resetm:SetWidth(90)
	resetm:SetHeight(20)
	resetm:SetPoint("BOTTOMLEFT",10, 10)
	resetm:SetScript("OnClick", function(self) ThunderDB = nil ReloadUI() end)

	local savem = NewButton("Save", ThunderUI.main)
	savem:SetWidth(90)
	savem:SetHeight(20)
	savem:SetPoint("BOTTOMRIGHT", -10, 10)
	savem:SetScript("OnClick", function(self) ReloadUI() end)

	table.sort(ThunderUI.modules, function(a,b) return a.name < b.name end)
	for i, module in pairs(ThunderUI.modules) do
	if ThunderDB.modules[module.name] == nil then ThunderDB.modules[module.name] = true end

		local childpanel = CreateFrame("frame", module.name, InterfaceOptionsFramePanelContainer)
		childpanel.name = module.name
		childpanel.parent = ThunderUI.main.name

		local label = childpanel:CreateFontString(nil,"OVERLAY", "GameFontNormal")
		label:SetText(module.name)
		label:SetWidth(220)
		label:SetHeight(20)
		label:SetPoint("TOP", 0, -10)

		local checkbox = CreateFrame("CheckButton", "cb_module"..module.name, childpanel, "InterfaceOptionsCheckButtonTemplate")
		if ThunderDB.modules[module.name] then
			_G["cb_module"..module.name.."Text"]:SetText("|cff00ff00Enable|r")
		else
			_G["cb_module"..module.name.."Text"]:SetText("|cffff0000Enable|r")
		end
		_G["cb_module"..module.name.."Text"]:SetFontObject("GameFontNormal")
		checkbox:SetChecked(ThunderDB.modules[module.name])
		checkbox:SetScript("OnClick", function()
			ThunderDB.modules[module.name] = not ThunderDB.modules[module.name]
			if ThunderDB.modules[module.name] then
				_G["cb_module"..module.name.."Text"]:SetText("|cff00ff00Enable|r")
			else
				_G["cb_module"..module.name.."Text"]:SetText("|cffff0000Enable|r")
			end
		end)
		checkbox:SetPoint("TOPLEFT", childpanel, 20, -20)

		InterfaceOptions_AddCategory(childpanel)

		local reset = NewButton("Reset module options", childpanel)
		reset:SetWidth(140)
		reset:SetHeight(20)
		reset:SetPoint("BOTTOMLEFT",10, 10)
		reset:SetScript("OnClick", function(self) ThunderDB[module.name] = nil ReloadUI() end)

		local save = NewButton("Save", childpanel)
		save:SetWidth(90)
		save:SetHeight(20)
		save:SetPoint("BOTTOMRIGHT", -10, 10)
		save:SetScript("OnClick", function(self) ReloadUI() end)

		module.Init()

		parseOptions(childpanel, module.name, ThunderDB[module.name])
   end

   print("|cff9DC7CCThe Thunder UI v 5.0|r "..lc_welcome)

   ThunderUI:UnregisterEvent("VARIABLES_LOADED")
   ThunderUI:SetScript("OnEvent", nil)
end)