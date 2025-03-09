--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildDepositorySalePanel"
require "UI/Template/GuildDepositorySaleItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
local l_guildDepositoryMgr = nil
local l_guildData = nil
--next--
--lua fields end

--lua class define
GuildDepositorySaleHandler = class("GuildDepositorySaleHandler", super)
--lua class define end

--lua functions
function GuildDepositorySaleHandler:ctor()
    
    super.ctor(self, HandlerNames.GuildDepositorySale, 0)
    
end --func end
--next--
function GuildDepositorySaleHandler:Init()
    
    self.panel = UI.GuildDepositorySalePanel.Bind(self)
    super.Init(self)
    l_guildData = DataMgr:GetData("GuildData")
    l_guildDepositoryMgr = MgrMgr:GetMgr("GuildDepositoryMgr")

    --初始化数据
    self.curSelectItem = nil  --当前选中的物品
    self.curBidPrice = 0  --当前竞标出价
    self.saleItemList = nil  --拍卖物品清单

    --按钮点击事件绑定
    self:ButtonEventBind()

    --拍卖清单物品项的池创建
    self.saleItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildDepositorySaleItemTemplate,
        TemplatePrefab = self.panel.GuildDepositorySaleItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.SaleScrollView.LoopScroll
    })

    --界面展示
    self:ShowSaleDetail()
    
end --func end
--next--
function GuildDepositorySaleHandler:Uninit()

    self.curSelectItem = nil
    self.curBidPrice = 0 
    self.saleItemList = nil 
    
    self.saleItemTemplatePool = nil

    super.Uninit(self)
    l_guildDepositoryMgr = nil
    l_guildData = nil
    self.panel = nil
    
end --func end
--next--
function GuildDepositorySaleHandler:OnActive()
    
    
end --func end
--next--
function GuildDepositorySaleHandler:OnDeActive()
    
    
end --func end
--next--
function GuildDepositorySaleHandler:Update()
    
    
end --func end


--next--
function GuildDepositorySaleHandler:BindEvents()
    
    --公会仓库数据
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_GET_GUILD_DEPOSITORY_DATA,function(self, depositoryInfo)
        self:ShowSaleDetail()
        --界面展示刷新
    end)

    --倒计时数据推送
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_TIME_COUNT_DOWN,function(self, timeTable)
        self.panel.CountDownText.LabText = Lang("GUILD_DEPOSITORY_SALE_REMIAN_TIME", 
        timeTable.day * 24 + timeTable.hour, timeTable.min, timeTable.sec)
        --按钮的文本设置
        self:SetBidButtonText()
    end)
    --出价消息返回
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_SALE_BID,function(self)
        --列表数据更新并刷新展示
        local l_saleList = l_guildData.GetGuildDepositorySaleList()
        if l_saleList and #l_saleList > 0 then
            self.saleItemTemplatePool:RefreshCells()
            self:OnSelectItem(self.curSelectItem or l_saleList[1])
        end
    end)

    --道具信息变更
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, MgrProxy:GetGameEventMgr().OnBagUpdate, function(self)
        --公会贡献变更数据比RPC数据晚一帧 要单独接
        self.panel.OwnText.LabText = tostring(MPlayerInfo.GuildContribution)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--展示界面
function GuildDepositorySaleHandler:ShowSaleDetail()
    --判断是否有拍卖列表数据 
    local l_saleList = l_guildData.GetGuildDepositorySaleList()
    if l_saleList and #l_saleList > 0 then
        --展示拍卖物品列表
        self.saleItemTemplatePool:ShowTemplates({Datas = l_saleList,
            Method = function(item)
                self.saleItemTemplatePool:SelectTemplate(item.ShowIndex)
                self:OnSelectItem(item.data)
            end})
        --初始显示第一个物品数据
        if not self.curSelectItem then
            self:OnSelectItem(l_saleList[1])
        end
        --倒计时显示
        local l_timeTable = Common.TimeMgr.GetCountDownDayTimeTable(l_guildDepositoryMgr.NextTime)
        self.panel.CountDownText.LabText = Lang("GUILD_DEPOSITORY_SALE_REMIAN_TIME", 
            l_timeTable.day * 24 + l_timeTable.hour, l_timeTable.min, l_timeTable.sec)
    end
end

--按钮点击事件绑定
function GuildDepositorySaleHandler:ButtonEventBind()
    --竞价按钮点击
    self.panel.BtnBid:AddClick(function ()
        --CD确认
        if self.curSelectItem.lastCancelTime > 0 then
            local l_cancelCD = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("AuctionCancelBiddingCd").Value or 0)
            local l_deltaTime = Common.TimeMgr.GetNowTimestamp() - self.curSelectItem.lastCancelTime
            if l_deltaTime < l_cancelCD then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_SALE_BID_CANCEL_CD"))
                return
            end
        end
        --消耗图标字符串获取
        local l_costItemData = TableUtil.GetItemTable().GetRowByItemID(GameEnum.l_virProp.GuildContribution)
        local l_iconStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), l_costItemData.ItemIcon, l_costItemData.ItemAtlas, 20, 1)
        local l_costStr = l_iconStr..tostring(self.curBidPrice)
        --完整字符串获取
        local l_costText = Lang("GUILD_DEPOSITORY_SALE_BID_CHECK", self.curSelectItem.itemName, l_costStr)
        local l_haveText = Lang("CURRENT_HAVE", l_iconStr..tostring(MPlayerInfo.GuildContribution))

        CommonUI.Dialog.ShowCostCheckDlg(true, Lang("GUILD_SALE_BID"), l_costText, l_haveText, function ()
            self:BidItem()
        end, nil, nil, CommonUI.Dialog.DialogTopic.GUILD_DEPOSITORY_SALE)
    end)
    --修改出价按钮点击
    self.panel.BtnModify:AddClick(function ()
        --CD确认
        if self.curSelectItem.lastModifyTime > 0 then
            local l_modifyCD = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("AuctionChangeBiddingCd").Value or 0)
            local l_deltaTime = Common.TimeMgr.GetNowTimestamp() - self.curSelectItem.lastModifyTime
            if l_deltaTime < l_modifyCD then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_SALE_BID_MODIFY_CD"))
                return
            end
        end
        --消耗图标字符串获取
        local l_costItemData = TableUtil.GetItemTable().GetRowByItemID(GameEnum.l_virProp.GuildContribution)
        local l_iconStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), l_costItemData.ItemIcon, l_costItemData.ItemAtlas, 20, 1)
        local l_costStr = l_iconStr..tostring(self.curBidPrice)
        --完整字符串获取
        local l_costText = Lang("GUILD_DEPOSITORY_SALE_MODIFY_CHECK", self.curSelectItem.itemName, l_costStr)
        local l_haveText = Lang("GUILD_DEPOSITORY_SALE_MODIFY_TIP")

        CommonUI.Dialog.ShowCostCheckDlg(true, Lang("GUILD_SALE_BID_MODIFY"), l_costText, l_haveText, function ()
            self:BidItem()
        end, nil, nil, CommonUI.Dialog.DialogTopic.GUILD_DEPOSITORY_SALE)
    end)
    --取消竞拍按钮点击
    self.panel.BtnCancel:AddClick(function ()
        --提示与备注获取
        local l_costText = Lang("GUILD_DEPOSITORY_SALE_CANCEL_CHECK")
        local l_haveText = Lang("GUILD_DEPOSITORY_SALE_CANCEL_TIP")

        CommonUI.Dialog.ShowCostCheckDlg(true, Lang("GUILD_SALE_BID_CANCEL"), l_costText, l_haveText, function ()
            l_guildDepositoryMgr.ReqBidItem(self.curSelectItem.itemUid, 0)
        end, nil, nil, CommonUI.Dialog.DialogTopic.GUILD_DEPOSITORY_SALE)
    end)
end

--出价
function GuildDepositorySaleHandler:BidItem()
    --判断贡献是否足够 如果原本有出价 则判断差值是否够
    local l_checkCost = self.curBidPrice
    if self.curSelectItem.selfPrice ~= 0 then
        l_checkCost = self.curBidPrice - self.curSelectItem.selfPrice
    end
    if tonumber(tostring(MPlayerInfo.GuildContribution)) < l_checkCost then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CONTRIBUTION_NOT_ENOUGH"))
        return
    end
    --判断修改价格和原价格是否一样
    if self.curBidPrice == self.curSelectItem.selfPrice then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MODIFY_GUILD_SALE_BID_FAILED"))
        return
    end
    l_guildDepositoryMgr.ReqBidItem(self.curSelectItem.itemUid, self.curBidPrice)
end

--选中物品事件
function GuildDepositorySaleHandler:OnSelectItem(itemData)
    
    --数据为空判断
    if not itemData then
        return
    end

    --记录当前物品
    self.curSelectItem = itemData

    --物品基础信息展示
    if itemData.itemRow then
        self.panel.ItemName.LabText = itemData.itemName
        self.panel.ItemDescription.LabText = MgrMgr:GetMgr("ItemPropertiesMgr").GetDetailInfo(itemData.itemId)
    end

    --价格相关数据赋值
    --当前竞标出价等于临时存储的操作价格或者底价
    self.curBidPrice = itemData.tempPrice > 0 and itemData.tempPrice or itemData.reservePrice
    --底价
    self.panel.ReservePriceText.LabText = tostring(itemData.reservePrice)
    --出价
    self.panel.BidPriceBox.InputNumber.MinValue = itemData.reservePrice
    self.panel.BidPriceBox.InputNumber.MaxValue = 999999
    self.panel.BidPriceBox.InputNumber:SetValue(self.curBidPrice)
    self.panel.BidPriceBox.InputNumber.OnValueChange = function(value) 
        self.curBidPrice = tonumber(tostring(value))
        self.curSelectItem.tempPrice = self.curBidPrice
    end
    --已拥有
    self.panel.OwnText.LabText = tostring(MPlayerInfo.GuildContribution)
    --是否有已竞价 
    if itemData.selfPrice > 0 then
        --有竞价 竞价栏正常显示 显示修改、取消按钮
        self.panel.SelfPriceText.LabText = tostring(itemData.selfPrice)
        self.panel.SelfPriceBg:SetGray(false)
        self.panel.BtnBid.UObj:SetActiveEx(false)
        self.panel.BtnModify.UObj:SetActiveEx(true)
        self.panel.BtnCancel.UObj:SetActiveEx(true)
    else
        --无竞价 竞价栏清空并置灰 显示竞价按钮
        self.panel.SelfPriceText.LabText = ""
        self.panel.SelfPriceBg:SetGray(true)
        self.panel.BtnBid.UObj:SetActiveEx(true)
        self.panel.BtnModify.UObj:SetActiveEx(false)
        self.panel.BtnCancel.UObj:SetActiveEx(false)
    end
    --按钮的文本设置
    self:SetBidButtonText()
end

--竞价 修改竞价 按钮的文本设置
function GuildDepositorySaleHandler:SetBidButtonText()
    
    if self.curSelectItem.selfPrice > 0 then
        --有竞价 修改按钮的文本控制
        --判断是否显示CD 修改CD
        if self.curSelectItem.lastModifyTime > 0 then
            local l_modifyCD = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("AuctionChangeBiddingCd").Value or 0)
            local l_deltaTime = Common.TimeMgr.GetNowTimestamp() - self.curSelectItem.lastModifyTime
            if l_deltaTime < l_modifyCD then
                local l_timeTable = Common.TimeMgr.GetCountDownDayTimeTable(l_modifyCD - l_deltaTime)
                self.panel.BtnModifyText.LabText = Lang("GUILD_SALE_MODIFY_CD", l_timeTable.min, l_timeTable.sec)
            else
                self.panel.BtnModifyText.LabText = Lang("GUILD_SALE_BID_MODIFY")
            end
        else
            self.panel.BtnModifyText.LabText = Lang("GUILD_SALE_BID_MODIFY")
        end
    else
        --无竞价 竞价按钮的文本控制
        --判断是否显示CD 取消CD
        if self.curSelectItem.lastCancelTime > 0 then
            local l_cancelCD = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("AuctionCancelBiddingCd").Value or 0)
            local l_deltaTime = Common.TimeMgr.GetNowTimestamp() - self.curSelectItem.lastCancelTime
            if l_deltaTime < l_cancelCD then
                local l_timeTable = Common.TimeMgr.GetCountDownDayTimeTable(l_cancelCD - l_deltaTime)
                self.panel.BtnBidText.LabText = Lang("GUILD_SALE_CANCEL_CD", l_timeTable.min, l_timeTable.sec)
            else
                self.panel.BtnBidText.LabText = Lang("GUILD_SALE_BID")
            end
        else
            self.panel.BtnBidText.LabText = Lang("GUILD_SALE_BID")
        end
    end

end
--lua custom scripts end
return GuildDepositorySaleHandler