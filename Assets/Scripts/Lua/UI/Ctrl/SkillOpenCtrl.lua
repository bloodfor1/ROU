--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SkillOpenPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
SkillOpenCtrl = class("SkillOpenCtrl", super)
--lua class define end

--lua functions
function SkillOpenCtrl:ctor()
	
	super.ctor(self, CtrlNames.SkillOpen, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function SkillOpenCtrl:Init()
	
	self.panel = UI.SkillOpenPanel.Bind(self)
	super.Init(self)

    self.animationCountDown = 0
    self.showSkillIds = {}
end --func end
--next--
function SkillOpenCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function SkillOpenCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.skillId then
        self:ShowAnimation(self.uiPanelData.skillId)
    end
end --func end
--next--
function SkillOpenCtrl:OnDeActive()

end --func end
--next--
function SkillOpenCtrl:Update()
    self.animationCountDown = self.animationCountDown - UnityEngine.Time.deltaTime
    -- 处理获取多个技能的情况
    if self.animationCountDown <= 0 then
        self.isPlaying = false
        if #self.showSkillIds > 0 then
            local l_skillId = self.showSkillIds[1]
            table.remove(self.showSkillIds, 1)
            self:ShowAnimation(l_skillId)
        else
            UIMgr:DeActiveUI(UI.CtrlNames.SkillOpen)
        end
    end
	
end --func end
--next--
function SkillOpenCtrl:BindEvents()
	
end --func end
--next--
--lua functions end

--lua custom scripts

function SkillOpenCtrl:ShowAnimation(skillId)
    local l_skillRow = TableUtil.GetSkillTable().GetRowById(skillId)
    if not l_skillRow then return end

    if self.isPlaying then
        table.insert(self.showSkillIds, skillId)
        return
    end

    self.isPlaying = true
    self.animationCountDown = 1.5

    MLuaClientHelper.PlayFxHelper(self.panel.SkillAnimation.gameObject)

    local l_skillName = l_skillRow.Name
    self.panel.SkillName3.gameObject:SetActiveEx(#l_skillName / 3 <= 3)
    self.panel.SkillName3Text.LabText = l_skillName
    self.panel.SkillName5.gameObject:SetActiveEx(#l_skillName / 3 > 3)
    self.panel.SkillName5Text.LabText = Common.Utils.GetCutOutText(l_skillName, 5)
    self.panel.SkillBtn:SetSprite(l_skillRow.Atlas, l_skillRow.Icon, true)

end

--lua custom scripts end
return SkillOpenCtrl