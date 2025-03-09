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
---@class ItemFlagPartTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RequireSign MoonClient.MLuaUICom
---@field IsHaveFlag MoonClient.MLuaUICom
---@field ImgLock MoonClient.MLuaUICom
---@field Img_TimeLimitProp MoonClient.MLuaUICom
---@field GrayMask MoonClient.MLuaUICom
---@field EquipMultiTalentFlag MoonClient.MLuaUICom
---@field EquipFlag MoonClient.MLuaUICom
---@field EquipCanWearFlag MoonClient.MLuaUICom
---@field CardFragmentFlag MoonClient.MLuaUICom
---@field AssistReward MoonClient.MLuaUICom

---@class ItemFlagPartTemplate : BaseUITemplate
---@field Parameter ItemFlagPartTemplateParameter

ItemFlagPartTemplate = class("ItemFlagPartTemplate", super)
--lua class define end

--lua functions
function ItemFlagPartTemplate:Init()
    super.Init(self)
    self.propInfo = nil
    self.isAddRequireSignEvent = false
    self.requireItem = nil
end--func end
--next--
function ItemFlagPartTemplate:BindEvents()
    if self.requireItem then
        self:addRequireSignEvent()
    end

end --func end
--next--
function ItemFlagPartTemplate:OnDestroy()
    -- do nothing
end--func end
--next--
function ItemFlagPartTemplate:OnDeActive()
    self:initPanelState()
end--func end
--next--
function ItemFlagPartTemplate:OnSetData(data)
    self:initPanelState()
    self.propInfo = data.PropInfo
    local isGray = data.IsGray
    local isLock = data.IsLock
    local isShowRequireSign = data.IsShowRequireSign
    local requireSignType = data.RequireSignType
    local showEquipFlag = data.IsShowEquipFlag
    local showAssist = data.IsAssist
    local isHave = data.IsHave
    local isCardFragmentFlag = self.propInfo.ItemConfig.TypeTab == Data.BagModel.PropType.CardFragment
    self.Parameter.GrayMask:SetActiveEx(isGray)
    self.Parameter.ImgLock:SetActiveEx(isLock)

    local l_isCountLimitProp = self.propInfo:ItemMatchesType(GameEnum.EItemType.CountLimit)
    if l_isCountLimitProp then
        self.Parameter.Img_TimeLimitProp:SetActiveEx(true)
    end

    if isShowRequireSign then
        self.requireItem = MgrMgr:GetMgr("RequireItemMgr").GetNeedItemCountByID(tonumber(self.propInfo.TID)) > 0
        --if l_RequireItems then
        --    for i = 1, #l_RequireItems do
        --        if l_RequireItems[i].ID == self.propInfo.TID then
        --            self.requireItem = l_RequireItems[i]
        --            break
        --        end
        --    end
        --end
        self:showRequireSign()
    end
    --已装备标签
    if showEquipFlag then
        local targetItem = self:_getItemByUid(self.propInfo.UID)
        if nil ~= targetItem then
            showEquipFlag = true
        end
    end
    self.Parameter.EquipFlag:SetActiveEx(showEquipFlag)
    self.Parameter.AssistReward:SetActiveEx(showAssist)
    self.Parameter.EquipMultiTalentFlag:SetActiveEx(false)
    self.Parameter.IsHaveFlag:SetActiveEx(isHave)
    if data.IsShowEquipMultiTalentFlag then
        local l_isInMultiTalentEquip, a, b = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquip(self.propInfo)
        self.Parameter.EquipMultiTalentFlag:SetActiveEx(l_isInMultiTalentEquip)
    end
    self.Parameter.EquipCanWearFlag:SetActiveEx(false)
    if data.IsShowBagEquipCanWearFlag then
        local l_equipPart = MgrMgr:GetMgr("BagEquipMgr").GetCurrentSelectEquipPart()
        if l_equipPart then
            local l_row = self.propInfo.EquipConfig
            if l_row then
                if l_row.EquipId == l_equipPart then
                    self.Parameter.EquipCanWearFlag:SetActiveEx(true)
                    self.Parameter.EquipCanWearFlag:PlayChildrenFx()
                end
            end
        end
    end
    self.Parameter.CardFragmentFlag:SetActiveEx(isCardFragmentFlag)
end--func end
--next--
--lua functions end

--lua custom scripts
---@return ItemData
function ItemFlagPartTemplate:_getItemByUid(uid)
    local types = { GameEnum.EBagContainerType.Equip }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

ItemFlagPartTemplate.TemplatePath = "UI/Prefabs/ItemPart/ItemFlagPart"

function ItemFlagPartTemplate:ctor(param)
    super.ctor(self, param)
end

function ItemFlagPartTemplate:addRequireSignEvent()
    if self.isAddRequireSignEvent then
        return
    end

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self.showRequireSign)
    self.isAddRequireSignEvent = true
end

function ItemFlagPartTemplate:showRequireSign()
    self.Parameter.RequireSign:SetActiveEx(self.requireItem)
end

function ItemFlagPartTemplate:initPanelState()
    self.Parameter.EquipFlag:SetActiveEx(false)
    self.Parameter.GrayMask:SetActiveEx(false)
    self.Parameter.ImgLock:SetActiveEx(false)
    self.Parameter.RequireSign:SetActiveEx(false)
    self.Parameter.AssistReward:SetActiveEx(false)
    self.Parameter.IsHaveFlag:SetActiveEx(false)
    self.Parameter.Img_TimeLimitProp:SetActiveEx(false)
end
--lua custom scripts end
return ItemFlagPartTemplate