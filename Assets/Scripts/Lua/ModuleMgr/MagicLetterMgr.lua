---@module MagicLetterMgr : MagicLetterData
module("ModuleMgr.MagicLetterMgr", package.seeall)

local l_waitSendLetterResult = false
---@type ModuleMgr.PropMgr
local l_propMgr = MgrMgr:GetMgr("PropMgr")

--region 协议相关
function ReqAllMagicLetters()
    local l_reqLetterInfoState, l_currentReqMinUUID = GetReqMagicLetterStateInfo()
    --已请求完所有数据
    if l_currentReqMinUUID < 0 then
        return
    end
    local l_msgId = Network.Define.Rpc.QueryMagicPaper
    ---@type QueryMagicPaperArg
    local l_sendInfo = GetProtoBufSendTable("QueryMagicPaperArg")
    l_sendInfo.uuid = l_currentReqMinUUID
    l_sendInfo.type = l_reqLetterInfoState
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function ReqMagicLetterInfoByUUID(letterUid)
    local l_reqLetterInfoState, l_currentReqMinUUID = GetReqMagicLetterStateInfo()
    --已请求完所有数据
    if l_currentReqMinUUID < 0 then
        return
    end
    local l_msgId = Network.Define.Rpc.QueryMagicPaper
    ---@type QueryMagicPaperArg
    local l_sendInfo = GetProtoBufSendTable("QueryMagicPaperArg")
    l_sendInfo.uuid = l_currentReqMinUUID
    l_sendInfo.type = l_reqLetterInfoState
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnRetQueryMagicPaper(msg, arg)
    ---@type QueryMagicPaperRes
    local l_sendInfo = ParseProtoBufToTable("QueryMagicPaperRes", msg)

    if l_sendInfo.result == ErrorCode.ERR_SUCCESS then
        SetLetterInfos(l_sendInfo.brief_list, arg.letterStateType)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_sendInfo.result))
    end
end
--@Description:目前只有信笺礼包被抢完才会获取此数据
function ReqMagicLetterDetailInfo(letterUid)
    local l_msgId = Network.Define.Rpc.QueryGrapPaper
    ---@type QueryGrapPaperArg
    local l_sendInfo = GetProtoBufSendTable("QueryGrapPaperArg")
    l_sendInfo.paper_uid = ToUInt64(letterUid)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnRetMagicLetterDetailInfo(msg, arg)
    ---@type QueryGrapPaperRes
    local l_sendInfo = ParseProtoBufToTable("QueryGrapPaperRes", msg)
    if l_sendInfo.result == ErrorCode.ERR_SUCCESS then
        SetMagicLetterDetailInfo(arg.paper_uid, l_sendInfo.grap_list)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_sendInfo.result))
    end
end
function ReqGrabRedEnvelope(letterUid)
    local l_msgId = Network.Define.Rpc.GrabMagicPaper
    ---@type GrabMagicPaperArg
    local l_sendInfo = GetProtoBufSendTable("GrabMagicPaperArg")
    l_sendInfo.paper_uid = MLuaCommonHelper.ULong(letterUid)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnRetGrabRedEnvelope(msg, arg)
    ---@type GrabMagicPaperRes
    local l_info = ParseProtoBufToTable("GrabMagicPaperRes", msg)
    local l_isSuccess = l_info.result == ErrorCode.ERR_SUCCESS

    CreateLetterInfo(l_info.paper_brief)

    if not l_isSuccess then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        SetMagicLetterDetailInfo(l_info.paper_brief.paper_uid, l_info.paper_deail)
    end

    local l_letterInfo = GetLetterInfoByUid(arg.paper_uid)
    if l_letterInfo ~= nil then
        if l_isSuccess then
            l_letterInfo.isReceived = true
            if l_info.envelope.items ~= nil and #l_info.envelope.items > 0 then
                ---@type ItemBrief
                local l_rewardInfo = l_info.envelope.items[1]
                local l_propItem = TableUtil.GetItemTable().GetRowByItemID(l_rewardInfo.item_id)
                if not MLuaCommonHelper.IsNull(l_propItem) then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GRAB_REDENVELOPE_SUCCESS", l_letterInfo.sendPlayerName, l_propItem.ItemName, l_rewardInfo.item_count))
                end
            end
        else
            if l_info.result ~= ErrorCode.ERR_RED_ENVELOPE_REPEAT_GRAB then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GRAB_REDENVELOPE_FAIL", l_letterInfo.sendPlayerName))
            end
        end
    end
    EventDispatcher:Dispatch(EMagicEvent.OnGetMagicLetterInfo)
    EventDispatcher:Dispatch(EMagicEvent.OnGetGrabRedEnvelopeResult, l_isSuccess,arg.paper_uid,l_info.envelope)
end
function ReqThanksMagicPaper(letterUid, receivePlayerUid)
    local l_msgId = Network.Define.Rpc.ThanksMagicPaper
    ---@type ThanksMagicPaperArg
    local l_sendInfo = GetProtoBufSendTable("ThanksMagicPaperArg")
    l_sendInfo.paper_uid = MLuaCommonHelper.ULong(letterUid)
    Network.Handler.SendRpc(l_msgId, l_sendInfo, receivePlayerUid)
end
function OnRetThanksMagicPaper(msg, arg, customData)
    ---@type ThanksMagicPaperRes
    local l_info = ParseProtoBufToTable("ThanksMagicPaperRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        MgrMgr:GetMgr("FriendMgr").RequestSendPrivateChatMsg(customData, Lang("THANKS_SEND_LETTER"))
    end
    UIMgr:DeActiveUI(UI.CtrlNames.MagicLetter)

end
function ReqSendMagicLetter(blessing)
    if string.ro_len(blessing) < 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED_BLESSING_TIPS"))
        return
    end
    local l_receiveFriendInfo = GetReceiveLetterFriendInfo()
    if l_receiveFriendInfo == nil then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED_FRIEND_TIP"))
        return
    end
    local l_magicPaperItem = TableUtil.GetMagicPaperTypeTable().GetRowByMagicPaperID(GetFragranceEffectId())
    if MLuaCommonHelper.IsNull(l_magicPaperItem) or l_magicPaperItem.MagicPaperExpend.Length < 1 then
        return
    end
    local l_sendLetterPropId = l_magicPaperItem.MagicPaperExpend[0][0]
    local l_sendLetterPropNeedNum = l_magicPaperItem.MagicPaperExpend[0][1]
    local l_sendLetterPropNum = Data.BagModel:GetBagItemCountByTid(l_sendLetterPropId)
    local l_coinPropId = l_magicPaperItem.MagicPaperExpend[1][0]
    local l_coinPropNeedNum = l_magicPaperItem.MagicPaperExpend[1][1]
    local l_coinItem = TableUtil.GetItemTable().GetRowByItemID(l_coinPropId)
    local l_sendLetterCostItem = TableUtil.GetItemTable().GetRowByItemID(l_sendLetterPropId)
    if MLuaCommonHelper.IsNull(l_coinItem) or MLuaCommonHelper.IsNull(l_sendLetterCostItem) then
        logError("ItemTable not exist Id:" .. tostring(l_coinPropId) .. " or Id:" .. tostring(l_sendLetterPropId))
        return
    end
    local l_coinPropText = GetImageText(l_coinItem.ItemIcon, l_coinItem.ItemAtlas, 20, 26, false)
    local l_sendLetterPropTxt = GetImageText(l_sendLetterCostItem.ItemIcon, l_sendLetterCostItem.ItemAtlas, 20, 26, false)
    local l_coinCostStr = MNumberFormat.GetNumberFormat(tostring(l_coinPropNeedNum))
    local l_content = Lang("SEND_MAGIC_LETTER_DIALOG_CONTENT", l_sendLetterPropTxt, l_sendLetterPropNeedNum, l_coinPropText, l_coinCostStr)
    local l_dialogExtraData = {
        imgClickInfos = {
            {
                imgName = l_sendLetterCostItem.ItemIcon,
                clickAction = function(spriteName, ed)
                    Common.CommonUIFunc.SetDialogRichTextPropClickEvent(l_sendLetterPropId, ed.position)
                end,
            },
            {
                imgName = l_coinItem.ItemIcon,
                clickAction = function(spriteName, ed)
                    Common.CommonUIFunc.SetDialogRichTextPropClickEvent(l_coinPropId, ed.position)
                end,
            },
        }
    }

    CommonUI.Dialog.ShowPayConfirmDlg(true, Lang("SEND_LETTER_TITLE"), l_content, function()
        local l_hasCoinNum = Data.BagModel:GetCoinNumById(l_coinPropId)
        if l_sendLetterPropNum < l_sendLetterPropNeedNum and l_hasCoinNum < l_coinPropNeedNum then
            if not MLuaCommonHelper.IsNull(l_coinItem) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
            end
            return
        end
        sendMagicLetterMsg(blessing, l_receiveFriendInfo, GetFragranceEffectId())
    end, nil, nil, nil, nil, nil, nil, nil, UnityEngine.TextAnchor.MiddleLeft, l_dialogExtraData)
end
---@param blessing string @祝福语
---@param receiveFriendInfo FriendInfo
---@param fragranceId number @香氛id
function sendMagicLetterMsg(blessing, receiveFriendInfo, fragranceId)
    if l_waitSendLetterResult then
        return
    end
    local l_msgId = Network.Define.Rpc.SendMagicPaper
    ---@type SendMagicPaperArg
    local l_sendInfo = GetProtoBufSendTable("SendMagicPaperArg")
    l_sendInfo.bless_words = blessing
    l_sendInfo.recv_uid = receiveFriendInfo.uid
    l_sendInfo.paper_id = fragranceId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRetSendMagicPaper(msg, arg)
    ---@type SendMagicPaperRes
    local l_info = ParseProtoBufToTable("SendMagicPaperRes", msg)
    if l_info.result == ErrorCode.ERR_SUCCESS then
        UIMgr:DeActiveUI(UI.CtrlNames.MagicLetter)
        SetLastSendLetterContent("")
        l_propMgr.EventDispatcher:RemoveObjectAllFunc(l_propMgr.USE_ITEM_REPLY, ModuleMgr.MagicLetterMgr)
        l_propMgr.EventDispatcher:Add(l_propMgr.USE_ITEM_REPLY, function(_, askType, useItemSuc, letterInfo)
            if askType ~= AskGsUseItemType.AskGsUseItemType_MagicPaper then
                return
            end
            l_waitSendLetterResult = false
            if useItemSuc then
                InsertSendLetterSelf(letterInfo)
            end
        end, ModuleMgr.MagicLetterMgr)
        PlayMagicLetterFullScreenEffect(false)
    else
        l_waitSendLetterResult = false
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end
---@param receiveFriendInfo FriendInfo
function onTestSendMagicLetterSuc(letterUid, blessing, receiveFriendInfo)
    letterUid = MLuaCommonHelper.ULong(11111111111)
    ---@type ModuleMgr.ChatMgr
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_letterParam = {
        {
            type = l_chatMgr.ChatHrefType.MagicLetter,

            param64 = {
                [1] = letterUid,
                [2] = receiveFriendInfo.uid,
            },
            name = {
                [1] = receiveFriendInfo.base_info.name,
            }
        }
    }
    --发送世界频道聊天消息
    l_chatMgr.SendChatMsg(MPlayerInfo.UID, blessing, l_chatMgr.EChannel.WorldChat, l_letterParam)

    --发送好友频道聊天消息
    local l_friendMgr = MgrMgr:GetMgr("FriendMgr")
    l_friendMgr.RequestSendPrivateChatMsg(receiveFriendInfo.uid, blessing, l_letterParam)
end
--endregion

--region 外部接口
---@Description:查看魔法信笺
function CheckMagicLetter(uid)
    local l_letterInfo = GetLetterInfoByUid(uid)
    if l_letterInfo ~= nil then
        --已分配完，展示查看界面
        if l_letterInfo.isAllAllocated then
            UIMgr:ActiveUI(UI.CtrlNames.MagicLetterSee,{
                letterUid= uid,
                showDetail = true,
            })
            return
            --自己已抢过，弹提示
        elseif l_letterInfo.isReceived then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("HAS_GRAB_LETTER_TIPS"))
            UIMgr:ActiveUI(UI.CtrlNames.MagicLetterSee, {
                letterUid= uid,
                showDetail = true,
            })
            return
        end
    end
    UIMgr:ActiveUI(UI.CtrlNames.MagicLetterSee, {
        letterUid= uid,
        showDetail = false,
    })
end

---@Description:播放魔法信笺接收或者发送时的全屏特效
---@param isReceive boolean 是否为接收信笺
function PlayMagicLetterFullScreenEffect(isReceive)
    if UIMgr:IsActiveUI(UI.CtrlNames.MagicLetterBigEffect) then
        EventDispatcher:Dispatch(EMagicEvent.PlayFullScreenEffect,isReceive)
    else
        local l_openPanelData = {
            showReceiveLetterEffect = isReceive,
            showSendLetterEffect = not isReceive,
        }
        UIMgr:ActiveUI(UI.CtrlNames.MagicLetterBigEffect,l_openPanelData)
    end
end
--endregion

--region 测试代码
function CreateTestMagicInfos(infoNum)
    local l_data = {}

    for i = 1, infoNum do
        ---@type letterInfo
        local l_letterInfo = {
            letterUid = MPlayerInfo.UID + i,
            sendPlayerUid = MPlayerInfo.UID,
            sendPlayerName = "sendPlayer_" .. i,
            receivePlayerUid = MPlayerInfo.UID,
            receivePlayerName = "receivePlayer_" .. i,
            blessing = "blessing!",
            sendTime = i * 4294967295,
            isAllAllocated = i % 2 == 0,
        }
        table.insert(l_data, l_letterInfo)
    end
    SetLetterInfos(l_data)
end
function CreateTestMagicLetterRedEnvelopeInfo(letterUid)
    CreateTestMagicLetterDetailInfo(letterUid)
    isSuc = letterUid % 2 == 0
    -----@type letterDetailInfo
    local l_letterDetailInfo = GetMagicLetterDetailInfo(letterUid)
    l_letterDetailInfo.hasGrabRedEnvelope = true
    EventDispatcher:Dispatch(EMagicEvent.OnGetGrabRedEnvelopeResult, isSuc, GetMagicLetterDetailInfo(letterUid)[1])
end
function CreateTestMagicLetterDetailInfo(letterUid)
    ---@type letterDetailInfo
    local l_detailInfos = {
        {
            roleUid = MPlayerInfo.UID,
            isSuperRedEnvelope = true,
            rewardPropId = 103,
            number = 10,
        },
        {
            roleUid = MPlayerInfo.UID,
            isSuperRedEnvelope = false,
            rewardPropId = 101,
            number = 20,
        }
    }
    SetMagicLetterDetailInfo(letterUid, l_detailInfos)
end
--endregion
return MagicLetterMgr