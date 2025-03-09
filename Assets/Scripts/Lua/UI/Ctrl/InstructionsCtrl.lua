--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InstructionsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
InstructionsCtrl = class("InstructionsCtrl", super)
--lua class define end
--lua functions
function InstructionsCtrl:ctor()

	super.ctor(self, CtrlNames.Instructions, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function InstructionsCtrl:Init()

	self.panel = UI.InstructionsPanel.Bind(self)
	super.Init(self)

	self.panel.Content.LabText = Lang("ARENA_INFO_TIPS")
    self.panel.BG:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.Instructions)
    end)
end --func end
--next--
function InstructionsCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function InstructionsCtrl:OnActive()


end --func end
--next--
function InstructionsCtrl:OnDeActive()


end --func end
--next--
function InstructionsCtrl:Update()


end --func end



--next--
function InstructionsCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
