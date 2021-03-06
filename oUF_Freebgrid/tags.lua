﻿local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
ns.numberize = numberize

local x = "M"

local getTime = function(expirationTime)
    local expire = -1*(GetTime()-expirationTime)
    local timeleft = numberize(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

-- Priest
local pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags['freebgrid:pom'] = function(u) 
    local c = select(4, UnitAura(u, GetSpellInfo(41635))) if c then return "|cffFFCF7F"..pomCount[c].."|r" end 
end
oUF.TagEvents['freebgrid:pom'] = "UNIT_AURA"

oUF.Tags['freebgrid:rnw'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.TagEvents['freebgrid:rnw'] = "UNIT_AURA"

oUF.Tags['freebgrid:rnwTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:rnwTime'] = "UNIT_AURA"

oUF.Tags['freebgrid:pws'] = function(u) if UnitAura(u, GetSpellInfo(17)) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:pws'] = "UNIT_AURA"

oUF.Tags['freebgrid:ws'] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900"..x.."|r" end end
oUF.TagEvents['freebgrid:ws'] = "UNIT_AURA"

oUF.Tags['freebgrid:fw'] = function(u) if UnitAura(u, GetSpellInfo(6346)) then return "|cff8B4513"..x.."|r" end end
oUF.TagEvents['freebgrid:fw'] = "UNIT_AURA"

oUF.Tags['freebgrid:sp'] = function(u) if not UnitAura(u, GetSpellInfo(79107)) then return "|cff9900FF"..x.."|r" end end
oUF.TagEvents['freebgrid:sp'] = "UNIT_AURA"

oUF.Tags['freebgrid:fort'] = function(u) if not(UnitAura(u, GetSpellInfo(79105)) or UnitAura(u, GetSpellInfo(6307)) or UnitAura(u, GetSpellInfo(469))) then return "|cff00A1DE"..x.."|r" end end
oUF.TagEvents['freebgrid:fort'] = "UNIT_AURA"

-- Druid
local lbCount = { 4, 2, 3}
oUF.Tags['freebgrid:lb'] = function(u) 
    local name, _,_, c,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(94447))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..lbCount[c].."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..lbCount[c].."|r"
        else
            return "|cffA7FD0A"..lbCount[c].."|r"
        end
    end
end
oUF.TagEvents['freebgrid:lb'] = "UNIT_AURA"

oUF.Tags['freebgrid:rejuv'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.TagEvents['freebgrid:rejuv'] = "UNIT_AURA"

oUF.Tags['freebgrid:rejuvTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:rejuvTime'] = "UNIT_AURA"

oUF.Tags['freebgrid:regrow'] = function(u) if UnitAura(u, GetSpellInfo(8936)) then return "|cff00FF10"..x.."|r" end end
oUF.TagEvents['freebgrid:regrow'] = "UNIT_AURA"

oUF.Tags['freebgrid:wg'] = function(u) if UnitAura(u, GetSpellInfo(48438)) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:wg'] = "UNIT_AURA"

oUF.Tags['freebgrid:motw'] = function(u) if not(UnitAura(u, GetSpellInfo(1126)) or UnitAura(u,GetSpellInfo(20217))) then return "|cffFF00FF"..x.."|r" end end
oUF.TagEvents['freebgrid:motw'] = "UNIT_AURA"

-- Warrior
oUF.Tags['freebgrid:stragi'] = function(u) if not(UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330)) or UnitAura(u, GetSpellInfo(8075))) then return "|cffFF0000"..x.."|r" end end
oUF.TagEvents['freebgrid:stragi'] = "UNIT_AURA"

-- Shaman
oUF.Tags['freebgrid:rip'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == 'player') then return "|cff00FEBF"..x.."|r" end
end
oUF.TagEvents['freebgrid:rip'] = 'UNIT_AURA'

oUF.Tags['freebgrid:ripTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:ripTime'] = 'UNIT_AURA'

local earthCount = {'i','h','g','f','p','q','Z','Z','Y'}
oUF.Tags['freebgrid:earth'] = function(u) 
    local c = select(4, UnitAura(u, GetSpellInfo(974))) if c then return '|cffFFCF7F'..earthCount[c]..'|r' end 
end
oUF.TagEvents['freebgrid:earth'] = 'UNIT_AURA'

--paladin
oUF.Tags['freebgrid:beacon'] = function(u) if UnitAura(u, GetSpellInfo(53563)) then return "|cffffff10"..x.."|r" end end
oUF.TagEvents['freebgrid:beacon'] = "UNIT_AURA"

oUF.Tags['freebgrid:selfbeacon'] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, GetSpellInfo(53563))
  if not (fromwho == "player") then return end
  if UnitAura(u, GetSpellInfo(53563)) then return "|cffff33ff"..x.."|r" end end
oUF.TagEvents['freebgrid:selfbeacon'] = "UNIT_AURA"

oUF.Tags['freebgrid:beaconTime'] = function(u)
  local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, GetSpellInfo(53563))
  if (fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:beaconTime'] = "UNIT_AURA"

ns.classIndicators={
    ["DRUID"] = {
        ["TL"] = "",
        ["TR"] = "[freebgrid:motw]",
        ["BL"] = "[freebgrid:regrow][freebgrid:wg]",
        ["BR"] = "[freebgrid:lb]",
        ["Cen"] = "[freebgrid:rejuvTime]",
    },
    ["PRIEST"] = {
        ["TL"] = "[freebgrid:pws][freebgrid:ws]",
        ["TR"] = "[freebgrid:fw][freebgrid:sp][freebgrid:fort]",
        ["BL"] = "[freebgrid:rnw]",
        ["BR"] = "[freebgrid:pom]",
        ["Cen"] = "",
    },
    ["PALADIN"] = {
        ["TL"] = "",
		["TR"] = "[freebgrid:selfbeacon][freebgrid:beacon]",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "[freebgrid:beaconTime]",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "",
        ["TR"] = "[freebgrid:stragi][freebgrid:fort]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[freebgrid:rip]",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[freebgrid:earth]",
        ["Cen"] = "[freebgrid:ripTime]",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    }
}