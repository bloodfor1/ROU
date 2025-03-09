--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/NormalIntroducePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
NormalIntroduceCtrl = class("NormalIntroduceCtrl", super)
--lua class define end

--lua functions
function NormalIntroduceCtrl:ctor()

	super.ctor(self, CtrlNames.NormalIntroduce, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function NormalIntroduceCtrl:Init()

	self.panel = UI.NormalIntroducePanel.Bind(self)
	super.Init(self)

end --func end
--next--
function NormalIntroduceCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function NormalIntroduceCtrl:OnActive()


end --func end
--next--
function NormalIntroduceCtrl:OnDeActive()


end --func end
--next--
function NormalIntroduceCtrl:Update()


end --func end



--next--
function NormalIntroduceCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
