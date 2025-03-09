--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FollowSetPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FollowSetCtrl = class("FollowSetCtrl", super)
--lua class define end

--lua functions
function FollowSetCtrl:ctor()

	super.ctor(self, CtrlNames.FollowSet, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function FollowSetCtrl:Init()

	self.panel = UI.FollowSetPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function FollowSetCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function FollowSetCtrl:OnActive()


end --func end
--next--
function FollowSetCtrl:OnDeActive()


end --func end
--next--
function FollowSetCtrl:Update()


end --func end



--next--
function FollowSetCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
