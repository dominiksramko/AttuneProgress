local AttuneType = {
    CANT_WRONG_RACE = -8,
    CANT_WRONG_ITEM = -6,
    CANT_NO_STATS = -3,
    CANT_WRONG_ARMOR = -2,
    CAN_ATTUNE = 1,
}

local ValidEquipSlots = {
    INVTYPE_2HWEAPON = true,
    INVTYPE_BODY = true,
    INVTYPE_CHEST = true,
    INVTYPE_CLOAK = true,
    INVTYPE_FEET = true,
    INVTYPE_FINGER = true,
    INVTYPE_HAND = true,
    INVTYPE_HEAD = true,
    INVTYPE_HOLDABLE = true,
    INVTYPE_LEGS = true,
    INVTYPE_NECK = true,
    INVTYPE_RANGED = true,
    INVTYPE_RANGEDRIGHT = true,
    INVTYPE_ROBE = true,
    INVTYPE_SHIELD = true,
    INVTYPE_SHOULDER = true,
    INVTYPE_THROWN = true,
    INVTYPE_TRINKET = true,
    INVTYPE_WAIST = true,
    INVTYPE_WEAPON = true,
    INVTYPE_WEAPONMAINHAND = true,
    INVTYPE_WEAPONOFFHAND = true,
    INVTYPE_WRIST = true,
}

local function IsItemEquippable(itemID)
    local equipSlot = select(9, GetItemInfo(itemID))
    return equipSlot and ValidEquipSlots[equipSlot]
end

local function GetItemIDFromLink(itemLink)
    if not itemLink then
        return nil
    end

    local _, _, itemString = string.find(itemLink, "|Hitem:(%d+):")
    if itemString then
        return tonumber(itemString)
    else
        return nil
    end
end

local function ColorText(text, r, g, b)
    local hexColor = string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
    return "\124cFF" .. hexColor .. text .. "\124r"
end


local function GetForgeText(itemLink)
    local forgeType = bit.rshift(CustomExtractItemBonus(itemLink), 12)
    if forgeType == 1 then
        return ColorText("TF ", 0.71, 0.75, 1)
    end
    if forgeType == 2 then
        return ColorText("WF ", 0.88, 0.46, 0.39)
    end
    if forgeType == 3 then
        return ColorText("LF ", 1, 1, 0.65)
    end
    return ""
end

local function GetProgressColors(progress)
    progress = math.max(0, math.min(100, progress))
    local red = {1, 0, 0}
    local yellow = {1, 1, 0}
    local green = {0, 1, 0}
    local r, g, b
    if progress < 50 then
        r = red[1] + (yellow[1] - red[1]) * (progress / 50)
        g = red[2] + (yellow[2] - red[2]) * (progress / 50)
        b = red[3] + (yellow[3] - red[3]) * (progress / 50)
    else
        r = yellow[1] + (green[1] - yellow[1]) * ((progress - 50) / 50)
        g = yellow[2] + (green[2] - yellow[2]) * ((progress - 50) / 50)
        b = yellow[3] + (green[3] - yellow[3]) * ((progress - 50) / 50)
    end
    return r, g, b
end

local function GetProgressText(itemLink)
    local itemID = GetItemIDFromLink(itemLink)
    local attuneType = CanAttuneItemHelper(itemID)
    local forgeText = GetForgeText(itemLink)

    if attuneType == AttuneType.CANT_NO_STATS then
        return nil
    end

    if attuneType == AttuneType.CANT_WRONG_RACE then
        return forgeText..ColorText("A", 0.9, 0, 0)
    end

    if attuneType == AttuneType.CANT_WRONG_ITEM then
        return forgeText..ColorText("A", 0.9, 0, 0)
    end

    if attuneType == AttuneType.CANT_WRONG_ARMOR then
        return forgeText..ColorText("A", 0.9, 0, 0)
    end

    if attuneType == AttuneType.CAN_ATTUNE then
        local attuneProgress = floor(GetItemLinkAttuneProgress(itemLink))
        if attuneProgress == 0 then
            return forgeText .. ColorText("A", 0, 0.9, 0)
        end
        if attuneProgress == 100 then
            return forgeText
        end
        local r,g,b = GetProgressColors(attuneProgress)
        return forgeText .. ColorText(attuneProgress, r, g, b)
    end
    
    return '?'
end

AttuneProgress = setmetatable({}, {
    __call = function(self, itemFrame, itemLink)
        if not itemLink then
            if itemFrame.attuneProgress then
                itemFrame.attuneProgress:Hide()
            end
            return
        end

        local itemID = GetItemIDFromLink(itemLink)

        local isEquippable = IsItemEquippable(itemID)
        if not isEquippable then
            if itemFrame.attuneProgress then
                itemFrame.attuneProgress:Hide()
            end
            return
        end

        if itemFrame.attuneProgress then
            local progressText = GetProgressText(itemLink)
            if not progressText then
                itemFrame.attuneProgress:Hide()
                return
            end
            itemFrame.attuneProgress:SetText(progressText)
            itemFrame.attuneProgress:Show()
        else
            local progressText = GetProgressText(itemLink)
            if not progressText then
                return
            end
            local textFrame = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            textFrame:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            textFrame:SetPoint("BOTTOM", 0, 5)
            textFrame:SetTextColor(1, 1, 1, 1)
            textFrame:SetText(progressText)
            itemFrame.attuneProgress = textFrame
        end
    end,
})
