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
local forgeSchoolRecommendMgr = MgrMgr:GetMgr("ForgeSchoolRecommendMgr")
--lua fields end

--lua class define
---@class item_FactionRecommendationParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Widget_Stars MoonClient.MLuaUICom
---@field Txt_Name MoonClient.MLuaUICom
---@field txt_match MoonClient.MLuaUICom
---@field Txt_Feature_02 MoonClient.MLuaUICom
---@field Txt_Featuer_01 MoonClient.MLuaUICom
---@field Txt_Desc MoonClient.MLuaUICom
---@field IsMatching MoonClient.MLuaUICom
---@field Img_School MoonClient.MLuaUICom
---@field Img_Feature_02 MoonClient.MLuaUICom
---@field Img_Feature_01 MoonClient.MLuaUICom
---@field Btn_MainTarget MoonClient.MLuaUICom

---@class item_FactionRecommendation : BaseUITemplate
---@field Parameter item_FactionRecommendationParameter

item_FactionRecommendation = class("item_FactionRecommendation", super)
--lua class define end

--lua functions
function item_FactionRecommendation:Init()
    super.Init(self)
    self:_initTemplateConfig()
    self:_initWidgets()
end --func end
--next--
function item_FactionRecommendation:BindEvents()
    -- do nothing
end --func end
--next--
function item_FactionRecommendation:OnDestroy()
    -- do nothing
end --func end
--next--
function item_FactionRecommendation:OnDeActive()
    -- do nothing
end --func end
--next--
function item_FactionRecommendation:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function item_FactionRecommendation:_initTemplateConfig()
    self._onSelect = nil
    self._onSelectSelf = nil
    self._selfID = nil

    self._starTemplatePoolConfig = {
        TemplateClassName = "Star",
        TemplatePath = "UI/Prefabs/Star",
        TemplateParent = self.Parameter.Widget_Stars.transform
    }
end

function item_FactionRecommendation:_initWidgets()
    self._stars = self:NewTemplatePool(self._starTemplatePoolConfig)
    local onClick = function()
        self:_onSelected()
    end

    self.Parameter.Btn_MainTarget:AddClick(onClick)
end

function item_FactionRecommendation:_onSelected()
    self._onSelect(self._onSelectSelf, self._selfID, self.ShowIndex)
end

---@param data ForgeSchoolTemplateParam
function item_FactionRecommendation:_onSetData(data)
    if nil == data then
        logError("[ForgeRecommendTemplate] invalid param")
        return
    end

    self.Parameter.IsMatching.gameObject:SetActiveEx(false)
    self._onSelect = data.onSelectItem
    self._onSelectSelf = data.onSelectItemSelf
    self._selfID = data.config.NAME
    self.Parameter.Txt_Name.LabText = data.config.SchoolName
    self.Parameter.Txt_Desc.LabText = data.config.TEXT3
    self.Parameter.Img_School:SetSpriteAsync(data.config.RecommendClassIconAtlas, data.config.RecommendClassIconSprite)
    local starCount = data.config.DifficultyStar
    local starParam = {}
    for i = 1, starCount do
        table.insert(starParam, 1)
    end

    self._stars:ShowTemplates({ Datas = starParam })
    local featureTable = {}
    local features = data.config.FeatureText
    for i = 0, features.Length - 1 do
        local featureID = features[i]
        local localText = forgeSchoolRecommendMgr.GetFeatureNameByType(featureID)
        table.insert(featureTable, localText)
    end

    self.Parameter.Txt_Featuer_01.LabText = featureTable[1]
    self.Parameter.Txt_Feature_02.LabText = featureTable[2]
    self.Parameter.Img_Feature_01.Img.color = self:_createColorByFeatureType(features[0])
    self.Parameter.Img_Feature_02.Img.color = self:_createColorByFeatureType(features[1])
    self:_refreshMatchState(data.matchState)
end

function item_FactionRecommendation:_createColorByFeatureType(id)
    local EFeatureType = GameEnum.ESchoolFeatureType
    local C_FEATURE_MAP = {
        [EFeatureType.Support] = { r = 96 / 255, g = 176 / 255, b = 108 / 255, a = 255 / 255 },
        [EFeatureType.Attack] = { r = 213 / 255, g = 120 / 255, b = 136 / 255, a = 255 / 255 },
        [EFeatureType.Defence] = { r = 87 / 255, g = 139 / 255, b = 204 / 255, a = 255 / 255 },
    }

    local colorConfig = C_FEATURE_MAP[id]
    return self:_createColor(colorConfig)
end

---@param colorConfig RoColor
function item_FactionRecommendation:_createColor(colorConfig)
    if nil == colorConfig then
        return nil
    end

    -- return Color.New(236 / 255.0, 231 / 255.0, 52 / 255.0, 176 / 255.0)
    return Color.New(colorConfig.r, colorConfig.g, colorConfig.b, colorConfig.a)
end

---@param state number
function item_FactionRecommendation:_refreshMatchState(state)
    local EMatchState = GameEnum.EStyleMatchState
    local C_STATE_STR_MAP = {
        [EMatchState.NoMatch] = "",
        [EMatchState.AttrMatch] = Common.Utils.Lang("C_ATTR_MATCH_STYLE"),
        [EMatchState.SkillMatch] = Common.Utils.Lang("C_SKILL_MATCH_STYLE"),
        [EMatchState.BothMatch] = Common.Utils.Lang("C_MULTIPAL_MATCH_STYLE"),
    }

    local str = C_STATE_STR_MAP[state]
    if nil == str then
        logError("[ForgeRecommend] invalid state: " .. tostring(state))
        return
    end

    self.Parameter.txt_match.LabText = str
end

function item_FactionRecommendation:OnSelect()
    self.Parameter.IsMatching.gameObject:SetActiveEx(true)
end

function item_FactionRecommendation:OnDeselect()
    self.Parameter.IsMatching.gameObject:SetActiveEx(false)
end
--lua custom scripts end
return item_FactionRecommendation