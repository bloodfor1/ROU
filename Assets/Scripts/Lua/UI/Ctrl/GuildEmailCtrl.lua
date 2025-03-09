--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildEmailPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildEmailCtrl = class("GuildEmailCtrl", super)
--lua class define end

local l_maxGuildEmailWordsLength = 100  --内容字数上限
local l_VitalityCost = 100 --元气消耗

--lua functions
function GuildEmailCtrl:ctor()

    super.ctor(self, CtrlNames.GuildEmail, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent

end --func end
--next--
function GuildEmailCtrl:Init()

    self.panel = UI.GuildEmailPanel.Bind(self)
    super.Init(self)

    l_maxGuildEmailWordsLength = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("GuildNoticeMailLimit").Value)
    l_VitalityCost = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("GuildNoticeMailCost").Value)

    self.panel.CostTipText.LabText = Lang("GUILD_EMAIL_COST_TIP", l_VitalityCost)

    self.panel.WordsInput.Input.characterLimit = l_maxGuildEmailWordsLength

    self.panel.BtnClose:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildEmail)
    end)
    self.panel.BtnSend:AddClick(function()
        self:GuildEmailSend()
    end)
    self.panel.WordsRemain.LabText = Lang("STILL_CAN_INPUT_COUNT", tostring(l_maxGuildEmailWordsLength))
    self.panel.WordsInput:OnInputFieldChange(function()
        local l_wordsLength = string.ro_len_normalize(self.panel.WordsInput.Input.text)
        self.panel.WordsRemain.LabText = Lang("STILL_CAN_INPUT_COUNT", tostring(l_maxGuildEmailWordsLength - l_wordsLength))
    end)

    --设置遮罩
    --self:SetBlockOpt(BlockColor.Transparent)

end --func end
--next--
function GuildEmailCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildEmailCtrl:OnActive()


end --func end
--next--
function GuildEmailCtrl:OnDeActive()


end --func end
--next--
function GuildEmailCtrl:Update()


end --func end





--next--
function GuildEmailCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function GuildEmailCtrl:GuildEmailSend()
    local l_content = self.panel.WordsInput.Input.text
    --职位判定
    local l_guildData = DataMgr:GetData("GuildData")
    if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.ViceChairman then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_EMAIL_POSITION_ERROR"))
        UIMgr:DeActiveUI(UIMgr.CtrlNames.GuildEmail)
        return
    end
    --内容为空判定
    if string.ro_isEmpty(l_content) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_EMAIL_CONTENT_EMPTY"))
        return
    end
    --字数上限判定
    if string.ro_len_normalize(l_content) > 100 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_EMAIL_CONTENT_TOO_LONG"), l_maxGuildEmailWordsLength)
        return
    end
    --元气是否足够判定
    if MPlayerInfo.Yuanqi < MLuaCommonHelper.Long(l_VitalityCost) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VITALITY_NOT_ENOUGH"))
        return
    end
    --发送
    MgrMgr:GetMgr("GuildMgr").ReqSendGuildEmail(l_content)
end
--lua custom scripts end
