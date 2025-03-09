--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/ReBackPrivilegePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
ReBackPrivilegeHandler = class("ReBackPrivilegeHandler", super)
--lua class define end

--lua functions
function ReBackPrivilegeHandler:ctor()

    super.ctor(self, HandlerNames.ReBackPrivilege, 0)

end --func end
--next--
function ReBackPrivilegeHandler:Init()

    self.panel = UI.ReBackPrivilegePanel.Bind(self)
    super.Init(self)

    self.privilegeItemTemplatePool = self:NewTemplatePool({
        TemplateClassName = "PrivilegeItemTemplate",
        TemplatePrefab = self.panel.PrivilegeItemPrefab.gameObject,
        TemplateParent = self.panel.PrivilegeItemParent.transform,
    })

end --func end
--next--
function ReBackPrivilegeHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function ReBackPrivilegeHandler:OnActive()
    local returnPrivilege = TableUtil.GetReturnPrivilege().GetTable()
    self.privilegeItemTemplatePool:ShowTemplates({ Datas = returnPrivilege })

end --func end
--next--
function ReBackPrivilegeHandler:OnDeActive()


end --func end
--next--
function ReBackPrivilegeHandler:Update()


end --func end
--next--
function ReBackPrivilegeHandler:OnShow()
    self:InitLeftTime()
end --func end
--next--
function ReBackPrivilegeHandler:OnHide()
    if self.leftTimer then
        self:StopUITimer(self.leftTimer)
        self.leftTimer = nil
    end
end --func end
--next--
function ReBackPrivilegeHandler:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function ReBackPrivilegeHandler:InitLeftTime()
    local reBackMgr = MgrMgr:GetMgr("ReBackMgr")
    local leftTime = reBackMgr.GetLeftTime()
    if leftTime <= 0 then
        self.panel.LeftTimeRoot:SetActiveEx(false)
    else
        self.panel.LeftTimeRoot:SetActiveEx(true)
        self.panel.LeftTime.LabText = reBackMgr.GetFormatTime(leftTime)
        if self.leftTimer then
            self:StopUITimer(self.leftTimer)
            self.leftTimer = nil
        end
        self.leftTimer = self:NewUITimer(function()
            self.panel.LeftTime.LabText = reBackMgr.GetFormatTime(leftTime)
            leftTime = leftTime - 1
            if leftTime <= 0 then
                self.panel.LeftTimeRoot:SetActiveEx(false)
                self:StopUITimer(self.leftTimer)
            end
        end, 1, -1, true)
        self.leftTimer:Start()
    end
end
--lua custom scripts end
return ReBackPrivilegeHandler