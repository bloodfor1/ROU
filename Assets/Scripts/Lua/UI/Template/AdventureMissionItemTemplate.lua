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
---@class AdventureMissionItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field NormalBG MoonClient.MLuaUICom
---@field NameBox MoonClient.MLuaUICom
---@field MissionName MoonClient.MLuaUICom
---@field MissionImg MoonClient.MLuaUICom
---@field LockMask MoonClient.MLuaUICom
---@field LockBG MoonClient.MLuaUICom
---@field IsLock MoonClient.MLuaUICom
---@field IsCanGetAward MoonClient.MLuaUICom

---@class AdventureMissionItemTemplate : BaseUITemplate
---@field Parameter AdventureMissionItemTemplateParameter

AdventureMissionItemTemplate = class("AdventureMissionItemTemplate", super)
--lua class define end

--lua functions
function AdventureMissionItemTemplate:Init()
    
        super.Init(self)
    
end --func end
--next--
function AdventureMissionItemTemplate:OnDestroy()
    
    
end --func end
--next--
function AdventureMissionItemTemplate:OnDeActive()
    
    
end --func end
--next--
function AdventureMissionItemTemplate:OnSetData(data)
    
    self.Parameter.IsLock.UObj:SetActiveEx(not data.isFinish)
    self.Parameter.MissionName.LabText = MgrMgr:GetMgr("TaskMgr").GetTaskNameByTaskId(data.missionData.Target)
    if data.isGetAward then
        --已领奖关闭遮罩 开启并加载正式图
        self.Parameter.MissionImg:SetActiveEx(true)
        self.Parameter.MissionImg:SetRawTexAsync("AdventureDiary/"..data.missionData.Res)
        self.Parameter.LockMask.UObj:SetActiveEx(false)
        self.Parameter.NormalBG:SetActiveEx(true)
        self.Parameter.LockBG:SetActiveEx(false)
        self.Parameter.MissionName.LabColor = UIDefineColor.SmallTitleColor
    else
        --未领奖关闭正式图 开启并加载未解锁图
        self.Parameter.MissionImg:SetActiveEx(false)
        self.Parameter.LockMask.UObj:SetActiveEx(true)
        self.Parameter.LockMask:SetSprite("AdventureDiary", "UI_AdventureDiary_Mask0"..self.ShowIndex..".png")
        self.Parameter.NormalBG:SetActiveEx(false)
        self.Parameter.LockBG:SetActiveEx(true)
        self.Parameter.MissionName.LabColor = RoColor.Hex2Color(RoColor.WordColor.None[2])
    end
    --完成切未领奖 显示红点
    self.Parameter.IsCanGetAward.UObj:SetActiveEx(data.isFinish and not data.isGetAward)
    --点击事件
    self.Parameter.Prefab:AddClick(function()
        if data.isFinish and not data.isGetAward then
            MgrMgr:GetMgr("AdventureDiaryMgr").ReqGetMissionAward(data.missionData.ID)
        else
            local l_openData = {
                type = DataMgr:GetData("AdventureDiaryData").EUIOpenType.AdventureDiaryTask,
                missionInfo = data,
                isNeedAnim = false,
                isShowing = false
            }
            UIMgr:ActiveUI(UI.CtrlNames.AdventureDiaryTask, l_openData)
        end
    end)
    
end --func end
--next--
function AdventureMissionItemTemplate:BindEvents()
    
    
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return AdventureMissionItemTemplate