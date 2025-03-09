---@module ModuleMgr.RoleInfoMgr
module("ModuleMgr.RoleInfoMgr", package.seeall)

------------事件相关-----------
EventDispatcher = EventDispatcher.new()
--服务器等级变更
ON_SERVER_LEVEL_UPDATE = "ON_SERVER_LEVEL_UPDATE"
--设置保存按钮状态
ROLE_INFO_SAVE_STATE = "ROLE_INFO_SAVE_STATE"
--刷新角色面板
ROLE_INFO_REFRESH = "ROLE_INFO_REFRESH"
--切换到细节页签
CHANGE_TO_DETAIL = "CHANGE_TO_DETAIL"
--重置属性点
RESET_ROLE_ATTRS = "RESET_ROLE_ATTRS"
--变身事件
ON_TRANS_FIGURE = "ON_TRANS_FIGURE"
------------事件相关-----------

--缓存一个RoleInfoData的引用
local l_roleInfoData = DataMgr:GetData("RoleInfoData")
l_RecommendAttrId = 0 --流派Id
--属性总页数
l_pageCount = 0
--当前属性页
l_curPage = nil
--当前属性页的数据
l_qualityPointPageInfo = nil

function OnInit()

end

function OnAfterSelectRole()
    GetServerLevelBonusInfo()
end

------------------协议对接----------------------
--升级自动加点
function AutoAddPoint()
    local profession = tonumber(MPlayerInfo.ProID)
    local genreTable = GetGenreIdByProfession(profession)
    if MEntityMgr.PlayerEntity.IsTransfigured then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_ATTR_POINT"))
        return
    end
    --根据ID生成推荐
    for i = 1, table.maxn(genreTable) do
        AutoCalulateCom(genreTable[1])
        break
    end
    local attrAddList = {}
    local attrList = BasicAttrList
    local hasAddAttr = false
    for i = 1, table.maxn(attrList) do
        local plusAttr = PlayerAttr[attrList[i].base].plusAttr
        if plusAttr >= 0.01 then
            table.insert(attrAddList, { attr_type = attrList[i].base, attr_value = plusAttr })
            if plusAttr > 0 then
                hasAddAttr = true
            end
        end
    end
    --版本要求 注释掉 自动加点 需要二次确认
    if hasAddAttr then
        --RequestAttrAdd(attrAddList)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_NOT_PLUS_ATTR"))
    end
    return hasAddAttr
end

--自动计算当前推荐点数，会自动清空玩家加点内容
function AutoCalulateCom(genreId)
    if not genreId then
        local profession = tonumber(MPlayerInfo.ProID)
        local genreTable = GetGenreIdByProfession(profession)
        genreId = genreTable[1] or 100001
    end
    ResetPlusAttr()
    RefreshData()
    local level = MPlayerInfo.Lv
    local recomAttr = GetComByLevelAndGenre(level, genreId)
    l_RecommendAttrId = genreId
    if recomAttr then
        local totalPoint = PlayerAttr.totalQualityPoint
        local recomPoint = 0
        local priority = {}
        --初始化优先级
        for i = 1, table.maxn(BasicAttrList) do
            recomPoint = recomPoint + recomAttr[BasicAttrList[i].base]
        end
        recomPoint = math.max(recomPoint, 1)
        for i = 1, table.maxn(BasicAttrList) do
            priority[BasicAttrList[i].base] = recomAttr[BasicAttrList[i].base] / recomPoint
        end
        while totalPoint > 0 do
            local addId = -1
            local maxPriority = -1
            local costPoint = -1
            for i = 1, table.maxn(BasicAttrList) do
                local nowPoint = PlayerAttr[BasicAttrList[i].base].baseAttr + PlayerAttr[BasicAttrList[i].base].plusAttr
                local maxAttrPoint = GetAttrLimit(BasicAttrList[i].base)
                local cost = GetNextNeedPointByNum(nowPoint + 1)
                local nowPriority = priority[BasicAttrList[i].base] / cost
                local recomAttrNum = recomAttr[BasicAttrList[i].base]
                if cost <= totalPoint and nowPriority > maxPriority and (nowPoint + 1) <= maxAttrPoint and nowPoint < recomAttrNum then
                    addId = BasicAttrList[i].base
                    maxPriority = nowPriority
                    costPoint = cost
                end
            end
            if addId ~= -1 then
                totalPoint = totalPoint - costPoint
                PlayerAttr[addId].plusAttr = PlayerAttr[addId].plusAttr + 1
            else
                totalPoint = 0
            end
        end
        RefreshView()
    end
end

--重置加点信息 并且刷新
function ResetPlusAttrAndRefresh()
    ResetPlusAttr()
    RefreshData()
    RefreshView()
end

--recommendId 作用于服务器打点 目的是判断当前加点到底是属于 手动还是自动 自动则传推荐Id 默认为0
function RequestAttrAdd(attrList, pageId)
    local l_msgId = Network.Define.Rpc.AttrAdd
    ---@type AttrAddArg
    local l_sendInfo = GetProtoBufSendTable("AttrAddArg")
    l_sendInfo.page_id = pageId or l_curPage
    for i = 1, table.maxn(attrList) do
        local attr = l_sendInfo.attr_list:add()
        attr.attr_type = attrList[i].attr_type
        attr.attr_value = attrList[i].attr_value
        attr.attr_operatetype = (l_RecommendAttrId == 0 or nil)
                and QualityPointOperateType.QUALITY_POINT_FREE_ASSIGN or QualityPointOperateType.QUALITY_POINT_RECOMMAND_ASSIGN
        attr.attr_recommend_id = l_RecommendAttrId or 0
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--收到服务器的加点反馈
function OnAttrAdd(msg)
    ---@type AttrAddRes
    local l_info = ParseProtoBufToTable("AttrAddRes", msg)
    CloseConfirmView()
end

function OnAttrChange(msg)
    ---@type AttrUpdateInfo
    local l_info = ParseProtoBufToTable("AttrUpdateInfo", msg)
    local msgParam = {}
    if l_info.entity_id == MPlayerInfo.UID then
        local baseAttrHasChanged = false
        --如果属性点变了，才会Reset属性
        for i = 1, table.maxn(l_info.attr_list) do
            msgParam[l_info.attr_list[i].attr_type] = l_info.attr_list[i].cur_value
            table.insert(msgParam, singleData)
            if l_info.attr_list[i].incr_value and l_info.attr_list[i].incr_value ~= 0 then
                baseAttrHasChanged = true
            end
        end
        --属性变化 界面刷新 source_type == 1 需要显示属性变化
        if baseAttrHasChanged and l_info.source_type == 1 then
            ResetPlusAttr()
            RefreshDetilState()
            RefreshView()
        end
    end

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnPlayerAttrUpdate, msgParam)
    DealWithRedSign()
end

--获取玩家的基础属性的属性点
function GetRoleBasicAttr(attrId)
    local baseAttr = PlayerAttr[attrId].baseAttr
    local nowValueTb = l_qualityPointPageInfo and l_qualityPointPageInfo[l_curPage] or nil
    local attrValue = nowValueTb and nowValueTb.point_list[attrId] or baseAttr
    return attrValue
end

function RequestAttrClear()
    local l_msgId = Network.Define.Rpc.AttrClear
    ---@type AttrClearArg
    local l_sendInfo = GetProtoBufSendTable("AttrClearArg")
    l_sendInfo.page_id = pageId or l_curPage
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnAttrClear(msg)
    ---@type AttrClearRes
    local l_info = ParseProtoBufToTable("AttrClearRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("REST_SUCCESS"))
    end
end

-- 收到服务器的推动属性发生变化 
function OnShowRoleAttrChange(attrList, isShow)
    local cAttrShowList = {}
    for i = 1, table.maxn(l_roleInfoData.SecondLevelList) do
        local delta = 0
        local l_base  = l_roleInfoData.SecondLevelList[i].base
        local l_equip = l_roleInfoData.SecondLevelList[i].equip

        if not l_roleInfoData.PlayerAttr[l_base] then
            l_roleInfoData.PlayerAttr[l_base] = {}
        end
        l_roleInfoData.PlayerAttr[l_base].baseAttr = MEntityMgr:GetMyPlayerAttr(l_base)
        l_roleInfoData.PlayerAttr[l_base].equipAttr = MEntityMgr:GetMyPlayerAttr(l_equip)
        ---下面这个特殊判定的意思是如果是移动速度相关的显示 不显示最终值 只显示移动速度增加的百分比  策划要求
        if l_base == AttrType.ATTR_BASIC_MOVE_SPD_FINAL then
            l_base = AttrType.ATTR_PERCENT_MOVE_SPD
        end
        if attrList:ContainsKey(l_base) then
            delta = delta + attrList[l_base]
        end
        if attrList:ContainsKey(l_equip) then
            delta = delta + attrList[l_equip]
        end
        if delta < -100 then
            if l_base == ATTR_PERCENT_CT_FIXED
                    or l_base == ATTR_PERCENT_CT_FIXED_FINAL
                    or l_base == ATTR_PERCENT_CT_CHANGE
                    or l_base == ATTR_PERCENT_CT_CHANGE_FINAL then
                delta = tostring(GetAttrNum(delta / 100, 0)) .. "%"
                table.insert(cAttrShowList, "<color=#FFFFFFFF>" .. l_roleInfoData.SecondLevelList[i].name .. "</color>" .. "<color=#69FFB7FF> " .. delta .. "</color>")
            end
        elseif delta > 0 then
            if l_roleInfoData.SecondLevelList[i].isPercent then
                delta = tostring(GetAttrNum(delta / 100, 1)) .. "%"
            end
            table.insert(cAttrShowList, "<color=#FFFFFFFF>" .. l_roleInfoData.SecondLevelList[i].name .. "</color>" .. "<color=#69FFB7FF>" .. " + " .. delta .. "</color>")
        end
    end
    if table.maxn(cAttrShowList) > 0 then
        if isShow then
            MgrMgr:GetMgr("TipsMgr").ShowAttr2ListTips(cAttrShowList)
        end
    end
    RefreshView()
end

--刷新属性
function RefreshData()
    --先用C#中的属性去刷新lua中的属性
    local totalQualityPoint = GetTotalQualityPoint()
    local nowCostPoint = 0
    for i = 1, table.maxn(BasicAttrList) do
        if not PlayerAttr[BasicAttrList[i].base] then
            PlayerAttr[BasicAttrList[i].base] = {}
            PlayerAttr[BasicAttrList[i].base].plusAttr = 0
        end
        local baseAttr = MEntityMgr:GetMyPlayerAttr(BasicAttrList[i].base)
        local equipAttr = MEntityMgr:GetMyPlayerAttr(BasicAttrList[i].equip)
        local plusAttr = PlayerAttr[BasicAttrList[i].base].plusAttr
        nowCostPoint = nowCostPoint + GetNeedPointByNum(baseAttr + plusAttr)

        PlayerAttr[BasicAttrList[i].base].baseAttr = baseAttr
        PlayerAttr[BasicAttrList[i].base].equipAttr = equipAttr
        PlayerAttr[BasicAttrList[i].base].nextCost = GetNextNeedPointByNum(baseAttr + plusAttr + 1)
    end
    --记录加点之前的属性
    l_roleInfoData.CalulatePreSecondAttr()
    --模拟增加属性
    l_roleInfoData.AddPlusAttrToPlayer()
    --拿出算好之后的属性
    l_roleInfoData.CalulateAfterSecondAttr()

    totalQualityPoint = totalQualityPoint - nowCostPoint
    PlayerAttr.totalQualityPoint = totalQualityPoint
end

--断线重连
function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    RoleBasicAttrListSet(l_roleAllInfo.quality_point)
end

--角色登陆成功
function OnSelectRoleNtf(roleData)
    ResetMultiData()
    RoleBasicAttrListSet(roleData.quality_point)
end

--服务器同步属性点变化
function OnQualityPointUpdateNotify(msg)
    ---@type QualityPointRecord
    local l_info = ParseProtoBufToTable("QualityPointRecord", msg)
    RoleBasicAttrListSet(l_info)
end

--ToDo 挪到Data里面去
function ResetMultiData()
    l_RecommendAttrId = 0
    l_pageCount = 0
    l_curPage = nil
    l_qualityPointPageInfo = nil 
end

function RoleBasicAttrListSet(qualityData)
    l_pageCount = qualityData.page_count
    if l_pageCount == nil then
        logError("服务器传的pageCount是空的")
        l_pageCount=0
    end
    l_curPage = qualityData.cur_page == 0 and l_curPage or qualityData.cur_page
    if l_curPage == 0 or l_curPage == nil then
        l_curPage = 1
    end --数据保护
    l_qualityPointPageInfo = l_qualityPointPageInfo or {}
    local data = qualityData.page_list
    --服务器数据
    for i = 1, #data do
        local id = data[i].id
        if id ~= 0 then
            l_qualityPointPageInfo[id] = {}
            l_qualityPointPageInfo[id].id = data[i].id
            l_qualityPointPageInfo[id].name = data[i].name
            l_qualityPointPageInfo[id].point_list = {}
            for z = 1, #data[i].point_list do
                local cType = data[i].point_list[z].type
                local cValue = data[i].point_list[z].level
                l_qualityPointPageInfo[id].point_list[cType] = cValue
            end
        end
    end

    local attrSystemId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.AttrMultiTalent
    for i, v in ipairs(MgrMgr:GetMgr("MultiTalentMgr").GetMultiTableDataBySystemId(attrSystemId)) do
        if l_qualityPointPageInfo[v.ProjectId] ~= nil and l_qualityPointPageInfo[v.ProjectId].id ~= nil then
            if l_qualityPointPageInfo[v.ProjectId].name == "" or l_qualityPointPageInfo[v.ProjectId].name == nil then
                l_qualityPointPageInfo[v.ProjectId].name = Lang(v.Name)
            end
        else
            l_qualityPointPageInfo[v.ProjectId] = {}
            l_qualityPointPageInfo[v.ProjectId].id = v.ProjectId
            l_qualityPointPageInfo[v.ProjectId].name = Lang(v.Name)
            l_qualityPointPageInfo[v.ProjectId].point_list = {}
        end
    end
end

--对这个数据结构做处理
function CalculateQualityPointPageInfo(QualityPointPageInfo)
    if QualityPointPageInfo == nil then
        return
    end
    local l_qualityPageData = {}
    local data = QualityPointPageInfo
    --服务器数据
    local id = data.id
    if id ~= 0 then
        l_qualityPageData[id] = {}
        l_qualityPageData[id].id = data.id
        l_qualityPageData[id].name = data.name
        l_qualityPageData[id].point_list = {}
        for z = 1, #data.point_list do
            local cType = data.point_list[z].type
            local cValue = data.point_list[z].level
            l_qualityPageData[id].point_list[cType] = cValue
        end
    end
    return l_qualityPageData, id
end

--计算剩余的属性点
function CalculateQualityPoint(isSelf, playerLevel, QualityPointPageInfo)
    if isSelf then
        local allPoint = GetTotalQualityPoint()
        return allPoint, allPoint - PlayerAttr.totalQualityPoint, PlayerAttr.totalQualityPoint
    end
    local totalQualityPoint = GetTotalQualityPoint(playerLevel)
    local data = QualityPointPageInfo
    local nowCostPoint = 0
    --服务器数据
    local id = data.id
    if id ~= 0 then
        for z = 1, #data.point_list do
            local cValue = data.point_list[z].level
            nowCostPoint = nowCostPoint + GetNeedPointByNum(cValue)
        end
    end
    return totalQualityPoint, nowCostPoint, totalQualityPoint - nowCostPoint
end

function GetRolePageInfo(pageId)
    for k, v in pairs(l_qualityPointPageInfo) do
        if k == pageId then
            return v
        end
    end
end

function OnReceiveSyncTime(msg)
    local l_info = ParseProtoBufToTable("SyncTimeRes", msg)
    SetServerLevel(l_info.serverlevel)
end

--请求服务器等级
function GetServerLevelBonusInfo()
    local l_msgId = Network.Define.Rpc.GetServerLevelBonusInfo
    ---@type GetServerLevelBonusInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetServerLevelBonusInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--服务器反馈请求服务器等级
function OnGetServerLevelBonusInfo(msg)
    ---@type GetServerLevelBonusInfoRes
    local l_info = ParseProtoBufToTable("GetServerLevelBonusInfoRes", msg)
    if l_info.errcode ~= 0 then
        --此处不应有报错
        logRed(Common.Functions.GetErrorCodeStr(l_info.errcode))
    else
        MPlayerInfo.ServerLevel = l_info.serverlevel
        SeverLevelData.serverDay = l_info.server_open_days
        SeverLevelData.serverlevel = l_info.serverlevel
        SeverLevelData.basebonus = l_info.basebonus
        SeverLevelData.jobbonus = l_info.jobbonus
        SeverLevelData.nextrefreshtime = l_info.nextrefreshtime
        SeverLevelData.hiddenbaselevel = l_info.hidden_base_level
        RefreshView()
    end
    EventDispatcher:Dispatch(ON_SERVER_LEVEL_UPDATE)
end

------------------协议对接----------------------

------------------对外接口----------------------

--获取当前等级所有的素质点
function GetTotalQualityPoint(playerLevel)
    local level = playerLevel or MPlayerInfo.Lv
    if MPlayerInfo.Lv == 0 then
        logError("[RoleInfoMgr][GetTotalQualityPoint] 获取玩家等级为0级 理论上不应该存在这种情况 可能是GM导致")
        return 0
    end
    return GetQualityPointByLevel(level)
end

--获取当前等级的的素质点
function GetQualityPointByLevel(level)
    if l_roleInfoData.AttrBaseLvTable[level] == nil then
        logError("[RoleInfoMgr][GetQualityPointByLevel]no qualitypoint config with level:" .. tostring(level))
        return 0
    end
    return l_roleInfoData.AttrBaseLvTable[level]
end

--获取玩家升级属性点需要的点数
function GetNeedPointByNum(num)
    return l_roleInfoData.AttrPointNeedTable[num] or 0
end

--获取玩家下一次升级属性点需要的点数
function GetNextNeedPointByNum(num)
    local ret = 0
    if l_roleInfoData.AttrPointNeedTable[num] then
        preCost = l_roleInfoData.AttrPointNeedTable[num - 1] or 0
        ret = l_roleInfoData.AttrPointNeedTable[num] - preCost
    end
    return ret
end

--获取玩家升级所需Exp
function GetLevelExp(level)
    if level == nil then
        return 0
    end
    local lvRow = TableUtil.GetBaseLvTable().GetRowByBaseLv(level)
    if lvRow then
        return lvRow.Exp
    else
        return 0
    end
end

--获取玩家升级所需JobExp
function GetJobLvExp(cLevel)
    if cLevel == nil then
        return 0
    end
    local lvRow = TableUtil.GetJobLvTable().GetRowByJobLv(cLevel)
    if lvRow then
        return lvRow.Exp
    else
        return 0
    end
end

--重置临时操作的加点
function ResetPlusAttr()
    for i = 1, table.maxn(BasicAttrList) do
        if PlayerAttr[BasicAttrList[i].base] then
            PlayerAttr[BasicAttrList[i].base].plusAttr = 0
        end
    end
end

--判断玩有没有临时加点操作
function HasPlusPoint()
    local ret = false
    for i = 1, table.maxn(BasicAttrList) do
        if PlayerAttr[BasicAttrList[i].base] and PlayerAttr[BasicAttrList[i].base].plusAttr > 0 then
            ret = true
            break
        end
    end
    return ret
end

--玩家是否进行过属性加点
function HasBaseAttrAdded()
    local ret = false
    for i = 1, table.maxn(BasicAttrList) do
        if PlayerAttr[BasicAttrList[i].base] then
            if PlayerAttr[BasicAttrList[i].base].baseAttr > 0 then
                ret = true
                break
            end
        end
    end
    return ret
end

--获取当前的所有素质点可以加的属性值
function GetStatPointByAllPoint(curAllPoint)
    local needTable = TableUtil.GetAttrPointNeed().GetTable()
    local totalPoint = 0
    for i = 1, table.maxn(needTable) do
        totalPoint = totalPoint + needTable[i].Pointneed
        if totalPoint > curAllPoint then
            return (needTable[i].Statpoint - 1)
        end
    end
    return totalPoint
end

--判断特殊属性是否需要显示
function GetIsNeedShowSpecialAttr(attrTableData)
    if attrTableData == nil then
        return false
    end
    if attrTableData.TypeId ~= 4 then
        return true
    end
    local baseAttr = MEntityMgr:GetMyPlayerAttr(attrTableData.Id)
    --自身不等于0则显示
    if baseAttr ~= 0 then
        return true
    else
        if attrTableData.MatchId == 0 then
            return false
        end
        local l_matchTable = TableUtil.GetAttrInfoTable().GetRowById(attrTableData.MatchId)
        if not l_matchTable then
            return false
        end
        local baseMatchAttr = MEntityMgr:GetMyPlayerAttr(l_matchTable.Id)
        return baseMatchAttr ~= 0
    end
end

--自动加点六唯属性逻辑
function GetComByLevelAndGenre(level, genre)
    local key = level .. "|" .. genre
    local recomTable = TableUtil.GetAttraddRecomTable().GetRowByProfession(key)
    if recomTable then
        local recomInfo = {}
        recomInfo[ATTR_BASIC_STR] = recomTable.STR
        recomInfo[ATTR_BASIC_INT] = recomTable.INT
        recomInfo[ATTR_BASIC_VIT] = recomTable.VIT
        recomInfo[ATTR_BASIC_DEX] = recomTable.DEX
        recomInfo[ATTR_BASIC_AGI] = recomTable.AGI
        recomInfo[ATTR_BASIC_LUK] = recomTable.LUK
        return recomInfo
    else
        return nil
    end
end

--获取职业的推荐流派加点信息
function GetGenreIdByProfession(professionId)
    local proInfo = TableUtil.GetProfessionTable().GetRowById(professionId)
    local genreList = {}
    if proInfo then
        local genreIds = string.ro_split(proInfo.AttrRecommend, "|")
        for i = 1, table.maxn(genreIds) do
            table.insert(genreList, tonumber(genreIds[i]))
        end
    else
        table.insert(genreList, 100001)
    end
    return genreList
end

--获取玩家的元气限制
function GetVigourLimit()
    local l_base_level = MPlayerInfo.Lv
    if l_base_level <= 0 then
        return l_roleInfoData.GetOriginalvigourlimit()
    else
        return l_roleInfoData.GetOriginalvigourlimit() + (l_base_level - 1) * l_roleInfoData.GetVigourIncrease()
    end
end

--获取玩家的移动速度
function GetMyPlayerMoveSpeed()
    local professionId = MPlayerInfo.ProID
    return GetMoveSpeedByProfessionId(professionId)
end

--获取某个职业的移动速度
function GetMoveSpeedByProfessionId(professionId)
    local proInfo = TableUtil.GetProfessionTable().GetRowById(professionId)
    if proInfo then
        local presentId = proInfo.PresentM
        if not MPlayerInfo.IsMale then
            presentId = proInfo.PresentF
        end
        local presentInfo = TableUtil.GetPresentTable().GetRowById(presentId)
        return presentInfo.RunSpeed
    end
    return 1
end

--获取属性最大限制
function GetAttrLimit(attrId)
    local row = TableUtil.GetAttributeAttrLimit().GetRowByAttributeAttr(attrId)
    if not row then
        return 0
    end
    return row.AttributeLimit
end

--按照策划需求对显示的属性进行排序
function GetSortTable()
    if table.maxn(l_roleInfoData.BasicAttrList) < 6 then
        logerror("Server Data Error")
        return
    end
    local SortAttrTb = {}
    table.insert(SortAttrTb, l_roleInfoData.BasicAttrList[1])
    table.insert(SortAttrTb, l_roleInfoData.BasicAttrList[3])
    table.insert(SortAttrTb, l_roleInfoData.BasicAttrList[5])
    table.insert(SortAttrTb, l_roleInfoData.BasicAttrList[2])
    table.insert(SortAttrTb, l_roleInfoData.BasicAttrList[4])
    table.insert(SortAttrTb, l_roleInfoData.BasicAttrList[6])
    return SortAttrTb
end

--获取信息
function GetGenreDetailInfo(genreId)
    local info = {}
    local row = TableUtil.GetProfessionTextTable().GetRowByNAME(genreId)
    if row then
        info.name = row.NAME
        info.cname = row.SchoolName
        info.icon = row.ICON
        info.text1 = row.TEXT1
        info.text2 = row.TEXT2
        info.text3 = row.TEXT3
        info.star = row.DifficultyStar
        info.recommendPoint = row.RecommendPoint
        info.FeatureText = row.FeatureText
        info.recommendClass = row.RecommendClass
        info.atlas = row.RecommendClassIconAtlas
        info.sprite = row.RecommendClassIconSprite
        return info
    end
    logError("RecommendId is Nil  ProfessionTextTable @ChenNi" .. genreId)
    return nil
end

--返回玩家基础属性的具体数值
function GetAttrPointById(id)
    if l_roleInfoData.PlayerAttr[id] then
        return l_roleInfoData.PlayerAttr[id].baseAttr
    else
        logError("PlayerAttr is nil Id-->>" .. id)
    end
end

--获取推荐等级
function GetRecommendLevel()
    return MGlobalConfig:GetInt("RecommendLevel", 40)
end

--返回玩家属性数值
function GetAttrNum(value, isRate)
    if value == 0 then
        return 0
    end
    --需要保留两位小数
    if isRate > 0 then
        value = StringEx.Format("{0:F2}", value)
    else
        value = math.ceil(value)
    end
    return value
end

--暂时不能离开这个区域 请玩家去改名
function RoleNotChangeName()
    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.OK, true, nil, Common.Utils.Lang("ROLE_NOT_CHANGE_NAME_TIPS"), Common.Utils.Lang("TASK_NAV_TEXT"), "", function(...)
        local l_tmp = string.ro_split(MGlobalConfig:GetString("NonameSeekNpc"), "=")
        local l_npcId = tonumber(l_tmp[1])
        local l_sceneId = tonumber(l_tmp[2])
        MTransferMgr:GotoNpc(l_sceneId, l_npcId)
    end)
end

function GetAttrNameByAttrId(attrId)
    local ret = nil
    for i = 1, table.maxn(l_roleInfoData.SecondLevelList) do
        if l_roleInfoData.SecondLevelList[i].base == attrId or l_roleInfoData.SecondLevelList[i].equip == attrId then
            ret = l_roleInfoData.SecondLevelList[i].name
        end
    end
    return ret
end
------------------对外接口----------------------


------------------红点处理----------------------
function IsRoleInfoRedPoint()
    local totalQualityPoint = GetTotalQualityPoint()
    local attrList = l_roleInfoData.BasicAttrList
    local nowCostPoint = 0
    for i = 1, table.maxn(attrList) do
        if not PlayerAttr[attrList[i].base] then
            PlayerAttr[attrList[i].base] = {}
            PlayerAttr[attrList[i].base].plusAttr = 0
        end
        local baseAttr = MEntityMgr:GetMyPlayerAttr(attrList[i].base)
        local equipAttr = MEntityMgr:GetMyPlayerAttr(attrList[i].equip)
        local plusAttr = PlayerAttr[attrList[i].base].plusAttr

        PlayerAttr[attrList[i].base].baseAttr = baseAttr
        PlayerAttr[attrList[i].base].equipAttr = equipAttr
        PlayerAttr[attrList[i].base].nextCost = GetNextNeedPointByNum(baseAttr + plusAttr + 1)
        nowCostPoint = nowCostPoint + GetNeedPointByNum(baseAttr + plusAttr)
    end

    totalQualityPoint = totalQualityPoint - nowCostPoint
    PlayerAttr.totalQualityPoint = totalQualityPoint
    local maxCost = 0
    for z = 1, table.maxn(attrList) do
        if PlayerAttr[attrList[z].base] and PlayerAttr[attrList[z].base].nextCost > maxCost then
            maxCost = PlayerAttr[attrList[z].base].nextCost
        end
    end
    if PlayerAttr.totalQualityPoint >= maxCost then
        return true
    end
    return false
end

function DealWithRedSign()
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.StatusPoint)
end

function CheckRedSignMethod()
    if not MEntityMgr.PlayerEntity then
        return 0
    end
    --变身期间不显示红点
    if MEntityMgr.PlayerEntity.IsTransfigured then
        return 0
    end
    if IsRoleInfoRedPoint() then
        return 1
    end
    return 0
end
------------------红点处理----------------------

------------------刷新UI的逻辑------------------
function OnShowRoleInfo(type)

    local l_RoleOpenData = {
        openType = ERoleInfoOpenType.ShowBeginnerGuide,
    }
    UIMgr:ActiveUI(UI.CtrlNames.RoleAttr, l_RoleOpenData)

end

function CloseConfirmView()
    EventDispatcher:Dispatch(ROLE_INFO_SAVE_STATE, false)
end

function RefreshView()
    EventDispatcher:Dispatch(ROLE_INFO_REFRESH)
end

function RefreshDetilState()
    EventDispatcher:Dispatch(CHANGE_TO_DETAIL)
end

function ResetRoleAttr()
    EventDispatcher:Dispatch(RESET_ROLE_ATTRS)
end

function ShowBeginnerGuide()
    l_roleInfoData.IsNeedShowRoleInfoGuide=true
end

--变身之后抛出事件
function OnTransFigure()
    EventDispatcher:Dispatch(ON_TRANS_FIGURE)
end

-- 进副本之后判断当前副本是否是新人转职副本
function GetIsNewUserTransferDungeon()
    local globalTableDungeonIds = MGlobalConfig:GetSequenceOrVectorInt("TransfigureDungeonsID")
    local isNewUserTransferDungeon = false
    if MPlayerInfo and MPlayerInfo.PlayerDungeonsInfo and MPlayerInfo.PlayerDungeonsInfo.DungeonID then
        for i = 1, globalTableDungeonIds.Length do
            if tostring(globalTableDungeonIds[i - 1]) == tostring(MPlayerInfo.PlayerDungeonsInfo.DungeonID) then
                isNewUserTransferDungeon = true
                break
            end
        end
    end
    return isNewUserTransferDungeon
end
------------------刷新UI的逻辑------------------

return ModuleMgr.RoleInfoMgr