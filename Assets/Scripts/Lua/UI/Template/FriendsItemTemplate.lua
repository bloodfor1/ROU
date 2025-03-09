--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class FriendsItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PlayerHeadButton MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field FriendsText MoonClient.MLuaUICom
---@field Friends_Selected MoonClient.MLuaUICom
---@field Friends_ItemButton MoonClient.MLuaUICom
---@field ChatPrompt MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom

---@class FriendsItemTemplate : BaseUITemplate
---@field Parameter FriendsItemTemplateParameter

FriendsItemTemplate = class("FriendsItemTemplate", super)
--lua class define end

--lua functions
function FriendsItemTemplate:Init()
    super.Init(self)
    self._head = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadDummy.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
    self.Mgr = MgrMgr:GetMgr("FriendMgr")
end --func end
--next--
function FriendsItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function FriendsItemTemplate:OnSetData(data)
    if data == nil then
        return
    end
    self.Data = data
    self:showFriendItem(data)
end --func end
--next--
function FriendsItemTemplate:BindEvents()
    --更新联系人数据
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.UpdateContactData, self.onUpdateContactData,self)

end --func end
--next--
function FriendsItemTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function FriendsItemTemplate:showFriendItem(friendData)
    local l_memberDetailInfo = friendData.base_info
    if l_memberDetailInfo == nil then
        return
    end

    if friendData.friend_type == 1 or friendData.friend_type == 3 then
        ---@type HeadTemplateParam
        local param = {
            EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_memberDetailInfo),
            ShowProfession = true,
            Profession = l_memberDetailInfo.type,
            ShowLv = true,
            Level = l_memberDetailInfo.base_level
        }

        self._head:SetData(param)
        self.Parameter.Name.LabText = Common.Utils.PlayerName(l_memberDetailInfo.name)
        -- 标签处理
        MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, l_memberDetailInfo.tag)
    end

    local l_unReadData = self.Mgr.GetUnReadData(friendData.uid)
    if l_unReadData == nil or l_unReadData.count <= 0 then
        self:showChatPrompt(false)
    else
        self:showChatPrompt(true)
    end

    self.Parameter.Mask:SetActiveEx(l_memberDetailInfo.status ~= MemberStatus.MEMBER_NORMAL)
    self:showSelect(self.Mgr.CurrentSelectFriendIndex == self.ShowIndex)
    self.Parameter.Friends_ItemButton:AddClick(function()
        self:MethodCallback(self)
        self:showSelect(true)
        self:showChatPrompt(false)
    end)

    local l_uid = friendData.uid
    self.Parameter.PlayerHeadButton:AddClick(function()
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(l_uid)
    end)
end
function FriendsItemTemplate:onUpdateContactData(data)
    if data==nil then
        return
    end
    if self.Data.uid ~= data.uid then
        return
    end
    self.Data = data
    self:showFriendItem(self.Data)
end
function FriendsItemTemplate:showSelect(isShow)
    self.Parameter.Friends_Selected.gameObject:SetActiveEx(isShow)
end

function FriendsItemTemplate:showChatPrompt(isShow)
    self.Parameter.ChatPrompt.gameObject:SetActiveEx(isShow)
end
--lua custom scripts end
return FriendsItemTemplate