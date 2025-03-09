--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PvpArenaInvitationPanel"
require "UI/Template/PvpArenaInvitationItemPrefab"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
---@class UI.PvpArenaInvitationCtrl : UIBaseCtrl
PvpArenaInvitationCtrl = class("PvpArenaInvitationCtrl", super)
--lua class define end

--lua functions
function PvpArenaInvitationCtrl:ctor()

    super.ctor(self, CtrlNames.PvpArenaInvitation, UILayer.Function,UITweenType.UpAlpha, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function PvpArenaInvitationCtrl:Init()

    self.panel = UI.PvpArenaInvitationPanel.Bind(self)
    super.Init(self)
    self.guildMgr = MgrMgr:GetMgr("GuildMgr")
    self.friendMgr = MgrMgr:GetMgr("FriendMgr")
    self.pvpArenaMgr = MgrMgr:GetMgr("PvpArenaMgr")

end --func end
--next--
function PvpArenaInvitationCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function PvpArenaInvitationCtrl:OnActive()

    self:OnInit()

end --func end
--next--
function PvpArenaInvitationCtrl:OnDeActive()

    self:OnUninit()

end --func end
--next--
function PvpArenaInvitationCtrl:Update()


end --func end

--next--
function PvpArenaInvitationCtrl:BindEvents()
    ---@param self UI.PvpArenaInvitationCtrl
    self:BindEvent(self.guildMgr.EventDispatcher,self.guildMgr.ON_GUILD_MEMBERLIST_SHOW, function(self)
        local l_guildData = DataMgr:GetData("GuildData")
        local l_tempList = l_guildData.SortMemberList(l_guildData.guildMemberList, l_guildData.EMemberSortType.StateBaseLv)
        ---@type GuildMemberShowData[]
        local l_showList = {}
        if #l_tempList > 0 then
            for i = 1, #l_tempList do
                if l_tempList[i].baseInfo.roleId ~= MPlayerInfo.UID then
                    local l_index = #l_showList + 1
                    ---@class GuildMemberShowData
                    l_showList[l_index] = {}
                    l_showList[l_index].info = l_tempList[i].baseInfo
                    l_showList[l_index].is_online = l_tempList[i].isOnline
                    l_showList[l_index].type = 1
                end
            end
        end
        self:ShowGuildMemberList(l_showList)
    end)
    ---@param self UI.PvpArenaInvitationCtrl
    self:BindEvent(self.friendMgr.EventDispatcher,self.friendMgr.ResetFriendInfoEvent, function(self)
        local l_data = self.friendMgr.FriendDatas
        ---@type ClientShowFriendData[]
        local l_friendData = {}
        if #l_data>0 then
            for i = 1, #l_data do
                if l_data[i].npcID == nil and tostring(l_data[i].base_info.role_uid) ~= tostring(MPlayerInfo.UID) then
                    local l_index = #l_friendData + 1
                    ---@class ClientShowFriendData
                    l_friendData[l_index] = {}
                    l_friendData[l_index].info = l_data[i].base_info
                    l_friendData[l_index].type = 2
                    l_friendData[l_index].is_online=self.friendMgr.IsFriendOnline(l_data[i].base_info.role_uid)
                end
            end
        end
        self:ShowFriendList(l_friendData)
    end)
    self:BindEvent(self.friendMgr.EventDispatcher,self.friendMgr.ChangeOnlineEvent, function(self)
        self.PvpArenaInvitationItemPool:RefreshCells()
    end)
    self:BindEvent(self.pvpArenaMgr.EventDispatcher,self.pvpArenaMgr.ON_PVP_CANINVITE_UPDATE, function()
        self.panel.Checkmark.gameObject:SetActiveEx(self.pvpArenaMgr.m_canInvite)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function PvpArenaInvitationCtrl:OnInit()
    --self:SetBlockOpt(BlockColor.Dark)
    self.panel.OnlyWearToggle.gameObject:SetActiveEx(self.pvpArenaMgr.JudgeIsOwner(MPlayerInfo.UID))
    self.PvpArenaInvitationItemPool = self:NewTemplatePool(
    {
        ScrollRect = self.panel.ScrollView.LoopScroll,
        UITemplateClass = UITemplate.PvpArenaInvitationItemPrefab,
        TemplatePrefab = self.panel.PvpArenaInvitationItemPrefab.LuaUIGroup.gameObject
    })
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self.friendOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Friend)
    self.guildOpen = MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild()
    if self.friendOpen then
        self.friendMgr.RequestGetFriendInfo()
    end
    self.panel.friendBtn.TogEx.onValueChanged:AddListener(function()
        if self.panel.friendBtn.TogEx.isOn then
            if self.friendOpen then
                self.friendMgr.RequestGetFriendInfo()
            else
                self.PvpArenaInvitationItemPool:ShowTemplates({ Datas = {} })
            end
        end
    end)
    self.panel.guildBtn.TogEx.onValueChanged:AddListener(function()
        if self.panel.guildBtn.TogEx.isOn then
            if self.guildOpen then
                self.guildMgr.ReqGuildMemberList()
            else
                self.PvpArenaInvitationItemPool:ShowTemplates({ Datas = {} })
            end
        end
    end)
    self.panel.closeButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaInvitation)
    end)
    self.panel.Background:AddClick(function()
        MgrMgr:GetMgr("PvpArenaMgr").ArenaSetMemberInvite()
    end)
    self.panel.Checkmark.gameObject:SetActiveEx(self.pvpArenaMgr.m_canInvite)
end


function PvpArenaInvitationCtrl:OnUninit()

    self.PvpArenaInvitationCtrl = nil

end

---@param data GuildMemberShowData[]
function PvpArenaInvitationCtrl:ShowGuildMemberList(data)
    self.PvpArenaInvitationItemPool:ShowTemplates({ Datas = data })

end

---@param data ClientShowFriendData[]
function PvpArenaInvitationCtrl:ShowFriendList(data)
    self.PvpArenaInvitationItemPool:ShowTemplates({ Datas = data })
end

--lua custom scripts end
return PvpArenaInvitationCtrl