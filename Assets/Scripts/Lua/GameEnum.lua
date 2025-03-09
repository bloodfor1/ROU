---
--- Created by richardjiang.
--- DateTime: 2018/8/3 19:28
---

---@module GameEnum
module("GameEnum", package.seeall)

--- lua的基础类型
ELuaBaseType = {
    None = "None",
    Nil = "nil",
    Number = "number",
    String = "string",
    Boolean = "boolean",
    Table = "table",
    Func = "function",
    Thread = "thread",
    UsrData = "userdata",
}

EMPCLoginType = {
    PC = "PC"
}

EMSDKLoginType = {
    Weixin = "Weixin",
    WXQrCode = "WXQrCode",
    QQ = "QQ",
    Guest = "Guest",
}

EJoyyouLoginType = {
    AutoLogin = "0",
    GameCenter = "1",
    Google = "2",
    JoyyouGuest = "3",
    Facebook = "4",
    JoyyouEmail = "5",
    Apple = "6",
}

EJoyyouShareSDKType = {
    Facebook = "Facebook",
    KakaoTalk = "KakaoTalk",
}

--登录平台标示
ELoginPlatform = {
    [PlatType.PLAT_PC] = "pc",
    [PlatType.PLAT_IOS] = "ios",
    [PlatType.PLAT_ANDROID] = "android",
}

-- 游戏语言和技术中心的语言映射
GameLanguage2TechnologyCenter = {
    Chinese = "zh-cn",
    Japanese = "ja",
    TradChinese = "zh-tw",
    Korean = "ko",
}

-- 海外sdk errorcode
JoyyouSDKResult = {
    SUCCESS = "0",
    ERROR = "1",
    CANCER = "2",
    SDKLoginError = "3",
    VERIFY_PURCHASE_ERRO = "1001",    -- 当前情况是玩家付了钱，但是没有消耗商品，导致发货失败，需要手动触发消耗商品的操作，遮罩不关闭
    NETWORK_ERROR = "1002",             -- 网络异常
    ONESTORE_NEED_LOGIN = "2001",   -- onestore支付返回错误码10和12的时候， ONESTORE_NEED_LOGIN(2001) 支付失败，请确保onestore应用账号登录之后再重启游戏！
}

-- Adjust tracker
AdjustTrackerEvent = {
    FirstAppOpen = "zepygm", --第一次启动游戏 资源下载完成时点
    AppOpen = "tb98ea", --反复启动 资源下载完成时点
    GoogleLogin = "itn39p", --谷歌登入 谷歌登入时点
    FacebookLogin = "lf7dr9", --脸书登入  脸书登入时点
    AppStoreLogin = "enw1ev", --APP STORE 登入 ios登入时点
    InAppEnter = "w1xez3", --游戏进入 在登入画面上，点击’开始游戏‘按钮的时点
    CharacterCreate = "316e4x", --角色生成 角色生成时点
    GameStart = "cixqvu", --游戏开始 选角画面上点击‘开始游戏’按钮的时点
    ShopPurchaseComplete = "3f4xdd", --在商会购买完毕 在交易-商会上，交易完毕的时点
    StallPurchaseComplete = "jebl7a", --在摆摊购买完毕 在交易-摆摊上，交易完毕的时点
    AuctionPurchaseComplete = "52g1gg", --在拍卖购买完毕 在交易-拍卖上，交易完毕的时点
    GeneralStorePurchaseComplete = "f6isvu", --在万事屋购买完毕 在卖场-万事屋上，交易完毕的时点
    MysteryShopPurchaseComplete = "7lkvi3", --在神秘商店购买完毕  再卖场-神秘商店上，交易完毕的时点
    BaseLv10 = "vp9rjw", --BASE 10Lv 等级 10 达到 达到的时点
    BaseLv20 = "j6ngbr", --BASE 20Lv 等级 20 达到 达到的时点
    BaseLv30 = "hqgtmw", --BASE 30Lv 等级 30 达到 达到的时点
    BaseLv40 = "676kcv", --BASE 40Lv 等级 40 达到 达到的时点
    BaseLv50 = "pzfvaq", --BASE 50Lv 等级 50 达到 达到的时点
    BaseLv60 = "olyx7d", --BASE 60Lv 等级 60 达到 达到的时点
    BaseLv70 = "y6uap8", --BASE 70Lv 等级 70 达到 达到的时点
    BaseLv80 = "ntyhmm", --BASE 80Lv 等级 80 达到 达到的时点
    BaseLv90 = "e3e8ao", --BASE 90Lv 等级 90 达到 达到的时点
    FirstJobLv10 = "xdc85i", --1转 10 达到 1转 JOB Lv 10 达到的时点
    FirstJobLv20 = "1857k2", --1转 20 达到 1转 JOB Lv 20 达到的时点
    FirstJobLv30 = "iz90va", --1转 30 达到 1转 JOB Lv 30 达到的时点
    FirstJobLv40 = "fapjn2", --1转 40 达到 1转 JOB Lv 40 达到的时点
    SecondJobLv10 = "5sfkp3", --2转 10 达到 2转 JOB Lv 10 达到的时点
    SecondJobLv20 = "1k70lo", --2转 20 达到 2转 JOB Lv 20 达到的时点
    SecondJobLv30 = "nq7wa0", --2转 30 达到 2转 JOB Lv 30 达到的时点
    SecondJobLv40 = "qxpilo", --2转 40 达到 2转 JOB Lv 40 达到的时点
    ThirdJobLv10 = "8u2ddw", --3转 10 达到 3转 JOB Lv 10 达到的时点
    ThirdJobLv20 = "ri4c66", --3转 20 达到 3转 JOB Lv 20 达到的时点
    ThirdJobLv30 = "98a0y5", --3转 30 达到 3转 JOB Lv 30 达到的时点
    ThirdJobLv40 = "r8rta3", --3转 40 达到 3转 JOB Lv 40 达到的时点
    AchivementNovice3star = "520dqt", --成就-初心者 3星 达到 成就-初心者 3星 达到的时点
    AchivementNovice5star = "1jpl5b", --成就-初心者 5星 达到    成就-初心者 5星 达到的时点
    Achivementpioneer3star = "frcbqg", --成就-开拓者 3星 达到    成就-开拓者 3星 达到的时点
    Achivementpioneer5star = "h06t4v", --成就-开拓者 5星 达到    成就 开拓者 5星 达到的时点
    Achivementchallenger3star = "mealdu", --成就-挑战者 3星 达到    成就-挑战者 3星 达到的时点
    Achivementchallenger5star = "nww3h2", --成就-挑战者 5星 达到     成就-挑战者 5星 达到的时点
    AchivementTraveler3star = "sy39ii", --成就-旅行家 3星 达到    成就-旅行家 3星 达到的时点
    AchivementTraveler5star = "s8nq8y", --成就-旅行家 5星 达到    成就-旅行家 5星 达到的时点
    AchivementAdventurer3star = "vnz2ls", --成就-冒险家 3星 达到    成就-冒险家 3星 达到的时点
    AchivementAdventurer5star = "j724rp", --成就-冒险家 5星 达到    成就-冒险家 5星 达到的时点
    GuildCreation = "64yxez", --创建公会 创建公会的时点
    GuildJoin = "m3t21n", --加入公会 加入公会的时点
    PurchaseEvent = "o646zo", -- 玩家充值韩币成功
}

-- 活动表现类型
ActivityShowType = {
    normal = 1,
    pvp = 2,
    mvp = 3,
    expelMonster = 4,
    worldEvent = 5,
    themeDungeon = 6,
    towerDefense = 7,
}

-- 活动类型
ActivityType = {
    daily = 0,
    week = 1,
    weekInTime = 2,
    weekLoop = 3,
}

DungeonsResultStatus = {
    none = 0,
    win = 1,
    lose = 2,
    draw = 3, -- 平局
}

AwardExpReason = {
    none = 0,
    bless = 1, -- 祝福经验
    health = 2, -- 健康战斗时间
}

ExtraFightStatus = {
    none = 0,
    tired = 1,
    exhaust = 2,
}

BagType = {
    BAG = 0,
    WAREHOUSE = 1,
    TEMPBAG = 2,
    BODY = 3,
    SHORTCUTBAR = 4,
    ALLITEM = 5,
    VIRTUALITEM = 6,
    FASHION_BAG = 7,
    CART = 8
}

-- (1常规猫手恶魔等，2副本，3任务，4特殊任务奇闻等)
DelegateType = {
    Normal = 1,
    Dungeon = 2,
    Task = 3,
    WorldPve = 4,
    DanceTask = 6
}

Delegate = {
    activity_Evil = 1, ----恶魔宝藏
    activity_CatTeam = 2, ----猫手商队
    activity_Trial = 3, ---圣歌试炼
    activity_Maze = 4, ---迷雾之森
}

-- 世界奇闻难度
WorldEventDifficulty = {
    easy = 1,
    normal = 2,
    hard = 3
}

SpecialItemTipShowType = {
    None = 0,
    Item = 1,
    Sticker = 2,
    Achievement = 3,
    IconFrame = 4,
    ChatBubble = 5,
}

l_virProp = {
    exp = 201,
    jobExp = 202,
    Coin104 = 104, -- 金币，103和104一个为免费获得的金币，一个为付费获得的金币
    Coin103 = 103, -- 金币
    Coin102 = 102, -- zeny币(旧功能里可能把铜币叫做zeny币)
    Coin101 = 101, -- 铜币
    SkillPoint = 203,
    BoliPoint = 301,
    Yuanqi = 302,
    Certificates = 303,
    GuildContribution = 401,
    Prestige = 402,
    ArenaCoin = 501,
    AssistCoin = 701,
    MerchantCoin = 110,
    Debris = 304,
    MonsterCoin = 503,
    ReturnPoint = 403, -- 回归积分
}

--选择礼包类型
ChooseGiftType = {
    Normal = 1, --icon
    HeadWear = 2, --头饰
    Vehicle = 3, --载具
}

RewardGiftStatus = {
    Lock = 1,
    CanTake = 2,
    CanBuy = 3,
    Taked = 4
}

JobAwardItemType = {
    Normal = 1,
    Pro = 2,
    ForeShow = 3
}

JobAwardItemStatus = {
    Lock = 1,
    CanTake = 2,
    Taked = 3
}

EffType = { MinusSkill = 1, PlusSkill = 2, ApplySkill = 3 }

--怪物级别(0.普通怪，1.精英怪，2.Boss怪，3.召唤物，4.MINI，5.MVP，6.魔物驱逐宝箱怪，7.魔物驱逐经验怪，8.草类）
UnitTypeLevel = {
    Normal = 0,
    Elite = 1,
    Boss = 2,
    Summon = 3,
    Mini = 4,
    Mvp = 5,
    MonsterRepelBoxMons = 6,
    MonsterRepelExperience = 7,
    GrassTypeMons = 8,
}

EPlatform = {
    ePlatform_None = 0,
    ePlatform_Weixin = 1,
    ePlatform_QQ = 2,
    ePlatform_WTLogin = 3,
    ePlatform_QQHall = 4,
    ePlatform_Guest = 5
}

EFlag = {
    eFlag_Succ = 0,
    eFlag_QQ_NoAcessToken = 1000, -- QQ&QZone login fail and can't get accesstoken
    eFlag_QQ_UserCancel = 1001, -- 用户取消
    eFlag_QQ_LoginFail = 1002, -- 登录失败
    eFlag_QQ_NetworkErr = 1003, -- 网络错误
    eFlag_QQ_NotInstall = 1004, -- QQ未安装
    eFlag_QQ_NotSupportApi = 1005, -- QQ版本不支持此api
    eFlag_QQ_AccessTokenExpired = 1006, -- accesstoken过期
    eFlag_QQ_PayTokenExpired = 1007, -- paytoken过期
    eFlag_QQ_UnRegistered = 1008, -- 没有在qq注册

    eFlag_QQ_MessageTypeErr = 1009, -- QQ消息类型错误
    eFlag_QQ_MessageContentEmpty = 1010, -- QQ消息为空
    eFlag_QQ_MessageContentErr = 1011, -- QQ消息不可用（超长或其他）

    eFlag_WX_NotInstall = 2000, -- Weixin is not installed
    eFlag_WX_NotSupportApi = 2001, -- Weixin don't support api
    eFlag_WX_UserCancel = 2002, -- Weixin user has cancelled
    eFlag_WX_UserDeny = 2003, -- Weixin user has denys
    eFlag_WX_LoginFail = 2004, -- Weixin login faild
    eFlag_WX_RefreshTokenSucc = 2005, -- Weixin 刷新票据成功
    eFlag_WX_RefreshTokenFail = 2006, -- Weixin 刷新票据失败
    eFlag_WX_AccessTokenExpired = 2007, -- Weixin accessToken过期
    eFlag_WX_RefreshTokenExpired = 2008, -- Weixin refresh过期

    eFlag_WX_Group_HasNoAuthority = 2009, --游戏没有建群权限
    eFlag_WX_Group_ParameterError = 2010, --参数检查错误
    eFlag_WX_Group_HadExist = 2011, --微信群已存在
    eFlag_WX_Group_AmountBeyond = 2012, --建群数量超过上限
    eFlag_WX_Group_IDNotExist = 2013, --群ID不存在
    eFlag_WX_Group_IDHadCreatedToday = 2014, --群ID今天已经建过群，每天每个ID只能创建一次群聊
    eFlag_WX_Group_JoinAmountBeyond = 2015, --加群数量超限，每天每个ID最多可加2个群
    eFlag_Error = -1,


    eFlag_Local_Invalid = -2, --/** 自动登录失败, 需要重新授权, 包含本地票据过期, 刷新失败登所有错误 */
    eFlag_Checking_Token = 5001, --/*添 加正在检查token的逻辑 */
    eFlag_NotInWhiteList = -3, --/** 不在白名单 */
    eFlag_LbsNeedOpenLocationService = -4, --/** 需要引导用户开启定位服务 */
    eFlag_LbsLocateFail = -5, --/** 定位失败	 */
    eFlag_NeedLogin = 3001, --/* 快速登陆相关返回值 */ /**需要进入登陆页 */
    eFlag_UrlLogin = 3002, -- /**使用URL登陆成功 */
    eFlag_NeedSelectAccount = 3003, --/**需要弹出异帐号提示 */
    eFlag_AccountRefresh = 3004, --/**通过URL将票据刷新 */
    eFlag_Need_Realname_Auth = 3005, --/**需要实名认证**/
    eFlag_InvalidOnGuest = -7, --/* 该功能在Guest模式下不可使用 */
    eFlag_Guest_AccessTokenInvalid = 4001, --/* Guest的票据失效 */
    eFlag_Guest_LoginFailed = 4002, --/* Guest模式登录失败 */
    eFlag_Guest_RegisterFailed = 4003, --/* Guest模式注册失败 */
    eFlag_Webview_closed = 6001, --/* 关闭内置浏览器*/
    eFlag_Webview_page_event = 7000, --/* 传递的js消息*/
}

-- 双天赋类型
MultiTaltentType = {
    Skill = 0,
    Attr = 1,
    Equip = 2
}

ModelAlarmType = {
    Player = 1,
    NPC = 2,
    Monster = 3
}

-- 装备助手枚举
EEquipAssistType = {
    None = 0,
    RefineAssist = 1,
    EnchantAssist = 2,
    EnchantAssistOnInherit = 3,
    EnchantAssistOnPerfect = 4,
}

--- 装备属性的类型
--- 这个是服务器和客户端公用的类型
EItemAttrType = {
    None = -1,
    Attr = 0,
    Buff = 1,
    --- 服务器定义的额外属性
    TempAttr = 2,
    Card = 3,
}

--- 装备属性的模块枚举
EItemAttrModuleType = {
    None = 0,
    Enchant = 1,
    EnchantCache = 2,
    EnchantCacheHigh = 3,
    Device = 4,
    Base = 5,
    -- 流派属性
    School = 6,
    Hole = 7,
    HoleCache = 8,
    Card = 9,
    CardAttr = 10,
    Refine = 11,
    MaxBase = 12,
    MaxStyle = 13,
    BelluzGearCache = 14,
    BelluzGear = 15,
    RareBase = 16,
    RareStyle = 17,
}

--- 装备的类型，分为商店装，副本装和锻造装
EEquipSourceType = {
    None = 0,
    Shop = 1,
    Forge = 2,
    Instance = 3,
}

--- 时装类型
EFashionType = {
    None = 0,
    Head = 1,
    Face = 2,
    Mouth = 3,
    Back = 4,
    Tail = 5,
    Max = 6,
}

--- 对应ItemTable当中TypeTab
EItemType = {
    None = 0,
    Equip = 1,
    Consume = 2,
    Mat = 3,
    Card = 4,
    NoType = 5,
    Fashion = 6,
    Currency = 7,
    Recipe = 8,
    Mission = 9,
    DailyLife = 10,
    BluePrint = 11,
    Displacer = 12,
    HeadIcon = 13,
    Vehicle = 14,
    ExpBook = 15,
    CardFragment = 16,
    Title = 17,
    Sample = 19,
    -- 贝鲁兹核心齿轮
    BelluzGear = 20,
    Bingo = 23, -- Bingo幸运数字道具
    CountLimit = 24, --有使用次数限制的道具
    -- 聊天气泡框
    ChatBubbleBg = 26,
    -- 角色头像框
    IconFrame = 27,
}

--背包有使用次数限制的道具类型 （ItemUseCountTable中的Type）
EItemUseCountType = {
    ReplicaCard = 1, -- 以太因子卡
}

--- 背包容器类型，不是背包切页类型
EBagContainerType = {
    None = 0,
    Bag = 1,
    --- 客户端做查询用的枚举，只做映射，不做数据
    WareHouse = 2,
    Equip = 3,
    Cart = 4,
    Wardrobe = 5,
    Merchant = 6,
    HeadIcon = 7,
    --- 生活职业道具
    LifeProfession = 8,
    Title = 9,
    TitleUsing = 10,
    CatCaravan = 11,
    Vehicle = 12,
    VirtualItem = 13,
    --- 快速使用
    ShortCut = 14,
    --- 仓库页枚举，每个仓库页是一个单独的容器
    WareHousePage_1 = 15,
    WareHousePage_2 = 16,
    WareHousePage_3 = 17,
    WareHousePage_4 = 18,
    WareHousePage_5 = 19,
    WareHousePage_6 = 20,
    WareHousePage_7 = 21,
    WareHousePage_8 = 22,
    WareHousePage_9 = 23,
    BeiluzCore = 24,
    --- 用来存放当前正在装备的头像框和气泡框
    PlayerCustom = 25,
    Max = 26,
}

EBagNetUpdateType = {
    None = 0,
    Remove = 1,
    Update = 2,
    Add = 3,
}

-- 道具获取类型
ItemSearchType = {
    NpcShopGet = 1,
    SystemPanel = 2,
    TaskGet = 3,
    DungeonsGet = 4,
    CollectGet = 5,
    RecipeGet = 6,
    Achievement = 7,
    AchievementBadge = 8,
    GarderobeAward = 9,
    MonsterDrop = 10,
    AwardPack = 11,
}

EServerNotifyActionType = {
    BlackCurtain = 0,
    StoryBoard = 1,
}

---EquipTable EquipID
EEquipSlotType = {
    None = 0,
    Weapon = 1,
    BackUpHand = 2,
    Armor = 3,
    Cape = 4,
    Boot = 5,
    Accessory = 6,
    HeadWear = 7,
    FaceGear = 8,
    MouthGear = 9,
    BackGear = 10,
    Vehicle = 11,
    Trolley = 12,
    BattleHorse = 13,
    BattleBird = 14,
}

--- 对应的是客户端的槽位枚举编号
--- 对应的是服务器的EquipPos
EEquipSlotIdxType = {
    None = 0,
    MainWeapon = 1,
    BackupWeapon = 2,
    Helmet = 3,
    FaceGear = 4,
    MouthGear = 5,
    Cape = 6,
    Armor = 7,
    Boots = 8,
    Accessory1 = 9,
    Accessory2 = 10,
    BackGear = 11,
    Vehicle = 12,
    Trolley = 13,
    BattleHorse = 14,
    BattleBird = 15,
    Fashion = 16,
    Max = 17
}

--- 这边有一个盾牌的枚举没写，因为暂时不需要
EWeaponCarryType = {
    None = 0,
    SingleHand = 1,
    DoubleWeaponDoubleHand = 2,
    DoubleHand = 3,
}

--- 道具的用途，对应item_function_table当中的itemFunction字段
EItemFunctionType = {
    None = -1,
    NoEffect = 0,
    AddBuff = 1,
    RandomTeleport = 2,
    ConfirmedTeleport = 3,
    OpenUI = 4,
    Award = 5,
    Lottery = 6,
    PackagePick = 7,
    Arrow = 8,
    LoadSkillEffect = 9,
    PathFindToTargetScene = 10,
    GuildGiftPackage = 11,
    ArrowEffect = 12,
    LittleDemon = 13,
    RottedBranch = 14,
    Bingo = 15,
    VehicleBreach = 17, --载具突破
    GuaJiJiaSu = 20, -- 挂机加速道具
    DaBaoTang = 21, -- 打宝糖
}

--- 背包切页的编号，对应prefab
EBagPageIdxType = {
    None = -1,
    Default = 0,
    Equip = 1,
    Consume = 2,
    Mat = 3,
    Card = 4
}

--- 附魔属性的颜色配置
EEnchantAttrQuality = {
    None = 0,
    Blue = 1,
    Purple = 2,
    Gold = 3,
}

--- 贝鲁兹核心的技能颜色
EBeiluzCoreSkillQuality = {
    None = 1,
    Blue = 2,
    Purple = 3,
    Gold = 4,
}

--- 工会分数和排名的类型
--- 这个和表ID是有对应关系并且要算偏移量的，不能随意修改
EGuildScoreType = {
    None = -1,
    Total = 0,
    GuildHunt = 1,
    GuildCooking = 2,
    GuildEliteMatch = 3,
    GVG = 4,
}

--- 工会排名的页签类型
EGuildRankPageType = {
    None = 0,
    Elite = 1,
    Normal = 2,
}

EStrParseType = {
    None = 0,
    Value = 1,
    Array = 2,
    Matrix = 3,
}

EGuildContentID = {
    None = 0,
    -- 皇室竞赛
    RoyalMatch = 12,
}

EPlayerGender = {
    None = -1,
    Male = 0,
    Female = 1,
    NoGender = 2,
}

--- 角色头像框展示用的枚举
EHeadMenuOpenType = {
    AddOfferInfo = 1,
    SetPanelByInfo = 2,
    RefreshHeadIconByUid = 3,
    SetQuickPanelByNameAndFunc = 4,
}

--- 道具提示类型
--- 对应ItemTable当中的AccessPrompt
EGainItemTipsType = {
    None = -1,
    NoTips = 0,
    SpecialTips = 1,
    HighQualityTips = 2,
}

--- 对应equipTable当中的WeaponID以及EquipWeaponTable当中的ID
EWeaponDetailType = {
    None = 0,
    Knife = 1,
    Sword = 2,
    DoubleHandSword = 3,
    Spear = 4,
    DoubleHandSpear = 5,
    Axe = 6,
    DoubleHandAxe = 7,
    Hammer = 8,
    Wand = 9,
    DoubleHandWand = 10,
    Bow = 11,
    Fist = 12,
    Instrument = 13,
    Whip = 14,
    Book = 15,
    FistBlade = 16,
    Shield = 17,
    DoubleHandKnife = 101,
    DoubleHandBlade = 102,
    RightKnifeLeftBlade = 103,
    LeftKnifeRightBlade = 104,
}

--- 对应ItemTable当中的QuickUse字段
EItemQuickUseType = {
    None = -1,
    NoQuickUse = 0,
    NormalQuickUse = 1,
    ShowPackage = 2,
}

--- 需要创建道具数据的操作类型
EItemCreateType = {
    None = 0,
    Tid = 1,
    Item = 2,
    RoItem = 3,
}

--- 鱼的大小
EFishGradeDefine = {
    FISH_GRADE_S = 1,
    FISH_GRADE_M = 2,
    FISH_GRADE_L = 3,
    FISH_GRADE_XL = 4,
}

--- 对应EquipHoleTable当中的Quality
EEquipHoleAttrQuality = {
    None = 0,
    Green = 1,
    Blue = 2,
    Purple = 3,
}

--- 对应流派表中的特征
ESchoolFeatureType = {
    None = 0,
    Support = 1,
    Attack = 2,
    Defence = 3,
}

--- 玩家流派对应的状态
EStyleMatchState = {
    None = 0,
    NoMatch = 1,
    SkillMatch = 2,
    AttrMatch = 3,
    BothMatch = 4,
}

--- 勾选框 类型
---0无勾选框
---1不再提示(本次登录)
---2今日不再提示
---3双向不再提示(勾选后无论确定还是取消都会记录操作)
---4本机本号永远不再提示
EDialogToggleType = {
    None = -1,
    NoTog = 0,
    NoHintWhenLogin = 1,
    NoHintToday = 2,
    NoHintBothWay = 3,
    NoHintCurRole = 4
}

--- 对应服务器枚举
ERefineSvrID = {
    None = -1,
    RefineLv = 0,
    RefineSealLv = 1,
    AdditionalRate = 4,
    UnlockExp = 7,
}

--- 服务器用于表示卡洞上有没有卡的状态
EHoleSvrState = {
    None = -2,
    HoleSealed = 0,
    HoleOpen = -1,
}

--- 角色养成的类型
ERoleNurtType = {
    None = 0,
    Forge = 1,
    Refine = 2,
    Enchant = 3,
    CardInsert = 4,
    SkillPoint = 6,
    AttrPoint = 7,
    Madel = 8,
    VehicleLv = 9,
    VehicleQuality = 10,
    MercCrew = 11,
    MercLv = 12,
    MercEquip = 13,
    AutoMedicine = 14,
}
--- 匹配选项，有可能是队长匹配队员，也可能是队员匹配队长
--- 决定了页面开启的状态
ETeamMatchOption = {
    None = 0,
    MatchMember = 1,
    MatchTeam = 2,
}

--- 职责枚举，对应职责表
ETeamDuty = {
    None = -1,
    Free = 0,
    Tank = 1,
    Heal = 2,
    Attack = 3,
    --- 这个枚举表示已经有了角色了，如果队伍职责法伤扩展，这个ID顺延
    Occupied = 4,
}

--- 匹配页开启的状态
ETeamMatchProcessState = {
    None = 0,
    PlayerMatch = 1,
    TeamMatch = 2,
}

--- 匹配中页面的展示状态
ETeamMatchProcessDisplayState = {
    None = 0,
    SmallWin = 1,
    DetailWin = 2
}

EAttrCompareType = {
    None = 0,
    ShowSingle = 1,
    ShowDouble = 2,
}

--- 服务器给的封魔石保存的属性ID
EEnchantSvrValueType = {
    None = -1,
    EnchantItemID = 0,
    EnchantItemLv = 1,
}

--- 客户端使用的错误码，主要是用来处理一些拦截的问题的
EClientErrorCode = {
    None = -1,
    Success = 0,
    ItemLvInvalid = 1,
    ItemGenderInvalid = 2,
    ItemProfessionInvalid = 3,
    BagWeightExceeded = 4,
    ItemCannotGotoWarehouse = 5,
    ItemCannotGotoCart = 6,
    ItemCannotGotoShortCutBar = 7,
    --- 不能装备副手武器
    CannotEquipBackUpWeapon = 8,
    --- 切换装备CD
    EquipSwitchInCd = 9,
    --- 小推车超重
    TrolleyWeightExceeded = 10,
    --- 小推车格子满
    CarItemMax = 11,
    RunningGearCannotGotoWareHouse = 12,
    Unknown = 100,
}

--- 对应equipReform表中的随机类型
EEquipAttrRandType = {
    None = 0,
    Static = 1,
    Rand = 2,
}

--- EquipTable当中的属性的随机类型
EStyleAttrRandType = {
    None = -1,
    Static = 0,
    Rand = 1,
}

--- 装备强化引导的操作类型
EEquipEnhanceGuideType = {
    None = -1,
    --- 作为错误类型返回，如果收到了这个类型则不进行任何引导操作
    Fault = 0,
    SwitchEquip = 1,
    RefineTransfer = 2,
    EnchantInherit = 3,
    RemoveCard = 4,
    EnchantExtract = 5,
}

--- 装备强化引导的步骤类型
EEquipEnhanceStepType = {
    None = -1,
    Fault = 0,
    RefineTransfer = 1,
    EnchantInherit = 2,
    RemoveCard = 3,
    EnchantExtract = 4,
}

--- 属性显示方式的枚举
EEquipAttrConvertType = {
    None = -1,
    IntAdd = 0,
    PercentAdd = 1,
    Int = 2,
    Percent = 3,
    Element = 4,
    DividedTenThousandAdd = 5,
}

--- 场景类型
ESceneType = {
    None = 0,
    Hall = 1,
    Wild = 2,
    Dunegons = 3,
    Prepare = 4,
    PVP = 5,
    Cook = 6,
    TeamWait = 7,
    PvpCanyon = 8,
    Guild = 9,
    Hunt = 10,
}

EReviveType = {
    Situ = 1,
    SceneConfig = 2,
    Butter = 3,
    RecordPoin = 4,
    Random = 5,
    Maze = 6,
    Hunt = 7
}

EDoseDrugType = {
    None = 0,
    Hp = 1,
    Mp = 2,
}

ESucceedFail = {
    Succeed = 1,
    Fail = 2
}

EItemTimeType = {
    None = 0,
    -- 固定过期时间，不叠加
    FixedTime = 1,
    -- 过期时间叠加
    AddTime = 2,
    -- 随活动结束销毁
    ExpireOnActivityEnd = 3
}

EBattleHealthy = {
    Healthy = 1,
    Tried = 2,
    VeryTried = 3
}

-- 活动状态
ETimeLimitState = {
    kTLS_None = 0,
    kTLS_Show = 1,
    kTLS_Before_Begin = 2,
    kTLS_Begin = 3,
    kTLS_Before_End = 4,
    kTLS_End = 5,
    kTLS_Hide = 6,
    kTLS_Lock = 7,
    kTLS_UnLock = 8
}

-- 活动类型
ECommonActivityType = {
    kCA_None = 0,
    kCA_Gift = 1
}
--- 头像框，气泡框item的标记状态
ECustomItemActiveType = {
    None = 0,
    InActive = 1,
    Active = 2,
    InUse = 3,
}

--- 客户端使用的玩家个性化数据槽位类型
ECustomContClientSlot = {
    None = 0,
    HeadFrame = 1,
    ChatBubble = 2,
}

--- 服务器使用的玩家个性化槽位类型
ECustomContSvrSlot = {
    None = -1,
    HeadFrame = 0,
    ChatBubble = 1,
}

--- 称号品质和颜色对应关系
ETitleQuality = {
    None = -1,
    Grey = 0,
    Green = 1,
    Blue = 2,
    Purple = 3,
    Gold = 4,
}

--- shopTable当中的ShopId
EShopType = {
    None = 0,
    EquipShardShop = 130,
    ThemePartyShop = 125,
}

--- 属性描述的覆盖类型
EAttrDescType = {
    None = 0,
    Default = 1,
    EquipTextOne = 2,
    EquipTextTwo = 3,
}

--- 属性值类型
EAttrValueState = {
    None = 0,
    Normal = 1,
    Max = 2,
    Rare = 3,
}

-- 活动类型
EActType = {
    NewKing = 6,
}

--- 对应EquipMapStringInt表当中的DisplayType
EEquipStrIntMapValueType = {
    None = -1,
    Normal = 0,
    Decimal = 1,
}

--- 对应ornamentTable当中的OrnamentType
EEquipGearType = {
    None = 0,
    Head = 1,
    Face = 2,
    Mouth = 3,
    Back = 4,
    Tail = 5
}

EMonsterBookAwardType = {
    None = 0,
    SingleMonster = 1,
    GroupMonster = 2,
}

-- game server 标签
EGameServerFlag = {
    None = 0, -- 无
    Hot = 1, -- 火爆
    Recommend = 2, -- 推荐
    New = 4, -- 新服
    Limited = 8, -- 维护服
    Experience = 16, -- 体验服
}

-- game server 状态对应颜色 图集
EGameServerState2Sprites = {
    [EnumServerState.ServerState_Maintain] = "UI_Commonicon_Boli_04.png",
    [EnumServerState.ServerState_Smooth] = "UI_Commonicon_Boli_03.png",
    [EnumServerState.ServerState_Hot] = "UI_Commonicon_Boli_02.png",
    [EnumServerState.ServerState_Full] = "UI_Commonicon_Boli_01.png",
    [EnumServerState.ServerState_Recommend] = "UI_Commonicon_Boli_03.png",
    [EnumServerState.ServerState_Auto] = "UI_Commonicon_Boli_03.png",
}

--- 战场阵营枚举，目前仅限于战场使用
EBattleFieldCamp = {
    CampNone = 0,
    CampLeft = 1,
    CampRight = 2,
}

--- 客户端自定义的PVP活动类型
EPvPLuaType = {
    None = 0,
    Arena = 1,
    BattleField = 2,
    Ring = 3,
    GuildMatch = 4
}

EDailyTaskHintType = {
    None = 0,
    ShowRichTextContext = 1,
    ShowHowToPlay = 2,
    ShowGameHelp = 3,
}

--- 战场结算当中的角色标签目前是有四种
EBattleFieldTagType = {
    None = 0,
    MostKill = 1,
    MostDamage = 2,
    MostAssist = 3,
    MostHeal = 4,
}

--- 贝鲁仔齿轮的状态
--- 复制的BeiluzCoreMgr里面的E_ACTIVE_STATE
EGearState = {
    None = 0,
    Unused = 1, -- 未使用过
    NoLife = 2, -- 使用过但寿命耗尽
    InUse = 3, -- 使用过且寿命未耗尽
}

return GameEnum