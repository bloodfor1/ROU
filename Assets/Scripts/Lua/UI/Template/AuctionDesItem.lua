--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class AuctionDesItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field IsFollow MoonClient.MLuaUICom
---@field FollowTog MoonClient.MLuaUICom
---@field FollowBtn MoonClient.MLuaUICom

---@class AuctionDesItem : BaseUITemplate
---@field Parameter AuctionDesItemParameter

AuctionDesItem = class("AuctionDesItem", super)
--lua class define end

--lua functions
function AuctionDesItem:Init()
	
	super.Init(self)
	    self.auctionMgr = MgrMgr:GetMgr("AuctionMgr")
        self.Parameter.FollowBtn:AddClick(function()
            if self.itemId then
                self.auctionMgr.AuctionFollowItem(self.itemId, not self.Parameter.FollowTog.Tog.isOn)
            end
        end)
	    self.itemTemplate = self:NewTemplate("ItemTemplate",{
	        TemplateParent = self.Parameter.ItemIcon.transform
	    })
	
end --func end
--next--
function AuctionDesItem:BindEvents()
    self:BindEvent(self.auctionMgr.EventDispatcher, self.auctionMgr.EEventType.AuctionItemFollowRefresh, function(_, itemId)
        if self.itemId == itemId then
            self:Refresh()
        end
    end)
	
end --func end
--next--
function AuctionDesItem:OnDestroy()
	
	
end --func end
--next--
function AuctionDesItem:OnDeActive()
	
	
end --func end
--next--
function AuctionDesItem:OnSetData(data)
    self.itemId = data
    self:Refresh()
end --func end
--next--
--lua functions end

--lua custom scripts

function AuctionDesItem:Refresh()
    local l_isFollow = self.auctionMgr.IsFollow(self.itemId)
    self.Parameter.FollowTog.Tog.isOn = l_isFollow
    self.Parameter.IsFollow:SetActiveEx(l_isFollow)
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(self.itemId)
    if l_itemRow then
        self.Parameter.Name.LabText = l_itemRow.ItemName
    end
    self.itemTemplate:SetData({ID = self.itemId, IsShowCount = false, IsShowTips = true})
end

--lua custom scripts end
return AuctionDesItem