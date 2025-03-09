--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildInviteOfferPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildInviteOfferCtrl = class("GuildInviteOfferCtrl", super)
--lua class define end

local l_guildId = 0  --目标公会ID
local l_inviterId = nil  --邀请者id
local l_isCanEnterDirect = false  --是否可以直接进入公会
local l_totalTime = 9 --总时间
local l_remainTime = l_totalTime --剩余时间
local l_isInitOver = false

--lua functions
function GuildInviteOfferCtrl:ctor()

    super.ctor(self, CtrlNames.GuildInviteOffer, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function GuildInviteOfferCtrl:Init()

    self.panel = UI.GuildInviteOfferPanel.Bind(self)
    super.Init(self)
    l_guildId = 0
    l_totalTime = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("GuildInvitedTime").Value)
    l_remainTime = l_totalTime

    self.panel.BtClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildInviteOffer)
    end)

    self.panel.BtYes:AddClick(function()
        self:AgreeInvite()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildInviteOffer)
    end)

    l_isInitOver = true

end --func end
--next--
function GuildInviteOfferCtrl:Uninit()

    l_guildId = 0
    l_inviterId = nil
    l_isCanEnterDirect = false
    l_totalTime = 9
    l_remainTime = l_totalTime
    l_isInitOver = false

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildInviteOfferCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("GuildData").EUIOpenType.GuildInviteOffer then
            local l_data = self.uiPanelData
            self:SetInviteInfo(l_data.playerId, l_data.playerName, l_data.playerLv, 
                l_data.guildId, l_data.guildName, l_data.isCanEnter)
        end
    end

end --func end
--next--
function GuildInviteOfferCtrl:OnDeActive()


end --func end
--next--
function GuildInviteOfferCtrl:Update()

    if l_isInitOver then
        if l_remainTime <= 0 then
            UIMgr:DeActiveUI(UI.CtrlNames.GuildInviteOffer)
        else
            self.panel.Slider.Slider.value = l_remainTime / l_totalTime
        end
        l_remainTime = l_remainTime - UnityEngine.Time.deltaTime
    end

end --func end





--next--
function GuildInviteOfferCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
--设置界面信息
function GuildInviteOfferCtrl:SetInviteInfo(playerId, playerName, playerLv, guildId, guildName, isCanEnterDirect)

    l_guildId = guildId
    l_inviterId = playerId
    self.panel.TxName.LabText = playerName or ""
    self.panel.TxLevel.LabText = StringEx.Format("Lv {0}", playerLv or 0)
    self.panel.TxDetail.LabText = Lang("GUILD_INVITE_TEXT", guildName)
    l_isCanEnterDirect = isCanEnterDirect

end

--同意邀请请求
function GuildInviteOfferCtrl:AgreeInvite()
    --判断公会id是否为0
    if l_guildId == 0 then
        return
    end
    --判断自己是否有公会
    if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_IN_GUILD"))
        return
    end
    --请求加入
    MgrMgr:GetMgr("GuildMgr").ReqApply(l_guildId, l_isCanEnterDirect and l_inviterId or 0)
end
--lua custom scripts end
