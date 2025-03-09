--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AuctionCommodityDescriptionPanel"
require "UI/Template/AuctionDesItem"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
AuctionCommodityDescriptionCtrl = class("AuctionCommodityDescriptionCtrl", super)
--lua class define end

--lua functions
function AuctionCommodityDescriptionCtrl:ctor()
	
	super.ctor(self, CtrlNames.AuctionCommodityDescription, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function AuctionCommodityDescriptionCtrl:Init()
	
	self.panel = UI.AuctionCommodityDescriptionPanel.Bind(self)
	super.Init(self)

    self.auctionMgr = MgrMgr:GetMgr("AuctionMgr")


    -- 当前显示的分类
    self.showAuctionIndex = nil

    -- 当前页
    self.curPage = 1
    -- 最大页数
    self.maxPage = 1
    -- 每页数量
    self.perPage = 10

    -- 上一页
    self.panel.BtnPageUp:AddClick(function()
        self:SetPage(self.curPage - 1)
    end)
    -- 下一页
    self.panel.BtnPageDown:AddClick(function()
        self:SetPage(self.curPage + 1)
    end)

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AuctionCommodityDescription)
    end)

    -- 仅显示已关注
    self.panel.ShowFollowTog.Tog.isOn = false
    self.panel.ShowFollowTog.Tog.onValueChanged:AddListener(function(isOn)
        self:RefreshAuctionItems()
    end)

    self.auctionItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AuctionDesItem,
        TemplatePrefab = self.panel.AuctionDesItem.LuaUIGroup.gameObject,
        ScrollRect = self.panel.AuctionItemScroll.LoopScroll,
    })


    self.panel.RightEmptyText.LabText = Lang("TRADE_BUY_EMPTY")

    self:InitTogPanel()
    self:RefreshPageUI()
	
end --func end
--next--
function AuctionCommodityDescriptionCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function AuctionCommodityDescriptionCtrl:OnActive()
	
	
end --func end
--next--
function AuctionCommodityDescriptionCtrl:OnDeActive()
	
	
end --func end
--next--
function AuctionCommodityDescriptionCtrl:Update()
	
	
end --func end
--next--
function AuctionCommodityDescriptionCtrl:BindEvents()

end --func end
--next--
--lua functions end

--lua custom scripts

function AuctionCommodityDescriptionCtrl:InitTogPanel()
    self.panel.TogPanel.TogPanel.OnTogOn = function(index)
        self:OnIndexSelected(index)
    end
    local l_firstParentIndex = nil
    local l_firstChildIndex = nil
    local l_notEmptyState = self.auctionMgr.GetIndexNotEmptyStateForFollow()
    for _, parentIndex in ipairs(self.auctionMgr.auctionParentIndexList) do
        -- 不显示我的竞拍，推荐
        if parentIndex.index > 0 and l_notEmptyState[parentIndex.index] then
            if not l_firstParentIndex then l_firstParentIndex = parentIndex.index end

            local l_indexList = {}
            local l_nameList = {}
            table.insert(l_indexList, parentIndex.index)
            table.insert(l_nameList, parentIndex.name)
            for _, childIndex in ipairs(parentIndex.childIndexList) do
                if l_notEmptyState[childIndex.index] then
                    if l_firstParentIndex == parentIndex.index and not l_firstChildIndex then l_firstChildIndex = childIndex.index end

                    table.insert(l_indexList, childIndex.index)
                    table.insert(l_nameList, childIndex.name)
                end
            end
            self.panel.TogPanel.TogPanel:AddTogGroup(l_indexList, l_nameList)
        end
    end

    -- 默认选中第一个非空
    if l_firstChildIndex then
        self.panel.TogPanel.TogPanel:SetTogOn(l_firstChildIndex)
    elseif l_firstParentIndex then
        self.panel.TogPanel.TogPanel:SetTogOn(l_firstParentIndex)
    end
end

function AuctionCommodityDescriptionCtrl:OnIndexSelected(index)
    if index > 0 and self.auctionMgr.IsParentIndex(index) then return end
    --logError(index)
    self.showAuctionIndex = index
    self.curPage = 1
    self:RefreshAuctionItems()
end

function AuctionCommodityDescriptionCtrl:RefreshAuctionItems()
    local l_bI = (self.curPage - 1) * self.perPage + 1
    local l_eI = l_bI + self.perPage - 1
    local l_isFollow = self.panel.ShowFollowTog.Tog.isOn
    local l_itemDatas= self.auctionMgr.GetAuctionItemsSortedForFollow(self.showAuctionIndex, l_isFollow)
    local l_itemNum = #l_itemDatas
    self.maxPage = math.ceil(l_itemNum / self.perPage)
    if self.maxPage == 0 then self.maxPage = 1 end

    local l_bI = (self.curPage - 1) * self.perPage + 1
    local l_eI = l_bI + self.perPage - 1
    local l_itemDatasByPage = {}
    for i = l_bI, l_eI do
        table.insert(l_itemDatasByPage, l_itemDatas[i])
    end

    self:RefreshPageUI()
    self.auctionItemPool:ShowTemplates({Datas = l_itemDatasByPage})

    self.panel.RightEmpty:SetActiveEx(#l_itemDatasByPage == 0)
end

function AuctionCommodityDescriptionCtrl:SetPage(page)
    if page < 1 or page > self.maxPage then return end
    self.curPage = page
    self:RefreshPageUI()
    self:RefreshAuctionItems()
end

function AuctionCommodityDescriptionCtrl:RefreshPageUI()
    self.panel.PageText.LabText = self.curPage .. "/" .. self.maxPage
end

--lua custom scripts end
return AuctionCommodityDescriptionCtrl