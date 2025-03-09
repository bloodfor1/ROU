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
local l_gameEventMgr = MgrProxy:GetGameEventMgr()
--lua fields end

--lua class define
---@class SelectEquipTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextName MoonClient.MLuaUICom
---@field SelfBg MoonClient.MLuaUICom
---@field Scale MoonClient.MLuaUICom
---@field OnlyWearToggle MoonClient.MLuaUICom
---@field NoneEquipText MoonClient.MLuaUICom
---@field EquipItemScroll MoonClient.MLuaUICom
---@field Dropdown_Root MoonClient.MLuaUICom
---@field Dropdown MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field SelectEquipItemPrefab MoonClient.MLuaUIGroup

---@class SelectEquipTemplate : BaseUITemplate
---@field Parameter SelectEquipTemplateParameter

local C_EQUIP_TYPE_MAP = {
    Common.Utils.Lang("AllText"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_WUQI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_FUSHOU"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_KUIJIA"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_PIFENG"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_XIEZI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_SHIPIN"),
    --Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_TOUSHI"),
    --Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_LIANSHI"),
    --Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_ZUISHI"),
    --Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_BEISHI"),
    --Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_ZAIJU"),
}

SelectEquipTemplate = class("SelectEquipTemplate", super)
--lua class define end

--lua functions
function SelectEquipTemplate:Init()
    super.Init(self)
    --当前选择的装备类型，0为全部
    self._currentEquipIndex = 0
    self._isOnlyShowBody = false
    self._noneEquipTextPosition = nil
    self._showHeight = nil
    self.Data = nil
    self.bagEquips = {}
    self.bodyEquip = {}
    self.Parameter.Dropdown.DropDown:ClearOptions()
    self.Parameter.Dropdown:SetDropdownOptions(C_EQUIP_TYPE_MAP)
    local onDropDownValueChanged = function(index)
        self:_onDropValueChanged(index)
    end

    self.Parameter.Dropdown.DropDown.onValueChanged:AddListener(onDropDownValueChanged)
    self._equipTemplatePool = self:NewTemplatePool(
            {
                TemplateClassName = "SelectEquipItemTemplate",
                TemplatePrefab = self.Parameter.SelectEquipItemPrefab.gameObject,
                ScrollRect = self.Parameter.EquipItemScroll.LoopScroll,
                Method = function(index)
                    self:_onEquipCell(index)
                end
            })
    self.Parameter.OnlyWearToggle:OnToggleChanged(function(isOn)
        self:_onOnlyWearToggleChange(isOn)
    end)

    self:_showDefaultButtonName()
end --func end
--next--
function SelectEquipTemplate:OnDestroy()
    self:_setDefaultHeight()
    self.Parameter.SelfBg:SetActiveEx(false)
    self.Parameter.Dropdown.DropDown:ClearOptions()
    self._equipTemplatePool = nil
    self._currentEquipIndex = 0
    self.Data = nil
end --func end
--next--
function SelectEquipTemplate:OnDeActive()
end --func end
--next--
function SelectEquipTemplate:OnSetData(data)
    self:_setData(data)
end --func end
--next--
function SelectEquipTemplate:BindEvents()

end --func end
--next--
--lua functions end

--lua custom scripts
---@class SelectEquipTemplateParam @使用SelectEquipTemplate所需要的配置参数
---@field SelectEquipMgrName string @mgr名字
---@field IsSelectSameEquip boolean @在切换时是否选择相同的装备
---@field IsDefaultNotSelectedEquip boolean @默认不选择装备
---@field NoneEquipTextPosition number[] @没有装备的时候显示的位置
---@field ShowHeight number @显示的高度
---@field OnItemSelected function<ItemData> @选中道具之后触发的回调
---@field OnItemSelectSelf table @选中道具之后回调的self
---@field StartSelectItemUID userdata @道具的UID，uint64，如果设置了这个，一开始就会在选择这个

---@param data SelectEquipTemplateParam
function SelectEquipTemplate:_setData(data)
    ---@type SelectEquipTemplateParam
    self.Data = data

    self._noneEquipTextPosition = data.NoneEquipTextPosition
    self._showHeight = data.ShowHeight
    self:_showTemplate(data)
    self:_setDefaultOption()
end

function SelectEquipTemplate:_setDefaultOption()
    if nil == self.Parameter.Dropdown then
        return
    end

    self.Parameter.Dropdown.DropDown.value = 0
end

function SelectEquipTemplate:_onDropValueChanged(index)
    self:_showEquipItems(index)
end

local l_noneEquipTextLocalPosition = Vector2.New(-232, -48)
local l_defaultHeight = 472.5

function SelectEquipTemplate:ctor(data)
    data.TemplatePath = "UI/Prefabs/SelectEquipPrefab"
    super.ctor(self, data)
end

--对断线重连进行处理，断线重连的时候背包道具数据会重新刷新一遍，因此这里也要重新刷新一遍
--需要new的地方调用
function SelectEquipTemplate:OnReconnected()
    local l_data = self.Data
    l_data.IsSelectSameEquip = true
    self:_showTemplate(l_data)
end

function SelectEquipTemplate:_setDefaultHeight()
    self.Parameter.Scale.gameObject:SetRectTransformHeight(l_defaultHeight)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.Scale.transform)
end

--显示整个界面
--SetData的时候调用
function SelectEquipTemplate:_showTemplate(data)
    if self._showHeight then
        self.Parameter.Scale.gameObject:SetRectTransformHeight(self._showHeight)
    else
        self.Parameter.Scale.gameObject:SetRectTransformHeight(l_defaultHeight)
    end

    self:_loadAllEquip(data)
    --刚开始以toggle的初始值来显示
    self:_setOnlyShowBody(self.Parameter.OnlyWearToggle.Tog.isOn)

    local l_isShowBg = false
    if MgrMgr:GetMgr(data.SelectEquipMgrName).IsShowSelectBg ~= nil then
        l_isShowBg = MgrMgr:GetMgr(data.SelectEquipMgrName).IsShowSelectBg()
    end

    if l_isShowBg then
        self.Parameter.SelfBg:SetActiveEx(true)
    else
        self.Parameter.SelfBg:SetActiveEx(false)
    end
end

--获取所有数据
function SelectEquipTemplate:_loadAllEquip(data)
    self.bagEquips = {}
    self.bodyEquip = {}
    for equipIndex, name in pairs(MgrMgr:GetMgr("EquipMgr").eEquipTypeName) do
        local l_bagEquips = MgrMgr:GetMgr("EquipMgr").GetEquipsInBagWithEquipId(equipIndex)
        local l_bodyEquips = MgrMgr:GetMgr("EquipMgr").GetEquipOnBodyWithEquipId(equipIndex)
        self.bagEquips[equipIndex] = MgrMgr:GetMgr(data.SelectEquipMgrName).GetSelectEquips(l_bagEquips)
        self.bodyEquip[equipIndex] = MgrMgr:GetMgr(data.SelectEquipMgrName).GetSelectEquips(l_bodyEquips)
    end
end

function SelectEquipTemplate:_onOnlyWearToggleChange(isShow)
    self:_setOnlyShowBody(isShow)
    --self:_showDefaultButtonName()
    self:_onEquipCell(1)
end

function SelectEquipTemplate:_showDefaultButtonName()
    self:_showEquipItems(0)
end

--点击仅显示已装备toggle的时候调用
function SelectEquipTemplate:_setOnlyShowBody(isShow)
    self._isOnlyShowBody = isShow
    self:_showEquipItems(self._currentEquipIndex)
end

--显示装备部位的装备
function SelectEquipTemplate:_showEquipItems(equipIndex)
    self._currentEquipIndex = equipIndex
    if self.Data == nil then
        return
    end

    local equips = self:_getEquips()

    local l_currentSelectIndex = 1
    local l_isGetSelectIndex = false
    local l_selectUid = nil
    if MgrMgr:GetMgr("SelectEquipMgr").NeedSelectUid then
        l_selectUid = MgrMgr:GetMgr("SelectEquipMgr").NeedSelectUid
        MgrMgr:GetMgr("SelectEquipMgr").NeedSelectUid = nil
    else
        if self.Data.IsSelectSameEquip then
            local l_selectEquip = self._equipTemplatePool:GetCurrentSelectTemplateData()
            if l_selectEquip then
                l_selectUid = l_selectEquip.UID
            end
        end
    end

    --- 如果设置了这个UID会一直选中这个UID
    if nil ~= self.Data.StartSelectItemUID then
        l_selectUid = self.Data.StartSelectItemUID
    end

    --logGreen("l_selectUid:"..tostring(l_selectUid))
    if l_selectUid then
        for i = 1, #equips do
            if equips[i].UID == l_selectUid then
                l_currentSelectIndex = i
                l_isGetSelectIndex = true
                break
            end
        end
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.Scale.transform)
    self._equipTemplatePool:CancelSelectTemplate()
    self._equipTemplatePool:ShowTemplates({
        Datas = equips,
        AdditionalData = self.Data.SelectEquipMgrName,
        StartScrollIndex = l_currentSelectIndex
    })

    if l_isGetSelectIndex or (not self.Data.IsDefaultNotSelectedEquip) then
        if #equips >= l_currentSelectIndex then
            self:_onEquipCell(l_currentSelectIndex)
        end
    end

    local l_hasEquips = 0 ~= #equips
    if not l_hasEquips then
        self.Parameter.TextName.LabText = MgrMgr:GetMgr(self.Data.SelectEquipMgrName).GetNoneEquipText()
        self:_setNoneEquipTextPosition()
        --- 如果没有装备就传一个空数据过去
        self:_onEquipCell(-1)
    end

    if self.Data.DefaultHideNoneText then
        self.Parameter.NoneEquipText.gameObject:SetActiveEx(false)
        self.Data.DefaultHideNoneText = nil
    else
        self.Parameter.NoneEquipText.gameObject:SetActiveEx(not l_hasEquips)
    end
    MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("SelectEquipMgr").SelectEquipShowEquipEvent, l_hasEquips)
end

function SelectEquipTemplate:_getEquips()
    local equips = {}
    --当为全部时显示所有装备
    if self._currentEquipIndex == 0 then
        for i, v in pairs(self.bodyEquip) do
            table.ro_insertRange(equips, v)
        end
        if not self._isOnlyShowBody then
            for i, v in pairs(self.bagEquips) do
                table.ro_insertRange(equips, v)
            end
        end
    else
        --当不是全部时显示相应的装备类型的装备
        table.ro_insertRange(equips, self.bodyEquip[self._currentEquipIndex])
        if not self._isOnlyShowBody then
            table.ro_insertRange(equips, self.bagEquips[self._currentEquipIndex])
        end
    end

    local l_finalFilterFunc = MgrMgr:GetMgr(self.Data.SelectEquipMgrName).GetFinalShowEquips
    if l_finalFilterFunc then
        equips = l_finalFilterFunc(equips)
    end
    return equips
end

--点击装备
function SelectEquipTemplate:_onEquipCell(index)
    local l_data = self._equipTemplatePool:getData(index)
    self._equipTemplatePool:SelectTemplate(index)
    MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("SelectEquipMgr").SelectEquipCellEvent, l_data)
    l_gameEventMgr.RaiseEvent(l_gameEventMgr.OnEquipCellSelected, l_data)
    self:_invokeOnSelectCallBack(l_data)
end

---@param itemData ItemData
function SelectEquipTemplate:_invokeOnSelectCallBack(itemData)
    if nil == self.Data then
        logError("[SelectEquipTemplate] self Data got nil")
        return
    end

    if nil == self.Data.OnItemSelected then
        return
    end

    if nil == self.Data.OnItemSelectSelf then
        self.Data.OnItemSelected(itemData)
        return
    end

    self.Data.OnItemSelected(self.Data.OnItemSelectSelf, itemData)
end

--是否包含装备
function SelectEquipTemplate:_isHaveEquipWithIndex(equipIndex)
    if self.bodyEquip[equipIndex] == nil then
        return false
    end

    if self._isOnlyShowBody then
        return #self.bodyEquip[equipIndex] > 0
    else
        if self.bagEquips[equipIndex] == nil then
            return false
        end

        return #self.bagEquips[equipIndex] > 0 or #self.bodyEquip[equipIndex] > 0
    end
end

function SelectEquipTemplate:ShowSelectEquipWithData(data)
    if #self:_getEquips() == 0 then
        self.Parameter.NoneEquipText:SetActiveEx(true)
    end
    if data.NoneEquipText ~= nil then
        self.Parameter.TextName.LabText = data.NoneEquipText
    end

    if data.NoneEquipTextPosition then
        self._noneEquipTextPosition = data.NoneEquipTextPosition
        self:_setNoneEquipTextPosition()
    end

    if data.IsShowCurrentSelectData then
        if self._equipTemplatePool.CurrentSelectIndex ~= 0 then
            self:_onEquipCell(self._equipTemplatePool.CurrentSelectIndex)
        end
    end
end

--- 获取当前显示的Item的数量
function SelectEquipTemplate:GetDisplayItemCount()
    if not self._equipTemplatePool then
        return 0
    end
    return #self._equipTemplatePool:getDatas()
end

function SelectEquipTemplate:_setNoneEquipTextPosition()
    if self._noneEquipTextPosition then
        self.Parameter.NoneEquipText.gameObject:SetPos(self._noneEquipTextPosition)
    else
        self.Parameter.NoneEquipText.gameObject:SetRectTransformPos(l_noneEquipTextLocalPosition.x, l_noneEquipTextLocalPosition.y)
    end
end

---@return ItemData[]
function SelectEquipTemplate:GetCurrentShowEquips()
    local equips = {}
    if self._currentEquipIndex == 0 then
        for i, v in pairs(self.bodyEquip) do
            table.ro_insertRange(equips, v)
        end
        for i, v in pairs(self.bagEquips) do
            table.ro_insertRange(equips, v)
        end
    else
        table.ro_insertRange(equips, self.bodyEquip[self._currentEquipIndex])
        table.ro_insertRange(equips, self.bagEquips[self._currentEquipIndex])
    end

    return equips
end

function SelectEquipTemplate:RefreshSelectEquip()
    self._equipTemplatePool:RefreshCell(self._equipTemplatePool.CurrentSelectIndex)
end

function SelectEquipTemplate:CancelSelectTemplate()
    if self._equipTemplatePool then
        self._equipTemplatePool:CancelSelectTemplate()
    end
end
--lua custom scripts end
return SelectEquipTemplate