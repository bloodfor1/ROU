---@class playerInfo
---@field data @Add 协议数据
---@field uid int64
---@field name string
---@field level number
---@field sex number
---@field type number
---@field guildId number
---@field guildName string
---@field tag string @Add玩家标签
---@field equipData @Add缓存-不要直接取
---@field GetEquipData function  @Add获取入口
---@field attribData  @缓存-不要直接取
---@field GetAttribData function @Add获取入口
---@field fightIdleAnimPath string @Add缓存-不要直接取
---@field GetPathFightIdleAnim function @Add获取入口
---@field IconFrameID number @角色头像框ID
---@field ChatBubbleID number @其他角色聊天气泡框ID
---@field ChatTagID number @角色聊天标签ID

---@module ModuleMgr.PlayerInfoMgr
module("ModuleMgr.PlayerInfoMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

SET_MAIN_TARGET_EVENT = "SET_MAIN_TARGET_EVENT"
--@Description:从服务器获得单个玩家信息
GET_SINGLE_PLAYERINFO_FROM_SERVER = "GET_SINGLE_PLAYERINFO_FROM_SERVER"
--@Description:从服务器获得一组玩家信息
GET_GROUP_PLAYERINFO_FROM_SERVER = "GET_GROUP_PLAYERINFO_FROM_SERVER"
---@type hashmap
local l_cachePlayerInfoTable = Common.hashmap.create()
local l_playerInfoTable = Common.hashmap.create()

PlayerCallbackInfo = {}
g_bossAndTargetCache = {}

local NEED_TARGET_NAME_BOSS_TYPE = {
    [ROGameLibs.UnitTypeLevel.kUnitTypeLevel_BOSS:ToInt()] = true,
    [ROGameLibs.UnitTypeLevel.kUnitTypeLevel_Mini:ToInt()] = true,
    [ROGameLibs.UnitTypeLevel.kUnitTypeLevel_MVP:ToInt()] = true
}

--MgrMgr调用
function OnLogout()
    ClearTaskSceneObjActionID()
    MPlayerInfo:ClearTaskNpcAction()
    MPlayerInfo:ClearCollection()
    l_cachePlayerInfoTable:clear()
    g_bossAndTargetCache = {}
end

function SetMainTarget(uid, name, lv, isRole, isEnemy, isNpc, isCollection, isMercenary)
    local l_openData = {
        openType = DataMgr:GetData("TipsData").MainTargetInfoOpenType.RefreshTargetInfo,
        targetUid = uid,
        targetName = name,
        targetLv = lv,
        targetIsRole = isRole,
        targetIsEnemy = isEnemy,
        targetIsNpc = isNpc,
        targetIsCollection = isCollection,
        targetIsMercenary = isMercenary
    }
    UIMgr:ActiveUI(UI.CtrlNames.MainTargetInfo, l_openData)
    MgrMgr:GetMgr("TeamMgr").SetTeamTargetPlayer(uid)
end

function DisPatchSetTarget(uid, name, lv, isRole, isEnemy, isNpc, isCollection, isMercenary)
    EventDispatcher:Dispatch(SET_MAIN_TARGET_EVENT, uid, name, lv, isRole, isEnemy, isNpc, isCollection, isMercenary)
end

function HideOter()
    local l_handler = UIMgr:GetHandler(UI.CtrlNames.QuickPanel, UI.HandlerNames.QuickTeamPanel)
    if l_handler then
        l_handler:CloseAllMarkUI()
    end
end

function SetTargetHP(uid, hp, maxhP)
    local l_openData = {
        openType = DataMgr:GetData("TipsData").MainTargetInfoOpenType.RefreshTargetHP,
        uid = uid,
        hp = hp,
        maxhP = maxhP,
    }
    UIMgr:ActiveUI(UI.CtrlNames.MainTargetInfo, l_openData)
end

function SetTargetSP(uid, sp, maxSP)
    local l_openData = {
        openType = DataMgr:GetData("TipsData").MainTargetInfoOpenType.RefreshTargetSP,
        uid = uid,
        sp = sp,
        maxSP = maxSP,
    }
    UIMgr:ActiveUI(UI.CtrlNames.MainTargetInfo, l_openData)
end

-- EntityTable中字段UnitTypeLevel为2,4,5的怪物，被玩家选取后，会显示当前仇恨目标。
function SetTargetTargetName(message,bossUID,targetUID)
    local l_target_entity = MEntityMgr:GetEntity(bossUID)
    if l_target_entity and l_target_entity.AttrMonster and NEED_TARGET_NAME_BOSS_TYPE[l_target_entity.AttrMonster:GetMonsterUnitTypeLevel()] then
        if tostring(targetUID) == "0" then
            g_bossAndTargetCache[tostring(bossUID)] = nil
        else
            g_bossAndTargetCache[tostring(bossUID)] = targetUID
        end
        g_bossAndTargetCache[tostring(bossUID)] = targetUID
        local l_openData = {
            openType = DataMgr:GetData("TipsData").MainTargetInfoOpenType.RefreshTargetTargetName,
            uid = bossUID,
            targetUID = targetUID,
        }
        UIMgr:ActiveUI(UI.CtrlNames.MainTargetInfo, l_openData)
    end
end

function UpdatePlayerTriggerAction(triggerId, actionId)
    MPlayerInfo:AddTaskSceneObjActionID(triggerId, actionId)
end

function RemovePlayerTriggerAction(triggerId)
    MPlayerInfo:RemoveTaskSceneObjActionID(triggerId)
end

function ClearTaskSceneObjActionID()
    MPlayerInfo:ClearTaskSceneObjActionID()
end

function AddCollectionWithTask(taskId, collectionId)
    MPlayerInfo:AddCollectionWithTask(taskId, collectionId)
end

function RemoveCollectionWithTask(taskId, collectionId)
    MPlayerInfo:RemoveCollectionWithTask(taskId, collectionId)
end

function AddCollectionWithTaskTarget(targetId, collectionId)
    MPlayerInfo:AddCollectionWithTaskTarget(targetId, collectionId)
end

function RemoveCollectionWithTaskTarget(targetId, collectionId)
    MPlayerInfo:RemoveCollectionWithTaskTarget(targetId, collectionId)
end

function CacheTaskNpcPosition(npcId, scencId, position)
    MPlayerInfo:CacheTaskNpcPosition(npcId, scencId, position)
end

function RemoveTaskNpcPosition(npcId, scencId)
    MPlayerInfo:RemoveTaskNpcPosition(npcId, scencId)
end

function ClearTaskNpcPosition()
    MPlayerInfo:ClearTaskNpcPosition()
end

function AddTaskNpcAction(npcId, actionId, script, tag)
    MPlayerInfo:AddTaskNpcAction(npcId, actionId, script, tag)
end

function RemoveTaskNpcAction(npcId)
    MPlayerInfo:RemoveTaskNpcAction(npcId)
end

function OnReconnected(reconnectData)
    PlayerCallbackInfo = {}
end

--region 协议信息
--通过服务器数据那角色数据:在请求中的角色不过重复请求
--id：角色uid (uint64 or string)
function GetPlayerInfoFromServer(uid, func)
    local l_funcArray = PlayerCallbackInfo[uid] or {}
    PlayerCallbackInfo[uid] = l_funcArray
    table.insert(l_funcArray, func)
    if #l_funcArray <= 1 then
        local l_msgId = Network.Define.Rpc.ChatSenderInfo
        ---@type ChatSenderInfoArg
        local l_sendInfo = GetProtoBufSendTable("ChatSenderInfoArg")
        l_sendInfo.uid = uid
        Network.Handler.SendRpc(l_msgId, l_sendInfo, uid)
    end
end

--接收服务器的角色信息协议
function OnChatSenderInfo(msg, arg, customData)
    ---@type ChatSenderInfoRes
    local l_resInfo = ParseProtoBufToTable("ChatSenderInfoRes", msg)
    local l_idst = arg.uid --arg现在用对象池缓存，连续请求会覆盖之前的参数，故用customData代替
    if customData ~= nil then
        l_idst = customData
    end
    local l_funcArray = PlayerCallbackInfo[l_idst] or {}
    PlayerCallbackInfo[l_idst] = nil

    --返回的结构体
    local l_returnObj = CreatMemberData(l_resInfo.member_info)
    l_returnObj.error = l_resInfo.error
    for i = 1, #l_funcArray do
        local l_func = l_funcArray[i]
        l_func(l_returnObj)
    end

    --需求最新的服务器数据，目前不做缓存

    --新的缓存机制，用于对数据新旧不敏感的模块
    l_cachePlayerInfoTable:put(l_idst, l_returnObj)

    EventDispatcher:Dispatch(GET_SINGLE_PLAYERINFO_FROM_SERVER, l_idst, l_returnObj)
end

function BatchGetPlayerInfoFromServer(uidList)
    local l_msgId = Network.Define.Rpc.BatchChatSenderInfo
    ---@type BatchChatSenderInfoArg
    local l_sendInfo = GetProtoBufSendTable("BatchChatSenderInfoArg", msg)
    for i = 1, #uidList do
        l_sendInfo.role_uid_list:add().value = uidList[i]
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnBatchGetPlayerInfoFromServer(msg, arg)
    local l_msgId = Network.Define.Rpc.BatchChatSenderInfo
    ---@type BatchChatSenderInfoRes
    local l_sendInfo = ParseProtoBufToTable("BatchChatSenderInfoRes", msg)
    if l_sendInfo.error == ErrorCode.ERR_SUCCESS then
        for i = 1, #l_sendInfo.member_list do
            local l_memberData = CreatMemberData(l_sendInfo.member_list[i])
            l_cachePlayerInfoTable:put(l_memberData.uid, l_memberData)
        end
        EventDispatcher:Dispatch(GET_GROUP_PLAYERINFO_FROM_SERVER)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_sendInfo.error))
    end
end

---@Description:请求角色的战斗相关信息
function ReqGetRolesBattleInfo(roleUIDs)
    local l_msgId = Network.Define.Rpc.GetRolesBattleInfo
    ---@type GetRolesBattleInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetRolesBattleInfoArg")
    for k, v in pairs(roleUIDs) do
        table.insert(l_sendInfo.role_id_list,v)
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRetGetRolesBattleInfo(msg)
    ---@type GetRolesBattleInfoRes
    local l_resInfo = ParseProtoBufToTable("GetRolesBattleInfoRes", msg)
    if l_resInfo.roles_battle_info_list==nil then
        return
    end
    MgrMgr:GetMgr("CapraCardMgr").RetRoleBattleInfo(l_resInfo.roles_battle_info_list)
end

--endregion

-------------------------------管理玩家信息缓存--------------------------------

--获取玩家信息
function GetPlayerInfoLocal(uid, isFromChat)
    local l_uidStr = MoonCommonLib.StringEx.ConverToString(uid)

    --策划需求最新的服务器数据，缓存池暂时没用
    if l_playerInfoTable:containsKey(l_uidStr) then
        local playerInfo = l_playerInfoTable:get(l_uidStr)
        playerInfo.isSelf = false
        return playerInfo
    end

    if MPlayerInfo ~= nil and MoonCommonLib.StringEx.ConverToString(MPlayerInfo.UID) == l_uidStr then
        local l_playerInfo = {}
        l_playerInfo.uid = uid
        l_playerInfo.uidStr = l_uidStr
        l_playerInfo.name = MPlayerInfo.Name
        if MPlayerInfo.IsMale then
            l_playerInfo.sex = 0
        else
            l_playerInfo.sex = 1
        end
        l_playerInfo.role_type = MPlayerInfo.ProfessionId / 1000 * 1000
        l_playerInfo.head_gear_id = MPlayerInfo.OrnamentHead or 0
        l_playerInfo.mouth_gear_id = MPlayerInfo.OrnamentMouth or 0
        l_playerInfo.face_gear_id = MPlayerInfo.OrnamentFace or 0
        l_playerInfo.head_equip_id = MPlayerInfo.OrnamentHeadFromBag or 0
        l_playerInfo.face_equip_id = MPlayerInfo.OrnamentFaceFromBag or 0
        l_playerInfo.mouth_equip_id = MPlayerInfo.OrnamentMouthFromBag or 0
        l_playerInfo.hair_style_id = MPlayerInfo.HairStyle or 0
        l_playerInfo.fashion_id = MPlayerInfo.Fashion or 0
        l_playerInfo.level = MPlayerInfo.Lv or 0
        l_playerInfo.tag = DataMgr:GetData("RoleTagData").GetActiveTagId()
        l_playerInfo.has_album = false -- 暂时设为false
        l_playerInfo.isSelf = true

        return l_playerInfo
    end

    if not isFromChat then
        local l_playerInfo = {}
        l_playerInfo.uid = uid
        l_playerInfo.uidStr = l_uidStr
        local l_entity = MEntityMgr:GetEntity(uid)
        if l_entity == nil then
            return nil
        end
        l_playerInfo.name = l_entity.Name
        return l_playerInfo
    end

    return nil
end

--@Description:获取缓存的玩家数据信息，可能比较旧，慎用
function GetCachePlayerInfo(uid)
    if uid:equals(MPlayerInfo.UID) then
        return GetPlayerInfoLocal(uid, false)
    end
    return l_cachePlayerInfoTable:get(uid)
end

---@param member MemberBaseInfo
---@return playerInfo
function CreatMemberData(member)
    if not member then
        return
    end

    return {
        error = nil,
        data = member, --协议数据
        --基本信息
        uid = member.role_uid,
        uidStr = tostring(member.role_uid),
        name = member.name or "",
        level = member.base_level or 0,
        sex = member.sex or 0,
        type = member.type or 1000,
        guildId = member.guild_id or 0,
        guildName = string.ro_isEmpty(member.guild_name) and Lang("NO_GUILD") or member.guild_name,
        --- 角色头像框
        IconFrameID = _getValidFrameID(member.outlook.portrait_frame),
        --- 聊天气泡框
        ChatBubbleID = _getValidChatBubbleID(member.chat_frame),
        --- 聊天头像框
        ChatTagID = member.chat_tag,
        -- 玩家标签
        tag = member.tag,
        equipData = nil, --缓存-不要直接取
        GetEquipData = dataGetEquipData, --获取入口
        attribData = nil, --缓存-不要直接取
        GetAttribData = dataGetAttribData, --获取入口
        fightIdleAnimPath = nil, --缓存-不要直接取
        GetPathFightIdleAnim = getFightIdleAnimPath, --获取入口
    }
end

--获取玩家的装备数据 (解析玩家外观 头像 拼模型均可使用)
--data = 来着服务器的MemberBaseInfo对象
---@param data MemberBaseInfo
function GetEquipData(data)
    if data == nil then
        logError("data 不能为空！")
        return nil
    end

    local l_equipData = MoonClient.MEquipData.New()
    l_equipData.IconFrameID = _getValidFrameID(data.outlook.portrait_frame)
    l_equipData.IsMale = ((data.sex or 0) == 0)
    l_equipData.ProfessionID = data.type or 1000  --为空报错则显示初心者
    l_equipData.HairID = data.outlook.hair_id or 0
    l_equipData.HairStyleID = data.outlook.hair_id or 0
    l_equipData.EyeID = data.outlook.eye.eye_id or 0
    l_equipData.EyeColorID = data.outlook.eye.eye_style_id or 0
    l_equipData.FashionItemID = data.outlook.wear_fashion or 0
    l_equipData.HeadID = data.outlook.wear_head_portrait_id or 0
    --装备(背包)中装备的饰品
    l_equipData.OrnamentHeadFromBagItemID = 0
    l_equipData.FashionFromBagItemID = 0
    l_equipData.OrnamentFaceFromBagItemID = 0
    l_equipData.OrnamentMouthFromBagItemID = 0

    --装扮(时装)中的装备的饰品
    --饰品还是背包中的饰品
    --外形覆盖装备(背包)中装备的饰品
    --即相当于饰品装备幻化 属性取背包中装备的 外形取装扮中装备的
    l_equipData.OrnamentHeadItemID = 0
    l_equipData.OrnamentFaceItemID = 0
    l_equipData.OrnamentMouthItemID = 0

    local E_EQUIP_POS_TYPE = GameEnum.EEquipSlotIdxType
    --- PB给过来的编号到lua当中会加1，这个时候使用的时候客户端的槽位枚举
    local l_equipIdList = data.equip_ids
    l_equipData.OrnamentHeadFromBagItemID = _getItemIdByEquipPos(E_EQUIP_POS_TYPE.Helmet, l_equipIdList)
    l_equipData.OrnamentFaceFromBagItemID = _getItemIdByEquipPos(E_EQUIP_POS_TYPE.FaceGear, l_equipIdList)
    l_equipData.OrnamentMouthFromBagItemID = _getItemIdByEquipPos(E_EQUIP_POS_TYPE.MouthGear, l_equipIdList)
    l_equipData.WeaponItemIDFromBag = _getItemIdByEquipPos(E_EQUIP_POS_TYPE.MainWeapon, l_equipIdList)
    l_equipData.WeaponExItemIDFromBag = _getItemIdByEquipPos(E_EQUIP_POS_TYPE.BackupWeapon, l_equipIdList)
    l_equipData.FashionFromBagItemID = _getItemIdByEquipPos(E_EQUIP_POS_TYPE.Fashion, l_equipIdList)

    --- 这里可能是背饰，也可能是尾巴
    local bagGearID = _getItemIdByEquipPos(E_EQUIP_POS_TYPE.BackGear, l_equipIdList)
    local ornament = TableUtil.GetOrnamentTable().GetRowByOrnamentID(bagGearID, true)
    if nil ~= ornament then
        if ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Back then
            l_equipData.OrnamentBackFromBagItemID = bagGearID
        elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Tail then
            l_equipData.OrnamentTailFromBagItemID = bagGearID
        end
    end

    --装扮(时装)中的装备的饰品获取
    local l_oenamentIdList = data.outlook.wear_ornament
    for i = 1, #l_oenamentIdList do
        local ornament = TableUtil.GetOrnamentTable().GetRowByOrnamentID(l_oenamentIdList[i].value, true)
        if ornament then
            if ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Head then
                l_equipData.OrnamentHeadItemID = ornament.OrnamentID
            elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Face then
                l_equipData.OrnamentFaceItemID = ornament.OrnamentID
            elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Mouth then
                l_equipData.OrnamentMouthItemID = ornament.OrnamentID
            elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Back then
                l_equipData.OrnamentBackItemID = ornament.OrnamentID
            elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Tail then
                l_equipData.OrnamentTailItemID = ornament.OrnamentID
            end
        end
    end

    return l_equipData
end

--- 获取合理的聊天气泡框ID，如果服务器没赋值，这里就设置为默认值
---@param bubbleID number
---@return number
function _getValidChatBubbleID(bubbleID)
    local default = MgrMgr:GetMgr("DialogBgMgr").GetDefault()
    if nil == bubbleID or 0 >= bubbleID then
        return default
    end

    return bubbleID
end

--- 如果参数值非法，这里会直接设置为默认值
---@param frameID number
---@return number
function _getValidFrameID(frameID)
    local default = MgrMgr:GetMgr("HeadFrameMgr").GetDefault()
    if nil == frameID or 0 >= frameID then
        return default
    end

    return frameID
end

--- 根据槽位获取角色装备ID
---@param equipPos number @PB的EquipPos
---@param idTable table<number, PBuint32>
---@return number
function _getItemIdByEquipPos(equipPos, idTable)
    if nil == equipPos then
        logError("[PlayerInfo] invalid param")
        return 0
    end

    local ret = 0
    local targetValue = idTable[equipPos]
    if nil ~= targetValue then
        ret = targetValue.value
    end

    return ret
end

--获取玩家的装备数据 (解析玩家外观 头像 拼模型均可使用)
---@param data RoleBriefInfo
function GetEquipDataByRoleBriefInfo(data)
    if data == nil then
        logError("RoleBriefInfo data 不能为空！")
        return nil
    end

    local l_equipData = MoonClient.MEquipData.New()

    l_equipData.IconFrameID = _getValidFrameID(data.outlook.portrait_frame)
    l_equipData.IsMale = ((data.sex or 0) == 0)
    l_equipData.ProfessionID = data.type or 1000  --为空报错则显示初心者
    l_equipData.HairID = data.outlook.hair_id or 0
    l_equipData.HairStyleID = data.outlook.hair_id or 0
    l_equipData.EyeID = data.outlook.eye.eye_id or 0
    l_equipData.EyeColorID = data.outlook.eye.eye_style_id or 0

    local l_head = data.outlook.wear_head_portrait
    l_equipData.HeadID = l_head and l_head.ItemID or 0
    l_equipData.HeadID = l_equipData.HeadID or 0
    l_equipData.FashionItemID = 0
    if data.outlook.wear_fashion ~= nil and data.outlook.wear_fashion.ItemID ~= nil then
        l_equipData.FashionItemID = data.outlook.wear_fashion.ItemID
    end

    --装备(背包)中装备的饰品
    l_equipData.OrnamentHeadFromBagItemID = 0
    l_equipData.OrnamentFaceFromBagItemID = 0
    l_equipData.OrnamentMouthFromBagItemID = 0
    l_equipData.FashionFromBagItemID = 0

    --装扮(时装)中的装备的饰品
    --饰品还是背包中的饰品
    --外形覆盖装备(背包)中装备的饰品
    --即相当于饰品装备幻化 属性取背包中装备的 外形取装扮中装备的
    l_equipData.OrnamentHeadItemID = 0
    l_equipData.OrnamentFaceItemID = 0
    l_equipData.OrnamentMouthItemID = 0

    --装备(背包)中装备的饰品获取
    local l_equipIdList = data.equip_ids
    if l_equipIdList ~= nil then
        for i = 1, #l_equipIdList do
            local l_equipId = l_equipIdList[i].value
            if l_equipId > 0 then
                local ornament = TableUtil.GetOrnamentTable().GetRowByOrnamentID(l_equipId, true)
                if ornament then
                    if ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Head then
                        l_equipData.OrnamentHeadFromBagItemID = ornament.OrnamentID
                    elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Face then
                        l_equipData.OrnamentFaceFromBagItemID = ornament.OrnamentID
                    elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Mouth then
                        l_equipData.OrnamentMouthFromBagItemID = ornament.OrnamentID
                    elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Back then
                        l_equipData.OrnamentBackFromBagItemID = ornament.OrnamentID
                    elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Tail then
                        l_equipData.OrnamentTailFromBagItemID = ornament.OrnamentID
                    end
                else
                    local equip = TableUtil.GetEquipTable().GetRowById(l_equipId, true)
                    if equip and equip.WeaponId ~= 0 then
                        if i == 1 then
                            l_equipData.WeaponItemIDFromBag = equip.Id
                        else
                            l_equipData.WeaponExItemIDFromBag = equip.Id
                        end
                    end
                    if equip and equip.EquipId == 15 then
                        l_equipData.FashionFromBagItemID = equip.Id
                    end
                end
            end
        end
    end

    --装扮(时装)中的装备的饰品获取
    local l_oenamentIdList = data.outlook.wear_ornament
    if l_oenamentIdList ~= nil then
        for i = 1, #l_oenamentIdList do
            local ornament = TableUtil.GetOrnamentTable().GetRowByOrnamentID(l_oenamentIdList[i].ItemID, true)
            if ornament then
                if ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Head then
                    l_equipData.OrnamentHeadItemID = ornament.OrnamentID
                elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Face then
                    l_equipData.OrnamentFaceItemID = ornament.OrnamentID
                elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Mouth then
                    l_equipData.OrnamentMouthItemID = ornament.OrnamentID
                elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Back then
                    l_equipData.OrnamentBackItemID = ornament.OrnamentID
                elseif ornament.OrnamentType == OrnamentWearType.OrnamentWearType_Tail then
                    l_equipData.OrnamentTailItemID = ornament.OrnamentID
                end
            end
        end
    end

    if data.equipData ~= nil then
        l_equipData.OrnamentHeadItemID = data.equipData.OrnamentHeadItemID
        l_equipData.OrnamentFaceItemID = data.equipData.OrnamentFaceItemID
        l_equipData.OrnamentMouthItemID = data.equipData.OrnamentMouthItemID
        l_equipData.OrnamentBackItemID = data.equipData.OrnamentBackItemID
        l_equipData.OrnamentTailItemID = data.equipData.OrnamentTailItemID
    end
    return l_equipData
end

--获取属性对象
--data = 来着服务器的MemberBaseInfo对象
--equipData = MoonClient.MEquipData对象，而已为空
function GetAttribData(data, equipData)
    if equipData == nil then
        equipData = GetEquipData(data)
        if equipData == nil then
            logError("equipData is nil")
            return
        end
    end
    local l_tempId = MUIModelManagerEx:GetTempUID()
    if equipData.ProfessionID == 0 then
        logError("传入的玩家数据不对，ProfessionID = 0")
        return
    end
    local l_attribData = MAttrMgr:InitRoleAttr(l_tempId, data.name, equipData.ProfessionID, equipData.IsMale, nil)
    l_attribData:SetOrnament(equipData.HairID)
    l_attribData:SetHair(equipData.HairStyleID)
    l_attribData:SetEye(equipData.EyeID)
    l_attribData:SetEyeColor(equipData.EyeColorID)
    l_attribData:SetFashion(equipData.FashionItemID)
    l_attribData:SetFashion(equipData.FashionFromBagItemID, true)
    l_attribData:SetOrnament(equipData.OrnamentHeadItemID)
    l_attribData:SetOrnament(equipData.OrnamentFaceItemID)
    l_attribData:SetOrnament(equipData.OrnamentMouthItemID)
    l_attribData:SetOrnament(equipData.OrnamentBackItemID)
    l_attribData:SetOrnament(equipData.OrnamentTailItemID)
    l_attribData:SetOrnament(equipData.OrnamentHeadFromBagItemID, true)
    l_attribData:SetOrnament(equipData.OrnamentFaceFromBagItemID, true)
    l_attribData:SetOrnament(equipData.OrnamentMouthFromBagItemID, true)
    l_attribData:SetOrnament(equipData.OrnamentBackFromBagItemID, true)
    l_attribData:SetOrnament(equipData.OrnamentTailFromBagItemID, true)
    l_attribData:SetWeapon(equipData.WeaponItemIDFromBag, true)
    l_attribData:SetWeaponEx(equipData.WeaponExItemIDFromBag, true)

    return l_attribData
end

--获取临时创建的 MEquipData 对象
function dataGetEquipData(returnData)
    if returnData.equipData ~= nil then
        return returnData.equipData
    end

    returnData.equipData = GetEquipData(returnData.data)
    return returnData.equipData
end

--获取临时创建的 MAttrRole 对象
function dataGetAttribData(returnData)
    if returnData.attribData ~= nil then
        return returnData.attribData
    end

    local l_data = returnData.data
    local l_equipData = returnData:GetEquipData()
    returnData.attribData = GetAttribData(l_data, l_equipData)
    return returnData.attribData
end

--获取战斗站姿动画路径
function getFightIdleAnimPath(returnData)
    if returnData.fightIdleAnimPath ~= nil then
        return returnData.fightIdleAnimPath
    end

    local l_equipData = returnData:GetEquipData()

    local l_equip = nil
    if l_equipData.WeaponItemIDFromBag > 0 then
        l_equip = TableUtil.GetEquipTable().GetRowById(l_equipData.WeaponItemIDFromBag)
    end
    local l_pro = TableUtil.GetProfessionTable().GetRowById(l_equipData.ProfessionID)
    local l_PresentId = 0
    if l_equipData.IsMale then
        l_PresentId = l_pro.PresentM
    else
        l_PresentId = l_pro.PresentF
    end
    local l_PresentTable = TableUtil.GetPresentTable().GetRowById(l_PresentId)
    if not l_PresentTable then
        logError("l_PresentTable is nil")
        return
    end
    local l_weaponId = 0
    if l_equip then
        l_weaponId = l_equip.WeaponId
    end
    local l_idleAnimPath = nil
    for i = 0, l_PresentTable.IdleFAnim.Length - 1 do
        if tonumber(l_PresentTable.IdleFAnim:get_Item(i, 0)) == l_weaponId then
            l_idleAnimPath = l_PresentTable.IdleFAnim:get_Item(i, 1)
            break
        end
    end
    --没有动画用默认的
    if not l_idleAnimPath then
        l_idleAnimPath = l_PresentTable.IdleFAnim:get_Item(0, 1)
    end

    returnData.fightIdleAnimPath = MAnimationMgr:GetClipPath(l_idleAnimPath)

    return returnData.fightIdleAnimPath
end

function GetDefaultEquip(proId, sex)

    local l_proRow = TableUtil.GetProfessionTable().GetRowById(proId)
    if not l_proRow then
        return
    end

    local l_key = 'DefaultEquip' .. ((sex == 0) and "M" or "F")
    local l_equipId = l_proRow[l_key]
    local l_equipRow = TableUtil.GetDefaultEquipTable().GetRowById(l_equipId)
    if not l_equipRow then
        return
    end

    local l_equipData = MoonClient.MEquipData.New()

    l_equipData.IsMale = sex == 0
    l_equipData.ProfessionID = proId
    l_equipData.HairID = 0
    l_equipData.HairStyleID = l_equipRow.BarberStyleID
    l_equipData.EyeID = l_equipRow.Eye
    l_equipData.EyeColorID = l_equipRow.EyeColor
    l_equipData.FashionItemID = 0
    l_equipData.HeadID = 0
    --装备(背包)中装备的饰品
    l_equipData.OrnamentHeadFromBagItemID = 0
    l_equipData.OrnamentFaceFromBagItemID = 0
    l_equipData.OrnamentMouthFromBagItemID = 0
    l_equipData.FashionFromBagItemID = 0

    --装扮(时装)中的装备的饰品
    --饰品还是背包中的饰品
    --外形覆盖装备(背包)中装备的饰品
    --即相当于饰品装备幻化 属性取背包中装备的 外形取装扮中装备的
    l_equipData.OrnamentHeadItemID = 0
    l_equipData.OrnamentFaceItemID = 0
    l_equipData.OrnamentMouthItemID = 0

    return l_equipData
end
return ModuleMgr.PlayerInfoMgr