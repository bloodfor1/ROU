--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ModifyCharacterNamePanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ModifyCharacterNameCtrl = class("ModifyCharacterNameCtrl", super)
--lua class define end

--lua functions
function ModifyCharacterNameCtrl:ctor()
    super.ctor(self, CtrlNames.ModifyCharacterName, UILayer.Function, nil, ActiveType.Exclusive)
    self.roleNameLenMax = MGlobalConfig:GetInt("RoleNameLenMax")
    self.roleNameValue = nil
end --func end
--next--
function ModifyCharacterNameCtrl:Init()

    self.panel = UI.ModifyCharacterNamePanel.Bind(self)
    super.Init(self)

end --func end
--next--
function ModifyCharacterNameCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ModifyCharacterNameCtrl:OnActive()
    self:OnActiveView()
end --func end
--next--
function ModifyCharacterNameCtrl:OnDeActive()
    MPlayerInfo:FocusToMyPlayer()
    self.roleNameValue = nil
    self.head2D = nil

end --func end
--next--
function ModifyCharacterNameCtrl:Update()

end --func end

--next--
function ModifyCharacterNameCtrl:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("SelectRoleMgr").EventDispatcher, MgrMgr:GetMgr("SelectRoleMgr").ON_GET_RANDOM_NAME, function(self, name)
        self.panel.InputFieldName.Input.text = name
    end)
    self:BindEvent(MgrMgr:GetMgr("SelectRoleMgr").EventDispatcher, MgrMgr:GetMgr("SelectRoleMgr").ON_MODIFY_NAME, function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.ModifyCharacterName)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function ModifyCharacterNameCtrl:FocusToNpc()

    local curNpcId = MgrMgr:GetMgr("NpcMgr").GetCurrentNpcId()

    if not curNpcId or curNpcId == -1 then
        curNpcId = MGlobalConfig:GetInt("ModifyNameNpcId")
    end

    -- Focus对应npc，相对于对话框需要左移一点，旋转一点
    local l_npc_entity = MNpcMgr:FindNpcInViewport(curNpcId)
    if l_npc_entity then
        local l_right_vec = l_npc_entity.Model.Rotation * Vector3.right
        local l_temp2 = -0.8
        MPlayerInfo:FocusToOrnamentBarter(curNpcId, l_right_vec.x * l_temp2, 1, l_right_vec.z * l_temp2, 4, 10, 5)
    else
        logError(StringEx.Format("找不到场景中的npc npc_id:{0}", curNpcId))
        return
    end

    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end
end

function ModifyCharacterNameCtrl:OnActiveView()
    -- body
    MgrMgr:GetMgr("TaskMgr").ResetModifyNameFlag()
    self:FocusToNpc()
    self.panel.HeadIcon:SetActiveEx(false)
    self.panel.InputFieldName:SetActiveEx(false)
    self.panel.BtnSubmit:SetActiveEx(false)
    self.panel.Boy:SetActiveEx(false)
    self.panel.Girl:SetActiveEx(false)
    self.panel.BtnClose:AddClick(function(...)
        -- body
        UIMgr:DeActiveUI(UI.CtrlNames.ModifyCharacterName)
    end)

    self.panel.InputFieldName.Input.text = ""
    if not self.head2D then
        self.head2D = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.panel.HeadDummy.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        IsPlayerSelf = true,
        ShowFrame = false,
        ShowBg = false,
    }

    self.head2D:SetData(param)
    local l_randomShow = true
    MPlayerInfo:OpenCameraMask(MLayer.MASK_NPC)
    if l_randomShow then
        -- 随机名字
        self.panel.BtnRandomName:AddClick(function()
            self:RandName()
        end)
    end

    self.panel.BtnRandomName.gameObject:SetActiveEx(l_randomShow)
    --字符动态输入长度限制
    self.panel.InputFieldName:OnInputFieldChange(function(txt)

        txt = StringEx.DeleteEmoji(txt)
        if tonumber(string.ro_len(txt)) <= self.roleNameLenMax then
            self.roleNameValue = txt
        end
        self.panel.InputFieldName.Input.text = self.roleNameValue

    end)
    self.panel.BtnSubmit:AddClick(function()
        self:ValidateName()
    end)
    self:InitUserData()
end

function ModifyCharacterNameCtrl:InitUserData(...)
    -- body
    MLuaClientHelper.PlayFxHelper(self.panel.HeadIcon.gameObject)
    self.panel.HeadIcon:SetActiveEx(true)
    self.panel.InputFieldName:SetActiveEx(true)
    self.panel.BtnSubmit:SetActiveEx(true)
    self.panel.Boy:SetActiveEx(MPlayerInfo.IsMale)
    self.panel.Girl:SetActiveEx(not MPlayerInfo.IsMale)
    if MPlayerInfo.IsMale then
        self.panel.TextBoy.CanvasGroup.alpha = 1
        self.panel.TextGirl.CanvasGroup.alpha = 0.35
    else
        self.panel.TextBoy.CanvasGroup.alpha = 0.35
        self.panel.TextGirl.CanvasGroup.alpha = 1
    end
end

--请求服务端随机角色名
function ModifyCharacterNameCtrl:RandName()
    local l_msgId = Network.Define.Rpc.GetValidName
    ---@type GetValidNameArg
    local l_sendInfo = GetProtoBufSendTable("GetValidNameArg")
    l_sendInfo.sex = MPlayerInfo.IsMale and 0 or 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ModifyCharacterNameCtrl:ValidateName(...)
    -- body
    local l_number = tonumber(self.panel.InputFieldName.Input.text)
    if l_number then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_NUMBER"))
        return
    end

    local l_roleNameLenMin = MGlobalConfig:GetInt("RoleNameLenMin")
    --判断字符串长度
    local l_nameLength = tonumber(string.ro_len(self.panel.InputFieldName.Input.text))

    if l_nameLength == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_NULL_OR_EMPTY"))
        return
    end

    if l_nameLength < l_roleNameLenMin or l_nameLength > self.roleNameLenMax then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_LENGTH"))
        return
    end
    --判断是否有非法字符
    if string.ro_isLegal(self.panel.InputFieldName.Input.text) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_ILLEGAL"))
        return
    end
    self.roleNameValue = self.panel.InputFieldName.Input.text
    local l_msgId = Network.Define.Rpc.GsChangeRoleName
    ---@type ChangeRoleNameArg
    local l_sendInfo = GetProtoBufSendTable("ChangeRoleNameArg")
    l_sendInfo.newrolename = self.roleNameValue
    l_sendInfo.roleid = MPlayerInfo.UID
    l_sendInfo.rpcid = 0
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--lua custom scripts en
