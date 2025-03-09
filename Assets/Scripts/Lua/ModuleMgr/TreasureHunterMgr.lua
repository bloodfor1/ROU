--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleMgr.TreasureHunterMgr
module("ModuleMgr.TreasureHunterMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

--lua model end

--lua custom scripts

local l_data = DataMgr:GetData("TreasureHunterData")

function SurveyTreasure()
    local l_msgId = Network.Define.Rpc.SurveyTreasure
    Network.Handler.SendRpc(l_msgId, nil)
end

function OnSurveyTreasure(msg)
    ---@type SurveyTreasureRes
    local l_info = ParseProtoBufToTable("SurveyTreasureRes", msg)
    --if l_info.error_code ~= 0 then
    --    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    --end
    local EndUpdate = l_data.SetSurveyBtnCdStamp(l_info.CD)
    if not EndUpdate then
        EventDispatcher:Dispatch(l_data.END_UPDATE_CD)
    end
end

function OnTreasureHunterShowSurveyBtn(msg)
    ---@type TreasureHunterShowSurveyBtnData
    local l_info = ParseProtoBufToTable("TreasureHunterShowSurveyBtnData", msg)
    local active = l_info.enable
    if active then
        UIMgr:ActiveUI(UI.CtrlNames.TreasureHunter_Btn)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.TreasureHunter_Btn)
    end
end

function OnMonsterTreasureDelNtf(...)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TREASUREHUNTER_TREASURE_IS_OVER"))
end

function OnTreasureHunterInfoNtf(msg)
    ---@type RepeatTreasureChestInfo
    local l_info = ParseProtoBufToTable("RepeatTreasureChestInfo", msg)
    l_data.AddEntityInfos(l_info.detector)
end

function GetTreasurePanelInfo(uid)
    local l_msgId = Network.Define.Rpc.GetTreasurePanelInfo
    local l_sendInfo = GetProtoBufSendTable("GetTreasurePanelInfoArg")
    l_sendInfo.uid = uid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetTreasurePanelInfo(msg, arg)
    ---@type GetTreasurePanelInfoRes
    local l_info = ParseProtoBufToTable("GetTreasurePanelInfoRes", msg)
    if l_info.errcode ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    else
        l_data.SetSelectPanelInfo(l_info)
        l_data.SetSelectEntityUid(arg.uid)
        UIMgr:ActiveUI(UI.CtrlNames.TreasureHunter)
    end
end

function HelpTreasure(uid)
    local l_msgId = Network.Define.Rpc.HelpTreasure
    local l_sendInfo = GetProtoBufSendTable("HelpTreasureArg")
    l_sendInfo.uid = uid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnHelpTreasure(msg, arg)
    ---@type HelpTreasureRes
    local l_info = ParseProtoBufToTable("HelpTreasureRes", msg)
    if l_info.errcode ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    end
    EventDispatcher:Dispatch(l_data.IS_HELP)
end

function SendHelpToFirend(uid)
    local str = Common.Utils.Lang("TREASURE_HUNTER_HELP_FRIEND")
    local info = l_data.GetSelectPanelInfo()
    local awardName = l_data.GetAwardName(info.treasure_award_id)
    str = StringEx.Format(str, awardName)
    local param
    str, param = MgrMgr:GetMgr("LinkInputMgr").GetTreasureHunterAwardPack(str, info.pos, info.scene_line, MScene.SceneID)
    MgrMgr:GetMgr("FriendMgr").RequestSendPrivateChatMsg(uid, str, param, true)
    UIMgr:DeActiveUI(UI.CtrlNames.TreasureHunter)
    UIMgr:DeActiveUI(UI.CtrlNames.TreasureHunter_invite)
    MgrMgr:GetMgr("FriendMgr").OpenCommunity()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SEND_SUCCESS"))
end

function SendHelpToGuild(rewardId, pos, line)
    local str = Common.Utils.Lang("TREASURE_HUNTER_HELP_GUILD")
    local awardName = l_data.GetAwardName(rewardId)
    str = StringEx.Format(str, awardName)
    local param
    str, param = MgrMgr:GetMgr("LinkInputMgr").GetTreasureHunterAwardPack(str, pos, line, MScene.SceneID)
    if MgrMgr:GetMgr("ChatMgr").SendChatMsg(MPlayerInfo.UID, str, DataMgr:GetData("ChatData").EChannel.GuildChat, param) then
        local l_changeToChannel = DataMgr:GetData("ChatData").EChannel.GuildChat
        UIMgr:DeActiveUI(UI.CtrlNames.TreasureHunter)
        UIMgr:ActiveUI(UI.CtrlNames.Chat, { changeToChannel = l_changeToChannel, needChangeToCurrentChannel = true })
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SEND_SUCCESS"))
    end
end

function StartTreasureHunter()
    local l_msgId = Network.Define.Rpc.StartTreasureHunter
    Network.Handler.SendRpc(l_msgId, nil)
end

function OnStartTreasureHunter(msg, arg)
    ---@type StartTreasureHunterRes
    local l_info = ParseProtoBufToTable("StartTreasureHunterRes", msg)
    if l_info.err ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.err), l_info.result))
    end
end

--lua custom scripts end
return ModuleMgr.TreasureHunterMgr