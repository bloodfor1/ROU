--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local L_CONST_EFFECT_PATH = "Effects/Prefabs/Creature/Ui/Fx_Ui_FuMoTeJi"
local super = UITemplate.BaseUITemplate
local l_attrUtil = MgrMgr:GetMgr("AttrUtilMgr")
--lua fields end

--lua class define
---@class AchieveTplParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLv MoonClient.MLuaUICom
---@field Title_01 MoonClient.MLuaUICom
---@field Text_Attr_2 MoonClient.MLuaUICom
---@field Text_Attr_1 MoonClient.MLuaUICom
---@field Text_Attr_0 MoonClient.MLuaUICom
---@field ShowSkillButton_1 MoonClient.MLuaUICom
---@field ShowSkillButton_0 MoonClient.MLuaUICom
---@field ShowSkillButton MoonClient.MLuaUICom
---@field QualityGood_2 MoonClient.MLuaUICom
---@field QualityGood_1 MoonClient.MLuaUICom
---@field QualityGood_0 MoonClient.MLuaUICom
---@field LvImage MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field IconBg MoonClient.MLuaUICom
---@field EffectImageBuff_2 MoonClient.MLuaUICom
---@field EffectImageBuff_1 MoonClient.MLuaUICom
---@field EffectImageBuff_0 MoonClient.MLuaUICom
---@field BuffName_2 MoonClient.MLuaUICom
---@field BuffName_1 MoonClient.MLuaUICom
---@field BuffName_0 MoonClient.MLuaUICom
---@field Btn_Confirm MoonClient.MLuaUICom
---@field Attr_Wrap_2 MoonClient.MLuaUICom
---@field Attr_Wrap_1 MoonClient.MLuaUICom
---@field Attr_Wrap_0 MoonClient.MLuaUICom

---@class AchieveTpl : BaseUITemplate
---@field Parameter AchieveTplParameter

AchieveTpl = class("AchieveTpl", super)
--lua class define end

--lua functions
function AchieveTpl:Init()

    super.Init(self)
    self:_initData()
end --func end
--next--
function AchieveTpl:OnDestroy()

    self:_onDestroy()
    self:_destroyAllEffect()

end --func end
--next--
function AchieveTpl:OnDeActive()

    self:_destroyAllEffect()

end --func end
--next--
function AchieveTpl:OnSetData(data)
    self:_showStoneData(data.propInfo)
    local l_cbData = data.cbData
    if nil == l_cbData then
        return
    end

    self:_setOnCloseCb(l_cbData.cb, l_cbData.cbSelf)
end --func end
--next--
function AchieveTpl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
-- 这里要显示装备tips，所以用一个通用的物品标记
function AchieveTpl:_initData()
    self.Parameter.LuaUIGroup.gameObject:SetActiveEx(true)
    self.itemTlp = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.IconBg.transform })
    self.Parameter.Btn_Confirm:AddClickWithLuaSelf(self._onItemSelected, self)
    self.attrTable = {
        { attr = self.Parameter.Attr_Wrap_0,
          buffObj = self.Parameter.ShowSkillButton_0,
          buffText = self.Parameter.BuffName_0,
          attrText = self.Parameter.Text_Attr_0,
          starObj = self.Parameter.QualityGood_0,
          fxBuff = self.Parameter.EffectImageBuff_0,
          showState = false },

        { attr = self.Parameter.Attr_Wrap_1,
          buffObj = self.Parameter.ShowSkillButton_1,
          buffText = self.Parameter.BuffName_1,
          attrText = self.Parameter.Text_Attr_1,
          starObj = self.Parameter.QualityGood_1,
          fxBuff = self.Parameter.EffectImageBuff_1,
          showState = false },

        { attr = self.Parameter.Attr_Wrap_2,
          buffObj = self.Parameter.ShowSkillButton,
          buffText = self.Parameter.BuffName_2,
          attrText = self.Parameter.Text_Attr_2,
          starObj = self.Parameter.QualityGood_2,
          fxBuff = self.Parameter.EffectImageBuff_2,
          showState = false },
    }
end

function AchieveTpl:_onDestroy()
    self.onSelectCb = nil
    self.onSelectCbSelf = nil
    self.itemTlp = nil
    self.propInfo = nil
end

-- 设置点击关闭上层的回调
function AchieveTpl:_setOnCloseCb(cb, cbSelf)
    if nil == cb or nil == cbSelf then
        return
    end

    self.onCloseCallBack = cb
    self.onCloseCbSelf = cbSelf
end

-- 显示封魔石数据
---@param itemData ItemData
function AchieveTpl:_showStoneData(itemData)
    if nil == self.effectIDTable then
        self.effectIDTable = { 0, 0, 0 }
    end

    self:_destroyAllEffect()
    for i = 1, #self.attrTable do
        local config = self.attrTable[i]
        config.showState = false
    end

    if nil == itemData then
        logError("[ItemAchieve] propInfo is nil")
        return
    end

    self.propInfo = itemData
    local l_itemDataConfig = {
        PropInfo = itemData,
        IsShowCount = false
    }

    local stateValid =  self:_validState()
    self.Parameter.Btn_Confirm:SetGray(not stateValid)
    self.itemTlp:SetData(l_itemDataConfig)
    self.Parameter.Title_01.LabText = itemData.ItemConfig.ItemName
    local l_equipEntries = itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
    for i = 1, #l_equipEntries do
        if i <= #self.attrTable then
            local entryData = l_equipEntries[i]
            local l_attrText = self.attrTable[i].attrText
            local l_star = self.attrTable[i].starObj
            local l_buffName = self.attrTable[i].buffText
            local l_buffObj = self.attrTable[i].buffObj
            local l_fxObj = self.attrTable[i].fxBuff
            local l_coloredName, l_value, l_showStar, l_isBuff = l_attrUtil.CalcAttrDisplayConf(entryData)
            local l_desc = "nil"
            if l_isBuff then
                l_desc = l_coloredName
            else
                l_desc = StringEx.Format(l_coloredName, l_value)
            end

            l_buffObj.gameObject:SetActiveEx(l_isBuff)
            l_attrText.gameObject:SetActiveEx(not l_isBuff)
            l_fxObj.gameObject:SetActiveEx(l_isBuff)
            l_star.gameObject:SetActiveEx(l_showStar)
            l_attrText.LabText = l_desc
            l_buffName.LabText = l_desc
            self.attrTable[i].showState = true

            if l_isBuff then
                local l_cb = function()
                    self.effectIDTable[i] = 0
                end

                self.effectIDTable[i] = self:_createBuffEffect(l_fxObj.RawImg, self.effectIDTable[i], l_cb)
            end
        end
    end

    for i = 1, #self.attrTable do
        local l_config = self.attrTable[i]
        local l_isShow = l_config.showState
        l_config.attr.gameObject:SetActiveEx(l_isShow)
    end
end

local L_CONST_FX_CONFIG = {
    offset = { x = -0.12, y = -0.16, z = 0 },
    scale = { x = 1.25, y = 1, z = 1 }
}

function AchieveTpl:_createBuffEffect(rawImg, fxID, onDestroy)
    if 0 < fxID then
        self:DestroyUIEffect(fxID)
    end

    local l_onLoadedCb = function(obj)
        if nil == obj then
            logError("[EnchantProperty] fx obj is nil")
            return
        end

        local l_offset = L_CONST_FX_CONFIG.offset
        local l_scale = L_CONST_FX_CONFIG.scale
        obj.transform:SetLocalPos(l_offset.x, l_offset.y, l_offset.z)
        obj.transform:SetLocalScale(l_scale.x, l_scale.y, l_scale.z)
    end

    local l_fxData = {}
    l_fxData.rawImage = rawImg
    l_fxData.destroyHandler = onDestroy
    l_fxData.loadedCallback = l_onLoadedCb
    local l_ret = self:CreateUIEffect(L_CONST_EFFECT_PATH, l_fxData)

    return l_ret
end

function AchieveTpl:_destroyAllEffect()
    for i = 1, #self.effectIDTable do
        local l_effectID = self.effectIDTable[i]
        if 0 < l_effectID then
            self:DestroyUIEffect(l_effectID)
        end
    end
end

-- 点击确定之后的回调函数
function AchieveTpl:_onItemSelected()
    if nil == self.onCloseCbSelf or nil == self.onCloseCallBack then
        return
    end

    if not self:_validState() then
        local l_str = Lang("C_EQUIP_SAME_TID")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
        return
    end

    self.onCloseCallBack(self.onCloseCbSelf, self.propInfo)
end

--- 判断是不是和选中的另一个装备是同一个ID
function AchieveTpl:_validState()
    local oldEquip = MgrMgr:GetMgr("EnchantInheritMgr").GetOldEquip()
    local ret =  nil == oldEquip or oldEquip.TID ~= self.propInfo.TID
    return ret
end

--lua custom scripts end
return AchieveTpl