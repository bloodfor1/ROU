--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SetupChatRoomPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
SetupChatRoomCtrl = class("SetupChatRoomCtrl", super)
--lua class define end

--lua functions
function SetupChatRoomCtrl:ctor()

	super.ctor(self, CtrlNames.SetupChatRoom, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function SetupChatRoomCtrl:Init()

	self.panel = UI.SetupChatRoomPanel.Bind(self)
	super.Init(self)
    self.RoomMgr = MgrMgr:GetMgr("ChatRoomMgr")

    self.panel.Floor.Listener.onClick=function(obj,data)
        -- 需求暂不关闭界面
        -- self.panel.Floor.gameObject:SetActiveEx(false)
        -- UIMgr:DeActiveUI(CtrlNames.SetupChatRoom)
        -- MLuaClientHelper.ExecuteClickEvents(data.position,CtrlNames.SetupChatRoom)
        -- self.panel.Floor.gameObject:SetActiveEx(true)
        -- self.panel.Floor.Listener.onClick = nil
    end

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.SetupChatRoom)
    end,true)

    self.panel.CancelBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.SetupChatRoom)
    end,true)

    local l_inputData = MGlobalConfig:GetSequenceOrVectorInt("ChatRoomNameLen")
    local l_inputMin = l_inputData and l_inputData[0] or 0
    local l_inputMax = l_inputData and l_inputData[1] or 20
    self.panel.InputField:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        --输入字数限制
        if string.ro_len(value)>l_inputMax then
            value=string.ro_cut(value,l_inputMax)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_LIMIT", l_inputMax))
        end
        self.panel.InputField.Input.text=value
    end,true)
    self.panel.InputField.Input.text = self.RoomMgr.Room.Name

    --密码
    self:SetCodeSt(self.RoomMgr.Room.Code)
    self.panel.CodeBtn.Listener.onClick=function(obj,data)
        if data~=nil and tostring(data:GetType()) == "MoonClient.MPointerEventData" and data.Tag==CtrlNames.NumberCodeInput then
            return
        end
        UIMgr:ActiveUI(CtrlNames.NumberCodeInput,function(ctrl)
            local l_pos = self.panel.CodeText.transform.position
            l_pos.y = l_pos.y + 0.3
            ctrl:InitInput(l_pos,4,self.CodeSt,function(codeNum,codeSt)
                self:SetCodeSt(codeSt)
            end)
        end)
    end
    self.panel.CodeRandomBtn:AddClick(function()
        self:SetCodeSt(string.format("%04d",math.random(0,10000)))
    end,true)

    --人数下拉组
    local l_numData = {}
    local l_numName = {}
    local l_rowInfo = MGlobalConfig:GetSequenceOrVectorInt("ChatRoomSelectNumber")
    for i = 0, l_rowInfo.Length-1 do
        table.insert(l_numData,l_rowInfo[i])
        table.insert(l_numName,Lang("ChatRoom_Create_Num",l_rowInfo[i])) --%d人
    end
    self.panel.NumMenum.DropDown.onValueChanged:AddListener(function(index)
        self.CurNum = l_numData[index+1]
    end)
    self.panel.NumMenum.DropDown:ClearOptions()
    self.panel.NumMenum:SetDropdownOptions(l_numName)
    self.CurNum = l_numData[1]
    local l_defValue = 0
    for i=1,#l_numData do
        if self.RoomMgr.Room.MaxNum == l_numData[i] then
            self.panel.NumMenum.DropDown.value = i - 1
            break
        end
    end

    --类型下拉组
    local l_typeData = {1}
    local l_typeName = {Lang("ChatRoom_Create_Type1")} --聊天室
    self.panel.TypeMenum.DropDown.onValueChanged:AddListener(function(index)
        self.CurType = l_typeData[index+1]
    end)
    self.panel.TypeMenum.DropDown:ClearOptions()
    self.panel.TypeMenum:SetDropdownOptions(l_typeName)
    self.CurType = l_typeData[1]
    local l_defValue = 0
    for i=1,#l_typeData do
        if self.RoomMgr.Room.Type == l_typeData[i] then
            self.panel.TypeMenum.DropDown.value = i - 1
            break
        end
    end

    --确认
    self.panel.CreatBtn:AddClick(function()
        local l_title = self.panel.InputField.Input.text
        local l_count = string.ro_len(l_title)
        if l_count < l_inputMin then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatRoom_Create_NameShort"))--房间名太短
            return
        end

        if MgrMgr:GetMgr("ChatRoomMgr").TrySetRoom(l_title,self.CurNum,self.CurType,self.CodeSt) then
            UIMgr:DeActiveUI(CtrlNames.SetupChatRoom)
        end
    end,true)
end --func end
--next--
function SetupChatRoomCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function SetupChatRoomCtrl:OnActive()


end --func end
--next--
function SetupChatRoomCtrl:OnDeActive()


end --func end
--next--
function SetupChatRoomCtrl:Update()


end --func end





--next--
function SetupChatRoomCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function SetupChatRoomCtrl:SetCodeSt(codeSt)
    self.CodeSt = codeSt
    if string.ro_isEmpty(self.CodeSt) then
        self.panel.CodeText.LabText = Lang("ChatRoom_Create_NoCode")--"无密码"
    else
        self.panel.CodeText.LabText = self.CodeSt
    end
end
--lua custom scripts end
