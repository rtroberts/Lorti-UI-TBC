﻿--get the addon namespace
local addon, ns = ...
--get the config values
local cfg = ns.cfg

---------------------------------------
-- LOCALS
---------------------------------------

--backdrop
local backdrop1 = {
	bgFile = nil,
	edgeFile = "Interface\\AddOns\\Lorti-UI-Redux\\textures\\outer_shadow",
	tile = false,
	tileSize = 32,
	edgeSize = 4,
	insets = {
		left = 4,
		right = 4,
		top = 4,
		bottom = 4
	}
}

---------------------------------------
-- FUNCTIONS
---------------------------------------

--apply aura frame texture func
local function applySkin(b, isBuff)
	if not b or (b and b.styled) then
		return
	end
	--button name
	local name = b:GetName()

	--icon
	local icon = _G[name .. "Icon"]
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetDrawLayer("BACKGROUND", -8)
	b.icon = icon
	--border
	local border = _G[name .. "Border"] or b:CreateTexture(name .. "Border", "BACKGROUND", nil, -7)
	border:SetTexture("Interface\\AddOns\\Lorti-UI-Redux\\textures\\gloss2")
	border:SetTexCoord(0, 1, 0, 1)
	border:SetDrawLayer("BACKGROUND", -7)
	if isBuff then
		border:SetVertexColor(0, 0, 0)
	end
	border:ClearAllPoints()
	border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
	b.border = border
	--shadow
	local back = CreateFrame("Frame", nil, b)
	back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
	back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
	back:SetFrameLevel(b:GetFrameLevel() - 1)

	back.Backdrop = CreateFrame("Frame", "Backdrop", back, BackdropTemplateMixin and "BackdropTemplate")
	back.Backdrop:SetAllPoints()
	back.Backdrop:SetBackdrop(backdrop1)

	back.Backdrop:SetBackdropBorderColor(0, 0, 0, 0.9)
	b.bg = back
	--set button styled variable
	b.styled = true
end

--apply castbar texture

local function applycastSkin(b)
	if not b or (b and b.styled) then
		return
	end
	-- parent
	if b == TargetFrameSpellBar.Icon then
		b.parent = TargetFrameSpellBar
		b:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end
	-- frame
	frame = CreateFrame("Frame", nil, b.parent)
	--border
	local border = frame:CreateTexture(nil, "BACKGROUND")
	border:SetTexture("Interface\\AddOns\\Lorti-UI-Redux\\textures\\gloss")
	border:SetTexCoord(0, 1, 0, 1)
	border:SetDrawLayer("BACKGROUND", -7)
	border:SetVertexColor(0.4, 0.35, 0.35)
	border:ClearAllPoints()
	border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
	b.border = border
	--shadow
	local back = CreateFrame("Frame", nil, b.parent)
	back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
	back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
	back:SetFrameLevel(frame:GetFrameLevel() - 0)

	back.Backdrop = CreateFrame("Frame", "Backdrop", back, BackdropTemplateMixin and "BackdropTemplate")
	back.Backdrop:SetAllPoints()
	back.Backdrop:SetBackdrop(backdrop1)

	back.Backdrop:SetBackdropBorderColor(0, 0, 0, 0.9)
	b.bg = back
	--set button styled variable
end

-- setting timer for castbar icons

function UpdateTimer(self, elapsed)
	total = total + elapsed
	if TargetFrameSpellBar.Icon then
	--FIXME: styling target cast bar is broken. Fix it.
	-- check Imp Blizz UI to see how/if they are styling it
	--applycastSkin(TargetFrameSpellBar.Icon)
	end
	-- this seems like an absurd hack. TODO: Find a better way to do this; probably a better event to use
	-- if TargetFrameSpellBar.Icon.styled then
	-- 	cf:SetScript("OnUpdate", nil)
	-- end
end

---------------------------------------
-- INIT
---------------------------------------

hooksecurefunc(
	"TargetFrame_UpdateAuras",
	function(self)
		for i = 1, MAX_TARGET_BUFFS do
			b = _G["TargetFrameBuff" .. i]
			applySkin(b, true)
		end
		for i = 1, MAX_TARGET_DEBUFFS do
			b = _G["TargetFrameDebuff" .. i]
			applySkin(b, false)
		end
		for i = 1, MAX_TARGET_BUFFS do
			b = _G["FocusFrameBuff" .. i]
			applySkin(b, true)
		end
		for i = 1, MAX_TARGET_DEBUFFS do
			b = _G["FocusFrameDebuff" .. i]
			applySkin(b, false)
		end
	end
)

total = 0
--cf = CreateFrame("Frame", "Lorti_Auras")
--cf:SetScript("OnUpdate", UpdateTimer)
