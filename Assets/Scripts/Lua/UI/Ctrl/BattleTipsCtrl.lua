--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattleTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
BattleTipsCtrl = class("BattleTipsCtrl", super)
--lua class define end

--lua functions
function BattleTipsCtrl:ctor()

	super.ctor(self, CtrlNames.BattleTips, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function BattleTipsCtrl:Init()

	self.panel = UI.BattleTipsPanel.Bind(self)
	super.Init(self)
	self.time = Time.realtimeSinceStartup
end --func end
--next--
function BattleTipsCtrl:Uninit()

	self.time = nil

	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function BattleTipsCtrl:OnActive()

	MLuaClientHelper.PlayFxHelper(self.panel.Alarm.gameObject)
end --func end
--next--
function BattleTipsCtrl:OnDeActive()


end --func end
--next--
function BattleTipsCtrl:Update()

	if not self.time then
		return
	end

	if Time.realtimeSinceStartup - self.time > 5 then
		UIMgr:DeActiveUI(self.name)
		self.time = nil
	end
end --func end





--next--
function BattleTipsCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function BattleTipsCtrl:SetContent(content)
	self.panel.Tips.LabText = content
end

--lua custom scripts end
