--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SkillControllerContainerPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
SkillControllerContainerCtrl = class("SkillControllerContainerCtrl", super)
--lua class define end

--lua functions
function SkillControllerContainerCtrl:ctor()
	
	super.ctor(self, CtrlNames.SkillControllerContainer, UILayer.Normal, nil, ActiveType.Normal)
	
end --func end
--next--
function SkillControllerContainerCtrl:Init()
	
	self.panel = UI.SkillControllerContainerPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function SkillControllerContainerCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function SkillControllerContainerCtrl:OnActive()

    MUIManager:ActiveUI(MUIManager.SKILL_CONTORLLER)
	
end --func end
--next--
function SkillControllerContainerCtrl:OnDeActive()

	MUIManager:DeActiveUI(MUIManager.SKILL_CONTORLLER)
end --func end

--next--
function SkillControllerContainerCtrl:OnShow()

    MUIManager:ShowUI(MUIManager.SKILL_CONTORLLER, true)
	
end --func end
--next--
function SkillControllerContainerCtrl:OnHide()

    MUIManager:HideUI(MUIManager.SKILL_CONTORLLER, true)
	
end --func end
--lua functions end

--lua custom scripts

--lua custom scripts end
return SkillControllerContainerCtrl