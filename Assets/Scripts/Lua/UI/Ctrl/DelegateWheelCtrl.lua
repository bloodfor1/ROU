--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DelegateWheelPanel"
require "UI/Template/DelegateWheelItem"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local accelerateTime = 3
local keepTime = 2.5
local decelerateTime = 2
local keepX = accelerateTime + keepTime
local decelerateX = keepX + decelerateTime
--next--
--lua fields end

--lua class define
DelegateWheelCtrl = class("DelegateWheelCtrl", super)
--lua class define end

--lua functions
function DelegateWheelCtrl:ctor()

    super.ctor(self, CtrlNames.DelegateWheel, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
    --self:SetParent(UI.CtrlNames.DelegatePanel)
    self.InsertPanelName = UI.CtrlNames.DelegatePanel
    self.overrideSortLayer = UILayerSort.Function + 1

end --func end
--next--
function DelegateWheelCtrl:Init()

    self.panel = UI.DelegateWheelPanel.Bind(self)
    super.Init(self)
    self.items = {}
    self.awardMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self.mgr = MgrMgr:GetMgr("DelegateModuleMgr")
    self.shopMgr = MgrMgr:GetMgr("ShopMgr")
    self.coinDirty = false
    self.targetIndex = 0
    self.awardItemReverse = {}
    self.decelerated = false
    self.decelerateCount = 0
    self.lastInterval = 0
    self.ItemPool = self:NewTemplatePool(
            {
                ScrollRect = self.panel.ScrollView.LoopScroll,
                UITemplateClass = UITemplate.DelegateWheelItem,
                TemplatePrefab = self.panel.DelegateWheelItem.LuaUIGroup.gameObject,
                SetCountPerFrame = 1,
                CreateObjPerFrame = 2,
            })
end --func end
--next--
function DelegateWheelCtrl:Uninit()
    self.lastInterval = 0
    self.targetIndex = 0
    self.awardItemReverse = nil
    self.decelerated = false
    self.decelerateCount = 0
    self.ItemPool = nil
    super.Uninit(self)
    self.panel = nil
    self.coinDirty = false
end --func end
--next--
function DelegateWheelCtrl:OnActive()

    self:OnInit()

end --func end
--next--
function DelegateWheelCtrl:OnDeActive()
    if self.mgr.IsDelegateRewardKnown() then
    --if next(self.mgr.g_reward) then
        self:ShowReward()
    end
    self:OnUninit()

end --func end
--next--
function DelegateWheelCtrl:Update()
    self.ItemPool:OnUpdate()
    if self.startTween and self.panel and #self.items > 1 then
        self:UpdateTween()
    end
end --func end

--next--
function DelegateWheelCtrl:BindEvents()
    self:BindEvent(self.awardMgr.EventDispatcher, self.awardMgr.AWARD_PREWARD_MSG .. "DelegateWheelCtrl", self.OnGetReward)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.DELEGATE_RECONNECTED, function(...)
        self:OnUninit()
        self:OnInit()
    end)

    self:BindEvent(self.mgr.EventDispatcher, self.mgr.DELEGATE_UPDATE, function()
        if self.panel then
            self.panel.Number.LabText = self.mgr.GetLeftAwardTimes()
            self:UpdateRedPoint()
        end
    end)
    local shopMgr = MgrMgr:GetMgr("ShopMgr")
    self:BindEvent(shopMgr.EventDispatcher, shopMgr.DELEGATE_SHOP, function()
        if self.panel then
            self:InitShop()
        end
    end)
    self:BindEvent(shopMgr.EventDispatcher, shopMgr.BuyCommodity, self.OnBuyCommodity)
    self:BindEvent(Data.PlayerInfoModel.COINCHANGE, Data.onDataChange, function(mgr)
        self.coinDirty = true
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

local l_shopID = MGlobalConfig:GetInt("EntrustShopID")
local l_speed = 0.03

function DelegateWheelCtrl:OnInit()
    self.wheelAnimator = self.panel.WheelAnimator.gameObject:GetComponent("FxAnimationHelper")
    if self.wheelAnimator ~= nil then
        self.wheelAnimator:PlayAll()
        self.wheelAnimator:SetSpeed(1)
    end
    self.panel.DelegateWheelItem.LuaUIGroup.gameObject:SetActiveEx(false)
    local l_id = MGlobalConfig:GetInt("EntrustBoxAward")
    self.startTween = false
    self.awardMgr.GetPreviewRewards(l_id, self.awardMgr.AWARD_PREWARD_MSG .. "DelegateWheelCtrl")

    local l_rows = TableUtil.GetEntrustLevelTable().GetTable()
    local l_rowCount = #l_rows
    local l_target
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        if not l_target then
            l_target = l_row
        end
        if tonumber(MPlayerInfo.Lv) < l_row.BaseLevel then
            break
        end
        l_target = l_row
    end
    local l_value = 0
    --local l_count = tonumber(Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Certificates))
    local l_str = ""
    if l_target then
        local cost = math.min(self.mgr.GetCertificatesCost(), tonumber(l_target.RewardBoxLimit))
        l_value = cost / tonumber(l_target.RewardBoxLimit)
        l_str = tostring(cost) .. "/" .. tostring(l_target.RewardBoxLimit)
        self.panel.Text.LabText = StringEx.Format(Common.Utils.Lang("DELEGATE_TIPS"), l_target.RewardBoxLimit)
    end
    self.panel.process.LabText = l_str
    self.panel.slider.Slider.value = l_value
    self.panel.Number.LabText = self.mgr.GetLeftAwardTimes()
    self.panel.WheelTitle.LabText = Lang("DELEGATE_WHEEL_TITLE")
    self.panel.WheelCostTxt.LabText = Lang("DELEGATE_WHEEL_COST_TITLE")

    self.panel.luckBtn:AddClick(function()
        if self.startTween then
            return
        end

        if self.mgr.GetLeftAwardTimes() > 0 then
            self.targetIndex = 0
            self.decelerated = false
            self.decelerateCount = 0
            self.mgr.TakeAward()
            self:StartTween()
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DELEGATE_LUCKYDRAW_NOT"))
        end
    end)

    self:UpdateNumber()
    self:UpdateRedPoint()
    MgrMgr:GetMgr("ShopMgr").RequestShopItem(l_shopID, true)

end

function DelegateWheelCtrl:OnUninit()
    local l_count = #self.items
    if l_count > 0 then
        for i = 1, l_count do
            MResLoader:DestroyObj(self.items[i].go)
        end
    end
    self.items = {}
    self.mgr.CleanDelegateReward()
    self.wheelAnimator = nil
end

function DelegateWheelCtrl:UpdateNumber()
    if not self.startTween then
        local l_count = MPlayerInfo.Debris
        self.panel.iconText.LabText = tostring(l_count)
    end
end

function DelegateWheelCtrl:OnGetReward(awardPreviewRes)
    local l_count = #self.items
    if l_count > 0 then
        for i = 1, l_count do
            MResLoader:DestroyObj(self.items[i].go)
        end
    end
    self.items = {}
    local l_datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleAwardRes(awardPreviewRes)
    local l_tp = self.panel.Item.gameObject
    for k, v in pairs(l_datas) do
        local l_info = v
        local l_index = #self.items + 1
        if l_index > 10 then
            logError("配置数量不正确")
            return
        end
        self.items[l_index] = {}
        local l_temp = self:CloneObj(l_tp)
        local l_p = l_tp.transform.parent:Find("p" .. tostring(l_index)):GetComponent("MLuaUICom").gameObject.transform
        l_temp.transform:SetParent(l_p)
        l_temp.transform:SetLocalPosZero()
        l_temp:SetLocalScaleToOther(l_tp)
        self.awardItemReverse[l_info.ID] = l_index
        local l_item = TableUtil.GetItemTable().GetRowByItemID(tonumber(l_info.ID))
        self.items[l_index].go = l_temp
        self.items[l_index].info = l_info
        self.items[l_index].go:SetActiveEx(true)
        self.items[l_index].icon = l_temp.transform:Find("Image"):GetComponent("MLuaUICom")
        self.items[l_index].mask = l_temp.transform:Find("Mask"):GetComponent("MLuaUICom")
        self.items[l_index].checked = l_temp.transform:Find("Checked"):GetComponent("MLuaUICom")
        self.items[l_index].icon.gameObject:SetActiveEx(true)
        self.items[l_index].mask.gameObject:SetActiveEx(false)
        self.items[l_index].checked.gameObject:SetActiveEx(false)
        self.items[l_index].fx = nil
        self.items[l_index].item = l_item
        self.items[l_index].icon:SetSprite(l_item.ItemAtlas, l_item.ItemIcon)
        self.items[l_index].go:GetComponent("MLuaUICom"):SetSprite(Data.BagModel.getItemBgAtlas(), Data.BagModel:getItemBgById(l_item.ItemID))
        self.items[l_index].icon:AddClick(function()
            local propInfo = Data.BagModel:CreateItemWithTid(tonumber(l_info.ID))
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, self.items[l_index].icon.gameObject.transform, nil, { IsShowCloseButton = false })
        end)
    end
end

function DelegateWheelCtrl:GetShopData()
    local l_items = {}
    local l_shopMgr = MgrMgr:GetMgr("ShopMgr")
    for i, v in ipairs(l_shopMgr.BuyShopItems) do
        local data = TableUtil.GetShopCommoditTable().GetRowById(v.table_id)
        table.insert(l_items, {
            data = data,
            price = Common.Functions.VectorSequenceToTable(data.ItemPerPrice)[1][2],
            count = data.ItemPerMount,
        })
    end
    return l_items
end

function DelegateWheelCtrl:InitShop()
    local moneyId = MGlobalConfig:GetInt("EntrustExchangeMoneyID")
    if moneyId then
        local itemSdata = TableUtil.GetItemTable().GetRowByItemID(moneyId)
        if itemSdata then
            self.panel.ShopIcon:SetSprite(itemSdata.ItemAtlas, itemSdata.ItemIcon)
        end
    end

    local l_items = self:GetShopData()
    if #l_items > 0 then
        self.ItemPool:ShowTemplates({ Datas = l_items })
    end
end

--==============================--
--@Description:商店物品更新
--@Date: 2019/6/10
--@Param: [args]
--@Return:
--==============================--
function DelegateWheelCtrl:OnBuyCommodity()
    if not self.startTween and self.ItemPool then
        self:UpdateNumber()
        self.ItemPool:RefreshCells()
    end
end

--==============================--
--@Description:开始转盘动画
--@Date: 2019/6/10
--@Param: [args]
--@Return:
--==============================--
function DelegateWheelCtrl:StartTween()
    local l_count = #self.items
    if l_count > 0 then
        for i = 1, l_count do
            self.items[i].mask.gameObject:SetActiveEx(false)
            self.items[i].checked.gameObject:SetActiveEx(false)
        end
    end
    self.startTime = Time.realtimeSinceStartup
    self.lastTime = nil
    self.interval = l_speed
    self.startTween = true
    self.panel.luckBtn:SetGray(true)
    if self.wheelAnimator then
        self.wheelAnimator:SetSpeed(12)
    end
end

--==============================--
--@Description:结束转盘动画
--@Date: 2019/6/10
--@Param: [args]
--@Return:
--==============================--
function DelegateWheelCtrl:EndTween()
    self.startTime = Time.realtimeSinceStartup
    self.lastTime = nil
    self.interval = l_speed
    self.startTween = false
    self.panel.luckBtn:SetGray(false)
    self:OnBuyCommodity()
    if self.wheelAnimator then
        self.wheelAnimator:SetSpeed(1)
    end
    if self.coinDirty then
        self:UpdateNumber()
        self.ItemPool:RefreshCells()
    end
end


--==============================--
--@Description:更新动画表现
--@Date: 2019/6/10
--@Param: [args]
--@Return:
--==============================--
function DelegateWheelCtrl:UpdateTween()
    accelerateTime = 1.5
    keepTime = 1
    decelerateTime = 2.2
    keepX = accelerateTime + keepTime
    decelerateX = keepX + decelerateTime
    l_speed = 0.0167
    if not self.indexNum then
        self.indexNum = 1
        if not self.items[self.indexNum] then
            return
        end
        self.items[self.indexNum].mask.gameObject:SetActiveEx(true)
    end
    if not self.lastTime then
        self.lastTime = Time.realtimeSinceStartup
    end
    -- 转盘尚未得知抽奖结果 且 服务器已经下发抽奖结果（存于g_reward）
    if self.targetIndex == 0 and self.mgr.IsDelegateRewardKnown() then
        local l_reward_id = self.mgr.GetDelegateRewardID()
        local l_index = self.awardItemReverse[l_reward_id]
        if l_index == nil then
            logError("服务器下发委托转盘道具<" .. l_reward_id .. ">不在转盘上，策划检测配置")
        else
            self.targetIndex = l_index
        end
    end

    local l_pass = Time.realtimeSinceStartup - self.startTime
    if l_pass <= accelerateTime then
        self.interval = math.pow(l_pass - accelerateTime, 2) * 0.04 + l_speed
    elseif l_pass > accelerateTime and l_pass < keepX then
        self.interval = l_speed
    else
        if self.decelerated then
            local l_offset = ((#self.items + self.indexNum) - self.targetIndex) % #self.items
            l_offset = l_offset + #self.items * (self.decelerateCount - 1)
            local l_rate = math.pow(l_offset / 4, 2) * 1.4
            self.interval = l_rate * l_speed
        else
            if self.targetIndex == self.indexNum then
                self.decelerated = true
                self.decelerateCount = self.decelerateCount + 1
                self.lastInterval = self.interval
            end
        end
    end
    if Time.realtimeSinceStartup - self.lastTime > self.interval then
        self.lastTime = Time.realtimeSinceStartup
        self.items[self.indexNum].mask.gameObject:SetActiveEx(false)

        local l_index = #self.items
        self.indexNum = self.indexNum + 1
        if self.indexNum > l_index then
            self.indexNum = 1
        end
        self.items[self.indexNum].mask.gameObject:SetActiveEx(true)

        if self.targetIndex == self.indexNum and self.decelerated then
            if self.decelerateCount < 2 then
                self.decelerateCount = self.decelerateCount + 1
                self.lastInterval = self.interval
            else
                if not self.mgr.IsDelegateRewardKnown() then
                    self.items[self.indexNum].mask.gameObject:SetActiveEx(false)
                    self.items[self.indexNum].checked.gameObject:SetActiveEx(false)
                    self:EndTween()
                else
                    if self.mgr.GetDelegateRewardID() == self.items[self.indexNum].info.ID then
                        self.items[self.indexNum].checked.gameObject:SetActiveEx(true)
                        self:ShowReward()
                        self:EndTween()
                    end
                end
            end
        end
    end
end

function DelegateWheelCtrl:ShowReward()
    -- MgrProxy:GetQuickUseMgr().OnItemChangeNtf(self.mgr.g_info)
    if self.mgr.IsDelegateRewardKnown() then
        local l_target_id = self.mgr.GetDelegateRewardID()
        local l_target_num = self.mgr.GetDelegateRewardNum()
        --local l_target = self.mgr.g_reward
        local l_opt = {
            itemId = l_target_id,
            itemOpts = { num = l_target_num, icon = { size = 18, width = 1.4 } },
        }
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)

        local l_specialTips = false
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_target_id)
        if l_itemRow and (l_itemRow.AccessPrompt == 1 or l_itemRow.AccessPrompt == 2) then
            l_specialTips = true
        end

        if l_specialTips then
            MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(l_target_id, l_target_num, nil)
        end
    end
    
    self.mgr.CleanDelegateReward()
end

function DelegateWheelCtrl:UpdateRedPoint()
    self.panel.RedSignPrompt.gameObject:SetActiveEx(self.mgr.GetLeftAwardTimes() > 0)
end
--lua custom scripts end
return DelegateWheelCtrl