--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AdventureDiaryAchieveTipPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class AdventureDiaryAchieveTipCtrl : UIBaseCtrl
AdventureDiaryAchieveTipCtrl = class("AdventureDiaryAchieveTipCtrl", super)
--lua class define end

--lua functions
function AdventureDiaryAchieveTipCtrl:ctor()
    
    super.ctor(self, CtrlNames.AdventureDiaryAchieveTip, UILayer.Function, nil, ActiveType.Standalone)
    
end --func end
--next--
function AdventureDiaryAchieveTipCtrl:Init()
    
    self.panel = UI.AdventureDiaryAchieveTipPanel.Bind(self)
    super.Init(self)

    self.sectionIndex = nil    --对应章节索引
    self.missionIndex = nil    --对应冒险子任务索引

    --关闭按钮点击事件
    self.panel.BtnClose:AddClick(function ()
        DataMgr:GetData("AdventureDiaryData").ReleaseAdventureData()
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiaryAchieveTip)
    end)
    --领取奖励按钮点击事件
    self.panel.BtnGoAward:AddClick(function ()
        --存在指定的章节和任务索引则按指定逻辑打开 不存在则按普通逻辑打开
        if self.sectionIndex and self.missionIndex then
            UIMgr:ActiveUI(UI.CtrlNames.AdventureDiary, {
                type = DataMgr:GetData("AdventureDiaryData").EUIOpenType.AdventureDiaryByAimIndex,
                aimSectionIndex = self.sectionIndex,
                aimMissionIndex = self.missionIndex,
            })
        else
            UIMgr:ActiveUI(UI.CtrlNames.AdventureDiary)
        end
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiaryAchieveTip)
    end)
    
end --func end
--next--
function AdventureDiaryAchieveTipCtrl:Uninit()
           
    self.sectionIndex = nil    
    self.missionIndex = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AdventureDiaryAchieveTipCtrl:OnActive()
    --如果没有传入数据 则认为异常开启直接关闭
    if (not self.uiPanelData) or (not self.uiPanelData.missionInfo) then
        DataMgr:GetData("AdventureDiaryData").ReleaseAdventureData()
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiaryAchieveTip)
        return
    end

    --正常展示数据
    self:ShowAdventureAchieveTips(self.uiPanelData.missionInfo)
    
end --func end
--next--
function AdventureDiaryAchieveTipCtrl:OnDeActive()
    
    
end --func end
--next--
function AdventureDiaryAchieveTipCtrl:Update()
    
    
end --func end
--next--
function AdventureDiaryAchieveTipCtrl:BindEvents()
    
    
end --func end
--next--
--lua functions end

--lua custom scripts

--展示冒险日记完成提示
function AdventureDiaryAchieveTipCtrl:ShowAdventureAchieveTips(missionInfo)
    --依据冒险子任务的目标任务ID获取对应任务信息
    local l_taskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(missionInfo.missionData.Target)
    if not l_taskInfo then
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiaryAchieveTip)
        return
    end
    --冒险日记名称显示
    self.panel.AdventureName.LabText = l_taskInfo.name
    --冒险日记目标详细信息显示
    self.panel.Details.LabText = l_taskInfo.targetDesc[1]
    --记录任务ID 和 相关索引
    self.sectionIndex = missionInfo.sectionIndex
    self.missionIndex = missionInfo.missionIndex
end
--lua custom scripts end
return AdventureDiaryAchieveTipCtrl