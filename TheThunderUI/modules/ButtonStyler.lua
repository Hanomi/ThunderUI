----------------------------------------------------------------------------------------
-- rActionButtonStyler
-- zork - 2010
----------------------------------------------------------------------------------------

local module = {}
module.name = "ButtonStyler"
module.Init = function()
	if not ThunderDB.modules[module.name] then return end
	local settings = ThunderDB

local _G = _G

local nomoreplay = function() end
local replace = string.gsub
  
local function applyBackground(bu)
	local bg = CreateFrame("Frame", nil, bu)
	bg:SetPoint("TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, 0)
	bg:SetFrameLevel(bu:GetFrameLevel()-1)
	SetTemplate(bg)
	bu.bg = bg
end
  
--initial style func
local function rActionButtonStyler_AB_style(self)
	if not self.rABS_Styled and self:GetParent() and  self:GetParent():GetName() ~= "MultiCastActionBarFrame" and self:GetParent():GetName() ~= "MultiCastActionPage1" and self:GetParent():GetName() ~= "MultiCastActionPage2" and self:GetParent():GetName() ~= "MultiCastActionPage3" then
	  
		local action = self.action
		local name = self:GetName()
		local bu  = _G[name]
		local ic  = _G[name.."Icon"]
		local co  = _G[name.."Count"]
		local bo  = _G[name.."Border"]
		local ho  = _G[name.."HotKey"]
		local cd  = _G[name.."Cooldown"]
		local na  = _G[name.."Name"]
		local fl  = _G[name.."Flash"]
		local nt  = _G[name.."NormalTexture"]
      
		--hide the border (plain ugly, sry blizz)
		bo:Hide()
		bo.Show = nomoreplay
		na:Hide()
      
		if not ThunderDB["ActionBars"]["HideHotkey"] then
			ho:SetFont(ThunderDB["ButtonStyler"]["ButtonFont"], ThunderDB["ButtonStyler"]["ButtonFontSize"], "OUTLINE")
			ho:ClearAllPoints()
			ho:SetPoint("TOPRIGHT", 1, -1)
			ho:SetWidth(ThunderDB["ActionBars"]["ButtonSize"]+2)
			ho:SetHeight(ThunderDB["ButtonStyler"]["ButtonFontSize"])
		else
			ho:Hide()
			ho.Show = nomoreplay
		end

		co:ClearAllPoints()
		co:SetPoint("BOTTOMRIGHT", 0, fixscale(2))
		co:SetFont(ThunderDB["ButtonStyler"]["ButtonFont"], ThunderDB["ButtonStyler"]["ButtonFontSize"], "OUTLINE")
    
		--applying the textures
	--	fl:SetTexture("")
		bu:SetNormalTexture("")
		bu:SetHighlightTexture(ThunderDB["ButtonStyler"]["HighlightText"])
		bu:SetPushedTexture(ThunderDB["ButtonStyler"]["PushedText"])
		bu:SetCheckedTexture(ThunderDB["ButtonStyler"]["CheckedText"])

		--cut the default border of the icons and make them shiny
		ic:SetTexCoord(0.1,0.9,0.1,0.9)
		ic:SetPoint("TOPLEFT", bu, "TOPLEFT", fixscale(2), fixscale(-2))
		ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", fixscale(-2), fixscale(2))
			
		--adjust the cooldown frame
		cd:SetPoint("TOPLEFT", bu, "TOPLEFT", fixscale(2), fixscale(-2))
		cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", fixscale(-2), fixscale(2))

		if not bu.bg then applyBackground(bu) end
      
		--disable resetting of textures
	--	fl.SetTexture = nomoreplay
		bu.SetHighlightTexture = nomoreplay
		bu.SetPushedTexture = nomoreplay
		bu.SetCheckedTexture = nomoreplay
		bu.SetNormalTexture = nomoreplay

		self.rABS_Styled = true
	end  
end
  
  --style pet buttons
local function rActionButtonStyler_AB_stylepet()

	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local bu  = _G[name]
		local ic  = _G[name.."Icon"]
		local fl  = _G[name.."Flash"]
		local nt  = _G[name.."NormalTexture2"]
		local cd  = _G[name.."Cooldown"]

	--	fl:SetTexture("")
		bu:SetNormalTexture("")
		bu:SetHighlightTexture(ThunderDB["ButtonStyler"]["HighlightText"])
		bu:SetPushedTexture(ThunderDB["ButtonStyler"]["PushedText"])
		bu:SetCheckedTexture(ThunderDB["ButtonStyler"]["CheckedText"])
		
		--cut the default border of the icons and make them shiny
		ic:SetTexCoord(0.1,0.9,0.1,0.9)
		ic:SetPoint("TOPLEFT", bu, "TOPLEFT", fixscale(2), fixscale(-2))
		ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", fixscale(-2), fixscale(2))

		--adjust the cooldown frame
		cd:SetPoint("TOPLEFT", bu, "TOPLEFT", fixscale(2), fixscale(-2))
		cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", fixscale(-2), fixscale(2))

		--shadows+background
		if not bu.bg then applyBackground(bu) end
	end  
end
  
  --style shapeshift buttons
local function rActionButtonStyler_AB_styleshapeshift()
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local bu  = _G[name]
		local ic  = _G[name.."Icon"]
		local fl  = _G[name.."Flash"]
		local nt  = _G[name.."NormalTexture"]
		local cd  = _G[name.."Cooldown"]

	--	fl:SetTexture("")
		bu:SetNormalTexture("")
		bu:SetHighlightTexture(ThunderDB["ButtonStyler"]["HighlightText"])
		bu:SetPushedTexture(ThunderDB["ButtonStyler"]["PushedText"])
		bu:SetCheckedTexture(ThunderDB["ButtonStyler"]["CheckedText"])
    
		--cut the default border of the icons and make them shiny
		ic:SetTexCoord(0.1,0.9,0.1,0.9)
		ic:SetPoint("TOPLEFT", bu, "TOPLEFT", fixscale(2), fixscale(-2))
		ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", fixscale(-2), fixscale(2))

		--adjust the cooldown frame
		cd:SetPoint("TOPLEFT", bu, "TOPLEFT", fixscale(2), fixscale(-2))
		cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", fixscale(-2), fixscale(2))

		--shadows+background
		if not bu.bg then applyBackground(bu) end
	end
end

local function modActionButton_UpdateHotkeys(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()
	
	text = replace(text, '(s%-)', 'S')
	text = replace(text, '(a%-)', 'A')
	text = replace(text, '(c%-)', 'C')
	text = replace(text, '(Mouse Button )', 'M')
	text = replace(text, '(Middle Mouse)', 'M3')
	text = replace(text, '(Num Pad )', 'N')
	text = replace(text, '(Page Up)', 'PU')
	text = replace(text, '(Page Down)', 'PD')
	text = replace(text, '(Spacebar)', 'SpB')
	text = replace(text, '(Insert)', 'Ins')
	text = replace(text, '(Home)', 'Hm')
	text = replace(text, '(Delete)', 'Del')
	
	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end

	if ThunderDB["ActionBars"]["HideHotkey"] ~= true then
		hotkey:ClearAllPoints()
		hotkey:SetPoint("TOPRIGHT", 1, -1)
		hotkey:SetWidth(ThunderDB["ActionBars"]["ButtonSize"]+2)
		hotkey:SetHeight(ThunderDB["ButtonStyler"]["ButtonFontSize"])
	else
		hotkey:Hide()
	end
end

---------------------------------------
-- CALLS // HOOKS
---------------------------------------

hooksecurefunc("ActionButton_Update",         rActionButtonStyler_AB_style)
hooksecurefunc("ShapeshiftBar_Update",        rActionButtonStyler_AB_styleshapeshift)
hooksecurefunc("ShapeshiftBar_UpdateState",   rActionButtonStyler_AB_styleshapeshift)
hooksecurefunc("PetActionBar_Update",         rActionButtonStyler_AB_stylepet)
hooksecurefunc("ActionButton_UpdateHotkeys",  modActionButton_UpdateHotkeys)

end
tinsert(ThunderUI.modules, module) -- finish him!