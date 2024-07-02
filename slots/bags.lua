local frame = CreateFrame("Frame")
local AttuneProgress = AttuneProgress

local function HandleBag(bag)
    bagID = bag:GetID()
    size = bag.size
    name = bag:GetName()

    for i=1, size do
		bid = size - i + 1
		itemLink = GetContainerItemLink(bagID, i)
        itemFrame = _G[name.."Item"..bid]
        AttuneProgress(itemFrame, itemLink)
	end
end

function HandleBags()
    for _, bag in ipairs(ContainerFrame1.bags) do
        bag = _G[bag]
        HandleBag(bag)
	end
end

hooksecurefunc("ContainerFrame_OnShow", function()
    frame:RegisterEvent("BAG_UPDATE")
    frame:SetScript("OnEvent", function(self, event, ...)
        if event == "BAG_UPDATE" then
            HandleBags()
        end
    end)
	HandleBags()
end)

hooksecurefunc("ContainerFrame_OnHide", function()
    if(ContainerFrame1.bagsShown == 0) then
		frame:UnregisterEvent("BAG_UPDATE")
        frame:SetScript("OnEvent", nil)
		frame:Hide()
	end
end)
