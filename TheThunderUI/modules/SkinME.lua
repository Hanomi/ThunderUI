local module = {}
module.name = l_skin
module.Init = function()
	if not ThunderDB.modules[module.name] then return end
	
--[[
    Skada skin for TukUI by Darth Android / Telroth - Black Dragonflight
    Skins all Skada windows to fit TukUI
    All overridden options are removed from Skada's config to reduce confusion
    
    Window height is moved to the Bars config pane - it works a bit differently now.
    If set to 0, window auto-sizes to the number of bars as before, with a minimum of 1 bar.
    If set to 1, then it sizes to accomodate the number of bars defined by the "Max bars" setting
    
    TODO:
     + Add Integration options

	(C)2010 Darth Android / Telroth - Black Dragonflight
	File version v15.37
]]
if not IsAddOnLoaded("Skada") then return end

Mod_AddonSkins = CreateFrame("Frame")
local Mod_AddonSkins = Mod_AddonSkins

local tukskin = SetTemplate
local function skinFrame(self, frame)
	tukskin(frame,frame)
end
local function skinButton(self, button)
	skinFrame(self, button)
	-- Crazy hacks which only work because self = Skin *AND* self = config
	local name = button:GetName()
	local icon = _G[name.."Icon"]
	if icon then
		icon:SetTexCoord(unpack(self.buttonZoom))
		icon:SetDrawLayer("ARTWORK")
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT",button,"TOPLEFT",self.borderWidth, -self.borderWidth)
		icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-self.borderWidth, self.borderWidth)
	end
end

Mod_AddonSkins.SkinFrame = skinFrame
Mod_AddonSkins.SkinBackgroundFrame = skinFrame
Mod_AddonSkins.SkinButton = skinButton
Mod_AddonSkins.normTexture = ThunderDB[l_main][l_bar]
Mod_AddonSkins.bgTexture = ThunderDB[l_main][l_blank]
Mod_AddonSkins.font = ThunderDB[l_main][l_font]
Mod_AddonSkins.smallFont = ThunderDB[l_main][l_font]
Mod_AddonSkins.fontSize = 10
Mod_AddonSkins.buttonSize = fixscale(27,27)
Mod_AddonSkins.buttonSpacing = fixscale(4,4)
Mod_AddonSkins.borderWidth = fixscale(2,2)
Mod_AddonSkins.buttonZoom = {.09,.91,.09,.91}
Mod_AddonSkins.barSpacing = fixscale(1,1)
Mod_AddonSkins.barHeight = fixscale(20,20)
Mod_AddonSkins.skins = {}

-- Dummy function expected by some skins
function dummy() end


function Mod_AddonSkins:RegisterSkin(name, initFunc)
	self = Mod_AddonSkins -- Static function
	if type(initFunc) ~= "function" then error("initFunc must be a function!",2) end
	self.skins[name] = initFunc
end

Mod_AddonSkins:RegisterEvent("PLAYER_LOGIN")
Mod_AddonSkins:RegisterEvent("PLAYER_ENTERING_WORLD")
Mod_AddonSkins:SetScript("OnEvent",function(self, event, addon)
	self:SetScript("OnEvent",nil)
	if event == "PLAYER_LOGIN" then
		-- Initialize all skins
		for name, func in pairs(self.skins) do
			func(self,self,self,self,self) -- Mod_AddonSkins functions as skin, layout, and config.
		end
		self:UnregisterEvent("PLAYER_LOGIN")
	end

	-- Embed Right
		SkadaBarWindowSkada:ClearAllPoints()
		SkadaBarWindowSkada:SetPoint("TOPRIGHT", UIParent, "BOTTOMRIGHT", -152, 18+ThunderDB[l_lpanels][l_lpheight])
	--local function AdjustSkadaFrameLevels()
		--	SkadaBarWindowSkada:SetFrameLevel(ChatFrame3:GetFrameLevel() + 2)
		--	if SkadaBG then
		--		SkadaBG:SetFrameStrata("MEDIUM")	
		--		SkadaBG:ClearAllPoints()
		--		SkadaBG:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -150, 26)
		--		SkadaBG:SetHeight(ThunderDB[l_lpanels][l_lpheight]-10)
		--		SkadaBG:SetWidth(fixscale(148))
		--		--fixscale(148) ThunderDB[l_lpanels][l_lpheight]-10
		--	end
	--	end
		
	--	SkadaBarWindowSkada:HookScript("OnShow", AdjustSkadaFrameLevels)
		--trick game into firing OnShow script so we can adjust the frame levels
		SkadaBarWindowSkada:Hide()
		SkadaBarWindowSkada:Show()
end)

local Skada = Skada

Mod_AddonSkins:RegisterSkin("Skada",function(Skin,skin,Layout,layout,config)
	Layout.PositionSkadaWindow = dummy
	-- Used to strip unecessary options from the in-game config
	local function StripOptions(options)
		options.baroptions.args.bartexture = options.windowoptions.args.height
		options.baroptions.args.bartexture.order = 12
		options.baroptions.args.bartexture.max = 1
		options.baroptions.args.barspacing = nil
		options.titleoptions.args.texture = nil
		options.titleoptions.args.bordertexture = nil
		options.titleoptions.args.thickness = nil
		options.titleoptions.args.margin = nil
		options.titleoptions.args.color = nil
		options.windowoptions = nil
    --if not TukuiDB.skins.Skada.nofont or TukuiDB.skins.Skada.nofont ~= true then
        options.baroptions.args.barfont = nil
        options.titleoptions.args.font = nil
    --end
	end
	-- Hook the bar mod
	local barmod = Skada.displays["bar"]
	-- Strip options
	barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
    barmod.AddDisplayOptions = function(self, win, options)
        self:AddDisplayOptions_(win, options)
        StripOptions(options)
	end
	for k, options in pairs(Skada.options.args.windows.args) do
        if options.type == "group" then
            StripOptions(options.args)
        end
    end
	-- Size height correctly
	barmod.AdjustBackgroundHeight = function(self,win)
	    local numbars = 0
	    if win.bargroup:GetBars() ~= nil then
		    if win.db.background.height == 0 then
                for name, bar in pairs(win.bargroup:GetBars()) do if bar:IsShown() then numbars = numbars + 1 end end
            else
                numbars = win.db.barmax
            end
            if win.db.enabletitle then numbars = numbars + 1 end
            if numbars < 1 then numbars = 1 end
		    local height = numbars * (win.db.barheight + config.barSpacing) + config.barSpacing + config.borderWidth
            --if win.db.enabletitle then height = height + 1 end
		    if win.bargroup.bgframe:GetHeight() ~= height then
			    win.bargroup.bgframe:SetHeight(height+1)
		    end
	    end
    end
	-- Override settings from in-game GUI
--	local titleBG = {
--		bgFile = config.normTexture,
--		tile = false,
--		tileSize = 0
--	}
	barmod.ApplySettings_ = barmod.ApplySettings
	barmod.ApplySettings = function(self, win)
	
		win.db.barwidth = fixscale(146)
		win.db.barheight = 14
		win.db.barmax = (math.floor((ThunderDB[l_lpanels][l_lpheight]-6) / win.db.barheight) - 1)
		win.db.background.height = ThunderDB[l_lpanels][l_lpheight]-6
		win.db.spark = false
		win.db.barslocked = true
	
        win.db.enablebackground = true
        win.db.background.borderthickness = config.borderWidth
		barmod:ApplySettings_(win)
		layout:PositionSkadaWindow(win)
   --     if win.db.enabletitle then
    --        win.bargroup.button:SetBackdrop(titleBG)
    --    end
        win.bargroup:SetTexture(config.normTexture)
        win.bargroup:SetSpacing(config.barSpacing)
		win.bargroup:SetFont(config.font,config.fontSize, config.fontFlags)
		local titlefont = CreateFont("TitleFont"..win.db.name)
		titlefont:SetFont(config.font,config.fontSize, config.fontFlags)
		win.bargroup.button:SetNormalFontObject(titlefont)
        local color = win.db.title.color
	    win.bargroup.button:SetBackdropColor(unpack(ThunderDB[l_main][l_bcolor]))
		if win.bargroup.bgframe then
            skin:SkinBackgroundFrame(win.bargroup.bgframe)
			if win.db.reversegrowth then
				win.bargroup.bgframe:SetPoint("BOTTOM", win.bargroup.button, "BOTTOM", 0, -1 * (win.db.enabletitle and 2 or 1))
			else
				win.bargroup.bgframe:SetPoint("TOP", win.bargroup.button, "TOP", 0,1 * (win.db.enabletitle and 2 or 1))
			end
		end
        self:AdjustBackgroundHeight(win)
        win.bargroup:SetMaxBars(win.db.barmax)
        win.bargroup:SortBars()
	end
	-- Update pre-existing displays
	for k, window in ipairs(Skada:GetWindows()) do
		window:UpdateDisplay()
	end
end)


end
tinsert(ThunderUI.modules, module) -- finish him!