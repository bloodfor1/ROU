--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/TeammatePanel"
require "UI/Template/GHMateInviteTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
TeammateHandler = class("TeammateHandler", super)
--lua class define end

--lua functions
function TeammateHandler:ctor()
    
    super.ctor(self, HandlerNames.Teammate, 0)
    
end --func end
--next--
function TeammateHandler:Init()
    
    self.panel = UI.TeammatePanel.Bind(self)
    super.Init(self)

    self.curSelectedItem = nil
    --排行榜池建立
    self.rankTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GHMateInviteTemplate,
        TemplatePrefab = self.panel.GHMateInvitePrefab.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })
    self.panel.GHMateInvitePrefab.gameObject:SetActiveEx(false)
    self.Mgr = MgrMgr:GetMgr("GuildHuntMgr")

    self.refreshCD = 0
    self.panel.RefreshBtn:AddClick(function()
        if self.refreshCD <= 0 then
            self.Mgr.ReqGuildHuntFindTeamMate()
            self.refreshCD = MGlobalConfig:GetFloat("TeamInviteCD", 5)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("HAVE_UPDATE"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFRESH_TOO_FAST"))
        end
    end)
    
end --func end
--next--
function TeammateHandler:Uninit()

    self.curSelectedItem = nil
    self.rankTemplatePool = nil
    self.Mgr = nil
    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function TeammateHandler:OnActive()

    self.rankTemplatePool:ShowTemplates({Datas = DataMgr:GetData("GuildData").guildHuntInfo.friendList,
        Method = function(memberItem)
            self:OnSelectRankMemberItem(memberItem)
        end})
    
end --func end
--next--
function TeammateHandler:OnDeActive()
    
    
end --func end
--next--
function TeammateHandler:Update()

    if self.refreshCD > 0 then
        self.refreshCD = self.refreshCD - UnityEngine.Time.deltaTime
    end

end --func


--next--
function TeammateHandler:BindEvents()

    self:BindEvent(self.Mgr.EventDispatcher,self.Mgr.ON_GET_GUILD_HUNT_INFO, function(self)
        self:OnActive()
    end)

end --func end

--next--
--lua functions end

--lua custom scripts
--选中某个成员的点击事件
function TeammateHandler:OnSelectRankMemberItem(memberItem)

    if self.curSelectedItem ~= nil then
        self.curSelectedItem:SetSelect(false)
    end
    self.curSelectedItem = memberItem
    self.curSelectedItem:SetSelect(true)
    --显示玩家详细界面
    local l_ui = UIMgr:GetUI(UI.CtrlNames.PlayerMenuL)
    if (not l_ui) or (not l_ui.isActive) then
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(MLuaCommonHelper.Long(memberItem.data.member.role_uid))
    end

end
--lua custom scripts end
return TeammateHandler