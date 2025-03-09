--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CameraMaskPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CameraMaskCtrl = class("CameraMaskCtrl", super)
--lua class define end

--lua functions
function CameraMaskCtrl:ctor()

	super.ctor(self, CtrlNames.CameraMask, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function CameraMaskCtrl:Init()

	self.panel = UI.CameraMaskPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function CameraMaskCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function CameraMaskCtrl:OnActive()


end --func end
--next--
function CameraMaskCtrl:OnDeActive()


end --func end
--next--
function CameraMaskCtrl:Update()


end --func end



--next--
function CameraMaskCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
