local frame = CreateFrame("Frame")
local AttuneProgress = AttuneProgress

local items = {
	"Head 1",
	"Neck",
	"Shoulder 2",
	"Shirt",
	"Chest 3",
	"Waist 4",
	"Legs 5",
	"Feet 6",
	"Wrist 7",
	"Hands 8",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand 9",
	"SecondaryHand 10",
	"Ranged 11",
	"Tabard",
}

local HandleChar = function()
	if(not CharacterFrame:IsShown()) then return end
	for i, value in pairs(items) do
		key, index = string.split(" ", value)
		itemFrame = _G["Character"..key.."Slot"]
        itemLink = GetInventoryItemLink("player", i)
        AttuneProgress(itemFrame, itemLink)
	end
end

frame:SetParent("CharacterFrame")
frame:SetScript("OnShow", HandleChar)
frame:SetScript("OnEvent", function(self, event, unit) if(unit == "player") then HandleChar() end end)
frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
