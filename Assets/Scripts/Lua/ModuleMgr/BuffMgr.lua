---
--- Created by husheng.
--- DateTime: 2018/3/15 16:40
---
---@module ModuleMgr.BuffMgr
module("ModuleMgr.BuffMgr", package.seeall)

--------------------事件相关--------------------
EventDispatcher = EventDispatcher.new()
BUFF_UPDATE_EVENT = "BUFF_UPDATE_EVENT"    ---buff update
TARGET_BUFF_TIPS_OPEN = "TARGET_BUFF_TIPS_OPEN"
TEAM_BUFF_INFO_UPDATE = "TEAM_BUFF_INFO_UPDATE"
------------------------------------------------

g_playerAddBuffInfo = {}        ---player buff info
g_playerReduceBuffInfo = {}     ---player buff info

g_targetAddBuffInfo = {}        ---target buff info
g_targetReduceBuffInfo = {}     ---target buff info
g_tragetAffixBuffIdTb = {}      --词缀BuffTb

SpBuffInfo = {}

--boss buff信息
BossBuffInfo = {}

--[[
异常状态buff类型
--]]
local l_spBuff = {
    [ROGameLibs.BuffStateType.kBuffStateType_Stun:ToInt()] = Common.Utils.Lang("BUFF_DES_XUANYUN"),
    [ROGameLibs.BuffStateType.kBuffStateType_Frozen:ToInt()] = Common.Utils.Lang("BUFF_DES_BINGDONG"),
    [ROGameLibs.BuffStateType.kBuffStateType_Petrochemical:ToInt()] = Common.Utils.Lang("BUFF_DES_SHIHUA"),
    [ROGameLibs.BuffStateType.kBuffStateType_Paralysis:ToInt()] = Common.Utils.Lang("BUFF_DES_MABI"),
    [ROGameLibs.BuffStateType.kBuffStateType_Fear:ToInt()] = Common.Utils.Lang("BUFF_DES_KONGJU"),
    [ROGameLibs.BuffStateType.kBuffStateType_Immobilize:ToInt()] = Common.Utils.Lang("BUFF_DES_STOP"),
    [ROGameLibs.BuffStateType.kBuffStateType_Sleep:ToInt()] = Common.Utils.Lang("BUFF_DES_SLEPP"),
}

ReduceStatrEffect = "Effects/Prefabs/Creature/Ui/Fx_Ui_DeBuf_Start_Red"
DebuffEndEffect = "Effects/Prefabs/Creature/Ui/Fx_Ui_DeBuf_End_Red"
AddStatrEffect = "Effects/Prefabs/Creature/Ui/Fx_Ui_DeBuf_Start_Blue"
AddEndEffect = "Effects/Prefabs/Creature/Ui/Fx_Ui_DeBuf_End_Blue"

------
--id
--appendCount
--leftTime
--updateTime
--table

function UpdateBuffInfo(uid)
    local l_e = MEntityMgr:GetEntity(uid, true)
    local l_add = {}
    local l_reduce = {}
    local l_sp = {}
    local l_bossBuffInfo = {}
    local l_buff
    if l_e then
        l_buff = l_e.Buff
        if l_buff then
            local l_buffInfoDict = l_buff:GetBuffInfoByLua()
            local l_itor = l_buffInfoDict:GetEnumerator()
            while l_itor:MoveNext() do
                local l_k = l_itor.Current.Key
                local l_v = l_itor.Current.Value
                local l_info = {}
                l_info.uid = l_k
                l_info.appendCount = l_v._appendCount
                l_info.leftTime = l_v._leftTime
                l_info.updateTime = l_v._updateTime
                l_info.remainTime = l_v._remainTime
                l_info.totalTime = l_v._totalTime
                l_info.couldCancel = l_v._couldCancel
                l_info.buffStateType = l_v._buffStateType
                l_info.buffAttrDecision = l_v._buffAttrDecision
                l_info.tableInfo = TableUtil.GetBuffTable().GetRowById(l_v._buffId)
                if l_info.tableInfo.IsVisible then
                    if not l_info.tableInfo.IsDebuff then
                        table.insert(l_add, l_info)
                    else
                        table.insert(l_reduce, l_info)
                    end
                end
                if l_spBuff[l_info.buffStateType:ToInt()] then
                    local l_index = #l_sp + 1
                    l_sp[l_index] = {}
                    l_sp[l_index].buff = l_info
                    l_sp[l_index].name = l_spBuff[l_info.buffStateType:ToInt()]
                end
                --boss buff信息
                if l_info.tableInfo.Type == 300 then
                    table.insert(l_bossBuffInfo, {buff = l_info, name = l_info.tableInfo.InGameName})
                end
            end

            -- 特殊处理打宝糖buff
            local l_autoFightItemMgr = MgrMgr:GetMgr("AutoFightItemMgr")
            local l_daBaoTangBuffId = l_autoFightItemMgr.GetDaBaoTangBuffId()
            if l_daBaoTangBuffId ~= 0 and tostring(uid) == tostring(MPlayerInfo.UID) then
                local l_buffRow = TableUtil.GetBuffTable().GetRowById(l_daBaoTangBuffId)
                table.insert(l_add, 1,{
                    uid = -1,
                    appendCount = 1,
                    remainTime = l_autoFightItemMgr.GetDaBaoTangBuffLeftTime(),
                    totalTime = 0,
                    isStop = l_autoFightItemMgr.IsDaBaoTangBuffStop(),
                    tableInfo = l_buffRow,
                })
            end
        end
    end
    if tostring(uid) == tostring(MPlayerInfo.UID) then
        g_playerAddBuffInfo = {}
        g_playerAddBuffInfo = l_add
        g_playerReduceBuffInfo = {}
        g_playerReduceBuffInfo = l_reduce
        SpBuffInfo = l_sp
        BossBuffInfo = l_bossBuffInfo
        if #SpBuffInfo > 0 then
            table.sort(SpBuffInfo, function(x, y)
                return x.buff.remainTime < y.buff.remainTime
            end)
        end
        ShowMainBuff()
    else
        g_targetAddBuffInfo = {}
        g_targetAddBuffInfo = l_add
        g_targetReduceBuffInfo = {}
        g_targetReduceBuffInfo = l_reduce
        g_tragetAffixBuffIdTb = GetEntityAffixBuffTb(l_e)
    end

    EventDispatcher:Dispatch(BUFF_UPDATE_EVENT, uid)
end

function GetEntityAffixBuffTb(cEntity)
    local affixBuffTb = {}

    if cEntity == nil then
        return affixBuffTb
    end

    if cEntity.IsRole then
        return affixBuffTb
    end

    if cEntity.IsMonster then
        local affixList = cEntity.AttrMonster.MonsterAffixIds
        if affixList.Count < 0 then
            return affixBuffTb
        end

        for z = 0, affixList.Count - 1 do
            local id = affixList:get_Item(z)
            local tbData = TableUtil.GetAffixTable().GetRowById(id)
            if tbData then
                for i = #g_targetAddBuffInfo, 1, -1 do
                    if g_targetAddBuffInfo[i].tableInfo.Id == tbData.AffixEffect then
                        --修改数据文件的图集和图片信息
                        g_targetAddBuffInfo[i].tableInfo.Icon = tbData.AffixIcon
                        g_targetAddBuffInfo[i].tableInfo.InGameName = tbData.Name
                        g_targetAddBuffInfo[i].tableInfo.Description = tbData.Description
                        table.insert(affixBuffTb, g_targetAddBuffInfo[i])
                        table.remove(g_targetAddBuffInfo, i)
                    end
                end
                for y = #g_targetReduceBuffInfo, 1, -1 do
                    if g_targetReduceBuffInfo[y].tableInfo.Id == tbData.AffixEffect then
                        --修改数据文件的图集和图片信息
                        g_targetReduceBuffInfo[y].tableInfo.Icon = tbData.AffixIcon
                        g_targetReduceBuffInfo[y].tableInfo.InGameName = tbData.Name
                        g_targetReduceBuffInfo[y].tableInfo.Description = tbData.Description
                        table.insert(affixBuffTb, g_targetReduceBuffInfo[y])
                        table.remove(g_targetReduceBuffInfo, y)
                    end
                end
            end
        end
    end
    return affixBuffTb
end

---异常状态表现;
function ShowMainBuff()
    local l_BuffOpenData = 
    {
        openType = EMainBuffOpenType.UpdateBuff
    }
    UIMgr:ActiveUI(UI.CtrlNames.MainBuff,l_BuffOpenData)
end

TeamBuffInfo = {}


MgrMgr:Regist("BuffMgr")

local l_timer = {}

function OnUpdate()
    if l_timer.sec == nil or l_timer.sec < 0 then
        l_timer.sec = 0.5
        l_timer.start = Time.realtimeSinceStartup
        if table.ro_size(TeamBuffInfo) > 0 then
            for k, v in pairs(TeamBuffInfo) do
                local l_entityID = k
                local l_buff = v
                if #l_buff > 0 then
                    for i=#l_buff,1,-1 do
                        l_buff[i].remain = l_buff[i].remain - (Time.realtimeSinceStartup - l_buff[i].start)
                        l_buff[i].start = Time.realtimeSinceStartup
                        if l_buff[i].remain < 0 then
                            l_buff[i].remain = 0
                            table.remove(l_buff, i)
                        end
                    end
                end
            end
        end
    end
    l_timer.sec = l_timer.sec - (Time.realtimeSinceStartup - l_timer.start)
    l_timer.start = Time.realtimeSinceStartup
end

function OnTeamSyncBuff(msg)
    ---@type BuffSyncToMsData
    local l_info = ParseProtoBufToTable("BuffSyncToMsData", msg)
    local l_addInfo = l_info.add_info
    local l_removeEntityID = l_info.remove_info.entity_id
    local l_removeInfo = l_info.remove_info.buff_uuid_list
    local l_roIDList = {}
    if #l_addInfo > 0 then
        for i = 1, #l_addInfo do
            local l_target = l_addInfo[i]
            local l_entityID = l_target.entity_id
            local l_buffID = l_target.buff_id
            local l_buffUID = l_target.buff_uuid
            local l_repUID = l_buffUID
            local l_remain = l_target.left_time
            local l_alltime = l_target.total_time

            local l_tableInfo = TableUtil.GetBuffTable().GetRowById(l_buffID)
            local l_type = l_tableInfo.BuffEffect
            if l_tableInfo.IsVisible and l_spBuff[l_type] then
                if not table.ro_contains(l_roIDList, l_entityID) then
                    table.insert(l_roIDList, l_entityID)
                end
                if not TeamBuffInfo[l_entityID] then
                    TeamBuffInfo[l_entityID] = {}
                end
                local l_replce = false
                if l_repUID then
                    if #TeamBuffInfo[l_entityID] > 0 then
                        for ii = 1, #TeamBuffInfo[l_entityID] do
                            local l_targetInfo = TeamBuffInfo[l_entityID][ii]
                            if l_targetInfo.buffUID == l_repUID and l_targetInfo.buffID == l_buffID then
                                TeamBuffInfo[l_entityID][ii].buffUID = l_buffUID
                                TeamBuffInfo[l_entityID][ii].remain = l_remain
                                TeamBuffInfo[l_entityID][ii].alltime = l_alltime
                                l_replce = true
                                break
                            end
                        end
                    end
                end
                if not l_replce then
                    local l_index = #TeamBuffInfo[l_entityID] + 1
                    TeamBuffInfo[l_entityID][l_index] = {}
                    TeamBuffInfo[l_entityID][l_index].buffID = l_buffID
                    TeamBuffInfo[l_entityID][l_index].buffUID = l_buffUID
                    TeamBuffInfo[l_entityID][l_index].remain = l_remain
                    TeamBuffInfo[l_entityID][l_index].alltime = l_alltime
                    TeamBuffInfo[l_entityID][l_index].tableInfo = l_tableInfo
                    TeamBuffInfo[l_entityID][l_index].start = Time.realtimeSinceStartup
                end
                table.sort(TeamBuffInfo[l_entityID], function(x, y)
                    return x.remain < y.remain
                end)
            end
        end
    end
    if #l_removeInfo > 0 then
        for i = 1, #l_removeInfo do
            local l_entityID = l_removeEntityID
            local l_buffUID = l_removeInfo[i].value
            if not table.ro_contains(l_roIDList, l_entityID) then
                table.insert(l_roIDList, l_entityID)
            end
            if TeamBuffInfo[l_entityID] then
                if #TeamBuffInfo[l_entityID] > 0 then
                    local l_targetIndex = nil
                    for ii = 1, #TeamBuffInfo[l_entityID] do
                        local l_targetInfo = TeamBuffInfo[l_entityID][ii]
                        if l_targetInfo.buffUID == l_buffUID then
                            l_targetIndex = ii
                            break
                        end
                    end
                    if l_targetIndex then
                        table.remove(TeamBuffInfo[l_entityID], l_targetIndex)
                    end
                end
                if #TeamBuffInfo[l_entityID] > 0 then
                    table.sort(TeamBuffInfo[l_entityID], function(x, y)
                        return x.remain < y.remain
                    end)
                end
            end
        end
    end
    if table.ro_size(l_roIDList) > 0 then
        EventDispatcher:Dispatch(TEAM_BUFF_INFO_UPDATE, l_roIDList)
    end
end

function GetBuffType(buffData)
    local l_type = buffData.BuffEffect
    return ROGameLibs.BuffStateType.IntToEnum(l_type)
end


function GetBuffTimeDes(sec)
    local l_d = 0
    local l_h = 0
    local l_m = 0
    local l_s = 0
    l_d = math.floor(sec/(60*60*24))
    if l_d>0 then
        l_h = math.floor((sec - l_d*60*60*24)/(60*60))
        return tostring(l_d).."d"..tostring(l_h).."h"
    else
        l_h = math.floor(sec/(60*60))
        if l_h>0 then
            l_m = math.floor((sec - l_h*60*60)/60)
            return tostring(l_h).."h"..tostring(l_m).."m"
        else
            l_m = math.floor(sec/60)
            if l_m>0 then
                l_s = math.floor(sec - l_m*60)
                return tostring(l_m).."m"..tostring(l_s).."s"
            end
        end
    end
    return tostring(sec).."s"
end

return ModuleMgr.BuffMgr

