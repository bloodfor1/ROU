--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/NPCInstructionsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
NPCInstructionsCtrl = class("NPCInstructionsCtrl", super)
--lua class define end

--lua functions
function NPCInstructionsCtrl:ctor()

	super.ctor(self, CtrlNames.NPCInstructions, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function NPCInstructionsCtrl:Init()

	self.panel = UI.NPCInstructionsPanel.Bind(self)
	super.Init(self)
	self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.NPCInstructions)
        MgrMgr:GetMgr("NpcMgr").TalkWithLastNpc()
    end)
    -- self.panel.Content.LabText = Lang("ARENA_INFO_TIPS")

end --func end
--next--
function NPCInstructionsCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function NPCInstructionsCtrl:OnActive()
    MPlayerInfo:FocusToRefine(MgrMgr:GetMgr("NpcMgr").CurrentNpcId, -2.69,1.69,0, 10, -40, 30)

end --func end
--next--
function NPCInstructionsCtrl:OnDeActive()
    MPlayerInfo:FocusToMyPlayer()
end --func end
--next--
function NPCInstructionsCtrl:Update()


end --func end



--next--
function NPCInstructionsCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function NPCInstructionsCtrl:InitWithContent(title, content)
	self.panel.TmTitle.LabText = title
	self.panel.Content.LabText = content
end

--lua custom scripts end
