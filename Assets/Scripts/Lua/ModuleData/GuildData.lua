--lua model
---@module ModuleData.GuildData
module("ModuleData.GuildData", package.seeall)
--lua model end

--region ---------------------- 枚举 --------------------------
--UI激活对应函数枚举
EUIOpenType = 
{
    GuildChangePosition = 1,
    GuildConstruction = 2,
    GuildDinnerMenuTips = 3,
    GuildInviteOffer = 4,
    GuildWelfareReceive = 5,
    GuildRedEnvelopeList = 6,
    GuildModifyInfor = 7,
    GuildIconSelect = 8,
    GuildUpgrade = 9,
    GuildStone = 10,
    GuildStoneHelp = 11,
    GuildRefreshPlayerMenuL = 12,
}
--公会界面页签枚举
EGuildHandleType =
{
    GuildInfo = 1,
    GuildMember = 2,
    GuildWelfare = 3,
    GuildActivity = 4
}
--公会内容表分类枚举
EGuildContentType =
{
    Welfare = 1,         -- 福利
    Activity = 2,        -- 活动
}
--公会内容枚举
EGuildContent = 
{
    SaleMechine = 1,            --贩卖机
    WeeklyWelfare = 2,          --每周福利
    Dinner = 3,                 --公会宴会
    Crystal = 4,                --华丽水晶
    Gift = 5,                   --公会礼盒
    Hunt = 8,                   --公会狩猎
    Depository = 9,             --公会仓库
    Match = 10,                 --公会匹配赛
    MemorialStone = 11,         --纪念原石
    RoyalRace = 12,             --皇室竞赛
    Manual = 13,                --组织手册
    InvestigationTeam = 14,     --时空调查团
}
--公会内容按钮文字类型
EGuildContentBtnText =
{
    Goto = 1,         -- 前往
    LookAt = 2,       -- 查看
    Grant = 3,        -- 发放
}
--公会相关FunctionId的枚举
EGuildFunction =
{
    GuildDinner = 7000,                --公会宴会
    GuildDoubleCook = 7001,            --公会双人烹饪
    GuildUpgrade = 7003,               --公会升级
    GuildMenu = 7004,                  --公会菜单查看
    GuildDinnerDescribe = 7005,        --公会宴会介绍
    GuildFate = 7006,                  --公会缘分考验
    GuildShop = 7007,                  --公会贩卖机
    GuildCrystal = 7008,               --公会华丽水晶
    GuildHunt = 7009,                  --公会宴会
    GuildMatch = 15101,                --公会匹配赛
}
--公会建筑类型枚举
EBuildingType = {
    Hall = 1,           --大厅
    Crystal = 2,        --华丽水晶
    SaleMechine = 3,    --贩卖机
    Entertainment = 4,  --娱乐室
    Depository = 5,     --仓库
}
--公会职位类型枚举
EPositionType = {
    NotInGuild = 0,     --不在公会中
    Chairmen = 1,       --会长
    ViceChairman = 2,   --副会长
    Director = 3,       --理事
    Deacon = 4,         --执事
    Beauty = 5,         --魅力担当
    Special_1 = 6,      --特殊成员1
    Special_2 = 7,      --特殊成员2
    Member = 8,         --成员
}
--成员列表展示类型枚举
EMemberListType = {
    AllList = 0,       --全部数据列表
    SearchList = 1,    --搜索数据列表
}
--公会成员排序类型枚举
EMemberSortType = {
    None = 0,                 --不排序
    Name = 1,                 --名字排序
    Level = 2,                --等级排序
    Job = 3,                  --职业排序
    Position = 4,             --职务排序
    Contribution = 5,         --贡献排序
    Achievement = 6,          --成就排序
    Activity = 7,             --活跃排序
    ActivityChat = 8,         --发言活跃度排序
    ActivityFight = 9,        --战绩活跃度排序
    StateOfflineTime = 10,    --在线状态排序(离线时间、名字作为第二规则)
    StateBaseLv = 11,         --在线状态排序(等级作为第二规则)
    Normal = 100,             --默认排序
    NormalBox = 101,          --默认排序(礼盒)
}

--公会福利分红领取状态枚举
EWelfareStateType = {
    Disable = 0,    --不可领取
    CanGet = 1,     --可领取
    IsGeted = 2,    --已领取
}

--公会狩猎难度枚举
EGuildHuntDungeonType = {
    Easy = 0,  --简单难度
    Normal = 1,  --普通难度
    Hard = 2,  --困难难度
}

--微信绑群回调枚举
EGroupWXCallBackType = {
    Create = 0,   --请求创建回调
    Apply = 1,    --请求加入回调
}

--公会新闻的枚举类型
ENewsType = 
{
    News = 0,       --新闻
    NewsDrop = 1,    --点滴
}

--公会狩猎开启资格
EHuntExCount = {
    None = 0,     --不可开启额外次数，但是还有机会获得
    HasExtraOne = 1,    --可以随时开启额外次数
    NoneExtra = 2,      --不可开启额外次数，没有机会了
}

--- 今日公会资金捐献情况
CheckBankrollLimitType = {
    --- 本次捐赠不会超过
    NotReached = 0,
    --- 本次捐赠前已经超过
    Reached = 1,
    --- 本次捐赠即将超过
    AboutToReach = 2,
}
--endregion------------------ END 枚举 ------------------------

--region-------------------- 常量 ---------------------------
--公会场景ID
GUILD_SCENE_ID = 29
--公会列表每页的容量
GUILD_LIST_PAGE_CAPACITY = 30
--公会成员列表每页的容量
GUILD_MEMBER_LIST_PAGE_CAPACITY = 60
--公会仓库每页的容量(格子数)
GUILD_DEPOSITORY_PAGE_CAPACITY = 20
--公会狩猎发送的红包ID
GUILD_HUNT_REDENVELOPE_ID = 2050007  
--公会华丽水晶BUFF的ID
GUILD_CRYSTAL_BUFF_ID = 610014001
--公会华丽水晶第一次一级红点标识符
GUILD_CRYSTAL_ONE_LEVEL_RED = "GUILD_CRYSTAL_ONE_LEVEL_RED"
--公会新闻转发的标识类型  @马鑫
GUILD_NEWS_BASIC_TYPE = 999
--endregion------------------ END 常量  ------------------------

--region-------------------- 变量数据 ---------------------------
--个人公会数据
selfGuildMsg = {
    id = 0, --公会编号
    name = "", --公会名称
    position = 0, --公会职位 1会长 2副会长 3理事 4执事 5成员 6特殊成员1 7特殊成员2
    contribution = 0, --当前贡献度
    joinTime = 0, --加入时间
    hasBuilt = false,  --是否参与过当次公会建设
    guildGroupBindState = false,  --公会群绑定状态
    isJoinedGroup = false,  --是否已加入公会群
}
--所属公会的基础信息
guildBaseInfo = {}
--所属公会建设信息
guildBuildInfo = {}
--所属公会的水晶信息
guildCrystalInfo = {}
--所属公会的公会仓库信息
guildDepositoryInfo = {}
--公会狩猎动态npc位置
huntNpcLoc = {}
--- 存放公会等级到公会资金每日获取上限的映射
bankrollLimitTable = {}

--公会职务名称数据
guildPositionName = {
    [EPositionType.NotInGuild] = "",                       --无公会
    [EPositionType.Chairmen] = Lang("CHAIRMEN"),           --会长
    [EPositionType.ViceChairman] = Lang("VICECHAIRMAN"),   --副会长
    [EPositionType.Director] = Lang("DIRECTOR"),           --理事
    [EPositionType.Deacon] = Lang("DEACON"),               --执事
    [EPositionType.Beauty] = Lang("BEAUTY"),               --魅力担当
    [EPositionType.Special_1] = "",                        --特殊成员名字需要服务器返回
    [EPositionType.Special_2] = "",                        --特殊成员名字需要服务器返回
    [EPositionType.Member] = Lang("MEMBER"),               --成员
}

--公会成员列表
---@type ClientGuildMemberDetailInfo[]
guildMemberList = nil
--公会申请列表
guildApplyList = nil
--当期成员列表展示类型
curGuildMemberListType = EMemberListType.AllList
--当前公会人数统计
curViceChairmanNum = 0  --副会长人数
curDirectorNum = 0  --理事人数
curDeaconNum = 0  --执事人数
curBeautyNum = 0  --魅力担当人数
curOnlineNum = 0  --在线人数

--当前公会HUD的数据 当有新数据来时进行对比 如果无变化则不触发事件
curGuildName_HUD = nil
curGuildPositionName_HUD = nil
curGuildIconId_HUD = nil

--公会新闻类型的显示数据
guildNewsBelongType = nil

--寻路前往公会的各类标志
findPath_activityId = nil  --公会寻路依据(活动表ID)
findPath_funcId = nil  --NPC功能Id
findPath_pos = nil  --指定坐标
findPath_npcId = nil  --目标NPC的ID
arriveCallBack = nil  --到达后的回调

--公会宴会数据
dinnerMenu = {}  --宴会菜单数据（排行榜）
curDishData = {}  --当前展示的菜品数据 dishEntity dishCount costTime endTime makers
guildCookScoreInfo = { guildNum =0 } --公会宴会排行信息
allGuildPersionalRank = {} --全公会宴会个人排行榜信息
selfGuildPersionalRank = {} --自己公会宴会个人排行榜信息
local cookRankMemberPool={}
local hasOpenDinnerWish=false --是否已开启公会宴会祝福
local openDinnerWishPlayerName=nil --开启香槟祝福玩家名称
local guildCookScoreColors={RoColor.Hex2Color("FFD858FF"),RoColor.Hex2Color("B3CFEBFF"),RoColor.Hex2Color("EEAA91FF"),RoColor.Hex2Color("BEBEBEFF")}
local guildCookRandomEventStartTime = 0 --公会宴会随机事件开启时间
local isRandomEventTouched =false --公会随机事件是否已触发
local cookEndTime = -1  --烹饪比赛结束时间
local guildCookRandomEventTouchTime = 0 --随机事件触发时间
local randomEventLastTime=-1 --随机事件持续时间
--公会宴会奶油大乱斗数据
dinnerFightTotalNum = 0  --大乱斗参与总人数
dinnerFightCurNum = 0  --大乱斗剩余人数
dinnerFightInfoShowTime = nil  --大乱斗信息展示时间
dinnerFightStartTime = nil  --大乱斗开始时间
dinnerFightEndTime = nil  --大乱斗结束时间

--公会福利相关数据
guildGiftInfo = {}          --公会礼盒信息
guildGiftSendMemberIds = nil    --公会礼盒发放目标列表 被钩选中的人
guildWelfareState = EWelfareStateType.Disable   --公会福利分红领取状态
guildWelfareIsClick = false     --公会福利是否不显示领取按钮小红点状态
guildWelfareClick = false       --公会福利分红是否领取

--公会狩猎相关信息
guildHuntInfo = nil       --公会狩猎信息
guildHuntPortalIds = nil  --公会狩猎传送门ID表
huntDoorId = 0   --公会狩猎当前选中的传送门ID

--公会绑群相关数据
WXCallBackType = EGroupWXCallBackType.Create   --用于区分请求微信公会群状态的回调区分标识符（是否创建和是否加入是一个回调）
guildGroupId_QQ = 0  --QQ需要记录群ID
zoneId = "1"    --区编号
areaId = "1"    --地区编号

--公会精灵喊话时间
gSpriteShoutTime = 1
--公会精灵喊话持续时间
gSpriteWaitTime = 1
--公会精灵初始化位置
gSpriteInitPos= Vector3.New(0,0,0)
--公会新闻MessageId和表数据的映射
gGuildNewsMessageIdTable = {}
--- 捐赠给公会的道具ID->数值贡献（公会资金|BaseExp|公会贡献）的映射
gGuildItemTable = {}

---组织手册
local l_curOrganizeProgress = 0
---获得组织力奖励的最小组织力值
local l_MinOrganizeValue = -1
---获得组织力奖励的最大组织力值
local l_MaxOrganizeValue = -1
---能够增加组织力贡献的道具
local l_addOrganizeContributtionProps = {}
---当前已领取的组织力贡献个人奖励
local l_curHasGetRewardKey = {}
---当前能够领取的组织力贡献个人奖励 （红点需求后新增，辅助与判断红点）
local l_curCanGetRewardKey = {}
--endregion------------------ END 变量数据  ------------------------

--region-------------------- 生命周期 ---------------------------
--初始化
function Init( ... )
    InitSelfGuildMsg()
    InitGuildInfo()
    InitGuildHUD()
    InitGuildFindPath()
    InitCountData()
    InitGuildCrystalInfo()
    InitGuildDepositoryInfo()
    InitGuildDinnerInfo()
    InitGuildWelfareInfo()
    InitGuildHuntInfo()
    InitGuildBindGroupInfo()
    InitGuildNewsInfo()
    InitHuntNpc()
    InitGuildItemTable()
    InitBankrollLimitTable()
end

--登出重置
function Logout( ... )
    Init()
end
--endregion------------------ END 生命周期  ------------------------

--region-------------------- 初始化方法 ---------------------------
--初始化个人公会信息
function InitSelfGuildMsg()
    selfGuildMsg.id = 0
    selfGuildMsg.name = ""
    selfGuildMsg.position = EPositionType.NotInGuild
    selfGuildMsg.contribution = 0
    selfGuildMsg.joinTime = 0
    selfGuildMsg.hasBuilt = false
    selfGuildMsg.guildGroupBindState = false
    selfGuildMsg.isJoinedGroup = false
    --C#记录的公会ID更新
    if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.AttrRole then
        MEntityMgr.PlayerEntity.AttrRole.GuildId = 0
    end
end 

--初始化公会信息
function InitGuildInfo()
    --公会数据
    guildBaseInfo = {}
    --所属公会建设信息
    guildBuildInfo = {}
    --公会自定义的职位名称
    guildPositionName[EPositionType.Special_1] = ""
    guildPositionName[EPositionType.Special_2] = ""
end

--初始化公会HUD数据
function InitGuildHUD()
    curGuildName_HUD = nil
    curGuildPositionName_HUD = nil
    curGuildIconId_HUD = nil
end

--初始化公会狩猎npc位置
function InitHuntNpc()

    local l_data, l_npcloc, l_npcInfo
    l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingEasyPortal").Value
    l_npcloc = string.ro_split(l_data, "=")
    l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingEasyNpcID").Value
    l_npcInfo = string.ro_split(l_data, "=")
    huntNpcLoc[l_npcInfo[1]] = Vector3(l_npcloc[1], l_npcloc[2], l_npcloc[3])

    l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingNormalPortal").Value
    l_npcloc = string.ro_split(l_data, "=")
    l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingNormalNpcID").Value
    l_npcInfo = string.ro_split(l_data, "=")
    huntNpcLoc[l_npcInfo[1]] = Vector3(l_npcloc[1], l_npcloc[2], l_npcloc[3])
    huntNpcLoc[l_npcInfo[2]] = Vector3(l_npcloc[1], l_npcloc[2], l_npcloc[3])

    l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingHardPortal").Value
    l_npcloc = string.ro_split(l_data, "=")
    l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingHardNpcID").Value
    l_npcInfo = string.ro_split(l_data, "=")
    huntNpcLoc[l_npcInfo[1]] = Vector3(l_npcloc[1], l_npcloc[2], l_npcloc[3])
    huntNpcLoc[l_npcInfo[2]] = Vector3(l_npcloc[1], l_npcloc[2], l_npcloc[3])

end

--- 若有新道具请在此处将道具ID插入列表
--- 读表初始化{公会贡献道具ID->公会资金|BaseExp|公会贡献}的映射
function InitGuildItemTable()
    gGuildItemTable[MGlobalConfig:GetInt("CrystalItemID",-1)] = MGlobalConfig:GetString("CrystalExchange", "")
    gGuildItemTable[MGlobalConfig:GetInt("UnitySculptureID", -1)] = MGlobalConfig:GetString("UnitySculptureExchange", "")
    gGuildItemTable[MGlobalConfig:GetInt("CertificateItemID", -1)] = MGlobalConfig:GetString("CertificateExchange", "")
    for id, score in pairs(gGuildItemTable) do
        if id == -1 or score == "" then
            logError("[GuildData.InitGuildItemTable] {公会贡献道具ID->公会资金|BaseExp|公会贡献}映射初始化失败")
        end
    end
end

--- 获取公会捐赠道具所得到的点数
---@param itemID number 公会id
---@param type number 获取点数类型 1->公会资金 2->BaseExp 3->公会贡献
---@return number 道具对应点数
function GetGuildItemExchange(itemID, type)
    if table.ro_size(gGuildItemTable) == 0 then
        logError("[GuildData.GetGuildItemExchange] 注册的公会道具为空")
        return 0
    end
    if table.ro_containsKey(gGuildItemTable, itemID) then
        ret = MgrMgr:GetMgr("TableStrParseMgr").ParseValue(gGuildItemTable[itemID], GameEnum.EStrParseType.Array, GameEnum.ELuaBaseType.Number)
        if #ret >= type then
            return ret[type]
        else
            logError("[GuildData.GetGuildItemExchange] 不存在此类型点数")
        end
    else
        logError("[GuildData.GetGuildItemExchange] 该道具不是公会捐赠道具")
    end
    return 0
end

--- 读表初始化{公会级别->每日获取公会资金上限}的映射
function InitBankrollLimitTable()
    local bankrollLimitStr = TableUtil.GetGuildSettingTable().GetRowBySetting("GuildBankrollDayLimit").Value
    bankrollLimitTable = MgrMgr:GetMgr("TableStrParseMgr").ParseValue(bankrollLimitStr,
            GameEnum.EStrParseType.Matrix, GameEnum.ELuaBaseType.Number)
    ret = {}
    -- 解析后的字符串所得二维矩阵，每行第一个元素为键，第二个元素为值
    for i = 1, #bankrollLimitTable do
        if #bankrollLimitTable[i] ~= 2 then
            logError("[GuildData.InitBankrollLimitTable] 解析字符串{0}无法得到正确键值对", ToString(bankrollLimitTable[i]))
            return
        else
            ret[bankrollLimitTable[i][1]] = bankrollLimitTable[i][2]
        end
    end
    bankrollLimitTable = ret
    if ret == nil or #ret == 0 then
        logError("[GuildData.InitBankrollLimitTable] 公会资金上限信息为空")
    end
end

--初始化公会寻路标记数据
function InitGuildFindPath()
    findPath_activityId = nil  
    findPath_funcId = nil 
    findPath_pos = nil  
    findPath_npcId = nil  
    arriveCallBack = nil
end

--初始化统计数据
function InitCountData()
    curViceChairmanNum = 0
    curDirectorNum = 0
    curDeaconNum = 0
    curBeautyNum = 0
    curOnlineNum = 0
end

--初始化公会水晶数据
function InitGuildCrystalInfo()
    guildCrystalInfo = {}
    guildCrystalInfo.crystalList = {}
    --每个水晶的数据获取
    for i = 1, 6 do
        local l_crystal = {}
        l_crystal.id = i
        l_crystal.level = 1
        l_crystal.exp = 0 --64位
        l_crystal.isStudy = false
        l_crystal.isCharged = false
        table.insert(guildCrystalInfo.crystalList, l_crystal)
    end
    --正在研究的相关数据
    guildCrystalInfo.getExeTimeRemain = 0
    guildCrystalInfo.quickUpgradeUsedCount = 0
    --充能数据
    guildCrystalInfo.chargeFreeTimes = 0
    guildCrystalInfo.chargeLeftTime = 0
    --当前BUFF剩余时间
    guildCrystalInfo.buffAttrList = nil
    guildCrystalInfo.buffLeftTime = 0
end

--初始化公会新闻的数据
function InitGuildNewsInfo()
    guildNewsBelongType = {}
    local l_guildNewsTypeLength = MGlobalConfig:GetInt("GuildNewsTypeLength")
    for i = 1, l_guildNewsTypeLength do
        guildNewsBelongType[i] = {}
        local l_newsTypeData = string.ro_split(MGlobalConfig:GetString("GuildNewsType"..i),"=")
        guildNewsBelongType[i].belongType = l_newsTypeData[1]
        guildNewsBelongType[i].belongTypeName = l_newsTypeData[2]
        guildNewsBelongType[i].belongTypeSprite = l_newsTypeData[3]
        guildNewsBelongType[i].belongTypeAtlas = l_newsTypeData[4]
    end
    local l_data = string.ro_split(MGlobalConfig:GetString("GuildNewsSpiritTalkTimekeeping"),"|")
    gSpriteShoutTime = tonumber(l_data[1])
    gSpriteWaitTime = tonumber(l_data[2])
    local l_dataPos = string.ro_split(MGlobalConfig:GetString("GuildNewsSpiritPlace"),"|")
    gSpriteInitPos = Vector3.New(tonumber(l_dataPos[1]),tonumber(l_dataPos[2]),0)

    local l_guildNewsTable= TableUtil.GetGuildNewsTable().GetTable()
    for i = 1, #l_guildNewsTable do
        gGuildNewsMessageIdTable[tonumber(l_guildNewsTable[i].NewsContent)] = l_guildNewsTable[i]
    end
end

--初始化公会仓库数据 
function InitGuildDepositoryInfo()
    guildDepositoryInfo = {}
    guildDepositoryInfo.nextTimeFrame = 0    --下一个时间节点
    guildDepositoryInfo.capacity = 0         --公会仓库最大容量
    guildDepositoryInfo.itemList = {}        --仓库物品列表
    guildDepositoryInfo.saleList = {}        --拍卖物品列表
    guildDepositoryInfo.lastItemUid = 0      --最后一件仓库存储物品的UID 判断列表是否刷新
end

--初始化公会宴会数据
function InitGuildDinnerInfo()
    dinnerMenu = {}  
    curDishData = {}
    hasOpenDinnerWish = false
    openDinnerWishPlayerName=nil
    dinnerFightTotalNum = 0  
    dinnerFightCurNum = 0  
    dinnerFightInfoShowTime = nil  
    dinnerFightStartTime = nil  
    dinnerFightEndTime = nil
    ClearRankInfo()
end

--初始化公会福利数据
function InitGuildWelfareInfo()
    guildGiftInfo = {}          --公会礼盒信息
    guildGiftSendMemberIds = nil    --公会礼盒发放目标列表 被钩选中的人
    guildWelfareState = EWelfareStateType.Disable   --公会福利分红领取状态
    guildWelfareIsClick = false     --公会福利是否不显示领取按钮小红点状态
    guildWelfareClick = false       --公会福利分红是否领取
end

--初始化公会狩猎信息
function InitGuildHuntInfo()
    guildHuntInfo = {}
    guildHuntInfo.seal = 0  --灵魂碎片使用记录
    guildHuntInfo.state = 0  --当前活动该状态 0未开启 1开启 2开启已结束 
    guildHuntInfo.cdTime = 0  --活动开启CD时间
    guildHuntInfo.leftTime = 0  --活动剩余时间
    guildHuntInfo.usedTimes_open = 0  --本周已使用的开启次数
    guildHuntInfo.maxTimes_open = 0  --本周最大可开启次数
    guildHuntInfo.usedTimes_reward = 0  --本此活动已获得的奖励次数
    guildHuntInfo.maxTimes_reward = 0  --本次活动可获得的最大奖励次数
    guildHuntInfo.isGetFinalReward = false  --是否已获取本次活动的最终奖励
    guildHuntInfo.dungeonList = {}  --公会狩猎FB的数据 包含数据 副本类型 副本id 当前已完成次数 最大次数要求次数
    guildHuntInfo.scoreList = {}  --公会成员战斗成绩排行榜 玩家基础数据 得分 排名
    guildHuntInfo.friendList = {}  --公会成员狩猎剩余次数信息
    guildHuntInfo.selfScore = nil  --个人战斗的得分数据 玩家基础数据 得分 排名
    guildHuntInfo.add = 0

    --传送门ID记录信息
    guildHuntPortalIds = nil
end

--初始化公会绑群相关数据
function InitGuildBindGroupInfo()
    WXCallBackType = EGroupWXCallBackType.Create   --用于区分请求微信公会群状态的回调区分标识符（是否创建和是否加入是一个回调）
    guildGroupId_QQ = 0  --QQ需要记录群ID
    zoneId = "1"    --区编号
    areaId = "1"    --地区编号
end
--endregion------------------ END 初始化方法  ------------------------

--region---------------------------------------- 获取数据  -----------------------------------------------
--获取公会人数
function GetGuildMemberNum()
    return guildBaseInfo.cur_member or 0
end

--获取自己的公会职务
function GetSelfGuildPosition()
    return selfGuildMsg.position
end

--根据编号获取公会职务名称
--PositionId  1会长 2副会长 3理事 4执事 5成员 6特殊成员1 7特殊成员2
function GetPositionName(positionId)
    return guildPositionName[positionId]
end

function IsGuildBeauty(positionId)
    return positionId == EPositionType.Beauty
    --Color(255/255, 134/255, 157/255, 1)
end
--根据建筑ID获取建设信息
--buildingId 建筑ID (EBuildingType枚举值)
function GetGuildBuildInfo(buildingId)
    local l_buildInfo = nil
    for i = 1, #guildBuildInfo do
        if guildBuildInfo[i].id == buildingId then
            l_buildInfo = guildBuildInfo[i]
            break
        end
    end
    return l_buildInfo
end

--根据ID获取指定水晶的数据
function GetCrystalInfo(crystalId)
    return guildCrystalInfo.crystalList[crystalId]
end

function HasOpenDinnerWish()
     return hasOpenDinnerWish
end

function GetDinnerWishOpener()
    return openDinnerWishPlayerName
end

function GetCookEndTime()
    local l_cookEndTime=cookEndTime
    if cookEndTime<0 then
        l_cookEndTime =tonumber(TableUtil.GetGuildActivityTable().GetRowBySetting("CookoffEndTime").Value)
        cookEndTime=l_cookEndTime
    end
    return math.modf( l_cookEndTime / 100 ),math.fmod( l_cookEndTime, 100 )
end

function GetOpenDinnerWishNeedCoinInfo()
    local l_openWishCosCoinStr = TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetChampagneCoin").Value
    local l_coinPropId = 0
    local l_coinPropNeedNum = 0
    local l_coinStrSplit = ParseString(l_openWishCosCoinStr,"=",2)
    if l_coinStrSplit~=nil then
        l_coinPropId=tonumber(l_coinStrSplit[1])
        l_coinPropNeedNum = tonumber(l_coinStrSplit[2])
    end
    return l_coinPropId,l_coinPropNeedNum
end
function GetOpenDinnerWishNeedPropInfo()
    local l_openWishCosPropStr = TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetChampagneItem").Value
    local l_openWishCosPropId = 0
    local l_openWishCosPropNeedNum=0
    local l_propStrSplit = ParseString(l_openWishCosPropStr,"=",2)
    if l_propStrSplit~=nil then
        l_openWishCosPropId=tonumber(l_propStrSplit[1])
        l_openWishCosPropNeedNum = tonumber(l_propStrSplit[2])
    end
    l_openWishCosPropId = 2050008
    l_openWishCosPropNeedNum=1
    return l_openWishCosPropId,l_openWishCosPropNeedNum
end
--获取公会仓库的拍卖清单
function GetGuildDepositorySaleList()
    return guildDepositoryInfo and guildDepositoryInfo.saleList
end
function GetGuildCookScoreColor(rank)
    return guildCookScoreColors[rank]
end
function SetCurrentOrganizeProgressValue(value) 
    l_curOrganizeProgress = value
    local l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    l_guildMgr.EventDispatcher:Dispatch(l_guildMgr.ON_GUILD_ORGANIZE_PROGRESS_UPDATE)
end

function SetCurrentHasGetPersonalRewardKey(value)
    l_curHasGetRewardKey = {}
    for i = 1, #value do
        table.insert(l_curHasGetRewardKey,value[i])
    end
    local l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    l_guildMgr.EventDispatcher:Dispatch(l_guildMgr.ON_GET_GUILD_ORGANIZATION_PERSONAL_REWARD)
end
function AddPersonalRewardKey(value)
    table.insert(l_curHasGetRewardKey,value)
    for i = 1, #l_curCanGetRewardKey do
        if l_curCanGetRewardKey[i]==value then
            table.remove(l_curCanGetRewardKey,i)
            MgrMgr:GetMgr("GuildMgr").onGuildOrganizePersonRewardInfoChanged()
            break
        end
    end
    local l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    l_guildMgr.EventDispatcher:Dispatch(l_guildMgr.ON_GET_GUILD_ORGANIZATION_PERSONAL_REWARD)
end
function HasGetOrganizePersonalReward(organizeContribution)
    for i = 1, #l_curHasGetRewardKey do
        if l_curHasGetRewardKey[i] == organizeContribution then
            return true
        end
    end
    return false
end
function SetCanGetPersonalReward(data)
    l_curCanGetRewardKey = {}
    for i = 1, #data do
        table.insert(l_curCanGetRewardKey,data[i])
    end
    MgrMgr:GetMgr("GuildMgr").onGuildOrganizePersonRewardInfoChanged()
end

function GetCanGetPersonalReward()
    return l_curCanGetRewardKey
end

function GetCurrentOrganizeProgressValue()
    return l_curOrganizeProgress
end

function GetMaxAndMinOrganizeValue()
    if l_MaxOrganizeValue <= 0 then
        local l_manualRows = TableUtil.GetGuildManualTable().GetTable()
        for i = 1, #l_manualRows do
            local l_organizeItem = l_manualRows[i]
            if i==1 then
                l_MinOrganizeValue = l_organizeItem.ManualScore
            end

            if l_organizeItem.ManualScore > l_MaxOrganizeValue then
                l_MaxOrganizeValue = l_organizeItem.ManualScore
            elseif l_organizeItem.ManualScore < l_MinOrganizeValue then
                l_MinOrganizeValue = l_organizeItem.ManualScore
            end
        end
    end
    return l_MaxOrganizeValue,l_MinOrganizeValue
end

function GetAddOrganizeContributionProps()
    if #l_addOrganizeContributtionProps<1 then
        table.insert(l_addOrganizeContributtionProps,MGlobalConfig:GetInt("CrystalItemID"))
        table.insert(l_addOrganizeContributtionProps,MGlobalConfig:GetInt("UnitySculptureID"))
        table.insert(l_addOrganizeContributtionProps,MGlobalConfig:GetInt("CertificateItemID"))
    end
    return l_addOrganizeContributtionProps
end
--endregion------------------------------------- END 获取数据  -----------------------------------------------

--region---------------------------------------- 设置数据  -----------------------------------------------
--设置公会职位名称 仅限两个特殊成员职位
--positionId  1会长 2副会长 3理事 4执事 5成员 6特殊成员1 7特殊成员2
--name 要设置的名称
function SetPositionName(positionId, name)
    if positionId == EPositionType.Special_1 or positionId == EPositionType.Special_2 then
        guildPositionName[positionId] = name
    end
end
function SetDinnerWishOpener(name)
    hasOpenDinnerWish=true
    openDinnerWishPlayerName = name
end
--设置公会成员列表
---@param memberListInfo GuildMemberDetailInfo__Array
function SetGuildMemberList(memberListInfo)
    if not memberListInfo or #memberListInfo == 0 then
        return
    end 

    guildMemberList = {}
    for i = 1, #memberListInfo do
        local l_member = AnalysisMemberInfo(memberListInfo[i])
        if l_member then
            table.insert(guildMemberList, l_member)
        end
    end
end

--设置公会申请列表
function SetGuildApplyList(memberListInfo)
    if not memberListInfo or #memberListInfo == 0 then
        return
    end 

    guildApplyList = {}
    for i = 1, #memberListInfo do
        local l_member = AnalysisMemberInfo(memberListInfo[i])
        if l_member then
            table.insert(guildApplyList, l_member)
        end
    end
end

--解析服务器传来的公会成员数据
---@param memberInfo GuildMemberDetailInfo
---@return ClientGuildMemberDetailInfo
function AnalysisMemberInfo(memberInfo)

    if not memberInfo then
        return nil
    end
    ---@class ClientGuildMemberDetailInfo
    local l_member = {}
    --基础信息
    l_member.baseInfo = AnalysisMemberBaseInfo(memberInfo.base_info)
    --公会职位
    l_member.position = memberInfo.permission
    --当前贡献
    l_member.curContribute = tonumber(tostring(memberInfo.cur_contribute))
    --总贡献
    l_member.totalContribute = tonumber(tostring(memberInfo.total_contribute))
    --成就值
    l_member.achievement = tonumber(tostring(memberInfo.achievement))
    --聊天活跃度
    l_member.activeChat = memberInfo.active_chat
    --战斗活跃度
    l_member.activeFight = memberInfo.active_fight
    --加入公会时间
    l_member.joinTime = memberInfo.join_time
    --在线状态
    l_member.isOnline = memberInfo.is_online
    --上一次离线时间
    l_member.lastOfflineTime = memberInfo.last_offline_time
    --红包列表信息
    l_member.redEnvelopeList = memberInfo.guild_red_envelope_info
    --本周礼盒时候已领取
    l_member.giftIsGet = memberInfo.gift_is_get

    l_member.isOpenChampagne = memberInfo.is_open_champagne
    return l_member
end

--解析公会成员的基础数据
---@return ClientMemberBaseInfo
---@param baseInfo MemberBaseInfo
function AnalysisMemberBaseInfo(baseInfo)

    if not baseInfo then
        return nil
    end
    ---@class ClientMemberBaseInfo
    local l_base = {}
    --角色ID
    l_base.roleId = baseInfo.role_uid
    --职业
    l_base.profession = baseInfo.type
    --名字
    l_base.name = baseInfo.name
    --性别
    l_base.sex = baseInfo.sex
    --人物等级
    l_base.baseLv = baseInfo.base_level
    --职业等级
    l_base.jobLv = baseInfo.job_level
    --外观数据
    l_base.outlook = baseInfo.outlook
    --装备数据
    l_base.equip_ids = baseInfo.equip_ids
    --玩家标签
    l_base.tag = baseInfo.tag

    return l_base
end

--设置公会华丽水晶数据
function SetGuildCrystalInfo(crystalInfo)
    guildCrystalInfo = {}
    guildCrystalInfo.crystalList = {}
    --每个水晶的数据获取
    for i = 1, #crystalInfo.crystal_list do
        local l_crystal = {}
        l_crystal.id = crystalInfo.crystal_list[i].id
        l_crystal.level = crystalInfo.crystal_list[i].level
        l_crystal.exp = crystalInfo.crystal_list[i].exp --64位
        l_crystal.isStudy = false
        l_crystal.isCharged = false
        table.insert(guildCrystalInfo.crystalList, l_crystal)
    end
    --正在研究的相关数据
    if crystalInfo.cur_upgrade_crystal ~= 0 then
        guildCrystalInfo.crystalList[crystalInfo.cur_upgrade_crystal].isStudy = true
    end
    guildCrystalInfo.getExeTimeRemain = crystalInfo.upgrade_left_time
    guildCrystalInfo.quickUpgradeUsedCount = crystalInfo.quick_upgrade_used_count
    --充能相关数据
    for i = 1, #crystalInfo.give_energy_crystal_list do
        guildCrystalInfo.crystalList[crystalInfo.give_energy_crystal_list[i].value].isCharged = true
    end
    guildCrystalInfo.chargeFreeTimes = crystalInfo.give_energy_free_used_count
    guildCrystalInfo.chargeLeftTime = crystalInfo.give_energy_left_time
    --当前BUFF剩余时间
    guildCrystalInfo.buffAttrList = crystalInfo.attr_list
    guildCrystalInfo.buffLeftTime = crystalInfo.buff_left_time
end

--设置公会仓库数据
function SetGuildDepositoryInfo(info)
    --下一个时间节点的倒计时获取
    guildDepositoryInfo.nextTimeFrame = tonumber(tostring(info and info.nextauctiontime or 0))
    --当前最大容量获取
    guildDepositoryInfo.capacity = info and info.maxcellcount or 0
    --设置公会仓库存储物品列表
    SetGuildDepositoryItemList(info)
    --设置公会仓库拍卖物品列表
    SetGuildDepositorySaleList(info)
end

--设置公会仓库存储物品列表
function SetGuildDepositoryItemList(info)
    if info and info.cells and #info.cells > 0 then
        --判断原本是否有缓存 或者 缓存和服务器上的仓库物品列表是否不一致
        if not guildDepositoryInfo.itemList or
            #guildDepositoryInfo.itemList == 0 or
            #guildDepositoryInfo.itemList ~= #info.cells or
            guildDepositoryInfo.lastItemUid ~= info.cells[#info.cells].itemuuid then

            guildDepositoryInfo.itemList = {}
            for i = 1, #info.cells do
                local l_temp = info.cells[i]
                local l_itemData = {}
                l_itemData.itemId = l_temp.itemid
                l_itemData.itemUid = l_temp.itemuuid
                l_itemData.itemQuality = 0
                l_itemData.isAttented = l_temp.isattention
                local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_temp.itemid)
                if l_itemRow then
                    l_itemData.itemQuality = l_itemRow.ItemQuality
                end
                table.insert(guildDepositoryInfo.itemList, l_itemData)
            end
            --记录最后一件物品的UID
            guildDepositoryInfo.lastItemUid = info.cells[#info.cells].itemuuid
            --按稀有度排序
            table.sort(guildDepositoryInfo.itemList, function (a, b)
                if a.itemQuality > b.itemQuality then 
                    return true
                elseif a.itemQuality == b.itemQuality then
                    return a.itemId < b.itemId
                else
                    return false
                end
            end)
        end
    else
        guildDepositoryInfo.itemList = {}
    end
end

--设置公会仓库拍卖物品列表
function SetGuildDepositorySaleList(info)
    --判断是否有拍卖物品清单
    if info and info.auctions and info.auctions.items and #info.auctions.items > 0 then
        --若有拍卖清单则记录
        local l_saleItemList = info.auctions.items
        if not guildDepositoryInfo.saleList or
            #guildDepositoryInfo.saleList == 0 or
            #guildDepositoryInfo.saleList ~= #l_saleItemList or 
            guildDepositoryInfo.saleList[1].itemUid ~= l_saleItemList[1].itemuuid then
            --原本没有缓存则 或者 列表不对应 则初始化拍卖列表
            guildDepositoryInfo.saleList = {}
            for i = 1, #l_saleItemList do
                local l_saleItem = {}
                l_saleItem.itemUid = l_saleItemList[i].itemuuid
                l_saleItem.itemId = l_saleItemList[i].itemid
                l_saleItem.reservePrice = l_saleItemList[i].baseprice
                l_saleItem.selfPrice = l_saleItemList[i].myprice
                l_saleItem.isAttended = l_saleItemList[i].isattention
                l_saleItem.lastModifyTime = tonumber(tostring(l_saleItemList[i].lastchangepricetime))  --上一次修改竞价的时间(第一次出价不会有值)
                l_saleItem.lastCancelTime = tonumber(tostring(l_saleItemList[i].lastcancletime))  --上一次取消竞价的时间
                l_saleItem.itemName = nil  --物品名称 这里只做申明
                l_saleItem.tempPrice = 0  --临时操作价格 这里只做初始化 缓存记录列表 也是因为这个值
                table.insert(guildDepositoryInfo.saleList, l_saleItem)
            end
        end
    else
        --如果没有拍卖清单 则置空
        guildDepositoryInfo.saleList = {}
    end
end

--设置公会仓库物品的关注
function SetGuildDepositoryItemAttention(itemUid, isAttented)
    if guildDepositoryInfo.itemList and #guildDepositoryInfo.itemList > 0 then
        for i = 1, #guildDepositoryInfo.itemList do
            local l_temp = guildDepositoryInfo.itemList[i]
            if l_temp.itemUid == itemUid then
                l_temp.isAttented = isAttented
                break
            end
        end
    end
end
--region 公会宴会
--设置公会宴会菜单数据
function SetGuildDinnerMenu(menuInfo)
    dinnerMenu = {}
    for i = 1, #menuInfo do
        local l_dishInfo = menuInfo[i]
        local l_dish = {}
        l_dish.rank = l_dishInfo.rank
        l_dish.count = l_dishInfo.dish_count
        l_dish.time = l_dishInfo.cost_time
        l_dish.name1 = l_dishInfo.member_list and l_dishInfo.member_list[1] and l_dishInfo.member_list[1].base_info.name or "————"
        l_dish.name2 = l_dishInfo.member_list and l_dishInfo.member_list[2] and l_dishInfo.member_list[2].base_info.name or "————"
        l_dish.score=l_dishInfo.score
        table.insert(dinnerMenu, l_dish)
    end
    table.sort(dinnerMenu, function(a, b) return a.rank < b.rank end)
end

--@Description:设置公会宴会烹饪比赛积分相关信息
function SetGuildCookScoreInfo(data)
    if data==nil then
        guildCookScoreInfo.guildNum=0
        return
    end
    guildCookScoreInfo.guildNum=#data
    for i = 1, guildCookScoreInfo.guildNum do
        local l_guildInfo=data[i]
        local l_guildScoreInfo=guildCookScoreInfo[i]
        if l_guildScoreInfo==nil then
            l_guildScoreInfo=
            {
                rank = l_guildInfo.rank,
                guildName = l_guildInfo.guild_name,
                guildScore = l_guildInfo.guild_score,
                guildIconId = l_guildInfo.icon_id,
                member1BaseInfo = l_guildInfo.member_list[1],
                member2BaseInfo = l_guildInfo.member_list[2],
            }
            guildCookScoreInfo[i]=l_guildScoreInfo
        end
        l_guildScoreInfo.rank = l_guildInfo.rank
        l_guildScoreInfo.guildName = l_guildInfo.guild_name
        l_guildScoreInfo.guildScore = l_guildInfo.guild_score
        l_guildScoreInfo.guildIconId = l_guildInfo.icon_id
        l_guildScoreInfo.member1BaseInfo = l_guildInfo.member_list[1]
        l_guildScoreInfo.member2BaseInfo = l_guildInfo.member_list[2]
    end
end
function ClearRankInfo()
    guildCookScoreInfo = { guildNum =0 }
    allGuildPersionalRank={}
    selfGuildPersionalRank={}
end
function GetGuildCookScoreInfo()
    return guildCookScoreInfo
end
function GetMyGuildCookScoreInfo()
    if guildBaseInfo==nil then
        return
    end
    local l_myGuildName = guildBaseInfo.name
    local l_guildCookInfo
    for i = 1, #guildCookScoreInfo do
        local l_tempGuildCookInfo= guildCookScoreInfo[i]
        if l_tempGuildCookInfo.guildName == l_myGuildName then

            l_guildCookInfo = l_tempGuildCookInfo
        end
    end
    return l_guildCookInfo
end
--@Description:设置公会宴会烹饪比赛个人排行榜信息
function SetGuildCookScorePersionalRank(data,isAll)
    local l_persionalRankInfos
    if isAll then
        l_persionalRankInfos=allGuildPersionalRank
    else
        l_persionalRankInfos=selfGuildPersionalRank
    end
    for i = 1, #l_persionalRankInfos do
        ReleaseRankMemberInfo(l_persionalRankInfos[i])
    end
    l_persionalRankInfos={}
    for i = 1, #data do
        local l_roleRankInfo = data[i]
        local l_member1Name
        local l_member2Name
        if #l_roleRankInfo.member_list>1 then
            l_member1Name = l_roleRankInfo.member_list[1]
            l_member2Name = l_roleRankInfo.member_list[2]
        else
            l_member1Name = ""
            l_member2Name = ""
            logError("GuildDinnerGetPersonResult msg roleName is not enough!")
        end
        local l_tempData = GetRankMemberInfoFromPool(l_roleRankInfo.rank,l_member1Name,l_member2Name,
                l_roleRankInfo.guild_name,l_roleRankInfo.score,l_roleRankInfo.time,l_roleRankInfo.count)
        table.insert(l_persionalRankInfos,l_tempData)
    end
    if isAll then
        allGuildPersionalRank = l_persionalRankInfos
    else
        selfGuildPersionalRank = l_persionalRankInfos
    end
end
function GetGuildCookScorePersionalRank(isAll)
    if isAll then
        return allGuildPersionalRank
    end
    return selfGuildPersionalRank
end

function SetRandomEventStartTime(time)
    local l_eventStartTime = MLuaCommonHelper.Int(time/1000)
    isRandomEventTouched = l_eventStartTime==0
    if not isRandomEventTouched then
        guildCookRandomEventStartTime = l_eventStartTime
    else
        guildCookRandomEventTouchTime=Common.TimeMgr.GetNowTimestamp()
    end
end
function IsRandomEventTouched()
    return isRandomEventTouched,guildCookRandomEventTouchTime
end
function GetRandomEventStartTime()
    return guildCookRandomEventStartTime
end
--获取宴会随机事件持续时间
function GetRandomEventLastTime()
    if randomEventLastTime<0 then
        randomEventLastTime=30
        local l_eventLastTimeItem = TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetEventLastTime")
        if not MLuaCommonHelper.IsNull(l_eventLastTimeItem) then
            randomEventLastTime = tonumber(l_eventLastTimeItem.Value)
        end
    end
    return randomEventLastTime
end
--待抽象优化
function GetRankMemberInfoFromPool(rank,member1,member2,guildName,score,useTime,cookNum)
    local l_data=nil
    for i = 1, #cookRankMemberPool do
        local l_tempData=cookRankMemberPool[i]
        if not l_tempData.isUsing then
            l_data=l_tempData
        end
    end
    if l_data == nil then
        l_data =
        {
            rank = rank,
            member1Name = member1,
            member2Name = member2,
            guildName = guildName,
            score = score,
            useTime=useTime,
            cookNum = cookNum,
        }
        table.insert(cookRankMemberPool,l_data)
    else
        l_data.rank=rank
        l_data.member1Name = member1
        l_data.member2Name = member2
        l_data.guildName = guildName
        l_data.score = score
        l_data.useTime = useTime
        l_data.cookNum = cookNum
    end

    l_data.isUsing = true
    return l_data
end
function ReleaseRankMemberInfo(data)
    data.isUsing = false
end
function ClearRankMemberInfo(clearData)
    if clearData then
        cookRankMemberPool = {}
        return
    end
    for i = 1, #cookRankMemberPool do
        local l_tempData = cookRankMemberPool[i]
        l_tempData.isUsing=false
    end
end
--endregion
--设置公会礼盒数据
function SetGuildGiftInfo(giftInfo)
    guildGiftInfo.have = giftInfo.gift_count
    guildGiftInfo.max = giftInfo.gift_total_count
    guildGiftInfo.weekGet = 0
    guildGiftInfo.guildHunt = 0
    guildGiftInfo.guildOrganizeContribution = 0
    for i = 1, #giftInfo.gift_week_type do
        local l_giftWeekType = giftInfo.gift_week_type[i]
        if l_giftWeekType.value == 1 then
            guildGiftInfo.guildHunt = giftInfo.gift_week_count[i] and giftInfo.gift_week_count[i].value or 0
        elseif l_giftWeekType.value == 2 then
            guildGiftInfo.guildOrganizeContribution = giftInfo.gift_week_count[i] and giftInfo.gift_week_count[i].value or 0
        end
    end
    guildGiftInfo.weekGet = guildGiftInfo.guildHunt + guildGiftInfo.guildOrganizeContribution
end

--设置公会狩猎数据
function SetGuildHuntInfo(huntInfo)
    --信息数据获取
    guildHuntInfo.state = huntInfo.state
    guildHuntInfo.cdTime = huntInfo.open_cd
    guildHuntInfo.leftTime = huntInfo.left_time
    guildHuntInfo.usedTimes_open = huntInfo.open_used_count
    guildHuntInfo.maxTimes_open = huntInfo.open_max_count
    guildHuntInfo.usedTimes_reward = huntInfo.reward_used_count
    guildHuntInfo.maxTimes_reward = huntInfo.reward_max_count
    guildHuntInfo.isGetFinalReward = huntInfo.is_get_final_reward
    guildHuntInfo.dungeonList = huntInfo.dungeon_list
    guildHuntInfo.selfScore = huntInfo.self_score
    guildHuntInfo.seal = huntInfo.seal_piece_used_times
    guildHuntInfo.add = huntInfo.has_additional_hunt_count
    --排行榜获取
    guildHuntInfo.scoreList = {}
    for i = 1, #huntInfo.score_list do 
        local l_temp = {}
        l_temp.member_info = huntInfo.score_list[i].member_info
        l_temp.score = huntInfo.score_list[i].score
        l_temp.rank = huntInfo.score_list[i].rank
        l_temp.diffScore = {huntInfo.score_list[i].difficult_count, huntInfo.score_list[i].common_count, huntInfo.score_list[i].simple_count}
        table.insert(guildHuntInfo.scoreList, l_temp)
    end
    table.sort(guildHuntInfo.scoreList, function(a, b)
        return a.rank < b.rank
    end)
end
--endregion------------------------------------- END 设置数据  -----------------------------------------------

--region---------------------------------------- 数据释放  -----------------------------------------------
--释放公会成员列表
function ReleaseGuildMemberList()
    guildMemberList = nil
    curGuildMemberListType = EMemberListType.AllList  --列表类型重置
end

--释放公会申请列表
function ReleaseGuildApplyList()
    guildApplyList = nil
end

--释放公会仓库数据
function ReleaseGuildDepositoryInfo()
    InitGuildDepositoryInfo()
end

--释放公会宴会奶油大乱斗数据
function ReleaseGuildDinnerFightInfo()
    dinnerFightTotalNum = 0  --大乱斗参与总人数
    dinnerFightCurNum = 0  --大乱斗剩余人数
    dinnerFightInfoShowTime = nil  --大乱斗信息展示时间
    dinnerFightStartTime = nil  --大乱斗开始时间
    dinnerFightEndTime = nil  --大乱斗结束时间
end

--endregion------------------------------------- END 数据释放  -----------------------------------------------

--region------------------------------公会成员列表排序与统计---------------------------------------
--成员列表排序
---@param memberList ClientGuildMemberDetailInfo[]
---@return ClientGuildMemberDetailInfo[]
function SortMemberList(memberList, sortType, isNeedCount)
    
    --待排序目标列表为空直接返回
    if not memberList then
        return
    end
    local l_sortedList = memberList

    --排序
    if sortType == EMemberSortType.None then
        --不排序
    elseif sortType == EMemberSortType.Normal then
        --默认排序
        l_sortedList = SortMember_Normal(l_sortedList, isNeedCount)
    elseif sortType == EMemberSortType.NormalBox then
        --默认排序(礼盒发放)
        l_sortedList = SortMember_NormalBox(l_sortedList)
    elseif sortType == EMemberSortType.Name then
        --名字排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_Name(a, b)
        end)
    elseif sortType == EMemberSortType.Level then
        --等级排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_Level(a, b)
        end)
    elseif sortType == EMemberSortType.Job then
        --职业排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_Job(a, b)
        end)
    elseif sortType == EMemberSortType.Position then
        --职务排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_Position(a, b)
        end)
    elseif sortType == EMemberSortType.Contribution then
        --贡献排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_Contribution(a, b)
        end)
    elseif sortType == EMemberSortType.Achievement then
        --成就排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_Achievement(a, b)
        end)
    elseif sortType == EMemberSortType.Activity then
        --活跃排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_Activity(a, b)
        end)
    elseif sortType == EMemberSortType.ActivityChat then
        --发言排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_ActivityChat(a, b)
        end)
    elseif sortType == EMemberSortType.ActivityFight then
        --战绩排序
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_ActivityFight(a, b)
        end)
    elseif sortType == EMemberSortType.StateOfflineTime then
        --在线状态排序(离线时间、名字作为第二规则)
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_StateOfflineTime(a, b)
        end)
    elseif sortType == EMemberSortType.StateBaseLv then
        --在线状态排序(等级作为第二规则)
        table.sort(l_sortedList, function(a, b)
            return MemberCompare_StateBaseLv(a, b)
        end)
    end
    --返回排序后的
    return l_sortedList
end

--默认成员排序
--排序规则 自己 -> 在线 -> 离线
--等级降序
function SortMember_Normal(memberDataList, isNeedCount)
    --需要统计的话 清理原本统计数据
    if isNeedCount then
        InitCountData()
    end

    local l_result = {}
    local l_onLine = {}
    local l_offLine = {}
    local l_selfId = tonumber(tostring(MPlayerInfo.UID))
    local l_findSelf = false  --是否找到自己的标志 找到自己之后就不再对比ID 减少消耗
    --先分组
    for i = 1, #memberDataList do
        local l_member = memberDataList[i]
        if not l_findSelf and tonumber(tostring(l_member.baseInfo.roleId)) == l_selfId then
            table.insert(l_result, l_member)
            l_findSelf = true
        elseif l_member.isOnline then
            table.insert(l_onLine, l_member)
        else
            table.insert(l_offLine, l_member)
        end
        --公会相关人数统计
        if isNeedCount then
            GuildMemberCount(l_member)
        end
    end
    --排序
    table.sort(l_onLine, function(a,b) return a.baseInfo.baseLv > b.baseInfo.baseLv end)
    table.sort(l_offLine, function(a,b) return a.baseInfo.baseLv > b.baseInfo.baseLv end)
    --合成总表
    table.ro_insertRange(l_result, l_onLine)
    table.ro_insertRange(l_result, l_offLine)
    --返回
    return l_result
end

--默认成员(礼盒发放)排序
--排序规则 职务 -> 贡献
function SortMember_NormalBox(memberDataList)
    local l_result = memberDataList
    table.sort(l_result, function(a,b)
        if a.position == b.position then
            return a.totalContribute > b.totalContribute  --同职务时比较贡献
        else
            return a.position < b.position
        end
    end)
    return l_result
end


--成员姓名的排序对比
function MemberCompare_Name(a, b)
    if a.baseInfo.name and b.baseInfo.name then
        --直接return这个函数调用 会报错
        if MLuaClientHelper.CompareStringByCurrentCulture(a.baseInfo.name, b.baseInfo.name) then  
            return true
        end
        return false
    elseif a.baseInfo.name then
        return true
    else
        return false
    end
end

--成员基础等级排序对比
function MemberCompare_Level(a, b)
    if not a.baseInfo or not a.baseInfo.baseLv then  
        --a为空 往后排
        return false
    elseif not b.baseInfo or not b.baseInfo.baseLv then  
        --b为空 往后排
        return true
    elseif a.baseInfo.baseLv == b.baseInfo.baseLv then
        --同等级 按姓名排序
        return MemberCompare_Name(a, b)
    else
        return a.baseInfo.baseLv > b.baseInfo.baseLv
    end
end

--成员职业排序对比
function MemberCompare_Job(a, b)
    if not a.baseInfo or not a.baseInfo.profession then  --前者为空直接往后扔
        return false
    elseif not b.baseInfo or not b.baseInfo.profession then  --后者为空直接往后扔
        return true
    elseif a.baseInfo.profession == 1000 and a.baseInfo.profession ~= b.baseInfo.profession then  --初心者放最后 前者为初心者 前者直接往后扔
        return false
    elseif b.baseInfo.profession == 1000 and a.baseInfo.profession ~= b.baseInfo.profession then  --初心者放最后 后者为初心者 后者直接往后扔
        return true
    elseif a.baseInfo.profession == b.baseInfo.profession then  --先判同职业防止前后两者都为空
        return MemberCompare_Name(a, b)  --同职业
    else
        return a.baseInfo.profession < b.baseInfo.profession
    end
end

--成员公会职位排序对比
function MemberCompare_Position(a, b)
    if a.position == b.position then
        return MemberCompare_Name(a, b)  --同职务
    else
        return a.position < b.position
    end
end

--成员贡献排序对比
function MemberCompare_Contribution(a, b)
    if a.totalContribute == b.totalContribute then
        return MemberCompare_Name(a, b)  
    else
        return a.totalContribute > b.totalContribute
    end
end

--成员成就排序对比
function MemberCompare_Achievement(a, b)
    if a.achievement == b.achievement then
        return MemberCompare_Name(a, b)  
    else
        return a.achievement > b.achievement
    end
end

--成员活跃度排序对比
function MemberCompare_Activity(a, b)
    local l_activityA = a.activeChat / 2 + a.activeFight
    local l_activityB = b.activeChat / 2 + b.activeFight
    if l_activityA == l_activityB then
        return MemberCompare_Name(a, b)  
    else
        return l_activityA > l_activityB
    end
end

--成员发言活跃度排序对比
function MemberCompare_ActivityChat(a, b)
    if a.activeChat == b.activeChat then
        return MemberCompare_Name(a, b)  --同发言
    else
        return a.activeChat > b.activeChat
    end
end

--成员战斗活跃度排序对比
function MemberCompare_ActivityFight(a, b)
    if a.activeFight == b.activeFight then
        return MemberCompare_Name(a, b)  --同战绩
    else
        return a.activeFight > b.activeFight
    end
end

--成员在线状态排序对比(在线 => 离线时间 => 名字)
function MemberCompare_StateOfflineTime(a, b)
    if a.isOnline and b.isOnline then
        return false  --同在线
    elseif a.isOnline then
        return true
    elseif b.isOnline then
        return false
    elseif tonumber(a.lastOfflineTime) > tonumber(b.lastOfflineTime) then
        return true
    elseif tonumber(a.lastOfflineTime) == tonumber(b.lastOfflineTime) then
        return MemberCompare_Name(a, b)  --同离线时间
    else
        return false
    end
end

--成员在线状态排序对比(在线 => 离线 => 人物等级)
function MemberCompare_StateBaseLv(a, b)
    if a.isOnline == b.isOnline then  --同时在线或离线对比等级
        return MemberCompare_Level(a, b)
    else  --在离线非同状态 直接返回前者的状态即可
        return a.isOnline
    end
end


--公会人员数量统计
function GuildMemberCount(member)
    --管理人员数量统计
    if member.position == EPositionType.ViceChairman then
        curViceChairmanNum = curViceChairmanNum + 1
    elseif member.position == EPositionType.Director then
        curDirectorNum = curDirectorNum + 1
    elseif member.position == EPositionType.Deacon then
        curDeaconNum = curDeaconNum + 1
    elseif member.position == EPositionType.Beauty then
        curBeautyNum = curBeautyNum + 1
    end
    --在线人数统计
    if member.isOnline then
        curOnlineNum = curOnlineNum + 1
    end
end

--倒序翻转成员列表
function ReverseMemberList(memberList)
    local l_result = {}
    if memberList and #memberList > 0 then
        for i = #memberList , 1, -1 do
            table.insert(l_result, memberList[i])
        end
    end
    return l_result
end

--endregion-----------------------------End 公会成员列表排序与统计-------------------------------------
return ModuleData.GuildData