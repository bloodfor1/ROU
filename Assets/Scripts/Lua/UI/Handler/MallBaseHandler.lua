--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/MallGoldPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
---@class MallBaseHandler : UIBaseHandler
MallBaseHandler = class("MallBaseHandler", super)
--lua class define end

--lua functions
function MallBaseHandler:ctor(handlerName, magicNum)

    super.ctor(self, handlerName, magicNum)

end --func end
--next--
function MallBaseHandler:Init()

    super.Init(self)

    self.mallMgr = MgrMgr:GetMgr("MallMgr")
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")

    self:InitTemplate()
end --func end
--next--
function MallBaseHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

    self.mallMgr = nil
    self.openMgr = nil
end --func end

function MallBaseHandler:BindEvents()
    --刷新所有数据
    self:BindEvent(self.mallMgr.EventDispatcher, self.mallMgr.Event.ResetData, function(self, mid)
        if self.curMallId == mid then
            self:SetTable(self.curMallId)
            local l_ctrl = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
            if l_ctrl then
                UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Mall_Refresh_Hint"))--商品已刷新
            end
        end
    end)
    --单个商品数据改变
    self:BindEvent(self.mallMgr.EventDispatcher, self.mallMgr.Event.ResetItem, function(self, mid, data)
        if self.curMallId == mid then
            local l_tem = self.ItemPool:FindShowTem(function(tem)
                return tem.data == data
            end)
            if l_tem then
                l_tem:SetData(data)
            end
        end
    end)
end

function MallBaseHandler:OnActive()

    super.OnActive(self)

    self.globalOpened = false
    self.openTbl = {}

    if self.name ~= HandlerNames.MallFeeding then
        --新手指引相关
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "MallGuide" }, UI.CtrlNames.Mall)
    end
end

function MallBaseHandler:OnDeActive()

    super.OnDeActive(self)

    self.openTbl = nil
    self.globalOpened = false
end

function MallBaseHandler:InitTemplate()
    self.ItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MallItemPrefab,
        ScrollRect = self.panel.ItemGroup.LoopScroll,
        TemplatePrefab = self.ctrlRef.panel.MallItemPrefab.LuaUIGroup.gameObject,
        Method = handler(self, self.OnSelectItem),
        SetCountPerFrame = 2,
        CreateObjPerFrame = 2,
    })
end

function MallBaseHandler:OnSelectItem(tem)

    local l_refresh, l_mData = self.mallMgr.GetMallData(self.curMallId, false)
    if l_refresh or not l_mData.data then
        return
    end

    self.mallMgr.chooseItem = nil
    self.ItemPool:SelectTemplate(tem.ShowIndex)

    local l_data = tem.data
    local l_mallRow = tem.mallRow
    local l_time
    if tem.mallRow.ShowCountDown and l_data.next_refresh_time then
        l_time = l_data.next_refresh_time + MLuaCommonHelper.Int(l_mData.resetTime - MServerTimeMgr.UtcSeconds)
        l_time = math.max(0, l_time)
    end

    local propInfo = Data.BagModel:CreateItemWithTid(tem.itemRow.ItemID)
    propInfo.ItemCount = ToInt64(l_data.left_timess)
    propInfo.IsBind = l_data.is_bind

    local l_extraTips = nil
    if self.mallMgr.CanShowDeliverWay(l_mallRow.DeliverWay) then
        l_extraTips = Lang("MallMailNotify")
    end

    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, Data.BagModel.WeaponStatus.MALL, {
        --最多购买数 l_data.left_times=-1不限制购买数量
        maxValue = l_data.left_times >= 0 and l_data.left_times or 999,
        --货币id
        priceID = l_data.money_type,
        --现价
        priceNum = tonumber(l_data.now_price),
        --原价
        priceOriginal = tonumber(l_data.origin_price),
        --折扣
        discounts = tem.Discounts,
        --折扣剩余时间
        discountsTime = l_time,
        -- 购买提示
        btnNotifyContent = l_extraTips,
        --购买回调
        buyFunc = function(num)
            num = MLuaCommonHelper.Long2Int(num)
            if l_data.left_times < 0 or (num <= l_data.left_times and num > 0) then
                log("购买道具=> mid={0}; sid={1}; num={2}; price={3}", self.curMallId, l_data.seq_id, num, l_data.now_price)
                self.mallMgr.SendBuyMallItem(self.curMallId, l_data.seq_id, num, l_data.now_price)
            else
                --提示
                local l_mInterfaceRow
                local l_rows = TableUtil.GetMallInterfaceTable().GetTable()
                for i = 1, #l_rows do
                    local l_row = l_rows[i]
                    if l_row.Tab == l_mallRow.Tab and l_row.WeightId == l_mallRow.WeightPoolParameter then
                        l_mInterfaceRow = l_row
                        break
                    end
                end
                if l_mInterfaceRow and l_mInterfaceRow.RefreshIntervalType == 101 then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Mall_Upper_Limit_Day"))--该商品已达今日购买上限
                elseif l_mInterfaceRow and l_mInterfaceRow.RefreshIntervalType == 102 then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Mall_Upper_Limit_Week"))--该商品已达本周购买上限
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Mall_Upper_Limit"))--该商品已达购买上限
                end
            end
        end,
        -- 标识卖场高度特判
        forMallAutoSize = true
    })
end

function MallBaseHandler:SetTable(MID, extraType)

    self.curMallId = MID
    local l_refresh, l_data = self.mallMgr.GetMallData(self.curMallId, true)
    if l_refresh then
        return
    end
    if self.mallMgr.chooseItem ~= nil and l_data.data ~= nil then
        local l_index
        for i, v in ipairs(l_data.data) do
            if v.seq_id == self.mallMgr.chooseItem.MajorID then
                l_index = i
                break
            end
        end
        if l_index ~= nil then
            self.ItemPool:ShowTemplates({ Datas = l_data.data, StartScrollIndex = l_index })
            self.ItemPool:SelectTemplate(l_index)
        else
            self.ItemPool:ShowTemplates({ Datas = l_data.data })
            self.ItemPool:SelectTemplate(0)
        end
    else
        self.ItemPool:ShowTemplates({ Datas = l_data.data or {} })
        self.ItemPool:SelectTemplate(0)
    end

    self.ctrlRef:SetResetTimeInfo(self.name)
end

function MallBaseHandler:CustomSetToggle(tagName, mallType, redKey)
    self.panel[tagName].TogEx.isOn = false
    if self.openTbl[mallType] then
        self.panel[tagName]:OnToggleExChanged(function(b)
            if b then
                self:SetTable(mallType)
            end
        end, true)
        self.panel[tagName].gameObject:SetActiveEx(true)
        local l_ret = (not self.globalOpened) and (self.mallMgr.SelectTab == nil or self.mallMgr.SelectTab == mallType)
        self.panel[tagName].TogEx.isOn = l_ret
        if l_ret then
            self.globalOpened = true
        end
    else
        self.panel[tagName].gameObject:SetActiveEx(false)
    end
end

function MallBaseHandler:BuildMallTagTbl(mallTypeTbl)

    self.openTbl = {}
    for i, v in ipairs(mallTypeTbl) do
        self.openTbl[v] = self.mallMgr.IsSystemOpenByMallType(v)
    end
    if self.mallMgr.SelectTab then
        if not self.openTbl[self.mallMgr.SelectTab] then
            self.mallMgr.SelectTab = nil
        end
    end
end


--lua custom scripts end
return MallBaseHandler