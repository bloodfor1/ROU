--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MoveControllerContainerPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
MoveControllerContainerCtrl = class("MoveControllerContainerCtrl", super)
--lua class define end

--lua functions
function MoveControllerContainerCtrl:ctor()
	
	super.ctor(self, CtrlNames.MoveControllerContainer, UILayer.Normal, nil, ActiveType.Normal)
	
end --func end
--next--
function MoveControllerContainerCtrl:Init()
	
	self.panel = UI.MoveControllerContainerPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function MoveControllerContainerCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MoveControllerContainerCtrl:OnActive()
    MUIManager:ActiveUI(MUIManager.MOVE_CONTROLLER)
	
end --func end
--next--
function MoveControllerContainerCtrl:OnDeActive()
    MUIManager:DeActiveUI(MUIManager.MOVE_CONTROLLER)
	
end --func end
function MoveControllerContainerCtrl:OnShow()

	MUIManager:ShowUI(MUIManager.MOVE_CONTROLLER, true)

end --func end
--next--
function MoveControllerContainerCtrl:OnHide()

	MUIManager:HideUI(MUIManager.MOVE_CONTROLLER, true)

end --func end
--lua functions end

--lua custom scripts

--lua custom scripts end
return MoveControllerContainerCtrl