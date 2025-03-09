---
--- Created by chauncyhu.
--- DateTime: 2018/6/21 16:22
---

module("ModuleMgr.HeadMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

function SetHead(idList)
    local l_msgId = Network.Define.Rpc.QueryRoleBriefInfo
    ---@type QueryRoleBriefInfoArg
    local l_sendInfo = GetProtoBufSendTable("QueryRoleBriefInfoArg")
    for i = 1,#idList do
        local oneItem = l_sendInfo.role_ids:add()
        oneItem.value = idList[i]
    end
    l_sendInfo.query_type = 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo, idList)
end

function OnHeadInfoRsp(msg, sendArgs, customData)
    local l_info = msg.base_infos
    if #l_info<1 then
        return
    end

    logGreen("[HeadMgr]OnHeadInfoRsp get head info count:"..tostring(#l_info))
    local headInfos = {}
    for i = 1,#l_info do
        local l_tempInfo = l_info[i]
        local l_attr,l_player = GetAttrByMemberDetailInfo(l_tempInfo)
        local str = tostring(l_player.uid)
        headInfos[str] = {attr = l_attr, player = l_player}
        logGreen("[HeadMgr]OnHeadInfoRsp get head info ID:"..str)
    end

    EventDispatcher:Dispatch(EventConst.Names.HEAD_SET_HEDA, headInfos, customData)
end

function GetAttrByMemberDetailInfo(roleInfo)
    local l_player = {}
    l_player.uid = roleInfo.role_uid
    l_player.name = Common.Utils.PlayerName(roleInfo.name) or ""
    l_player.sex = roleInfo.sex or 0
    l_player.level = roleInfo.base_level or 1
    l_player.joblevel = roleInfo.job_level or 1
    l_player.role_type = roleInfo.type or 1000
    l_player.hair = roleInfo.outlook.hair_id or 0
    l_player.fashion = roleInfo.outlook.wear_fashion or 0
    l_player.eye = roleInfo.outlook.eye.eye_id
    l_player.eyecolor = roleInfo.outlook.eye.eye_style_id
    l_player.headId = roleInfo.outlook.wear_head_portrait_id
    l_player.equip_ids = roleInfo.equip_ids
    l_player.wear_ornament = roleInfo.outlook.wear_ornament
    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitRoleAttr(l_tempId, l_player.name, l_player.role_type, l_player.sex == 0, nil)
    l_attr:SetHair(l_player.hair)
    l_attr:SetHead(l_player.headId)
    l_attr:SetEye(l_player.eye)
    l_attr:SetEyeColor(l_player.eyecolor)
    l_attr:SetFashion(l_player.fashion)
    if #l_player.wear_ornament > 0 then
        for i = 1, #l_player.wear_ornament do
            l_attr:SetOrnament(l_player.wear_ornament[i].value)
        end
    end
    if #l_player.equip_ids > 0 then
        for i = 1, #l_player.equip_ids do
            if i - 1 == Data.BagModel.WeapType.Fashion and l_player.fashion == 0 then ---未应用收纳的时装时读取装备的时装
                l_attr:SetFashion(l_player.equip_ids[i].value)
            else
                l_attr:SetOrnament(l_player.equip_ids[i].value, true)
            end
        end
    end
    return l_attr, l_player

end
