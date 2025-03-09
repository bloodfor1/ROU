--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CatCaravanTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
CatCaravanTipsCtrl = class("CatCaravanTipsCtrl", super)
--lua class define end

--lua functions
function CatCaravanTipsCtrl:ctor()

    super.ctor(self, CtrlNames.CatCaravanTips, UILayer.Function, nil, ActiveType.Standalone)

    self.InsertPanelName = UI.CtrlNames.CatCaravan

end --func end
--next--
function CatCaravanTipsCtrl:Init()
    self.panel = UI.CatCaravanTipsPanel.Bind(self)
    super.Init(self)
    self.panel.Floor.Listener.onClick = function(obj, data)
        self.panel.Floor.gameObject:SetActiveEx(false)
        UIMgr:DeActiveUI(CtrlNames.CatCaravanTips)
        MLuaClientHelper.ExecuteClickEvents(data.position, CtrlNames.CatCaravanTips)
    end
end

--next--
function CatCaravanTipsCtrl:Uninit()
    self.ItemTem = nil
    self.tData = nil
    self.data = nil
    self.pos = nil
    self.recycleRow = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function CatCaravanTipsCtrl:OnActive()
    --self:SetParent(UI.CtrlNames.CatCaravan)
end --func end
--next--
function CatCaravanTipsCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function CatCaravanTipsCtrl:Update()
    -- do nothing
end --func end

--next--
function CatCaravanTipsCtrl:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onItemUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param itemData ItemData
---@param param boolean
function CatCaravanTipsCtrl._validFunc(itemData, param)
    if nil == itemData or GameEnum.ELuaBaseType.Boolean ~= type(param) then
        return false
    end

    local uid = itemData.UID
    local containsUID = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquipWithUid(uid)
    return containsUID == param
end

--- 获取符合条件道具对象
---@return ItemData
function CatCaravanTipsCtrl:_getValidBagItems(tid)
    if GameEnum.ELuaBaseType.Number ~= type(tid) then
        logError("[CatCaravan] invalid param")
        return {}
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local conditions = {
        { Cond = self._validFunc, Param = false },
        { Cond = itemFuncUtil.ItemMatchesTid, Param = tid },
    }

    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret
end

---@param itemInfo ItemUpdateData[]
function CatCaravanTipsCtrl:_onItemUpdate(itemInfo)
    if self.panel == nil then
        return
    end

    if self.recycleRow == nil or self.tData == nil or self.data == nil or self.pos == nil then
        return
    end

    if nil == itemInfo then
        logError("[CatCaravanTipsCtrl] invalid param")
        return
    end

    if 0 < #itemInfo then
        self:SetData(self.tData, self.data, self.pos)
    end
end

function CatCaravanTipsCtrl:SetData(tData, data, pos)
    if self.panel == nil then
        return
    end

    self.tData = tData
    self.data = data
    self.pos = pos
    self.recycleRow = TableUtil.GetRecycleTable().GetRowByID(self.data.item_id)
    local l_total = MgrMgr:GetMgr("CatCaravanMgr").GetCoinOrPropNumWithoutMultiTalentsEquip(self.recycleRow.ItemID)
    local l_color = (l_total >= self.data.item_count) and RoColorTag.Green or RoColorTag.Red
    self.panel.NeedNum.LabText = GetColorText(tostring(l_total), l_color) .. "/" .. tostring(self.data.item_count)
    self.panel.AwardNum.LabText = tostring(data.price)--self.recycleRow.Reputation * self.data.item_count

    local l_showData = {
        ID = self.recycleRow.ItemID,
        IsShowCount = false,
    }

    if self.ItemTem == nil then
        self.ItemTem = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.panel.NeedIcon.transform,
            Data = l_showData
        })
    else
        self.ItemTem:SetData(l_showData)
    end

    self.panel.SetBtn:AddClick(function()
        local l_total = MgrMgr:GetMgr("CatCaravanMgr").GetCoinOrPropNumWithoutMultiTalentsEquip(self.recycleRow.ItemID)
        if l_total < self.data.item_count then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.recycleRow.ItemID, nil, nil, nil, true)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CatCaravan_Materials"))--"材料不足，无法装货")
            return
        end

        local l_bagItems = self:_getValidBagItems(self.recycleRow.ItemID)
        local l_selectItems = self:FindItems(l_bagItems, self.data.item_count)
        l_total = 0
        for i = 1, #l_selectItems do
            l_total = l_total + l_selectItems[i].num
        end

        if not int64.equals(l_total, self.data.item_count) then
            logError(StringEx.Format("选择的数量不一致 => targetNum={0}; selectNum={1}", self.data.item_count, tostring(l_total)))
            return
        end

        MgrMgr:GetMgr("CatCaravanMgr").SendSellGoods(self.tData.id, self.data.id, l_selectItems)
        UIMgr:DeActiveUI(CtrlNames.CatCaravanTips)
    end, true)

    self.AwardItem = nil
    local l_awardID = MGlobalConfig:GetInt("FillTotalAward")
    local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(l_awardID)
    if l_awardData ~= nil then
        for i = 0, l_awardData.PackIds.Length - 1 do
            local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
            if l_packData ~= nil then
                for j = 0, l_packData.GroupContent.Count - 1 do
                    self.AwardItem = l_packData.GroupContent:get_Item(j, 0)
                    self.AwardItem = TableUtil.GetItemTable().GetRowByItemID(self.AwardItem)
                    break
                end
            end
        end
    end
    if self.AwardItem ~= nil then
        self.panel.AwardImage:SetSprite(self.AwardItem.ItemAtlas, self.AwardItem.ItemIcon, true)
    end

    self.panel.AwardImage.Listener.onClick = function(obj, data)
        if data ~= nil and tostring(data:GetType()) == "MoonClient.MPointerEventData" and data.Tag == CtrlNames.CurrencyDesc then
            return
        end
        UIMgr:ActiveUI(CtrlNames.CurrencyDesc, function(ctrl)
            ctrl:SetID(402)
        end)
    end

    --位置与镜像
    local l_pos = { x = self.pos.x, y = self.pos.y }
    l_pos.x = l_pos.x / UIMgr.uiRoot.transform.localScale.x
    l_pos.y = l_pos.y / UIMgr.uiRoot.transform.localScale.y
    l_pos.z = 0
    self.panel.Main.transform:SetLocalPos(l_pos)
    if l_pos.y <= self.panel.Background.transform.sizeDelta.y * 1.2 - (UIMgr.uiRoot.transform.sizeDelta.y / 2.0) then
        self.panel.Main.transform:SetLocalScaleY(-1)
        self.panel.Content.transform:SetLocalScaleY(-1)
        self.panel.Content.transform:SetLocalPosY(-91)
    else
        self.panel.Main.transform:SetLocalScaleY(1)
        self.panel.Content.transform:SetLocalScaleY(1)
        self.panel.Content.transform:SetLocalPosY(-76.6)
    end
end

---@param bagItems ItemData[]
function CatCaravanTipsCtrl:FindItems(bagItems, getNum)
    local getItems = {}
    for i = 1, #bagItems do
        local l_item = bagItems[i]
        if l_item.IsBind and l_item.ItemCount > 0 then
            local l_num = self:_getMinValue(l_item.ItemCount, getNum)
            getItems[#getItems + 1] = {
                uid = l_item.UID,
                num = l_num,
                bind = l_item.IsBind,
            }

            getNum = getNum - l_num
            if 0 >= getNum then
                return getItems
            end
        end
    end

    for i = 1, #bagItems do
        local l_item = bagItems[i]
        if (not l_item.IsBind) and l_item.ItemCount > 0 then
            local l_num = self:_getMinValue(l_item.ItemCount, getNum)
            getItems[#getItems + 1] = {
                uid = l_item.UID,
                num = l_num,
                bind = l_item.IsBind,
            }

            getNum = getNum - l_num
            if 0 >= getNum then
                return getItems
            end
        end
    end

    return getItems
end

function CatCaravanTipsCtrl:_getMinValue(valueLeft, valueRight)
    if valueLeft >= valueRight then
        return valueRight
    end

    return valueLeft
end

--lua custom scripts end
