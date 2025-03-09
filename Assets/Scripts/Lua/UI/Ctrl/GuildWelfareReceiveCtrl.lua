--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildWelfareReceivePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildWelfareReceiveCtrl = class("GuildWelfareReceiveCtrl", super)
--lua class define end

--lua functions
function GuildWelfareReceiveCtrl:ctor()

    super.ctor(self, CtrlNames.GuildWelfareReceive, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function GuildWelfareReceiveCtrl:Init()

    self.panel = UI.GuildWelfareReceivePanel.Bind(self)
    super.Init(self)

    --点击背景蒙版关闭
    self.panel.BgButton:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

end --func end
--next--
function GuildWelfareReceiveCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GuildWelfareReceiveCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("GuildData").EUIOpenType.GuildWelfareReceive then
            self:RefreshInfo(self.uiPanelData.data)
        end
    end

end --func end
--next--
function GuildWelfareReceiveCtrl:OnDeActive()


end --func end
--next--
function GuildWelfareReceiveCtrl:Update()


end --func end



--next--
function GuildWelfareReceiveCtrl:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("GuildWelfareMgr").EventDispatcher,MgrMgr:GetMgr("GuildWelfareMgr").ON_GUILD_GET_WELFARE_AWARD, function(self, isGet)
        self:RefreshButtons(isGet)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildWelfareReceiveCtrl:RefreshInfo(data)
    local l_guildData = DataMgr:GetData("GuildData")
    --抬头
    local titleStr = Common.Utils.Lang("GUILD_WELFARE_RECEIVE_TITLE")
    local postionId = l_guildData.GetSelfGuildPosition()
    if postionId > l_guildData.EPositionType.Beauty then
        postionId = l_guildData.EPositionType.Member
    end
    local positionName = l_guildData.GetPositionName(postionId)
    self.panel.ReceiveTitle.LabText = StringEx.Format(titleStr, MPlayerInfo.Name, positionName)
    --公告
    local textStr = Common.Utils.Lang("GUILD_WELFARE_RECEIVE_TEXT")
    self.panel.ReceiveText.LabText = StringEx.Format(textStr, tostring(data.zeny))
    --按钮显示
    self:RefreshButtons(data.isGet)
    --按钮功能
    self.panel.BtnConfirm:AddClick(function()
        MgrMgr:GetMgr("GuildWelfareMgr").ReqGetWelfareAward()
    end)
end

function GuildWelfareReceiveCtrl:RefreshButtons(isGet)
    self.panel.BtnConfirm.gameObject:SetActiveEx(not isGet)
    self.panel.BtnNone.gameObject:SetActiveEx(isGet)
end
--lua custom scripts end
