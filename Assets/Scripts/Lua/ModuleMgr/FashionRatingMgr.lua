---@module ModuleMgr.FashionRatingMgr
module("ModuleMgr.FashionRatingMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
Event = {
    ResetData = "ResetData", --刷新所有数据
    DetailData = "DetailData", --详细数据
    HistoryData = "HistoryData", --历史杂志
    InvData = "InvData", --刷新邀请函数据
    LetterData = "LetterData", --获得邀请函
    RoleData = "RoleData", --拼玩家模型
}

FashionMagazineID = 0
FashionLetterID = 2040010
FashionPhotoFocusOffset = nil
FashionCameraDistanceRange = nil
FashionCameraTiltRange = nil
FashionLeaderboardCount = 0
FashionMagazineTime = nil
FashionCameraCountDown = nil
FashionBaseRewardScorePercentage = nil -- 玩家分数/理论最高分超过多少才发放参与奖
IsFashionRatingPhoto = false        -- 当前是否是时尚评分拍照
FashionMagazineNpcID = 6212
FashionRankID = 1000
FashionTableID = 1000
RankLimit = 100     --排行榜上限
RankPageLimit = 20      --排行榜每页上限
FashionData = DataMgr:GetData("FashionData")
---key为2表示显示所有排名，为12时表示显示公会与好友
RankKey = 2

CanUpData = false --能否上传照片数据
ScenarioStartWaitCommand = nil
ScenarioGradeWaitCommand = nil
----------------------------------生命周期
function OnInit()

    FashionMagazineID = MGlobalConfig:GetInt("FashionMagazineID")
    FashionPhotoFocusOffset = MGlobalConfig:GetSequenceOrVectorFloat("FashionPhotoFocusOffset")
    FashionPhotoFocusOffset = Vector3.New(FashionPhotoFocusOffset[0], FashionPhotoFocusOffset[1], FashionPhotoFocusOffset[2])
    FashionCameraDistanceRange = MGlobalConfig:GetSequenceOrVectorFloat("FashionCameraDistanceRange")
    FashionCameraDistanceRange = Vector2.New(FashionCameraDistanceRange[0], FashionCameraDistanceRange[1])
    FashionCameraTiltRange = MGlobalConfig:GetSequenceOrVectorFloat("FashionCameraTiltRange")
    FashionCameraTiltRange = Vector2.New(FashionCameraTiltRange[0], FashionCameraTiltRange[1])
    FashionCameraCountDown = MGlobalConfig:GetInt("FashionCameraCountDown")
    FashionLeaderboardCount = MGlobalConfig:GetInt("FashionLeaderboardCount")
    FashionMagazineTime = MGlobalConfig:GetSequenceOrVectorString("FashionMagazineTime")
    FashionBaseRewardScorePercentage = MGlobalConfig:GetFloat("FashionBaseRewardScorePercentage")
    FashionMagazineNpcID = MGlobalConfig:GetInt("FashionMagazineNpcID")
    FashionRankID = MGlobalConfig:GetInt("GarderobeLeaderboardID")
    FashionScoreRankID = MGlobalConfig:GetInt("FashionLeaderboardID")
    FashionTableID = GetFashionTableID(FashionRankID)
    RankLimit = TableUtil.GetLeaderBoardComponentTable().GetRowByID(FashionTableID).RecordCount
    RankPageLimit = TableUtil.GetLeaderBoardComponentTable().GetRowByID(FashionTableID).CountsPerPage
    --InitNpc()

end

function OnLogout()

    if ScenarioStartWaitCommand then
        ScenarioStartWaitCommand.Block:Quit()
        ScenarioStartWaitCommand = nil
    end
    if ScenarioGradeWaitCommand then
        ScenarioGradeWaitCommand.Block:Quit()
        ScenarioGradeWaitCommand = nil
    end
    FashionData.CurPoint = 0
    FashionData.MaxPoint = 0
    FashionData.GradeCount = 0

end

function OnReconnected(reconnectData)
    --断线重连

end

function OnSelectRoleNtf(roleInfo)
    --角色登陆成功

end

------------------------------------
function GetFashionTableID(id)

    local leaderId = TableUtil.GetLeaderBoardFrameTable().GetRowByID(FashionRankID)
    if leaderId then
        local leaderData = Common.Functions.VectorToTable(leaderId.LeaderBoards)
        if leaderData then
            return leaderData[1]
        else
            return id
        end
    else
        return id
    end

end
--道具点击使用按钮的时刻
function TryUseItem(uid, propID)

    if propID == FashionMagazineID then
        UIMgr:ActiveUI(UI.CtrlNames.FashionRatingMain)
        return true
    elseif propID == FashionLetterID then
        UIMgr:ActiveUI(UI.CtrlNames.FashionCollection)
        return true
    end
    return false

end

--保存上传照片
function TryUploadPhotograph()

    if MScene.GameCamera.UCam == nil then
        return
    end
    if MEntityMgr.PlayerEntity == nil then
        return
    end

    local l_model = MEntityMgr.PlayerEntity.Model
    local l_p = l_model.Position
    local l_s = l_model.Scale
    local l_r = l_model.Rotation.eulerAngles
    local l_mM = MScene.GameCamera.UCam.worldToCameraMatrix
    local l_pM = MScene.GameCamera.UCam.projectionMatrix
    local l_curAnim = MEntityMgr.PlayerEntity.Model.Ator:GetCurrentAnimInfo()
    SendUploadFashionPhotoData({
        --摄影机矩阵数据
        l_mM.m00, l_mM.m01, l_mM.m02, l_mM.m03,
        l_mM.m10, l_mM.m11, l_mM.m12, l_mM.m13,
        l_mM.m20, l_mM.m21, l_mM.m22, l_mM.m23,
        l_mM.m30, l_mM.m31, l_mM.m32, l_mM.m33,
        l_pM.m00 * MScene.GameCamera.UCam.aspect,
        l_pM.m01, l_pM.m02, l_pM.m03,
        l_pM.m10, l_pM.m11, l_pM.m12, l_pM.m13,
        l_pM.m20, l_pM.m21, l_pM.m22, l_pM.m23,
        l_pM.m30, l_pM.m31, l_pM.m32, l_pM.m33,
        --主角位置-旋转-缩放
        l_p.x, l_p.y, l_p.z,
        l_s.x, l_s.y, l_s.z,
        l_r.x, l_r.y, l_r.z,
        --动画
        l_curAnim.NormalizedTime,
        --表情
        MEntityMgr.PlayerEntity.Model.EmotionEyeId,
        MEntityMgr.PlayerEntity.Model.EmotionMouthId,
    }, {
        l_curAnim.StateKey,
        l_curAnim.ClipPath,
    })

end

--劇本開始調用
function ScenarioStart(luatype, command, args)

    ScenarioStartWaitCommand = command
    RequestFashionEvaluationInfo()

end

--剧本按钮【给我评分】调用
function ScenarioGrade(luatype, command, args)

    local l_mgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_mgr.IsSystemOpen(l_mgr.eSystemId.FashionRating) then
        local l_row = TableUtil.GetOpenSystemTable().GetRowById(l_mgr.eSystemId.FashionRating)
        if l_row then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Fashion_Unlock", l_row.BaseLevel)) --等级%s才能参加时尚评分
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BAG_TIP_NO_FUNCTION"))
        end
        command.Block:Quit()
        return
    end

    ScenarioGradeWaitCommand = command
    RequestEvaluateFashion()

end

--劇本，拍照入口
function ScenarioPhotograph(luatype, command, args)

    --如果在坐骑上，则下坐骑
    if MEntityMgr.PlayerEntity.IsRideAnyVehicle then
        MgrMgr:GetMgr("VehicleMgr").RequestTakeVehicle(false)
    end

    local l_photoData = {
        openType = FashionData.EUIOpenType.FASHION_PHOTO,
        callBack = function()
            local mgr = MgrMgr:GetMgr("FashionRatingMgr")
            if mgr.CanUpData ~= 1 then
                logError("当前分数不为最高分，不保存拍照数据")
                return
            end
            mgr.TryUploadPhotograph()
        end
    }
    UIMgr:ActiveUI(UI.CtrlNames.Photograph, { [UI.CtrlNames.Photograph] = l_photoData })

end
----------------------------------协议
--当前主题和次数数据
function RequestFashionEvaluationInfo()

    local l_msgId = Network.Define.Rpc.RequestFashionEvaluationInfo
    ---@type FashionEvaluationInfoArg
    local l_sendInfo = GetProtoBufSendTable("FashionEvaluationInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnFashionEvaluationInfo(msg, arg)

    ---@type FashionEvaluationInfoRes
    local l_resInfo = ParseProtoBufToTable("FashionEvaluationInfoRes", msg)

    FashionData.SetEvaluationInfo(l_resInfo)
    EventDispatcher:Dispatch(Event.InvData)
    if ScenarioStartWaitCommand then
        ScenarioStartWaitCommand:FinishCommand()
        ScenarioStartWaitCommand = nil
    end

end

--当前npc数据
function RequestFashionEvaluationNpc()

    local l_msgId = Network.Define.Rpc.RequestFashionEvaluationNpc
    ---@type FashionEvaluationNpcArg
    local l_sendInfo = GetProtoBufSendTable("FashionEvaluationNpcArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnFashionEvaluationNpc(msg, arg)

    ---@type FashionEvaluationNpcRes
    local l_resInfo = ParseProtoBufToTable("FashionEvaluationNpcRes", msg)

    FashionData.NpcData = { sceneId = l_resInfo.npc_scene_id, x = l_resInfo.npc_x, y = l_resInfo.npc_y, z = l_resInfo.npc_z }
    EventDispatcher:Dispatch(Event.InvData)

end

--为自己评分
function RequestEvaluateFashion()

    local l_msgId = Network.Define.Rpc.EvaluateFashion
    ---@type EvaluateFashionArg
    local l_sendInfo = GetProtoBufSendTable("EvaluateFashionArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnEvaluateFashion(msg, arg)

    ---@type EvaluateFashionRes
    local l_resInfo = ParseProtoBufToTable("EvaluateFashionRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
        if ScenarioGradeWaitCommand then
            ScenarioGradeWaitCommand.Block:Quit()
            ScenarioGradeWaitCommand = nil
        end
        return
    end
    FashionData.CurPoint = l_resInfo.score
    FashionData.MaxPoint = l_resInfo.max_score
    CanUpData = l_resInfo.has_update
    if ScenarioGradeWaitCommand then
        ScenarioGradeWaitCommand:FinishCommand()
        ScenarioGradeWaitCommand = nil
    end
    --logError("评分完成!, score = {0}; max_score = {1}; has_update = {2}", l_resInfo.score, l_resInfo.max_score, l_resInfo.has_update)    RequestFashionEvaluationInfo()

end

--上传【照片】数据
function SendUploadFashionPhotoData(args, args64)

    local l_msgId = Network.Define.Ptc.UploadFashionPhotoData
    ---@type UploadFashionPhotoData
    local l_sendInfo = GetProtoBufSendTable("UploadFashionPhotoData")
    for i = 1, #args do
        l_sendInfo.photo.args:add().value = args[i]
    end
    for i = 1, #args64 do
        l_sendInfo.photo.action:add().value = args64[i]
    end
    FashionData.PhotoData = l_sendInfo.photo
    l_sendInfo.index = FashionData.GradeCount
    Network.Handler.SendPtc(l_msgId, l_sendInfo)

end

--拉取杂志数据
function RequestFashionMagazine(round)

    local l_msgId = Network.Define.Rpc.RequestFashionMagazine
    ---@type FashionMagazineArg
    local l_sendInfo = GetProtoBufSendTable("FashionMagazineArg")
    l_sendInfo.round = round
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnFashionMagazine(msg, arg)

    ---@type FashionMagazineRes
    local l_resInfo = ParseProtoBufToTable("FashionMagazineRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
        return
    end

    FashionData.JournalRound = l_resInfo.round
    FashionData.JournalTheme = l_resInfo.theme
    local l_newDataLis = {}
    for i = 1, #l_resInfo.ranks do
        local l_uid = l_resInfo.ranks[i].value
        l_newDataLis[i] = {
            rid = l_uid,
            rank = i,
        }
    end
    --[[for i = 2, 50 do
        l_newDataLis[i] = {
            rid = l_newDataLis[i - 1].rid,
            rank = i,
        }
    end]]

    FashionData.SetNewData(l_newDataLis)
    EventDispatcher:Dispatch(Event.ResetData)

end

--拉取杂志历史
function RequestFashionHistory()

    local l_msgId = Network.Define.Rpc.FashionHistory
    ---@type RoleFashionScoreArg
    local l_sendInfo = GetProtoBufSendTable("FashionHistoryArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnFashionHistory(msg, arg)

    local l_resInfo = ParseProtoBufToTable("FashionHistoryRes", msg)
    FashionData.SetHistoryMagazine(l_resInfo.history_nodes)
    EventDispatcher:Dispatch(Event.HistoryData)

end

--拉取照片数据
function RequestRoleFashionScore(data, round)

    local l_msgId = Network.Define.Rpc.RequestRoleFashionScore
    ---@type RoleFashionScoreArg
    local l_sendInfo = GetProtoBufSendTable("RoleFashionScoreArg")
    for _, v in pairs(data) do
        local roleid = l_sendInfo.roleid:add()
        roleid.role_id = v.rid
        roleid.index = v.photo_id
    end
    l_sendInfo.round = round
    Network.Handler.SendRpc(l_msgId, l_sendInfo, data)

end

function OnRoleFashionScore(msg, _, arg)

    ---@type RoleFashionScoreRes
    local l_resInfo = ParseProtoBufToTable("RoleFashionScoreRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
        return
    end
    if l_resInfo.socre == nil or #l_resInfo.socre <= 0 then
        return
    end
    for i = 1, #l_resInfo.socre do
        local l_data = FashionData.SetRoleFashionScore(l_resInfo.socre[i], arg)
        if l_data then
            EventDispatcher:Dispatch(Event.DetailData, l_data)
        end
    end

end

function ApplyFashionTicket()

    local l_msgId = Network.Define.Rpc.FetchFashionTicket
    ---@type FetchFashionTicketArg
    local l_sendInfo = GetProtoBufSendTable("FetchFashionTicketArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnFashionTicket(msg)

    local l_resInfo = ParseProtoBufToTable("FetchFashionTicketRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
        return
    end
    EventDispatcher:Dispatch(Event.LetterData)

end
--分享时尚评分至公会聊天界面
function ShareFashionRating()

    local l_fashionTheme = TableUtil.GetFashionThemeTable().GetRowByID(FashionData.JournalTheme, true)
    if l_fashionTheme then
        local l_curPercent = FashionData.CurPoint / tonumber(l_fashionTheme.HighestScore)
        local l_text = ""
        if l_curPercent - tonumber(FashionBaseRewardScorePercentage) >= 0 then
            l_text = Common.Utils.Lang("FashionRatingShareGuild", FashionData.CurPoint, string.format("%.1f", l_curPercent * 100))
        else
            l_text = Common.Utils.Lang("FashionRatingShareGuildShort", FashionData.CurPoint)
        end
        ShareFashionPhoto()
        local l_channel = DataMgr:GetData("ChatData").EChannel.GuildChat
        -- 由于客户端不知道一共能评分多少次 这里给服务器传GradeCount剩余次数
        local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetFashionRatingPack(l_text, MPlayerInfo.UID, FashionData.GradeCount or 0)
        local l_isSendSucceed = MgrMgr:GetMgr("ChatMgr").SendChatMsg(MPlayerInfo.UID, l_msg, l_channel, l_msgParam)
        if l_isSendSucceed then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ShareSucceedTextGuild"))
        end
    end

end

function ShareFashionPhoto()

    local l_msgId = Network.Define.Ptc.ShareFashionPhoto
    ---@type FashionPhotoShareData
    local l_sendInfo = GetProtoBufSendTable("FashionPhotoShareData")
    l_sendInfo.photo_data = FashionData.PhotoData
    l_sendInfo.score = FashionData.CurPoint
    Network.Handler.SendPtc(l_msgId, l_sendInfo)

end

-- 点击公会聊天短链接
function ClickLinkToShowPhoto(rid, photoId)

    local l_fashionData = {
        openType = DataMgr:GetData("FashionData").EUIOpenType.RATING_PHOTO,
        rid = rid,
        type = ChatHrefType.FashionRating,
        photoId = photoId
    }
    UIMgr:ActiveUI(UI.CtrlNames.FashionRatingPhoto, l_fashionData)

end

function ChatShareC2M(type, uid)

    local l_msgId = Network.Define.Rpc.ChatShareMsg
    ---@type ChatShareC2MArg
    local l_sendInfo = GetProtoBufSendTable("ChatShareC2MArg")
    l_sendInfo.uid = uid
    l_sendInfo.share_type = type
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnChatShareC2MMsg(photo)

    local l_data = FashionData.SetSharePhotoInfo(photo)
    EventDispatcher:Dispatch(Event.DetailData, l_data)

end

function ClickItemOwner(itemId)
    return _haveItemWithId(itemId)
end

function _haveItemWithId(propId)
    local types = {
        GameEnum.EBagContainerType.Bag,
        GameEnum.EBagContainerType.Cart,
        GameEnum.EBagContainerType.WareHouse,
    }

    local count = Data.BagApi:GetItemCountByContListAndTid(types, propId)
    return 0 < count
end

function InitNpc()
    -- do nothing
end

function GotoNpc()

    local l_taskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    if not l_taskMgr.IsActivityOpend(l_taskMgr.g_ActivityType.activity_Fashion) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_IS_ALREADY_OVER"))
        return
    end

    game:ShowMainPanel()
    local l_position = Vector3(FashionData.NpcData.x + 0.5, FashionData.NpcData.y, FashionData.NpcData.z + 0.5)
    MTransferMgr:GotoPosition(FashionData.NpcData.sceneId, l_position, function()
        MgrMgr:GetMgr("NpcMgr").TalkWithNpc(FashionData.NpcData.sceneId, FashionMagazineNpcID)
    end)

end

function CreatePlayerModel(info)

    EventDispatcher:Dispatch(Event.RoleData, info)

end

return FashionRatingMgr