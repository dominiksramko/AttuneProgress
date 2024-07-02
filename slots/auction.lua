local frame = CreateFrame("Frame")
local AttuneProgress = AttuneProgress
local AuctionFrameBrowse_Hooked = false

frame:RegisterEvent("AUCTION_HOUSE_SHOW")
frame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "AUCTION_HOUSE_SHOW" then
        HookAuctionHouseFrames()
    end

    if event == "AUCTION_ITEM_LIST_UPDATE" then
        HandleAuction()
    end
end)

function HookAuctionHouseFrames()
    if not AuctionFrameBrowse_Hooked then
        AuctionFrameBrowse_Hooked = true
        hooksecurefunc("AuctionFrameBrowse_Update", HandleAuction)

        hooksecurefunc("AuctionFrameBrowse_Update", function()
            local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
            if offset ~= AuctionFrameBrowse.currentOffset then
                AuctionFrameBrowse.currentOffset = offset
                HandleAuction()
            end
        end)
    end
    HandleAuction()
end

function HandleAuction()
    local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame);
    for i = 1, NUM_BROWSE_TO_DISPLAY do
        local itemIndex = offset + i
        local browseButton = _G["BrowseButton"..i]
        local itemFrame = _G["BrowseButton"..i.."Item"]
        local itemLink = GetAuctionItemLink("list", itemIndex)
        AttuneProgress(itemFrame, itemLink)
    end
end
