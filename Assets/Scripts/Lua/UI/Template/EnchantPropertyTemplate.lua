--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "CommonUI/Color"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local l_attrUtilMgr = MgrMgr:GetMgr("AttrUtilMgr")
--lua fields end

--lua class define
---@class EnchantPropertyTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class EnchantPropertyTemplate : BaseUITemplate
---@field Parameter EnchantPropertyTemplateParameter

EnchantPropertyTemplate = class("EnchantPropertyTemplate", super)
--lua class define end

--lua functions
function EnchantPropertyTemplate:Init()
    super.Init(self)
    self._fxId1 = 0
    self._fxId2 = 0
    self._fxId3 = 0
    self._propertyType = 0
    self._propertyId = 0

    self.Parameter.EffectImageName:SetActiveEx(false)
    self.Parameter.EffectImageNumber:SetActiveEx(false)

    local l_cb = function()
        self:_onShowSkillBtnClick()
    end

    self.Parameter.ShowSkillButton:AddClick(l_cb)
    self:_initEffectConfig()
end --func end
--next--
function EnchantPropertyTemplate:OnDeActive()
    self:_destroyFx()
end --func end

--next--
function EnchantPropertyTemplate:OnSetData(data, additionalData)
    self:_showDataInfo(data, additionalData)
end --func end

--next--
function EnchantPropertyTemplate:OnDestroy()
    self:_destroyFx()
end --func end
--next--
--lua functions end

--lua custom scripts
local CONST_ENCHANT_BUFF_EFF_PATH = "Effects/Prefabs/Creature/Ui/Fx_Ui_FuMoTeJi"
local CONST_ENCHANT_DESC_NAME = "Effects/Prefabs/Creature/Ui/Fx_Ui_FuMo_WenZi_01"
local CONST_ENCHANT_NUM_NAME = "Effects/Prefabs/Creature/Ui/Fx_Ui_FuMo_ShuZi_01"

-- 数据驱动空间显示状态
local l_widgetShowConfig = {
    [true] = { showPropertyCount = false, showBaseProperty = false, showSkill = true },
    [false] = { showPropertyCount = true, showBaseProperty = true, showSkill = false },
}

function EnchantPropertyTemplate:_initEffectConfig()
    self.effectConfig = {
        buffEffect = {
            effectName = CONST_ENCHANT_BUFF_EFF_PATH,
            effectImg = self.Parameter.EffectImageBuff.RawImg,
            offset = { x = 0.13, y = 0.01, z = 0 },
            scale = { x = 1.3, y = 1, z = 1 }
        },
        nameEffect = {
            effectName = CONST_ENCHANT_DESC_NAME,
            effectImg = self.Parameter.EffectImageName.RawImg,
            offset = { x = 0, y = 0, z = 0 },
            scale = { x = 1, y = 1, z = 1 }
        },
        numEffect = {
            effectName = CONST_ENCHANT_NUM_NAME,
            effectImg = self.Parameter.EffectImageNumber.RawImg,
            offset = { x = 0, y = 0, z = 0 },
            scale = { x = 1, y = 1, z = 1 }
        },
    }
end

-- 点击技能按钮出现的回调
function EnchantPropertyTemplate:_onShowSkillBtnClick()
    if not self.isBuff then
        logError("[EnchantProperty] property is not buff, but still be clicked")
        return
    end

    local l_position = self.Parameter.ShowSkillButton.transform.position
    ---@type SkillUIAttrData
    local l_data = {}
    l_data.type = 3
    l_data.id = self.propertyID

    ---@type SkillUIData
    local l_skillData = {
        openType = DataMgr:GetData("SkillData").OpenType.ShowSkillInfo,
        position = l_position,
        data = l_data
    }

    UIMgr:ActiveUI(UI.CtrlNames.SkillAttr, l_skillData)
end

-- 这个函数分成3部分，显示颜色，显示星，显示特效
-- 这里要做个标注，在这个地方发过来的数据是一个服务器组装的数据，结构是 {table_id = 1, entrys = {{id = 1, val = 1}}}
---@param data ItemAttrData
function EnchantPropertyTemplate:_showDataInfo(data, additionalData)
    self:_destroyFx()
    if nil == data then
        logError("[PropertyTemplate] data got nil")
        return
    end

    local l_entryName, l_entryValue, l_entryShowStar, l_isBuff = l_attrUtilMgr.CalcAttrDisplayConf(data)
    if l_isBuff then
        local l_cb = function()
            self._fxId3 = 0
        end
        self._fxId3 = self:_showFxCtrl(self.effectConfig.buffEffect, self._fxId3, l_cb)
    end

    self.isBuff = l_isBuff
    self.propertyID = data.AttrID

    self.Parameter.PropertyCount:SetActiveEx(l_widgetShowConfig[l_isBuff].showPropertyCount)
    self.Parameter.BaseProperty:SetActiveEx(l_widgetShowConfig[l_isBuff].showBaseProperty)
    self.Parameter.ShowSkillButton:SetActiveEx(l_widgetShowConfig[l_isBuff].showSkill)
    self.Parameter.BuffName.LabText = l_entryName
    self.Parameter.PropertyName.LabText = StringEx.Format(l_entryName, l_entryValue)
    self.Parameter.PropertyCount.LabText = ""

    self.Parameter.QualityGood:SetActiveEx(l_entryShowStar)
    if additionalData.IsShowEffect then
        local l_cb_1 = function()
            self._fxId1 = 0
        end

        local l_cb_2 = function()
            self._fxId2 = 0
        end

        self._fxId1 = self:_showFxCtrl(self.effectConfig.nameEffect, self._fxId1, l_cb_1)
        self._fxId2 = self:_showFxCtrl(self.effectConfig.numEffect, self._fxId2, l_cb_2)
    end
end

function EnchantPropertyTemplate:_showFxCtrl(config, fxID, onDestroy)
    if nil == config then
        logError("[PropertyTemplate] config is nil")
        return
    end

    if 0 < fxID then
        self:DestroyUIEffect(fxID)
    end

    local l_onLoadedCb = function(obj)
        if nil == obj then
            logError("[EnchantProperty] fx obj is nil")
            return
        end

        local l_offset = config.offset
        local l_scale = config.scale
        obj.transform:SetLocalPos(l_offset.x, l_offset.y, l_offset.z)
        obj.transform:SetLocalScale(l_scale.x, l_scale.y, l_scale.z)
    end

    local l_fxData = {}
    l_fxData.rawImage = config.effectImg
    l_fxData.destroyHandler = onDestroy
    l_fxData.loadedCallback = l_onLoadedCb
    local l_ret = self:CreateUIEffect(config.effectName, l_fxData)
    
    return l_ret
end

function EnchantPropertyTemplate:_destroyFx()
    if self._fxId1 > 0 then
        self:DestroyUIEffect(self._fxId1)
    end
    if self._fxId2 > 0 then
        self:DestroyUIEffect(self._fxId2)
    end
    if self._fxId3 > 0 then
        self:DestroyUIEffect(self._fxId3)
    end
end

--lua custom scripts end
return UITemplate.EnchantPropertyTemplate