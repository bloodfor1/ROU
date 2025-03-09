--[[
    Lua网络协议号定义
]]

module("Network.Define")

--rpc协议(request)
Rpc = {
    --- 请求分解道具
    ResolveItem = 1128786457,
    --- 请求更换聊天标签
    ChangeChatTag = 1128791615,
    --- 装备同名继承
    EquipInherit = 1128764194,
    BackstageActRequest = 1129184718,
    --新手换装
    ChangeStyle = 1128727383,

    --节日签到活动
    GetSpecialSupplyInfo = 1128734825,
    ChooseSpecilSupplyAwards = 1128743280,
    SetSpecialSupplyDice = 1128778314,
    RecvSpecialSupplyAwards = 1128784938,
    RandomDiceValue = 1128743010,
    -- 活动：新王的号角
    ActivityNewKingGetReward = 1128782504,
    ActivityGetData = 1129158810,

    -- 累计充值
    --GetPayAwardInfo = 1128774024,
    GetPayAward = 1128738621,

    EquipReform = 1128778505,
    AchievementGetInfo = 1128752389,
    AchievementGetFinishRateInfo = 1129164423,
    AchievementGetBadgeRateInfo = 1129175274,
    AchievementGetItemReward = 1128735039,
    AchievementGetPointReward = 1128732759,
    AchievementGetBadgeReward = 1128780012,

    FAQReport = 1128731125,
    ChangeReplicaCardState = 1128755949,
    GetRolesBattleInfo = 1129171177,
    GetReturnLoginPrize = 1128731738,

    EquipRefineAttachLucky = 1128742201,

    EquipHoleRefoge = 1128769765,
    EquipSaveHoleReforge = 1128745573,
    AddEquipTask = 1128767390,
    DelEquipTask = 1128732487,
    GetStaticSceneLine = 1129226137,
    ChangeSceneLine = 1129224998,

    GetVersion = 1129717237,
    QueryGateIP = 1128914367, --QueryGateIP
    SyncTime = 1129592379, --SyncTime
    SelectRole = 1129200538,
    CreateRoleNew = 1129232997,
    ClientLoginRequest = 1129625954,
    DoEnterScene = 1128751841,

    --改名
    GsChangeRoleName = 1128752616,
    GetMengXinLevelGift = 1128744335,

    --组队
    CreateTeam = 1129148556,
    InviteJoinTeam = 1129163133,
    AcceptTeamInvatation = 1129181638,
    LeaveTeam = 1129176068,
    GetTeamInfo = 1129152922,
    TransferProfession = 1128771166,
    QueryIsInTeam = 1129180182, --查询路人是否组队 是否队长
    BegJoinTeam = 1129171872, --请求加入队伍
    KickTeamMember = 1129137396, --踢人
    FollowOthers = 1129137599, --请求跟随
    Acceptbegjointeam = 1129141268, --允许进组
    GetApplicationList = 1129176355, --获取申请列表
    GetInvitationList = 1129144612, --获取邀请列表
    GetTeamMatchStatus = 1129145531, --获取当前匹配状态

    UseRedEnvelope = 1128774840, --使用公会红包

    TeamSetting = 1129139618, --组队设置
    QueryRoleBriefInfo = 1129136620, --请求人物信息
    AutoPairOperate = 1129134113, --请求自动匹配 or 关掉自动匹配
    GetTeamList = 1129177826, --请求组队列表
    TeamShout = 1129170140, --组队喊话
    ToBeFollowed = 1129160769, --队长邀请队员跟随他
    ReplyToBeFollowed = 1129122060, --回复邀请
    QueryAutoPairStatus = 1129164941, --请求匹配状态
    RecommandMember = 1129133287, --队员推荐进队
    ApplyForCaptain = 1129124095, --申请队长
    RespondForApplyCaptain = 1129136904, --申请队长的回复
    GetMercenaryReviveTime = 1129151974,
    GetTeamAllMercenary = 1129144889,
    GetRecentTeamMate = 1129128050, --获得最近组队的玩家UID
    AttrAdd = 1128737032,
    AttrClear = 1128789081,
    AttrModule = 1128784260,

    --技能加点
    SkillPoint = 1128767096,
    SkillSlot = 1128745327,
    SkillReset = 1128765835, --洗点

    --死亡复活
    RoleRevive = 1128758728,
    --任务
    TaskCheck = 1128766630,
    TaskAccept = 1128738439,
    TaskFinish = 1128741434,
    TaskReport = 1128778976,
    TaskGiveup = 1128757361,
    TaskTrackGotoDungeon = 1128755414,
    GetTaskConvoyPosition = 1128750651,
    GetTaskRecord = 1128761488,
    --道具
    SortBag = 1128785581,
    MoveItem = 1128746186,
    UseItem = 1128773760,
    EquipItem = 1128749880,
    TakeOffEquip = 1128744877,
    AppraiseEquip = 1128744089,
    UnlockBlank = 1128757309,
    ChangeTrolley = 1128738156,
    ExchangeAwardPack = 1128784745, --选择礼包
    --角斗场pvp
    CreateArenaPvpCustom = 1129129747,
    ActiveJoinArenaRoom = 1129171555,
    ChangeArenaRoomCondition = 1129177531,
    ShowArenaRoomList = 1129140477,
    ArenaInviteRequet = 1129133686,
    ArenaSetMemberInvite = 1129178908,

    --衣橱
    WearFashion = 1128758615,
    WearOrnament = 1128775996,
    FashionCountSendAward = 1128743083, --典藏值奖励
    --mvp
    GetMvpInfo = 1129136198,
    GetMVPRankInfo = 1129128194, --mvp排行榜
    --理发店
    ChangeHair = 1128788792,
    UnlockHair = 1128728678,
    --发送喇叭
    SendHorn = 1128761623,
    --美瞳
    ChangeEye = 1128744800,
    UnlockEye = 1128791893,

    ExchangeMoney = 1128778325,
    OpenSystemReward = 1128745425,
    -- 载具
    TakeVehicle = 1128771248,
    AskTakeVehicle = 1128781155,
    GetOnVehicleAgree = 1128790822,
    AccelerateVehicle = 1128736973,
    RideCommonVehicle = 1128749877,
    TakeBattleVehicle = 1128783061,

    EnableVehicle = 1128779284,
    UpgradeVehicle = 1128788708,
    UpgradeVehicleLimit = 1128733029,
    DevelopVehicleQuality = 1128753020,
    AddOrnamentDye = 1128732654,
    UseOrnamentDye = 1128760584,
    ConfirmVehicleQuality = 1128763257,
    ExchangeSpecialVehicle = 1128754312,

    --变身
    RequestTransfigure = 1128768960,

    RequestShopItem = 1128744124,
    RequestBuyShopItem = 1128762963,
    RequestSellShopItem = 1128760171,

    --烹饪
    SingleCookingStart = 1128784825,
    SingleCookingFinish = 1128778949,

    --主题副本
    ForgeEquip = 1128767066,
    DailyActivityShow = 1128735207, --每日活跃的任务
    DrawBoLiPointAward = 1128786644,
    DailyActivityShowToMS = 1129140825,
    EquipRefineUpgrade = 1128790245,
    EquipRefineRepair = 1128771973,
    IsAssist = 1129169557, --是否使用助战奖励
    GetThemeDungeonInfo = 1128787675, -- 获取主题副本信息

    --商会
    GetCountInfo = 1128760287, --购买次数
    GetTradeInfo = 1128952634, --商会信息
    TradeBuyItem = 1128926117, --购买协议
    TradeSellItem = 1128944005, --出售协议
    TradeFollowItem = 1128976314, --关注
    ExchangeMoney = 1128778325,
    GetValidName = 1129177850, ----角色取名
    --公会
    GuildCreate = 1129171225, --公会创建
    GuildGetInfo = 1129131812, --公会信息获取
    GetJoinGuildTime = 1129127053, --获取加入公会的时间点
    GuildGetList = 1129122180, --公会列表获取
    GuildSearch = 1129148787, --公会搜索
    GuildApply = 1129123552, --申请加入
    GuildDeclarationChange = 1129149358, --招募宣言修改
    GuildAnnounceChange = 1129137999, --公会公告修改
    GuildQueryMemberList = 1129142490, --公会成员列表获取
    GuildEmailSend = 1129169406, --公会群消息发送
    GuildMemberSearch = 1129179783, --公会成员搜索
    GuildChangePermission = 1129159214, --修改成员职位
    GuildPermissionNameChange = 1129153491, --公会职位自定义名称修改
    FindGuildBeautyCandidate = 1129176966, --公会魅力方案资格筛选
    GuildKickOutMember = 1129160676, --踢出公会成员
    GuildGetApplicationList = 1129121848, --获取申请者列表
    GuildApplyReplay = 1129151561, --审核申请者
    GuildAutoApprovalApply = 1129137729, --设置是否自动接收申请者
    GuildQuit = 1129162077, --退出公会
    GuildIconChange = 1129171992, --公会图标修改
    GuildGetNewsInfo = 1129156837, --公会新闻获取
    GuildInviteJoin = 1129184869, --邀请入会
    GuildGetBuildingInfo = 1129157042, --获取公会建筑信息
    GuildUpBuildingLevel = 1129126928, --公会建筑升级
    GuildDonateMaterials = 1129130049, --公会物资捐赠
    GuildDonateMoney = 1129143944, --公会财物捐献
    GuildCrystalGetInfo = 1129152545, --公会获取水晶相关信息
    GuildCrystalLearn = 1129160009, --公会水晶设置研究
    GuildCrystalQuickUpgrade = 1129182314, --公会快速升级
    GuildCrystalPray = 1129175047, --公会水晶祈福
    GuildCrystalGiveEnergy = 1129132514, --公会水晶充能
    GuildCrystalCheckAnnounce = 1129183059, --公会华丽水晶充能公告有效性确认
    GuildGetWelfare = 1129168114, --公会分红
    GuildWelfareAward = 1129168405, --公会领取分红
    GuildGiveItem = 1129162224, --公会上交水晶
    GuildGiftGetInfo = 1129173532, --公会礼包信息获取
    GuildGiftHandOut = 1129157127, --公会礼包发放
    GuildHuntGetInfo = 1129134001, --公会狩猎信息获取
    GuildHuntOpenRequest = 1129153420, --公会狩猎开启
    GuildHuntGetFinalReward = 1129151935, --公会狩猎宝箱开启
    GetGuildRepoInfo = 1129136256, --公会仓库信息获取
    GuildHuntFindTeamMate = 1129139406, --公会狩猎寻找好友
    GuildRepoSetAttention = 1129140340, --公会仓库设置关注
    GuildRepoRemoveItem = 1129164413, --公会仓库删除物品
    GuildAuctionSetPrice = 1129179943, --公会仓库拍卖出价
    GetGuildAuctionPublicRecord = 1129175724, --公会仓库公会拍卖纪录获取
    GetGuildAuctionPersonalRecord = 1128729611, --公会仓库个人拍卖纪录获取

    GuildBinding = 1129183774, --公会请求绑群
    GuildBindingRemind = 1128778900, --公会提醒会长绑群

    GuildDinnerViewMenu = 1129137018,
    GuildDinnerTaskAccept = 1128733593,
    GuildDinnerGetDishNPCState = 1128727662, --公会宴会菜肴状态请求
    GuildDinnerEatDish = 1128742237, --公会宴会菜肴品尝请求
    GuildDinnerShareDish = 1129169324, --公会菜肴分享请求
    GuildDinnerCreamMeleeRenshu = 1128770055, --公会宴会大乱斗参与人数请求
    GuildDinnerGetPhotoAward = 1128731396, --公会宴会请求与石像拍照奖励请求
    GuildDinnerOpenChampagne = 1128784176, --公会宴会请求开启香槟
    GuildDinnerGetPersonResult = 1129138651, --公会宴会个人比赛结果
    GuildDinnerGetCompetitionResult = 1129176523, --公会宴会烹饪比赛各帮会总成绩
    CheckGuildDinnerOpen = 1129178703, --公会宴会是否开启

    SendGuildRedEnvelope = 1129181967, --发送红包
    GetGuildRedEnvelopeInfo = 1129171028, --确认红包信息
    GrabGuildRedEnvelope = 1129126906, --抢红包
    GetGuildRedEnvelopeResult = 1129143244, --请求红包结果

    GetGuildOrganizationInfo = 1129185130, --获得组织力贡献信息
    GetGuildOrganizationRank = 1129148331, --组织力贡献排行
    GetGuildOrganizationPersonalAward = 1129174353, --组织力个人贡献奖励

    --- 获取公会分数
    GuildRankActivityRpc = 1129169580,
    --- 获取公会自身排名
    SelfRankRpc = 1128794768,
    --- 排行榜数据
    GetGuildLeaderBoardByRank = 1129173022,
    --- 通用请求头像数据
    QueryRoleSmallPhotoRpc = 1129157096,

    BattlefieldApply = 1129155909, --战场申请
    EnterGuildMatchWaitingRoomRequest = 1129163863, --公会匹配赛申请

    AddFriend = 1129143052,
    DeleteFriend = 1129129420,
    ReadPrivateMessage = 1129129211,
    GetFriendInfo = 1129146902,

    ---摆摊
    StallGetMarkInfo = 1128942350, --获取二级页签信息
    StallGetItemInfo = 1128967942, --获取物品信息
    StallItemBuy = 1128975104, --购买
    StallRefresh = 1128788226, ---刷新

    StallGetSellInfo = 1128976159, ---获取出售信息
    StallGetPreSellItemInfo = 1128953047, --获取上架物品信息
    StallSellItem = 1128944412, ---上架
    StallSellItemCancel = 1128980908, --下架
    StallDrawMoney = 1128959649, ---提现
    StallBuyStallCount = 1128779146, ---摊位购买
    StallReSellItem = 1128960031,

    GetMailList = 1129145449, --拉取邮件列表
    MailOp = 1129167666, --邮件状态操作
    GetOneMail = 1129140065, --请求详细信息

    EquipEnchant = 1128753497, --附魔
    EquipEnchantConfirm = 1128744623, --确认附魔结果
    ClearEnchatCache = 1128727593, --清楚附魔缓存
    GetServerLevelBonusInfo = 1128744501, --获取服务器等级

    ExchangeHeadGear = 1128755928, --请求头饰兑换

    --圣歌试炼
    HSQueryRoundInfo = 1128772198, --请求当前轮信息
    EnterSceneWall = 1128787288, --场景交互
    PickUpDropBuff = 1128779462, --BUFF拾取

    PullChatMsg = 1129152353, --拉取聊天消息
    AwardPreview = 1128782230, --奖励预览
    BatchAwardPreview = 1128779065, --奖励预览-批量

    YuanQiRequest = 1128779696, --生活技能制作四合一
    LifeSkillFishing = 1128731554, --钓鱼
    LifeEquipChange = 1128790552, --钓鱼用具使用
    AutoFishPush = 1128737106, --自动钓鱼信息获取
    AutoCollect = 1128772211, --自动采集
    GetAutoCollectEndTime = 1128771950, --采集结束时间
    LifeSkillUpgrade = 1128746803, --生活职业升级
    BreakOffAutoCollect = 1128774484, --打断自动采集

    EquipCardInsert = 1128745300, --插卡
    EquipCardRemove = 1128790135, --拆卡
    EquipMakeHole = 1128781979, --打洞
    QueryRandomAwardStart = 1128761127, --请求开启轮盘
    GiveGifts = 1129166628, --赠送功能

    GetGiftLimitInfo = 1129147285, --赠送获取好友列表
    GetBlessInfo = 1128752669, -- 获取怪物驱逐数据
    BlessOperation = 1128774077, -- 开启/关闭祝福buff
    SevenLoginActivityGetInfo = 1128771087, --领取七日登陆信息
    SevenLoginActivityGetReward = 1128736745, --领取七日登陆奖励

    --卡普拉记录
    SaveReviveRecord = 1128791108,

    --发送聊天
    SendChatMsg = 1129123678,
    RoleSearch = 1129169351, --搜索玩家
    FrequentWords = 1128730952, --常用语
    ChatShareMsg = 1129181288,
    ChangeChatForbid = 1129184995, --更改玩家屏蔽状态

    DoubleActiveApply = 1128776009, -- 双人动作申请
    DoubleActiveAgree = 1128765938, -- 双人动作回复

    ChatSenderInfo = 1129166100, --角色显示数据

    EquipCompound = 1128750693, --装备合成

    DirTeleport = 1128772835, --单向传送

    TowerDefenseFastNextWave = 1128731472,
    SetTowerDefenseBless = 1128736443,
    GetTowerDefenseWeekAward = 1128730513,

    GetItemByUid = 1129183651, --更具角色uid和道具uid 拿道具数据

    JudgeTextForbid = 1129142139, --屏蔽词判断

    UnLockRoleIllutration = 1128727729, --解锁魔物图鉴

    BeginMatchForBattleField = 1129135725, --战场主动匹配

    MaterialsMechant = 1128775466, --商人材料合成
    MakeDevice = 1128779350, --置换器制作
    UseDevice = 1128744146, --置换器使用

    DoubleActiveEnd = 1128787829, --结束双人动作

    EquipRefineTransfer = 1128736998, --精炼转移
    EquipRefineUnblock = 1128739348, --解除封印

    ExtractCard = 1128742974, --抽卡
    RecoveCard = 1128731988, --分解
    RecycleCardPreview = 1128737033, --抽卡预览

    EquipEnchantReborn = 1128761739,
    EquipEnchantInherit = 1128779426, -- 附魔继承
    EquipEnchantRebornPerfect = 1128737820, -- 完美提炼
    EquipEnchantRebornPreview = 1128756473,

    PreviewOrnament = 1128762887, --头饰抽取预览
    RecoveOrnament = 1128732527, --头饰分解
    ExtractOrnament = 1128738331, --头饰抽取

    PreviewMagicEquipExtract = 1128751780, --装备抽取预览
    RecoveEquip = 1128753410, --装备分解
    ExtractEquip = 1128770021, --装备抽取

    GetTutorialMark = 1128791897, --获取新手指引状态
    UpdateTutorialMark = 1128761009, --更新新手指引状态

    MedalOp = 1128747673, --勋章操作
    GetPrestigeAddition = 1128791048, --获取勋章服务器加成

    CatTradeActivityGetInfo = 1128754318, --猫车，拉取信息
    CatTradeActivityGetReward = 1128761508, --猫车,领取奖励
    CatTradeActivitySellGoods = 1128775408, --猫车，交货

    GetPostcardDisplay = 1128770966, --冒险日记获取子任务奖励领取记录
    UpdatePostcardDisplay = 1128737022, --冒险日记子任务奖励领取
    GetPostcardOneChapterAward = 1128744495, --冒险日记单个章节奖励领取
    UpdatePostcardChapterAward = 1128754980, --冒险日记总章节奖励领取

    SetArrow = 1128781745, -- 设置箭矢
    PayNotify = 1128644866, -- 充值查询

    DelegationAward = 1128755925, -- 委托领奖

    CreateChatRoom = 1128761121, --创建聊天室
    ChangeRoomSetting = 1128785493, --房间属性改版
    KickRoomMember = 1128743196, --将成员踢出
    LeaveRoom = 1128729918, --离开房间
    DissolveRoom = 1128746837, --解散房间
    ApplyJoinRoom = 1128738287, --申请加入
    RoomChangeCaptain = 1128764064, --房主变化
    GetChatRoomInfo = 1128773395, --主动拉取聊天室信息
    RoomAfk = 1128751381, --同步最大最小化窗口

    SwitchRole = 1129219665, --切换角色

    JunkItem = 1128767547, --丢弃道具

    PayFine = 1128774963,
    SetRedPointCommonData = 1128730530, --红点cd存储

    ThirtySignActivityGetInfo = 1128738399, --拉取30日签到数据
    ThirtySignActivityGetReward = 1128735340, --领取签到数据

    RequestEquipForgedList = 1128764582,

    DeleteRole = 1129202888,
    ResumeRole = 1129248219,
    GetAccountRoleData = 1129197904,
    WearHeadPortrait = 1128752237,

    RequestGridState = 1128763481, -- 请求贴纸格子状态
    RequestChangeSticker = 1128769752, -- 请求替换贴纸
    RequestAllOwnStickers = 1128764861, -- 请求所有拥有的贴纸
    RequestUnlockGrid = 1128734467, -- 请求解锁格子
    SaveStickersInGrid = 1128758446, -- 保存格子状态
    SceneTriggerSummonMonster = 1128742915,
    AttrRaisedChoose = 1128762972,

    RequestFashionEvaluationInfo = 1128766799, --当前主题和次数数据
    RequestFashionEvaluationNpc = 1129145357, --时尚杂志npc数据
    EvaluateFashion = 1128772536, --为自己评分
    RequestFashionMagazine = 1129147755, --拉取杂志数据
    RequestRoleFashionScore = 1129162408, --拉取照片信息
    FashionHistory = 1129151628, --拉取杂志历史
    FetchFashionTicket = 1128765043, --领取时尚杂志邀请函

    GetCobblestoneInfo = 1129162949, --获取公会原石数据
    CarveStone = 1129160022, --雕刻原石
    AskForCarveStone = 1129164971, --公会原石雕刻求助
    AskForPersonalCarveStone = 1129169057, --公会原石私人求助
    GetGuildStoneHelper = 1129127643, --公会晶石分配信息
    MakeStone = 1129180267, --制作原石
    MakeSouvenirStone = 1129145746, --制作精致原石
    AssignSouvenirCrystal = 1129156206, --公会原石礼盒分配
    SceneTriggerSummonMonster = 1128742915,
    AttrRaisedChoose = 1128762972,
    SceneTriggerSummonMonster = 1128742915,
    AttrRaisedChoose = 1128762972,
    CertifyRequest = 1128911720, -- 请求验证
    QueryGateIPNew = 1128921835, --请求网关IP

    --迷宫副本
    RunRoulette = 1128774358,


    GetThemeDungeonWeeklyAward = 1128761467, -- 请求主题副本奖励
    FinishClientAchievement = 1128757411, -- 照片墙


    QueryKapulaSign = 1129160327, --拉取卡普拉签名信息
    ReadKapulaAssis = 1129176881, --读取卡普拉信息
    PreCheckOperateLegal = 1128744350, --自拍、表情动作等
    AcceptGameAgreement = 1128916137, --保存用户协议信息
    EasyShowNavigate = 1128745025, --获取寻路路径
    RandomNavigate = 1128742311, --获取目的地半径随机寻路点

    GetLimitedOfferRechargeTable = 1128740302, --请求充值表
    RoleActivityStatusNtf = 1128777560, --通知角色待机或者活动的协议
    GetNextLimitedOfferOpenTime = 1128778686, -- 获取下次限时特惠开启时间

    MerchantGetShopInfo = 1128944029, -- 请求跑商信息
    MerchantShopBuy = 1128979834, -- 请求购买
    MerchantShopSell = 1128968171, -- 请求出售
    MerchantTaskComplete = 1128746307, -- 跑商提交
    MerchantGetEventInfo = 1128963659, -- 获取跑商事件
    MerchantEventBuy = 1128971309, -- 购买跑商事件
    MerchantEventPreBuy = 1128949160, -- 购买跑商事件前

    --主题舞会
    GetThemePartyInvitation = 1129162958, --获取主题派对邀请函
    GetThemePartyActivityInfo = 1129159342, --获取主题活动信息
    SetLoopDanceGroup = 1128752545, --保存舞会信息
    ThemePartySendLove = 1129141252, --点赞
    ThemePartyGetLoveInfo = 1129152568, --获取点赞信息
    ThemePartyGetNearbyPerson = 1129124882, --拉取周围人的信息
    ThemePartyGetPrizeMember = 1129143741, --获取舞会的得奖名单
    RequestLotteryDrawInfo = 1129129580, --请求舞会的抽奖时间信息

    GetMallInfo = 1128733225, --获取商城数据
    BuyMallItem = 1128738163, --购买商城货物
    FreshMallItem = 1128731167,
    GetMallTimestamp = 1128735412,
    ReceiveLevelGift = 1128765199, -- 领取等级奖励
    RequestKillMonsterCount = 1128777002, --请求击杀怪物数量

    TowerDungeonsAward = 1128758589, --领取无限塔奖励
    GetDungeonsMonster = 1128765336, --获取副本怪物

    GetSimpleBattleRevenue = 1128730987, --获取简易战斗统计数据
    GetBattleRevenue = 1128745733, --获取战斗统计数据

    SendGuildAid = 1129124326, --照相任务公会请求
    GetJobAward = 1128788806, -- 领取职业等级奖励
    BarterItem = 1128767822, --兑换某一个物体

    GSLocalGMCmd = 1128758869, -- gm指令

    GetWatchRoomList = 1129146633, -- 获取观战列表
    LikeWatchRoom = 1129132192, -- 点赞
    SearchWatchRoom = 1129172065, -- 搜索
    RequestWatchDungeons = 1128784650, -- 观战
    GetRoleWatchRecord = 1128734084, -- 观战记录
    WatcherSwitchPlayer = 1128782153, -- 切换观战角色
    GetWatchRoomInfo = 1129141438, -- 获取气泡观战信息
    SavePearsonalSetting = 1128735814, -- 观战设置

    OpenMultiTalent = 1128774577, --开启天赋
    ChangeMultiTalent = 1128752637, --切换天赋
    RenameMultiTalent = 1128742570, --重命名

    --佣兵相关
    MercenarySkillSlot = 1128740864, --佣兵技能
    MercenaryEquipUpgrade = 1128752468, --佣兵装备
    MercenaryTalentRequest = 1128734171, --佣兵天赋
    MercenaryTakeToFight = 1128778519, --佣兵出战
    MercenaryRequestUpgrade = 1128766095, --佣兵升级
    SelectTeamMercenarys = 1129133324, --队伍佣兵出战
    CheckTowerDefenseCondition = 1128767900, -- 塔防入口信息
    TowerDefenseSummon = 1128733263, -- 塔防召唤|升级英灵
    TowerDefenseServant = 1128733480, -- 塔防 回复|加速 英灵
    MercenaryChangeFightStatus = 1128777347, -- 协同被动

    -- 推送sdk相关
    PushInfoSwitchInfo = 1129150517,
    PushInfoSwitchModify = 1129169899,

    --脱离卡死
    RoleDetached = 1128735574,

    UpgradeLevel = 1128762492,

    -- 称号
    UpdateTitleStatus = 1128735844,

    ShareStickers = 1129138856, -- 贴纸分享
    --公会匹配战相关
    GetGuildFlowers = 1129153799, --领取/购买鲜花
    GuildBattleTeamApply = 1129167240, --队伍报名
    GetGuildBattleMgrTeamInfo = 1129139864, --获取队伍管理界面信息
    GetGuildBattleTeamInfo = 1129172172, --获取候选池队伍信息
    ChangeGuildBattleTeam = 1129161977, --更改参赛队伍
    GetGuildBattleWatchInfo = 1129184095, --观战获取鲜花和胜场信息
    GuildBattleTeamReApply = 1129150536, --队伍报名二次确认
    GetGuildBattleResult = 1129131050, --获取最终结果
    GiveGuildFlower = 1129181269, --匹配赛送花
    GuildMatchConvene = 1129125901, --勇士集结
    --波利团
    GetPollyAward = 1128760594, --领取波利奖励
    --排行榜
    RequestLeaderBoardInfo = 1128855700, --获取排行榜信息

    -- 一次存储系统
    SetOnceData = 1128780499,

    SetThemeStamp = 1128748759,
    IsAllMemberAssist = 1129183516, --队伍中是否全部为助战成员
    SetWorldEventSign = 1128778331, --时空调查团打标记
    --魔法信笺
    SendMagicPaper = 1129164539, --发送魔法信笺
    GrabMagicPaper = 1129120510, --抢魔法信笺红包
    QueryMagicPaper = 1129144494, --查询魔法信笺信息
    QueryGrapPaper = 1129163124, --查询魔法信笺详细信息
    BatchChatSenderInfo = 1129122857, --批量请求玩家信息
    ThanksMagicPaper = 1129169201, --感谢赠送魔法信笺

    SetWorldEventSign = 1128778331, --时空调查团打标记
    --月卡
    QueryCanBuyMonthCard = 1128784299, --购买月卡
    TestBuyMonthCard = 1128788416, --测试购买月卡
    RequestBuyQualifiedPack = 1128731643, --限定礼包购买
    RequestPickFreeGiftPack = 1128729821, --领取免费小礼品
    MonthCardExpireConfirm = 1128772387, --月卡过期确认
    BuyRebateCard = 1128775407,
    --- 批量请求团体数据的通用协议
    ClientGetRoleLeaderBoardRank = 1128845642,

    -- 黑市
    GetBlackMarketItemPrice = 1128759833,

    CDKeyExchange = 1129128786, -- 兑换码
    -- 拍卖
    GetAuctionInfo = 1128980521,
    AuctionFollowItem = 1128933946,
    AuctionItemBib = 1128968182,
    AuctionBillCancel = 1128929819,
    -- 卡片解封
    EquipCardUnSeal = 1128738199,
    GetMonsterAward = 1128758584, --魔物图鉴奖励领取

    SetClientCommonDataRpc = 1128734424, -- 设置commondata

    --宝藏猎人
    SurveyTreasure = 1128754845, --点击勘测按钮
    GetTreasurePanelInfo = 1128729159,
    HelpTreasure = 1128783550,
    StartTreasureHunter = 1128756487,

    -- 贝鲁兹核心
    MaintenanceWheelRpc = 1128730767,
    CombineWheelRpc = 1128733067,
    WheelReset = 1128774149,
    WheelChooseReset = 1128760505,

    -- 回归
    ReturnTaskFinish = 1128754873,
    ReturnPrizeWelcomeNext = 1128786767,    -- 欢迎流程下一步

    -- 回城设置
    RecallOperate = 1128731962,

    -- Bingo活动
    QueryBingoGuess = 1128754596,
    QueryBingoLight = 1128742089,
    QueryBingoZone = 1128732491,
    GetBingoAward = 1128730467,
    -- 礼包
    GetCommonAward = 1128753484,
    GetTimeGiftInfo = 1128757652,

    ManualRefreshMallItem = 1128730148,
}

--ptc协议(response)
Ptc = {
    --- 战场同步杀人数
    BattleFieldPVPCounterNtf = 1195581788,
    --- 聊天标签同步
    UpdateChatTag = 1195602437,
    LoginChallenge = 1413686732,
    KickRoleNtf = 1195616447,
    KeepAlivePingAck = 1129623050, --KeepAlivePingAck
    KeepAlivePingReq = 1413709288, --KeepAlivePingReq
    DelayNotify = 1128741923, --DelayNotify
    EnterSceneNtf = 1195575234,
    SelectRoleNtf = 1195637234,
    ReconnectSyncNotify = 1195616830, -- ReconnectSyncNotify
    ClientLogout = 1129590152,
    TowerDefenseMagicPowerNtf = 1195630538,
    TowerDefenseSyncMonster = 1195606521,
    TowerDefenseWaveBegin = 1195588285,
    TowerDefenseEndlessStartNtf = 1195592171,
    BackstageActNtf = 1296257992,
    RequestAchieveInfo = 1128745487,

    -- 节日签到活动
    SetSpecialSupplyDicePtc = 1195582962,
    SpecialSupplyRandomDiceNtf = 1195597938,
    MengXinLevelGiftsInfoNtf = 1195595651,
    ArenaSyncScoreNtf = 1195631593,

    --改名
    RoleNameChangeNotify = 1195575620,
    --组队
    CreateTeamNtf = 1296281627,
    NewTeamInvatationNtf = 1296290081,
    RecommondJoinTeamNtf = 1296263096, --队长收到申请入队的请求
    NewTeamMemberNtf = 1296257613,
    LeaveTeamNtf = 1296274472,
    TeamMercenaryChangeNtf = 1296284342,
    AttrUpdateNotify = 1195600949,
    AllMemberStatusNtf = 1296253748,
    TeamApplicationNtf = 1296237838, --队长收到入队申请
    HandOverCaptainReq = 1129128796, --提升队长
    CaptainChangeNtf = 1296247723, --队长变更通知
    KickTeamMemberNtf = 1296288652, --踢人下发广播通知
    PairOverNtf = 1296265068, --匹配结果下发
    MemberPosNtf = 1195609131, --同步位置信息
    AskFollowNtf = 1296283378, --同步邀请跟随的信息
    BeginFollowNtf = 1296282961, --跟随Ntf
    TeamSettingNtf = 1296291798, --同步组队设置
    ClearApplicationListReq = 1129134902, --清除申请列表
    StopFollow = 1129178948, --客户端通知服务器停止跟随
    StopFollowMS = 1296259399, --服务器通知停止跟随
    TeamShoutNtf = 1296249997, --组队喊话推送
    TeamMemberStatusNtf = 1296296903, --组队状态同步 在线 离线 暂离
    TeamAfkNtf = 1129122635, --组队暂离状态设置
    ApplyCaptainNtf = 1296264196, --通知队长有人申请队长
    RefuseCaptainApplyNtf = 1296254249, --广播队长拒绝了申请
    test = 21696666,
    UpdateTeamProfessions = 1296243073, -- 职业匹配
    --转职
    TransferProfessionPtc = 1195602697,
    --道具
    JobLevelChangeNtf = 1195573953,
    LevelChangeNtf = 1195603965,
    BagFullSendMailNtf = 1195634437,
    BagLoadUnlockNtf = 1195586264,

    --任务
    TaskUpdate = 1195633975,
    TaskTriggerAllNotify = 1195612261,
    TaskDelete = 1195598263,
    TaskTriggerNotify = 1195592923,
    TaskTriggerDelete = 1195620879,
    ItemChangeNtf = 1195630403,
    ItemAwardNtf = 1195618306,
    AcceptTaskFailedNotifyMs = 1296239520,
    AcceptTaskFailedNotify = 1195589442,
    TaskDanceStatusNtf = 1195593396,
    TakePhotoCondition = 1128779276, --任务拍照触发机制

    --GM
    LocalGMCmd = 1128743809,
    DPSInfoNtf = 1195599645,
    --角斗场pvp
    PushIntoArenaPvpCustom = 1129146080, --开始
    SyncArenaRoomBriefInfoNtf = 1296281837, --房间信息
    ArenaRoomStateNtf = 1296294026, --开始结束
    ArenaInviteNtf = 1296300648,
    --聊天
    ChatMsgNtf = 1413693523,
    TaskFinishNotify = 1195634242,
    ShowBubbleNotify = 1195608853,
    ChatForbidNtfOnLogin = 1296257469,

    --新的聊天
    ChattingMsgNotify = 1296249794,
    ChattingMsgNtf = 1413741926,
    SendChattingMsg = 1129131590,

    --
    PushAnnouceNtf = 1413689142,
    PushHornNtf = 1413723955,
    OpenSystemInfoNtf = 1195602084,
    MSOpenSystemInfoNtf = 1296238035,
    -- 载具
    AskTakeVehicleNotify = 1195615041,
    UpdateVehicleAttrs = 1195594244,
    AddTempVehicle = 1195593452,
    UpdateVehicleRecordForGM = 1195596679,

    BroadcastTakePhotoStatus = 1128748879,

    --主题副本
    CaptainRequestEnterFBPtc = 1129131206, ---请求进入主题副本
    FailEnterFBNtf = 1296275459, ---请求进入副本失败
    AskMemberEnterFBNtf = 1296286321, ---通知队员选择
    MemberReplyEnterFBPtc = 1129148673, ---队员同意或拒绝
    SyncMemberReplyEnterFBNtf = 1296282990, ---同步其他队员的选择
    DungeonsResult = 1195573408, ---副本结算
    LeaveSceneReq = 1128781931, ---客户端主动请求离开副本
    DungeonsEncourage = 1128775436, ---点赞
    NotifyDungeonsEncourage = 1195578442, ---点赞通知

    --无限塔
    NotifyTowerRefresh = 1195631564, --刷新周期

    --双人烹饪
    CookFoodOperationPtc = 1128769891, -- 双人烹饪操作

    EnterDungeons = 1128745152,
    PushAdData2Client = 1296256557,

    EffectShow = 1195581110,

    ---副本提示
    DungeonsPrompt = 1195629424,
    BossTimeline = 1195623389,
    Guide = 1195592968,
    GuideDisable = 1195576203,
    ShowCutSceneNtf = 1195596779,
    SingleTimeLineEnd = 1128741963,
    DungeonsUpdateNotify = 1195605085, --副本倒计时延长

    ---商会
    TradeInfoUpdateNotify = 1245911761, ----商会变更信息
    TradeKeepAliveNotify = 1128960476, ----保活
    CountInfoUpdateNotify = 1195588959, ----购买次数更新
    TradeItemStockChangeNtf = 1245909467,

    --公会
    EnterGuildScene = 1129154667, --进入公会场景
    GuildEnterNotify = 1296276726, --被接收进入公会
    GuildKickOutNotify = 1296286225, --被踢出公会
    GuildInviteNotify = 1296245054, --被邀请入会
    GuildRoleInfoSyncNotifyToClient = 1296298497, --个人公会信息变动推送
    GuildRoleInfoSyncNotifyToNeighbor = 1195610104, --屏幕内他人信息变动推送
    GuildUpgradeNotify = 1296292389, --公会建筑升级完成推送
    GuildCrystalUpdateNotfiy = 1296251398, --公会水晶升级推送
    GuildHuntOpenNotify = 1296283897, --公会狩猎开启推送
    GuildHuntFinishNtf = 1296258646, --公会狩猎完成推送
    NtfGuildHuntReward = 1296243557, --公会狩猎副本完成特殊推送
    GuildHuntDungeonUpdateNotify = 1296295864, --公会狩猎进度更新
    GuildHuntSealPieceCount = 1296286095, --公会狩猎灵魂碎片使用历史
    GuildAuctionPersonalRecord = 1195611606, --公会仓库个人拍卖纪录推送
    GuildTodayMoney = 1296243885, --公会今日获得资金

    GuildBindingNtf = 1129138460, --公会绑群通知服务器

    GuildDinnerShareDishToClient = 1413739811, --公会宴会菜肴分享消息
    GuildDinnerCreamMeleeStart = 1195602466, --公会宴会前大乱斗开始消息
    GuildDinnerCreamMeleeMemberChange = 1195623813, --公会宴会前大乱斗参与人数变化消息
    GuildDinnerCreamMeleeEnd = 1195579148, --大乱斗结束信息
    GuildDinnerPetrifactionNtf = 1195597264, --公会宴会有人变石像信息
    GuildDinnerPetrifactionEndNtf = 1195610119, --公会宴会有人变石像结束信息
    GuildDinnerOpenChampagneNtf = 1296246654, --公会宴会开启香槟
    GuildDinnerRandomEventNtf = 1195637913, --公会宴会随机刷新事件通知
    GuildOrganizePersonAwardNtf = 1296283589, --组织手册个人可领奖励通知

    SendPrivateChatMsg = 1129128385,
    PrivateChatNtf = 1296281221,
    UnReadMessageCountNtf = 1296301563,
    UpdateOrAddFriendNtf = 1296291398,
    DeleteFriendNtf = 1296300171,
    AddFriendTipNtf = 1296298087,
    FriendIntimacyDegreeNtf = 1296241600,

    --圣歌试炼
    HSDungeonsOneRoundStart = 1195610109, --每轮转盘开始
    HSCloseRoulette = 1195589740, --每轮战斗开始
    HSDungeonsOneRoundOver = 1195593381, --每轮结束
    PraiseRole = 1195590642, --点赞推送

    --波利团（呀哈哈）
    DiscoverYahhNtf = 1195620950, --找到波利精灵
    YahhAwardNtf = 1195592782, --奖励信息有新增
    ---摆摊
    StallItemSoldNotify = 1245956397, --卖出通知

    UpdateMailNtf = 1296260259, --邮件状态同步

    HintNotifyMS = 1296268655, --红点
    --技能解锁
    TaskUnlockSkillNtf = 1195634813,

    LifeSkillNtf = 1195576816,
    AutoCollectEndNtf = 1195585915, --自动采集结束
    UpdateLifeSkillAward = 1195633812, --更新生活职业奖励

    BeHatredDisappearNotify = 1195580067, --副本仇恨消失

    WaBaoAwardIdNtf = 1195634322, -- 挖宝转盘

    MSErrorNotify = 1296275872,
    GSErrorNotify = 1195608496,
    TradeErrorNotify = 1245907313,

    LifeEquipNtf = 1195579382, --钓鱼相关装备获取(鱼竿、遮阳棚)
    AutoFishResultNtf = 1195591197, --自动钓鱼结算

    SevenLoginActivityUpdateNotify = 1195576049, --通知七日奖励数据更新

    RedPointNotify = 1296256110,

    PhotoFlowTlog = 1128777144, -- 拍照日志

    AnnounceClearNotify = 1296285407, --清除公告
    RoleOnlineNtf = 1296300446,


    DoubleActiveApplyPush = 1195621625, -- 邀请双人动作
    DoubleActiveSuc = 1195582454, --
    DoubleActiveRevoke = 1128787307, -- 取消双人动作(主动方)
    DoubleActiveRefuse = 1128764512, -- 拒绝双人动作(被动方)
    DoubleActiveRefused = 1195583741, -- 拒绝双人动作(被动方)
    DoubleActiveRevoked = 1195628771, -- 取消双人动作(被动方)

    TowerStartCountdown = 1195622557, --无限之塔倒计时
    TowerLucky = 1195573804, --无限塔结算幸运玩家

    NotifyFirstKillMonster = 1195596335, --首次击杀魔物图鉴

    SingleAchievementNotify = 1195593387,
    SetAchievementFocus = 1128787188,

    NotityTeamBattlefieldMatch = 1296270654, --战场进度匹配队列

    TriggerAddSkillNtf = 1195634321,
    GetWorldPveEvent = 1128760433,
    RoleWorldEventNotify = 1195589246,
    RoleWorldEventDBNotify = 1195594295,
    SaveAutoBattleInfoNtf = 1128752550,

    MedalChangedNofity = 1195594728, --勋章改变
    RedPointNotifyGs = 1195629117,
    GarbageCollectNtf = 1195585462,
    CheckQueuingReq = 1129222574,
    CheckQueuingNtf = 1313048034,
    FashionLevelChange = 1195578108,

    WaBaoStartNotify = 1195590657, -- 挖宝通知
    SaveRoleSetupInfoNtf = 1128784493, --通知服务器设置等级一下陌生人屏蔽是否开启
    ClearChatRecordNtf = 1129124422, --删除好友聊天记录

    PayParameterInfoNtf = 1128634311, --登陆成功时，上传支付参数给服务器
    BuyGoodUrlNtf = 1128634311, --推送支付url

    LeaveRoomNft = 1195585853, --离开聊天房间
    RoomChangeCaptainNtf = 1195591822, --房主变化
    RoomDissolveNtf = 1195585222, --解散房间
    RoomKickMemberNtf = 1195582250, --将成员踢出
    RoomSettingChangeNtf = 1195592986, --房间属性改版
    RoomInfoNtf = 1195636189, --进入房间时拿到的房间信息
    NewRoomMemberNtf = 1195629672, --一个用户加入房间
    RoomBriefNeighbourNtf = 1195605056, --冒泡信息同步
    RoomMerberStatusNft = 1195586275, --同步离线状态

    UnitAppear = 1195609157, --镜像同步？

    EquipBuffAttachSkillNtf = 1195616937,

    NotifyRollStart = 1195596922,
    RollConfirm = 1128759041,
    RollConfirmNtf = 1195621194,
    NotifyFlop = 1195627555,
    MVPDeadNotify = 1195637941,
    ChatMsgClearNtf = 1296240545, --清楚某人的聊天
    TeamSyncBuff = 1296242124,
    ChatMsgClearNtf = 1296240545, --清楚某人的聊天

    FashionCountNtf = 1195613102, --装扮时尚度通知
    GMAnnouncePtc = 1296274171,

    PVPBroadcastNtf = 1195580385,
    ShareFashionPhoto = 1129177893, --照片分享协议
    FollowOutRangeNft = 1195612438,

    ThirtySignActivityUpdateNotify = 1195575653,

    DelegationRefresh = 1195631870, -- 委托全量信息
    DelegationUpdate = 1195589650, -- 委托增量信息
    PVPBroadcastNtf = 1195580385,
    OwnStickersNtf = 1195577366, -- 贴纸变化通知
    PayBuyGoodsNtf = 1128745557, -- 支付结果上传
    PayMoneySuccessFromGs = 1195593450,
    PayMoneySuccessFromMs = 1296255208,
    AntiAddictionNtf = 1296284088, -- 防沉迷
    AISyncVarListNtf = 1195584500,
    AttrRaisedNotify = 1195608859, --收到副本加点推送

    UploadFashionPhotoData = 1129172775, --上传【照片】数据

    CobbleStoneHelp = 1413728030, --公会有人求助雕刻
    CobblleStoneCarvedNtf = 1296276013, --其他人帮我雕刻成功

    WeakQteGuideNotify = 1195626579, --AI节点调用新手指引(弱指引)
    QteGuideNotify = 1195599627, --QTE指引(强指引)

    UpdateDungeonsTarget = 1195622990,
    DungeonsTargetSection = 1195635808,

    -- 回归
    ReturnTaskReset = 1195585349,       -- 任务重置
    ReturnTaskUpdate = 1195597761,      -- 任务刷新
    ReturnPrizeLoginAwardUpdate = 1195590078,
    ReturnPrizeWelcomeNtf = 1195597954,

    --迷宫副本
    MazeDungeonsMapNtf = 1195636190,
    MazeDungeonsIncreaseMapNtf = 1195575463,
    RunRouletteNtf = 1195588703,
    MazeRoomStartOrEndNtf = 1195617947, --迷雾之森躲避球开始或结束推送

    --SendRedEnvelopeNtf = 1296241599,  --公会红包的推送
    SendRenEnvelopePasswordNtf = 1296278205, --公会口令红包成功领取后推送

    CommandScriptSendEvent = 1128749896, --剧本发送网络事件
    SendToEntityAINtf = 1128733513, --剧本向Entity AI发送消息

    CheckStateExclusionFailNtf = 1195596486, --服务器同步状态互斥错误码消息

    MerchantUpdateNotify = 1195595800, -- 跑商消息通知

    TeleportItem = 1128773851, -- 蝴蝶翅膀传送
    NpcTalkReq = 1128782160, --npc对话后停止移动

    --主题舞会
    EnterSceneReq = 1128772851,
    DanceReq = 1128784877,
    DanceActionNtf = 1195609063,
    ThemePartyStateNtf = 1296283191,
    ThemePartyLoveNtf = 1296255732,
    ThemePartyLotteryDrawNtf = 1296236947,
    SwichSceneBgmNtf = 1195603048,

    NtfClientLimitedOfferStatus = 1195618314, -- 推送限时特惠状态
    MidasExceptionNtf = 1296250619,
    PayForLimitedOfferSuccessNtf = 1128789258,
    NpcTalkScriptEvent = 1128790698, --网络事件

    --大世界
    AllSceneInfluenceNtf = 1296255766,
    SceneInfluenceUpdate = 1296261825,
    DynamicDisplayNpcNtf = 1195614752,
    DynamicDisplayNpcUpdate = 1195637863,
    ActivityMailTipNtf = 1296280460,

    CallBlackCurtainNtf = 1195597876, --服务器通知播放黑幕

    BattleRevenueChangeNtf = 1195635041, --战斗通知物品改变

    ChatCDNotify = 1296291844, --同步聊天cd剩余时间

    DungeonWatchAllMemberStatusNtf = 1195626788, -- 观战信息同步
    DungeonWatchBriefStatusNft = 1195592047, -- 观战状态信息同步
    UpdateRoomWatchInfo = 1195587426, -- 观战房间信息同步
    WatchSwitch = 1195586814, -- 通知客户端观战对象切换
    DungeonsWatchInit = 1195613574, -- 观战初始化消息
    QualityPointUpdateNotify = 1195578637, --同步属性点变化
    NotifySkillPlan = 1195584897, -- 技能方案变化通知
    GuildMatchTeamCacheNtf = 1296300582, -- 公会匹配赛队伍快照
    GuildMatchActivityNtf = 1296274601, -- 公会匹配赛推送
    TeamWatchStatusNtf = 1296250035, -- 队伍成员观战状态

    --佣兵相关
    MercenaryAttrUpdateNtf = 1195632803, --佣兵属性
    MercenaryRecruitNtf = 1195611336, --佣兵招募
    MercenaryAdvanceNtf = 1195637428, --佣兵进阶
    MercenaryDeadNtf = 1195605936, --佣兵死亡
    MercenaryUidNtf = 1195602999, --佣兵UID
    MercenaryEquipInfoNtf = 1195634967, -- gm升级装备
    MercenarySkillOpenNtf = 1195626907, -- 佣兵技能解锁
    MercenaryFightNumNtf = 1195593112, -- 佣兵栏位解锁

    CommondataNtf = 1195623669, --数据同步协议

    HealthExpNtf = 1195630096, -- 祈福经验上线通知

    RoleAttributeNtf = 1195577348, -- 角色属性更改，如称号
    HealthExpNtf = 1195630096, -- 祈福经验上线通知

    PushMsgTokenToMs = 1129141763, -- 客户端上传推送token

    --公会匹配战相关
    RefreshGuildBattrleMgrTeamInfoNtf = 1296296938, --队伍管理界面刷新数据
    GuildFlowersChangeNtf = 1296271846, --鲜花数量改变推送
    GuildBattleResultNtf = 1296261277, --最终战斗结算
    GuildMatchSyncRoleLife = 1195577398, --匹配赛玩家剩余生命值
    GuildMatchBattleTeamApplyResultNtf = 1296250745, --匹配赛玩家报名结果
    RefreshGuildMatchTeamInfoNtf = 1296253053, --更新匹配池数据
    --LeaveToGuildMatchWaitingRoomNtf =
    --角色养成
    RoleNurturanceTlog = 1128782584,
    UseItemReplyClientPtc = 1296275156, --支付扣除返回
    --- 道具更新同步协议
    UpdateItemNtf = 1195575816,
    --- 调换道具位置协议
    SwapItem = 1128777735,

    -- 拍卖
    AuctionKeepAliveNotify = 1128987784,
    AuctionItemChangeNotify = 1245937080,
    UpdateMonsterKilledNum = 1195634579, --更新魔物数量

    OpenSystemChangeNtf = 1195584031, -- 开关通知
    --宝藏猎人
    MonsterTreasureDelNtf = 1195630606,
    TreasureHunterInfoNtf = 1195573462,
    TreasureHunterShowSurveyBtn = 1195623842,

    -- 回城
    RoleRecallNtf = 1195613497,
    --角色死亡
    RoleDeadNtf = 1195636943,

    -- sdk创建支付订单
    PaySDKCreateOrder = 1128647375,
    -- sdk创建支付订单返回结果
    PaySDKOrderResult = 1162032749,

    NtfActivityTimeInfo = 1195611541,
    NtfActivityState = 1195586489,
    SyncTeamMemberInfo = 1296286257,
    CaptainRequestEnterSceneReq = 1129142674,
}
