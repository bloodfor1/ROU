--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TreasureHunter_invitePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TreasureHunter_inviteCtrl = class("TreasureHunter_inviteCtrl", super)
--lua class define end

--lua functions
function TreasureHunter_inviteCtrl:ctor()

    super.ctor(self, CtrlNames.TreasureHunter_invite, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent
    self.ClosePanelNameOnClickMask = UI.CtrlNames.TreasureHunter_invite
end --func end
--next--
function TreasureHunter_inviteCtrl:Init()

    self.panel = UI.TreasureHunter_invitePanel.Bind(self)
    super.Init(self)
    self.FriendTem = nil
end --func end
--next--
function TreasureHunter_inviteCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.FriendTem = nil
end --func end
--next--
function TreasureHunter_inviteCtrl:OnActive()
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TreasureHunter_invite)
    end)
    self:RefreshPanel()
end --func end
--next--
function TreasureHunter_inviteCtrl:OnDeActive()


end --func end
--next--
function TreasureHunter_inviteCtrl:Update()


end --func end
--next--
function TreasureHunter_inviteCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

function TreasureHunter_inviteCtrl:RefreshPanel()
    local l_friendInfos = MgrMgr:GetMgr("FriendMgr").GetFriendInfos()
    if #l_friendInfos <= 1 then
        self.panel.NilPanel:SetActiveEx(true)
        self.panel.LoopScroll:SetActiveEx(false)
        return
    end
    self.panel.NilPanel:SetActiveEx(false)
    self.panel.LoopScroll:SetActiveEx(true)
    if self.FriendTem == nil then
        self.FriendTem = self:NewTemplatePool({
            TemplateClassName = "TreasureHunterInviteTem",
            ScrollRect = self.panel.LoopScroll.LoopScroll,
            TemplatePrefab = self.panel.TreasureHunterInviteTem.gameObject,
        })
    end
    local l_data = {}
    for i = 2, #l_friendInfos do
        table.insert(l_data, l_friendInfos[i])
    end
    self.FriendTem:ShowTemplates({ Datas = l_data })
end

--lua custom scripts end
return TreasureHunter_inviteCtrl