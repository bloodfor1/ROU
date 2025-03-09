--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RunningBusinessPanel"
require "UI/Template/RunningBusinessPotTemplate"
require "UI/Template/RunningBusinessTradeTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
RunningBusinessCtrl = class("RunningBusinessCtrl", super)
--lua class define end

local l_mgr = MgrMgr:GetMgr("MerchantMgr")
local l_timeMgr = Common.TimeMgr
local l_bagModel = Data.BagModel
local l_data = DataMgr:GetData("MerchantData")
--lua functions
function RunningBusinessCtrl:ctor()

    super.ctor(self, CtrlNames.RunningBusiness, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function RunningBusinessCtrl:Init()

    self.panel = UI.RunningBusinessPanel.Bind(self)
    super.Init(self)
    -- 绑定事件
    self:BindingClickEvent()
    -- 初始化template
    self:InitTemplatePool()
    -- 上次选中节点
    self.lastSelectTemplate = nil
    -- 控制更新频率 
    self.updateFrameCtrl = 0
    -- 同步更新背包数据
    self:InitBaseBagProps()
    -- 商店刷新timer
    self.refreshShopTimer = nil

    self:InitCoinIcon()

    self:InitTitle()
end --func end
--next--
function RunningBusinessCtrl:Uninit()

    self.updateFrameCtrl = nil
    self.lastSelectTemplate = nil
    self.bagTemplatePool = nil
    self.bagTemplatePool = nil
    self.buyPanelActive = nil

    -- 清理数据
    if l_data then
        l_data.MerchantPotLastPoint = nil
        l_data.MerchantBagProps = nil
        l_data.MerchantPreSellProps = nil
        l_data.MerchantShowBagType = l_data.EMerchantBagType.Default
        l_data.MerchantShopType = l_data.EMerchantShopType.Sell
    end

    if self.refreshShopTimer then
        self:StopUITimer(self.refreshShopTimer)
        self.refreshShopTimer = nil
    end

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function RunningBusinessCtrl:OnActive()
    self:RunningBusinessPanelRefresh()
end --func end
--next--
function RunningBusinessCtrl:OnDeActive()


end --func end
--next--
function RunningBusinessCtrl:Update()
    -- 控制更新频率
    if self.updateFrameCtrl > 0 then
        self.updateFrameCtrl = self.updateFrameCtrl - 1
        return
    end
    self.updateFrameCtrl = 15

    self:RefreshFewFrame()
end --func end


--next--
function RunningBusinessCtrl:BindEvents()
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.MERCHANT_GOODS_CHANGED, self.RunningBusinessPanelRefresh)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.MERCHANT_DATA_UPDATE, function()
        self:InitBaseBagProps()
        self:CheckTips()
        self:RunningBusinessPanelRefresh()
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.MERCHANT_EVENT_UPDATE, function()
        self:OnMerchantEventUpdate()
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.CHANGE_TOG_PANEL, self.ChangeTogEvent)
end --func end

--next--
--lua functions end

--lua custom scripts

function RunningBusinessCtrl:RunningBusinessPanelRefresh()

    self.panel.CoinDetail.LabText = Lang("MerchantCurCoinFormat", tonumber(tostring(MPlayerInfo.MerchantCoin)), tonumber(TableUtil.GetBusinessGlobalTable().GetRowByName("FinishBoliCoin").Value))

    self.bagTemplatePool:ShowTemplates({
        Datas = l_data.MerchantBagProps,
        ShowMinCount = 100
    })

    if self.refreshShopTimer then
        self:StopUITimer(self.refreshShopTimer)
        self.refreshShopTimer = nil
    end

    -- 只有商店界面才显示出售、购买页面
    if l_data.MerchantShowBagType == l_data.EMerchantBagType.Shop then
        local l_sellVisible = (l_data.MerchantShopType == l_data.EMerchantShopType.Sell)
        self:UpdateShopSellPanelVisible(l_sellVisible)
        if l_sellVisible then
            self:RefreshSellShop()
        else
            self:RefreshBuyShop()
        end

        if l_data.CurMerchantState == l_data.EMerchantState.Running and l_data.MerchantShopDatas then
            self.refreshShopTimer = self:NewUITimer(function()
                l_mgr.RequestMerchantGetShopInfo()
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_GOODS_INFO_CHANGED"))
            end, l_data.MerchantShopDatas.outdate_time - Common.TimeMgr.GetNowTimestamp())
            self.refreshShopTimer:Start()
        end
    end
end

function RunningBusinessCtrl:CloseUI()

    UIMgr:DeActiveUI(self.name)
end

-- 绑定事件
function RunningBusinessCtrl:BindingClickEvent()

    self.panel.CloseButton:AddClick(function()
        self:CloseUI()
    end)

    self.panel.BtnSell:AddClick(function()
        l_mgr.RequestMerchantShopSell()
    end)

    self.panel.Tanhao:AddClick(function()
        l_mgr.RequestGetEvent(nil, true)
    end)

    self.panel.Btn_Submit:AddClick(function()
        l_mgr.RequestMerchantSubmit()
    end)

    self.buyPanelActive = true
    self.panel.TogBuying.TogEx.isOn = true
    self.panel.TogBuying.TogEx.onValueChanged:AddListener(function(a)
        if self.panel.TogBuying.TogEx.isOn then
            if not self.buyPanelActive then
                self.buyPanelActive = true
                l_data.MerchantShopType = l_data.EMerchantShopType.Buy
                self:InitBaseBagProps()
                self:RunningBusinessPanelRefresh()
            end
        end
    end)

    self.panel.TogSelling.TogEx.onValueChanged:AddListener(function(a)
        if self.panel.TogSelling.TogEx.isOn then
            if self.buyPanelActive then
                self.buyPanelActive = false
                l_data.MerchantShopType = l_data.EMerchantShopType.Sell
                self:InitBaseBagProps()
                self:RunningBusinessPanelRefresh()

                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_TO_SELL"))
            end
        end
    end)
end

-- 初始化pool
function RunningBusinessCtrl:InitTemplatePool()

    self.bagTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.RunningBusinessPotTemplate,
        TemplateParent = self.panel.BagContent.transform,
        ScrollRect = self.panel.BagScroll.LoopScroll,
    })

    if l_data.MerchantShowBagType == l_data.EMerchantBagType.Default then
        self.panel.MerchantGoods.gameObject:SetActive(false)
        -- MLuaCommonHelper.SetRectTransformPosX(self.panel.CargoBag.gameObject, 0)
    else
        self.shopTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.RunningBusinessTradeTemplate,
            TemplateParent = self.panel.Content.transform,
            TemplatePrefab = self.panel.RunningBusinessTradeTemplate.gameObject,
            -- ScrollRect=self.panel.ScrollView.LoopScroll,
        })
        self.panel.MerchantGoods.gameObject:SetActive(true)
        -- MLuaCommonHelper.SetRectTransformPosX(self.panel.CargoBag.gameObject, 230.13)
    end
end

-- 更新时间显示
function RunningBusinessCtrl:RefreshFewFrame()
    -- 跑商开始时间
    local l_curTime = l_timeMgr.GetNowTimestamp()
    local l_remainingMerchantTime = l_data.MerchantDuringTime + l_data.MerchantStartTime - l_curTime
    l_remainingMerchantTime = (l_remainingMerchantTime >= 0) and l_remainingMerchantTime or 0

    local l_remainintMerchantRet = l_timeMgr.GetCountDownDayTimeTable(l_remainingMerchantTime)
    self.panel.TradeTime.LabText = StringEx.Format("{0:00}:{1:00}", l_remainintMerchantRet.min, l_remainintMerchantRet.sec)

    -- 商店刷新时间倒计时
    if l_data.MerchantShowBagType == l_data.EMerchantBagType.Shop then
        local l_remainingRefreshTime = l_data.MerchantShopDatas.outdate_time - l_curTime
        l_remainingRefreshTime = (l_remainingRefreshTime >= 0) and l_remainingRefreshTime or 0
        local l_remainingRet = l_timeMgr.GetCountDownDayTimeTable(l_remainingRefreshTime)
        self.panel.SellShopTime.LabText = StringEx.Format("{0:00}:{1:00}", l_remainingRet.min, l_remainingRet.sec)
    end
end

---@return ItemData[]
function RunningBusinessCtrl:_getMerchantItems()
    local types = { GameEnum.EBagContainerType.Merchant }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

-- 同步背包数据
function RunningBusinessCtrl:InitBaseBagProps()
    l_data.MerchantPreSellProps = {}
    l_data.MerchantBagProps = {}
    local l_props = self:_getMerchantItems()
    for i, v in ipairs(l_props) do
        local itemDataCopy = table.ro_deepCopy(v)
        table.insert(l_data.MerchantBagProps, itemDataCopy)
    end
end

-- 刷新购买页面
function RunningBusinessCtrl:RefreshBuyShop()
    self.shopTemplatePool:ShowTemplates({ Datas = l_data.MerchantShopDatas.buy_items, Method = function(template, data)
        self:UpdateSelectState(template)
        local l_propInfo = Data.BagModel:CreateItemWithTid(data.item_id)
        -- 商店最大购买数量
        local l_maxValue = l_data.GetBuyLimitByPropId(data.item_id)
        if l_maxValue <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_GOODS_NOT_ENOUGH"))
            return
        end

        -- 货币足够
        local l_canBuyCount = math.floor(tonumber(tostring(MPlayerInfo.MerchantCoin)) / data.price)
        l_maxValue = l_maxValue >= l_canBuyCount and l_canBuyCount or l_maxValue
        if l_maxValue <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_BUY_LACK_COIN"))
            return
        end

        local cShopData = {
            price = data.price,
            recyleItem = GameEnum.l_virProp.MerchantCoin,
            maxValue = l_maxValue,
        }
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(l_propInfo, nil, Data.BagModel.WeaponStatus.TO_MERCHANT, cShopData)
    end })
    self:UpdateSelectState()
end

-- 刷新出售页面
function RunningBusinessCtrl:RefreshSellShop()

    self.panel.SellTotalCoin.LabText = tostring(self:CalculateTotalPrice())

    self.shopTemplatePool:ShowTemplates({ Datas = l_data.MerchantPreSellProps, Method = function(_, data)
    end })
    self:UpdateSelectState()
end

-- 设置页面显示
function RunningBusinessCtrl:UpdateShopSellPanelVisible(visible)

    self.panel.BtnSell.gameObject:SetActiveEx(visible)
    self.panel.SellTotalPrice.gameObject:SetActiveEx(visible)
    MLuaCommonHelper.SetRectTransformPosY(self.panel.RefreshTime.gameObject, visible and -420 or -453)
    MLuaCommonHelper.SetRectTransformHeight(self.panel.TradeBg.gameObject, visible and 385 or 425)
end

-- 更新item选中态
function RunningBusinessCtrl:UpdateSelectState(newTemplate)

    if self.lastSelectTemplate then
        self.lastSelectTemplate:UpdateSelectState(false)
        self.lastSelectTemplate = nil
    end
    if newTemplate then
        newTemplate:UpdateSelectState(true)
        self.lastSelectTemplate = newTemplate
    end
end

-- 计算当前待出售道具总价格
function RunningBusinessCtrl:CalculateTotalPrice()

    local l_totalPrice = 0
    if l_data.MerchantPreSellProps then
        for i, v in ipairs(l_data.MerchantPreSellProps) do
            l_totalPrice = l_totalPrice + v.price * v.item_count
        end
    end

    return l_totalPrice
end

-- 价格变化时，关闭tips
function RunningBusinessCtrl:CheckTips()

    if l_data.MerchantShowBagType ~= l_data.EMerchantBagType.Shop then
        return
    end

    if not UIMgr:IsActiveUI(CtrlNames.CommonItemTips) then
        return
    end
    local l_tips = UIMgr:GetUI(CtrlNames.CommonItemTips)
    if not l_tips then
        return
    end

    local l_tipsInfo = l_tips:GetTipsInfo()
    if not l_tipsInfo then
        return
    end

    local l_tipsInfoCom = l_tips:GetTemplentByName(l_tipsInfo, "shopSetInfo")
    local l_tipsNumCom = l_tips:GetTemplentByName(l_tipsInfo, "shopSetNum")
    if not l_tipsInfoCom or not l_tipsNumCom then
        return
    end

    local l_oriPrice = l_tipsInfoCom:GetInfoComponentValue()
    local l_selectCount = l_tipsNumCom:GetNumComponentValue()

    local l_propId = ((l_tipsInfo.data or {}).baseData or {}).TID
    if not l_propId then
        return
    end

    if l_data.MerchantShopType == l_data.EMerchantShopType.Sell then
        if l_oriPrice ~= l_data.GetSellPriceByPropId(l_propId) then
            MgrMgr:GetMgr("ItemTipsMgr").CloseCommonTips()
        end
    else
        if l_oriPrice ~= l_data.GetBuyPriceByPropId(l_propId) then
            MgrMgr:GetMgr("ItemTipsMgr").CloseCommonTips()
        end
    end
end

-- 显示事件列表信息
function RunningBusinessCtrl:ShowEventsInfo()

    UIMgr:ActiveUI(CtrlNames.RunningBusinessEventTips)
end

-- 收到服务器事件信息q
function RunningBusinessCtrl:OnMerchantEventUpdate()
    self:ShowEventsInfo()
end

function RunningBusinessCtrl:InitCoinIcon()
    local l_item = TableUtil.GetItemTable().GetRowByItemID(GameEnum.l_virProp.MerchantCoin)
    if l_item then
        self.panel.CoinIcon1:SetSprite(l_item.ItemAtlas, l_item.ItemIcon)
        self.panel.CoinIcon2:SetSprite(l_item.ItemAtlas, l_item.ItemIcon)
    else
        logError("RunningBusinessCtrl:InitCoinIcon() fail 找不到MerchantCoin配置")
    end
end

function RunningBusinessCtrl:ChangeTogEvent(auto)
    if (l_data.MerchantShopType == l_data.EMerchantShopType.Buy) then
        self.panel.TogBuying.TogEx.isOn = true
        self.panel.TogSelling.TogEx.isOn = false
    else
        self.panel.TogBuying.TogEx.isOn = false
        self.panel.TogSelling.TogEx.isOn = true
        if not auto then
            l_mgr.g_tmpShowIndex = nil
        end
    end
end

function RunningBusinessCtrl:InitTitle()
    local l_row = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
    if not l_row then
        return
    end

    self.panel.Text.LabText = Lang("MerchantShopName", l_row.MapEntryName)
end

--lua custom scripts end
return RunningBusinessCtrl
