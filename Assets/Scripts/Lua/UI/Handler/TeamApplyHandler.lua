--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/TeamApplyPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
TeamApplyHandler = class("TeamApplyHandler", super)
--lua class define end

--lua functions
function TeamApplyHandler:ctor()
    super.ctor(self, HandlerNames.TeamApply, 0)
end --func end
--next--

function TeamApplyHandler:Init()
    self.panel = UI.TeamApplyPanel.Bind(self)
    super.Init(self)
    self.panel.ButtonRefresh:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("Refresh")
    end)
    self.panel.ButtonClear:AddClick(function()
        DataMgr:GetData("TeamData").ResetTeamApplication()
        MgrMgr:GetMgr("TeamMgr").ClearApplicationListReq()
        self:RefreshUIByApplyInfo()
        MgrMgr:GetMgr("TeamMgr").onTeamApplicationInfoChange()
    end)
    self.TeamApplyPerTemPool = nil
end --func end
--next--
function TeamApplyHandler:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.TeamApplyPerTemPool = nil

end --func end
--next--
function TeamApplyHandler:OnActive()

    if self.TeamApplyPerTemPool == nil then
        self.TeamApplyPerTemPool = self:NewTemplatePool({
            TemplateClassName = "TeamApplyPerTem",
            TemplatePrefab = self.panel.TeamApplyPerTem.gameObject,
            TemplateParent = self.panel.TeamApplyPerTem.transform.parent.transform,
        })
    end

    --获取申请列表
    ModuleMgr.TeamMgr:GetApplicationLists()
end --func end
--next--
function TeamApplyHandler:OnDeActive()
end --func end
--next--
function TeamApplyHandler:Update()


end --func end


--next--
function TeamApplyHandler:BindEvents()
    --监听组队成员变化
    local TeamApplyInfoUpdate = function()
        self:RefreshUIByApplyInfo()
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_APPLY_INFO_UPDATE, TeamApplyInfoUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts
function TeamApplyHandler:RefreshUIByApplyInfo()

    local data = DataMgr:GetData("TeamData").TeamApplicationInfo
    self.panel.NoData:SetActiveEx(table.maxn(data) <= 0)
    self.TeamApplyPerTemPool:ShowTemplates({ Datas = data })
end

return TeamApplyHandler
--lua custom scripts end
