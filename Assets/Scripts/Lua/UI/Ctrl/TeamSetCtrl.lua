--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamSetPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamSetCtrl = class("TeamSetCtrl", super)
--lua class define end

--lua functions
function TeamSetCtrl:ctor()

	super.ctor(self, CtrlNames.TeamSet, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function TeamSetCtrl:Init()
	self.panel = UI.TeamSetPanel.Bind(self)
	super.Init(self)
    self:InintPanel()
end --func end
--next--
function TeamSetCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function TeamSetCtrl:OnActive()


end --func end
--next--
function TeamSetCtrl:OnDeActive()


end --func end
--next--
function TeamSetCtrl:Update()


end --func end



--next--
function TeamSetCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function TeamSetCtrl:InintPanel()
	self.panel.ButtonClose:AddClick(function ()
		UIMgr:DeActiveUI(UI.CtrlNames.TeamSet)
	end)

    self:InintTeamSet(DataMgr:GetData("TeamData").myTeamInfo.teamSetting)
    --新的TeamSet用于赋值
    self.newTeamSetting = DataMgr:GetData("TeamData").GetTempTeamSetting()
	self.panel.TxtName.Input.characterLimit = 10  --限制名字设置的输入长度
    self.panel.Btnconfirm:AddClick(function ()
        self.newTeamSetting.name = self.panel.TxtName.Input.text
        MgrMgr:GetMgr("TeamMgr").TeamSetting(self.newTeamSetting)
	end)

    self.panel.BtnTarget:AddClick(function ()
        UIMgr:ActiveUI(UI.CtrlNames.TeamTarget)
	end)
end

function TeamSetCtrl:SetSelfTeamSet(value)
    if value then
        self.newTeamSetting.target = value.target
        self.newTeamSetting.min_lv = value.min_lv
        self.newTeamSetting.max_lv = value.max_lv
        local targetName = Common.Utils.Lang("TEAM_TARGET")..DataMgr:GetData("TeamData").GetTargetNameById(value.target)
        local lvName = "(Lv."..tostring(value.min_lv).."~Lv."..tostring(value.max_lv)..")"
        self.panel.TxtTarget.LabText = targetName..lvName
    end
end

function TeamSetCtrl:InintTeamSet(teamSetting)
    if teamSetting then
        self.panel.TxtName.Input.text = teamSetting.name
        local targetName = Common.Utils.Lang("TEAM_TARGET")..DataMgr:GetData("TeamData").GetTargetNameById(teamSetting.target)
        local lvName = "(Lv."..tostring(teamSetting.min_lv).."~Lv."..tostring(teamSetting.max_lv)..")"
        self.panel.TxtTarget.LabText = targetName..lvName
    end
end
--lua custom scripts end
