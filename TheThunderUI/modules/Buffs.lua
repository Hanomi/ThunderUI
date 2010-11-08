----------------------------------------------------------------------------------------
-- monoBuffs
-- MonoLIT - 2010
----------------------------------------------------------------------------------------

local module = {}
module.name = l_mbuffs
module.Init = function()
	if not ThunderDB.modules[module.name] then return end
	local settings = ThunderDB
	
BUFFS_PER_ROW = ThunderDB[l_mbuffs][l_mBuffPerRow]
local mh, _, _, oh, _, _, te = GetWeaponEnchantInfo()

local frameBD = {
	edgeFile = ThunderDB[l_main][l_shadow], edgeSize = 5,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local make_backdrop = function(f)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint("TOPLEFT", fixscale(-4), fixscale(4))
	f:SetPoint("BOTTOMRIGHT", fixscale(4), fixscale(-4))
	f:SetBackdrop(frameBD);
	f:SetBackdropColor(0,0,0,0)
	f:SetBackdropBorderColor(0,0,0,1)
end

ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint("TOPRIGHT","UIParent", -10, -10)
ConsolidatedBuffs:SetSize(ThunderDB[l_mbuffs][l_mBuffSize], ThunderDB[l_mbuffs][l_mBuffSize])
ConsolidatedBuffs.SetPoint = function() end
ConsolidatedBuffsIcon:SetTexture("Interface\\Icons\\Spell_ChargePositive")
ConsolidatedBuffsIcon:SetTexCoord(0.03,0.97,0.03,0.97)
ConsolidatedBuffsIcon:SetSize(ThunderDB[l_mbuffs][l_mBuffSize]-2,ThunderDB[l_mbuffs][l_mBuffSize]-2)
local h = CreateFrame("Frame")
h:SetParent(ConsolidatedBuffs)
h:SetAllPoints(ConsolidatedBuffs)
h:SetFrameLevel(30)
ConsolidatedBuffsCount:SetParent(h)
ConsolidatedBuffsCount:SetPoint("BOTTOMRIGHT")
ConsolidatedBuffsCount:SetFont(ThunderDB[l_mbuffs][l_mFont], ThunderDB[l_mbuffs][l_mFontSize], "OUTLINE")
local CBbg = CreateFrame("Frame", nil, ConsolidatedBuffs)
make_backdrop(CBbg)

for i = 1, 3 do
	_G["TempEnchant"..i.."Border"]:Hide()
	local te 			= _G["TempEnchant"..i]
	local teicon 		= _G["TempEnchant"..i.."Icon"]
	local teduration 	= _G["TempEnchant"..i.."Duration"]
	local h = CreateFrame("Frame")
	h:SetParent(te)
	h:SetAllPoints(te)
	h:SetFrameLevel(30)
	te:SetSize(ThunderDB[l_mbuffs][l_mBuffSize],ThunderDB[l_mbuffs][l_mBuffSize])
	teicon:SetPoint("BOTTOMRIGHT", te, -2, 2)
	teicon:SetTexCoord(.08, .92, .08, .92)
	teicon:SetPoint("TOPLEFT", te, 2, -2)
	teduration:ClearAllPoints()
	teduration:SetParent(h)
	teduration:SetPoint("BOTTOM", 0, fixscale(ThunderDB[l_mbuffs][l_mTimeOffset]))
	teduration:SetFont(ThunderDB[l_mbuffs][l_mFont], ThunderDB[l_mbuffs][l_mFontSize], "THINOUTLINE")
	local bd = CreateFrame("Frame", i.."tePanel", te)
	bd:SetPoint("TOPLEFT", 0, 0)
	bd:SetPoint("BOTTOMRIGHT", 0, 0)
	bd:SetFrameLevel(te:GetFrameLevel()-1)
	SetTemplate(bd)
	te.bd = bd
	local bg = CreateFrame("Frame", nil, te)
	make_backdrop(bg)
end

local function CreateBuffStyle(buttonName, i, debuff)
	local buff		= _G[buttonName..i]
	local icon		= _G[buttonName..i.."Icon"]
	local border	= _G[buttonName..i.."Border"]
	local duration	= _G[buttonName..i.."Duration"]
	local count 	= _G[buttonName..i.."Count"]

	if icon and not _G[buttonName..i.."Background"] then
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("TOPLEFT", buff, 2, -2)
		icon:SetPoint("BOTTOMRIGHT", buff, -2, 2)
		if debuff then
			buff:SetSize(ThunderDB[l_mbuffs][l_mDeBuffSize],ThunderDB[l_mbuffs][l_mDeBuffSize])
		else
			buff:SetSize(ThunderDB[l_mbuffs][l_mBuffSize],ThunderDB[l_mbuffs][l_mBuffSize])
		end
		duration:ClearAllPoints()
		duration:SetPoint("BOTTOM", 1, fixscale(ThunderDB[l_mbuffs][l_mTimeOffset]))
		duration:SetFont(ThunderDB[l_mbuffs][l_mFont], ThunderDB[l_mbuffs][l_mFontSize], "THINOUTLINE")
		local bg = CreateFrame("Frame", buttonName..i.."Background", buff)
		make_backdrop(bg)
		count:ClearAllPoints()
		count:SetPoint("TOPRIGHT", buff, -1, -1)
		count:SetFont(ThunderDB[l_mbuffs][l_mFont], ThunderDB[l_mbuffs][l_mFontSize], "OUTLINE")
		
		local bd = CreateFrame("Frame", buttonName..i.."Panel", buff)
		bd:SetPoint("TOPLEFT", 0, 0)
		bd:SetPoint("BOTTOMRIGHT", 0, 0)
		bd:SetFrameLevel(buff:GetFrameLevel()-1)
		SetTemplate(bd)
		buff.bd = bd
		
		if debuff then
			buff.bd:SetBackdropBorderColor(1,.3,.3,1)
		else
			buff.bd:SetBackdropBorderColor(unpack(ThunderDB[l_main][l_bgcolor])) 
		end
			
	end
	if border then border:Hide() end
end

local function OverrideBuffAnchors()
	local buttonName = "BuffButton" -- c
	local buff, previousBuff, aboveBuff;
	local numBuffs = 0;
	local slack = BuffFrame.numEnchants
	local mh, _, _, oh, _, _, te = GetWeaponEnchantInfo()
	if ( BuffFrame.numConsolidated > 0 ) then
		slack = slack + 1;	
	end
	for i=1, BUFF_ACTUAL_DISPLAY do
		CreateBuffStyle(buttonName, i, false)
		local buff = _G[buttonName..i]
		if not ( buff.consolidated ) then	
			numBuffs = numBuffs + 1
			i = numBuffs + slack
			buff:ClearAllPoints()
			if ( (i > 1) and (mod(i, BUFFS_PER_ROW) == 1) ) then
 				if ( i == BUFFS_PER_ROW+1 ) then
					buff:SetPoint("TOP", ConsolidatedBuffs, "BOTTOM", 0, -10)
				else
					buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -10)
				end
				aboveBuff = buff; 
			elseif ( i == 1 ) then
				buff:SetPoint("TOPRIGHT","UIParent", -10, -10)
			else
				if ( numBuffs == 1 ) then
					if mh and oh and te and not UnitHasVehicleUI("player") then
						buff:SetPoint("TOPRIGHT", TempEnchant3, "TOPLEFT", -ThunderDB[l_mbuffs][l_mBuffOffset], 0);
					elseif ((mh and oh and not te) or (mh and te and not oh) or (te and oh and not mh)) and not UnitHasVehicleUI("player") then
						buff:SetPoint("TOPRIGHT", TempEnchant2, "TOPLEFT", -ThunderDB[l_mbuffs][l_mBuffOffset], 0);
					elseif ((mh and not oh and not te) or (oh and not te and not mh) or (te and not oh and not mh)) and not UnitHasVehicleUI("player") then
						buff:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -ThunderDB[l_mbuffs][l_mBuffOffset], 0)
					else
						buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -ThunderDB[l_mbuffs][l_mBuffOffset], 0);
					end
				else
					buff:SetPoint("RIGHT", previousBuff, "LEFT", -ThunderDB[l_mbuffs][l_mBuffOffset], 0);
				end
			end
			previousBuff = buff
		end		
	end
end

local function OverrideDebuffAnchors(buttonName, i)
	if ThunderDB[l_mbuffs][l_mBuffDebuffs] then
		CreateBuffStyle(buttonName, i, true)
		local debuff = _G[buttonName..i];
		local dtype = select(5, UnitDebuff("player",i))      
		local color
		if (dtype ~= nil) then
			color = DebuffTypeColor[dtype]
		else
			color = DebuffTypeColor["none"]
		end
		debuff:ClearAllPoints()
		if i == 1 then
			debuff:SetPoint("TOPRIGHT", "UIParent", -10, ThunderDB[l_mbuffs][l_mDebuffOffset])
		else
			debuff:SetPoint("RIGHT", _G[buttonName..(i-1)], "LEFT", -ThunderDB[l_mbuffs][l_mBuffOffset], 0)
		end
	else
		_G[buttonName..i]:Hide()
	end
end

-- fixing the consolidated buff container sizes because the default formula is just SHIT!
local z = 0.79 -- 37 : 28 // 30 : 24 -- dasdas;djal;fkjl;jkfsfoi !!!! meaningfull comments we all love them!!11
local function OverrideConsolidatedBuffsAnchors()
	ConsolidatedBuffsTooltip:SetWidth(min(BuffFrame.numConsolidated * ThunderDB[l_mbuffs][l_mBuffSize] * z + 18, 4 * ThunderDB[l_mbuffs][l_mBuffSize] * z + 18));
    ConsolidatedBuffsTooltip:SetHeight(floor((BuffFrame.numConsolidated + 3) / 4 ) * ThunderDB[l_mbuffs][l_mBuffSize] * z + CONSOLIDATED_BUFF_ROW_HEIGHT * z);
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", OverrideBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", OverrideDebuffAnchors)
--hooksecurefunc("AuraButton_Update", OverrideAuraButton_Update)
hooksecurefunc("ConsolidatedBuffs_UpdateAllAnchors", OverrideConsolidatedBuffsAnchors)

end
tinsert(ThunderUI.modules, module) -- finish him!
