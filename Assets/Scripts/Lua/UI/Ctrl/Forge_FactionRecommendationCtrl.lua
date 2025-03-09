--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Forge_FactionRecommendationPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local forgeSchoolRecommendMgr = MgrMgr:GetMgr("ForgeSchoolRecommendMgr")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
--lua fields end

--lua class define
Forge_FactionRecommendationCtrl = class("Forge_FactionRecommendationCtrl", super)
--lua class define end

--lua functions
function Forge_FactionRecommendationCtrl:ctor()
    super.ctor(self, CtrlNames.Forge_FactionRecommendation, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.None
end --func end
--next--
function Forge_FactionRecommendationCtrl:Init()
    self.panel = UI.Forge_FactionRecommendationPanel.Bind(self)
    super.Init(self)

    self:_initMember()
    self:_initWidgets()
end --func end
--next--
function Forge_FactionRecommendationCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function Forge_FactionRecommendationCtrl:OnActive()
    if MGlobalConfig:GetInt("ForgeRookieRecommendGuide", 0) <= MPlayerInfo.Lv then
        local l_beginnerGuideChecks = { "FoundryEquipment3" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end

    self._selectedID = forgeSchoolRecommendMgr.GetSelectID()
    self:_refreshPage()
end --func end
--next--
function Forge_FactionRecommendationCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function Forge_FactionRecommendationCtrl:Update()
    -- do nothing
end --func end
--next--
function Forge_FactionRecommendationCtrl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function Forge_FactionRecommendationCtrl:_initMember()
    self._selectedID = 0
    self._templatePoolConfig = {
        TemplateClassName = "item_FactionRecommendation",
        TemplatePath = "UI/Prefabs/item_FactionRecommendation",
        ScrollRect = self.panel.LoopVertical.LoopScroll,
    }
end

function Forge_FactionRecommendationCtrl:_initWidgets()
    self._schoolPool = self:NewTemplatePool(self._templatePoolConfig)
    local onClose = function()
        self:_onRestore()
        self:_onClose()
    end

    local onConfirm = function()
        self:_onConfirm()
    end

    local onRestore = function()
        self:_onRestore()
    end

    self.panel.ButtonClose:AddClick(onClose)
    self.panel.Btn_OK:AddClick(onConfirm)
    self.panel.Btn_Restore:AddClick(onRestore)
end

function Forge_FactionRecommendationCtrl:_onSingleItemSelected(id, showIdx)
    self._selectedID = id
    forgeSchoolRecommendMgr.SetSelectedSchoolID(id)
    self:_refreshSelectState(showIdx)
    gameEventMgr.RaiseEvent(gameEventMgr.ForgeFiltrateSet, id)
end

function Forge_FactionRecommendationCtrl:_refreshSelectState(idx)
    self._schoolPool:SelectTemplate(idx)
end

--- 返回匹配流派状态
---@return number
function Forge_FactionRecommendationCtrl:_getMatchState(attrMatchID, skillMatchID, currentID)
    if nil == attrMatchID or nil == skillMatchID or nil == currentID then
        logError("[ForgeRecommend] invalid param")
        return 0
    end

    local EMatchState = GameEnum.EStyleMatchState
    local ret = EMatchState.NoMatch
    if attrMatchID == currentID then
        ret = EMatchState.AttrMatch
    end

    if skillMatchID == currentID then
        if EMatchState.NoMatch == ret then
            ret = EMatchState.SkillMatch
        else
            ret = EMatchState.BothMatch
        end
    end

    return ret
end

--- 重置界面状态
function Forge_FactionRecommendationCtrl:_refreshPage()
    local tableData = forgeSchoolRecommendMgr.GetForgeRecommendSchoolList()
    local selectedIdx = 0
    local forgeRecommendParam = {}
    local skillMatchID = forgeSchoolRecommendMgr.GetPlayerSkillMatchID()
    local attrMatchID = forgeSchoolRecommendMgr.GetPlayerAttrMatchID()
    for i = 1, #tableData do
        local singleConfig = tableData[i]
        ---@type ForgeSchoolTemplateParam
        local singleTemplateParam = {
            config = singleConfig,
            onSelectItem = self._onSingleItemSelected,
            onSelectItemSelf = self,
            currentSelectedID = self._selectedID,
            matchState = self:_getMatchState(attrMatchID, skillMatchID, singleConfig.NAME)
        }

        table.insert(forgeRecommendParam, singleTemplateParam)
        if singleConfig.NAME == self._selectedID then
            selectedIdx = i
        end
    end

    local itemTemplateParam = {
        Datas = forgeRecommendParam
    }

    self._schoolPool:ShowTemplates(itemTemplateParam)
    if 0 >= selectedIdx or selectedIdx > #tableData then
        return
    end

    self._schoolPool:SelectTemplate(selectedIdx)
end

function Forge_FactionRecommendationCtrl:_onRestore()
    forgeSchoolRecommendMgr.ClearSelectedID()
    self._schoolPool:CancelSelectTemplate()
    gameEventMgr.RaiseEvent(gameEventMgr.ForgeFiltrateSet, 0)
end

function Forge_FactionRecommendationCtrl:_onClose()
    forgeSchoolRecommendMgr.ClearSelectedID()
    self._schoolPool:CancelSelectTemplate()
    UIMgr:DeActiveUI(UI.CtrlNames.Forge_FactionRecommendation)
end

function Forge_FactionRecommendationCtrl:_onConfirm()
    self._schoolPool:CancelSelectTemplate()
    UIMgr:DeActiveUI(UI.CtrlNames.Forge_FactionRecommendation)
end

--lua custom scripts end
return Forge_FactionRecommendationCtrl