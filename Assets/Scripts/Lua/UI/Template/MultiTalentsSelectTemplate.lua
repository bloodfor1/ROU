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
---@class MultiTalentsSelectTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalentButtonParent MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field OpenSelectButton MoonClient.MLuaUICom
---@field OpenDetailsPanelButton MoonClient.MLuaUICom
---@field CurrentTalentName MoonClient.MLuaUICom
---@field CloseSelectButton MoonClient.MLuaUICom
---@field TalentButtonPrefab MoonClient.MLuaUIGroup

---@class MultiTalentsSelectTemplate : BaseUITemplate
---@field Parameter MultiTalentsSelectTemplateParameter

MultiTalentsSelectTemplate = class("MultiTalentsSelectTemplate", super)
--lua class define end

--lua functions
function MultiTalentsSelectTemplate:Init()
    super.Init(self)
    self._currentFunctionId = 0
    self._currentOpenIndex = 0
    self._isShowSelectButtons = false
    self._detailsAnchor = nil
    self.redSign=nil
    self.Parameter.CurrentTalentName:GetText().useEllipsis = true
    self:_setTalentButtonParentActive(false)
    self.Parameter.OpenSelectButton:AddClick(function()
        self:_showSelectButtons()
    end)
    self.Parameter.CloseSelectButton:AddClick(function()
        self:_setTalentButtonParentActive(false)
    end)
    self.Parameter.OpenDetailsPanelButton.Listener.onClick = function(go, eventData)
        self:_onOpenDetailsPanelButton(eventData)
    end

end --func end
--next--
function MultiTalentsSelectTemplate:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher, MgrMgr:GetMgr("MultiTalentMgr").ReceiveRenameMultiTalentEvent, self._refreshSelect, self)
    self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher, MgrMgr:GetMgr("MultiTalentMgr").ReceiveOpenMultiTalentEvent, self._refreshSelect, self)
    self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher, MgrMgr:GetMgr("MultiTalentMgr").ReceiveChangeMultiTalentEvent, function(_, sendInfo)
        if sendInfo.data.system_id == self._currentFunctionId then
            self._currentOpenIndex = sendInfo.data.plan_id
            self:_refreshSelect()
        end
    end)
end --func end
--next--
function MultiTalentsSelectTemplate:OnDestroy()
    self._talentButtonTemplatePool = nil
    self.redSign=nil
end --func end
--next--
function MultiTalentsSelectTemplate:OnDeActive()
    self:_setTalentButtonParentActive(false)
end --func end
--next--
function MultiTalentsSelectTemplate:OnSetData(data, additionalData)

    local l_isNeedSetFrame = false
    if additionalData then
        if additionalData.IsOnlyShowSelect then
            self.Parameter.OpenDetailsPanelButton:SetActiveEx(false)
        end
        self._detailsAnchor = additionalData.DetailsAnchor
        l_isNeedSetFrame = additionalData.IsNeedSetFrame
    end

    if self._talentButtonTemplatePool == nil then
        local l_templatePoolData={
            TemplateClassName = "TalentButtonTemplate",
            TemplatePrefab = self.Parameter.TalentButtonPrefab.gameObject,
            TemplateParent = self.Parameter.TalentButtonParent.Transform,
            Method = function(index)
                self:_onTalentButton(index)
            end
        }
        if l_isNeedSetFrame then
            l_templatePoolData.SetCountPerFrame=1
            l_templatePoolData.CreateObjPerFrame=1
        end
        self._talentButtonTemplatePool = self:NewTemplatePool(l_templatePoolData)
    end

    self._detailsAnchor = nil
    self._currentFunctionId = data
    self._currentOpenIndex = MgrMgr:GetMgr("MultiTalentMgr").GetCurrentTalentIndexWithFunction(self._currentFunctionId)
    self:_openAllTalents()
    self:_refreshSelect()


end --func end
--next--
--lua functions end

--lua custom scripts
function MultiTalentsSelectTemplate:ctor(itemData)
    if itemData == nil then
        itemData = {}
    end
    itemData.TemplatePath = "UI/Prefabs/MultiTalentsSelectPrefab"
    super.ctor(self, itemData)
end

function MultiTalentsSelectTemplate:_onTalentButton(index)
    self:_setTalentButtonParentActive(false)
    if self._currentOpenIndex == index then
        return
    end

    MgrMgr:GetMgr("MultiTalentMgr").ChangeMultiTalent(self._currentFunctionId, index)
end

function MultiTalentsSelectTemplate:_setTalentButtonParentActive(isShow)
    self._isShowSelectButtons = isShow
    self.Parameter.TalentButtonParent:SetActiveEx(isShow)
    self.Parameter.CloseSelectButton:SetActiveEx(isShow)
end

function MultiTalentsSelectTemplate:_showSelectButtons()
    self:_setTalentButtonParentActive(not self._isShowSelectButtons)
end

--判断哪些需要开启，请求开启协议
function MultiTalentsSelectTemplate:_openAllTalents()
    local l_multiTalentsTableInfos = MgrMgr:GetMgr("MultiTalentMgr").GetMultiTableDataBySystemId(self._currentFunctionId)

    if l_multiTalentsTableInfos then
        for i = 1, #l_multiTalentsTableInfos do
            --logGreen("_openAllTalents:"..tostring(self._currentFunctionId).." :"..tostring(l_multiTalentsTableInfos[i].ProjectId).." :"..tostring(self:_isNeedToOpen(l_multiTalentsTableInfos[i])))
            if self:_isNeedToOpen(l_multiTalentsTableInfos[i]) then
                MgrMgr:GetMgr("MultiTalentMgr").OpenMultiTalent(l_multiTalentsTableInfos[i].SystemId, l_multiTalentsTableInfos[i].ProjectId)
            end
        end
    end
end

--是否需要请求开启协议协议
function MultiTalentsSelectTemplate:_isNeedToOpen(tableInfo)
    if tableInfo.ProjectId == 1 then
        return false
    end

    local l_isOpne = MgrMgr:GetMgr("MultiTalentMgr").IsTalentOpenWithFunctionAndIndex(self._currentFunctionId, tableInfo.ProjectId)
    if l_isOpne then
        return false
    end

    local l_costItem = tableInfo.CostItem
    if l_costItem.Length > 0 and l_costItem[0][0] ~= 0 then
        return false
    end

    if tableInfo.AchievementLevel > MgrMgr:GetMgr("AchievementMgr").BadgeLevel then
        return false
    end

    return true
end

function MultiTalentsSelectTemplate:_refreshSelect()
    if self._currentFunctionId == 0 then
        return
    end
    local l_name = MgrMgr:GetMgr("MultiTalentMgr").GetTalentNameWithFunctionAndIndex(self._currentFunctionId, self._currentOpenIndex)
    if not l_name then
        return
    end

    self.Parameter.CurrentTalentName.LabText = l_name
    local l_multiTalentsTableInfos = MgrMgr:GetMgr("MultiTalentMgr").GetMultiTableDataBySystemId(self._currentFunctionId)
    if l_multiTalentsTableInfos == nil then
        logError("l_multiTalentsTableInfos是空的，currentFunctionId：" .. tostring(self._currentFunctionId) .. "  OpenIndex:" .. tostring(self._currentOpenIndex))
        return
    end
    self._talentButtonTemplatePool:ShowTemplates({
        Datas = l_multiTalentsTableInfos,

    })

    self.Parameter.RedSign:SetActiveEx(false)
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_redSignIndex = {
        [l_openSystemMgr.eSystemId.AttrMultiTalent] = eRedSignKey.PlayerPlanQ,
        [l_openSystemMgr.eSystemId.SkillMultiTalent] = eRedSignKey.SkillPlanQ,
        [l_openSystemMgr.eSystemId.EquipMultiTalent] = eRedSignKey.BagPlanQ
    }
    if self.redSign then
        self:UninitRedSign(self.redSign)
        self.redSign=nil
    end
    self.redSign=self:NewRedSign({
        Key = l_redSignIndex[self._currentFunctionId],
        Listener = self.Parameter.OpenDetailsPanelButton
    })
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(l_redSignIndex[self._currentFunctionId])

end

function MultiTalentsSelectTemplate:_onOpenDetailsPanelButton(eventData)
    local l_multiTalentsTableInfo = MgrMgr:GetMgr("MultiTalentMgr").GetMultiTableDataWithSystemIdAndIndex(self._currentFunctionId, self._currentOpenIndex)
    if l_multiTalentsTableInfo == nil then
        return
    end
    local l_infoText = Lang(l_multiTalentsTableInfo.Tips)
    local pos = Vector2.New(eventData.position.x, eventData.position.y)
    eventData.position = pos

    local l_anchor = Vector2.New(0.5, 1)
    if self._detailsAnchor then
        l_anchor = self._detailsAnchor
    end
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_infoText, eventData, l_anchor)
end

function MultiTalentsSelectTemplate:UpdateSingleTemplate()
    if not self._talentButtonTemplatePool then
        return
    end

    self._talentButtonTemplatePool:OnUpdate()
end
--lua custom scripts end
return MultiTalentsSelectTemplate