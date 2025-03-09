---@module CommonUIFunc
module("Common.CommonUIFunc", package.seeall)
require "TableEx/MonsterDataTable"
require "TableEx/NpcDataTable"
require "TableEx/ItemSearchTable"

ProfessionChangeTb = {}
ProfessionChangeTb.Zero = 0
ProfessionChangeTb.One = 1
ProfessionChangeTb.Two = 2

--定义转职的枚举
PROFESSIONTYPE = {
    ZERO = 0,
    ONE = 1,
    TWO = 2,
    THREE = 3
}
ProfessionChangeLv = nil

--根据全局配置 获取玩家的转职区间
function InitProfessionChangeLv()
    if ProfessionChangeLv == nil then
        local l_globalData = TableUtil.GetGlobalTable().GetRowByName("JobChangeLevel").Value
        local l_changeProfessionTb = string.ro_split(l_globalData, "|")

        ProfessionChangeLv = {}
        for i, v in ipairs(l_changeProfessionTb) do
            ProfessionChangeLv[i] = tonumber(v)
        end
    end
    return ProfessionChangeLv
end

--获取显示的Job等级 和玩家处于几转状态 --参数1 玩家的Job等级 参数2 玩家的职业Id
function GetShowJobLevelAndProByLv(cLv, cProId)
    --新手副本 转职副本 特殊处理
    if MScene.SceneID == 1004 or MScene.SceneID == 1500 then
        return cLv, PROFESSIONTYPE.TWO
    end

    InitProfessionChangeLv()
    local cProfessionId = cProId
    local cData = TableUtil.GetProfessionTable().GetRowById(cProfessionId)
    if cData then
        if cData.ProfessionType == PROFESSIONTYPE.ZERO then
            return cLv, cData.ProfessionType
        end
        if cData.ProfessionType == PROFESSIONTYPE.ONE then
            return cLv - ProfessionChangeLv[1], cData.ProfessionType
        end
        if cData.ProfessionType == PROFESSIONTYPE.TWO then
            return cLv - ProfessionChangeLv[2], cData.ProfessionType
        end
        if cData.ProfessionType == PROFESSIONTYPE.THREE then
            return cLv - ProfessionChangeLv[3], cData.ProfessionType
        end
    end
    return cLv, PROFESSIONTYPE.ZERO
end

--根据玩家的转职数 返回放假的技能点数
function GetSkillPointByCpNum(cPnum, cLv)

    InitProfessionChangeLv()

    if cPnum == PROFESSIONTYPE.ZERO then
        return 0
    end

    if cPnum == PROFESSIONTYPE.ONE then
        return cLv - ProfessionChangeLv[1]
    end

    if cPnum == PROFESSIONTYPE.TWO then
        return cLv - ProfessionChangeLv[2]
    end

    if cPnum == PROFESSIONTYPE.THREE then
        return cLv - ProfessionChangeLv[3]
    end

    return 0
end

--返回道具是否有路径产出
function isItemHaveExport(cItemId)
    local cData = ItemSearchTable[tonumber(cItemId)]
    if cData then
        for k, v in pairs(cData) do
            if table.ro_size(cData[k]) > 0 then
                return true
            end
        end
    end
    return false
end

--返回怪物所在场景和怪物所在位置
--[1055] = {[5] = {84.955,10.05,34.89}}
function GetMonsterSceneIdAndPos(cMonsterId)
    local cSceneTb = {}
    local cPosTb = {}

    if MonsterDataTable[cMonsterId] then
        if table.ro_size(MonsterDataTable[cMonsterId]) > 0 then
            local num = 0
            for k, v in pairs(MonsterDataTable[cMonsterId]) do
                num = num + 1
                local cPos = Vector3.New(v[1], v[2], v[3])
                cSceneTb[num] = k
                cPosTb[num] = cPos
            end
        end
    end
    return cSceneTb, cPosTb
end

--返回怪物非副本的怪物所在位置
function GetMonsterNormalSceneIdAndPos(cMonsterId)
    local cSceneTb = {}
    local cPosTb = {}

    if MonsterDataTable[cMonsterId] then
        if table.ro_size(MonsterDataTable[cMonsterId]) > 0 then
            local num = 0
            for k, v in pairs(MonsterDataTable[cMonsterId]) do
                if not IsDungonBySceneId(k) then
                    num = num + 1
                    local cPos = Vector3.New(v[1], v[2], v[3])
                    cSceneTb[num] = k
                    cPosTb[num] = cPos
                end
            end
        end
    end
    return cSceneTb, cPosTb
end
function GoToLatestMonsterPos(cMonsterId, centerScene, cArriveFun, cCancelFun)
    local cSceneTb, cposTb = GetMonsterNormalSceneIdAndPos(cMonsterId)
    local sceneNum = #cSceneTb
    if sceneNum < 1 then
        logError("MonsterDataTable no exist monsterId:" .. tostring(cMonsterId))
        return ;
    end
    if centerScene == nil then
        centerScene = MScene.SceneID
    else
        centerScene = tonumber(centerScene)
    end

    local gotoScene = cSceneTb[1]
    local gotoPos = cposTb[1]
    local findBestFitScene = false

    if table.ro_contains(cSceneTb, centerScene) then
        --是否包含centerScene
        gotoScene = centerScene
        findBestFitScene = true
    end

    if not findBestFitScene then
        local mapData = TableUtil.GetMapTable().GetRowBySceneId(centerScene)  --是否包含子场景
        if MLuaCommonHelper.IsNull(mapData) then
            local isContain, containValue = table.ro_containAnyInArray(cSceneTb, mapData.LabyrinthArea1)
            if isContain then
                gotoScene = containValue
                findBestFitScene = true
            else
                isContain, containValue = table.ro_containAnyInArray(cSceneTb, mapData.LabyrinthArea2)
                if isContain then
                    gotoScene = containValue
                    findBestFitScene = true
                else
                    isContain, containValue = table.ro_containAnyInArray(cSceneTb, mapData.LabyrinthArea3)
                    if isContain then
                        gotoScene = containValue
                        findBestFitScene = true
                    end
                end
            end
            if not findBestFitScene then
                isContain, containValue = table.ro_containAnyInArray(cSceneTb, mapData.RelatedArea) --是否包含相邻场景
                if isContain then
                    gotoScene = containValue
                    findBestFitScene = true
                end
            end
        end
    end

    if findBestFitScene then
        for i = 1, sceneNum do
            if cSceneTb[i] == gotoScene then
                gotoPos = cposTb[i]
            end
        end
    end
    MTransferMgr:GotoPosition(gotoScene, gotoPos, cArriveFun, cCancelFun)
end
function GetRichTextCSharp(content, params)
    local l_luaParams = {}
    if not MLuaCommonHelper.IsNull(params) then
        for i = 0, params.Count - 1 do
            local l_tempParam = params[i]
            local l_luaParam = {};
            l_luaParam.type = l_tempParam.type
            if not MLuaCommonHelper.IsNull(l_tempParam.param32) then
                l_luaParam.param32 = {}
                for j = 0, l_tempParam.param32.Count - 1 do
                    local l_param32Data = {
                        value = l_tempParam.param32[j]
                    }
                    table.insert(l_luaParam.param32, l_param32Data)
                end
            end
            if not MLuaCommonHelper.IsNull(l_tempParam.param64) then
                l_luaParam.param64 = {}
                for j = 0, l_tempParam.param64.Count - 1 do
                    local l_param64Data = {
                        value = l_tempParam.param64[j]
                    }
                    table.insert(l_luaParam.param64, l_param64Data)
                end
            end
            if not MLuaCommonHelper.IsNull(l_tempParam.name) then
                l_luaParam.name = {}
                for j = 0, l_tempParam.name.Count - 1 do
                    table.insert(l_luaParam.name, l_tempParam.name[j])
                end
            end
            table.insert(l_luaParams, l_luaParam)
        end

        local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
        local l_newContent = l_linkInputMgr.PackToTag(content, l_luaParams, false, true)
        return l_newContent
    end
    return content
end
function CheckMonsterIsMvp(cMonsterId)
    local cTable = TableUtil.GetMvpTable().GetTable()
    if cTable then
        for c, v in pairs(cTable) do
            if v.EntityID == cMonsterId then
                return true, GetSceneNameBySceneId(v.SceneID),v
            end
        end
    end
    return false, "" , nil
end

--是否是精英怪
function CheckMonsterIsElite(cMonsterId)
    local result = ""
    local cMonsterInfo = TableUtil.GetEntityTable().GetRowById(cMonsterId)
    if cMonsterInfo ~= nil then
        return cMonsterInfo.UnitTypeLevel == GameEnum.UnitTypeLevel.Mini
    end
    return false
end

function GetMonsterName(monsterId)
    local result = ""
    local cMonsterInfo = TableUtil.GetEntityTable().GetRowById(monsterId)
    if cMonsterInfo ~= nil then
        result = cMonsterInfo.Name
    end
    return result
end

function GetMonsterAtlasAndIcon(cMonsterId)
    local atlas = ""
    local icon = ""
    local cMonsterInfo = TableUtil.GetEntityTable().GetRowById(cMonsterId)
    if cMonsterInfo ~= nil then
        local pId = cMonsterInfo.PresentID
        local cPresentInfo = TableUtil.GetPresentTable().GetRowById(pId)
        if cPresentInfo then
            return cPresentInfo.Atlas, cPresentInfo.Icon
        end
    end
    return atlas, icon
end

--返回是否是副本
function IsDungonBySceneId(SceneId)
    local SceneInfo = TableUtil.GetSceneTable().GetRowByID(SceneId)
    if SceneInfo ~= nil then
        if SceneInfo.SceneType == 2 or SceneInfo.SceneType == 1 then
            return false
        else
            return true
        end
    end
    return false
end

--依据返回场景名
function GetSceneNameBySceneId(SceneId)
    local SceneInfo = TableUtil.GetSceneTable().GetRowByID(SceneId)
    if SceneInfo ~= nil then
        return tostring(SceneInfo.MiniMap)
    else
        return ""
    end
end

--依据NpcId返回Npc所在场景
function GetNpcSceneIdAndPos(cNpcId)
    local cSceneTb = {}
    local cPosTb = {}

    if NpcDataTable[cNpcId] then
        if table.ro_size(NpcDataTable[cNpcId]) > 0 then
            local num = 0
            for k, v in pairs(NpcDataTable[cNpcId]) do
                num = num + 1
                local cPos = Vector3.New(v[1], v[2], v[3])
                --cSceneTb[num] = k
                --cPosTb[num]   = cPos
                table.insert(cSceneTb, k)
                table.insert(cPosTb, cPos)
            end
        end
    end
    return cSceneTb, cPosTb
end

--获取Npc的位置
function GetNpcPosBySceneId(npcId, sceneId)
    if NpcDataTable[npcId] then
        if table.ro_size(NpcDataTable[npcId]) > 0 then
            local l_npcPosData = NpcDataTable[npcId][sceneId]
            if l_npcPosData then
                return Vector3.New(l_npcPosData[1], l_npcPosData[2], l_npcPosData[3])
            end
        end
    end
    return nil
end

--依据ShopId返回NpcId
function GetNpcIdByShopId(cShopId)
    local cNpcTable = {}
    local shopInfo = TableUtil.GetShopTable().GetRowByShopId(cShopId)

    if shopInfo == nil then
        logError("TableUtil.GetShopTable().GetRowByShopId(cShopId) == nil ShopId == " .. cShopId)
        return {}
    end

    return GetNpcIdTbByFuncId(shopInfo.SystemId)
end

--依据ShopId返回FuncID
function GetFuncIdByShopId(cShopId)
    local shopInfo = TableUtil.GetShopTable().GetRowByShopId(cShopId)

    if shopInfo then
        return shopInfo.SystemId
    else
        return 0
    end
end

--本地缓存FuncId和NpcId的关联
--table结构 {[FuncId] = {NpcId,NpcId},[FuncId] = {NpcId,NpcId}}
funcIdReleatNpcId = nil

function SetfuncIdReleatNpcId()
    if funcIdReleatNpcId ~= nil then
        return
    end

    funcIdReleatNpcId = {}
    local l_NpcTable = TableUtil.GetNpcTable().GetTable()
    for c, v in pairs(l_NpcTable) do
        local cFunId = Common.Functions.VectorToTable(v.NpcFunctionId)
        local l_funIdNum = table.maxn(cFunId)
        if l_funIdNum < 1 then
            --如果NpcFunctionId字段没有数据，则读取备用字段NpcFunctionIdBackup
            cFunId = Common.Functions.VectorToTable(v.NpcFunctionIdBackup)
            l_funIdNum = table.maxn(cFunId)
        end
        for i = 1, l_funIdNum do
            if funcIdReleatNpcId[cFunId[i]] then
                table.insert(funcIdReleatNpcId[cFunId[i]], v.Id)
            else
                funcIdReleatNpcId[cFunId[i]] = {}
                table.insert(funcIdReleatNpcId[cFunId[i]], v.Id)
            end
        end
    end
end

--依据FuncId返回NpcTable
function GetNpcIdTbByFuncId(cFuncId)
    SetfuncIdReleatNpcId()
    return funcIdReleatNpcId[cFuncId] ~= nil and funcIdReleatNpcId[cFuncId] or {}
end

FuncOpenType = {
    MainMenu = 1,
    ChildMenu = 2,
    Npc = 3,
}

--依据FunId返回查找方式
function GetFunctionTypeByFuncId(cFuncId)
    local tableData = TableUtil.GetOpenSystemTable().GetRowById(cFuncId)
    local finType = 1
    if tableData then
        local cFunType = Common.Functions.VectorToTable(tableData.TypeTab)
        if table.maxn(cFunType) == 1 then
            return cFunType[1]
        end
        for i = 1, table.maxn(cFunType) do
            if cFunType[i] == 1 or cFunType[i] == 2 or cFunType[i] == 5 then
                finType = 1
            else
                finType = 3
                return finType
            end
        end
    end
    return finType
end

--反向NPC位置表
local npcAllReverseTb = {}

--依据FuncId 执行一个方法 这个方法可能是打开界面 也可能是走到某一个Npc的位置 在打开界面
--如果是NPC寻路 能找到NPC返回true 不能则返回false 不是NPC寻路默认返回true
--justTalk 走过去只和Npc聊天 不做操作
function InvokeFunctionByFuncId(cFuncId, param, justTalk,invokeSucceedCallBack)
    --增加支持传参
    local cOpenType = Common.CommonUIFunc.GetFunctionTypeByFuncId(cFuncId)
    local cMethod = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(cFuncId)
    local cNpcTb = Common.CommonUIFunc.GetNpcIdTbByFuncId(cFuncId)
    if cOpenType == Common.CommonUIFunc.FuncOpenType.Npc then

        if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon() then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Tips_ButtonCantUseText"))
            return false
        end

        --NPC位置反向表
        local npcReverseTb = {}
        if not npcAllReverseTb[cFuncId] then
            local npcReverse = {}
            for k, v in ipairs(cNpcTb) do
                local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(v)  --这个地方需要简单重构一下 返回一个数据结构更为妥当
                for k1, v1 in ipairs(sceneIdTb) do
                    if not npcReverse[v1] then
                        npcReverse[v1] = {}
                    end
                    table.insert(npcReverse[v1], { npcId = v, npcPos = posTb[k1] })
                end
            end
            npcAllReverseTb[cFuncId] = npcReverse
            npcReverseTb = npcReverse
        else
            npcReverseTb = npcAllReverseTb[cFuncId]
        end

        if table.maxn(cNpcTb) > 0 then
            local gotoSceneId, gotoPos
            local currentSceneID = MScene.SceneID

            --优先判断当前场景中是否有对应功能的NPC 有的话去距离最近的NPC   --这块地方也优化一下吧 看着有点蛋疼
            local currentNpcTb = npcReverseTb[currentSceneID]
            if currentNpcTb then
                local currentPos = MEntityMgr.PlayerEntity.Position
                if #currentNpcTb > 1 then
                    local minDistance
                    for k, v in ipairs(currentNpcTb) do
                        local distance = math.sqrt(math.pow((v.npcPos.x - currentPos.x), 2) + math.pow((v.npcPos.y - currentPos.y), 2) + math.pow((v.npcPos.z - currentPos.z), 2))
                        if not minDistance then
                            minDistance = distance
                        end
                        if minDistance >= distance then
                            minDistance = distance
                            gotoSceneId = currentSceneID
                            gotoPos = v.npcId   --这儿是不是写错了 确定不是npcPos吗
                        end
                    end
                else
                    gotoSceneId = currentSceneID
                    gotoPos = currentNpcTb[1].npcId
                end
            end
            --本如果本场景内没有对应功能的NPC 则优先寻找当前场景所属区域的主城场景
            if not gotoSceneId then
                local mapTb = TableUtil.GetMapTable().GetRowBySceneId(currentSceneID)
                if mapTb then
                    local mainCityId = mapTb.Region
                    if npcReverseTb[mainCityId] then
                        if #npcReverseTb[mainCityId] > 0 then
                            gotoSceneId = mainCityId
                            gotoPos = npcReverseTb[mainCityId][1].npcId   --这儿是不是写错了 确定不是npcPos吗
                        end
                    end
                end
            end
            --存储点主城   存储点是啥？ 目前有实现吗
            --TODO
            --如果当前场景没有 当前场景所属主城也没有 寻找普隆德拉中对应功能的NPC
            if not gotoSceneId then
                if npcReverseTb[7] then
                    if #npcReverseTb[7] > 0 then
                        gotoSceneId = 7
                        gotoPos = npcReverseTb[7][1].npcId  --这儿是不是写错了 确定不是npcPos吗
                    end
                end
            end
            --普隆德拉也没有 则遍历地图场景找ID最小的地图里面的那个NPC 根据检索到的地图顺序找ID最小的那个
            if not gotoSceneId then
                local minSceneId
                for k, v in pairs(npcReverseTb) do
                    if not minSceneId then
                        minSceneId = k
                    end
                    if minSceneId >= k then
                        minSceneId = k
                        gotoSceneId = k
                        gotoPos = v[1].npcId  --这儿是不是写错了 确定不是npcPos吗
                    end
                end
            end

            --如果找到了目标NPC则寻路过去返回true 没找到则弹出提示返回false
            if gotoSceneId then
                --寻找成功的回调
                if invokeSucceedCallBack then
                    invokeSucceedCallBack()
                end
                --寻路导航过去
                return MTransferMgr:GotoNpc(gotoSceneId, gotoPos, function()
                    --延迟1帧执行 到达后回调 防止一开始就在边上 直接又把界面关了
                    local l_timer = Timer.New(function(b)
                        if justTalk then
                            MgrMgr:GetMgr("NpcMgr").TalkWithNpc(gotoSceneId, gotoPos)
                        else
                            if cMethod ~= nil then
                                cMethod(param, gotoPos)  --部分功能需要获取对话触发的NPC的ID 所以增加npcId参数 gotoPso存的是交互的npcId
                            end
                        end
                    end, 0)
                    l_timer:Start()
                end)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ACTIVITY_CANNOT_FIND_NPC"))
                return false
            end
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_NPCHERE"))
            return false
        end
    else
        if invokeSucceedCallBack then
            invokeSucceedCallBack()
        end
        if cMethod ~= nil then
            cMethod(param)
        end
        return false  --不需要走向NPC寻路的话 不需要显示主界面
    end
end

--依据FuncId返回funcName
function GetFunctionNameByFuncId(cFuncId)
    local tableData = TableUtil.GetOpenSystemTable().GetRowById(cFuncId)
    if tableData then
        return tableData.Title
    end
    return ""
end

--依据FuncId返回当前功能是否开放以及开放等级
function GetFunctionIsOpenAndOpenLevelByFuncId(FuncId)
    local l_tableData = TableUtil.GetOpenSystemTable().GetRowById(FuncId)
    local l_isOpen=false
    local l_level=0
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_showStr = ""
    local l_tipsStr = ""
    l_isOpen = l_openSystemMgr.IsSystemOpen(FuncId)
    if not l_isOpen then
        l_showStr = _getFunctionOpenText(l_tableData.BaseLevel)
        l_tipsStr = _getFunctionNotOpenTipsText(l_tableData.BaseLevel,l_tableData.Title)
        return false,l_tableData.BaseLevel,l_showStr,l_tipsStr
    end

    --任务开启：判断OpenSystemTable中配置的TaskId字段，是否已达成开启任务
    local l_taskIdTb = Common.Functions.VectorToTable(l_tableData.TaskId)
    if #l_taskIdTb > 0 then
        for _, value in pairs(l_taskIdTb) do
            if not l_taskMgr.CheckTaskFinished(value) then
                return false,l_tableData.BaseLevel,Lang("NotOpened") ,Lang("FINISH_TASK_FIRST")
            end
        end
    end

    --开启时间：如果功能在DailyActivitiesTable中有配置TimeCycle活动周时间和TimePass活动时间，需要判断是否在活动时间内
    if FuncId ~= MgrMgr:GetMgr("OpenSystemMgr").eSystemId.CatCaravan then  --猫手商队存在于活动表 但不做处理 实在没时间改机制 策划 服务器都没时间 所以临时特判
        local l_dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
        local l_totalActivityData = GetDaialyActivityTotalData()
        local l_dailyActivityData = l_totalActivityData[FuncId]
        local l_activityId = l_dailyActivityData and l_dailyActivityData.Id
        if l_dailyActivityData and (not l_dailyTaskMgr.IsActivityOpend(l_activityId) or not l_dailyTaskMgr.IsActivityInOpenDay(l_activityId)) then
            return false,l_tableData.BaseLevel,l_dailyActivityData.TimeTextDisplay,Lang("DAILY_FUNCTION_OPEN",l_dailyActivityData.TimeTextDisplay)
        end
    end

    --判断是否需要加入公会
    local l_itemAchievingTypeTb = TableUtil.GetItemAchievingTypeTable().GetRowByID(FuncId,true) 
    if l_itemAchievingTypeTb and l_itemAchievingTypeTb.GuildActivity == 1 then
        if not MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
            return false,l_tableData.BaseLevel,Lang("NO_GUILD"),Lang("CHAT_HINT_MESSAGE_CONDITION_GUILD")
        end
    end

    return l_isOpen, l_level, "",""
end

local l_dailyActivityTotalData = {}
function GetDaialyActivityTotalData()
    if #l_dailyActivityTotalData <= 0 then
        local activities = TableUtil.GetDailyActivitiesTable().GetTable()
        for i, v in pairs(activities) do
            l_dailyActivityTotalData[v.FunctionID] = v
        end
    end
    return l_dailyActivityTotalData
end

function _getFunctionNotOpenTipsText(openLevel,functionName)
    if openLevel==nil or openLevel == 0 then
        return Lang("SYSTEM_DONT_OPEN")
    end
    return Lang("LEVEL_NOTENOUGH_TIPS", openLevel, functionName)
end

function _getFunctionOpenText(openLevel)
    if openLevel==nil or openLevel == 0 then
        return Lang("SYSTEM_DONT_OPEN")
    end
    return Lang("LEVEL_NOTENOUGH", openLevel)
end

--依据副本Id返回NpcId
function GetNpcIdAndFuncIDByDungonId(cDungonId)

    local l_systemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local cNpcTable = {}
    local cDfunId = 0
    --这里这个Table需要维护副本类型（1.镜像副本 2.主题副本 3.无限塔 4.双人烹饪5.爱神副本6战场 7 圣歌试炼 8 新手副本 11擂台PVP 13挑战 19迷雾之森）
    local dungonFuncTb = {
        [1] = 0,
        [2] = 5023,
        [3] = 5030,
        [4] = 7001,
        [5] = 5040,
        [6] = 15001,
        [7] = 5050,
        [8] = 0,
        [11] = 15002,
        [13] = 5140,
        [15] = 5073,
        [16] = 7009,
        [18] = 5074,
        [19] = 5070,
        [23] = 5160,
        [24] = 5161,
        [26] = 5020,
    }
    local l_DungonTable = TableUtil.GetDungeonsTable().GetRowByDungeonsID(cDungonId)
    if l_DungonTable ~= nil then
        cDfunId = dungonFuncTb[l_DungonTable.DungeonsType]
        if not cDfunId then
            logError(StringEx.Format("副本类型对应的功能id不存在 @马鑫  副本ID:{0} 副本类型:{1}", cDungonId, l_DungonTable.DungeonsType))
        end
    else
        logError(StringEx.Format("副本类型对应的功能id不存在 @马鑫  副本ID:{0}", cDungonId))
    end

    return GetNpcIdTbByFuncId(cDfunId), cDfunId
end

function GetFuncAtlasAndIconByFuncId(cFunId)
    local l_SysTable = TableUtil.GetOpenSystemTable().GetRowById(cFunId)
    if l_SysTable ~= nil then
        return l_SysTable.SystemAtlas, l_SysTable.SystemIcon
    else
        return "", ""
    end
end

function GetMainPanelAtlasAndIconByFuncId(cFunId)
    local l_atlasIcon = ""
    local l_SysTable = TableUtil.GetOpenSystemTable().GetRowById(cFunId)
    if l_SysTable ~= nil then
        l_atlasIcon = string.sub(l_SysTable.SystemIcon, 1, -5) .. "_Main.png"
        return "IconMain", l_atlasIcon
    else
        return "", ""
    end
end

function GetFuncNoticeAtlasAndIconByFuncId(cFunId)
    local l_SysTable = TableUtil.GetOpenSystemTable().GetRowById(cFunId)
    if l_SysTable ~= nil then
        return l_SysTable.NoticeAtlas, l_SysTable.NoticePhoto
    else
        return "", ""
    end
end

function GetFuncNameByFuncId(cFunId)
    local l_SysTable = TableUtil.GetOpenSystemTable().GetRowById(cFunId)
    if l_SysTable ~= nil then
        return l_SysTable.Title
    else
        return ""
    end
end

function GetDungonNameByDungonID(cDungonId)
    local l_DungonTable = TableUtil.GetDungeonsTable().GetRowByDungeonsID(cDungonId)
    if l_DungonTable ~= nil then
        return tostring(l_DungonTable.DungeonsName)
    else
        return ""
    end
end

function GetDungonTypeByDungonID(cDungonId)
    local l_DungonTable = TableUtil.GetDungeonsTable().GetRowByDungeonsID(cDungonId)
    if l_DungonTable ~= nil then
        return l_DungonTable.DungeonsType
    else
        return ""
    end
end

function GetShopNameByShopId(cShopId)
    local ShopInfo = TableUtil.GetShopTable().GetRowByShopId(cShopId)
    if ShopInfo ~= nil then
        return ShopInfo.ShopName
    end
    return ""
end

--显示职业字符串的函数
function GetProfessionStr(professionType)
    local ret = Common.Utils.Lang("TRADE_DES_JOB") .. "："
    local profession = Common.Functions.VectorSequenceToTable(professionType)
    local index = 1
    local professionTable = TableUtil.GetProfessionTable().GetTable()
    local isFull = false

    for j = 1, table.maxn(profession) do
        if index ~= 1 then
            ret = ret .. "/"
        end
        if profession[j][2] == 0 then
            --如果第二位为0
            if profession[j][1] == 0 then
                --如果配置 0=0 显示全职业
                ret = ret .. Common.Utils.Lang("FULL_PROFESSION")
                isFull = true
                return ret, isFull
            else
                -- 3000=0显示为 服侍和牧师 则显示职业系列
                local professionRow = TableUtil.GetProfessionTable().GetRowById(profession[j][1])
                if professionRow then
                    ret = ret .. Common.Utils.Lang("ONE_PROFESSION", professionRow.Name)
                else
                    logError("配置检查 @策划 ProfessionTable Id -->>  " .. profession[j][1])
                end
            end
        else
            --如果第二位为1 则显示固定职业 如 4000=1显示为固定巫师
            local professionRow = TableUtil.GetProfessionTable().GetRowById(profession[j][1])
            if professionRow then
                ret = ret .. professionRow.Name
            else
                logError("配置检查 @策划 ProfessionTable Id -->>  " .. profession[j][1])
            end
        end
        index = index + 1
    end
    return ret, isFull
end

--依据一个职业类别 返回这个职业是否在这个职业系中 如服侍是否在法师系中  参数1 查询职业Id 参数2 职业系Id 比如铁匠属于商人
function GetProfessionBelongState(playerType, parentId)
    local l_count = 1    --防止死循环
    local l_curType = playerType
    while l_curType ~= 0 and l_curType ~= parentId and l_count < 10 do
        local l_proRow = TableUtil.GetProfessionTable().GetRowById(l_curType)
        if l_proRow then
            l_curType = l_proRow.ParentProfession
        else
            break
        end
        l_count = l_count + 1
    end
    return l_curType == parentId
end

--返回该职业的职业系的所有ID
function GetPlayerProfessionList(professionId)
    local plist = GetProfessionTypeList()
    for k, v in pairs(plist) do
        for i = 1, table.maxn(v) do
            if v[i] == professionId then
                return v
            end
        end
    end
    return {}
end

--一个职业系的table
function GetProfessionTypeList()
    local professionTable = TableUtil.GetProfessionTable().GetTable()
    local parentProfessionList = {}

    --首先 建立用所有的职业父Id为Key的Table 结果{[1000] = {},[2000] = {}}
    for i = 1, table.maxn(professionTable) do
        if professionTable[i].Id > 1000000 then
            break
        end
        if professionTable[i].Id < 1000000 then
            if parentProfessionList[professionTable[i].Id] == nil then
                parentProfessionList[professionTable[i].Id] = {}
            end
        end
    end

    --然后遍历 找出父职业Id下面的子Id 结果{[1000] = {2000,3000,4000},[2000] = {2001},[3000] = {3001}}
    for i = 1, table.maxn(professionTable) do
        if professionTable[i].Id > 1000000 then
            break
        end
        for k, v in pairs(parentProfessionList) do
            if professionTable[i].ParentProfession == k then
                table.insert(parentProfessionList[k], professionTable[i].Id)
            end
        end
    end

    --然后在遍历 上面得到的父职业的子Id列表  相当于递归 在查找子项 有没有对应的子职业
    for k, v in pairs(parentProfessionList) do
        for i = 1, table.maxn(v) do
            if parentProfessionList[v[i]] ~= nil then
                table.ro_insertRange(parentProfessionList[k], parentProfessionList[v[i]])
            end
        end
    end

    --去掉子节点为0的 去掉父节点为1000的
    local finProfessionList = {}
    for k, v in pairs(parentProfessionList) do
        if table.maxn(v) > 0 and k ~= 1000 then
            table.insert(v, k)
            table.sort(v, function(a, b)
                return a < b
            end)
            finProfessionList[k] = v
        end
    end

    --Common.Functions.DumpTable(finProfessionList)
    return finProfessionList
end

--查找所有职业的字符串
function GetFullProfessionStr()
    local ret = ""
    local professionTable = TableUtil.GetProfessionTable().GetTable()
    local index = 1
    for i = 1, table.maxn(professionTable) do
        if (professionTable[i].Id < 1000000) then
            if index == 1 then
                ret = ret .. professionTable[i].Name
            else
                ret = ret .. "/" .. professionTable[i].Name
            end
            index = index + 1
        end
    end
    return ret
end

--根据道具表的ItemData获取一个装备类型名称
function GetEquipTypeName(itemTableData)
    if itemTableData.TypeTab == 1 then
        local equipTableInfo = TableUtil.GetEquipTable().GetRowById(itemTableData.ItemID)
        if not equipTableInfo then
            return
        end

        local typeName = MgrMgr:GetMgr("EquipMgr").eEquipTypeName[equipTableInfo.EquipId]
        if equipTableInfo.EquipId == 1 then
            local equipWeaponTableInfo = TableUtil.GetEquipWeaponTable().GetRowById(equipTableInfo.WeaponId)
            return typeName .. "·" .. equipWeaponTableInfo.WeaponName
        else
            return typeName
        end
    else
        return GetItemTypeNameBySubClssType(itemTableData.Subclass)
    end
end

--根据Item表的SubClass 取中文类型
function GetItemTypeNameBySubClssType(SubclassId)
    local itemSubClssTableInfo = TableUtil.GetItemSubclassTable().GetRowByID(SubclassId)
    if itemSubClssTableInfo then
        return itemSubClssTableInfo.Des
    end
end

--根据性别类型 返回一个字符串 性别：无限制 or 男 or 女 or 人妖
function GetSexStr(sexType)
    local ret = ""
    if sexType == 2 then
        ret = Common.Utils.Lang("SEX_GENDER") .. "：" .. Common.Utils.Lang("NOT_LIMIT")
    elseif sexType == 0 then
        ret = Common.Utils.Lang("SEX_GENDER") .. "：" .. Common.Utils.Lang("SEX_MEN")
    elseif sexType == 1 then
        ret = Common.Utils.Lang("SEX_GENDER") .. "：" .. Common.Utils.Lang("SEX_WOMEN")
    else
        ret = Common.Utils.Lang("SEX_GENDER") .. "：" .. Common.Utils.Lang("SEX_NOSEX")
    end
    return ret
end

--根据itemTableData的LevelLimit字段 返回一个等级限制的字符串 无限制 or 限制等级Num
function GetLevelStr(levelLimit)
    local ret = ""
    local minLevel = levelLimit:get_Item(0)
    if minLevel == 0 then
        ret = Common.Utils.Lang("NOT_LIMIT")
    else
        ret = minLevel
    end
    return ret
end

--单向传送场景
function GoDirTeleport(sceneId, npcId)
    local l_msgId = Network.Define.Rpc.DirTeleport
    ---@type DirTeleportData
    local l_sendInfo = GetProtoBufSendTable("DirTeleportData")
    l_sendInfo.sceneid = sceneId
    l_sendInfo.npcid = npcId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function IsInContainDeviceTable(type)
    local l_table = TableUtil.GetDeviceTable().GetTable()
    local l_indexs = {}
    for i = 1, #l_table do
        local data = Common.Functions.VectorToTable(l_table[i].TypeLimit)
        for i = 1, #data do
            if l_indexs[data[i]] == nil then
                l_indexs[data[i]] = {}
            end
        end
    end
    return l_indexs[type] ~= nil
end

--获取玩家的父职业ID
--MPlayerInfo.ProfessionId
function GetParentIdByCurProfessionId(curProfessionId)
    if curProfessionId == nil then
        logError("Current Profession Id is nil")
        return nil
    end
    local professionTableData = TableUtil.GetProfessionTable().GetRowById(curProfessionId)
    if professionTableData == nil then
        logError("professionTableData nil Id -->>" .. professionTableData.Id)
        return nil
    end
    return professionTableData.ParentProfession
end

function OpenMagicMachinePanel(NpcId, FuncId, itemid)
    MgrMgr:GetMgr("NpcMgr").CurrentNpcId = NpcId
    if FuncId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractCard then
        --3091
        MgrMgr:GetMgr("MagicExtractMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicExtractMachineMgr").EMagicExtractMachineType.Card
        MgrMgr:GetMgr("MagicExtractMachineMgr").SetExtractMagicPreViewData({ itemid = itemid })
    elseif FuncId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractEquip then
        --3098
        MgrMgr:GetMgr("MagicExtractMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicExtractMachineMgr").EMagicExtractMachineType.Equip
        MgrMgr:GetMgr("MagicExtractMachineMgr").SetExtractMagicPreViewData({ itemid = itemid })
    end
    local cMethod = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(FuncId)
    if cMethod then
        cMethod()
    end
end

function ShowMonsterTipsById(monsterId, prefunc)
    if prefunc then
        prefunc()
    end
    local l_sceneIdTable = {}
    local l_posTb = {}
    local l_isMvp,l_place,l_mvpTableData = CheckMonsterIsMvp(monsterId)
    if l_isMvp and l_mvpTableData then
        local l_sceneData = TableUtil.GetSceneTable().GetRowByID(l_mvpTableData.SceneID)
        if l_sceneData and l_sceneData.LandPos then
            local l_Pos = Vector3.New(l_sceneData.LandPos[0],l_sceneData.LandPos[1],l_sceneData.LandPos[2])
            table.insert(l_sceneIdTable,l_mvpTableData.SceneID)
            table.insert(l_posTb,l_Pos)
        end
    else
        l_sceneIdTable, l_posTb = GetMonsterSceneIdAndPos(monsterId)
    end
    ShowItemAchievePlacePanel(l_sceneIdTable, l_posTb, nil)
end

function ShowItemAchievePlacePanel(cSceneTb, cPosTb, cArriveFun)
    UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function(ctrl)
        ctrl:SetPlacePanle(cSceneTb, cPosTb, cArriveFun)
    end)
end

ConsumeDatas = {}
IsFinishSetConsumeTbData = false
function GetConsumeIdTb()
    --属性点消耗
    local l_consume = MGlobalConfig:GetVectorSequence("ResetPropertyPointCost")
    if not l_consume then
        logError("GlobalTable ResetPropertyPointCost is nil @沈天考")
        return
    end
    for i = 0, l_consume.Length - 1 do
        local l_data = {}
        l_data.ID = tonumber(l_consume[i][0])
        l_data.RequireCount = tonumber(l_consume[i][1])
        l_data.IsProperty = true
        l_data.IsSkill = false
        table.insert(ConsumeDatas, l_data)
    end

    --属性点消耗
    local l_consumeSkill = MGlobalConfig:GetVectorSequence("ResetSkillPointCost")
    if not l_consumeSkill then
        logError("GlobalTable ResetSkillPointCost is nil @李韬")
        return
    end
    for i = 0, l_consume.Length - 1 do
        local l_data = {}
        l_data.ID = tonumber(l_consumeSkill[i][0])
        l_data.RequireCount = tonumber(l_consumeSkill[i][1])
        l_data.IsProperty = false
        l_data.IsSkill = true
        table.insert(ConsumeDatas, l_data)
    end
    IsFinishSetConsumeTbData = true
end

--判断一个道具是否是Global表里面的消耗道具 如技能重置 属性点重置
function GetItemIdIsInConsumeIdTb(itemId)
    if not IsFinishSetConsumeTbData then
        GetConsumeIdTb()
    end
    for i = 1, table.maxn(ConsumeDatas) do
        if tostring(ConsumeDatas[i].ID) == tostring(itemId) then
            return true, ConsumeDatas[i].IsProperty, ConsumeDatas[i].IsSkill
        end
    end
    return false, false, false
end

--判断一个道具是不是背包扩充道具
function GetItemIdIsBagWeightAddedId(itemId)
    local l_consumeId = MGlobalConfig:GetInt("BagLoadUnlockItemID")
    if l_consumeId == 0 then
        logError("GlobalTable BagLoadUnlockItemID is nil @李韬")
        return
    end
    return itemId == l_consumeId
end

--判断场景是不是可去的区域
function CheckScene(targetId)
    local sceneID = MScene.SceneID
    local SceneTable = TableUtil.GetSceneTable().GetRowByID(sceneID)
    if SceneTable.SceneType == 1 or SceneTable.SceneType == 2 then
        return true
    end

    --如果自己在的场景和检测场景相同 那么返回True
    if targetId ~= nil and sceneID == targetId then
        return true
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_AUTO_PATH"))
    return false
end

function OpenRoleInfoCtrlAndConsume()
    if not MgrMgr:GetMgr("RoleInfoMgr").HasBaseAttrAdded() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_NOT_NEED_CLEAR_TIPS"))
        return
    end

    local l_RoleOpenData = {
        openType = MgrMgr:GetMgr("RoleInfoMgr").ERoleInfoOpenType.ResetRoleAttr,
    }
    UIMgr:ActiveUI(UI.CtrlNames.RoleAttr, l_RoleOpenData)

end

function OpenSkillCtrlAndConsume()
    if not MgrMgr:GetMgr("SkillLearningMgr").CanResetSkills() then
        return
    end
    local l_skillData = {
        openType = DataMgr:GetData("SkillData").OpenType.ResetSkills
    }
    UIMgr:ActiveUI(UI.CtrlNames.SkillLearning, l_skillData)
end

function OpenBagConsume()
    CommonUI.Dialog.ShowConsumeDlg("", Data.BagModel:getAddWeightTipsInfo(),
            function()
                MgrMgr:GetMgr("PropMgr").RequestUnlockBlank(BagType.BAG)
            end, nil, Data.BagModel:getAddWeightConsume())
end

-----以下用于创建通用动画
UITweenType = {
    None = 0,
    Left = 1,
    Right = 2,
    Up = 3,
    Down = 4,
    Alpha = 5,
    LeftAlpha = 6,
    RightAlpha = 7,
    UpAlpha = 8,
    DownAlpha = 9,
}

function CreateTween(go, tweenType, moveDelta, time, isFadeOut, onComplete)
    local tweenId = 0
    if tweenType ~= nil then
        -- 播放淡入动画
        tweenId = TweenUI(go, tweenType, moveDelta, time, isFadeOut, function()
            --MLuaCommonHelper.SetLocalPos(go, 0, 0, 0)
            --MLuaCommonHelper.SetRectTransformOffset(go, 0, 0, 0, 0)
            onComplete()
        end)
    end
    return tweenId
end

-- UI淡入淡出动画
function TweenUI(go, tweenType, moveDelta, time, isFadeOut, onComplete)
    if not MLuaCommonHelper.IsNull(go) and tweenType ~= nil then
        local l_destPos = go.transform.localPosition
        local l_srcPos = go.transform.localPosition

        if tweenType == UITweenType.Left or tweenType == UITweenType.LeftAlpha then
            if isFadeOut then
                l_destPos.x = l_destPos.x + moveDelta
            else
                l_srcPos.x = l_srcPos.x + moveDelta
            end
        elseif tweenType == UITweenType.Right or tweenType == UITweenType.RightAlpha then
            if isFadeOut then
                l_destPos.x = l_destPos.x - moveDelta
            else
                l_srcPos.x = l_srcPos.x - moveDelta
            end
        elseif tweenType == UITweenType.Up or tweenType == UITweenType.UpAlpha then
            if isFadeOut then
                l_destPos.y = l_destPos.y - moveDelta
            else
                l_srcPos.y = l_srcPos.y - moveDelta
            end
        elseif tweenType == UITweenType.Down or tweenType == UITweenType.DownAlpha then
            if isFadeOut then
                l_destPos.y = l_destPos.y + moveDelta
            else
                l_srcPos.y = l_srcPos.y + moveDelta
            end
        end

        if tweenType and tweenType > UITweenType.None and tweenType < UITweenType.Alpha then
            return MUITweenHelper.TweenPos(go, l_srcPos, l_destPos, time, onComplete)
        else
            local l_srcAlpha = 0
            local l_destAlhpa = 1
            if isFadeOut then
                l_srcAlpha = 1
                l_destAlhpa = 0
            end

            return MUITweenHelper.TweenPosAlpha(go, l_srcPos, l_destPos, l_srcAlpha, l_destAlhpa, time, onComplete)
        end
    end
    return 0
end

--创建模型的方法
--Data = MemberBase
--rawImag传MluaUiCom
--isDrag 是否可以拖动旋转 需要添加MLuaUIListener
--isCanClick 是否可以点击 默认打开名片 支持自定义方法
--ClickFunc 点击方法
function CreateModelEntity(data, rawImageLuaCom, isDrag, isCanClick, ClickFunc)
    local isDragNow = false
    local isMale = true
    if data.sex and data.sex == 1 then
        isMale = false
    end
    local attr = MgrMgr:GetMgr("TeamMgr").GetRoleAttrByData(data.type, isMale, data.outlook, data.equip_ids)
    local l_fxData = MUIModelManagerEx:GetDataFromPool()
    l_fxData.rawImage = rawImageLuaCom.RawImg
    l_fxData.attr = attr
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)

    local model = MUIModelManagerEx:CreateModel(l_fxData)
    model:AddLoadModelCallback(function(m)
        rawImageLuaCom.gameObject:SetActiveEx(true)
    end)

    if isDrag and rawImageLuaCom.Listener then
        rawImageLuaCom.Listener.onDrag = function(uobj, event)
            model.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
            isDragNow = true
        end
    end

    if isCanClick and rawImageLuaCom.Listener then
        rawImageLuaCom.Listener.onClick = function(g, e)
            if isDragNow then
                isDragNow = false
                return
            end
            if ClickFunc then
                ClickFunc()
            else
                RefreshPlayerMenuLByUid(data.role_uid)
            end
        end
    end

    MUIModelManagerEx:ReturnDataToPool(l_fxData)
    return model
end

--创建模型的方法
--vechileId 载具Id
--rawImag传MluaUiCom
--isDrag 是否可以拖动旋转 需要添加MLuaUIListener
--isCanClick 是否可以点击 默认打开名片 支持自定义方法
--ClickFunc 点击方法
function CreateVechicleModel(vechileId, rawImageLuaCom, isDrag, isCanClick, ClickFunc)
    if vechileId == nil then
        logError("vechileId is nil")
        return
    end
    rawImageLuaCom:SetActiveEx(false)
    local modelObj = MUIModelManagerEx:CreateModelByItemId(vechileId, rawImageLuaCom.RawImg)
    modelObj:AddLoadModelCallback(function(m)
        modelObj.Trans:SetLocalRotEuler(0, -180, 0)
        SetModleSize(modelObj.Trans)
        rawImageLuaCom:SetActiveEx(true)
    end)

    if isDrag and rawImageLuaCom.Listener then
        rawImageLuaCom.Listener.onDrag = function(uobj, event)
            if modelObj.Trans then
                modelObj.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
            end
        end
    end
    if isCanClick and rawImageLuaCom.Listener then
        rawImageLuaCom.Listener.onClick = function(g, e)
            if ClickFunc then
                ClickFunc()
            end
        end
    end
    return modelObj
end

--创建玩家的模型 但是需要玩家模型穿戴ItemId的装备or服饰
--itemId 穿戴Id
--rawImag传MluaUiCom
--isWearNothing 是否不穿玩家本身的衣服
--isDrag 是否可以拖动旋转 需要添加MLuaUIListener
--isCanClick 是否可以点击 默认打开名片 支持自定义方法
--ClickFunc 点击方法
---@param ext_args {}
function CreatePlayerModel(itemIds, itemTableData, rawImageLuaCom, isWearNothing, isDrag, isCanClick, ClickFunc, ext_args)
    if type(itemIds) ~= "table" then
        logError("itemIds is not table")
        return
    end
    if type(itemTableData) ~= "table" then
        logError("itemTableData is not table")
        return
    end

    if #itemIds ~= #itemTableData then
        logError("itemIds和itemTableData长度不同")
        return
    end

    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitRoleAttr(l_tempId, tostring(l_tempId), MPlayerInfo.ProID, MPlayerInfo.IsMale, nil)
    l_attr:SetHair(MPlayerInfo.HairStyle)
    l_attr:SetEyeColor(MPlayerInfo.EyeColorID)
    l_attr:SetEye(MPlayerInfo.EyeID)
    if not isWearNothing then
        l_attr:SetOrnament(MPlayerInfo.OrnamentHead)
        l_attr:SetOrnament(MPlayerInfo.OrnamentFace)
        l_attr:SetOrnament(MPlayerInfo.OrnamentMouth)
        l_attr:SetOrnament(MPlayerInfo.OrnamentBack)
        l_attr:SetOrnament(MPlayerInfo.OrnamentTail)
        l_attr:SetOrnament(MPlayerInfo.OrnamentHeadFromBag, true)
        l_attr:SetOrnament(MPlayerInfo.OrnamentFaceFromBag, true)
        l_attr:SetOrnament(MPlayerInfo.OrnamentMouthFromBag, true)
        l_attr:SetOrnament(MPlayerInfo.OrnamentBackFromBag, true)
        l_attr:SetOrnament(MPlayerInfo.OrnamentTailFromBag, true)
        l_attr:SetFashion(MPlayerInfo.Fashion)
    end
    for i,v in ipairs(itemIds) do
        if GetItemIsOrnament(itemTableData[i]) then
            l_attr:SetOrnament(v)
        end
        if TableUtil.GetFashionTable().GetRowByFashionID(v,true) ~= nil then
            l_attr:SetFashion(v)
        end
    end
    local l_fxData = MUIModelManagerEx:GetDataFromPool()
    l_fxData.rawImage = rawImageLuaCom.RawImg
    l_fxData.attr = l_attr
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)
    if ext_args then
        l_fxData.width = ext_args.width or l_fxData.width
        l_fxData.height = ext_args.height or l_fxData.height
        -- 可以继续增加其他数据
    end

    rawImageLuaCom:SetActiveEx(false)
    local model = MUIModelManagerEx:CreateModel(l_fxData)
    model:AddLoadModelCallback(function(m)
        rawImageLuaCom:SetActiveEx(true)
    end)

    if isDrag and rawImageLuaCom.Listener then
        rawImageLuaCom.Listener.onDrag = function(uobj, event)
            if model.Trans then
                model.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
            end
        end
    end
    if isCanClick and rawImageLuaCom.Listener then
        rawImageLuaCom.Listener.onClick = function(g, e)
            if ClickFunc then
                ClickFunc()
            end
        end
    end
    MUIModelManagerEx:ReturnDataToPool(l_fxData)
    return model
end

function GetMyselfRoleAttr()
    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitRoleAttr(l_tempId, tostring(l_tempId), MPlayerInfo.ProID, MPlayerInfo.IsMale, nil)
    l_attr:SetHair(MPlayerInfo.HairStyle)
    l_attr:SetFashion(MPlayerInfo.Fashion)
    l_attr:SetOrnament(MPlayerInfo.OrnamentHead)
    l_attr:SetOrnament(MPlayerInfo.OrnamentFace)
    l_attr:SetOrnament(MPlayerInfo.OrnamentMouth)
    l_attr:SetOrnament(MPlayerInfo.OrnamentBack)
    l_attr:SetOrnament(MPlayerInfo.OrnamentTail)
    l_attr:SetEyeColor(MPlayerInfo.EyeColorID)
    l_attr:SetEye(MPlayerInfo.EyeID)
    l_attr:SetWeapon(MPlayerInfo.WeaponFromBag, true)
    l_attr:SetWeaponEx(MPlayerInfo.WeaponExFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentHeadFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentFaceFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentMouthFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentBackFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentTailFromBag, true)
    return l_attr
end

function SetModleSize(objTrans)
    local bundSize = nil
    local bounds = nil
    if objTrans.gameObject:GetComponent("Renderer") then
        bundSize = objTrans.gameObject:GetComponent("Renderer").bounds.size
        bounds = objTrans.gameObject:GetComponent("Renderer").bounds
    else
        bundSize = objTrans:GetChild(0).gameObject:GetComponent("Renderer").bounds.size
        bounds = objTrans:GetChild(0).gameObject:GetComponent("Renderer").bounds
    end
    if bundSize == nil then
        logError("Check Object Renderer Compent")
        return
    end
    local maxSize = math.max(bundSize.x, bundSize.y, bundSize.z)

    local l_standScale = 1
    if maxSize > 0 then
        StandScale = 1.3 / maxSize
    else
        logError("maxSize == 0")
    end

    objTrans:SetLocalScale(l_standScale, l_standScale, l_standScale)
    objTrans:SetLocalPos(0, l_standScale / 2, 0)
end

function CalculateLowLevelTipsInfo(richTextCom, posCom, anchorePos)
    local l_richText = richTextCom:GetRichText()
    if l_richText == nil then
        return
    end
    richTextCom.UObj:SetActiveEx(false)
    l_richText.raycastTarget = true
    l_richText.isUseDefaultHrefColor = false
    l_richText.gameObject:SetActiveEx(true)
    l_richText.onHrefClick:RemoveAllListeners()
    l_richText.onHrefClick:AddListener(function(key)
        local l_hrefData = string.ro_split(key, '@@')
        if #l_hrefData >= 2 then
            if l_hrefData[1] == "MarkTips" then
                local l_pointEventData = {}
                l_pointEventData.position = Input.mousePosition
                local TxtTb = string.ro_split(Lang(l_hrefData[2]), '|')
                MgrMgr:GetMgr("TipsMgr").ShowMarkTips(TxtTb[1], TxtTb[2], l_pointEventData, anchorePos or Vector2(0.5, 0), MUIManager.UICamera, true)
            end
            if l_hrefData[1] == "MarkSkillTips" then
                if l_hrefData[2] and l_hrefData[3] then
                    MgrMgr:GetMgr("SkillLearningMgr").ShowSkillTip(tonumber(l_hrefData[2]), posCom and posCom.gameObject or richTextCom.gameObject, tonumber(l_hrefData[3]))
                end
            end
        end
    end)
end

function GetItemIsOrnament(itemTableData)
    if itemTableData == nil then
        return false
    end
    if itemTableData.Subclass == 103 or
            itemTableData.Subclass == 104 or
            itemTableData.Subclass == 105 or
            itemTableData.Subclass == 106 then
        return true
    end
    return false
end

--返回进击的恶魔的布置信息
function GetFightMonsterId()
    local l_table = TableUtil.GetEntrustActivitiesTable().GetTable()
    local l_monsterData = nil
    local l_sceneTb = {}
    local l_posTb = {}
    for i = 1, #l_table do
        if l_table[i].SystemID == 5060 then
            l_monsterData = l_table[i]
            break
        end
    end

    local l_sceneInfo = l_monsterData and l_monsterData.Position or {}
    for i = 1, l_sceneInfo.Length do
        local data = l_sceneInfo[i - 1]
        table.insert(l_sceneTb, data[0])
        table.insert(l_posTb, Vector3.New(data[1], data[2], data[3]))
    end
    return l_sceneTb, l_posTb
end

function OpenWheel()
    --目前分组机制造成没办法处理 所以在此特殊处理 提前关闭委托的分界面
    UIMgr:DeActiveUI(UI.CtrlNames.Emblem)
    UIMgr:ActiveUI(UI.CtrlNames.DelegatePanel, { Tab = 2 })
end

--是否是独一无二的类型的副本 就是副本表里面这种类型的副本只有一个
function IsStandAloneDungeons(dungeonsType)
    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    if dungeonsType == nil then
        return false
    end
    if dungeonsType == l_dungeonMgr.DungeonType.DungeonsBlackHouse or
            dungeonsType == l_dungeonMgr.DungeonType.DungeonAvoid or
            dungeonsType == l_dungeonMgr.DungeonType.DungeonBeach then
        return true
    end
    return false
end

local _string_format = StringEx.Format
--[Comment]
--生成图片文本信息
--@return <quad xxxxxx />
function GetImageText(sprite, atlas, size, width, anim)
    local l_s, l_w = tonumber(size) or 16, tonumber(width) or 1
    return _string_format("<quad spname={0} atname={1} size={2} width={3} anim={4}/>",
            sprite, atlas, l_s, l_w, tostring(anim or false))
end

--生成超链接
function GetRichText(textInfo, href, color, hrefText)
    if not color then
        color = "Blue"
    end
    return StringEx.Format("{0} <a href={1}><color=$${2}$$>{3}>></color></a>", textInfo, href, color, hrefText)
end

function GetCommonRichText(href,color,hrefText)
    if not color then
        color = "Blue"
    end
    return StringEx.Format(" <a href={0}><color=$${1}$$>{2}</color></a>", href, color, hrefText)
end

--itemData 道具的表数据
--href 超链接文本
--color 超链接的颜色
--物品的超链接的字符串获取
function GetItemHrefText(itemData, href, color)
    if itemData then
        local l_href = href or "ShowItemDetail" .. "|" .. itemData.ItemID
        local l_color = color or RoColorTag.Blue
        return StringEx.Format("<a href={0}>{1}</a>", l_href, GetColorText(itemData.ItemName, l_color))
    else
        return itemData.ItemName
    end
end

--在地图上加特效，nil为默认值，返回特效Id
function AddMapEffect(pos, effectName, size, scale, playTime, activeSmall, activeBig, removeOnCloseBigMap)
    local l_effectId = MapObjMgr:GetEffectId()
    local l_mapObjData = MapObjMgr:GetMapObjData()

    l_mapObjData.spName = effectName;
    if pos ~= nil then
        l_mapObjData.spPos = pos;
    end
    if activeSmall ~= nil then
        l_mapObjData.activeSmall = activeSmall
    end
    if activeBig ~= nil then
        l_mapObjData.activeBig = activeBig
    end
    if size ~= nil then
        l_mapObjData.size = size;
    end
    if scale ~= nil then
        l_mapObjData.scale = scale;
    end
    if playTime ~= nil then
        l_mapObjData.effectObj.playTime = playTime;
    end
    if removeOnCloseBigMap ~= nil then
        l_mapObjData.removeOnCloseBigMap = removeOnCloseBigMap;
    end
    MapObjMgr:AddEffect(l_effectId, l_mapObjData)
    return l_effectId
end
--移除地图上的特效
function RemoveMapEffect(effectId)
    MapObjMgr:RmEffect(effectId)
end
--在地图上加动态特效，nil为默认值(此处为举例，如果之后动效增多，直接赋值比较好)
function AddDynamicMapEffect(mapType, id, effectType, playMode, sourceValue, targetValue, playCount, loopTime)
    local l_dyObj = MapObjMgr:GetDynamicEffectObj()
    l_dyObj.effectType = effectType;
    l_dyObj.playMode = playMode
    if sourceValue ~= nil then
        if effectType == MoonClient.DynamicEffectType.Scale then
            l_dyObj.sourceScale = sourceValue
        elseif effectType == MoonClient.DynamicEffectType.Move then
            l_dyObj.sourcePos = sourceValue
        end
    end
    if targetValue ~= nil then
        if effectType == MoonClient.DynamicEffectType.Scale then
            l_dyObj.targetScale = targetValue
        elseif effectType == MoonClient.DynamicEffectType.Move then
            l_dyObj.targetPos = targetValue
        end
    end
    if playCount ~= nil then
        l_dyObj.playCount = playCount
    end
    if loopTime ~= nil then
        l_dyObj.loopTime = loopTime
    end
    MapObjMgr:AddDynamicEffect(mapType, id, l_dyObj)
end

function IsUIActive(uiName)
    return UIMgr:IsActiveUI(uiName)
end

--向GM便捷测试模块注册方法
function RegisterTestFunc(funcName, callback)
    MgrMgr:GetMgr("GmMgr").RegisterTestFunc(funcName, callback)
end

--向GM便捷测试模块推送日志信息
function AddTempInfo(infoStr)
    MgrMgr:GetMgr("GmMgr").AddTempInfo(infoStr)
end

--检测一个道具能否兑换头饰 锻造装备
--ItemExchangeOrnamentInfo = {}
ItemExchangeEquipInfo = {}
--IsFinishCheck = false
function CheckItemExcnageInfo( itemId )
    local b1 = ItemSwitchTable[itemId]
    local b2 = nil
    if ItemForgeTableWeapon[itemId] or ItemForgeTableArmor[itemId] then
        if not ItemExchangeEquipInfo[itemId] then
            local t = {}
            if ItemForgeTableWeapon[itemId] then
                table.ro_insertRange(t,ItemForgeTableWeapon[itemId])
            end
            if ItemForgeTableArmor[itemId] then
                table.ro_insertRange(t,ItemForgeTableArmor[itemId])
            end
            ItemExchangeEquipInfo[itemId] = t
        end
        b2 = ItemExchangeEquipInfo[itemId]
    end
    return b1,b2
--[[
    if IsFinishCheck then
        return ItemExchangeOrnamentInfo[itemId], ItemExchangeEquipInfo[itemId]
    end
    --头饰相关----------------------------
    local allOrnamentOrigin = TableUtil.GetOrnamentBarterTable().GetTable()
    for i = 1, #allOrnamentOrigin do
        local row = allOrnamentOrigin[i]
        if row.ItemCost then
            for i = 0, row.ItemCost.Length - 1 do
                if row.ItemCost[i] ~= nil then
                    local itemData = {
                        ["ItemId"] = row.ItemCost[i][0],
                        ["Count"] = row.ItemCost[i][1],
                    }
                    if ItemExchangeOrnamentInfo[itemData.ItemId] == nil then
                        ItemExchangeOrnamentInfo[itemData.ItemId] = {}
                    end
                    table.insert(ItemExchangeOrnamentInfo[itemData.ItemId], row.OrnamentID)
                end
            end
        end
    end
    --头饰相关------------------------------

    --装备相关------------------------------
    local allEquipOrigin = TableUtil.GetEquipForgeTable().GetTable()
    for i = 1, #allEquipOrigin do
        local row = allEquipOrigin[i]
        if row.ForgeMaterials then
            for i = 0, row.ForgeMaterials.Length - 1 do
                if row.ForgeMaterials[i] ~= nil then
                    local itemData = {
                        ["ItemId"] = row.ForgeMaterials[i][0],
                        ["Count"] = row.ForgeMaterials[i][1],
                    }
                    if ItemExchangeEquipInfo[itemData.ItemId] == nil then
                        ItemExchangeEquipInfo[itemData.ItemId] = {}
                    end
                    table.insert(ItemExchangeEquipInfo[itemData.ItemId], row.Id)
                end
            end
        end
    end
    --装备相关------------------------------
    IsFinishCheck = true
    return ItemExchangeOrnamentInfo[itemId] or {},ItemExchangeEquipInfo[itemId] or {}
    --]]
end

ItemExchangeVehicleInfo = {}
function GetVehicleExchangeInfo(itemId)
    if table.ro_size(ItemExchangeVehicleInfo) > 0 then
        return ItemExchangeVehicleInfo[itemId] or {}
    end

    --载具兑换相关----------------------------
    local l_vehicleTable = TableUtil.GetVehicleTable().GetTable()
    for i = 1, #l_vehicleTable do
        local row = l_vehicleTable[i]
        if row.ItemCost then
            for i = 0, row.ItemCost.Length - 1 do
                if row.ItemCost[i] ~= nil then
                    local itemData = {
                        ["ItemId"] = row.ItemCost[i][0],
                        ["Count"] = row.ItemCost[i][1],
                    }
                    if ItemExchangeVehicleInfo[itemData.ItemId] == nil then
                        ItemExchangeVehicleInfo[itemData.ItemId] = {}
                    end
                    table.insert(ItemExchangeVehicleInfo[itemData.ItemId], row.ID)
                end
            end
        end
    end
    return ItemExchangeVehicleInfo[itemId] or {}
end

function RefreshPlayerMenuLByUid(uid,relativeScreenPos,onlyChangePosY)
    local l_openData = {
        openType = DataMgr:GetData("TeamData").ETeamOpenType.RefreshHeadIconByUid,
        Uid = uid,
        relativeScreenPos = relativeScreenPos,
        onlyChangePosY = onlyChangePosY,
    }
    UIMgr:ActiveUI(UI.CtrlNames.PlayerMenuL, l_openData)
end
function SetDialogRichTextPropClickEvent(propId, eventPos)
    local l_extraData = {
        relativeScreenPosition = eventPos,
    }
    local l_itemData = Data.BagModel:CreateItemWithTid(propId)
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(l_itemData, nil, nil, nil, false, l_extraData)
end

---@Description:设置头像
---@param uid int64
---@param playerInfo playerInfo
---@param headParentCom MoonClient.MLuaUICom @Add 头像父对象，不能为nil
---@param professionCom MoonClient.MLuaUICom @Add 职业展示 可以为nil
---@param nameTxtCom MoonClient.MLuaUICom @Add 名字展示 可以为nil
function SetHeadInfo(uid, playerInfo, headParentCom, professionCom, nameTxtCom)
    --todo 64 equal
    logWarn("--todo 64 equal")
    local l_isSelf = MPlayerInfo.UID == uid
    if not l_isSelf and playerInfo == nil then
        logError("缺少必须的 playerInfo数据！")
        return
    end
    if MLuaCommonHelper.IsNull(headParentCom) then
        logError("headParentCom is null!")
        return
    end
    if not MLuaCommonHelper.IsNull(professionCom) then
        local l_profession = 0
        if l_isSelf then
            l_profession = MPlayerInfo.ProfessionId / 1000 * 1000
        else
            l_profession = playerInfo.type
        end
        local l_professionRow = TableUtil.GetProfessionTable().GetRowById(l_profession, false)
        if l_professionRow then
            professionCom:SetSpriteAsync("Common", l_professionRow.ProfessionIcon)
            professionCom:SetActiveEx(true)
        else
            professionCom:SetActiveEx(false)
        end
    end
    if not MLuaCommonHelper.IsNull(nameTxtCom) then
        if l_isSelf then
            nameTxtCom.LabText = MPlayerInfo.Name
        else
            nameTxtCom.LabText = playerInfo.name
        end
    end
    local l_headObj
    if headParentCom.Transform.childCount > 0 then
        l_headObj = headParentCom.Transform:GetChild(0)
    else
        l_headObj = MResLoader:CreateObjFromPool("UI/Prefabs/Head2D")
        l_headObj.transform:SetParent(headParentCom.Transform)
        l_headObj.transform:SetLocalPosZero()
        l_headObj.transform:SetLocalScaleOne()
        l_headObj.gameObject:SetActiveEx(true)
    end
    local l_head = l_headObj:GetComponent("MHeadBehaviour")
    if l_isSelf then
        MgrMgr:GetMgr("HeadImgMgr").SetHead2DByInfoAndHeadBehaviour(DataMgr:GetData("SelectRoleData").GetCurRoleInfo(), l_head)
    else
        if playerInfo.GetEquipData ~= nil then
            l_head:SetRoleHead(playerInfo:GetEquipData())
        end
    end
end

--获取屏幕内可以拖动的位置
--dragObjRectTrans 拖动物件的RectTransform
--targetPos 拖动的位置 一般为EventData.position
function GetScreenDragPos(dragObjRectTrans, targetPos)
    local l_xMax = dragObjRectTrans.sizeDelta.x
    local l_yMax = dragObjRectTrans.sizeDelta.y
    local l_startPosx = dragObjRectTrans.sizeDelta.x / 2
    local l_startPosy = dragObjRectTrans.sizeDelta.y / 2
    local l_screenRect = UnityEngine.Rect.New(l_startPosx, l_startPosy, Screen.width - l_xMax, Screen.height - l_yMax)
    if l_screenRect:Contains(targetPos) then
        return targetPos
    else
        --x和y都不满足条件
        if not l_screenRect:Contains(Vector2.New(l_startPosx, targetPos.y))
                and not l_screenRect:Contains(Vector2.New(targetPos.x, l_startPosy)) then
            local l_posY = 0
            local l_posX = 0
            if targetPos.y < l_startPosy then
                l_posY = l_startPosy
            elseif targetPos.y > Screen.height - l_startPosy then
                l_posY = Screen.height - l_startPosy
            end

            if targetPos.x < l_startPosx then
                l_posX = l_startPosx
            elseif targetPos.x > Screen.width - l_startPosx then
                l_posX = Screen.width - l_startPosx
            end
            return Vector2.New(l_posX, l_posY)
        end
        -- y不满足条件
        if not l_screenRect:Contains(Vector2.New(l_startPosx, targetPos.y)) then
            if targetPos.y < l_startPosy then
                return Vector2.New(targetPos.x, l_startPosy)
            elseif targetPos.y > Screen.height - l_startPosy then
                return Vector2.New(targetPos.x, Screen.height - l_startPosy)
            end
        end
        -- x不满足条件
        if not l_screenRect:Contains(Vector2.New(targetPos.x, l_startPosy)) then
            if targetPos.x < l_startPosx then
                return Vector2.New(l_startPosx, targetPos.y)
            elseif targetPos.x > Screen.width - l_startPosx then
                return Vector2.New(Screen.width - l_startPosx, targetPos.y)
            end
        end
    end
    return targetPos
end

--参数1 传要移动的Text的Mluauicom
--参数2 传遮挡Text的Mask2D的Go的Mluauicom
--参数3 是否重置位置 重置会从最右边开始移动 不重置则是当前
--参数4 是否循环
--参数5 停顿时间
function SetItemTemAnimation(txtGo,maskGo,isResetMove,isLoop,stopTime,waitTimer)
    LayoutRebuilder.ForceRebuildLayoutImmediate(txtGo.RectTransform)
    local l_textSize = txtGo.RectTransform.sizeDelta.x
    local l_maskSize = maskGo.RectTransform.sizeDelta.x
    local l_bNeedAnim = l_textSize > l_maskSize
    local l_animTween = nil
    local l_resetState = false
    local l_stopTime = stopTime or 3
    local finTime = math.random(1,l_stopTime)
    local l_timer = waitTimer or Timer.New(function()
        if l_animTween then
            l_animTween:DOPlay()
        end
    end,finTime)
    l_timer:Stop()
    if l_bNeedAnim then
        l_animTween = txtGo:GetComponent("DOTweenAnimation")
        local l_runSpeed = 25
        local l_moveDis = isResetMove and (-l_textSize - l_maskSize) or -l_textSize
        local l_duration = math.abs(l_moveDis) / l_runSpeed
        l_animTween:DOKill()
        l_animTween.duration = l_duration
        l_animTween.endValueV3 = Vector3.New(l_moveDis, 0, 0)
        if not MLuaCommonHelper.IsNull(l_animTween.onComplete) then
            l_animTween.onComplete:RemoveAllListeners()
            l_animTween.onComplete:AddListener(function()
                txtGo.gameObject:SetRectTransformPos(l_maskSize + l_textSize / 2, 0)
                if isLoop then
                    SetItemTemAnimation(txtGo,maskGo,true,true,stopTime,l_timer)
                end
            end)
        end
        if l_stopTime~= nil then
            if not MLuaCommonHelper.IsNull(l_animTween.onUpdate) then
                l_animTween.onUpdate:RemoveAllListeners()
                l_animTween.onUpdate:AddListener(function()
                    if not l_resetState then
                        local halfsize = txtGo.RectTransform.sizeDelta.x / 2
                        --if txtGo.RectTransform.anchoredPosition.x <= 0 then
                        if txtGo.RectTransform.anchoredPosition.x <= halfsize then
                            l_animTween:DOPause()
                            if l_timer then 
                                l_timer:Start() 
                            end
                            l_resetState = true
                        end
                    end
                end)
            end
        end
        l_animTween:CreateTween()
        l_animTween:DORestart()
    end
    --清除
    return l_animTween, l_timer
end

--Ro用HttpKey
function GetHttpSignAndTimeAndUrl()
    local str_time = tostring(MServerTimeMgr.UtcSeconds)
    local str_md5 = str_time .. g_Globals.HTTP_KEY
    local str_sign = string.upper(MCommonFunctions.EncryptWithMD5(str_md5))
    return str_sign, str_time, MPlatformConfigManager.GetLocal().apiDomain
end

-- 是否在大厅
function IsInHallScene(sceneId)
    local l_sceneRow = TableUtil.GetSceneTable().GetRowByID(sceneId)
    if l_sceneRow and l_sceneRow.SceneType == 1 then
        return true
    end
    return false
end

function SetSpriteByItemId(luaCom,itemId)
    if luaCom == nil or itemId == nil then
        return
    end
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if not l_itemData then
        return
    end
    luaCom:SetSprite(l_itemData.ItemAtlas,l_itemData.ItemIcon)
end

-- 道具不足返回一个道具不足的Text
function ShowCoinStatusText(coinId, showNum)
    local l_haveCount = Data.BagModel:GetCoinOrPropNumById(coinId)
    local l_showNum = tonumber(showNum)
    local l_consumePropEnough = false --数量是否充足
    if l_haveCount and  l_showNum and l_haveCount >= l_showNum then
        l_consumePropEnough = true
    end
    if not l_consumePropEnough then
        local l_text = RoColor.GetTextWithDefineColor(l_showNum,RoColor.UIDefineColorValue.WaringColor)
        return l_text,l_showNum-l_haveCount
    end
    return l_showNum,l_showNum-l_haveCount
end


-- 获取折扣通用显示文本 discount为1相当于是1折
function GetDiscountFormat(discount)
    if g_Globals.IsKorea then
        return Lang("Mall_Discount_Korea", 100 - discount * 10.0) -- {0}%折扣
    else
        return StringEx.Format(Lang("Mall_Discount"), discount)--"{0:.#}折"
    end
end

---@Description:将C#的枚举值转化为int类型
---@param enumValue userdata
function ChangeEnumValueToNumber(enumValue)
    if type(enumValue)=="userdata" then
        return enumValue:GetHashCode()
    end
    return tonumber(enumValue)
end

--------------------------------寻路请求服务器请求时限单独维护---------------------------------------------
--寻路超时计时器
local l_navigateTimer = nil

--寻路请求倒计时开始
function ReqNavigateStartCountDown( ... )
    --已有计时器直接返回
    if l_navigateTimer then
        return
    end
    --创建计时器  默认写死一秒超时
    l_navigateTimer = Timer.New(function ()
        --超时则关闭界面
        game:ShowMainPanel()
        --关闭计时器
        if l_navigateTimer then
            l_navigateTimer:Stop()
            l_navigateTimer = nil
        end
    end, 1, -1, false)
    l_navigateTimer:Start()
end

--获取服务器寻路请求的结果
function GetNavigateResult(eventType, result)
    --收到导航消息停止超时判断计时器
    if l_navigateTimer then
        l_navigateTimer:Stop()
        l_navigateTimer = nil
        --如果接收到的导航结果为成功则关闭界面
        if result then
            game:ShowMainPanel()
        end
    end
    
end

----------------------------------END 寻路请求服务器请求时限单独维护-----------------------------------------

return Common.CommonUIFunc