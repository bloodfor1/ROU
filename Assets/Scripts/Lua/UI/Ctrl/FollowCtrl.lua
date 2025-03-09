--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FollowPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
FollowCtrl = class("FollowCtrl", super)
--lua class define end

--lua functions
function FollowCtrl:ctor()
	
	super.ctor(self, CtrlNames.Follow, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function FollowCtrl:Init()
	
	self.panel = UI.FollowPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function FollowCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil


end --func end
--next--
function FollowCtrl:OnActive()

	self.time = tonumber(MGlobalConfig:GetInt("FollowKeepingTime"))
	self.time = self.time >0 and self.time or 10
	self.panel.Text.LabText = StringEx.Format("{0:F2}",self.time)
	self.start = Time.realtimeSinceStartup

end --func end
--next--
function FollowCtrl:OnDeActive()

	self.time = -1
	self.start = -1

end --func end
--next--
function FollowCtrl:Update()

	if self.start and self.time and self.time>0 then
		local l_pass = Time.realtimeSinceStartup - self.start
		self.start = Time.realtimeSinceStartup
		self.time = self.time - l_pass
		if self.time< 0 then
			UIMgr:DeActiveUI(UI.CtrlNames.Follow)
			return
		end
		self.panel.Text.LabText = StringEx.Format("{0:F2}",self.time)
	end

end --func end





--next--
function FollowCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return FollowCtrl