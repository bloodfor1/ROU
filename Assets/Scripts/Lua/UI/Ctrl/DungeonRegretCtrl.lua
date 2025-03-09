--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DungeonRegretPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
DungeonRegretCtrl = class("DungeonRegretCtrl", super)
--lua class define end

--lua functions
function DungeonRegretCtrl:ctor()
	
	super.ctor(self, CtrlNames.DungeonRegret, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function DungeonRegretCtrl:Init()
	
	self.panel = UI.DungeonRegretPanel.Bind(self)
	super.Init(self)

    self.panel.BackBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.DungeonRegret)
    end)

    self.closeTimer = self:NewUITimer(function()
        UIMgr:DeActiveUI(UI.CtrlNames.DungeonRegret)
    end, 5)
    self.closeTimer:Start()
end --func end
--next--
function DungeonRegretCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function DungeonRegretCtrl:OnActive()
	
	
end --func end
--next--
function DungeonRegretCtrl:OnDeActive()
	
	
end --func end
--next--
function DungeonRegretCtrl:Update()
	
	
end --func end
--next--
function DungeonRegretCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return DungeonRegretCtrl