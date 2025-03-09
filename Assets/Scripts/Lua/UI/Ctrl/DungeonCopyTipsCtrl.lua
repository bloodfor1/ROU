--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DungeonCopyTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
DungeonCopyTipsCtrl = class("DungeonCopyTipsCtrl", super)
--lua class define end

--lua functions
function DungeonCopyTipsCtrl:ctor()

	super.ctor(self, CtrlNames.DungeonCopyTips, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function DungeonCopyTipsCtrl:Init()

	self.panel = UI.DungeonCopyTipsPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function DungeonCopyTipsCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function DungeonCopyTipsCtrl:OnActive()


end --func end
--next--
function DungeonCopyTipsCtrl:OnDeActive()


end --func end
--next--
function DungeonCopyTipsCtrl:Update()


end --func end



--next--
function DungeonCopyTipsCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function DungeonCopyTipsCtrl:EnterOrExitCopyDungeon(val)
	if val then
		self:ShowText(Lang("ENTER_COPY_DUNGEON_TIPS"))
	else
		self:ShowText(Lang("EXIT_COPY_DUNGEON_TIPS"))
	end
end

function DungeonCopyTipsCtrl:ShowText(str)
	self.panel.MapTime.LabText = str
	local tweenFade= self.panel.MapTime.UObj:GetComponent("DOTweenAnimation")
	tweenFade:DORestart()
	tweenFade.tween.onComplete = function()
		UIMgr:DeActiveUI(UI.CtrlNames.DungeonCopyTips)
	end
end

--lua custom scripts end
