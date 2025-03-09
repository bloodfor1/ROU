--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/QuickChatPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
QuickChatCtrl = class("QuickChatCtrl", super)
--lua class define end

--lua functions
function QuickChatCtrl:ctor()

	super.ctor(self, CtrlNames.QuickChat, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function QuickChatCtrl:Init()

	self.panel = UI.QuickChatPanel.Bind(self)
	super.Init(self)
    self.panel.Num:SetActiveEx(false)
    self.panel.Icon:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.QuickChat)

        MgrMgr:GetMgr("FriendMgr").OpenFriend()
    end)
end --func end
--next--
function QuickChatCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function QuickChatCtrl:OnActive()

    -- canvas层级设置-1 为了不挡在其他的prefab前面
    local l_layer = UI.UILayerSort[self.GroupContainerType] - 1
    local l_spineMesh = self.panel.QuickChat.UObj:GetComponent("Canvas")
    if l_spineMesh then
        l_spineMesh.overrideSorting = true
        l_spineMesh.sortingOrder = l_layer
    end

    self:ResetNum()
end --func end
--next--
function QuickChatCtrl:OnDeActive()


end --func end
--next--
function QuickChatCtrl:Update()


end --func end





--next--
function QuickChatCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function QuickChatCtrl:ResetNum()
    local num = MgrMgr:GetMgr("FriendMgr").NewMessageNum
    self.panel.Num.LabText = tostring(num)
end
--lua custom scripts end
