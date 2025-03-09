--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InputpasswordPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
InputpasswordCtrl = class("InputpasswordCtrl", super)
--lua class define end

--lua functions
function InputpasswordCtrl:ctor()

	super.ctor(self, CtrlNames.Inputpassword, UILayer.Tips, UITweenType.UpAlpha, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    
end --func end
--next--
function InputpasswordCtrl:Init()

	self.panel = UI.InputpasswordPanel.Bind(self)
    super.Init(self)
    
    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.Inputpassword)
    end,true)

    self.CodeNum = 0
    self.CodeSt = nil
    self.panel.CodeBtn.Listener.onClick = function(obj,eventData)
        if eventData~=nil and tostring(eventData:GetType()) == "MoonClient.MPointerEventData" and eventData.Tag==CtrlNames.NumberCodeInput then
            return
        end
        UIMgr:ActiveUI(CtrlNames.NumberCodeInput,function(ctrl)
            local l_pos = self.panel.CodeInput.transform.position
            ctrl:InitInput(l_pos,4,self.CodeSt,function(codeNum,codeSt)
                self.CodeNum = codeNum
                self.CodeSt = codeSt
                self.panel.CodeInput.Input.text = codeSt
            end)
        end)
    end

    self.panel.BtnYes:AddClick(function()
        MgrMgr:GetMgr("ChatRoomMgr").TryJoinRoom(self.roomID,self.title,self.CodeSt)
        UIMgr:DeActiveUI(CtrlNames.Inputpassword)
    end,true)

    self.panel.BtnNo:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.Inputpassword)
    end,true)
end --func end
--next--
function InputpasswordCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function InputpasswordCtrl:OnActive()


end --func end
--next--
function InputpasswordCtrl:OnDeActive()


end --func end
--next--
function InputpasswordCtrl:Update()


end --func end





--next--
function InputpasswordCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function InputpasswordCtrl:SetRoomInfo(roomID, title)
    self.roomID = roomID
    self.title = title
end
--lua custom scripts end
