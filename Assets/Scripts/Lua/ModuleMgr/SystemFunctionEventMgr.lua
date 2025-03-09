---@module ModuleMgr.SystemFunctionEventMgr
module("ModuleMgr.SystemFunctionEventMgr", package.seeall)
require "Data/Model/BagModel"

local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")

--todo mx 走配置
--获取途径里面有些功能点击不能走默认方法
--使用用户自定义方法的FuncId Table
useCustomMethodFuncTb = {
    l_openSystemMgr.eSystemId.Barber, -- 1080 头饰商店 打开头饰商店 并选中对应的选项 接口由罗中杰提供
    l_openSystemMgr.eSystemId.Trade, -- 11001 商会 接口由胡胜提供
    l_openSystemMgr.eSystemId.Stall, -- 11002 摆摊 接口由胡胜提供
    l_openSystemMgr.eSystemId.MonsterExpel, --5110 魔物驱逐 接口由胡胜提供
    l_openSystemMgr.eSystemId.Wabao, -- 5060 进击的恶魔 接口由xx提供
    l_openSystemMgr.eSystemId.HsMonster, --5050 圣歌试炼 走到Npc面前和Npc聊天
    l_openSystemMgr.eSystemId.RecoveCard, --3090卡片分解
    l_openSystemMgr.eSystemId.ExtractCard, -- 3091 卡片抽卡
    l_openSystemMgr.eSystemId.RecoveHead, -- 3092 头饰分解
    l_openSystemMgr.eSystemId.ExtractHead, -- 3093 头饰抽取
    l_openSystemMgr.eSystemId.RecoveEquip, -- 3097 装备分解
    l_openSystemMgr.eSystemId.ExtractEquip, -- 3098 装备抽取
    l_openSystemMgr.eSystemId.forgeWeapon, -- 3094 武器打造
    l_openSystemMgr.eSystemId.forgeArmor, -- 3095防具打造
    l_openSystemMgr.eSystemId.ThemeParty, --2001主题派对
}

--todo mx 走配置
--获取途径预判断逻辑 有些需要预先判断
customPreCheck = {
    [l_openSystemMgr.eSystemId.forgeWeapon] = function(preCheckId)
        return MgrMgr:GetMgr("ForgeMgr").IsEquipCanShow(preCheckId)
    end, -- 3094 武器打造
    [l_openSystemMgr.eSystemId.forgeArmor] = function(preCheckId)
        return MgrMgr:GetMgr("ForgeMgr").IsEquipCanShow(preCheckId)
    end, -- 3095防具打造
}

battleFieldActivityId = 7 -- 战场活动id
function NpcJudgeSystemFunctionEvent(id)
    local tableData = TableUtil.GetOpenSystemTable().GetRowById(id)
    local functionName = GetFunctionName(tableData, 2)
    local event = ModuleMgr.SystemFunctionEventMgr[functionName]
    if functionName ~= nil and event ~= nil then
        return event(tableData, param, npcId)
    end
    return true
end
function GetSystemFunctionEvent(id)
    local tableData = TableUtil.GetOpenSystemTable().GetRowById(id)
    local functionName = GetFunctionName(tableData)
    local event = ModuleMgr.SystemFunctionEventMgr[functionName]
    if functionName == nil or event == nil then
        logError("未配置相应的功能事件 Id为 " .. tostring(id))
        return nil
    else
        return function(param, npcId)
            local l_openSystem = MgrMgr:GetMgr("OpenSystemMgr")
            if not l_openSystem.IsSystemOpen(id) then
                if id == l_openSystem.eSystemId.NewPlayer then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEW_PLAYER_CLOSE"))
                    return
                end
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SystemNotOpened", tableData.Title))
                return
            end

            --部分功能需要跳过NPC交互直接打开界面 但有需要获取对话触发的NPC的ID 所以增加npcId参数
            event(tableData, param, npcId)
        end
    end
end
function IsHaveSystemFunctionEvent(id)
    local tableData = TableUtil.GetOpenSystemTable().GetRowById(id)
    if tableData == nil then
        return false
    end
    local functionName = GetFunctionName(tableData)
    if functionName == nil then
        return false
    end
    local event = ModuleMgr.SystemFunctionEventMgr[functionName]
    if event == nil then
        return false
    end

    return true
end
--得到功能名字，默认为功能函数，第二个参数传2则为npc对话框判定函数
function GetFunctionName(tableData, type)
    if tableData == nil then
        return nil
    end
    if type == nil then
        type = 1
    end
    local h = tableData.FunctionOrder
    if type == 2 then
        h = tableData.NpcJudgeFunction
    end
    local FunctionOrder = Common.Functions.VectorToTable(h)
    return FunctionOrder[1]
end

--预注册登录换装
function LetsDressUp()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.CreateChar)
end
---主题副本
function ThemeDungeonEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.ThemeDungeonArround)
end

--伊甸园黑板
function EdenTaskEvent(tableData)
    -- MgrMgr:GetMgr("EdenTaskMgr").RequestEdenTask()
end

--成就
function OpenAchievementEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("AchievementMgr").OnAchievementButton()
end

-- 黑市
function OpenBlackShop(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ShopMgr").OpenBlackShop()
end

-- 理发店
function BarberShopEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.IsPassenger then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ISPASSENGER_BABAR_LIMIT"))
        return
    end
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MPlayerInfo:FocusOffSetView(1)
    UIMgr:ActiveUI(UI.CtrlNames.BarberShop)
    MEntityMgr.HideNpcAndRole = true
end

function OpenBGMRoomEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("BGMHouseMgr").OpenBGMHousePlayerWithAllMusic()
end

function ShowRoleInfoEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("RoleInfoMgr").OnShowRoleInfo()
end

-- 美容院
function BeautyShopEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.IsPassenger then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ISPASSENGER_BEATUTY_LIMIT"))
        return
    end
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MPlayerInfo:FocusOffSetView(2)
    UIMgr:ActiveUI(UI.CtrlNames.BeautyShop)
    MEntityMgr.HideNpcAndRole = true
end

--道具商店
function PropertyShopEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local h = tableData.FunctionOrder
    local FunctionOrder = Common.Functions.VectorToTable(h)
    MgrMgr:GetMgr("ShopMgr").OpenBuyShop(tonumber(FunctionOrder[2]))
end

--工会商店
function PropertyGuildShopEvent(tableData)

    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_guildData = DataMgr:GetData("GuildData")
    local l_guildShopInfo = l_guildData.GetGuildBuildInfo(l_guildData.EBuildingType.SaleMechine)
    local l_guildShopLevel = l_guildShopInfo and l_guildShopInfo.level or 0

    if l_guildBuildingLevel == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantOpenGuildShopText"))
        return
    end

    local h = tableData.FunctionOrder
    local FunctionOrder = Common.Functions.VectorToTable(h)
    MgrMgr:GetMgr("ShopMgr").OpenBuyShop(tonumber(FunctionOrder[2]))
end
--出售
function ShopSellEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()

    local h = tableData.FunctionOrder
    local shop_id = 0
    if h and h.Length >= 2 then
        shop_id = tonumber(h:get_Item(1)) or 0
    end

    MgrMgr:GetMgr("ShopMgr").OpenSellShop(shop_id)
end

--无限塔
function InfiniteTowerEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.InfinityTower)
end

function OpenCapraFAQEvent()
    UIMgr:ActiveUI(UI.CtrlNames.CapraFAQ)
end

--无限塔介绍
function InfiniteTowerInfoEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.NPCInstructions, function(ctrl)
        ctrl:InitWithContent(Lang("INFINITE_TOWER_INFO_TIPS_TITLE"), Lang("INFINITE_TOWER_INFO_TIPS"))
    end)
end

--去迷雾岛
function GotoTowerEntrance(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_npcId = MGlobalConfig:GetInt("NpcToIzlude")
    local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(l_npcId)
    if sceneIdTb[1] ~= nil then
        l_npcId = MGlobalConfig:GetInt("NpcToMistyIsland")
        Common.CommonUIFunc.GoDirTeleport(sceneIdTb[1], l_npcId)
    end
end

--从迷雾岛返回
function LeaveTowerEntrance(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_npcId = MGlobalConfig:GetInt("NpcToMistyIsland")
    local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(l_npcId)
    if sceneIdTb[1] ~= nil then
        l_npcId = MGlobalConfig:GetInt("NpcToIzlude")
        Common.CommonUIFunc.GoDirTeleport(sceneIdTb[1], l_npcId)
    end
end

--取消
function CancelEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
end

function OpenGameTips(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local h = tableData.FunctionOrder
    local FunctionOrder = Common.Functions.VectorToTable(h)
    local l_tipsID = tonumber(FunctionOrder[2])
    if l_tipsID then
        UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
            ctrl:ShowPanel(l_tipsID)
        end)
    end
end

function EnterTaskEvent(taskID, callBack, args)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local data = MgrMgr:GetMgr("DelegateModuleMgr").GetDelegateByTaskId(taskID)
    if data then
        local l_target = data.sdata
        local l_name = ""
        local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_target.DungeonID, true)
        if l_dungeonData then
            l_name = l_dungeonData.DungeonsName
        end
        local l_count = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Certificates)
        local l_cost = l_target.Cost[0][1]
        if l_cost <= l_count then
            local l_key = "DELEGATE_ENTER_DUNGEON"
            local l_conentent = l_target.ConfirmTips ..
                    StringEx.Format(Common.Utils.Lang("DELEGATE_ENTER_DUNGEON"), l_name, l_cost)
            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_conentent, function()
                if callBack then
                    callBack(args)
                end
            end, nil, nil, 0, l_key, nil, nil, nil, UnityEngine.TextAnchor.UpperLeft)
        else
            local l_key = "DELEGATE_ENTER_DUNGEON_NOT"
            local l_conentent = StringEx.Format(Common.Utils.Lang("DELEGATE_ENTER_DUNGEON_NOT"), l_cost)
            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_conentent, function()
                if callBack then
                    callBack(args)
                end
            end, nil, nil, 0, l_key, nil, nil, nil, UnityEngine.TextAnchor.UpperLeft)
        end
        return
    end
    if callBack then
        callBack(args)
    end
end

--进入副本
function EnterDungeonEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local h = tableData.FunctionOrder
    local FunctionOrder = Common.Functions.VectorToTable(h)
    local l_dungeonID = tonumber(FunctionOrder[2])
    local l_target = nil
    local l_rows = TableUtil.GetEntrustActivitiesTable().GetTable()
    local l_rowCount = #l_rows
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        if l_row.DungeonID and l_row.DungeonID > 0 and l_row.DungeonID == l_dungeonID then
            l_target = l_row
            break
        end
    end
    local l_hasTeam = table.ro_size(DataMgr:GetData("TeamData").myTeamInfo.memberList) > 0
    if l_target and not l_hasTeam then
        local l_isfinish = MgrMgr:GetMgr("DelegateModuleMgr").IsDelegateFinish(l_target.MajorID)
        if l_isfinish then
            local l_key = "DELEGATE_ENTER_DUNGEON_FINISH"
            local l_conentent = Common.Utils.Lang("DELEGATE_ENTER_DUNGEON_FINISH")
            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_conentent, function()
                MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_dungeonID, 0, 0)
            end, nil, nil, 0, l_key, nil, nil, nil, nil)
            return
        end
        local l_name = ""
        local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_target.DungeonID)
        if l_dungeonData then
            l_name = l_dungeonData.DungeonsName
        end
        local l_count = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Certificates)
        local l_cost = l_target.Cost[0][1]
        if l_cost <= l_count then
            local l_key = "DELEGATE_ENTER_DUNGEON"
            local l_conentent = l_target.ConfirmTips ..
                    StringEx.Format(Common.Utils.Lang("DELEGATE_ENTER_DUNGEON"), l_name, l_cost)
            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_conentent, function()
                MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_dungeonID, 0, 0)
            end, nil, nil, 0, l_key, nil, nil, nil, UnityEngine.TextAnchor.UpperLeft)
        else
            local l_key = "DELEGATE_ENTER_DUNGEON_NOT"
            local l_conentent = StringEx.Format(Common.Utils.Lang("DELEGATE_ENTER_DUNGEON_NOT"), l_cost)
            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_conentent, function()
                MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_dungeonID, 0, 0)
            end, nil, nil, 0, l_key, nil, nil, nil, UnityEngine.TextAnchor.UpperLeft)
        end
        return
    end
    MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_dungeonID, 0, 0)
end

--打开世界地图
function OpenWorldMapEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.WorldMap)
end

--改名
function ModifyNameEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    -- body
    UIMgr:ActiveUI(UI.CtrlNames.ModifyCharacterName)
end

--兑换邀请函
function ExchangePartyLetter()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ThemePartyMgr").GetThemePartyInvitation()
end

--进入主题舞会
function EnterThemeParty()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ThemePartyMgr").EnterToThemePartyScene()
end

--派对说明
function ShowThemePartyInfo()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_skillData = {
        openType = DataMgr:GetData("CommonIntroduceData").OpenType.InitInfoAndNpc,
        title = Lang(TableUtil.GetThemePartyTable().GetRowBySetting("PartyInfoTitle").Value),
        info = Lang(TableUtil.GetThemePartyTable().GetRowBySetting("PartyInfoMainTxt").Value),
        altas = "Icon01",
        icon = "UI_Icon_Gonghuiyanhui.png"
    }
    UIMgr:ActiveUI(UI.CtrlNames.CommonIntroduce, l_skillData)
end

--塔防入口说明
function ShowTowerDefenseEntranceInfo()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_TDData1 = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TowerDefenseSingle)
    local l_TDData2 = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TowdrDefenseEntrance)
    if l_TDData1 and l_TDData2 then
        local l_towerDefenseData = {
            openType = DataMgr:GetData("CommonIntroduceData").OpenType.InitInfoAndNpc,
            title = l_TDData1.Title,
            info = Common.Utils.Lang("TD_INFO_TIP"),
            altas = l_TDData2.SystemAtlas,
            icon = l_TDData2.SystemIcon
        }
        UIMgr:ActiveUI(UI.CtrlNames.CommonIntroduce, l_towerDefenseData)
    end
end

--打开公会狩猎
function OpenGuildHuntInfoEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.GuildHuntInfo)
end

--公会匹配赛参赛队伍报名
function GuildMatchApply()
    local l_mgr = MgrMgr:GetMgr("GuildMatchMgr")
    local systemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_guildMatchData = DataMgr:GetData("GuildMatchData")
    if l_mgr and systemMgr.IsSystemOpen(l_guildMatchData.SystemOpen) then
        l_mgr.GuildBattleTeamApply(1)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("BAG_TIP_NO_FUNCTION")))
    end
end

--公会匹配赛啦啦队伍报名
function GuildMatchCheerApply()
    local l_mgr = MgrMgr:GetMgr("GuildMatchMgr")
    local systemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_guildMatchData = DataMgr:GetData("GuildMatchData")
    if l_mgr and systemMgr.IsSystemOpen(l_guildMatchData.SystemOpen) and systemMgr.IsSystemOpen(l_guildMatchData.SystemForLaLa) then
        l_mgr.GuildBattleTeamApply(2)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("BAG_TIP_NO_FUNCTION")))
    end
end

--公会匹配赛管理对话框是否出现
function CheckGuildMatchMgr()
    local taskMgr = MgrMgr:GetMgr("GuildMatchMgr")
    local systemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    ---@type ModuleData.GuildData
    local l_guildData = DataMgr:GetData("GuildData")
    local l_guildMatchData = DataMgr:GetData("GuildMatchData")
    local judge = true
    judge = judge and taskMgr.IsActivityOpend()
    judge = judge and (l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen or
            l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.ViceChairman)
    judge = judge and systemMgr.IsSystemOpen(l_guildMatchData.SystemForTeam)
    judge = judge and systemMgr.IsSystemOpen(l_guildMatchData.SystemOpen)
    return judge
end

function GuildMatchTeamMgr()
    MgrMgr:GetMgr("GuildMatchMgr").GetGuildBattleMgrTeamInfo()
end
--进入公会匹配赛等候区
function GuildMatchEnter()

    local systemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_guildMatchData = DataMgr:GetData("GuildMatchData")
    if systemMgr.IsSystemOpen(l_guildMatchData.SystemOpen) and systemMgr.IsSystemOpen(l_guildMatchData.SystemForEnter) then
        local l_msgId = Network.Define.Rpc.EnterGuildMatchWaitingRoomRequest
        ---@type EnterGuildMatchWaitingRoomRequestArg
        local l_sendInfo = GetProtoBufSendTable("EnterGuildMatchWaitingRoomRequestArg")
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("BAG_TIP_NO_FUNCTION")))
    end

end
--公会匹配赛说明
function ShowGuildMatchInfo()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_openTable = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.GuildHunt)
    local l_guildMatchData = {
        openType = DataMgr:GetData("CommonIntroduceData").OpenType.InitInfoAndNpc,
        title = Lang("GUILDMATCH_INFO_TITLE"),
        info = Lang("GUILDMATCH_INFO_MAINTXT"),
        altas = l_openTable.SystemAtlas,
        icon = l_openTable.SystemIcon
    }
    UIMgr:ActiveUI(UI.CtrlNames.CommonIntroduce, l_guildMatchData)
end

--公会狩猎说明
function ShowGuildHuntInfo()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_openTable = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.GuildHunt)
    local l_skillData = {
        openType = DataMgr:GetData("CommonIntroduceData").OpenType.InitInfoAndNpc,
        title = Lang("GUILDHUNT_INFO_TITLE"),
        info = Lang("GUILDHUNT_INFO_MAINTXT"),
        altas = l_openTable.SystemAtlas,
        icon = l_openTable.SystemIcon
    }
    UIMgr:ActiveUI(UI.CtrlNames.CommonIntroduce, l_skillData)
end

function SkillEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.SkillLearning)
end

function JobPreviewEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.JobPreview)
end

function OpenFestivalActivity()
    local l_mgr = MgrMgr:GetMgr("FestivalMgr")
    local l_data = DataMgr:GetData("FestivalData")
    l_data.UpdateFestival()
    if l_data.Festival and #l_data.Festival > 0 then
        UIMgr:ActiveUI(UI.CtrlNames.Festival)
    else
        l_mgr.SendBackstageAct()            --如果没有缓存向服务器请求
    end
end

function SetupEvent(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if param == nil then
        UIMgr:ActiveUI(UI.CtrlNames.Setting)
    else
        UIMgr:ActiveUI(UI.CtrlNames.Setting, { selectId = tonumber(param[1]) })
    end

end

function OpenBagEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Normal)
    UIMgr:ActiveUI(UI.CtrlNames.Bag)
end

function OpenVehicleEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if not MgrMgr:GetMgr("VehicleInfoMgr").CanOpenVehiclePanel() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("OPEN_VEHICLE_CONDITION"))
        return
    end
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if tableData.Id == l_openSysMgr.eSystemId.VehicleAbility then
        UIMgr:ActiveUI(UI.CtrlNames.VehiclesBG, {
            selectPanel = UI.CtrlNames.VehiclesOccupation,
        })
    elseif tableData.Id == l_openSysMgr.eSystemId.VehicleQuality then
        UIMgr:ActiveUI(UI.CtrlNames.VehiclesBG, {
            selectPanel = UI.CtrlNames.VehiclesCharacteristic,
        })
    else
        UIMgr:ActiveUI(UI.CtrlNames.VehiclesBG)
    end

end

function OpenCommunityURL(tableData)
    if game:GetAuthMgr().AuthData.GetCurLoginType() == GameEnum.EJoyyouLoginType.JoyyouGuest then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("Tourist_Can_Not_Go_Community_Tip"), function()
            MgrMgr:GetMgr("BindAccountMgr").LogoutToGameOpenBindAccountUI()
        end)
        return
    end
    local CommunityURL = MGlobalConfig:GetString("CommunityURL")
    local url = CommunityURL .. "CommunityAccount/Sso?token=" .. DataMgr:GetData("AuthData").GetAccountInfo().token
    url = url .. "&server=" .. game:GetAuthMgr().AuthData.GetCurGateServer().serverid
    url = url .. "&url=" .. CommunityURL
    --MLogin.OpenURL(CJson.encode({ url = url }))
    Application.OpenURL(url)
end

function OpenMvpPanel(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.DailyTask, {
        distinationActivityId = MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_Mvp
    })
end

function OnBtnOpenActivityNewKing()
    UIMgr:ActiveUI(UI.CtrlNames.ActivityNewKing)
end

function CameraEvent(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MEntityMgr.PlayerEntity.IsDead then
        return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DEAD_NO_USE"))
    end

    if param == nil then
        UIMgr:ActiveUI(UI.CtrlNames.Photograph)
    else
        local l_msg = string.ro_split(param, "|")
        local l_photoType = l_msg[1]
        local l_targetPos = l_msg[2]
        if string.ro_isEmpty(l_photoType) then
            l_photoType = "Photo"
        end
        if l_photoType ~= "Photo" and l_photoType ~= "SelfPhoto" and l_photoType ~= "VR360Photo" and l_photoType ~= "ARPhoto" then
            logError("不存在照相类型为 " .. tostring(l_photoType) .. "的情况！！！ 可用的情况只有 Photo SelfPhoto VR360Photo ARPhoto")
            return
        end
        local l_photograph_ui = UIMgr:GetUI(UI.CtrlNames.Photograph)
        if l_photograph_ui == nil or not l_photograph_ui.isActive then
            local l_photoData = {
                openType = DataMgr:GetData("FashionData").EUIOpenType.SPECIAL_PHOTO,
                targetPos = l_targetPos,
                photoType = l_photoType
            }
            UIMgr:ActiveUI(UI.CtrlNames.Photograph, { [UI.CtrlNames.Photograph] = l_photoData })
        else
            l_photograph_ui:SetCameraType(l_photoType)
            if l_targetPos ~= nil then
                if l_photoType == "VR360Photo" then
                    local l_timer = Timer.New(function(b)
                        MEventMgr:LuaFireEvent(MEventType.MEvent_CamPhotoTarget, MScene.GameCamera, l_targetPos)
                    end, 0.05)
                    l_timer:Start()
                else
                    local l_timer = Timer.New(function(b)
                        local l_vector = string.ro_split(l_targetPos, ",")
                        if #l_vector == 2 then
                            MEventMgr:LuaFireEvent(MEventType.MEvent_CamPhotoRot, MScene.GameCamera, l_vector[1], l_vector[2], true)
                        else
                            logError("拍照参数数量错误！！位置参数只能有两个！！分别代表X与Y轴的旋转 当前为:" .. l_targetPos)
                        end
                    end, 0.05)
                    l_timer:Start()
                end
            end
        end
    end
end

function ShowOpenDinnerWishDialog()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("GuildDinnerMgr").ShowOpenDinnerWishDialog()
end

function OpenCamera(param)
    -- body
end

function AlbumEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.Album)
end
function GarderobeEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.Garderobe)
end
function ActivityEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.DailyTask)
end
function RiskEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("DailyTaskMgr").OpenDailyTask()
end

function EquipCardForgeEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.EquipElevate, function(ctrl)
        ctrl:SelectOneHandler("EquipCardForge")
    end)
end

function RefineEvent(tableData, param, npcId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if npcId then
        MgrMgr:GetMgr("NpcMgr").CurrentNpcId = npcId
    end

    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.Refine)
end

function OpenTradePanel()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MgrMgr:GetMgr("RedSignMgr").IsRedSignShow(eRedSignKey.Stall) then
        MgrMgr:GetMgr("SweaterMgr").OpenSellSweater(MgrMgr:GetMgr("SweaterMgr").ESweaterType.Stall, nil)
        return
    end
    MgrMgr:GetMgr("SweaterMgr").OpenSweater(nil)
end

--拍卖榜
function OpenAuctionPanel()
    UIMgr:ActiveUI(UI.CtrlNames.Sweater, { openSweaterType = MgrMgr:GetMgr("SweaterMgr").ESweaterType.Auction })
end

function JoinBattle()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_teamInfo = DataMgr:GetData("TeamData").myTeamInfo
    if l_teamInfo.isInTeam then
        for i = 1, #l_teamInfo.memberList do
            local l_targetLevel = l_teamInfo.memberList[i].roleLevel
            if not MgrMgr:GetMgr("BattleMgr").CanMatchingLevelSection(l_targetLevel) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BattleHintJoinLevelSection"))--存在活动等级区间不匹配的队友,无法进入
                return
            end
        end
    end
    local l_msgId = Network.Define.Rpc.BattlefieldApply
    ---@type PVPApplyArg
    local l_sendInfo = GetProtoBufSendTable("PVPApplyArg")
    l_sendInfo.type = MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_Battle
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OpenGuildEvent(data, type)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("GuildMgr").OpenGuild(type)
end

function OpenGuildUpgradeEvent()
    --公会升级界面打开
    local curNpcId = MgrMgr:GetMgr("NpcMgr").GetCurrentNpcId()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_openData = {
        type = DataMgr:GetData("GuildData").EUIOpenType.GuildUpgrade,
        npcId = curNpcId
    }
    UIMgr:ActiveUI(UI.CtrlNames.GuildUpgrade, l_openData)

end

function OpenGuildCrystalEvent()

    local l_openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openMgr.IsSystemOpen(l_openMgr.eSystemId.GuildCrystal) then
        return
    end
    --公会华丽水晶界面打开
    local l_guildData = DataMgr:GetData("GuildData")
    local l_guildCrystalData = l_guildData.GetGuildBuildInfo(l_guildData.EBuildingType.Crystal)
    local l_guildCrystalLevel = l_guildCrystalData and l_guildCrystalData.level or 0

    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if l_guildCrystalLevel > 0 then
        UIMgr:ActiveUI(UI.CtrlNames.GuildCrystal)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CRYSTAL_USE_LIMIT"))
    end
end

function OpenGuildHuntFromNpcEvent()
    --公会狩猎界面打开(NPC对话)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.GuildHuntInfo)
end

--载具兑换打开
function OpenVehicleBarterEvent(_, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.VehicleShop, function(ctrl)
        ctrl:SetDefaultItem(param)
    end)
end

function OpenOrnamentBarterEvent(_, npcId, ornamentId)
    if not npcId then
        require("Command/CommandMacro")
        npcId = CommandMacro.NPCId()
    end

    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.HeadShop, { npcId = npcId, ornamentId = ornamentId })
end

--圣歌试炼打开
function HymnTrialOpenEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.HymnTrialEnter)
end

--波利团图鉴打开
function BoliIllustrationOpenEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("BoliGroupMgr").ShowBoliIllustration()
end

--卡普拉仓库
function OpenPotEvent()
    if UIMgr:IsPanelShowing(UI.CtrlNames.Shop) then
        UIMgr:DeActiveUI(UI.CtrlNames.Shop)
    end

    if UIMgr:IsPanelShowing(UI.CtrlNames.Bag) then
        local gameEventMgr = MgrProxy:GetGameEventMgr()
        gameEventMgr.RaiseEvent(gameEventMgr.OnOpenWareHousePage)
        return
    end

    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Pot)
    UIMgr:ActiveUI(UI.CtrlNames.Bag)
end

function SevenDayAwardEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.LandingAward)
end

function OpenReturnActivity()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.ReBack)
end

function OpenNewPlayerBox()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.NewPlayer)
end
-- 兑换码
function OpenCDKey()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.ExchangecodeDialog)
end

--生活技能
function LifeSkillEvent(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if param and table.ro_size(param)>0 then
        local l_openUIData = {
            classID = tonumber(param[1]),
        }
        UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionMain, l_openUIData)
    else
        UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionMain)
    end
    UserDataManager.SetDataFromLua("LifeProfessionRedRot", MPlayerSetting.PLAYER_SETTING_GROUP, "false")
end

--卡普拉存储点
function KplSavePointEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("KplFunctionMgr").RequestSaveReviveRecord(MScene.SceneID)
end

--挖宝导航用空方法
function DigTreasureEvent()
    -- body
end

--MVP界面
function OpenMvpEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.MvpPanel)
end

-- 天地树守卫战
function OpenTowerDefense()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TowerDefenseSingle) or
            MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TowerDefenseDouble) then
        MgrMgr:GetMgr("TowerDefenseMgr").OpenTowerDefenseEntrance()
    else
        local tableData = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TowerDefenseSingle)
        if tableData then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("EXTRACT_CARD_OPEN"), tableData.BaseLevel))
        end
    end
end

--卡片抽取
function ExtractCardEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractCard) then
        MgrMgr:GetMgr("MagicExtractMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicExtractMachineMgr").EMagicExtractMachineType.Card
        MgrMgr:GetMgr("MagicExtractMachineMgr").OpenExtractCardPanel()
    else
        local tableData = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractCard)
        if tableData then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("EXTRACT_MACHINE_OPEN"), tableData.BaseLevel))
        end
    end
end

--卡片分解
function RecoveCardEvent()

    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveCard) then
        MgrMgr:GetMgr("MagicRecoveMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicRecoveMachineMgr").EMagicRecoveMachineType.Card
        UIMgr:ActiveUI(UI.CtrlNames.MagicRecoveMachine)
    end
end

--头饰抽取
function ExtractHeadWearEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractHead) then
        MgrMgr:GetMgr("MagicExtractMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicExtractMachineMgr").EMagicExtractMachineType.HeadWear
        MgrMgr:GetMgr("MagicExtractMachineMgr").ReqExtractPreview()
    else
        local tableData = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractHead)
        if tableData then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("EXTRACT_MACHINE_OPEN"), tableData.BaseLevel))
        end
    end
end

--头饰分解
function RecoveHeadWearEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveHead) then
        MgrMgr:GetMgr("MagicRecoveMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicRecoveMachineMgr").EMagicRecoveMachineType.HeadWear
        UIMgr:ActiveUI(UI.CtrlNames.MagicRecoveMachine)
    end
end

-- 装备抽取
function ExtractEquipEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractEquip) then
        MgrMgr:GetMgr("MagicExtractMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicExtractMachineMgr").EMagicExtractMachineType.Equip
        MgrMgr:GetMgr("MagicExtractMachineMgr").OpenExtractEquipPanel()
    else
        local tableData = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractEquip)
        if tableData then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("EXTRACT_MACHINE_OPEN"), tableData.BaseLevel))
        end
    end
end

-- 装备分解
function RecoveEquipEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveEquip) then
        MgrMgr:GetMgr("MagicRecoveMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicRecoveMachineMgr").EMagicRecoveMachineType.Equip
        UIMgr:ActiveUI(UI.CtrlNames.MagicRecoveMachine)
    end
end


--问卷调查
function OpenQuestionnaireMethod()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_url
    if MGameContext.IsAndroid or MGameContext.IsUnityEditorOrPC then
        l_url = MGlobalConfig:GetString("QuestionAndroidUrl", "0")
    else
        l_url = MGlobalConfig:GetString("QuestionIOSUrl", "0")
    end

    if l_url == nil or l_url == "0" then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NotOpened"))
        return
    end

    --MLogin.OpenURL(CJson.encode({ url = l_url }))
    Application.OpenURL(l_url)
end

--图鉴
function OpenIllustrationEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.IllustrationPandect)
end

function OpenCardIllustrationByEquipmentPart(equipPart)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if openMgr.IsSystemOpen(openMgr.eSystemId.IllustratorCard) then
        local illusMgr = MgrMgr:GetMgr("IllustrationMgr")
        local l_openData = {
            openType = illusMgr.OpenType.SelectEquipPart,
            equipPart = equipPart,
        }
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationCard, l_openData)
    end
end

function OpenIllustrationEquipmentEvent(tableData, params)
    --- 如果界面处于开启状态，则直接返回，原因是界面处于开启状态，还会进入这个函数
    --- 说明玩家是在图鉴界面的锻造材料中点过来的，这个时候不跳转
    if UIMgr:IsActiveUI(UI.CtrlNames.IllustrationEquipment) then
        return
    end

    if params then
        local l_equipId = params[1]
        if l_equipId then
            l_equipId = tonumber(l_equipId)
            MgrMgr:GetMgr("IllustrationMgr").SelectEquipId = l_equipId
        end
    end

    UIMgr:ActiveUI(UI.CtrlNames.IllustrationEquipment)
end

function OpenIllustrationByEquip(partId, professionId)
    local illusMgr = MgrMgr:GetMgr("IllustrationMgr")
    if illusMgr.IsIllustrationEquipCanShow(partId, professionId) == false then
        return
    end

    professionId = MgrMgr:GetMgr("ProfessionMgr").GetBaseProfessionIdWithProfessionId(professionId)
    local openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if openMgr.IsSystemOpen(openMgr.eSystemId.IllustratorEquip) then
        if partId and professionId then
            illusMgr.SetEquipSearchValue(partId, professionId)
        end

        UIMgr:ActiveUI(UI.CtrlNames.IllustrationEquipment)
    else
        logGreen("没有开启装备图鉴:" .. tostring(openMgr.eSystemId.IllustratorEquip))
    end
end

function OpenIllustrationByCardSelectInfo(type, schoolId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local illusMgr = MgrMgr:GetMgr("IllustrationMgr")
    local l_openData = {
        openType = illusMgr.OpenType.SelectCard,
        schoolId = schoolId,
        type = type
    }
    UIMgr:ActiveUI(UI.CtrlNames.IllustrationCard, l_openData)
end

--勋章
function OpenMedal()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if MPlayerInfo.ProID == 1000 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MEDAL_FUNC_OPEN_LIMIT_TIP"))
    else
        UIMgr:ActiveUI(UI.CtrlNames.Medal)
    end
end

--返回获取途径是否需要预检测
function PreCheckFunction(funcId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if customPreCheck[funcId] then
        return { state = true, func = customPreCheck[funcId] }
    end
    return { state = false, func = nil }
end

--返回一个道具获取途径的Method
function GetItemAchieveMethod(id)
    local tableData = TableUtil.GetOpenSystemTable().GetRowById(id)
    local functionName = GetFunctionName(tableData)
    local event = ModuleMgr.SystemFunctionEventMgr[functionName]
    local isUseCustom = false

    for i = 1, table.maxn(useCustomMethodFuncTb) do
        if useCustomMethodFuncTb[i] == id then
            isUseCustom = true
            break
        end
    end

    if not isUseCustom then
        if functionName == nil or event == nil then
            logError("未配置相应的功能事件 Id为 " .. tostring(id))
            return nil
        else
            return function(param)
                event(tableData, param)
            end
        end
    else
        return GetItemAchieveMethodByFunc(id)
    end
end

function GetItemAchieveMethodByFunc(funcId)
    --头饰商店
    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Barber then
        --1080
        return function(dataTb)
            OpenOrnamentBarterEvent(_, dataTb.npcId, dataTb.itemId)
        end
    end

    --商会
    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Trade then
        --11001
        return function(dataTb)
            local l_tableData = TableUtil.GetCommoditTable().GetRowByCommoditID(dataTb.itemId, true)
            if l_tableData and tonumber(MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData.serverlevel) < tonumber(l_tableData.OpenSystemLev) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("OPEN_FAIL_BY_SERVERLIMIT", l_tableData.OpenSystemLev))
                return
            end
            MgrMgr:GetMgr("SweaterMgr").OpenBuySweater(MgrMgr:GetMgr("SweaterMgr").ESweaterType.Trade, dataTb.itemId)
        end
    end

    --摆摊
    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Stall then
        --11002
        return function(dataTb)

            MgrMgr:GetMgr("TradeMgr").OpenStallOnAchieve(dataTb)
        end
    end

    --魔物驱逐
    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MonsterExpel then
        --5110
        return function(dataTb)
            MgrMgr:GetMgr("DailyTaskMgr").OpenDailyTask()
        end
    end

    --圣歌试炼
    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.HsMonster then
        --5050
        return function(dataTb)
            MgrMgr:GetMgr("NpcMgr").TalkWithNpc(dataTb.sceneId, dataTb.npcId)
        end
    end

    --挖宝
    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Wabao then
        --5060
        return function(dataTb)
            MgrMgr:GetMgr("DailyTaskMgr").OpenDailyTask()
        end
    end

    --卡片分解 头饰分解
    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveCard --3090
            or funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractCard --3091
            or funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveHead --3092
            or funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractHead --3093
            or funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveEquip --3097
            or funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractEquip then
        --3098
        return function(dataTb)
            Common.CommonUIFunc.OpenMagicMachinePanel(dataTb.npcId, funcId, dataTb.itemId)
        end
    end

    --武器打造 或者 防具打造
    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.forgeArmor or
            funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.forgeWeapon then
        return function(dataTb)
            local l_method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(funcId)
            l_method(dataTb.itemId)
        end
    end

    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ThemeParty then
        return function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_PARTY_GET"))
        end
    end

    if funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.FirstRecharge then
        return function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("FIRST_CHARGE_GET"))
        end
    end

    return function()
        log("没有点击方法 @马鑫")
    end
end

function EnterCookingDoubleDungeon(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("CookingDoubleMgr").CaptainRequestEnter(tableData.Id)
end

-- region Arena
--==============================--
--@Description: 报名擂台
--@Date: 2018/9/19
--@Param: [args]
--@Return:
--==============================--
function JoinArena()
    local dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    if dailyTaskMgr.IsActivityOpend(dailyTaskMgr.g_ActivityType.activity_Ring) then
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
        if MPlayerInfo.Lv < MgrMgr:GetMgr("ArenaMgr").ArenaMinLv then
            return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ARENA_MIN_MATCH_LV", MgrMgr:GetMgr("ArenaMgr").ArenaMinLv))
        elseif MPlayerInfo.Lv > MgrMgr:GetMgr("ArenaMgr").ArenaMaxLv then
            return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ARENA_MAX_MATCH_LV", MgrMgr:GetMgr("ArenaMgr").ArenaMaxLv))
        end

        -- 有玩家不在x~y区间内
        local minLv, maxLv = MgrMgr:GetMgr("ArenaMgr").GetJoinLvRange()
        if minLv == -1 and maxLv == -1 then
            logError("全局配置的最低和最高和BattleGroundLvRangeTable不一致 @华哥")
            return
        end
        if DataMgr:GetData("TeamData").GetPlayerTeamInfo() and not DataMgr:GetData("TeamData").IsAllMemberInSameLvRange(minLv, maxLv) then
            return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ARENA_NOT_SAME_MATCH_LV", minLv, maxLv))
        end

        -- 报名
        MgrMgr:GetMgr("PvpMgr").JoinPvp(dailyTaskMgr.g_ActivityType.activity_Ring)

    else
        MgrMgr:GetMgr("NpcTalkDlgMgr").OnSetTalk(false, Lang("ARENA_OPEN_TIME_TIP"), true)
    end
end

-- 打开奖励兑换
function OpenArenaShop()

end

-- 擂台玩法介绍
function ShowArenaPlayMethod()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.NPCInstructions, function(ctrl)
        ctrl:InitWithContent(Lang("ARENA_INFO_TIPS_TITLE"), Lang("ARENA_INFO_TIPS"))
    end)
end

-- endregion

--打开材料制作界面
function OpenMaterialMakeEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.EquipElevate, function(ctrl)
        ctrl:SelectOneHandler("MaterialMake")
    end)
end

--打开置换器制作界面
function OpenDisplacerMakeEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.EquipElevate, function(ctrl)
        ctrl:SelectOneHandler("DisplacerMake")
    end)
end

--打开置换器使用界面
function OpenDisplacerUseEvent(tableData, weaponUid)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.DisplacerUse, function(ctrl)
        ctrl:SetOpenWeapon(weaponUid)
    end)
end

--手推车改造界面打开
function OpenRefitTrolleyEvent(tableData, param, npcId)
    local curNpcId = npcId or MgrMgr:GetMgr("NpcMgr").GetCurrentNpcId()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.Refitshop, function(ctrl)
        ctrl:SetNpc(curNpcId)
    end)
end

--猎鹰商店打开
function OpenBattleBirdEvent(tableData, param, npcId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    OpenRefitTrolleyEvent(tableData, param, npcId)
end

--战斗坐骑商店打开
function OpenBattleVehicleEvent(tableData, param, npcId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    OpenRefitTrolleyEvent(tableData, param, npcId)
end

--福利
function OpenWelfareEvent(tableData, param, npcId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.Welfare)
end

--签到
function OpenSignInEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.SignIn)
end

function OnGuildCookMenu()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("GuildDinnerMgr").SendGuildDinnerViewMenuReq()
end

function OnGuildCookIntroduce()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_skillData = {
        openType = DataMgr:GetData("CommonIntroduceData").OpenType.InitInfoAndNpc,
        title = Lang(TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetTitleWord").Value),
        info = Lang(TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetContentWord").Value),
        altas = "Icon01",
        icon = "UI_Icon_Gonghuiyanhui.png"
    }
    UIMgr:ActiveUI(UI.CtrlNames.CommonIntroduce, l_skillData)
end

function OnBattleIntroduce()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.GameHelp, { type = MStageEnum.Battle })
end

function OnGuildCookCupidTask()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("GuildDinnerMgr").SendGuildDinnerTaskAcceptReq()
end

--猫手商队
function OpenCatCaravan()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.CatCaravan)
end

function OpenTask()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.Task)
end

function OpenGuaji()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.DailyTask,
            {
                distinationActivityId = MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_Magic,
                openFarmPrompt = true,
            })
end

function OpenWorldEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_openParam = {
        distinationActivityId = MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_WorldNews,
    }
    UIMgr:ActiveUI(UI.CtrlNames.DailyTask, l_openParam)

end

function OnHeroIntroduceClick()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_skillData = {
        openType = DataMgr:GetData("CommonIntroduceData").OpenType.InitInfoAndNpc,
        title = Common.Utils.Lang("HERO_CHALLENGE_TITLE"),
        info = Common.Utils.Lang("HERO_CHALLENGE_CONTENT"),
        altas = "Icon01",
        icon = "UI_Icon_Yingxiongtiaozhan.png"
    }
    UIMgr:ActiveUI(UI.CtrlNames.CommonIntroduce, l_skillData)
end

function OnHeroChallengeClick()
    if MgrMgr:GetMgr("DailyTaskMgr").IsActivityOpend(MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_HeroChallenge) then
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
        UIMgr:ActiveUI(UI.CtrlNames.HeroChallenge)
    else
        MgrMgr:GetMgr("NpcTalkDlgMgr").OnSetTalk(false, Lang("HERO_OPEN_TIME_TIP"), true)
    end
end

function OnHeroRankClick()

end

function OpenPostCard()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    OpenAdventureDiary()
end

--打开冒险日记
function OpenAdventureDiary()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.AdventureDiary)
end

-- 委托
function DelegateEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    --目前分组机制造成没办法处理 所以在此特殊处理 提前关闭委托的分界面
    UIMgr:DeActiveUI(UI.CtrlNames.Emblem)
    UIMgr:DeActiveUI(UI.CtrlNames.DelegateWheel)
    UIMgr:ActiveUI(UI.CtrlNames.DelegatePanel, { Tab = 1 })
end

-- 个性化，头像
function OpenPersonal(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_photoId = nil
    if param then
        l_photoId = tonumber(param[1])
    end
    MgrMgr:GetMgr("HeadSelectMgr").OpenHeadUI(l_photoId)
end

-- 称号
function OpenTitleEvent(tableData, param)
    local l_titleId = nil
    if param then
        l_titleId = tonumber(param[1])
    end
    MgrMgr:GetMgr("TitleStickerMgr").OpenTitleUI(l_titleId)
end

-- 首领图鉴
function OpenLeaderEvent(tableData, param)
    local l_leaderId = nil
    if param then
        l_leaderId = tonumber(param[1])
    end
    UIMgr:ActiveUI(UI.CtrlNames.Theme_ChiefGuild, { leaderId = l_leaderId })
end

--佣兵
function OpenMercenaryEvent(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if param then
        MgrMgr:GetMgr("MercenaryMgr").OpenMercenary(tonumber(param[1]))
    else
        MgrMgr:GetMgr("MercenaryMgr").OpenMercenary()
    end
end

--波利商城
function OpenMall(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_mallMgr = MgrMgr:GetMgr("MallMgr")
    local l_customData = {}
    if tableData then
        local h = tableData.FunctionOrder
        local FunctionOrder = Common.Functions.VectorToTable(h)
        local l_mallId = tonumber(FunctionOrder[2])
        if param then
            l_mallId = tonumber(param[1])
        end
        l_customData = {
            Tab = l_mallId,
        }
    end

    if param and param.functionId then
        local mallId = l_mallMgr.GetMallIdByFuncId(param.functionId)
        l_customData = {
            Tab = mallId,
        }
    end
    
    UIMgr:ActiveUI(UI.CtrlNames.Mall, l_customData)
end

--迷宫副本
function EnterMazeDungeon()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.MazeEnter)
end

function OpenMazeDungeonWheel()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("MazeDungeonMgr").RequestRunRoulette()
end

function OpenTimeLimit()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()

    UIMgr:ActiveUI(UI.CtrlNames.Rollback)
    UIMgr:DeActiveUI(UI.CtrlNames.Mall)
end

function OpenBusinessMap(...)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("MerchantMgr").OpenMerchantShopMap()
end

--装备相关的

function ForgeEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.EquipElevate)
end

function OpenForgeEvent(tableData, equipId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if tableData.FunctionOrder.Length ~= 2 then
        logError("功能开启表填的FunctionOrder数据不对，id：" .. tableData.Id)
        return
    end
    MgrMgr:GetMgr("ForgeMgr").OpenForge(tableData.FunctionOrder[1], equipId)
end

function OpenEnchantEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ShowEquipPanleMgr").OpenEnchantPanle()
end
function OpenEnchantAdvancedEvent()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ShowEquipPanleMgr").OpenEnchantAdvancedPanle()
end

function MakeHoleEvent(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ShowEquipPanleMgr").OpenMakeHolePanle()
end

function OpenCardForgeEvent(tableData, cardId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ShowEquipPanleMgr").OpenCardForgePanle(cardId)
end

function OpenCardUnsealEvent(tableData, cardId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("SealCardMgr").OpenUnsealCardUI(cardId)
end

--- 节日签到活动
function OpenActivityCheckIn()
    ---@type ModuleMgr.OpenSystemMgr
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.ActivityCheckIn) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTipsWithLang("ACTIVITY_IS_ALREADY_OVER")
        return
    end
    if not MgrMgr:GetMgr("ActivityCheckInMgr").IsSystemOpenExtraCheck() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTipsWithLang("ACTIVITY_IS_ALREADY_OVER")
        MgrMgr:GetMgr("ActivityCheckInMgr").SendGetSpecialSupplyInfo() --强制刷新下
        return
    end

    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.ActivityCheckIn)
end

--- 累计充值返利
function OpenTotalRechargeAwardUI()
    if not MgrMgr:GetMgr("TotalRechargeAwardMgr").IsSystemOpen() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_OPEN_PLEASE_WAITTING"))
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.TotalRechargeAward)
end

--- 装备改造
function OnEquipReform()
    UIMgr:ActiveUI(UI.CtrlNames.EquipGaiZao)
end

function OpenLevelReward(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.LevelReward)
end

function OpenMonthCard(tableData)
    UIMgr:ActiveUI(UI.CtrlNames.MonthCard)
end

function ShowWorldPveIntroduce()
    --MgrMgr:GetMgr("SystemFunctionEventMgr").ShowWorldPveIntroduce()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_skillData = {
        openType = DataMgr:GetData("CommonIntroduceData").OpenType.SetBigInfo,
        title = Lang("WORLD_PVE_INTRODUCE_TITLE"),
        info = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.WorldPve,
        altas = TableUtil.GetOpenSystemTable().GetRowById(5135).SystemAtlas,
        icon = TableUtil.GetOpenSystemTable().GetRowById(5135).SystemIcon,
        fun = function()
            UIMgr:DeActiveUI(UI.CtrlNames.CommonIntroduce)
        end
    }
    UIMgr:ActiveUI(UI.CtrlNames.CommonIntroduce, l_skillData)
end

--装备相关的
function OpenWatchWarUI(tableData)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.WatchWarBG)
end

-- 开启精炼助手
function OpenRefineAssist(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    _openPageBySelection(GameEnum.EEquipAssistType.RefineAssist)
end

function OpenEquipShardTable()
    UIMgr:ActiveUI(UI.CtrlNames.EquipCarryShop)
end

-- 开启附魔助手
-- param = {
-- handlerName = GameEnum.EEquipAssistType.EnchantAssistOnInherit,
-- EquipPropInfo = nil,
-- ItemPropInfo = nil,
-- switchPerfect = true}
function OpenEnchantAssist(tableData, param)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    if nil == param then
        _openPageBySelection(GameEnum.EEquipAssistType.EnchantAssist)
        return
    end

    if GameEnum.EEquipAssistType.EnchantAssistOnInherit == param.handlerName then
        local l_enchantInheritMgr = MgrMgr:GetMgr("EnchantInheritMgr")
        l_enchantInheritMgr.SetOldEquip(param.ItemPropInfo)
        l_enchantInheritMgr.SetNewEquip(param.EquipPropInfo)
        _openPageBySelection(param.handlerName)
        return
    end

    -- 这里会默认进入完美提炼，如果有其他需求就在这里进行修改
    if GameEnum.EEquipAssistType.EnchantAssistOnPerfect == param.handlerName then
        local enchantExtractMgr = MgrMgr:GetMgr("EnchantmentExtractMgr")
        enchantExtractMgr.SetCacheData(param.ItemPropInfo)
        _openPageBySelection(param.handlerName)
        return
    end

    logError("[SystemFunc] invalid page type: " .. tostring(param.handlerName))
end

function BackToSelectRole()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    game:GetAuthMgr():LogoutToSelectRole()
end

-- 根据选项来开启页面
function _openPageBySelection(pageType)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    local l_mgr = MgrMgr:GetMgr("ShowEquipPanleMgr")
    if nil == l_mgr then
        logError("[ShowEquipPanleMgr] ShowEquipPanleMgr is nil, plis check")
        return
    end
    l_mgr.OpenEquipAssistPanelByType(pageType)
end

--查看宣传海报
function FashionOut()

    local l_fashionData = DataMgr:GetData("FashionData").EUIOpenType.SHOW
    UIMgr:ActiveUI(UI.CtrlNames.FashionCatalog, l_fashionData)

end

--打开过往时尚杂志
function FashionMagazine()

    local l_fashionData = DataMgr:GetData("FashionData").EUIOpenType.HISTORY
    UIMgr:ActiveUI(UI.CtrlNames.FashionCatalog, l_fashionData)

end

-- 首充礼包
function OpenFirstRecharge()
    UIMgr:ActiveUI(UI.CtrlNames.FirstRecharge)
end

-- 直购礼包
function OpenCapraReward(tableData, groupId)

end

-- 打开Bingo活动
function OpenBingo()
    UIMgr:ActiveUI(UI.CtrlNames.Bingo)
end


-- 打开排行榜
function OpenLeaderboardFrame(tableData)
    local h = tableData.FunctionOrder
    local FunctionOrder = Common.Functions.VectorToTable(h)
    local l_rankType = tonumber(FunctionOrder[2])
    local openData = {
        openType = 1,
        RankMainType = tonumber(l_rankType),
    }
    UIMgr:ActiveUI(UI.CtrlNames.Rank, openData)
end

function OpenIllustrationMonsterPanel(tableData, param)
    if param ~= nil then
        local l_openData = {
            openType = DataMgr:GetData("IllustrationMonsterData").MonsterOpenType.SearchMonster,
            EntityId = param[1]
        }
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonsterBg, l_openData)
    else
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonsterBg)
    end
end

function OpenIllustrationCardPanel(tableData, param)
    if param ~= nil then
        local illusMgr = MgrMgr:GetMgr("IllustrationMgr")
        local l_openData = {
            openType = illusMgr.OpenType.SearchCard,
            cardId = param[1]
        }
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationCard, l_openData)
    else
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationCard)
    end

end

function OpenBeiluzEvent()
    UIMgr:ActiveUI(UI.CtrlNames.BeiluzCore)
end

function OpenTreasureHunterInfo()
    require "Command/CommandMacro"
    MgrMgr:GetMgr("TreasureHunterMgr").GetTreasurePanelInfo(CommandMacro.NPCUuid())
end

function OpenJobChoose()

    local proList = DataMgr:GetData("SkillData").GetNextProfessionList(MPlayerInfo.ProID)
    if #proList == 1 then
        MgrMgr:GetMgr("TaskMgr").RequestJobChoice(proList[1])
    else
        UIMgr:ActiveUI(UI.CtrlNames.Choosejob_npc, proList)
    end

end

function GetTreasureHunterTask(tableData, param, gotoPos)
    local l_sceneId, l_pos = Common.CommonUIFunc.GetNpcSceneIdAndPos(tonumber(gotoPos))
    MgrMgr:GetMgr("NpcMgr").TalkWithNpc(l_sceneId[1], tonumber(gotoPos))
end

function OpenRebateMonthCardPanel()
    UIMgr:ActiveUI(UI.CtrlNames.RebateMonthCard)
end

function OpenCardExchangeShop()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("CardExchangeShopMgr").ShowCardExchangeShop()
end

function UseAutoMedicine()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("USE_AUTO_MEDICINE"))
end

function EnterHuntField(tableData)
    if tableData.FunctionOrder.Length ~= 2 then
        logError("功能开启表填的FunctionOrder数据不对，id：" .. tableData.Id)
        return
    end
    local l_msgId = Network.Define.Ptc.CaptainRequestEnterSceneReq
    ---@type CaptainRequestEnterSceneData
    local l_sendInfo = GetProtoBufSendTable("CaptainRequestEnterSceneData")
    l_sendInfo.scene_id = tonumber(tableData.FunctionOrder[1])
    l_sendInfo.captain_uuid = MPlayerInfo.UID
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function CheckShowEnterHuntFieldBtn()
    local teamInfo = DataMgr:GetData("TeamData").myTeamInfo
    if teamInfo.captainId and not uint64.equals(teamInfo.captainId, 0) and not uint64.equals(teamInfo.captainId, -1) and not uint64.equals(MPlayerInfo.UID, teamInfo.captainId) then
        return false
    end
    return true
end

function LeaveScene()
    MgrMgr:GetMgr("DungeonMgr").LeaveDungeon()
end

return SystemFunctionEventMgr

