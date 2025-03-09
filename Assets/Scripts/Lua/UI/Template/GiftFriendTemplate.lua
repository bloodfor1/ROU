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
---@class GiftFriendTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Stranger MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field IsFriend MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field Gift_Selected MoonClient.MLuaUICom
---@field Gift_ItemButton MoonClient.MLuaUICom
---@field FeelGood MoonClient.MLuaUICom

---@class GiftFriendTemplate : BaseUITemplate
---@field Parameter GiftFriendTemplateParameter

GiftFriendTemplate = class("GiftFriendTemplate", super)
--lua class define end

--lua functions
function GiftFriendTemplate:Init()
    super.Init(self)
    self._playerHead = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadDummy.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function GiftFriendTemplate:OnDeActive()
    self.data = nil
    self._playerHead = nil
end --func end
--next--
function GiftFriendTemplate:OnSetData(data)
    self.data = data
    self:ShowFriendItem(data)
end --func end
--next--
function GiftFriendTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function GiftFriendTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
--好友信息
function GiftFriendTemplate:ShowFriendItem(friendData)
    --好友or陌生人
    local l_friendInfo = friendData.friend_list
    self.Parameter.IsFriend.gameObject:SetActiveEx(l_friendInfo.friend_type == 1)
    self.Parameter.Stranger.gameObject:SetActiveEx(l_friendInfo.friend_type == 4 or l_friendInfo.friend_type == 3)
    if l_friendInfo.friend_type == 4 then
        self.Parameter.Stranger.LabText = Common.Utils.Lang("Friend_StrangerText")
    elseif l_friendInfo.friend_type == 3 then
        self.Parameter.Stranger.LabText = Common.Utils.Lang("Friend_ContactsText")
    end

    --基本信息 职业
    local l_memberBaseInfo = l_friendInfo.base_info
    self.Parameter.Mask:SetActiveEx(l_memberBaseInfo.status == MemberStatus.MEMBER_OFFLINE)
    local l_equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_memberBaseInfo)
    ---@type HeadTemplateParam
    param = {
        EquipData = l_equipData,
        ShowProfession = true,
        Profession = l_memberBaseInfo.type,
    }

    if self._playerHead == nil then
        self._playerHead = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.HeadDummy.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end
    self._playerHead:SetData(param)
    local l_intimacyDegree = l_friendInfo.intimacy_degree~=nil and l_friendInfo.intimacy_degree or 0
    --好友度
    self.Parameter.FeelGood.LabText = l_intimacyDegree
    --名字
    self.Parameter.Name.LabText = l_memberBaseInfo.name
    --等级
    self.Parameter.Level.LabText = tostring(l_memberBaseInfo.base_level)
    --选中效果
    self:ShowSelect(MgrMgr:GetMgr("GiftMgr").g_currentSelectFriendIndex == self.ShowIndex)
    --点击
    self.Parameter.Gift_ItemButton:AddClick(function()
        self:MethodCallback(self)
        self:ShowSelect(true)
    end)
end

function GiftFriendTemplate:ShowSelect(isShow)
    self.Parameter.Gift_Selected.gameObject:SetActiveEx(isShow)
end
--lua custom scripts end
return GiftFriendTemplate