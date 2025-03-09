require "Data/Model/PlayerInfoModel"

---@module ModuleMgr.OpenSystemMgr
module("ModuleMgr.OpenSystemMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

eSystemId = {
    EquipShardExchange = 4100, -- 装备碎片兑换
    EquipSwapAttr = 3099, -- 装备一键交换属性
    EquipReform = 10820, -- 装备改造
    RefineTransfer = 10811, -- 精炼转移
    RefineSeal = 10812, -- 精炼解封
    RefineAssist = 10818, -- 精炼助手
    EnchantmentAssist = 10819, -- 附魔助手
    EnchantExtract = 10810, -- 附魔提炼
    EnchantInherit = 10817, -- 附魔继承
    Bag = 101,
    AutomaticDrinkMedicine = 151,
    Camera = 104,
    Album = 105,
    Setup = 107,
    Skill = 102,
    Garderobe = 106, --衣橱
    GarderobeAward = 10601, --时尚度奖励
    Risk = 109, --活动按钮
    Shop = 999,
    Activity = 103,
    EyeShopId = 1050, --美瞳店
    HairShopcId = 1040, --美发店
    Forge = 108, --打造，合成，插卡的集合
    Guild = 111,
    Achievement = 113,
    AchievementLevel = 11301, --成就等级奖励
    AchievementReward = 11302, --领取成就奖励
    Illustrator = 114, --手册
    AdventureDiary = 116, --冒险日记
    IllustratorEquip = 11404, --装备图鉴
    IllustratorMonster = 11405, --怪物图鉴
    IllustratorCard = 11406, --卡片图鉴
    Delegate = 117,
    Mall = 118, --波利商城
    MallGoldHot = 11801, -- 金币 热销
    MallGoldGift = 11802, -- 金币 礼包
    MallMasterHouseZeny = 11803, -- 万事屋 zeny
    MallMasterHouseCoin = 11804, -- 万事屋 铜币
    MallMysteryShop = 11805, -- 神秘商店 每日限时
    MallFeeding = 11806, -- 充值界面
    TotalRechargeAward = 11807, -- 累计充值奖励
    MallGoldAppearance = 11808,
    GiftPackage = 11209, -- 礼包
    Festival = 180,
    ChatRoom = 121, --聊天室
    ChatForbid = 152, --聊天屏蔽
    Refine = 10802, -- 精炼
    Enchant = 10803, -- 附魔
    ForgeSub = 10801, --打造
    Compound = 10806, --道具合成
    LifeProfession = 6000, --生活技能
    LifeProfessionGather = 6010, --采集
    LifeProfessionMining = 6020, --挖矿
    LifeProfessionFish = 6030, --钓鱼
    LifeProfessionCook = 6040, --烹饪
    LifeProfessionDrug = 6050, --制药
    LifeProfessionSweet = 6060, --甜品
    LifeProfessionSmelt = 6070, --冶炼武器
    LifeProfessionArmor = 6080, --冶炼防具
    LifeProfessionAcces = 6090, --冶炼饰品
    LifeProfessionFoodFusion = 6110, --烹饪组合
    LifeProfessionMedicineFusion = 6120, --制药组合
    EquipCard = 10804, -- 插卡
    MakeHole = 10805, -- 打洞
    Friend = 130, --好友(暂没用，占位)
    Email = 13001, --邮件(暂没用，占位)
    PresentGift = 13002, --赠送礼物
    Wabao = 5060, -- 挖宝
    Questionnaire = 998, --问卷调查
    CardSell = 3051, --卡片出售
    MaterialMake = 10807, --材料制造
    Displace = 10808, --置换器
    UseDisplace = 10809, --使用置换器
    RecoveCard = 3090, --卡片分解
    ExtractCard = 3091, --卡片抽卡
    UnsealCard = 9012, --卡片解封
    RecoveHead = 3092, --头饰分解
    ExtractHead = 3093, --头饰抽取
    RecoveEquip = 3097, --装备分解
    ExtractEquip = 3098, --装备抽取
    GuildCook = 7001, --公会宴会
    GuildShop = 7007, --公会商店
    GuildCrystal = 7008,
    GuildHunt = 7009, --公会狩猎
    GuildWeekCook = 7012, --公会周末宴会
    ActivityCheckIn = 8001, --节日活动签到
    BingoActivity = 12010, -- Bingo活动
    ActivityNewKing = 13000, -- 新王的号角
    ItemSell = 3011, --道具出售
    WorldPve = 5130, --世界奇闻
    CatCaravan = 5131, --猫手商队
    TowerDefenseSingle = 5160, --塔防单人
    TowerDefenseDouble = 5161, --塔防双人
    TowdrDefenseEntrance = 5164, -- 塔防入口
    ArenaShop = 15003,
    AssistShop = 3070,
    MonsterShop = 3080,
    Task = 9008, --任务
    LevelUp = 5121, --野外挂机
    Vehicle = 140, --载具
    VehicleAbility = 9006, --载具能力
    VehicleQuality = 9009, --载具素质
    VehicleSkill = 9010, --载具技能
    VehicleAmulet = 9011, --载具护符
    ThemeDungeon = 5020, -- 主题副本
    ThemeChallenge = 5023, -- 主题副本挑战
    ThemeStory = 5025, -- 主题副本挑战
    Welfare = 112, --福利
    LandingAward = 11201, --登陆奖励
    SignIn = 11202, --签到
    MonthCard = 11204, --月卡
    CapraCard = 1220, --卡普拉礼品卡
    FirstRecharge = 11208, -- 首充
    VIPCard = 1221, --vip卡
    PrivilegedPackage = 11205, --特权礼包
    SubscribeTo = 11206, --订阅
    Suit = 10813, -- 套装
    EnchantAdvanced = 10814, --高级附魔
    BeginnerBook = 116, --萌新手册
    FashionRating = 15010, --时尚评分
    FashionCountAward = 15011, --新版时尚度奖励
    Delegate = 117, --委托
    Barber = 1080, --头饰商店
    VehicleBarber = 1081, --载具兑换
    MonsterExpel = 5110, --魔物驱逐
    HsMonster = 5050, --圣歌试炼
    Tower = 5031, --无限塔
    TowerReward = 5034, --无限塔首通
    forgeWeapon = 3094, --武器制作
    forgeArmor = 3095, --防具制作
    TimeLimitPay = 10816, --限时特惠
    Merchant = 5123, --跑商
    LevelReward = 11203, --等级礼包
    Personal = 11402, --个性化图鉴
    BoliHandBook = 11403, --波利团
    HeadBook = 11409, --头像
    TitleBook = 11407, --称号
    IconFrame = 11410, -- 头像框
    DialogBg = 11411, -- 气泡框
    ChatTag = 11412, -- 聊天标签
    TrolleyFuncId = 1110,
    BattleBirdFuncId = 1109,
    BattleVehicleFuncId = 1108,
    QueueSkillFuncId = 1028,
    GuildStoneOpenId = 7014,
    MVP = 5100, -- MVP
    DelegateExchange = 11701, -- 委托兑换商店
    DelegateReward = 11702, -- 委托犒赏
    AutoBattle = 144, --自动战斗
    SkillMultiTalent = 145, --技能双天赋
    AttrMultiTalent = 146, --属性双天赋
    EquipMultiTalent = 147, --装备双天赋
    Collocation = 148, --搭配界面
    Medal = 115, --勋章
    MainRoleInfo = 143, --角色界面
    AutoPotionSetting = 1205, -- 自动吃药
    AutoRangeSetting = 1206, -- 挂机范围
    AutoPickSetting = 1207, -- 自动拾取
    AutoFightType = 1029, -- 自动战斗类型
    ThemeParty = 2003, --主题派对
    ThemePartyShop = 2005, --主题派对商店
    Mercenary = 122, --佣兵系统
    MercenaryUpgrade = 12201, -- 佣兵升级
    MercenaryTalent = 12202, -- 佣兵天赋
    PushNotification = 171, -- 推送
    Sweater = 110, -- 交易
    Trade = 11001, -- 商会
    Stall = 11002, -- 摆摊
    Auction = 11003, -- 拍卖
    BlackShop = 11006, -- 黑市
    Consultation = 1701, --卡普拉问答
    Recommend = 1702, --贴士（百科）
    ExchangeCode = 11207, -- 兑换码
    RateApp = 1085, --游戏评价 （一个小弹框）
    Share_Sdk = 1089, --sdk分享功能
    Share_Story = 6710, --剧情分享功能
    --region 聊天快捷工具
    Emoticon = 16001, --表情
    QuickTalk = 16002, --常用语
    ChatProp = 16003, --聊天中的道具
    RedEnvelope = 16004, --聊天中的红包
    RoleGrow = 16005, --角色成长
    ChatAchievement = 16006, --聊天中的成就
    ChatCloth = 16007, --典藏值
    MagicLetter = 16008, --魔法信笺
    --endregion

    -- 回归
    Return = 11213,
    ReturnTask = 11215,
    ReturnLogin = 11214,
    ReturnPointShop = 11216,
    ReturnPayShop = 11217,
    ReBackPrivilege = 11218,

    ChatVoice = 16009, --语音聊天
    Beiluz = 10821, -- 贝鲁兹
    BeiluzCombine = 10822, -- 贝鲁兹合成
    BeiluzReset = 10823, -- 贝鲁兹重置
    BeiluzMaintain = 10824, --贝鲁兹保养
    RebateMonthCardNormal = 124, --普通返利月卡
    RebateMonthCardSuper = 125, --超级返利月卡
    RebateMonthCardOnceBuy = 12401, --一次性购买普通月卡剩余奖励
    RebateSuperardOnceBuy = 12501, --一次性购买超级月卡剩余奖励
    PaymentTips = 20002, -- 花费真实货币时是否进行提示（目前只有韩国用到）
    CardExchangeShop = 19007,
    PaymentTips = 20002, -- 花费真实货币时是否进行提示（目前只有韩国用到）
    MonsterDrap = 1000000, -- 怪物掉落
    EliteDrap = 1000001, -- 精英掉落
    PackageDrap = 1000002, -- 礼包
    BlessedExperience = 153, -- 礼包
    ThemeParty = 2001, -- 主题派对
    --萌新奖励
    NewPlayer = 11311,
    NewPlayerGift = 11312,
    NewPlayerShop = 11313,
    NewPlayerShow = 11314,
    --卡普拉问答
    CapraFaq = 170,
}

EFunctionType = {
    MainPanel = 1,
    SecondPanel = 2,
    NPC = 3,
    SpecialPanel = 4,
}

local extraCheckCases = {
    [eSystemId.LandingAward] = function()
        return MgrMgr:GetMgr("LandingAwardMgr").IsSystemOpenExtraCheck()
    end,
    [eSystemId.SignIn] = function()
        return MgrMgr:GetMgr("SignInMgr").IsSystemOpenExtraCheck()
    end,
    [eSystemId.TimeLimitPay] = function()
        return MgrMgr:GetMgr("TimeLimitPayMgr").IsSystemOpenExtraCheck()
    end,
    [eSystemId.ActivityCheckIn] = function()
        return MgrMgr:GetMgr("ActivityCheckInMgr").IsSystemOpenExtraCheck()
    end,
    default = function()
        return true
    end,
}

OpenSystemFuncPreviewId = MGlobalConfig:GetInt("OpenSystemFuncPreviewId")
local specialOpenBtnIds = { OpenSystemFuncPreviewId, 101, 151, 10821 }

--开启的系统有改变
OpenSystemChange = "OnOpenSystemChange"
--开启的系统动画结束
OpenSystemFinish = "OpenSystemFinish"
--系统预览
OpenSystemPreview = "OpenSystemPreview"
--系统预览领奖
OpenSystemReward = "OpenSystemReward"
--功能开启一次结束时调用
ShowOpenFinishEvent = "ShowOpenFinishEvent"
--3个位置的按钮的父物体
ButtonRoot = { "RightUpButtonA", "RightUpButtonB", "RightPanel", "RightPanelB" }
StandardButton = "standardButton"
-- 开启系统数据有更新
OpenSystemUpdate = "OpenSystemUpdate"
--关闭功能
CloseSystemEvent = "CloseSystemEvent"

--开启的功能
OpenSystem = {}
--功能预览可领奖功能
RewardSystem = {}
--缓存下来的需要显示开启的功能
CacheOpenSystem = {}
CloseSystem = {}
IsOnOpenPanel = false
OpenSystemPreviewTable = {};

local IsStart = false

function OnInit()
    Data.PlayerInfoModel.BASELV:Add(Data.onDataChange, ShowOpenSystemPreview, ModuleMgr.OpenSystemMgr)
    Data.PlayerInfoModel.JOBLV:Add(Data.onDataChange, ShowOpenSystemPreview, ModuleMgr.OpenSystemMgr)

    GlobalEventBus:Add(EventConst.Names.CutSceneStop, function()
        ShowOpenSystem()
    end, ModuleMgr.OpenSystemMgr)
end

function OnUninit()
    Data.PlayerInfoModel.BASELV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.OpenSystemMgr)
    Data.PlayerInfoModel.JOBLV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.OpenSystemMgr)
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.CutSceneStop, ModuleMgr.OpenSystemMgr)
end

--服务器发送过来功能开启数据
function OnOpenSystemInfoNtf(msg)
    ---@type OpenSystemInfo
    local l_info = ParseProtoBufToTable("OpenSystemInfo", msg)
    SetOpenSystemInfo(l_info)
end

--服务器发送过来功能开启数据，但服务器数据不变更
function OnMSOpenSystemInfoNtf(msg)
    ---@type OpenSystemInfo
    local l_info = ParseProtoBufToTable("OpenSystemInfo", msg)
    SetOpenSystemInfo(l_info)
end

function OnOpenSystemChangeNtf(msg)

    local l_info = ParseProtoBufToTable("OpenSystemChangeData", msg)
    -- 模拟SetOpenSystemInfo需要的参数
    local l_ret = {}
    l_ret.opensys_ids = {}
    l_ret.closesys_ids = {}
    l_ret.noticesys_ids = {}
    for i, v in ipairs(l_info.open_system) do
        table.insert(l_ret.opensys_ids, { value = v })
    end
    for i, v in ipairs(l_info.close_system) do
        table.insert(l_ret.closesys_ids, { value = v })
    end

    SetOpenSystemInfo(l_ret)
end

function SetOpenSystemInfo(l_info)
    if IsStart then
        local l_openId
        for i = 1, #l_info.opensys_ids do
            l_openId = l_info.opensys_ids[i].value
            if not table.ro_contains(OpenSystem, l_openId) then
                table.insert(CacheOpenSystem, l_openId)
            end
        end

        ShowOpenSystem()
        local l_openIDs = FindOpenIds(l_info.opensys_ids)
        EventDispatcher:Dispatch(OpenSystemUpdate, l_openIDs)
    end

    _addData(AddOpenSystem, l_info.opensys_ids)
    _addData(AddRewardSystem, l_info.noticesys_ids)
    _addData(AddCloseSystem, l_info.closesys_ids)

    IsStart = true
    ShowOpenSystemPreview()
    EventDispatcher:Dispatch(OpenSystemUpdate)
    MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_OnOpenSystemUpdate)
end

function _addData(func, list)
    if nil == func or nil == list then
        logError("[OpenSysMgr] param cannot be nil")
        return
    end

    for i = 1, #list do
        func(list[i].value)
    end
end

--==============================--
--@Description: 过滤新开放的功能
--@Date: 2018/8/14
--@Param: [args]
--@Return:
--==============================--
function FindOpenIds(opensys_ids)
    local ret = {}
    for i, v in ipairs(opensys_ids) do
        if not ret[v.value] and not array.contains(OpenSystem, v.value) then
            table.insert(ret, v)
        end
    end
    return ret
end

local l_isShowSkill = false
local l_isShowDelegate = false
local l_skillFuncId = 102
local l_delegateFuncId = 117
function ShowOpenFinish(id)
    EventDispatcher:Dispatch(ShowOpenFinishEvent, id)

    -- 功能开启有技能面板时，打开技能面板
    if id == l_skillFuncId then
        l_isShowSkill = true
    end

    if #CacheOpenSystem == 0 and l_isShowSkill then
        l_isShowSkill = false
        local method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(l_skillFuncId)
        if method ~= nil and MPlayerInfo.ProID ~= 0 then
            method()
        end
    end

    -- 功能开启有委托按钮是，展示委托的新手指引
    if id == l_delegateFuncId then
        l_isShowDelegate = true
    end

    if #CacheOpenSystem == 0 and l_isShowDelegate then
        local l_beginnerGuideChecks = { "Entrust1" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, UI.CtrlNames.Main)
        l_isShowDelegate = false
    end
end

--显示功能开启
function ShowOpenSystem()

    if #CacheOpenSystem == 0 then
        return
    end
    if MPlayerInfo.IsPhotoMode then
        return
    end
    if MgrMgr:GetMgr("NpcMgr").IsTalking() then
        return
    end
    if IsOnOpenPanel then
        return
    end
    if MCutSceneMgr.IsPlaying then
        return
    end
    if MgrMgr:GetMgr("TimeLimitPayMgr").IsOnOpenPanel then
        return
    end
    for i = 1, #CacheOpenSystem do
        local systemId = CacheOpenSystem[i]
        local openSdata = TableUtil.GetOpenSystemTable().GetRowById(systemId)
        if not openSdata then
            return logError("OpenSystemTable表配置有误：" .. tostring(systemId))
        end
        if openSdata.CanOpenFx == 1 then
            if IsOpenTypeContain(openSdata, { 1, 2, 4 }) then
                game:ShowMainPanel(UI.CtrlNames.PropIcon)
                break
            end
        end
    end

    EventDispatcher:Dispatch(OpenSystemChange)
    MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_OnOpenSystemChange)
end

--打开功能开启界面
function OpenFunctionOpenPanel()
    if MCutSceneMgr.IsPlaying then
        return
    end
    if MgrMgr:GetMgr("TimeLimitPayMgr").IsOnOpenPanel then
        return
    end
    if #CacheOpenSystem > 0 then
        UIMgr:ActiveUI(UI.CtrlNames.FunctionOpen)
    end
end

function AddOpenSystem(openId)
    if not table.ro_contains(OpenSystem, openId) then
        table.insert(OpenSystem, openId)
        table.ro_removeValue(CloseSystem, openId)
    end
    if not table.ro_contains(OpenSystem, OpenSystemFuncPreviewId) then
        table.insert(OpenSystem, OpenSystemFuncPreviewId)
    end
end

function AddCloseSystem(id)
    if not table.ro_contains(CloseSystem, id) then
        table.insert(CloseSystem, id)
        table.ro_removeValue(OpenSystem, id)
        EventDispatcher:Dispatch(CloseSystemEvent, id)
    end
end

function AddRewardSystem(id)
    if not table.ro_contains(RewardSystem, id) then
        table.insert(RewardSystem, id)
    end
end

--得到按钮路径(id ==> path)
function GetButtonPath(id)
    local openSdata = TableUtil.GetOpenSystemTable().GetRowById(id)
    return ButtonRoot[openSdata.SystemPlace] .. "/" .. openSdata.Id
end

--判断数据是否是主界面按钮数据
local function _isMainButtonTableInfo(tableInfo)
    for i = 1, tableInfo.TypeTab.Length do
        if tableInfo.TypeTab[i - 1] == 1 then
            return true
        end
    end
    return false
end
--对主界面按钮的表数据进行缓存
local _cacheButtonTableInfos = nil
--获取主界面按钮的表数据
local function _getButtonTableInfo(id)
    if _cacheButtonTableInfos == nil then
        _cacheButtonTableInfos = {}
        local openSystemTable = TableUtil.GetOpenSystemTable().GetTable()
        for i = 1, #openSystemTable do
            if _isMainButtonTableInfo(openSystemTable[i]) then
                _cacheButtonTableInfos[openSystemTable[i].Id] = openSystemTable[i]
            end
        end
    end
    return _cacheButtonTableInfos[id]
end

--得到相应位置并比sort大的开启的按钮
--buttonPlace按钮位置
--sort按钮排序
function GetOpenedButton(buttonPlace, sort)
    local buttons = {}
    local mainCtrl = UIMgr:GetOrInitUI(UI.CtrlNames.Main)
    if mainCtrl then
        for i = 1, #OpenSystem do
            local systemId = OpenSystem[i]
            -- 额外判断
            if SystemOpenExtraCheck(systemId) then
                if not table.ro_contains(CacheOpenSystem, systemId) then
                    local l_openTableInfo = _getButtonTableInfo(systemId)
                    if l_openTableInfo then
                        if table.ro_contains(buttonPlace, l_openTableInfo.SystemPlace) and l_openTableInfo.SortID > sort then
                            local system = mainCtrl:GetButton(systemId)
                            table.insert(buttons, system)
                        end
                    end
                end
            end
        end
    end
    return buttons
end

--表中TypeTab这个数据是否包含给定的类型
--包含types其中的一条即为包含
function IsOpenTypeContain(_tableData, types)
    local h = _tableData.TypeTab
    local tableTypes = Common.Functions.VectorToTable(h)
    for i = 1, #types do
        if table.ro_contains(tableTypes, types[i]) then
            return true
        end
    end
    return false
end

function GetServerLevelTableRowByLevel(level)
    local l_rows = TableUtil.GetServerLevelTable().GetTable()
    local l_rowCount = #l_rows
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        -- 防止出现level没有精确配置的情况
        if l_row.ServeLevel >= level then
            return l_row
        end
    end
    return nil
end

--当功能未开启时点击会弹出提示，提示内容
function GetOpenSystemTipsInfo(id)
    local l_table = TableUtil.GetOpenSystemTable().GetRowById(id)
    if l_table == nil then
        return "找不到该OpenSystem @韩艺鸣 id=" .. id
    end
    local l_ServerDescLv = l_table.ServerDescLv
    if l_ServerDescLv > MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData.serverlevel then
        local l_row = GetServerLevelTableRowByLevel(l_ServerDescLv)
        local days = 9999
        if l_row then
            days = l_row.BeginDay - MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData.serverDay
        end
        days = math.max(1, days)
        local t = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
        local zone = MServerTimeMgr.TimeZoneOffsetValue
        t = t + days * 86400 + zone
        local str = os.date("!%Y-%m-%d 05:00 ", t)
        return str .. Lang("ACTIVITY_OPEN_SERVER_LEVEL_CONDITION", l_ServerDescLv)
    end

    local l_lv = l_table.BaseLevel
    if l_lv > MPlayerInfo.Lv then
        return StringEx.Format(Common.Utils.Lang("OPEN_SYSTEM_LIMIT_LV"), tostring(l_lv), l_table.Title)
    end

    local l_job = l_table.JobLevel
    if l_job > MPlayerInfo.JobLv then
        return StringEx.Format(Common.Utils.Lang("OPEN_SYSTEM_LIMIT_JOB"), tostring(l_job))
    end

    local l_taskIds = l_table.TaskId
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    for i = 0, l_taskIds.Count - 1 do
        if l_taskIds[i] ~= 0 and not l_taskMgr.CheckTaskFinished(l_taskIds[i]) then
            local l_taskName = l_taskMgr.GetTaskNameByTaskId(l_taskIds[i])
            return StringEx.Format(Common.Utils.Lang("OPEN_SYSTEM_LIMIT_TASK"), tostring(" " .. l_taskName .. " "))
        end
    end

    --成就等级处理
    if MgrMgr:GetMgr("AchievementMgr").BadgeLevel < l_table.AchievementLevel then
        local l_row = TableUtil.GetAchievementBadgeTable().GetRowByLevel(l_table.AchievementLevel)
        return Common.Utils.Lang("OPEN_SYSTEM_LIMIT_ACHIEVEMENT", l_row.Name)
    end

    return Common.Utils.Lang("SYSTEM_DONT_OPEN")
end

function GetParentId(id)

    local l_row = TableUtil.GetOpenSystemTable().GetRowById(id)
    if not l_row then
        return 0
    end

    return l_row.FatherID
end

--是否开启
function IsSystemOpen(id, extraCheck)
    --额外条件 + 来自服务器的系统开关
    if extraCheck then
        if not SystemOpenExtraCheck(id) then
            return false
        end
    end
    local l_parentId = GetParentId(id)
    if l_parentId > 0 then
        if not table.ro_contains(OpenSystem, l_parentId) then
            return false
        end
    end

    local l_isOpen = table.ro_contains(OpenSystem, id)
    return l_isOpen
end
--- 测试使用，强行修改本地功能开放状态
function ForceSetOpenSystemState(id, open)
    local l_notHas = true
    for i = 1, #OpenSystem do
        if OpenSystem[i] == id then
            l_notHas = false
            if not open then
                table.remove(OpenSystem, i)
            end
            break
        end
    end
    if l_notHas and open then
        table.insert(OpenSystem, id)
    end
    EventDispatcher:Dispatch(OpenSystemUpdate)
end

--是否有委托
function IsDelegateOpen(systemId)
    return MgrMgr:GetMgr("DelegateModuleMgr").IsDelegateOpen(systemId)
end

--开放baselv
function GetSystemOpenBaseLv(id)
    local l_table = TableUtil.GetOpenSystemTable().GetRowById(id)
    if l_table == nil then
        logError("找不到该OpenSystem @韩艺鸣 id= ", id)
        return 0
    end
    return l_table.BaseLevel
end

--开放AchievementLevel
function GetSystemAchievementLevel(id)
    local l_table = TableUtil.GetOpenSystemTable().GetRowById(id)
    if l_table == nil then
        logError("找不到该OpenSystem @韩艺鸣 id= ", id)
        return 0
    end
    return l_table.AchievementLevel
end


--是否可预览
--此预览为访问npc时，功能没有开启，是否显示按钮
function IsCanPreview(id)
    local openTable = TableUtil.GetOpenSystemTable().GetRowById(id)
    if openTable == nil then
        return false
    end
    if openTable.IsOpen <= 0 then
        return false
    end

    if openTable.FunctionPreviewOpen == 0 then
        return false
    end
    if MPlayerInfo.Lv >= openTable.FunctionPreviewOpen then
        return true
    else
        return false
    end
end

--功能预览
function ShowOpenSystemPreview()
    SetOpenSystemPreviewIdTable();
    EventDispatcher:Dispatch(OpenSystemPreview)
end
--获取功能预览奖励
function GetReward(msg)
    ---@type OpenSystemRewardRes
    local l_info = ParseProtoBufToTable("OpenSystemRewardRes", msg)
    local l_error = l_info.error
    local l_errorNo = l_error.errorno or ErrorCode.ERR_SUCCESS
    MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_info.error)
    if l_errorNo ~= ErrorCode.ERR_SUCCESS then
        return
    end
    local removeIndex = -1
    for i = 1, #RewardSystem do
        if RewardSystem[i] == OpenSystemPreviewTable[1] then
            removeIndex = i
            break
        end
    end
    if removeIndex > 0 then
        table.remove(RewardSystem, removeIndex)
    end
    SetOpenSystemPreviewIdTable();
    EventDispatcher:Dispatch(OpenSystemReward)
end

function SetOpenSystemPreviewIdTable()
    OpenSystemPreviewTable = {}
    local openSystemTable = TableUtil.GetOpenSystemTable().GetTable()
    for i = 1, #openSystemTable do
        local openSystemItem = openSystemTable[i];
        if not table.ro_contains(OpenSystem, openSystemItem.Id) then
            if openSystemItem.CanNotice ~= 0 then
                table.insert(OpenSystemPreviewTable, openSystemItem.Id);
            end
        end
    end
    local previewTableLen = #OpenSystemPreviewTable;
    if previewTableLen > 0 then
        SortPreviewIds(OpenSystemPreviewTable)
    end
end
--按等级排序功能预览的数据
function SortPreviewIds(ids)
    table.sort(ids, function(a, b)
        local openTableA = TableUtil.GetOpenSystemTable().GetRowById(a)
        local openTableB = TableUtil.GetOpenSystemTable().GetRowById(b)
        return openTableA.CanNotice < openTableB.CanNotice
    end)
end

-- 判断系统开放，额外条件
function SystemOpenExtraCheck(systemId)
    return switch(systemId)(extraCheckCases)
end

function IsSystemCached(systemId)
    if not CacheOpenSystem then
        return false
    end
    return table.ro_contains(CacheOpenSystem, systemId)
end

--MgrMgr
function OnLogout()
    OpenSystem = {}
    RewardSystem = {}
    CacheOpenSystem = {}
    CloseSystem = {}
    IsStart = false
    OpenSystemPreviewTable = {};
    IsOnOpenPanel = false
end

function CheckOpenQuestionnaire()
    if MGameContext.IsAndroid then
        return true
    else
        return false
    end
end

--==============================--
--@Description: 是否是特殊功能开放按钮
--@Date: 2018/9/5
--@Param: [args]
--@Return:
--==============================--
function IsSpecialOpenBtn(openSystemId)
    return table.ro_contains(specialOpenBtnIds, openSystemId)
end

--判断功能按钮是否可以显示
function IsSystemButtonCanShow(openSystemId)

    if IsSystemOpen(openSystemId) then
        local l_MainUiTableData = MgrMgr:GetMgr("SceneEnterMgr").CurrentMainUiTableData
        local l_h1 = l_MainUiTableData.MainIcon
        local l_MainIcons = Common.Functions.VectorToTable(l_h1)
        if table.ro_contains(l_MainIcons, openSystemId) then
            return true
        end
    end

    return false

end

return ModuleMgr.OpenSystemMgr