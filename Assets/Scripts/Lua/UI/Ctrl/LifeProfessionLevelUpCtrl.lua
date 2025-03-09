--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LifeProfessionLevelUpPanel"

local ClassID = MgrMgr:GetMgr("LifeProfessionMgr").ClassID
local Mgr = MgrMgr:GetMgr("LifeProfessionMgr")
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
LifeProfessionLevelUpCtrl = class("LifeProfessionLevelUpCtrl", super)
--lua class define end

--lua functions
function LifeProfessionLevelUpCtrl:ctor()

	super.ctor(self, CtrlNames.LifeProfessionLevelUp, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
    self.InsertPanelName = UI.CtrlNames.LifeProfession
    --self:SetParent(CtrlNames.LifeProfession)

end --func end
--next--
function LifeProfessionLevelUpCtrl:Init()

	self.panel = UI.LifeProfessionLevelUpPanel.Bind(self)
	super.Init(self)
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.LifeProfessionLevelUp)
    end,true)
    self.panel.UpBtn:AddClick(function()
        if self.TaskInfo ~= nil then
            UIMgr:DeActiveUI(CtrlNames.LifeProfessionLevelUp)
            UIMgr:DeActiveUI(CtrlNames.LifeProfession)
            MgrMgr:GetMgr("TaskMgr").NavToTaskAcceptNpc(self.TaskInfo.taskId)
        end
    end,true)
    self.panel.Floor.Listener.onClick = function(obj,data)
        self.panel.Floor.gameObject:SetActiveEx(false)
        UIMgr:DeActiveUI(CtrlNames.LifeProfessionLevelUp)
        MLuaClientHelper.ExecuteClickEvents(data.position,CtrlNames.LifeProfessionLevelUp)
        self.panel.Floor.gameObject:SetActiveEx(true)
        self.panel.Floor.Listener.onClick = nil
    end

end --func end
--next--
function LifeProfessionLevelUpCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function LifeProfessionLevelUpCtrl:OnActive()


end --func end
--next--
function LifeProfessionLevelUpCtrl:OnDeActive()


end --func end
--next--
function LifeProfessionLevelUpCtrl:Update()


end --func end



--next--
function LifeProfessionLevelUpCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function LifeProfessionLevelUpCtrl:SetClassName(class)

    self.ClassName = class
    local l_curLevel = Mgr.GetLv(class)
    local l_careerName = Mgr.GetCareerName(class)
    local l_nextCraft = TableUtil.GetCraftingSkillTable().GetRowBySkillLv(l_curLevel+1)
    local l_taskID = 0
    if l_nextCraft ~= nil then
        if class == ClassID.Cook then
            l_taskID = l_nextCraft.FoodLvUpMission
        elseif class == ClassID.Drug then
            l_taskID = l_nextCraft.MedicineLvUpMission
        elseif class == ClassID.Sweet then
            l_taskID = l_nextCraft.DessertLvUpMission
        elseif class == ClassID.Smelt then
            l_taskID = l_nextCraft.SmeltWepLvUpMission
        elseif class == ClassID.Armor then
            l_taskID = l_nextCraft.SmeltArmorLvUpMission
        elseif class == ClassID.Acces then
            l_taskID = l_nextCraft.SmeltAccsLvUpMission
        else
            return
        end
    end

    self.TaskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(l_taskID)
    if self.TaskInfo == nil then
        return
    end

    self.panel.Title.LabText = Lang("LifeProfession_Career_Level", l_careerName)--提升%s职业等级
    self.panel.Level.LabText = Lang("LifeProfession_CareerLv", l_careerName, l_curLevel)--当前%s职业等级：Lv.%d
    --Base等级提升至<color=#FF4F4FFF>Lv.%d</color>时去导师处完成职业任务，即可提升%s职业等级。
    self.panel.Content.LabText = Lang("LifeProfession_Career_UpDesc",self.TaskInfo.minBaseLevel, l_careerName)
    self.panel.UpBtn.gameObject:SetActiveEx(MPlayerInfo.Lv >= self.TaskInfo.minBaseLevel)

end
--lua custom scripts end
