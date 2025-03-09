--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AddFriendsPanel"

require "Common/Functions"
require "Common/Utils"
require "UI/Template/AddFriendTemplate"
require "Common/UI_TemplatePool"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
AddFriendsCtrl = class("AddFriendsCtrl", super)
--lua class define end

--lua functions
function AddFriendsCtrl:ctor()

    super.ctor(self, CtrlNames.AddFriends, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function AddFriendsCtrl:Init()

    self.panel = UI.AddFriendsPanel.Bind(self)
	super.Init(self)

    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.AddFriends)
    end)

    self.panel.BtnSearch:AddClick(function()
        self:SearchFriend()
    end)

    self.panel.Emty.gameObject:SetActiveEx(true)
    self.panel.ScrollView.gameObject:SetActiveEx(false)

    self.templatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AddFriendTemplate,
        TemplatePrefab = self.panel.AddFriend.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll,
    })

    self.panel.ScrollView.LoopScroll.enabled = false

    self.panel.SearchInput:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        self.panel.SearchInput.Input.text=value;
    end,false)
end --func end
--next--
function AddFriendsCtrl:Uninit()

    self.templatePool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AddFriendsCtrl:OnActive()


end --func end
--next--
function AddFriendsCtrl:OnDeActive()


end --func end
--next--
function AddFriendsCtrl:Update()


end --func end



--next--
function AddFriendsCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("FriendMgr").EventDispatcher,MgrMgr:GetMgr("FriendMgr").SearchRoleEvent,function(self, search_list)
        self:OnSearchUpdate(search_list)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function AddFriendsCtrl:SearchFriend()

    local l_content= self.panel.SearchInput.Input.text
    if not string.ro_isEmpty(l_content) then
        -- self.panel.SearchInput.Input.text=""
        MgrMgr:GetMgr("FriendMgr").RequestSearchRole(l_content)
    else

    end
end

function AddFriendsCtrl:OnSearchUpdate(search_list)
    local l_dataLis = {}
    for i=1,#search_list do
        local l_data = search_list[i]
        if l_data.role_uid and l_data.role_uid~=0 then
            if l_data.name and not string.ro_isEmpty(l_data.name) then
                l_dataLis[#l_dataLis+1] = l_data
            end
        end
    end

    local l_count = #l_dataLis
    if l_count <= 0 then
        self.panel.Emty.gameObject:SetActiveEx(true)
        self.panel.ScrollView.gameObject:SetActiveEx(false)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SEARCH_ROLE_NONE"))
        return
    else
        self.panel.Emty.gameObject:SetActiveEx(false)
        self.panel.ScrollView.gameObject:SetActiveEx(true)
    end

    self.templatePool:ShowTemplates({Datas = l_dataLis, Method = function(id)
        self:RequestAddFriend(id)
    end})
end

function AddFriendsCtrl:RequestAddFriend(id)

    MgrMgr:GetMgr("FriendMgr").RequestAddFriend(id)
end

--lua custom scripts end
