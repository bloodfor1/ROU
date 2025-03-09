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
---@class MercenaryCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SubBtn MoonClient.MLuaUICom
---@field Selection MoonClient.MLuaUICom
---@field Notrecruited MoonClient.MLuaUICom
---@field NotOpen MoonClient.MLuaUICom
---@field LockLevelText MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LevelUp MoonClient.MLuaUICom
---@field LevelText MoonClient.MLuaUICom
---@field JobImg MoonClient.MLuaUICom
---@field Info MoonClient.MLuaUICom
---@field HeadImg MoonClient.MLuaUICom
---@field Empty MoonClient.MLuaUICom
---@field DieTimeText MoonClient.MLuaUICom
---@field Die MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom
---@field Attack MoonClient.MLuaUICom
---@field AddBtn MoonClient.MLuaUICom

---@class MercenaryCellTemplate : BaseUITemplate
---@field Parameter MercenaryCellTemplateParameter

MercenaryCellTemplate = class("MercenaryCellTemplate", super)
--lua class define end

--lua functions
function MercenaryCellTemplate:Init()
	
	super.Init(self)
	    self.mercenaryMgr = MgrMgr:GetMgr("MercenaryMgr")
	    self.Parameter.BackBtn:AddClick(function()
	        if self.isUnOpen then
	            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_OPEN_PLEASE_WAITTING"))
	            return
	        end
	        if self.isLocked then
                local l_taskName = MgrMgr:GetMgr("TaskMgr").GetTaskNameByTaskId(self.lockTask)
                local l_lv = MgrMgr:GetMgr("TaskMgr").GetTaskAcceptBaseLv(self.lockTask)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_TARGET_TIP_26", "", l_lv) ..  Lang("TASK_LIMIT", l_taskName, ""))
	            return
	        end
	        if self.isEmpty then
	            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_FIGHT_SELECTION"))
	            return
	        end
	    end)
	    self.Parameter.HeadImg:AddClick(function()
	        if self.parentCtrl then
	            self.parentCtrl:OnMercenaryCellClicked(self)
	        end
	    end)
	    self.Parameter.AddBtn:AddClick(function()
	        self.mercenaryMgr.ChangeFightState(self.mercenaryInfo.tableInfo.Id, true)
	    end)
	    self.Parameter.SubBtn:AddClick(function()
	        self.mercenaryMgr.ChangeFightState(self.mercenaryInfo.tableInfo.Id, false)
	    end)
	    if not self.updateTimer then
	        self.updateTimer = self:NewUITimer(function()
	            self:Update()
	        end, 1, -1, true)
	        self.updateTimer:Start()
	    end
	
end --func end
--next--
function MercenaryCellTemplate:OnDestroy()
	
	    if self.updateTimer then
			self:StopUITimer(self.updateTimer)
	        self.updateTimer = nil
	    end
	
end --func end
--next--
function MercenaryCellTemplate:OnDeActive()
	
	
end --func end
--next--
function MercenaryCellTemplate:Update()

	    --复活检测
	    if self.mercenaryInfo then
	        self.Parameter.Die:SetActiveEx(self.mercenaryInfo.reviveTimeCountDown>0)
	        if self.mercenaryInfo.reviveTimeCountDown>0 then
	            self.Parameter.DieTimeText.LabText = Lang("MERCENARY_REVIVE", math.floor(self.mercenaryInfo.reviveTimeCountDown))
	        end
	    end
	
end --func end
--next--
function MercenaryCellTemplate:OnSetData(data)
	
	    self.mercenaryInfo = nil
	    self.Parameter.Empty:SetActiveEx(false)
	    self.Parameter.Lock:SetActiveEx(false)
	    self.Parameter.Info:SetActiveEx(false)
	    self.Parameter.NotOpen:SetActiveEx(false)
	    self.Parameter.Die:SetActiveEx(false)
	        self.Parameter.LevelUp:SetActiveEx(false)
	    self.lockedLevel = nil
	    self.isUnOpen = data.isUnOpen
        self.isLocked = data.isLocked
	    self.isEmpty = false
        self.lockTask = data.lockTask
	    if data.isUnOpen then
	        self.Parameter.NotOpen:SetActiveEx(true)
	        return
	    end
	    if data.isLocked then
	        -- self.lockedLevel = data.lockLevel
	        self.Parameter.Lock:SetActiveEx(true)
	        self.Parameter.LockLevelText.LabText = Lang("TASK_LIMIT", "", "")
	        return
	    end
	    if not data.mercenaryInfo then
	        self.isEmpty = true
	        self.Parameter.Empty:SetActiveEx(true)
	        return
	    end
	    self.Parameter.Info:SetActiveEx(true)
	    self.mercenaryInfo = data.mercenaryInfo
	    self.parentCtrl = data.parentCtrl
	    local l_tableInfo = self.mercenaryInfo.tableInfo
	    local l_isRecruited = self.mercenaryInfo.isRecruited
	    local l_isDie = false
	    local l_isInFight = self.mercenaryInfo.outTime ~= 0
	    self.Parameter.LevelText.LabText = "Lv." .. self.mercenaryInfo.level
	    self.Parameter.HeadImg:SetSprite(l_tableInfo.MercenaryAtlas, l_tableInfo.MercenaryIcon, true)
	    self.Parameter.Attack:SetActiveEx(l_isInFight and l_isRecruited)
	    self:RefreshBtnState()
	    self.Parameter.SubBtn:SetActiveEx(l_isInFight and l_isRecruited)
	    local l_jobRow = TableUtil.GetProfessionTable().GetRowById(self.mercenaryInfo.tableInfo.Profession)
	    if l_jobRow then
	        self.Parameter.JobImg:SetSprite("Common", l_jobRow.ProfessionIcon)
	    end
	    self.Parameter.HeadImg:SetGray(not l_isRecruited)
	    --self.Parameter.JobImg:SetActiveEx(l_isRecruited)
	    self.Parameter.LevelText:SetActiveEx(l_isRecruited)
	    self.Parameter.Notrecruited:SetActiveEx(not l_isRecruited)
	    if not l_isRecruited then
	        local l_lockLevel = 0
	        for i = 0, self.mercenaryInfo.tableInfo.Unlock.Length - 1 do
	            if self.mercenaryInfo.tableInfo.Unlock[i][0] == 1 then
	                l_lockLevel = self.mercenaryInfo.tableInfo.Unlock[i][1]
	            end
	        end
	        local l_recruitText = ""
	        if l_lockLevel <= MPlayerInfo.Lv then
	            l_recruitText = Lang("MERCENARY_RECRUIT")
	        else
	            l_recruitText = Lang("Level", l_lockLevel)  .. Lang("MERCENARY_RECRUIT")
	        end
	        self.Parameter.Notrecruited.LabText = l_recruitText
	    end
	    self.Parameter.Die:SetActiveEx(l_isDie)
	    self:SetSelected(false)
	        local l_canLevelUp = l_isInFight and (self.mercenaryMgr.CanLevelUp(self.mercenaryInfo.tableInfo.Id, false) or self.mercenaryMgr.CanEquipLevelUp(self.mercenaryInfo.tableInfo.Id, false))
	        self.Parameter.LevelUp:SetActiveEx(l_canLevelUp)
	    --刷新复活状态
	    self:Update()
	
end --func end
--next--
function MercenaryCellTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MercenaryCellTemplate:SetSelected(isSelected)
    --if self.isSelected == isSelected then return end
    self.isSelected = isSelected
    self.Parameter.Selection:SetActiveEx(isSelected)

    self:RefreshBtnState()
end

function MercenaryCellTemplate:RefreshBtnState()
    if self.mercenaryInfo then
        local l_isRecruited = self.mercenaryInfo.isRecruited
        local l_isInFight = self.mercenaryInfo.outTime ~= 0
        local l_canFight = self.mercenaryMgr.CanMercenaryFight()
        self.Parameter.AddBtn:SetActiveEx(not l_isInFight and l_isRecruited and self.isSelected and l_canFight)
    end
end

function MercenaryCellTemplate:IsSelected()
    return self.isSelected
end
--lua custom scripts end
return MercenaryCellTemplate