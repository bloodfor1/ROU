--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LevelRewardPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
LevelRewardCtrl = class("LevelRewardCtrl", super)
--lua class define end

--lua functions
function LevelRewardCtrl:ctor()

    super.ctor(self, CtrlNames.LevelReward, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function LevelRewardCtrl:Init()

    self.panel = UI.LevelRewardPanel.Bind(self)
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("LevelRewardMgr")
    self.awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self.pointItems = {}
    self.previewAwards = {}
    self.lastChooseItem = nil

    self.growAwardItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.growContent.transform,
    })

    self.levelAwardItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.giftBagContent.transform,
    })

    self.panel.discountBtn:AddClick(function()
        self:OnDiscountBtn()
    end)

    self.panel.rewardBtn:AddClick(function()
        self:OnGetRewardBtn()
    end)

    self.panel.closeBtn:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

end --func end
--next--
function LevelRewardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.previewAwards = {}
    self.growAwardItemPool = nil
    self.levelAwardItemPool = nil
    self.lastChooseItem = nil
end --func end
--next--
function LevelRewardCtrl:OnActive()
    self.panel.GiftBagItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.playerIcon:SetActiveEx(false)

    self.uObj:GetComponent('RectTransform').sizeDelta = MUIManager:GetUIScreenSize()

    local rewards = self.mgr.UpdateLevelRewardsInfo()
    self:InitLines()
    self:InitRewards(rewards)
    self:RefreshCurrent(rewards)

end --func end

function LevelRewardCtrl:InitLines()
    local basePackageTable = TableUtil.GetBasePackageTable().GetTable()
    local count = #basePackageTable
    array.each(self.panel.line, function(v)
        v:SetActiveEx(true)
    end)
    for i = count, #self.panel.line do
        self.panel.line[i]:SetActiveEx(false)
    end
end

function LevelRewardCtrl:InitRewards(rewards)
    if #rewards > #self.panel.Point then
        logError("等级奖励prefab挂载节点数量小于奖励数")
    end
    for i, v in ipairs(self.panel.Point) do
        if rewards[i] then
            self:NewPoint(rewards[i], v)
        end
    end
end

function LevelRewardCtrl:NewPoint(data, point)
    local data = table.ro_clone(data)
    data.ctrl = self
    if not data.sdata then
        data.sdata = TableUtil.GetBasePackageTable().GetRowById(data.id)
    end
    local reward = self:NewTemplate("GiftBagItemTemplate", {
        TemplatePrefab = self.panel.GiftBagItemTemplate.LuaUIGroup.gameObject,
        TemplateParent = point.transform,
        Data = data
    })
    reward:AddLoadCallback(function(tmp)
        tmp:transform().anchoredPosition = Vector2.zero
    end)

    table.insert(self.pointItems, reward)
end

function LevelRewardCtrl:RefreshCurrent(rewards)
    local curItem
    for i, v in ipairs(self.pointItems) do
        if v:GetCurrentStatus() == GameEnum.RewardGiftStatus.CanTake then
            curItem = v
            break
        end
    end
    if not curItem then
        for i = #self.pointItems, 1, -1 do
            local v = self.pointItems[i]
            if v:GetCurrentStatus() ~= GameEnum.RewardGiftStatus.Lock then
                curItem = v
                break
            end
        end
    end
    if not curItem then
        curItem = self.pointItems[1]
    end
    if curItem then
        local size = Vector2(Screen.width, Screen.height)
        local sizeUI = MUIManager:GetUIScreenSize();
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.content.RectTransform)
        self.panel.content:GetComponent("ContentSizeFitter").enabled = false
        if next(self.pointItems) then
            local lastPoint = self.panel.Point[#self.pointItems]
            if lastPoint then
                local pos1 = MUIManager.UICamera:WorldToScreenPoint(lastPoint.transform.position)
                local _, pos2 = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.content.RectTransform, pos1, MUIManager.UICamera, nil)
                local contentOriginSize = self.panel.content.RectTransform.sizeDelta
                self.panel.content.RectTransform.sizeDelta = Vector2(math.min(pos2.x + 150, contentOriginSize.x), contentOriginSize.y)
            end
        end
        self.moveCo = MgrMgr:GetMgr("CoroutineMgr"):addCo(function()
            AwaitTime(0.1)
            if self.panel then
                local pos1 = MUIManager.UICamera:ScreenToWorldPoint(Vector3(size.x * 0.6, size.y / 2, 0))
                local minx = self.panel.scroll.RectTransform.sizeDelta.x - self.panel.content.RectTransform.sizeDelta.x
                local minWorldPos = MUIManager.UICamera:ScreenToWorldPoint(Vector3(minx / sizeUI.x * size.x, size.y / 2, 0))

                local pos2 = curItem:gameObject().transform.position
                if pos1.x < pos2.x then
                    local xDelta = pos1.x - pos2.x
                    local pos3 = self.panel.content.transform.position
                    self.panel.content.transform.position = Vector3(math.max(minWorldPos.x, pos3.x + xDelta), pos3.y, pos3.z)
                end
            end
        end)
        self:ChooseItem(curItem)

        -- 玩家标记
        local id = curItem:GetId()
        local lv = MPlayerInfo.Lv
        if id > #self.panel.playerPos then
            self.panel.playerIcon:SetActiveEx(false)
            logError("player pos 不足")
        elseif lv < self.mgr.g_level_start or lv >= self.mgr.g_level_end then
            self.panel.playerIcon:SetActiveEx(false)
        else
            self.panel.playerIcon:SetActiveEx(true)
            self.panel.playerLv.LabText = StringEx.Format("Lv.{0}", lv)
            local idx = math.floor((lv-self.mgr.g_level_start) / 10) + 1
            self.panel.playerIcon.RectTransform.anchoredPosition = self.panel.playerPos[idx].RectTransform.anchoredPosition
        end
    else
        self.panel.growingUp:SetActiveEx(false)
        self.panel.upgrade:SetActiveEx(false)
    end
end

function LevelRewardCtrl:ChooseItem(item)
    if self.lastChooseItem then
        if self.lastChooseItem == item then
            return
        end
        self.lastChooseItem:Select(false)
        self.lastChooseItem = nil
    end
    item:Select(true)
    self.lastChooseItem = item
    self:RefreshBags(item)
end

function LevelRewardCtrl:RefreshBags(item)
    self.growupAwardSignature = self:GetAwardSignature(item.data.sdata.FreeBasePackage)
    self.levelUpAwardSignature = self:GetAwardSignature(item.data.sdata.SaleBasePackage)
    self:RefreshGrowingGiftBag(item.data, item.status)
    self:RefreshLevelUpGiftBag(item.data, item.status)
end

function LevelRewardCtrl:RefreshGrowingGiftBag(data, status)
    local sdata = data.sdata
    if sdata and sdata.FreeBasePackage.Count > 0 then
        self.panel.growingUp:SetActiveEx(true)
        self.panel.growTxt.LabText = Lang("LEVEL_REWARD_FREE_BAG_TEXT", sdata.Base)
        local signature = self:GetAwardSignature(sdata.FreeBasePackage)
        if self.previewAwards[signature] then
            self:OnGrowAwardMsg(self.previewAwards[signature], nil, signature)
        else
            self.awardPreviewMgr.GetBatchPreviewRewards(Common.Functions.VectorToTable(sdata.FreeBasePackage), self.mgr.AWARD_PREVIEW_GROW_REWARD)
        end
        local finish = data[0] and data[0] == 1 or false
        self.panel.rewardBtn:SetGray(status == GameEnum.RewardGiftStatus.Lock)
        self.panel.rewardBtn:SetActiveEx(not finish)
        self.panel.rewardBtn.transform:Find("RedSignPrompt").gameObject:SetActiveEx(status == GameEnum.RewardGiftStatus.CanTake)
        self.panel.finishGrowReward:SetActiveEx(finish)
    else
        self.panel.growingUp:SetActiveEx(false)
    end
end

function LevelRewardCtrl:RefreshLevelUpGiftBag(data, status)
    local sdata = data.sdata
    if sdata and sdata.SaleBasePackage.Count > 0 then
        self.panel.upgrade:SetActiveEx(true)
        self.panel.giftBagTxt.LabText = Lang("LEVEL_REWARD_BUG_BAG_TEXT", sdata.Base)
        self.panel.price.LabText = sdata.SaleBasePackageValue[0][1] or 0
        self.panel.disCountPrice.LabText = sdata.SaleBasePackagePrice[0][1] or 0
        if #sdata.SaleBasePackageValue > 0 then
            local itemId = sdata.SaleBasePackageValue[0][0]
            local itemSdata = TableUtil.GetItemTable().GetRowByItemID(itemId)
            if itemSdata then
                self.panel.concurrencyIcon[1]:SetSpriteAsync(itemSdata.ItemAtlas, itemSdata.ItemIcon)
                self.panel.concurrencyIcon[2]:SetSpriteAsync(itemSdata.ItemAtlas, itemSdata.ItemIcon)
            end
        end
        local signature = self:GetAwardSignature(sdata.SaleBasePackage)
        if self.previewAwards[signature] then
            self:OnLevelAwardMsg(self.previewAwards[signature], nil, signature)
        else
            self.awardPreviewMgr.GetBatchPreviewRewards(Common.Functions.VectorToTable(sdata.SaleBasePackage), self.mgr.AWARD_PREVIEW_LEVEL_REWARD)
        end
        local finish = data[1] and data[1] == 1 or false
        self.panel.discountBtn:SetGray(status == GameEnum.RewardGiftStatus.Lock)
        self.panel.discountBtn:SetActiveEx(not finish)
        self.panel.discountBtn.transform:Find("RedSignPrompt").gameObject:SetActiveEx(status == GameEnum.RewardGiftStatus.CanTake)
        self.panel.finishLevelReward:SetActiveEx(finish)
    else
        self.panel.upgrade:SetActiveEx(false)
    end
end

function LevelRewardCtrl:GetAwardSignature(awardPackage)
    local ret = ""
    local awardIds = awardPackage
    if awardPackage.Count then
        awardIds = Common.Functions.VectorToTable(awardPackage)
    end
    table.sort(awardIds, function(a, b)
        return a < b
    end)
    for i, v in ipairs(awardIds) do
        ret = ret .. v
    end
    return ret
end

--next--
function LevelRewardCtrl:OnDeActive()
    if self.moveCo then
        MgrMgr:GetMgr("CoroutineMgr"):removeCo(self.moveCo)
        self.moveCo = nil
    end
    UIMgr:DeActiveUI(UI.CtrlNames.Dialog)


end --func end
--next--
function LevelRewardCtrl:Update()


end --func end

--next--
function LevelRewardCtrl:BindEvents()
    self:BindEvent(self.awardPreviewMgr.EventDispatcher, self.mgr.AWARD_PREVIEW_GROW_REWARD, self.OnGrowAwardMsg)
    self:BindEvent(self.awardPreviewMgr.EventDispatcher, self.mgr.AWARD_PREVIEW_LEVEL_REWARD, self.OnLevelAwardMsg)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.LEVEL_REWARD_REFRESH_ITEM, self.OnRefreshItem)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.LEVEL_REWARD_REFRESH_LEVEL, self.OnRefreshLevel)
end --func end
--next--
--lua functions end

--lua custom scripts
function LevelRewardCtrl:OnGrowAwardMsg(info, sendAwardIds, signature)
    local datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleBatchAwardRes(info)
    self.growAwardItemPool:ShowTemplates({ Datas = datas })
    local signature = signature
    if not signature then
        local awardIds = {}
        for i, v in ipairs(sendAwardIds) do
            table.insert(awardIds, v.value)
        end
        signature = self:GetAwardSignature(awardIds)
    end
    self.previewAwards[signature] = info
end

function LevelRewardCtrl:OnLevelAwardMsg(info, sendAwardIds, signature)
    local datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleBatchAwardRes(info)
    self.levelAwardItemPool:ShowTemplates({ Datas = datas })
    local signature = signature
    if not signature then
        local awardIds = {}
        for i, v in ipairs(sendAwardIds) do
            table.insert(awardIds, v.value)
        end
        signature = self:GetAwardSignature(awardIds)
    end
    self.previewAwards[signature] = info
end

function LevelRewardCtrl:OnRefreshItem(giftId, giftInfo)
    local item = array.find(self.pointItems, function(v)
        return v.data.sdata.Id == giftId
    end)
    if item then
        giftInfo = table.ro_clone(giftInfo)
        giftInfo.ctrl = self
        item:SetData(giftInfo)
    end
    self:RefreshBags(item)
end

function LevelRewardCtrl:OnRefreshLevel()
    local rewards = self.mgr.UpdateLevelRewardsInfo()
    if #rewards > #self.panel.Point then
        logError("等级奖励prefab挂载节点数量小于奖励数")
    end
    for i, v in ipairs(self.panel.Point) do
        if rewards[i] then
            local data = table.ro_clone(rewards[i])
            data.ctrl = self
            if not self.pointItems[i] then
                self:NewPoint(data, v)
            else
                self.pointItems[i]:SetData(data)
            end
        end
    end
    self:RefreshCurrent(rewards)
end

function LevelRewardCtrl:OnGetRewardBtn()
    if self.lastChooseItem then
        if self.lastChooseItem:GetCurrentStatus() == GameEnum.RewardGiftStatus.Lock then
            return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LEVEL_REWARD_CAN_NOT_TAKE"))
        end
        self.mgr.ReceiveLevelGift(self.lastChooseItem.data.sdata.Id, 0)
    end
end

function LevelRewardCtrl:OnDiscountBtn()
    if self.lastChooseItem then
        if self.lastChooseItem:GetCurrentStatus() == GameEnum.RewardGiftStatus.Lock then
            return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LEVEL_REWARD_CAN_NOT_TAKE"))
        end

        local costItemId = self.lastChooseItem:GetCostId()
        if costItemId == 0 then
            return logError("invalid cost id: ", costItemId)
        end

        local propNum = Data.BagModel:GetCoinOrPropNumById(costItemId)
        local cost = self.lastChooseItem:GetCost()
        if propNum >= cost then
            local content = Lang("LEVEL_REWARD_CONSUME_CONTENT", MNumberFormat.GetNumberFormat(self.lastChooseItem:GetCost()), self.lastChooseItem:GetLv(), costItemId)
            content = MgrMgr:GetMgr("RichTextFormatMgr").FormatRichTextContent(content)
            CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm,true, nil,content, Common.Utils.Lang("DLG_BTN_YES"),Common.Utils.Lang("DLG_BTN_NO"), function()
                self.mgr.ReceiveLevelGift(self.lastChooseItem.data.sdata.Id, 1)
            end, nil, nil, 0)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LEVEL_REWARD_PROP_NOT_ENOUGTH", TableUtil.GetItemTable().GetRowByItemID(costItemId).ItemName))
            local propInfo = Data.BagModel:CreateItemWithTid(costItemId)
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
        end
    end
end

--lua custom scripts end
return LevelRewardCtrl