----------------------------------------------------------------------------------------
-- Ingame config and modules system by Wildbreath(aka Fernir)
----------------------------------------------------------------------------------------

addonName, ns = ...

local media = "Interface\\Addons\\"..addonName.."\\media\\"
local _, playerclass = UnitClass("player")
local settingsChanged = false

DefaultSettings = {
	firstStart = true,

	[l_main] = {
		[l_font] = media.."font.ttf",
		[l_fontsize] = 11,
		[l_autoscale] = true,
		[l_scale] = 0.75,
		[l_blank] = media.."WHITE64X64",
		[l_bar] = media.."bartex1",
		[l_shadow] = media.."glowTex",
		[l_cp] = media.."bubbleTex",
		[l_bcolor] = {.05, .05, .05, 1},
		[l_bgcolor] = {.3, .3, .3, 1},
	},

	[l_ab] = {
		[l_abTestMode] = false,
		[l_abInvert] = true,
		[l_abThird] = false,
		[l_ab123x] = 0,
		[l_ab123y] = 26,
		[l_ab3x] = -304,
		[l_ab3y] = 26,
		[l_ab45x] = -10,
		[l_ab45y] = 0,
		[l_abVx] = 185,
		[l_abVy] = 132,
		[l_abBusize] = 28,
		[l_abSBusize] = 28,
		[l_abPBusize] = 28,
		[l_abOffset] = 4,
		[l_abRB] = 2,
		[l_abMR] = false,
		[l_abMS] = false,
		[l_abHS] = false,
		[l_abMP] = false,
	},

	[l_bstyler] = {
		[l_bsfont] = media.."font.ttf",
		[l_bsfontsize] = 10,
		[l_bshh] = false,
		[l_bsHighlight] = media.."Highlight",
		[l_bsPushed] = media.."Pushed",
		[l_bsChecked] = media.."Checked",
	},

	[l_chat] = {
		[l_cfont] = media.."font.ttf",
		[l_curl] = true,
		[l_ccopy] = true,
		[l_cwidth] = 348,
		[l_cheight] = 130,
	},

	[l_lpanels] = {
		[l_lpwidth] = 348,
		[l_lpheight] = 130,
	},

	[l_tooltips] = {
		[l_tcursor] = false,
		[l_thidecombat] = false,
		[l_thideuf] = false,
		[l_thideab] = false,
		[l_ttitles] = true,
	},

	[l_data] = {
		[l_dfont] = media.."font.ttf",
		[l_dfontsize] = 10,
		[l_dltime] = true,
		[l_d24time] = true,
		[l_dfpsms] = 5,
		[l_dmem] = 6,
		[l_darmor] = 4,
		[l_dgold] = 7,
		[l_dtime] = 1,
		[l_dfriends] = 3,
		[l_dguild] = 2,
		[l_dbags] = 8,
	},

	[l_mbuffs] = {
		[l_mBuffDebuffs] = false,
		[l_mBuffSize] = 28,
		[l_mDeBuffSize] = 28,
		[l_mBuffPerRow] = 16,
		[l_mFont] = media.."font.ttf",
		[l_mFontSize] = 11,
		[l_mTimeOffset] = -11,
		[l_mDebuffOffset] = -110,
		[l_mBuffOffset] = 4,
	},

	[l_loot] = {
		[l_lfontsize] = 11,
		[l_lfont] = media.."font.ttf",
	},

	[l_lroll] = {
		[l_lrX] = 340,
		[l_lrY] = -180,
		[l_lrcolorboe] =  {1, 0.8, 0.8, 1},
	},

	[l_cc] = {
		[l_cfont] = media.."font.ttf",
		[l_cfontsize] = 18,
	},

	[l_as] = {
		[l_asHE] = true,
		[l_asDD] = false,
		[l_asAPI] = false,
		[l_asmail] = true,
		[l_asmark] = true,
		[l_asmerch] = true,
	},

	[l_nameplates] = {
		[l_npfont] = media.."font.ttf",
		[l_npfontsize] = 9,
	},

	[l_uf] = {
		[l_ufcc] = true,
		[l_uficc] = true,
		[l_uffont] = media.."font.ttf",
		[l_uffsize] = 9,
		[l_ufufsize] = 10,
		[l_ufclbars] = true,
		[l_ufwA] = 192,
		[l_ufwB] = 110,
		[l_ufwC] = 100,
		[l_ufHA] = 20,
		[l_ufmfs] = true,
		[l_ufport] = true,
		[l_ufcast] = true,
		[l_ufcastmaxi] = false,
		[l_ufcastmaxiYpos] = 150,
		[l_ufcasticon] = true,
		[l_ufcastlatency] = true,
		[l_ufpvp] = false,
		[l_ufauras] = true,
		[l_ufausize] = 22,
		[l_ufdeb] = true,
		[l_ufautop] = true,
		[l_ufalim] = 8,
		[l_ufacta] = true,
		[l_ufospd] = false,
		[l_uftotd] = false,
		[l_ufuicont] = 0.15,
		[l_ufhideparty] = true,
	},

	[l_ufr] = {
		[l_ufrkblizz] = true,
		[l_ufrhealmode] = false,
		[l_ufrwidth] = 60,
		[l_ufrheight] = 38,
		[l_ufroffset] = 3,
		[l_ufrpoint] = "TOP",
		[l_ufrgrowth] = "RIGHT",
		[l_ufrorient] = "HORIZONTAL",
		[l_ufrpower] = true,
		[l_ufrpowersize] = 0.06,
		[l_ufrisize] = 11,
		[l_ufrdsize] = 18,
		[l_ufrlfdrole] = false,
		[l_ufrfont] = media.."font.ttf",
		[l_ufrufsize] = 10,
		[l_ufrhealdif] = false,
		[l_ufrpartyn] = 5,
		[l_ufrPets] = false,
		[l_ufrMT] = false,
		[l_ufrfu] = 0.5,
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
	SetCVar("chatStyle", "classic")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("showTutorials", 0)
	SetCVar("showNewbieTips", 0)
	SetCVar("autoDismountFlying", 1)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoQuestProgress", 1)
	SetCVar("showLootSpam", 1)
	SetCVar("guildMemberNotify", 1)
	SetCVar("chatBubblesParty", 1)
	SetCVar("chatBubbles", 1)

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

if ThunderDB[l_main][l_autoscale] == true then
	ThunderDB[l_main][l_scale] = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
end

----------------------------------------------------------------------------------------
-- Pixel size
----------------------------------------------------------------------------------------

local fixx = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/ThunderDB[l_main][l_scale]
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
	SetCVar("uiScale", ThunderDB[l_main][l_scale])
end)

----------------------------------------------------------------------------------------
-- Border and Background function
----------------------------------------------------------------------------------------

function SetTemplate(f)
	f:SetBackdrop({
		bgFile = ThunderDB[l_main][l_blank],
		edgeFile = ThunderDB[l_main][l_blank],
		tile = false, tileSize = 0, edgeSize = fixscale(1),
		insets = {left = fixscale(-1), right = fixscale(-1), top = fixscale(-1), bottom = fixscale(-1)}
	})
	f:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
	f:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor]))
end

----------------------------------------------------------------------------------------
-- Option check
----------------------------------------------------------------------------------------

if ThunderDB[l_ufr][l_ufrpowersize] > 0.1 then
	ThunderDB[l_ufr][l_ufrpowersize] = 0.1
elseif ThunderDB[l_ufr][l_ufrpowersize] < 0.0000001 then
	ThunderDB[l_ufr][l_ufrpowersize] = 0.0000001
end

end

StaticPopupDialogs["INSTALL"] = {
	text = l_intalltext,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ThunderDB.firstStart = false; setupVars(); ReloadUI(); end,
	OnCancel = function() ThunderDB.firstStart = true end,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["SAVEOPTS"] = {
	text = l_settingchanged,
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
			print("|cffaaffaaRestored|r "..k.." |cffaaffaaoption|r")
		end
		if type(v) == "table" then
			for n,m in pairs(v) do
				if ThunderDB[k][n] == nil then
					ThunderDB[k][n] = m
					print("|cffaaffaaRestored|r "..k.." |cffaaffaaoption. New value|r "..n)
				end
			end
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

	parseOptions(ThunderUI.main, l_main, ThunderDB[l_main])

	LaunchMain(ThunderDB)

	local resetm = NewButton(l_reset, ThunderUI.main)
	resetm:SetWidth(90)
	resetm:SetHeight(20)
	resetm:SetPoint("BOTTOMLEFT",10, 10)
	resetm:SetScript("OnClick", function(self) ThunderDB = nil ReloadUI() end)

	local savem = NewButton(l_save, ThunderUI.main)
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
			_G["cb_module"..module.name.."Text"]:SetText(l_enableG)
		else
			_G["cb_module"..module.name.."Text"]:SetText(l_enableR)
		end
		_G["cb_module"..module.name.."Text"]:SetFontObject("GameFontNormal")
		checkbox:SetChecked(ThunderDB.modules[module.name])
		checkbox:SetScript("OnClick", function()
			ThunderDB.modules[module.name] = not ThunderDB.modules[module.name]
			if ThunderDB.modules[module.name] then
				_G["cb_module"..module.name.."Text"]:SetText(l_enableG)
			else
				_G["cb_module"..module.name.."Text"]:SetText(l_enableR)
			end
		end)
		checkbox:SetPoint("TOPLEFT", childpanel, 20, -20)

		InterfaceOptions_AddCategory(childpanel)

		local reset = NewButton(l_resetmodule, childpanel)
		reset:SetWidth(170)
		reset:SetHeight(20)
		reset:SetPoint("BOTTOMLEFT",10, 10)
		reset:SetScript("OnClick", function(self) ThunderDB[module.name] = nil ReloadUI() end)

		local save = NewButton(l_save, childpanel)
		save:SetWidth(90)
		save:SetHeight(20)
		save:SetPoint("BOTTOMRIGHT", -10, 10)
		save:SetScript("OnClick", function(self) ReloadUI() end)

		module.Init()

		parseOptions(childpanel, module.name, ThunderDB[module.name])
   end

   local thunderver = GetAddOnMetadata(addonName, "Version")
   print("|cff9DC7CCThe Thunder UI v"..thunderver.."|r "..l_welcome)

   ThunderUI:UnregisterEvent("VARIABLES_LOADED")
   ThunderUI:SetScript("OnEvent", nil)
end)