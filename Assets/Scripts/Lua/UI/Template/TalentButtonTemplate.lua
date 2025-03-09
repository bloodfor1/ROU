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
---@class TalentButtonTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalentName MoonClient.MLuaUICom
---@field OpenChangeNamePanleButton MoonClient.MLuaUICom
---@field LockImage MoonClient.MLuaUICom
---@field OpenChangeNamePanleButton_mask MoonClient.MLuaUICom
---@field SelectTalentButton MoonClient.MLuaUICom

---@class TalentButtonTemplate : BaseUITemplate
---@field Parameter TalentButtonTemplateParameter

TalentButtonTemplate = class("TalentButtonTemplate", super)
--lua class define end

--lua functions
function TalentButtonTemplate:Init()
    super.Init(self)
    self._isOpne = false
    self._tableInfo = nil
    self.Parameter.SelectTalentButton:AddClick(function()
        self:_onSelectTalentButton()
    end)

    self.Parameter.OpenChangeNamePanleButton:AddClick(function()
        local l_currentFunctionId = self._tableInfo.SystemId
        local l_currentOpenIndex = MgrMgr:GetMgr("MultiTalentMgr").GetCurrentTalentIndexWithFunction(l_currentFunctionId)
        local l_name = MgrMgr:GetMgr("MultiTalentMgr").GetTalentNameWithFunctionAndIndex(l_currentFunctionId, self.ShowIndex)
        CommonUI.Dialog.ShowYesNoInputDlg(true, Common.Utils.Lang("MultiTalent_ChangeName"), "", Common.Utils.Lang("DLG_BTN_YES"),
                Common.Utils.Lang("DLG_BTN_NO"), function(newName)
                    if l_name == newName then
                        return
                    end
                    newName = StringEx.DeleteEmoji(newName)
                    MgrMgr:GetMgr("MultiTalentMgr").RenameMultiTalent(l_currentFunctionId, self.ShowIndex, newName)
                end, function()
                end)
    end)

end --func end
--next--
function TalentButtonTemplate:OnDestroy()

end --func end
--next--
function TalentButtonTemplate:OnDeActive()

end --func end
--next--
function TalentButtonTemplate:OnSetData(data)

    self._tableInfo = data
    local l_functionId = data.SystemId
    local l_name = MgrMgr:GetMgr("MultiTalentMgr").GetTalentNameWithFunctionAndIndex(l_functionId, self.ShowIndex)
    self._isOpne = MgrMgr:GetMgr("MultiTalentMgr").IsTalentOpenWithFunctionAndIndex(l_functionId, self.ShowIndex)
    self.Parameter.LockImage:SetActiveEx(not self._isOpne)
    self.Parameter.OpenChangeNamePanleButton:SetActiveEx(self._isOpne)
    self.Parameter.OpenChangeNamePanleButton_mask:SetActiveEx(false)
    self.Parameter.TalentName.LabText = l_name

end --func end
--next--
function TalentButtonTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function TalentButtonTemplate:_onSelectTalentButton()
    if self._isOpne then
        self.MethodCallback(self.ShowIndex)
    else
        self:_showOpenPanle()
    end
end

function TalentButtonTemplate:_showOpenPanle()
    if self._tableInfo == nil then
        return
    end

    if self.ShowIndex > 2 then
        local l_isOpne = MgrMgr:GetMgr("MultiTalentMgr").IsTalentOpenWithFunctionAndIndex(self._tableInfo.SystemId, self.ShowIndex - 1)
        if l_isOpne == false then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MultiTalent_CantOpenWithLastNotOpen"))
            return
        end
    end

    local l_achievementLevel = self._tableInfo.AchievementLevel
    if l_achievementLevel > 0 then
        if l_achievementLevel > MgrMgr:GetMgr("AchievementMgr").BadgeLevel then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("MultiTalent_NotOpenWithAchievementLevel"), l_achievementLevel))
            return
        end
    end

    local l_costItem = self._tableInfo.CostItem
    if l_costItem.Length == 0 then
        logError("道具个数是0")
        return
    end

    if l_costItem[0][0] == 0 then
        logError("道具数据是0")
        return
    end

    local l_consumeDatas = {}
    for i = 0, l_costItem.Length - 1 do
        local l_data = {}
        l_data.ID = tonumber(l_costItem[i][0])
        l_data.IsShowCount = false
        l_data.IsShowRequire = true
        l_data.RequireCount = tonumber(l_costItem[i][1])
        table.insert(l_consumeDatas, l_data)
    end

    CommonUI.Dialog.ShowConsumeDlg("", Common.Utils.Lang("MultiTalent_OpenWithConsume"), function()
        if self._tableInfo == nil then
            return
        end

        MgrMgr:GetMgr("MultiTalentMgr").OpenMultiTalent(self._tableInfo.SystemId, self._tableInfo.ProjectId)
    end, nil, l_consumeDatas)
end
--lua custom scripts end
return TalentButtonTemplate