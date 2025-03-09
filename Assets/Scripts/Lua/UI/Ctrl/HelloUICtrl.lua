--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HelloUIPanel"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
HelloUICtrl = class("HelloUICtrl", super)
--lua class define end

--lua functions
function HelloUICtrl:ctor()

	super.ctor(self, CtrlNames.HelloUI, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function HelloUICtrl:Init()

	self.panel = UI.HelloUIPanel.Bind(self)
	super.Init(self)
end --func end
--next--
function HelloUICtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function HelloUICtrl:OnActive()
end --func end
--next--
function HelloUICtrl:OnDeActive()
end --func end
--next--
function HelloUICtrl:Update()


end --func end

--next--
function HelloUICtrl:BindEvents()

	--dont override this function
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
