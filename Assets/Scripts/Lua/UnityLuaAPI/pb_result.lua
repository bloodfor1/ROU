
---@class EnmDailyActivityType
---@field EnmDailyActivityTypeNone number @value:0,des:
---@field EnmDailyActivityTypeLeyuan number @value:1,des:乐园团委托
---@field EnmDailyActivityTypeTheme number @value:2,des:记忆碎片
---@field EnmDailyActivityTypeTower number @value:3,des:无尽之塔
---@field EnmDailyActivityTypePVP number @value:4,des:角斗场
---@field EnmDailyActivityTypeMVP number @value:5,des:MVP
---@field EnmDailyActivityTypeTrail number @value:6,des:圣歌试炼
---@field EnmDailyActivityTypeBattlefield number @value:7,des:战场
---@field EnmDailyActivityTypeDigTreasure number @value:8,des:挖宝
---@field EnmDailyActivityTypePlatform number @value:10,des:擂台
---@field EnmDailyActivityTypeGuildMatch number @value:11,des:公会匹配赛
EnmDailyActivityType = {}

---@class EnmDungeonsDegree
---@field kDungeonsDegreeNone number @value:0,des:
---@field kDungeonsDegreeOne number @value:1,des:难度一
---@field kDungeonsDegreeTwo number @value:2,des:难度二
---@field kDungeonsDegreeThree number @value:3,des:难度三
EnmDungeonsDegree = {}

---@class EnmBingoGridState
---@field kBingoGridStateNone number @value:0,des:
---@field kBingoGridStateCanGuess number @value:1,des:未知可猜
---@field kBingoGridStateCantGuess number @value:2,des:未知但不可猜
---@field kBingoGridStateGray number @value:3,des:待点亮
---@field kBingoGridStateOwn number @value:4,des:已点亮
---@field kBingoGridStateCost number @value:5,des:付费可点亮
EnmBingoGridState = {}

---@class EnmBackstageDetailType
---@field EnmBackstageDetailTypeNone number @value:0,des:
---@field EnmBackstageDetailTypeTreasureHunt number @value:2,des:宝藏猎人
---@field EnmBackstageDetailTypeSpecialSupply number @value:3,des:特殊补给活动
---@field EnmBackstageDetailTypeBingo number @value:4,des:bingo
---@field EnmBackstageDetailTypeDungeons number @value:5,des:活动副本
---@field EnmBackstageDetailTypeWarriorRecruit number @value:6,des:勇士招募积分
---@field EnmBackstageDetailTypeHuntField number @value:7,des:狩猎场
EnmBackstageDetailType = {}

---@class ReturnPrizeTaskTarget
---@field kReturnPrizeTaskTarget_None number @value:0,des:
---@field kReturnPrizeTaskTarget_use_delegate_point number @value:1,des:消耗委托点数
---@field kReturnPrizeTaskTarget_mvp number @value:2,des:参与mvp
---@field kReturnPrizeTaskTarget_use_zeny number @value:3,des:消耗zeny
---@field kReturnPrizeTaskTarget_refine_equip number @value:4,des:装备精炼
---@field kReturnPrizeTaskTarget_guild_chat number @value:5,des:公会频道发言
---@field kReturnPrizeTaskTarget_maoshou number @value:6,des:建设绵绵岛
ReturnPrizeTaskTarget = {}

---@class ReturnPrizeWelcomeStatus
---@field kReturnPrizeWelcomeStatus_None number @value:0,des:无意义
---@field kReturnPrizeWelcomeStatus_letter number @value:1,des:欢迎回来，信封界面
---@field kReturnPrizeWelcomeStatus_content number @value:2,des:信件内容
---@field kReturnPrizeWelcomeStatus_prize number @value:3,des:见面礼
---@field kReturnPrizeWelcomeStatus_join_guild number @value:4,des:加入公会
---@field kReturnPrizeWelcomeStatus_end number @value:5,des:回归结束界面。
ReturnPrizeWelcomeStatus = {}

---@class AttrType
---@field ATTR_SPECIAL_SEX number @value:0,des:性别
---@field ATTR_SPECIAL_BASE_LV number @value:1,des:角色等级
---@field ATTR_BASIC_BASE_EXP number @value:2,des:角色经验
---@field ATTR_SPECIAL_JOB_LV number @value:3,des:职业等级
---@field ATTR_BASIC_JOB_EXP number @value:4,des:职业经验
---@field ATTR_BASIC_HP number @value:5,des:当前生命值
---@field ATTR_PERCENT_HP number @value:6,des:恢复当前生命值万分比
---@field ATTR_BASIC_SP number @value:7,des:当前魔法值
---@field ATTR_PERCENT_SP number @value:8,des:恢复当前魔法值万分比
---@field ATTR_BASIC_SIGHT number @value:9,des:视野
---@field ATTR_SPECIAL_WEAPON_TYPE number @value:10,des:武器类型
---@field ATTR_SPECIAL_SPECIAL_EXP number @value:11,des:经验加成
---@field ATTR_SPECIAL_BARROW_CAR number @value:12,des:是否有手推车
---@field ATTR_BASIC_STR number @value:13,des:素质力量
---@field ATTR_BASIC_STR_EQUIP number @value:14,des:力量
---@field ATTR_BASIC_INT number @value:15,des:素质智力
---@field ATTR_BASIC_INT_EQUIP number @value:16,des:智力
---@field ATTR_BASIC_AGI number @value:17,des:素质敏捷
---@field ATTR_BASIC_AGI_EQUIP number @value:18,des:敏捷
---@field ATTR_BASIC_DEX number @value:19,des:素质灵巧
---@field ATTR_BASIC_DEX_EQUIP number @value:20,des:灵巧
---@field ATTR_BASIC_VIT number @value:21,des:素质体质
---@field ATTR_BASIC_VIT_EQUIP number @value:22,des:体质
---@field ATTR_BASIC_LUK number @value:23,des:素质幸运
---@field ATTR_BASIC_LUK_EQUIP number @value:24,des:装备幸运
---@field ATTR_BASIC_BASE_ATK number @value:25,des:素质物理攻击
---@field ATTR_PERCENT_BASE_ATK number @value:26,des:素质物理攻击万分比
---@field ATTR_BASIC_WEAPON_ATK number @value:27,des:物理攻击
---@field ATTR_PERCENT_WEAPON_ATK number @value:28,des:物理攻击万分比
---@field ATTR_BASIC_SKILL_ATK number @value:29,des:技能物理攻击
---@field ATTR_BASIC_BASE_DEF number @value:30,des:素质物理防御
---@field ATTR_PERCENT_BASE_DEF number @value:31,des:素质物理防御万分比
---@field ATTR_BASIC_DEF number @value:32,des:物理防御
---@field ATTR_PERCENT_DEF number @value:33,des:物理防御万分比
---@field ATTR_BASIC_BASE_MATK number @value:34,des:素质魔法攻击
---@field ATTR_PERCENT_BASE_MATK number @value:35,des:素质魔法攻击万分比
---@field ATTR_BASIC_WEAPON_MATK number @value:36,des:魔法攻击
---@field ATTR_PERCENT_WEAPON_MATK number @value:37,des:魔法攻击万分比
---@field ATTR_BASIC_SKILL_MATK number @value:38,des:技能魔法攻击
---@field ATTR_BASIC_BASE_MDEF number @value:39,des:素质魔法防御
---@field ATTR_PERCENT_BASE_MDEF number @value:40,des:素质魔法防御万分比
---@field ATTR_BASIC_MDEF number @value:41,des:魔法防御
---@field ATTR_PERCENT_MDEF number @value:42,des:魔法防御万分比
---@field ATTR_BASIC_IGNORE_DEF number @value:43,des:忽视物理防御
---@field ATTR_PERCENT_IGNORE_DEF number @value:44,des:忽视物理防御万分比
---@field ATTR_BASIC_IGNORE_MDEF number @value:45,des:忽视魔法防御
---@field ATTR_PERCENT_IGNORE_MDEF number @value:46,des:忽视魔法防御
---@field ATTR_BASIC_MAX_HP number @value:47,des:生命上限
---@field ATTR_PERCENT_MAX_HP number @value:48,des:生命上限万分比
---@field ATTR_BASIC_MAX_SP number @value:49,des:魔法上限
---@field ATTR_PERCENT_MAX_SP number @value:50,des:魔法上限万分比
---@field ATTR_BASIC_HIT number @value:51,des:命中
---@field ATTR_PERCENT_HIT number @value:52,des:命中万分比
---@field ATTR_BASIC_FLEE number @value:53,des:闪避
---@field ATTR_PERCENT_FLEE number @value:54,des:闪避万分比
---@field ATTR_BASIC_CRI number @value:55,des:暴击
---@field ATTR_PERCENT_CRI number @value:56,des:暴击万分比
---@field ATTR_BASIC_CRI_RES number @value:57,des:暴击防护
---@field ATTR_PERCENT_CRI_RES number @value:58,des:暴击防护万分比
---@field ATTR_PERCENT_CRI_DAM number @value:59,des:暴伤万分比
---@field ATTR_PERCENT_CRI_DEF number @value:60,des:暴伤防护万分比
---@field ATTR_BASIC_REFINE number @value:61,des:精炼物理攻击
---@field ATTR_BASIC_MREFINE number @value:62,des:精炼魔法攻击
---@field ATTR_BASIC_REFINE_REDUC number @value:63,des:精炼物理防御
---@field ATTR_BASIC_MREFINE_REDUC number @value:64,des:精炼魔法防御
---@field ATTR_PERCENT_DAM_INCREASE number @value:65,des:物理伤害加伤万分比
---@field ATTR_PERCENT_MDAM_INCREASE number @value:66,des:魔法伤害加伤万分比
---@field ATTR_PERCENT_DAM_REDUC number @value:67,des:物理伤害减免万分比
---@field ATTR_PERCENT_MDAM_REDUC number @value:68,des:魔法伤害减免万分比
---@field ATTR_PERCENT_SKILL_ASPD number @value:69,des:技能攻速
---@field ATTR_BASIC_EQUIP_ASPD number @value:70,des:装备攻速
---@field ATTR_PERCENT_EQUIP_ASPD number @value:71,des:装备攻速万分比
---@field ATTR_BASIC_BASE_ASPD number @value:72,des:基础攻速
---@field ATTR_BASIC_MOVE_SPD number @value:73,des:移动速度*100
---@field ATTR_PERCENT_MOVE_SPD number @value:74,des:移动速度万分比
---@field ATTR_BASIC_HP_RESTORE_SPD number @value:75,des:HP恢复速度
---@field ATTR_PERCENT_HP_RESTORE_SPD number @value:76,des:HP恢复速度万分比
---@field ATTR_BASIC_SP_RESTORE_SPD number @value:77,des:SP恢复速度
---@field ATTR_PERCENT_SP_RESTORE_SPD number @value:78,des:SP恢复速度万分比
---@field ATTR_PERCENT_ITEM_HP_RESTORE_SPD number @value:79,des:HP药剂恢复速度万分比
---@field ATTR_PERCENT_ITEM_SP_RESTORE_SPD number @value:80,des:SP药剂恢复速度万分比
---@field ATTR_BASIC_CT_FIXED number @value:81,des:固定吟唱时间
---@field ATTR_PERCENT_CT_FIXED number @value:82,des:固定吟唱时间万分比
---@field ATTR_BASIC_CT_CHANGE number @value:83,des:可变吟唱时间
---@field ATTR_PERCENT_CT_CHANGE number @value:84,des:可变吟唱时间万分比
---@field ATTR_BASIC_CD_CHANGE number @value:85,des:冷却时间
---@field ATTR_PERCENT_CD_CHANGE number @value:86,des:冷却时间万分比
---@field ATTR_BASIC_SP_COST number @value:87,des:魔法值消耗
---@field ATTR_PERCENT_SP_COST number @value:88,des:魔法值消耗万分比
---@field ATTR_BASIC_ATK_DISTANCE number @value:89,des:攻击距离
---@field ATTR_PERCENT_HEAL_ENC number @value:90,des:治疗加成万分比
---@field ATTR_PERCENT_BEHEAL_ENC number @value:91,des:受治疗加成
---@field ATTR_SPECIAL_SINGING_BREAK_MAX_HP_PERCENT number @value:92,des:吟唱期间受到最大生命值百分比总伤害打断吟唱（在GlobalTable初始化）
---@field ATTR_SPECIAL_ASPD number @value:93,des:ASPD最终值; 0是正常速度; 1000相当于增速1000/10000.0
---@field ATTR_SPECIAL_STR number @value:94,des:属性计算后力量
---@field ATTR_SPECIAL_INT number @value:95,des:属性计算后智力
---@field ATTR_SPECIAL_AGI number @value:96,des:属性计算后敏捷
---@field ATTR_SPECIAL_DEX number @value:97,des:属性计算后灵巧
---@field ATTR_SPECIAL_VIT number @value:98,des:属性计算后体质
---@field ATTR_SPECIAL_LUK number @value:99,des:属性计算后幸运
---@field ATTR_SPECIAL_VEHICLE_SPD number @value:100,des:载具速度
---@field ATTR_BASIC_GROUP_CD_CHANGE number @value:101,des:技能公共CD改变
---@field ATTR_PERCENT_GROUP_CD_CHANGE number @value:102,des:技能公共CD改变万分比
---@field ATTR_BASIC_WIGHT number @value:103,des:当前负重
---@field ATTR_PERCENT_WIGHT number @value:104,des:当前负重万分比
---@field ATTR_BASIC_WIGHT_MAX number @value:105,des:负重上限基础
---@field ATTR_PERCENT_WIGHT_MAX number @value:106,des:负重上限万分比
---@field ATTR_SPECIAL_WIGHT_MAX number @value:107,des:总负重上限
---@field ATTR_BASIC_WIGHT_PROFESSION number @value:108,des:职业负重
---@field ATTR_BASIC_WIGHT_COMMODITY number @value:109,des:物品负重
---@field ATTR_PERCENT_FLOATING_DAMAGE_UP number @value:110,des:伤害向上浮动属性万分比
---@field ATTR_PERCENT_FLOATING_DAMAGE_DOWN number @value:111,des:伤害向下浮动属性万分比
---@field ATTR_BASIC_WEAPON_ATK_DISTANCE number @value:112,des:武器射程
---@field ATTR_BASIC_EXTRA_WIGHT number @value:113,des:负重额外添加上限(健身券添加的负重上限; buff添加的负重上线)
---@field ATTR_BASIC_WIGHT_CART number @value:114,des:手推车负重
---@field ATTR_SPECIAL_WIGHT_CART_MAX number @value:115,des:手推车最大负重
---@field ATTR_BASIC_MOVE_SPD_FINAL number @value:116,des:最终速度
---@field ATTR_BASIC_BASE_ATK_FINAL number @value:117,des:
---@field ATTR_BASIC_BASE_MATK_FINAL number @value:118,des:
---@field ATTR_BASIC_BASE_DEF_FINAL number @value:119,des:
---@field ATTR_BASIC_BASE_MDEF_FINAL number @value:120,des:
---@field ATTR_BASIC_WEAPON_ATK_FINAL number @value:121,des:
---@field ATTR_BASIC_WEAPON_MATK_FINAL number @value:122,des:
---@field ATTR_BASIC_DEF_FINAL number @value:123,des:
---@field ATTR_BASIC_MDEF_FINAL number @value:124,des:
---@field ATTR_BASIC_CT_FIXED_FINAL number @value:125,des:
---@field ATTR_BASIC_CT_CHANGE_FINAL number @value:126,des:
---@field ATTR_BASIC_MAX_HP_FINAL number @value:127,des:
---@field ATTR_BASIC_MAX_SP_FINAL number @value:128,des:
---@field ATTR_BASIC_HIT_FINAL number @value:129,des:
---@field ATTR_BASIC_FLEE_FINAL number @value:130,des:
---@field ATTR_BASIC_HP_RESTORE_SPD_FINAL number @value:131,des:
---@field ATTR_BASIC_SP_RESTORE_SPD_FINAL number @value:132,des:
---@field ATTR_BASIC_CRI_FINAL number @value:133,des:
---@field ATTR_BASIC_CRI_RES_FINAL number @value:134,des:
---@field ATTR_SPECIAL_CARD_DROP_RATE number @value:135,des:卡片掉率
---@field ATTR_SPECIAL_HEADWEAR_DROP_RATE number @value:136,des:头饰掉率
---@field ATTR_SPECIAL_NO_SKILL number @value:137,des:不可主动使用技能(不包括普攻
---@field ATTR_SPECIAL_NO_ATTACK number @value:138,des:普攻不可用
---@field ATTR_SPECIAL_NO_USE_ITEM number @value:139,des:道具不可用
---@field ATTR_SPECIAL_NO_MOVE number @value:140,des:不可主动位移（包括技能类型为“位移类”的技能）
---@field ATTR_SPECIAL_NO_CHARGE_MOVE number @value:141,des:不可被动位移
---@field ATTR_SPECIAL_NO_STIFF number @value:142,des:受击不会硬直
---@field ATTR_SPECIAL_FEAR_RUN number @value:143,des:不受控制位移
---@field ATTR_SPECIAL_HIDING number @value:144,des:不可被发现
---@field ATTR_SPECIAL_FREEZE number @value:145,des:冻结当前动作帧
---@field ATTR_SPECIAL_NO_ATTACKED number @value:146,des:免疫所有受到的伤害和即将受到的减益效果
---@field ATTR_SPECIAL_DEATH_MIMICRY number @value:147,des:装死
---@field ATTR_SPECIAL_NO_SNEER number @value:148,des:不接受嘲讽类技能的嘲讽效果
---@field ATTR_SPECIAL_NO_STOP_SINGING_BY_HURT number @value:149,des:不会受到伤害打断吟唱
---@field ATTR_SPECIAL_NO_STOP_SINGING number @value:150,des:不会被打断吟唱
---@field ATTR_SPECIAL_NO_STOP_SKILL number @value:151,des:不会被打断技能
---@field ATTR_SPECIAL_NO_STEAL number @value:152,des:不可被偷窃
---@field ATTR_SPECIAL_NO_CHANGE_HATRED_TARGET number @value:153,des:不改变仇恨目标
---@field ATTR_SPECIAL_BREAK_HIDING number @value:154,des:破隐一击
---@field ATTR_SPECIAL_IGNORE_HATRED number @value:155,des:忽略仇恨
---@field ATTR_SPECIAL_CUR_COMBAT_POWER number @value:156,des:当前战力
---@field ATTR_SPECIAL_MAX_COMBAT_POWER number @value:157,des:最大战力
---@field ATTR_SPECIAL_STATE_NO_MOVE number @value:158,des:主动状态导致的不可位移
---@field ATTR_SPECIAL_ATK_ATTR number @value:159,des:攻击属性
---@field ATTR_SPECIAL_DEF_ATTR number @value:160,des:防御属性
---@field ATTR_SPECIAL_SIZE number @value:161,des:体型
---@field ATTR_SPECIAL_RACE number @value:162,des:种族
---@field ATTR_SPECIAL_JOB number @value:163,des:职业
---@field ATTR_SPECIAL_IS_MONSTER number @value:164,des:是否是怪物
---@field ATTR_SPECIAL_AFTER_RESET_HP number @value:165,des:属性计算后重置血量
---@field ATTR_SPECIAL_AFTER_RESET_SP number @value:166,des:属性计算后重置蓝量
---@field ATTR_SPECIAL_ENTITY_TABLE_ID number @value:167,des:EntityTableID
---@field ATTR_SPECIAL_BUFF_WEAPON_ATTACK_ATTR number @value:168,des:buff修改武器攻击属性
---@field ATTR_SPECIAL_FORBID_NATURAL_RECOVERY number @value:169,des:不可自然恢复
---@field ATTR_SPECIAL_DEF_TYPE number @value:170,des:防御属性类型
---@field ATTR_SPECIAL_UNABLE_SELECT number @value:171,des:不可选中属性
---@field ATTR_PERCENT_WIND_SKILL_ATK number @value:172,des:风属性技能攻击万分比
---@field ATTR_PERCENT_EARTH_SKILL_ATK number @value:173,des:地属性技能攻击万分比
---@field ATTR_PERCENT_FIRE_SKILL_ATK number @value:174,des:火属性技能攻击万分比
---@field ATTR_PERCENT_WATER_SKILL_ATK number @value:175,des:水属性技能攻击万分比
---@field ATTR_PERCENT_FORMLESS_SKILL_ATK number @value:176,des:无属性技能攻击万分比
---@field ATTR_PERCENT_HOLY_SKILL_ATK number @value:177,des:圣属性技能攻击万分比
---@field ATTR_PERCENT_DARK_SKILL_ATK number @value:178,des:暗属性技能攻击万分比
---@field ATTR_PERCENT_GHOSS_SKILL_ATK number @value:179,des:念属性技能攻击万分比
---@field ATTR_PERCENT_UNDEAD_SKILL_ATK number @value:180,des:不死属性技能攻击万分比
---@field ATTR_PERCENT_POISON_SKILL_ATK number @value:181,des:毒属性技能攻击万分比
---@field ATTR_PERCENT_WIND_SKILL_DEF number @value:182,des:风属性技能防御万分比
---@field ATTR_PERCENT_EARTH_SKILL_DEF number @value:183,des:地属性技能防御万分比
---@field ATTR_PERCENT_FIRE_SKILL_DEF number @value:184,des:火属性技能防御万分比
---@field ATTR_PERCENT_WATER_SKILL_DEF number @value:185,des:水属性技能防御万分比
---@field ATTR_PERCENT_FORMLESS_SKILL_DEF number @value:186,des:无属性技能防御万分比
---@field ATTR_PERCENT_HOLY_SKILL_DEF number @value:187,des:圣属性技能防御万分比
---@field ATTR_PERCENT_DARK_SKILL_DEF number @value:188,des:暗属性技能防御万分比
---@field ATTR_PERCENT_GHOSS_SKILL_DEF number @value:189,des:念属性技能防御万分比
---@field ATTR_PERCENT_UNDEAD_SKILL_DEF number @value:190,des:不死属性技能防御万分比
---@field ATTR_PERCENT_POISON_SKILL_DEF number @value:191,des:毒属性技能防御万分比
---@field ATTR_PERCENT_WIND_NPC_DAM number @value:192,des:对风属性魔物攻击万分比
---@field ATTR_PERCENT_EARTH_NPC_DAM number @value:193,des:对地属性魔物攻击万分比
---@field ATTR_PERCENT_FIRE_NPC_DAM number @value:194,des:对火属性魔物攻击万分比
---@field ATTR_PERCENT_WATER_NPC_DAM number @value:195,des:对水属性魔物攻击万分比
---@field ATTR_PERCENT_FORMLESS_NPC_DAM number @value:196,des:对无属性魔物攻击万分比
---@field ATTR_PERCENT_HOLY_NPC_DAM number @value:197,des:对圣属性魔物攻击万分比
---@field ATTR_PERCENT_DARK_NPC_DAM number @value:198,des:对暗属性魔物攻击万分比
---@field ATTR_PERCENT_GHOSS_NPC_DAM number @value:199,des:对念属性魔物攻击万分比
---@field ATTR_PERCENT_UNDEAD_NPC_DAM number @value:200,des:对不死属性魔物攻击万分比
---@field ATTR_PERCENT_POISON_NPC_DAM number @value:201,des:对毒属性魔物攻击万分比
---@field ATTR_PERCENT_BRUTE_DAM number @value:202,des:对动物种族增伤万分比
---@field ATTR_PERCENT_DEMI_HUMAN_DAM number @value:203,des:对人形种族增伤万分比
---@field ATTR_PERCENT_DEMON_DAM number @value:204,des:对恶魔种族增伤万分比
---@field ATTR_PERCENT_PLANT_DAM number @value:205,des:对植物种族增伤万分比
---@field ATTR_PERCENT_UNDEAD_DAM number @value:206,des:对不死种族增伤万分比
---@field ATTR_PERCENT_FORMLESS_DAM number @value:207,des:对无形种族增伤万分比
---@field ATTR_PERCENT_FISH_DAM number @value:208,des:对鱼贝种族增伤万分比
---@field ATTR_PERCENT_ANGEL_DAM number @value:209,des:对天使种族增伤万分比
---@field ATTR_PERCENT_INSECT_DAM number @value:210,des:对昆虫种族增伤万分比
---@field ATTR_PERCENT_DRAGON_DAM number @value:211,des:对龙族种族增伤万分比
---@field ATTR_PERCENT_BRUTE_RES number @value:212,des:受到动物种族减伤万分比
---@field ATTR_PERCENT_DEMI_HUMAN_RES number @value:213,des:受到人形种族减伤万分比
---@field ATTR_PERCENT_DEMON_RES number @value:214,des:受到恶魔种族减伤万分比
---@field ATTR_PERCENT_PLANT_RES number @value:215,des:受到植物种族减伤万分比
---@field ATTR_PERCENT_UNDEAD_RES number @value:216,des:受到不死种族减伤万分比
---@field ATTR_PERCENT_FORMLESS_RES number @value:217,des:受到无形种族减伤万分比
---@field ATTR_PERCENT_FISH_RES number @value:218,des:受到鱼贝种族减伤万分比
---@field ATTR_PERCENT_ANGEL_RES number @value:219,des:受到天使种族减伤万分比
---@field ATTR_PERCENT_INSECT_RES number @value:220,des:受到昆虫种族减伤万分比
---@field ATTR_PERCENT_DRAGON_RES number @value:221,des:受到龙族种族减伤万分比
---@field ATTR_PERCENT_SMALL_DAM number @value:222,des:对小体型魔物增伤万分比
---@field ATTR_PERCENT_MID_DAM number @value:223,des:对中体型魔物增伤万分比
---@field ATTR_PERCENT_BIG_DAM number @value:224,des:对大体型魔物增伤万分比
---@field ATTR_PERCENT_BOSS_DAM number @value:225,des:对BOSS魔物增伤万分比
---@field ATTR_PERCENT_MONSTER_DAM number @value:226,des:对非boss魔物增伤万分比
---@field ATTR_PERCENT_PLAYER_DAM number @value:227,des:对玩家增伤万分比
---@field ATTR_PERCENT_TRAP_DAM number @value:228,des:陷阱类技能伤害增加万分比
---@field ATTR_PERCENT_SMALL_RES number @value:229,des:受到小体型魔物减伤万分比
---@field ATTR_PERCENT_MID_RES number @value:230,des:受到中体型魔物减伤万分比
---@field ATTR_PERCENT_BIG_RES number @value:231,des:受到大体型魔物减伤万分比
---@field ATTR_PERCENT_BOSS_RES number @value:232,des:受到boss魔物减伤万分比
---@field ATTR_PERCENT_MONSTER_RES number @value:233,des:对非boss魔物减伤万分比
---@field ATTR_PERCENT_PLAYER_RES number @value:234,des:对玩家减伤万分比
---@field ATTR_PERCENT_TRAP_RES number @value:235,des:受到陷阱类技能伤害减少万分比
---@field ATTR_PERCENT_HATRED number @value:236,des:仇恨修正系数万分比
---@field ATTR_EQUIP_MAIN_WEAPON number @value:237,des:主武器
---@field ATTR_EQUIP_SECONDRY_WEAPON number @value:238,des:副武器
---@field ATTR_EQUIP_HEAD_GEAR number @value:239,des:头饰
---@field ATTR_EQUIP_FACE_GEAR number @value:240,des:脸饰
---@field ATTR_EQUIP_MOUTH_GEAR number @value:241,des:嘴饰
---@field ATTR_EQUIP_CLOAK number @value:242,des:衣服
---@field ATTR_EQUIP_ARMOR number @value:243,des:
---@field ATTR_EQUIP_BOOTS number @value:244,des:
---@field ATTR_EQUIP_ORNAMENT1 number @value:245,des:
---@field ATTR_EQUIP_ORNAMENT2 number @value:246,des:
---@field ATTR_EQUIP_BACK_GEAR number @value:247,des:背饰
---@field ATTR_EQUIP_HORSE number @value:248,des:坐骑
---@field ATTR_SPECIAL_REMOTE_PHYSICAL_DAMAGE_RATE number @value:249,des:远程物理伤害加成
---@field ATTR_SPECIAL_ITEM_RECOVER_RATE number @value:250,des:道具恢复加成
---@field ATTR_SPECIAL_PHYSICAL_DAMAGE_REBOUND_RATE number @value:251,des:物理伤害反弹比例
---@field ATTR_SPECIAL_MAGIC_DAMAGE_REBOUND_RATE number @value:252,des:魔法伤害反弹比例
---@field ATTR_BASIC_SINGLE_SINGING_TIME_CHANGE number @value:253,des:单体技能吟唱时间
---@field ATTR_PERCENT_SINGLE_SINGING_TIME_CHANGE number @value:254,des:单体技能吟唱时间万分比
---@field ATTR_SPECIAL_DAMAGE_RATE number @value:255,des:受到的伤害增加s%
---@field ATTR_SPECIAL_REMOTE_PHYSICAL_DAMAGE_RELIEF number @value:256,des:远程物理伤害减免
---@field ATTR_SPECIAL_POISON_ANTIBODY_RATE number @value:257,des:毒异常状态抗性
---@field ATTR_SPECIAL_BLOOD_ANTIBODY_RATE number @value:258,des:
---@field ATTR_SPECIAL_BURN_ANTIBODY_RATE number @value:259,des:
---@field ATTR_SPECIAL_CURSE_ANTIBODY_RATE number @value:260,des:
---@field ATTR_SPECIAL_DARK_ANTIBODY_RATE number @value:261,des:
---@field ATTR_SPECIAL_SILENT_ANTIBODY_RATE number @value:262,des:
---@field ATTR_SPECIAL_FEAR_ANTIBODY_RATE number @value:263,des:
---@field ATTR_SPECIAL_STUN_ANTIBODY_RATE number @value:264,des:
---@field ATTR_SPECIAL_SLEEP_ANTIBODY_RATE number @value:265,des:
---@field ATTR_SPECIAL_FROZEN_ANTIBODY_RATE number @value:266,des:
---@field ATTR_SPECIAL_FOSSILIZE_ANTIBODY_RATE number @value:267,des:
---@field ATTR_SPECIAL_PARALYTIC_ANTIBODY_RATE number @value:268,des:
---@field ATTR_SPECIAL_DIZZY_ANTIBODY_RATE number @value:269,des:眩晕异常状态抗性
---@field ATTR_SPECIAL_POISON_SUCC_RATE number @value:270,des:毒异常状态成功率
---@field ATTR_SPECIAL_BLOOD_SUCC_RATE number @value:271,des:
---@field ATTR_SPECIAL_BURN_SUCC_RATE number @value:272,des:
---@field ATTR_SPECIAL_CURSE_SUCC_RATE number @value:273,des:
---@field ATTR_SPECIAL_DARK_SUCC_RATE number @value:274,des:
---@field ATTR_SPECIAL_SILENT_SUCC_RATE number @value:275,des:
---@field ATTR_SPECIAL_FEAR_SUCC_RATE number @value:276,des:
---@field ATTR_SPECIAL_STUN_SUCC_RATE number @value:277,des:
---@field ATTR_SPECIAL_SLEEP_SUCC_RATE number @value:278,des:
---@field ATTR_SPECIAL_FROZEN_SUCC_RATE number @value:279,des:
---@field ATTR_SPECIAL_FOSSILIZE_SUCC_RATE number @value:280,des:
---@field ATTR_SPECIAL_PARALYTIC_SUCC_RATE number @value:281,des:
---@field ATTR_SPECIAL_DIZZY_SUCC_RATE number @value:282,des:眩晕异常状态成功率
---@field ATTR_PERCENT_SKILL_ATK number @value:283,des:技能物理攻击万分比
---@field ATTR_BASIC_BRUTE_DAM number @value:284,des:对动物种族增伤
---@field ATTR_BASIC_DEMI_HUMAN_DAM number @value:285,des:对人族增伤
---@field ATTR_BASIC_DEMON_DAM number @value:286,des:对恶魔增伤
---@field ATTR_BASIC_PLANT_DAM number @value:287,des:对植物增伤
---@field ATTR_BASIC_UNDEAD_DAM number @value:288,des:对不死增伤
---@field ATTR_BASIC_FORMLESS_DAM number @value:289,des:对无形增伤
---@field ATTR_BASIC_FISH_DAM number @value:290,des:对鱼贝增伤
---@field ATTR_BASIC_ANGEL_DAM number @value:291,des:对天使增伤
---@field ATTR_BASIC_INSECT_DAM number @value:292,des:对昆虫增伤
---@field ATTR_BASIC_DRAGON_DAM number @value:293,des:对龙族增伤
---@field ATTR_PERCENT_STR_EQUIP number @value:294,des:力量加成万分比
---@field ATTR_PERCENT_INT_EQUIP number @value:295,des:智力加成万分比
---@field ATTR_PERCENT_AGI_EQUIP number @value:296,des:敏捷加成万分比
---@field ATTR_PERCENT_DEX_EQUIP number @value:297,des:灵巧加成万分比
---@field ATTR_PERCENT_VIT_EQUIP number @value:298,des:体质加成万分比
---@field ATTR_PERCENT_LUK_EQUIP number @value:299,des:幸运加成万分比
---@field ATTR_SPECIAL_NO_ACTIVE_SKILL number @value:300,des:目标的被动技能仍然生效
---@field ATTR_PERCENT_CT_FIXED_FINAL number @value:301,des:总固定吟唱
---@field ATTR_PERCENT_CT_CHANGE_FINAL number @value:302,des:总可变吟唱
---@field ATTR_SPECIAL_SINGING_INTERRUPT number @value:303,des:能不能打断施法
---@field ATTR_SPECIAL_BATTLE_VEHICLE_SPD number @value:304,des:战斗坐骑速度
---@field ATTR_SPECIAL_WITH_ARROW_ELEMENT number @value:305,des:
---@field ATTR_SPECIAL_WITHOUT_ARROW_ELEMENT number @value:306,des:
---@field ATTR_SPECIAL_CHAT_ROOM number @value:307,des:是否在聊天室
---@field ATTR_SPECIAL_WIGHT_CART_FINAL number @value:308,des:手推车负重
---@field ATTR_SPECIAL_IMMUNE_OTHERS_BUFF number @value:309,des:免疫所有其他人的上buff
---@field ATTR_SPECIAL_PHYSICAL_DAMAGE_RATE number @value:310,des:近战物理攻击
---@field ATTR_SPECIAL_PHYSICAL_DAMAGE_RELIEF number @value:311,des:近战物理减伤
---@field ATTR_BASIC_WEAPONEX_ATK number @value:312,des:武器物理攻击
---@field ATTR_BASIC_WEAPONEX_MATK number @value:313,des:武器魔法攻击
---@field ATTR_SPECIAL_DANCE number @value:314,des:跳舞属性
---@field ATTR_SPECIAL_DANCE_SPEED number @value:315,des:跳舞速度
---@field ATTR_BASIC_SHIELD_DEF number @value:316,des:盾牌防御
---@field ATTR_BASIC_SHIELD_DEF_IGNORE number @value:317,des:盾牌破甲防御 
---@field ATTR_BASIC_MEDEL_ATK number @value:318,des:
---@field ATTR_PERCENT_MEDEL_ATK number @value:319,des:
---@field ATTR_BASIC_MEDEL_MATK number @value:320,des:
---@field ATTR_PERCENT_MEDEL_MATK number @value:321,des:
---@field ATTR_BASIC_MEDEL_HP number @value:322,des:
---@field ATTR_PERCENT_MEDEL_HP number @value:323,des:
---@field ATTR_BASIC_MEDEL_SP number @value:324,des:
---@field ATTR_PERCENT_MEDEL_SP number @value:325,des:
---@field ATTR_SPECIAL_EAGLE number @value:326,des:是否有猎鹰
---@field ATTR_NEED_CALC_COMBAT_POWER number @value:327,des:是否需要计算战力
---@field ATTR_PERCENT_WEAPONEX_ATK number @value:328,des:武器物理攻击
---@field ATTR_PERCENT_WEAPONEX_MATK number @value:329,des:武器魔法攻击
---@field ATTR_SPECIAL_NO_SCENE_INTERACTION number @value:330,des:与场景物件交互互斥
---@field ATTR_SPECIAL_HPBAN number @value:331,des:HP不可回复  
---@field ATTR_SPECIAL_SPBAN number @value:332,des:SP不可回复
---@field ATTR_SPECIAL_NO_EQUIP_MODIFY number @value:333,des:不可替换装备属性
---@field ATTR_SPECIAL_INDESTRUCT_MWEAPON number @value:334,des:主武器不可破坏
---@field ATTR_SPECIAL_INDESTRUCT_SWEAPON number @value:335,des:副武器不可破坏
---@field ATTR_SPECIAL_INDESTRUCT_BODY number @value:336,des:铠甲不可破坏
---@field ATTR_SPECIAL_INDESTRUCT_BACK number @value:337,des:披肩不可破坏
---@field ATTR_SPECIAL_INDESTRUCT_SHOE number @value:338,des:鞋子不可破坏
---@field ATTR_TOTAL_REFINE number @value:339,des:总精炼物攻
---@field ATTR_TOTAL_MREFINE number @value:340,des:总精炼魔攻
---@field ATTR_SPECIAL_CAN_NOT_CHANGE_FIGHT_STATE number @value:341,des:不能切换战斗状态
---@field ATTR_BASIC_MERCENARY_ATK number @value:342,des:佣兵物理攻击
---@field ATTR_BASIC_MERCENARY_MATK number @value:343,des:佣兵魔法攻击
---@field ATTR_BASIC_MERCENARY_HP number @value:344,des:佣兵生命上限
---@field ATTR_SPECIAL_HATRED_NUM number @value:345,des:仇恨倍率
---@field ATTR_BASIC_ADDITIONAL_ATK_DAM number @value:346,des:物理追加伤害
---@field ATTR_BASIC_ADDITIONAL_MATK_DAM number @value:347,des:魔法追加伤害
---@field ATTR_BASIC_RESOURCE number @value:348,des:战斗资源
---@field ATTR_PERCENT_RESOURCE number @value:349,des:
---@field ATTR_BASIC_MAX_RESOURCE number @value:350,des:战斗资源最大值
---@field ATTR_PERCENT_MAX_RESOURCE number @value:351,des:
---@field ATTR_BASIC_MAX_RESOURCE_FINAL number @value:352,des:
---@field ATTR_MAX_COUNT number @value:353,des:最大值
AttrType = {}

---@class FashionTheme
---@field kFashionThemeNone number @value:0,des:不用
---@field kFashionThemeKingStyle number @value:1,des:王者风范
---@field kFashionThemeSpringSunshine number @value:2,des:春日阳光
---@field kFashionThemeDarkField number @value:3,des:黑暗领域
---@field kFashionThemeBrightSky number @value:4,des:璀璨星空
---@field kFashionThemeGentlemanManner number @value:5,des:绅士风度
FashionTheme = {}

---@class AutoBattleModel
---@field kAutoBattleModelNone number @value:0,des:
---@field kAutoBattleCustom number @value:1,des:自定义
---@field kAutoBattleModelHalf number @value:2,des:半屏
---@field kAutoBattleModelAllSceen number @value:3,des:全屏
---@field kAutoBattleModelAllMap number @value:4,des:全地图
AutoBattleModel = {}

---@class WatchUnitType
---@field kWatchUnitTypeNone number @value:0,des:
---@field kWatchUnitTypePVE number @value:1,des:
---@field kWatchUnitTypePVPLight number @value:2,des:
---@field WatchUnitTypePVPHeavy number @value:3,des:
WatchUnitType = {}

---@class ServantType
---@field kServantTypeNone number @value:0,des:
---@field kServantTypeSwordman number @value:1,des:剑士英灵
---@field kServantTypeAcolyte number @value:2,des:牧师英灵
---@field kServantTypeMagician number @value:3,des:法师英灵
ServantType = {}

---@class LeaderBoardType
---@field kLeaderBoardTypeNone number @value:0,des:
---@field kLeaderBoardTypePerson number @value:1,des:个人榜
---@field kLeaderBoardTypeTeam number @value:2,des:团队榜
---@field kLeaderBoardTypeGuild number @value:3,des:公会榜
LeaderBoardType = {}

---@class EItemExtraDataKey
---@field None number @value:0,des:默认值
---@field IEDK_EnchantEquipPos number @value:1,des:附魔部位，封魔石专用
---@field IEDK_EnchantLv number @value:2,des:附魔等级，封魔石专用
---@field IEDK_EnchantExtracted number @value:3,des:附魔是否被提炼过
---@field IEDK_EnchantTimesTotal number @value:4,des:高级附魔和低级附魔的次数总和
---@field IEDK_DeviceDuration number @value:5,des:置换器耐久度
---@field IEDK_RefineLv number @value:6,des:精炼等级
---@field IEDK_RefineSealLv number @value:7,des:精炼封印等级
---@field IEDK_RefineUnlockExp number @value:8,des:精炼解封经验
---@field IEDK_GuildRedPacketValue number @value:9,des:工会狩猎用的红包数据
---@field IEDK_ReformLv number @value:10,des:改造档次
---@field IEDK_DAY_COUNT number @value:11,des:每日使用次数[会员卡]
---@field IEDK_TOTAL_COUNT number @value:12,des:总使用次数[会员卡]
---@field IEDK_LAST_FRESH_TIME number @value:13,des:上次刷新每日计数的时间戳[会员卡]
---@field IEDK_ReforgTimes number @value:14,des:装备重铸次数
---@field IEDK_WheelWeight number @value:15,des:贝鲁兹齿轮负重
---@field IEDK_WheelAttrTableId number @value:16,des:齿轮随机WheelAttrTableId
---@field IEDK_SpecialItemProgress number @value:17,des:特殊道具的进度值
---@field IEDK_Child_ItemID number @value:18,des:道具子ID
EItemExtraDataKey = {}

---@class EItemDataBitType
---@field IsBind number @value:0,des:是否是绑定
---@field IsDamaged number @value:1,des:是否已经损坏
---@field EnchantExtracted number @value:2,des:是否被附魔提炼过
---@field ItemFormStall number @value:3,des:是不是商会买来的商品
---@field ItemFromAuction number @value:4,des:是不是拍卖来的商品
---@field ItemLifeEndSurvival number @value:5,des:到期后是否保留
---@field ItemActive number @value:6,des:是否激活 0代表不激活，1代表激活
EItemDataBitType = {}

---@class EItemAttrModuleSvrType
---@field Attr_None number @value:0,des:
---@field Attr_Enchant number @value:1,des:附魔属性
---@field Attr_EnchantCache number @value:2,des:普通附魔的缓存属性
---@field Attr_EnchantCacheHigh number @value:3,des:高级附魔的缓存属性
---@field Attr_Device number @value:4,des:置换器属性
---@field Attr_Base number @value:5,des:基础属性
---@field Attr_School number @value:6,des:流派属性
---@field Attr_Hole_1 number @value:7,des:第一个洞的属性
---@field Attr_Hole_2 number @value:8,des:第二个洞的属性
---@field Attr_Hole_3 number @value:9,des:第三个洞的属性
---@field Attr_HoleCache_1 number @value:10,des:第一个洞的重铸属性
---@field Attr_HoleCache_2 number @value:11,des:第二个洞的重铸属性
---@field Attr_HoleCache_3 number @value:12,des:第三个洞的重铸属性
---@field Attr_Refine number @value:13,des:精炼：0精炼等级，1封印等级
---@field Attr_LibAttr number @value:14,des:库词条
---@field Attr_Hidden_info number @value:15,des:隐藏信息
---@field Attr_Belluz number @value:16,des:贝鲁兹
---@field Attr_Enchantstone number @value:17,des:
---@field Attr_EnchantParam number @value:18,des:附魔其他属性
---@field Attr_EnchantCost number @value:19,des:附魔历史消耗
---@field Attr_GiftCardCD number @value:20,des:会员卡[礼品卡]CD
---@field Attr_tlog number @value:21,des:tlog记录数据
---@field Attr_Belluz_Cache number @value:22,des:贝鲁兹重置缓存
---@field Attr_School_2 number @value:23,des:流派属性2
EItemAttrModuleSvrType = {}

---@class LeaderBoardRequestType
---@field LeaderBoardRequestTypeNone number @value:0,des:
---@field LeaderBoardRequestTypeGuildRoyal number @value:1,des:公会荣誉本公会排名
LeaderBoardRequestType = {}

---@class AskGsUseItemType
---@field AskGsUseItemNone number @value:0,des:
---@field AskGsUseItemType_MagicPaper number @value:1,des:发送魔法信笺扣除
AskGsUseItemType = {}

---@class EnvelopeType
---@field EnvelopeTypeNone number @value:0,des:
---@field EnvelopeTypeSuperGift number @value:1,des:超级礼包
---@field EnvelopeTypeFirstOne number @value:2,des:第一个抢到的包
---@field EnvelopeTypeBigEvenlope number @value:4,des:大红包
---@field EnvelopeTypeFirstItem number @value:8,des:第一个抢到道具的包
EnvelopeType = {}

---@class PayParamIntKey
---@field PayParamIntKeyNone number @value:0,des:
---@field PayParamIntKeyMallId number @value:1,des:卖场的mallid
---@field PayParamIntKeyMallSeqId number @value:2,des:卖场购买的seqid
---@field PayParamIntKeyMallNumber number @value:3,des:卖场购买数量
---@field PayParamIntKeySpecialSupplyStage number @value:4,des:绵绵岛超前定制骰子的 阶段
---@field PayParamIntKeySpecialSupplyDiceValue number @value:5,des:绵绵岛超前定制 骰子的值
---@field PayParamIntKeySpecialSupplyRediceCount number @value:6,des:重骰的次数
---@field PayParamIntKeySpecialSupplyCanDice number @value:7,des:当前的情况是否可以重骰
---@field PayParamIntKeySpecialSupplyRediceValue number @value:8,des:重骰的骰子点数
---@field PayParamIntKeyGuildCrystalEnergyType number @value:9,des:公会水晶充能类型
---@field PayParamIntKeyGuildlId number @value:10,des:公会id
---@field PayParamIntKeyBinGoPos number @value:11,des:bingo_pos
---@field PayParamIntKeyLevelGiftID number @value:12,des:等级奖励ID
---@field PayParamIntKeyLevelGiftType number @value:13,des:等级奖励类型
---@field PayParamIntKeyCommonAwardMajorId number @value:14,des:majorid
---@field PayParamIntKeyCommonAwardTimes number @value:15,des:奖励次数
---@field PayParamIntKeyCommonAwardType number @value:16,des:奖励类型
---@field PayParamIntKeyAwardActId number @value:17,des:奖励活动id
---@field PayParamIntKeyBuyGiftPack number @value:18,des:卡普拉贵宾卡礼包
---@field PayParamIntKeyExchangeMoneyType number @value:19,des:货币兑换类型
PayParamIntKey = {}

---@class ExchangeMoneyType
---@field ExchangeMoneyTypeDefault number @value:0,des:默认直接兑换
---@field ExchangeMoneyTypeShortcut number @value:1,des:快捷兑换
ExchangeMoneyType = {}

---@class GuildRankScoreType
---@field GuildRankScoreTypeNone number @value:0,des:
---@field GuildRankScoreTypeTotal number @value:1,des:总积分
---@field GuildRankScoreTypeMatch number @value:2,des:公会匹配赛
---@field GuildRankScoreTypeHunter number @value:3,des:公会狩猎战
---@field GuildRankScoreTypeDinner number @value:4,des:公会宴会
GuildRankScoreType = {}

---@class GuildRoyalType
---@field GuildRoyalTypeNone number @value:0,des:
---@field GuildRoyalTypeFirst number @value:1,des:精英组
---@field GuildRoyalTypeSecond number @value:2,des:荣誉组
GuildRoyalType = {}

---@class TaskStatus
---@field kTaskStatusAccepting number @value:0,des:待接、可接
---@field kTaskStatusAccepted number @value:1,des:已接取、可交付
---@field kTaskStatusAbandoned number @value:2,des:放弃
---@field kTaskStatusFinished number @value:3,des:完成
---@field kTaskStatusFailed number @value:4,des:失败
---@field kTaskStatusCanFinish number @value:5,des:
---@field kTaskStatusNotTask number @value:6,des:
---@field kTaskStatusDestroyed number @value:7,des:销毁
TaskStatus = {}

---@class TaskType
---@field kTaskTypeNone number @value:0,des:
---@field kTaskTypeMainStory number @value:1,des:
---@field kTaskTypeBranch number @value:2,des:
---@field kTaskTypeProfession number @value:3,des:
---@field kTaskTypeDaily number @value:4,des:
---@field kTaskTypeWeekly number @value:5,des:
---@field kTaskTypeGuide number @value:6,des:
---@field kTaskTypeSurprise number @value:7,des:
---@field kTaskTypeGuild number @value:8,des:
---@field kTaskTypeEden number @value:9,des:伊甸园任务
---@field kTaskTypeAishen number @value:10,des:爱神任务
---@field kTaskTypeEdenUrgent number @value:11,des:伊甸园特殊任务,加急
---@field kTaskTypeAdventure number @value:12,des:冒险任务
---@field kTaskTypeDungeon number @value:13,des:副本任务
---@field kTaskTypeLife number @value:14,des:生活支线任务
---@field kTaskTypeWorldPve number @value:15,des:世界pve
---@field kTaskTypePostcard number @value:16,des:萌新任务
---@field kTaskTypeDelegate number @value:17,des:日常委托任务
---@field kTaskTypeFake number @value:18,des:前端假任务服务器不用管
---@field kTaskTypeExplore number @value:19,des:探索任务
---@field kTaskTypeMercenary number @value:20,des:佣兵
---@field kTaskTypeChallenge number @value:21,des:挑战任务
---@field kTaskTypeActivity number @value:22,des:活动任务
---@field kTaskTypeMedal number @value:23,des:勋章
---@field kTaskTypeActivityGuide number @value:24,des:活动引导任务
---@field kTaskTypeRecruit number @value:25,des:征召
TaskType = {}

---@class TaskLimitIdentity
---@field kTaskLimitIdentityNone number @value:0,des:
---@field kTaskLimitIdentityTeamLeader number @value:1,des:
---@field kTaskLimitIdentityLoverTeamLeader number @value:2,des:异性组队队长
TaskLimitIdentity = {}

---@class TaskSubChoose
---@field kTaskSubChooseNone number @value:0,des:
---@field kTaskSubChooseRandom number @value:1,des:子任务中随机选取一个
---@field kTaskSubChooseSequence number @value:2,des:子任务顺序执行
---@field kTaskSubChoosePlayer number @value:3,des:玩家自己选择一个
---@field kTaskSubChooseEden number @value:4,des:乐园团任务随机类型
---@field kTaskSubRandomSeq number @value:5,des:随机依次N个
TaskSubChoose = {}

---@class TaskTargetType
---@field kTaskTargetTypeNone number @value:0,des:
---@field kTaskTargetTypeTalk number @value:1,des:
---@field kTaskTargetTypeMonster number @value:2,des:
---@field kTaskTargetTypeCollection number @value:3,des:
---@field kTaskTargetTypeGather number @value:4,des:
---@field kTaskTargetTypeFindPath number @value:5,des:
---@field kTaskTargetTypeUseItem number @value:6,des:
---@field kTaskTargetTypeFinishDungeon number @value:7,des:
---@field kTaskTargetTypeOperation number @value:8,des:
---@field kTaskTargetTypePhoto number @value:9,des:
---@field kTaskTargetTypeActive number @value:10,des:
---@field kTaskTargetTypeAchieve number @value:11,des:
---@field kTaskTargetTypeGuaid number @value:12,des:
---@field kTaskTargetTypeSocial number @value:13,des:
---@field kTaskTargetTypeScript number @value:14,des:
---@field kTaskTargetTypeMonsterDrop number @value:15,des:
---@field kTaskTargetTypeSub number @value:16,des:依赖子任务
---@field kTaskTargetTypeEnterDungeon number @value:17,des:进入副本
---@field kTaskTargetTypeFinishCooking number @value:18,des:完成单人烹饪
---@field kTaskTargetTypeFinishCookingDungeon number @value:19,des:通关双人烹饪副本
---@field kTaskTargetTypePublicVehicle number @value:20,des:搭乘公共载具
---@field kTaskTargetTypeSceneObject number @value:21,des:场景交互
---@field kTaskTargetTypePublicVehicleSingle number @value:22,des:单人载具
---@field kTaskTargetTypeDoubleAction number @value:23,des:双人交互
---@field kTaskTargetTypeSkillRelease number @value:24,des:释放指定技能N次
---@field kTaskTargetTypePlayTimeLine number @value:25,des:播放timeline动画
---@field kTaskTargetTypeSkillLevel number @value:26,des:技能等级
---@field kTaskTargetTypeFakeUseItem number @value:27,des:使用假物品
---@field kTaskTypeInsideStory number @value:28,des:黑幕效果前端展示
---@field kTaskTargetTypeItemDynamicRecycle number @value:29,des:动态道具回收目标类型
---@field kTaskTargetTypeSpMonster number @value:30,des:属性怪
---@field kTaskTargetTypeDynamicPhoto number @value:31,des:动态拍照
---@field kTaskTargetTypeQte number @value:32,des:QTE目标
---@field kTaskTargetTypeConvoy number @value:33,des:护送
---@field kTaskTargetTypeCarry number @value:34,des:搬运
---@field kTaskTargetTypeFake number @value:35,des:假任务目标,后端不处理
---@field kTaskTargetTypeCollectCategory number @value:36,des:采集某一类型采集物
---@field kTaskTargetTypeDelayCD number @value:37,des:等待N秒任务目标完成
---@field kTaskTargetTypeNpcAction number @value:38,des:与NPC指定交互
---@field kTaskTargetTypeAction number @value:39,des:玩家上报指定动作
---@field kTaskTargetTypeCyc number @value:40,des:该任务为环任务
---@field kTaskTargetTypeSpTalk number @value:41,des:对话前收集后扣除
---@field kTaskTargetTypeDance number @value:42,des:泡点
---@field kTaskTargetTypeSurvey number @value:43,des:勘测
---@field kTaskTargetTypeGameplay number @value:44,des:玩法
TaskTargetType = {}

---@class TaskTriggerEvent
---@field kTaskTriggerEventNone number @value:0,des:
---@field kTaskTriggerEventEnterMirrorDungeon number @value:1,des:服务器进入镜像副本
---@field kTaskTriggerEventLeaveMirrorDungeon number @value:2,des:服务器退出镜像副本
---@field kTaskTriggerEventAddNpc number @value:3,des:刷出npc
---@field kTaskTriggerEventRemoveNpc number @value:4,des:删除npc
---@field kTaskTriggerEventHideNpc number @value:5,des:隐藏公共npc
---@field kTaskTriggerEventShowNpc number @value:6,des:恢复显示公共npc
---@field kTaskTriggerEventAddMonster number @value:7,des:刷出怪物
---@field kTaskTriggerEventRemoveMonster number @value:8,des:删除之前刷出的怪物
---@field kTaskTriggerEventTimeline number @value:9,des:播放过场动画
---@field kTaskTriggerEventAddBuff number @value:10,des:给玩家上buff
---@field kTaskTriggerEventAddCollection number @value:11,des:刷出采集物
---@field kTaskTriggerEventRemoveCollection number @value:12,des:删除采集物
---@field kTaskTriggerEventPlayCamera number @value:13,des:调用镜头
---@field kTaskTriggerEventCall number @value:14,des:喊话
---@field kTaskTriggerEventPlaySceneScript number @value:15,des:调用剧情脚本
---@field kTaskTriggerEventBlackScreen number @value:16,des:调用黑幕
---@field kTaskTriggerEventEnterDungeon number @value:17,des:传入普通副本
---@field kTaskTriggerEventChangeScene number @value:18,des:跳转到其他场景
---@field kTaskTriggerEventOpenSystem number @value:19,des:打开系统
---@field kTaskTriggerEventActiveSceneTrigger number @value:20,des:激发场景触发器
---@field kTaskTriggerEventDeActiveSceneTrigger number @value:21,des:关闭场景触发器
---@field kTaskTriggerEventActiveUI number @value:22,des:掉起UI
---@field kTaskTriggerEventDelBuff number @value:23,des:删除buff
---@field kTaskTriggerEventAddEffects number @value:24,des:指定位置加特效
---@field kTaskTriggerEventDelEffects number @value:25,des:删除特效
---@field kTaskTriggerEventPlayAction number @value:26,des:npc/玩家播放动作
---@field kTaskTriggerEvenAudio number @value:27,des:播放音效
TaskTriggerEvent = {}

---@class TaskTriggerAction
---@field kTaskTriggerActionClose number @value:0,des:关闭触发器事件
---@field kTaskTriggerActionOpen number @value:1,des:打开触发器事件
---@field kTaskTriggerActionActive number @value:2,des:只触发一次, 立即通知
TaskTriggerAction = {}

---@class TaskAcceptType
---@field kTaskAcceptTypeNone number @value:0,des:
---@field kTaskAcceptTypeDialog number @value:1,des:通常通过npc对话接取
---@field kTaskAcceptTypeAuto number @value:2,des:自动接取
---@field kTaskAcceptTypePanel number @value:3,des:面板接取
---@field kTaskAcceptTypeRemote number @value:4,des:飞鸽传书
TaskAcceptType = {}

---@class TaskTriggerTime
---@field kTaskTriggerNone number @value:0,des:
---@field kTaskTriggerAccept number @value:1,des:接取成功时触发
---@field kTaskTriggerCanFinish number @value:2,des:完成任务的时候触发,还未交付
---@field kTaskTriggerFinished number @value:3,des:交付任务的时候触发
---@field kTaskTriggerTarget number @value:4,des:完成具体任务目标时触发
---@field kTaskTriggerCanTake number @value:5,des:满足任务接取条件就触发
TaskTriggerTime = {}

---@class CaptainChangeType
---@field CHANGE_CAPTAIN_TYPE_NONE number @value:0,des:
---@field CHANGE_CAPTAIN_TYPE_HANDOVER number @value:1,des:移交队长
---@field CHANGE_CAPTAIN_TYPE_OFFLINE number @value:2,des:离线转让
---@field CHANGE_CAPTAIN_TYPE_APPLY number @value:3,des:申请队长时转让
---@field CHANGE_CAPTAIN_TYPE_LEAVE number @value:4,des:队长离开队伍
CaptainChangeType = {}

---@class KickType
---@field KICK_NORMAL number @value:0,des:
---@field KICK_RELOGIN number @value:1,des:
---@field KICK_GMFORBID number @value:2,des:
---@field KICK_SERVER_SHUTDOWN number @value:3,des:
---@field KICK_DEL_ROLE number @value:4,des:
---@field KICK_CHANGE_PROFESSION number @value:5,des:
KickType = {}

---@class ErrorCode
---@field ERR_SUCCESS number @value:0,des:
---@field ERR_UNKNOWN number @value:1,des:
---@field ERR_PASSWORD_ERROR number @value:2,des:
---@field ERR_RELOGIN number @value:3,des:
---@field ERR_ACCOUNT_NOT_EXIST number @value:4,des:
---@field ERR_NAME_EXIST number @value:5,des:
---@field ERR_INVALID_NAME number @value:6,des:
---@field ERR_STATE_ERROR number @value:7,des:
---@field ERR_PROFESSION_TYPE number @value:8,des:
---@field ERR_FAILED number @value:9,des:
---@field ERR_ACCOUNT_ROLE_FULL number @value:10,des:
---@field ERR_ACCOUNT_DATA_ERROR number @value:11,des:
---@field ERR_TIMEOUT number @value:12,des:
---@field ERR_SKILL_CONFIGERROR number @value:13,des:
---@field ERR_SKILL_LEVELREQ number @value:14,des:
---@field ERR_SKILL_ITEMREQ number @value:15,des:
---@field ERR_ACHIVE_NOTCOMPLETE number @value:16,des:
---@field ERR_ACHIVE_NOTCONFIG number @value:17,des:
---@field ERR_SKILL_POINT number @value:18,des:
---@field ERR_PROF_ERROR number @value:19,des:
---@field ERR_PROF_LEVELREQ number @value:20,des:
---@field ERR_PROF_LEVELREQ2 number @value:21,des:
---@field ERR_BIND_SKILL_OUTRANGE number @value:22,des:
---@field ERR_BIND_SKILL_NOT_LEARN number @value:23,des:
---@field ERR_BIND_SKILL_MISSSLOT number @value:24,des:
---@field ERR_ENHANCE_ERROR number @value:25,des:
---@field ERR_ENHANCE_LACKITEM number @value:26,des:
---@field ERR_ENHANCE_FAILED number @value:27,des:
---@field ERR_ENHANCE_SUCCEED number @value:28,des:
---@field ERR_ENHANCE_MAX number @value:29,des:
---@field ERR_ARENA_ERROR number @value:30,des:
---@field ERR_ARENA_COUNTLIMIT number @value:31,des:
---@field ERR_DECOMPOSE_FAILED number @value:32,des:
---@field ERR_DECOMPOSE_CANNOT number @value:33,des:
---@field ERR_DECOMPOSE_NOTFIND number @value:34,des:
---@field ERR_SCENE_LEVELREQ number @value:35,des:
---@field ERR_SCENE_NOFATIGUE number @value:36,des:
---@field ERR_SCENE_TODYCOUNTLIMIT number @value:37,des:
---@field ERR_SCENE_NEEDPREVCOMPLETE number @value:38,des:
---@field ERR_ITEM_NOTEXIST number @value:39,des:
---@field ERR_ITEM_LEVELLIMIT number @value:40,des:
---@field ERR_ITEM_CANNOTBEEQUIPED number @value:41,des:
---@field ERR_EMBLEM_NOEMPTYSLOT number @value:42,des:
---@field ERR_ITEM_NOT_ENOUGH number @value:43,des:
---@field ERR_EMBLEM_MAXLEVEL number @value:44,des:
---@field ERR_JADE_MAXLEVEL number @value:45,des:
---@field ERR_JADECOMPOSE_NOTFIND number @value:46,des:
---@field ERR_JADEATTACH_NOEMPTYSLOT number @value:47,des:
---@field ERR_JADE_COUNTNOTENOUGH number @value:48,des:
---@field ERR_CHECKIN_FULL number @value:49,des:
---@field ERR_CHECKIN_LACKDRAGONCOIN number @value:50,des:
---@field ERR_ACTIVITY_NOCHESTINDEX number @value:51,des:
---@field ERR_ACTIVITY_HASGETCHEST number @value:52,des:
---@field ERR_ACTIVITY_NOTENOUGHVALUE number @value:53,des:
---@field ERR_ACTIVITY_SPECIALCHESTCOUNTLIMIT number @value:54,des:
---@field ERR_ARENA_ADDCOUNTLACKCOIN number @value:55,des:
---@field ERR_JADE_OPENJADELACKCOIN number @value:56,des:
---@field ERR_JADE_NOEMPTYSLOT number @value:57,des:
---@field ERR_ITEM_NEED_DRAGONCOIN number @value:58,des:
---@field ERR_BUY_LIMIT number @value:59,des:
---@field ERR_SWEEP_NOT_THREE_STAR number @value:60,des:
---@field ERR_SHOP_ITEMNOTEXIST number @value:61,des:
---@field ERR_SHOP_LACKMONEY number @value:62,des:
---@field ERR_TEAM_ALREADY_INTEAM number @value:63,des:
---@field ERR_TEAM_NOT_EXIST number @value:64,des:
---@field ERR_TEAM_FULL number @value:65,des:
---@field ERR_TEAM_WRONG_PASSWORD number @value:66,des:
---@field ERR_SCENE_TIMELIMIT number @value:67,des:
---@field ERR_TEAM_EXPEDITIONID_NOT_EXIST number @value:68,des:
---@field ERR_TEAM_LEVEL_REQUARE number @value:69,des:
---@field ERR_SCENE_COOLDOWN number @value:70,des:
---@field ERR_SKILL_MAXLEVEL number @value:71,des:
---@field ERR_WORLDBOSS_DEAD number @value:72,des:
---@field ERR_REINFORCE_LEVELLIMIT number @value:73,des:
---@field ERR_REINFORCE_LACKMONEY number @value:74,des:
---@field ERR_ARENA_REWARDTAKEN number @value:75,des:
---@field ERR_SKILL_PROFESSION_ERROR number @value:76,des:
---@field ERR_SKILL_NEED_PRESKILL number @value:77,des:
---@field ERR_LOGIN_TIMEOUT number @value:78,des:
---@field ERR_LOGIN_NOSERVER number @value:79,des:
---@field ERR_SHOP_LEVELLIMIT number @value:80,des:
---@field ERR_SHOP_PPTLIMIT number @value:81,des:
---@field ERR_SHOP_COUNTLIMIT number @value:82,des:
---@field ERR_SHOP_DAILYCOUNTLIMIT number @value:83,des:
---@field ERR_CHAT_LEVELLIMIT number @value:84,des:
---@field ERR_CHAT_LENGTHLIMIT number @value:85,des:
---@field ERR_CHAT_TIMELIMIT number @value:86,des:
---@field ERR_FASHOIN_ALREADY_EXIST number @value:87,des:
---@field ERR_FASHION_NOT_EXIST number @value:88,des:
---@field ERR_FRIEND_MAX number @value:89,des:
---@field ERR_FRIEND_REPEATED number @value:90,des:
---@field ERR_FRIEND_NOTEXIST number @value:91,des:
---@field ERR_BLACK_INSELF number @value:92,des:
---@field ERR_BLACK_INOTHER number @value:93,des:
---@field ERR_BLACK_NOTEXIST number @value:94,des:
---@field ERR_LOGIN_VERIFY_FAILED number @value:95,des:
---@field ERR_GUILD_NOT_EXIST number @value:96,des:
---@field ERR_GUILD_NAME_EXIST number @value:97,des:
---@field ERR_GUILD_NOT_IN_GUILD number @value:98,des:
---@field ERR_GUILD_ALREADY_IN_GUILD number @value:99,des:
---@field ERR_GUILD_NO_PERMISSION number @value:100,des:
---@field ERR_CHAPTERCHEST_ALREADY_FETCHED number @value:101,des:
---@field ERR_CHAPTERCHEST_NEEDSTAR number @value:102,des:
---@field ERR_SESSION_KICKOFF number @value:103,des:
---@field ERR_ALIVE_TIMEOUT number @value:104,des:
---@field ERR_GS_CLOSED number @value:105,des:
---@field ERR_FASHIONCOMPOSE_LEVEL_REQ number @value:106,des:
---@field ERR_GUILD_FULL number @value:107,des:
---@field ERR_GUILD_PPT_REQ number @value:108,des:
---@field ERR_GUILD_WAITAPPROVAL number @value:109,des:
---@field ERR_GUILD_MEMBER_NOT_EXIST number @value:110,des:
---@field ERR_FLOWER_SELF number @value:111,des:
---@field ERR_FLOWER_COUNTLIMIT number @value:112,des:
---@field ERR_FLOWER_ROLELIMIT number @value:113,des:
---@field ERR_FLOWER_COSTLIMIT number @value:114,des:
---@field ERR_GUILDCARD_ALLCOUNTLIMIT number @value:115,des:
---@field ERR_GUILDCARD_COUNTLIMIT number @value:116,des:
---@field ERR_GUILDCARD_CHANGELIMIT number @value:117,des:
---@field ERR_GUILDCHECKIN_LIMIT number @value:118,des:
---@field ERR_GUILDCHECKIN_MONEY number @value:119,des:
---@field ERR_GUILDCHECKIN_TAKEN number @value:120,des:
---@field ERR_GUILDCHECKIN_BOXLIMIT number @value:121,des:
---@field ERR_SCENE_NEED_PRESCENE number @value:122,des:
---@field ERR_GUILDBONUS_NOTEXIST number @value:123,des:
---@field ERR_GUILDBONUS_ALREADYGET number @value:124,des:
---@field ERR_GUILDBONUS_EXCEED number @value:125,des:
---@field ERR_GUILD_OPENLIMIT number @value:126,des:
---@field ERR_SHOP_OPENLIMIT number @value:127,des:
---@field ERR_GUILDCHECKIN_ALLCOUNT number @value:128,des:
---@field ERR_TEAM_EXPEDITION_DAYCOUNT number @value:129,des:
---@field ERR_TEAM_GUILD_DAYCOUNT number @value:130,des:
---@field ERR_TEAM_NEST_DAYCOUNT number @value:131,des:
---@field ERR_GUILD_LEVEL_REQ number @value:132,des:
---@field ERR_TEAM_NOT_OPENTIME number @value:133,des:
---@field ERR_TEAM_NEED_ATLEAST_2_MEMBER number @value:134,des:
---@field ERR_TEAM_ONLY_LEADER_CAN_KICK number @value:135,des:
---@field ERR_TEAM_MEMBER_NOT_EXIST number @value:136,des:
---@field ERR_SKILL_GUILD_CONTRIBUTE number @value:137,des:
---@field ERR_REWARD_TAKEN number @value:138,des:
---@field ERR_REWARD_LIMIT number @value:139,des:
---@field ERR_REWARD_NOTEXIST number @value:140,des:
---@field ERR_GUILD_VICE_FULL number @value:141,des:
---@field ERR_GUILD_OFFICER_FULL number @value:142,des:
---@field ERR_GUILD_ELITE_FULL number @value:143,des:
---@field ERR_TEAM_MEMBER_NOT_ONLINE number @value:144,des:
---@field ERR_TEAM_DISAGREE_BATTLE number @value:145,des:
---@field ERR_TEAM_ONLY_LEADER_CAN_STARTBATTLE number @value:146,des:
---@field ERR_TEAM_MATCHING number @value:147,des:
---@field ERR_ROLE_NOT_ONLINE number @value:148,des:
---@field ERR_TEAM_ONLY_LEADER_CAN_DO number @value:149,des:
---@field ERR_LACKCOIN number @value:150,des:
---@field ERR_LACKDIAMOND number @value:151,des:
---@field ERR_SMELTING_INVALID number @value:152,des:
---@field ERR_SMELTING_TRANSINVALID number @value:153,des:
---@field ERR_GUILD_NAME_TOO_SHORT number @value:154,des:
---@field ERR_GUILD_NAME_TOO_LONG number @value:155,des:
---@field ERR_TEAM_NOT_IN_HALL number @value:156,des:
---@field ERR_TEAM_IN_BATTLE number @value:157,des:
---@field ERR_TEAM_VOTE number @value:158,des:
---@field ERR_TEAM_STATE_ERROR number @value:159,des:
---@field ERR_TEAM_INVITE_ROLE_IS_IN_BATTLE number @value:160,des:
---@field ERR_ITEM_COOLDOWN number @value:161,des:
---@field ERR_LOGIN_FORBID number @value:162,des:
---@field ERR_LOGIN_MAXNUM number @value:163,des:
---@field ERR_SCENE_NEED_PRETASK number @value:164,des:进场景需要完成前置任务
---@field ERR_NAME_HAS_INVALID_CHAR number @value:165,des:
---@field ERR_SMELTING_LACKMONEY number @value:166,des:
---@field ERR_OTHER_GAOJIGU_NOTOPEN number @value:167,des:
---@field ERR_FISHING_NUMNOTENOUGH number @value:168,des:
---@field ERR_FISHING_ALREADYSEAT number @value:169,des:
---@field ERR_FISHING_SEATNOTEMPTY number @value:170,des:
---@field ERR_SLOTATTR_NOEQUIP number @value:171,des:
---@field ERR_SLOTATTR_MONEYLIMIT number @value:172,des:
---@field ERR_SLOTATTR_LEVELLIMIT number @value:173,des:
---@field ERR_PK_NOMATCH number @value:174,des:
---@field ERR_ITEM_WRONG_PROFESSION number @value:175,des:
---@field ERR_SKILL_NOT_MATCH number @value:176,des:
---@field ERR_TSHOW_LEVEL_NOTENOUGH number @value:177,des:
---@field ERR_TRANSFER_LACKMONEY number @value:178,des:
---@field ERR_AUCT_HAVEBIDDING number @value:179,des:
---@field ERR_AUCT_ITEMOUTSALE number @value:180,des:
---@field ERR_AUCT_PRICECHAGE number @value:181,des:
---@field ERR_AUCT_SURPASSSELF number @value:182,des:
---@field ERR_AUCT_POINTLESS number @value:183,des:
---@field ERR_AUCT_DRAGONCOINLESS number @value:184,des:
---@field ERR_AUCT_BUYSELF number @value:185,des:
---@field ERR_ALREADY_IN_CAMP number @value:186,des:
---@field ERR_NOT_IN_CAMP number @value:187,des:
---@field ERR_AUCT_ONSALEMAX number @value:188,des:
---@field ERR_AUCT_COMMONERR number @value:189,des:
---@field ERR_AUCT_ITEMSALED number @value:190,des:
---@field ERR_SCENE_NOT_IN_CONFIG number @value:191,des:
---@field ERR_GAOJIGU_MODEL_DUPLICATE_FASHIONID number @value:192,des:
---@field ERR_TEAMBUY_COUNT_MAX number @value:193,des:
---@field ERR_TEAMBUY_DIAMOND_LESS number @value:194,des:
---@field ERR_ADDFRIEND_DUMMYROLE number @value:195,des:
---@field ERR_VERSION_FAILED number @value:196,des:
---@field ERR_EXPBACK_ALREADYGET number @value:197,des:
---@field ERR_PK_OPENTIME number @value:198,des:
---@field ERR_ITEM_NEED_DIAMOND number @value:199,des:
---@field ERR_WORD_FORBID number @value:200,des:
---@field ERR_TEAM_TOWER_DAYCOUNT number @value:201,des:
---@field ERR_AUCTGOLDLESS number @value:202,des:
---@field ERR_ILLEGAL_CODE number @value:203,des:
---@field ERR_GUILD_CHECKINBONUS_TIMEERROR number @value:204,des:
---@field ERR_GUILD_CHECKINBONUS_ASKTOOMUCH number @value:205,des:
---@field ERR_TEAM_NOJOININBATTLE number @value:206,des:
---@field ERR_REGISTER_NUM_LIMIT number @value:207,des:
---@field ERR_FRIEND_MAXOTHER number @value:208,des:
---@field ERR_FRIEND_SENDLIMIT number @value:209,des:
---@field ERR_FRIEND_TAKENLIMIT number @value:210,des:
---@field ERR_ROLE_NOTEXIST number @value:211,des:
---@field ERR_RANDOMFRIEND_CD number @value:212,des:
---@field ERR_ENHANCE_TRANSLEVEL number @value:213,des:
---@field ERR_ENHANCE_TRANSPOS number @value:214,des:
---@field ERR_GUILD_LVL_LIMIT number @value:215,des:
---@field ERR_FRIEND_HASSEND number @value:216,des:
---@field ERR_GUILD_APPLYFULL number @value:217,des:
---@field ERR_BLACK_CHAT number @value:218,des:
---@field ERR_PVP_ROLE_INBATTLE number @value:219,des:
---@field ERR_FRIEND_SELF number @value:220,des:
---@field ERR_BLACK_MAX number @value:221,des:
---@field ERR_EMBLEM_NOIDENTIFY number @value:222,des:
---@field ERR_EMBLEM_NOTHIRDSLOT number @value:223,des:
---@field ERR_EMBLEM_CANTIDENTIFY number @value:224,des:
---@field GUILD_SKILL_STUDY_LEVEL_LIMIT number @value:225,des:
---@field GUILD_SKILL_GUILD_LEVEL_LIMIT number @value:226,des:
---@field ERR_GUILD_EXP_LIMIT number @value:227,des:
---@field ERR_REVIVE_MAXNUM number @value:228,des:
---@field ERR_QA_OVER_NAME_TIME number @value:229,des:
---@field ERR_QA_IN_OTHER_TYPE number @value:230,des:
---@field ERR_JADE_MINEQUIPLEVEL number @value:231,des:
---@field ERR_SWEEP_POWERPOINT_LESS number @value:232,des:
---@field ERR_SWEEP_TICKET_LESS number @value:233,des:
---@field ERR_ACCOUNT_INVALID number @value:234,des:
---@field ERR_JADE_WRONGTYPE number @value:235,des:
---@field ERR_SHOP_TIMELIMIT number @value:236,des:
---@field ERR_SHOP_VIPLIMIT number @value:237,des:
---@field ERR_SHOP_ARENALIMIT number @value:238,des:
---@field ERR_SHOP_PKLIMIT number @value:239,des:
---@field ERR_SHOP_GUILDLIMIT number @value:240,des:
---@field ERR_AUDIO_NOT_EXIST number @value:241,des:
---@field ERR_SHOP_INVALID number @value:242,des:
---@field ERR_WATCH_LIVEISOVER number @value:243,des:
---@field ERR_WATCH_LIVEISFULL number @value:244,des:
---@field ERR_TOWER_INSWEEP number @value:245,des:
---@field ERR_TOWER_FLOOR_NOTENOUGH number @value:246,des:
---@field ERR_DRAGON_TICKET_NOTENOUGH number @value:247,des:
---@field ERR_WATCH_WAIT number @value:248,des:
---@field ERR_OP_EXP_NOT_OPEN number @value:249,des:
---@field ERR_TEAM_GODDESS_DAYCOUNT number @value:250,des:
---@field ERR_TEAM_SEAL_TYPE number @value:251,des:
---@field ERR_DRAGON_PROGRESS_INVALID number @value:252,des:
---@field ERR_TEAMBUY_DRAGONCOIN_LESS number @value:253,des:
---@field ERR_JADE_REPLACE number @value:254,des:
---@field ERR_PVP_TEAM_MATCH number @value:255,des:
---@field ERR_GS_UNREADY number @value:256,des:
---@field ERR_INVALID_REQUEST number @value:257,des:
---@field ERR_PET_NOT_EXIST number @value:258,des:
---@field ERR_PE_CAN_NOT_RELEASE number @value:259,des:
---@field ERR_PETSYS_NOT_OPEN number @value:260,des:
---@field ERR_PET_SEAT_NOT_ENOUGH number @value:261,des:
---@field ERR_ACCOUNT_QUEUING number @value:262,des:
---@field ERR_TITLE_MAX number @value:263,des:
---@field ERR_TITLE_LACKITEM number @value:264,des:
---@field ERR_TITLE_PPTLIMIT number @value:265,des:
---@field ERR_BLACK_REPEATED number @value:266,des:
---@field ERR_BLACK_SELF number @value:267,des:
---@field ERR_TEAM_LEADER_NOTHELPER number @value:268,des:
---@field ERR_PET_IS_FULL number @value:269,des:
---@field ERR_IBSHOP_LACKGOODS number @value:270,des:
---@field ERR_IBSHOP_LIMITCOUNT number @value:271,des:
---@field ERR_IBSHOP_LACKDIAMOND number @value:272,des:
---@field ERR_IBSHOP_LACKDRAGON number @value:273,des:
---@field ERR_CHAT_PUNISH number @value:274,des:
---@field ERR_LOCKED_ROLE number @value:275,des:
---@field ERR_IBSHOP_ERRPARAM number @value:276,des:
---@field ERR_IBSHOP_BUYLV number @value:277,des:
---@field ERR_SPRITE_NOTFIND number @value:278,des:
---@field ERR_SPRITE_LEVELMAX number @value:279,des:
---@field ERR_SPRITE_EVOLUTION_LEVELMAX number @value:280,des:
---@field ERR_SPRITE_EVOLUTION_LEVELLIMIT number @value:281,des:
---@field ERR_SPRITE_EVOLUTION_LACKOFCOST number @value:282,des:
---@field ERR_SPRITE_AWAKE_LACKOFCOST number @value:283,des:
---@field ERR_SPRITE_LEVELUP_LACKOFCOST number @value:284,des:
---@field ERR_SPRITE_ALREADY_INFIGHT number @value:285,des:
---@field ERR_SPRITE_INFIGHT_FULL number @value:286,des:
---@field ERR_SPRITE_ALREADY_OUTFIGHT number @value:287,des:
---@field ERR_REVIVE_ITEMLIMIT number @value:288,des:
---@field ERR_REVIVE_MONEYLIMIT number @value:289,des:
---@field ERR_ENHANCE_NO_EQUIP_CAN_TRANSFORM number @value:290,des:
---@field ERR_IBSHOP_VIPLEVEL number @value:291,des:
---@field ERR_IBSHOP_OPENGROUP number @value:292,des:
---@field ERR_SPRITE_INFIGHT_SAMETYPE number @value:293,des:
---@field ERR_SMELT_MINLEVEL number @value:294,des:
---@field ERR_JADE_GOLDNOTENOUGH number @value:295,des:
---@field ATLAS_CARD_NOT_ENOUGH number @value:296,des:
---@field ERR_AUCT_ITEM_LESS number @value:297,des:
---@field ERR_AUCT_ITEM_LOCK number @value:298,des:
---@field ERR_AUCT_PRICE_NOTCHANGE number @value:299,des:
---@field ERR_LEVELSEAL_PROP_NOT_ENGOUTH number @value:300,des:
---@field ERR_AUCT_AUTOREFRESH_TIME number @value:301,des:
---@field ERR_ATLAS_NOT_BREAK number @value:302,des:
---@field ERR_LOGIN_NOT_IN_WHITE_LIST number @value:303,des:
---@field ERR_TEAM_NOT_PASS number @value:304,des:
---@field ERR_QA_ALEADY_IN_ROOM number @value:500,des:
---@field ERR_QA_NO_DATA number @value:501,des:
---@field ERR_QA_LEVEL_NOT_ENOUGH number @value:502,des:
---@field ERR_QA_NOT_IN_TIME number @value:503,des:
---@field ERR_QA_NO_GUILD number @value:504,des:
---@field ERR_QA_NO_COUNT number @value:505,des:
---@field ERR_TASK_NOT_ACCEPT number @value:510,des:任务未被接取
---@field ERR_TASK_ALREADY_TAKE number @value:511,des:任务已被接取
---@field ERR_TASK_NOT_FOUND number @value:512,des:任务未找到
---@field ERR_TASK_NOT_FINISH number @value:513,des:任务未完成
---@field ERR_TASK_NO_TABLE number @value:514,des:任务表中无任务
---@field ERR_GUILD_LADDER_NOT_OPEN number @value:515,des:
---@field ERR_GARDEN_NOTEXIST_FARMLAND number @value:516,des:
---@field ERR_GARDEN_NOHARVESTSTATE number @value:517,des:
---@field ERR_GARDEN_STEALEDTIMES_EXCEED number @value:518,des:
---@field ERR_GARDEN_NOTEXIST_SEEDID number @value:519,des:
---@field ERR_GARDEN_NOTEXIST_SPRITE number @value:520,des:
---@field ERR_SKYCITY_NOT_OPEN number @value:521,des:
---@field ERR_GMF_UP_INCOOL number @value:522,des:
---@field ERR_GMF_UP_FULL number @value:523,des:
---@field ERR_QA_NO_GUILD_ROOM number @value:524,des:
---@field ERR_TEAM_ALREADY_INOTHERTEAM number @value:525,des:
---@field ERR_TEAM_IDIP number @value:526,des:
---@field ERR_COMMENDWATCH_COUNTLIMIT number @value:527,des:
---@field ERR_CARDMATCH_BEGINFAILED number @value:528,des:
---@field ERR_CARDMATCH_NOBEGIN number @value:529,des:
---@field ERR_CARDMATCH_ENDSOON number @value:530,des:
---@field ERR_CARDMATCH_CHANGELIMIT number @value:531,des:
---@field ERR_SKILL_PREPOINTLIMIT number @value:532,des:
---@field ERR_SPACTIVITY_TASK_NOT_COMPLETE number @value:533,des:
---@field ERR_SPACTIVITY_TASK_GET number @value:534,des:
---@field ERR_SPACTIVITY_NOPRIZE number @value:535,des:
---@field ERR_SPACTIVITY_NOTPRIZETIME number @value:536,des:
---@field ERR_SPACTIVITY_NOTENOUGH_MONEY number @value:537,des:
---@field ERR_SPACTIVITY_PRIZE_GET number @value:538,des:
---@field ERR_GARDEN_PLANT_CD number @value:539,des:
---@field ERR_GARDEN_COOKING_EXCEED number @value:540,des:
---@field ERR_GARDEN_COOKINGLEVEL_LOW number @value:541,des:
---@field ERR_GARDEN_PLANT_CUL_ERR number @value:542,des:
---@field ERR_GARDEN_ERR_SEED number @value:543,des:
---@field ERR_GARDEN_NOSEED number @value:544,des:
---@field ERR_GARDEN_NOALLOW number @value:545,des:
---@field ERR_GMF_NOPOWER_KICK_LEADER number @value:546,des:
---@field ERR_SPRITE_ALREADY_ISLEADER number @value:547,des:
---@field ERR_SPRITE_AWAKE_ROLE_LEVELLIMIT number @value:548,des:
---@field ERR_SPRITE_EVOLUTION_ROLE_LEVELLIMIT number @value:549,des:
---@field ERR_GUILD_ALREADY_BIND number @value:550,des:
---@field ERR_GUILD_NOT_BIND number @value:551,des:
---@field ERR_ALREADY_IN_QQGROUP number @value:552,des:
---@field ERR_INSPIRE_COOLDOWN number @value:553,des:
---@field ERR_SKYCITY_IN_TEAM number @value:554,des:
---@field ERR_SKYCITY_TEAM_OUTTIME number @value:555,des:
---@field ERR_GMF_DOWN_FIGHTING number @value:556,des:
---@field ERR_GMF_DOWN_HAVEFAILED number @value:557,des:
---@field ERR_JADE_SAME_TYPE number @value:558,des:
---@field ERR_CHAT_BLACK_INSELF number @value:559,des:
---@field ERR_CHAT_BLACK_INOTHER number @value:560,des:
---@field ERR_GARDEN_QUESTS_NOENOUGH number @value:561,des:
---@field ERR_GARDEN_NOTINGARDEN number @value:562,des:
---@field ERR_GARDEN_FOODBOOK_ACTIVED number @value:563,des:
---@field ERR_ROLE_LOGOUT number @value:564,des:
---@field ERR_TEAM_INV_LOGOUT number @value:565,des:
---@field ERR_SKYCITY_LV number @value:566,des:
---@field ERR_RESWAR_TEAM number @value:567,des:
---@field ERR_RESWAR_ACTIVITY number @value:568,des:
---@field ERR_RESWAR_GROUP number @value:569,des:
---@field ERR_RESWAR_STATE number @value:570,des:
---@field ERR_RESWAR_CD number @value:571,des:
---@field ERR_BAG_FULL number @value:572,des:
---@field ERR_BAG_FULL_TAKEOFF_EQUIP number @value:573,des:
---@field ERR_BAG_FULL_TAKEOFF_FASHION number @value:574,des:
---@field ERR_BAG_FULL_TAKEOFF_EMBLEM number @value:575,des:
---@field ERR_BAG_FULL_TAKEOFF_JADE number @value:576,des:
---@field ERR_BAG_FULL_GIVE_MAIL_REWARD number @value:577,des:
---@field ERR_AUCT_PRICE_CHANGE number @value:578,des:
---@field ERR_GMF_UPBATTLE_REPEAT number @value:579,des:
---@field ERR_PANDORA_LACKOF_FIRE number @value:580,des:
---@field ERR_AUCT_AUCTOVER number @value:581,des:
---@field ERR_GOLDCLICK_LIMIT number @value:582,des:
---@field ERR_DRAGONCOIN_LIMIT number @value:583,des:
---@field ERR_NOTGUILD number @value:584,des:
---@field ERR_SCENE_NOT_PET number @value:585,des:
---@field ERR_GUILDBONUS_ALLGET number @value:586,des:
---@field ERR_GUILDBUFF_GUILD number @value:587,des:
---@field ERR_GUILDBUFF_POS number @value:588,des:
---@field ERR_GUILDBUFF_CD number @value:589,des:
---@field ERR_GUILDBUFF_ITEM number @value:590,des:
---@field ERR_RESWAR_LEADER number @value:591,des:
---@field ERR_RESWAR_LACKPLAYER number @value:592,des:
---@field ERR_TEAM_INV_IN_FAMILY number @value:593,des:
---@field ERR_TASK_NO_ASK_HELPNUM number @value:594,des:
---@field ERR_TASK_CANNOT_HELP number @value:595,des:
---@field ERR_TASK_ALREADY_FINISH number @value:596,des:任务已完成了
---@field ERR_TASK_ALREADY_ASKED number @value:597,des:
---@field ERR_GARDEN_NOEXIST_FOODID number @value:598,des:
---@field ERR_GARDEN_FOOD_NOALLOW number @value:599,des:
---@field ERR_TASK_NO_ASKINFO number @value:600,des:
---@field ERR_TASK_ASKITEM_REFRESH number @value:601,des:
---@field ERR_ANTI_CHEAT_DETECTED number @value:305,des:
---@field ERR_MS_UNREADY number @value:306,des:
---@field ERR_PET_EXP_EQUAL number @value:602,des:
---@field ERR_TASK_CANNT_HELPSELF number @value:603,des:
---@field CanNotDelInGuildArena number @value:604,des:
---@field ERR_RESWAR_TEAMFIGHTING number @value:605,des:
---@field ERR_TASK_CANNOT_GIVEUP number @value:606,des:
---@field ERR_GUILD_INHERIT_NOT_EXIT number @value:607,des:
---@field ERR_GUILD_INHERIT_GAP number @value:608,des:
---@field ERR_GUILD_INHERIT_LVL number @value:609,des:
---@field ERR_GUILD_INHERIT_TIMES number @value:610,des:
---@field ERR_GUILD_INHERIT_MAP_WRONG number @value:611,des:
---@field ERR_TEAMCOST_DIAMOND number @value:612,des:
---@field ERR_TEAMCOST_DRAGON number @value:613,des:
---@field ERR_TEAM_PPTLIMIT number @value:614,des:
---@field ERR_GUILD_INHERIT_CD_TIME number @value:615,des:
---@field ERR_MS_UNNORMAL number @value:616,des:
---@field ERR_TEAMCOST_NUMLIMIT number @value:617,des:
---@field ERR_STATE_CANTCHANGE number @value:618,des:
---@field ERR_TEAM_MEMCOUNT_OVER number @value:619,des:
---@field ERR_GUILD_INHERIT_CAN_NOT number @value:620,des:
---@field ERR_SYS_NOTOPEN number @value:621,des:
---@field ERR_NAME_ALLNUM number @value:622,des:
---@field ERR_NAME_TOO_LONG number @value:623,des:
---@field ERR_NAME_TOO_SHORT number @value:624,des:
---@field ERR_GUILD_INHERIT_OTHER_TIMES number @value:625,des:
---@field ERR_NEED_FIRST_PROMOTE number @value:626,des:
---@field ERR_FM_NOANCHOR number @value:627,des:
---@field ERR_CAN_NOT_USE_PET_SKILL_BOOK number @value:628,des:
---@field ERR_ENCHANT_MINLEVEL number @value:629,des:
---@field ERR_ENCHANT_LACKITEM number @value:631,des:
---@field ERR_ENCHANT_WRONGPOS number @value:632,des:
---@field ERR_PARTNER_NUM_INVALID number @value:650,des:
---@field ERR_PARTNER_FDEGREE_NOT_ENOUGH number @value:651,des:
---@field ERR_PARTNER_NOT_IN_MAIN_HALL number @value:652,des:
---@field ERR_PARTNER_NOT_ENOUGH_DRAGON number @value:653,des:
---@field ERR_PARTNER_CD_NOT_OK number @value:654,des:
---@field ERR_HORSE_ACTIVITY number @value:655,des:
---@field ERR_TEAM_WEEK_NEST_EXP number @value:656,des:
---@field ERR_PARTNER_CHEST_TAKED number @value:657,des:
---@field ERR_PARTNER_NO_PARTNER number @value:658,des:
---@field ERR_PARTNER_LN_NOT_ENOUGH number @value:659,des:
---@field ERR_PARTNER_ALREADY_HAS number @value:660,des:
---@field ERR_PARTNER_ALREADY_APPLY_LEAVE number @value:661,des:
---@field ERR_PARTNER_NOT_APPLY_LEAVE number @value:662,des:
---@field ERR_INVFIGHT_ROLE_LOGOUT number @value:663,des:
---@field ERR_INVFIGHT_ME_LEVEL number @value:664,des:
---@field ERR_INVFIGHT_ME_SCENE number @value:665,des:
---@field ERR_INVFIGHT_OTHER_LEVEL number @value:666,des:
---@field ERR_INVFIGHT_OTHER_SCENE number @value:667,des:
---@field ERR_INVFIGHT_INV_REPEAT number @value:668,des:
---@field ERR_INVFIGHT_INV_COUNT_MAX number @value:669,des:
---@field ERR_INVFIGHT_INV_TIME_OVER number @value:670,des:
---@field ERR_INVFIGHT_INV_DELAY number @value:671,des:
---@field ERR_DOODAD_FULL number @value:672,des:
---@field ERR_INVFIGHT_INV_TO_COUNT_MAX number @value:673,des:
---@field ERR_PARTNER_ITEM_NOT_FOUND number @value:674,des:
---@field ERR_PARTNER_OTHER_BUYING number @value:675,des:
---@field ERR_PARTNER_SHOP_NO_COUNT number @value:676,des:
---@field ERR_FRIEND_IS_PARTNER number @value:677,des:
---@field ERR_PANDORA_LACKOF_HEART number @value:678,des:
---@field ERR_SELF_HAS_ALLIANCE number @value:679,des:
---@field ERR_OTHER_HAS_ALLIANCE number @value:680,des:
---@field ERR_AUDIOTXT number @value:681,des:
---@field ERR_MENTOR_ASKMAXTODAY number @value:682,des:
---@field ERR_MENTOR_REFRESHTOOFAST number @value:683,des:
---@field ERR_MENTOR_OTHER_ONLINE number @value:684,des:
---@field ERR_PARTNER_LEVEL_NOT_ENOUGH number @value:685,des:
---@field ERR_GCASTLE_NOT_IN_ACT number @value:686,des:
---@field ERR_GCASTLE_NOT_IN_FIGHT number @value:687,des:
---@field ERR_GCASTLE_ROLE_FULL number @value:688,des:
---@field ERR_CARDMATCH_SIGNUP_LIMIT number @value:689,des:
---@field ERR_GUILDAUCT_PUBLIC_TIME number @value:690,des:
---@field ERR_FASHIONCOMPOSE_TIMELIMIT number @value:691,des:
---@field ERR_FASHIONCOMPOSE_QUALITY number @value:692,des:
---@field ERR_FASHIONCOMPOSE_FAILED number @value:693,des:
---@field ERR_FASHIONCOMPOSE_POS number @value:694,des:
---@field ERR_RESWAR_LEAVETEAM number @value:695,des:
---@field ERR_RECONNECT_FAIL number @value:696,des:
---@field ERR_CANTCHOOSEHERO number @value:697,des:
---@field ERR_HERO_INVALID number @value:698,des:
---@field ERR_TEAM_SERVER_OPEN_TIME number @value:699,des:
---@field ERR_AUDIO_CHAT number @value:700,des:
---@field ERR_HERO_LACKMONEY number @value:701,des:
---@field ERR_HEROBATTLE_CANTGETPRIZE number @value:702,des:
---@field ERR_HEROBATTLE_ALREADYGET number @value:703,des:
---@field ERR_CAN_NOT_DEL_IN_GUILD_TERRITOYR number @value:704,des:
---@field ERR_HORSE_TEAM number @value:705,des:
---@field ERR_GCASTLE_ROLE_LEVEL number @value:706,des:
---@field ERR_CAN_INGORE number @value:707,des:
---@field ERR_LEAGUE_NOT_IN_TEAM number @value:708,des:
---@field ERR_LEAGUE_ALREADY_HAS_TEAM number @value:709,des:
---@field ERR_LEAGUE_TEAM_ROLE_NUM_INVALID number @value:710,des:
---@field ERR_LEAGUE_HAS_NO_TEAM number @value:711,des:
---@field ERR_LEAGUE_TEAM_NOT_EXIST number @value:712,des:
---@field ERR_GARDEN_STEAL_LIMIT number @value:713,des:
---@field ERR_LEAGUE_TEAM_IN_MATCH number @value:714,des:
---@field ERR_LEAGUE_TEAM_NOT_IN_MATCH number @value:715,des:
---@field ERR_SKILL_NEED_EXPRESKILL number @value:716,des:
---@field ERR_EQUIP_CANTFORGE number @value:717,des:
---@field ERR_EQUIP_FORGE_LACK_ITEM number @value:718,des:
---@field ERR_EQUIP_FORGE_LACK_STONE number @value:719,des:
---@field ERR_LEAGUE_ROLE_ALREADY_UP number @value:720,des:
---@field ERR_LEAGUE_ROLE_FIGHTING number @value:721,des:
---@field ERR_LEAGUE_ROLE_ALREADY_BATTLE number @value:722,des:
---@field ERR_REQUEST_REPEAT number @value:723,des:
---@field ERR_EQUIP_FORGE_FAILED number @value:724,des:
---@field ERR_NOMAIL_GETREWARD number @value:725,des:
---@field ERR_MIDAS_FAILED number @value:726,des:
---@field ERR_LEAGUE_TEAM_IN_BATTLE number @value:727,des:
---@field ERR_ENCHANT_NOTHAVE number @value:728,des:
---@field ERR_ENCHANT_ALREADYHAVE number @value:729,des:
---@field ERR_ENCHANT_TRANSFER_LEVEL_LIMIT number @value:730,des:
---@field ERR_FM_NOINAUDIO number @value:731,des:
---@field ERR_FM_NOINROOM number @value:732,des:
---@field ERR_CHANGEPRO_LEVEL number @value:733,des:
---@field ERR_CHANGEPRO_TIME number @value:734,des:
---@field ERR_CHANGEPRO_COUNT number @value:735,des:
---@field ERR_CHANGEPRO_INVALID number @value:736,des:
---@field ERR_CHANGEPRO_SAMEPRO number @value:737,des:
---@field ERR_CHANGEPRO_ITEMLIMIT number @value:738,des:
---@field ERR_SMELT_MAXVALUE number @value:739,des:
---@field ERR_SPRITE_AWAKE_MAX number @value:740,des:
---@field ERR_CHANGEPRO_KICK number @value:741,des:
---@field ERR_LEAGUE_NOT_IN_MATCH_TIME number @value:742,des:
---@field ERR_LEAGUE_TEAM_NOT_IN_BATTLE number @value:743,des:
---@field ERR_SPRITE_TRAIN_MAX number @value:744,des:
---@field ERR_SPRITE_TRAIN_CHOOSEMAX number @value:745,des:
---@field ERR_SPRITE_TRAIN_LACKITEM number @value:746,des:
---@field ERR_SPRITE_NOTTRAIN number @value:747,des:
---@field ERR_SPRITE_RESETTRAIN_LACKITEM number @value:748,des:
---@field ERR_LEAGUE_ALREADY_FIGHTED number @value:749,des:
---@field ERR_LEAGUE_NOT_IN_APPLY_TIME number @value:750,des:
---@field ERR_HORSE_INTEAM number @value:751,des:
---@field ERR_LEAGUE_INV_NOT_IN_TEAM number @value:752,des:
---@field ERR_LEAGUE_INV_ALREADY_HAS_TEAM number @value:753,des:
---@field ERR_SPRITE_TRAIN_NOT_ENOUGH number @value:754,des:
---@field ERR_AUDIO_TIMELIMIT number @value:755,des:
---@field ERR_DECLAREWAR_OUT_TIME number @value:756,des:
---@field ERR_LEAGUE_TEAM_CANNOT_CROSS number @value:757,des:
---@field ERR_DECLARATION_TOO_LONG number @value:758,des:
---@field ERR_CROSS_ZONE_UNUSABLE number @value:759,des:
---@field ERR_NOT_DEL_GUILD_IN_TERR number @value:760,des:
---@field ERR_GCASTLE_FIGHT_END number @value:761,des:
---@field ERR_CAREER_PVP_NOTOPEN number @value:762,des:
---@field ERR_APOLLO_CDN number @value:763,des:
---@field ERR_LEAGUE_HAS_MEMBER_NOT_TEAM number @value:764,des:
---@field ERR_POK_MATCH_ENDSOON number @value:765,des:
---@field ERR_QUESTCAREER_NOT_ONLINE number @value:766,des:
---@field ERR_MIDAS_BALANCE_NOTENOUTH number @value:767,des:
---@field ERR_HAS_JOIN_OTHER_GUILD_BOSS number @value:768,des:
---@field ERR_AUTH_TOKEN_INVALID number @value:769,des:
---@field ERR_TEAM_TICKET_LESS number @value:770,des:
---@field ERR_TEAM_USE_TICKET_COUNT_LESS number @value:771,des:
---@field ERR_TEAM_TICKET_CONFIG number @value:772,des:
---@field ERR_TEAM_TICKET_SEAL number @value:773,des:
---@field ERR_INVALID_IBBUY number @value:774,des:
---@field ERR_CROSS_IBBUY number @value:775,des:
---@field ERR_GUILD_NAME_NULL number @value:776,des:
---@field ERR_GUILD_LOCK_NAME number @value:777,des:
---@field ERR_ARGENTA_DAILY_GET number @value:778,des:
---@field ERR_WORLDBOSSGUILD_COUNTLIMIT number @value:779,des:
---@field ERR_WORLDBOSSGUILD_UNMATCH number @value:780,des:
---@field ERR_HERO_EXPERIENCE_HAVE number @value:781,des:
---@field ERR_PLATSHARE_FAILED number @value:782,des:
---@field ERR_HERO_ALREADY_CHOSEN number @value:783,des:
---@field ERR_SKY_NOT_TEAM_MEMBER number @value:784,des:
---@field ERR_SKY_ALREADY_HAS_TEAM number @value:785,des:
---@field ERR_SKY_HAS_NO_TEAM number @value:786,des:
---@field ERR_SKY_INV_NOT_TEAM_MEMBER number @value:787,des:
---@field ERR_SKY_TEAM_IN_MATCH number @value:788,des:
---@field ERR_SKY_INV_ALREADY_HAS_TEAM number @value:789,des:
---@field ERR_SKY_TEAM_ROLE_NUM_INVALID number @value:790,des:
---@field ERR_SKY_TEAM_IN_BATTLE number @value:791,des:
---@field ERR_SKY_HAS_NOT_TEAM_MEMBER number @value:792,des:
---@field ERR_MENTOR_COMPLETE_OTHER_OFFLINE_NEED_DAYS number @value:793,des:
---@field ERR_MENTOR_COMPLETE_IN_RELATION_NEED_DAYS number @value:794,des:
---@field ERR_TRANSFERR_OTHER_ROLES_LEAVE number @value:795,des:
---@field ERR_PLAT_BANACC number @value:796,des:
---@field ERR_RESWAR_DIFF_GUILD number @value:797,des:
---@field ERR_SKY_ALREADY_FIGHTED number @value:798,des:
---@field ERR_SKY_TEAM_NO_DAILY_NUM number @value:799,des:
---@field ERR_IBGIFT_NOT_ENOUCH number @value:800,des:
---@field ERR_IBGIFT_DAY_MAXBUYCOUNT number @value:801,des:
---@field ERR_IBGIFT_FRIEND number @value:802,des:
---@field ERR_ALREADY_BUYAILEEN number @value:803,des:
---@field ERR_GUILDACMPPATY_NOTOPEN number @value:804,des:
---@field ERR_GUILDACMPPATY_ERRSTAGE number @value:805,des:
---@field ERR_GUILDACMPPATY_DISTANCE number @value:806,des:
---@field ERR_MENTOR_ALREADY_INRELATION number @value:807,des:
---@field ERR_NOT_BESPEAK number @value:808,des:
---@field ERR_NOT_TEAM_CAPTAIN number @value:809,des:
---@field ERR_NOT_IN_TEAM number @value:810,des:
---@field ERR_ATTR_TOP_LIMIT number @value:811,des:
---@field ERR_QUALITY_POINT_LIMIT number @value:812,des:
---@field ERR_ITEM_PUT_IN_TEMP_BAG number @value:813,des:
---@field ERR_TASK_NO_TASK number @value:814,des:任务不存在
---@field ERR_TASK_PREID number @value:815,des:前置任务限制
---@field ERR_TASK_LEVEL number @value:816,des:任务等级限制
---@field ERR_TASK_ITEM number @value:817,des:任务物品限制
---@field ERR_TASK_IDENTITY number @value:818,des:任务身份限制
---@field ERR_TASK_PROFESSION number @value:819,des:任务职业限制
---@field ERR_TASK_NOT_FINISHED number @value:820,des:任务未完成
---@field ERR_TASK_FINISHED number @value:821,des:任务已完成
---@field ERR_TASK_UNDERGOING number @value:822,des:任务已接取进行中
---@field ERR_ITEM_CREATE_FAIL number @value:823,des:
---@field ERR_FASHION_NOT_HAVE number @value:824,des:
---@field ERR_FASHION_WEARING number @value:825,des:
---@field ERR_ITEM_UNKNOW_TYPE number @value:826,des:
---@field ERR_ITEM_NOT_HAVE number @value:827,des:
---@field ERR_INVALID_CONFIG number @value:828,des:
---@field ERR_EQUIP_NOT_APPRAISED number @value:829,des:
---@field ERR_ITEM_STILL_FREEZE number @value:830,des:物品有0.5秒冻结期不能拾取
---@field ERR_HAIR_TYPE_NOT_EXIST number @value:831,des:
---@field ERR_SEX_NOT_RIGHT number @value:832,des:
---@field ERR_LEVEL_NOT_RIGHT number @value:833,des:
---@field ERR_PROFESSION_RIGHT number @value:834,des:
---@field ERR_SCENE_NOT_EXIST number @value:835,des:
---@field ERR_BATCH_READ_SUCCESS number @value:836,des:特殊ID:区分批量读取成功
---@field ERR_ITEM_CANNOT_USE number @value:837,des:物品不能使用
---@field ERR_CANNOT_WEAPON_DURING_SKILL number @value:838,des:释放技能的过程不能换武器
---@field ERR_MAIN_WEAPON_IS_DOUBLE_HANDS number @value:839,des:主手武器是双手武器，此时副手上不能装备东西
---@field ERR_EYE_ID_NOT_EXIST number @value:840,des:不存在这种眼睛
---@field ERR_EYE_STYLE_ID_NOT_EXIST number @value:841,des:不存在这种眼睛颜色
---@field ERR_VIRTUAL_ITEM_LACK_ZENY number @value:842,des:虚拟物品:缺少ZENY币
---@field ERR_VIRTUAL_ITEM_LACK_ROMONEY number @value:843,des:虚拟物品:缺少RO币
---@field ERR_VIRTUAL_ITEM_LACK_DIAMOND number @value:844,des:虚拟物品:缺少DIAMOND钻石
---@field ERR_VIRTUAL_ITEM_WILL_OVERLAP number @value:845,des:虚拟物品:操作尝试越界,操作回滚
---@field ERR_VIRTUAL_ITEM_BAD_TYPE number @value:846,des:虚拟物品:类型错误
---@field ERR_TASK_SCENE_TRIGGER_MODIFY_FAILED number @value:847,des:任务场景触发失败,后台检车失败
---@field ERR_TASK_CANT_GIVEUP number @value:848,des:任务无法放弃
---@field ERR_TASK_ALREADY_HAVE_EDEN_TASK number @value:849,des:已经有一个伊甸园任务在进行中
---@field ERR_TASK_EDEN_TASK_FULL number @value:850,des:每日伊甸园任务数量满了
---@field ERR_TASK_WRONG_SEX number @value:851,des:性别不符合任务需求
---@field ERR_TASK_EDEN_NOT_EXIST number @value:852,des:所请求的任务不在面板里
---@field ERR_TASK_EDEN_ALREADY_FINISHED number @value:853,des:伊甸园任务重复接报错
---@field ERR_NAVIGATE_NOWAY number @value:854,des:寻路错误
---@field ERR_SHOP_TYPE_INVALID number @value:855,des:商店type不存在
---@field ERR_SHOP_ITEM_LOCKED number @value:856,des:商品被锁定,无法买卖
---@field ERR_SHOP_OVERFLOW number @value:857,des:输入购买参数越界
---@field ERR_SHOP_CONFIG_ERROR number @value:858,des:商品查询表失败
---@field ERR_SHOP_RECYCLE_NULL number @value:859,des:商品无回收价值,不可回收
---@field ERR_COOKING_NOT_ENOUGH_RECIPE number @value:860,des:没有足够的菜谱
---@field ERR_COOKING_NOT_ENOUGH_INGREDIENTS number @value:861,des:没有足够的食材
---@field ERR_TARGET_ROLE_OFFLINE number @value:862,des:目标玩家已经离线
---@field ERR_NOT_IN_WALL_AREA number @value:863,des:不在场景物件区域内
---@field ERR_NAVIGATE_MAP_LIMIT number @value:864,des:便捷寻路地图限制
---@field ERR_VEHICLE_ALREADY_TAKE_VEHICLE number @value:865,des:已经搭乘了载具
---@field ERR_VEHICLE_NOT_EQUIP number @value:866,des:没装备载具
---@field ERR_NOT_ALLOWED_INFIGHT number @value:867,des:战斗时不允许该操作
---@field ERR_VEHICLE_NOT_DRIVER number @value:868,des:不是载具的驾驶员
---@field ERR_VEHICLE_IN_CD number @value:869,des:在CD中
---@field ERR_TASK_TIME_OUT number @value:870,des:任务超时失败
---@field ERR_BAG_SPACE_NOT_ENOUGH number @value:871,des:背包空间不足
---@field ERR_ITEM_FORGE_MATERIAL_LACK number @value:872,des:装备打造材料不足
---@field ERR_VEHICLE_CANNOT_USE_IN_THIS_SCENE number @value:873,des:
---@field ERR_COOK_NOT_IN_RANGE number @value:874,des:不在合法范围
---@field ERR_COOK_POT_FULL number @value:875,des:锅已经满了
---@field ERR_COOK_FOOD_NOT_CHOPPED number @value:876,des:需要切过的食物
---@field ERR_COOK_FOOD_NOT_RAW number @value:877,des:需要未处理的食物
---@field ERR_COOK_PLAT_FULL number @value:878,des:台子满了
---@field ERR_COOK_ROLE_NOT_CARRY number @value:879,des:玩家是空手的
---@field ERR_COOK_ROLE_IN_CARRY number @value:880,des:
---@field ERR_TASK_GIVE_UP number @value:881,des:主动放弃
---@field ERR_TASK_ACCEPT_NEED_CAPTAIN number @value:882,des:需要队长才能接受
---@field ERR_TASK_FINISH_NEED_CAPTAIN number @value:883,des:需要队长才能交
---@field ERR_TASK_NEED_ALL_MEMBER number @value:884,des:需要全员在场
---@field ERR_TASK_NEED_TEAM number @value:885,des:需要组队
---@field ERR_TASK_TEAM_MEMBER_COUNT_WRONG number @value:886,des:组队人数不正确
---@field ERR_VEHICLE_CANNOT_USE_VEHICLE number @value:887,des:
---@field ERR_TASK_TEAM_SEX number @value:888,des:队伍性别组成不对
---@field ERR_TASK_TEAM_DISTANCE number @value:889,des:队员之间距离错误
---@field ERR_NUMBER_NEGATIVE number @value:890,des:负数错误
---@field ERR_NUMBER_POSITIVE number @value:891,des:正数错误
---@field ERR_ITEM_CANNOT_STORE_WAREHOUSE number @value:892,des:东西不能移动到仓库里
---@field ERR_ITEM_CANNOT_IN_QUICK number @value:893,des:东西不能放到快捷栏里
---@field ERR_IS_IN_TRANSFIGURE number @value:894,des:玩家在变身中
---@field ERR_IS_IN_WALL number @value:895,des:玩家在场景交互物件中
---@field ERR_IS_IN_VEHICLE number @value:896,des:玩家在载具中
---@field ERR_IS_IN_COMMON_VEHICLE number @value:897,des:玩家在公共载具中
---@field ERR_COMMON_VEHICLE_NOT_CAPTAIN number @value:898,des:只有队长才能使用公共载具
---@field ERR_IS_IN_SPECIAL_ACTION number @value:899,des:玩家处于特殊动作
---@field ERR_EASYPATH_NOPATH number @value:900,des:无法获取当前寻路路径
---@field ERR_EASYPATH_DISTANCE_CHECK_FAILED number @value:901,des:检测距离目标点过远
---@field ERR_EASYPATH_NO_NEXTPATH number @value:902,des:没有下一步寻路路径
---@field ERR_EASYPATH_NPC_ERROR number @value:903,des:卡普拉id错误
---@field ERR_PASSENGER_IS_FULL number @value:904,des:乘客人数已满
---@field ERR_TRANSFER_PROFESSION_FIGHTING number @value:905,des:转职失败,正在战斗中
---@field ERR_TRANSFER_PROFESSION_TRANS_FIGURE number @value:906,des:转职失败,吃了变身药
---@field ERR_TRANSFER_PROFESSION_NO_DATA number @value:907,des:转职失败,没有对应职业配置
---@field ERR_TRANSFER_PROFESSION_WRONG_PROFESSION number @value:908,des:转职失败,职业不匹配
---@field ERR_TRANSFER_PROFESSION_BASE_LEVEL number @value:909,des:转职失败,基础等级不满足
---@field ERR_TRANSFER_PROFESSION_JOB_LEVEL number @value:910,des:转职失败,职业等级不满足
---@field ERR_TRANSFER_PROFESSION_SKILL_POING number @value:911,des:转职失败,技能点数不够
---@field ERR_VEHICLE_LAND_ONE_LIMIT number @value:912,des:地面单人载具限制
---@field ERR_VEHICLE_LAND_TWO_LIMIT number @value:913,des:地面双人载具限制
---@field ERR_VEHICLE_SKY_ONE_LIMIT number @value:914,des:空中单人限制
---@field ERR_VEHICLE_SKY_TWO_LIMIT number @value:915,des:空中双人限制
---@field ERR_TRANSFIGURED_LIMIT number @value:916,des:变身限制
---@field ERR_SKILL_RESET_FIGHTING number @value:917,des:技能洗点失败，正在战斗中
---@field ERR_SKILL_RESET_TRANSFIGURED number @value:918,des:技能洗点失败，正在变身中
---@field ERR_COMMON_VEHICLE_TEAM_PLAYER_LIMIT number @value:919,des:公共载具上队伍人数太多
---@field ERR_SPECIAL_PRIZE_START_REPEATED number @value:920,des:惊奇盒不能重复开启
---@field ERR_OTHERS_CANNOT_VEHICLE number @value:921,des:对方当前状态不能上载具
---@field ERR_ACCOUNT_SELECTING_ROLE number @value:922,des:玩家正在选角中
---@field ERR_ROLE_ALREADY_DEAD number @value:923,des:玩家已经死了
---@field ERR_VEHICLE_WHEN_SINGING number @value:924,des:吟唱状态不能上载具
---@field ERR_IS_IN_BUFF_SPECIAL_ACTION number @value:925,des:buff特殊状态下不能变身
---@field ERR_WAREHOUSE_FULL number @value:926,des:仓库已经满了
---@field ERR_TRADE_BUY_COUNT_LIMIT number @value:927,des:购买数量错误
---@field ERR_TRADE_ITEM_NOT_EXIST number @value:928,des:物品不存在
---@field ERR_TRADE_ITEM_OPEN_LEVEL_LIMIT number @value:929,des:该物品暂未开放购买
---@field ERR_TRADE_ITEM_SINGLE_BUY_LIMIT number @value:930,des:不能超过单次购买上限
---@field ERR_TRADE_ITEM_COUNT_LIMIT number @value:931,des:物品库存不足
---@field ERR_TRADE_ITEM_BUY_STOP number @value:932,des:该物品达到涨停，不可购买
---@field ERR_TRADE_ITEM_SHORT_SUPPLY number @value:933,des:物品供不应求
---@field ERR_TRADE_ITEM_PRICE_ERR number @value:934,des:物品价格错误，检查公式
---@field ERR_TRADE_ROLE_NOT_FOUND number @value:935,des:未找到玩家
---@field ERR_TRADE_ROLE_DAY_BUY_LIMIT number @value:936,des:购买超过每天上限
---@field ERR_TRADE_SELL_COUNT_LIMIT number @value:937,des:卖出超过上限
---@field ERR_TRADE_ITEM_SINGLE_SELL_LIMIT number @value:938,des:单次出售超过上限
---@field ERR_TRADE_ITEM_SELL_FULL number @value:939,des:该物品已跌停
---@field ERR_TRADE_ROLE_DAY_SELL_LIMIT number @value:940,des:每日出售达到上限
---@field ERR_EQUIP_NOT_REFINE number @value:941,des:装备不能精炼
---@field ERR_REFINE_MAX_LEVEL_LIMIT number @value:942,des:精炼等级已经是最高级
---@field ERR_EQUIP_IS_DISREPAIR number @value:943,des:装备已损坏
---@field ERR_EQUIP_IS_REPAIR number @value:944,des:装备没损坏
---@field ERR_EQUIP_CONFIG_ERROR number @value:945,des:没从equiptable找到配置信息
---@field ERR_EQUIP_REFINE_CONFIG_ERROR number @value:946,des:没从equiprefinetable找到配置信息
---@field ERR_IS_IN_COLLECTING number @value:947,des:当前处于采集状态
---@field ERR_COLLECTION_NOT_EXIST number @value:948,des:采集物不存
---@field ERR_COLLECTION_LACK_NUM number @value:949,des:采集物次数不够
---@field ERR_COLLECT_STATEMACHINE_LIMIT number @value:950,des:采集状态机不通过
---@field ERR_TASK_BASE_LEVEL_LOW number @value:951,des:base等級低于最低限制
---@field ERR_TASK_BASE_LEVEL_HIGH number @value:952,des:base等级高于最高限制
---@field ERR_TASK_JOB_LEVEL_LOW number @value:953,des:JOB等级低于最低限制
---@field ERR_TASK_JOB_LEVEL_HIGH number @value:954,des:JOB等级高于最高限制
---@field ERR_COLLECTION_OUT_RANGE number @value:955,des:超出采集物可采集范围
---@field ERR_COLLECTION_TASK_LIMIT number @value:956,des:采集物任务限制了
---@field ERR_IS_IN_DEAD_STATUS number @value:957,des:玩家处于死亡状态
---@field ERR_IS_IN_DEATH_MIMICRY number @value:958,des:玩家处于装死状态
---@field ERR_IS_IN_CLIMBING number @value:959,des:玩家处于攀爬状态
---@field ERR_IN_REFUSE_LIST number @value:960,des:对方暂时拒绝了，过一段时间再试
---@field ERR_SEND_TOO_FREQUENT number @value:961,des:发送过于频繁
---@field ERR_ARGS_ERROR number @value:962,des:参数错误
---@field ERR_TEAM_NEED_TARGET number @value:963,des:队伍需要一个目标
---@field ERR_ALREADY_IN_MATCH_QUEUE number @value:964,des:已经在匹配队列里了
---@field ERR_NO_TEAM_MEMBERS number @value:965,des:队伍中没有队员
---@field ERR_CANNOT_MATCH_IN_DUNGEONS number @value:966,des:在副本中不能匹配
---@field ERR_NOT_BELONG_TO_THIS_DUNGEON number @value:967,des:不属于这个副本
---@field ERR_CONTAIN_FORBID_WORD number @value:968,des:包含敏感词
---@field ERR_READ_MESSAGE_NOT_UID number @value:969,des:读取消息找不到uid
---@field ERR_IS_ALREADY_MY_FRIEND number @value:970,des:已经是我的好友了
---@field ERR_LOAD_RELATION_ROLE_FAIL number @value:971,des:load社交服务器角色信息失败
---@field ERR_FRIEND_TOO_MANY number @value:972,des:好友人数已满
---@field ERR_MS_LOAD_MODULE_FAIL number @value:973,des:master拉取模块数据失败
---@field ERR_MS_NOT_HAVE_FRIEND_DATA number @value:974,des:master没有好友数据
---@field ERR_MS_NOT_HAVE_MESSAGE_DATA number @value:975,des:master没有聊天数据
---@field ERR_MS_NOT_HAVE_BASE_DATA number @value:976,des:master没有玩家基本数据
---@field ERR_IS_NOT_MY_FRIEND number @value:977,des:不是我的好友
---@field ERR_MS_NOT_HAVE_BASE_INFO_DATA number @value:978,des:
---@field ERR_GUILD_IS_IN_GUILD number @value:1000,des:玩家已经在公会
---@field ERR_GUILD_DECLARATION_TOO_LONG number @value:1001,des:公会宣言长度过长
---@field ERR_GUILD_NAME_INVALID number @value:1002,des:公会名字非法
---@field ERR_GUILD_DECLARATION_INVALID number @value:1003,des:公会宣言非法
---@field ERR_GUILD_ANNOUNCE_TOO_LONG number @value:1004,des:公会公告过长
---@field ERR_GUILD_ANNOUNCE_INVALID number @value:1005,des:公会公告非法
---@field ERR_GUILD_CREATE_FAILED number @value:1006,des:创建公会失败
---@field ERR_GUILD_FULL_GUILD number @value:1007,des:公会已满，不能创建新公会
---@field ERR_GUILD_ROLE_APPLY_FULL number @value:1008,des:申请已达上限
---@field ERR_GUILD_ROLE_ONE_KEY_APPLY_CD number @value:1009,des:一键申请冷却
---@field ERR_GUILD_ROLE_NOT_IN_APPLY_LIST number @value:1010,des:不在公会申请列表
---@field ERR_GUILD_MEMBER_FULL number @value:1011,des:公会人数已满
---@field ERR_GUILD_PERMISSION_NOT_EXIST number @value:1012,des:权限不存在
---@field ERR_GUILD_PERMISSION_FULL number @value:1013,des:公会授权已满
---@field ERR_GUILD_CHAIRMAN_QUIT number @value:1014,des:会长不能退出公会
---@field ERR_GUILD_DECLARATION_TOO_SHORT number @value:1015,des:公会宣言过短
---@field ERR_GUILD_INVALID_ICON number @value:1016,des:公会icon错误
---@field ERR_BATTLEFIELD_LEVEL_LIMIT number @value:1017,des:战场等级不够
---@field ERR_COLLECTION_IS_ENEMY number @value:1018,des:采集物是敌对阵营的
---@field ERR_EQUIP_NOT_ENCHANT number @value:1019,des:该装备不能附魔
---@field ERR_EQUIP_ENCHANT_CONFIG_ERROR number @value:1020,des:装备附魔配置出错
---@field ERR_EQUIP_ENCHANT_RESULT_CONFIG_ERROR number @value:1021,des:装备附魔result配置出错
---@field ERR_EQUIP_THESAURUS_CONFIG_ERROR number @value:1022,des:装备thesaurus配置出错
---@field ERR_SCENE_NOT_SUPPORT_LINE number @value:1023,des:该场景不支持分线
---@field ERR_SCENE_IS_CROWDED number @value:1024,des:场景太拥挤了
---@field ERR_BATTLEFIELD_MATCHED_FAILED number @value:1025,des:战场匹配失败
---@field ERR_BATTLEFIELD_TEAM_FAILED number @value:1026,des:战场组队失败
---@field ERR_IS_FRIEND_IS_MYSELF number @value:1027,des:不能加自己为好友
---@field ERR_GUILD_NAME_ALL_NUMBER number @value:1028,des:公会名字不能都是数字
---@field ERR_MAIL_NOT_EXIST number @value:1029,des:邮件不存在
---@field ERR_MAIL_ALREADY_READ number @value:1030,des:邮件已读
---@field ERR_MAIL_EXPIRE number @value:1031,des:邮件过期了
---@field ERR_MAIL_HAS_ITEM number @value:1032,des:邮件有附件
---@field ERR_MS_NOT_HAVE_MAIL_DATA number @value:1033,des:master没有邮件
---@field ERR_SWITCH_HAS_OPEN number @value:1034,des:开关处于开启状态
---@field ERR_EQUIP_CARD_HOLE_OVERLAP number @value:1035,des:插卡洞数超上限
---@field ERR_EQUIP_CARD_ID number @value:1036,des:无效卡ID
---@field ERR_EQUIP_CARD_NO_HOLE number @value:1037,des:配置最多0个洞，不可以插卡
---@field ERR_EQUIP_ITEM_LEVEL_FAILED number @value:1038,des:装备等级限制无
---@field ERR_EQUIP_CARD_NOT_IN_HOLE number @value:1039,des:装备卡片并不在洞中
---@field ERR_NO_THIS_ENTRYATTR number @value:1040,des:没有这个流派词条
---@field ERR_STALL_REFRESH_TOP_LIMIT number @value:1100,des:刷新已达上限
---@field ERR_STALL_SELL_ITEM_NOT_EXIST number @value:1101,des:物品不存在
---@field ERR_STALL_ITEM_SOLD_OUT number @value:1102,des:该物品已售罄
---@field ERR_STALL_ITEM_BUY_LIMIT number @value:1103,des:购买物品数量不够
---@field ERR_STALL_BUY_NUM_TOP_LIMIT number @value:1104,des:摊位已达上限
---@field ERR_STALL_ITEM_BUY_FREEZE number @value:1105,des:购买物品冻结
---@field ERR_STALL_ITEM_SELL_FREEZE number @value:1106,des:出售物品冻结
---@field ERR_STALL_INDEX_NOT_EXIST number @value:1107,des:摆摊索引不存在
---@field ERR_STALL_ITEM_CONF_NOT_EXIST number @value:1108,des:摆摊配置不存在
---@field ERR_STALL_ROLE_SELL_LOCKED number @value:1109,des:出售操作过于频繁，已冻结
---@field ERR_STALL_ITEM_SELL_PRICE_LIMIT number @value:1110,des:出售物品价格错误
---@field ERR_STALL_NEED_DRAW_MONEY number @value:1111,des:需先提现
---@field ERR_STALL_SELL_NOT_OUT_DATE number @value:1112,des:不能重现上架未超时道具
---@field ERR_STALL_SELL_NUM_FULL number @value:1113,des:出售格子已满
---@field ERR_STALL_ITEM_NOT_EXIST number @value:1114,des:出售的物品不存在
---@field ERR_STALL_ITEM_COUNT_LIMIT number @value:1115,des:出售的物品数量不足
---@field ERR_STALL_DRAW_MONEY_EMPTY number @value:1116,des:当前无可提取道具
---@field ERR_EQUIP_ENCHANT_HAS_NO_ATTR number @value:1117,des:附魔没属性
---@field ERR_STALL_SELL_BIND_ITEM number @value:1118,des:不能出售绑定道具
---@field ITEM_CANNOT_USE_CUR_SCENE number @value:1119,des:当前场景不能使用该道具
---@field AWARD_PREVIEW_ERRO_PREVIEW_TYPE number @value:1120,des:奖励预览不支持的预览类型
---@field ERRO_PARA_CHECK_FAILED number @value:1121,des:入参检测错误
---@field ERRO_GET_ROWDATA_FROM_TABLE_FAILED number @value:1122,des:从表中读取数据错误
---@field AWARD_PREVIEW_ERRO_LIMIT_GUDEG_FAILED number @value:1123,des:奖励预览限制检测失败
---@field ERR_BOLI_POINT_NOT_ENOUGH number @value:1124,des:波利点不足
---@field ERR_GIFT_TAKE_PRESENT_TIMES_FAILED number @value:1125,des:赠送者扣除赠送礼物次数失败
---@field ERR_GIFT_TAKE_RECIPIENT_TIMES_FAILED number @value:1126,des:接受者扣除受赠送礼物次数失败
---@field ERR_GIFT_CHECK_FRIEND_INTIMACY_FAILED number @value:1127,des:礼物赠送好友度限制
---@field ERR_GIFT_CHECK_ITEM_LIST_FAILED number @value:1128,des:礼物赠送商品列表检测失败
---@field ERR_GIFT_CHECK_ITEM_COUNT_FAILED number @value:1129,des:礼物赠送商品数量检测失败
---@field ERR_MS_NOT_HAVE_GIFT_LIMIT_DATA number @value:1130,des:master没有礼物赠送计数
---@field ERR_GIFT_GIVE_BIND_ITEM number @value:1131,des:不能赠送绑定道具
---@field ERR_GIFT_FRIEND_INTIMACY_LIMIT number @value:1132,des:好友度负一道具限制不能赠送
---@field ERR_SEVEN_LOGIN_REWARD_NOT_EXIST number @value:1133,des:奖励不存在
---@field ERR_SEVEN_LOGIN_REWARD_IS_GET number @value:1134,des:奖励已领取
---@field ERR_NOT_USE_POWERITEM number @value:1135,des:未使用增强道具精灵等
---@field ERR_VIRTUAL_ITEM_LACK_YUANQI number @value:1136,des:缺少元气值
---@field ERR_LIFE_SKILL_RECIPE_ERROR number @value:1137,des:生活技能recipe错误
---@field ERR_LIFE_SKILL_CANT_USE number @value:1138,des:生活技能不允许使用
---@field ERR_LIFE_SKILL_TYPE_CHANGE_FAILED number @value:1139,des:生活技能转换失败
---@field ERR_LIFE_SKILL_CONFIG_ERROR number @value:1140,des:生活技能配置错误
---@field ERR_LIFE_SKILL_RECIPE_CONFIG_ERROR number @value:1141,des:生活技能recipe错误
---@field ERR_LIFE_SKILL_IEGAL number @value:1142,des:生活技能不是合法的
---@field ERR_LIFE_SKILL_STRUCT_ERROR number @value:1143,des:生活技能错误
---@field ERR_LIFE_SKILL_NO_LEFT_TIME number @value:1144,des:生活技能没有剩余次数
---@field ERR_LIFE_SKILL_ADD_TIME_FAILED number @value:1145,des:添加次数失败
---@field ERR_LIFE_SKILL_ITEMCHANGE_FAILED number @value:1146,des:生活技能无法获取改变道具原因
---@field ERR_LIFE_SKILL_YUANQI_CONFIG_ERROR number @value:1147,des:生活技能配置元气消耗不正确
---@field ERR_LIFE_SKILL_CREATE_NULL number @value:1148,des:生活技能打造不为空
---@field ERR_COLLECTION_SYSTEM_NOT_OPEN number @value:1149,des:采集功能没有开放
---@field ERR_SYSTEM_NOT_OPEN number @value:1150,des:系统未开放
---@field ERR_COLLECTION_DAILYCOUNT_LIMIT number @value:1151,des:采集日常活动次数达上限
---@field ERR_DAILY_ACTIVITY_NOT_EXIST number @value:1152,des:日常活动不存在
---@field ERR_LUA_SCRIPT_NOT_EXIST number @value:1153,des:lua脚本不存在
---@field ERR_LUA_SCRIPT_EXECUTE_FAILED number @value:1154,des:lua脚本执行失败
---@field ERR_NEED_EXTRA_BAG number @value:1155,des:需要更多背包格子
---@field ERR_TARGET_SCENE_CANNOT_FOLLOW number @value:1156,des:目标场景无法跟随
---@field ERR_TEAM_SHOUT_CD number @value:1157,des:组队喊话CD
---@field ERR_FOLLOW_OUT_DUNGEON_NOT_PERMMITED number @value:1158,des:不允许跟随副本外的玩家
---@field ERR_TEAM_MVP_AWARD_LIMIT number @value:1159,des:MVP团队奖励次数已达上限
---@field ERR_KILL_MVP_AWARD_LIMIT number @value:1160,des:最后一击奖励次数已达上限
---@field ERR_MINI_DROP_LIMIT number @value:1162,des:mini拾取奖励次数已达上限
---@field ERR_MVP_DROP_LIMIT number @value:1163,des:mvp拾取奖励次数已达上限
---@field ERR_MVP_POINTS_AWARD_LIMIT number @value:1164,des:mvp积分奖励次数已达上限
---@field ERR_BATTLEFIELD_MATCHED_SUCCESS number @value:1165,des:战场匹配成功
---@field ERR_DAILY_ACTIVITY_NOT_OPEN number @value:1166,des:每日活动未开放
---@field ERR_DIG_TREASURE_BAG_FULL number @value:1167,des:
---@field ERR_NO_THIS_EQUIP_TYPE number @value:1168,des:没有此装备类型
---@field ERR_GUILD_KICK_MEMBER_NEED_MONEY number @value:1169,des:公会踢人需要元气
---@field ERR_IS_ALREADY_OPEN_BLESS number @value:1170,des:祝福已经开启
---@field ERR_IS_ALREADY_CLOSE_BLESS number @value:1171,des:祝福已经关闭
---@field ERR_BLESS_TIME_IS_ZERO number @value:1172,des:祝福剩余时间为0了
---@field ERR_NEED_RIDER_SKILL number @value:1173,des:需要学会骑乘术才能装备
---@field ERR_BAG_SPACE_TO_RESET_SKILL number @value:1174,des:背包已满，技能相关装备无法卸除，不能重置技能
---@field BAG_EXTRA_SPACE_NEED number @value:1175,des:背包需要额外%d个格子
---@field ERR_BAG_SORT_CD number @value:1176,des:整理背包cd
---@field ERR_CHAT_SCENE_CD_LIMIT number @value:1177,des:频道聊天CD限制
---@field ERR_CHAT_WORLD_LEVEL_LIMIT number @value:1178,des:世界聊天等级限制
---@field ERR_CHAT_WORLD_CD_LIMIT number @value:1179,des:世界聊天CD限制
---@field ERR_CHAT_GUILD_CD_LIMIT number @value:1180,des:公会聊天CD限制
---@field ERR_CHAT_TEAM_CD_LIMIT number @value:1181,des:队伍聊天CD限制
---@field ERR_CHAT_TYPE_UNSUPPORT number @value:1182,des:不支持的聊天类型
---@field ERR_ROLE_BAN number @value:1183,des:角色被封禁
---@field ERR_CANNOT_USE_DURING_TRANSFIGURED number @value:1184,des:变身状态下不能使用该物品
---@field ERR_EQUIP_POS_WRONG number @value:1185,des:装备不能装在这个位置
---@field ERR_SHOP_ITEM_CANT_SELL number @value:1186,des:商品不能在该商店售卖
---@field ERR_IS_IN_BATTLE_VEHICLE number @value:1187,des:玩家处于战斗载具状态
---@field ERR_INVATE_TEAM_ACT_LEVEL_LIMIT number @value:1188,des:该队伍当前参与的活动与您等级区间不匹配，申请失败
---@field ERR_JOIN_TEAM_ACT_LEVEL_LIMIT number @value:1189,des:您邀请的玩家与当前活动等级区间不匹配，邀请失败
---@field ERR_IS_OTHER_IN_VEHICLE number @value:1190,des:对方在载具中
---@field ERR_TRADE_SELL_ITEM_NOT_EXIST number @value:1200,des:出售物品不存在
---@field ERR_TRADE_SELL_BIND_ITEM number @value:1201,des:不能出售绑定道具
---@field ERR_TRADE_SELL_ITEM_PRICE number @value:1202,des:出售物品价格错误
---@field ERR_STALL_SELL_CANCEL_ITEM_NOT_EXIST number @value:1203,des:物品已下架
---@field ERR_EQUIP_ALREADY_WEARED number @value:1204,des:装备已经在身上了
---@field ERR_CANNOT_USE_SERVER_LEVEL_LIMIT number @value:1205,des:已经达到服务器等级上限不能用
---@field ERR_DIR_SEND_SCENE_FAILED number @value:1206,des:发送至指定场景失败
---@field ERR_DIR_TELEPORT_MAP number @value:1207,des:检测直接传送地图失败
---@field ERR_DIR_TELEPORT_CONSUME number @value:1208,des:检测消耗失败
---@field ERR_DIR_TELEPORT_NPCS number @value:1209,des:检测NPC失败
---@field ERR_NOT_ENOUGH_INTIMACY number @value:1210,des:好感度不够
---@field ERR_NOT_ENOUGH_BASE_LEVEL number @value:1211,des:base等级不够
---@field ERR_SCENE_NOT_ALLOW number @value:1212,des:场景不允许
---@field ERR_VIEW_NOT number @value:1213,des:不在视野范围内
---@field ERR_DISTANCE_NOT_ALLOW number @value:1214,des:距离不允许
---@field ERR_A_STATE_NOT_ALLOW number @value:1215,des:你的状态不允许
---@field ERR_B_STATE_NOT_ALLOW number @value:1216,des:对方状态不允许
---@field ERR_LAST_APPLY_EXIST number @value:1217,des:上个请求存在
---@field ERR_AGREE_TIME_OUT number @value:1218,des:回复时间已超时
---@field ERR_OTHER_NOT_ENOUGH_BASE_LEVEL number @value:1219,des:对方BASE等级不够
---@field ERR_MOB_RELEASE_INVALID_TIP number @value:1220,des:召唤兽释放失败提示
---@field ERR_COMPOUND_ITEM_NOT_EXIST number @value:1221,des:合成的道具在表中不存在
---@field ERR_GUILD_PERMISSION_NAME_TOO_SHORT number @value:1230,des:公会权限名过短
---@field ERR_GUILD_PERMISSION_NAME_TOO_LONG number @value:1231,des:公会权限名过长
---@field ERR_GUILD_PERMISSION_NAME_FORBID number @value:1232,des:公会权限名敏感词
---@field ERR_USER_INPUT_INVAILD number @value:1233,des:输入内容不合法
---@field ERR_DOUBLEACTIONCLIP_STATEMACHINE_LIMIT number @value:1234,des:双人交互动作转移失败
---@field ERR_GUILD_BUILDING_ALREADY_MAX_LEVEL number @value:1235,des:公会建筑已满级
---@field ERR_LACK_GUILD_MONEY number @value:1236,des:公会资金不足
---@field ERR_GUILD_RELY_OTHER number @value:1237,des:依赖建筑等级不足
---@field ERR_GUILD_ANOTHER_IS_BUILDING number @value:1238,des:有其它建筑正在升级
---@field ERR_GUILD_UPGRADE_ALREADY_FINISH number @value:1239,des:该建筑升级已完成
---@field ERR_GUILD_SELF_HAD_BUILT number @value:1240,des:已参与过本次建设
---@field ERR_IS_IN_DOUBLE_ACTION number @value:1241,des:在双人交互中
---@field ERR_MATERIAL_UNSUPPORT_MECHANT number @value:1242,des:材料不支持置换
---@field ERR_NEED_LERAN_SKILL number @value:1243,des:需要学习技能及等级
---@field ERR_GET_ROWDATA_FROM_TABLE_FAILED number @value:1244,des:读策划表出错
---@field ERR_MAKE_MATERIALS_NUM_LIMIT number @value:1245,des:置换材料单次限制
---@field ERR_PLATFORM_MATCHED_SUCCESS number @value:1246,des:擂台匹配成功
---@field ERR_PLATFORM_MATCHED_FAIL number @value:1247,des:擂台匹配失败
---@field ERR_PLATFORM_MATCHED_NEXT_FLOOR number @value:1248,des:擂台直接进入下一轮
---@field ERR_EQUIP_NO_ENCHANT_BEFORE number @value:1249,des:装备没有附魔，无法提炼
---@field ERR_NOT_CARD_TYPE number @value:1250,des:没有此卡片类型
---@field ERR_CARD_TIME_NOT_ENOUGH number @value:1251,des:抽卡次数不足
---@field CARD_AWARD_NOT_EXIST number @value:1252,des:卡片奖池不存在
---@field ERR_GUILD_GIVE_ITEM_ID_ERROR number @value:1253,des:上交的物品id错误
---@field ERR_GUILD_HAS_NOT_WELFARE number @value:1254,des:刚创建的公会，不存在上周福利
---@field ERR_GUILD_MEMBER_JOIN_TIME_TOO_LATE number @value:1255,des:玩家加入公会时间过晚，不能领取福利
---@field ERR_GUILD_MEMBER_WELFARE_ALREADY_AWARD number @value:1256,des:公会福利已经领取过了
---@field ERR_TROLLEY_CONDITION number @value:1257,des:手推车条件不足
---@field ERR_NOT_THIS_TROLLEY number @value:1258,des:没有这个手推车
---@field ERR_GUILD_DINNER_NOT_START number @value:1270,des:公会宴会未开始
---@field ERR_GUILD_DINNER_COOK_RANK_NOT_GENERATE number @value:1271,des:公会烹饪菜单未生成
---@field ERR_GUILD_DINNER_GUILD_NOT_OPEN number @value:1272,des:该公会未开启宴会
---@field ERR_GUILD_DINNER_TASK_NOT_EXIST number @value:1273,des:公会宴会任务不存在
---@field ERR_GUILD_DINNER_TASK_HAS_ACCEPTED number @value:1274,des:公会宴会任务已被别人接受
---@field ERR_GUILD_DINNER_NOT_IN_SCENE number @value:1275,des:不在公会宴会场景
---@field ERR_GUILD_DINNER_DISH_NPC_NOT_EXIST number @value:1276,des:公会宴会菜不存在
---@field ERR_GUILD_DINNER_EAT_DISH_COUNT_LIMIT number @value:1277,des:吃菜已达上限
---@field ERR_GUILD_DINNER_COOKING_NPC_NOT_EXIST number @value:1278,des:烹饪npc不存在
---@field ERR_GUILD_DINNER_EAT_NOT_OPEN number @value:1279,des:未到吃菜时间
---@field ERR_GUILD_DINNER_NOT_IN_COOK_STATE number @value:1280,des:公会宴会不在烹饪状态
---@field ERR_GUILD_DINNER_GUILD_LIMIT number @value:1281,des:公会未达到宴会开启条件
---@field ERR_GUILD_DINNER_NOT_IN_SAME_GUILD number @value:1282,des:不在同一个公会
---@field ERR_VIRTUAL_ITEM_LACK_CONTRIBUTE number @value:1283,des:公会贡献度不够
---@field ERR_TASK_GIVEUP_GUILD_CHANGE number @value:1284,des:公会变更删除任务
---@field ERR_BAG_MAX_LOAD number @value:1285,des:背包负重已达上限
---@field ERR_CART_MAX_LOAD number @value:1286,des:手推车负重已达上限
---@field ERR_CART_FULL number @value:1287,des:手推车已经满了
---@field ERR_CANNOT_STORE_CART number @value:1288,des:不能放入手推车
---@field ERR_UNLOCK_MAX_TIMES number @value:1289,des:解锁已经达到最大上限
---@field ERR_NOT_IN_SAME_PVP_WAITING_SCENE number @value:1290,des:不在同一pvp等候场景
---@field ERR_BATTLEFIELD_ALREADY_IN_MATCH_DEQUE number @value:1291,des:已经在战场匹配队列中
---@field ERR_DOUBLE_ACTION_LOGOUT number @value:1292,des:双人动作的一方登出时，给另一方发通知
---@field ERR_ROLE_ALREADY_CHANAGE_NAME number @value:1293,des:角色已经取过名字了
---@field ERR_ROLE_NOT_CHANGE_NAME number @value:1294,des:角色还没有取名
---@field ERR_GUILD_DINNER_MENU_EMPTY number @value:1295,des:公会宴会菜单为空
---@field ERR_ORNA_TIME_NOT_ENOUGH number @value:1296,des:抽头饰次数不足
---@field ERR_MAKE_DEVICE_FAILED number @value:1297,des:制作置换器概率失败
---@field ERR_DEVICE_USE_TYPE_ERROR number @value:1298,des:置换器使用类型错误
---@field ERR_REFINE_TRANSFER_LEVEL_ZERO number @value:1299,des:原装备精炼等级为0
---@field ERR_REFINE_TRANSFER_LEVEL_NOT_ZERO number @value:1300,des:新装备精炼等级不为0
---@field ERR_REFINE_TRANSFER_LEVEL_NOT_MATCH number @value:1301,des:新装备等级小于原装备等级
---@field ERR_REFINE_TRANSFER_PROFESSION_NOT_MATCH number @value:1302,des:新装备和原装备职业不相同
---@field ERR_REFINE_TRANSFER_EQUIPID_NOT_MATCH number @value:1303,des:新装备和原装备部位不同
---@field ERR_REFINE_TRANSFER_HAD_BE_SEAL number @value:1304,des:原装备被封印
---@field ERR_REFINE_HAD_BE_SEAL number @value:1305,des:装备被封印
---@field ERR_EQUIP_UNLOCK_BUT_NO_SEAL number @value:1306,des:解封一个没被封印的装备
---@field ERR_SHOP_LACK_GUILD_BUILD_LEVEL number @value:1307,des:公会建筑等级不够
---@field ERR_CANNOT_USE_CUR_ACTION number @value:1308,des:当前动作下不能用
---@field ERR_EASYNAV_Y_ERROR number @value:1309,des:便捷寻路:目标点的y轴坐标获取失败
---@field ERR_EASYNAV_BIGTYPE number @value:1310,des:便捷寻路:寻路方式错误bigtype参数不正确
---@field ERR_TASK_TEAMMEMBER_CANT_TAKE number @value:1311,des:队友无法接受任务
---@field ERR_TASK_GUILD_FAILED number @value:1312,des:公会任务失败删除
---@field ERR_TASK_TIMEOUT number @value:1313,des:任务超时
---@field ERR_PVE_TASK_COUNT_LIMIT number @value:1314,des:同时不能接取太多哟
---@field ERR_EASYNAV_FORBID_DYNAMIC_SCENE number @value:1315,des:动态地图不允许寻路
---@field ERR_VIRTUAL_ITEM_LACK_ARENA_COIN number @value:1316,des:缺少擂台币
---@field ERR_TASK_EDEN_ALREADY_GIVEUP number @value:1317,des:Eden任务已经放弃过
---@field ERR_TASK_ACCEPT_DURING_CD number @value:1318,des:任务接取处于CD时间
---@field ERR_NOT_IN_TRANSFIGURE number @value:1319,des:不在变身状态
---@field ERR_CAT_TRADE_REWARD_IS_GET number @value:1330,des:猫手商会奖励已经领取
---@field ERR_CAT_TRADE_IS_NOT_FULL number @value:1331,des:猫手商会未完成
---@field ERR_CAT_TRAIN_ID_INVALID number @value:1332,des:猫手商会火车id不存在
---@field ERR_CAT_SEAT_ID_INVALID number @value:1333,des:猫手商会座位不存在
---@field ERR_CAT_SEAT_IS_FULL number @value:1334,des:猫手商会座位已放满
---@field ERR_HERO_CHALLENGE_REFRESH number @value:1335,des:通知英雄挑战刷新
---@field ERR_SUPER_MEDAL_CANNOT_SET_ADCANCE number @value:1336,des:神圣勋章不能设置进阶
---@field ERR_GENERAL_MEDAL_CANNOT_SET_ADCANCE number @value:1337,des:光辉勋章不能主动激活
---@field ERR_GENERAL_MEDAL_CANNOT_UPGRADE number @value:1338,des:光辉勋章不能主动升级
---@field ERR_GENERAL_MEDAL_CANNOT_RESET_ATTR number @value:1339,des:光辉勋章不能设置流派属性种类
---@field ERR_CANNOT_FIND_MEDAL number @value:1340,des:找不到该勋章信息
---@field ERR_CANNOT_FIND_MEDAL_CONFIG number @value:1341,des:找不到勋章配置
---@field ERR_MEDAL_ACTIVE_BASE_LEVEL_LACK number @value:1342,des:激活需要的base等级不够
---@field ERR_MEDAL_ACTIVE_GENERAL_LEVEL_LACK number @value:1343,des:激活需要的特定勋章等级不够
---@field ERR_MEDAL_ALREADY_MAX_LEVEL number @value:1344,des:勋章当前已经是最高级了
---@field ERR_MEDAL_CONFIG_ERROR number @value:1345,des:勋章配置有问题
---@field ERR_MEDAL_ALREADY_ACTIVE number @value:1346,des:勋章已经激活了
---@field ERR_VIRTUAL_ITEM_LACK_PRESTIGE number @value:1347,des:声望不够
---@field ERR_REPEAT_CLICK number @value:1348,des:重复点击
---@field ERR_ELITE_MONSTER_REACH_LIMIT number @value:1349,des:击杀已经到上限
---@field ERR_ELITE_MONSTER_OVER_LIMIT number @value:1350,des:击杀已经超过上限
---@field ERR_TEAM_IN_MATCHING number @value:1351,des:队伍正在比赛中
---@field ERR_WAREHOUSE_SORT_CD number @value:1352,des:仓库整理cd
---@field ERR_TASK_TEAMMATE_TOOFAR number @value:1353,des:队友太远
---@field ERR_TASK_TEAMMATE_NOT_IN_SCENE number @value:1354,des:队友不在这场景里
---@field ERR_ENTER_DUNGEONS_TEAM_MEMBER_CHECK number @value:1355,des:队员踩到触发器无效提示
---@field ERR_TEAM_PIPEI_FULL number @value:1356,des:已经达到匹配人数上线
---@field ERR_DRIVER_NOT_IN_MY_SCENE number @value:1357,des:主驾不在此场景
---@field ERR_PASSENGER_NOT_IN_MY_SCENE number @value:1358,des:乘客不在此场景
---@field ERR_ITEM_CANNOT_USE_JOB_LEVEL_FULL number @value:1359,des:物品不能使用job等级满了
---@field ERR_TASK_NEED_THREE_TEAM number @value:1360,des:组队3人以上才能进行
---@field ERR_TASK_ALREADY_FINISHED_PLEASE_CONTINUE number @value:1361,des:你已经完成此奇闻任务，可以协助队友完成此任务
---@field ERR_TASK_ALREADY_EXISTED_PLEASE_CONTINUE number @value:1362,des:你已经接取了此奇闻任务，请和队友一起继续完成
---@field ERR_ITEM_NOT_USE_MEMBER_TOO_FAR number @value:1363,des:队友位置过远
---@field ERR_TEAM_SIZE_WRONG number @value:1364,des:队伍成员数不对
---@field ERR_CANNNOT_USE_CUR_STATE number @value:1365,des:当前状态不能使用
---@field ERR_QUERY_ROLEID_FAILED number @value:1366,des:请求roleid失败
---@field ERR_TEAM_TARGET_CAPTAIN_NOT_ONLINE number @value:1367,des:目标队伍队长不在线
---@field ERR_TARGET_DUNGEON_NOT_PASSED number @value:1368,des:还没有通关前一层
---@field ERR_CAPTAIN_STATUS_CHANGED number @value:1369,des:队长状态发生了变化
---@field ERR_DUNGEON_NEED_NOT_MEET number @value:1370,des:不符合副本进入条件
---@field ERR_DUNGEON_FULL number @value:1371,des:副本人数已经满了
---@field ERR_WHITE_OPERATE number @value:1372,des:白名单操作失败
---@field ERR_GUILD_MAIL_CONTENT_TOO_SHORT number @value:1373,des:内容为空
---@field ERR_GUILD_MAIL_CONTENT_TOO_LONG number @value:1374,des:内容过长
---@field ERR_GUILD_MAIL_SEND_COST_FAILD number @value:1375,des:元气不足，无法群发信息
---@field ERR_GUILD_INVITE_OTHER_OFFLINE number @value:1376,des:对方不在线
---@field ERR_GUILD_INVITE_OTHER_SYSTEM_NOT_OPEN number @value:1377,des:对方公会模块未开启
---@field ERR_GUILD_OTHER_IN_GUILD number @value:1378,des:对方已在公会
---@field ERR_STALL_SELL_SERVER_LEVEL_LIMIT number @value:1379,des:出售物品服务器等级不够
---@field ERR_COST_DIAMOND_IS_NEGATIVE number @value:1380,des:消耗钻石为负数
---@field ERR_LACK_DIAMOND number @value:1381,des:钻石不够
---@field ERR_BUY_GOOD_BILLNO_NOT_EXIST number @value:1382,des:直购订单号不存在
---@field ERR_IN_AUTO_FISHING number @value:1383,des:自动钓鱼状态不能执行手动钓鱼操作
---@field ERR_DRIVER_NOT_IN_VEHICLE number @value:1384,des:主驾不在载具上
---@field ERR_CHAT_MSG_TOOSHORT number @value:1385,des:聊天内容太短
---@field ERR_CHAT_MSG_TOOLONG number @value:1386,des:聊天内容太长
---@field ERR_POSTCARD_IS_TAKED number @value:1387,des:萌新手册奖励已领取
---@field ERR_MEDAL_ACTIVE_TASK_NOT_FINISH number @value:1388,des:激活任务条件未达成
---@field ERR_MEDAL_ACTIVE_SUM_GENERAL_LEVEL_LACK number @value:1389,des:激活需要的总的光辉勋章等级不够
---@field ERR_MEDAL_ACTIVE_ACHIEVEMENT_NOT_FINISH number @value:1390,des:激活需要成就未达成
---@field ERR_SHOP_DISTANCE_NOT_ENOUGH number @value:1391,des:商店距离太远
---@field ERR_DROPBUFF_NOT_FOUND number @value:1392,des:掉落buff未发现
---@field ERR_DROPBUFF_TAKE_FAILED number @value:1393,des:掉落buff拾取失败
---@field ERR_GUILD_CRYSTAL_NOT_EXIST number @value:1400,des:水晶不存在
---@field ERR_GUILD_CRYSTAL_LEVEL_CONF_NOT_EXIST number @value:1401,des:公会水晶等级配置不存在
---@field ERR_GUILD_CRYSTAL_LEVEL_TOP_LIMIT number @value:1402,des:公会水晶已达最大等级
---@field ERR_GUILD_CRYSTAL_BUILD_LIMIT number @value:1403,des:公会建筑等级不足
---@field ERR_GUILD_CRYSTAL_UPGRADE_BUILD_LIMIT number @value:1404,des:公会水晶升级建筑等级不足
---@field ERR_GUILD_CRYSTAL_UPGRADE_TOTAL_LEVEL_LIMIT number @value:1405,des:公会水晶升级总等级不足
---@field ERR_GUILD_CRYSTAL_QUICK_UPGRADE_COUNT_LIMIT number @value:1406,des:华丽水晶快速升级次数不足
---@field ERR_GUILD_CRYSTAL_QUICK_UPGRADE_LOCK number @value:1407,des:水晶快速升级系统繁忙
---@field ERR_GUILD_CRYSTAL_GIVE_ENERGY_LOCK number @value:1408,des:公会水晶充能系统繁忙
---@field ERR_GUILD_CRYSTAL_GIVE_ENERGY_FREE_COUT_LIMIT number @value:1409,des:公会水晶免费充能次数不足
---@field ERR_GUILD_CRYSTAL_NOT_OPEN number @value:1410,des:公会水晶未开启
---@field ERR_GUILD_CRYSTAL_PRAY_TRANSFIGURED number @value:1411,des:变身状态不能祈福
---@field ERR_IN_ZERO_PROFIT_STATUS number @value:1412,des:处于零收益状态
---@field ERR_SERVER_CUSTOM_ERR number @value:1413,des:服务器自定义的错误文本
---@field ERR_ROOM_CODE_WRONG number @value:1414,des:聊天室密码错误
---@field ERR_ROOM_NOT_EXIST number @value:1415,des:房间不存在
---@field ERR_ROOM_NOT_CAPTAIN number @value:1416,des:不是聊天室房主
---@field ERR_ROOM_ALREADY_IN_ROOM number @value:1417,des:角色已经处于聊天室中
---@field ERR_ROOM_ALREADY_IN_OTHER_ROOM number @value:1418,des:角色处于其他聊天室中
---@field ERR_ROOM_KICK_SELF number @value:1419,des:不能自己踢自己
---@field ERR_ROOM_NOT_IN_TARGET_ROOM number @value:1420,des:不在目标房间中
---@field ERR_ROOM_ALREADY_CAPTAIN number @value:1421,des:已经是房主
---@field ERR_CANNNOT_USE_DURING_CHATROOM number @value:1422,des:聊天室中不可使用
---@field ERR_ROOM_ALREADY_IN_STATUS number @value:1423,des:状态已经是设置的状态
---@field ERR_ROOM_NAME_TOO_SHORT number @value:1424,des:聊天室名字太短
---@field ERR_ROOM_NAME_TOO_LONG number @value:1425,des:聊天室名字太长
---@field ERR_ROOM_NAME_HAVE_FORBID_WORD number @value:1426,des:聊天室包含违禁词
---@field ERR_ROOM_MEMSIZE_OVER_CAPACITY number @value:1427,des:聊天室人数超过容量
---@field ERR_ROOM_CODE_OVER_MAXLEN number @value:1428,des:聊天室密码过长
---@field ERR_ROOM_CODE_ILLEGAL_CHAR number @value:1429,des:聊天室密码有非法字符
---@field ERR_ROOM_IN_KICK_CD number @value:1430,des:处于被踢CD中
---@field ERR_ROOM_IN_TRYCODE_CD number @value:1431,des:处于密码试错CD中
---@field ERR_TASK_WRONG_SUB_TASK number @value:1432,des:错误的子任务id
---@field ERR_FAR_FROM_NPC number @value:1433,des:离npc过远
---@field ERR_CHAT_FORBID_TALK number @value:1434,des:聊天被禁止发言
---@field ERR_DELEGATE_IN_ACTIVITY number @value:1435,des:委托任务已经接取
---@field ERR_DELEGATE_NOT_IN_ACTIVITY number @value:1436,des:委托任务还没有接取
---@field ERR_DELEGATE_FINISHED number @value:1437,des:委托任务已经完成
---@field ERR_DELEGATE_MONEY_NOT_ENOUGH number @value:1438,des:委托任务货币不足
---@field ERR_DELEGATE_NOT_EXIST number @value:1439,des:委托任务不存在
---@field ERR_DELEGATE_DOMINION_UPPER_LIMIT number @value:1440,des:势力委托任务已达接取上限
---@field ERR_ALREADY_RECEIVED_REWARD number @value:1441,des:奖励已经领取了
---@field ERR_REFINE_TYPE_NOT_EXIST number @value:1442,des:精炼类型不存在
---@field ERR_IS_IN_CHAT_ROOM number @value:1443,des:玩家在聊天室状态
---@field ERR_ROOM_STATE_ENTER_FAILED number @value:1444,des:当前状态不能进入聊天室
---@field ERR_VIRTUAL_ITEM_LACK_ASSIST_POINT number @value:1445,des:缺少协同点
---@field ERR_ASSIST_DAY_LIMIT number @value:1446,des:协同之证日获取上限
---@field ERR_ASSIST_WEEK_LIMIT number @value:1447,des:周获取上限
---@field ERR_ACCOUNT_STATE_NOT_IN_LOBBY number @value:1448,des:游戏帐号不在大厅
---@field ERR_ROLE_ALREADY_DELETE number @value:1449,des:角色已经被删除
---@field ERR_ROLE_IS_NORMAL number @value:1450,des:角色处于正常状态，不能被恢复
---@field ERR_ROLE_IS_NOT_NORMAL number @value:1451,des:角色处于非正常状态，不能被删除
---@field ERR_MS_NOT_HAVE_ROLE_ACCOUNT_DATA number @value:1452,des:没找到帐号信息
---@field ERR_ROLE_IS_DELETED number @value:1453,des:角色已经被删除
---@field ERR_ROLE_IS_ONLINE number @value:1454,des:玩家在线，不能被删除
---@field ERR_BAG_FULL_TASK_ITEM_DROP number @value:1455,des:背包空间不足无法继续获得任务道具
---@field ERR_THIRTY_SIGN_AWARD_ALREADY_GET number @value:1456,des:三十次签到当日奖励已经领取
---@field ERR_THIRTY_SIGN_AWARD_ID_NOT_EXIST number @value:1457,des:三十次签到当日奖励ID不存在
---@field ERR_THIRTY_SIGN_BAG_FULL number @value:1458,des:背包满请清理
---@field ERR_DO_ENTER_SCENE_FAIL number @value:1459,des:进场景失败
---@field ERR_ACHIEVEMENT_ITEM_REWARD_GET number @value:1470,des:成就奖励已领取
---@field ERR_ACHIEVEMENT_NOT_EXIST number @value:1471,des:成就不存在
---@field ERR_ACHIEVEMENT_NOT_COMPLETE number @value:1472,des:成就未完成
---@field ERR_ACHIEVEMENT_POINT_REWARD_NOT_EXIST number @value:1473,des:成就点奖励不存在
---@field ERR_ACHIEVEMENT_POINT_REWARD_NOT_FINISH number @value:1474,des:成就点奖励未完成
---@field ERR_ACHIEVEMENT_POINT_REWARD_IS_GET number @value:1475,des:成就点奖励已领取
---@field ERR_INVALID_ATTR_CHOOSE number @value:307,des:
---@field ERR_OTHER_IS_IN_DEAD_STATUS number @value:1476,des:乘客处于死亡状态
---@field ERR_STICKER_NOT_HAVE number @value:1477,des:贴纸未拥有
---@field ERR_GRID_POS number @value:1478,des:格子位置错误
---@field ERR_GRID_UNLOCKED number @value:1479,des:格子已经解锁
---@field ERR_CANNOT_CHANGE_DIAMOND number @value:1480,des:禁止通过次级货币通道修改钻石数量
---@field ERR_GUILD_GIFT_NOT_ENOUGH number @value:1485,des:公会礼盒数量不足
---@field ERR_GUILD_GIFT_HAS_RECEIVED number @value:1486,des:已领取公会礼盒
---@field ERR_GUILD_GIFT_RECV_JOIN_TIME number @value:1487,des:进入公会时间不足
---@field ERR_ON_RIDE_CANNOT_USE number @value:1488,des:坐骑状态不能使用
---@field ERR_ROLE_ALREADY_EXIST number @value:1489,des:角色已存在
---@field ERR_INSERT_CARD_POS number @value:1491,des:插卡位置错误
---@field ERR_REFORGE_POS number @value:1492,des:重铸位置错误
---@field ERR_NO_THEME_DUNGEON_WEEK_AWARD number @value:1493,des:当前没有主题副本周奖励
---@field ERR_THEME_DUNGEON_WEEK_AWARD_WAIT number @value:1494,des:请等下周某某时间再来领取
---@field ERR_TRADE_ITEM_NOT_NOTICE number @value:1495,des:非公示物品不能被关注
---@field ERR_TRADE_IN_FORBID_SELL_TIME number @value:1496,des:在禁止出售时间段出售物品
---@field ERR_TRADE_IN_FORBID_BUY_TIME number @value:1497,des:在禁止购买时间段购买物品
---@field ERR_TRADE_FOLLOW_LIMIT number @value:1498,des:关注已达上限
---@field ERR_TRADE_BUY_ITEM_KIND_LIMIT number @value:1499,des:预购物品种类超出上限
---@field ERR_QUERY_GATEIP_FAILED number @value:1500,des:请求gateip失败
---@field ERR_GUILD_STONE_NO_EXIST number @value:1501,des:不存在的公会原石
---@field ERR_GUILD_HELP_CD number @value:1502,des:求助CD中
---@field ERR_STONE_HELP_TIMES_OUT number @value:1503,des:帮助雕刻原石次数已用完
---@field ERR_STONE_CARVE_OVER number @value:1504,des:原石已经雕刻完成了
---@field ERR_CARVE_STONE_LIMIT number @value:1505,des:每天雕刻次数到上限了
---@field ERR_CARVE_LINK_INVALID number @value:1506,des:雕刻求助链接已经失效
---@field ERR_MEDAL_ITEMTABLE_ERROR number @value:1507,des:获取表失败
---@field ERR_FASHION_EVA_NOT_OPEN_NOW number @value:1508,des:时尚评分尚未开始
---@field ERR_CANT_FIND_ROLE_FASHION_SCORE number @value:1509,des:没有玩家时尚评分数据
---@field ERR_FASHION_EVA_TIMES_TOP_LIMIT number @value:1510,des:今日时尚评分次数已达上限
---@field ERR_FASHION_EVA_SCORE_FAILED number @value:1511,des:时尚评分失败
---@field ERR_MS_NOT_HAVE_ROLE_COUNTER_DATA number @value:1512,des:没有玩家counter信息
---@field ERR_GUILD_HUNT_IS_START number @value:1520,des:公会狩猎已开始
---@field ERR_GUILD_HUNT_NOT_IN_OPEN_TIME number @value:1521,des:公会狩猎不在开启时间
---@field ERR_GUILD_HUNT_OPEN_CD_LIMIT number @value:1522,des:公会狩猎开启cd限制
---@field ERR_GUILD_HUNT_OPEN_COUNT_LIMIT number @value:1523,des:公会狩猎开启次数不够
---@field ERR_GUILD_HUNT_NOT_OPEN number @value:1524,des:公会狩猎未开始
---@field ERR_GUILD_HUNT_CLOSED number @value:1525,des:公会狩猎已结束
---@field ERR_GUILD_HUNT_QUIT_TIME_LIMIT number @value:1526,des:公会狩猎上次离开公会时间不足
---@field ERR_GUILD_HUNT_JOIN_TIME_LIMIT number @value:1527,des:公会狩猎加入时间不足
---@field ERR_GUILD_HUNT_REWARD_COUNT_LIMIT number @value:1528,des:公会狩猎奖励次数不足
---@field ERR_GUILD_HUNT_NOT_IN_SAME_GUILD number @value:1529,des:有队员不在同一公会
---@field ERR_GUILD_HUNT_TEAM_MEMBER_QUIT_TIME_LIMIT number @value:1530,des:队员离开公会时间限制
---@field ERR_GUILD_HUNT_TEAM_MEMBER_JOIN_TIME_LIMIT number @value:1531,des:队员加入公会时间限制
---@field ERR_GUILD_HUNT_DUNGEON_NOT_EXIST number @value:1532,des:公会狩猎副本不存在
---@field ERR_GUILD_HUNT_NOT_REWARD_TIME number @value:1533,des:未到领奖时间
---@field ERR_GUILD_HUNT_NOT_FINISHED number @value:1534,des:公会狩猎未完成
---@field ERR_GUILD_HUNT_NOT_REACH_REWARD_CONDITION number @value:1535,des:未达到领奖条件
---@field ERR_GUILD_HUNT_IS_GET_FINAL_REWARD number @value:1536,des:已领取最终奖励
---@field ERR_GUILD_HUNT_REWARD_IS_FULL number @value:1537,des:本次活动奖励已达上限，后续参与只给积分，将不会获得其他奖励
---@field ERR_GUILD_HUNT_SCORE_IS_FULL number @value:1538,des:本次活动获得积分次数已达上限
---@field ERR_GUILD_HUNT_REWARD_FULL_NOTICE number @value:1539,des:你本周奖励次数已满，无法获得战斗奖励
---@field ERR_GUILD_INVITE_NOT_EXIST number @value:1540,des:公会邀请已失效
---@field ERR_TRANSFIGURE_CAN_COLLECT number @value:1541,des:某些采集物在变身状态下无法采集
---@field ERR_DELEGATE_NOT_REFRESH number @value:1542,des:委托未刷新
---@field ERR_DELEGATE_COST_NOT_ENOUGH number @value:1543,des:委托证明消耗不足
---@field ERR_GUILD_BINDING_REMIND_LACK_COUNT number @value:1544,des:提醒公会绑群次数不足
---@field ERR_GUILD_TODAY_IS_BINDDING number @value:1545,des:今天已经绑定过群
---@field ERR_GUILD_NOT_CHAIRMAN number @value:1546,des:不是工会会长
---@field ERR_MAZE_INVAILD number @value:1547,des:迷宫副本获取非法
---@field ERR_MAZE_ROULETTE_INPUT_ERROR number @value:1548,des:迷宫副本输入非法
---@field ERR_MAZE_ROULETTE_ONCE number @value:1549,des:迷宫副本随机转盘失败
---@field ERR_MAZE_ROULETTE_ROOMTYPE_LEGAL number @value:1550,des:迷宫副本转盘获得房间失败
---@field ERR_MAZE_ROULETTE_GET_ROOM_BYTYPE_LEGAL number @value:1551,des:Roulette配置对应房间失败
---@field ERR_MAZE_ALREADY_PREVIEW number @value:1552,des:不能再次申请多看一个房间
---@field ERR_DUNGEONS_NOR_MAZE number @value:1553,des:当前不在迷宫副本
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT number @value:1490,des:采集物个人采集次数达上线
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT_DAY_ZERO number @value:1554,des:采集物个人采集次数达上线(每天凌晨0点)
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT_DAY_FIVE number @value:1555,des:采集物个人采集次数达上线(每日凌晨5点)
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT_WEEK_ZERO number @value:1556,des:采集物个人采集次数达上线(每周凌晨0点)
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT_WEEK_FIVE number @value:1557,des:采集物个人采集次数达上线(每周凌晨5点)
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT_MONTH_ZERO number @value:1558,des:采集物个人采集次数达上线(每月凌晨0点)
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT_MONTH_FIVE number @value:1559,des:采集物个人采集次数达上线(每月凌晨5点)
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT_DAY_TWELVE number @value:1560,des:采集物个人采集次数达上线(每天中午12点)
---@field ERR_COLLECTION_INDIVIDUAL_LIMIT_END number @value:1570,des:采集物个人采集次数达上限(预留)
---@field ERR_RECOVER_STATUS number @value:1571,des:被追缴状态
---@field ERR_ROLE_DUNGEONS_NOT_EXIST number @value:1572,des:个人dungeons不存在
---@field ERR_DUNGEONS_NOT_FOUND_CACHE_BY_TYPE number @value:1573,des:个人dungeons无法通过type找到cache
---@field ERR_NOT_IN_DEFAULT_STATE number @value:1574,des:当前有动作正在进行中(状态不为default)
---@field ERR_IS_IN_SINGLE_GROUND_VEHICLE number @value:1575,des:玩家在单人地面载具中
---@field ERR_IS_IN_SINGLE_FLY_VEHICLE number @value:1576,des:玩家在单人飞行载具中
---@field ERR_IS_IN_COUPLE_GROUND_VEHICLE number @value:1577,des:玩家在双人地面载具中
---@field ERR_IS_IN_COUPLE_FLY_VEHICLE number @value:1578,des:玩家在双人飞行载具中
---@field ERR_IS_IN_PHOTO number @value:1579,des:玩家在自拍中
---@field ERR_IS_IN_TASK_INTERACTIVE number @value:1580,des:玩家在任务道具交互动作中
---@field ERR_IS_IN_NPC_INTERACTIVE number @value:1581,des:玩家在Npc交互中
---@field ERR_IS_IN_PLAYER_INTERACTIVE number @value:1582,des:玩家交互中
---@field ERR_IS_IN_GO_FIGHT number @value:1583,des:玩家在进战斗中
---@field ERR_IS_IN_PASSIVE_GO_FIGHT number @value:1584,des:玩家在被动进战斗中
---@field ERR_IS_IN_CHANGE_LINE number @value:1585,des:玩家在切换分线中
---@field ERR_IS_IN_WEATHER_ACTION number @value:1586,des:玩家在天气动作中
---@field ERR_IS_IN_FISHING_ACTION number @value:1587,des:玩家在钓鱼动作中
---@field ERR_IS_IN_BACK_TO_GUILD number @value:1588,des:玩家在回到公会
---@field ERR_IS_IN_COUPLE_ACTION_FRAGMENT number @value:1589,des:玩家在片段型双人动作
---@field ERR_IS_IN_COUPLE_ACTION_CONTINUE number @value:1590,des:玩家在持续型双人动作
---@field ERR_CHECK_STATE_FAIL number @value:1591,des:切换状态失败（状态互斥表没通过）
---@field ERR_TRANSFER_STATE_SUCCESS number @value:1592,des:状态转移成功
---@field ERR_OTHER_CANNOT_COMMON_VEHICLE number @value:1593,des:其他人（队友）当前的状态不能搭乘公共载具
---@field ERR_APPLY_IN_CD number @value:1594,des:申请CD中
---@field ERR_TEAM_TARGET_CAPTAIN_ACTIVE number @value:1595,des:队长处于活跃状态
---@field ERR_TARGET_ROLE_NOT_IN_TEAM number @value:1596,des:目标玩家不在队伍里
---@field ERR_TARGET_ROLE_STATUS_CHANGE number @value:1597,des:目标玩家状态已经改变
---@field ERR_TARGET_LINE_FULL number @value:1598,des:目标线已经满了
---@field ERR_RED_ENVELOPE_ZENY_LESS_MIN number @value:1599,des:红包ZENY币少于最低限制
---@field ERR_RED_ENVELOPE_ZENY_MORE_MAX number @value:1600,des:红包ZENY币多于最多限制
---@field ERR_CREATE_OBJECT_FAILED number @value:1601,des:创建对象失败
---@field ERR_RED_ENEVLOPE_OVER_LIMIT number @value:1602,des:发送或者领取红包超出限制
---@field ERR_RED_ENVELOPE_NULL number @value:1603,des:红包为空指针
---@field ERR_NOT_IN_SAME_GUILD number @value:1604,des:不在同一个公会
---@field ERR_RED_ENVELOPE_EXPIRE number @value:1605,des:红包过期失效
---@field ERR_RED_ENVELOPE_FINISHED number @value:1606,des:红包被领完了
---@field ERR_PARAM number @value:1607,des:错误的参数
---@field ERR_RED_ENVELOPE_NOT_EXIST number @value:1608,des:红包不存在
---@field ERR_RED_ENVELOPE_PASSWORD_WRONG number @value:1609,des:红包口令错误
---@field ERR_RED_ENVELOPE_REPEAT_GRAB number @value:1610,des:重复抢红包
---@field ERR_RED_ENVELOPE_SENDER_NOT_ONLINE number @value:1611,des:红包发送者不在线
---@field ERR_RED_ENVELOPE_WORDS_LEN_EXCEED_LIMIT number @value:1612,des:红包寄语/口令长度超出限制
---@field ERR_RED_EVNELOPE_EXPIRE_FAILED number @value:1613,des:过期红包失败,这里过期是动词
---@field ERR_RED_ENVELOPE_NOT_FINISHED number @value:1614,des:红包尚未被抢完
---@field ERR_IS_IN_MUTEX_STATE number @value:1615,des:玩家在互斥状态中
---@field ERR_ADD_NEW_RED_ENVELOPE_FAILED number @value:1616,des:添加新的红包失败
---@field ERR_MERCHANT_SHOP_NPC_NOT_EXIST number @value:1620,des:跑商npc不存在
---@field ERR_MERCHANT_SHOP_BUY_ITEM_COUNT_ERROR number @value:1621,des:跑商购买物品数量小于等于0
---@field ERR_MERCHANT_SHOP_BUY_ITEM_NOT_EXIST number @value:1622,des:跑商购买物品不存在
---@field ERR_MERCHANT_SHOP_BUY_ITEM_COUNT_LIMIT number @value:1623,des:跑商购买物品数量超过库存
---@field ERR_MERCHANT_SHOP_BUY_ITEM_PRICE_DIFF number @value:1624,des:跑商购买物品价格不一致
---@field ERR_MERCHANT_SHOP_SELL_ITEM_NOT_EXIST number @value:1625,des:跑商出售物品不存在
---@field ERR_MERCHANT_SHOP_SELL_ITEM_PRICE_DIFF number @value:1626,des:跑商出售物品价格不一致
---@field ERR_MERCHANT_SHOP_NPC_DISTANCE_LIMIT number @value:1627,des:跑商距离npc距离过远
---@field ERR_MERCHANT_SHOP_SELL_ITEM_COUNT_ERROR number @value:1628,des:跑商出售物品数量错误
---@field ERR_MERCHANT_NOT_START number @value:1629,des:跑商未开始
---@field ERR_MERCHANT_CAN_NOT_FINISH number @value:1630,des:跑商未完成
---@field ERR_MERCHANT_EVENT_NPC_NOT_EXIST number @value:1631,des:跑商事件npc不存在
---@field ERR_MERCHANT_EVENT_PRICE_NOT_MATCH number @value:1632,des:跑商事件价格不对
---@field ERR_MERCHANT_EVENT_BUY_REPEAT number @value:1633,des:跑商事件重复购买
---@field ERR_MERCHANT_EVENT_BUY_FAILED number @value:1634,des:跑商事件购买失败
---@field ERR_MERCHANT_EVENT_NPC_DISTANCE_LIMIT number @value:1635,des:跑商事件npc距离过远
---@field ERR_VIRTUAL_ITEM_LACK_BOLI_COIN number @value:1636,des:波利币不足
---@field ERR_CARVE_STONE_HELP_LIMIT number @value:1637,des:已经帮助雕刻
---@field ERR_ARENA_ROOM_NOT_EXIST number @value:1638,des:角斗场房间不存在
---@field ERR_ARENA_CREATE_ROOM_FAILED number @value:1639,des:角斗场创建房间失败
---@field ERR_ARENA_ROOM_FULL number @value:1640,des:角斗场房间已满无法加入
---@field ERR_ARENA_ROLE_NOT_IN_ROOM number @value:1641,des:玩家不在角斗场房间中
---@field ERR_ARENA_INVITE_DEST_NOT_ONLINE number @value:1642,des:角斗场被邀请者不在线
---@field ERR_ARENA_INVITE_TOO_FAST number @value:1643,des:角斗场邀请太快
---@field ERR_ARENA_ROOM_HAD_START number @value:1644,des:角斗场房间已经开始
---@field ERR_ARENA_ROLE_ALREADY_IN_ROOM number @value:1645,des:角斗场玩家已在房间
---@field ERR_ARENA_INVITE_ROLE_IS_IN_DUNGEONS number @value:1646,des:角斗场被邀请者在副本中
---@field ERR_LEVEL_GIFT_HAS_RECEIVED number @value:1647,des:等级礼包已经领取过了
---@field ERR_LEVEL_GIFT_BAG_NUM number @value:1648,des:背包格子不足领取礼包
---@field ERR_LEVEL_GIFT_MONEY_NOT_ENOUGH number @value:1649,des:等级礼包买不起
---@field ERR_CUR_SCENE_CANNOT_ENTER_GUILD_SCENE number @value:1650,des:当前所在场景，不能点击进入公会场景
---@field ERR_BATTLEFIELD_TEAMMATE_NOT_IN_SCENE number @value:1651,des:队友不在战场等候场景中
---@field ERR_ROLE_LIMITED_OFFER_NULL number @value:1652,des:指针为空
---@field ERR_ROLE_NULL number @value:1653,des:role指针为空
---@field ERR_ADD_NEW_LIMITED_OFFER_FAILED number @value:1654,des:添加新的限时特惠失败
---@field ERR_CANNOT_FIND_LIMITED_OFFER_ID number @value:1655,des:找不到ID对应的限时特惠项目
---@field ERR_WRONG_ACTIVITY_STATUS number @value:1656,des:玩家活动状态错误
---@field ERR_LIMITED_OFFER_NOT_OPEN number @value:1657,des:限时特惠功能尚未开启
---@field ERR_LIMITED_OFFER_NOT_STARTED number @value:1658,des:限时特惠尚未开始
---@field ERR_MALL_INFO_EXPIRED number @value:1659,des:商城物品信息已经过期
---@field ERR_MALL_ITEM_NOT_ENOUGH number @value:1660,des:商城物品可购买次数不足
---@field ERR_GUILD_WELFARE_IS_ZERO number @value:1661,des:本周的公会福利为0
---@field ERR_TASK_STATUS_WRONG number @value:1662,des:任务状态不对
---@field ERR_TASK_EXCLUSIVE number @value:1663,des:任务互斥限制
---@field ERR_TASK_CONFIG_ERROR number @value:1664,des:任务配置问题
---@field ERR_TASK_TARGET_NEED_FINISH number @value:1665,des:任务目标需要完成
---@field ERR_MEDAL_ACTIVE_ACHIEVEMENT_LEVEL_NOT_ENOUGH number @value:1666,des:玩家成就徽章等级不够
---@field ERR_DUNGEONS_NOT_PASS number @value:1667,des:该副本未通关
---@field ERR_DUNGEONS_ALREADY_AWARD number @value:1668,des:该副本已经领取过奖励
---@field ERR_TABLE_NOT_EXIST number @value:1669,des:
---@field ERR_CANNOT_FOLLOW_ONESELF number @value:1670,des:不能跟随自己
---@field ERR_DELEGATE_HAS_NO_LEFT_AWARD_TIMES number @value:1671,des:委托抽奖次数不足
---@field ERR_ALREADY_HAS_LUCKY_NO number @value:1672,des:玩家已经拥有幸运码
---@field ERR_PROTOCOL_IS_SENDING number @value:1673,des:协议正在发送中
---@field ERR_THEME_PARTY_ENTER_TIME_FAIL number @value:1674,des:正在准备主题派对，暂时不能进入
---@field ERR_THEME_PARTY_HAS_NOT_INVITATION number @value:1675,des:玩家没有邀请函
---@field ERR_THEME_PARTY_NOT_ACTIVITY_TIME number @value:1676,des:不在活动时间范围
---@field ERR_THEME_PARTY_LACK_LOVE_NUM number @value:1677,des:点亮爱心次数不足
---@field ERR_THEME_PARTY_ALREADY_SEND_LOVE number @value:1678,des:已经赠送过爱心
---@field ERR_ARENA_MEMBER_CANT_INVITE number @value:1679,des:角斗场成员未开放邀请权限
---@field ERR_GUILD_AID_CD_LIMIT number @value:1680,des:公会援助CD限制
---@field ERR_NAVIGATE_TOMAP_INVALID number @value:1681,des:目的地无法自动寻路
---@field ERR_NAVIGATE_NOWMAP_INVALID number @value:1682,des:当前地图不能自动寻路
---@field ERR_SHARE_DISH_CD number @value:1683,des:还有%s秒才能分享
---@field ERR_IS_TOO_FREQUENT number @value:1684,des:请求太频繁
---@field ERR_INVALID_POSITION number @value:1685,des:非法坐标
---@field ERR_SERVER_ERROR number @value:1686,des:服务器报错
---@field ERR_VIRTUAL_ITEM_LACK_ARMORY number @value:1687,des:纹章不足
---@field ERR_ROLE_STATE_NOT_IN_GAME number @value:1688,des:玩家状态不对，无法切场景
---@field ERR_TUTORIAL_IS_EMPTY number @value:1689,des:玩家没有完成的新手引导
---@field ERR_NO_SCENE_INTERACTION number @value:1690,des:玩家无法与场景物件交互
---@field ERR_MULTI_TALENT_NOT_EXIST number @value:1691,des:多天赋不存在
---@field ERR_ACHIEVEMENT_LEVEL_NOT_ENOUGH number @value:1692,des:成就等级不够
---@field ERR_QUALITY_POINT_PAGE_NOT_EXIST number @value:1693,des:属性页不存在
---@field ERR_JOB_LEVEL_NOT_ENOUGH number @value:1694,des:job等级不足
---@field ERR_JOB_LEVEL_ALREADY_AWARD number @value:1695,des:job等级奖励已经领取
---@field ERR_SKILL_MULTI_TALENT_SEQ_ERROR number @value:1696,des:开技能多天赋次序错误
---@field ERR_ROLE_IS_FIGHTING number @value:1697,des:角色正在战斗
---@field ERR_CANT_CHANGE_SKILL_TALENT_IN_PVP number @value:1698,des:pvp场景不能切换技能天赋
---@field ERR_SKILL_TALENT_NOT_EXIST number @value:1699,des:该技能天赋不存在
---@field ERR_SKILL_POINT_NOT_ENOUGHT number @value:1700,des:技能点不足
---@field ERR_PROFESSION_SKILL_POINT_NOT_FULL number @value:1701,des:职业技能点未点满
---@field ERR_SKILL_NOT_EXIST number @value:1702,des:该技能不存在
---@field ERR_SKILL_TASK_NOT_FINISH number @value:1703,des:技能任务未完成
---@field ERR_SKILL_LEVEL_TOP number @value:1704,des:技能超过最大等级
---@field ERR_PRE_SKILL_LEVEL_NOT_ENOUGH number @value:1705,des:前置技能等级不足
---@field ERR_SKILL_SLOT_NOT_EXIST number @value:1706,des:该技能孔不存在
---@field ERR_PASSIVE_SKILL_NOT_SLOT number @value:1707,des:被动技能不能安装
---@field ERR_SKILL_REPEATED_SLOT number @value:1708,des:技能重复安装
---@field ERR_EQUIP_PAGE_NO_EXIST number @value:1709,des:装备页不存在
---@field ERR_INVALID_EQUIP_PAGE_ID number @value:1710,des:非法的装备页id
---@field ERR_EQUIPMENT_PAGE_ITEMS_CAN_NOT_MOVE number @value:1711,des:装备页的装备无法拍卖移动等
---@field ERR_STALL_STOCK_IS_FULL number @value:1712,des:库存已满
---@field ERR_GUILD_WAREHOUSE_NOITEM number @value:1713,des:公会仓库里没有这个东西
---@field ERR_GUILD_WAREHOUSE_COUNT_LIMIT number @value:1714,des:公会仓库容量限制
---@field ERR_GUILD_WAREHOUSE_LEVEL_LIMIT number @value:1715,des:公会等级不够,无法查看公会仓库
---@field ERR_GUILD_WAREHOUSE_TIME_LIMIT number @value:1716,des:加入时间不够,无法查看公会仓库
---@field ERR_GUILD_WAREHOUSE_NO_AUCTION number @value:1717,des:公会拍卖没有这个道具
---@field ERR_GUILD_CRYSTAL_ANNOUNCE_INVALID number @value:1718,des:水晶公告已失效
---@field ERR_ITEM_USE_CD_LIMIT number @value:1719,des:物品使用过于频繁
---@field ERR_IN_BUFF_MUTEX_STATE number @value:1720,des:buff触发进入状态互斥
---@field ERR_GUILD_WAREHOUSE_LOWER_THAN_BASE number @value:1721,des:出价低于底价
---@field ERR_GUILD_WAREHOUSE_CHANGE_PRICE_CD number @value:1722,des:改价cd中不能改价
---@field ERR_GUILD_WAREHOUSE_GIVEUP_PRICE_CD number @value:1723,des:放弃竞拍cd中,不能放弃
---@field ERR_WORDS_EXCEED_NUM_LIMIT number @value:1724,des:星标常用语超出数量限制
---@field ERR_REMOVE_FREQUENT_WORDS_FAILED number @value:1725,des:取消星标常用语失败
---@field ERR_CHAT_SHARE_NULLPTR number @value:1726,des:分享的指针为空
---@field ERR_CHAT_SHARE_CANNOT_FIND number @value:1727,des:找不到分享
---@field ERR_REVIVE_ALREADY_ALIVE number @value:1728,des:已经复活
---@field ERR_WARDCOBE_FULL number @value:1729,des:衣橱满了
---@field ERR_WARDCOBE_ALLREADY_HAD_FASHION number @value:1730,des:衣橱里面已经存在
---@field ERR_WARDROBE_AWARD_NOT_EXIST number @value:1731,des:典藏值奖励不存在
---@field ERR_WARDROBE_AWARD_IS_GET number @value:1732,des:典藏值奖励已经获取
---@field ERR_WARDROBE_AWARD_NOT_FINISH number @value:1733,des:典藏值奖励没有达到
---@field ERR_TASK_LIMIT number @value:1734,des:任务TASKLIMIT字段不通过
---@field ERR_WATCH_ROOM_NOT_EXIST number @value:1735,des:观战房间不存在
---@field ERR_SEPCTATOR_TYPE_ERROR number @value:1736,des:观战分类不存在
---@field ERR_WATCH_ROOM_NOMORE_PAGE number @value:1737,des:没有更多房间了
---@field ERR_ALREADY_IN_WATCH_ROOM number @value:1738,des:已经在观战房间内
---@field ERR_SEARCH_KEY_TOO_SHORT number @value:1739,des:搜索关键词过短
---@field ERR_REQUEST_TOO_FAST number @value:1740,des:请求过快
---@field ERR_HAS_ALREADY_LIKE_ROOM number @value:1741,des:已经给观战房间点过赞了
---@field ERR_WATCH_ROOM_FULL number @value:1742,des:观战人数已满
---@field ERR_NOT_IN_SCENE number @value:1743,des:不在场景中
---@field ERR_NOT_IN_DUNGEONS number @value:1744,des:不在副本中
---@field ERR_DUNGEONS_NOT_SUPPORT_WATCH number @value:1745,des:副本不支持观战
---@field ERR_DUNGEONS_WATCH_FAIL number @value:1746,des:副本观战失败
---@field ERR_CHAT_WATCH_ROMM_CD_LIMIT number @value:1747,des:观战聊天CD
---@field ERR_STATE_MUTEX_WATCH number @value:1748,des:观战状态互斥
---@field ERR_DUNGEON_WATCH_HAS_RESULT number @value:1749,des:副本已结算不能观战
---@field ERR_NOT_FOUND number @value:1750,des:
---@field ERR_THEME_PARTY_CAN_NOT_EXCHANGE_INVITATION number @value:1751,des:该段时间内，不能兑换邀请函
---@field ERR_EQUIP_IS_DESTROYED_BY_BUFF number @value:1752,des:装备被buff临时破坏，失效。不能穿脱
---@field ERR_STATE_MUTEX_DANCE number @value:1753,des:跳舞状态互斥
---@field ERR_TRY_WATCH_AGAIN number @value:1754,des:稍后请重试观战
---@field ERR_CAPTAIN_IS_WATCHING number @value:1755,des:被跟随者正在观战
---@field ERR_CONNECT_MS_FAILED number @value:1756,des:连接ms失败
---@field ERR_CONNECT_DB_FAILED number @value:1757,des:连接db失败
---@field ERR_CONNECT_TRADE_FAILED number @value:1758,des:连接trade server失败
---@field ERR_CONNECT_AUDIO_FAILED number @value:1759,des:连接audio server失败
---@field ERR_CONNECT_AUTH_FAILED number @value:1760,des:连接auth server失败
---@field ERR_DEC_EQUIP_NOTEXIST number @value:1761,des:待分解装备不存在
---@field ERR_EXTRACT_ERUIP_NOT_ENOUGH number @value:1762,des:抽取装备次数不足
---@field ERR_EQUIP_EXTRACT_AWARD_NOT_EXIST number @value:1763,des:抽取奖池不存在
---@field ERR_EQUIP_CANNOT_RECOVE number @value:1764,des:装备无法分解
---@field ERR_TOWER_DEF_MANA_LACK number @value:1765,des:魔力不足
---@field ERR_TOWER_DEF_CMD_INVALID number @value:1766,des:指令无效
---@field ERR_TOWER_DEF_BEYOND_LIMIT number @value:1767,des:超过召唤上限
---@field ERR_TOWER_DEF_SUMMON_ABSENCE number @value:1768,des:召唤阵不存在
---@field ERR_TOWER_DEF_CMD_CDLIMIT number @value:1769,des:指令处于CD中
---@field ERR_TOWER_DEF_NOT_IN_CIRCLE number @value:1770,des:玩家不再魔法阵内
---@field ERR_TOWER_DEF_NO_SERVANT number @value:1771,des:魔法阵内有没有英灵
---@field ERR_TRY_TAKE_ITEM_FAILED number @value:1772,des:扣除道具失败
---@field ERR_VEHICLE_UPGRADE_TIMES_LIMIT number @value:1773,des:载具升级次数达到限制
---@field ERR_VEHICLE_LEVEL_LIMIT number @value:1774,des:载具达到等级限制
---@field ERR_VEHICLE_CANNOT_CHANGE_STATUS number @value:1775,des:不能切换载具状态
---@field ERR_VEHICLE_BREAK_LIMIT number @value:1776,des:素质突破次数达到限制
---@field ERR_VEHICLE_DEVELOP_TYPE number @value:1777,des:素质培养类型错误
---@field ERR_VEHICLE_DEVELOP_FAILED number @value:1778,des:素质培养失败
---@field ERR_ROLE_VEHICLE_NOT_EXIST number @value:1779,des:角色载具信息不存在
---@field ERR_VEHICLE_CANNOT_FIND_VEHICLE number @value:1780,des:找不到载具
---@field ERR_VEHICLE_CANNOT_FIND_OUTLOOK_ID number @value:1781,des:找不到配饰或配色ID
---@field ERR_VEHICLE_ALREADY_HAVE number @value:1782,des:已经拥有这个载具
---@field ERR_CAN_NOT_FIND_MERCENARY number @value:1783,des:玩家没有这个佣兵
---@field ERR_MERCENARY_HAS_NOT_THE_SKILL number @value:1784,des:佣兵没有这个技能
---@field ERR_MERCENARY_EQUIP_TOUCH_MAX_LEVEL number @value:1785,des:佣兵装备已达到最大等级
---@field ERR_MERCENARY_HAS_NOT_THE_EQUIP number @value:1786,des:佣兵没有这个装备
---@field ERR_MERCENARY_EQUIP_NOT_MAX_LEVEL number @value:1787,des:装备未达到最大等级无法进阶
---@field ERR_MERCENARY_EQUIP_NOT_SUPPORT_ADVANCE number @value:1788,des:装备不支持进阶
---@field ERR_MERCENARY_HAS_NOT_THE_TALENT number @value:1789,des:佣兵没有这个天赋
---@field ERR_MERCENARY_ALREADY_HAD_THE_TALENT number @value:1790,des:佣兵已拥有该天赋
---@field ERR_MERCENARY_LEVEL_NOT_ENOUGH number @value:1791,des:佣兵等级不足
---@field ERR_MERCENARY_CONFIG_ERROR number @value:1792,des:佣兵配置错误
---@field ERR_MERCENARY_TALENT_TOUCH_MAX_LEVEL number @value:1793,des:佣兵天赋已达最大等级
---@field ERR_MERCENARY_TALENT_NOT_MAX_LEVEL number @value:1794,des:佣兵天赋未达最大等级无法强化
---@field ERR_VIRTUAL_ITEM_LACK_MERCENARY_TALENT_POINT number @value:1795,des:缺少佣兵天赋点
---@field ERR_MERCENARY_TOUCH_MAX_LEVEL number @value:1796,des:佣兵等级已达上限
---@field ERR_ROLE_LEVEL_NOT_ENOUGH number @value:1797,des:玩家等级不足
---@field ERR_MERCENARY_NOT_TAKE_OUT number @value:1798,des:佣兵未出战
---@field ERR_MERCENARY_CANNOT_TAKE_OUT_IN_SCENE number @value:1799,des:该场景不允许携带佣兵
---@field ERR_MERCENARY_CANNOT_TAKE_OUT_WHEN_FIGHT number @value:1800,des:战斗状态下不允许出战
---@field ERR_MERCENARY_CANNOT_TAKE_BACK_WHEN_FIGHT number @value:1801,des:战斗状态不允许收回
---@field ERR_MERCENARY_ALREADY_TAKE_OUT number @value:1802,des:佣兵已出战
---@field ERR_MERCENARY_TEAM_HAS_NO_POS number @value:1803,des:佣兵无法出战因为队伍没有位置
---@field ERR_MERCENARY_MAX_BATTLE_NUM number @value:1804,des:无法出战因为已达最大上限
---@field ERR_MERCENARY_TALENT_CANT_SWITCH number @value:1805,des:佣兵天赋无法切换
---@field ERR_MERCENARY_CANNOT_TAKE_BACK_IN_SCENE number @value:1806,des:该场景无法收回佣兵
---@field ERR_MERCENARY_EQUIP_LEVEL_GT_MERCENARY number @value:1807,des:佣兵装备等级大于佣兵等级
---@field ERR_CANT_ENTER_COUPLE_ACTION number @value:1808,des:无法进入双人动作
---@field ERR_CANT_ENTER_COUPLE_VEHICLE number @value:1809,des:无法进入双人载具
---@field ERR_DETACHED_NO_LEGAL_POS number @value:1810,des:没有合法的坐标
---@field ERR_DETACHED_IN_CD number @value:1811,des:脱离卡死处于CD当中
---@field ERR_EQUIP_CANNOT_REBORN number @value:1812,des:装备无法提炼
---@field ERR_EQUIP_CANNOT_ENCHANT_INHERIT number @value:1813,des:装备无法继承
---@field ERR_MERCENARY_SHOULD_ADVANCE number @value:1814,des:佣兵等级暂时达到上限需进阶
---@field ERR_GUILD_MONEY_NOT_ENOUGH number @value:1815,des:公会资金不足
---@field ERR_GUILD_HUNT_NOT_IN_SAME_SCENE number @value:1816,des:有队员不在队长场景中
---@field ERR_GUILD_HUNT_JOIN_TIMES_LIMIT number @value:1817,des:公会狩猎参加次数受限
---@field ERR_PLATFORM_NO_TEAM number @value:1818,des:擂台玩家没有组队
---@field ERR_PLATFORM_TEAM_OVERFLOW number @value:1819,des:玩家队伍人数溢出
---@field ERR_PLATFORM_MEMBER_OUTSIDE number @value:1820,des:队伍有人不在等候区
---@field ERR_ROLE_SCENE_CAN_NOT_WATCH number @value:1821,des:玩家所在场景不允许观战
---@field ERR_CANNOT_DEVELOP_WITHOUT_VEHICLE number @value:1822,des:未获取载具不能培养
---@field ERR_IN_KUANG_NU_ZHI_QIANG_STATE number @value:1823,des:狂怒之抢无法换装备
---@field ERR_JOIN_TEAM_BACK_MERCENARY number @value:1824,des:加入队伍佣兵收回
---@field ERR_LEAVE_TEAM_NORMAL number @value:1825,des:离开队伍
---@field ERR_LEAVE_TEAM_OUT_MERCENARY number @value:1826,des:离开队伍出战佣兵
---@field ERR_LEAVE_TEAM_NOT_OUT_MERCENARY number @value:1827,des:离开队伍但佣兵无法出战
---@field ERR_JOIN_TEAM_NORMAL number @value:1828,des:加入队伍
---@field ERR_UPGRADE_BASE_LOW number @value:1829,des:等级低于*级
---@field ERR_UPGRADE_BASE_HIGH number @value:1830,des:base等级高于**级
---@field ERR_UPGRADE_BASE_FAILED number @value:1831,des:Base升级失败
---@field ERR_UPGRADE_JOBCHANGE_LOW_TWICE number @value:1832,des:你尚未进行职业二转
---@field ERR_UPGRADE_JOBCHANGE_OVER_TWICE number @value:1833,des:你已经二转
---@field ERR_UPGRADE_JOB_HIGH number @value:1834,des:Job等级超过
---@field ERR_UPGRADE_JOB_FAILED number @value:1835,des:job升级失败
---@field ERR_GUILD_DINNER_CHAMPAGNE_HAS_OPEND number @value:1836,des:宴会香槟祝福已被开启
---@field ERR_CAN_NOT_BE_DIAMOND number @value:1837,des:钻石只能通过唯一的途径
---@field ERR_IN_PAYING number @value:1838,des:只在支付中
---@field ERR_IN_SENDING_AWARD number @value:1839,des:发奖中
---@field ERR_ALREADY_ADD_GOODS number @value:1840,des:已经发货
---@field ERR_GUILD_ROLE_IS_CANDIDATED number @value:1841,des:成员已经参加公会赛
---@field ERR_GUILD_IN_TIME_NOT_ENOUGH number @value:1842,des:加入公会时间不足
---@field ERR_GUILD_MATCH_APPLY_TEAM_MEMBER_NOT_ENOUGH number @value:1843,des:公会战队伍报名人数不足
---@field ERR_GUILD_MATCH_NO_COMPETITION number @value:1844,des:公会匹配赛没有对手
---@field ERR_GUILD_MATCH_NOT_APPLY_TIME number @value:1845,des:不在报名时间
---@field ERR_GUILD_MATCH_PARTICIPANTS_CHANGE number @value:1846,des:等候区内参赛人员变更，提出场景
---@field ERR_GUILD_MATCH_NOT_TEAM_MANAGE_TIME number @value:1847,des:不在参赛队伍管理时间
---@field ERR_GUILD_MATCH_WAITING_ROOM_NOT_OPEN number @value:1848,des:等候区未开放
---@field ERR_GUILD_MATCH_ROLE_NOT_WATCHING number @value:1849,des:玩家不在观战状态
---@field ERR_GUILD_MATCH_NOT_IN_FIGHT number @value:1850,des:当前不在战斗状态
---@field ERR_GUILD_MATCH_NOT_BATTLE_TEAM number @value:1851,des:不是参赛队伍,不能进入等候区
---@field ERR_GUILD_MATCH_APPLY_NO_TEAM number @value:1852,des:报名参赛无队伍
---@field ERR_CONTAINER_NOT_FOUND number @value:1853,des:容器未找到
---@field ERR_ITEM_CHECKIN_FAILED number @value:1854,des:道具不能进入对应容器
---@field ERR_ITEM_CHECKOUT_FAILED number @value:1855,des:道具不能取出
---@field ERR_TITLE_USING_NOW number @value:1856,des:称号已使用
---@field ERR_STALL_ITEM_DISABLE number @value:1857,des:无效摆摊道具
---@field ERR_TRADE_ITEM_DISABLE number @value:1858,des:无效商会道具
---@field ERR_TEAM_OPERATE_IS_BANNED_IN_SCENE number @value:1859,des:改场景禁止队伍操作
---@field ERR_LEADER_BOARD_NOT_EXIST number @value:1860,des:排行榜不存在
---@field ERR_RANK_RECORD_NOT_EXIST number @value:1861,des:排行榜记录不存在
---@field ERR_BOARD_VIEW_TYPE_ERROR number @value:1862,des:排行榜数据请求类型错误
---@field ERR_LEADERBOARD_CONFIG_ERROR number @value:1863,des:排行榜配置错误
---@field ERR_CLIENT_CANT_ACTIVE_REVIVE number @value:1864,des:客户端不能主动复活
---@field ERR_NOT_REACH_REVIVE_TIME number @value:1865,des:未到复活时间
---@field ERR_THE_STATE_CANT_REVIVE number @value:1866,des:当前状态无法复活
---@field ERR_IS_CHANGING_SCENE number @value:1867,des:正在切场景中
---@field ERR_ITEM_EXISTS number @value:1868,des:道具已存在
---@field ERR_FASHION_EVA_HISOTRY_NOTFOUND number @value:1869,des:时尚杂志往期数据不存在
---@field ERR_STONE_AWARD_ALREADY_GET number @value:1870,des:纪念原石奖励已经领取
---@field ERR_STONE_CARVE_UNFINISHED number @value:1871,des:雕刻未完成
---@field ERR_STONE_SOUVENIR_CRYSTAL_NOT_ENOUGH number @value:1872,des:纪念晶石不够
---@field ERR_STONE_SOUVENIR_CRYSTAL_HVE_ASSIGNED number @value:1873,des:有人已经领取过纪念晶石
---@field ERR_BLESSING_IN_OPEN_CD number @value:1874,des:祝福开关处于CD中
---@field ERR_TRADE_IN_FORBID_SELL_TIME2 number @value:1875,des:非预购商品刷新时间不能买卖
---@field ERR_TRADE_IN_FORBID_BUY_TIME2 number @value:1876,des:同上
---@field ERR_ROYAL_NOT_OPEN number @value:1877,des:公会荣誉未开启
---@field ERR_PICK_SMALL_GIFT_PACK_NOT_YET number @value:1878,des:未到小礼包领取时间
---@field ERR_NO_QUALIFIED_BUY_GIFT_PACK number @value:1879,des:没有资格购买限定礼包
---@field ERR_BUY_GIFT_PACK_TOP_LIMIT number @value:1880,des:限定礼包已达限购上限
---@field ERR_NOT_ACTIVE_MONTH_CARD number @value:1881,des:未开启月卡
---@field ERR_ALREADY_ACTIVE_MONTH_CARD number @value:1882,des:已开启月卡
---@field ERR_WORLD_PVE_NOT_IN_SAME_GUILD number @value:1883,des:不在同一个公会[时空调查团]
---@field ERR_GUILD_BEAUTY_NOT_FEMALE number @value:1884,des:公会团宠不是女性角色
---@field ERR_GUILD_BEAUTY_TIME_NOT_ENOUGH number @value:1885,des:公会团宠玩家加入公会时间不足
---@field ERR_GUILD_BEAUTY_ACTIVITY_NOT_ENOUGH number @value:1886,des:公会团宠玩家活跃不足
---@field ERR_ALREADY_GUILD_BEAUTY number @value:1887,des:该角色已经是公会团宠
---@field ERR_CHAIRMAN_CAN_NOT_BE_GUILD_BEAUTY number @value:1888,des:会长不能成为团宠
---@field ERR_STALL_NUM_INVALID number @value:1889,des:摊位数量不合法(idip)
---@field ERR_VIP_CARD_ACTIVED number @value:1890,des:vip卡已激活(idip)
---@field ERR_VIP_CARD_INACTIVE number @value:1891,des:vip卡非激活状态(idip)
---@field ERR_TASK_SURPRISE_FAILED number @value:1892,des:奇遇触发失败
---@field ERR_FAQ_CONTENT_EMPTY number @value:1893,des:faq字数少
---@field ERR_FAQ_CONTENT_OVER number @value:1894,des:faq提问超出长度限制
---@field ERR_FAQ_COUNT_NOT_ENOUGH number @value:1895,des:faq提问次数不足
---@field ERR_FAQ_ASK_SUCCESS number @value:1896,des:提问成功
---@field ERR_NOT_IN_BLACK_MARKET_SELL_TIME number @value:1897,des:不在黑市售出时间范围内
---@field ERR_NOT_IN_BLACK_MARKET_SELL_LIST number @value:1898,des:道具不能再黑市出售
---@field ERR_AUCTION_ITEM_NOT_OPEN number @value:1899,des:道具没有开放
---@field ERR_AUCTION_FOLLOW_LIST_IS_NULL number @value:1900,des:角色关注列表为空
---@field ERR_AUCTION_FOLLOW_LIST_IS_FULL number @value:1901,des:角色关注列表满了
---@field ERR_AUCTION_FOLLOW_LIST_NO_ITEM number @value:1902,des:关注列表中不存在道具
---@field ERR_AUCTION_NOT_IN_AUCTION_TIME number @value:1903,des:不在手动出价的时间
---@field ERR_AUCTION_BIB_INVALID_PRICE number @value:1904,des:出价价格错误
---@field ERR_AUCTION_SOMEONE_BIBING number @value:1905,des:有人正在出价中
---@field ERR_AUCTION_CONTAINER_IS_NULL number @value:1906,des:找不到上架的物品
---@field ERR_AUCTION_BIB_SUCCESS number @value:1907,des:出价成功
---@field ERR_AUCTION_BIB_FAILD number @value:1908,des:出价失败
---@field ERR_AUCTION_BIB_FAILD_LESS_THAN_OWNER_AUTO_PRICE number @value:1909,des:出价失败小于拥有者的自动出价
---@field ERR_AUCTION_IN_AUCTION_PREPARE_TIME number @value:1910,des:在拍卖准备时间
---@field ERR_AUCTION_CANCEL_BIB_SUCCESS number @value:1911,des:退单成功
---@field ERR_AUCTION_ROLE_NOT_BIB number @value:1912,des:角色没有参与出价
---@field ERR_AUCTION_NOT_IN_CANCEL_BIB_TIME number @value:1913,des:不在自动出价时间
---@field ERR_AUCTION_CANCEL_IN_INCALID_TIME number @value:1914,des:自动出价只能在拍卖开始之前取消
---@field ERR_AUCTION_BIB_SUCCESS_ADD_EXTRA_MONEY number @value:1915,des:出价成功，系统以自动收取订单差价
---@field ERR_AUCTION_BIB_FAILD_LESS_THAN_SELF_BIB number @value:1916,des:出价失败，手动出价需要高于当前设置的出价上限
---@field ERR_AUCTION_BIB_FAILD_SAME_MONEY_AUTO_BIB number @value:1917,des:出价失败，无法以相同价格重复自动出价
---@field ERR_AUCTION_BIB_SUCCESS_GET_DET_MONEY number @value:1918,des:出价成功，系统已自动返还订单差价
---@field ERR_AUCTION_BIB_PRICE_NO_IN_LIMIT number @value:1919,des:出价没有在n倍以内
---@field ERR_BILL_REPEAT number @value:1920,des:订单重复
---@field ERR_AUCTION_ITEM_BE_LOCK number @value:1921,des:道具被GM锁定
---@field ERR_GUILD_STONE_ASSIGN_ALL_FAILED number @value:1922,des:分配晶石全部失败
---@field ERR_GUILD_STONE_ASSIGN_PART_FAILED number @value:1923,des:分配晶石部分失败
---@field ERR_LIFE_SKILL_UPGRADE_SUB_PRICE_NOT_ENOUGH number @value:1924,des:生活职业升级辅助材料消耗不足，可用替代材料
---@field ERR_LIFE_SKILL_UPGRADE_PRICE_NOT_ENOUGH number @value:1925,des:生活职业升级材料消耗不足
---@field ERR_IS_IN_AUTO_COLLECTING number @value:1926,des:已经在自动采摘状态
---@field ERR_AUTO_COLLECT_TIME_NOT_ENOUGH number @value:1927,des:自动采集剩余时间不足
---@field ERR_AUTO_COLLECT_GATHER_TIMES_NOT_ENOUGH number @value:1928,des:自动埃及采摘次数不足
---@field ERR_AUTO_COLLECT_MINING_TIMES_NOT_ENOUGH number @value:1929,des:自动采集挖矿次数不足
---@field ERR_CARD_CANNOT_UNSEAL number @value:1930,des:卡片不可解封
---@field ERR_MAGIC_PAPER_TIMES number @value:1931,des:魔法信笺发送次数耗尽
---@field ERR_ROLE_SAME number @value:1932,des:不能发给自己
---@field ERR_ENVELOPE_SENDED number @value:1933,des:红包已发送
---@field ERR_MAGIC_PAPE_EXPIRE number @value:1934,des:魔法信笺已过期
---@field ERR_THANKSED number @value:1935,des:已经感谢过了
---@field ERR_PAPER_BLESS_INVALID number @value:1936,des:魔法信笺祝福语有敏感词
---@field ERR_PAPER_GRAB_TIMES number @value:1937,des:魔法信笺领取次数耗尽
---@field ERR_FM_UNNORMAL number @value:1938,des:fmserver未正常运行
---@field ERR_FM_NOTEXSIT number @value:1939,des:数据不存在
---@field ERR_WHEEL_CONFIG_ERROR number @value:1940,des:齿轮配置有误
---@field ERR_WHEEL_SKILL_NOT_EXIST number @value:1941,des:齿轮不存在可以选择的技能
---@field ERR_WHEEL_MAINTENANCE_LIFT_LIMIT number @value:1942,des:齿轮保养溢出
---@field ERR_WHEEL_COMPOSITE_ITEMID_DIFF number @value:1943,des:齿轮合并但道具ID不一致
---@field ERR_WHEEL_COMPOSITE_ITEM_NUM_ERROR number @value:1944,des:齿轮合并数量必须是偶数
---@field ERR_MONSTER_MANUAL_AWARD_TYPE number @value:1945,des:获取怪物图鉴奖励类型错误
---@field ERR_MONSTER_MANUAL_GET_AWARD_FAILED number @value:1946,des:怪物图鉴领取奖励失败
---@field ERR_EQUIP_INHERIT_NOT_SAME_EQUIP number @value:1947,des:同名继承不是同样的装备
---@field ERR_EQUIP_INHERIT_OTHER_HAS_NO_ATTR number @value:1948,des:同名继承对方装备没有可继承属性
---@field ERR_EQUIP_INHERIT_OWN_HAS_ATTR number @value:1949,des:同名继承待继承装备有属性
---@field ERR_GUILD_ORGANIZE_PERSON_AWARD_NOT_EXIST number @value:1950,des:公会组织手册个人奖励不存在
---@field ERR_GUILD_ORGANIZE_PERSON_AWARD_ALREADY_GET number @value:1951,des:公会组织手册个人奖励已领取
---@field ERR_GUILD_MATCH_SYSTEM_NOT_OPEN number @value:1952,des:公会匹配赛功能未开放
---@field ERR_GUILD_ORGANIZE_PERSON_AWARD_ALREADY_GET_THIS_WEEK number @value:1953,des:公会组织手册个人奖励本周已领取
---@field ERR_CANNOT_FIND_SURVEYOR number @value:1954,des:找不到探测器
---@field ERR_OWNER_TREASURE_COLLECTION_LACK_NUM number @value:1955,des:魔物宝藏缺少采集次数
---@field ERR_OTHER_TREASURE_COLLECTION_LACK_NUM number @value:1956,des:魔物宝藏其他人采集次数不足
---@field ERR_TREASURE_HUNTER_NO_TRACE_DETECTED number @value:1957,des:没有探查到魔物掩藏的痕迹
---@field ERR_TREASURE_HUNTER_ALREADY_HELP number @value:1958,des:已经帮助过勘测了
---@field ERR_TREASURE_HUNTER_FIND_DETECTED number @value:1959,des:发现勘测器
---@field ERR_TREASURE_HUNTER_HELP_SUCCESS number @value:1960,des:助力成功
---@field ERR_OTHER_TREASURE_COLLECTION_LACK_SUM_NUM number @value:1961,des:其他人总次数不足
---@field ERR_TREASURE_HUNTER_OPEN_TREASURE number @value:1962,des:打开魔物宝藏
---@field ERR_TREASURE_HUNTER_TASK_LIMIT number @value:1963,des:宝藏猎人接任务次数达到上限
---@field ERR_TREASURE_HUNTER_IN_ACTIVITY number @value:1964,des:宝藏猎人处于活动中
---@field ERR_TREASURE_HUNTER_SCENE_FULL number @value:1965,des:宝藏猎人场景勘测器已满，请换个场景
---@field ERR_ACTIVITY_TIME_LIMIT number @value:1966,des:参加活动次数已达上限
---@field ERR_ACTIVITY_NOT_OPEN number @value:1967,des:活动未开启
---@field ERR_CDK_ERROR number @value:1968,des:兑换码有误
---@field ERR_CDK_USED number @value:1969,des:该兑换码已使用
---@field ERR_CDK_EXPIRED number @value:1970,des:兑换码已过期
---@field ERR_CDK_INVALID_PERIOD number @value:1971,des:未到兑换码使用时间
---@field ERR_CDK_COUNT_LIMIT number @value:1972,des:您使用{0}兑换码次数已达上限
---@field ERR_CDK_SUCCESS number @value:1973,des:兑换成功请查收您的邮件
---@field ERR_CDK_SUCCESS_COUNT number @value:1974,des:还可使用{0}个{1}兑换码
---@field ERR_CDK_ERROR_UNUSUAL number @value:1975,des:兑换码异常
---@field ERR_SERVER_LEVEL_LIMIT number @value:1976,des:服务器等级限制
---@field ERR_PRESTIGE_COUNT_LIMIT number @value:1977,des:声望盒子使用次数达到限制
---@field ERR_PRESTIGE_USE_TIPS number @value:1978,des:声望盒子使用提示
---@field ERR_CAT_TRADE_VIP_COUNT_LIMIT number @value:1979,des:VIP用户猫手刷新使用次数达到上限
---@field ERR_HAIR_ALREADY_HAVE number @value:1980,des:已经解锁发型
---@field ERR_EYES_ALREADY_HAVE number @value:1981,des:已经解锁美瞳
---@field ERR_UNLOCK_FAILED number @value:1982,des:解锁失败
---@field ERR_HAIR_NEED_UNLOCK number @value:1983,des:发型还未解锁
---@field ERR_EYES_NEED_UNLOCK number @value:1984,des:美瞳还未解锁
---@field ERR_LACK_COIN103 number @value:1985,des:缺少金币103
---@field ERR_LACK_COIN104 number @value:1986,des:缺少金币104
---@field ERR_CAN_RECV_AWARDS number @value:1987,des:应该领取奖励
---@field ERR_BINGO_NO_DATA number @value:1988,des:BINGO没有数据
---@field ERR_BINGO_ALREADY_LIGHT number @value:1989,des:BINGO已经点亮
---@field ERR_BINGO_NEED_GUESS number @value:1990,des:BINGO需要先猜
---@field ERR_BINGO_REDUCE_ITEM_FAIL number @value:1991,des:BINGO道具扣除失败
---@field ERR_BINGO_IN_CD number @value:1992,des:猜数字还在冷却中
---@field ERR_BINGO_NOT_EXSIT number @value:1993,des:BINGO不存在猜测的数据
---@field ERR_BINGO_GUESS_NOT_OPEN number @value:1994,des:BINGO不在猜测时间
---@field ERR_BINGO_GUESS_WRONG number @value:1995,des:BINGO猜测错误
---@field ERR_BINGO_ALREADY_GUESS number @value:1996,des:BINGO已经猜过
---@field ERR_BINGO_NOT_SATIFY number @value:1997,des:条件不满足无法领奖
---@field ERR_BINGO_ALREADY_GET_AWARD number @value:1998,des:已经领过奖励
---@field ERR_HEALTH_BATTLE_QUICKLY number @value:1999,des:已有更好的挂机加速糖
---@field ERR_ROLE_TIRED number @value:2000,des:玩家疲惫状态
---@field ERR_USE_LIMIT number @value:2001,des:超过使用限制
---@field ERR_DABAO_CANDY_RATE number @value:2002,des:已有更高级的打宝糖
---@field ERR_CANDY_USE_SUCC number @value:2003,des:(tips用)你已成功使用挂机加速糖
---@field ERR_CANDY_OVER number @value:2004,des:(tps用)加速糖效果消失
---@field ERR_DABAOCANDY_USE_SUCC number @value:2005,des:(tips用)成功使用打宝糖
---@field ERR_PAY_LOCKING number @value:2006,des:支付锁锁住了，稍后再试
---@field ERR_CHATFORBID_DOUBLE_ADD number @value:2007,des:屏蔽聊天重复操作，对方已经在屏蔽名单，
---@field ERR_CHATFORBID_DOUBLE_DEL number @value:2008,des:屏蔽聊天重复操作，对象不在屏蔽名单里，无法删除
---@field ERR_MS_NOT_HAVE_ROLE_CHAT_FORBID_DATA number @value:2009,des:没有聊天屏蔽数据
---@field ERR_CHATFORBID_ADD_TOO_MUCH number @value:2010,des:屏蔽名单超过上限，无法添加
---@field ERR_REPEATED_GET_AWARD number @value:2011,des:重复领取奖励
---@field ERR_PRE_REGISTER_DB_FAILED number @value:2012,des:预注册数据库错误
---@field ERR_PRE_REGISTER_ESCAPE_STRING_FAILED number @value:2013,des:预注册转义字符串错误
---@field ERR_PRE_REGISTER_QUERY_ACCOUNT_FAILED number @value:2014,des:预注册查询account表错误
---@field ERR_PRE_REGISTER_INSERT_ACCOUNT_REPEATED number @value:2015,des:预注册account表重复注册
---@field ERR_PRE_REGISTER_INSERT_ROLE_FAILED number @value:2016,des:预注册插入role表错误
---@field ERR_PRE_REGISTER_UPDATE_ACCOUNT_FAILED number @value:2017,des:预注册更新account表错误
---@field ERR_PRE_REGISTER_INSERT_ACCOUNT_FAILED number @value:2018,des:预注册插入account表错误
---@field ERR_CONNECT_NS_FAILED number @value:2019,des:连接controlserver失败
---@field ERR_PRE_REGISTER_ACCOUNT_NOT_EXPIRE number @value:2020,des:预注册没有过期
---@field ERR_PRE_REGISTER_PARSE_STRING_ROLE_FAILED number @value:2021,des:预注册解析role的pb失败
---@field ERR_PRE_REGISTER_ROLE_UUID_INVALID number @value:2022,des:预注册的role的id非法
---@field ERR_PRE_REGISTER_DELETE_ACCOUNT_FAILED number @value:2023,des:预注册删除account失败
---@field ERR_PRE_REGISTER_QUERY_ROLE_FAILED number @value:2024,des:预注册查询role失败
---@field ERR_PRE_REGISTER_QUERY_ROLE_FIELD_FAILED number @value:2025,des:预注册查询role字段失败
---@field ERR_PRE_REGISTER_DELETE_ROLE_FAILED number @value:2026,des:预注册删除role失败
---@field ERR_NO_BACKSTAGE_ACT number @value:2027,des:暂时没有可显示的节日活动
---@field ERR_SKILL_IS_IN_ACTIVE number @value:2028,des:技能处于激活状态
---@field ERR_CHATTAG_NOT_HAVE number @value:2029,des:没有拥有这个标签
---@field ERR_TEAM_MEMBER_OFFLINE number @value:2030,des:有队员不在线
---@field ERR_COMMONAWARD_FAILED number @value:2031,des:通用领奖错误
---@field ERR_COMMONAWARD_CHECK_FAILD number @value:2032,des:通用领奖条件检测失败
---@field ERR_FASHION_COUNT_NOT_REACH number @value:2033,des:时尚等级未达到
---@field ERR_FASHION_COUNT_AWARD_GOT number @value:2034,des:时尚等级奖励已经领取过
---@field ERR_SHOP_HAND_BOOK_LV_LIMIT number @value:2035,des:魔物研究等级限制
---@field ERR_ATTR_CLEAR_CLEARED number @value:2036,des:不需要清空属性点,已清空过
---@field ERR_MVP_PART_AWARD number @value:2037,des:参与奖稍后发放
---@field ERR_POSTCARD_NOT_FINISH_CHAP number @value:2038,des:没有完成章节无法领奖
---@field ERR_PAY_GOODS_NOT_EXISTS number @value:2039,des:商品不存在
---@field ERR_PAY_REGION_INVALID number @value:2040,des:地区验证失败
---@field ERR_PAY_GOODS_UNSALE number @value:2041,des:商品不是售卖状态
---@field ERR_RELOGIN_FROM_OTHER_SERVER number @value:2042,des:账号在其他服有登录
---@field ERR_RETURN_PRIZE_TASK_NOT_FINISH number @value:2043,des:回归任务奖励领取失败，条件还没达成
---@field ERR_RETURN_LOGINPRIZE_NOT_FINISHED number @value:2044,des:老用户回归登录奖励无法领取
---@field ERR_STONE_GET_STONE_AWARD_LIMIT number @value:2045,des:领取纪念币奖励超出次数
---@field ERR_MALL_REFRESH_LACKOF_ITEM number @value:2046,des:卖场手动刷新刷新券不足
---@field ERR_MALL_REFRESH_COUNT_LIMIT number @value:2047,des:本日刷新已达上限
---@field ERR_MALL_REFRESH_COOL_DOWN_LIMIT number @value:2048,des:卖场个人刷新频繁
---@field ERR_CREATE_ORDER_CD number @value:2049,des:申请订单cd中
---@field ERR_RETURN_WELCOME_WRONG_STATUS number @value:2050,des:回归欢迎流程前后端状态不对
---@field ERR_ACTIVITY_NOTIN_AWARD_TIME number @value:2051,des:不在活动领奖时间
---@field ERR_ACTIVITY_ALREADY_AWARD number @value:2052,des:奖励已领取
---@field ERR_ACTIVITY_WRONG_TYPE number @value:2053,des:活动类型错误
---@field ERR_ACTIVITY_TASK_ENDS number @value:2054,des:所以任务已完成
---@field ERR_LEVEL_GIFT_LEVEL_NOT_ENOUGH number @value:2055,des:等级礼包领取等级不够
---@field ERR_GUILDMATCH_UNQUALIFIED number @value:2056,des:该公会没有资格参加公会匹配赛
---@field ERR_TEAM_INVITE_CD number @value:2057,des:组队邀请cd还没满
---@field ERR_SCENE_LINE_CAMP_FULL number @value:2058,des:场景分线阵营人数已满
---@field ERR_NOT_THE_SAME_CAMP number @value:2059,des:不是同阵营关系
ErrorCode = {}

---@class LoginType
---@field LOGIN_PASSWORD number @value:0,des:
---@field LOGIN_SNDA_PF number @value:1,des:
---@field LOGIN_QQ_PF number @value:2,des:
---@field LGOIN_WECHAT_PF number @value:3,des:
---@field LOGIN_IOS_GUEST number @value:4,des:
---@field LOGIN_IOS_AUDIT number @value:5,des:
---@field LOGIN_JOYYOU_GUEST number @value:6,des:游客登录
---@field LOGIN_JOYYOU_GOOGLE number @value:7,des:谷歌登录
---@field LOGIN_JOYYOU_FACEBOOK number @value:8,des:脸书登录
---@field LOGIN_JOYYOU_APPLE number @value:9,des:苹果登录
LoginType = {}

---@class PlatType
---@field PLAT_IOS number @value:0,des:
---@field PLAT_ANDROID number @value:1,des:
---@field PLAT_PC number @value:2,des:
PlatType = {}

---@class GameAppType
---@field GAME_APP_NONE number @value:0,des:
---@field GAME_APP_WECHAT number @value:1,des:
---@field GAME_APP_QQ number @value:2,des:
---@field GAME_APP_NET number @value:3,des:内网
GameAppType = {}

---@class EnumServerState
---@field ServerState_Maintain number @value:0,des:
---@field ServerState_Smooth number @value:1,des:
---@field ServerState_Hot number @value:2,des:
---@field ServerState_Full number @value:3,des:
---@field ServerState_Recommend number @value:4,des:
---@field ServerState_Auto number @value:5,des:
EnumServerState = {}

---@class ServerFlag
---@field ServerFlag_Maintain number @value:0,des:
---@field ServerFlag_New number @value:1,des:
---@field ServerFlag_Hot number @value:2,des:
---@field ServerFlag_Full number @value:3,des:
---@field ServerFlag_Recommend number @value:4,des:
---@field ServerFlag_Dummy number @value:5,des:
---@field ServerFlag_Smooth number @value:6,des:
ServerFlag = {}

---@class SceneType
---@field SCENE_NONE number @value:0,des:
---@field SCENE_HALL number @value:1,des:
SceneType = {}

---@class EnterSceneType
---@field ENTER_SCENE_NONE number @value:0,des:
---@field ENTER_SCENE_SELECT_ROLE number @value:1,des:
---@field ENTER_SCENE_SWITCH number @value:2,des:
---@field ENTER_SCENE_SWITCH_BACK number @value:3,des:
EnterSceneType = {}

---@class ReviveType
---@field Revive_None number @value:0,des:
---@field Revive_Self number @value:1,des:
---@field Revive_Other number @value:2,des:
---@field Revive_Item number @value:3,des:
---@field Revive_VIP number @value:4,des:VIP用户可以在野图[SceneType=2,默认配置为记录点复活]原地复活.
ReviveType = {}

---@class EntityCategory
---@field Category_Invalid number @value:0,des:非法数值
---@field Category_Role number @value:1,des:
---@field Category_Enemy number @value:2,des:
---@field Category_DummyRole number @value:3,des:
---@field Category_Bullet number @value:4,des:
---@field Category_NPC number @value:5,des:
---@field Category_DummyMob number @value:6,des:
---@field Category_AirWall number @value:7,des:空气墙
---@field Category_WallTrigger number @value:8,des:
---@field Category_Vehicle number @value:9,des:公共载具
---@field Category_MobMonster number @value:10,des:召唤怪
---@field Category_Collection number @value:11,des:采集物
---@field Category_Eagle number @value:12,des:老鹰
---@field Category_Trap number @value:13,des:陷阱
---@field Category_Item number @value:14,des:掉落物
---@field Category_DropBuff number @value:15,des:掉落buff
---@field Category_SceneTriggerObject number @value:16,des:场景触发物件
---@field Category_MirrorRole number @value:17,des:镜像玩家
---@field Category_Mercenary number @value:18,des:佣兵
EntityCategory = {}

---@class BroadCastType
---@field BroadCastToAll number @value:0,des:
---@field BroadCastCustom number @value:1,des:
BroadCastType = {}

---@class RoleType
---@field Role_None number @value:0,des:
---@field Role_Novice number @value:1000,des:初心者
---@field Role_SwordMan number @value:2000,des:剑士
---@field Role_Knight number @value:2101,des:骑士
---@field Role_LordKnight number @value:2102,des:骑士领主
---@field Role_RuneKnight number @value:2103,des:符文骑士
---@field Role_Crusader number @value:2201,des:十字军
---@field Role_Paladin number @value:2202,des:圣殿十字军
---@field Role_RoyalGuard number @value:2203,des:皇家卫士
---@field Role_Acolyte number @value:3000,des:服事
---@field Role_Priest number @value:3101,des:牧师
---@field Role_HighPriest number @value:3102,des:神官
---@field Role_ArchBishop number @value:3103,des:大主教
---@field Role_Monk number @value:3201,des:武僧
---@field Role_Champion number @value:3202,des:武术宗师
---@field Role_Sura number @value:3203,des:修罗
---@field Role_Magician number @value:4000,des:法师
---@field Role_Wizard number @value:4101,des:巫师
---@field Role_HighWizard number @value:4102,des:超魔导士
---@field Role_Warlock number @value:4103,des:大法师
---@field Role_Sage number @value:4201,des:贤者
---@field Role_Professor number @value:4202,des:智者
---@field Role_Sorcerer number @value:4203,des:元素使
---@field Role_Thief number @value:5000,des:盗贼
---@field Role_Assassin number @value:5101,des:刺客
---@field Role_AssassinCross number @value:5102,des:十字刺客
---@field Role_GuillotineCross number @value:5103,des:十字切割者
---@field Role_Rogue number @value:5201,des:流氓
---@field Role_Stalker number @value:5202,des:神行太保
---@field Role_ShadowChaser number @value:5203,des:逐影
---@field Role_Merchant number @value:6000,des:商人
---@field Role_Blacksmith number @value:6101,des:铁匠
---@field Role_WhiteSmith number @value:6102,des:神工匠
---@field Role_Mechanic number @value:6103,des:机匠
---@field Role_Alchemist number @value:6201,des:炼金术士
---@field Role_Creator number @value:6202,des:创造者
---@field Role_Genetic number @value:6203,des:基因学者
---@field Role_Archer number @value:7000,des:弓箭手
---@field Role_Hunter number @value:7101,des:猎人
---@field Role_Sniper number @value:7102,des:神射手
---@field Role_Ranger number @value:7103,des:游侠
---@field Role_Bard_Dancer number @value:7201,des:吟游诗人/舞娘
---@field Role_Clown_Gypsy number @value:7202,des:搞笑艺人/冷艳舞姬
---@field Role_Minstrel_Wanderer number @value:7203,des:宫廷乐师/漫游舞者
RoleType = {}

---@class FightGroupType
---@field FightNone number @value:0,des:
---@field FightEnemy number @value:1,des:
---@field FightRole number @value:2,des:
FightGroupType = {}

---@class SceneFinishState
---@field SCENE_FINISH_NONE number @value:0,des:
---@field SCENE_FINISH_START number @value:1,des:
---@field SCENE_FINISH_END number @value:2,des:
SceneFinishState = {}

---@class EntitySpecies
---@field Species_None number @value:0,des:
---@field Species_Boss number @value:1,des:
---@field Species_Opposer number @value:2,des:
---@field Species_Puppet number @value:3,des:
---@field Species_Elite number @value:4,des:
EntitySpecies = {}

---@class StartUpType
---@field StartUp_Normal number @value:0,des:
---@field StartUp_QQ number @value:1,des:
---@field StartUp_WX number @value:2,des:
StartUpType = {}

---@class ReadAccountDataType
---@field READ_ACCOUNT_DATA_LOGIN number @value:0,des:
---@field READ_ACCOUNT_DATA_RETURN_SELECT_ROLE number @value:1,des:
---@field READ_ACCOUNT_DATA_IDIP number @value:2,des:
---@field READ_ACCOUNT_DATA_CLIENT_PULL number @value:3,des:客户端主动拉取
---@field READ_ACCOUNT_DATA_TAG number @value:4,des:获得标签信息读取
---@field READ_ACCOUNT_DATA_CLOSE_TAG number @value:5,des:关闭标签读取
ReadAccountDataType = {}

---@class OutLookType
---@field OutLook_Fashion number @value:0,des:
---@field OutLook_Equip number @value:1,des:
OutLookType = {}

---@class LogoutType
---@field LOGOUT_ACCOUNT_NORMAL number @value:0,des:
---@field LOGOUT_RELOGIN_KICK_ACCOUNT number @value:1,des:
---@field LOGOUT_IDIP_KICK_ACCOUNT number @value:2,des:
---@field LOGOUT_RETURN_SELECT_ROLE number @value:3,des:
---@field LOGOUT_CHANGEPROFESSION number @value:4,des:
---@field LOGOUT_RECONNECT_ROLE number @value:5,des:重连登出角色
---@field LOGOUT_BAN_KICK_ROLE number @value:6,des:封号封角色踢出
---@field LOGOUT_DO_ENTER_SCENE_FAIL number @value:7,des:进场景失败，返回选角
---@field LOGOUT_SERVER_MAINTAIN number @value:8,des:服务器维护
LogoutType = {}

---@class LeaveSceneType
---@field LEAVE_SCENE_LOGOUT number @value:0,des:
---@field LEAVE_SCENE_SWITCH number @value:1,des:
LeaveSceneType = {}

---@class OutLookStateType
---@field OutLook_Normal number @value:0,des:
---@field OutLook_Sit number @value:1,des:
---@field OutLook_Dance number @value:2,des:
---@field OutLook_RidePet number @value:3,des:
---@field OutLook_Inherit number @value:4,des:
---@field OutLook_Fish number @value:5,des:
---@field OutLook_RidePetCopilot number @value:6,des:
OutLookStateType = {}

---@class ExpBackType
---@field EXPBACK_ABYSSS number @value:0,des:
---@field EXPBACK_NEST number @value:2,des:
---@field EXPBACK_CAMPTASK number @value:3,des:
ExpBackType = {}

---@class ItemFindBackType
---@field TOWER number @value:0,des:
ItemFindBackType = {}

---@class BagType
---@field BAG number @value:0,des:背包
---@field WAREHOUSE number @value:1,des:
---@field TEMPBAG number @value:2,des:
---@field BODY number @value:3,des:装备位
---@field SHORTCUTBAR number @value:4,des:
---@field ALLITEM number @value:5,des:
---@field VIRTUALITEM number @value:6,des:虚拟货币和钱
---@field FASHION_BAG number @value:7,des:时装背包
---@field CART number @value:8,des:手推车
---@field SPITEM number @value:9,des:特殊道具 目前用于头像
---@field MERCHANT_BAG number @value:10,des:跑商背包
---@field WARDROBE number @value:11,des:衣橱
---@field TITLE number @value:12,des:称号背包
---@field TITLE_USING number @value:13,des:使用中的称号
---@field LIFE_EQUIP number @value:14,des:生活装备
---@field BELLUZ number @value:15,des:贝鲁兹
---@field Warehouse_2 number @value:16,des:仓库页2
---@field Warehouse_3 number @value:17,des:
---@field Warehouse_4 number @value:18,des:
---@field Warehouse_5 number @value:19,des:
---@field Warehouse_6 number @value:20,des:
---@field Warehouse_7 number @value:21,des:
---@field Warehouse_8 number @value:22,des:
---@field Warehouse_9 number @value:23,des:
---@field PHOTO_FRAME number @value:24,des:0头像框/1气泡框
BagType = {}

---@class RiskBoxState
---@field RISK_BOX_LOCKED number @value:0,des:
---@field RISK_BOX_UNLOCKED number @value:2,des:
---@field RISK_BOX_CANGETREWARD number @value:3,des:
---@field RISK_BOX_GETREWARD number @value:4,des:
---@field RISK_BOX_DELETE number @value:5,des:
RiskBoxState = {}

---@class HeroBattleOver
---@field HeroBattleOver_Win number @value:0,des:
---@field HeroBattleOver_Lose number @value:2,des:
---@field HeroBattleOver_Draw number @value:3,des:
HeroBattleOver = {}

---@class LoginRewardState
---@field LOGINRS_CANNOT number @value:0,des:
---@field LOGINRS_HAVEHOT number @value:2,des:
---@field LOGINRS_HAVE number @value:3,des:
LoginRewardState = {}

---@class WeekReportDataType
---@field WeekReportData_GuildSign number @value:0,des:
---@field WeekReportData_WorldBoss number @value:2,des:
---@field WeekReportData_GuildRisk number @value:3,des:
---@field WeekReportData_GuildArena number @value:4,des:
---@field WeekReportData_GuildBoss number @value:5,des:
---@field WeekReportData_GuildTerryitory number @value:6,des:
WeekReportDataType = {}

---@class RiskGridType
---@field RISK_GRID_EMPTY number @value:0,des:
---@field RISK_GRID_NORMALREWARD number @value:2,des:
---@field RISK_GRID_REWARDBOX number @value:3,des:
---@field RISK_GRID_ADVENTURE number @value:4,des:
---@field RISK_GRID_DICE number @value:5,des:
---@field RISK_GRID_MAX number @value:6,des:
RiskGridType = {}

---@class PkResultType
---@field PkResult_Win number @value:0,des:
---@field PkResult_Lose number @value:2,des:
---@field PkResult_Draw number @value:3,des:
PkResultType = {}

---@class EmblemSlotType
---@field EmblemSlotType_None number @value:0,des:
---@field EmblemSlotType_Attri number @value:1,des:
---@field EmblemSlotType_Skill number @value:2,des:
---@field EmblemSlotType_ExtraSkill number @value:3,des:
EmblemSlotType = {}

---@class LiveType
---@field LIVE_RECOMMEND number @value:0,des:
---@field LIVE_PVP number @value:2,des:
---@field LIVE_NEST number @value:3,des:
---@field LIVE_PROTECTCAPTAIN number @value:4,des:
---@field LIVE_GUILDBATTLE number @value:5,des:
---@field LIVE_DRAGON number @value:6,des:
---@field LIVE_FRIEND number @value:7,des:
---@field LIVE_GUILD number @value:8,des:
---@field LIVE_FRIENDANDGUILD number @value:9,des:
---@field LIVE_HEROBATTLE number @value:10,des:
---@field LIVE_LEAGUEBATTLE number @value:11,des:
---@field LIVE_PVP2 number @value:12,des:
---@field LIVE_CUSTOMPK number @value:13,des:
---@field LIVE_MAX number @value:14,des:
LiveType = {}

---@class TeamMemberType
---@field TMT_NORMAL number @value:0,des:
---@field TMT_HELPER number @value:2,des:
---@field TMT_USETICKET number @value:3,des:
TeamMemberType = {}

---@class SkyCraftType
---@field SCT_RacePoint number @value:0,des:
---@field SCT_Eliminate number @value:2,des:
SkyCraftType = {}

---@class SCEliRoundType
---@field SCEliRound_None number @value:0,des:
---@field SCEliRound_8to4 number @value:1,des:
---@field SCEliRound_4to2 number @value:2,des:
---@field SCEliRound_2to1 number @value:3,des:
SCEliRoundType = {}

---@class KMatchType
---@field KMT_NONE number @value:0,des:
---@field KMT_EXP number @value:1,des:
---@field KMT_PVP number @value:2,des:
---@field KMT_HERO number @value:3,des:
---@field KMT_PK number @value:4,des:
---@field KMT_LEAGUE number @value:5,des:
---@field KMT_SKYCRAFT number @value:6,des:
---@field KMT_PKTWO number @value:7,des:
---@field KMT_MOBA number @value:8,des:
---@field KMT_WEEKEND_ACT number @value:9,des:
---@field KMT_CUSTOM_PKTWO number @value:10,des:
KMatchType = {}

---@class LeagueBattleType
---@field LeagueBattleType_RacePoint number @value:0,des:
---@field LeagueBattleType_Eliminate number @value:2,des:
---@field LeagueBattleType_CrossRacePoint number @value:3,des:
---@field LeagueBattleType_CrossEliminate number @value:4,des:
LeagueBattleType = {}

---@class ServerTag
---@field SERVER_TAG_NORMAL number @value:0,des:
---@field SERVER_TAG_IOS_AUDIT number @value:2,des:
ServerTag = {}

---@class CustomBattleOp
---@field CustomBattle_Query number @value:0,des:
---@field CustomBattle_Create number @value:2,des:
---@field CustomBattle_Join number @value:3,des:
---@field CustomBattle_Match number @value:4,des:
---@field CustomBattle_Reward number @value:5,des:
---@field CustomBattle_ClearCD number @value:6,des:
---@field CustomBattle_QueryRandom number @value:7,des:
---@field CustomBattle_QueryOne number @value:8,des:
---@field CustomBattle_DoCreate number @value:9,des:
---@field CustomBattle_DoJoin number @value:10,des:
---@field CustomBattle_UnJoin number @value:11,des:
---@field CustomBattle_UnMatch number @value:12,des:
---@field CustomBattle_Modify number @value:13,des:
---@field CustomBattle_QuerySelf number @value:14,des:
---@field CustomBattle_StartNow number @value:15,des:
---@field CustomBattle_DoClearCD number @value:16,des:
---@field CustomBattle_Drop number @value:17,des:
---@field CustomBattle_Search number @value:18,des:
CustomBattleOp = {}

---@class RoleState
---@field Logoff number @value:0,des:
---@field LoadScene number @value:1,des:
---@field InHall number @value:2,des:
---@field InBattle number @value:3,des:
RoleState = {}

---@class SexType
---@field SEX_MALE number @value:0,des:
---@field SEX_FEMALE number @value:1,des:
---@field SEX_UNKNOW number @value:2,des:
---@field SEX_SAME number @value:3,des:同性
---@field SEX_DIFFERENT number @value:4,des:异性
SexType = {}

---@class ArenaType
---@field ARENA_NONE number @value:0,des:
---@field ARENA_CUSTOM number @value:1,des:
---@field ARENA_MONKEY number @value:2,des:
ArenaType = {}

---@class ArenaState
---@field Arena_State_None number @value:0,des:
---@field Arena_Open_NoSee number @value:1,des:
---@field Arena_Open_CanSee number @value:2,des:
---@field Arena_Open_Ready number @value:3,des:
---@field Arena_Open_Playing number @value:4,des:
---@field Arena_Open_Ended number @value:5,des:
ArenaState = {}

---@class ArenaRoomPlayMode
---@field UNKNOWN_ROOMODE number @value:0,des:
---@field RANDOM_SHUFFLE number @value:1,des:
---@field CUSTOM_OPTIONAL number @value:2,des:
ArenaRoomPlayMode = {}

---@class ArenaUserState
---@field ARENAUSERSTATE_NONE number @value:0,des:
---@field ARENAUSERSTATE_JOIN number @value:1,des:
---@field ARENAUSERSTATE_LEAVE number @value:2,des:
---@field ARENAUSERSTATE_CHANGE_FIGHTGROUP number @value:3,des:
ArenaUserState = {}

---@class ArenaPvpFightGroup
---@field ARENA_FIGHTGROUP_NONE number @value:0,des:
---@field ARENA_FIGHTGROUP_RED number @value:1,des:
---@field ARENA_FIGHTGROUP_BLUE number @value:2,des:
ArenaPvpFightGroup = {}

---@class ArenaSyncType
---@field kArenaSyncTypeNone number @value:0,des:
---@field kArenaSyncTypeChangeCamp number @value:1,des:
---@field kArenaSyncTypeChangeOwner number @value:2,des:
---@field kArenaSyncTypeChangePlayMode number @value:3,des:
---@field kArenaSyncTypeMemberCanInvite number @value:4,des:
---@field kArenaSyncTypeMemberLeave number @value:5,des:
---@field kArenaSyncTypeMemberJoin number @value:6,des:
ArenaSyncType = {}

---@class ItemChangeReason
---@field ITEM_REASON_NONE number @value:0,des:
---@field ITEM_REASON_PICK_UP number @value:1,des:
---@field ITEM_REASON_MOVE_ITEM number @value:2,des:
---@field ITEM_REASON_USE number @value:3,des:
---@field ITEM_REASON_CLEAR_TEMP_BAG number @value:4,des:
---@field ITEM_REASON_JUNK number @value:5,des:
---@field ITEM_REASON_TASK_REMOVE number @value:6,des:
---@field ITEM_REASON_TASK_TAKE number @value:7,des:
---@field ITEM_REASON_TASK_REWARD number @value:8,des:
---@field ITEM_REASON_SKILL_STEAL number @value:9,des:【代码里没有使用】
---@field ITEM_REASON_MVP_FINAL_KILL_REWARD number @value:10,des:
---@field ITEM_REASON_MVP_TEAM_REWARD number @value:11,des:
---@field ITEM_REASON_CHANGE_HAIR number @value:12,des:做头发
---@field ITEM_REASON_APPRAISE_EQUIP number @value:13,des:鉴定装备
---@field ITEM_REASON_CHANGE_EYE number @value:14,des:做美瞳
---@field ITEM_REASON_BUY_ITEM number @value:15,des:商店购买道具
---@field ITEM_REASON_COOKING number @value:16,des:烹饪
---@field ITEM_REASON_DUNGEONS_RESULT number @value:17,des:副本结算
---@field ITEM_REASON_REVIVE number @value:18,des:复活
---@field ITEM_REASON_FORGE number @value:19,des:打造合成
---@field ITEM_REASON_TASK_EDEN number @value:20,des:乐园任务获得额外奖励
---@field ITEM_REASON_JOB_LEVEL_UPGRADE number @value:21,des:joblevel升级
---@field ITEM_REASON_TRANSFER_PROFESSION number @value:22,des:转职
---@field ITEM_REASON_GM_CMD number @value:23,des:GM命令
---@field ITEM_REASON_AWARD_PACK number @value:24,des:打开奖励包
---@field ITEM_REASON_OPEN_SYSTEM_REWARD number @value:25,des:功能开放发奖
---@field ITEM_REASON_USE_BUTTERFLY number @value:26,des:蝴蝶翅膀
---@field ITEM_REASON_TRADE_BUY number @value:27,des:商会购买
---@field ITEM_REASON_TRADE_SELL number @value:28,des:商会出售
---@field ITEM_REASON_REFINE number @value:29,des:精炼系统
---@field ITEM_REASON_COLLECT number @value:30,des:采集
---@field ITEM_REASON_GUILD_CREATE number @value:31,des:创建公会
---@field ITEM_REASON_ENCHANT number @value:32,des:附魔
---@field ITEM_REASON_MAIL number @value:33,des:邮件
---@field ITEM_REASON_STALL_REFRESH number @value:34,des:摆摊刷新
---@field ITEM_REASON_STALL_DRAW_MONEY number @value:35,des:摆摊提取钱币
---@field ITEM_REASON_STALL_BUY number @value:36,des:摆摊购买
---@field ITEM_REASON_STALL_BUY_NUM number @value:37,des:购买摊位
---@field ITEM_REASON_STALL_SELL_ITEM_DROP_DOWN number @value:38,des:摆摊下架
---@field ITEM_REASON_SELL_ITEM number @value:39,des:商店出售物品
---@field ITEM_REASON_SKILL_COST number @value:40,des:技能消耗
---@field ITEM_REASON_INSERTCARD number @value:41,des:插卡进装备
---@field ITEM_REASON_REMOVECARD number @value:42,des:装备拆卡
---@field ITEM_REASON_MAKEHOLE number @value:43,des:装备打洞
---@field ITEM_REASON_MAKEREFORM number @value:44,des:装备改造
---@field ITEM_REASON_TASK_REWARD_MAIN number @value:45,des:主线任务奖励
---@field ITEM_REASON_TASK_REWARD_BRANCH number @value:46,des:支线任务奖励
---@field ITEM_REASON_TASK_REWARD_AISHEN number @value:47,des:【代码里没有使用】爱神任务奖励
---@field ITEM_REASON_TASK_REWARD_EDEN number @value:48,des:【没有配置任务】伊甸园任务奖励
---@field ITEM_REASON_TASK_REWARD_PROFESSION number @value:49,des:转职任务奖励
---@field ITEM_REASON_DAILY_ACTIVITY number @value:50,des:完成日常活动
---@field ITEM_REASON_TURNTABLE_TICKTY number @value:51,des:抽奖券随机转盘
---@field ITEM_REASON_TURNTABLE_WABAO number @value:52,des:挖宝随机转盘
---@field ITEM_REASON_GIFT_SEND number @value:53,des:玩家礼物赠送
---@field ITEM_REASON_SEVEN_LOGIN_REWARD number @value:54,des:七日惊喜赠送
---@field ITEM_REASON_COLLECT_GARDEN number @value:55,des:采集木
---@field ITEM_REASON_COLLECT_MINING number @value:56,des:采集矿
---@field ITEM_REASON_COLLECT_FOOD number @value:57,des:料理
---@field ITEM_REASON_COLLECT_MEDICINE number @value:58,des:制药
---@field ITEM_REASON_COLLECT_DESSERT number @value:59,des:甜品
---@field ITEM_REASON_COLLECT_SMELT number @value:60,des:冶炼
---@field ITEM_REASON_COLLECT_FISHING number @value:61,des:钓鱼
---@field ITEM_REASON_FIVE_REFRESH number @value:62,des:凌晨5点刷新
---@field ITEM_REASON_MVP_JOIN_AWARD number @value:63,des:mvp参与奖励
---@field ITEM_REASON_EDEN_TICKET number @value:64,des:乐园团5环奖券
---@field ITEM_REASON_COLLECT_SMELT_WEAPON number @value:65,des:武器冶炼
---@field ITEM_REASON_COLLECT_SMELT_DEFEND number @value:66,des:装备冶炼
---@field ITEM_REASON_COLLECT_SMELT_ACC number @value:67,des:饰品冶炼
---@field ITEM_REASON_ATTR_CLEAR number @value:68,des:清除属性点
---@field ITEM_REASON_HYMN_TRIAL number @value:69,des:圣歌试炼副本通关
---@field ITEM_REASON_DIR_TELEPORT number @value:70,des:单向传送
---@field ITEM_REASON_EQUIP_COMPOUND number @value:71,des:物品合成
---@field ITEM_REASON_GUILD_BUILD number @value:72,des:参与公会建设
---@field ITEM_REASON_MATERIAL_MECHANT number @value:73,des:物品置换
---@field ITEM_REASON_ENCHANT_REBORN number @value:74,des:附魔提炼
---@field ITEM_REASON_BOLI_AWARD number @value:75,des:【代码里没有使用】波利点数达到条件给物品
---@field ITEM_REASON_GUILD_ITEM_EXCHANGE number @value:76,des:水晶精华上交
---@field ITEM_REASON_GUILD_WELFARE number @value:77,des:公会福利
---@field ITEM_REASON_CARD_RECYCLE number @value:78,des:卡片回收系统-分解
---@field ITEM_REASON_GUILD_DINNER_TASK_FINISH_SCENE_REWARD number @value:80,des:公会宴会任务完成场景奖励
---@field ITEM_REASON_GUILD_DINNER_EAT_DISH number @value:81,des:公会宴会吃菜
---@field ITEM_REASON_GUILD_DINNER_SCENE_REWARD number @value:82,des:宴会场景奖励
---@field ITEM_REASON_GUILD_QUIT_FREEZE number @value:83,des:公会退出冻结贡献度
---@field ITEM_REASON_GUILD_ENTER_FREEZE number @value:84,des:公会进入返还的贡献度
---@field ITEM_REASON_WORLD_PVE_BASE number @value:85,des:pve奖励
---@field ITEM_REASON_WORLD_PVE_ADDITIONAL number @value:86,des:pve额外奖励
---@field ITEM_REASON_ORNAMENT_RECYCLE number @value:87,des:头饰回收系统
---@field ITEM_REASON_USE_DEVICE number @value:88,des:置换器
---@field ITEM_REASON_DEVICE_MAKE number @value:89,des:置换器生成
---@field ITEM_REASON_REFINE_TRANSFER number @value:90,des:精炼转移
---@field ITEM_REASON_REFINE_UNLOCK_SEAL number @value:91,des:精炼解封
---@field ITEM_REASON_TASK_ADVENTURE number @value:92,des:冒险任务类型奖励
---@field ITEM_REASON_COOK_DUNGEONS number @value:93,des:双人副本结算
---@field ITEM_REASON_CAT_TRADE_REWARD number @value:94,des:猫手商会奖励
---@field ITEM_REASON_CAT_TRADE_SELL_GOODS number @value:95,des:猫手商会出售货物
---@field ITEM_REASON_MEDAL_ACTIVE number @value:96,des:勋章激活消耗物品
---@field ITEM_REASON_MEDAL_UPGRADE number @value:97,des:勋章升级消耗物品
---@field ITEM_REASON_MEDAL_RESET number @value:98,des:勋章属性重置消耗物品
---@field ITEM_REASON_TOWER_RESULT number @value:99,des:无限塔结算
---@field ITEM_REASON_BATTLE_RESULT number @value:100,des:战场结算
---@field ITEM_REASON_THEME_RESULT number @value:101,des:主题副本结算
---@field ITEM_REASON_CARD_DRAW number @value:102,des:卡片回收系统-抽取卡片
---@field ITEM_REASON_ORNAMENT_DRAW number @value:103,des:头饰回收系统-抽取头饰
---@field ITEM_REASON_MINI_JOIN_AWARD number @value:104,des:Mini参与奖励
---@field ITEM_REASON_PLATFORM_RESULT number @value:105,des:擂台结算
---@field ITEM_REASON_HERO_CHALLENGE_RESULT number @value:106,des:英雄挑战结算
---@field ITEM_REASON_PICK_UP_EXP number @value:107,des:杀怪经验掉落
---@field ITEM_REASON_DROP_PUBLIC number @value:108,des:共有掉落
---@field ITEM_REASON_DROP_PRIVATE number @value:109,des:个人掉落
---@field ITEM_REASON_GROUP_AWARD number @value:110,des:单人触摸,全Team获得
---@field ITEM_REASON_IDIP number @value:111,des:idip增加道具
---@field ITEM_REASON_GUILD_SEND_MAIL number @value:112,des:公会发送邮件
---@field ITEM_REASON_ROLL_POINT number @value:113,des:roll点玩法
---@field ITEM_REASON_FLOP number @value:114,des:翻牌玩法
---@field ITEM_REASON_KILL_MINI number @value:115,des:杀死mini
---@field ITEM_REASON_POSTCARD_AWARD number @value:116,des:萌新手册奖励
---@field ITEM_REASON_GUILD_CRYSTAL_QUICK_UPGRADE number @value:120,des:公会水晶快速升级
---@field ITEM_REASON_GUILD_CRYSTAL_GIVE_ENERGY number @value:121,des:公会水晶充能
---@field ITEM_REASON_GUILD_CRYSTAL_PRAY number @value:122,des:公会水晶祈福
---@field ITEM_REASON_DELEGATE_COST number @value:123,des:委托任务消费
---@field ITEM_REASON_DELEGATE_RETURN number @value:124,des:委托任务返还
---@field ITEM_REASON_DELEGATE_UPPER_LIMIT number @value:125,des:委托任务上限
---@field ITEM_REASON_DELEGATE_RESET number @value:126,des:委托任务重置
---@field ITEM_REASON_DELEGATE_ACTIVE_AWARD number @value:127,des:委托任务活跃奖励
---@field ITEM_REASON_ASSIST number @value:128,des:助战奖励
---@field ITEM_REASON_ASSIST_SPECIAL number @value:129,des:助战特殊奖励
---@field ITEM_REASON_THIRTY_SIGN_IN number @value:130,des:三十次签到奖励
---@field ITEM_REASON_ACHIEVEMENT_ITEM number @value:131,des:成就完成奖励
---@field ITEM_REASON_ACHIEVEMENT_POINT number @value:132,des:成就点奖励
---@field ITEM_REASON_DUNGEON_COST number @value:133,des:副本门票消耗
---@field ITEM_REASON_ACTIVE_JUNK number @value:134,des:主动销毁物品
---@field ITEM_REASON_DUNGEON_WEEK number @value:135,des:大秘境周活跃奖励
---@field ITEM_REASON_COBBLESTONE number @value:136,des:消耗委托证明获得原石
---@field ITEM_REASON_MAKE_STONE number @value:137,des:制作原石获得组织的团结力
---@field ITEM_REASON_SERVER_UNSYNC number @value:138,des:服务器数据不同步导致的数据变化
---@field ITEM_REASON_GUILD_HUNT_FINAL_REWARD number @value:140,des:公会狩猎最终奖励
---@field ITEM_REASON_GUILD_HUNT_DUNGEONS number @value:141,des:公会狩猎副本奖励
---@field ITEM_REASON_MAZE_DUNGEONS number @value:142,des:迷宫副本奖励物品
---@field ITEM_REASON_SEND_RED_ENEVLOPE number @value:143,des:发红包
---@field ITEM_REASON_GRAB_RED_ENEVLOPE number @value:144,des:抢红包
---@field ITEM_REASON_MERCHANT_BUY number @value:145,des:跑商买入
---@field ITEM_REASON_MERCHANT_SELL number @value:146,des:跑商卖出
---@field ITEM_REASON_MERCHANT_CLEAR number @value:147,des:跑商开始或结束清空背包
---@field ITEM_REASON_MERCHANT_INIT number @value:148,des:跑商初始化
---@field ITEM_REASON_MERCHANT_EVENT_BUY number @value:149,des:跑商事件购买
---@field ITEM_REASON_LEVEL_GIFT number @value:150,des:等级礼包相关
---@field ITEM_REASON_LIMITED_TIME_OFFER number @value:151,des:限时特惠
---@field ITEM_REASON_BUY_MALL_ITEM number @value:152,des:购买商城物品
---@field ITEM_REASON_PAY number @value:153,des:充值、赠送获得
---@field ITEM_REASON_DUNGEONS_AWARD number @value:154,des:副本领奖
---@field ITEM_REASON_FASHION_EVA_JOIN number @value:155,des:时尚评分参与奖励
---@field ITEM_REASON_DELEGATE_DARW_AWARD number @value:156,des:委托消耗证明抽奖
---@field ITEM_REASON_THEME_PARTY_INVITATION number @value:157,des:主题派对邀请函
---@field ITEM_REASON_THEME_PARTY_LOTTERY number @value:158,des:主题派对抽奖
---@field ITEM_REASON_OFFLINE_ITEM_DELETE number @value:159,des:离线模块删除物品
---@field ITEM_REASON_THEME_PARTY_EXP number @value:160,des:主题派对定时经验
---@field ITEM_REASON_GUILD_DINNER_PHOTO number @value:161,des:恶搞宝箱 雕塑拍照
---@field ITEM_REASON_CREAM_MELEE_WINNER number @value:162,des:工会宴会奶油乱斗赢家
---@field ITEM_REASON_CREAM_MELEE_WATCH number @value:163,des:工会宴会奶油乱斗观战
---@field ITEM_REASON_BATTLE_STATISTICS number @value:164,des:需要野外战斗统计
---@field ITEM_REASON_GUILD_DINNER_BOX number @value:165,des:公会礼盒
---@field ITEM_REASON_BIG_WORLD_FRUIT number @value:166,des:大世界果子采集
---@field ITEM_REASON_THEME_PARTY_DANCE number @value:167,des:主题派对特别奖励
---@field ITEM_REASON_GUILD_PACK number @value:168,des:公会礼盒
---@field ITEM_REASON_MULTI_TALENT number @value:169,des:多天赋
---@field ITEM_REASON_SKILL_RESET number @value:170,des:技能重置
---@field ITEM_REASON_COLLECT_DIG_TREASURE number @value:171,des:挖宝
---@field ITEM_REASON_GUILD_AUCTION number @value:172,des:公会拍卖
---@field ITEM_REASON_FASHION_COUNT_AWARD number @value:173,des:时尚度礼包
---@field ITEM_REASON_TAKE_OFF_EQUIP number @value:174,des:脱装备
---@field ITEM_REASON_WEAR_EQUIP number @value:175,des:穿装备
---@field ITEM_REASON_LEVEL_GIFT_BUY number @value:176,des:等级礼包购买
---@field ITEM_REASON_TOWER_DEFENSE_DUNGEON number @value:177,des:塔防奖励
---@field ITEM_REASON_VEHICLE number @value:178,des:升级载具
---@field ITEM_REASON_DEVELOP_VEHICLE number @value:179,des:载具素质培养
---@field ITEM_REASON_UPGRADE_MERCENARY_EQUIP number @value:180,des:升级佣兵装备
---@field ITEM_REASON_ADVANCE_MERCENARY_EQUIP number @value:181,des:进阶佣兵装备
---@field ITEM_REASON_UPGRADE_MERCENARY_TALENT number @value:182,des:升级佣兵天赋
---@field ITEM_REASON_STRENGTHEN_MERCENARY_TALENT number @value:183,des:强化佣兵天赋
---@field ITEM_REASON_RESET_MERCENARY_TALENT number @value:184,des:重置佣兵天赋
---@field ITEM_REASON_UPGRADE_MERCENARY number @value:185,des:升级佣兵
---@field ITEM_REASON_STUDY_MERCENARY_TALENT number @value:186,des:学习佣天赋
---@field ITEM_REASON_TLOG_LIFESKILL_DEBUG number @value:187,des:对生活技能的debug
---@field ITEM_REASON_TRADE_RESELL_ITEM number @value:188,des:摆摊重新上架
---@field ITEM_REASON_GUILD_KICK_OUT_ROLE number @value:189,des:公会踢成员
---@field ITEM_REASON_ENCHANT_REBORN_PERFECT number @value:190,des:完美提炼
---@field ITEM_REASON_ENCHANT_INHERIT number @value:191,des:附魔继承
---@field ITEM_REASON_THEME_PARTY_DANCE_RIGHT number @value:192,des:主题派对跳对奖励
---@field ITEM_REASON_TAKE_OFF_MULTI_EQUIP number @value:193,des:多天赋脱装备
---@field ITEM_REASON_WEAR_MULTI_EQUIP number @value:194,des:多天赋穿装备
---@field ITEM_REASON_NPC_PRESENT number @value:195,des:NPC馈赠
---@field ITEM_REASON_THEME_PARTY_JOIN_AWARD number @value:196,des:主题派对参与奖
---@field ITEM_REASON_STALL_SELL number @value:197,des:摆摊出售物品
---@field ITEM_REASON_OPEN_CHAMPAGNE number @value:198,des:开启公会宴会香槟祝福
---@field ITEM_REASON_DINNER_COMPETITION number @value:199,des:宴会比赛发放称号物品
---@field ITEM_REASON_PAY_FAILD number @value:200,des:支付失败
---@field ITEM_REASON_GUILD_DINNER_CHAMPAGNE_EXP number @value:201,des:开启香槟祝福后的exp奖励
---@field ITEM_REASON_GUILD_MATCH number @value:202,des:公会匹配赛
---@field ITEM_REASON_ASSIST_MENGXIN number @value:203,des:助战萌新用户
---@field ITEM_REASON_ASSIST_HUILIU number @value:204,des:助战回流用户
---@field ITEM_REASON_ASSIST_XIAOHAO number @value:205,des:助战小号用户
---@field ITEM_REASON_FASHIONTICKET number @value:206,des:时尚杂志邀请函
---@field ITEM_REASON_BATTLE_ASSIST_RESULT number @value:207,des:战场助战奖励
---@field ITEM_REASON_MONTH_CARD number @value:208,des:购买月卡
---@field ITEM_REASON_BUY_GIFT_PACK number @value:209,des:购买限定礼包
---@field ITEM_REASON_PICK_FREE_SMALL_GIFT_PCAK number @value:210,des:领取免费礼包
---@field ITEM_REASON_THEMESTORY_RESULT number @value:211,des:剧情本
---@field ITEM_REASON_COOK_DUNGEONS_WEEKEND number @value:212,des:周末宴会副本结算
---@field ITEM_REASON_TOWER_DEFENSE_WEEKAWARD number @value:213,des:塔防周奖励
---@field ITEM_REASON_BLACK_MARKET_SELL number @value:214,des:黑市售出道具
---@field ITEM_REASON_AUCTION_SUCCESS number @value:215,des:拍卖成功
---@field ITEM_REASON_AUCTION_BIB_FAILD number @value:216,des:出价失败
---@field ITEM_REASON_AUCTION_CANCEL_AUTO_BIB number @value:217,des:取消自动出价
---@field ITEM_REASON_AUCTION_BIB_BE_EXCEED number @value:218,des:出价被超过
---@field ITEM_REASON_AUCTION_BIB number @value:219,des:拍卖出价
---@field ITEM_REASON_OUTSIDE_BILL number @value:220,des:外部订单
---@field ITEM_REASON_EDEN_LUCK number @value:221,des:【代码里没有用到】乐园团幸运奖励
---@field ITEM_REASON_EDEN_PROFESSION number @value:222,des:【代码里没有用到】乐园团职业
---@field ITEM_REASON_EQUIP_DRAW number @value:223,des:装备抽取
---@field ITEM_REASON_EQUIP_RECYCLE number @value:224,des:分解装备
---@field ITEM_REASHON_YAHAHA_AWARD number @value:225,des:发现呀哈哈奖励
---@field ITEM_REASON_EXP_BLESS number @value:226,des:祝福经验
---@field ITEM_REASON_EXP_HEALTH number @value:227,des:健康经验
---@field ITEM_REASON_COLLECT_FOOD_FAILURE number @value:228,des:烹饪失败奖励
---@field ITEM_REASON_COLLECT_FOOD_BIG_SUCCESS number @value:229,des:烹饪大成功奖励
---@field ITEM_REASON_COLLECT_MEDICINE_FAILURE number @value:230,des:制药失败奖励
---@field ITEM_REASON_COLLECT_MEDICINE_BIG_SUCCESS number @value:231,des:制药大成功奖励
---@field ITEM_REASON_COLLECT_DESSERT_FAILURE number @value:232,des:甜品失败奖励
---@field ITEM_REASON_COLLECT_DESSERT_BIG_SUCCESS number @value:233,des:甜品大成功奖励
---@field ITEM_REASON_COLLECT_SMELT_WEAPON_FAILURE number @value:234,des:武器冶炼失败奖励
---@field ITEM_REASON_COLLECT_SMELT_WEAPON_BIG_SUCCESS number @value:235,des:武器冶炼大成功奖励
---@field ITEM_REASON_COLLECT_SMELT_DEFEND_FAILURE number @value:236,des:防具冶炼失败奖励
---@field ITEM_REASON_COLLECT_SMELT_DEFEND_BIG_SUCCESS number @value:237,des:防具冶炼大成功奖励
---@field ITEM_REASON_COLLECT_SMELT_ACC_FAILURE number @value:238,des:饰品冶炼失败奖励
---@field ITEM_REASON_COLLECT_SMELT_ACC_BIG_SUCCESS number @value:239,des:饰品冶炼大成功奖励
---@field ITEM_REASON_COLLECT_FOOD_FUSION number @value:240,des:烹饪组合奖励
---@field ITEM_REASON_COLLECT_MEDICINE_FUSION number @value:241,des:制药组合奖励
---@field ITEM_REASON_LIFE_SKILL_UPGRADE number @value:242,des:生活职业升级
---@field ITEM_REASON_UNSEAL_CARD number @value:243,des:卡片解封
---@field ITEM_REASON_MSASK number @value:244,des:ms请求扣除道具
---@field ITEM_REASON_PAPER_SUCC number @value:245,des:发送魔法信笺成功
---@field ITEM_REASON_MAGIC_PAPER_GRAB number @value:246,des:魔法信笺抢红包
---@field ITEM_REASON_RESET_WHEEL number @value:247,des:重置齿轮
---@field ITEM_REASON_CHOOSE_WHEEL_SKILL number @value:248,des:选择齿轮技能
---@field ITEM_REASON_COMPOSITE_WHEEL number @value:249,des:齿轮合成
---@field ITEM_REASON_MAINTEANCE_WHEEL number @value:250,des:齿轮保养
---@field ITEM_REASON_MONSTER_MANUAL number @value:251,des:魔物图鉴发奖励
---@field ITEM_REASON_EQUIP_INHERIT number @value:252,des:同名继承
---@field ITEM_REASON_QUIT_GIULD_REDUCE_ITEM number @value:253,des:退出公会扣除物品
---@field ITEM_REASON_GUILD_ORGANIZA_PERSONAL_AWARD number @value:254,des:公会组织手册阶段解锁个人奖励
---@field ITEM_REASON_TREASURE_HUNT_FOOTPRINT number @value:255,des:宝藏猎人魔物脚印直接给奖励
---@field ITEM_REASON_TREASURE_HUNT_BOX number @value:256,des:宝藏猎人魔物宝藏箱子
---@field ITEM_REASON_HUIYUAN_CARD number @value:257,des:会员卡[礼品卡]
---@field ITEM_REASON_HUIYUAN_CARD_CHANGE number @value:258,des:会员卡[礼品卡]数据更新
---@field ITEM_REASON_PRESTIGE_BOX number @value:259,des:声望盒子
---@field ITEM_REASON_UNLOCK_HAIR number @value:260,des:解锁新发型
---@field ITEM_REASON_UNLOCK_EYES number @value:261,des:解锁新美瞳
---@field ITEM_REASON_CHAT number @value:262,des:聊天
---@field ITEM_REASON_DIAMOND_SYNC number @value:263,des:payserver钻石同步
---@field ITEM_REASON_SPECIAL_SUPPLY number @value:264,des:特殊补给 限时活动
---@field ITEM_REASON_SPECIAL_SUPPLY_REDICE number @value:265,des:重新骰骰子
---@field ITEM_REASON_SPECIAL_SUPPLY_QUICK_DICE number @value:266,des:超前定制骰子
---@field ITEM_REASON_ACT_MONTH_CARD number @value:267,des:激活返利月卡
---@field ITEM_REASON_MAIL_GIVE_PAYMEN number @value:268,des:邮件领取付费道具
---@field ITEM_REASON_TOWER_JUMP number @value:269,des:无尽塔跳层奖励
---@field ITEM_REASON_BINGO_LIGHT number @value:270,des:Bingo点亮消耗
---@field ITEM_REASON_SPECIAL_ITEM_EXTRA number @value:271,des:特殊道具触发的额外奖励
---@field ITEM_REASON_CONSUME_SPECIAL_ITEM number @value:272,des:消耗特殊道具
---@field ITEM_REASON_MODIFY_ACTIVE number @value:273,des:玩家改变改变激活状态
---@field ITEM_REASON_HEALTH_QUICKLY number @value:274,des:挂机加速多倍糖
---@field ITEM_REASON_DABAO_CANDY number @value:275,des:魔物驱逐打宝糖
---@field ITEM_REASON_PAY_AWARD number @value:276,des:累计充值奖励
---@field ITEM_REASON_FRESH_MALL_CARDS number @value:277,des:刷新租赁卡片池
---@field ITEM_REASON_TEAMLEADER_EXTRA_AWARD number @value:278,des:组队队长额外奖励
---@field ITEM_REASON_TEAMLEADER_EXTRA_BIG_AWARD number @value:279,des:队长礼包开出较好的奖励，发世界公告
---@field ITEM_REASON_AUCTION_RETRY number @value:280,des:拍卖返还道具失败后重试
---@field ITEM_REASON_EXTRA_CARD_DROP number @value:281,des:额外卡片掉落
---@field ITEM_REASON_EXCHANGE_MONEY number @value:282,des:金币兑换zeny币
---@field ITEM_REASON_RETURN_TASK_PRIZE number @value:283,des:老用户回归任务奖励
---@field ITEM_REASON_RETURN_LOGIN_PRIZE number @value:284,des:老用户回归登录奖励
---@field ITEM_REASON_MALL_MANUAL_REFRESH number @value:285,des:卖场手动刷新扣除道具
---@field ITEM_REASON_GMT_NORMAL number @value:286,des:后台普通操作
---@field ITEM_REASON_GMT_REFUND number @value:287,des:gmt后台退款操作
---@field ITEM_REASON_RETURN_WELCOME_PRIZE number @value:288,des:回归欢迎界面奖励
---@field ITEM_REASON_TAGNEW_LEVELGIFT number @value:289,des:萌新等级奖励
---@field ITEM_REASON_WARRIOR_RECRUIT number @value:290,des:勇士招募
---@field ITEM_REASON_TASK_RECRUIT number @value:291,des:任务勇士招募
---@field ITEM_REASON_CAT_TRADE_SELL_EXTRA number @value:292,des:猫手出售新人加速
---@field ITEM_REASON_BAG_MOVE_TO_WAREHOUSE number @value:292,des:背包移入仓库
---@field ITEM_REASON_WAREHOUSE_MOVE_TO_BAG number @value:293,des:仓库移入背包
---@field ITEM_REASON_BAG_MOVE_TO_CART number @value:294,des:背包移入手推车
---@field ITEM_REASON_CART_MOVE_TO_BAG number @value:295,des:手推车移入背包
ItemChangeReason = {}

---@class CreateSceneType
---@field CreateSceneType_None number @value:0,des:
---@field CreateSceneType_Poll number @value:1,des:
---@field CreateSceneType_LeastLoad number @value:2,des:
CreateSceneType = {}

---@class OrnamentWearType
---@field OrnamentWearType_Invalid number @value:0,des:
---@field OrnamentWearType_Head number @value:1,des:头饰
---@field OrnamentWearType_Face number @value:2,des:脸饰
---@field OrnamentWearType_Mouth number @value:3,des:嘴饰
---@field OrnamentWearType_Back number @value:4,des:背饰
---@field OrnamentWearType_Tail number @value:5,des:尾部
---@field OrnamentWearType_Fashion number @value:6,des:时装
OrnamentWearType = {}

---@class ItemTypeTab
---@field ItemType_Invalid number @value:0,des:
---@field ItemType_Equip number @value:1,des:装备
---@field ItemType_Consumables number @value:2,des:消耗品
---@field ItemType_Material number @value:3,des:材料
---@field ItemType_Card number @value:4,des:卡片
---@field ItemType_BagOther number @value:5,des:背包内不分类道具
---@field ItemType_Fashion number @value:6,des:时装
---@field ItemType_Money number @value:7,des:虚拟道具，货币
---@field ItemType_CookBook number @value:8,des:食谱
---@field ItemType_Task number @value:9,des:任务道具
---@field ItemType_LifeEquip number @value:10,des:生活职业道具
---@field ItemType_HeadwearDrawing number @value:11,des:头饰图纸
---@field ItemType_Device number @value:12,des:置换器
---@field ItemType_HeadPortrait number @value:13,des:头像
---@field ItemType_Carrier number @value:14,des:载具
---@field ItemType_CarrierExpBook number @value:15,des:载具经验书
---@field ItemType_CardPatch number @value:16,des:卡牌碎片
---@field ItemType_Title number @value:17,des:称号
---@field ItemType_Commodity number @value:18,des:跑商道具
---@field ItemType_Monster number @value:19,des:魔物
---@field ItemType_Belluz number @value:20,des:贝鲁兹
---@field ItemType_EnchantStone number @value:21,des:封魔石
---@field ItemType_DoubleAwardCard number @value:22,des:双倍奖励触发卡
---@field ItemType_BingoNumber number @value:23,des:Bingo数字道具
---@field ItemType_SpecialItem number @value:24,des:特殊道具类型
---@field ItemType_ChatFrame number @value:26,des:聊天框
---@field ItemType_PortraitFrame number @value:27,des:头像框
ItemTypeTab = {}

---@class OutlookMask
---@field OutlookMask_None number @value:0,des:
---@field OutlookMask_Fashion number @value:1,des:时装
---@field OutlookMask_Ornament number @value:2,des:饰品
---@field OutlookMask_Hair number @value:4,des:头发
---@field OutlookMask_Equip number @value:8,des:装备
---@field OutlookMask_Eye number @value:16,des:眼睛（含类型与颜色）
---@field OutlookMask_HeadPortrait number @value:32,des:头像
---@field OutlookMask_Belluz number @value:64,des:贝鲁兹戒指
---@field OutlookMask_PortraitFrame number @value:128,des:头像框
---@field OutlookMask_All number @value:2147483647,des:所有外观
OutlookMask = {}

---@class EquipPos
---@field MAIN_WEAPON number @value:0,des:主武器
---@field SECONDARY_WEAPON number @value:1,des:副手武器
---@field HEAD_GEAR number @value:2,des:头盔
---@field FACE_GEAR number @value:3,des:脸饰
---@field MOUTH_GEAR number @value:4,des:嘴饰
---@field CLOAK number @value:5,des:披风
---@field ARMOR number @value:6,des:盔甲
---@field BOOTS number @value:7,des:鞋子
---@field ORNAMENT1 number @value:8,des:饰品1
---@field ORNAMENT2 number @value:9,des:饰品2
---@field BACK_GEAR number @value:10,des:背部饰品
---@field HORSE number @value:11,des:载具
---@field TROLLEY number @value:12,des:手推车
---@field BATTLE_HORSE number @value:13,des:战斗坐骑
---@field BATTLE_BIRD number @value:14,des:猎鹰鸟
---@field FASHION number @value:15,des:时装
EquipPos = {}

---@class ArenaRoomState
---@field ARENA_ROOM_STATE_DEFAULT number @value:0,des:
---@field ARENA_ROOM_STATE_START number @value:1,des:
---@field ARENA_ROOM_STATE_SETTLE number @value:2,des:
ArenaRoomState = {}

---@class ChatChannel
---@field CHAT_CHANNEL_WORLD number @value:0,des:
---@field CHAT_CHANNEL_TEAM number @value:1,des:
---@field CHAT_CHANNEL_GUILD number @value:2,des:
---@field CHAT_CHANNEL_PROFESSION number @value:3,des:
---@field CHAT_CHANNEL_CUR_SCENE number @value:4,des:
---@field CHAT_CHANNLE_SYSTEM number @value:5,des:
---@field CHAT_CHANNEL_SMALL_HORN number @value:6,des:
---@field CHAT_CHANNEL_BIG_HORN number @value:7,des:
ChatChannel = {}

---@class AnnouceType
---@field ANNOUNCE_NONE number @value:0,des:
---@field ANNOUCE_IMPORTANT number @value:1,des:重要公告
---@field ANNOUCE_SECONDARY number @value:2,des:次级公告
---@field ANNOUCE_DUNGEONS number @value:3,des:队伍公告
AnnouceType = {}

---@class WallCollideType
---@field kNone number @value:0,des:无阻挡
---@field kFaceLeft number @value:1,des:朝左（单向墙）
---@field kFaceRight number @value:2,des:朝右（单向墙）
---@field kFaceAll number @value:3,des:左右都有阻挡（双向墙）
WallCollideType = {}

---@class ReplyType
---@field REPLY_TYPE_REFUSE number @value:0,des:拒绝
---@field REPLY_TYPE_AGREE number @value:1,des:同意
ReplyType = {}

---@class FailEnterFBReason
---@field FAIL_ENTER_FB_SUCESS number @value:0,des:
---@field FAIL_ENTER_FB_ITEM_NOT_ENOUGH number @value:1,des:所需物品不足
---@field FAIL_ENTER_FB_FORMER_CHAPTER_UNLOCK number @value:2,des:之前章节尚未解锁
---@field FAIL_ENTER_FB_TASK_ERROR number @value:3,des:所需任务条件不满足
---@field FAIL_ENTER_FB_LEVEL_ERROR number @value:4,des:等级不满足条件
---@field FAIL_ENTER_FB_TIMES_LIMIT number @value:5,des:次数限制
---@field FAIL_ENTER_FB_MEMBER_NUMBER number @value:6,des:队伍人数不对
---@field FAIL_ENTER_FB_FAIL number @value:7,des:
---@field FAIL_ENTER_FB_IN_DUNGEONS number @value:8,des:已在副本中
---@field FAIL_ENTER_FB_SCENE_FAILED number @value:9,des:创建场景失败
---@field FAIL_ENTER_FB_REQUEST_TOO_FAST number @value:10,des:请求过于频繁
---@field FAIL_ENTER_FN_TIMEOUT number @value:11,des:超时
---@field FAIL_ENTER_FB_COOK_DUNGEON_TIME_LIMIT number @value:12,des:%s已经烹饪达到上限
---@field FAIL_ENTER_FB_SOMEONE_LEAVE_WAITING_SCENE number @value:13,des:有人离开了等候区
---@field FAIL_ENTER_BANNED number @value:14,des:%s处于封禁状态
---@field FAIL_ENTER_FB_DELEGATE_LACK number @value:15,des:没有该委托任务
---@field FAIL_ENTER_FB_DEAD number @value:16,des:玩家死了
---@field FAIL_ENTER_FB_NOT_IN_TEAM number @value:17,des:不在队伍里
---@field FAIL_ENTER_FB_IN_VEHICLE number @value:18,des:自己已在载具上
---@field FAIL_ENTER_FB_SELF_IN_DUNGEONS number @value:19,des:自己已经在副本里面
---@field FAIL_ENTER_FB_RUN_BUSINESS number @value:20,des:处于跑商状态
---@field FAIL_ENTER_FB_NUMBER_FEW number @value:21,des:需要一个至少n人的队伍
---@field FAIL_ENTER_FB_NUMBER_MANY number @value:22,des:需要一个最多n人的队伍
---@field FAIL_ENTER_FB_LEVEL_FEW number @value:23,des:至少需要N等级
---@field FAIL_ENTER_FB_LEVEL_MANY number @value:24,des:最多n的等级
---@field FAIL_ENTER_FB_CHECK_STATE number @value:25,des:状态互斥没通过
---@field FAIL_ENTER_FB_SYSTEM_NOT_OPENED number @value:26,des:有玩家的功能没有开启
---@field FAIL_ENTER_FB_WATCHING number @value:27,des:角色观战中
---@field FAIL_ENTER_FB_PRE_WAVE number @value:28,des:前置波次不够
---@field FAIL_ENTER_FB_NOT_ACTIVITY number @value:29,des:不在活动估时间内
---@field FAIL_ENTER_FB_CURR_SCENE_NOT_ALLOW number @value:30,des:当前场景不允许
---@field FAIL_ENTER_FB_MEMBER_IN_SCENE number @value:31,des:有队员已经在场景中
FailEnterFBReason = {}

---@class DungeonsResultStatus
---@field kResultNone number @value:0,des:
---@field kResultVictory number @value:1,des:
---@field kResultLose number @value:2,des:
---@field kResultDraw number @value:3,des:平局
---@field kResultMazeRoomVictory number @value:4,des:迷宫房间胜利
---@field kResultAssistSuccess number @value:5,des:助战成功
DungeonsResultStatus = {}

---@class DungeonsBattleAttr
---@field DUNGEONS_BATTLE_TAKEN number @value:0,des:承受伤害
---@field DUNGEONS_BATTLE_DAMAGE number @value:1,des:造成伤害
---@field DUNGEONS_BATTLE_HEAL number @value:2,des:恢复血量
---@field DUNGEONS_BATTLE_FATAL_HIT number @value:3,des:致命一击
DungeonsBattleAttr = {}

---@class WeatherType
---@field kWeatherTypeNone number @value:0,des:无
---@field kWeatherTypeSunny number @value:1,des:晴天
---@field kWeatherTypeCloudy number @value:2,des:阴天
---@field kWeatherTypeFog number @value:3,des:雾天
---@field kWeatherTypeLightRain number @value:4,des:小雨
---@field kWeatherTypeHeavyRain number @value:5,des:大雨
---@field kWeatherTypeThunderRain number @value:6,des:雷雨
---@field kWeatherTypeLightSnow number @value:7,des:小雪
---@field kWeatherTypeHeavySnow number @value:8,des:大雪
---@field kWeatherTypeSandstorm number @value:9,des:沙尘
---@field kWeatherTypeAfterRain number @value:10,des:雨后
---@field kWeatherTypeAfterSnow number @value:11,des:雪后
WeatherType = {}

---@class CookingQte
---@field kCookQteNone number @value:0,des:无动作
---@field kCookQteFire number @value:1,des:控制火力
---@field kCookQteStir number @value:2,des:搅拌
CookingQte = {}

---@class TeleportType
---@field kTeleportPointTypeNone number @value:0,des:无
---@field kTeleportPointTypeWall number @value:1,des:传送阵
---@field kTeleportPointTypeKapula number @value:2,des:卡普拉
---@field kTeleportPointTypeFinish number @value:3,des:终点
TeleportType = {}

---@class FoodOperation
---@field FOOD_OPERATION_NONE number @value:0,des:
---@field FOOD_OPERATION_PICK number @value:1,des:
---@field FOOD_OPERATION_CUT number @value:2,des:
---@field FOOD_OPERATION_DROP number @value:3,des:
---@field FOOD_OPERATION_PICK_POT number @value:4,des:起锅
FoodOperation = {}

---@class CookingPotState
---@field kCookPotStateEmpty number @value:0,des:空锅
---@field kCookPotStateCook number @value:1,des:正在煮
---@field kCookPotStateWaitServe number @value:2,des:等待起锅
CookingPotState = {}

---@class CookDungeonAttr
---@field COOK_DUNGEONS_NONE number @value:0,des:
---@field COOK_DUNGEONS_FINISHED number @value:1,des:
---@field COOK_DUNGEONS_FAILED number @value:2,des:
---@field COOK_DUNGEONS_BOOMED number @value:3,des:
---@field COOK_DUNGEONS_SCORE number @value:4,des:烹饪副本得分
CookDungeonAttr = {}

---@class PositionSyncReason
---@field kSyncPositionUnknow number @value:0,des:
---@field kSyncPositionTeleport number @value:1,des:传送
---@field kSyncPositionCorrect number @value:2,des:纠正拉回
---@field kSyncPositionBeatbackEnd number @value:3,des:纠正击退
---@field kSyncPositionFall number @value:4,des:掉落
---@field kSyncPositionAiSetPosition number @value:5,des:AI设置位置
---@field kSyncPositionFlywings number @value:6,des:苍蝇翅膀传送
---@field kSyncPositionDetached number @value:7,des:脱离卡死
---@field kSyncPositionRevive number @value:8,des:复活设置位置
---@field kSyncPositinCutScene number @value:9,des:客户端播放动画后位置转移
PositionSyncReason = {}

---@class RoleModuleType
---@field kRoleModuleTypeNone number @value:0,des:空占位
---@field kRoleModuleTypeBrief number @value:1,des:外貌信息
---@field kRoleModuleTypeExtraInfo number @value:2,des:额外信息
---@field kRoleModuleTypeSkill number @value:3,des:技能信息
---@field kRoleModuleTypeQualityPoint number @value:4,des:素质加点
---@field kRoleModuleTypeBag number @value:5,des:背包信息
---@field kRoleModuleTypeGameRole number @value:6,des:库里使用
---@field kRoleModuleTypeTask number @value:7,des:任务相关
---@field kRoleModuleTypeFashion number @value:8,des:时装信息
---@field kRoleModuleTypeEquip number @value:9,des:所有装备
---@field kRoleModuleTypeSticker number @value:10,des:贴纸系统
---@field kRoleModuleTypeVehicle number @value:11,des:载具记录
---@field kRoleModuleTypeOpenSystem number @value:12,des:系统开放
---@field kRoleModuleTypeShop number @value:13,des:商店信息
---@field kRoleModuleTypeDungeon number @value:14,des:副本记录
---@field kRoleModuleTypeCount number @value:15,des:所有计数相关
---@field kRoleModuleTypeGuarantee number @value:16,des:保底机制
---@field kRoleModuleTypeScript number @value:17,des:所有lua相关数据
---@field kRoleModuleTypeSevenLogin number @value:18,des:七日登录
---@field kRoleModuleTypeLifeSkill number @value:19,des:生活技能
---@field kRoleModuleTypeLifeEquip number @value:20,des:生活技能装备
---@field kRoleModuleTypeTempRecord number @value:21,des:
---@field kRoleModuleTypeAchievement number @value:22,des:成就信息
---@field kRoleModuleTypeIllustration number @value:23,des:图鉴
---@field kRoleModuleTypeHealth number @value:24,des:健康时间
---@field kRoleModuleTypeWorldEvent number @value:25,des:世界pve事件
---@field kRoleModuleTypeCatTrade number @value:26,des:猫手商队
---@field kRoleModuleTypeMedal number @value:27,des:勋章模块
---@field kRoleModuleTypeTutorialMark number @value:28,des:新手引导
---@field kRoleModuleTypePay number @value:29,des:充值模块
---@field kRoleModuleTypePostcard number @value:30,des:萌新手册
---@field kRoleModuleTypeDelegate number @value:31,des:委托
---@field kRoleModuleTypeThirtySign number @value:32,des:三十次签到
---@field kRoleModuleTypeSuit number @value:33,des:装备套装
---@field kRoleModuleTypeMerchant number @value:34,des:跑商
---@field kRoleModuleTypeLuaActivity number @value:35,des:Lua活动模块
---@field kRoleModuleTypeLimitedTimeOffer number @value:36,des:限时特惠
---@field kRoleModuleTypeMall number @value:37,des:商城
---@field kRoleModuleTypeGuildAuctionRecordPersonal number @value:38,des:拍卖记录私人存档
---@field kRoleModuleTypeDungeonWatch number @value:39,des:观战
---@field kRoleModuleTypeMercenary number @value:40,des:佣兵
---@field kRoleModuleTypeVitalData number @value:41,des:关键数据
---@field kRoleModuleTypeCommondata number @value:42,des:通用数据
---@field kRoleModuleTypeItemComponent number @value:43,des:
---@field kRoleModuleTypeTag number @value:44,des:标签信息
---@field kRoleModuleTypeMonthCard number @value:45,des:月卡
---@field kRoleModuleTypeLuckyPoint number @value:46,des:幸运值
---@field kRoleModuleTypeSurprise number @value:47,des:奇遇
---@field kRoleModuleTypeCommonAward number @value:48,des:通用领奖组件
---@field kRoleModuleTypeChatTag number @value:49,des:聊天标签
---@field kRoleModuleTypeExtraCardDrop number @value:50,des:额外卡片掉落机制
---@field kRoleModuleTypeJifen number @value:51,des:积分值
RoleModuleType = {}

---@class SwitchSceneType
---@field SWITCH_SCENE_NULL number @value:0,des:
---@field SWITCH_SCENE_DELIVER number @value:1,des:传送
---@field SWITCH_SCENE_BATTLEFIELD_RUN_OUT number @value:2,des:战场次数用完
---@field SWITCH_SCENE_DELIVER_BUTTERFLY number @value:3,des:蝴蝶翅膀传送
SwitchSceneType = {}

---@class RefineAdditionalType
---@field Item_None number @value:0,des:什么都不添加
---@field Item_RollBack number @value:1,des:添加祝福不回退材料
---@field Item_Beecham number @value:2,des:添加祝福必成材料
RefineAdditionalType = {}

---@class RefineUpgradeResultType
---@field RESULT_NONE number @value:0,des:
---@field RESULT_SUCCESS number @value:1,des:成功
---@field RESULT_FAIL number @value:2,des:失败
---@field RESULT_FAIL_LOWER_LEVEL number @value:3,des:失败降级
---@field RESULT_FAIL_DISREPAIR number @value:4,des:损坏
RefineUpgradeResultType = {}

---@class YStyle
---@field YStyle_None number @value:0,des:会受到Y影响的维度: 无
---@field YStyle_Flying number @value:1,des:会受到Y影响的维度:飞行载具
---@field YStyle_Climbing number @value:2,des:会受到Y影响的维度:攀爬
YStyle = {}

---@class LeaveWallType
---@field LeaveWallType_None number @value:0,des:无
---@field LeaveWallType_Behit number @value:1,des:被击
---@field LeaveWallType_Finish number @value:2,des:到达终点
LeaveWallType = {}

---@class NavigationDestType
---@field NavigationDestType_None number @value:0,des:无
---@field NavigationDestType_Npc number @value:1,des:Npc
NavigationDestType = {}

---@class QueryRoleBriefType
---@field kQueryTeam number @value:0,des:组队查询
---@field kQueryPVPResult number @value:1,des:pvp结算查询
QueryRoleBriefType = {}

---@class NavigationMethodType
---@field NavigationMethodType_None number @value:0,des:无
---@field NavigationMethodType_Ground number @value:1,des:点地寻路
---@field NavigationMethodType_Map number @value:2,des:小地图寻路
NavigationMethodType = {}

---@class FriendType
---@field TYPE_SYSTEM number @value:0,des:系统
---@field TYPE_FRIEND number @value:1,des:好友
---@field TYPE_GROUP number @value:2,des:群
---@field TYPE_CONTACT number @value:3,des:联系人
---@field TYPE_STRANGER number @value:4,des:陌生人
FriendType = {}

---@class ChatMsgType
---@field CHAT_TYPE_PRIVATE number @value:0,des:私聊
---@field CHAT_TYPE_GROUP number @value:1,des:群聊
---@field CHAT_TYPE_TEAM number @value:2,des:队伍
---@field CHAT_TYPE_GUILD number @value:3,des:公会
---@field CHAT_TYPE_CURSCENE number @value:4,des:当前场景
---@field CHAT_TYPE_WORLD number @value:5,des:世界
---@field CHAT_TYPE_SYSTEM number @value:6,des:系统
---@field CHAT_TYPE_PROFESSION number @value:7,des:职业
---@field CHAT_TYPE_SMALLHORN number @value:8,des:小喇叭
---@field CHAT_TYPE_BIGHORN number @value:9,des:大喇叭
---@field CHAT_TYPE_CHAT_ROOM number @value:10,des:聊天室
---@field CHAT_TYPE_WATCH_ROOM number @value:11,des:观战聊天
ChatMsgType = {}

---@class SceneLineStatus
---@field SceneLineStatus_Uncrowded number @value:0,des:不拥挤
---@field SceneLineStatus_Crowded number @value:1,des:拥挤
SceneLineStatus = {}

---@class EnchantType
---@field EnchantCommonType number @value:0,des:普通附魔
---@field EnchantBlessType number @value:1,des:祝福附魔
EnchantType = {}

---@class TerrianType
---@field TERRIAN_TYPE_NONE number @value:0,des:普通地表
---@field TERRIAN_TYPE_SHALLOW_WATER number @value:1,des:浅水
---@field TERRIAN_TYPE_DEEP_WATER number @value:2,des:深水
TerrianType = {}

---@class MailOpType
---@field Mail_None number @value:0,des:
---@field Mail_Read number @value:1,des:
---@field Mail_Del number @value:2,des:
---@field Mail_ReadAll number @value:3,des:
---@field Mail_DelAll number @value:4,des:
MailOpType = {}

---@class MailDbOpType
---@field Mail_Op_Add number @value:0,des:
---@field Mail_Op_Update number @value:1,des:
---@field Mail_Op_Delete number @value:2,des:
MailDbOpType = {}

---@class EnumSystemType
---@field System_None number @value:0,des:
---@field System_Mail number @value:1,des:
EnumSystemType = {}

---@class HSRandomEvent
---@field kHSRandomEventTypeNone number @value:0,des:
---@field kHSRandomEventTypeSpecialMonster number @value:1,des:刷新特殊怪物
---@field kHSRandomEventTypeEliteMonster number @value:2,des:精英怪
---@field kHSRandomEventTypeBoss number @value:3,des:刷BOSS
---@field kHSRandomEventTypeRoleBuff number @value:4,des:玩家获得buff
---@field kHSRandomEventTypeMonsterBuff number @value:5,des:怪物获得buff
---@field kHSRandomEventTypeSecret number @value:6,des:不确定事件
HSRandomEvent = {}

---@class FriendOpType
---@field Friend_Add number @value:0,des:
---@field Friend_Delete number @value:1,des:
---@field Friend_Cover number @value:2,des:
FriendOpType = {}

---@class RedPointModule
---@field kRedPointModuleNone number @value:0,des:占位符
---@field kRedPointModuleRecommendPoint number @value:1,des:推荐加点
---@field kRedPointModuleFriend number @value:2,des:好友
---@field kRedPointModuleMail number @value:3,des:邮件
---@field kRedPointModuleStall number @value:4,des:摆摊
---@field kRedPointModuleReward number @value:5,des:获得礼包
---@field kRedPointModuleTeam number @value:6,des:队伍
---@field kRedPointModuleLimitTimeActive number @value:7,des:限时活动
---@field kRedPointModuleBoliPoint number @value:8,des:波利点奖励
---@field kRedPointModuleGuildApply number @value:9,des:公会申请
---@field kRedPointModuleProfessionFirst number @value:10,des:一转职业
---@field kRedPointModuleProfessionSecond number @value:11,des:二转预览
---@field kRedPointModuleProfessionSecondPreview number @value:12,des:二转预览
---@field kRedPointModuleForging number @value:13,des:锻造
---@field kRedPointModuleRefine number @value:14,des:精炼
---@field kRedPointModuleEnchant number @value:15,des:附魔
---@field kRedPointModuleHole number @value:16,des:打洞
---@field kRedPointModuleCard number @value:17,des:插卡
---@field kRedPointModuleOrnament number @value:18,des:配饰
---@field kRedPointModuleFashion number @value:19,des:时装
---@field kRedPointModuleLiveSkillUnlock number @value:20,des:解锁生活技能
---@field kRedPointModuleLiveSkillAvailable number @value:21,des:生活技能可用
---@field kRedPointModuleMax number @value:42,des:最大值
---@field kRedPointModuleKapulaAssistant number @value:41,des:卡普拉助手
---@field kRedPointModuleRedEnvelope number @value:43,des:红包
---@field kRedPointModuleAdventure number @value:51,des:冒险
---@field kRedPointModuleSticker number @value:65,des:贴纸
---@field kRedPointModuleGuildStone number @value:75,des:原石雕刻の纪念晶石数量红点
---@field kRedPointModuleGuildStoneCommon number @value:77,des:公会原石の功能提示红点
---@field kRedPointModuleTimeLimitGift number @value:98,des:限时礼包
---@field kRedPointModuleImportantMail number @value:116,des:重要邮件
RedPointModule = {}

---@class RandomAwardSceneType
---@field RandomAwardSceneTypeNone number @value:0,des:
---@field RandomAwardSceneTypeTickty number @value:1,des:抽奖券
---@field RandomAwardSceneTypeWaBao number @value:2,des:挖宝
RandomAwardSceneType = {}

---@class RedPointCheckType
---@field kRedPointCheckTypeNone number @value:0,des:暂时不处理
---@field kRedPointCheckTypeClient number @value:1,des:客户端检查
---@field kRedPointCheckTypeServer number @value:2,des:服务器检查
RedPointCheckType = {}

---@class LifeSkillType
---@field LIFE_SKILL_TYPE_NONE number @value:0,des:无
---@field LIFE_SKILL_TYPE_GARDEN number @value:1,des:园艺
---@field LIFE_SKILL_TYPE_MINING number @value:2,des:采矿
---@field LIFE_SKILL_TYPE_FOOD number @value:3,des:料理
---@field LIFE_SKILL_TYPE_MEDICINE number @value:4,des:制药
---@field LIFE_SKILL_TYPE_DESSERT number @value:5,des:甜品
---@field LIFE_SKILL_TYPE_SMELT number @value:6,des:冶炼
---@field LIFE_SKILL_TYPE_FISHING number @value:7,des:钓鱼
---@field LIFE_SKILL_TYPE_DIG_TREASURE number @value:8,des:挖宝采集
---@field LIFE_SKILL_TYPE_SMELT_WEAPON number @value:9,des:武器冶炼
---@field LIFE_SKILL_TYPE_SMELT_DEFEND number @value:10,des:防具冶炼
---@field LIFE_SKILL_TYPE_SMELT_ACC number @value:11,des:饰品冶炼
---@field LIFE_SKILL_TYPE_GROUP_AWARD number @value:12,des:组队宝箱打开
---@field LIFE_SKILL_TYPE_DUNGEON_BOX number @value:13,des:大秘境宝箱
---@field LIFE_SKILL_TYPE_GUILD_DINNER_BOX number @value:14,des:公会宴会宝箱
---@field LIFE_SKILL_TYPE_BIGWORLD_FRUIT number @value:15,des:大世界果子
---@field LIFE_SKILL_TYPE_FOOD_FUSION number @value:16,des:烹饪组合
---@field LIFE_SKILL_TYPE_MEDICINE_FUSION number @value:17,des:制药组合
---@field LIFE_SKILL_TYPE_MONSTER_TREASURE number @value:18,des:宝藏猎人魔物宝藏
---@field LIFE_SKILL_TYPE_FOOTPRINT_SUCCESS number @value:19,des:魔物脚印(成功)
---@field LIFE_SKILL_TYPE_FOOTPRINT_FAIL number @value:20,des:魔物脚印(失败)
LifeSkillType = {}

---@class FishingType
---@field FISHING_TYPE_NONE number @value:0,des:无用
---@field FISHING_TYPE_INTRO number @value:1,des:进入钓鱼界面
---@field FISHING_TYPE_UPPER number @value:2,des:起竿
---@field FISHING_TYPE_THROW number @value:3,des:丢鱼漂
---@field FISHING_TYPE_UPPERNONE number @value:4,des:起空竿
---@field FISHING_TYPE_AUTO_FISH number @value:5,des:自动钓鱼
---@field FISHING_TYPE_STOP_AUTO_FISH number @value:6,des:结束自动钓鱼
FishingType = {}

---@class NavClientMethodType
---@field NAV_CLIENT_METHOD_TYPE_NONE number @value:0,des:无
---@field NAV_CLIENT_METHOD_TYPE_AI number @value:1,des:AI驱动
---@field NAV_CLIENT_METHOD_TYPE_HUMAN number @value:2,des:人为驱动
NavClientMethodType = {}

---@class NavBigType
---@field NAV_BIG_TYPE_NONE number @value:0,des:无
---@field NAV_BIG_TYPE_POS number @value:1,des:便捷寻坐标
---@field NAV_BIG_TYPE_MAP number @value:2,des:便捷寻地图
NavBigType = {}

---@class LifeEquipType
---@field LIFE_EQUIP_TYPE_NONE number @value:0,des:生活技能装备:无
---@field LIFE_EQUIP_TYPE_FOD number @value:1,des:鱼竿
---@field LIFE_EQUIP_TYPE_SEAT number @value:2,des:座椅和帐篷
---@field LIFE_EQUIP_TYPE_GARDEN number @value:3,des:采集
---@field LIFE_EQUIP_TYPE_MINING number @value:4,des:挖矿
LifeEquipType = {}

---@class DailyActivityStatus
---@field kDailyActivityStatusNone number @value:0,des:
---@field kDailyActivityStatusWaiting number @value:1,des:
---@field kDailyActivityStatusApplying number @value:2,des:
---@field kDailyActivityStatusBattling number @value:3,des:
DailyActivityStatus = {}

---@class AwardExpReason
---@field AWARD_EXP_NONE number @value:0,des:无
---@field AWARD_EXP_BLESS number @value:1,des:祝福经验
---@field AWARD_EXP_HEALTH number @value:2,des:健康战斗额外奖励
AwardExpReason = {}

---@class ChatMediumType
---@field ChatMediumTypeNone number @value:0,des:
---@field ChatMediumTypeText number @value:1,des:文字消息
---@field ChatMediumTypeAudio number @value:2,des:语音消息
ChatMediumType = {}

---@class SavePhotoType
---@field SAVE_NONE number @value:0,des:
---@field SAVE_LOCAL number @value:1,des:
---@field SAVE_GAME number @value:2,des:
---@field SAVE_ALL number @value:3,des:
SavePhotoType = {}

---@class PhotoOperateType
---@field NORMAL_LENS number @value:0,des:
---@field FREEDOM_LENS number @value:1,des:
---@field SELF_STICK_LENS number @value:2,des:
---@field AR_LENS number @value:3,des:
PhotoOperateType = {}

---@class MemberStatus
---@field MEMBER_NONE number @value:0,des:
---@field MEMBER_NORMAL number @value:1,des:组队Normal状态
---@field MEMBER_OFFLINE number @value:2,des:组队离线状态
---@field MEMBER_AFK number @value:3,des:暂时离开
---@field CHAT_ROOM_MEMBER_AFK number @value:4,des:聊天室暂离
---@field MEMBER_WAITING number @value:5,des:组队等待状态
---@field MEMBER_AWAYFROM number @value:6,des:组队远离状态
MemberStatus = {}

---@class CheckDungeonType
---@field TYPE_TEAM_DUNGEON number @value:0,des:队伍过副本检测
---@field TYPE_GUILD_DUNGEON number @value:1,des:公会场景检测
CheckDungeonType = {}

---@class DeliverType
---@field Deliver_None number @value:0,des:
---@field Deliver_Wall number @value:1,des:
---@field Deliver_Revive number @value:2,des:
---@field Deliver_Teleport number @value:3,des:蝴蝶翅膀专用
---@field Deliver_Kapula number @value:4,des:卡普拉传送
---@field Deliver_Mirror_Stay number @value:5,des:镜像副本
---@field Deliver_Team_Force number @value:6,des:组队强制拉到指定坐标
---@field Deliver_GuildScene number @value:7,des:
---@field Deliver_EasyPath number @value:8,des:便捷寻路传送
---@field Deliver_Butterfly number @value:9,des:蝴蝶翅膀传送
---@field Deliver_ArenaPvp number @value:10,des:角斗场进战斗场景
---@field Deliver_RoyalExercise number @value:11,des:皇家演练
DeliverType = {}

---@class AchievementTargetType
---@field kAchievementTargetTypeNone number @value:0,des:占位
---@field kAchievementTargetTypeDaemonTreasure number @value:1,des:恶魔宝藏
---@field kAchievementTargetTypeKillMvp number @value:2,des:击杀mvp
---@field kAchievementTargetTypeStallGetZeny number @value:3,des:摆摊获得zeny
---@field kAchievementTargetTypeAppraisalRareEquip number @value:4,des:鉴定稀有装备
---@field kAchievementTargetTypeRefineEquip number @value:5,des:精炼装备
---@field kAchievementTargetTypeTowerInfinite number @value:6,des:无限塔
---@field kAchievementTargetTypeRevengeMonster number @value:7,des:魔物驱逐 复仇的魔物
---@field kAchievementTargetTypeJewelry number @value:8,des:魔物驱逐 邪恶箱
---@field kAchievementTargetTypeOrnaments number @value:9,des:饰品数量
---@field kAchievementTargetTypeStruckByThunder number @value:10,des:被雷劈
---@field kAchievementTargetTypeKillMonsterWithSize number @value:11,des:击杀怪物·体型
---@field kAchievementTargetTypeKillMonsterWithRace number @value:12,des:击杀怪物·种族
---@field kAchievementTargetTypeWeaponHole number @value:13,des:武器孔
---@field kAchievementTargetTypeWeaponCard number @value:14,des:武器插卡
---@field kAchievementTargetTypeUpHeadEmojiPhoto number @value:15,des:头顶表情拍照
---@field kAchievementTargetTypeTimesOfMVP number @value:16,des:击杀mvp的
---@field kAchievementTargetTypeGuildDoublePeopleCook number @value:17,des:工会宴会双人烹饪
---@field kAchievementTargetTypeRefineFailed number @value:18,des:精炼失败次数达到n
---@field kAchievementTargetTypeKillElitistMonster number @value:19,des:击杀精英怪还要野外
---@field kAchievementTargetTypeEnchantTimes number @value:20,des:附魔次数达到n
---@field kAchievementTargetTypePassDungeonInTime number @value:21,des:m秒全队通关副本
---@field kAchievementTargetTypePrizeOfTeammate number @value:22,des:收到队友的点赞
---@field kAchievementTargetTypeKillMINI number @value:23,des:击杀所有mini
---@field kAchievementTargetTypeTimesOfMINI number @value:24,des:击杀过MINI的次数
---@field kAchievementTargetTypeFirstAttackOfMVP number @value:25,des:首刀mvp
---@field kAchievementTargetTypeFirstAttackOfMINI number @value:26,des:首刀mini
---@field kAchievementTargetTypeKillBossAndPhoto number @value:27,des:击杀boss并拍照
---@field kAchievementTargetTypeSpecialOrnament number @value:28,des:解锁指定配饰
---@field kAchievementTargetTypeSpecialOrnamentsSet number @value:29,des:解锁配置集合
---@field kAchievementTargetTypeFaceEmojiSelfPhoto number @value:30,des:使用所有的面部表情进行自拍
---@field kAchievementTargetTypeLastAttackOfMVP number @value:31,des:尾刀mvp
---@field kAchievementTargetTypeGuildDinnerRank number @value:32,des:公会宴会排名
---@field kAchievementTargetTypeGuildDinnerJoin number @value:33,des:参与公会宴会
---@field kAchievementTargetTypeHeroChallengeScore number @value:34,des:英雄挑战分数
---@field kAchievementTargetTypeMaxFashionDegree number @value:35,des:时尚度的历史最大值达到过n
---@field kAchievementTargetTypeTotalFinishCatShipTimes number @value:36,des:猫手商队填充货船次数达到n
---@field kAchievementTargetTypeTransferTimes number @value:37,des:达成职业n转
---@field kAchievementTargetTypeMedalOfGloryNumbers number @value:38,des:光辉勋章激活数量达到n
---@field kAchievementTargetTypeMedalOfGloryLevel number @value:39,des:光辉勋章总等级达到n
---@field kAchievementTargetTypeMedalOfHolyNumbers number @value:40,des:神圣勋章激活数量达到n
---@field kAchievementTargetTypeResetQualityPoint number @value:41,des:玩家是否重置过素质点
---@field kAchievementTargetTypeResetSkillPoint number @value:42,des:玩家是否重置过技能点
---@field kAchievementTargetTypeMaxQualityPoint number @value:43,des:分配属性点数最大值达到n(重置后不累加)
---@field kAchievementTargetTypeMaxSkillPoint number @value:44,des:分配技能点数最大值达到n(重置后不累加)
---@field kAchievementTargetTypeJoinBattlefieldTimes number @value:45,des:累计参与战场n次(根据结算统计)
---@field kAchievementTargetTypeWinBattlefieldTimes number @value:46,des:累计战场结算胜利n次
---@field kAchievementTargetTypeLoseBattlefieldTimes number @value:47,des:累计战场结算失败n次
---@field kAchievementTargetTypeIdClimb number @value:48,des:玩家是否进行过攀爬
---@field kAchievementTargetTypeIsWearAccessory number @value:49,des:玩家是否穿戴过配饰
---@field kAchievementTargetTypeIsWatchPicWall number @value:50,des:玩家是否查看过照片墙
---@field kAchievementTargetTypeIsCarrier number @value:51,des:玩家是否装备过载具
---@field kAchievementTargetTypeFinishTask number @value:52,des:玩家是否完成过id为n的任务
---@field kAchievementTargetTypeFinishAcievement number @value:53,des:玩家是否完成过id为n的成就
---@field kAchievementTargetTypeEntrustEvidenceNumbers number @value:54,des:累计消耗委托证明达到n(实际消耗掉才计数)
---@field kAchievementTargetTypeFriendNumbers number @value:55,des:最大好友数达到n
---@field kAchievementTargetTypeGiveGiftNumbers number @value:56,des:累计赠送n个道具
---@field kAchievementTargetTypeReceiveGift number @value:57,des:累计获赠n个道具
---@field kAchievementTargetTypeBuildChatRoom number @value:58,des:是否建立过聊天室
---@field kAchievementTargetTypeChangeHairTimes number @value:59,des:累计修改发型/发色次数达到n
---@field kAchievementTargetTypeChangeEyesStyleTimes number @value:60,des:累计修改瞳型/瞳色次数达到n
---@field kAchievementTargetTypeRefineTransform number @value:61,des:精炼转移次数达到n
---@field kAchievementTargetTypeMakeFood number @value:62,des:生活技能，制造料理数量达到n
---@field kAchievementTargetTypeMakeMedicine number @value:63,des:生活技能，制造药水数量达到n
---@field kAchievementTargetTypeFriendDegree number @value:64,des:拥有m个好友度达到n的好友
---@field kAchievementTargetTypeDoubleAction number @value:65,des:成功邀请玩家做双人动作，次数达到n
---@field kAchievementTargetTypeBeDoubleAction number @value:66,des:成功被邀请做双人动作，次数达到n
---@field kAchievementTargetTypeMonsterIllustration number @value:67,des:魔物图鉴点亮数量达到n
---@field kAchievementTargetTypeSelfPhoto number @value:68,des:自拍次数达到n
---@field kAchievementTargetTypeUnlockMap number @value:69,des:解锁指定地图，地图id对应MapTable
---@field kAchievementTargetTypeBeKilledByOnePunch number @value:70,des:是否被一击秒杀过
---@field kAchievementTargetTypeMonsterAffix number @value:71,des:击杀过特定词缀的怪物，n对应AffixTable表中的id
---@field kAchievementTargetTypeBattlefieldVictory number @value:72,des:擂台结算时，是否以15:0的比分赢得比赛
---@field kAchievementTargetTypeHeadEmoji number @value:73,des:使用头顶表情次数达到n，头顶表情对应的表ShowExpressionTable
---@field kAchievementTargetTypeWinBattlefieldAndDoorExist number @value:74,des:战场结算时，【获得胜利】且【己方大门未被攻破】
---@field kAchievementTargetTypeWearRefineEquip number @value:75,des:指定部位n穿戴过精炼+m的装备，n对应EquipPos
---@field kAchievementTargetTypeArenaStory number @value:76,des:擂台达到n层
---@field kAchievementTargetTypeArenaStoryMTimes number @value:77,des:擂台达到n层m次
---@field kAchievementTargetTypePvPKill number @value:78,des:在PVP玩法中累计击杀n名玩家；
---@field kAchievementTargetTypePvPDead number @value:79,des:在PVP玩法中累计被击杀n次；
---@field kAchievementTargetTypePvPAssists number @value:80,des:在PVP玩法中累计助攻n次；
---@field kAchievementTargetTypeForgeEquip number @value:81,des:装备锻造N次
---@field kAchievementTargetTypeStallGetRobi number @value:82,des:商会出售道具获得Zeny币达到n
---@field kAchievementTargetTypeIsJoinGuild number @value:83,des:是否加入过公会
---@field kAchievementTargetTypeHymnTimes number @value:84,des:累计通关圣歌试炼达到n
---@field kAchievementTargetTypeFruitShopChangeTimes number @value:85,des:在果实商店中，兑换道具数量达到n
---@field kAchievementTargetTypePassXiaShuiDaoZhiMi number @value:86,des:通关下水道之谜
---@field kAchievementTargetTypeSageMemories number @value:87,des:通关贤者回忆任意3个副本
---@field kAchievementTargetTypeSageMemoriesBigSecret number @value:88,des:通关贤者回忆任意3个大秘境
---@field kAchievementTargetTypeKillMvpTimes number @value:89,des:累计参与击杀n只MVP怪
---@field kAchievementTargetTypeSetPosKeeper number @value:90,des:使用过存储
---@field kAchievementTargetTypeMerchant number @value:91,des:跑商成就
---@field kAchievementTargetTypeGetCardNums number @value:92,des:累积获得n张任意卡片
---@field kAchievementTargetTypeRefineTotalLevel number @value:93,des:全身穿戴装备的总精炼等级
---@field kAchievementTargetTypeTotalHole number @value:94,des:全身装备的开洞数
---@field kAchievementTargetTypePartyLuckStartOneToThree number @value:95,des:主题派对中，是否获得过幸运之星1-3星
---@field kAchievementTargetTypePartyLuckStartOne number @value:96,des:主题派对中，是否获得过幸运之星1等奖
---@field kAchievementTargetTypePartyLuckStartTimes number @value:97,des:主题派对，获得n次幸运奖
---@field kAchievementTargetTypeWinButterFighting number @value:98,des:公会宴会，累积获得n次奶油乱斗的胜利
---@field kAchievementTargetTypeFateTest number @value:99,des:缘分考验
---@field kAchievementTargetTypeRandomBox number @value:100,des:随机宝箱
---@field kAchievementTargetTypeWinGreatSecretProject number @value:101,des:通关大秘境第M章任意难度
---@field kAchievementTargetTypeYaHaHa number @value:102,des:呀哈哈数量
---@field kAchievementTargetTypeWorldWonderEvent number @value:103,des:累积完成n次世界奇闻
---@field kAchievementTargetTypeGuildPray number @value:104,des:完成n次公会祈福
---@field kAchievementTargetTypeAchievementBadge number @value:105,des:成就勋章等级
---@field kAchievementTargetTypeBigWorldFruit number @value:106,des:大世界采集果子
---@field kAchievementTargetTypeFashionBisection number @value:107,des:累积参加n次卢恩杂志
---@field kAchievementTargetTypeWeaponLevel number @value:108,des:武器等级
---@field kAchievementTargetTypeArmorLevel number @value:109,des:防具等级
---@field kAchievementTargetTypeYahahaBoLiType number @value:110,des:类型为m的波利精灵n个
---@field kAchievementTargetTypeTowerDefenseType number @value:117,des:守卫天地树玩法中，在结算时累计击杀n波怪物
---@field kAchievementTargetTypeSetMercenaryFight number @value:118,des:成功设置n名佣兵出战
---@field kAchievementTargetTypeUpgrageMercenaryLevel number @value:119,des:累计n名佣兵升到m级
---@field kAchievementTargetTypeMercenaryEquipLevel number @value:120,des:累计n名佣兵，全身5件装备升到m级
---@field kAchievementTargetTypeMercenaryTalent number @value:121,des:累计n名佣兵，解锁m个天赋
---@field kAchievementTargetTypeTowerDefenseInsistType number @value:122,des:守卫天地树玩法中，坚持到第n波怪物刷新
---@field kAchievementTargetTypeGuildDinnerNumberOne number @value:123,des:在周末宴会比赛中取得第1名的成绩
---@field kAchievementTargetTypeGuildDinnerNumberTwoOrThree number @value:124,des:在周末宴会比赛中取得第2-3名的成绩
---@field kAchievementTargetTypeGuildDinnerNumberFourToTen number @value:125,des:在周末宴会比赛中取得第4-10名的成绩
---@field kAchievementTargetTypeAssistCertificateCount number @value:126,des:累计获得N个协同之证
---@field kAchievementTargetTypeAssistCount number @value:127,des:累计助战了N次
---@field kAchievementTargetTypeLoveMengXin number @value:128,des:累计赠送过N个萌新玩家礼物
---@field kAchievementTargetTypeGetGiftFromMengXin number @value:129,des:获得1次萌新玩家赠送的礼物
---@field kAchievementTargetTypeLoveHuiGui number @value:130,des:累计赠送过N个回归玩家礼物
---@field kAchievementTargetTypeGetGiftFromHuiGui number @value:131,des:获得1次回归玩家赠送的礼物
---@field kAchievementTargetTypeThemeDungeonNormal number @value:132,des:通关【贤者回忆】挑战玩法基础模式n次
---@field kAchievementTargetTypeTimeCard number @value:133,des:累计租赁N张卡片
---@field kAchievementTargetTypeMonResearchLv number @value:134,des:魔物研究总等级达到N级
---@field kAchievementTargetTypeLifeSkillLv number @value:135,des:玩家任意生活技能等级达到n即可完成成就
---@field kAchievementTargetTypeLifeSkillMake number @value:136,des:玩家通过任意生活技能制造物品数量达到n即可完成成就
---@field kAchievementTargetTypeSetHeadP number @value:137,des:设置N次特殊头像
---@field kAchievementTargetTypeSetTitle number @value:138,des:设置N次特殊称号
---@field kAchievementTargetTypeCallMonster number @value:139,des:使用N次枯树枝召唤魔物
---@field kAchievementTargetTypeGreenBelluz number @value:140,des:获得N个绿色贝鲁兹核心(参考一下获得卡片的成就，从邮件等途径获得的道具不计数)
---@field kAchievementTargetTypeBlueBelluz number @value:141,des:获得N个蓝色贝鲁兹核心(参考一下获得卡片的成就，从邮件等途径获得的道具不计数)
AchievementTargetType = {}

---@class WorldEventTriggerType
---@field kWorldEventTriggerNone number @value:0,des:
---@field kWorldEventTriggerNpc number @value:1,des:刷npc
---@field kWorldEventTriggerSceneTrigger number @value:2,des:刷触发器
WorldEventTriggerType = {}

---@class CardType
---@field CARD_TYPE_PURPLE number @value:0,des:紫卡
---@field CARD_TYPE_BULE_GREEN number @value:1,des:蓝绿卡
CardType = {}

---@class MedalType
---@field Medal_Type_None number @value:0,des:
---@field Medal_Type_General number @value:1,des:光辉勋章
---@field Medal_Type_Super number @value:2,des:神圣勋章
MedalType = {}

---@class MedalOpType
---@field Medal_Op_None number @value:0,des:
---@field Medal_Op_Active number @value:1,des:激活勋章
---@field Medal_Op_Upgrade number @value:2,des:勋章升级(神圣勋章进阶)
---@field Medal_Op_Reset number @value:3,des:勋章重置
MedalOpType = {}

---@class MedalChangeType
---@field Medal_Change_None number @value:0,des:
---@field Medal_Change_Active number @value:1,des:勋章被激活了
---@field Medal_Change_Level_Up number @value:2,des:升级了
---@field Medal_Change_Max_Level number @value:3,des:升级满了
---@field Medal_Change_Active_Progress number @value:4,des:激活进度改变了
MedalChangeType = {}

---@class FriendDegreeSourceType
---@field Friend_Degree_None number @value:0,des:无
---@field Friend_Degree_Chat number @value:1,des:聊天
---@field Friend_Degree_MVP number @value:2,des:组队参与击杀一只mini/mvp增加友好度
---@field Friend_Degree_Dungeons number @value:3,des:组队完成一次副本、pvp时，增加友好度
FriendDegreeSourceType = {}

---@class BanRoleOperate
---@field Operate_Query number @value:0,des:查询
---@field Operate_Add number @value:1,des:部分更新
---@field Operate_Del number @value:2,des:删除
---@field Operate_Replace number @value:3,des:替换覆盖
BanRoleOperate = {}

---@class LockRoleOperate
---@field Operate_Lock number @value:0,des:封号
---@field Operate_Unlock number @value:1,des:解封
LockRoleOperate = {}

---@class IdipProcType
---@field Proc_Master number @value:0,des:该命令发给master处理
---@field Proc_Game number @value:1,des:
---@field Proc_Trade number @value:2,des:
---@field Proc_Master_Game number @value:3,des:先在master处理,然后专发给game处理
IdipProcType = {}

---@class PayParamType
---@field PAY_PARAM_NONE number @value:0,des:
---@field PAY_PARAM_LIST number @value:1,des:
PayParamType = {}

---@class RollContext
---@field RollContextNone number @value:0,des:
---@field RollContextDungeonsResult number @value:1,des:
---@field RollContextMvp number @value:2,des:
---@field RollContextMini number @value:3,des:
RollContext = {}

---@class ArrowPos
---@field ARROW_POS_IN_USE number @value:0,des:正在使用得
---@field ARROW_POS_LOAD_1 number @value:1,des:
---@field ARROW_POS_LOAD_2 number @value:2,des:
---@field ARROW_POS_LOAD_3 number @value:3,des:
---@field ARROW_POS_MAX number @value:4,des:
ArrowPos = {}

---@class DropBuffType
---@field ENUM_DROPBUFF_PERSON number @value:0,des:个人
---@field ENUM_DROPBUFF_TEAM number @value:1,des:队伍
DropBuffType = {}

---@class RoomChangeReason
---@field ROOM_LEAVE_SELF number @value:0,des:
---@field ROOM_CHANGE_SCENE number @value:1,des:
---@field ROOM_CHANGE_LOGOUT number @value:2,des:
---@field ROOM_CHANGE_LOGIN number @value:3,des:
---@field ROOM_CHANGE_REVIVE number @value:4,des:
---@field ROOM_CHANGE_KICK number @value:5,des:
RoomChangeReason = {}

---@class LoginPlat
---@field plat_id number @value:0,des:
---@field android_qq number @value:1,des:
---@field android_wechat number @value:2,des:
---@field ios_qq number @value:3,des:
---@field ios_wechat number @value:4,des:
---@field ios_guest number @value:5,des:
LoginPlat = {}

---@class BanAccountOperate
---@field BAN_AC_QUERY number @value:0,des:查
---@field BAN_AC_ADD number @value:1,des:增加
---@field BAN_AC_DEL number @value:2,des:删除
BanAccountOperate = {}

---@class SingleTimeLineEndType
---@field ENUM_SINGLE_TIMELINE_END_FINISH number @value:0,des:正常结束
---@field ENUM_SINGLE_TIMELINE_END_CLICKSKIP number @value:1,des:点击跳过
SingleTimeLineEndType = {}

---@class RoleStatusType
---@field Role_Status_None number @value:0,des:正常
---@field Role_Status_Deleting number @value:1,des:正在删除中
---@field Role_Status_Deleted number @value:2,des:角色已删除
RoleStatusType = {}

---@class AccountOpType
---@field Account_Op_None number @value:0,des:
---@field Account_Op_Delete number @value:1,des:
---@field Account_Op_Resume number @value:2,des:
AccountOpType = {}

---@class StickerGridStatus
---@field kGridClose number @value:0,des:条件不足
---@field kGridAward number @value:1,des:可以点击领奖
---@field kGridOpen number @value:2,des:已经点击开启
StickerGridStatus = {}

---@class MazeRoomType
---@field kMazeRoomTypeNone number @value:0,des:与MazeRoomTable对应(无)
---@field kMazeRoomTypeBornRoom number @value:1,des:出生房
---@field kMazeRoomTypeBossRoom number @value:2,des:BOSS房
---@field kMazeRoomTypeMonsterRoom number @value:3,des:怪物房
---@field kMazeRoomTypeEventRoom number @value:4,des:事件房
---@field kMazeRoomTypeKeyRoom number @value:5,des:钥匙房
---@field kMazeRoomTypeEliteRoom number @value:6,des:精英房
---@field kMazeRoomTypeSpecialRoom number @value:7,des:彩蛋房
---@field kMazeRoomTypeDuobi number @value:8,des:躲避球房
---@field kMazeRoomTypeQuGanBoLi number @value:9,des:驱赶波利
MazeRoomType = {}

---@class MazeRoomNtfStatus
---@field kMazeRoomNtfStatusNone number @value:0,des:
---@field kMazeRoomNtfStatusNotVictory number @value:1,des:未通关
---@field kMazeRoomNtfStatusVictory number @value:2,des:通关
MazeRoomNtfStatus = {}

---@class MazePathStatus
---@field kMazePathStatusNone number @value:0,des:
---@field kMazePathStatusPass number @value:1,des:已经通关
---@field kMazePathStatusNotPass number @value:2,des:未通关
---@field kMazePathStatusLastRoom number @value:3,des:上一个房间
---@field kMazePathStatusNowRoom number @value:4,des:当前房间
MazePathStatus = {}

---@class ItemNumChangeType
---@field change_type_add number @value:0,des:物品增加
---@field change_type_del number @value:1,des:物品减少
ItemNumChangeType = {}

---@class MailReason
---@field Mail_Reason_None number @value:0,des:
---@field Mail_Reason_Gift number @value:1,des:赠送礼物
---@field Mail_Reason_ShangHui number @value:2,des:商会
---@field Mail_Reason_PaiMai number @value:3,des:拍卖
---@field Mail_Reason_Red_Envelope number @value:4,des:红包道具
---@field Mail_Reason_ExchangeDiamond number @value:5,des:货币兑换
---@field Mail_Reason_BuyMallItem number @value:6,des:购买卖场道具
---@field Mail_Reason_NewFirstLogin number @value:7,des:开服3天后新建角色邮件奖励
MailReason = {}

---@class ClientAchievementType
---@field UsePhotoWall number @value:0,des:使用照片墙
---@field UseShowExpression number @value:1,des:使用头顶表情
ClientAchievementType = {}

---@class EnterSceneCameraFadeType
---@field CameraFadeType_Fade number @value:0,des:水波纹
---@field CameraFadeType_FadeInOut number @value:1,des:淡入淡出
EnterSceneCameraFadeType = {}

---@class SpMonsterTarget
---@field SpMonsterTargetNormal number @value:0,des:普通怪
---@field SpMonsterTargetElite number @value:1,des:精英怪
---@field SpMonsterTargetBoss number @value:2,des:Boss怪
---@field SpMonsterTargetMob number @value:3,des:召唤物
---@field SpMonsterTargetMini number @value:4,des:MINI
---@field SpMonsterTargetMvp number @value:5,des:MVP
---@field SpMonsterTargetJewelry number @value:6,des:宝箱怪
---@field SpMonsterTargetExp number @value:7,des:经验怪
---@field SpMonsterTargetGrass number @value:8,des:草系怪
SpMonsterTarget = {}

---@class OnlineType
---@field ROLE_OFFLINE number @value:0,des:
---@field ROLE_ONLINE number @value:1,des:
---@field ROLE_DELETED number @value:2,des:
OnlineType = {}

---@class QualityPointOperateType
---@field QUALITY_POINT_RESET number @value:0,des:素质点重置
---@field QUALITY_POINT_FREE_ASSIGN number @value:1,des:素质点自由分配
---@field QUALITY_POINT_RECOMMAND_ASSIGN number @value:2,des:素质点推荐分配
QualityPointOperateType = {}

---@class SingleScriptEnum
---@field kSingleScriptEnumNone number @value:0,des:
---@field kSingleScriptEnumSkill number @value:1,des:技能
---@field kSingleScriptEnumBuff number @value:2,des:buff
---@field kSingleScriptEnumCreateMonster number @value:3,des:召怪
SingleScriptEnum = {}

---@class RedEnvelopeType
---@field RED_ENVELOPE_NONE number @value:0,des:
---@field RED_ENVELOPE_ORDINARY number @value:1,des:普通红包
---@field RED_ENVELOPE_PASSWORD number @value:2,des:口令红包
RedEnvelopeType = {}

---@class DbOpType
---@field DB_OP_NONE number @value:0,des:
---@field DB_OP_INSERT number @value:1,des:
---@field DB_OP_UPDATE number @value:2,des:
---@field DB_OP_DELETE number @value:3,des:
---@field DB_OP_QUERY number @value:4,des:
DbOpType = {}

---@class ArenaMode
---@field kArenaModeNone number @value:0,des:
---@field kArenaModePrivate number @value:1,des:
---@field kArenaModePublic number @value:2,des:
ArenaMode = {}

---@class CarryItemType
---@field kCarryItemTypeCook number @value:0,des:烹饪
---@field kCarryItemTypeTask number @value:1,des:任务搬运
CarryItemType = {}

---@class MutexStateType
---@field kTypeInitiativeTransfigured number @value:0,des:变身
---@field kTypeChangeLine number @value:15,des:切换分线
MutexStateType = {}

---@class RoleActivityStatusType
---@field ROLE_ACTIVITY_STATUS_NONE number @value:0,des:
---@field ROLE_ACTIVITY_STATUS_STANDBY number @value:1,des:
---@field ROLE_ACTIVITY_STATUS_ACTIVE number @value:2,des:
RoleActivityStatusType = {}

---@class LimitedOfferStatusType
---@field LIMITED_OFFER_NONE number @value:0,des:
---@field LIMITED_OFFER_START number @value:1,des:活动开始
---@field LIMITED_OFFER_STOP number @value:2,des:活动结束
LimitedOfferStatusType = {}

---@class LocalizationNameType
---@field kLocalizationNameTypeNone number @value:0,des:
---@field kLocalizationNameTypeID number @value:1,des:本地化词库ID
---@field kLocalizationNameTypeKey number @value:2,des:本地化词库英文KEY
---@field kLocalizationNameTypeCusmStr number @value:3,des:服务器自定义字符串
LocalizationNameType = {}

---@class ThemePartyEventType
---@field kPartyEventTypeNone number @value:0,des:
---@field kPartyEventTypeKick number @value:1,des:开始踢人
---@field kPartyEventTypeStart number @value:2,des:活动开始
---@field kPartyEventTypeWarmminUp number @value:3,des:预热
---@field kPartyEventTypeDance number @value:4,des:开始跳舞
---@field kPartyEventTypeLottery number @value:5,des:开始抽奖
---@field kPartyEventTypeEnter number @value:6,des:可以进入场景
ThemePartyEventType = {}

---@class ThemePartyClientState
---@field kPartyStateNone number @value:0,des:
---@field kPartyStateReady number @value:1,des:活动准备阶段
---@field kPartyStateWarmmingUp number @value:2,des:跳舞预热阶段
---@field kPartyStateDance number @value:3,des:跳舞阶段
---@field kPartyStateLottery number @value:4,des:抽奖阶段
---@field kPartyStateKick number @value:5,des:踢人阶段
ThemePartyClientState = {}

---@class ThemePartyLotteryType
---@field kLotteryTypeThirdPrize number @value:0,des:派对三等奖
---@field kLotteryTypeSecondPrize number @value:1,des:派对二等奖
---@field kLotteryTypeFirstPrize number @value:2,des:派对一等奖
---@field kLotteryTypeLuckyPrize number @value:3,des:派对幸运奖
---@field kLotteryTypeJoinPrize number @value:4,des:派对参与奖
ThemePartyLotteryType = {}

---@class RevenueStatisticsType
---@field kStatisticsTypeBless number @value:0,des:统计祝福类型
---@field kStatisticsTypeCommon number @value:1,des:统计普通类型
---@field kStatisticsTypeCount number @value:2,des:
RevenueStatisticsType = {}

---@class SlotType
---@field kSlotTypeManual1 number @value:0,des:手动技能孔1
---@field kSlotTypeManual2 number @value:1,des:手动技能孔2
---@field kSlotTypeAuto number @value:2,des:自动技能孔
---@field kSlotTypeManual3 number @value:3,des:支援类技能队列
SlotType = {}

---@class AwardLevel
---@field LEVEL_NONE number @value:0,des:
---@field LEVEL_SENIOR number @value:1,des:高级礼包
---@field LEVEL_INTERMEADIATE number @value:2,des:中级礼包
---@field LEVEL_PRIMARY number @value:3,des:初级礼包
AwardLevel = {}

---@class FrequentWordsOper
---@field FRE_WORDS_NONE number @value:0,des:
---@field FRE_WORDS_ADD number @value:1,des:
---@field FRE_WORDS_REMOVE number @value:2,des:
---@field FRE_WORDS_QUERY number @value:3,des:
FrequentWordsOper = {}

---@class ShareType
---@field CHAT_SHARE_NONE number @value:0,des:
---@field CHAT_SHARE_ITEM number @value:1,des:道具分享
---@field CHAT_SHARE_ACHIEVEMENT number @value:2,des:分享成就
---@field CHAT_SHARE_QUALITY_POINT number @value:7,des:分享属性点
---@field CHAT_SHARE_SKILL number @value:8,des:分享技能点
---@field CHAT_SHARE_WARDROBE number @value:9,des:分享衣橱
---@field CHAT_SHARE_FASHION_PHOTO number @value:13,des:时尚杂志照片
---@field CHAT_SHARE_TITLE number @value:14,des:称号分享
---@field CHAT_SHARE_STICKER number @value:15,des:贴纸分享
---@field CHAT_SHARE_THEMECONFIRM number @value:16,des:剧情挑战本占前确认
---@field CHAT_SHARE_GUILD_NEWS number @value:17,des:公会新闻分享
---@field CHAT_SHARE_MAGIC_PAPER_PRIVATE number @value:18,des:魔法信笺私聊消息
---@field CHAT_SHARE_MAGIC_PAPER number @value:19,des:魔法信笺世界红包
---@field CHAT_SHARE_CAPRA_FAQ number @value:20,des:卡普拉答
ShareType = {}

---@class ChatShareOp
---@field CHAT_SHARE_OP_NONE number @value:0,des:
---@field CHAT_SHARE_OP_SHARE number @value:1,des:
---@field CHAT_SHARE_OP_QUERY number @value:2,des:
ChatShareOp = {}

---@class MsgForbidFlag
---@field MSG_FORBID_NORMAL number @value:0,des:合法
---@field MSG_FORBID_EVIL number @value:1,des:不合法,不能显示
---@field MSG_FORBID_DIRTY number @value:2,des:合法,但包含敏感词
MsgForbidFlag = {}

---@class HrefType
---@field HREF_NONE number @value:0,des:
---@field HREF_PROP number @value:1,des:道具链接
---@field HREF_ACHIEVEMENT_DETAILS number @value:2,des:成就详情
---@field HREF_ACHIEVEMENT_BADGE number @value:3,des:成就勋章
---@field HREF_STONE_SCULPTURE number @value:4,des:原石雕刻连接
---@field HREF_PVP number @value:5,des:PVP
---@field HREF_COOKING number @value:6,des:品尝烹饪
---@field HREF_ATTRIBUTE_PLAN number @value:7,des:6维属性方案
---@field HREF_SKILL_PLAN number @value:8,des:技能方案
---@field HREF_CLOTH_PLAN number @value:9,des:衣橱方案
---@field HREF_ROLE_INFO number @value:10,des:玩家信息
---@field HREF_CRYSTAL number @value:11,des:华丽水晶
---@field HREF_WATCH_SHARE number @value:12,des:观战分享
---@field HREF_FASHION_RATING number @value:13,des:时尚评分
---@field HREF_TITLE number @value:14,des:称号分享
---@field HREF_STICKER number @value:15,des:贴纸分享(非超链接)
---@field HREF_THEME_CONFIRM number @value:16,des:剧情挑战本战前确认
---@field HREF_GUILD_NEWS number @value:17,des:公会新闻分享
---@field HREF_MAGIC_PAPER_PRIVATE number @value:18,des:魔法信笺私聊消息
---@field HREF_MAGIC_PAPER number @value:19,des:魔法信笺世界红包
---@field HREF_CAPRA_FAQ number @value:20,des:卡普拉问答
HrefType = {}

---@class UpdateWatchType
---@field UpdateWatchTypeNone number @value:0,des:
---@field UpdateWatchTypeRoleLike number @value:1,des:
---@field UpdateWatchTypeRoleEnter number @value:2,des:
---@field UpdateWatchTypeRoleLeave number @value:3,des:
---@field UpdateWatchTypeRoomCreate number @value:4,des:
---@field UpdateWatchTypeRoomDestory number @value:5,des:
---@field UpdateWatchTypeRoleGiveFlower number @value:6,des:
---@field UpdateWatchTypeExtraWatchTimes number @value:7,des:
UpdateWatchType = {}

---@class StepSyncBools
---@field kStepSyncNone number @value:0,des:无用
---@field kStepSyncInBattle number @value:1,des:参考代码里原来的解释
---@field kStepSyncIgnorePosSync number @value:2,des:参考代码里原来的解释
---@field kStepSyncMoved number @value:4,des:参考代码里原来的解释
---@field kStepSyncMoving number @value:8,des:参考代码里原来的解释
---@field kStepClientNeedMove number @value:16,des:客户端执行移动逻辑
StepSyncBools = {}

---@class VehicleOperation
---@field VEHICLE_OPERATION_NONE number @value:0,des:
---@field VEHICLE_OPERATION_ENABLE number @value:1,des:启用载具
---@field VEHICLE_OPERATION_DISABLE number @value:2,des:停用载具/休息
VehicleOperation = {}

---@class VehicleQualityDevelopType
---@field VEHICLE_QUALITY_NONE number @value:0,des:
---@field VEHICLE_QUALITY_JUNIOR number @value:1,des:初级培养
---@field VEHICLE_QUALITY_SENIOR number @value:2,des:高级培养
VehicleQualityDevelopType = {}

---@class VehicleSecret
---@field VEHICLE_SECRET_NONE number @value:0,des:
---@field VEHICLE_SECRET_JUNIOR number @value:1,des:初级秘籍
---@field VEHICLE_SECRET_SENIOR number @value:2,des:高级秘籍
---@field VEHICLE_SECRET_SUPER number @value:3,des:超级秘籍
VehicleSecret = {}

---@class VehicleOutlookType
---@field VEHICLE_OUTLOOK_NONE number @value:0,des:
---@field VEHICLE_OUTLOOK_ORNAMENT number @value:1,des:配饰
---@field VEHICLE_OUTLOOK_DYE number @value:2,des:染色
VehicleOutlookType = {}

---@class VehicleStatus
---@field VEHICLE_STATUS_NONE number @value:0,des:
---@field VEHICLE_STATUS_ENABLE number @value:1,des:启用状态
---@field VEHICLE_STATUS_DISABLE number @value:2,des:停用状态
VehicleStatus = {}

---@class VehicleType
---@field VEHICLE_TYPE_NONE number @value:0,des:
---@field VEHICLE_TYPE_PROFESSION number @value:1,des:职业载具
---@field VEHICLE_TYPE_SPECIAL number @value:2,des:特色载具
---@field VEHICLE_TYPE_BATTLE number @value:3,des:战斗载具
VehicleType = {}

---@class MercenaryEquipType
---@field kMercenaryEquipTypeNone number @value:0,des:
---@field kMercenaryEquipTypeMainWeapon number @value:1,des:武器
---@field kMercenaryEquipTypeArmor number @value:2,des:护甲
---@field kMercenaryEquipTypeCloak number @value:3,des:斗篷
---@field kMercenaryEquipTypeSecondWeapon number @value:4,des:副手
---@field kMercenaryEquipTypeBoot number @value:5,des:鞋子
---@field kMercenaryEquipTypeOrnament number @value:6,des:饰品
MercenaryEquipType = {}

---@class MercenaryTalentOperation
---@field kMercenaryTalentOperationNone number @value:0,des:
---@field kMercenaryTalentOperationStudy number @value:1,des:
---@field kMercenaryTalentOperationUpgrade number @value:2,des:
---@field kMercenaryTalentOperationStrengthen number @value:3,des:
---@field kMercenaryTalentOperationSwitch number @value:4,des:
---@field kMercenaryTalentOperationReset number @value:5,des:
MercenaryTalentOperation = {}

---@class VehicleQualityBreakType
---@field VEHICLE_QUALITY_BREAK_TYPE_NONE number @value:0,des:
---@field VEHICLE_QUALITY_BREAK_TYPE_UPGRADE number @value:1,des:进阶载具突破素质上限
---@field VEHICLE_QUALITY_BREAK_TYPE_SCROLL number @value:2,des:使用超级卷轴突破上限
VehicleQualityBreakType = {}

---@class VitalDataType
---@field VITAL_DATA_TYPE_NONE number @value:0,des:
---@field VITAL_DATA_TYPE_VIRTUAL_ITEM number @value:1,des:虚拟物品
VitalDataType = {}

---@class CommondataType
---@field kCDT_NORMAL number @value:0,des:普通数据
---@field kCDT_DUNGEON number @value:1,des:副本
---@field kCDT_SKILL number @value:2,des:技能
---@field kCDT_VITALE_DATA number @value:3,des:关键数据
---@field kCDT_OWN_TITLE number @value:4,des:已有称号(临时)
---@field kCDT_USING_TITLE number @value:5,des:穿戴中的称号(临时)
---@field kCDT_NEW_TITLE number @value:6,des:新获得的称号(临时)
---@field kCDT_ROLE_TAG number @value:7,des:用户标签
---@field kCDT_MONTH_CARD number @value:8,des:月卡
---@field KCDT_LUCKY_POINT number @value:9,des:幸运值
---@field kCDT_CLIENT_ONCE number @value:10,des:客户端一次系统
---@field kCDT_SERVER_ONCE number @value:11,des:服务器一次系统
---@field kCDT_SURPRISE_CONDITION number @value:12,des:奇遇系统条件计数
---@field kCDT_SURPRISE_SUFFICIENT number @value:13,des:参照条件
---@field kCDT_TD_DUNGEON number @value:14,des:塔防相关计数器
---@field kCDT_CLIENT number @value:15,des:客户端专属
---@field kCDT_EQUIP_PAGE number @value:16,des:装备页配置，subid 16page,16pos
---@field kCDT_TLOG_DATA number @value:17,des:tlog的一些值记录
---@field kCDT_BACKSTAGE_ACT number @value:18,des:限时活动每日参与次数(每日0点清空,key是活动id)
---@field kCDT_TASK_FINISH_COUNT number @value:19,des:任务系统完成次数
---@field kCDT_RED_POINT number @value:20,des:红点系统
---@field kCDT_SPECIALSUPPLY_DICE_DATA number @value:21,des:限时活动 特殊补给 骰子的数据
---@field kCDT_SPECIALSUPPLY_BASE_DATA number @value:22,des:限时活动特殊补给的基础数据
---@field kCDT_SPECIALSUPPLY_ITEM_CD_DATA number @value:23,des:选择的item的CD数据
---@field kCDT_SPECIALSUPPLY_DICE_COUNT number @value:24,des:定制骰子的次数
---@field kCDT_TASK_ACTIVITY_ID number @value:25,des:记录活动任务对应的活动id
---@field kCDT_BINGO_GRID number @value:26,des:Bingo格子
---@field kCDT_BINGO_REWARD number @value:27,des:Bingo奖励
---@field kCDT_BINGO_LIGHT_LEVEL number @value:28,des:Bingo点亮层数
---@field kCDT_BINGO_GUESS number @value:29,des:Bingo猜数字记录
---@field kCDT_BACKSTAGE_INITTIME number @value:30,des:节日活动初始化时间戳
---@field kCDT_COMMON_AWARD number @value:31,des:通用奖励领取,subid 32位奖励id，value高32 时间戳，0-31领取次数
---@field kCDT_PAY_AWARD_RECORD number @value:32,des:累计充值奖励记录
---@field kCDT_DROP_ITEM_CD number @value:33,des:物品掉落CD
---@field kCDT_COMMON_JIFEN number @value:34,des:积分数据记录
---@field kCDT_COMMON_JIFEN_AWARD number @value:35,des:积分领奖
---@field kCDT_BACKSTAGE_TOTAL_SCORE number @value:36,des:节日活动，总积分(高32位是清除时间轴,低32位拥有数值)
---@field kCDT_BACKSTAGE_TODAY_SCORE_ZERO number @value:37,des:节日活动，今日积分,0点清空
---@field kCDT_BACKSTAGE_TODAY_SCORE_FIVE number @value:38,des:节日活动今日积分,5点清空
---@field kCDT_TASK_PROFESS_CHOICE number @value:39,des:任务选择职业
CommondataType = {}

---@class CommondataId
---@field kCDI_BEGIN number @value:0,des:普通数据枚举
---@field kCDI_SHOW_TITLE number @value:1,des:显示称号
---@field kCDI_REMAIN_DELEGATION number @value:2,des:昨日剩余委托卷数量
---@field kCDI_MENGXIN_TIME_STAMP number @value:3,des:萌新时间戳
---@field kCDI_REGRESS_TIME_STAMP number @value:4,des:回归时间戳
---@field kCDI_REGRESS_COUNT number @value:5,des:回归激活次数
---@field kCDI_MENGXIN_COUNT number @value:6,des:萌新激活次数
---@field kCDI_RECHARGE_COUNT number @value:7,des:充值次数
---@field kCDI_PICK_SMALL_GIFT_PACK_TIME number @value:8,des:免费礼包领取时间
---@field kCDI_MONTH_CARD_EXPIRE_CONFIRM number @value:9,des:月卡过期确认
---@field kCDI_THEME_DUNGEON_STAMP number @value:10,des:主题挑战本刷新
---@field kCDI_TD_BLESS number @value:11,des:塔防天赋
---@field kCDI_BAG_EXTEND_TIMES number @value:12,des:背包扩容次数
---@field kCDT_AUTO_BATTLE_STATUS number @value:13,des:自动战斗状态
---@field kCDT_CUR_EQUIP_PAGE number @value:14,des:当前装备页
---@field kCDT_HAS_EQUIP_PAGE number @value:15,des:当前拥有装备页，初始值是0，不是1，激活后是2
---@field kCDT_MAX_FIGHT_POINT number @value:16,des:历史最大战力
---@field kCDI_CUR_FIGHT_POINT number @value:17,des:当前战力
---@field kCDI_TOTAL_RECHARGE number @value:18,des:历史累计充值总数(扩大了1w倍)
---@field kCDI_ITEM_DB_LIST_NUM number @value:19,des:上次落地时DB列数，不一样时会重新把道具均匀分布到各自DB
---@field kCDI_TREASUREHUNTER_TASK_DELETE_TIME number @value:20,des:宝藏猎人玩家的删除任务时间
---@field kCDT_TREASUREHUNTER_HAS_SURVEY number @value:21,des:是否已经刷出了脚印
---@field kCDT_NORMAL_CARD_BUYINFO number @value:22,des:普通返利月卡购买信息，高32位截至时间戳，低32位累计购买次数（用于TLog)
---@field kCDT_NORMAL_CARD_AWARD_INFO number @value:23,des:普通返利月卡领奖信息 高32位最后一次领奖时间戳，低32位已经领奖次数重新购买清零0
---@field kCDT_SUPER_CARD_BUYINFO number @value:24,des:超級返利月卡购买信息，高32位截至时间戳，低32位累计购买次数（用于TLog)
---@field kCDT_SUPER_CARD_AWARD_INFO number @value:25,des:超级返利月卡领奖信息 高32位最后一次领奖时间戳，低32位已经领奖次数重新购买清零0
---@field kCDT_NORMAL_CARD_PRODU_ID number @value:26,des:普通月卡订单ID
---@field kCDT_SUPER_CARD_PRODU_ID number @value:27,des:超级月卡订单ID
---@field kCDI_BINGO_LIGHT_LEVEL number @value:28,des:Bingo点亮层数
---@field kCDI_BINGO_AWARD number @value:29,des:Bingo领奖
---@field kCDI_HEALTH_BATTLE_QUICKLY number @value:30,des:健康挂机加速消耗的itemid
---@field kCDI_DAOBAO_CANDY_ID number @value:31,des:打宝糖当前itemid
---@field kCDI_DABAO_CANDY_REMAIN_TIME number @value:32,des:打宝糖剩余时间
---@field kCDI_DABAO_CANDY_START_TICK number @value:33,des:打宝糖开始计时时间轴
---@field kCDI_ILLUSTRATION_LEVEL number @value:34,des:魔物研究等级
---@field kCDI_MENGXIN_MAIL number @value:35,des:二类萌新邮件奖励状态
---@field kCDI_MIRRORDUNGEON_POS number @value:36,des:玩家进入镜像副本前的位置X、Z
---@field kCDI_MENGXIN_LEVEL_GIFT number @value:37,des:萌新等级奖励数据
---@field kCDI_RECRUIT_CAMP number @value:38,des:征召阵营
---@field kCDT_ROLE_ITEM_REVIVE_TIMES number @value:39,des:使用复活之证复活的次数
CommondataId = {}

---@class RoleAttributeId
---@field RoleAttr_None number @value:0,des:
---@field RoleAttr_TitleId number @value:1,des:称号id
---@field RoleAttr_Tag number @value:2,des:标签
---@field RoleAttr_belluze_effectid number @value:3,des:贝鲁兹特效id
RoleAttributeId = {}

---@class TitleStatus
---@field TitleStatus_Show number @value:0,des:显示称号
---@field TitleStatus_Hide number @value:1,des:隐藏称号
---@field TitleStatus_SetId number @value:2,des:设置称号
TitleStatus = {}

---@class Region
---@field kRegionChina number @value:0,des:国内
---@field kRegionJapan number @value:1,des:日本
---@field kRegionGAT number @value:2,des:港澳台
---@field kRegionKorea number @value:3,des:韩国
---@field kRegionDNY number @value:4,des:东南亚
---@field kRegionNone number @value:101,des:
---@field kRegionTest number @value:102,des:测试
Region = {}

---@class PayBillStatus
---@field kPayBillStatusIdle number @value:0,des:
---@field kPayBillStatusCreated number @value:1,des:已创建
---@field kPayBillStatusAddGoods number @value:2,des:发货中
---@field kPayBillStatusFinished number @value:3,des:已完成
---@field kPayBillStatusFailed number @value:4,des:失败
PayBillStatus = {}

---@class CallBackType
---@field BlackCurtainType number @value:0,des:
---@field StoryBoardType number @value:1,des:
CallBackType = {}

---@class ROLE_TAG
---@field RoleTagNone number @value:0,des:
---@field RoleTagMengxin number @value:1001,des:萌新标签
---@field RoleTagRegress number @value:1002,des:回归标签
ROLE_TAG = {}

---@class SyncGuildOpType
---@field kSyncGuildOpTypeNone number @value:0,des:
---@field kSyncGuildOpTypeAddMember number @value:1,des:
---@field kSyncGuildOpTypeDelMember number @value:2,des:
---@field kSyncGuildOpTypeCreateGuild number @value:3,des:
---@field kSyncGuildOpTypeDismissGuild number @value:4,des:
---@field kSyncGuildOpTypeGuildCover number @value:5,des:
SyncGuildOpType = {}

---@class AuctionBillState
---@field kAuctionBillStateNone number @value:0,des:
---@field kAuctionBillStateAutoBib number @value:1,des:订单自动出价
---@field kAuctionBillStateManualBib number @value:2,des:订单手动出价
---@field kAuctionBillStateBibFinished number @value:3,des:订单结束
---@field kAuctionBillStateCancelBib number @value:4,des:取消出价
---@field kAuctionBillStateBibBeOvertaken number @value:5,des:订单被超过
AuctionBillState = {}

---@class AuctionResult
---@field kAuctionResultNone number @value:0,des:
---@field kAuctionResultFaild number @value:1,des:竞拍失败
---@field kAuctionResultSuccess number @value:2,des:竞拍成功
---@field kAuctionResultCancel number @value:3,des:取消自动出价
AuctionResult = {}

---@class MonsterAwardType
---@field MONSTER_AWARD_NONE number @value:0,des:
---@field MONSTER_AWARD_SINGLE number @value:1,des:单个怪物奖励
---@field MONSTER_AWARD_GROUP number @value:2,des:组怪物奖励
---@field MONSTER_AWARD_RSEARCH number @value:3,des:总体研究奖励
MonsterAwardType = {}

---@class DialogTabType
---@field DIALOG_TAB_TYPE_NONE number @value:0,des:
---@field DIALOG_TAB_TYPE_GENDER number @value:1,des:性别标签
---@field DIALOG_TAB_TYPE_ACHIVEMENT number @value:2,des:成就标签
---@field DIALOG_TAB_TYPE_FASHION number @value:3,des:典藏值标签
---@field DIALOG_TAB_TYPE_ENTITY number @value:4,des:魔物研究标签
---@field DIALOG_TAB_TYPE_LEVEL number @value:10,des:等级排行标签
DialogTabType = {}

---@class MaintainOperation
---@field kCloseMaintain number @value:0,des:关闭维护，也就是开放服务器
---@field kOpenMaintain number @value:1,des:开启维护，也就是关闭服务器访问
---@field kChangeMaintainInfo number @value:2,des:更改维护信息
MaintainOperation = {}

---@class CommondataClientUseId
---@field kCDT_Last_Save_Time number @value:0,des:最后一次存储时间，用于版本号
---@field kCDT_NormalCard_Time number @value:1,des:普通返利卡到期时间戳
---@field kCDT_SuperCard_Time number @value:2,des:超级返利卡到期时间戳
---@field kCDT_VipCard_Expire number @value:3,des:会员卡过期时间
---@field kCDT_AUTO_BATTLE number @value:13,des:注释：自动战斗状态（用于占位符）
---@field kCDT_MALL_GITF_REFRESH_Time number @value:14,des:卖场礼包上一次刷新时间戳
---@field kCDT_MALL_SHOP_REFRESH_Time number @value:15,des:卖场神秘商店上一次刷新时间戳
CommondataClientUseId = {}

---@class SpecialItemType
---@field SpecialItemTypeNone number @value:0,des:无类型
---@field SpecialItemTypeDungeons number @value:1,des:道具副本触发
SpecialItemType = {}

---@class RegisterResult
---@field REGISTER_RESULT_DEFAULT number @value:0,des:默认正常注册
---@field REGISTER_RESULT_PRE_SUCCESS number @value:1,des:预注册成功
---@field REGISTER_RESULT_PRE_FAILED number @value:2,des:预注册失败
RegisterResult = {}

---@class SingleAchievementNotify
---@field totalachievementpoint number @总的成就点数
---@field badgelevel number @勋章等级
---@field changed Achievement__Array @这个更新,根据id,客户端做覆盖
---@field point_reward_list PBuint32__Array @已领取的成就点奖励

---@class SetAchievementFocus
---@field id number @
---@field isfocus boolean @true表示关注

---@class AchievementDbInfo
---@field achievement_list number__Array @
---@field achievement_count_list int64__Array @
---@field badge_list number__Array @
---@field badge_count_list int64__Array @
---@field mtime uint64 @

---@class AchievementGetFinishRateInfoArg
---@field achievement_id number @

---@class AchievementGetInfoArg

---@class AchievementGetInfoRes
---@field error_code ErrorCode @
---@field achievement_list PBuint32__Array @
---@field achievement_rate_list PBdouble__Array @
---@field badge_rate number @

---@class AchievementGetServerInfoArg
---@field badge_level number @

---@class AchievementGetServerInfoRes
---@field error_code ErrorCode @
---@field achievement_list number__Array @
---@field achievement_count_list int64__Array @
---@field badge_lt_count int64 @
---@field role_total_count int64 @

---@class AchievementGetFinishRateInfoRes
---@field error_code ErrorCode @
---@field rate number @

---@class AchievementGetBadgeRateInfoArg
---@field badge_level number @

---@class AchievementGetBadgeRateInfoRes
---@field error_code ErrorCode @
---@field rate number @

---@class AchievementGetItemRewardArg
---@field item_id number @

---@class AchievementGetItemRewardRes
---@field error_code ErrorCode @

---@class AchievementGetPointRewardArg
---@field id number @

---@class AchievementGetPointRewardRes
---@field error_code ErrorCode @

---@class AchievementSyncToMsInfo
---@field role_id uint64 @
---@field achievement_id number @
---@field last_level number @
---@field level number @

---@class AchievementUpdateNotifyInfo
---@field role_id uint64 @
---@field target_type number @
---@field arg number @
---@field count number @
---@field operator_type number @

---@class FinishClientAchievementArg
---@field type number @

---@class FinishClientAchievementRes
---@field result ErrorCode @

---@class AchievementGetBadgeRewardArg
---@field badge_level number @

---@class AchievementGetBadgeRewardRes
---@field error_code ErrorCode @

---@class DailyActivityShowArg
---@field empty number @

---@class DailyActivityData
---@field activity_id number @活动id
---@field max_count number @需完成次数
---@field now_count number @当前已经完成次数
---@field start_time int64 @活动最近的一次开始时间
---@field end_time int64 @结束时间
---@field is_finished boolean @是否已完成
---@field battle_start_time int64 @
---@field status DailyActivityStatus @
---@field platform PlatformDailyInfo @
---@field battlefield BattlefieldDailyInfo @

---@class DailyActivityShowRes
---@field result ErrorCode @返回码
---@field activitys DailyActivityData__Array @可见活动
---@field award_index number @标识波利点数领奖的索引

---@class DrawBoLiPointAwardArg

---@class DrawBoLiPointAwardRes
---@field result ErrorCode @

---@class SevenLoginActivityGetRewardRes
---@field error_code ErrorCode @

---@class SevenLoginActivityGetRewardArg
---@field id number @

---@class SevenLoginActivityGetInfoArg

---@class SevenLoginActivityGetInfoRes
---@field error_code ErrorCode @
---@field cur_reward number @
---@field reward_get_list PBint32__Array @

---@class SevenLoginActivityUpdateNotifyInfo
---@field cur_reward number @

---@class GetBlessInfoArg

---@class GetBlessInfoRes
---@field result ErrorCode @
---@field remain_time number @剩余的祝福时间
---@field is_blessing boolean @是否开启了祝福
---@field monsters BlessMonsterData__Array @
---@field extra_fight_time number @每日额外战斗时间
---@field used_blessing_time number @今日使用的祝福时间
---@field open_timestamp uint64 @开启祝福的时间戳

---@class BlessMonsterData
---@field monster_id number @对应entitytable中的id
---@field kill_num number @

---@class BlessOperationArg
---@field is_open boolean @true:开启祝福 false：关闭祝福

---@class BlessOperationRes
---@field result ErrorCode @
---@field is_blessing boolean @

---@class PlatformDailyInfo
---@field round_id number @轮数
---@field next_round_left_time number @下一轮剩余时间

---@class BattlefieldDailyInfo
---@field in_match_deque boolean @是否在匹配队列

---@class CatTradeActivityGetInfoArg
---@field is_vip_refresh boolean @是否是VIP用户的立即返港

---@class CatTradeActivityGetInfoRes
---@field error_code ErrorCode @
---@field train_list CatTradeTrainInfo__Array @
---@field status number @0不可领 1可领 2已领

---@class CatTradeTrainInfo
---@field id number @
---@field seat_list CatTradeTrainSeatInfo__Array @
---@field is_full boolean @

---@class CatTradeActivityGetRewardArg

---@class CatTradeTrainSeatInfo
---@field id number @
---@field item_id number @
---@field item_count number @
---@field is_full boolean @
---@field price number @

---@class CatTradeActivityGetRewardRes
---@field error_code ErrorCode @

---@class CatTradeActivitySellGoodsArg
---@field train_id number @
---@field train_seat_id number @
---@field item_list PBuint64__Array @
---@field item_count_list PBint32__Array @

---@class CatTradeActivitySellGoodsRes
---@field error_code ErrorCode @

---@class DailyDelegateRefreshList
---@field delegate_data DelegateData__Array @委托信息
---@field refresh_time uint64 @

---@class DailyDelegateRecord
---@field today DailyDelegateRefreshList @刷新列表
---@field week_count MapInt32Int32__Array @每个势力本周刷新了多少
---@field last_server_level number @上次刷新时服务器等级
---@field yesterday DailyDelegateRefreshList @昨天的数据

---@class DelegateRefreshData
---@field today DailyDelegateRefreshList @
---@field yesterday DailyDelegateRefreshList @

---@class ThirtySignActivityGetRewardArg

---@class ThirtySignActivityGetRewardRes
---@field err_code ErrorCode @

---@class ThirtySignActivityGetInfoArg

---@class ThirtySignActivityGetInfoRes
---@field error_code ErrorCode @
---@field cur_reward number @
---@field max_reward_index number @
---@field is_end boolean @

---@class ThirtySignActivityUpdateNotifyInfo
---@field cur_reward number @
---@field max_reward_index number @
---@field is_end boolean @true表示没必要显示这个功能了

---@class ReceiveLevelGiftArg
---@field gift_id number @等级礼包id
---@field type number @礼包类型

---@class ReceiveLevelGiftRes
---@field result ErrorCode @

---@class DelegateData
---@field id number @
---@field task_id number @
---@field accept_npc TaskNpc @
---@field finish_npc TaskNpc @

---@class TreasureHunterShowSurveyBtnData
---@field enable boolean @是否打开

---@class SurveyTreasureRes
---@field error_code ErrorCode @
---@field CD uint64 @下次可以点击的时间戳

---@class BackstageActData
---@field act_id number @活动唯一id
---@field time_data BackstageActTimeData @时间相关数据
---@field server_data BackstageActServerData @服务器使用数据(部分字段客户端也有可能用到)
---@field client_data BackstageActClientData @客户端显示数据
---@field act_data string @活动生成的数据

---@class BackstageActClientData
---@field act_name string @活动名字
---@field act_desc string @活动描述
---@field atlas_name string @图标图集
---@field icon_name_1 string @图标名字
---@field tips_atlas_name string @tips界面图标图集
---@field activity_form number @任务形式
---@field acitive_text string @活动任务文本描述
---@field target string @跳转方式+位置
---@field button_txt string @跳转按钮显示文字
---@field award_id number @显示奖励id
---@field sort number @排序
---@field show_type number @活动界面显示类型
---@field act_times number @每日参与次数
---@field icon_name_2 string @
---@field icon_name_3 string @
---@field icon_name_4 string @
---@field atlas_name_four string @
---@field total_act_times number @总共参与次数
---@field actual_time PairIntInt @实际开放时间
---@field day_times PairIntInt__Array @每日开放时间
---@field system_id number @进入等级限制要去读取的sysytem_id值。
---@field score_limit_list BackstageActScoreLimitNode__Array @积分限制相关
---@field fetch_award_time PairInt64Int64 @领奖时间段
---@field rank_main_id number @对应leaderboard_frame表的id

---@class BackstageAct2ClientNode
---@field act_uid number @活动uid,唯一ID
---@field act_type number @活动类型
---@field display_end_stamp int64 @活动显示的结束时间
---@field display_data BackstageActClientData @显示数据
---@field today_play_times_key int64 @今日参与次数的commondatakey
---@field cur_or_next_act_time PairInt64Int64 @当前或者下一个活动时间范围
---@field delay_time number @(废弃
---@field gift_id PairIntInt__Array @礼包id
---@field act_tid number @活动模板ID
---@field father_id number @父活动id

---@class backstageAct2ClientList
---@field act_list BackstageAct2ClientNode__Array @
---@field is_from_rpc boolean @是否来自rpc请求
---@field father_data BackstageActFatherData__Array @父节点数据
---@field act_type number @0节日活动,1礼包活动

---@class BackstageActReqRes
---@field result ErrorCode @

---@class BackstageActReqArg
---@field father_id number @父节点id
---@field act_type number @0代表节日活动，1代表礼包活动

---@class SaveBackstagerActArg
---@field act_valid number @是否删除
---@field act_data BackstageActData @
---@field is_father boolean @是否父节点数据

---@class SaveBackstagerActRes
---@field result ErrorCode @

---@class BackstageActGSData
---@field act_id number @
---@field act_type number @活动类型
---@field status_type number @状态
---@field open_params RepeatedString @开启活动所需参数
---@field cur_or_next_act_time PairInt64Int64 @当前或者下一个活动时间范围
---@field day_max_participate_cnt number @玩家每日最大参与次数
---@field act_extradata string @活动产生的数据
---@field delay_time number @额外领奖时间（废弃
---@field gift_list PairIntInt__Array @礼包列表
---@field actual_time PairInt64Int64 @实际活动时间(大区间
---@field fetch_award_time PairInt64Int64 @领奖时间段
---@field score_limit_list BackstageActScoreLimitNode__Array @道具积分限制信息
---@field open_params_pi64i64 PairInt64Int64__Array @pairint64的openparam
---@field open_param_int64 int64__Array @int64的openparam

---@class BackstageActGSDataList
---@field data_list BackstageActGSData__Array @
---@field father_nodes BackstageAct2GSFatherNode__Array @父节点

---@class BackstageActFatherData
---@field act_name string @活动名字
---@field display_time PairInt64Int64 @显示按钮的时间
---@field atlas_name string @图标图集
---@field icon_name string @界面背景
---@field act_type number @活动类型
---@field father_id number @父活动id

---@class BackstageAct2GSFatherNode
---@field act_data BackstageActData @父节点数据
---@field displaying boolean @是否显示状态(gs维护)

---@class GetSpecialSupplyInfoArg

---@class GetSpecialSupplyInfoRes
---@field result ErrorCode @错误码
---@field online_time int64 @在线时长
---@field choose_item_index number @item_list的下标，因为奖励可能是同样的
---@field item_list SupplyItemInfo__Array @所有item列表
---@field dice_list number__Array @骰子值的列表，初值是-1
---@field can_recv_awards boolean @是否可以领取奖励
---@field awards_multiple number @奖励的倍数，骰子骰出来的倍数，默认是0
---@field use_dice_count number @已经骰骰子的次数
---@field can_redice boolean @是否可以重骰 骰子
---@field next_recv_awards_time int64 @下一次领取奖励时间戳
---@field act_start_time int64 @活动开始时间
---@field act_end_time int64 @活动结束时间
---@field default_dice boolean @是否是默认定制

---@class SupplyItemInfo
---@field item_id number @一个item的id
---@field item_cd_end_time int64 @CD结束的时间
---@field bind number @道具绑定的参数
---@field item_count number @道具的数量

---@class ChooseSpecilSupplyAwardsArg
---@field item_index number @item_list的下标

---@class ChooseSpecilSupplyAwardsRes
---@field result ErrorCode @错误码
---@field item_index number @item_list的下标

---@class SetSpecialSupplyDiceArg
---@field stage number @设置的阶段 最小是0

---@class SetSpecialSupplyDiceRes
---@field result ErrorCode @错误码
---@field stage number @设置的阶段 最小是0
---@field value number @骰子的点数

---@class RecvSpecialSupplyAwardsArg

---@class RecvSpecialSupplyAwardsRes
---@field result ErrorCode @错误码

---@class RandomDiceValueArg
---@field use_dice_count number @当前使用的次数是第几次

---@class RandomDiceValueRes
---@field result ErrorCode @错误码
---@field awards_multiple number @骰出的点数，也就是奖励的倍数
---@field use_dice_count number @骰骰子的次数
---@field can_redice boolean @是否可以重骰

---@class QueryBingoGuessArg
---@field pos number @位置1-36
---@field item_id number @数字道具

---@class QueryBingoGuessRes
---@field result ErrorCode @

---@class QueryBingoLightRes
---@field result ErrorCode @

---@class QueryBingoLightArg
---@field light_pos number @

---@class UpdateBackstageActDataArg
---@field act_id number @
---@field act_data string @

---@class UpdateBackstageActDataRes
---@field result ErrorCode @

---@class BingoGridData
---@field grid_data PairIntInt__Array @
---@field open_time PairInt64Int64__Array @开放时间
---@field init_time int64 @初始化时间戳

---@class QueryBingoZoneArg

---@class QueryBingoZoneRes
---@field result ErrorCode @
---@field guess_list RepeatPairIntInt @

---@class GetBingoAwardArg
---@field award_id number @奖励ID

---@class GetBingoAwardRes
---@field result ErrorCode @

---@class BackstageActTimeData
---@field display_time PairInt64Int64 @显示时间
---@field actual_time PairInt64Int64 @实际活动的时间
---@field open_time_repeat_pair RepeatPairIntInt @开放的时间段列表
---@field delay_time number @活动结束后的领奖时长单位小时(废弃
---@field last_begin_time int64 @最后一次开始时间戳
---@field fetch_award_time PairInt64Int64 @领奖时间段
---@field pre_notice PairIntInt @开始前x秒发公告
---@field clear_rank_time int64 @清除排行榜的时间
---@field rank_send_award_time int64 @通知排行榜发奖的时间

---@class BackstageActServerData
---@field father_id number @父节点id
---@field act_tid number @活动模板ID
---@field act_type number @活动类型
---@field is_show number @是否显示该活动
---@field system_id number @判断role.systemopen()
---@field open_params RepeatedString @开放活动需要的参数
---@field server_level number @服务器等级
---@field gift_list RepeatPairIntInt @礼包列表
---@field score_limit_list BackstageActScoreLimitNode__Array @积分限制信息
---@field rank_main_id number @排行mainid，用于清榜的时候用
---@field open_params_pi64i64 PairInt64Int64__Array @解析成Pairint6464的类型的openparam
---@field open_param_int64 int64__Array @解析成int64类型的openparam

---@class ActivityTimeInfo
---@field time_id number @时间id
---@field loop_type number @循环类型
---@field loop_day number__Array @循环生效参数数组(如果是周循环，表示星期，如果是月循环表示的是日期）
---@field show_begin_time number @显示开始时间
---@field show_end_time number @显示结束时间
---@field real_begin_time number @生效开始时间
---@field real_end_time number @生效结束时间

---@class NtfActivityTimeInfoList
---@field activity_time_info_list ActivityTimeInfo__Array @活动时间信息列表

---@class GetActivityAwardArg
---@field act_type number @活动类型
---@field index number @奖励阶段,从1开始

---@class GetActivityAwardRes
---@field result ErrorCode @

---@class JifenActivityData
---@field jifen_list PairInt64Int64__Array @second积分值first高32位预留低16位阵营16-32位积分类型
---@field time_stamp uint64 @最新时间戳

---@class JifenSyncData
---@field act_type number @活动Type
---@field jifen JifenActivityData @

---@class GetTotalJifenArg
---@field act_type number @活动类型

---@class GetTotalJifenRes
---@field result ErrorCode @
---@field jifen JifenActivityData @

---@class GetActivitiesDataArg
---@field act_type number @

---@class GetActivitiesDataRes
---@field result ErrorCode @
---@field act_type number @
---@field act_id number @
---@field act_data string @

---@class BackstageActScoreLimitNode
---@field item_id number @道具id
---@field everyday_limit number @每日限制
---@field rank_com_id number @相应排行榜的comid
---@field commondata_type number @清0时机对应的commondatatype
---@field item_type number @上面itemid对应类型(1积分2货币)
---@field local_today string @今日积分字段本地化
---@field local_total string @总积分本地化
---@field local_limit string @积分上限本地化

---@class AuctionItemDBInfo
---@field auction_id number @
---@field count number @
---@field money_type number @
---@field item_id number @
---@field is_in_auction boolean @是否开始拍卖
---@field auction_continue_time number @拍卖剩余时间
---@field auction_extend_time number @拍卖延长时间
---@field owner_role_uid uint64 @当前竞价最高的玩家
---@field item_uid uint64 @
---@field base_price number @
---@field cur_price number @
---@field bill_brief AuctionBillBrief__Array @
---@field gm_lock boolean @gm锁

---@class AuctionRoleDBData
---@field role_uid uint64 @
---@field role_db_info AuctionRoleDBInfo @
---@field operate_type number @0:插入行 1:删除行

---@class AuctionItemPbInfo
---@field auction_id number @
---@field count number @
---@field end_auction_time number @拍卖结束时间
---@field item_uid uint64 @
---@field is_in_auction boolean @是否开始拍卖
---@field is_init boolean @是否是初始状态，未被出价
---@field cur_bib_price number @当前物品出价
---@field my_bib_price number @我的出价 0:我没有出价
---@field bill_state AuctionBillState @我对这个拍卖品订单状态

---@class GetAuctionInfoArg

---@class GetAuctionInfoRes
---@field error_code ErrorCode @
---@field auction_item_info AuctionItemPbInfo__Array @
---@field follow_item_list number__Array @

---@class AuctionFollowItemArg
---@field item_id number @
---@field is_follow boolean @true:关注 false:取关

---@class AuctionFollowItemRes
---@field error_code ErrorCode @

---@class FollowerItemList
---@field role_uid uint64 @
---@field item_id number__Array @

---@class AuctionItemBibArg
---@field item_uid uint64 @
---@field is_auto_bib boolean @true: 自动出价 false: 手动出价
---@field bib_price number @出价的价格

---@class AuctionItemBibRes
---@field error_code ErrorCode @

---@class AuctionBillCancelArg
---@field item_uid uint64 @

---@class AuctionBillCancelRes
---@field error_code ErrorCode @

---@class AuctionRolePbInfo
---@field follow_item_list number__Array @关注列表
---@field role_cur_bill_info AuctionBillInfo__Array @玩家正在拍卖的订单

---@class AuctionBillInfo
---@field item_uid uint64 @
---@field auction_id number @
---@field bill_brief AuctionBillBrief @

---@class AuctionDBInfo
---@field auction_item_list AuctionItemDBInfo__Array @当前上架的物品
---@field auction_item_stock AuctionItemBrief__Array @拍卖行物品基础信息（库存,价格）

---@class AuctionRoleDBInfo
---@field follow_item_list number__Array @
---@field role_cur_bill_info AuctionBillInfo__Array @玩家正在拍卖的订单
---@field role_history_bill_list AuctionBillInfo__Array @玩家历史订单（七天）

---@class AuctionItemBrief
---@field item_id number @
---@field stock number @库存
---@field price number @价格
---@field history_auction_count number @日均竞拍人数
---@field today_auction_count number @今日拍卖出去的个数

---@class AuctionBillBrief
---@field create_time number @
---@field bib_result number @
---@field role_uid uint64 @
---@field state AuctionBillState @订单状态

---@class AuctionKeepAliveNotifyData

---@class AuctionItemPbNotify
---@field item_infos AuctionItemPbInfo__Array @

---@class AuctionFinishedSendMailArg
---@field role_auction_pb RoleAuctionItemFinishedPb__Array @

---@class AuctionFinishedSendMailRes
---@field result ErrorCode @

---@class RoleAuctionItemFinishedPb
---@field role_uid uint64 @
---@field item_id number @
---@field item_count number @
---@field money_type number @
---@field bib_price number @玩家出价
---@field item_deal_price number @道具成交价格
---@field result AuctionResult @玩家拍卖结果

---@class RoleDepositDBData
---@field role_uid uint64 @
---@field add_or_del boolean @0:add 1:del
---@field db_info DepositDBInfo @

---@class TradeSendDepositArg
---@field deposit_info RoleDepositInfo__Array @

---@class TradeSendDepositRes
---@field error_code ErrorCode @
---@field role_uid uint64 @
---@field deposit_item RoleDepositInfo__Array @

---@class DepositDBInfo
---@field deposit_info RoleDepositInfo__Array @

---@class RoleDepositInfo
---@field item_info MapInt32Int32 @
---@field reason ItemChangeReason @
---@field sub_reason ItemChangeReason @子原因

---@class QueryUniqueRoleIDsArg
---@field server_id number @
---@field rpcid number @
---@field want_num number @
---@field role_info RoleCreateInfo @

---@class QueryUniqueRoleIDsRes
---@field start_index uint64 @起始ID
---@field len number @可用长度

---@class RoleCreateInfo
---@field sex number @
---@field type number @
---@field eye_id number @
---@field hair_id number @
---@field role_index number @
---@field eye_style_id number @
---@field player_init_name string @玩家创建角色默认名字

---@class RegisterNs2AuthArg
---@field zoneid number @
---@field serverid number @

---@class RegisterNs2AuthRes
---@field result ErrorCode @

---@class CertifyArg
---@field token string @
---@field account string @
---@field password string @
---@field type LoginType @
---@field pf string @
---@field openid string @
---@field platid PlatType @
---@field version string @

---@class CertifyRes
---@field loginToken string @
---@field userphone string @
---@field loginzoneid number @
---@field error ErrorCode @
---@field tag number @
---@field baninfo PlatBanAccount @
---@field account_info LoginAccountInfo @

---@class MaintainData
---@field operation number @看具体操作 MaintainOperation
---@field maintaininfo string @维护公告，客户端需要立即获得
---@field maintainendtime uint64 @维护结束时间

---@class QueryGateNewRes
---@field recommandgate LoginGateData @
---@field servers SelfServerData__Array @
---@field allservers LoginGateData__Array @
---@field error ErrorCode @

---@class QueryGateNewArg
---@field token string @
---@field account string @
---@field type LoginType @
---@field platid PlatType @
---@field version string @

---@class AcceptGameAgreementArg
---@field openid string @
---@field push_set number @
---@field agreement string @使用条款版本号
---@field type LoginType @

---@class AcceptGameAgreementRes
---@field error ErrorCode @

---@class GetGameAgreementArg
---@field openid string @

---@class GetGameAgreementRes
---@field agreed boolean @

---@class LoginAccountInfo
---@field is_accepted boolean @是否已经接受用户协议
---@field openid string @

---@class HatredTargetInfo
---@field entity_id uint64 @
---@field behatred_entity_uuid uint64 @受到仇恨的entity
---@field use_arrow boolean @是否用箭头提示
---@field use_sync_hatred_target boolean @用于仇恨目标更新

---@class BeginMatchForBattleFieldArg

---@class BeginMatchForBattleFieldRes
---@field error ErrorCode @

---@class GetBattleRevenueArg

---@class GetBattleRevenueRes
---@field result ErrorCode @
---@field bless_info BlessRevenuePbInfo @
---@field common_info CommonRevenuePbInfo @

---@class BaseRevenuePbInfo
---@field fight_time number @
---@field base_exp int64 @
---@field job_exp int64 @
---@field items RevenueItemPbInfo__Array @

---@class BlessRevenuePbInfo
---@field base_info BaseRevenuePbInfo @
---@field is_bless boolean @
---@field remain_bless_time number @

---@class CommonRevenuePbInfo
---@field base_info BaseRevenuePbInfo @
---@field fight_state number @

---@class GetSimpleBattleRevenueArg

---@class GetSimpleBattleRevenueRes
---@field result ErrorCode @
---@field base_info BaseRevenuePbInfo @

---@class RevenueChangeDataPb
---@field items RevenueItemPbInfo__Array @
---@field is_bless boolean @
---@field exp_info RevenueExpPbInfo @

---@class RevenueExpPbInfo
---@field base_exp int64 @
---@field job_exp int64 @

---@class BigWolrdDBData
---@field group InfluenceGroup__Array @
---@field influence MSInfluence__Array @
---@field last_refresh_time uint64 @

---@class InfluenceGroup
---@field id number @
---@field cycle_type number @
---@field trigger_count number @

---@class MSInfluence
---@field id number @
---@field cycle_type number @
---@field trigger_count number @

---@class InfluenceData
---@field type number @
---@field args InfluenceArgs @
---@field scene_id number @
---@field influence_id number @

---@class InfluenceArgs

---@class SceneInfluenceSet
---@field evts SceneInfluenceEvt__Array @所有正在发生的影响

---@class SceneInfluenceEvt
---@field scene_id number @
---@field influence_id number @
---@field end_time number @时间戳，持续到此时

---@class ReqChatRecordRes
---@field result ErrorCode @
---@field records ChatRecordList @

---@class ReqChatRecordArg
---@field rpc_id number @
---@field sequence_id PBuint64__Array @

---@class ChatInfo
---@field uid uint64 @
---@field channel ChatChannel @
---@field content string @
---@field name string @
---@field content_key string @
---@field is_show_in_chat boolean @是否显示在聊天栏
---@field show_time number @显示时间(秒)

---@class ChatSenderInfoRes
---@field error ErrorCode @
---@field member_info MemberBaseInfo @

---@class ChatSenderInfoArg
---@field uid uint64 @

---@class SendHornArg
---@field channel ChatChannel @
---@field content string @
---@field item Item__Array @

---@class SendHornRes
---@field error ErrorCode @

---@class AnnounceData
---@field id number @
---@field session_ids PBuint64__Array @
---@field uuid int64 @
---@field type number @
---@field announce_msg AnnounceMsg__Array @公告数据
---@field send_time int64 @
---@field end_time int64 @
---@field show_interval int64 @
---@field outlook_id number @外观类型
---@field is_close boolean @关闭公告

---@class ChatBubbleData
---@field entity_uid uint64 @说话的entity_uid
---@field chat_id number @

---@class PrivateChatInfo
---@field uid uint64 @
---@field content string @文字消息
---@field medium_type ChatMediumType @语音/文字
---@field audio AudioChat @语音消息
---@field extra_param ExtraParam__Array @成就聊天道具等
---@field server_trigger boolean @是否服务器主动发起

---@class PrivateDetailChatInfo
---@field chat_uid uint64 @聊天对象uid
---@field chat_type number @0：使用id  1：内容 2：语音
---@field id number @
---@field content string @
---@field chat_time uint64 @
---@field who_type number @0系统消息 1我说的 2他人说的 3我说的，但发送失败 4服务器主动触发我自己(server判断加入未读列表)
---@field squence number @标识唯一id
---@field audio AudioChat @语音
---@field extra_param ExtraParam__Array @

---@class ReadPrivateMessageArg
---@field uid uint64 @
---@field squence number @

---@class ReadPrivateMessageRes
---@field result ErrorCode @
---@field private_chat_list PrivateDetailChatInfo__Array @

---@class UnReadMessageCountInfo
---@field uid uint64 @
---@field count number @
---@field last_chat_time uint64 @最近的聊天时间

---@class UnReadMessageCountData
---@field total_unread_count number @
---@field unread_counts UnReadMessageCountInfo__Array @

---@class ObjectMessagePbInfo
---@field uid uint64 @聊天对象uid
---@field last_chat_time uint64 @
---@field current_squence number @
---@field messages uint64__Array @
---@field chat_count number @对方和我说话的次数

---@class RoleMessagePbInfo
---@field message_list ObjectMessagePbInfo__Array @

---@class ChatMsgHead
---@field msg_type ChatMsgType @频道类型，枚举ChatMsgType
---@field msg_id number @消息id,全局唯一
---@field msg_time uint64 @服务器消息时间戳
---@field sender_uid uint64 @发送者消息id
---@field receiver_uid uint64 @接受者消息id,依据msg_type判断接收者类型
---@field preview_type number @前端使用类型 后端只转发

---@class ChatMsg
---@field msg_head ChatMsgHead @通用消息头
---@field msg_content string @文字消息
---@field medium ChatMediumType @介质（文字/语音）
---@field audio AudioChat @语音消息
---@field extra_param ExtraParam__Array @成就 道具等
---@field red_envelope_info GuildRedEnvelopeInfo @红包数据
---@field stickers StickerBaseInfo @贴纸数据

---@class ChatMsgWithLists
---@field chat_msg ChatMsg @目前Game维护场景,场景消息广播
---@field receiver_list uint64__Array @在线玩家
---@field exclude_list uint64__Array @注意这里是sessionid，添加屏蔽之后要加这个名单

---@class PullChatArg
---@field msghead ChatMsgHead @消息头

---@class PullChatRes
---@field error ErrorCode @错误码
---@field msg ChatMsg__Array @消息体

---@class AudioChat
---@field audio_id string @
---@field text string @文字翻译
---@field duration number @时长

---@class ChatRecord
---@field private PrivateDetailChatInfo @好友私聊
---@field from_type ChatMsgType @私聊/公会...
---@field other ChatMsg @除好友私聊外的其它
---@field sequence_id int64 @唯一id

---@class DelChatRecordData
---@field sequence_id PBuint64__Array @

---@class ChatRecordList
---@field record ChatRecord__Array @

---@class ReqChatRecordFromDBArg
---@field sequence_id PBuint64__Array @
---@field rpc_id number @

---@class ReqChatRecordFromDBRes
---@field records ChatRecordList @
---@field result ErrorCode @

---@class SendChatMsgArg
---@field msg ChatMsg @

---@class SendChatMsgRes
---@field result ErrorCode @
---@field residue_chat_cd int64 @此频道剩余cd
---@field reason string @
---@field end_time uint64 @结束禁言的时间戳

---@class ChatItemCostArg
---@field delay_rpc number @
---@field item_id number @扣除道具的id
---@field item_count number @扣除道具的数量
---@field role_uid uint64 @

---@class ChatItemCostRes
---@field result ErrorCode @错误码

---@class AnnounceClearInfo
---@field announce_list PBint64__Array @

---@class AnnounceNotifyToGuildInfo
---@field guild_id int64 @
---@field announce_id number @
---@field announce_msg AnnounceMsg__Array @

---@class ClearChatRecordData
---@field chat_uid uint64 @聊天对象的uid

---@class RoleMessageInfo
---@field role_uid uint64 @
---@field message RoleMessagePbInfo @

---@class GMAnnouncePtcData
---@field data string @

---@class TalkCDOffset
---@field talk_type number @聊天频道类型
---@field offset_cd int64 @调整偏移cd
---@field end_timestamp int64 @失效时间
---@field reason string @

---@class TalkCDOffsetData
---@field role_uid uint64 @
---@field server_id number @
---@field cd_info TalkCDOffsetList @
---@field mtime uint64 @

---@class TalkCDOffsetList
---@field cd_info TalkCDOffset__Array @
---@field forbid_info TalkForbid__Array @

---@class TalkForbid
---@field talk_type number @聊天频道类型
---@field end_timestamp int64 @失效时间
---@field reason string @
---@field self_see boolean @聊天是否自己可以看到

---@class TalkForbidData
---@field account string @
---@field server_id number @
---@field forbid_info TalkCDOffsetList @
---@field mtime uint64 @

---@class TalkForbidList
---@field openid string @
---@field talk_forbid TalkForbid__Array @

---@class TalkForbidListNtfData
---@field talk_list TalkForbidList__Array @

---@class AnnounceTransferToMsData
---@field announce_id number @
---@field announce_msg AnnounceMsg__Array @
---@field role_ids PBuint64__Array @

---@class SendGuildAidArg
---@field msg ChatMsg @

---@class SendGuildAidRes
---@field result ErrorCode @
---@field residue_chat_cd int64 @此频道剩余cd
---@field end_time uint64 @
---@field reason string @

---@class ChatCDNotifyData
---@field chat_cd ChatCD__Array @
---@field aid_cd ChatCD__Array @

---@class ChatCD
---@field type ChatMsgType @
---@field residue_chat_cd int64 @此频道剩余cd
---@field end_time uint64 @结束禁言的时间戳
---@field reason string @

---@class CheckTextForbidArg
---@field rpc_id number @
---@field check_text CheckText__Array @

---@class CheckTextForbidRes
---@field error_code ErrorCode @
---@field check_text CheckText__Array @

---@class CheckText
---@field uid uint64 @
---@field text string @
---@field flag MsgForbidFlag @脏词类型

---@class BatchChatSenderInfoArg
---@field role_uid_list PBuint64__Array @只处理20位玩家

---@class BatchChatSenderInfoRes
---@field error ErrorCode @
---@field member_list MemberBaseInfo__Array @

---@class RoleChatForbidInfo
---@field forbidrole PBuint64__Array @屏蔽聊天的roleid

---@class ChatForbidInfo
---@field detail MemberBaseInfo @详细信息
---@field roleid PBuint64 @如果该玩家不在线，没有详细信息，则只有roleid，客户端可以后续拉取

---@class ChangeChatForbidReq
---@field roleid PBuint64 @
---@field isadd boolean @true，增加名单，false，删除该id

---@class ChangeChatForbidRes
---@field result ErrorCode @
---@field forbidinfo ChatForbidInfo @如果成功，这里会有具体信息

---@class ChatForbidNtfOnLoginNtf
---@field forbidlist PBuint64__Array @

---@class ChangeChatTagRes
---@field result ErrorCode @

---@class ChangeChatTagArg
---@field tag_id number @聊天标签id

---@class RoleChatNotify

---@class RoomSetting
---@field room_name string @
---@field room_type number @
---@field room_capacity number @容纳的人数
---@field room_code string @0表示没密码,1为有密码 真实密码不会传给客户端防止破解泄密

---@class ChatRoomInfo
---@field room_uid uint64 @
---@field room_captain_uid uint64 @房主uid
---@field room_member RoomMemberInfo @成员基本信息
---@field room_setting RoomSetting @
---@field create_time uint64 @

---@class CreateChatRoomArg
---@field setting RoomSetting @

---@class CreateChatRoomRes
---@field result ErrorCode @

---@class RoomChangeCaptainData
---@field captain UserID @
---@field room_code string @非0为存在密码,若是房主密码为明文,若是成员为非零数字防止泄密

---@class ChangeRoomSettingArg
---@field setting RoomSetting @

---@class ChangeRoomSettingRes
---@field result ErrorCode @

---@class RoomMemberInfo
---@field info MemberBaseInfo__Array @

---@class KickRoomMemberArg
---@field kick_role_uid uint64 @

---@class KickRoomMemberRes
---@field result ErrorCode @

---@class ChangeRoomData
---@field setting RoomSetting @
---@field create_time uint64 @

---@class LeaveRoomArg

---@class LeaveRoomRes
---@field result ErrorCode @

---@class DissolveRoomArg

---@class DissolveRoomRes
---@field result ErrorCode @

---@class ApplyJoinRoomArg
---@field room_uid uint64 @
---@field room_code string @

---@class ApplyJoinRoomRes
---@field result ErrorCode @

---@class RoomChangeCaptainArg
---@field new_captain_uid uint64 @

---@class RoomChangeCaptainRes
---@field result ErrorCode @

---@class ChatRoomInfoArg

---@class ChatRoomInfoRes
---@field result ErrorCode @
---@field room_info ChatRoomInfo @

---@class RoomMerberStatusNtfData
---@field role_uid uint64 @
---@field status MemberStatus @

---@class RoomAfkArg
---@field is_afk boolean @

---@class RoomAfkRes
---@field result ErrorCode @

---@class RoomBriefNeighbourNtfData
---@field role_uid uint64 @
---@field brief ChatRoomBrief @

---@class RoomDissolveNtfData
---@field reason RoomChangeReason @

---@class LeaveRoomNftData
---@field role_uid uint64 @
---@field reason RoomChangeReason @

---@class ShowTipToRoleData
---@field string_table_key string @
---@field show_tip_type number @
---@field color number @颜色
---@field show_time number @显示时间
---@field args LocalizationNameContainer @参数，非必选

---@class AnnounceMsg
---@field localization_name LocalizationName @本地化数据
---@field extra_param ExtraParam @额外参数

---@class SyncTimeRes
---@field server_time uint64 @服务器时间（毫秒）
---@field time_zone number @时区
---@field serverlevel number @当前服务器等级

---@class NullArg

---@class NullRes
---@field result ErrorCode @

---@class SyncGameTimeData
---@field time_offset number @时间偏移
---@field open_servertime uint64 @开服时间
---@field server_level number @服务器等级,变化的时候必填

---@class PBCuint64
---@field value uint64 @

---@class PBCuint32
---@field value number @

---@class HintNotifyMSData
---@field system_type EnumSystemType @
---@field is_hint boolean @

---@class RedPointNotify
---@field notify RedPoint__Array @各种通知

---@class RedPoint
---@field moduleid number @功能id,等待后面整理
---@field count number @大于0就表示有通知

---@class OperateGeneralRecordArg
---@field operate_type number @
---@field key string @
---@field value string @
---@field mtime uint64 @

---@class OperateGeneralRecordRes
---@field error ErrorCode @
---@field key string @
---@field value string @

---@class MapUint64ToInt32
---@field first uint64 @
---@field second number @

---@class RoleReconnectToMsData
---@field role_id uint64 @

---@class RegisterMasterServerData
---@field serverid number @
---@field app number @
---@field plat number @

---@class SaveMsRecordArg
---@field data StringPair @
---@field mtime uint64 @

---@class SaveMsRecordRes
---@field error ErrorCode @

---@class StringPair
---@field key string @
---@field value string @

---@class RegisterNumToMs
---@field register_account number @

---@class WhileListData
---@field openids string__Array @

---@class GetWhiteListFromLoginArg
---@field server_id number @

---@class GetWhiteListFromLoginRes
---@field result ErrorCode @
---@field openids string__Array @

---@class CheckStringUsableArg
---@field str_buff string @
---@field delay_rpc number @

---@class CheckStringUsableRes
---@field result ErrorCode @

---@class ClientASMIadInfoArg
---@field role_id uint64 @
---@field attribution number @是否从AppStore搜索下载 0-false/1-true
---@field org_name string @
---@field campaign_id number @
---@field campaign_name string @
---@field conversion_date string @
---@field click_date string @
---@field adgroup_id number @
---@field adgroup_name string @
---@field key_word string @

---@class ClientASMIadInfoRes
---@field errorcode ErrorCode @

---@class ServerRecordSaveToDbArg
---@field key string @
---@field content string @
---@field mtime uint64 @
---@field delay_rpc_id number @需要dalyrpc的时候用

---@class ServerRecordSaveToDbRes
---@field error_code ErrorCode @

---@class KapulaSignArg

---@class KapulaSignRes
---@field sign LocalizationName @

---@class ReadKapulaAssisArg

---@class ReadKapulaAssisRes
---@field result ErrorCode @

---@class RoleLeaveStateData
---@field state_type number @

---@class NpcTalkScriptEventData
---@field event_type string @事件唯一标识
---@field npc_uid uint64 @
---@field role_id uint64 @
---@field param CommonMultiParam__Array @

---@class CommonMultiParam
---@field float_arg number @
---@field string_arg string @

---@class LocalizationName
---@field type LocalizationNameType @指向应该读取哪个值
---@field id number @本地词库id
---@field str string @KEY/自定义字符串

---@class LocalizationNameContainer
---@field local_name_list LocalizationName__Array @

---@class TableVerData
---@field tables TableHashData__Array @

---@class TableHashData
---@field table_name string @
---@field hash_value uint64 @
---@field hash_time uint64 @

---@class PBuint32
---@field value number @

---@class PBuint64
---@field value uint64 @

---@class PBint64
---@field value int64 @

---@class PBint32
---@field value number @

---@class ExtraParam
---@field type number @参考HrefType
---@field param32 PBint32__Array @
---@field param64 PBint64__Array @
---@field name string__Array @

---@class UpgradeLevelArg
---@field base_or_job boolean @

---@class UpgradeLevelRes
---@field result ErrorCode @

---@class RegisterPay2LoginArg
---@field zone_id number @
---@field server_id number @

---@class RegisterPay2LoginRes
---@field result ErrorCode @
---@field login_server_id number @

---@class RegisterGt2PayArg
---@field server_id number @
---@field line_id number @

---@class RegisterGt2PayRes
---@field result ErrorCode @

---@class RegisterGs2PayArg
---@field line number @
---@field server_id number @

---@class RegisterGs2PayRes

---@class RegisterPayServerData
---@field server_id number @
---@field app number @
---@field plat number @

---@class ShowErrorCode
---@field error_table_key string @ErrorTable关键字

---@class DayActiveInfo
---@field last_update_time int64 @
---@field today_login_roles int64__Array @
---@field day_active_nums int64__Array @

---@class DungeonsPassedInfo
---@field dungeon_ids number__Array @

---@class SetOnceDataArg
---@field key number @
---@field flag boolean @

---@class SetOnceDataRes
---@field result ErrorCode @

---@class FAQReportArg
---@field is_matched boolean @是否匹配
---@field question string @问题
---@field answer string @答案
---@field content string @玩家反馈的问题

---@class FAQReportRes
---@field result ErrorCode @

---@class SetCommonDataArg
---@field key number @key
---@field value int64 @

---@class SetCommonDataRes
---@field result ErrorCode @

---@class MapUint32ToUint64
---@field first number @
---@field second uint64 @

---@class PairInt64Int64
---@field first int64 @
---@field second int64 @

---@class RepeatPairIntInt
---@field repeat_pairs PairIntInt__Array @

---@class PairIntInt
---@field first number @
---@field second number @

---@class SQLExecCommonArg
---@field sql string @要执行的sql语句
---@field rpc_id number @rpc_id
---@field query_type number @查询类型(返回用
---@field mail_uid uint64 @邮件id(删除全局邮件专用)

---@class SQLExecCommonRes
---@field result ErrorCode @结果

---@class SetRedPointCommonDataArg
---@field key number @
---@field value int64 @直接用int64,这里不用压缩

---@class SetRedPointCommonDataRes
---@field error_code ErrorCode @

---@class SaveTlogCloseToDb
---@field tlogname string @
---@field isclose number @1表示关闭tlog，0表示解除关闭

---@class SaveTlogCloseToDbNtf
---@field tlogname string @
---@field isclose number @1表示关闭这条tlog，0表示解除关闭。

---@class TlogCloseInfo
---@field tlogname string @
---@field isclose boolean @

---@class TlogCloseInfoNtf
---@field tlogclosechangeinfo TlogCloseInfo__Array @

---@class ActivityState
---@field activity_type number @活动类型：1-礼包;
---@field activity_id number @活动id
---@field activity_state number @活动状态

---@class GetTimeGiftInfoArg
---@field last_updata_time number @最后一次得到通知的时间戳

---@class GetTimeGiftInfoRes
---@field last_update_time number @服务器礼包数据最后一次变更时间
---@field gift_info_list TimeGiftInfo__Array @限时礼包信息列表

---@class TimeGiftInfo
---@field main_id number @礼包活动uid
---@field group_id number @礼包组id
---@field function_id number @功能id
---@field time_limit_id number @活动时间id
---@field activity_name string @礼包名称
---@field sort number @排序优先级
---@field gift_id_list number__Array @礼包id list
---@field state number @礼包活动开启状态

---@class GetCountInfoArg

---@class GetCountInfoRes
---@field error_code ErrorCode @
---@field item_list CountItemInfo__Array @

---@class CountUpdateSyncInfo
---@field item_list CountItemInfo__Array @

---@class CountItemAllInfo
---@field type int64 @
---@field id int64 @
---@field count int64 @
---@field top_limit int64 @
---@field cd_time_stamp int64 @cd到达时间戳

---@class CountUpdateSyncAllInfo
---@field item_list CountItemAllInfo__Array @

---@class SyncServerCountToGSRes
---@field error ErrorCode @

---@class OperateServerCountArg
---@field type int64 @
---@field id int64 @
---@field incr_count int64 @
---@field cd_time_stamp int64 @

---@class OperateServerCountRes
---@field count_real_incr int64 @

---@class FailEnterFBData
---@field uid uint64 @
---@field reason FailEnterFBReason @
---@field param number @

---@class CaptainRequestEnterFBData
---@field dungeon_id number @
---@field chapter_id uint64 @
---@field captain_id uint64 @
---@field dungeons_degree EnmDungeonsDegree @副本难度等级

---@class AskMemberEnterFBData
---@field dungeon_id number @
---@field chapter_id number @
---@field assist boolean @是否必须助战
---@field scene_id number @场景id

---@class MemberReplyEnterFBData
---@field type ReplyType @

---@class SyncMemberReplyEnterFBData
---@field uid uint64 @
---@field type ReplyType @

---@class CheckMemberQualificationForDungeonArg
---@field dungeon_id number @
---@field uid uint64 @
---@field check_type CheckDungeonType @
---@field qualification_type number @第一次查资格 第二次查资格并扣除相关费用之类的
---@field is_single_dungeon boolean @

---@class CheckMemberQualificationForDungeonRes
---@field reason FailEnterFBReason @
---@field lock_items Item @
---@field assist boolean @是否默认助战

---@class DungeonsResultData
---@field status DungeonsResultStatus @
---@field dungeons_id number @副本id
---@field pass_time number @通关时间
---@field attrs DungeonsAttrData__Array @战斗属性统计
---@field cook_result CookResultData__Array @
---@field pvp PVPParam @
---@field award_list CounterIntPair__Array @通关奖励
---@field platform_statistics PlatformStatistics @擂台角斗场统计
---@field degree EnmDungeonsDegree @副本难度
---@field grade number @副本成绩
---@field theme_record ThemeDungeonsRecord @
---@field room_type MazeRoomType @迷宫房间类型
---@field guild_match_statistics GuildMatchStatistics @公会匹配赛副本
---@field back_scene_uid number @返回场景的uid
---@field is_assist boolean @是否助战
---@field awards_info AwardsInfo__Array @道具列表

---@class DungeonsAttrData
---@field role_id uint64 @
---@field attr_id PBuint32__Array @
---@field profession RoleType @

---@class DungeonsEncourageData
---@field src_role_id uint64 @
---@field dest_role_id uint64 @

---@class NewMenuOrderData
---@field new_order Order @

---@class RemoveMenuOrderData
---@field order Order @

---@class CookFoodOperationData
---@field trigger_id uint64 @
---@field operation FoodOperation @

---@class CookDungeonNotRequireFoodData
---@field require_food_id number @

---@class CookDungeonTargetData
---@field failed_count number @
---@field time_left number @
---@field dishes_to_cook Order__Array @
---@field dishes_cooked Order__Array @

---@class Order
---@field uid uint64 @
---@field id number @
---@field time_left number @
---@field score number @烹饪得分

---@class OrderFinishData
---@field order Order @

---@class CookResultData
---@field id CookDungeonAttr @
---@field value number @

---@class DungeonsPromptData
---@field message_id number @

---@class BattlefieldTeamInfoArg
---@field scene_id number @

---@class BattlefieldTeamInfo
---@field uid uint64 @组id
---@field total_elo number @elo总值
---@field total_recent_ten_win_times number @近10赢的总数
---@field member_num number @队伍人数

---@class BattlefieldTeamInfoRes
---@field result ErrorCode @
---@field team_info BattlefieldTeamInfo__Array @

---@class BattlefieldStartData
---@field teams BattlefieldTeam__Array @
---@field dungeons_id number @

---@class BattlefieldTeam
---@field team1 uint64 @
---@field team2 uint64 @
---@field vs_team1 uint64 @
---@field vs_team2 uint64 @

---@class BattlefieldUnmatchedData
---@field team_ids uint64__Array @

---@class HSUsedAwardTimesDungeonArg
---@field role_id uint64 @

---@class HSUsedAwardTimesDungeonRes
---@field used_times number @今日已获奖励次数
---@field total_times number @今日可获奖励次数
---@field result ErrorCode @

---@class HSDungeonsInfo
---@field round number @第几轮
---@field monster_id PBint32__Array @怪物配置id
---@field outer_event_id number @外圈随机事件
---@field inner_evnet_id number @内圈随机事件
---@field role_id uint64 @开启开关的玩家id
---@field monster_num number @本轮怪物总数量

---@class HSQueryRoundInfoRes
---@field result ErrorCode @
---@field info HSDungeonsInfo @一轮信息
---@field monster_left_num number @本轮剩余怪物数量

---@class HSQueryRoundInfoArg
---@field role_uuid uint64 @

---@class BattlefieldTeamInfoInScene
---@field scene_id number @
---@field dungeons_id number @
---@field teams BattlefieldTeamInfo__Array @

---@class BattlefieldTeamInfoData
---@field teams_in_scene BattlefieldTeamInfoInScene__Array @
---@field round_times number @第几轮匹配

---@class BattlefieldMatchStatusData
---@field matched_teams uint64__Array @匹配成功组队
---@field unmatched_teams uint64__Array @匹配失败组队

---@class TrialDungeonChooseProfessionArg
---@field professionid number @职业id

---@class TrialDungeonChooseProfessionRes
---@field errcode ErrorCode @返回值,一般成功

---@class TowerLuckyData
---@field role_id PBuint64__Array @

---@class TowerStartCountdownData
---@field duration number @时长
---@field type number @0通关跳层倒计时通知 1跳层倒计时开始duration为当前进度 2计时重置
---@field jump_dungeon_id number @type为0时 需要跳入的副本id等待duration秒

---@class ChangeDungeonArg
---@field data SceneSwitchData @
---@field role_ids PBuint64__Array @
---@field team_uid uint64 @

---@class ChangeDungeonRes
---@field error ErrorCode @

---@class PullMonsterWaveSeedFromMsArg
---@field line_id number @
---@field all_seed AllMonsterWaveSeeds @

---@class PullMonsterWaveSeedFromMsRes
---@field error ErrorCode @

---@class PVPApplyArg
---@field type EnmDailyActivityType @

---@class PVPApplyRes
---@field result ErrorCode @
---@field type EnmDailyActivityType @

---@class PlatformJumpFloorData
---@field platform_uid number @

---@class DungeonsSetMonsterData
---@field num number @设置数量

---@class SeedPair
---@field type number @
---@field seed number @

---@class AllMonsterWaveSeeds
---@field seeds SeedPair__Array @

---@class CheckFollowConditionArg
---@field target_dungeon_id number @
---@field rpc_id number @
---@field check_type number @
---@field follower_id uint64 @
---@field role_id uint64 @

---@class CheckFollowConditionRes
---@field error ErrorCode @

---@class HSCloseRouletteData
---@field monster_id PBint32__Array @

---@class IsAssistArg
---@field is_assist boolean @

---@class IsAssistRes
---@field error ErrorInfo @

---@class DungeonAffixData
---@field dungeon_id number @
---@field affix_ids PBint32__Array @

---@class GetThemeDungeonWeeklyAwardArg
---@field real_get boolean @

---@class GetThemeDungeonWeeklyAwardRes
---@field error ErrorCode @
---@field can_award boolean @

---@class RouletteInfo
---@field room_id number @
---@field room_type MazeRoomType @
---@field result ErrorCode @

---@class FollowOutRangeNftData
---@field out_or_in number @1 out 0 in

---@class PerDungeonMonsterData
---@field dungeons_id number @副本id
---@field monster_ids PBint32__Array @怪物id

---@class DungeonsMonsterData
---@field monsters PerDungeonMonsterData__Array @

---@class GetDungeonsMonsterArg

---@class GetDungeonsMonsterRes
---@field result ErrorCode @
---@field data DungeonsMonsterData @

---@class TowerDungeonsAwardArg
---@field dungeons_id number @

---@class TowerDungeonsAwardRes
---@field result ErrorCode @
---@field dungeons_id number @

---@class MazeRoomStartOrEndData
---@field start_or_end boolean @1是开始，0是结束
---@field start_time uint64 @
---@field room_type MazeRoomType @

---@class SyncDungeonResultToMs
---@field scene_uid number @
---@field result_status number @

---@class DungeonsResultNtfToMs
---@field scene_uid number @
---@field result_status number @
---@field dungeon_id number @

---@class CheckTowerDefenseConditionRes
---@field result ErrorCode @
---@field condition number @

---@class CheckTowerDefenseConditionArg

---@class TowerDefenseSummonArg
---@field summon_id number @召唤阵
---@field servant_type number @英灵职业
---@field is_summon boolean @true召唤false升级

---@class TowerDefenseSummonRes
---@field result ErrorCode @

---@class TowerDefenseServantArg
---@field summon_id number @召唤阵id
---@field servant_cmd number @执行命令

---@class TowerDefenseServantRes
---@field result ErrorCode @

---@class TowerDefenseMagicPowerNtfData
---@field magic_value number @当前魔力值
---@field summon_info SummonInfo__Array @
---@field reason number @变化原因
---@field increase number @增量可能小于零
---@field monster_pos Vec3 @怪物死亡位置
---@field cmd_cd_list CommandSpellCD__Array @角色身上命令cd

---@class TowerDefenseSyncMonsterData
---@field total_monster_count number @
---@field dead_monster_count number @

---@class SummonInfo
---@field summon_id number @召唤阵id
---@field servant_list ServantInfo__Array @兵种信息
---@field cmd_cd_list CommandSpellCD__Array @释放命令时间

---@class ServantInfo
---@field servant_type number @兵种
---@field servant_num number @数量
---@field servant_level number @等级

---@class TowerDefenseWaveBeginData
---@field current_wave number @当前的波次
---@field can_fast_next_wave boolean @能否快速下一波
---@field next_wave_left_time number @下波开始次剩余时间
---@field finished_wave int64 @普通完成的波次(二进制)
---@field start_or_end boolean @完成波 还是开始波
---@field now_time_stamp uint64 @当前时间戳
---@field finish_wave_count number @完成总波次包含无尽模式
---@field endless_status boolean @是否无尽模式

---@class TowerDefenseFastNextWaveArg

---@class TowerDefenseFastNextWaveRes
---@field result ErrorCode @

---@class CommandSpellCD
---@field cmd number @
---@field cmd_timestamp uint64 @放技能时间

---@class AssistData
---@field assist boolean @

---@class IsAllMemberAssist

---@class IsAllMemberAssistRes
---@field is_all_member_assist boolean @所有成员是否都助战

---@class ThemeDungeonDBInfo
---@field cur_theme_id number @
---@field select_result_list ThemeDungonResult__Array @
---@field select_pool number__Array @随机池
---@field select_new_pool number__Array @随机池
---@field last_refresh_time uint64 @

---@class ThemeDungonResult
---@field theme_id number @
---@field server_day_began number @
---@field random_seed number @
---@field last_refresh_time uint64 @

---@class ThemeSelectResultNtfArg
---@field select_result ThemeDungonResult @
---@field line number @

---@class ThemeSelectResultNtfRes
---@field result ErrorCode @

---@class GetThemeDungeonInfoArg

---@class GetThemeDungeonInfoRes
---@field result ErrorCode @
---@field dungeons DungeonAffixData__Array @副本信息
---@field theme_id number @主题id
---@field next_refresh_time uint64 @
---@field last_refresh_time uint64 @上次刷新时间可能不是整点

---@class SetThemeStampArg

---@class SetThemeStampRes
---@field result ErrorCode @

---@class SetTowerDefenseBlessArg
---@field attack_id number @攻击id
---@field defense_id number @防御天赋

---@class SetTowerDefenseBlessRes
---@field result ErrorCode @

---@class GetTowerDefenseWeekAwardArg
---@field id number @

---@class GetTowerDefenseWeekAwardRes
---@field result ErrorCode @

---@class TowerDefenseEndlessData
---@field interval_time number @

---@class GetRolesBattleInfoArg
---@field role_id_list uint64__Array @玩家角色id的列表

---@class GetRolesBattleInfoRes
---@field roles_battle_info_list RolesBattleInfo__Array @玩家的信息

---@class RolesBattleInfo
---@field role_id uint64 @玩家角色id
---@field isAssist boolean @是否是助战

---@class AddFriendArg
---@field friend_uid uint64 @

---@class AddFriendRes
---@field result ErrorCode @

---@class DeleteFriendArg
---@field friend_uid uint64 @

---@class DeleteFriendRes
---@field result ErrorCode @

---@class UpdateOrAddFriendData
---@field friend_info FriendInfo @

---@class FriendInfo
---@field uid uint64 @
---@field friend_type FriendType @好友类型
---@field intimacy_degree number @好友度
---@field base_info MemberBaseInfo @玩家基本信息
---@field is_guild_beauty boolean @是否公会魅力担当

---@class DeleteFriendData
---@field friend_uid uint64 @

---@class GetFriendInfoArg
---@field uid uint64 @

---@class GetFriendInfoRes
---@field result ErrorCode @
---@field friend_list FriendInfo__Array @
---@field message_info UnReadMessageCountData @

---@class FriendPbInfo
---@field uid uint64 @
---@field friend_type FriendType @
---@field intimacy_degree number @
---@field day_intimacy_degree number @今天增加的好友度
---@field last_refresh_time uint64 @
---@field statistics FriendDegreeStatistic__Array @好友度各来源统计

---@class RoleFriendPbInfo
---@field friends FriendPbInfo__Array @

---@class FriendIntimacyDegreeData
---@field friend_uid uint64 @
---@field intimacy_degree number @

---@class AddFriendTipNtfData
---@field friend_uid uint64 @
---@field message_id number @

---@class SyncGsFriendInfoData
---@field role_uid uint64 @
---@field op_type FriendOpType @
---@field friend_datas GsFriendInfo__Array @

---@class GsFriendInfo
---@field friend_uid uint64 @
---@field intimacy_degree number @

---@class DoubleActiveApplyArg
---@field friend_role_id uint64 @朋友id
---@field active_type number @行为类型

---@class DoubleActiveApplyRes
---@field result ErrorCode @申请结果

---@class DoubleActiveReplyArg
---@field friend_id uint64 @别人的ID
---@field active_type number @用户行为
---@field is_agree number @是否同意

---@class DoubleActiveReplyRes
---@field friend_id uint64 @
---@field active_type number @
---@field result number @

---@class DoubleActiveData
---@field friend_info MemberBaseInfo @
---@field active_type number @

---@class DoubleActiveEndArg
---@field role_id uint64 @

---@class DoubleActiveEndRes
---@field result ErrorCode @

---@class DoubleActiveEndData
---@field role_id uint64 @

---@class FriendDegreeEventData
---@field source_type FriendDegreeSourceType @来源
---@field friends FriendDegreeUid__Array @

---@class FriendDegreeUid
---@field src_uid uint64 @
---@field dst_uid uint64 @

---@class FriendDegreeStatistic
---@field source_type FriendDegreeSourceType @
---@field count number @

---@class DoubleActiveEnterArg
---@field passive_uuid uint64 @
---@field index number @

---@class DoubleActiveEnterRes
---@field result ErrorCode @

---@class DoubleActionClipControlInterruptData
---@field success_enter_double_action_state boolean @

---@class DoubleActionClipControlStartData
---@field driving_uuid uint64 @
---@field passive_uuid uint64 @
---@field index number @

---@class SingelRoleFriends
---@field role_uid uint64 @
---@field friend_info RoleFriendPbInfo @

---@class KapulaAssistantInfo
---@field kapula_sign LocalizationName @
---@field last_set_time uint64 @
---@field player_read_time MapKeyValue__Array @
---@field player_own_point_time MapKeyValue__Array @

---@class BattleFieldPVPCounterNtfData
---@field brief_info RoleBattleBriefInfo__Array @全量推送所有人变化的PVP统计信息

---@class DynamicDisplayNPCInfo
---@field scene_id number @
---@field npc_table_id number @
---@field npc_uuid uint64 @
---@field pos Vec3 @

---@class DynamicDisplayNPCSet
---@field npc DynamicDisplayNPCInfo__Array @

---@class DynamicDisplayNPCUpdetaData
---@field npc DynamicDisplayNPCInfo @
---@field is_appear number @1出现，0消失

---@class PVPCounter
---@field key number @
---@field value number @

---@class DungeonRandomWaveData
---@field scene_id number @场景id
---@field random_wave_data RandomWaveData__Array @场景所有随机信息

---@class RandomWaveData
---@field wave_id number @配置wave的id
---@field monster_id number @随机出怪物entity表的id
---@field affix_ids number__Array @随机词缀列表

---@class CarryItem
---@field id number @
---@field count number @
---@field state number @
---@field time number @可搬运剩余时间
---@field type CarryItemType @携带物类型

---@class Vec3
---@field x number @
---@field y number @
---@field z number @
---@field layer number @层级

---@class UnitAppearance
---@field uID uint64 @
---@field unitName LocalizationName__Array @本地化名字
---@field unitType number @
---@field level number @
---@field category EntityCategory @
---@field outlook OutLook @
---@field unitSex SexType @性别
---@field skills SkillInfo__Array @所有学习的技能
---@field attr_list AttrInfo__Array @属性
---@field fight_group number @
---@field drop_item DropItemInfo @
---@field buffs ROBuffInfos @
---@field ownerUID uint64 @召唤兽的召唤师ID
---@field unitTransfigureID number @变身
---@field wall_data WallData @墙的数据
---@field vehicle TakeVehicleInfo @
---@field step_sync_info StepSyncInfo @
---@field position Vec3 @
---@field direction number @
---@field in_battle boolean @
---@field common_vehicle VehicleEntityData @公共载具实体特有的数据
---@field carry_item_ CarryItem @玩家携带的东西, 会有抱动作
---@field common_vehicle_uuid uint64 @玩家乘坐的公共载具uid
---@field equip_data EquipData @
---@field effect_id number @播放特效id
---@field outward_info OutwardInfo @怪物饰品
---@field collection_data CollectionData @采集物实体数据
---@field show_weights number @显示权重
---@field guild_info RoleGuildInfo @公会信息
---@field affix_ids PBint32__Array @词缀id
---@field skill_start_info SkillStartInfo__Array @技能开始信息
---@field platform_floor number @擂台层数
---@field trigger_object_info SceneTriggerObjectInfo @触发器对象数据
---@field drop_buff DropBuffInfo @场景掉落buff
---@field room_info ChatRoomBrief @聊天室信息
---@field watch_room_uid number @观战房间uid
---@field is_hit_outlook_when_bewatched boolean @被观战时是否隐藏外观
---@field title_id number @使用中的称号id
---@field tag number @标签信息
---@field belluz_effectid number @贝鲁兹特效id

---@class OutLook
---@field change_mask number @变化标记，使用枚举变量OutlookMask的按位或
---@field wear_fashion Item @穿戴时装
---@field wear_ornament Item__Array @穿戴的饰品
---@field hair_id number @头发ID
---@field eye EyeInfo @眼睛
---@field wear_head_portrait Item @头像
---@field portrait_frame number @头像框

---@class SkillInfo
---@field skill_id number @
---@field skill_level number @

---@class Item
---@field uid uint64 @
---@field ItemID number @
---@field ItemCount number @
---@field is_bind boolean @
---@field extra_desc uint64 @
---@field fashion FashionInfo @时装信息
---@field ornament OrnamentInfo @饰品
---@field equip_component EquipComponent @
---@field avg_price int64 @
---@field device_component DeviceComponent @置换器数据
---@field head_portrait HeadPortrait @头像信息
---@field create_time uint64 @
---@field reborn_info RebornInfo @封魔石提炼信息
---@field extra_data ExtraData @额外参数
---@field item_pos number @道具位置,16位，高8位容器，低8位位置

---@class StepSyncInfo
---@field entity_id uint64 @实体id
---@field position Vec3Easy @
---@field shrink number @原本的一些bool现在收进来,用位来做,还有角色状态,阵营
---@field attr_list AttrInfo__Array @属性
---@field dead_info DeadStepSyncInfo @
---@field default_info DefaultStepSyncInfo @
---@field skill_info SkillStepSyncInfo @
---@field singing_info SingingStepSyncInfo @
---@field state_changed boolean @
---@field faceandselfangle number @面朝方向,加上自拍角度合到一起
---@field special_info SpecialStepSyncInfo @
---@field collect_info CollectStepSyncInfo @采集组件
---@field climb_info ClimbStepSyncInfo @攀爬
---@field y_layer number @纵向层级
---@field battle_vehicle_id number @战斗坐骑Id
---@field skill_core_info SyncSkillInfo__Array @技能数据(SkillCore)
---@field born_info BornSyncInfo @
---@field fish_info FishStepSyncInfo @钓鱼组件数据
---@field double_action_clip_info DoubleActionClipStepSyncInfo @双人交互片段型
---@field move_time number @
---@field behit_info BeHitInfo @
---@field dance_info DanceStepSyncInfo @

---@class AttrInfo
---@field attr_type number @
---@field attr_value number @

---@class BulletAppearSyncInfo
---@field firer uint64 @
---@field target uint64 @
---@field skill_id uint64 @
---@field trigger_time number @
---@field bullet_id uint64 @
---@field position Vec3 @
---@field direction Vec3 @
---@field escaped_time number @
---@field skill_num number @
---@field face_degree_ number @自转时用的角度
---@field revolution_face_dgree_ number @公转朝向角度
---@field revolution_center Vec3 @公转圆心，因为要考虑视野进出，所以必须要同步

---@class BuffRemoveSyncInfo
---@field entity_id uint64 @
---@field buff_uuid_list uint64__Array @

---@class SkillResultSyncInfo
---@field firer uint64 @
---@field target uint64 @
---@field damage_result DamageResult @
---@field count number @
---@field delay number @
---@field damage_uuid uint64 @
---@field trigger_times number @
---@field skill_num number @

---@class DamageResult
---@field type number @
---@field result number @
---@field count number @

---@class MemberBriefInfo
---@field uid uint64 @
---@field name string @
---@field gender SexType @

---@class TeamBriefInfo
---@field team_id uint64 @
---@field members MemberBriefInfo__Array @
---@field captain_uid uint64 @
---@field setting LibTeamSetting @
---@field mercenarys TeamMercenaryBriefInfo__Array @

---@class PositionSyncInfo
---@field x number @
---@field z number @
---@field uuid uint64 @
---@field y number @
---@field reason PositionSyncReason @
---@field face number @面向，单位度
---@field need_change_camera_face boolean @是否需要改变相机朝向
---@field camera_face number @相机朝向

---@class GameRoleSerializeInfo
---@field attr_list AttrInfo__Array @
---@field buff_list RORoleBuffList @
---@field vehicle VehicleSerializeInfo @
---@field carry_item_ CarryItem @身上携带的物品
---@field body_change BodyChangeInfo @体型修改
---@field skill_list SkillDataInfo__Array @
---@field skill_list_transfigured SkillDataInfo__Array @
---@field role_y GameRoleY @y轴同步
---@field battle_vehicle_id number @战斗坐骑ID, 0为没有骑
---@field move_info MoveDataInfo @
---@field blessing_info BlessingInfo @祝福组件数据
---@field replace_info ReplacerInfo__Array @置换器数据
---@field qte_list QteSkillSyncInfo__Array @qte技能数据
---@field dance_info DanceGroupInfo @跳舞循环的组合
---@field arrow_item_id number @箭矢ID, 0为无穷箭矢

---@class RORoleBuff
---@field uuid_ uint64 @
---@field buff_table_id_ number @
---@field is_valid_ boolean @
---@field current_trigger_count_ number @
---@field hp_ number @
---@field time_duration_ number @
---@field append_count_ number @
---@field firer_uuid_ uint64 @
---@field save_time_ uint64 @
---@field need_clear boolean @离开场景的时候是否需要清除
---@field is_pvp boolean @
---@field equip_id number @
---@field item_uid uint64 @
---@field extra_param_ MapInt32Int32__Array @
---@field timer_revive_left_time uint64 @死亡时buff剩余时间
---@field total_time number @
---@field item_type number @buff所属物品类型
---@field buff_effect_infos RORoleBuffEffect__Array @effect数据
---@field related_entity_uuids uint64__Array @相关entity的uuids

---@class RORoleBuffList
---@field buff_list_ RORoleBuff__Array @身上现有buff
---@field trigger_cd_group_list MapUint32ToUint64__Array @触发公共cd组时间戳

---@class MapKeyListValue
---@field Key number @
---@field buff_uuid_ PBuint64__Array @

---@class MapKeyListValue32
---@field key number @
---@field value_list number__Array @

---@class BulletDestroySyncInfo
---@field firer uint64 @
---@field skill_id uint64 @
---@field bullet_id uint64 @
---@field skill_num number @

---@class SkillEndSyncInfo
---@field firer uint64 @
---@field skill_uuid uint64 @
---@field reason number @

---@class DropItemInfo
---@field item_id number @
---@field count number @
---@field hoster_uuid uint64 @
---@field is_team boolean @
---@field exist_time number @

---@class DeadStepSyncInfo
---@field firer uint64 @
---@field remind_time number @
---@field hater uint64 @
---@field need_play_dead_anim boolean @是否需要播放死亡动画

---@class DefaultStepSyncInfo
---@field force boolean @

---@class SkillStepSyncInfo
---@field skill_uuid uint64 @

---@class SingingStepSyncInfo
---@field target uint64 @
---@field skilleffect_id number @
---@field cast_point Vec3 @
---@field interval number @
---@field using_times number @
---@field start_time uint64 @

---@class EquipComponent
---@field stars number @星级
---@field basic_attr BasicAttr @
---@field entry_attr EntryAttr @
---@field hole_info HoleInfo @
---@field enchant_info EnchantInfo @
---@field refine_info RefineInfo @
---@field raity number @稀有度
---@field is_disrepair boolean @是否损坏
---@field stunt_attr StuntAttr @特技词条
---@field reform_times number @已经改造次数
---@field lib_attr LibAttr @
---@field device_info DeviceInfo @置换器数据
---@field hidden_info HiddenInfo @隐藏属性

---@class Entry
---@field type number @
---@field id number @
---@field val number @
---@field extra_param MapInt32Int32__Array @

---@class BasicAttr
---@field attr_block AttrBlock__Array @

---@class EntryAttr
---@field attr_block AttrBlock__Array @

---@class HoleInfo
---@field open_hole HoleAndCardBlock__Array @
---@field reforge_count number @总重铸次数

---@class RefineInfo
---@field level number @
---@field seal_level number @封印等级
---@field cur_unlock_exp number @当前解封印经验
---@field level_highest number @精炼最高等级
---@field continue_success_times number @持续成功次数
---@field level_cost MapInt32ListMap32__Array @第一次精炼到X级的历史消耗
---@field total_cost ItemCostInfo__Array @历史总消耗
---@field transfer_item_id number @精炼等级转出装备id
---@field transfer_item_refine_level number @继承装备的精炼等级
---@field attached_success_pro number @精炼附加成功概率

---@class EnchantInfo
---@field cost_list ItemCostInfo__Array @
---@field has_reborn boolean @是否被提炼了
---@field entrys EnchantEntryBlock__Array @
---@field cache_entrys EnchantEntryBlock__Array @
---@field cache_entrys_high EnchantEntryBlock__Array @
---@field junior_record EnchantRecord @初级附魔
---@field senior_record EnchantRecord @高级附魔
---@field last_enchant_time int64 @上次附魔时间
---@field save_time int64 @附魔到保存间隔时间
---@field enchant_level number @上次附魔档次id

---@class FashionInfo
---@field end_time number @有效截止时间

---@class OrnamentInfo
---@field end_time number @时效

---@class ROBuffInfo
---@field entity_id uint64 @
---@field buff_id number @buff表ID
---@field buff_uuid uint64 @buff唯一ID
---@field replace_buff_uuid uint64 @
---@field append_count number @
---@field left_time number @
---@field total_time number @
---@field firer_uuid uint64 @
---@field related_entity_uuids uint64__Array @
---@field extra_params ROBuffExtraParam__Array @

---@class ROBuffInfos
---@field buff ROBuffInfo__Array @

---@class BeatBackStepSyncInfo
---@field direction Vec3 @
---@field curve string @
---@field is_dead boolean @
---@field target uint64 @
---@field distance number @
---@field start_position Vec3 @

---@class BuffAddSkillSyncInfo
---@field firer uint64 @
---@field target uint64 @
---@field skilleffect_id number @
---@field skill_id number @
---@field skill_level number @
---@field cast_point Vec3 @
---@field time_scale number @
---@field skill_uuid uint64 @
---@field use_anim boolean @

---@class EyeInfo
---@field eye_id number @眼睛ID
---@field eye_style_id number @眼睛颜色

---@class TakeVehicleInfo
---@field driver_uuid uint64 @主驾ID
---@field passenger_uuid uint64 @乘客ID
---@field is_get_on boolean @
---@field vehicle_id number @
---@field ornament_id number @配饰id
---@field dye_id number @染色id
---@field position Vec3 @落地位置
---@field is_getoff_pos_valid boolean @是否合法点

---@class PBDriverComponent
---@field vehicle_id number @
---@field passengers PBuint64__Array @
---@field ornament_id number @配饰ID
---@field dye_id number @染色id

---@class PBPassengerComponent
---@field vehicle_id number @
---@field driver_uuid uint64 @

---@class VehicleSerializeInfo
---@field driver PBDriverComponent @
---@field passenger PBPassengerComponent @
---@field common_vehicle PBCommonVehicleComponent @

---@class BuffDataSyncInfo
---@field visible_entity_list uint64__Array @

---@class BulletBoomSyncInfo
---@field firer uint64 @
---@field target uint64 @
---@field skill_id uint64 @
---@field bullet_id uint64 @
---@field position Vec3 @
---@field skill_num number @

---@class WallData
---@field uuid uint64 @
---@field wall_id number @墙id
---@field wall_scale Vec3 @长宽高
---@field enable boolean @是否有效
---@field air_wall_fx_id number @空气墙特效id
---@field type number @墙的类型
---@field collide_type WallCollideType @碰撞类型
---@field cook_data_ CookData @双人烹饪数据
---@field prize_data PrizeWallData @惊喜盒
---@field colony_data ColonyWallData @通过人数占领的墙的数据(战场)
---@field trigger_type number @当前触发类型
---@field trans_state_name string @过渡动画名字
---@field reach_state_name string @到达动画名字
---@field is_singlewall boolean @是否是单向墙
---@field is_crossatk boolean @是否可以跨墙攻击(仅空气墙)
---@field light_data LightBoxData @扭曲光线触发器

---@class EnterWallSyncInfo
---@field wall_uuid uint64 @墙uid
---@field uuid uint64 @
---@field wall_speed Vec3 @传送带速度

---@class SpecialStepSyncInfo
---@field special_type number @
---@field index number @
---@field wall_uid uint64 @
---@field carray_item_id number @持有道具id
---@field can_active_interrupt boolean @是否可以被主动打断
---@field move_time number @位移时间
---@field y_axis_speed number @y轴速度
---@field free_style_anim_index number @随机休闲动作

---@class CookData
---@field carry_item_ CarryItem @砧板/平台上的物品
---@field pot_data_ CookPotData @锅的额外数据
---@field left_time_ number @剩余时间
---@field entity_uuid_ uint64 @正在处理的玩家

---@class CookPotData
---@field pot_state_ CookingPotState @锅的状态
---@field foods PBuint32__Array @锅中的食物列表

---@class EquipData
---@field equips PBuint32__Array @

---@class PBCommonVehicleComponent
---@field vehicle_uuid uint64 @

---@class VehicleEntityData
---@field fly_time number @飞行时间
---@field vehicle_item_id number @公共载具在配置表中的id
---@field passenger_list PBuint64__Array @乘客列表

---@class SyncTeamBriefInfoData
---@field type number @
---@field info TeamBriefInfo__Array @
---@field index number @

---@class PrizeWallData
---@field left_time number @剩余时间
---@field sub_type number @子类型
---@field last_op_uuid uint64 @上一次操作人
---@field last_op_name string @上一次操作者姓名

---@class BodyChangeInfo
---@field component_id number @组件id
---@field left_time number @剩余时间

---@class SkillDataInfo
---@field skill_id number @
---@field cooldown number @
---@field attr_power number @元素能量

---@class QteSkillSyncInfo
---@field skill_id number @
---@field skill_lv number @
---@field outdate_time number @
---@field cooldown_time number @

---@class OutwardInfo
---@field entity_uid uint64 @
---@field orn_head number @
---@field orn_face number @
---@field orn_mouth number @
---@field orn_back number @
---@field orn_tail number @

---@class GameRoleY
---@field style YStyle @影响类型
---@field start Vec3 @起始点

---@class CollectionData
---@field uuid uint64 @
---@field collection_id number @采集物id
---@field state number @当前状态
---@field state_start_time int64 @状态开始时间戳
---@field state_end_time uint64 @状态结束时间戳
---@field owner_role_id uint64 @拥有者玩家id
---@field owner_collect_times number @拥有者采集了多少次
---@field other_collect_times number @其他玩家采集了多少次

---@class CollectStepSyncInfo
---@field collection_uid uint64 @采集物uid
---@field collection_id number @采集物id
---@field interval number @采集时间
---@field carray_item_id number @手上持有物件(生活技能)

---@class ClimbStepSyncInfo
---@field wall_id uint64 @墙id

---@class ModifyWeatherData
---@field scene_weather_list SceneWeatherData__Array @

---@class SceneWeatherData
---@field scene_id number @
---@field time_part number @0、早晨 2、白昼 3、晚上 4、深夜
---@field weather_type number @

---@class ColonyWallData
---@field fight_group number @当前阵营
---@field wait_change_fight_group number @正在读条准备切换的阵营
---@field end_change_time int64 @结束抢夺的时间戳
---@field total_occupy_time int64 @占领需要总用时
---@field wait_change_time int64 @暂停占领的时间戳
---@field could_occupy boolean @判断当前能否被占领，用于给客户端做显示逻辑

---@class SyncSkillInfo
---@field skill_id number @
---@field attr_power number @技能元素能量

---@class ItemCostInfo
---@field item_id number @
---@field item_count number @

---@class DungeonsReconnectInfo
---@field revive_num number @复活次数
---@field last_dead_time uint64 @最后死亡时间
---@field begin_time uint64 @开始时间
---@field guide Vec3 @主题副本箭头坐标
---@field kick_left_time number @踢出剩余时间
---@field platform_reconnect PlatformDuneonsReconnect @擂台副本重连
---@field light_map LightMapData @场景light
---@field affixids PBint32__Array @场景词缀
---@field lose_extra_time number @倒计时额外时间
---@field is_resulted boolean @是否结算了
---@field arena_reconnect ArenaDungeonsReconnect @角斗场副本重连
---@field room_start_time uint64 @迷宫房间开始的时间
---@field guild_match_reconnect GuildMatchDungeonsReconnect @公会匹配副本重连

---@class BornSyncInfo
---@field born_time int64 @出生时间

---@class StuntAttr
---@field attr_block AttrBlock__Array @

---@class MoveDataInfo
---@field last_move_time_ int64 @

---@class BlessingInfo
---@field blessing_time number @祝福剩余时间
---@field killed_exp_monster_count number @已击杀的经验怪
---@field killed_jewelry_monster_count number @已击杀的宝箱怪
---@field blessing_monster_list BlessingMonsterList__Array @击杀的特殊怪
---@field current_killed_monster_count number @当前已击杀怪的数量
---@field total_killed_monster_count number @一共击杀怪的数量
---@field last_fighting_time uint64 @最后一次对怪物造成伤害的时间
---@field current_monster_count_cd int64 @当前停止怪物计数的CD时间
---@field last_killed_monster_id number @最后刷出的特殊怪的uuid
---@field last_killed_monster_level number @最后刷出的特殊怪的等级
---@field is_in_monster_count_cd boolean @是否在杀怪不计数的CD时间内
---@field is_recording_time boolean @是否正在在计时
---@field rush_monster_left_time number @定时刷怪剩余时间
---@field extra_fight_time number @每日健康战斗时间
---@field last_refresh_time int64 @上一次刷新野外挂机的时间
---@field used_blessing_time number @今日使用祝福时间

---@class BlessingMonsterList
---@field entity_table_id number @EntityTable的Id
---@field monster_count number @怪物数量

---@class FishStepSyncInfo
---@field carray_item_id number @鱼竿id
---@field seat_item_id number @遮阳伞
---@field auto_one_end_time int64 @自动钓鱼起竿时间戳

---@class MapKey64Value32
---@field key uint64 @
---@field value number @

---@class RoleGuildInfo
---@field guild_id int64 @
---@field guild_name string @
---@field permission number @
---@field permission_name string @
---@field icon_id number @
---@field role_id uint64 @
---@field last_guild_id int64 @
---@field freeze_contribute number @
---@field guild_level number @
---@field buildings GuildBuildInfo__Array @

---@class StepSyncList
---@field state_flows string__Array @状态流(StepSyncInfo)
---@field skill_result_flows string__Array @技能结算流(SkillResultSyncInfo)
---@field skill_end_flows string__Array @技能结束流(SkillEndSyncInfo)
---@field bullet_appear_flows string__Array @子弹流(BulletAppearSyncInfo)
---@field bullet_boom_flows string__Array @子弹boom流(BulletBoomSyncInfo)
---@field bullet_destroy_flows string__Array @子弹销毁流(BulletDestroySyncInfo)
---@field buff_add_flows string__Array @buff添加流(ROBuffInfo)
---@field buff_update_flows string__Array @buff更新流(ROBuffInfo)
---@field buff_remove_flows string__Array @buff删除流(BuffRemoveSyncInfo)
---@field position_sync_flows string__Array @位置同步流(PositionSyncInfo)
---@field qte_skill_list_flows string__Array @qte技能列表(QteSkillSyncInfo)
---@field beat_back_flows string__Array @击退流(BeatBackStepSyncInfo)
---@field jump_word_flows string__Array @跳字流(JumpWordInfo)
---@field skill_start_flows string__Array @技能开始流
---@field enter_hatred_flows string__Array @
---@field skill_core_flows string__Array @技能CD流
---@field auto_fish_flows string__Array @自动钓鱼流(AutoFishSyncInfo)
---@field collection_state_flow string__Array @采集物状态流(CollectionSyncInfo)
---@field scene_trigger_object_flow string__Array @SceneTriggerObject状态流(SceneTriggerObjectInfo)
---@field play_fx_flows string__Array @特效流
---@field take_photo_status_flows string__Array @怪物表情流TakePhotoStatus
---@field buff_effect_trigger_flows string__Array @buff effect 触发时同步给客户端
---@field skill_target_flows string__Array @技能目标流(SkillResultTargetInfo)

---@class JumpWordInfo
---@field type number @
---@field count number @
---@field entity uint64 @
---@field attack_type_source number @元素属性来源

---@class SkillStartInfo
---@field target uint64 @
---@field firer uint64 @
---@field skill_uuid uint64 @
---@field cast_point Vec3 @
---@field time_scale number @
---@field using_times number @
---@field no_result_index number__Array @
---@field skill_effect_id number @
---@field anim boolean @
---@field time_elapsed number @
---@field attr_type number @

---@class AttrBlock
---@field attr_list Entry__Array @
---@field block_id number @

---@class LibAttr
---@field attr_block AttrBlock__Array @

---@class MapInt32Int32
---@field key number @
---@field value number @

---@class DoubleActionClipStepSyncInfo
---@field index_ number @table上的某一行
---@field driving_uuid_ uint64 @双人动作主动方
---@field passive_uuid_ uint64 @双人动作被动方

---@class RORoleTransfigureInfo
---@field to_be_transfigure_id number @目标EntityTableId
---@field entity_table_id number @已经变身的EntityTableId
---@field transfigure_timestamp uint64 @变身开始时间戳
---@field in_battle_vehicle_before boolean @变身前是否骑着战斗坐骑
---@field attributes AttrInfo__Array @变身后属性
---@field buff_list RORoleBuffList @变身后buff数据

---@class CreateBattleParam
---@field owner_id uint64 @
---@field scene_type number @
---@field rpc_id number @
---@field dungeon_id number @
---@field room_type number @
---@field pvp PVPParam @pvp相关参数
---@field guild_id int64 @
---@field role_ids PBuint64__Array @
---@field fight_groups ScenePartFightGroup__Array @
---@field degree EnmDungeonsDegree @副本难度
---@field role_brief RoleBattleBriefInfo__Array @
---@field assist_info boolean__Array @助战信息
---@field switch_data SceneSwitchData @
---@field arena CreateArenaParam @角斗场信息
---@field guild_hunt_info GuildHuntCountInfo @公会狩猎信息
---@field team_uid uint64 @

---@class PVPSceneCamp
---@field camp_id uint64 @
---@field total_elo number @
---@field role_ids PBuint64__Array @
---@field platform_uid number @擂台uid
---@field role_infos RoleBattleBriefInfo__Array @
---@field flower_num number @
---@field guild_brief GuildBriefInfo @公会匹配赛公会信息

---@class PVPParam
---@field camp1 PVPSceneCamp @阵营1
---@field camp2 PVPSceneCamp @阵营2
---@field round_id number @pvp轮数
---@field floor number @擂台层数
---@field fight_history FightHistory @历史对战信息

---@class ScenePartFightGroup
---@field role_id uint64 @
---@field fight_group number @
---@field role_type RoleType @角色职业
---@field role_name string @角色名字

---@class PlatformDuneonsReconnect
---@field remain_points number @自身剩余点数
---@field camp1_remain_points number @阵营1剩余点数
---@field camp2_remain_points number @阵营2剩余点数
---@field left_life_counter MapUint64ToInt32__Array @
---@field floor number @擂台层数

---@class PlatformStatistics
---@field role_life_counter MapUint64ToInt32__Array @
---@field camp1_remain_points number @
---@field camp2_remain_points number @
---@field floor number @

---@class EnterHatred
---@field entity_uuid uint64 @

---@class GameRoleSkillInfo
---@field skill_id number @
---@field cd number @

---@class GameRoleSkillGroupInfo
---@field group_id number @
---@field group_cd number @

---@class GameRoleReconnectInfo
---@field buff_list ROBuffInfos @
---@field carry_item CarryItem @玩家携带物品
---@field battle_vehicle_id number @战斗坐骑
---@field skill_list GameRoleSkillInfo__Array @
---@field qte_skill_list QteSkillSyncInfo__Array @
---@field skill_group_list GameRoleSkillGroupInfo__Array @
---@field fight_group number @阵营
---@field face number @朝向
---@field pos Vec3 @位置
---@field transfigure_id number @变身后entity_id
---@field dungeon_data DungeonReconnectData @副本重连数据
---@field fish_info GameRoleReconnectFishInfo @钓鱼断线重连
---@field equip_buff_skill BuffSkill @装备学的技能
---@field dance_info DanceActionInfo @

---@class DeviceComponent
---@field entrys Entry__Array @词条BUFF
---@field dura number @耐久

---@class DeviceInfo
---@field attr_block AttrBlock__Array @词条块
---@field dura number @耐久

---@class ReplacerInfo
---@field equip_uuid uint64 @装备uuid
---@field replacer_id number @置换器id
---@field fighting_time number @战斗时间

---@class GuildBuildInfo
---@field id number @
---@field level number @

---@class HiddenInfo
---@field attr_block AttrBlock__Array @

---@class SkillCoreInfo
---@field skill_effect_id number @
---@field cool_down number @
---@field group_cool_down number @
---@field using_times number @

---@class RORoleBuffEffect
---@field effect_type number @BuffEffectType
---@field attribute_change MapInt32Int32__Array @属性修改
---@field unit_attr_infos MapInt32Int32__Array @元素属性修改
---@field transfigure_info RORoleTransfigureInfo @变身序列化数据
---@field equip_buff_skill BuffSkill @从装备处获得的技能

---@class RoleBattleBriefInfo
---@field role_id uint64 @
---@field name string @
---@field profession RoleType @
---@field sex SexType @
---@field level number @
---@field pvp_counters PVPCounter__Array @pvp战斗计数
---@field camp_id number @阵营ID

---@class LightMapData
---@field period_type number @时间段
---@field weather_type number @天气类型

---@class DungeonReconnectData
---@field light_map_data LightMapData @场景天气数据

---@class DistortedLightData
---@field rotate_count number @旋转次数
---@field connect_to_box_id number @连向的box id
---@field is_active boolean @

---@class LightBoxData
---@field box_data DistortedLightData__Array @

---@class AutoFishSyncInfo
---@field end_time int64 @起竿时间
---@field entity_uuid uint64 @

---@class AutoFishResultInfo
---@field itemid number @道具tableid
---@field count number @获取数量

---@class AutoFishResultData
---@field info AutoFishResultInfo__Array @每个info

---@class GameRoleReconnectFishInfo
---@field auto_one_end_time int64 @自动钓鱼一次结束时间戳
---@field water_center_x number @
---@field water_center_y number @
---@field water_center_z number @
---@field water_radius number @

---@class AutoFishPushArg
---@field is_auto boolean @

---@class AutoFishPushRes
---@field left_time number @剩余次数
---@field is_continue number @自动续时

---@class CancelBuffArg
---@field buff_uuid uint64 @

---@class CancelBuffRes
---@field result ErrorCode @

---@class CollectionSyncInfo
---@field state number @切换状态
---@field start_time int64 @开始时间戳
---@field uuid uint64 @entity_uuid

---@class SceneTriggerObjectInfo
---@field id number @
---@field int_param MapInt32Int32__Array @
---@field string_param MapInt32String__Array @

---@class DropBuffInfo
---@field buff_id number @
---@field bufftype DropBuffType @
---@field startime int64 @
---@field hoster uint64 @
---@field exist_time number @
---@field table_id number @

---@class PickUpBuff
---@field buff_uid uint64 @
---@field take_uuid uint64 @
---@field buff_id number @

---@class PickUpBuffArg
---@field uuid uint64 @

---@class PickUpBuffRes
---@field code ErrorCode @
---@field doodadid number @

---@class ChatRoomBrief
---@field room_uid uint64 @
---@field name string @
---@field have_code boolean @
---@field is_captain boolean @

---@class PVPBroadcastNotice
---@field announce_id number @公告id
---@field message string__Array @广播消息

---@class BuffSkill
---@field skill_id PBint32__Array @
---@field skill_lv PBint32__Array @

---@class BuffSyncToMsData
---@field add_info ROBuffInfo__Array @
---@field remove_info RemoveBuffSyncInfo @

---@class RemoveBuffSyncInfo
---@field entity_id uint64 @
---@field buff_uuid_list PBuint64__Array @

---@class PBdouble
---@field value number @

---@class BeHitInfo
---@field anim number @

---@class ROBuffExtraParam
---@field type number @
---@field value number @

---@class OnTeleportInfo
---@field enable boolean @

---@class BigWorldActivity
---@field type number @活动类型
---@field tigger_times number @触发次数
---@field award_times number @奖励次数

---@class BigWorldRecord
---@field activitys BigWorldActivity__Array @

---@class HeadPortrait
---@field end_time uint64 @有效期截止时间戳

---@class DungeonsUpdateNotifyInfo
---@field dungeons_id number @
---@field is_lose_extra_time_change boolean @
---@field lose_extra_time number @

---@class TriggerResetInfo
---@field sceneid number @场景id
---@field groupids PBint32__Array @
---@field objectids PBint32__Array @

---@class UseReviveItemRes
---@field result ErrorCode @

---@class UseReviveItemArgs
---@field item_id number @
---@field target uint64 @

---@class HoleAndCardBlock
---@field entrys Entry__Array @
---@field cache_entrys Entry__Array @
---@field card_id number @
---@field is_bind boolean @
---@field rand_entry_times number @随机次数
---@field table_id number @
---@field cache_table_id number @

---@class MazeSyncData
---@field index number @房间id(一维数组)
---@field type MazeRoomType @房间类型
---@field directions MazeSyncDirectionData @入口
---@field status MazeRoomNtfStatus @通关状态
---@field path_status MazePathStatus @路径状态

---@class MazeSyncDirectionData
---@field up number @上入口去什么房间
---@field left number @左入口去什么房间
---@field right number @右入口去什么房间
---@field down number @下入口去什么房间

---@class MazeSyncRoomsData
---@field datas MazeSyncData__Array @房间信息
---@field is_gm boolean @

---@class EnchantEntryBlock
---@field entrys Entry__Array @
---@field table_id number @
---@field rand_entry_times number @
---@field enchant_level number @档次id

---@class PBfloat
---@field value number @

---@class PBString
---@field value string @

---@class SceneTriggerObjectSyncInfo
---@field uuid uint64 @
---@field info SceneTriggerObjectInfo @

---@class SceneSwitchData
---@field sceneOwner uint64 @
---@field watchers PBuint64__Array @
---@field deliver SceneDeliverInfo__Array @传送信息
---@field dungeons_id number @副本id
---@field type SwitchSceneType @
---@field owner_level number @
---@field camera_fade_type EnterSceneCameraFadeType @相机渐变类型
---@field origin_scene_uid number @原场景uid
---@field show_tip ShowTipToRoleData @切场景提示
---@field back_scene_uid number @

---@class SceneDeliverInfo
---@field type DeliverType @
---@field scene_id number @
---@field positon Vec3 @
---@field face number @
---@field camera number @镜头朝向
---@field delta_height number @离地高度
---@field not_rotate_camera boolean @不转镜头

---@class PlayFxInfo
---@field fx_id number @
---@field position Vec3 @
---@field face number @
---@field time number @

---@class MazeEndSyncData
---@field boss_room_index number @提前可见boss房

---@class OnSceneTriggerArg
---@field group_id number @
---@field trigger_id number @
---@field timing_type number @触发时机
---@field scene_trigger_object_id number @

---@class OnSceneTriggerRes
---@field result ErrorCode @

---@class EnterSceneTriggerObjectArg
---@field trigger_object_uuid uint64 @

---@class YaHahaData
---@field boli BoliInfo__Array @
---@field region_award_info BoliAwardIdCountInfo__Array @区域对应的领奖信息
---@field type_award_info BoliAwardIdCountInfo__Array @类型对应的领奖信息

---@class BoliInfo
---@field id number @
---@field scene_id number @
---@field elf_uuid uint64 @
---@field discover_time uint64 @发现时间
---@field is_award boolean @是否领过奖
---@field region_id number @区域id

---@class DanceStepSyncInfo
---@field dance_id number @
---@field time_elapsed number @
---@field time_scale number @
---@field is_wild_dance boolean @

---@class DanceArgs
---@field dance_id number @

---@class DanceGroupInfo
---@field action_list PBint32__Array @
---@field is_loop boolean @

---@class DanceActionInfo
---@field length number @跳舞动作序列总长度
---@field index number @跟随舞娘跳对的进度
---@field loop_action_list PBint32__Array @自定义跳舞序列
---@field is_loop boolean @自定义舞蹈序列是否循环播放
---@field bgm_index number @DanceBGMTable的Id
---@field bgm_duration number @BGM播放了的时间
---@field nth_bgm number @第几首BGM（预热为第一首）
---@field is_stop boolean @跳舞动作打断
---@field dance_action_group_index number @DanceActionGroupTable的Id

---@class SetLoopDanceRes
---@field loop_info DanceGroupInfo @
---@field result ErrorCode @

---@class SingleScriptInfoSkill
---@field type SingleScriptEnum @
---@field request_uuid uint64 @
---@field response_uuid uint64 @
---@field skill_id number @
---@field cast_point Vec3 @
---@field skill_level number @
---@field force_to_play boolean @强制释放

---@class SingleScriptData
---@field types SingleScriptEnum__Array @
---@field skill SingleScriptInfoSkill @
---@field buff SingleScriptInfoBuff @
---@field monster SingleScriptInfoCreateMonster @

---@class SingleScriptInfoBuff
---@field type SingleScriptEnum @
---@field request_uuid uint64 @
---@field response_uuid uint64 @
---@field buff_id number @

---@class SingleScriptInfoCreateMonster
---@field type SingleScriptEnum @
---@field request_uuid uint64 @
---@field response_uuid uint64 @
---@field monster_id number @
---@field cast_point Vec3 @
---@field view_layer number @
---@field born_radius number @

---@class SingleScriptDataResponse
---@field result ErrorCode @

---@class CreateArenaParam
---@field game_mode ArenaType @
---@field room_mode ArenaMode @
---@field play_mode ArenaRoomPlayMode @
---@field scene_type number @战斗场景/等候场景

---@class ArenaDungeonsReconnect
---@field camp1_kill_nums number @
---@field camp2_kill_nums number @
---@field camp1_id number @
---@field camp2_id number @
---@field camp1_roles uint64__Array @
---@field camp2_roles uint64__Array @

---@class MapInt32String
---@field key number @
---@field value string @

---@class DoubleActionWithNpcArg
---@field npc_uuid uint64 @
---@field action_id number @

---@class LibTeamSetting
---@field target number @
---@field min_level number @
---@field max_levle number @
---@field name string @

---@class SceneTriggerGroupInfo
---@field trigger_group_id number @触发器组id
---@field scene_trigger_obj_id number @引起这次触发的SceneTriggerObjId

---@class MemberBaseInfo
---@field role_uid uint64 @
---@field type RoleType @
---@field name string @
---@field sex SexType @
---@field base_level number @
---@field job_level number @
---@field outlook MemberOutLook @
---@field equip_ids PBuint32__Array @
---@field status MemberStatus @
---@field map_id number @
---@field guild_id int64 @
---@field guild_name string @
---@field guild_level number @
---@field guild_permission number @公会职位
---@field account string @
---@field extra_info MemberBaseInfoExt @其他信息
---@field line_id number @
---@field tag number @标签信息
---@field scene_uid number @
---@field chat_tag number @聊天标签
---@field chat_frame number @气泡框

---@class MemberBaseInfoExt
---@field createtime uint64 @
---@field setup_info SetupInfoData @设置信息
---@field achievement_point number @成就点
---@field currentdiamond int64 @
---@field currentrob int64 @
---@field currentzeny int64 @
---@field client_info ClientInfo @
---@field last_login_time uint64 @
---@field last_logout_time uint64 @
---@field role_index number @
---@field online_time number @在线时间
---@field sticker StickerBaseInfo @

---@class SetupInfoData
---@field is_chat_level_limit boolean @是否聊天有等级限制
---@field damage_number_show number @伤害数字显示
---@field target_choose number @目标选择

---@class ClientInfo
---@field PlatID number @
---@field ClientVersion string @
---@field SystemSoftware string @
---@field SystemHardware string @
---@field TelecomOper string @
---@field Network string @
---@field ScreenWidth number @
---@field ScreenHight number @
---@field CpuHardware string @
---@field ip string @
---@field pf string @
---@field token string @已废弃，使用new_token。如果要删除，要把所有用到string的token全修改，并且清档！
---@field logintype LoginType @
---@field RegChannel number @注册渠道
---@field LoginChannel number @登录渠道
---@field Density number @像素密度
---@field Memory number @内存信息单位M
---@field GLRender string @opengl render信息
---@field GLVersion string @opengl版本信息
---@field DeviceId string @设备ID
---@field picurl string @玩家自定义头像的url
---@field new_token string @

---@class StickerBaseInfo
---@field grid PBint32__Array @
---@field grid_unlock_status PBint32__Array @

---@class MemberOutLook
---@field wear_fashion number @穿戴时装
---@field wear_ornament PBuint32__Array @穿戴的饰品
---@field hair_id number @头发ID
---@field eye EyeInfo @眼睛
---@field wear_head_portrait_id number @头像id
---@field fashion_count number @
---@field portrait_frame number @头像框

---@class ChangeSceneRole
---@field role_id uint64 @切场景的id
---@field watch_player_uid uint64 @0表示不是观战, > 0是观战

---@class DungeonsWatchInitData
---@field begin_time uint64 @副本开始时间
---@field pvp_life_count MapUint64ToInt32__Array @

---@class DungeonsTargetData
---@field id number @
---@field cur_step number @
---@field total_count number @

---@class DungeonsTargetSection
---@field dungeons_id number @
---@field targets DungeonsTargetData__Array @

---@class SendToEntityAIData
---@field event_name string @事件名
---@field entity_uuids PBuint64__Array @接受事件的entity

---@class TakePhotoStatusInfo
---@field role_id uint64 @
---@field take_photo_status number @
---@field take_photo_type number @

---@class StateStepSyncList
---@field statesync string__Array @单独同步状态流(StepSyncInfo)

---@class TestSingleMove
---@field postion Vec3 @
---@field face number @
---@field issetest boolean @
---@field b string @
---@field i number @
---@field si number @

---@class Vec3Easy
---@field a number @
---@field b number @

---@class RoleMercenaryRecord
---@field mercenarys MercenaryInfo__Array @
---@field fight_num number @可出战栏位
---@field fight_status_setted number @佣兵出战状态

---@class MercenaryInfo
---@field id number @
---@field base_info MercenaryBaseInfo @
---@field equip_info MercenaryEquipInfo @
---@field skill_info MercenarySkillInfo @
---@field talent_info MercenaryTalentInfo @
---@field out_time int64 @
---@field revive_timestamp int64 @复活时间戳
---@field last_dead_timestamp int64 @
---@field dead_times number @
---@field status number @
---@field hp number @
---@field sp number @
---@field buff_list MapInt32Int32__Array @

---@class MercenaryEquipInfo
---@field equips MercenaryEquipSingle__Array @

---@class MercenarySkillInfo
---@field skills MercenarySkillSingle__Array @已选择的技能

---@class MercenaryTalentInfo
---@field talents MercenaryTalentSingle__Array @已解锁的天赋

---@class MercenaryBaseInfo
---@field level number @
---@field exp number @

---@class MercenaryEquipSingle
---@field id number @
---@field level number @

---@class MercenarySkillSingle
---@field id number @

---@class MercenaryTalentSingle
---@field id number @
---@field level number @
---@field last_strengthen_timestamp int64 @上次开始时间戳

---@class MercenaryAttrInfo
---@field id number @
---@field attrs AttrInfo__Array @

---@class MercenaryAttrUpdateData
---@field mercenarys MercenaryAttrInfo__Array @
---@field source_type number @0/默认，1/实体变化

---@class TeamMercenaryBriefInfo
---@field id number @
---@field owner_id uint64 @

---@class RebornInfo
---@field entrys EnchantEntryBlock__Array @附魔信息
---@field cache_entrys EnchantEntryBlock__Array @
---@field cache_entrys_high EnchantEntryBlock__Array @
---@field equip_pos number @
---@field level_limit number @
---@field enchant_level number @附魔档次

---@class GuildHuntCountInfo
---@field simple_finish_times number @简单难度完成次数
---@field seal_piece_used_times number @封印碎片使用次数

---@class ExtraData
---@field value32 number @

---@class MapInt32ListMap32
---@field level number @
---@field item_cost ItemCostInfo__Array @

---@class BuffEffectTriggerSyncInfo
---@field buff_uuid_ uint64 @
---@field in_effect_group_id_ number @在BuffTable 的 EffectGroup 中的Id
---@field entity_uuid_ uint64 @

---@class GuildMatchDungeonsReconnect
---@field remain_points number @自身剩余点数
---@field camp1_remain_points number @阵营1剩余点数
---@field camp2_remain_points number @阵营2剩余点数
---@field left_life_counter MapUint64ToInt32__Array @
---@field camp1_flower_num number @
---@field camp2_flower_num number @
---@field fight_history FightHistory @
---@field round_id number @
---@field end_time int64 @副本剩余秒数

---@class GuildMatchStatistics
---@field role_life_counter MapUint64ToInt32__Array @
---@field camp1_remain_points number @
---@field camp2_remain_points number @
---@field guild_brief GuildBriefInfo__Array @

---@class GuildBriefInfo
---@field camp_id number @
---@field guild_id int64 @
---@field icon_id number @
---@field guild_name string @

---@class FightHistory
---@field pvp_result PVPResult__Array @

---@class PVPResult
---@field camp1_result DungeonsResultStatus @
---@field camp2_result DungeonsResultStatus @

---@class GuildMatchSyncRoleLifeData
---@field camp1_role_life_counter MapUint64ToInt32__Array @
---@field camp2_role_life_counter MapUint64ToInt32__Array @
---@field camp1_score number @
---@field camp2_score number @
---@field camp1_guild_id int64 @
---@field camp2_guild_id int64 @
---@field dungeons_end_time uint64 @副本结束时间戳

---@class BoliAwardIdCountInfo
---@field id number @波利id
---@field count number @到达领奖的次数
---@field is_award boolean @是否领奖

---@class Ro_Item
---@field uid uint64 @道具唯一ID
---@field item_id number @道具模板ID
---@field item_count int64 @道具数量
---@field total_price int64 @道具总价
---@field state_sign number @状态枚举，第0位表示绑定，1表示损坏
---@field effective_time number @有效时间,加上 创建时间为结束时间戳
---@field create_time uint64 @创建时间戳
---@field item_pos number @在容器中的位置
---@field attr_list Ro_Item_Attr_List__Array @属性列表
---@field buff_list Ro_Item_Attr_List__Array @buff列表
---@field extra_data_map MapInt32Int32__Array @存放一些零碎的数据，具体内容去看EItemExtraDataKey
---@field money_type number @出售货币类型，0表示默认，其他表示货币id
---@field fight_attr_list Ro_Item_Attr_List__Array @临时战斗属性

---@class Ro_Item_Attr
---@field attr_id number @属性id
---@field attr_val number @属性数值
---@field ro_item_extra_param MapInt32Int32__Array @TODO，可能需要改结构

---@class Ro_Item_Attr_List
---@field attr_or_buff_list Ro_Item_Attr__Array @属性列表
---@field table_id number @表ID，看客户端逻辑，也许可以删掉
---@field attrmodletype number @属性所属模块

---@class EnchantRecord
---@field enchant_times number @附魔次数
---@field level_second_cur_times number @未出现第2档附魔的次数
---@field level_second_trigger_times number @触发第2档附魔的阈值次数
---@field level_fifth_cur_times number @未出现第5档附魔的次数
---@field level_fifth_trigger_times number @触发第5档附魔的阈值次数
---@field profession_attr_times number @职业专属属性没有随机到的次数
---@field enchant_level number @附魔档次id

---@class SkillResultTargetInfo
---@field firer uint64 @技能释放者
---@field target_list uint64__Array @技能多目标
---@field skill_uuid uint64 @技能唯一id
---@field result_index number @技能result下标

---@class AutoCollectArg
---@field collect_type LifeSkillType @
---@field add_time number @增加时间
---@field is_continue boolean @是否自动续时

---@class AutoCollectRes
---@field result ErrorCode @

---@class RoleSmallPhotoData
---@field role_id uint64 @角色id
---@field role_type RoleType @角色职业
---@field name string @角色名字
---@field sex_type SexType @角色性别
---@field base_level number @基础等级
---@field job_level number @职业等级
---@field outlook MemberOutLook @外观
---@field equip_ids PBuint32__Array @装备信息

---@class SwitchSkyBoxData
---@field toggle boolean @是否切换，目前只支持一个

---@class BreakOffAutoCollectArg
---@field collect_type LifeSkillType @

---@class BreakOffAutoCollectRes
---@field result ErrorCode @

---@class GetAutoCollectEndTimeArg
---@field collect_type LifeSkillType @采集类型

---@class GetAutoCollectEndTimeRes
---@field end_time uint64 @自动采集结束时间

---@class AutoCollectData
---@field collect_type LifeSkillType @

---@class ArenaSyncScoreData
---@field camp1_roles uint64__Array @
---@field camp2_roles uint64__Array @
---@field camp1_score number @
---@field camp2_score number @
---@field camp1_id number @
---@field camp2_id number @
---@field dungeons_end_time uint64 @副本结束时间戳

---@class FashionEvaluationInfoArg

---@class FashionEvaluationInfoRes
---@field left_times number @剩余可拍照次数
---@field theme FashionTheme @
---@field result ErrorCode @
---@field fashion_collect_score number @典藏值
---@field fashion_collect_rank number @典藏值排名
---@field photo_data FashionPhotoData @今日最高分头像
---@field max_score number @本期参与的最高分数

---@class EvaluateFashionArg

---@class EvaluateFashionRes
---@field result ErrorCode @
---@field score number @
---@field max_score number @
---@field has_update number @

---@class FashionMagazineArg
---@field round number @第x期

---@class FashionMagazineRes
---@field ranks PBuint64__Array @
---@field result ErrorCode @
---@field theme FashionTheme @
---@field round number @第x期

---@class FashionPhotoData
---@field args PBfloat__Array @
---@field outlook MemberOutLook @
---@field equip_ids PBuint32__Array @
---@field type RoleType @
---@field sex SexType @
---@field action PBString__Array @

---@class DBFashionScore
---@field role_id uint64 @
---@field score number @
---@field name string @
---@field photo FashionPhotoData @

---@class MsCreateNpcData
---@field scene_id number @
---@field npc_id number @
---@field face number @
---@field pos Vec3 @
---@field destory_time uint64 @

---@class RoleFashionScoreArg
---@field roleid RoleFashionKeyValData__Array @
---@field round number @第x期

---@class RoleFashionScoreRes
---@field result ErrorCode @
---@field socre DBFashionScore__Array @

---@class RoleFashionData
---@field eva_times number @

---@class FashionEvaRecord
---@field score FashionScoreForSave__Array @
---@field begin_time int64 @
---@field end_time number @
---@field influence_id number @
---@field cur_theme FashionTheme @
---@field round number @第x期

---@class FashionRatringStartNtfData
---@field npc MsCreateNpcData @
---@field theme FashionTheme @

---@class RoleFashionRankData
---@field score number @
---@field index int64 @照片的index

---@class RoleFashionKeyValData
---@field role_id uint64 @
---@field index int64 @-1表示取最高得分照片

---@class UploadFashionPhotoData
---@field photo FashionPhotoData @
---@field index number @第几次上传

---@class FashionScoreForSave
---@field role_id uint64 @
---@field score number @
---@field name string @
---@field photos FashionPhotoData__Array @

---@class FashionHistoryNode
---@field round number @第x期
---@field theme number @主题
---@field fashion_score_data DBFashionScore @玩家数据

---@class FashionHistoryArg

---@class FashionHistoryRes
---@field history_nodes FashionHistoryNode__Array @历史节点

---@class FetchFashionTicketArg

---@class FetchFashionTicketRes
---@field result ErrorCode @

---@class FashionEvaHistoryDB
---@field records FashionEvaRecord__Array @往期数据

---@class OpenFashionTicketArg

---@class OpenFashionTicketRes

---@class SaveFashionPhotoRecordData
---@field role_id uint64 @玩家id
---@field photo_data FashionPhotoData @拍照数据
---@field score number @积分

---@class FashionEvaluationNpcArg

---@class FashionEvaluationNpcRes
---@field npc_scene_id number @场景id
---@field npc_x number @坐标x
---@field npc_y number @
---@field npc_z number @

---@class FashionPhotoShareData
---@field score number @积分
---@field name string @名字
---@field photo_data FashionPhotoData @照片

---@class FashionEvaMirrorID
---@field role_id_list uint64__Array @玩家id列表

---@class GiftLimitPbInfo
---@field role_uid uint64 @其他角色id
---@field present_times GiftTimesPair__Array @已赠送信息

---@class RoleGiftLimitPbInfo
---@field uid uint64 @赠送者id
---@field gift_limit_times GiftLimitTimesPb__Array @
---@field send_list uint64__Array @赠送过的人的id

---@class GiveGiftsArg
---@field role_uid uint64 @角色id
---@field uid_items ItemUidPair__Array @道具id及数量
---@field gift_type number @赠送类型

---@class GiveGiftsRes
---@field result ErrorCode @错误码
---@field gift_times GiftTimes @赠送次数信息

---@class GetGiftLimitInfoArg
---@field role_uid uint64 @角色id

---@class GetGiftLimitInfoRes
---@field result ErrorCode @
---@field limit_list GiftLimitInfo__Array @

---@class GiftLimitInfo
---@field friend_list FriendInfo @本人与该玩家关系
---@field gift_times GiftTimes__Array @赠送次数信息

---@class GiveGiftItemChangeArg
---@field rpcid number @
---@field item_change_reason ItemChangeReason @
---@field remove_item_list ItemUidPair__Array @扣除的道具列表
---@field intimacy_degree number @好友度
---@field mail_id number @
---@field award_id number @
---@field match_content LocalizationNameContainer @邮件模板格式化参数
---@field mail_recv_uid uint64 @收件者uid
---@field gift_type number @赠送类型 用来校验
---@field match_title LocalizationNameContainer @
---@field match_send_name LocalizationNameContainer @

---@class GiftTimes
---@field gift_type number @赠送类型
---@field gift_recipient_times number @该玩家接受赠送的剩余次数
---@field present_times GiftTimesPair__Array @已使用赠送次数信息

---@class GiveGiftItemChangeRes
---@field error_code ErrorCode @
---@field need_back boolean @
---@field item_id_list ItemCountInfo__Array @

---@class GiftLimitTimesPb
---@field gift_type number @赠送类型
---@field gift_recipient_times number @本人当日接受赠送的次数
---@field gift_limits GiftLimitPbInfo__Array @
---@field be_add_count boolean @接受赠送的次数是否被增加过(公会团宠用)

---@class GiftTimesPair
---@field limit_type number @1/天,2/周
---@field left_times number @
---@field total_count number @

---@class GetMengXinLevelGiftArg
---@field gift_id number @礼包ID

---@class GetMengXinLevelGiftRes
---@field result ErrorCode @

---@class MengXinLevelGiftsData
---@field gift_id number @当前可领取的礼包ID
---@field close_time int64 @结束时间戳

---@class GMCommonArg
---@field args string__Array @参数列表 cmd为第一个
---@field role_uid uint64 @角色id
---@field send_to number @0:后面的全部 1:game 2:trade 3:login 4:control 5:audio 6:battle 7:log
---@field delay_rpc number @进程间内部使用
---@field request_id number @idip用
---@field ismaster boolean @如果命令有多个进程同时执行，需要选取一个做master，执行数据库落地等排他操作

---@class GMCommonRes
---@field result ErrorCode @结果
---@field cmd string @命令号
---@field result_message string @执行的结果

---@class GMMailArg
---@field type number @邮件类型
---@field role_uid_list uint64__Array @角色uid列表
---@field mail_id number @邮件id
---@field title string @邮件标题
---@field content string @邮件内容
---@field match_content string @
---@field award_id number @奖励id
---@field item_list ItemTemplate__Array @奖励表
---@field expire_day number @期限
---@field request_id number @idip用
---@field idip_item_extra IdipItemExtraInfoPb @额外物品信息

---@class GMAnnounceArg
---@field role_ids uint64__Array @接收者uid 为空是全服
---@field type number @
---@field content string @公告内容
---@field send_time uint64 @
---@field end_time uint64 @
---@field show_interval number @
---@field request_id number @idip用

---@class GMBanRoleArg
---@field operate_role_uid uint64 @
---@field operate_type BanRoleOperate @
---@field request_id number @idip用
---@field ban_info BanRoleInfo__Array @
---@field is_operate_account boolean @
---@field server_id number @
---@field open_id string @
---@field ban_account PlatBanAccount @

---@class GMAnnounceClearArg
---@field request_id number @idip专用
---@field announce_id uint64 @

---@class GMReloadTableCmdArg
---@field args string__Array @
---@field request_id number @idip

---@class GMReloadTableCmdRes
---@field result ErrorCode @
---@field message string @

---@class ChangeServerOpenDayRes
---@field result ErrorCode @

---@class ChangeServerOpenDayArg
---@field open_day string @时间格式YYYYMMDD
---@field open_day_timestamp uint64 @
---@field is_reset boolean @
---@field time_offset number @时间偏移
---@field server_id number @
---@field mtime uint64 @

---@class GMRoleInfoArg
---@field role_id uint64 @
---@field role_name string @
---@field request_id number @
---@field server_id number @

---@class GMRoleInfoRes
---@field error_code ErrorCode @
---@field role RoleAllInfo @
---@field is_ban boolean @
---@field end_time number @
---@field ban_reason string @

---@class RoleInfoArg
---@field role_id uint64 @
---@field role_name string @
---@field rpc_id number @

---@class RoleInfoRes
---@field error_code ErrorCode @
---@field role RoleAllInfo @

---@class IdipReadRoleDataArg
---@field role_info IdipReadRoleInfo @
---@field rpc_id number @
---@field server_id number @

---@class IdipReadRoleDataRes
---@field result ErrorCode @
---@field role_info RoleAllInfo @
---@field is_ban boolean @
---@field end_time number @
---@field ban_reason string @

---@class IdipReadRoleInfo
---@field role_id uint64 @
---@field role_name string @

---@class IdipGetAllAnnounceArg
---@field request_id number @

---@class AnnouneceInfo
---@field announce_id int64 @
---@field content string @
---@field start_time number @
---@field end_time number @
---@field interval number @
---@field type number @
---@field role_list string @

---@class IdipGetAllAnnounceRes
---@field result ErrorCode @
---@field announce_info AnnouneceInfo__Array @

---@class IdipGetSysOpenTimeArg
---@field request_id number @

---@class IdipGetSysOpenTimeRes
---@field result ErrorCode @
---@field open_time number @
---@field open_level number @

---@class IdipSetSysOpenTimeArg
---@field open_time number @
---@field request_id number @

---@class IdipSetSysOpenTimeRes
---@field result ErrorCode @
---@field open_time number @
---@field open_level number @

---@class LockRoleData
---@field role_uid uint64 @
---@field operate_type LockRoleOperate @
---@field ban_info BanRoleInfo @ban_info.type只能为 0

---@class IdipGetRoleAllInfoArg
---@field role ARole__Array @需要获取的角色
---@field get_type number @0:在线优先内存获取 1:均从db获取
---@field request_id number @

---@class IdipGetRoleAllInfoRes
---@field result ErrorCode @
---@field role_info RoleAllInfo__Array @角色信息

---@class GsGetRoleAllInfoArg
---@field role ARole__Array @
---@field delay_rpc number @
---@field read_unique_id number @

---@class GsGetRoleAllInfoRes
---@field result ErrorCode @
---@field role_info RoleAllInfo__Array @

---@class IdipItemModifyArg
---@field role ARole__Array @
---@field item_datas IdipItemModifyData__Array @
---@field serial_num string @流水号
---@field source_id number @渠道号
---@field cmd string @命令字

---@class IdipItemModifyData
---@field add_or_dev number @增加或减少
---@field item_uid uint64 @道具Uid
---@field item_data ItemTemplate @道具模板

---@class IdipItemModifyRes
---@field result ErrorCode @

---@class IdipMapIntToInt
---@field key number @
---@field value number @

---@class IdipGetRoleFriendInfoArg
---@field role ARole__Array @
---@field request_id number @

---@class IdipGetRoleFriendInfoRes
---@field result ErrorCode @
---@field friend_info SingelRoleFriends__Array @

---@class IdipGetRoleGiftInfoArg
---@field role ARole__Array @
---@field request_id number @

---@class IdipGetRoleGiftInfoRes
---@field result ErrorCode @
---@field gift_info RoleGiftLimitPbInfo__Array @

---@class IdipGetRoleMessageInfoArg
---@field role ARole__Array @
---@field request_id number @

---@class IdipGetRoleMessageInfoRes
---@field result ErrorCode @
---@field role_message RoleMessageInfo__Array @

---@class IdipComCmd
---@field idip_cmd number @对应EIdipCmd 请求id 返回id+1
---@field idip_request_id number @本次操作对应的请求id 回复的时候需要
---@field serialize_buff string @根据id系列化的字符串
---@field rpcid number @

---@class IdipRoleModifyArg
---@field role ARole @
---@field proc_type IdipProcType @逻辑发给哪个进程处理
---@field cmd_arg IdipComCmd @携带的参数
---@field is_logout boolean @是否要踢下线

---@class IdipRoleModifyRes
---@field result ErrorCode @
---@field re_serialize_buff IdipComCmd @

---@class IdipGsRoleModifyArg
---@field role ARole @
---@field rpc_id number @
---@field cmd_arg IdipComCmd @
---@field is_logout boolean @

---@class IdipGsRoleModifyRes
---@field result ErrorCode @
---@field re_serialize_buff IdipComCmd @

---@class IdipGetRoleMailInfoArg
---@field role ARole__Array @
---@field request_id number @

---@class IdipGetRoleMailInfoRes
---@field result ErrorCode @
---@field mail_info RoleMailInfo__Array @

---@class IdipProcessDataSeondMoney
---@field moneytype number @货币类型
---@field money int64 @货币修改数量
---@field serial_num string @流水号
---@field cmd string @命令符
---@field source_id number @渠道号

---@class IdipProcessDataSeondMoneyRes
---@field before int64 @改前数量
---@field after int64 @改后数量

---@class IdipTrRoleModifyArg
---@field role ARole @
---@field rpc_id number @
---@field cmd_arg IdipComCmd @
---@field is_logout boolean @

---@class IdipTrRoleModifyRes
---@field result ErrorCode @
---@field re_serialize_buff IdipComCmd @

---@class IdipWhiteListArg
---@field operate_type number @操作方式
---@field open_id string @OPENid
---@field request_id number @
---@field isbroadcast boolean @true代表会执行数据库落地和通知下线

---@class IdipGetRoleGuildInfoArg
---@field role ARole__Array @
---@field request_id number @

---@class IdipWhiteListRes
---@field result ErrorCode @
---@field open_ids string__Array @

---@class IdipGetRoleGuildInfoRes
---@field result ErrorCode @
---@field guild_info GuildInfo__Array @

---@class IdipProcessDataAttribute
---@field attribute_type number @
---@field attribute_value number @

---@class IdipProcessDataAttributeRes
---@field before int64 @改前数量
---@field after int64 @改后的量

---@class IdipGetRoleBanInfoArg
---@field role ARole__Array @
---@field request_id number @

---@class IdipGetRoleBanInfoRes
---@field result ErrorCode @
---@field ban_info BanInfo__Array @

---@class BanInfo
---@field role ARole @
---@field ban_info BanRoleInfo__Array @
---@field is_ban boolean @
---@field ban_account BanAccount @

---@class GMMessage
---@field role ARole @
---@field msg string @

---@class RepeatedGMMessage
---@field data GMMessage__Array @

---@class RepeatedString
---@field datas string__Array @

---@class IdipCommonRequestArg
---@field proc_type IdipProcType @
---@field cmd_arg IdipComCmd @

---@class IdipCommonRequestRes
---@field error_code ErrorCode @
---@field result IdipComCmd @

---@class MaskChatOperateArg
---@field open_id string @
---@field role_uid uint64 @为空表示本区的
---@field operate_active boolean @true封禁false解封
---@field end_timestamp uint64 @到期时间
---@field chat_type number @与ChatMsgType对应的,-1为全频道
---@field reason string @原因可为空
---@field self_can_see boolean @发言自己可见
---@field request_id number @
---@field kick_role_out boolean @

---@class MaskChatOperateRes
---@field result ErrorCode @

---@class ChangeChatIntervalArg
---@field open_id string @
---@field role_uid uint64 @为空表示本区的
---@field operate_active boolean @true表示加上规则false表示解除
---@field end_timestamp uint64 @到期自动解除时间
---@field chat_type number @与ChatMsgType对应的,-1为全频道
---@field reason string @原因可为空
---@field offset int64 @偏移 秒
---@field request_id number @
---@field kick_role_out boolean @

---@class ChangeChatIntervalRes
---@field result ErrorCode @

---@class AqChangeChatInterval
---@field data ChangeChatIntervalArg @

---@class AqMaskChatOperateData
---@field data MaskChatOperateArg @

---@class QueryRoleInfoByOpenIDArg
---@field open_id string @
---@field request_id number @
---@field area_id number @
---@field plat_id number @
---@field server_id number @
---@field callback_type number @

---@class QueryRoleInfoByOpenIDRes
---@field result ErrorCode @
---@field role_forbid_info ARoleForbidTalkInfo__Array @

---@class IdipChatMsgClearArg
---@field role ARole @
---@field request_id number @

---@class IdipChatMsgClearRes
---@field result ErrorCode @

---@class IdipChangeRolenameArg
---@field newrolename string @
---@field role ARole @
---@field account string @

---@class IdipModuleModifyRequestArg
---@field is_open boolean @
---@field module_id number__Array @
---@field cmd_arg IdipComCmd @
---@field isbroadcast boolean @true表示执行数据库落地和广播给下线服务器

---@class IdipModuleModifyRequestRes
---@field error_code ErrorCode @
---@field result IdipComCmd @

---@class OperateBanAccountArg
---@field ban_acc BanAccount @
---@field operate BanAccountOperate @
---@field request_id number @
---@field isbroadcast boolean @true表示会数据库落地，并且下发下线服务器

---@class OperateBanAccountRes
---@field result ErrorCode @
---@field is_ban boolean @
---@field ban_account BanAccount @

---@class IdipSetGameScoreArg
---@field role ARole @
---@field score_type number @
---@field val number @

---@class IdipSetGameScoreRes
---@field result string @

---@class IdipDiamondModifyArg
---@field role ARole @
---@field modify_count number @
---@field serial_num string @流水号
---@field source_id number @渠道号
---@field cmd string @命令符

---@class IdipDiamondModifyRes
---@field result string @

---@class BanAccountList
---@field acc_list BanAccount__Array @

---@class ForbidTalkArg
---@field openid string @
---@field talk_forbid TalkForbid @
---@field operate_add boolean @
---@field request_id number @
---@field isbroadcast boolean @是否广播

---@class ForbidTalkRes
---@field result ErrorCode @

---@class IdipUpdateMoneyArg
---@field role ARole @
---@field type number @
---@field val int64 @
---@field serial_num string @流水号
---@field source_id number @渠道号
---@field cmd string @命令字

---@class IdipUpdateMoneyRes
---@field result ErrorCode @
---@field mess string @

---@class IdipChangeRolenameRes
---@field result ErrorCode @

---@class ARole
---@field role_id uint64 @
---@field open_id string @

---@class KickOffRoleArg
---@field a_role ARole @
---@field is_all_area boolean @
---@field reason string @
---@field request_id number @

---@class KickOffRoleRes
---@field result ErrorCode @

---@class KickOffAccountArg
---@field a_role ARole @
---@field reason string @
---@field request_id number @

---@class KickOffAccountRes
---@field result ErrorCode @

---@class KickOffRoleData
---@field open_id string @
---@field reason string @

---@class IdipQueryRoleArg
---@field key_words string @
---@field max_limit number @
---@field request_id number @

---@class IdipQueryRoleRes
---@field result ErrorCode @
---@field role_list QueryRoleData__Array @

---@class QueryRoleData
---@field server_id number @
---@field a_role ARole @
---@field name string @
---@field base_level number @
---@field job number @

---@class IdipGuildQueryMemberListArg
---@field a_role ARole @
---@field guild_id int64 @
---@field pag_num number @
---@field request_id number @

---@class IdipGuildQueryMemberListRes
---@field result ErrorCode @
---@field cur_pag_num number @
---@field total_pag_num number @
---@field mem_list GuildListInfo__Array @

---@class GuildListInfo
---@field role_name string @
---@field role_uid uint64 @
---@field job number @
---@field permission number @
---@field guild_contribution int64 @

---@class IdipAntiAddictionArg
---@field request_id number @
---@field data AntiAddictionData @

---@class AntiAddictionData
---@field cmd_id number @4205：中控提醒 4207：中控禁玩 4209：中控强制验证
---@field role_id uint64 @
---@field area_id number @大区id 1-微信 2-手Q
---@field partition number @分区
---@field plat_id number @平台 0-iOS 1-Android
---@field open_id string @openid
---@field msg_content string @提示内容
---@field title string @提示标题
---@field trace_id string @流水号
---@field source string @渠道号非必要
---@field serial string @流水号
---@field begin_time number @禁玩开始时间（禁玩专用）
---@field end_time number @禁玩结束时间（禁玩专用）
---@field json_str string @实名认证json数据(强制验证专用)

---@class RegisterSwitchData
---@field max_register_num number @最大注册
---@field onoff boolean @注册开关

---@class RegisterSwitchArg
---@field server_id number @
---@field request_id number @
---@field data RegisterSwitchData @

---@class RegisterSwitchRes
---@field result ErrorCode @

---@class DBRegisterSwitchArg
---@field delay_id number @
---@field data RegisterSwitchData @

---@class DBRegisterSwitchRes
---@field result ErrorCode @

---@class QueryRegisterArg
---@field server_id number @
---@field request_id number @

---@class QueryRegisterRes
---@field result ErrorCode @
---@field data RegisterSwitchData @

---@class DBQueryRegisterArg
---@field delay_id number @

---@class DBQueryRegisterRes
---@field result ErrorCode @
---@field data RegisterSwitchData @

---@class IdipReloadRoleArg
---@field role ARole @

---@class IdipReloadRoleRes
---@field result ErrorCode @
---@field mess string @

---@class IdipWxLuckyBagArg
---@field area number @
---@field plat_id number @
---@field partition number @
---@field open_id string @
---@field cmd_arg IdipComCmd @

---@class IdipWxLuckyBagRes
---@field result ErrorCode @
---@field user_type number @福袋维度

---@class IdipGetAccountArg
---@field role_id uint64 @
---@field request_id number @

---@class IdipGetAccountRes
---@field result ErrorCode @
---@field account_info RoleBriefInfo @
---@field IsRoleDeleted boolean @

---@class RecoverRoleArg
---@field account string @
---@field server_id number @
---@field role_id uint64 @
---@field role_index number @
---@field role_status RoleStatusType @
---@field delay_id number @
---@field request_id number @
---@field mtime uint64 @

---@class RecoverRoleRes
---@field result ErrorCode @

---@class ARoleForbidTalkInfo
---@field role_id uint64 @
---@field open_id string @
---@field forbid_talk_info string @
---@field is_deleted boolean @

---@class IdipReloadConfigArg
---@field request_id number @

---@class IdipReloadConfigRes
---@field result ErrorCode @

---@class IdipLoginGMCommonArg
---@field args string__Array @
---@field request_id number @
---@field ismaster boolean @是否是主要操作对象

---@class IdipLoginGMCommonRes
---@field result ErrorCode @

---@class GSLocalGMCmdArg
---@field args string @

---@class GSLocalGMCmdRes
---@field result_msg string @

---@class DPSInfoData
---@field total_time int64 @战斗时长
---@field total_damage number @总伤害
---@field dps_damage number @秒伤害

---@class IdipSetRolePositionArg
---@field role ARole @
---@field scene_id number @

---@class IdipSetStallNumArg
---@field stall_num number @需要修改的摊位数量

---@class IdipIncRechargeCountArg
---@field inc_num number @增加次数

---@class IdipActiveVipCardArg
---@field card_type number @类型(0月卡)
---@field operate_type number @操作类型(1激活,2续费,3关闭)
---@field is_add_times number @是否计入累充(0不计入1计入)
---@field is_all_role number @是否所有玩家(0单个玩家1所有玩家)
---@field product_id number @

---@class IdipPaySdkArg
---@field role_id uint64 @role_id
---@field open_id string @
---@field product_id string @直购产品id

---@class IdipPaySdkRes
---@field result ErrorCode @

---@class Idip2PayCommonReqArg
---@field role ARole @
---@field cmd_arg IdipComCmd @

---@class Idip2PayCommonReqRes
---@field result ErrorCode @
---@field cmd_res IdipComCmd @

---@class IdipDismissGuildArg
---@field guild_id int64 @

---@class IdipDeleteMailArg
---@field mail_uid uint64 @
---@field reason number @0:GM删除1:退款删除

---@class IdipMultiPageArg
---@field current_page number @当前页
---@field page_row_count number @每页多少行

---@class deleteAccountAndRoleGMData
---@field account string @玩家账号
---@field player_uuid uint64 @

---@class IdipServerOpenSystemArg
---@field cmd_arg IdipComCmd @

---@class IdipServerOpenSystemRes
---@field result ErrorCode @
---@field open_system number__Array @
---@field close_system number__Array @

---@class PushAdDbData
---@field ad_id number @广告唯一id
---@field ad_switch number @开关(1开0关)
---@field start_time int64 @开始时间
---@field end_time int64 @结束时间
---@field show_type number @1每次登录弹,2当日首次登录弹,3只弹一次
---@field image_list IdipPushAdImageList @图片列表
---@field seen_roles RepeatUInt64 @发送过了的角色
---@field base_level number @baselevel限制

---@class IdipPushAdImageNode
---@field img_url string @图片地址
---@field jump_url string @游戏内的跳转地址
---@field btn_title string @前往按钮显示的字

---@class IdipPushAdImageList
---@field image_list IdipPushAdImageNode__Array @图片列表

---@class IdipCommonReqMultiSvrArg
---@field cmd_arg IdipComCmd @
---@field server_id number @服务器id

---@class IdipCommonReqMultiSvrRes
---@field error_code ErrorCode @
---@field cmd_res IdipComCmd @返回的结果

---@class RepeatUInt64
---@field datas uint64__Array @

---@class PushAdSaveArg
---@field datas PushAdDbData__Array @

---@class PushAdSaveRes
---@field err_code ErrorCode @

---@class PushAd2ClientData
---@field datas PushAdDbData__Array @

---@class PreRegisterRoleData
---@field name string @角色名字
---@field gender number @性别
---@field open_id string @OpenID

---@class IdipPreRegisterRoleArg
---@field pre_register_data PreRegisterRoleData @预注册角色信息

---@class IdipPreRegisterRoleRes
---@field pre_register_res PreRegisterRoleRes @预注册结果

---@class ControlPreRegisterRoleArg
---@field role_all_info RoleAllInfo @角色所有信息
---@field ctime uint64 @创角时间
---@field result ErrorCode @错误码

---@class ControlPreRegisterRoleRes
---@field pre_register_res PreRegisterRoleRes @预注册结果

---@class MasterPreRegisterRoleArg
---@field pre_register_data PreRegisterRoleData @预注册角色信息
---@field result ErrorCode @错误码

---@class MasterPreRegisterRoleRes
---@field pre_register_res PreRegisterRoleRes @预注册结果

---@class PreRegisterRoleRes
---@field result ErrorCode @错误码
---@field timestamp uint64 @导入数据库的时间戳
---@field role_uuid uint64 @角色uuid

---@class PreRegisterAccountDeleteArg
---@field open_id string @OpenID
---@field expire_time uint64 @过期时间（秒）
---@field role_uuid uint64 @角色id

---@class PreRegisterAccountDeleteRes
---@field result ErrorCode @删除结果错误码
---@field role_uuid uint64 @预注册角色id
---@field pre_register_role_data PreRegisterRoleData @预注册角色信息
---@field create_time uint64 @创角时间戳

---@class IdipModifyDiamond
---@field role_uid int64 @角色id
---@field modify_diamond number @修改钻石数量
---@field modify_free_diamond number @修改的免费钻石
---@field reason number @删除原因(0普通,1退款等)

---@class IdipQueryRoleMailInfoArg
---@field role ARole @
---@field request_id number @
---@field cond QueryCond @查询条件

---@class IdipQueryRoleMailInfoRes
---@field result ErrorCode @
---@field mail_info RoleMailInfo @

---@class QueryCond
---@field mail_uid uint64__Array @
---@field product_id number__Array @
---@field item_id number__Array @

---@class OperationCommondataRes
---@field result ErrorCode @

---@class IdipOperationCommondata
---@field operation_type number @操作类型为0返回，必须填写：1,设置,2增加
---@field commondata_type number @通用数据type枚举
---@field commondata_key_id number @通用数据key 的id
---@field commondata_value int64 @64位bit
---@field commondata_hight_value number @高32位数值
---@field commondata_low_value number @低32位数值

---@class QteGuideData
---@field guide_id number @

---@class WeakQteGuideData
---@field guide_id number @

---@class GuildHuntTreasureEventNotifyInfo
---@field guild_id int64 @公会id
---@field scene_uid number @公会场景uid
---@field member_count number @人数

---@class GuildAllInfo
---@field id int64 @
---@field brief GuildBriefDbInfo @
---@field application GuildApplicationDbInfo @
---@field building GuildBuildingDbInfo @
---@field crystal_system GuildCrystalSystemDbInfo @
---@field count_info GuildCountDbInfo @
---@field stone GuildStoneDBInfo @
---@field repository GuildRepo @公会仓库,内涵拍卖日志
---@field guild_royal GuildRankScoreDBInfo @公会排名系统/荣耀系统
---@field organization GuildOrganizationDbInfo @公会组织力

---@class GuildBriefDbInfo
---@field icon_id number @
---@field name string @
---@field other_name_list string__Array @
---@field level number @
---@field declaration string @
---@field announce string @
---@field creator uint64 @
---@field member_list GuildMemberDbInfo__Array @
---@field last_refresh_time int64 @
---@field is_auto_approval boolean @
---@field cur_money int64 @
---@field activeness int64 @
---@field news_list AnnounceData__Array @
---@field permission_list GuildPermissionDbInfo__Array @
---@field week_money int64 @统计本周资金
---@field last_week_welfare int64 @上一周的公会福利
---@field create_time int64 @公会创建时间
---@field gift_week_type number__Array @
---@field gift_week_count number__Array @
---@field gift_count number @
---@field last_binding_time uint64 @上一次解绑的时间
---@field last_dinner_score number @上周宴会比赛得分
---@field today_money int64 @统计本周资金

---@class GuildApplicationItemDbInfo
---@field role_id uint64 @
---@field apply_time int64 @
---@field is_one_key_apply boolean @
---@field sex_type SexType @性别

---@class GuildMemberDbInfo
---@field role_id uint64 @
---@field join_time int64 @
---@field permission number @
---@field cur_contribute int64 @
---@field total_contribute int64 @
---@field week_contribute int64 @
---@field is_welfare_award boolean @
---@field last_week_permission number @上周最后的职位
---@field last_logout_time int64 @
---@field extra_types number__Array @
---@field extra_params int64__Array @
---@field sex_type SexType @性别
---@field organization_contribute number @个人组织力贡献
---@field last_week_active number @上周活跃

---@class GuildApplicationDbInfo
---@field application_list GuildApplicationItemDbInfo__Array @

---@class GuildDbInfo
---@field operation number @
---@field id int64 @
---@field field_name_list string__Array @
---@field field_data_list string__Array @
---@field mtime uint64 @

---@class GuildCreateArg
---@field icon_id number @
---@field name string @
---@field declaration string @

---@class GuildCreateRes
---@field error_code ErrorCode @

---@class GuildGetInfoArg

---@class GuildGetInfoRes
---@field error_code ErrorCode @
---@field self_guild GuildDetailInfo @
---@field self_info GuildMemberDetailInfo @

---@class GuildDetailInfo
---@field id int64 @
---@field icon_id number @
---@field name string @
---@field level number @
---@field cur_member number @
---@field total_member number @
---@field cur_money int64 @
---@field total_money int64 @
---@field activeness int64 @
---@field declaration string @
---@field announce string @
---@field other_name_list string__Array @
---@field chairman GuildMemberDetailInfo @
---@field creator GuildMemberDetailInfo @
---@field is_apply boolean @
---@field permission_list GuildPermissionInfo__Array @
---@field today_money int64 @

---@class GuildMemberDetailInfo
---@field base_info MemberBaseInfo @
---@field permission number @
---@field cur_contribute int64 @
---@field total_contribute int64 @
---@field achievement int64 @
---@field is_online boolean @
---@field last_offline_time int64 @
---@field join_time int64 @
---@field active_chat number @
---@field active_fight number @
---@field gift_is_get boolean @是否已被发送礼盒
---@field guild_red_envelope_info GuildRedEnvelopeInfo__Array @公会红包信息
---@field is_open_champagne boolean @一周内是否开启过香槟

---@class GuildGetListArg
---@field last_guild_id int64 @
---@field count number @

---@class GuildGetListRes
---@field guild_list GuildDetailInfo__Array @

---@class GuildSearchArg
---@field name string @

---@class GuildSearchRes
---@field guild_list GuildDetailInfo__Array @
---@field result ErrorCode @

---@class GuildApplyArg
---@field guild_id int64 @0 表示一键申请
---@field invite_role uint64 @邀请人 0表示无人邀请

---@class GuildApplyRes
---@field error_code ErrorCode @
---@field guild_list PBint64__Array @

---@class GuildDeclarationChangeArg
---@field declartion string @

---@class GuildDeclarationChangeRes
---@field error_code ErrorCode @
---@field declartion string @过滤后的宣言

---@class GuildAnnounceChangeArg
---@field announce string @

---@class GuildAnnounceChangeRes
---@field error_code ErrorCode @
---@field announce string @过滤后的公告

---@class GuildQueryMemberListArg

---@class GuildQueryMemberListRes
---@field error_code ErrorCode @
---@field member_list GuildMemberDetailInfo__Array @

---@class GuildMemberSearchArg
---@field name string @

---@class GuildMemberSearchRes
---@field member_list GuildMemberDetailInfo__Array @

---@class GuildChangePermissionArg
---@field role_id uint64 @
---@field permission number @

---@class GuildChangePermissionRes
---@field error_code ErrorCode @

---@class GuildGetApplicationListArg

---@class GuildKickOutMemberRes
---@field error_code ErrorCode @

---@class GuildKickOutMemberArg
---@field role_id uint64 @
---@field force boolean @

---@class GuildGetApplicationListRes
---@field error_code ErrorCode @
---@field member_list GuildMemberDetailInfo__Array @
---@field is_auto boolean @

---@class GuildApplyReplayArg
---@field role_id uint64 @
---@field accept boolean @

---@class GuildApplyReplayRes
---@field error_code ErrorCode @

---@class GuildAutoApprovalApplyArg
---@field is_auto_approval boolean @

---@class GuildAutoApprovalApplyRes
---@field error_code ErrorCode @

---@class GuildEnterNotifyInfo
---@field guild_id int64 @
---@field guild_name string @

---@class GuildQuitArg

---@class GuildQuitRes
---@field error_code ErrorCode @

---@class GuildRoleFreezeContributeDbInfo
---@field role_id uint64 @
---@field guild_id int64 @
---@field cur_contribute int64 @
---@field total_contribute int64 @
---@field mtime uint64 @

---@class GuildIconChangeArg
---@field icon_id number @

---@class GuildIconChangeRes
---@field error_code ErrorCode @

---@class GuildKickOutNotifyInfo
---@field guild_id int64 @
---@field guild_name string @

---@class GuildGetNewsInfoArg

---@class GuildGetNewsInfoRes
---@field error_code ErrorCode @
---@field news_list AnnounceData__Array @

---@class GuildNewsPbInfo
---@field type number @
---@field args LocalizationNameContainer @

---@class GuildPermissionDbInfo
---@field permission number @
---@field permission_name string @

---@class GuildPermissionInfo
---@field permission number @
---@field permission_name string @

---@class GuildPermissionNameChangeArg
---@field permission_list GuildPermissionInfo__Array @

---@class GuildPermissionNameChangeRes
---@field error_info ErrorInfo @

---@class GuildGetBuildingInfoArg

---@class GuildGetBuildingInfoRes
---@field result ErrorCode @
---@field buildings GuildBuildingInfo__Array @
---@field cur_money int64 @
---@field self_had_built boolean @

---@class GuildBuildingInfo
---@field level number @建筑等级
---@field id number @
---@field is_upgrading boolean @是否正在升级
---@field upgrade_left_time number @升级剩余时间
---@field start_time uint64 @升级开始时间，存DB用，客户端不读

---@class GuildUpBuildingLevelArg
---@field building_id number @

---@class GuildUpBuildingLevelRes
---@field result ErrorInfo @

---@class GuildDonateMaterialsArg
---@field building_id number @

---@class GuildDonateMaterialsRes
---@field result ErrorCode @
---@field left_time number @

---@class GuildDonateMoneyArg
---@field building_id number @

---@class GuildUpgradeNotifyData
---@field buildings GuildBuildingInfo @

---@class GuildDonateMoneyRes
---@field result ErrorCode @
---@field left_time number @

---@class GuildBuildingDbInfo
---@field building_list GuildBuildingInfo__Array @

---@class RemoveGuildRoleFreezeContributeFromDbInfo
---@field role_id int64 @
---@field mtime uint64 @

---@class GuildRoleContributeSyncNotifyInfo
---@field role_id uint64 @
---@field guild_id int64 @
---@field cur_contribute int64 @

---@class GuildSceneRewardNotifyInfo
---@field guild_id int64 @
---@field scene_uuid number @
---@field reward_id number @

---@class GuildGiveItemArg
---@field item_uid uint64 @
---@field item_id number @
---@field item_count number @
---@field is_all boolean @是否全部上交

---@class GuildGiveItemRes
---@field item_id number @
---@field item_count number @
---@field add_guild_money int64 @
---@field add_base_exp int64 @
---@field add_guild_contribution int64 @
---@field error_code ErrorCode @
---@field guild_organization number @公会组织力

---@class GuildGetWelfareArg
---@field role_uid uint64 @

---@class GuildGetWelfareRes
---@field welfare int64 @可领取的福利
---@field is_award boolean @是否领取过
---@field error_code ErrorCode @

---@class GuildWelfareAwardArg
---@field role_uid uint64 @

---@class GuildWelfareAwardRes
---@field error_code ErrorCode @
---@field is_award boolean @是否领取过
---@field award_welfare int64 @领取的福利数

---@class GuildNewsAddNotifyInfo
---@field guild_id int64 @
---@field guild_news AnnounceData @

---@class GuildEmailSendArg
---@field content string @

---@class GuildEmailSendRes
---@field error_code ErrorCode @

---@class GuildInviteJoinArg
---@field aimPlayerId uint64 @

---@class GuildInviteJoinRes
---@field error_code ErrorCode @

---@class GuildInviteNotifyInfo
---@field playerId uint64 @
---@field playerName string @
---@field playerLv number @
---@field guildId int64 @
---@field guildName string @
---@field can_enter_guild boolean @

---@class GuildCrystalSystemDbInfo
---@field crystal_list GuildCrystalPbInfo__Array @
---@field cur_upgrade_crystal number @
---@field upgrade_start_time int64 @
---@field quick_upgrade_used_count number @
---@field give_energy_free_used_count number @
---@field give_energy_crystal_list number__Array @
---@field give_energy_start_time int64 @
---@field buff_list GuildCrystalBuffPbInfo__Array @

---@class GuildCrystalGetInfoArg

---@class GuildCrystalGetInfoRes
---@field error_code ErrorCode @
---@field all_info GuildCrystalAllInfo @

---@class GuildCrystalPbInfo
---@field id number @
---@field level number @
---@field exp int64 @

---@class GuildCrystalLearnArg
---@field id number @

---@class GuildCrystalLearnRes
---@field error_code ErrorCode @

---@class GuildCrystalQuickUpgradeArg
---@field id number @

---@class GuildCrystalQuickUpgradeRes
---@field error_code ErrorCode @

---@class GuildCrystalPrayArg
---@field id number @
---@field cost_type number @

---@class GuildCrystalPrayRes
---@field error_code ErrorCode @
---@field attr_list GuildCrystalAttrInfo__Array @
---@field buff_left_time number @

---@class GuildCrystalGiveEnergyArg
---@field type number @

---@class GuildCrystalGiveEnergyRes
---@field error_code ErrorCode @

---@class GuildInfo
---@field role_uid uint64 @
---@field guild_info GuildAllInfo @
---@field guild_members GuildGmMembersInfo @

---@class GuildCrystalPrayCostArg
---@field rpcid number @
---@field remove_items RoleItemChangeInfo__Array @
---@field attr_list GuildCrystalAttrInfo__Array @

---@class GuildCrystalPrayCostRes
---@field error_code ErrorCode @

---@class GuildCrystalAttrInfo
---@field attr_type number @
---@field attr_value number @
---@field attr_extra_value number @
---@field is_appointed boolean @

---@class GuildCrystalAllInfo
---@field crystal_list GuildCrystalPbInfo__Array @
---@field cur_upgrade_crystal number @
---@field upgrade_left_time number @
---@field quick_upgrade_used_count number @
---@field give_energy_free_used_count number @
---@field give_energy_crystal_list PBint32__Array @
---@field give_energy_left_time number @
---@field attr_list GuildCrystalAttrInfo__Array @
---@field buff_left_time number @

---@class GuildCrystalBuffPbInfo
---@field role_id uint64 @
---@field attr_list GuildCrystalAttrInfo__Array @
---@field outdate_time int64 @

---@class GuildGiftGetInfoArg

---@class GuildGiftGetInfoRes
---@field error_code ErrorCode @
---@field gift_count number @
---@field gift_total_count number @
---@field gift_week_type PBint32__Array @
---@field gift_week_count PBint32__Array @

---@class GuildGiftHandOutArg
---@field role_list PBuint64__Array @

---@class GuildGiftHandOutRes
---@field error_code ErrorCode @

---@class GuildServerDbInfo
---@field last_refresh_time int64 @
---@field gift_receive_list uint64__Array @
---@field guild_quit_member_list uint64__Array @
---@field guild_quit_time_list int64__Array @
---@field person_award_list GuildPersonAwardList__Array @

---@class GuildGiftAddNotifyInfo
---@field role_id uint64 @
---@field guild_id int64 @
---@field source_type number @
---@field gift_count number @

---@class GuildMemberExtraParamChangeNotifyInfo
---@field role_id uint64 @
---@field type number @
---@field value int64 @

---@class GuildCountDbInfo
---@field count_type_list number__Array @
---@field count_id_list int64__Array @
---@field count_value_list int64__Array @

---@class GuildHuntDbInfo
---@field guild_hunt_list GuildHuntGuildDbInfo__Array @
---@field join_role_list uint64__Array @
---@field join_count_list number__Array @
---@field last_refresh_time int64 @

---@class GuildHuntGetInfoArg

---@class GuildHuntGetInfoRes
---@field error_code ErrorCode @
---@field state number @
---@field open_cd number @
---@field left_time number @
---@field open_used_count number @
---@field open_max_count number @
---@field reward_used_count number @
---@field reward_max_count number @
---@field seal_piece_used_times number @封印碎片使用次数
---@field is_get_final_reward boolean @
---@field dungeon_list GuildHuntDungeonPbInfo__Array @
---@field score_list GuildHuntScorePbInfo__Array @
---@field self_score GuildHuntScorePbInfo @
---@field has_additional_hunt_count number @是否有额外的狩猎次数 0没有 1有可开启 2开启过了

---@class GuildHuntDungeonPbInfo
---@field type number @
---@field id number @
---@field cur_count number @
---@field max_count number @

---@class GuildHuntScorePbInfo
---@field member_info MemberBaseInfo @
---@field score number @
---@field rank number @
---@field simple_count number @简单难度次数
---@field common_count number @普通难度次数
---@field difficult_count number @困难难度次数

---@class GuildHuntOpenRequestArg

---@class GuildHuntOpenRequestRes
---@field error_code ErrorCode @

---@class GuildHuntOpenNotifyInfo

---@class GuildHuntDungeonUpdateNotifyInfo
---@field dungeon_list GuildHuntDungeonPbInfo__Array @

---@class GuildHuntDungeonUpdateNotifyToGsInfo
---@field scene_uuid number @
---@field dungeon_list GuildHuntDungeonPbInfo__Array @

---@class GuildHuntDungeonCloseNotifyToGsInfo
---@field scene_uuid number @

---@class GuildHuntDungeonOpenNotifyToGsInfo
---@field scene_uuid number @
---@field close_time int64 @
---@field dungeon_list GuildHuntDungeonPbInfo__Array @

---@class GuildHuntGetFinalRewardArg

---@class GuildHuntGetFinalRewardRes
---@field error_code ErrorCode @

---@class GuildHuntDungeonFinishArg
---@field dungeon_id number @
---@field guild_id int64 @
---@field role_list uint64__Array @
---@field pass_time number @

---@class GuildHuntDungeonFinishRes
---@field error_code ErrorCode @
---@field role_reward_list uint64__Array @
---@field role_full_reward_list uint64__Array @
---@field role_full_score_list uint64__Array @

---@class GuildHuntGuildDbInfo
---@field guild_id int64 @
---@field close_time int64 @
---@field member_list GuildHuntMemberDbInfo__Array @
---@field dungeon_list GuildHuntDungeonPbInfo__Array @
---@field seal_piece_used_times number @
---@field guild_score number @
---@field guild_score_simple number @

---@class GuildHuntMemberDbInfo
---@field member_id uint64 @
---@field reward_count number @
---@field score_count number @
---@field score number @
---@field final_reward boolean @
---@field is_join boolean @
---@field simple_count number @
---@field common_count number @
---@field difficult_count number @

---@class GetCobblestoneInfo

---@class GetCobblestoneInfoArg
---@field role_id uint64 @

---@class GetCobblestoneInfoRes
---@field error ErrorCode @
---@field can_still_carve number @
---@field carve_info GuildStoneCarveInfo @

---@class CarveStoneArg
---@field be_helped_role_id uint64 @

---@class CarveStoneRes
---@field error ErrorCode @
---@field carver_id uint64 @

---@class AskForCarveStoneArg

---@class AskForCarveStoneRes
---@field error ErrorInfo @

---@class MakeStoneArg

---@class MakeStoneRes
---@field error ErrorCode @

---@class CobbleStoneHelpData
---@field role_id uint64 @

---@class CobbleStoneHelpForwardData
---@field data CobbleStoneHelpData @
---@field session_ids PBuint64__Array @

---@class GuildStoneInfo
---@field owner_id uint64 @
---@field is_cur_stone_award_received boolean @
---@field is_souvenir_stone_award_received boolean @
---@field souvenir_coin_num number @纪念币
---@field souvenir_crystal_num number @纪念晶石数量
---@field souvenir_crystal_harvest_times number @纪念晶石收获次数
---@field cur_carver GuildStoneCarverInfo__Array @本次记录
---@field history_carver GuildStoneCarverInfo__Array @历史记录
---@field ask_private_help_list PBuint64__Array @私人求助名单
---@field last_ask_public_help_time number @
---@field help_other_list uint64__Array @帮助他人记录
---@field souvenir_crystal_assign_list uint64__Array @纪念晶石分配给他人名单
---@field souvenir_crystal_receive_list uint64__Array @纪念晶石分配给自己名单

---@class GuildStoneDBInfo
---@field guild_stone_info GuildStoneInfo__Array @

---@class SyncGuildStoneToMsArg
---@field stone Item__Array @

---@class SyncGuildStoneToMsRes
---@field code ErrorCode @

---@class CobblleStoneCarvedNtfData
---@field carver_name string @
---@field carver_uid uint64 @

---@class GuildBindingRemindArg

---@class GuildBindingRemindRes
---@field result ErrorCode @
---@field chairman_uid uint64 @
---@field chairman_account string @

---@class GetGuildChairmanInfoArg
---@field role_uid uint64 @
---@field rpc_id number @

---@class GetGuildChairmanInfoRes
---@field result ErrorCode @
---@field chairman_account string @
---@field chairman_uid uint64 @

---@class GuildBindingData
---@field binding_time uint64 @

---@class GuildBindingArg

---@class GuildBindingRes
---@field result ErrorCode @

---@class GuildRepoAttention
---@field roleids uint64__Array @角色id

---@class GuildRepoAuctionInfo
---@field roleoffer GuildRepoAuctionRoleInfo__Array @角色出价信息

---@class GuildRepoCell
---@field itemid number @
---@field itemuuid uint64 @
---@field attentionlist GuildRepoAttention @关注列表
---@field createtime uint64 @进入仓库的时间

---@class GuildRepo
---@field cells GuildRepoCell__Array @仓库格子
---@field lastauctionstarttime uint64 @最后一次拍卖开始时间
---@field auctionrecords GuildAuctionRecordPublic__Array @拍卖成功记录,按时间3个月过期去除
---@field auctionitems GuildAuctionItem__Array @所有正在拍卖的东西
---@field itemidgenerate uint64 @自增id记录
---@field tempsuccessrecord GuildAuctionRecordPublic__Array @个人领取的私人记录.拍卖成功
---@field tempfailedrecord GuildAuctionRecordPublic__Array @个人领取的失败记录

---@class GuildAuctionRecordPublic
---@field itemid number @
---@field itemuuid uint64 @
---@field roleid uint64 @买主的roleid
---@field time uint64 @发生的时间戳
---@field cost number @花费的公会贡献
---@field rolename string @买主的名字

---@class GuildRepoRoleView
---@field maxcellcount number @当前仓库容量,根据公会仓库建筑等级解锁
---@field cells GuildRepoCellRoleView__Array @仓库格子里的东西
---@field auctions GuildAuctionRoleView @拍卖物品信息
---@field nextauctiontime uint64 @下一次开放拍卖的时间,或者结束拍卖的时间点,有没有拍卖靠拍卖列表为空判断
---@field publicrecords GuildAuctionRecordRoleView @公共拍卖记录

---@class GuildRepoCellRoleView
---@field itemid number @
---@field itemuuid uint64 @
---@field isattention boolean @true表示关注

---@class GuildAuctionRoleView
---@field items GuildAuctionItemRoleView__Array @

---@class GuildAuctionItemRoleView
---@field itemid number @
---@field itemuuid uint64 @
---@field myprice number @玩家的出价
---@field lastchangepricetime uint64 @最后一次改价格的时间戳
---@field baseprice number @底价
---@field isattention boolean @true表示已经关注
---@field lastcancletime uint64 @上次取消的时间点,初始0

---@class GuildAuctionRecordRoleView
---@field publicrecords GuildAuctionRecordPublic__Array @公共拍卖记录,个人记录在roleallinfo里

---@class GetGuildRepoInfo

---@class GetGuildRepoInfoReq

---@class GetGuildRepoInfoRsp
---@field guildrepo GuildRepoRoleView @公会仓库,内含拍卖界面
---@field errcode ErrorCode @

---@class GuildRepoRemoveItemReq
---@field itemuuid uint64 @

---@class GuildRepoRemoveItemRsp
---@field errcode ErrorCode @

---@class GuildAuctionSetPriceReq
---@field itemuuid uint64 @道具的uuid
---@field newoffer number @新价格 0表示取消竞价

---@class GuildAuctionSetPriceRsp
---@field errcode ErrorCode @
---@field itemuuid uint64 @
---@field newprice number @
---@field oldprice number @用新旧价格来做剪刀差
---@field nextcdtime uint64 @根据错误码,返回时间戳.

---@class GuildRepoAuctionRoleInfo
---@field roleid uint64 @
---@field offer number @角色出价
---@field changetime uint64 @更改价格时间戳
---@field rolename string @角色名字
---@field giveuptime uint64 @放弃时间戳,也有延迟
---@field lastsettime uint64 @最后一次设置价格时间

---@class GuildRepoSetAttentionReq
---@field itemuuid uint64 @
---@field isattention boolean @true表示添加关注

---@class GuildRepoSetAttentionRsp
---@field errcode ErrorCode @
---@field isattention boolean @操作结果

---@class GetGuildAuctionPersonalRecordReq

---@class GetGuildAuctionPersonalRecordRsp
---@field personalrecords RoleGuildAuctionRecord @
---@field errcode ErrorCode @

---@class GuildAuctionItem
---@field itemid number @
---@field itemuuid uint64 @
---@field auctions GuildRepoAuctionInfo @所有出价人信息
---@field createtime uint64 @创建时间
---@field attentionlist GuildRepoAttention @关注列表,从仓库里带来.

---@class GetGuildAuctionPublicRecordReq

---@class GetGuildAuctionPublicRecordRsp
---@field records GuildAuctionRecordRoleView @公共记录
---@field errcode ErrorCode @

---@class GetGuildAuctionContrReq
---@field roleid uint64 @
---@field oldoffer number @
---@field newoffer number @

---@class GetGuildAuctionContrRsp
---@field errcode ErrorCode @
---@field roleid uint64 @
---@field oldoffer number @
---@field newoffer number @

---@class GuildCrystalCheckAnnounceArg
---@field announce_id number @

---@class GuildCrystalCheckAnnounceRes
---@field error_code ErrorCode @

---@class GetJoinGuildTimeReq

---@class GetJoinGuildTimeRsp
---@field errcode ErrorCode @
---@field jointime uint64 @加入公会的时间点

---@class GuildItemUseNtfData
---@field item_id number @
---@field count number @
---@field user_uid uint64 @

---@class GuildHuntFindTeamMateArg

---@class GuildHuntFindTeamMateRes
---@field error_code ErrorCode @
---@field member_list GuildHuntFindMemberInfo__Array @

---@class GuildHuntFindMemberInfo
---@field score number @成员得分
---@field remain_count number @剩余狩猎次数
---@field member MemberBaseInfo @

---@class GuildHuntSealPieceCountData
---@field seal_piece_count number @

---@class GuildHuntFinishNtfData

---@class GuildMatchDbInfo
---@field match_info_list GuildMatchPbInfo__Array @
---@field status number @
---@field pair GuildMatchPair__Array @

---@class GetGuildFlowersArg
---@field type number @1参战报名，2啦啦队报名
---@field flowers_count number @鲜花数量

---@class GetGuildFlowersRes
---@field result ErrorCode @

---@class GuildBattleTeamApplyArg
---@field type number @1参战报名，2啦啦队报名

---@class GuildBattleTeamApplyRes
---@field result ErrorCode @
---@field time_err_role_name string @入会时间不足的角色名称
---@field time number @
---@field guild_err_role_name string @不是公会成员的角色名称

---@class CandidateTeamInfo
---@field team_uuid number @队伍伪id
---@field battle_order number @队伍参战顺序
---@field member_list MemberBaseInfo__Array @队伍成员信息

---@class GuildBattleInfo
---@field guild_id number @
---@field flower_count number @当前鲜花数量
---@field win_or_not number__Array @每轮胜负情况

---@class GuildTeamRoundResult
---@field score number @最终分数
---@field win_or_not number @胜负情况
---@field mvp_role_name string @mvp玩家名称

---@class GuildBattleResult
---@field guild_id number @
---@field icon_id number @图标id
---@field team_result GuildTeamRoundResult__Array @每轮队伍胜负结果信息
---@field guild_name string @

---@class GetGuildBattleMgrTeamInfoArg

---@class GetGuildBattleMgrTeamInfoRes
---@field team_info CandidateTeamInfo__Array @参赛队伍信息
---@field result ErrorCode @

---@class GetGuildBattleTeamInfoArg
---@field type number @1参战队伍候选信息，2获取啦啦队候选信息

---@class GetGuildBattleTeamInfoRes
---@field team_info CandidateTeamInfo__Array @候选池队伍信息
---@field result ErrorCode @

---@class ChangeGuildBattleTeamArg
---@field battle_team number__Array @参赛队伍id

---@class ChangeGuildBattleTeamRes
---@field result ErrorCode @

---@class MgrTeamInfo
---@field team_info CandidateTeamInfo__Array @队伍管理界面信息
---@field handler_name string @管理员名字

---@class GetGuildBattleWatchInfoArg

---@class GetGuildBattleWatchInfoRes
---@field guild_battle_info GuildBattleInfo__Array @鲜花和胜场信息

---@class GuildFlowerChangeInfo
---@field guild_battle_info GuildBattleInfo__Array @

---@class BattleResultInfo
---@field camp1 GuildBattleResult @阵营1信息
---@field camp2 GuildBattleResult @阵营2信息

---@class GuildBattleTeamReApplyArg
---@field type number @队伍类型

---@class GuildBattleTeamReApplyRes
---@field result ErrorCode @
---@field time_err_role_name string @加入公会时间不足玩家名称
---@field time number @
---@field guild_err_role_name string @不是公会成员玩家名称

---@class EnterGuildMatchWaitingRoomRequestArg

---@class EnterGuildMatchWaitingRoomRequestRes
---@field result ErrorCode @

---@class ApplyResult
---@field result ErrorCode @公会赛报名结果

---@class TeamCacheInfo
---@field role_info RoleIdAndName__Array @id和名字

---@class GiveGuildFlowerArg
---@field guild_id int64 @
---@field num number @

---@class GiveGuildFlowerRes
---@field error_code ErrorCode @

---@class GameBattleResultInfo
---@field win_guild_id int64 @获胜公会id
---@field lose_guild_id int64 @失败公会id

---@class GuildMatchResultNftToMsData
---@field score number @分数
---@field result_status DungeonsResultStatus @胜负平情况
---@field guild_id int64 @
---@field mvp_role_id uint64 @

---@class GetGuildBattleResultArg

---@class GetGuildBattleResultRes
---@field camp1 GuildBattleResult @
---@field camp2 GuildBattleResult @

---@class CanditateTeamBrief
---@field battle_order number @
---@field team_uuid number @
---@field role_list uint64__Array @

---@class GuildMatchPbInfo
---@field guild_id int64 @
---@field competition_guild_id int64 @
---@field choosed_team_uuid number__Array @
---@field team_cache_id number @
---@field team_brief CanditateTeamBrief__Array @

---@class SendGuildMatchMsgData
---@field guild_score GuildScorePair__Array @

---@class GuildScorePair
---@field guild_id int64 @
---@field score number @

---@class GuildStoneCarveInfo
---@field is_stone_award_received boolean @纪念币奖励是否已经领取
---@field is_souvenir_stone_award_received boolean @精致的纪念币奖励是否已领取
---@field souvenir_coin_num number @纪念币数量
---@field souvenir_crystal_num number @纪念晶石数量
---@field cur_carve_info GuildStoneCarverInfo__Array @本次记录
---@field his_carve_info GuildStoneCarverInfo__Array @历史记录
---@field helpe_other_times number @帮助他人次数
---@field to_tomorrow_five_time number @冷却到第二天5点的时间剩余时间
---@field show_roles GuildStoneCarverInfo__Array @首页展示的协助雕刻者

---@class AskForPersonalCarveStoneArg
---@field role_id uint64 @

---@class AskForPersonalCarveStoneRes
---@field error_code ErrorCode @

---@class GuildStoneCarverInfo
---@field carver_id uint64 @雕刻者id
---@field carver_name string @雕刻者姓名
---@field base_level number @基础等级
---@field profession number @职业
---@field permission_info GuildPermissionInfo @公会职位
---@field outlook MemberOutLook @头像
---@field carve_time number__Array @雕刻时间
---@field carve_progress number @雕刻进度
---@field is_assigned_souvenir_crystal boolean @是否已分配晶石
---@field is_helped boolean @是否已帮助
---@field is_asked_help boolean @是否已求助

---@class GuildStoneHelper
---@field role_id uint64 @
---@field name string @
---@field base_level number @
---@field permission_info GuildPermissionInfo @职位
---@field helped_times number @帮助次数[x天内]
---@field friend_degree number @友好度
---@field is_assigned_souvenir_crystal boolean @是否已经分配纪念晶石
---@field is_assigned_full boolean @被分配者是否已分配满

---@class GetGuildStoneHelperArg

---@class GetGuildStoneHelperRes
---@field error_code ErrorCode @
---@field helpers GuildStoneHelper__Array @
---@field rest_souvenir_crystal_num number @剩余纪念晶石数量

---@class MakeSouvenirStoneARG

---@class MakeSouvenirStoneRes
---@field error_code ErrorCode @

---@class AssignSouvenirCrystalArg
---@field role_list uint64__Array @

---@class AssignSouvenirCrystalRes
---@field error_code ErrorCode @
---@field role_not_same_guild uint64__Array @

---@class GuildGmMemberBaseInfo
---@field role_uid uint64 @
---@field role_name string @
---@field role_type RoleType @
---@field base_level number @
---@field job_level number @
---@field join_time int64 @
---@field cur_contribute int64 @当前贡献
---@field total_contribute int64 @总贡献
---@field achievement_point number @成就点
---@field active_point int64 @活跃度
---@field last_logout_time int64 @最后登出时间

---@class GuildSeasonDbInfo
---@field state number @赛季状态
---@field start_time uint64 @赛季开始时间
---@field end_time uint64 @赛季结束时间
---@field season_count number @第x赛季

---@class GuildRankScoreUnitData
---@field rank_score_type GuildRankScoreType @积分类型
---@field score_value number @积分
---@field last_season_rank number @上赛季排名(0是没有荣耀)
---@field current_royal_type GuildRoyalType @当前赛季精英/荣誉组
---@field last_royal_type GuildRoyalType @上赛季精英组/荣誉组

---@class GuildGmMembersInfo
---@field member_list GuildGmMemberBaseInfo__Array @

---@class GuildNewsTlogData
---@field op_type number @1:点赞,2:附议
---@field news_type number @信息类型
---@field zd_or_not number @是否置顶
---@field news_player uint64 @新闻当事人

---@class GuildRankScoreDBInfo
---@field data_list GuildRankScoreUnitData__Array @所有产出积分和排名

---@class GuildRankActivityArg

---@class GuildRankActivityRes
---@field result ErrorCode @
---@field royal_info GuildRankScoreDBInfo @积分和荣耀列表
---@field current_season number @当前第x赛季
---@field season_end_time uint64 @赛季结束时间

---@class GetGuildOrganizationRankRes
---@field errcode ErrorCode @
---@field member_list GuildMemberOrganizationList__Array @

---@class GuildMemberOrganizationList
---@field rank number @排名
---@field member_base_info MemberBaseInfo @外显信息
---@field organization_contribute number @组织力贡献值

---@class GetGuildOrganizationInfoRes
---@field errcode ErrorCode @
---@field guild_organization number @组织力总贡献
---@field personal_award_list number__Array @已经领取奖励的key

---@class GuildItemOrganizationList
---@field guild_item_id number @公会物品id
---@field count number @上交的公会物品个数
---@field organization number @公会获得的组织力

---@class GuildOrganizationDbInfo
---@field guild_organization number @公会总的组织力
---@field guild_item_list GuildItemOrganizationList__Array @上交的公会物品及获得的组织力
---@field member_organization_list MemberOrganization__Array @成员贡献
---@field has_additional_hunt_count_ number @额外的狩猎次数 0无 1有可开启 2开启过了
---@field award_ number__Array @
---@field hunt_max_count number @
---@field person_award_list GuildPersonAwardList__Array @

---@class MemberOrganization
---@field role_id int64 @
---@field organization number @

---@class CheckGuildDinnerOpenRes
---@field errcode ErrorCode @
---@field is_open boolean @

---@class ActivityData
---@field end_time number @
---@field round number @
---@field type number @

---@class GuildBeautyUpdateNtfArg
---@field guild_id int64 @
---@field scene_unique_id number @
---@field type number @操作类型, 1新建/2删除/3更新
---@field role_id uint64 @
---@field mirror_data FetchMirrorRoleDataRes @镜像数据

---@class GetGuildOrganizationPersonalAwardArg
---@field award_stage number @

---@class GetGuildOrganizationPersonalAwardRes
---@field err ErrorCode @

---@class GuildOrganizePersonAwardList
---@field role_id int64 @
---@field award_list number__Array @

---@class GuildPersonAwardList
---@field role_id int64 @
---@field award_list MapKeyValue__Array @

---@class GuildOrganizePersonAwardNtfRes
---@field award_list number__Array @

---@class GuildHuntCloseNtf2GsInfo
---@field scene_uid int64 @

---@class GuildMatchConveneArg

---@class GuildMatchConveneRes
---@field result ErrorCode @

---@class GuildTodayMoney
---@field today_money int64 @工会今日资金获取

---@class GuildDinnerViewMenuArg

---@class GuildDinnerViewMenuRes
---@field error_code ErrorCode @
---@field menu_list GuildDinnerMenuPbInfo__Array @

---@class GuildDinnerMenuPbInfo
---@field rank number @
---@field dish_count number @
---@field cost_time int64 @
---@field member_list GuildMemberDetailInfo__Array @
---@field score number @得分

---@class GuildDinnerDishPrepareNotifyInfo
---@field scene_uuid number @
---@field start_time int64 @
---@field end_time int64 @

---@class GuildDinnerTaskAcceptArg
---@field npc_uuid uint64 @

---@class GuildDinnerTaskAcceptRes
---@field error_code ErrorCode @

---@class GuildDinnerCookDungeonResultNotifyInfo
---@field guild_id int64 @
---@field role_list uint64__Array @
---@field dish_count number @
---@field cost_time int64 @
---@field score number @烹饪得分
---@field time_buff_trigger_count number @
---@field immeadiate_count number @
---@field urgent_menu_trigger_count number @
---@field urgent_menu_finish_count number @
---@field perfect_pot_count number @

---@class GuildDinnerEatDishNotifyInfo
---@field guild_id int64 @
---@field scene_uuid number @
---@field start_time int64 @
---@field end_time int64 @
---@field eat_time int64 @
---@field eat_index number @
---@field dish_count number @
---@field makers NamePair__Array @
---@field cost_time int64 @

---@class GuildDinnerAddEventNotifyInfo
---@field guild_id int64 @
---@field scene_uuid number @
---@field start_time int64 @
---@field end_time int64 @
---@field event_index number @

---@class GuildDinnerTaskFinishedNotifyInfo
---@field guild_id int64 @
---@field role_id uint64 @
---@field partner_id uint64 @
---@field announce_id number @

---@class GuildDinnerGetDishNPCStateArg
---@field role_id uint64 @

---@class GuildDinnerGetDishNPCStateRes
---@field error_code ErrorCode @
---@field start_time int64 @
---@field end_time int64 @
---@field eat_time int64 @
---@field can_eat boolean @
---@field dish_count number @
---@field makers NamePair__Array @
---@field cost_time int64 @

---@class GuildDinnerEatDishArg
---@field role_id uint64 @

---@class GuildDinnerEatDishRes
---@field error_code ErrorCode @
---@field item ItemBrief @多倍奖励物品详情(触发多倍才发)

---@class GuildDinnerGetCookingNPCStateArg
---@field role_id uint64 @

---@class GuildDinnerGetCookingNPCStateRes
---@field error_code ErrorCode @
---@field start_time int64 @
---@field end_time int64 @
---@field is_dish_prepare boolean @

---@class GuildDinnerTaskRewardNotifyInfo
---@field scene_uuid number @
---@field role_uid uint64 @
---@field partner_uid uint64 @

---@class GuildDinnerActiveStartNotifyInfo
---@field scene_uuid number @
---@field start_time int64 @
---@field end_time int64 @
---@field melee_start_time int64 @
---@field melee_real_start_time int64 @
---@field melee_end_time int64 @
---@field dinner_type number @宴会类型(1工作日/2周末)

---@class GuildDinnerCookingStartNotifyInfo
---@field scene_uuid number @
---@field start_time int64 @
---@field end_time int64 @

---@class GuildDinnerShareDishArg
---@field dish_uuid uint64 @

---@class GuildDinnerShareDishRes
---@field error ErrorInfo @

---@class GuildDinnerShareDishNtfData
---@field names string @
---@field role_id uint64 @
---@field dish_count number @
---@field session_ids PBuint64__Array @
---@field dish_uuid uint64 @

---@class NamePair
---@field role_id uint64 @
---@field name string @

---@class GuildDinnerGetPhotoAwardArg
---@field role_id uint64 @

---@class GuildDinnerGetPhotoAwardRes
---@field error ErrorCode @

---@class GuildDinnerCreamMeleeRenshuArg

---@class GuildDinnerCreamMeleeRenshuData
---@field total_count number @
---@field alive_count number @

---@class GuildDinnerOpenChampagneData
---@field role_id uint64 @
---@field role_name string @

---@class GuildDinnerOpenChampagneRes
---@field result ErrorInfo @

---@class GuildDinnerOpenChampagneArg
---@field use_item boolean @
---@field guild_id int64 @

---@class GuildDinnerActiveEndNotifyData

---@class GuildDinnerGetCompetitionResultArg

---@class GuildDinnerGetCompetitionResultRes
---@field competiton_list GuildDinnerCompetitionRes__Array @公会宴会比赛成绩
---@field error ErrorCode @

---@class GuildDinnerGetPersonResultArg
---@field is_personal number @0表示拉参与比赛的公会成员成绩,1表示拉本公会成员成绩

---@class GuildDinnerGetPersonResultRes
---@field person_list GuildDinnerPersonRes__Array @个人成绩
---@field error ErrorCode @

---@class GuildDinnerCompetitionRes
---@field icon_id number @公会icon_id
---@field guild_name string @公会名称
---@field guild_score number @公会宴会比赛得分
---@field member_list MemberBaseInfo__Array @排名第一的两人组
---@field rank number @本次比赛排名

---@class GuildDinnerRandomEventNtfData
---@field event_start_time int64 @0代表结束，非0代表开始时间

---@class GuildDinnerPersonRes
---@field rank number @个人排名
---@field member_list string__Array @二人组姓名
---@field guild_name string @公会名称
---@field score number @烹饪得分
---@field count number @菜数
---@field time int64 @所用时间

---@class GuildDinnerRequestRewardAdditionArg
---@field percent_num number @公会排名
---@field guild_id int64 @公会id

---@class GuildDinnerRequestRewardAdditionRes
---@field addition_num number @额外奖励基数

---@class GuildDinnerAwardPrizeArg
---@field item_list ItemBrief__Array @奖励物品
---@field role_id uint64 @
---@field rank number @
---@field title_name string @

---@class GuildDinnerAwardPrizeRes
---@field error ErrorCode @

---@class GuildDinnerOpenChampagne2GsData
---@field guild_id int64 @
---@field role_id uint64 @

---@class EquipItemArg
---@field uid uint64 @装备id
---@field pos number @装备的格子位置

---@class EquipItemRes
---@field error ErrorCode @

---@class TakeOffEquipRes
---@field error ErrorCode @

---@class TakeOffEquipArg
---@field uid uint64 @

---@class UnlockBlankArg
---@field type BagType @

---@class UnlockBlankRes
---@field error ErrorCode @

---@class JunkItemArg
---@field uid uint64 @
---@field type BagType @

---@class JunkItemRes
---@field error ErrorCode @

---@class MoveItemArg
---@field uid uint64 @移动的物品uid
---@field from_type BagType @
---@field to_type BagType @
---@field count number @移动的数量
---@field pos number @如果移动跟快捷栏有关的话，表示在快捷栏的位置
---@field from_page number @如果是仓库 就是页码数
---@field to_page number @

---@class MoveItemRes
---@field error ErrorCode @

---@class ClearTeamBagArg

---@class ClearTeamBagRes
---@field error ErrorCode @

---@class FetchTempBagArg

---@class FetchTempBagRes
---@field error ErrorCode @

---@class UseItemArg
---@field uid uint64 @
---@field count uint64 @
---@field type BagType @
---@field item_id number @
---@field operate_type number @0是背包内操作  1是tips操作

---@class UseItemRes
---@field error ErrorInfo @

---@class DropInfo
---@field drops Item__Array @

---@class ItemChange
---@field change_items ItemChangeInfo__Array @
---@field add_items ItemChangeInfo__Array @
---@field remove_items ItemChangeInfo__Array @
---@field change_virtual_items VirtualItemChangeInfo__Array @
---@field exp_items ExpItemChangeInfo__Array @
---@field reason ItemChangeReason @
---@field is_new_loot boolean @
---@field infos LoadInfo__Array @
---@field extra_base_exp int64 @今日健康战斗折算的经验
---@field extra_job_exp int64 @今日健康战斗折算的job经验
---@field extra_fight_time number @每日额外战斗时间
---@field revenue_items RevenueItemChangeInfo__Array @野外战斗收益
---@field cur_equipment_page number @切换装备页的时候用
---@field tar_equipment_page number @

---@class ItemChangeInfo
---@field item Item @
---@field incr_value int64 @
---@field type BagType @
---@field page number @
---@field equip_page number @装备专用

---@class ChangeWarehouseNameArg
---@field page number @
---@field name string @

---@class ChangeWarehouseNameRes
---@field error ErrorCode @

---@class PickUpItemArg
---@field uuid uint64 @

---@class PickUpItemRes
---@field error ErrorCode @

---@class PickUpItemData
---@field role_id uint64 @
---@field item_uid uint64 @

---@class VirtualItemChangeInfo
---@field item VirtualItemData @虚拟物品
---@field incr_value int64 @增加减少的数值

---@class ExchangeMoneyArg
---@field source_item_id number @来源货币table_id
---@field dest_item_id number @兑换目标货币id
---@field counter number @需要消耗多少来源货币
---@field exchange_money_type ExchangeMoneyType @兑换类型（直接兑换、快速兑换）

---@class ExchangeMoneyRes
---@field result ErrorCode @兑换结果

---@class RequestShopItemArg
---@field shop_type number @商店类型
---@field refresh boolean @是否刷新

---@class RequestShopItemRes
---@field result ErrorCode @返回码
---@field shop ShopItems @商店详情
---@field refreshcount number @刷新次数

---@class BuyShopItem
---@field table_id number @商品表ID
---@field count number @对应商品购买几次

---@class BuyShopItemArg
---@field shop_type number @商店类型
---@field items BuyShopItem__Array @购买的商品s

---@class BuyShopItemRes
---@field error ErrorInfo @

---@class SellShopItem
---@field item_uid uint64 @贩卖道具uid
---@field count number @贩卖数量

---@class SellShopItemArg
---@field items SellShopItem__Array @贩卖道具s
---@field shop_id number @出售商店id
---@field black_market_type boolean @true代表黑市售出

---@class SellShopItemRes
---@field result ErrorCode @返回码

---@class TeleportItemData
---@field itemid number @传送道具id
---@field mapid number @目标场景id
---@field kapulaid number @目标卡普拉id

---@class SingleCookingFinishArg
---@field recipeid number @
---@field count number @
---@field qtesuccess boolean @true表示qte成功

---@class SingleCookingStartArg
---@field recipeid number @烹饪id
---@field count number @

---@class SingleCookingStartRes
---@field err ErrorCode @返回错误码
---@field qte CookingQte @参考宏定义

---@class SingleCookingFinishRes
---@field err ErrorCode @
---@field recipeid number @菜谱id
---@field resultcount number @获得总数量
---@field resultid number @奖励id

---@class ForgeEquipArg
---@field item_id number @打造装备id

---@class ForgeEquipRes
---@field error ErrorInfo @

---@class EquipRefineUpgradeArg
---@field item_uid uint64 @
---@field additional_type RefineAdditionalType @附加的物品类型

---@class EquipRefineUpgradeRes
---@field result ErrorCode @
---@field type RefineUpgradeResultType @

---@class EquipRefineRepairArg
---@field item_uid uint64 @

---@class EquipRefineRepairRes
---@field result ErrorCode @

---@class EquipEnchantArg
---@field enchant_type EnchantType @
---@field item_uid uint64 @

---@class EquipEnchantRes
---@field result ErrorCode @

---@class EquipEnchantConfirmArg
---@field item_uid uint64 @
---@field type number @

---@class EquipEnchantConfirmRes
---@field result ErrorCode @

---@class ItemPair
---@field item_id number @
---@field count number @
---@field fish_size number @鱼的大小具体值,精确小数点后1位

---@class AwardItem
---@field reason ItemChangeReason @
---@field items ItemPair__Array @

---@class ItemAwardNtfData
---@field awards AwardItem__Array @
---@field total_reason ItemChangeReason @

---@class AwardPreviewArg
---@field award_id number @奖励id
---@field real_get number @

---@class AwardPreviewRes
---@field result ErrorCode @执行的错误码
---@field award_list AwardContent__Array @奖励列表
---@field preview_type number @预览类型(0无预览,1顺序全读,2读item,3权重取一个,4价值全读
---@field preview_num number @预览数字
---@field preview_count number @道具数量

---@class AwardContent
---@field item_id number @奖励id
---@field count number @奖励数量
---@field drop_rate number @掉率
---@field is_particular boolean @是否特有
---@field is_bind boolean @是否绑定
---@field is_probably number @显示概率

---@class ExchangeHeadGearArg
---@field item_id number @

---@class ExchangeHeadGearRes
---@field error ErrorInfo @

---@class CardInsertArg
---@field equip_uid uint64 @装备uid
---@field card_uid uint64 @卡片uid
---@field pos number @插入卡片位置

---@class CardInsertRes
---@field result ErrorCode @返回码

---@class CardRemoveArg
---@field equip_uid uint64 @装备
---@field pos number @拆卡片的位置

---@class CardRemoveRes
---@field result ErrorCode @返回码

---@class HoleMakeArg
---@field equip_uid uint64 @装备uid

---@class HoleMakeRes
---@field result ErrorCode @返回码

---@class ItemUidPair
---@field item_uid uint64 @背包uid
---@field item_count number @数量不可为负数
---@field virtual_item_id number @虚拟物品id， 与item_uid互斥

---@class BagFullSendMailNtfData
---@field infos ItemPair__Array @
---@field info ErrorInfo @

---@class LifeEquipChangeArg
---@field equip LifeEquipItem__Array @装备

---@class LifeEquipChangeRes
---@field result ErrorCode @返回码

---@class ExpItemChangeInfo
---@field item_id number @
---@field item_count int64 @
---@field total_incr_value int64 @
---@field incr_list AwardExpData__Array @

---@class AwardExpData
---@field reason AwardExpReason @
---@field incr_value uint64 @增加值

---@class SortBagArg
---@field type BagType @

---@class SortBagRes
---@field error ErrorInfo @

---@class EquipCompoundArg
---@field uid_items ItemUidPair__Array @道具uid及数量 数量不可为负和零

---@class EquipCompoundRes
---@field result ErrorInfo @

---@class GetItemByUidArg
---@field item_uid uint64 @

---@class GetItemByUidRes
---@field result ErrorCode @
---@field item_content Item @
---@field ro_item_content Ro_Item @

---@class QueryItemByUidArg
---@field item_uid uint64 @
---@field delay_rpc number @

---@class QueryItemByUidRes
---@field result ErrorCode @
---@field item_content Ro_Item @

---@class MaterialsMechantArg
---@field wanted_item_id number @想要合成的材料id
---@field wanted_count number @
---@field prefer_use_bind boolean @优先使用绑定

---@class MaterialsMechantRes
---@field result ErrorInfo @

---@class AwardIDsData
---@field award_ids number__Array @
---@field reason ItemChangeReason @

---@class EquipEnchantRebornArg
---@field item_uid uint64 @

---@class EquipEnchantRebornRes
---@field result ErrorCode @

---@class EquipEnchantRebornPreviewArg
---@field item_uid uint64 @

---@class EquipEnchantRebornPreviewRes
---@field return_items MapInt32Int32__Array @返回的道具
---@field result ErrorCode @

---@class RecoveCardArg
---@field id_and_num MapKeyIntValue__Array @

---@class RecoveCardRes
---@field result ErrorInfo @
---@field id_and_num MapKeyIntValue__Array @

---@class ExtractCardArg
---@field type number @

---@class ExtractCardRes
---@field result ErrorInfo @
---@field card_id number @

---@class RecycleCardPreviewArg
---@field type number @

---@class RecycleCardPreviewRes
---@field cards RecycleCardData__Array @
---@field result ErrorCode @
---@field card_times number @抽卡次数

---@class RecycleCardData
---@field card_id number @
---@field is_new boolean @

---@class ChangeTrolleyArg
---@field trolley_id number @
---@field profession_id number @职业id

---@class ChangeTrolleyRes
---@field result ErrorCode @

---@class LoadInfo
---@field type BagType @
---@field max_load number @
---@field cur_load number @
---@field max_blank number @

---@class PreviewOrnamentData
---@field item_id number @装扮ID
---@field is_new boolean @是否是新品
---@field num number @

---@class PreviewOrnamentRes
---@field result ErrorCode @
---@field item_datas PreviewOrnamentData__Array @
---@field use_times number @使用次数

---@class PreviewOrnamentArg
---@field no_use boolean @无用的参数

---@class RecoveOrnamentArg
---@field item_uid PBuint64__Array @

---@class RecoveOrnamentRes
---@field result ErrorInfo @
---@field id_and_num MapKeyIntValue__Array @

---@class ExtractOrnamentArg
---@field no_use boolean @

---@class ExtractOrnamentRes
---@field result ErrorInfo @
---@field item_id number @
---@field item_num number @

---@class MakeDeviceArg
---@field make_id number @制作种类编号
---@field con1_index number @可选条件1下标
---@field con2_index boolean @可选材料是否存在
---@field is_blind_first boolean @是否绑定优先

---@class MakeDeviceRes
---@field result ErrorInfo @

---@class UseDeviceArg
---@field device_uid uint64 @置换器UID
---@field equip_uid uint64 @装备UID

---@class UseDeviceRes
---@field result ErrorCode @

---@class EquipRefineTransferArg
---@field from_uid uint64 @原装备
---@field to_uid uint64 @新装备
---@field is_perfect boolean @

---@class EquipRefineTransferRes
---@field result ErrorCode @

---@class EquipRefineUnblockArg
---@field item_uid uint64 @
---@field count number @使用多少份道具

---@class EquipRefineUnblockRes
---@field result ErrorCode @
---@field cur_exp number @

---@class ExchangeAwardPackArg
---@field item_uid uint64 @
---@field reward_id number @
---@field item_count number @
---@field idx number @

---@class ExchangeAwardPackRes
---@field error ErrorCode @

---@class WaBaoStartNotifyData

---@class ItemList
---@field item Item__Array @

---@class ItemUids
---@field item_uid PBuint64__Array @

---@class RollData
---@field roleinfo MapKeyIntValue__Array @玩家id和点数
---@field iteminfo RollItem__Array @item和item价值
---@field context RollContext @标记发生的场景

---@class RollConfirmData

---@class RollConfirmNtfData
---@field role_id uint64 @点击了role点的玩家

---@class FlopInfo
---@field real_slot RollItem @真实获得的道具
---@field other_slots RollItem__Array @陪衬
---@field context RollContext @发生的场景

---@class RollItem
---@field item_id number @
---@field item_count number @
---@field price number @

---@class SetArrowArg
---@field arrow_data ArrowPair__Array @

---@class SetArrowRes
---@field error ErrorCode @

---@class CreateItemByItemTemplateArg
---@field item_list ItemTemplate__Array @
---@field role_id uint64 @
---@field rpc_id number @

---@class CreateItemByItemTemplateRes
---@field item_list Item__Array @
---@field result ErrorCode @

---@class FashionCountData
---@field fashion_count number @时尚度
---@field fashion_count_history number @历史最高

---@class PayFineArg

---@class PayFineRes
---@field error ErrorCode @

---@class RequestEquipForgedListRes
---@field forged_list PBint32__Array @
---@field result ErrorCode @

---@class RequestEquipForgedListArg
---@field type boolean @no use

---@class BatchAwardPreviewArg
---@field award_id_list PBint32__Array @

---@class BatchAwardPreviewRes
---@field result ErrorCode @
---@field preview_result AwardPreviewResult__Array @

---@class AwardPreviewResult
---@field award_id number @
---@field award_list AwardContent__Array @
---@field preview_type number @
---@field preview_num number @
---@field preview_count number @

---@class WearHeadPortraitArs
---@field head_portrait_uid uint64 @
---@field is_on boolean @true穿上false脱下

---@class WearHeadPortraitRes
---@field result ErrorCode @

---@class EquipHoleRefogeArg
---@field equip_uid uint64 @
---@field pos number @

---@class EquipHoleRefogeRes
---@field result ErrorCode @

---@class EquipSaveHoleReforgeRes
---@field result ErrorCode @

---@class EquipSaveHoleReforgeArg
---@field equip_uid uint64 @
---@field pos number @

---@class ItemCountInfo
---@field item_id number @
---@field item_count int64 @

---@class ItemDemandDbInfo
---@field item_demand_info ItemCountInfo__Array @
---@field refresh_time uint64 @
---@field mtime uint64 @

---@class ItemDemandSyncInfo
---@field items ItemCountInfo__Array @
---@field is_overlay boolean @是否要全量覆盖

---@class ItemDemandSyncGetFromTrArg

---@class ItemDemandSyncGetFromTrRes
---@field item_demand ItemDemandSyncInfo @
---@field error_code ErrorCode @

---@class ItemDemandChangeData
---@field item_changes ItemDemandChangeInfo__Array @

---@class ItemDemandChangeInfo
---@field change_type ItemNumChangeType @
---@field item_id number @
---@field change_num int64 @

---@class RequestKillMonsterCountArg
---@field monster_ids PBint32__Array @

---@class RequestKillMonsterCountRes
---@field monster_id_count MapInt32Int32__Array @怪物击杀id和数量
---@field error ErrorCode @

---@class OfflineItemPb
---@field item_uid uint64 @
---@field item_id number @
---@field item_count int64 @
---@field is_bind boolean @
---@field create_time uint64 @
---@field unique_id uint64 @

---@class RoleOfflineItemPb
---@field role_uid uint64 @
---@field offline_items OfflineItemPb__Array @

---@class SaveOfflineItemDeleteDataArg
---@field role_items RoleOfflineItemPb__Array @
---@field mtime uint64 @

---@class SaveOfflineItemDeleteDataRes
---@field result ErrorCode @

---@class OfflineItemDeleteToGsArg
---@field delete_item RoleOfflineItemPb @

---@class OfflineItemDeleteToGsRes
---@field result ErrorCode @

---@class RevenueItemChangeInfo
---@field item VirtualItemData @
---@field is_bless boolean @

---@class AddEquipTaskArg
---@field equip_task_id number @

---@class AddEquipTaskRes
---@field result ErrorCode @

---@class EquipTaskData
---@field equip_task_ids number__Array @任务id

---@class DelEquipTaskArg
---@field equip_task_id number @

---@class DelEquipTaskRes
---@field result ErrorCode @

---@class BagLoadUnlockNtfData
---@field unlock_type number @
---@field unlock_load number @

---@class FashionCountSendAwardArg
---@field id number @

---@class FashionCountSendAwardRes
---@field result ErrorCode @

---@class ExtractEquipArg
---@field type number @抽取的装备类型

---@class ExtractEquipRes
---@field result ErrorInfo @
---@field item_id number @物品id
---@field item_num number @物品数量

---@class PreviewMagicEquipExtractArg
---@field type number @预览奖励类型

---@class PreviewMagicEquipExtractRes
---@field result ErrorCode @
---@field items_data PreviewMagicEquipExtractData__Array @物品信息
---@field use_times number @使用次数

---@class PreviewMagicEquipExtractData
---@field item_id number @物品id
---@field item_num number @物品数量

---@class RecoveEquipRes
---@field result ErrorInfo @
---@field id_and_num MapKeyIntValue__Array @

---@class RecoveEquipArg
---@field item_uid PBuint64__Array @

---@class EquipEnchantRebornPerfectArg
---@field item_from_uid uint64 @提炼装备uid

---@class EquipEnchantRebornPerfectRes
---@field item_uid uint64 @封魔石uid
---@field result ErrorCode @

---@class EquipEnchantInheritArg
---@field item_from_uid uint64 @
---@field item_to_uid uint64 @

---@class EquipEnchantInheritRes
---@field result ErrorCode @

---@class UseRedEnvelopeArg
---@field uid uint64 @
---@field words string @口令/祝福

---@class UseRedEnvelopeRes
---@field error_code ErrorCode @

---@class UpdateItem
---@field delete_list MapKey64Value32__Array @删除道具列表
---@field update_time int64 @最后更新服务器时间戳
---@field item_list RoItemAndReason__Array @道具列表

---@class GetAwardFromGSArg
---@field award_id number @
---@field guild_id int64 @

---@class GetAwardFromGSRes
---@field item ItemBrief__Array @

---@class SwapItemPos
---@field itemuid int64 @道具唯一id
---@field pos_type number @目标容器
---@field pos_index number @目标具体位置，-1表示服务器自己找位置
---@field item_count number @移动的数量，-1表示全部移动

---@class RequestBuyQualifiedPackArg
---@field pack_id number @

---@class QueryCanBuyMonthCardArg
---@field is_renew boolean @是否续订

---@class LuckyPointSystemOpenNtf
---@field enabled boolean @

---@class RoItemAndReason
---@field item Ro_Item @道具数据
---@field reason number @变更原因
---@field extra_param number @额外参数

---@class GetBlackMarketItemPriceArg
---@field auction_ids number__Array @

---@class GetBlackMarketItemPriceRes
---@field item_price AuctionItemInfo__Array @
---@field result ErrorCode @

---@class SellBlackMarketItemArg
---@field items SellShopItem__Array @

---@class SellBlackMarketItemRes
---@field result ErrorCode @

---@class GetAuctionItemPriceArg
---@field rpc_id number @

---@class GetAuctionItemPriceRes
---@field items AuctionItemPriceInfo @

---@class AuctionItemPriceInfo
---@field items AuctionItemInfo__Array @

---@class AuctionItemInfo
---@field acution_id number @
---@field price number @

---@class BlackMarketSoldData
---@field items MapInt32Int32__Array @

---@class EquipCardUnSealArg
---@field is_equip boolean @
---@field item_uid uint64 @
---@field pos number @如果是装备上的卡片 0开始

---@class EquipCardUnSealRes
---@field result ErrorCode @

---@class CompositeWheelsArg
---@field uids uint64__Array @

---@class CompositeWheelsRes
---@field result ErrorCode @

---@class ResetWheelArg
---@field uid uint64 @

---@class ResetWheelRes
---@field result ErrorCode @

---@class ChooseWheelResetSkillArg
---@field uid uint64 @
---@field skill_id number @

---@class MaintenanceWheelRes
---@field result ErrorCode @

---@class MaintenanceWheelArg
---@field uid uint64 @
---@field use_item_id number @润滑剂ID

---@class ChooseWheelResetSkillRes
---@field result ErrorCode @

---@class EquipReformArg
---@field uid uint64 @

---@class EquipReformRes
---@field result ErrorCode @

---@class EquipInheritArg
---@field from_item_uid uint64 @
---@field to_item_uid uint64 @继承装备id

---@class EquipInheritRes
---@field result ErrorCode @

---@class ItemAndReason
---@field item_id number @
---@field item_count number @
---@field reason number @

---@class LifeSkillAward
---@field item ItemAndReason__Array @

---@class RoItemList
---@field ro_item_list Ro_Item__Array @

---@class UnLockHairArg
---@field hair_id number @

---@class UnLockHairRes
---@field result ErrorCode @
---@field hair_id number @

---@class UnLockEyesArg
---@field eyes_id number @

---@class UnLockEyesRes
---@field result ErrorCode @
---@field eyes_id number @

---@class ActiveItemArg
---@field item_uid uint64 @道具的唯一标识

---@class ActiveItemRes
---@field result ErrorCode @错误码
---@field item_uid uint64 @道具的唯一标识
---@field active_status number @激活状态

---@class GetCommonAwardArg
---@field award_id number @请求的奖励id
---@field award_times number @请求领取次数
---@field award_type number @请求类型参数，普通领奖花钱领奖等类型
---@field active_id number @所属活动id（不填的话认为是普通礼包，非活动礼包）

---@class GetCommonAwardRes
---@field error_code ErrorCode @错误码，成功结果用commondate同步

---@class ResolveItemArg
---@field item_uid int64__Array @想要分解道具的列表

---@class ResolveItemRes
---@field error_code ErrorCode @错误码

---@class AskGsAddBuffArg
---@field role_id uint64 @玩家id
---@field buff_list AskGsBuffBrief__Array @buff列表

---@class AskGsBuffBrief
---@field buff_id number @buffid
---@field expire_time uint64 @截止时间(0表示不修正)

---@class AskGsUseItemArg
---@field role_id uint64 @角色id
---@field item_list ItemBrief__Array @需要扣除的道具(或)
---@field ask_uuid uint64 @请求消息的uuid

---@class AskGsUseItemRes
---@field result ErrorCode @结果
---@field cost_index number @实际扣除的道具在列表中的下标

---@class UseMoneyTellMsArg
---@field ask_type AskGsUseItemType @ms触发请求的类型
---@field role_id uint64 @角色id
---@field cost_item ItemBrief @实际扣除的道具
---@field timestamp int64 @时间戳
---@field exparam64 uint64 @扩展参数uint64

---@class UseMoneyTellMsRes
---@field result ErrorCode @

---@class AskGsOpItemInfo
---@field uuid uint64 @订单唯一id
---@field ask_type AskGsUseItemType @查询类型
---@field item_list ItemBrief__Array @需要扣除的道具列表
---@field role_id uint64 @角色id
---@field exparam_uint64 uint64__Array @扩展参数uint64
---@field expire_tick int64 @请求过期的时间点

---@class AskGsOpItemDBInfo
---@field item_info_list AskGsOpItemInfo__Array @存储db的列表

---@class UseItemReplyClientData
---@field result ErrorCode @
---@field ask_type AskGsUseItemType @请求gs扣除道具的类型
---@field magic_paper_brief PaperBrief @魔法信笺用

---@class GrabMagicPaperArg
---@field paper_uid uint64 @

---@class PaperBrief
---@field paper_uid uint64 @信笺uid(客户端叫letter_uid)
---@field paper_id number @信笺id(香氛id)
---@field create_time_stamp uint64 @
---@field sender_uid uint64 @
---@field sender_name string @
---@field recv_uid uint64 @
---@field recv_name string @
---@field bless_words string @
---@field is_received boolean @是否领取
---@field is_allocated boolean @是否分发完
---@field thanks boolean @是否感谢过

---@class GrabMagicPaperRes
---@field result ErrorCode @
---@field envelope EnvelopeInfo @抢到的红包
---@field paper_brief PaperBrief @信笺简要信息
---@field paper_deail GrapResult__Array @详细信息(领取失败时生效)

---@class MagicPaperDBInfo
---@field paper_list MagicPaperInfo__Array @
---@field ready_list MagicPaperInfo__Array @

---@class MagicPaperInfo
---@field brief PaperBrief @brief
---@field envelope_list EnvelopeInfo__Array @剩余红包序列
---@field grap_result GrapResult__Array @抢购结果

---@class EnvelopeInfo
---@field items ItemBrief__Array @
---@field envelope_type number @礼包类型(服务器用,可能会同时存在多种)
---@field display_type EnvelopeType @显示类型(客户端用

---@class GrapResult
---@field role_uid uint64 @
---@field envelop EnvelopeInfo @

---@class SendMagicPaperArg
---@field recv_uid uint64 @
---@field paper_id number @
---@field bless_words string @寄语

---@class SendMagicPaperRes
---@field result ErrorCode @

---@class QueryMagicPaperArg
---@field uuid uint64 @上一次请求到的最小uuid
---@field type number @1未领完 2已领完

---@class QueryMagicPaperRes
---@field result ErrorCode @
---@field total_count number @总数
---@field brief_list PaperBrief__Array @红包简要信息

---@class QueryGrapPaperArg
---@field paper_uid uint64 @

---@class QueryGrapPaperRes
---@field result ErrorCode @
---@field grap_list GrapResult__Array @

---@class ThanksMagicPaperArg
---@field paper_uid uint64 @信笺唯一id

---@class ThanksMagicPaperRes
---@field result ErrorCode @

---@class AddMagicPaperAwardArg
---@field role_id uint64 @

---@class MailInfo
---@field base_info MailBaseInfo @
---@field content_info MailContent @

---@class GetMailListArg

---@class GetMailListRes
---@field mails MailBaseInfo__Array @
---@field result ErrorCode @

---@class MailOpArg
---@field op_type MailOpType @
---@field mail_uid int64 @

---@class MailOpRes
---@field error ErrorInfo @
---@field op_type MailOpType @
---@field mail_uid uint64 @
---@field read_mail_uids PBuint64__Array @已读邮件列表（只针对type= 一键领取时有效）

---@class MailBaseInfo
---@field mail_uid uint64 @
---@field mail_id number @
---@field create_time uint64 @
---@field expire_time uint64 @
---@field is_read boolean @
---@field is_has_item boolean @
---@field match_title LocalizationNameContainer @
---@field send_uid uint64 @发送者uid
---@field extra_info MailExtraBaseInfo @

---@class MailExtraBaseInfo
---@field head_id number @
---@field title string @

---@class MailContent
---@field content string @
---@field match_content LocalizationNameContainer @
---@field reason number @
---@field mail_items Item__Array @
---@field send_name string @发送者名字
---@field match_send_name LocalizationNameContainer @通配名字

---@class UpdateMailData
---@field mail_info MailInfo @

---@class SMailTemplate
---@field mail_id number @
---@field expire_time uint64 @
---@field send_time uint64 @
---@field mail_items Item__Array @
---@field reason MailReason @
---@field match_content LocalizationNameContainer @通配内容
---@field mail_content SMailContent @
---@field match_title LocalizationNameContainer @通配标题
---@field match_send_name LocalizationNameContainer @通配发送者
---@field level_limit number @
---@field idip_item_extra_info IdipItemExtraInfoPb @idip加的物品额外信息
---@field delete_time uint64 @邮件删除时间
---@field tlog_extra_info AuctionTlogExtraInfo @拍卖额外信息
---@field item_change_reason ItemChangeReason @
---@field is_from_idip boolean @来源

---@class SMailContent
---@field send_name string @
---@field title string @
---@field content string @

---@class SMailInfo
---@field mail_uid uint64 @
---@field is_use_global boolean @
---@field is_read boolean @
---@field create_time uint64 @
---@field mail_temp SMailTemplate @
---@field send_uid uint64 @发送者uid
---@field product_id number @直购礼包id
---@field pay_ment number @付费邮件标识
---@field bill_no string @订单
---@field is_important boolean @重要标识

---@class GetOneMailArg
---@field mail_uid uint64 @

---@class GetOneMailRes
---@field result ErrorCode @
---@field mail_info MailInfo @

---@class AddGlobalMailData
---@field mail_info SMailInfo @

---@class MailOperationData
---@field role_uid uint64 @
---@field mail_list SMailInfo__Array @
---@field op_type MailDbOpType @
---@field mtime uint64 @

---@class GiveMailPrizeArg
---@field mail_items MailItemData__Array @
---@field role_uid uint64 @
---@field delay_id number @

---@class GiveMailPrizeRes
---@field mail_items MailItemData__Array @
---@field is_success boolean__Array @
---@field error ErrorInfo @

---@class MailItemData
---@field mail_uid uint64 @
---@field items Item__Array @
---@field reason MailReason @
---@field idip_item_extra_info IdipItemExtraInfoPb @

---@class RoleMailPbInfo
---@field max_global_mail_uid uint64 @
---@field mails SMailInfo__Array @
---@field global_mails SMailInfo__Array @

---@class UpdateRoleGlobalMailData
---@field role_uid uint64 @
---@field mail_uid uint64 @
---@field mtime uint64 @

---@class GsSendMailArg
---@field role_uid uint64 @
---@field mail_id number @
---@field items Item__Array @
---@field match_content LocalizationNameContainer @
---@field match_title LocalizationNameContainer @
---@field send_uid uint64 @
---@field match_send_name LocalizationNameContainer @
---@field reason MailReason @
---@field item_reason ItemChangeReason @
---@field create_time uint64 @邮件创建时间
---@field product_id number @直购礼包ID
---@field bill_no string @订单

---@class GsSendMailRes
---@field result ErrorCode @

---@class RoleMailInfo
---@field role_uid uint64 @
---@field mail_info RoleMailPbInfo @

---@class ActivityMailTipData
---@field is_hint boolean @

---@class AuctionTlogExtraInfo
---@field money_type number @拍卖商品货币类型
---@field price number @物品竟得价格
---@field auction_type number @拍卖主体
---@field reason number @物品来源[资源操作行为定义]
---@field sub_reason number @物品二级来源[资源流向定义]

---@class MallItem
---@field seq_id number @
---@field money_type number @
---@field left_times number @
---@field is_bind boolean @
---@field origin_price int64 @
---@field now_price int64 @
---@field next_refresh_time number @

---@class GetMallInfoArg
---@field mall_id number @

---@class GetMallInfoRes
---@field error ErrorCode @结果
---@field items MallItem__Array @道具信息
---@field next_fresh_time number @下次刷新时间
---@field manual_refresh_count number @当前手动刷新计数

---@class BuyMallItemArg
---@field mall_id number @
---@field seq_id number @
---@field num number @
---@field now_price int64 @

---@class BuyMallItemRes
---@field error ErrorInfo @
---@field need_refresh boolean @

---@class TradeItemPriceInfo
---@field item_id number @
---@field price int64 @

---@class TradeItemPriceInfos
---@field infos TradeItemPriceInfo__Array @

---@class GetTradePriceArg
---@field rpc_id number @

---@class FreshMallItemArg
---@field mall_id number__Array @

---@class FreshMallItemRes
---@field result ErrorCode @
---@field mall_items MultiMallItems__Array @

---@class MultiMallItems
---@field mall_id number @
---@field next_fresh_time number @
---@field items MallItem__Array @

---@class ManualRefreshMallItemArg
---@field mall_id number @卖场里页签的id

---@class ManualRefreshMallItemRes
---@field result ErrorCode @请求手动刷新的结果
---@field manual_refresh_count number @当前手动刷新的次数

---@class GetMallTimestampArg
---@field mall_id_list number__Array @卖场id

---@class GetMallTimestampRes
---@field result ErrorCode @结果
---@field mall_timestamp MallTimestamp__Array @卖场一些时间戳

---@class MallTimestamp
---@field last_buy_timestamp int64 @最后一次购买时间戳
---@field next_refresh_timestamp int64 @下次刷新时间戳

---@class MedalOpArg
---@field medal_type MedalType @
---@field op_type MedalOpType @操作类型
---@field medal_id number @
---@field reset_attr_pos number @填-1：表示随机，其他的指定位置
---@field op_times number @操作次数

---@class MedalOpRes
---@field result ErrorCode @
---@field op_type MedalOpType @
---@field changed_medals MedalInfo @
---@field add_prestige number @
---@field extra_prestige number @

---@class MedalChangedData
---@field medal_info MedalInfo @
---@field change_type MedalChangeType @改变类型

---@class GetPrestigeAdditionArg
---@field role_uid uint64 @
---@field medal_id number @勋章id

---@class GetPrestigeAdditionRes
---@field prestige_addition number @万分比
---@field medal_id number @
---@field result ErrorCode @

---@class PrestigeChangeData
---@field add_prestige number @增加的声望
---@field extra_add_prestige number @新手额外声望
---@field medal_id number @作用的光辉勋章id

---@class MercenarySkillSlotArgs
---@field id number @
---@field skills MercenarySkillInfo @

---@class MercenaryEquipUpgradeArgs
---@field mercenary_id number @
---@field equip_id number @
---@field count number @
---@field operation number @1/升级 2/进阶

---@class MercenaryEquipUpgradeRes
---@field result ErrorCode @
---@field equip_id number @
---@field new_level number @

---@class MercenaryTalentRequestRes
---@field result ErrorCode @

---@class MercenaryTalentRequestArgs
---@field mercenary_id number @
---@field talent_id number @填实际唯一ID
---@field switch_to_id number @
---@field operation MercenaryTalentOperation @

---@class MercenaryTakeToFightArgs
---@field id number @
---@field operation number @1/出战，2/收回

---@class MercenaryRequestUpgradeArgs
---@field mercenary_id number @
---@field item_id number @
---@field item_count number @

---@class MercenaryRequestUpgradeRes
---@field result ErrorCode @
---@field cur_level number @
---@field cur_exp number @

---@class MercenaryRecruitData
---@field mercenary_id number @
---@field default_skills MercenarySkillInfo @

---@class MercenaryAdvanceData
---@field last_mercenary_id number @
---@field after_mercenary_id number @
---@field equip_info MercenaryEquipInfo @
---@field skill_info MercenarySkillInfo @

---@class GetTeamAllMercenaryArgs
---@field team_id int64 @

---@class GetTeamAllMercenaryRes
---@field result ErrorCode @
---@field mercenary_list MercenaryBrief__Array @

---@class MercenaryBrief
---@field id number @
---@field owner_id uint64 @
---@field hp number @百分比
---@field sp number @百分比
---@field level number @
---@field is_in_team boolean @
---@field uid uint64 @佣兵uid

---@class SelectTeamMercenarysArgs
---@field owner_id PBuint64__Array @
---@field mercenary_id PBint32__Array @

---@class GetMercenaryReviveTimeArgs
---@field owner_id uint64 @
---@field mercenary_id number @

---@class GetMercenaryReviveTimeRes
---@field result ErrorCode @
---@field revive_timestamp int64 @复活时间戳
---@field owner_id uint64 @
---@field mercenary_id number @

---@class MercenaryStatusToMsData
---@field role_id uint64 @
---@field mercenary_id number @
---@field operation number @
---@field is_perfect_out boolean @
---@field revive_timestamp int64 @复活时间戳
---@field cur_hp number @
---@field cur_sp number @
---@field max_hp number @
---@field max_sp number @
---@field level number @
---@field mercenary_uid uint64 @

---@class MercenaryHitStatusFromMsData
---@field mercenary_ids number__Array @

---@class MercenaryDeadNtfData
---@field id number @
---@field revive_timestamp int64 @复活时间戳

---@class TeamMercenaryChangeData
---@field team_id uint64 @
---@field mercenarys MercenaryBrief__Array @

---@class MercenaryUidNtfData
---@field id number @
---@field uid uint64 @

---@class MercenaryEquipsData
---@field equips MercenaryEquipInfo @
---@field mercenary_id number @

---@class NewSkillInfo
---@field mercenary_id number @佣兵id
---@field skill_id number @技能id

---@class FightNumData
---@field num number @

---@class MercenaryChangeFightStatusArg
---@field status number @1协同 2跟随

---@class MerchantGetShopInfoArg
---@field npc_uuid uint64 @
---@field npc_id number @

---@class MerchantGetShopInfoRes
---@field error_code ErrorCode @
---@field outdate_time number @
---@field buy_items MerchantShopItemInfo__Array @
---@field sell_items MerchantShopItemInfo__Array @

---@class MerchantShopItemInfo
---@field item_uuid uint64 @
---@field item_id number @
---@field item_count number @
---@field price number @
---@field event_id number @

---@class MerchantShopBuyArg
---@field npc_uuid uint64 @
---@field npc_id number @
---@field item MerchantShopItemInfo @

---@class MerchantShopBuyRes
---@field error_info ErrorInfo @

---@class MerchantShopSellArg
---@field npc_uuid uint64 @
---@field npc_id number @
---@field items MerchantShopItemInfo__Array @

---@class MerchantShopSellRes
---@field error_code ErrorCode @

---@class MerchantCheckNpcInfoArg
---@field npc_uuid uint64 @
---@field npc_id number @

---@class MerchantCheckNpcInfoRes
---@field error_code ErrorCode @

---@class MerchantUpdateNotifyInfo
---@field state number @0未开始1进行中2成功3失败
---@field start_time int64 @
---@field money_count number @

---@class MerchantTaskCompleteArg

---@class MerchantTaskCompleteRes
---@field error_code ErrorCode @

---@class MerchantGetEventInfoArg

---@class MerchantGetEventInfoRes
---@field error_code ErrorCode @
---@field outdate_time number @
---@field events MerchantEventPbInfo__Array @
---@field not_own_npc PBint32__Array @

---@class MerchantEventPbInfo
---@field id number @
---@field args number @

---@class MerchantEventPreBuyRes
---@field error_code ErrorCode @
---@field price number @

---@class MerchantEventPreBuyArg
---@field npc_uuid uint64 @
---@field npc_id number @

---@class MerchantEventBuyArg
---@field npc_uuid uint64 @
---@field npc_id number @
---@field price number @

---@class MerchantEventBuyRes
---@field error_code ErrorCode @

---@class MerchantEventUpdateNotifyInfo
---@field npc_list number__Array @
---@field next_refresh_time int64 @

---@class MerchantEventSyncRequestArg

---@class MerchantEventSyncRequestRes
---@field error_code ErrorCode @
---@field npc_list number__Array @
---@field next_refresh_time int64 @

---@class MerchantEventSaveToDbInfo
---@field next_refresh_time int64 @
---@field events MerchantEventPbInfo__Array @
---@field role_list MerchantEventRoleDbInfo__Array @
---@field npc_list MerchantEventNpcDbInfo__Array @

---@class MerchantEventRoleDbInfo
---@field role_id uint64 @
---@field npc_id number @
---@field is_win boolean @

---@class MerchantEventNpcDbInfo
---@field npc_id number @
---@field events number__Array @

---@class RegisterRouter2WorldArg
---@field line number @
---@field listen RouterListenInfo @

---@class RegisterRouter2WorldRes
---@field result ErrorCode @
---@field is_master boolean @
---@field serverid number @

---@class CrossZoneStatusNtf
---@field gs_num number @

---@class RegisterDB2NsArg
---@field server_id number @
---@field line number @
---@field listen_links ListenAddressPair__Array @

---@class RegisterDB2NsRes
---@field result ErrorCode @

---@class ListenAddressPair
---@field link_name string @
---@field addr ListenAddress @

---@class DBConnectListenInfo
---@field dbinfos DBListenInfo__Array @

---@class DBListenInfo
---@field line number @
---@field addr ListenAddress @

---@class RegistServerRes
---@field server_id number @
---@field line number @

---@class RegistServer
---@field serverName string @
---@field serverID number @
---@field serverids number__Array @

---@class LimitedTimeOfferItem
---@field item_id number @
---@field item_base_count int64 @
---@field present_count int64 @赠送的数量
---@field gift_count int64 @首充返利的数量

---@class LimitedTimeOfferItemList
---@field items LimitedTimeOfferItem__Array @

---@class PayParameterInfo
---@field open_key string @登录token
---@field session_id string @登陆态帐号类型
---@field session_type string @登陆态票据类型，需和sessionId成对匹配
---@field pf string @平台标识信息
---@field pf_key string @由平台来源和openkey根据规则生成的一个密钥串
---@field app_id string @应用ID

---@class PayConsumeInfo
---@field bill_no string @订单号
---@field consume_diamond number @消耗钻石数量(已弃用)
---@field status number @状态
---@field ts number @时间戳
---@field type number @
---@field index number @
---@field count number @
---@field last_check_time number @最后一次检查消费订单的时间
---@field retry_count number @请求midas次数
---@field midas_err_count number @
---@field create_time number @订单创建时间
---@field param PayCallBackParam @
---@field consume_free_diamond number @消费的免费钻石数量(已弃用

---@class PayConsumeDiamondArg
---@field role_uid uint64 @
---@field consume_info PayConsumeInfo @消耗信息

---@class PayConsumeDiamondRes
---@field result ErrorCode @

---@class PayNotifyArg
---@field param_type PayParamType @
---@field param_id string @
---@field amount number @充值金额
---@field data PayParameterInfo @
---@field count number @

---@class PayNotifyRes
---@field error_code ErrorCode @
---@field result string @

---@class PayConsumeAddgoodsArg
---@field role_uid uint64 @
---@field balance number @当前钻石剩余数量
---@field consume_info PayConsumeInfo @
---@field buy_good_info PayBuyGoodInfo @直购
---@field outside_bill OutsideOrder @外部订单，直接发货
---@field free_balance number @当前免费钻石剩余数量
---@field present_info PayPresentInfo @添加一级货币

---@class PayConsumeAddGoodsRes
---@field result ErrorCode @

---@class PayTsslist
---@field inner_productid string @用户开通的订阅物品ID（注：该参数为订阅型月卡配置时候的servicecode）
---@field begintime string @用户订阅的开始时间 如过期后未续费，且一段时间后再次订阅 返回的是新的订阅开始时间
---@field endtime string @用户订阅的结束时间
---@field paychan string @用户订阅该物品id最后一次的支付渠道
---@field paysubchan number @用户订阅该物品id最后一次的支付子渠道id
---@field autopaychan string @目前没有使用
---@field autopaysubchan number @目前没有使用
---@field grandtotal_opendays number @用户订阅历史累计开通天数
---@field grandtotal_presentdays number @用户订阅历史累计赠送天数
---@field first_buy_time string @首次购买时间
---@field extend string @预留扩展字段，目前没有使用

---@class PayGetBalanceArg
---@field balance number @当前游戏币余额
---@field tss_list PayTsslist__Array @
---@field save_amt number @累计充值金额的游戏币数量
---@field is_pay boolean @
---@field param_id string @
---@field role_uid uint64 @
---@field free_balance number @当前免费金币剩余数量

---@class PayGetBalanceRes
---@field result ErrorCode @

---@class SavePayDataArg
---@field role_uid uint64 @
---@field save_amt number @
---@field no_save_amt number @
---@field subscribe string @订阅
---@field consume string @消耗游戏币
---@field present string @赠送
---@field op number @

---@class SavePayDataRes
---@field result ErrorCode @

---@class PaySubscribeInfo
---@field ts number @
---@field param_id string @
---@field amount number @
---@field call_back_param PayCallBackParam @

---@class PayPresentInfo
---@field bill_no string @
---@field add_diamond number @增加的钻石(已弃用)
---@field reason number @
---@field subreason number @
---@field ts number @
---@field last_check_time number @最后一次检查赠送的时间
---@field retry_count number @尝试次数
---@field midas_err_count number @
---@field create_time number @订单创建时间
---@field add_free_diamond number @增加的免费钻石(已弃用)
---@field param PayCallBackParam @支付回调参数
---@field status number @订单状态

---@class PayAccessInfo
---@field role_uid uint64 @
---@field save_amt number @
---@field no_save_amt number @
---@field subscribe_list PaySubscribeList @
---@field present_list PayPresentList @
---@field consume_list PayConsumeList @
---@field buy_good_list PayBuyGoodList @直购
---@field order_info_list OrderInfoList @
---@field outside_bill_list OutsideOrderList @外部订单server直接发货
---@field total_recharge int64 @历史累计充值金额

---@class PaySubscribeList
---@field subscribe PaySubscribeInfo__Array @

---@class PayPresentList
---@field present PayPresentInfo__Array @

---@class PayConsumeList
---@field consume PayConsumeInfo__Array @

---@class SavePayAccessArg
---@field role_uid uint64 @
---@field save_amt number @
---@field no_save_amt number @
---@field subscribe PaySubscribeList @
---@field consume PayConsumeList @
---@field present PayPresentList @
---@field buy_good PayBuyGoodList @直购
---@field order_info OrderInfoList @
---@field outside_bill_list OutsideOrderList @外部订单server直接发货
---@field total_recharge int64 @历史累计充值金额(扩大1w倍)

---@class SavePayAccessRes
---@field result ErrorCode @

---@class MidasExceptionInfo
---@field result ErrorCode @

---@class PresentReplyData
---@field role_uid uint64 @
---@field present PayPresentInfo @
---@field balance_node DBBalanceNode @钻石信息

---@class PayBuyGoodInfo
---@field url string @
---@field token string @
---@field bill_no string @订单号
---@field amt number @金额
---@field status number @状态
---@field ts number @
---@field type number @
---@field index number @
---@field count number @
---@field item_name string @道具名称
---@field item_desc string @表示物品的描述信息
---@field last_check_time number @最后一次检查时间
---@field retry_count number @尝试次数
---@field create_url_time number @
---@field create_time number @订单创建时间
---@field param PayCallBackParam @

---@class PayBuyGoodList
---@field buy_goods PayBuyGoodInfo__Array @

---@class PayGoodBrief
---@field item ItemBrief @
---@field price number @

---@class PayBuyGoodArg
---@field role_uid uint64 @
---@field buy_good_info PayBuyGoodInfo @

---@class PayBuyGoodRes
---@field result ErrorCode @

---@class BuyGoodUrlData
---@field url string @
---@field token string @
---@field bill_no string @

---@class PayAddDiamondData
---@field role_uid uint64 @
---@field data PayPresentInfo @

---@class BuyGoodHttpCallBackArg
---@field params HttpParam__Array @http参数
---@field request_id number @

---@class BuyGoodHttpCallBackRes
---@field result number @

---@class HttpParam
---@field param_key string @
---@field param_value string @

---@class PayBuyGoodsData
---@field good_id number @充值商品ID
---@field price number @充值商品价格
---@field recharge_num number @充值代币（点券）金额
---@field result number @充值结果：0成功 1失败

---@class LimitedTimeOfferRecharge
---@field id number @
---@field money number @
---@field item_list LimitedTimeOfferItemList @

---@class LimitedTimeOfferRechargeTable
---@field recharge_table LimitedTimeOfferRecharge__Array @

---@class GetLimitedOfferRechargeTableArg

---@class GetLimitedOfferRechargeTableRes
---@field error_code ErrorCode @
---@field recharge_table LimitedTimeOfferRechargeTable @

---@class BuyLimitedOfferGoodsArg
---@field goods_id number @

---@class BuyLimitedOfferGoodsRes
---@field error_code ErrorCode @

---@class GetNextLimitedOfferOpenTimeArg

---@class GetNextLimitedOfferOpenTimeRes
---@field error_code ErrorCode @
---@field next_open_time number @限时特惠下次开启时间

---@class PayForLimitedOfferSuccessNtfData
---@field is_paid boolean @是否在限时特惠购买了物品

---@class PayRolePbInfo
---@field role_id uint64 @
---@field session_id uint64 @
---@field account string @
---@field login_type LoginType @登录方式
---@field server_id number @
---@field ip string @
---@field login_plat_id number @
---@field gs_line number @

---@class OrderInfo
---@field order_id string @
---@field param_id string @
---@field price number @
---@field create_time uint64 @
---@field complete_time uint64 @
---@field offline boolean @
---@field expackage_coins string @
---@field expackage_amount string @
---@field actid number @

---@class OrderInfoList
---@field order_infos OrderInfo__Array @

---@class SavePayRoleBalanceArg
---@field role_uid uint64 @
---@field bill_no string @
---@field server_id number @
---@field db_node DBBalanceNode @db字段

---@class SavePayRoleBalanceRes
---@field result ErrorCode @

---@class PaySaveDBEndArg

---@class PaySaveDBEndRes

---@class PayCallBackParam
---@field call_back_id number @回调id
---@field rpc_type number @客户端协议的协议号，为了客户端回调
---@field reason number @
---@field subreason number @
---@field add_items PayGoodBrief__Array @购买的物品列表
---@field del_items PayGoodBrief__Array @消耗金币同时还需要消耗的道具
---@field result ErrorCode @支付结果
---@field guild_id int64 @公会id
---@field crystal_id number @公会水晶id
---@field bib_info PayBibBrief @拍卖的基础信息
---@field ask_gs_use_item_uuid uint64 @请求gs使用道具订单uuid
---@field ask_gs_use_item_index number @请求gs使用道具的下标
---@field red_envelope_arg SendGuildRedEnvelopeArg @创建红包信息[透传]
---@field int_param_list PayParamIntNode__Array @通用int参数列表
---@field reduce_rule number @扣除规则对应pay_define的ReduceRuleType枚举
---@field pay_lock_type number @支付锁类型
---@field bill_no string @订单号
---@field real_modify_coin103 number @实际修改的103
---@field real_modify_coin104 number @实际修改的104

---@class PayMoneySuccessData
---@field rpc_type number @客户端用的原rpc
---@field result ErrorCode @支付结果

---@class PaySuccessTransData
---@field param PayCallBackParam @

---@class PresentDiamondBackData
---@field item_count number @
---@field reason ItemChangeReason @

---@class SavePayBillStatusArg
---@field role_uid uint64 @
---@field server_id number @
---@field bill_no string @
---@field status PayBillStatus @

---@class PayBibBrief
---@field bib_price number @
---@field bib_item_uid uint64 @
---@field is_auto_bib boolean @

---@class PayBillFinishedData
---@field bill_no string @
---@field pay_type number @
---@field role_uid uint64 @
---@field result ErrorCode @结果

---@class SavePayBillStatusRes
---@field result ErrorCode @

---@class PaySuccessTransArg
---@field bill_no string @
---@field param PayCallBackParam @
---@field pay_type number @

---@class PaySuccessTransRes
---@field result ErrorCode @

---@class OutsideOrder
---@field bill_no string @订单id
---@field retry_count number @重试次数
---@field status number @状态
---@field last_check_time number @最后一次检测时间
---@field pay_price int64 @实际支付金额(有扩大1w倍)
---@field total_recharge int64 @历史累计金额,传到gs打tlog用(有扩大1w倍)
---@field product_name string @产品name字段
---@field currency_type string @现金类型(KRW,RMB)

---@class OutsideOrderList
---@field outside_order_list OutsideOrder__Array @

---@class SyncRoleDiamond
---@field diamond number @钻石
---@field free_diamond number @免费钻石
---@field total_diamond number @历史累计钻石
---@field total_free_diamond number @历史累计免费钻石

---@class DBBalanceNode
---@field diamond number @钻石
---@field free_diamond number @免费钻石
---@field total_diamond number @历史累计钻石
---@field total_free_diamond number @历史累计免费钻石

---@class PaySDKOrderResultData
---@field result ErrorCode @
---@field message string @
---@field order_id string @

---@class PaySDKCreateOrderData
---@field pay_type string @支付方式
---@field product_name string @商品name
---@field ext string @附加参数，扩展使用
---@field package_code string @
---@field lang_code string @
---@field game_code string @
---@field device_id string @设备id

---@class PayParamIntNode
---@field key PayParamIntKey @
---@field value int64 @

---@class PayAddDiamondArg
---@field role_uid uint64 @
---@field present_info PayPresentInfo @

---@class PayAddDiamondRes
---@field result ErrorCode @

---@class GetPayAwardArg
---@field region Region @
---@field id number @

---@class GetPayAwardRes
---@field error_code ErrorCode @

---@class GetRegionArg
---@field rpc_id number @

---@class GetRegionRes
---@field error_code ErrorCode @
---@field region Region @

---@class PayRoleHeartBeat
---@field role_uid uint64 @
---@field session_id uint64 @

---@class PushMsgAccountAllInfo
---@field account_id string @
---@field role_info RoleInfoOnFm @
---@field push_set PushMsgAccountSetInfo @
---@field push_records PushMsgAllRecord @

---@class PushMsgAllRecord
---@field push_rec PushMsgRecord__Array @

---@class PushMsgRecord
---@field notify_id number @
---@field push_time int64 @

---@class PushMsgAccountSetInfo
---@field main_switch number @总开关
---@field push_status number__Array @推送状态
---@field open_system number__Array @开放的系统
---@field push_switch_on number__Array @开启的推送
---@field push_switch_off number__Array @关闭的推送

---@class PushInformationInfo
---@field server_id number @
---@field notify_id number @
---@field time_stamp int64 @
---@field account_id string__Array @

---@class PushInformationAllInfo
---@field last_push_time int64 @
---@field push_info PushInformationDBInfo @

---@class PushInformationDBInfo
---@field push_info PushInformationInfo__Array @

---@class PushMsgMsToFmData
---@field server_id number @
---@field system_id number @
---@field push_time int64 @
---@field account string__Array @

---@class PushSwitchModifyFmRes
---@field result ErrorCode @
---@field main_switch number @
---@field all_switch_on number__Array @
---@field all_switch_off number__Array @

---@class PushSwitchModifyFmArg
---@field account_id string @
---@field rpc_id number @
---@field main_switch number @
---@field all_switch_on number__Array @
---@field all_switch_off number__Array @

---@class PushSwitchInfoArg

---@class PushSwitchInfoRes
---@field result ErrorCode @
---@field main_switch number @
---@field all_switch_on number__Array @
---@field all_switch_off number__Array @

---@class PushSwitchModifyArg
---@field main_switch number @总开关设置
---@field all_switch_on number__Array @
---@field all_switch_off number__Array @

---@class PushSwitchModifyRes
---@field result ErrorCode @
---@field main_switch number @
---@field all_switch_on number__Array @
---@field all_switch_off number__Array @

---@class PushSwitchInfoFmRes
---@field result ErrorCode @
---@field main_switch number @
---@field all_switch_on number__Array @
---@field all_switch_off number__Array @

---@class PushSwitchInfoFmArg
---@field account_id string @
---@field rpc_id number @

---@class PushMsgTokenData
---@field account_id string @
---@field push_token string @

---@class PushMsgServerSetData
---@field is_open boolean @
---@field server_id number @

---@class RankRoelInfo
---@field id uint64 @
---@field account string @
---@field session uint64 @
---@field guild_id uint64 @
---@field friends uint64__Array @

---@class DbRankData
---@field unique_id uint64 @
---@field row BoardRowData @
---@field date_index number__Array @
---@field create_time int64 @
---@field op number @

---@class RankBriefRole
---@field id uint64 @
---@field profession RoleType @

---@class PersonBoardData
---@field role_name string @
---@field role_info RankBriefRole @
---@field score uint64 @

---@class TeamBoardData
---@field captain_name string @
---@field role_infos RankBriefRole__Array @
---@field score uint64 @

---@class GuildBoardData
---@field guild_id uint64 @
---@field guild_name string @
---@field participate_roles RankBriefRole__Array @参赛人员
---@field score uint64 @

---@class BoardRowData
---@field board_id number @
---@field person_data PersonBoardData @
---@field team_data TeamBoardData @
---@field guild_data GuildBoardData @

---@class PushLeaderBoardDataRes
---@field result ErrorCode @

---@class PushLeaderBoardDataArg
---@field datas BoardRowData__Array @

---@class RankMemberInfo
---@field id uint64 @
---@field profession RoleType @

---@class RankRowData
---@field rank number @排名
---@field score uint64 @分数/战力
---@field name string @
---@field members RankMemberInfo__Array @成员
---@field timestamp int64 @发生时间戳,单位秒
---@field guild_id uint64 @公会排行榜用

---@class RequestLeaderBoardInfoRes
---@field result ErrorCode @
---@field rows RankRowData__Array @
---@field history_timestamp PBuint64__Array @
---@field own_rank RankRowData @0不存在, -1榜外

---@class RequestLeaderBoardInfoArg
---@field component_id number @
---@field page number @
---@field date_index number @
---@field view_type number @

---@class RankReadOnlineRoleArg
---@field max_count number @
---@field last_role_id uint64 @

---@class RankReadOnlineRoleRes
---@field role_list RankRoelInfo__Array @

---@class RankRoleAddNotityData
---@field role_list RankRoelInfo__Array @

---@class RankRoleRemoveNotifyData
---@field role_list uint64__Array @

---@class SyncGsFriends2RankData
---@field op FriendOpType @
---@field role_uid uint64 @
---@field friends uint64__Array @

---@class SyncguildInfo2RankData
---@field op SyncGuildOpType @
---@field guild_id uint64 @
---@field members uint64__Array @

---@class RankReadAllGuildFromMsRes
---@field guilds SyncguildInfo2RankData__Array @

---@class SaveRankListToDBData
---@field datas DbRankData__Array @
---@field mtime uint64 @

---@class LeaderBoardTimeInfo
---@field main_id number @
---@field timestamp int64__Array @

---@class SaveRankGeneralRecord
---@field field_data_list string__Array @
---@field field_name_list string__Array @
---@field mtime int64 @

---@class BoardHistoryInfo
---@field values LeaderBoardTimeInfo__Array @

---@class BoardRefreshInfo
---@field values LeaderBoardTimeInfo__Array @

---@class GetRoleLeaderBoardRankArg
---@field board_id number @
---@field date_index number @
---@field key_id_list uint64__Array @角色是roleid,公会是guildid
---@field query_type number @
---@field param uint64__Array @

---@class GetRoleLeaderBoardRankRes
---@field result ErrorCode @
---@field datas RoleLeaderBoardRank__Array @

---@class RankSendMailArg
---@field mails MailAwardNode__Array @

---@class RankSendMailRes
---@field result ErrorCode @

---@class MailAwardNode
---@field mail_id number @
---@field args string__Array @
---@field role_ids uint64__Array @

---@class BoardCurDateIndexs
---@field board_id number__Array @
---@field index number__Array @

---@class RegisterGt2RankArg
---@field serverid number @
---@field line number @

---@class RegisterGt2RankRes
---@field result ErrorCode @

---@class RoleLeaderBoardRank
---@field role_id uint64 @
---@field row RankRowData @

---@class GetLeaderBoardDataByRankArg
---@field board_id number @
---@field date_index number @
---@field begin_rank number @
---@field end_rank number @闭区间
---@field query_type number @
---@field rpc_id number @处理转发给客户端的rpcid(如果不需要填0无视)

---@class GetLeaderBoardDataByRankRes
---@field result ErrorCode @
---@field datas RankRowData__Array @

---@class GetGuildLeaderBoardArg
---@field board_id number @排行榜id
---@field date_index number @
---@field begin_rank number @1base
---@field end_rank number @闭区间

---@class BoardReawardInfo
---@field values LeaderBoardTimeInfo__Array @

---@class RefreshLearderBoardFromMsArg
---@field main_id number @
---@field save boolean @
---@field clear boolean @
---@field query_type number @

---@class GetGuildLeaderBoardRes
---@field result ErrorCode @
---@field datas GuildLeaderBoardRowData__Array @公会数据

---@class GuildRankMemberBrief
---@field role_id uint64 @角色id
---@field base_info MemberBaseInfo @基础数据给客户端显示头像

---@class GuildLeaderBoardRowData
---@field guild_id uint64 @公会id
---@field guild_name string @公会名称
---@field score uint64 @排名积分
---@field rank number @排名
---@field member_list uint64__Array @要显示的关键玩家(id)列表

---@class SelfRankArg
---@field board_id number @排行榜id
---@field key_id uint64 @玩家是玩家id，公会是公会id
---@field date_index number @

---@class SelfRankRes
---@field result ErrorCode @
---@field rank number @第x名

---@class DelLeaderBoardArg
---@field key_id uint64 @角色id/公会id
---@field board_id_list number__Array @排行榜id
---@field data_index number @历史榜

---@class DelLeaderBoardRes
---@field result ErrorCode @

---@class LevelRankChangeData
---@field rank_params LevelRankChangeParam__Array @

---@class LevelRankChangeParam
---@field role_id uint64 @
---@field rank number @

---@class LeaderBoardSendAwardArg
---@field com_list number__Array @要发奖的comid列表(id,是否清榜)

---@class LeaderBoardSendAwardRes
---@field result ErrorCode__Array @

---@class SendGuildRedEnvelopeArg
---@field red_envelope_type RedEnvelopeType @红包类型
---@field words string @寄语或者口令
---@field diamond_reward_id number @红包金额id
---@field number number @红包个数

---@class SendGuildRedEnvelopeRes
---@field error_code ErrorCode @

---@class GuildRedEnvelopeInfo
---@field guild_red_envelope_id uint64 @红包id
---@field sender_role_id uint64 @红包发送者id
---@field sender_role_name string @红包发送者名字
---@field red_envelope_type RedEnvelopeType @红包类型
---@field red_envelope_total_num number @红包总个数
---@field is_received boolean @是否已领取
---@field is_finished boolean @红包是否已经领完
---@field words string @寄语/口令

---@class GetGuildRedEnvelopeInfoArg
---@field guild_red_envelope_id PBuint64__Array @红包id

---@class GetGuildRedEnvelopeInfoRes
---@field error_code ErrorCode @
---@field guild_red_envelope_info GuildRedEnvelopeInfo__Array @公会红包信息

---@class GrabGuildRedEnvelopeArg
---@field guild_red_envelope_id uint64 @公会红包id
---@field guild_red_envelope_password string @公会红包口令(可为空)

---@class GrabGuildRedEnvelopeRes
---@field error_code ErrorCode @
---@field is_new_grab boolean @是否获得了新的红包[而不只是获得了结果]
---@field grab_guild_red_envelope_info GuildRedEnvelopeInfo @抢红包结果信息
---@field grab_guild_red_envelope_list GrabGuildRedEnvelopeResult__Array @

---@class GrabGuildRedEnvelopeResult
---@field role_id uint64 @
---@field role_name string @
---@field items ItemBrief__Array @领取的物品
---@field member_base_info MemberBaseInfo @

---@class GetRedEnvelopeCountInfoArg
---@field rpcid number @
---@field role_id uint64 @
---@field role_count_type int64 @
---@field role_count_id int64 @
---@field is_need_increase boolean @0:无需增加次数,1:需要增加次数
---@field diamond_zeny_id number @发红包流程透传RPC扣钻石用
---@field red_envelope_id uint64 @抢红包流程透传RPC红包ID
---@field words string @抢红包流程透传RPC红包口令
---@field red_envelope_arg SendGuildRedEnvelopeArg @创建红包信息[透传]

---@class GetRedEnvelopeCountInfoRes
---@field error_code ErrorCode @
---@field count int64 @当前数量
---@field is_limited boolean @是否达到上限

---@class IncrRedEnvelopCountArg
---@field role_id uint64 @
---@field role_couny_type int64 @
---@field role_count_id int64 @

---@class IncrRedEnvelopCountRes
---@field error_code ErrorCode @
---@field after_increase_count int64 @增长后的值

---@class GetGuildRedEnvelopeResultArg
---@field red_envelope_id uint64 @

---@class GetGuildRedEnvelopeResultRes
---@field error_code ErrorCode @
---@field guild_red_envelope_info GuildRedEnvelopeInfo @
---@field grab_guild_red_envelope_result GrabGuildRedEnvelopeResult__Array @

---@class SaveRedEnvelopeRecordArg
---@field db_op_type DbOpType__Array @
---@field id uint64__Array @
---@field expired number__Array @
---@field field_name_list string__Array @
---@field field_data_list string__Array @
---@field mtime uint64 @

---@class SaveRedEnvelopeRecordRes
---@field error_code ErrorCode @

---@class GuildRedEnvelopeAllInfo
---@field red_envelope_uuid uint64 @
---@field sender_role_id uint64 @
---@field sender_role_name string @
---@field sender_guild_id uint64 @
---@field type RedEnvelopeType @
---@field words string @
---@field diamond_reward_id number @
---@field consume_type number @
---@field reward_type number @
---@field red_envelope_numbe number @
---@field generate_time number @
---@field is_expired boolean @是否过期
---@field envelope_list int64__Array @
---@field grab_result RedEnvelopeReceiver__Array @
---@field is_need_return boolean @是否需要返还剩余红包

---@class RedEnvelopeReceiver
---@field role_id uint64 @
---@field role_name string @
---@field reward_num int64 @

---@class QueryRedEnvelopeArg

---@class QueryRedEnvelopeRes
---@field error_code ErrorCode @
---@field red_envelope_id uint64__Array @
---@field red_envelope_all_info GuildRedEnvelopeAllInfo__Array @

---@class RedEnvelopePassword
---@field password string @
---@field role_id uint64 @抢口令红包发送口令的人

---@class ReturnPrizeTaskInfo
---@field returntaskid number @回归奖励任务id
---@field step number @进度
---@field isprizetaken boolean @奖励是否已经拿取

---@class ReturnPrize
---@field returntasks ReturnPrizeTaskInfo__Array @回归任务
---@field returnprizetype number @回归奖励类型，四档在配置文件里。
---@field loginaward ReturnPrizeLoginAward @登录奖励
---@field welcome ReturnPrizeWelcome @欢迎流程
---@field tag_new_gifts number__Array @可领的萌新礼包
---@field tag_new_gifts_got number__Array @已领的萌新礼包

---@class ReturnPrizeNtf
---@field returntasks ReturnTasks @回归任务的状态，收到这一条重置整个界面
---@field endtime uint64 @结束时间点
---@field loginaward ReturnPrizeLoginAward @登录奖励进度
---@field returnprizetype number @回归奖励的档位，四档

---@class ReturnTaskInfo
---@field taskid number @回归任务id，参考ReturnTask.csv
---@field step number @当前进度
---@field isfinish boolean @是否完成
---@field istaken boolean @true表示奖励已经领取了

---@class ReturnTasks
---@field allreturntasks ReturnTaskInfo__Array @所有回归任务进度

---@class ReturnPrizeTaskUpdateInfoNtf
---@field returntasks ReturnTasks @更新界面

---@class GetReturnTaskPrizeReq
---@field returntaskid number @参考ReturnTask.csv

---@class GetReturnTaskPrizeRes
---@field result ErrorCode @简单返回，更新界面走更新协议，

---@class ReturnPrizeLoginAward
---@field logincount number @获取回归状态以后，登录次数
---@field dailyawardsindex number__Array @每日登录可以领取的礼包队列，存放的是奖励的数组下标，需要结合配表查询
---@field sumdayawardsindex number__Array @累计登录可领取的奖励列表，存放的是奖励的数组下标，需要结合配表查询
---@field finisheddailyawardsindex number__Array @已经领取的每日奖励下标
---@field finishedsumdayawardsindex number__Array @已经领取的累计登录奖励下标

---@class GetReturnLoginPrizeReq
---@field isdaily boolean @true 表示要领取每日登录奖励，false表示要领取累计登录奖励
---@field index number @奖励的数组下标

---@class GetReturnLoginPrizeRsp
---@field result ErrorCode @结果
---@field isdaily boolean @请求中的值返回
---@field index number @请求中的值返回

---@class ReturnPrizeWelcome
---@field status ReturnPrizeWelcomeStatus @根据不同的状态
---@field afkdays number @离开的具体天数

---@class ReturnPrizeWelcomeInfo
---@field status ReturnPrizeWelcomeStatus @ReturnPrizeWelcomeStatus当前的状态，根据状态选择不同的结构来做。
---@field prizeid number @见面礼id，status==kReturnPrizeWelcomeStatus_prize
---@field friends uint64__Array @好友列表，准备把礼盒发送过去 status==kReturnPrizeWelcomeStatus_friend_prize会用到
---@field guilds ReturnPrizeWelcomeGuild__Array @推荐的公会，status == kReturnPrizeWelcomeStatus_join_guild 会用到
---@field afkdays number @离线天数

---@class ReturnPrizeWelcomeNextReq
---@field status ReturnPrizeWelcomeStatus @ReturnPrizeWelcomeStatus返回服务器下发的状态，服务器后台也记了一个状态，用这个状态来做数据结构。
---@field chozenfriends uint64__Array @选中的好友id列表，只有状态是对应的才起作用

---@class ReturnPrizeWelcomeNextRsp
---@field welcomeinfo ReturnPrizeWelcomeInfo @根据具体状态发送具体的内容
---@field result ErrorCode @错误码

---@class ReturnPrizeWelcomeGuild
---@field guildid uint64 @公会id
---@field guildname string @公会名字
---@field friendcount number @好友数量
---@field maxcount number @当前人数上限
---@field currentcount number @当前人数
---@field iconid number @icon 的id

---@class GetReturnPrizeWelcomeGuildsReq
---@field roleid uint64 @

---@class GetReturnPrizeWelcomeGuildsRsp
---@field guilds ReturnPrizeWelcomeGuild__Array @返回的公会信息
---@field result ErrorCode @

---@class ReturnPrizeWelcomeNotify
---@field status ReturnPrizeWelcomeStatus @当前的进度，客户端只用来判断一些逻辑

---@class StateExclusionFailData
---@field from_state_type_list PBint32__Array @
---@field to_state_type number @

---@class TransferProfessionData
---@field role_type RoleType @

---@class ReadRoleBriefDataArg
---@field role_id uint64 @
---@field rpc_id number @
---@field index number @
---@field server_id number @
---@field mtime uint64 @

---@class ReadRoleBriefDataRes
---@field result ErrorCode @
---@field role_brief RoleBrief @

---@class GsReadRoleDataArg
---@field role_list ReadRoleBriefInfo__Array @
---@field rpc_id number @
---@field server_id number @
---@field mtime uint64 @

---@class GsReadRoleDataRes
---@field result ErrorCode @
---@field role_list RoleAllInfo__Array @

---@class MsReadRoleDataArg
---@field role_list ReadRoleBriefInfo__Array @
---@field rpc_id number @
---@field index number @
---@field read_unique_id number @批量读的唯一标识
---@field mtime uint64 @

---@class MsReadRoleDataRes
---@field result ErrorCode @
---@field role_list RoleAllInfo__Array @

---@class SyncRoleInfoChangeToMsData
---@field level number @
---@field job_lv number @
---@field role_type RoleType @
---@field fashion_record FashionRecord @
---@field equips Equips @
---@field elo number @
---@field recent_ten_win_times number @
---@field opened_system_list number__Array @
---@field closed_system_list number__Array @
---@field setup_info SetupInfoData @
---@field change_name_count number @
---@field achievement_point number @
---@field currentdiamond int64 @
---@field currentrob int64 @
---@field currentzeny int64 @
---@field sticker StickerBaseInfo @
---@field personal_setting PearsonalSetting @个人设置
---@field title_id number @称号id
---@field tag number @
---@field total_recharge int64 @历史充值数量
---@field total_login_days number @累计登录天数
---@field currentcoin104 int64 @货币104
---@field chat_icons ChatTagRecord @聊天个性化图案

---@class QueryRoleBriefInfoArg
---@field role_ids PBuint64__Array @
---@field query_type QueryRoleBriefType @

---@class QueryRoleBriefInfoRes
---@field base_infos MemberBaseInfo__Array @
---@field error ErrorCode @
---@field query_type QueryRoleBriefType @

---@class OperateRecentMateInfoArg
---@field uid uint64 @
---@field type number @操作类型 1是读 2是存
---@field rpc_id number @
---@field info RepeatMateInfo @
---@field mtime uint64 @

---@class OperateRecentMateInfoRes
---@field code ErrorCode @
---@field info RepeatMateInfo @

---@class RecentMateInfo
---@field mate_id uint64 @
---@field timestamp uint64 @

---@class RepeatMateInfo
---@field info RecentMateInfo__Array @

---@class GetValidNameArg
---@field sex SexType @

---@class GetValidNameRes
---@field code ErrorCode @
---@field name string @

---@class MsGetRoleModuleInfoArg
---@field rpc_id number @
---@field role_modules MsRoleModuleFlag__Array @
---@field server_id number @

---@class MsGetRoleModuleInfoRes
---@field result ErrorCode @
---@field role_modules MsRoleModuleData__Array @

---@class MsRoleModuleData
---@field uid uint64 @
---@field module_flag uint64 @
---@field friend_info RoleFriendPbInfo @
---@field role_message RoleMessagePbInfo @
---@field role_info RoleAllInfo @
---@field role_mail RoleMailPbInfo @
---@field role_gift_limit RoleGiftLimitPbInfo @
---@field role_account RoleBriefInfo @玩家账号信息
---@field counter RoleCounterInfo @玩家角色相关
---@field chatforbidrole RoleChatForbidInfo @屏蔽聊天的名单

---@class MsRoleModuleFlag
---@field role_uid uint64 @
---@field module_flag uint64 @
---@field account string @
---@field role_index number @

---@class SaveMsRoleModuleData
---@field uid uint64 @
---@field friend_info RoleFriendPbInfo @
---@field chat_message RoleMessagePbInfo @
---@field gift_limit RoleGiftLimitPbInfo @
---@field counter RoleCounterInfo @
---@field mtime uint64 @
---@field chatforbidrole RoleChatForbidInfo @屏蔽聊天的名单

---@class RoleItemChangeArg
---@field item_change_reason ItemChangeReason @
---@field add_item_list Ro_Item__Array @
---@field remove_item_list RoleItemChangeInfo__Array @
---@field bag_full_check boolean @
---@field call_back_param PayCallBackParam @钻石的参数
---@field is_all boolean @全部上交

---@class RoleItemChangeRes
---@field error ErrorInfo @

---@class RoleItemChangeInfo
---@field item_uuid uint64 @
---@field item_id number @
---@field item_count int64 @
---@field add_bind boolean @
---@field remove_unbind boolean @

---@class PraiseData
---@field uuid uint64 @被赞着id
---@field name string @被赞着昵称

---@class RoleSyncInfo
---@field level number @
---@field opened_system_list number__Array @
---@field closed_system_list number__Array @

---@class RoleOnlineData
---@field role_uid uint64 @上线的玩家uid
---@field is_online boolean @
---@field friend_data FriendInfo @如果上线的是我的好友，并且好友度超过指定值，这个字段为好友结构，或者为空
---@field is_need_notice boolean @是否提示上下线

---@class SaveReviveRecordArg
---@field scene_id number @

---@class SaveReviveRecordRes
---@field result ErrorCode @

---@class RoleSearchArg
---@field match_name string @匹配名字

---@class RoleSearchRes
---@field result ErrorCode @
---@field match_role_list MemberBaseInfo__Array @匹配出来的角色列表

---@class OnlineNumNtf
---@field timekey uint64 @
---@field serverid number @
---@field zoneid number @
---@field iosnum number @
---@field androidnum number @
---@field appid GameAppType @

---@class ChangeRoleNameArg
---@field newrolename string @新玩家名字
---@field rpcid number @
---@field roleid uint64 @
---@field account string @

---@class ChangeRoleNameRes
---@field errcode ErrorCode @返回值
---@field newrolename string @返回成功新的玩家名字

---@class RoleNameChangeNtf
---@field newrolename string @新的名字
---@field roleid uint64 @

---@class UnLockRoleIllutrationArg
---@field type number @
---@field id number @

---@class UnLockRoleIllutrationRes
---@field result ErrorCode @
---@field id number @

---@class FirstKillMonsterInfo
---@field id number @

---@class FadeInOutData
---@field time number @持续时间
---@field in_out number @0:渐入渐出
---@field in_time number @渐入时长
---@field out_time number @渐出时长

---@class SelectSlotIndex
---@field slot_index number @选择序号
---@field role_uid int64 @
---@field account_id string @
---@field server_id number @
---@field mtime uint64 @

---@class CancelTransfigureArgs

---@class CancelTransfigureRes
---@field result ErrorCode @

---@class OptionsChoiceData
---@field before_id number @
---@field after_id number @
---@field option_type number @

---@class GetTutorialMarkArg

---@class GetTutorialMarkRes
---@field result ErrorCode @
---@field tutorial_mark TutorialMark @

---@class UpdateTutorialMarkArg
---@field tutorial_id number @

---@class UpdateTutorialMarkRes
---@field result ErrorCode @

---@class GetPostcardDisplayArg

---@class GetPostcardDisplayRes
---@field result ErrorCode @
---@field table_ids PBint32__Array @
---@field chapter_ids number__Array @

---@class UpdatePostcardDisplayArg
---@field table_id number @

---@class UpdatePostcardDisplayRes
---@field result ErrorCode @

---@class DeleteRoleArg
---@field role_uid uint64 @

---@class DeleteRoleRes
---@field result ErrorCode @
---@field role_brief_data RoleBriefInfo @
---@field select_role_index number @
---@field role_uid uint64 @

---@class ResumeRoleArg
---@field role_uid uint64 @
---@field role_index number @

---@class ResumeRoleRes
---@field result ErrorCode @
---@field role_uid uint64 @
---@field role_index number @
---@field role_brief_data RoleBriefInfo @

---@class SaveAccountDataArg
---@field role_uid uint64 @
---@field role_index number @
---@field account string @
---@field status RoleStatusType @
---@field delete_time uint64 @
---@field last_select number @
---@field server_id number @
---@field rpc_id number @
---@field mtime uint64 @

---@class SaveAccountDataRes
---@field account string @
---@field role_uid uint64 @
---@field brief_data RoleBriefInfo @
---@field result ErrorCode @

---@class GetAccountRoleDataArg
---@field account string @帐号（openid）

---@class GetAccountRoleDataRes
---@field result ErrorCode @
---@field account_data LoadAccountData @

---@class AccountInfoData
---@field op_type AccountOpType @
---@field role_uid uint64 @
---@field status RoleStatusType @
---@field delete_time uint64 @

---@class AttrRaisedArg
---@field num number @
---@field enable boolean @

---@class AttrRaisedRes
---@field result ErrorCode @

---@class RoleGiveRewardArg
---@field rpcid number @
---@field reason ItemChangeReason @
---@field role_id uint64 @
---@field reward_id number @

---@class RoleGiveRewardRes
---@field error_code ErrorCode @

---@class RoleIdData
---@field server_id number @
---@field account_id string @
---@field role_id uint64 @

---@class RoleCounterInfo
---@field last_refresh_time int64 @
---@field infos SingleCountInfo__Array @

---@class SingleCountInfo
---@field type number @
---@field id int64 @
---@field refresh_type number @
---@field count int64 @

---@class PlayAnimAction
---@field entity_uuid uint64 @
---@field action_id number @
---@field can_not_interrupt boolean @动作无法打断

---@class PreCheckOperateLegalRes
---@field result ErrorCode @

---@class PreCheckOperateLegalArg
---@field operate_type number @自拍、表情动作等

---@class CheckRoleStateLegalArg
---@field state_type MutexStateType @
---@field delay_rpc_id number @

---@class CheckRoleStateLegalRes
---@field result ErrorCode @

---@class RoleActivityStatus
---@field role_activity_status RoleActivityStatusType @

---@class RoleActivityStatusNtfArg
---@field role_activity_type RoleActivityStatusType @

---@class RoleActivityStatusNtfRes
---@field error_code ErrorCode @
---@field rest_time number @活动剩余时间

---@class CallBlackCurtainData
---@field id number @调用的id
---@field type CallBackType @要调用的类型

---@class GetJobAwardArg
---@field profession_id number @
---@field level number @

---@class GetJobAwardRes
---@field error ErrorCode @

---@class UpdatePostcardChapterAwardArg

---@class UpdatePostcardChapterAwardRes
---@field result ErrorCode @

---@class RoleDetachedArg
---@field is_passive boolean @是否是被动脱离卡死

---@class RoleDetachedRes
---@field result ErrorCode @结果
---@field the_rest_time uint64 @还剩下多少时间

---@class HealthExpData
---@field extra_base_exp int64 @baseexp当前剩余量
---@field extra_job_exp int64 @jobexp当前剩余量
---@field battle_base_exp int64 @昨日剩余战斗base经验
---@field delegate_ticket number @昨日剩余委托卷
---@field battle_job_exp int64 @昨日战斗剩余job经验
---@field month_card boolean @当日5点时是否月卡状态

---@class RoleAttribute
---@field role_id uint64 @玩家id
---@field attr_id RoleAttributeId @属性id
---@field attr_value number @属性值

---@class PayRoleReadOnlineRoleArg
---@field last_role_uid uint64 @
---@field max_count number @

---@class PayRoleReadOnlineRoleRes
---@field error_code ErrorCode @
---@field role_list PayRolePbInfo__Array @

---@class PayRoleAddNotifyInfo
---@field role_list PayRolePbInfo__Array @

---@class PayRoleRemoveNotifyData
---@field role_list uint64__Array @

---@class RoleIdAndName
---@field role_id int64 @
---@field role_name string @

---@class GetBoliAwardArg
---@field type number @领奖type
---@field id number @波利id或者区域id
---@field count number @波利个数信息

---@class GetBoliAwardRes
---@field type number @
---@field id number @
---@field count number @
---@field result ErrorCode @

---@class RoleNurturanceTlogData
---@field type number @
---@field Progress string @
---@field operate_type number @
---@field recommend_system_id string @
---@field recommend_type number @
---@field select_system_id number @

---@class QueryRoleSmallPhotoArg
---@field role_id_list uint64__Array @要查询的玩家id列表

---@class LifeSkillUpgradeArg
---@field type LifeSkillType @生活职业类型
---@field cost_type number @消耗类型：1 辅助材料 2 替代材料

---@class QueryRoleSmallPhotoRes
---@field photo_list RoleSmallPhotoData__Array @头像数据

---@class LifeSkillUpgradeRes
---@field result ErrorCode @
---@field level number @

---@class RecallOperateArg
---@field auto_recall boolean @祝福时间消耗完毕自动回城选项
---@field five_recall boolean @每日五点自动回城的勾选项
---@field cancle_recall boolean @取消回城

---@class RecallOperateRes
---@field result ErrorCode @

---@class RoleRecallData
---@field reason number @
---@field left_time number @回城倒计时时间

---@class ChangeStyleArg
---@field hair_id number @
---@field eye EyeInfo @

---@class ChangeStyleRes
---@field result ErrorCode @

---@class FashionLevelChangeData
---@field pre_level number @
---@field new_level number @

---@class PostcardOneChapterAwardArg
---@field chapter_id number @章节ID

---@class PostcardOneChapterAwardRes
---@field result ErrorCode @

---@class CrossSceneInfo
---@field map_id number @
---@field scene_id number @
---@field gsline number @

---@class GetSceneInfoRes
---@field scenes CrossSceneInfo__Array @

---@class CreateBattleCrossArg
---@field rpc_id number @
---@field map_id number @
---@field scene_id number @
---@field line number @
---@field param CreateBattleParam @
---@field uid uint64 @

---@class CreateBattleCrossRes
---@field result ErrorCode @

---@class RoleEnterCrossSceneNtf
---@field scene_id number @
---@field scene_unique_id number @
---@field rolelist uint64__Array @

---@class CrossSceneDestoryed
---@field scene_unique_id number @

---@class StaticSceneDestoryArg
---@field unique_id number__Array @

---@class StaticSceneDestoryRes
---@field result ErrorCode @

---@class EnterDungeonsData
---@field dungeons_id number @
---@field role_id uint64 @

---@class SyncTakePhotoNotify
---@field role_id uint64 @角色id
---@field take_photo_status number @拍照状态
---@field take_photo_type number @

---@class BroadcastTakePhotoStatus
---@field take_photo_status number @当前拍照状态
---@field take_photo_type number @

---@class NearbyMapArg
---@field from_scene_id number @来源sceneid
---@field nearby_scene_id number @需要判断sceneid

---@class NearbyMapRes
---@field result ErrorCode @返回码

---@class EasyNavigateArg
---@field scene_map_id number @目标场景id
---@field position Vec3 @目标坐标
---@field dest_face number @方便客户端使用的目标face, 服务器不用填充
---@field dest_type NavigationDestType @目的地类型
---@field navi_method NavigationMethodType @客户端寻路方式
---@field big_type NavBigType @便捷寻路方式
---@field sequence number @寻路自增id
---@field range number @客户端使用的有效半径，服务器不填充

---@class EasyNavigateRes
---@field result ErrorCode @

---@class EnterSceneWallArg
---@field player_uuid uint64 @玩家uid
---@field wall_uuid uint64 @墙uid
---@field now_position Vec3 @当前位置
---@field box_id number @
---@field is_check_in_one_box_range boolean @用来标志检测是否在某个box内

---@class EnterSceneWallRes
---@field result ErrorCode @

---@class GetSceneYArg
---@field rpc_id number @延迟id
---@field x number @x
---@field z number @z
---@field scene_id number @场景id
---@field uuid uint64 @用户id
---@field navi_method NavigationMethodType @客户端寻路方式

---@class GetSceneYRes
---@field scene_id number @场景id
---@field y number @y
---@field result ErrorCode @

---@class GetSceneYTransformArg
---@field scene_id number @场景id
---@field rpc_id number @延迟id
---@field x number @x
---@field z number @z
---@field unique_id number @唯一id
---@field navi_method NavigationMethodType @客户端寻路方式

---@class GetSceneYTransformRes
---@field scene_id number @场景id
---@field y number @y
---@field result ErrorCode @返回码

---@class BossTimelineData
---@field timeline_name string @

---@class GuideData
---@field position Vec3 @
---@field scene_id number @目标场景id

---@class LeaveSceneWallData
---@field player_uuid uint64 @
---@field wall_uuid uint64 @
---@field dest Vec3 @终点坐标

---@class LeaveSceneWallRespData
---@field wall_uuid uint64 @墙uuid
---@field type LeaveWallType @离开方式
---@field dest Vec3 @通过认证的合法点

---@class BackToStaticArg
---@field rpc_id number @
---@field error_code ErrorCode @

---@class BackToStaticRes
---@field error ErrorCode @

---@class StaticSceneLineArg
---@field scene_id number @

---@class StaticSceneLineRes
---@field result ErrorCode @
---@field scene_id number @
---@field lines SceneLineData__Array @

---@class SceneLineData
---@field line number @
---@field status SceneLineStatus @

---@class ChangeSceneLineArg
---@field scene_id number @
---@field line number @

---@class ChangeSceneLineRes
---@field result ErrorCode @

---@class DirTeleportData
---@field sceneid number @目标场景ID
---@field npcid number @传送依据

---@class DirTeleportDataRes
---@field result ErrorCode @返回码

---@class EnterGuildSceneData
---@field dungeon_id number @

---@class CutSceneData
---@field id number @cutscene配表id

---@class EnterSceneTriggerObjectRes
---@field result ErrorCode @

---@class CPURate
---@field cpu_rate number @
---@field gs_line number @

---@class SingleTimeLineData
---@field timelineid number @
---@field time int64 @毫秒
---@field end_type SingleTimeLineEndType @结束type

---@class EnterTriggerFishpondArg
---@field trigger_object_uuid uint64 @
---@field player_face number @玩家朝向

---@class EnterTriggerFishpondRes
---@field result ErrorCode @

---@class FishpondWaterData
---@field water_center_x number @
---@field water_center_y number @
---@field water_center_z number @
---@field water_radius number @

---@class AISyncVarData
---@field key_list string__Array @
---@field value_list string__Array @
---@field type_list PBint32__Array @

---@class SendToSceneAIData
---@field event_name string @事件名
---@field entity_uuid uint64 @entity的uuid

---@class AIStartCommandData
---@field id number @指定npc/monster的id
---@field tag string @剧本tag
---@field command_script string @剧本
---@field callback_ai_event string @剧本回调AI事件

---@class OnSceneTrggerToClienArg
---@field group_id number @
---@field trigger_id number @
---@field result_id number @
---@field timing_type number @
---@field object_id number @

---@class TimingPlayerButtonInfo
---@field scene_trigger_object_id number @

---@class CommandScriptInfo
---@field name string @事件名

---@class FindElfArg
---@field elf_uuid uint64 @

---@class NpcTalkArgs
---@field npc_uuid uint64 @
---@field enable boolean @

---@class FindElfRes
---@field res ErrorCode @

---@class EasyShowNavigateArg
---@field scene_map_id number @目标地图id
---@field position Vec3 @目标地图位置
---@field dest_type NavigationDestType @目标类型
---@field need_running boolean @是否需要跑

---@class EasyShowNavigateRes
---@field result ErrorCode @返回码
---@field paths EasyPath__Array @展示路径

---@class RegisterGs2NsArg
---@field serverid number @
---@field line number @
---@field addrList ListenAddress__Array @
---@field allscene SceneStatInfo__Array @目前所有场景的信息,用来做异常掉线处理.

---@class RegisterGs2NsRes
---@field result ErrorCode @
---@field lineList number__Array @
---@field addrList ListenAddress__Array @
---@field proxyaddr ProxyAddr__Array @

---@class SceneStatInfo
---@field uniqueid number @唯一id
---@field sceneid number @场景id
---@field rolenum number @场景内人数
---@field camp_num_list number__Array @阵营人数列表

---@class EnterSceneData
---@field role_id uint64 @

---@class SwichSceneBGMData
---@field bgm_index number @
---@field duration number @
---@field nth_bgm number @
---@field dance_action_group_id number @

---@class SceneTriggerGroupCtlData
---@field enable boolean @是否开启
---@field group_id number @触发器组id
---@field trigger_id number @触发器id（整组填-1）

---@class SessionSwitchingSceneData
---@field session_id uint64 @
---@field is_switch boolean @

---@class SessionSwitchingSceneArg
---@field session_id uint64 @
---@field leave_type LeaveSceneType @
---@field param number @
---@field cache boolean @

---@class SessionSwitchingSceneRes
---@field error_code ErrorCode @

---@class RandomNavigateArg
---@field scene_map_id number @目标地图id
---@field position Vec3 @目标地图位置
---@field search_radius number @半径

---@class RandomNavigateRes
---@field result ErrorCode @
---@field scene_map_id number @目标地图id
---@field position Vec3 @

---@class BackToStaticAllData
---@field unique_id int64 @
---@field error_code ErrorCode @

---@class CutSceneTeleportArg
---@field id number @cutscene配置表的id

---@class CutSceneTeleportRes
---@field result ErrorCode @

---@class TreasureChestInfo
---@field uid uint64 @
---@field type number @0勘测器 1宝箱
---@field role_id int64 @
---@field role_name string @
---@field finish_time int64 @
---@field total_time int64 @

---@class RepeatTreasureChestInfo
---@field detector TreasureChestInfo__Array @

---@class HelpTreasureArg
---@field uid uint64 @

---@class HelpTreasureRes
---@field errcode ErrorCode @

---@class GetTreasurePanelInfoArg
---@field uid uint64 @

---@class GetTreasurePanelInfoRes
---@field errcode ErrorCode @
---@field finish_time uint64 @
---@field total_time number @
---@field total_depth number @
---@field current_depth number @
---@field role_id int64 @
---@field role_name string @
---@field treasure_award_id number @魔物宝藏奖励，拥有者和非拥有者不一样
---@field scene_line number @场景所在线
---@field pos Vec3 @位置
---@field award_id number @拥有者奖励id
---@field is_help boolean @是否帮助过

---@class TreasureData
---@field treasure_uid uint64 @宝箱id
---@field owner_collect_times number @拥有者采集次数
---@field other_collect_times number @其他玩家采集次数

---@class StartTreasureHunterArg

---@class StartTreasureHunterRes
---@field err ErrorCode @
---@field result number @

---@class CaptainRequestEnterSceneData
---@field scene_id number @场景id
---@field captain_uuid uint64 @队长uuid

---@class CheckMemberQualificationForSceneArg
---@field role_uuid uint64 @角色uuid
---@field scene_id number @场景id

---@class CheckMemberQualificationForSceneRes
---@field result ErrorCode @结果
---@field reason FailEnterFBReason @进入失败的原因

---@class SceneEventInstanceInfo
---@field event_id number @
---@field instance_id uint64 @
---@field scene_uuid number @
---@field kill_time uint64 @上次击杀时间

---@class SceneEventInstanceSyncNotifyInfo
---@field add_instance_list SceneEventInstanceInfo__Array @
---@field remove_instance_list SceneEventInstanceInfo__Array @
---@field all_sync boolean @

---@class GetMVPInfoArg

---@class GetMVPInfoRes
---@field mvp_list MVPInfo__Array @

---@class MVPInfo
---@field id number @
---@field is_refresh boolean @
---@field refresh_time number @
---@field has_final_killer boolean @
---@field final_killer_name string @
---@field best_name string @

---@class GetMVPRankInfoArg
---@field id number @

---@class GetMVPRankInfoRes
---@field mvp_team_member MVPMemberInfo__Array @排行第一名的队伍成员列表
---@field result ErrorCode @

---@class MVPRecordPbInfo
---@field mvp_id number @
---@field event_id number @
---@field event_instance_id uint64 @
---@field first_attack_id uint64 @
---@field first_attack_name string @
---@field final_killer_id uint64 @
---@field final_killer_name string @
---@field final_kill_time int64 @击杀这个mvp的用时
---@field best_team MVPRecordRankPbInfo @团队奖队伍
---@field be_killed_count number @累计被击杀次数
---@field max_injury_id uint64 @最高承受伤害玩家
---@field max_injury_name string @
---@field max_cure_id uint64 @最高有效治疗玩家
---@field max_cure_name string @
---@field max_dps_id uint64 @最高输出玩家
---@field max_dps_name string @
---@field role_dead_count number @
---@field next_create_time uint64 @下次刷新时间

---@class MVPRecordRankPbInfo
---@field is_team boolean @
---@field team_id uint64 @
---@field team_name string @
---@field score int64 @
---@field rank number @
---@field role_list MVPRecordRolePbInfo__Array @

---@class MVPRecordRolePbInfo
---@field id uint64 @
---@field name string @
---@field sex number @
---@field score int64 @
---@field dead_time number @死亡次数

---@class MVPRankInfo
---@field is_team boolean @
---@field sex number @
---@field name string @
---@field score number @
---@field rank number @

---@class GetAllMvpRecordArg

---@class GetAllMvpRecordRes
---@field allrecords MVPRecordPbInfo__Array @
---@field errcode ErrorCode @

---@class UpdateMVPRecord
---@field mvprecord MVPRecordPbInfo @
---@field mtime uint64 @

---@class MVPDeadInfo
---@field entity_id uint64 @最后击杀者uid
---@field mvp_id number @
---@field best_uid uint64 @mvp玩家uid
---@field mvp_team_uids PBuint64__Array @

---@class MVPMemberInfo
---@field member_info MemberBaseInfo @
---@field score int64 @

---@class PlatformJumpFloorEvent
---@field roleids uint64__Array @
---@field floor number @

---@class MVPRecordAddRequestArg
---@field scene_line number @
---@field scene_uuid number @
---@field record_info MVPRecordPbInfo @
---@field team_list MvpTeamResultInfo__Array @参与奖队伍信息

---@class MVPRecordAddRequestRes
---@field error_code ErrorCode @
---@field is_record boolean @

---@class MVPFinishNotifyInfo
---@field mvp_id number @
---@field event_id number @

---@class MVPCreatArg

---@class MVPConfigData
---@field mvp_id number @mvp 配置id
---@field kill_time int64 @上次被击杀的时间 单位秒

---@class MVPCreateRes
---@field mvp_configs MVPConfigData__Array @mvp可记录数据

---@class MvpTeamResultData
---@field team_result_list MvpTeamResultInfo__Array @
---@field event_id number @

---@class MvpTeamResultInfo
---@field score number @分数
---@field role_list MvpRoleResult__Array @
---@field role_num number @获奖成员个数
---@field dead_times number @死亡次数

---@class MvpRoleResult
---@field score number @
---@field dead_times number @
---@field role_id uint64 @

---@class ServerSyncInfo
---@field opened_system_list number__Array @
---@field closed_system_list number__Array @
---@field role_close_list OpenSystemSyncInfo__Array @
---@field open_server_time int64 @

---@class AgreementToFmData
---@field open_id string @
---@field push_set number @

---@class AgreementToFmAllData
---@field agreement_data AgreementToFmData__Array @

---@class MaintainServerStatusReq
---@field operation MaintainServerInfo @具体的操作
---@field requestid number @请求id用来返回json给平台
---@field isbroadcast boolean @true表示更改内存之后，还要做落地和下发下线服务器

---@class MaintainServerStatusRes
---@field result number @

---@class QueryMaintainServerReq
---@field platid number @平台id
---@field areaid number @大区id
---@field requestid number @请求id，用来返回json给技术中心
---@field serverid number @如果指定serverid，就只返回这一个

---@class QueryMaintainServerRes
---@field operations MaintainServerInfo__Array @历史操作
---@field result number @

---@class MaintainServerInfo
---@field ids string @相同操作批次的id集合用竖线 |  隔开
---@field maintaininfo string @维护公告全文
---@field maintainendtime int64 @维护公告结束时间，客户端显示用
---@field operate number @0关闭维护，也就是开服默认状态，1开始维护。

---@class ServerXMLConfInfo
---@field max_register_num number @最大注册人数
---@field open_register number @注册开关
---@field queue_cnt number @进入排队人数
---@field choose_gs_type number @选择gs方案(轮询,cpu占比

---@class StallGetMarkInfoArg
---@field id number @

---@class StallGetMarkInfoRes
---@field error_code ErrorCode @
---@field mark_list StallMarkPbInfo__Array @
---@field next_refresh_time int64 @

---@class StallMarkPbInfo
---@field id number @
---@field count number @
---@field second_mark_list StallSecondMarkPbInfo__Array @

---@class StallGetItemInfoArg
---@field item_id number @

---@class StallGetItemInfoRes
---@field error_code ErrorCode @
---@field item_list StallItemPbInfo__Array @
---@field next_refresh_time int64 @

---@class StallItemPbInfo
---@field item_uuid int64 @
---@field item_info Ro_Item @
---@field item_price int64 @
---@field money int64 @
---@field left_time number @

---@class StallItemBuyArg
---@field item_uuid int64 @
---@field item_count int64 @

---@class StallItemBuyRes
---@field error ErrorInfo @

---@class StallRefreshArg

---@class StallRefreshRes
---@field error_code ErrorCode @

---@class StallGetSellInfoArg

---@class StallGetSellInfoRes
---@field error_code ErrorCode @
---@field item_list StallItemPbInfo__Array @

---@class StallGetPreSellItemInfoArg
---@field item_id number @

---@class StallGetPreSellItemInfoRes
---@field error_code ErrorCode @
---@field base_price int64 @

---@class StallSellItemArg
---@field item_list StallItemPbInfo__Array @

---@class StallSellItemRes
---@field error_code ErrorCode @

---@class StallSellItemCancelArg
---@field item_list PBint64__Array @

---@class StallSellItemCancelRes
---@field error ErrorInfo @

---@class StallDrawMoneyArg
---@field item_uuid int64 @

---@class StallDrawMoneyRes
---@field error_code ErrorCode @

---@class StallBuyStallCountArg

---@class StallBuyStallCountRes
---@field error_code ErrorCode @
---@field next_stall_unlock_price int64 @

---@class StallItemSoldNotifyInfo
---@field item_list StallItemPbInfo__Array @

---@class StallRefreshNotifyInfo
---@field role_id uint64 @
---@field account string @

---@class StallSellItemCostRes
---@field error_code ErrorCode @
---@field item_list Ro_Item__Array @

---@class StallSellItemCostArg
---@field cur_stall_count int64 @
---@field cost_item_id number @
---@field cost_item_count int64 @
---@field item_list StallItemPbInfo__Array @

---@class StallDbInfo
---@field base_price_list StallBasePriceDbInfo__Array @
---@field base_price_prev_list StallBasePriceDbInfo__Array @
---@field last_record_save_time int64 @
---@field record_list StallItemRecordDbInfo__Array @

---@class StallBasePriceDbInfo
---@field item_id number @
---@field base_price number @

---@class StallSellItemsDbInfo
---@field item_sell_list StallItemSellDbInfo__Array @

---@class StallItemSellDbInfo
---@field item_uuid int64 @
---@field item_info Ro_Item @
---@field total_count int64 @
---@field price int64 @
---@field money int64 @
---@field sell_end_time int64 @
---@field sell_delay_time int64 @
---@field invalid boolean @

---@class StallReSellItemArg
---@field item_uuid int64 @
---@field price int64 @

---@class StallReSellItemRes
---@field error_code ErrorCode @

---@class StallItemRecordDbInfo
---@field item_id number @
---@field sell_count int64 @
---@field buy_count int64 @
---@field buy_total_money int64 @
---@field buy_total_time int64 @

---@class StallSaveToDBInfo
---@field stall_info StallDbInfo @

---@class StallSaveRecordToDBInfo
---@field record_time int64 @
---@field record_list StallItemRecordDbInfo__Array @

---@class StallSaveRoleToDBInfo
---@field role_id uint64 @
---@field account string @
---@field info StallSellItemsDbInfo @
---@field mtime uint64 @

---@class StallRemoveRoleToDBInfo
---@field role_id uint64 @
---@field mtime uint64 @

---@class StallSecondMarkPbInfo
---@field id number @
---@field count number @

---@class StallSyncInfoGetGsArg

---@class StallSyncInfoGetGsRes
---@field error_code ErrorCode @
---@field sync_info StallSyncInfo @

---@class StallSyncInfo
---@field item_prices StallItemPriceList @
---@field item_stocks StallItemStockList @

---@class StallItemStockInfo
---@field item_id number @
---@field stock_num int64 @库存

---@class StallItemStockList
---@field stall_items StallItemStockInfo__Array @

---@class StallItemPrice
---@field item_id number @
---@field price int64 @

---@class StallItemPriceList
---@field item_prices StallItemPrice__Array @

---@class RequestUnlockGridArg
---@field index number @解锁格子的序号

---@class GridStateRes
---@field grid PBint32__Array @格子放置状态
---@field result ErrorCode @
---@field grid_unlock_status PBint32__Array @格子解锁状态

---@class GridStateArg
---@field no_use boolean @

---@class RequestChangeStickerArg
---@field sticker_id number @
---@field pos number @格子

---@class OwnStickersNtfData
---@field stickers_id PBint32__Array @

---@class GetOwnStickersArg
---@field no_use boolean @

---@class GetOwnStickersRes
---@field own_all_stickers_id PBint32__Array @
---@field result ErrorCode @

---@class PosToStickerId
---@field pos number @格子位置,从0开始
---@field sticker_id number @贴纸ID

---@class SaveStickersInGridArg
---@field pos_to_sticker_id PosToStickerId__Array @格子和贴纸ID

---@class SystemOpenDbInfo
---@field force_close_list number__Array @
---@field role_close_list SystemOpenRoleDbInfo__Array @
---@field lucky_point_system_enabled number @-1关闭/>=0开启

---@class OpenSystemSyncInfo
---@field account string @
---@field system_id number @
---@field is_open boolean @
---@field outdate_time int64 @
---@field reason string @
---@field role_id uint64 @
---@field is_global boolean @

---@class SystemOpenRoleDbInfo
---@field account string @
---@field role_id uint64 @
---@field system_id number @
---@field outdate_time int64 @
---@field reason string @

---@class MultiTalentData
---@field system_id number @
---@field plan_id number @方案id

---@class OpenMultiTalentArg
---@field data MultiTalentData @

---@class OpenMultiTalentRes
---@field result ErrorCode @
---@field data MultiTalentData @

---@class ChangeMultiTalentArg
---@field data MultiTalentData @

---@class ChangeMultiTalentRes
---@field result ErrorCode @
---@field data MultiTalentData @

---@class RenameMultiTalentArg
---@field data MultiTalentData @
---@field new_plan_name string @

---@class RenameMultiTalentRes
---@field result ErrorCode @
---@field data MultiTalentData @
---@field new_plan_name string @

---@class OpenSystemChangeData
---@field open_system number__Array @
---@field close_system number__Array @

---@class TaskUpdateData
---@field tasks TaskInfo__Array @

---@class TaskAcceptFailed
---@field taskid number @任务id
---@field errcode ErrorCode @错误码
---@field membername string @不满足条件的玩家名字

---@class TaskInfo
---@field task_id number @
---@field status TaskStatus @
---@field status_time uint64 @可接或者已经时间
---@field targets TaskTargetInfo__Array @
---@field finish_count number @
---@field acceptting_time uint64 @可接时间,只有可接的时候进行赋值
---@field accept_npc TaskNpc @接取NPC
---@field finish_npc TaskNpc @交付NPC

---@class TaskTargetInfo
---@field type TaskTargetType @
---@field target_id number @目标id(monster id等)
---@field step number @
---@field max_step number @
---@field index number @
---@field scene_id number @
---@field x number @
---@field y number @
---@field double_action_uid uint64 @双人交互另一个人的uid
---@field time uint64 @时间
---@field id number @唯一id
---@field convoy_pos PositionData @
---@field ai_next_pos number @护送巡逻ai

---@class TaskAcceptRes
---@field result ErrorCode @
---@field task TaskUpdateData @
---@field task_id number @
---@field sequence_id number @

---@class TaskAcceptArg
---@field task_id number @
---@field sub_task_id number @子任务id
---@field sequence_id number @

---@class TaskFinishRes
---@field result ErrorCode @
---@field task_id number @
---@field sequence_id number @

---@class TaskFinishArg
---@field task_id number @
---@field sequence_id number @

---@class TaskDeleteData
---@field task_ids PBuint32__Array @

---@class TaskCheckArg
---@field task_id PBuint32__Array @
---@field sequence_id number @

---@class TaskCheckRes
---@field result ErrorCode @
---@field task TaskUpdateData @
---@field sequence_id number @
---@field check_result CheckResult__Array @

---@class TaskGiveupArg
---@field task_id number @
---@field sequence_id number @

---@class TaskGiveupRes
---@field result ErrorCode @
---@field task TaskInfo @
---@field delete_tasks TaskDeleteData @删除的任务
---@field task_id number @
---@field sequence_id number @

---@class TriggerInfo
---@field task_id number @任务id
---@field event number @事件类型 TaskTriggerEvent
---@field when number @时机TaskTriggerType
---@field step number @时机为kTaskTriggerTarget时有效,0开始
---@field vector_index number @数组下标

---@class TaskTriggerAllNotifyData
---@field data TriggerInfo__Array @

---@class NpcAction
---@field action_id number @
---@field npc_id number @
---@field task_id number @

---@class PlayAction
---@field action_id number @
---@field task_id number @

---@class TargetTriggerInfo
---@field task_id number @
---@field target_index number @
---@field targetlib_id number @

---@class PositionData
---@field scene_id number @
---@field pos Vec3 @

---@class GetConvoyNpcPosArg
---@field task_id number @
---@field target_index number @目标index 0开始

---@class GetConvoyNpcPosRes
---@field result ErrorCode @
---@field pos PositionData @

---@class TaskNpc
---@field npc_id number @
---@field scene_id number @

---@class CheckResult
---@field task_id number @
---@field result ErrorCode @

---@class TaskDoneInfo
---@field task_id number @
---@field time_stamp uint64 @任务完成时间

---@class DanceStatusData
---@field task_id number @
---@field is_pause boolean @
---@field dance_time number @已经跳舞时间 秒

---@class SetWorldEventSignArg
---@field event_id number__Array @

---@class SetWorldEventSignRes
---@field error_code ErrorCode @
---@field event_sign_pair RoleWorldEventSignPair__Array @

---@class RoleWorldEventSignPair
---@field event_id number @
---@field sign boolean @是否出现标记

---@class RoleWorldEventNewPair
---@field task_id number @
---@field is_new_player boolean @是否是萌新/回流玩家

---@class DeleteTaskData
---@field role_id uint64 @
---@field task_id number @

---@class CondData
---@field cond_id number__Array @条件id

---@class AutoPairOperateArg
---@field type number @
---@field target number @
---@field professions number__Array @队伍匹配选择职责,个人职责填写一个
---@field want_team_captain boolean @匹配时想成为队长,个人匹配用

---@class AutoPairOperateRes
---@field error ErrorCode @

---@class PairOverData
---@field reason number @1.超时 2.匹配完成

---@class GetTeamListArg
---@field target number @

---@class GetTeamListRes
---@field infos TeamMatchInfo__Array @
---@field error_info ErrorInfo @

---@class TeamMatchInfo
---@field max_level number @
---@field min_level number @
---@field profession_ids PBuint32__Array @
---@field name string @
---@field target number @
---@field team_id uint64 @
---@field captain MemberBaseInfo @
---@field create_time number @
---@field show_cooperation number @是否显示协同之证，1显示 0不显示

---@class TeamShoutArg

---@class TeamShoutRes
---@field error ErrorCode @
---@field error_param PBint32__Array @

---@class ToBeFollowedArg
---@field uid uint64 @

---@class ToBeFollowedRes
---@field error ErrorCode @

---@class AskFollowNtfData
---@field uid uint64 @邀请者的uid

---@class ReplyToBeFollowedArg
---@field type ReplyType @

---@class ReplyToBeFollowedRes
---@field error ErrorCode @

---@class QueryAutoPairStatusArg

---@class QueryAutoPairStatusRes
---@field status number @
---@field error ErrorCode @

---@class BeginFollowNtfData
---@field uid uint64 @

---@class TeamSettingNtfData
---@field ts TeamSetting @

---@class SyncMemberStatusNtf
---@field info MemberAttrChangeInfo__Array @

---@class SelectPrioritySceneForTeamArg
---@field team_id number @
---@field scene_id number @
---@field scene_unique_ids number__Array @
---@field role_ids uint64__Array @
---@field switch_data SceneSwitchData @

---@class SelectPrioritySceneForTeamRes
---@field error ErrorCode @
---@field scene_id_selected number @
---@field is_full boolean @场景线是否已满

---@class SyncMemberPosToMsData
---@field role_pos TeamMemberPos__Array @
---@field force_sync boolean @

---@class TeamShoutNtfData
---@field member_count number @
---@field profession_ids PBuint32__Array @
---@field setting TeamSetting @
---@field role_id uint64 @
---@field name string @
---@field show_coordination number @是否显示协同之证，1显示 0不显示

---@class SomeoneApplyForCaptainNtf
---@field role_id uint64 @

---@class TeamAfkNtfData
---@field is_afk boolean @

---@class TeamInvatationData
---@field team_info TeamInfo @
---@field inviter_id uint64 @

---@class RecommandMemberArg
---@field role_id uint64 @

---@class RecommandMemberRes
---@field error ErrorCode @

---@class CollectRoleDungeonInfo

---@class CollectRoleDungeonInfoRes
---@field infos RoleDungeonInfo__Array @

---@class RoleDungeonInfo
---@field role_id uint64 @
---@field dungeon_ids PBuint32__Array @

---@class TeamMemberStatusNtfData
---@field role_id uint64 @
---@field status MemberStatus @

---@class QueryRobotTeamBattleArg

---@class QueryRobotTeamBattleRes
---@field result ErrorCode @

---@class TeamMemberSyncToGameDataInfo
---@field is_follow boolean @是否跟随
---@field uuid uint64 @成员uuid
---@field captain uint64 @队长uuid

---@class TeamMemberSyncToGameData
---@field members TeamMemberSyncToGameDataInfo__Array @成员

---@class ApplyForCaptainArg

---@class ApplyForCaptainRes
---@field error ErrorInfo @

---@class CaptainChangeNtfData
---@field captain_id uint64 @
---@field type CaptainChangeType @

---@class RespondForApplyCaptainArg
---@field type number @

---@class RespondForApplyCaptainRes
---@field error ErrorCode @

---@class TeamMemberPos
---@field role_id uint64 @
---@field pos Vec3 @

---@class TeamInfo
---@field team_setting TeamSetting @
---@field team_id uint64 @
---@field member_list MemberBaseInfo__Array @
---@field captain_id uint64 @
---@field mercenary_list MercenaryBrief__Array @

---@class GetTeamInfoArg

---@class GetTeamInfoRes
---@field error ErrorCode @
---@field team_info TeamInfo @

---@class AllMemberStatusInfo
---@field team_id uint64 @
---@field members MemberStatusInfo__Array @
---@field mercenary_list MercenaryBrief__Array @

---@class OutTeamNtfData
---@field id uint64 @
---@field notice ErrorInfo @

---@class TeamWatchStatusNtfData
---@field members MemberWatchStatus__Array @

---@class MemberWatchStatus
---@field role_id uint64 @
---@field is_watching boolean @

---@class GetRecentTeamMateRes
---@field mates uint64__Array @
---@field result ErrorCode @

---@class GetTeamMatchStatusArg

---@class GetTeamMatchStatusRes
---@field error_code ErrorCode @
---@field is_in_match boolean @是否在匹配中

---@class DeleteThemePartyRoleInfoArg
---@field is_delete_love boolean @
---@field is_delete_luckyno boolean @
---@field mtime uint64 @

---@class SaveThemePartyRoleInfoArg
---@field all_roles ThemePartyRoleInfo__Array @
---@field mtime uint64 @

---@class GetThemePartyInvitationArg

---@class GetThemePartyInvitationRes
---@field result ErrorCode @
---@field lucky_no number @

---@class GetInvitationArg
---@field delay_rpc_id number @
---@field item_change_reason ItemChangeReason @

---@class GetInvitationRes
---@field result ErrorCode @

---@class SendThemePartyEventToGsArg
---@field event_type ThemePartyEventType @
---@field scene_uid number @
---@field begin_time uint64 @
---@field end_time uint64 @
---@field dance_random_number number @

---@class SendThemePartyEventToGsRes
---@field result ErrorCode @

---@class ThemePartySendLoveArg
---@field to_uid uint64 @收到爱心玩家uid

---@class ThemePartySendLoveRes
---@field result ErrorCode @

---@class ThemePartyGetLoveInfoArg

---@class ThemePartyGetLoveInfoRes
---@field result ErrorCode @
---@field member_list MemberBaseInfo__Array @送爱心玩家列表

---@class ThemePartyDbInfo
---@field current_state number @
---@field lottery_db_info ThemePartyLotteryDbInfo @抽奖信息
---@field last_end_time uint64 @保存最近一次活动结束的time
---@field dance_random_number number @

---@class LoveHeartPbInfo
---@field remain_love_num number @剩余的爱心数量
---@field records LoveHeartGiveRecord__Array @

---@class LoveHeartGiveRecord
---@field uid uint64 @
---@field time uint64 @

---@class ThemePartyStateData
---@field current_state ThemePartyClientState @
---@field time number @
---@field remain_time number @

---@class GetThemePartyActivityInfoArg

---@class GetThemePartyActivityInfoRes
---@field current_state ThemePartyClientState @
---@field time number @该阶段停留时间（秒）
---@field remain_time number @剩余时间（秒）
---@field lucky_no number @
---@field love_num number @点赞数
---@field result ErrorCode @

---@class ThemePartyLoveNtfData
---@field from_uid uint64 @谁给我发送爱心了
---@field from_name string @
---@field love_num number @

---@class ThemePartyLotteryDrawData
---@field lottery_type ThemePartyLotteryType @当前抽奖类型
---@field lucky_numbers PBuint32__Array @中奖号码
---@field group_members ThemePartyPrizeMember__Array @分组成员（只有抽幸运奖用到这个字段）

---@class ThemePartyAwardPrizeArg
---@field award_uid uint64 @
---@field lottery_index number @抽奖第几轮
---@field award_items ItemBrief__Array @

---@class ThemePartyAwardPrizeRes
---@field result ErrorCode @

---@class ThemePartyGetPrizeMemberArg

---@class ThemePartyGetPrizeMemberRes
---@field result ErrorCode @
---@field lottery_type_members ThemePartyLotteryTypePrizeMember__Array @不用类型的中奖成员列表

---@class ThemePartyLotteryTypePrizeMember
---@field lottery_type ThemePartyLotteryType @
---@field is_create boolean @奖励是否揭晓
---@field members ThemePartyPrizeMember__Array @

---@class DeleteThemePartyRoleInfoRes
---@field result ErrorCode @

---@class ThemePartyLotteryDbInfo
---@field all_lotterys ThemePartyEachLotteryInfo__Array @

---@class ThemePartyEachLotteryInfo
---@field lottery_type ThemePartyLotteryType @抽奖类型
---@field lottery_state number @抽奖状态
---@field create_time uint64 @创建时间
---@field lottery_roles ThemePartyRoleLotteryInfo__Array @获奖的玩家信息

---@class ThemePartyRoleLotteryInfo
---@field role_uid uint64 @
---@field lucky_no number @
---@field name string @

---@class ThemePartyDeleteInvitationArg
---@field role_uids uint64__Array @

---@class ThemePartyDeleteInvitationRes
---@field result ErrorCode @
---@field fail_uids uint64__Array @

---@class ThemePartyPrizeMember
---@field member MemberBaseInfo @
---@field lucky_no number @

---@class SendThemePartyTipArg
---@field tip_id number @

---@class SendThemePartyTipData
---@field tip_id number @
---@field scene_uid number @
---@field content LocalizationNameContainer @

---@class SaveThemePartyRoleInfoRes
---@field result ErrorCode @

---@class ThemePartyRoleInfo
---@field role_uid uint64 @
---@field lucky_info PartyLuckNum @
---@field love_info LoveHeartPbInfo @

---@class PartyLuckNum
---@field lucky_no number @
---@field has_winning boolean @

---@class ThemePartyNearbyPersonsArgs
---@field role_id uint64 @用户的角色id

---@class ThemePartyNearbyPersonsRes
---@field result ErrorCode @
---@field role_ids uint64__Array @用户角色id

---@class RequestLotteryDrawInfoArg

---@class RequestLotteryDrawInfoRes
---@field error_code ErrorCode @
---@field rest_time uint64 @剩余时间
---@field type ThemePartyLotteryType @获奖类型

---@class TitleStatusArg
---@field new_status TitleStatus @新的称号状态
---@field title_id number @称号id

---@class TitleStatusRes
---@field error_code ErrorCode @
---@field title_id number @称号id

---@class RegisterTrade2MsRes
---@field closedtlognames string__Array @关闭的tlog名单

---@class RegisterTrade2MsReq
---@field serverid number @

---@class TradeItemDbInfo
---@field item_id number @
---@field conf_presell boolean @
---@field is_presell boolean @
---@field stock_count int64 @库存量
---@field buy_count int64 @
---@field sell_count int64 @
---@field cur_price number @
---@field base_price number @
---@field last_stock_list int64__Array @
---@field role_buy_bill_list TradeDbBuyBill__Array @
---@field follower_list uint64__Array @关注玩家列表
---@field last_refresh_time int64 @
---@field role_buy_bill_result_list TradeDbBuyBillResult__Array @
---@field max_price int64 @
---@field pre_tendency number @刷新前供需趋势
---@field continue_days number @刷新前供需趋势不变天数
---@field modified_factor number @库存修正参数

---@class TradeDbInfo
---@field item_list TradeItemDbInfo__Array @
---@field refresh_time int64 @
---@field server_level number @
---@field mark_list TradeItemMarkDbInfo__Array @
---@field notice_refresh_time uint64 @
---@field trade_bills TradeBillInfo__Array @

---@class TradeKeepAliveInfo

---@class TradeUpdateInfo
---@field item_list TradeItemPbInfo__Array @
---@field del_item_list number__Array @
---@field server_level number @
---@field mark_list TradeItemMarkPbInfo__Array @

---@class GetTradeInfoArg

---@class GetTradeInfoRes
---@field error_code ErrorCode @
---@field item_list TradeItemPbInfo__Array @
---@field server_level number @
---@field mark_list TradeItemMarkPbInfo__Array @

---@class TradeBuyItemArg
---@field item_id number @
---@field count int64 @
---@field force boolean @

---@class TradeBuyItemRes
---@field error ErrorInfo @
---@field price int64 @
---@field role_id uint64 @
---@field is_notice boolean @是否公示（仅供服务器内部使用）
---@field request_time uint64 @请求时的时间（毫秒）

---@class TradeBuyItemCheckArg
---@field rpcid number @
---@field item_id number @
---@field item_count int64 @
---@field money_type number @
---@field money_count int64 @
---@field is_notice boolean @是否公示

---@class TradeBuyItemCheckRes
---@field error ErrorInfo @
---@field item_buy_limit int64 @剩余限购数量

---@class TradeItemPbInfo
---@field item_id number @
---@field buy_count int64 @
---@field sell_count int64 @
---@field cur_price number @
---@field base_price number @
---@field is_notice boolean @是否公示
---@field is_follow boolean @是否关注
---@field stock_num int64 @库存
---@field pre_buy_num int64 @预购数量
---@field modified_factor number @库存修正参数

---@class TradeSellItemArg
---@field item_uuid uint64 @
---@field item_id number @
---@field count int64 @
---@field price int64 @
---@field force boolean @

---@class TradeSellItemRes
---@field error_code ErrorCode @
---@field price int64 @
---@field is_notice boolean @是否公示（仅供服务器内部使用）
---@field request_time uint64 @请求时的时间（毫秒）
---@field role_id uint64 @

---@class TradeSellItemCheckArg
---@field rpcid number @
---@field item_uuid uint64 @
---@field item_id number @
---@field item_count int64 @
---@field item_price int64 @
---@field money_type number @
---@field money_count int64 @
---@field is_notice boolean @

---@class TradeSellItemCheckRes
---@field error_code ErrorCode @
---@field item_sell_limit int64 @物品每日限购数量

---@class TradeRolePbInfo
---@field role_id uint64 @
---@field session_id uint64 @
---@field account string @
---@field level number @
---@field system_opened_list number__Array @

---@class TradeRoleAddNotifyInfo
---@field role_list TradeRolePbInfo__Array @

---@class TradeRoleRemoveNotifyInfo
---@field role_list uint64__Array @

---@class TradeRoleReadOnlineRoleArg
---@field last_role_id uint64 @
---@field max_count number @

---@class TradeRoleReadOnlineRoleRes
---@field error_code ErrorCode @
---@field role_list TradeRolePbInfo__Array @

---@class TradeItemMarkPbInfo
---@field mark_id number @
---@field is_open boolean @
---@field open_time int64 @

---@class TradeItemMarkDbInfo
---@field mark_id number @
---@field open_time int64 @

---@class TradeGetRoleTlogInfoArg
---@field role_list uint64__Array @

---@class TradeGetRoleTlogInfoRes
---@field error_code ErrorCode @
---@field role_info_list TradeRoleTlogInfo__Array @

---@class TradeRoleTlogInfo
---@field server_id string @
---@field game_appid string @
---@field platform_id number @
---@field zone_area_id number @
---@field open_id string @
---@field role_id uint64 @
---@field role_name string @
---@field job_id number @
---@field gender number @
---@field level number @
---@field job_level number @
---@field friend_num number @
---@field charge_gold number @
---@field role_vip number @
---@field create_time string @
---@field power number @
---@field union_id uint64 @
---@field union_name string @
---@field reg_channel number @
---@field login_channel number @
---@field ip string @
---@field zoneid number @
---@field areaid number @
---@field currentdiamond uint64 @
---@field currentrob uint64 @当前Ro币
---@field currentzeny uint64 @
---@field serverlevel number @
---@field client_version string @

---@class TradeFollowItemArg
---@field item_id number @
---@field is_follow boolean @是否关注

---@class TradeFollowItemRes
---@field result ErrorCode @

---@class TradeItemStockData
---@field item_id number @

---@class TradeDbBuyBill
---@field role_id uint64 @
---@field create_time int64 @
---@field item_count int64 @
---@field buy_price int64 @

---@class TradeBalanceSendMailArg
---@field role_bills TradeBalanceRoleBillPb__Array @
---@field bill_id uint64 @

---@class TradeBalanceSendMailRes
---@field result ErrorCode @

---@class TradeBalanceBillPb
---@field item_id number @
---@field create_time uint64 @
---@field item_balance_count int64 @可以结算的数量
---@field item_fail_count int64 @结算未成功的数量
---@field price int64 @
---@field money_type number @

---@class TradeBalanceRoleBillPb
---@field role_id uint64 @
---@field bills TradeBalanceBillPb__Array @

---@class TradeBillInfo
---@field bill_id uint64 @
---@field role_bills TradeBalanceRoleBillPb__Array @

---@class TradeBillIdInfo
---@field bill_id uint64__Array @

---@class TradeDbBuyBillResult
---@field role_id uint64 @
---@field item_count int64 @
---@field buy_price int64 @
---@field create_time int64 @
---@field success_count int64 @
---@field calc_count int64 @
---@field recv_max_count int64 @

---@class GuildMatchArg
---@field guild_ids PBint64__Array @

---@class GuildMatchStatusData
---@field guild_matched_pair GuildMatchPair__Array @匹配成功公会
---@field unmatched_guilds PBuint64__Array @匹配失败组队

---@class GuildMatchPair
---@field guild_id1 uint64 @
---@field guild_id2 uint64 @

---@class SendRedEnvelopeG2MArg
---@field type RedEnvelopeType @类型
---@field words string @寄语/口令
---@field id number @红包方案id
---@field number number @红包个数
---@field delay_rpc_id number @
---@field need_return boolean @是否需要返还剩余红包

---@class SkillSlots
---@field slots SkillSlot__Array @
---@field type SlotType @技能孔类型

---@class RecoverInfo
---@field coin_type number @
---@field count int64 @
---@field reason string @

---@class RecoverInfos
---@field infos RecoverInfo__Array @
---@field time uint64 @

---@class IdipEquipRefineData
---@field level number @真实等级
---@field seal_level number @封印等级

---@class TutorialMark
---@field tutorial Tutorial__Array @

---@class Tutorial
---@field tutorial_id number @新手引导类型

---@class EasyPathListenData
---@field role_id uint64 @
---@field type TeleportType @传送类型
---@field scene_id number @目标场景id

---@class SyncTimeArg
---@field time int64 @

---@class QueryGateArg
---@field token string @
---@field account string @
---@field password string @
---@field type LoginType @
---@field pf string @
---@field openid string @
---@field platid PlatType @
---@field version string @

---@class QueryGateRes
---@field loginToken string @
---@field gateconfig string @
---@field userphone string @
---@field RecommandGate LoginGateData @
---@field servers SelfServerData__Array @
---@field loginzoneid number @
---@field allservers LoginGateData__Array @
---@field in_white_list boolean @
---@field error ErrorCode @
---@field notice PlatNotice @
---@field baninfo PlatBanAccount @封open_id全区的 在login上
---@field tag number @账号标记(普通/GM/内部测试人员..)

---@class LoginGateData
---@field ip string @
---@field zonename string @
---@field servername string @
---@field port number @
---@field serverid number @
---@field state number @
---@field flag number @
---@field maintaininfo string @停服维护信息，平台发过来的
---@field maintainendtime uint64 @维护结束时间平台发过来的时间点，做展示用

---@class SelfServerData
---@field servers LoginGateData @
---@field level number @

---@class PlatNotice
---@field type number @
---@field noticeid number @
---@field isopen boolean @
---@field areaid number @
---@field platid number @
---@field content string @
---@field updatetime number @
---@field isnew boolean @
---@field title string @

---@class PlatBanAccount
---@field reason string @
---@field endtime uint64 @

---@class DelayInfo
---@field delay number @

---@class BanAccount
---@field openid string @
---@field endtime uint64 @
---@field reason string @

---@class ServerInfo
---@field id number @
---@field name string @
---@field zonename string @

---@class ServerInfoPara
---@field serverinfo ServerInfo__Array @

---@class ServerListArg
---@field stateList ServerState__Array @

---@class ServerState
---@field serverID number @
---@field serverState number @

---@class RegisterLoginNtf
---@field serverid number @
---@field platform string @
---@field data ServerInfoPara @

---@class UpdateServerState2Login
---@field register_account number @
---@field online_role number @
---@field write_db boolean @
---@field serverid number @
---@field serverids number__Array @

---@class RegisterMs2LoginArg
---@field zoneid number @
---@field serverid number @
---@field needinfo boolean @true，表示需要从login获取额外的信息，初始化调用一次就够了，这个协议被同时用在ms和ns的注册上

---@class RegisterMs2LoginRes
---@field result ErrorCode @
---@field loginsvrid number @

---@class UpdateSelfServer
---@field accountid string @
---@field serverid number @
---@field level number @
---@field last_login_time int64 @

---@class TokenNoitfyData
---@field logintoken string @
---@field serverid number @

---@class LoginVerifyArg
---@field loginToken string @
---@field serverid number @
---@field uid uint64 @

---@class LoginVerifyRes
---@field userid string @
---@field isgm boolean @
---@field result ErrorCode @

---@class RoleAllInfo
---@field brief RoleBrief @
---@field ExtraInfo RoleExtraInfo @
---@field skill SkillRecord @
---@field quality_point QualityPointRecord @
---@field bag BagContent @
---@field game_role_info GameRoleSerializeInfo @
---@field taskrecord TaskRecord @任务的相关记录
---@field fashion FashionRecord @时装信息
---@field equips Equips @身上的所有装备
---@field vehicle TakeVehicleInfo @搭乘载具信息
---@field systems SystemRecord @功能开放
---@field shops Shops @商店记录
---@field dungeons DungeonsRecord @所有副本
---@field allmodifytime AllModuleModifyTime @所有模块的更新时间
---@field count_record CountRecord @
---@field climbing TakeClimbingInfo @攀爬信息
---@field guarantee_data GuaranteeData @
---@field seven_login_info SevenLoginInfo @七日签到奖励
---@field lifeskill LifeSkillRecord @生活技能
---@field lifeequip LifeEquipData @生活装备
---@field temp_record RoleTempRecord @一些临时的 但是却需要保存的数据
---@field showaction ShowAction @交互行为
---@field achievementrecord AchievementRecord @成就系统
---@field illustration Illustration @图鉴
---@field role_health Health @健康战斗转换的经验信息
---@field roleworldevent RoleWorldEvent @角色的世界pve事件记录
---@field cat_trade_info CatTradeDbInfo @猫手商会
---@field medal MedalRecord @勋章模块
---@field tutorial_mark TutorialMark @新手引导
---@field pay PayRecord @充值模块
---@field postcard_display PostcardDisplay @萌新手册
---@field delegation DelegationRecord @委托系统
---@field thirty_sign_info ThirtySignInfo @三十次签到奖励
---@field sticker_info Sticker @贴纸模块
---@field big_world BigWorldRecord @大世界
---@field suit_info Suit @装备套装系统
---@field merchant_record MerchantRecord @跑商记录
---@field lua_activity_info RoleLuaActivityData @Lua活动
---@field limited_time_offer_info LimitedTimeOfferRecord @限时特惠
---@field mall_record MallRecord @商城记录
---@field auctionrecords RoleGuildAuctionRecord @公会拍卖记录
---@field watch_record RoleWatchRecord @观战记录
---@field vehicle_record VehicleRecord @载具成长线信息
---@field mercenary_record RoleMercenaryRecord @佣兵信息
---@field vital_data RoleVitalData @关键数据,及时落地
---@field common_data Commondata @角色通用数据
---@field vital_commondata VitalCommondata @角色关键数据
---@field commondata_0 Commondata_0 @角色通用数据0
---@field commondata_1 Commondata_1 @角色通用数据_1
---@field commondata_2 Commondata_2 @角色通用数据_2
---@field commondata_3 Commondata_3 @角色通用数据3
---@field itemdata_0 ItemDataList_0 @道具数据_0
---@field itemdata_1 ItemDataList_1 @道具数据_1
---@field itemdata_2 ItemDataList_2 @道具数据_2
---@field itemdata_3 ItemDataList_3 @道具数据_3
---@field itemdata_4 ItemDataList_4 @道具数据_4
---@field chat_tag ChatTagRecord @聊天标签
---@field extra_card_drop ExtraCardDropRecord @卡片额外掉落机制
---@field returnprize ReturnPrize @回归体系数据

---@class SaveRoleDataArg
---@field roleid uint64 @
---@field account string @
---@field slot number @
---@field fieldName string__Array @
---@field fieldData string__Array @
---@field briefData string @
---@field param number @
---@field newname string @设置名字以后这里要更改
---@field server_id number @
---@field mtime uint64 @

---@class SceneCreatedData
---@field mapid number @
---@field sceneid number @
---@field gsline number @
---@field dungeon_id number @
---@field role_ids uint64__Array @
---@field pvp_param PVPParam @
---@field origin_scene_uid number @

---@class RoleSceneSwitchExtra
---@field roleid uint64 @

---@class EnterSceneReqToMsData
---@field mapid number @
---@field rolelist uint64__Array @
---@field data SceneSwitchData @

---@class ChangeSceneVerifyArg
---@field mapid number @
---@field rolelist uint64__Array @
---@field line number @
---@field destSceneID uint64 @
---@field data SceneSwitchData @
---@field isDestCross boolean @
---@field destLine number @
---@field isGM boolean @

---@class ChangeSceneVerifyRes
---@field result ErrorCode @
---@field destLine number @

---@class SceneDestroyedData
---@field sceneID number @
---@field result_status number @如果是副本的话，结算结果

---@class GetVersionArg

---@class GetVersionRes
---@field errorcode ErrorCode @
---@field version string @

---@class DoEnterSceneArg
---@field sceneid number @

---@class DoEnterSceneRes
---@field errorcode ErrorCode @
---@field scene_id number @
---@field others_in_view UnitAppearance__Array @
---@field dungeons DungeonsReconnectInfo @
---@field game_role_info GameRoleReconnectInfo @gamelib中一些数据
---@field platform PlatformUnit @擂台
---@field battle_param CreateBattleParam @战斗相关数值

---@class RoleBrief
---@field roleid uint64 @
---@field type RoleType @
---@field name string @
---@field accountID string @
---@field position Vec3 @
---@field sceneID number @
---@field face number @
---@field role_index number @
---@field sex SexType @
---@field inittime uint64 @
---@field onlinetime number @
---@field level number @
---@field job_level number @JOB等级
---@field revive_record ReviveRecord @
---@field target_position Vec3 @跨场景跳转的时候,需要指定目的坐标
---@field need_target_position boolean @需要跳转目的坐标
---@field guild_info RoleGuildInfo @
---@field record_scene_id number @记录点的场景id
---@field guild_scene_face number @
---@field guild_scene_position Vec3 @
---@field changenamecount number @改名字的次数
---@field server_id number @
---@field base_virtual_items VirtualItemData__Array @保存在这里，主要是给masterserver用
---@field view_layer number @视野层
---@field last_guild_scene_time uint64 @最近一次在公会场景的时间
---@field last_scene_time uint64 @最近一次进入静态场景的时间
---@field last_scene_uid number @上个场景的uid[包括动态场景,不一定与scene_id一致]
---@field account_create_time string @账户创建时间
---@field is_pre_register boolean @是否是预注册角色

---@class RoleExtraInfo
---@field lastLoginTime uint64 @
---@field lastLogoutTime number @
---@field loginTimes number @
---@field last_static_sceneid RoleLeaveStaticData @
---@field already_arrvied_map PBuint32__Array @已经到达过的地图map_id
---@field path EasyPath__Array @便捷寻路
---@field path_status boolean @便捷寻路状态
---@field last_refresh_time uint64 @最后刷新事件
---@field effect_id number @特效id
---@field continue_login_days number @连续登陆天数
---@field zero_profit_time uint64 @什么时候结束零收益状态 默认为0没有
---@field zero_profit_reason string @零收益原因
---@field total_login_days number @累计登陆天数
---@field last_anti_addiction_time uint64 @最近上报防沉迷的时间
---@field last_detached_time uint64 @上次脱离卡死的时间戳
---@field last_passive_detached_time uint64 @上次被动脱离卡死的时间戳
---@field regress_time uint64 @回归时间戳
---@field regress_online_time number @达到回归条件时的总在线时间

---@class BroadCastData
---@field broadcastType BroadCastType @
---@field data string @

---@class BroadCastG2TData
---@field data string @
---@field sessionList uint64__Array @

---@class LevelChanged
---@field level number @
---@field exp int64 @
---@field extra_base_exp int64 @今日健康战斗折算的经验
---@field extra_job_exp int64 @今日健康战斗折算的job经验
---@field extra_fight_time number @

---@class ListenAddress
---@field ip string @
---@field port number @

---@class RegisterGs2GtArg
---@field serverID number @
---@field line number @

---@class RegisterGs2GtRes
---@field errorcode ErrorCode @
---@field gtline number @

---@class SaveRoleDataRes
---@field result ErrorCode @

---@class RegisterGs2WorldArg
---@field line number @

---@class RegisterGs2WorldRes
---@field result ErrorCode @
---@field line_list number__Array @
---@field address_list ListenAddress__Array @
---@field is_master boolean @
---@field serverid number @

---@class RegisterGs2MsArg
---@field serverid number @
---@field line number @

---@class RegisterGs2MsRes
---@field errorcode ErrorCode @
---@field open_servertime uint64 @
---@field apptype GameAppType @
---@field plat PlatType @
---@field combineservertime uint64 @
---@field time_offset number @
---@field closedtlognames string__Array @关闭的tlog名单

---@class RegisterGs2RouterArg
---@field line number @

---@class RegisterGs2RouterRes
---@field result ErrorCode @
---@field line number @
---@field servers ServerIdInfo__Array @

---@class ServerIdInfo
---@field serverid number @
---@field serverids number__Array @

---@class MoveInfo
---@field Common number @
---@field time number @
---@field dx number @
---@field dy number @
---@field dz number @

---@class WorldMasterInfo
---@field serverid number @
---@field gs_num number @

---@class NewRouterInfo
---@field line number @
---@field address ListenAddress @

---@class SyncServerTime
---@field now uint64 @

---@class NewGateConnectedData
---@field line number @
---@field addr ListenAddress @

---@class NotifyServerConnect
---@field server ServerIdInfo @

---@class NotifyServerClose
---@field serverid number @

---@class GMToolCommandArg
---@field cmd string @
---@field args string @
---@field delayid number @
---@field type number @

---@class GMToolCommandRes
---@field result boolean @
---@field errMsg string @

---@class RegisterGt2GsArg
---@field serverID number @
---@field line number @

---@class RegisterGt2GsRes
---@field errorcode ErrorCode @
---@field gsline number @

---@class MSDestoryScene
---@field sceneuid number @

---@class CreateBattleArg
---@field rpcid number @
---@field mapID number @
---@field sceneID number @
---@field param CreateBattleParam @
---@field line number @
---@field uid uint64 @

---@class CreateBattleRes
---@field result ErrorCode @

---@class EnterSceneArg
---@field mapID number @
---@field roleDataList RoleAllInfo__Array @老版本需要的所有玩家数据
---@field roleSessionList uint64__Array @
---@field rpcid number @
---@field isgm boolean @
---@field destSceneID number @
---@field newSceneUniqueID number @
---@field cliInfoList ClientInfo__Array @
---@field type EnterSceneType @
---@field switch_data SceneSwitchData @
---@field read_role_list ReadRoleBriefInfo__Array @加载玩家数据需要的信息
---@field scene_line number @
---@field server_id number @
---@field use_gm boolean @

---@class EnterSceneRes
---@field result ErrorCode @
---@field mapid number @
---@field sceneid number @

---@class EnterSceneFromMsData
---@field roleID uint64 @
---@field sceneID number @
---@field gsLine number @
---@field mapID number @
---@field isCross boolean @

---@class ChangeGsLineData
---@field sessionID uint64 @
---@field line number @
---@field is_cross_gs boolean @
---@field keepalive boolean @

---@class UnitAppearList
---@field units UnitAppearance__Array @

---@class SceneEmptyNotify
---@field sceneuid number @
---@field mapid number @

---@class LoginChallenge
---@field challenge string @
---@field session uint64 @

---@class BroadCastDataM2T
---@field session_list uint64__Array @
---@field data string @
---@field type BroadCastType @

---@class RouterListenInfo
---@field ms ListenAddress @
---@field gate ListenAddress @
---@field gs ListenAddress @
---@field ctrl ListenAddress @
---@field db ListenAddress @

---@class RegisterGt2MsArg
---@field serverID number @
---@field line number @

---@class RegisterGt2MsRes
---@field errorcode ErrorCode @

---@class RegisterGt2NsArg
---@field serverID number @
---@field line number @
---@field addr ListenAddress @

---@class RegisterGt2NsRes
---@field result ErrorCode @
---@field proxyaddr ProxyAddr__Array @

---@class RegisterGt2RouterArg
---@field server_id number @
---@field line number @

---@class RegisterGt2RouterRes
---@field result ErrorCode @

---@class KickAccountData
---@field reason KickType @

---@class NotfiyGtSessionLogin

---@class LoginArg
---@field gameserverid number @
---@field token string @
---@field ios string @
---@field android string @
---@field pc string @
---@field openid string @
---@field clientInfo ClientInfo @
---@field loginzoneid number @

---@class LoginReconnectInfo
---@field scenetemplateid number @
---@field scenetime number @

---@class LoginRes
---@field result ErrorCode @
---@field version string @
---@field accountData LoadAccountData @
---@field function_open number @
---@field rinfo LoginReconnectInfo @
---@field session_id uint64 @
---@field ban_acc PlatBanAccount @
---@field maintaininfo string @如果服务器在维护中，填上维护公告
---@field maintainendtime int64 @如果维护状态，这里填充维护公告对应的内容

---@class LoadAccountData
---@field account string @
---@field all_roles RoleBriefInfo__Array @
---@field select_role_index number @
---@field is_register boolean @注册标记
---@field create_time string @
---@field server_id number @
---@field register_result RegisterResult @注册结果

---@class ReconnArg
---@field session uint64 @
---@field sceneid number @
---@field roleid uint64 @
---@field lastmodifytime uint64 @客户端的模块时间戳记录,取自最后一个心跳包的时间戳

---@class ReconnRes
---@field result ErrorCode @

---@class ReconnectGsArg
---@field delayrpc number @
---@field isadd boolean @
---@field sceneid number @
---@field roleid uint64 @
---@field lastmodifytime uint64 @客户端的模块时间戳记录,从客户端最后一个心跳包里拿

---@class ReconnectGsRes
---@field errorcode ErrorCode @

---@class SessionChangeData
---@field oldsession uint64 @
---@field newsession uint64 @
---@field roleid uint64 @

---@class ErrorInfo
---@field errorno number @
---@field param PBuint64__Array @
---@field param64 uint64 @
---@field istip boolean @
---@field message string @通知消息内容
---@field server_id number @区服id

---@class LoginRequestNewArg
---@field openid string @
---@field token string @
---@field clientInfo ClientInfo @
---@field loginzoneid number @
---@field serverid number @
---@field ios string @
---@field android string @
---@field pc string @

---@class LoginRequestNewRes
---@field result number @
---@field accountData LoadAccountData @
---@field function_open number @
---@field rinfo LoginReconnectInfo @
---@field version string @
---@field ban_acc PlatBanAccount @
---@field maintaininfo string @维护公告
---@field maintainendtime int64 @维护公告结束时间，只是用来提示

---@class UpdateStartUpType
---@field type StartUpType @

---@class MysqlConnectLostData
---@field msg string @

---@class CrossGsCloseNtf
---@field gsline number @

---@class RegisterMs2NsArg
---@field closedtlognames string__Array @关闭的tlog名单

---@class RegisterMs2NsRes

---@class RegisterCtrl2RouterArg
---@field serverid number @
---@field serverids number__Array @

---@class RegisterCtrl2RouterRes
---@field result ErrorCode @

---@class LoginReconnectReqArg
---@field reconnect boolean @

---@class LoginReconnectReqRes
---@field result ErrorCode @

---@class KickAccountFromMsArg
---@field roleid uint64 @
---@field accountID string @
---@field kickType KickType @

---@class KickAccountFromMsRes
---@field result ErrorCode @

---@class ReadAccountDataArg
---@field account string @
---@field serverid number @
---@field rpcid number @
---@field readType ReadAccountDataType @
---@field is_white boolean @是否是白名单玩家
---@field can_register boolean @是否可注册

---@class ReadAccountDataRes
---@field result ErrorCode @
---@field accountData LoadAccountData @
---@field ban_list BanRoleDataList @

---@class NotifyRoleLoginReconnect2GsArg
---@field rpcid number @
---@field oldsession uint64 @
---@field newsession uint64 @
---@field roleid uint64 @
---@field cinfo ClientInfo @
---@field sceneid number @
---@field mapid number @

---@class NotifyRoleLoginReconnect2GsRes
---@field result ErrorCode @

---@class CheckQueuingReq
---@field iscancel boolean @

---@class ReturnToSelectRoleArg

---@class ReturnToSelectRoleRes
---@field accountData LoadAccountData @

---@class SelectRoleNewRes
---@field result ErrorCode @
---@field banTime number @
---@field endTime number @
---@field reason string @

---@class ReadRoleDataArg
---@field roleid uint64 @
---@field rpcid number @
---@field index number @
---@field server_id number @

---@class ReadRoleDataRes
---@field result ErrorCode @
---@field data RoleAllInfo @

---@class CheckRoleNameArg
---@field rpcid number @
---@field name string @
---@field type RoleType @
---@field sex SexType @
---@field hair_id number @发型
---@field role_index number @
---@field eye EyeInfo @美瞳

---@class CheckRoleNameRes
---@field result ErrorCode @

---@class LeaveSceneArg
---@field rolelist ChangeSceneRole__Array @
---@field type LeaveSceneType @
---@field rpcid number @
---@field account string @
---@field destLine number @
---@field logoutType LogoutType @
---@field line number @
---@field deliver_type DeliverType @
---@field src_unique_id number @
---@field src_map_id number @
---@field dst_unique_id number @
---@field dst_map_id number @
---@field reconnect_role_id uint64 @重连角色
---@field reconnect_index number @
---@field new_session uint64 @
---@field scene_line number @
---@field last_code ErrorCode @登出的错误码,封号用
---@field ban_info BanRoleInfo @
---@field is_gm boolean @是GM发起的
---@field dst_camp_id number @目标阵营id

---@class UnlockSealFindBackData
---@field state boolean @
---@field type number @
---@field time number @

---@class DEStageProgress
---@field sceneid number @
---@field bossids number__Array @
---@field bosshppercenet number__Array @

---@class CircleDrawData
---@field index number @
---@field itemid number @
---@field itemcount number @
---@field prob number @

---@class PayV2Record
---@field pay PayBaseInfo__Array @
---@field aileen PayAileenRecord__Array @
---@field vipPoint number @
---@field vipLevel number @
---@field totalPay number @
---@field payCardButtonStatus number @
---@field payAileenButtonStatus number @
---@field lastFirstPayAwardTime number @
---@field growthFundLevelInfo PayAwardRecord__Array @
---@field growthFundLoginInfo PayAwardRecord__Array @
---@field vipLevelGiftInfo PayAwardRecord__Array @
---@field payFirstAwardButtonStatus number @
---@field growthFundButtonStatus number @
---@field payMemberInfo PayMemberRecord__Array @
---@field privilege PayMemberPrivilege @
---@field lastUpdateDay number @
---@field isEverPay boolean @
---@field consumelist PayconsumeBrief__Array @
---@field weekcard PaytssInfo @
---@field monthcard PaytssInfo @
---@field growthfund PaytssInfo @
---@field rewardTime number @
---@field growthfundnotifytime number @

---@class OutLookMilitaryRank
---@field military_rank number @

---@class RiskInfo2DB
---@field infos RiskMapInfos @
---@field updatetime number @
---@field getDiceTime number @
---@field getDiceNum number @
---@field riskInfo RoleRiskInfo @

---@class OutLookGuild
---@field name string @
---@field icon number @
---@field id uint64 @

---@class ShopRecordOne
---@field type number @
---@field updatetime number @
---@field items Item__Array @
---@field slots number__Array @
---@field buycount ItemBrief__Array @
---@field dailybuycount ItemBrief__Array @
---@field refreshcount number @
---@field refreshtime number @
---@field refreshday number @
---@field ishint boolean @
---@field weekbuycount ItemBrief__Array @

---@class BRRankState
---@field confid number @
---@field brbid1 number @
---@field brbid2 number @
---@field rank number @

---@class ItemBrief
---@field item_id number @
---@field item_uid uint64 @
---@field item_count int64 @
---@field is_bind boolean @

---@class CampRoleRecord
---@field lastCampID number @
---@field taskInfo CampTaskInfo2DB @

---@class EffectData
---@field effectID number @
---@field multiParams EffectMultiParams__Array @

---@class SpActivityOne
---@field actid number @
---@field task SpActivityTask__Array @
---@field getBigPrize boolean @
---@field startTime number @
---@field actStage number @
---@field argenta ArgentaData @

---@class LevelSealRecord
---@field type number @
---@field selfCollectCount number @
---@field selfAwardCountIndex number @
---@field LevelSealButtonStatus number @
---@field lastLevelSealStatus boolean @

---@class OutLookEquip
---@field itemid number__Array @
---@field enhancelevel number__Array @
---@field slot number__Array @
---@field enhancemaster number @

---@class RoleBriefInfo
---@field type RoleType @
---@field roleID uint64 @
---@field name string @
---@field level number @
---@field sex SexType @
---@field job_level number @
---@field outlook OutLook @外观
---@field equip_ids PBuint32__Array @
---@field status RoleStatusType @状态
---@field delete_time uint64 @删号时间
---@field role_index number @
---@field platid number @
---@field account string @账号(openid)信息

---@class StageInfo
---@field sceneID number__Array @
---@field rank number__Array @
---@field countscenegroupid number__Array @
---@field count number__Array @
---@field day number @
---@field buycount number__Array @
---@field cdscenegroupid number__Array @
---@field cooldown number__Array @
---@field chapterchest number__Array @
---@field chestOpenedScene number__Array @
---@field helperwincount number @
---@field helperweekwincount number @
---@field lastweekuptime number @
---@field bossrushmax number @
---@field brupday number @
---@field BRjoincounttoday number @
---@field BRrefreshcounttoday number @
---@field brrankstate BRRankState @
---@field stageprogress DEStageProgress__Array @
---@field stageassist StageAssistOne__Array @
---@field holidayid number @
---@field holidaytimes number @
---@field absparty AbsPartyInfo @
---@field kidhelpercount number @
---@field tarjatime number @
---@field tarjaaward number @

---@class RiskOneMapInfo
---@field grids RiskGridInfo__Array @
---@field curX number @
---@field curY number @
---@field boxInfos RiskBoxInfo__Array @
---@field mapid number @
---@field moveDirection number @

---@class IdipMessage
---@field message string @

---@class AbsPartyBase
---@field type number @
---@field diff number @

---@class IdipData
---@field mess IdipMessage @
---@field punishInfo IdipPunishData__Array @
---@field lastSendAntiAddictionTime number @
---@field isSendAntiAddictionRemind boolean @
---@field picUrl string @
---@field notice PlatNotice__Array @
---@field xinyue_hint boolean @

---@class STC_ACHIEVE_POINT_REWARD
---@field rewardId number @
---@field rewardStatus number @

---@class WeekEnd4v4Data
---@field indexWeekEnd number @
---@field activityID number @
---@field count number @

---@class RoleMiscData
---@field dummy number @
---@field lastpush number @
---@field pushflag number @
---@field laddertime number @
---@field answersindex number @
---@field answersversion number @
---@field hintflag number @
---@field lastchangeprotime number @
---@field changeprocount number @
---@field daily_lb_num number @
---@field updatetime number @
---@field declaration string @
---@field qqvip_hint boolean @
---@field qqvip_hint_read_time number @
---@field egame_hint boolean @
---@field egame_hint_readtime number @
---@field xinyue_hint boolean @
---@field xinyue_readtime number @
---@field last_level number @
---@field loginacttime number @
---@field loginactstatus boolean @
---@field daygiftitems number @
---@field hardestNestExpID number @

---@class EffectMultiParams
---@field IDType number @
---@field ID number @
---@field effectParams number__Array @

---@class RiskGridInfo
---@field x number @
---@field y number @
---@field gridType RiskGridType @
---@field rewardItem ItemBrief @
---@field boxState RiskBoxState @

---@class TeamRecord
---@field lastdayuptime number @
---@field lastweekuptime number @
---@field goddessGetRewardToday number @
---@field teamcountins TeamCountInfo__Array @
---@field teamcost RoleTeamCostInfo @
---@field weeknestrewardcount number @
---@field diamondcostcount number @
---@field useticketcount number @
---@field dragonhelpfetchedrew number__Array @

---@class CampTaskInfo2DB
---@field resetTime number @
---@field infos CampTaskInfo__Array @
---@field refreshTimes number @
---@field rewardTimes number @
---@field rewardTime number @

---@class CheckinRecord
---@field CheckinInfo number @
---@field CheckinTime number @
---@field CheckinCount number @

---@class SpActivityTask
---@field taskid number @
---@field state number @
---@field progress number @

---@class SpriteRecord
---@field SpriteData SpriteInfo__Array @
---@field InFight uint64__Array @
---@field Books boolean__Array @
---@field NewAwake SpriteInfo @

---@class RewardInfo
---@field UniqueId uint64 @
---@field Type number @
---@field SubType number @
---@field State number @
---@field TimeStamp number @
---@field Param string__Array @
---@field Item ItemBrief__Array @
---@field name string @
---@field comment string @
---@field uniqueday number @
---@field isget boolean @

---@class RolePartnerData
---@field partnerid uint64 @
---@field last_leave_partner_time number @
---@field taked_chest number @
---@field open_shop_time number @
---@field apply_leave_time number @
---@field chest_redpoint boolean @
---@field last_update_time number @

---@class IBGiftOrder
---@field orderid string @
---@field time number @

---@class QQVipInfo
---@field is_vip boolean @
---@field is_svip boolean @
---@field is_year_vip boolean @
---@field qq_vip_start number @
---@field qq_vip_end number @
---@field qq_svip_start number @
---@field qq_svip_end number @
---@field qq_year_vip_start number @
---@field qq_year_vip_end number @
---@field vip_newbie_rewarded boolean @
---@field svip_newbie_rewarded boolean @
---@field is_xinyue_vip boolean @

---@class SpActivity
---@field spActivity SpActivityOne__Array @
---@field lastBackFlowStartTime number @
---@field argentaPreData ArgentaPreData @
---@field lastArgentaStartTime number @

---@class PayBaseInfo
---@field paramID string @
---@field isPay boolean @

---@class BagExpandData
---@field type BagType @
---@field num number @
---@field count number @

---@class StcDesignationInfo
---@field designationID number @
---@field isNew boolean @
---@field reachTimestamp number @

---@class RoleRiskInfo
---@field mapID number @
---@field gridType number @
---@field sceneID number @
---@field canBuy boolean @

---@class SkillRecord
---@field manual_slot_1 SkillSlot__Array @
---@field manual_slot_2 SkillSlot__Array @
---@field automatic_slot SkillSlot__Array @
---@field all_skill ProfessionSkill__Array @
---@field first_learn_range_attack boolean @
---@field job_award ProfessionLevelPair__Array @
---@field plans SkillPlan__Array @技能方案
---@field cur_plan_id number @当前方案id(从0开始)

---@class PaytssInfo
---@field begintime number @
---@field endtime number @
---@field lastGetAwardTime number @

---@class Buff
---@field buffID number @
---@field buffLevel number @
---@field effecttime number @
---@field skillID number @

---@class SpriteInfo
---@field uid uint64 @
---@field SpriteID number @
---@field AttrID number__Array @
---@field AttrValue number__Array @
---@field AddValue number__Array @
---@field SkillID number @
---@field PassiveSkillID number__Array @
---@field Level number @
---@field EvolutionLevel number @
---@field Exp number @
---@field PowerPoint number @
---@field TrainExp number @
---@field EvoAttrID number__Array @
---@field EvoAttrValue number__Array @
---@field ThisLevelEvoAttrID number__Array @
---@field ThisLevelEvoAttrValue number__Array @

---@class RiskMapInfos
---@field infos RiskOneMapInfo__Array @
---@field diceNum number @
---@field leftDiceTime number @
---@field boxInfos RiskBoxInfo__Array @

---@class BagContent
---@field equip_page EquipPage__Array @
---@field bag Item__Array @
---@field warehouse WarehousePage__Array @
---@field bag_unlock_space number @
---@field warehouse_unlock_pages number @
---@field active_page number @
---@field virtual_items VirtualItemData__Array @
---@field shortcut_bar ShortcutData__Array @
---@field bag_max_load number @
---@field bag_cur_load number @
---@field bag_load_extend_times number @
---@field cart Item__Array @
---@field cart_cur_load number @
---@field cart_max_load number @
---@field cart_max_blank number @
---@field arrows ArrowPair__Array @
---@field recover_info RecoverInfos @
---@field merchant_bag Item__Array @
---@field wardrobe Item__Array @衣橱

---@class SBuffRecord
---@field buffs Buff__Array @
---@field items BuffItem__Array @

---@class ItemFindBackInfo
---@field id ItemFindBackType @
---@field subtype number @
---@field useCount number @
---@field towerLevel number @
---@field dayTime number @
---@field findBackCount number @
---@field level number @
---@field onceBackExp MapIntItem__Array @

---@class atlasdata
---@field groupid number @
---@field finishid number @

---@class SPetRecord
---@field touchStartTime number @
---@field touchHourAttr number @
---@field touchTodayAttr number @
---@field followStartTime number @
---@field followTodayAttr number @
---@field hungryStartTime number @
---@field moodStartTime number @
---@field max_level number @

---@class WeekReportData
---@field type WeekReportDataType @
---@field joincount number @
---@field lastjointime number @

---@class LiveRecord
---@field mostViewedRecord OneLiveRecordInfo @
---@field mostCommendedRecord OneLiveRecordInfo @
---@field recentRecords OneLiveRecordInfo__Array @
---@field myTotalCommendedNum number @
---@field myTotalViewedNum number @
---@field livevisible boolean @

---@class PandoraDrop
---@field pandoraDropID number @
---@field betterDropTimes number @
---@field bestDropTimes number @
---@field nextBetterDropTimes number @
---@field nextBestDropTimes number @

---@class GuildSkill
---@field skillId number @
---@field skillLvl number @

---@class MapIntItem
---@field key uint64 @
---@field value number @

---@class PushConfig
---@field type number @
---@field forbid boolean @

---@class IBShopAllRecord
---@field nLastTime number @
---@field allIBShopItems IBShopOneRecord__Array @
---@field nVipLv number @
---@field bLimitHot boolean @
---@field orders IBGiftOrder__Array @
---@field paydegree number @

---@class RolePushInfo
---@field infos PushInfo__Array @
---@field configs PushConfig__Array @

---@class RoleLotteryInfo
---@field lastDrawTime number @
---@field OneDrawCount number @
---@field MinimumRewardCount number @
---@field goldFreeDrawTime number @
---@field goldFreeDrawCount number @
---@field goldFreeDrawDay number @
---@field goldOneDrawCount number @
---@field goldMinimumRewardCount number @
---@field clickday number @
---@field clickfreetime number @
---@field clickfreecount number @
---@field clickcostcount number @
---@field pandora PandoraDrop__Array @
---@field lastGiftUpdateTime number @
---@field shareGiftCount number @
---@field spriteMinGuarantee number @
---@field spriteNextMinGuarantee number @

---@class PushInfo
---@field type number @
---@field sub_type number @
---@field time number @

---@class LeaveSceneRes
---@field result ErrorCode @
---@field dataList RoleAllInfo__Array @

---@class ShopRecord
---@field dayupdate number @
---@field shops ShopRecordOne__Array @
---@field weekupdate number @

---@class PayPrivilegeShop
---@field goodsID number @
---@field totalCount number @
---@field usedCount number @

---@class RiskBoxInfo
---@field state RiskBoxState @
---@field leftTime number @
---@field item ItemBrief @
---@field beginTime number @
---@field slot number @

---@class BuffItem
---@field itemid number @
---@field itemcount number @
---@field expiretime number @

---@class OnlyOnceGuildBonusData
---@field bonusType number @
---@field bonusVar number @

---@class RoleFindBackRecord
---@field openTime number @
---@field updateTime number @
---@field isFoundBack boolean @
---@field usedInfos ExpFindBackInfo__Array @
---@field curUsedInfos ExpFindBackInfo__Array @
---@field findBackOpenTime number @
---@field itemBackUpdateTime number @
---@field itemFindBackInfosHis ItemFindBackInfo__Array @
---@field itemFindBackInfoCur ItemFindBackInfo__Array @
---@field unlockSealTime number @
---@field unlockSealData UnlockSealFindBackData__Array @
---@field notifyBackTime number @

---@class RoleTeamCostInfo
---@field expid number @
---@field costindex number @
---@field dragoncount number @
---@field updateday number @
---@field getgiftvalue number @

---@class RoleGuildBonusData
---@field sentGuildBonus OnlyOnceGuildBonusData__Array @
---@field gotGuildBonusDayNum MapKeyValue__Array @
---@field gotGuildBonusTotalNum MapKeyValue__Array @

---@class SAtlasRecord
---@field atlas number__Array @
---@field finishdata atlasdata__Array @

---@class PvpRoleBrief
---@field roleid uint64 @
---@field rolename string @
---@field rolelevel number @
---@field roleprofession number @
---@field roleserverid number @

---@class SQARecord
---@field cur_qa_type number @
---@field trigger_time MapKeyValue__Array @
---@field used_count MapKeyValue__Array @
---@field last_reset_time number @
---@field last_end_time number @

---@class IBShopOneRecord
---@field nGoodsID number @
---@field activity number @
---@field activitytime number @
---@field nItemCount number @
---@field nUpdateTime number @

---@class StcAchieveInfo
---@field achieveID number @
---@field rewardStatus number @

---@class OutLookDesignation
---@field id number @

---@class FirstPassRecord
---@field infos FirstPassStageInfo__Array @

---@class HeroBattleOneGame
---@field team1 RoleSmallInfo__Array @
---@field team2 RoleSmallInfo__Array @
---@field over HeroBattleOver @
---@field mvpid uint64 @
---@field exploit number @

---@class OneLiveRecordInfo
---@field liveID number @
---@field DNExpID number @
---@field watchNum number @
---@field commendNum number @
---@field hasFriend boolean @
---@field beginTime number @
---@field tianTiLevel number @
---@field guildBattleLevel number @
---@field nameInfos LiveNameInfo__Array @
---@field liveType LiveType @
---@field hasGuild boolean @
---@field canEnter boolean @
---@field sceneID number @
---@field curWatchNum number @
---@field mapID number @
---@field isCross boolean @

---@class IdipPunishData
---@field type number @
---@field punishTime number @
---@field banTime number @
---@field reason string @

---@class ActivateHairColor
---@field hair_id number @
---@field hair_color_id number__Array @

---@class ArgentaPreData
---@field lastUpdateTime number @
---@field activityPoint number__Array @
---@field finishNestCount number__Array @

---@class PayAwardRecord
---@field id number @
---@field lastGetAwardTime number @

---@class ActivityRecord
---@field ActivityId number__Array @
---@field FinishCount number__Array @
---@field ActivityAllValue number @
---@field DoubleActivityId number @
---@field ChestGetInfo number @
---@field NeedFinishCount number__Array @
---@field activityWeekValue number @
---@field LastUpdateTime uint64 @
---@field guildladdertime number @

---@class HeroBattleRecord
---@field havehero number__Array @
---@field cangetprize boolean @
---@field alreadygetprize boolean @
---@field totalnum number @
---@field winnum number @
---@field losenum number @
---@field winthisweek number @
---@field lastupdatetime number @
---@field gamerecord HeroBattleOneGame__Array @
---@field todayspcount number @
---@field freeweekhero number__Array @
---@field bigrewardcount number @
---@field weekprize number @
---@field elopoint number @
---@field daytime number @
---@field daytimes number @
---@field experiencehero number__Array @
---@field experienceherotime number__Array @
---@field continuewinnum number @
---@field maxkillnum number @

---@class LoginRecord
---@field loginDayCount number @
---@field logindayforloginreward number @
---@field lastUpdateDay number @
---@field lrostate number @
---@field loginRewards LoginReward__Array @

---@class RoleSmallInfo
---@field roleID uint64 @
---@field roleName string @
---@field roleLevel number @
---@field roleProfession number @
---@field rolePPT number @

---@class PkOneRecord
---@field opposer uint64 @
---@field profession number @
---@field name string @
---@field point number @
---@field honorpoint number @
---@field result PkResultType @

---@class PkRecordSubInfo
---@field point number @
---@field rewardcount number @
---@field seasondata PkBaseHist @
---@field recs PkOneRec__Array @

---@class ReportDataRecord
---@field weeklogindays number @
---@field within20minsdays number @
---@field lastdayonlinetime number @
---@field lastdayupdate number @
---@field lastweekupdate number @
---@field weeknestfasttime number @
---@field weekactivedays number @
---@field weeknestdaytimes number @
---@field wxdata WeekReportData__Array @
---@field lastrecommondtime number @
---@field abyssdaycount number @

---@class Attribute
---@field basicAttribute number__Array @
---@field percentAttribute number__Array @
---@field attrID number__Array @

---@class FirstPassStageInfo
---@field firstPassID number @
---@field isGetReward boolean @
---@field rank number @
---@field hasCommended boolean @
---@field totalRank number @
---@field commendedStarLevels number__Array @

---@class GuildRecord
---@field cardplaycount number @
---@field cardchangecount number @
---@field updateday number @
---@field checkin number @
---@field boxmask number @
---@field cardbuychangecount number @
---@field recvFatigue number @
---@field askBonusTime number @
---@field getCheckInBonusNum number @
---@field darereward number__Array @
---@field ishintcard boolean @
---@field guildskills GuildSkill__Array @
---@field cardmatchid uint64 @
---@field inheritTeaTime number @
---@field inheritStuTime number @
---@field bonusData RoleGuildBonusData @
---@field guildinheritcdtime number @
---@field teacherinherittime number @
---@field partyreward MapKeyValue__Array @

---@class TowerRecord
---@field last_refresh_time int64 @刷新时间
---@field max_pass_floor number @最大通关层数
---@field history_max_pass_floor number @历史最大通关层
---@field award_dungeon_ids PBuint32__Array @通关奖励副本id

---@class Designation2DB
---@field coverDesignationID number @
---@field abilityDesignationID number @
---@field maxAbilityDesignationID number @
---@field designationData StcDesignationInfo__Array @

---@class AttributeInfo
---@field id number @
---@field value number @

---@class MapKeyValue
---@field key uint64 @
---@field value uint64 @

---@class PayMemberRecord
---@field ID number @
---@field ExpireTime number @
---@field isClick boolean @
---@field buttonStatus number @
---@field lastDragonFlowerTime number @
---@field isNotifyExpire boolean @
---@field begintime number @
---@field isNotifyExpireSoon boolean @

---@class AchieveDbInfo
---@field achieveData StcAchieveInfo__Array @
---@field achieveAward STC_ACHIEVE_POINT_REWARD__Array @
---@field oldachievement StcAchieveInfo__Array @

---@class PvpData
---@field pvprecs PvpOneRec__Array @
---@field wincountall number @
---@field losecountall number @
---@field drawcountall number @
---@field joincounttodayint number @
---@field wincountthisweek number @
---@field lastdayupt number @
---@field lastweekupt number @
---@field weekrewardhaveget boolean @
---@field todayplaytime number @
---@field todayplaytimes number @

---@class OutLookTitle
---@field titleID number @

---@class ArenaRecord
---@field OptimalRank number @
---@field point number @
---@field dayupdate number @
---@field pointreward number__Array @
---@field rankreward number__Array @

---@class PayMemberPrivilege
---@field usedReviveCount number @
---@field usedChatCount number @
---@field usedAbyssCount number @
---@field usedBossRushCount number @
---@field usedBuyGreenAgateCount number @
---@field usedSuperRiskCount number @
---@field usedPrivilegeShop PayPrivilegeShop__Array @

---@class OutLookState
---@field statetype OutLookStateType @
---@field param number @
---@field paramother uint64 @

---@class PetSingle
---@field uid uint64 @
---@field petid number @
---@field level number @
---@field exp number @
---@field sex number @
---@field power number @
---@field mood number @
---@field hungry number @
---@field fixedskills number__Array @
---@field randskills number__Array @
---@field record SPetRecord @
---@field max_level number @
---@field canpairride boolean @

---@class PayAileenRecord
---@field paramID string @
---@field itemID number @
---@field lastBuyTime number @
---@field detail PaytssInfo @
---@field lastdelivertime number @

---@class TeamCountInfo
---@field teamType number @
---@field finishCountToday number @
---@field buyCountToday number @
---@field extraAddCount number @
---@field helpcount number @

---@class PkRecord
---@field point number @
---@field week number @
---@field unused_win number @
---@field unused_lose number @
---@field unused_continuewin number @
---@field honorpoint number @
---@field boxtaken number__Array @
---@field records PkOneRecord__Array @
---@field unused_continuelose number @
---@field prowin number__Array @
---@field prolose number__Array @
---@field unused_lastwin number @
---@field unused_lastlose number @
---@field prodraw number__Array @
---@field unused_draw number @
---@field pointlastlose number @
---@field day number @
---@field rewardcounttoday number @
---@field todayplaytime number @
---@field histweek PkBaseHist @
---@field histall PkBaseHist @
---@field pkdaytimes number @
---@field weektimes number @
---@field last7daystime number @
---@field info2v2 PkRecordSubInfo @

---@class DragonRecord2DB
---@field record DragonRecord__Array @
---@field updateDay number @

---@class PlatformShareResult
---@field last_update_time number @
---@field firstpass_share_list MapIntItem__Array @
---@field weekly_share_number number @
---@field weekly_award boolean @
---@field disappear_redpoint boolean @
---@field have_notify_scene number__Array @

---@class RoleConfig
---@field type string__Array @
---@field value string__Array @

---@class ArgentaData
---@field argentaStartTime number @
---@field level number @
---@field lastUpdateTime number @
---@field getDailyRewards number__Array @

---@class TShowRoleDailyVoteData
---@field roleID uint64 @
---@field freeCount number @
---@field costCount number @

---@class OutLookSprite
---@field leaderid number @

---@class SChatRecord
---@field lastupdatetime number @
---@field worldchattimes number @

---@class StageAssistOne
---@field stageid number @
---@field point number @

---@class PvpOneRec
---@field wincount number @
---@field losecount number @
---@field drawcount number @
---@field mvpID uint64 @
---@field myside PvpRoleBrief__Array @
---@field opside PvpRoleBrief__Array @
---@field military number @

---@class PkBaseHist
---@field win number @
---@field lose number @
---@field draw number @
---@field lastwin number @
---@field lastlose number @
---@field continuewin number @
---@field continuelose number @

---@class PayconsumeBrief
---@field ts number @
---@field billno string @

---@class PkOneRec
---@field ret PkResultType @
---@field myside PvpRoleBrief__Array @
---@field opside PvpRoleBrief__Array @
---@field cpoint number @

---@class PetSysData
---@field fightid uint64 @
---@field followid uint64 @
---@field petseats number @
---@field lastfollowid uint64 @
---@field pets PetSingle__Array @

---@class ExpFindBackInfo
---@field type ExpBackType @
---@field usedCount number @

---@class LoginReward
---@field day number @
---@field itemID number @
---@field state LoginRewardState @
---@field items ItemBrief__Array @

---@class FlowerRecord
---@field roleid uint64__Array @
---@field count number__Array @
---@field updateday number @
---@field getRankReward boolean @
---@field getFlowerTime number @
---@field getFlowerNum number @

---@class CampTaskInfo
---@field taskID number @
---@field taskStatus number @

---@class RewardRecord
---@field RewardInfo RewardInfo__Array @
---@field given string @
---@field taken string @
---@field nextdayreward number @
---@field onlinereward number__Array @

---@class LiveNameInfo
---@field guildID uint64 @
---@field guildName string @
---@field guildIcon number @
---@field roleInfo RoleBriefInfo @
---@field teamLeaderName string @
---@field isLeft boolean @
---@field teamName string @
---@field leagueID uint64 @

---@class DragonRecord
---@field dragonType number @
---@field hardLevel number @
---@field curFloor number @
---@field updateTime number @

---@class AbsPartyInfo
---@field aby AbsPartyBase__Array @
---@field abyssmailtime number @

---@class MilitaryRecord
---@field military_rank number @
---@field military_rank_his number @
---@field military_exploit number @
---@field military_exploit_his number @
---@field last_update_time number @

---@class OutLookOp
---@field weapon OutLookType @
---@field clothes OutLookType @

---@class TShowVoteRecord
---@field updateTime number @
---@field voteData TShowRoleDailyVoteData__Array @
---@field haveSendRank boolean @

---@class BuyGoldFatInfo
---@field day number @
---@field BuyGoldCount number @
---@field BuyFatigueCount number__Array @
---@field BuyDragonCount number @

---@class CreateRoleOnDBNewArg
---@field rpcID number @
---@field roleData RoleAllInfo @
---@field mtime uint64 @

---@class CreateRoleOnDBNewRes
---@field result ErrorCode @
---@field nickid number @

---@class CheckQueuingNtf
---@field rolecount number @
---@field timeleft number @
---@field errorcode ErrorCode @

---@class CrossRoleInfo
---@field session uint64 @
---@field roleid uint64 @
---@field name string @

---@class ReportSessionInfo
---@field cross_gsline number @
---@field is_add boolean @
---@field roles CrossRoleInfo__Array @
---@field is_reconnect boolean @

---@class NewRoleCreatedData
---@field roledata RoleAllInfo @
---@field clientInfo ClientInfo @
---@field totalRoleNum number @

---@class FunctionOpenInfo
---@field flag number @

---@class NsCloseNtf
---@field serverid number @

---@class PayMember
---@field ID number @
---@field ExpireTime number @
---@field isClick boolean @

---@class SceneSwitchTeamData
---@field teamID number @
---@field curSceneIndex_nouse number @
---@field sceneIDs_nouse number__Array @
---@field towerReachFloor number @
---@field towerUseTime number @
---@field robotsummarystored RoleSummaryStored__Array @
---@field robotID uint64__Array @
---@field rolebufflist RoleBuff__Array @
---@field teamsyndata TeamSynAll @
---@field airsceneid number @

---@class PkBattleInfo
---@field roles PkRoleInfo__Array @
---@field robotlookupid number @
---@field guildladderid uint64__Array @

---@class PkRoleInfo
---@field pkrec PkRoleRec @
---@field rolebrief RoleSmallInfo @
---@field serverid number @

---@class PkRoleRec
---@field point number @
---@field win number @
---@field lose number @
---@field draw number @
---@field records number__Array @

---@class PvpRoleInfo
---@field roleid uint64 @
---@field camp number @
---@field level number @
---@field name string @
---@field profession number @
---@field military_rank number @

---@class RoleBuff
---@field roleid uint64 @
---@field bufflist Buff__Array @

---@class RoleSummaryStored
---@field RoleID uint64 @
---@field Level number @
---@field Profession number @
---@field Name string @
---@field Attribute Attribute @
---@field RoleArenaInfo RoleArenaInfo @
---@field fashion number__Array @
---@field skills SkillInfo__Array @
---@field equip Item__Array @
---@field PowerPoint number @
---@field emblem Item__Array @
---@field viplevel number @
---@field timelastlogout number @
---@field pptuptime number @
---@field leveluptime number @
---@field camp number @
---@field desigation number @
---@field sealtype number @
---@field sealbosscount number @
---@field nickid number @
---@field titleid number @
---@field op OutLookOp @
---@field push_info RolePushInfo @
---@field account string @
---@field device_id string @
---@field sprites SpriteInfo__Array @
---@field plat_type number @
---@field pets PetSingle__Array @
---@field fightPetId uint64 @
---@field fashionppt number @
---@field fashionpptuptime number @
---@field bindskills number__Array @
---@field privilege PayMember__Array @
---@field qqvip QQVipInfo @
---@field starttype StartUpType @
---@field enhancemaster number @
---@field pkpoint number @
---@field token string @
---@field military_record MilitaryRecord @
---@field display_fashion number__Array @
---@field artifact Item__Array @
---@field hair_color_id number @

---@class TeamSynAll
---@field members TeamSynMember__Array @
---@field teamID number @
---@field leaderID uint64 @
---@field expid number @
---@field guildID uint64 @
---@field pptlimit number @
---@field teamcost number @
---@field haspassword boolean @

---@class TeamSynMember
---@field roleID uint64 @
---@field memType TeamMemberType @

---@class RoleArenaInfo
---@field RecordCount number @
---@field RoleArenaRecordInfo RoleArenaRecordInfo__Array @

---@class ChangeSceneFromMsArg
---@field destSceneID number @
---@field mapid number @
---@field rolelist ChangeSceneRole__Array @
---@field data SceneSwitchData @
---@field isToCrossGs boolean @
---@field gsline number @
---@field type DeliverType @
---@field fight_group number @
---@field rpc_id number @

---@class RoleArenaRecordInfo
---@field RecordMask number @
---@field RecordTime number @
---@field ChallengedId uint64 @

---@class HorseSwitchData
---@field roleid uint64__Array @

---@class PvpBattleInfo
---@field roleinfo PvpRoleInfo__Array @
---@field uid number @

---@class ChangeSceneFromMsRes
---@field result ErrorCode @
---@field role_uid uint64 @出问题的玩家id
---@field role_name string @出问题的玩家名字

---@class SceneGardenSlot
---@field index number @
---@field plantuid uint64 @
---@field plantid number @
---@field buffid number @

---@class SkyCraftRoleBrief
---@field roleid uint64 @
---@field name string @
---@field level number @
---@field profession number @
---@field ppt number @
---@field pkpoint number @

---@class CustomBattleMatchBattleInfo
---@field battleuid uint64 @
---@field matchid number @
---@field issystem boolean @
---@field isfair boolean @
---@field type number @

---@class GmfScenePara
---@field roomdata GmfRoom @
---@field guildwartimestate number @

---@class KMatchRole
---@field roleid uint64 @
---@field serverid number @
---@field pvpinfo PvpRoleInfo @
---@field rolebrief RoleSmallInfo @
---@field pkrec PkRoleRec @
---@field pkmatchstage PkMatchStage__Array @
---@field eloPoint number @
---@field expdata KMatchExp @
---@field mapid number @

---@class GCFGuildGroup
---@field guildid uint64 @
---@field group number @

---@class BMReadySceneInfo
---@field group number @

---@class PkMatchStage
---@field ctime number @
---@field span number @
---@field robotpercent number @
---@field lookupid number @

---@class CustomBattleMatchInfo
---@field role CustomBattleMatchRoleInfo @
---@field battle CustomBattleMatchBattleInfo @

---@class SceneGardenInfo
---@field plants SceneGardenSlot__Array @

---@class GCFCreateBattleInfo
---@field uid uint64 @
---@field iswait boolean @
---@field guilds GCFGuildGroup__Array @
---@field existtime number @
---@field territoryid number @

---@class WorldBossBornInfo
---@field enemyid number @
---@field attackpercent number @
---@field maxhp number @
---@field currenthp number @

---@class SkyCitySceneInfo
---@field nFloor number @
---@field self SkyCityTeamBaseInfo__Array @
---@field target SkyCityTeamBaseInfo__Array @
---@field nGames number @
---@field nGroupID number @
---@field bWaitRoom boolean @
---@field rolsStatistics SCRoleStatistics__Array @
---@field endtime number @

---@class LeagueBattleTeamData
---@field league_teamid uint64 @
---@field name string @
---@field serverid number @
---@field servername string @
---@field score number @
---@field rank number @
---@field total_num number @
---@field total_win number @
---@field members LeagueBattleRoleBrief__Array @

---@class KMatchExp
---@field expid number @
---@field rolecount number @

---@class MobaBattleInfo
---@field uid number @
---@field roleinfo PvpRoleInfo__Array @
---@field elopoint1 number @
---@field elopoint2 number @

---@class KMatchUnit
---@field serverid number @
---@field roleid uint64 @
---@field teamid number @
---@field roles KMatchRole__Array @
---@field param uint64 @

---@class ResWarSceneInfo
---@field mineid number @
---@field teamid number @
---@field groupid number @
---@field endtime number @
---@field self ResWarTeamBaseInfo__Array @
---@field target ResWarTeamBaseInfo__Array @
---@field selfguildid uint64 @
---@field targetguildid uint64 @
---@field selfaddtime number @
---@field targetaddtime number @
---@field buffid number @

---@class LeagueBattleInfo
---@field team1 LeagueBattleTeamData @
---@field team2 LeagueBattleTeamData @
---@field type LeagueBattleType @
---@field uid number @

---@class CustomBattleParam
---@field infoa CustomBattleMatchInfo @
---@field infob CustomBattleMatchInfo @

---@class SceneOwnerInfo
---@field uid uint64 @

---@class HeroBattleInfo
---@field uid number @
---@field roleinfo PvpRoleInfo__Array @
---@field elopoint1 number @
---@field elopoint2 number @

---@class InvFightBattleInfo
---@field inunit InvFightUnit__Array @
---@field uID uint64 @

---@class CustomBattleMatchRoleInfo
---@field roleid uint64 @
---@field profession number @
---@field rolename string @
---@field serverid number @
---@field win number @
---@field lose number @
---@field draw number @
---@field records number__Array @
---@field timestamp number @
---@field stages PkMatchStage__Array @
---@field point number @

---@class GuildArenaData
---@field guildId uint64 @
---@field guildName string @
---@field guildIcon number @

---@class GmfRoom
---@field uid uint64 @
---@field wartype number @
---@field battleid number @
---@field guildid11 uint64 @
---@field guildid22 uint64 @
---@field createtime number @
---@field perstigerank11 number @
---@field perstigerank22 number @

---@class CreateBattleSceneArg
---@field newuid uint64 @
---@field destLine number @
---@field mapID number @
---@field param CreateBattleParam @
---@field createtype number @

---@class SkyCityTeamBaseInfo
---@field teamid number @
---@field uid uint64 @
---@field name string @
---@field lv number @
---@field ppt number @
---@field job number @
---@field online boolean @

---@class LeagueBattleRoleBrief
---@field roleid uint64 @
---@field name string @
---@field level number @
---@field serverid number @
---@field profession number @
---@field ppt number @
---@field pkpoint number @
---@field account string @

---@class guildbossinfo
---@field bossindex number @
---@field curbossindex number @
---@field bosshp number @
---@field count number @

---@class SkyCraftInfo
---@field type SkyCraftType @
---@field uid number @
---@field round SCEliRoundType @
---@field team1 SkyCraftTeamData @
---@field team2 SkyCraftTeamData @

---@class SCRoleStatistics
---@field roleid uint64 @
---@field killcount number @
---@field deadcount number @
---@field totaldamage number @

---@class BMRoleEnter
---@field roleid uint64 @
---@field name string @
---@field sceneid number @
---@field gsline number @
---@field level number @

---@class SkyCraftTeamData
---@field stid uint64 @
---@field name string @
---@field score number @
---@field rank number @
---@field total_num number @
---@field win_num number @
---@field members SkyCraftRoleBrief__Array @

---@class InvFightUnit
---@field roleid uint64 @
---@field smallinfo RoleSmallInfo @

---@class KMatchFightData
---@field type KMatchType @
---@field roles KMatchRole__Array @
---@field units KMatchUnit__Array @
---@field uid uint64 @

---@class BMFightSceneInfo
---@field games number @
---@field groupsvr number @
---@field battleid number @
---@field roles BMRoleEnter__Array @

---@class ResWarTeamBaseInfo
---@field teamid number @
---@field uid uint64 @
---@field name string @
---@field lv number @
---@field ppt number @
---@field job number @
---@field online boolean @
---@field guildid uint64 @
---@field guildname string @

---@class MsSaveDBEndArg
---@field is_end boolean @
---@field is_swtich boolean @

---@class MsSaveDBEndRes

---@class RegisterDb2RouterArg
---@field serverid number @

---@class RegisterDb2RouterRes
---@field result ErrorCode @

---@class RoleStateReport
---@field roleid uint64__Array @
---@field state number__Array @
---@field timelastlogin number__Array @

---@class FmMasterInfo
---@field serverid number @

---@class EnterHallNotice
---@field roleid uint64 @

---@class FirstEnterSceneNtf
---@field roleid uint64 @

---@class RoleInfoOnMs
---@field accountID string @
---@field roleid uint64 @
---@field name string @
---@field mapid number @
---@field sceneid number @
---@field roleCreatedTime number @
---@field idipdata IdipData @
---@field clientIP string @
---@field level number @
---@field lastLoginTime number @
---@field token string @
---@field logintype LoginType @
---@field loginplatid number @
---@field type RoleType @
---@field sex SexType @
---@field fashion_record FashionRecord @
---@field equips Equips @
---@field job_lv number @
---@field system_open_list number__Array @
---@field client_big_version number @
---@field change_name_count number @
---@field is_chat_level_limit boolean @是否过滤低等级玩家聊天消息
---@field server_id number @
---@field achievement_point number @
---@field clientinfo ClientInfo @
---@field currentdiamond uint64 @
---@field currentrob uint64 @
---@field currentzeny uint64 @
---@field zero_profit_time uint64 @
---@field zero_profit_reason string @
---@field last_logout_time uint64 @
---@field role_index number @
---@field online_time number @
---@field sticker StickerBaseInfo @个人图鉴
---@field line_id number @
---@field pearson_setting PearsonalSetting @
---@field title_id number @称号id
---@field tag number @标签信息
---@field total_recharge int64 @历史累计充值
---@field login_days number @登录天数
---@field register_time number @注册时间(用于查询用，省的从db取)
---@field chat_icons ChatTagRecord @聊天个性化图案

---@class MSCrashRecoverG2M
---@field isCrossGs boolean @
---@field sessionList uint64__Array @
---@field roleList RoleInfoOnMs__Array @
---@field gsline number @

---@class UpdateGlobalValue
---@field id number @
---@field dragoninfo GlobalDragonInfo @
---@field loginactivity GlobalLoginActivityInfo @

---@class GlobalDragonInfo
---@field sceneid number__Array @
---@field timestamp number__Array @

---@class GlobalLoginActivityInfo
---@field worldlv number @

---@class SyncRoleSummaryToMS
---@field rsus RoleSummaryStored__Array @

---@class CrossGsCloseNtf2Ms
---@field gsline number @

---@class GetRoleSummaryFromMSArg
---@field roleids uint64__Array @

---@class GetRoleSummaryFromMSRes
---@field rsus RoleSummaryStored__Array @

---@class CrashRecoverM2GArg
---@field gsLine number @
---@field max_count number @
---@field last_role_id uint64 @

---@class EquipPage
---@field equip Item__Array @
---@field page_name string @

---@class RegisterMs2HArg
---@field serverid number @

---@class RegisterMs2HRes
---@field ret number @

---@class QueryRouterArg
---@field serverid number @

---@class QueryRouterRes
---@field info RouterListenInfo @
---@field line number @

---@class RegisterMs2WorldArg
---@field server_id number @

---@class RegisterMs2WorldRes
---@field result ErrorCode @
---@field gs_num number @
---@field is_master boolean @
---@field serverid number @

---@class RegisterMs2RouterArg
---@field server_id number @

---@class RegisterMs2RouterRes
---@field result ErrorCode @

---@class AccountRole
---@field account string @
---@field roleid uint64 @

---@class RegisterMSToCSData
---@field platformid number @
---@field serverid number @
---@field platformtype number @
---@field servername string @
---@field apptype number @
---@field onlineAccounts AccountRole__Array @

---@class RegisterMSToCSDataRes
---@field error ErrorCode @
---@field serverID number @

---@class RoleLoginData
---@field sessionID uint64 @
---@field roledata RoleInfoOnMs @

---@class RoleLoginReconnectNtf
---@field roleid uint64 @

---@class RoleLogoutData
---@field sessionID uint64 @
---@field level number @

---@class ClientSessionChangeG2M
---@field roleid uint64 @
---@field oldsession uint64 @
---@field newsession uint64 @
---@field cinfo ClientInfo @

---@class RegisterMs2FmArg
---@field zoneid number @
---@field serverid number @

---@class FMWhiteRoleList
---@field role FMWhiteRoleData__Array @

---@class FMWhiteRoleData
---@field acc string @
---@field nick string @

---@class RegisterMs2FmRes
---@field result ErrorCode @
---@field fmsvrid number @
---@field whitelist FMWhiteRoleList @
---@field radiolist LargeRoomRoleParam @
---@field is_master boolean @

---@class LargeRoomRoleParam
---@field name string__Array @
---@field roleid uint64__Array @

---@class RoleStateNtf
---@field roleid uint64__Array @
---@field state number__Array @
---@field timelastlogin number__Array @

---@class BroadCastGlobalValue
---@field id number @
---@field value string @

---@class CrashRecoverM2GRes
---@field isCrossGs boolean @
---@field sessionList uint64__Array @
---@field roleList RoleInfoOnMs__Array @
---@field mapidList number__Array @
---@field sceneidList number__Array @
---@field owneridlist uint64__Array @
---@field dungeonidList number__Array @
---@field teamlist TeamBriefInfo__Array @
---@field mercenarylist MercenaryStatusToMsData__Array @佣兵信息

---@class HintNotify
---@field systemid number__Array @
---@field isremove boolean @

---@class IdipPunishInfo
---@field type number @
---@field endTime number @
---@field banTime number @
---@field leftTime number @

---@class CreateRoleArg
---@field name string @
---@field sex SexType @
---@field type RoleType @角色类型（临时）
---@field hair_id number @发型
---@field eye EyeInfo @美瞳

---@class CreateRoleRes
---@field result ErrorCode @
---@field roleData RoleAllInfo @

---@class SelectRoleArg
---@field index number @

---@class SelectRoleRes
---@field result ErrorCode @
---@field index number @
---@field ban_info BanRoleInfo @
---@field account_data LoadAccountData @

---@class RoleChangeSceneData
---@field roleid uint64 @
---@field mapid number @
---@field sceneid number @
---@field gsline number @
---@field iscrossgs boolean @
---@field line_id number @
---@field camp_id number @阵营id

---@class SelectRoleNtfData
---@field roleData RoleAllInfo @
---@field serverid number @
---@field task_triggers TaskTriggerAllNotifyData @

---@class SceneCfg
---@field SceneID number @
---@field SyncMode number @
---@field isWatcher boolean @
---@field camera number @镜头参数
---@field is_new_map boolean @对玩家来说是新探索的地图
---@field switch_type SwitchSceneType @
---@field scene_line number @
---@field dungeon_id number @副本id
---@field camera_fade_type EnterSceneCameraFadeType @相机渐变类型
---@field is_rotate_camera boolean @是否转镜头
---@field show_tip ShowTipToRoleData @切场景提示
---@field scene_uid number @

---@class Position
---@field uid uint64 @
---@field pos_x number @
---@field pos_y number @
---@field pos_z number @
---@field face number @
---@field bTransfer boolean @

---@class CallData
---@field skillid number @
---@field sequence number @
---@field slot number @
---@field leftrunningtime number @

---@class SceneRequest
---@field sceneID number @
---@field roleID uint64 @

---@class SkillSlot
---@field slot number @
---@field skill_id number @
---@field skill_level number @

---@class TargetHurtInfo
---@field target_id uint64 @
---@field hurt_value number @

---@class SkillReplyDataUnit
---@field effect_id number @
---@field firer_id uint64 @
---@field fx string @
---@field token number @
---@field target_list TargetHurtInfo__Array @

---@class SkillDataUnit
---@field slot number @
---@field target_id uint64 @
---@field manual_face number @
---@field cast_point Vec3 @

---@class UserID
---@field uid uint64 @

---@class TeamSetting
---@field min_lv number @
---@field max_lv number @
---@field target number @目标
---@field sub_target number @
---@field name string @
---@field create_time uint64 @

---@class AcceptTeamInvatationRes
---@field error ErrorCode @

---@class CreateTeamRes
---@field error ErrorCode @

---@class CreateTeamArg
---@field team_setting TeamSetting @

---@class AcceptTeamInvatationArg
---@field team_id uint64 @
---@field inviter_id uint64 @

---@class InviteJoinTeamArg
---@field user_id uint64 @

---@class InviteJoinTeamRes
---@field error ErrorCode @

---@class BegJoinTeamArg
---@field uid uint64 @
---@field team_id number @

---@class BegJoinTeamRes
---@field error ErrorCode @
---@field team_id uint64 @

---@class GetApplicationListRes
---@field members MemberBaseInfo__Array @
---@field error ErrorCode @

---@class GetApplicationListArg

---@class EmptyMsg

---@class LeaveTeamArg

---@class LeaveTeamRes
---@field error ErrorCode @

---@class KickTeamMemberRes
---@field error ErrorCode @

---@class KickTeamMemberArg
---@field user_id uint64 @

---@class TeamSettingArg
---@field team_setting TeamSetting @

---@class TeamSettingRes
---@field error ErrorCode @

---@class TransferArg
---@field role_type RoleType @

---@class TransferRes
---@field error ErrorCode @
---@field role_type RoleType @

---@class ProfessionSkill
---@field role_type RoleType @
---@field skill SkillInfo__Array @

---@class SkillPointArg
---@field data SkillPointData__Array @

---@class SkillPointRes
---@field err ErrorCode @
---@field data SkillPointData__Array @
---@field learn_skill_slot SkillSlot__Array @

---@class PerSkillPoint
---@field skill_id number @
---@field skill_point number @
---@field skill_operatetype QualityPointOperateType @技能点操作类型 枚举 自由分配 推荐分配
---@field skill_recommend_id number @手动加技能点 0 推荐加点 传推荐加点Id

---@class SkillPointData
---@field role_type RoleType @
---@field points PerSkillPoint__Array @

---@class SkillSlotData
---@field manual_slot_1 SkillSlot__Array @手动技能孔1
---@field manual_slot_2 SkillSlot__Array @手动技能孔2
---@field auto_slot SkillSlot__Array @自动技能孔
---@field manual_slot_3 SkillSlot__Array @支援类技能队列

---@class SkillSlotArg
---@field data SkillSlotData @

---@class SkillSlotRes
---@field err ErrorCode @
---@field data SkillSlotData @

---@class AttrCompareInfo
---@field attr_type number @类型
---@field cur_value number @
---@field incr_value number @

---@class AttrUpdateInfo
---@field entity_id uint64 @
---@field source_type number @来源
---@field attr_list AttrCompareInfo__Array @

---@class AttrAddInfo
---@field attr_type number @
---@field attr_value number @
---@field attr_operatetype QualityPointOperateType @属性点的操作类型枚举 自由分配,推荐分配
---@field attr_recommend_id number @手动加点属性 0 推荐添加传 professionText推荐Id

---@class AttrAddArg
---@field attr_list AttrAddInfo__Array @
---@field page_id number @

---@class AttrAddRes
---@field result ErrorCode @

---@class AttrClearArg
---@field page_id number @

---@class AttrClearRes
---@field result ErrorCode @

---@class QualityPointPageInfo
---@field id number @
---@field name string @
---@field point_list QualityPointInfo__Array @

---@class QualityPointInfo
---@field type number @
---@field level number @

---@class QualityPointRecord
---@field page_count number @
---@field cur_page number @
---@field page_list QualityPointPageInfo__Array @

---@class SingingArg
---@field skill_id number @
---@field target uint64 @
---@field common uint64 @压缩数据

---@class SingingRes
---@field result ErrorCode @

---@class VirtualItemData
---@field item_count int64 @
---@field item_id number @

---@class ShortcutData
---@field uid uint64 @
---@field item_id number @

---@class MemberStatusInfo
---@field role_id uint64 @
---@field cur_hp number @
---@field cur_sp number @
---@field total_hp number @
---@field total_sp number @
---@field lv number @
---@field scene_id number @
---@field role_type number @
---@field job_lv number @
---@field pos Vec3 @
---@field line_id number @
---@field scene_uid number @

---@class RoleReviveArg
---@field type ReviveType @
---@field role_id uint64 @

---@class RoleReviveRes
---@field err ErrorCode @

---@class ReviveRecord
---@field scene_id number @
---@field position Vec3 @
---@field face number @

---@class WarehousePage
---@field name string @
---@field item Item__Array @

---@class TaskRecord
---@field tasks TaskInfo__Array @所有任务
---@field trial_choice number @试炼任务选择
---@field complete_tasks TaskDoneInfo__Array @任务完成列表

---@class FashionRecord
---@field own_fashion Item__Array @拥有的时装
---@field wear_fashion_uid uint64 @穿着的时装uid
---@field own_ornament Item__Array @衣橱中的饰品
---@field wear_ornament_ids PBuint32__Array @穿着的饰品id
---@field current_hair_id number @头发ID
---@field eye EyeInfo @眼睛
---@field fashion_count number @时尚度
---@field fashion_count_history number @历史最高时尚度
---@field own_head_portrait Item__Array @拥有的头像
---@field wear_head_portraut_uid uint64 @当前穿着的头像
---@field fashion_count_award RepeatPairIntInt @典藏值领奖
---@field equip_ornament Item__Array @装备页当中的饰品
---@field ro_fashion RoFashionRecordPb @新外观系统
---@field portrait_frame number @头像框

---@class WearFashionReq
---@field uid uint64 @时装id
---@field is_put_on boolean @true:穿  false:脱

---@class CreateStaticSceneArg
---@field unique_id number @
---@field scene_id number @
---@field gs_line number @
---@field scene_line number @场景线

---@class WearFashionRes
---@field result ErrorCode @
---@field uid uint64 @
---@field is_put_on boolean @

---@class CreateStaticSceneRes
---@field err ErrorCode @

---@class SyncSkill
---@field skills SkillInfo__Array @
---@field role_id uint64 @

---@class SyncUnit
---@field role_id uint64 @
---@field skill SyncSkill @
---@field outlook OutLook @
---@field role SyncRole @
---@field trans_figure TransFigureInfo @
---@field vehicle TakeVehicleInfo @
---@field equip_data EquipData @
---@field common_vehicle CommonVehicleInfo @公共载具
---@field outward OutwardInfo @
---@field platform PlatformUnit @擂台
---@field battle_vehicle BattleVehicleInfo @

---@class LocalGMCmdArg
---@field cmd_and_args string @请用空格隔开比如 addexp 111 11
---@field is_master boolean @当一个gm命令会被多个进程同时执行的时候，比如多个login，需要通过这个变量，做逻辑执行的区分，比如数据库落地之类，只能有一个login去执行

---@class CreateBattleSceneRes
---@field result ErrorCode @
---@field sceneinstanceid number @
---@field sceneline number @

---@class CreateArenaPvpCustomArg
---@field mapid number @
---@field in_sceneid number @

---@class CreateArenaPvpCustomRes
---@field result ErrorCode @

---@class ActiveJoinArenaRoomArg
---@field scene_id number @
---@field gsline number @
---@field arena_type number @

---@class ActiveJoinArenaRoomRes
---@field result ErrorCode @

---@class ShowListArenaPvpArg
---@field type ArenaType @
---@field page number @
---@field show_count number @

---@class ArenaRoomInfo
---@field id number @
---@field name string @
---@field play_mode ArenaRoomPlayMode @
---@field room_open_minlevel number @
---@field room_open_maxlevel number @
---@field room_open_mincount number @
---@field room_open_maxcount number @
---@field member_can_invite boolean @成员能否邀请
---@field owner RoleBriefInfo @
---@field state ArenaState @
---@field custom_room ArenaCustomRoomInfo @自定义房间信息

---@class ShowListArenaPvpRes
---@field result ErrorCode @
---@field rooms ArenaRoomInfo__Array @

---@class ChangeArenaRoomConditionArg
---@field open_min_level number @
---@field open_max_level number @
---@field arena_type ArenaType @
---@field playmode ArenaRoomPlayMode @

---@class ChangeArenaRoomConditionRes
---@field result ErrorCode @

---@class RoomMemberStatusInfo
---@field role_id uint64 @
---@field belong_group ArenaPvpFightGroup @
---@field scene_id number @
---@field state ArenaUserState @

---@class RoleLeaveStaticData
---@field sessionid uint64 @
---@field static_sceneid number @
---@field static_mapid number @
---@field fight_group number @

---@class RoleSwitchInfo
---@field brief RoleBriefInfo @
---@field extra RoleExtraInfo @

---@class RoleLeaveSceneData
---@field role_id uint64 @

---@class WearOrnamentArg
---@field is_put_on boolean @是穿上还是脱下
---@field item_id number @饰品id

---@class WearOrnamentRes
---@field result ErrorCode @结果
---@field is_put_on boolean @
---@field item_id number @

---@class SceneDestroyData
---@field unique_id number @

---@class Equips
---@field equip_page EquipPage__Array @
---@field cur_page number @
---@field tot_page number @
---@field equip_list_forged PBint32__Array @已经制作的装备
---@field equip_task_id PBint32__Array @装备循环任务

---@class ChangeHairArg
---@field hair_id number @头发ID

---@class ChangeHairRes
---@field result ErrorCode @返回结果
---@field hair_id number @头发ID

---@class SyncRole
---@field role_type RoleType @

---@class ArenaSetMemberInviteArg
---@field can boolean @true 可以，no为不可以

---@class ArenaRoomChangeOwnerData
---@field new_owner RoleBriefInfo @

---@class TaskReportNpc
---@field npcid number @
---@field taskid number @指定任务id

---@class TaskReportPostion
---@field x number @
---@field z number @
---@field sceneid number @场景id

---@class TaskReportArg
---@field npc TaskReportNpc @如果有npc,则检查npc访问任务
---@field postion TaskReportPostion @如果有位置,那么后台检查寻路任务
---@field photo TaskReportPhoto @
---@field publicvehicle number @公共载具
---@field sceneobjectid number @场景物件的 配置id
---@field trialchoice number @试炼任务的选择
---@field skill_id number @技能释放任务
---@field timeline_id number @剧情动画id
---@field fakeitemid number @假物品的使用
---@field black_curtainid number @黑幕id
---@field qte_id number @上报QTE
---@field sequence_id number @
---@field npc_action NpcAction @上报NPC交互
---@field play_action PlayAction @上报玩家动作
---@field profess_choice number @玩家职业选择

---@class TaskReportRes
---@field result ErrorCode @
---@field delayfinish boolean @true表示自动完成,但是下一帧
---@field sequence_id number @

---@class ReadRoleBriefInfo
---@field role_id uint64 @
---@field use_cache boolean @是否使用cache
---@field watch_player_uid uint64 @：0表示不是观战, > 0是观战
---@field camp_id number @阵营id

---@class ReconectSync
---@field role_data RoleAllInfo @
---@field others_in_view UnitAppearance__Array @
---@field scene_id number @
---@field dungeons DungeonsReconnectInfo @
---@field game_role_info GameRoleReconnectInfo @gamelib里的一些数据
---@field dungeon_id number @
---@field task_triggers TaskTriggerAllNotifyData @

---@class ChangeEyeArg
---@field eye_id number @
---@field eye_style_id number @

---@class ChangeEyeRes
---@field result ErrorCode @
---@field eye_id number @
---@field eye_style_id number @

---@class CounterIntPair
---@field pair_key number @
---@field pair_value number @

---@class TakeVehicleArg
---@field is_get_on boolean @是否上车
---@field cur_status number @当前状态

---@class TakeVehicleRes
---@field result ErrorCode @
---@field is_get_on boolean @
---@field cur_status number @当前状态

---@class DriverPassenger
---@field driver_uuid uint64 @
---@field passenger_uuid uint64 @

---@class GetOnVehicleRes
---@field result ErrorCode @

---@class GetOnVehicleArg
---@field data DriverPassenger @

---@class GetOnVehicleAgreeArg
---@field data DriverPassenger @

---@class GetOnVehicleAgreeRes
---@field result ErrorCode @
---@field data DriverPassenger @

---@class AskTakeVehicleArg
---@field data DriverPassenger @

---@class AskTakeVehicleRes
---@field result ErrorCode @
---@field data DriverPassenger @

---@class ShopItemBrief
---@field table_id number @商品id
---@field is_lock boolean @是否解锁
---@field left_time number @剩余可购买次数
---@field buy_cost CounterUIntPair__Array @购买货币消耗

---@class CounterUIntPair
---@field pair_key number @
---@field pair_value number @

---@class ShopItems
---@field shop_id number @商店id
---@field items ShopItemBrief__Array @商品集合
---@field equips Item__Array @白模装备集合

---@class Shops
---@field shop ShopItems__Array @每个商店

---@class GeneralUint32
---@field id number @

---@class TransFigureInfo
---@field trans_figure_id number @
---@field buff_list ROBuffInfos @
---@field change_skill_only_ boolean @变身只改变技能

---@class OpenSystemInfo
---@field opensys_ids PBuint32__Array @开放系统
---@field closesys_ids PBuint32__Array @关闭系统
---@field server_opentime uint64 @开服时间
---@field noticesys_ids PBuint32__Array @可领取预告系统

---@class OpenSystemRewardArg
---@field system_id number @领奖id

---@class OpenSystemRewardRes
---@field error ErrorInfo @

---@class SystemRecord
---@field systems SysOpenRecord__Array @
---@field force_closed_systems PBint32__Array @

---@class DungeonsRecord
---@field theme_dungeons ThemeDungeonsRecord @主题副本
---@field tower TowerRecord @无限塔
---@field cook_dungeons CookDungeonsRecord @
---@field battlefield BattlefieldRecord @战场
---@field hymn_trail HSDungeonsRecord @圣歌试炼副本
---@field platform PlatformRecord @擂台
---@field hero_challenge HeroChallengeRecord @英雄挑战
---@field guild_match GuildMatchDungeonsRecord @公会匹配赛
---@field themestory_dungeons ThemeStoryDungeonsRecord @主题剧情本

---@class ThemeDungeonsRecord
---@field dungeons ThemeDungeonsInfo__Array @副本信息
---@field award_last_week number @

---@class MemberPosInfo
---@field role_id uint64 @
---@field pos Vec3 @

---@class ThemeDungeonsInfo
---@field dungeons_id number @副本id

---@class AllMemberPosInfo
---@field team_id uint64 @
---@field members MemberPosInfo__Array @

---@class EasyPath
---@field value number @卡普拉人员table_id/场景id
---@field teleport_type TeleportType @传送方式
---@field start_pos Vec3 @起点坐标
---@field start_camera number @起点相机
---@field start_face number @起点朝向
---@field end_pos Vec3 @终点坐标
---@field end_camera number @终点相机
---@field end_face number @终点朝向
---@field next_scene_id number @下一个场景ID
---@field code ErrorCode @当发生错误时的返回码中断寻路
---@field dest_type NavigationDestType @终点类型
---@field dest_scene_id number @最终场景id
---@field sequence number @自增id
---@field kapula_face number @卡普拉的面向

---@class EasyPathDestination
---@field type TeleportType @
---@field dest_id number @终点输入地图,卡普拉输入npcid

---@class EasyPathForgive
---@field type number @放弃状态,备用

---@class TaskTrackGotoDungeonArg
---@field taskid number @使用taskid来寻找要去的副本
---@field sequence_id number @

---@class TaskTrackGotoDungeonRes
---@field result ErrorCode @
---@field sequence_id number @

---@class QueryIsInTeamArg
---@field uid uint64 @

---@class QueryIsInTeamRes
---@field is_in_team boolean @
---@field is_captain boolean @
---@field is_friend boolean @
---@field result ErrorCode @
---@field member_count number @
---@field intimacy_degree number @
---@field sticker StickerBaseInfo @
---@field title_id number @称号id

---@class TeamApplicationData
---@field info MemberBaseInfo @

---@class FollowOthersArg
---@field uid uint64 @

---@class FollowOthersRes
---@field error ErrorCode @

---@class AcceptBegJoinTeamArg
---@field uid uint64 @

---@class AcceptBegJoinTeamRes
---@field error ErrorCode @

---@class NewMemberNtfData
---@field uid uint64 @
---@field name string @
---@field notice ErrorInfo @

---@class MemberAttrChangeInfo
---@field attr AttributeInfo__Array @
---@field uid uint64 @
---@field mercenary_id number @0:表示玩家,其他表示佣兵id

---@class AccelerateVehicleArg

---@class AccelerateVehicleRes
---@field result ErrorCode @

---@class CookDungeonsRecord
---@field dungeons CookDungeonsInfo__Array @

---@class CookDungeonsInfo
---@field dungeons_id number @

---@class CarryThingData
---@field wall_uuid uint64 @
---@field item CarryItem @
---@field entity_uuid uint64 @

---@class PutThingData
---@field entity_uuid uint64 @

---@class CommonVehicleInfo
---@field vehicle_uuid uint64 @公共载具uid
---@field passenger_uuid uint64 @乘客ID
---@field is_get_on boolean @
---@field vehicle_item_id number @
---@field position Vec3 @落地位置

---@class RideCommonVehicleArg
---@field vehicle_id number @

---@class RideCommonVehicleRes
---@field result ErrorCode @

---@class GetInvitationListArg
---@field type number @1好友 2工会 3最近组队 4佣兵

---@class GetInvitationListRes
---@field error ErrorCode @
---@field role_ids PBuint64__Array @
---@field spcial_recommand PBuint64__Array @

---@class ReconnectReadAccountArg
---@field session_id uint64 @
---@field account string @
---@field server_id number @
---@field delay_id number @
---@field role_id uint64 @角色id

---@class ReconnectReadAccountRes
---@field result ErrorCode @
---@field account_data LoadAccountData @

---@class RequestTransfigureArg
---@field transfigure_id number @变身配置表id

---@class RequestTransfigureRes
---@field result ErrorCode @

---@class BodyChangeData
---@field target_uuid uint64 @目标uuid
---@field left_time number @剩余时间

---@class EffectShowData
---@field target_uuid uint64 @目标uuid
---@field effect_id number @显示的effect

---@class SkillResultList
---@field results SkillResultSyncInfo__Array @

---@class ModuleModifyTime
---@field type RoleModuleType @类型
---@field time uint64 @时间戳[目前以秒为单位]
---@field save_db_time uint64 @落数据库时间戳[以毫秒为单位]

---@class AllModuleModifyTime
---@field times ModuleModifyTime__Array @所有模块的时间戳

---@class CountItemInfo
---@field type int64 @
---@field id int64 @
---@field count number @
---@field cd_time_stamp int64 @

---@class CountRecord
---@field count_item_list CountItemInfo__Array @

---@class CollectRequestArg
---@field collection_uid uint64 @

---@class CollectRequestRes
---@field result ErrorCode @

---@class CollectAwardData
---@field collection_uid uint64 @
---@field collect_time int64 @采集的时间点
---@field is_need_delete boolean @
---@field collect_type LifeSkillType @采集状态

---@class UnitDisappear
---@field uuid uint64 @
---@field leave_scene_reason number @离开场景的原因，是gamelib定义的一个枚举

---@class UnitDisappearData
---@field unit UnitDisappear__Array @

---@class RegisterProxy2NsArg
---@field line number @
---@field serverid number @
---@field gslisten ListenAddress @
---@field gatelisten ListenAddress @
---@field anylisten ListenAddress @

---@class RegisterProxy2NsRes
---@field errcode ErrorCode @

---@class RegisterProxy2MsArg
---@field serverid number @
---@field line number @

---@class RegisterProxy2MsRes
---@field errcode ErrorCode @

---@class AskProxyGs2NsArg
---@field serverid number @
---@field line number @

---@class AskProxyGs2NsRes
---@field serverid number @
---@field line number @
---@field address ListenAddress @

---@class AskProxyGt2Ns
---@field serverid number @
---@field line number @

---@class AskProxyGt2NsArg
---@field serverid number @
---@field line number @

---@class AskProxyGt2NsRes
---@field serverid number @
---@field line number @
---@field address ListenAddress @

---@class StopStateArg
---@field state number @

---@class StopStateRes
---@field result number @

---@class RegisterGs2ProxyArg
---@field serverid number @
---@field line number @

---@class RegisterGs2ProxyRes
---@field errcode ErrorCode @

---@class RegisterGt2ProxyArg
---@field serverid number @
---@field line number @

---@class RegisterGt2ProxyRes
---@field errcode ErrorCode @

---@class TakeClimbingInfo
---@field wall_uuid uint64 @在哪个墙上

---@class RegisterProxy2TradeArg
---@field serverid number @
---@field line number @

---@class RegisterProxy2TradeRes
---@field errcode ErrorCode @

---@class TaskTriggerRecord
---@field taskid number @任务id
---@field triggerevent number @事件类型 TaskTriggerEvent
---@field args PBuint64__Array @过程产生的数据,比如跳转场景,动态怪物uuid.

---@class BattlefieldRecord
---@field elo number @elo值
---@field win_times number @胜场
---@field lose_times number @输场
---@field draw_times number @平局场
---@field recent_ten_times_win_mask number @最近10次胜负掩码
---@field last_battle_time uint64 @最后战斗时间
---@field daily_battle_count number @每天参战数

---@class GuaranteeData
---@field guarantee_class GuaranteeClass__Array @

---@class GuaranteeClass
---@field total_times uint64 @该领域总保底次数
---@field hit MapKeyIntValue__Array @抽卡制第几次命中
---@field try_times MapKeyIntValue__Array @失败/计数
---@field pair_try_times MapPairKeyIntValue__Array @
---@field pair_hit MapPairKeyIntValue__Array @

---@class MapKeyIntValue
---@field key uint64 @
---@field value number @

---@class MapPairKeyIntValue
---@field first uint64 @
---@field second uint64 @
---@field value number @

---@class GetServerLevelBonusInfoArg

---@class GetServerLevelBonusInfoRes
---@field serverlevel number @当前服务器等级
---@field basebonus number @增加的,万分比的分子,可能为负数,显示的时候要做百分比处理
---@field jobbonus number @增加的,万分比的分子,可能为负数,显示的时候要做百分比处理
---@field nextrefreshtime uint64 @一个time_t结构,下一次刷新的时间,可能是0,不再刷新
---@field errcode ErrorCode @
---@field hidden_base_level number @角色经验对应的真实等级
---@field server_open_days number @开服天数

---@class AnyRegister2ProxyArg
---@field servertype number @一个字节ascii码
---@field serverid number @区服的id
---@field line number @如果有,则是line no,否则0

---@class AnyRegister2ProxyRes
---@field errcode ErrorCode @
---@field proxyserverid number @
---@field proxyline number @
---@field fromservertype number @
---@field app_type number @
---@field plat_type number @

---@class ProxyAddrNotify
---@field proxyaddr ProxyAddr__Array @

---@class AnyRegister2ControlArg
---@field servertype number @
---@field serverid number @
---@field line number @

---@class AnyRegister2ControlRes
---@field errcode ErrorCode @
---@field proxyaddrs ProxyAddr__Array @所有的proxy地址

---@class ProxyAddr
---@field addr ListenAddress @
---@field line number @proxy可以多线.

---@class HSDungeonsRecord
---@field used_times number @已获奖励次数

---@class SysOpenRecord
---@field id number @
---@field is_open_award_get boolean @

---@class BeHatredDisappearNotifyInfo

---@class AcrobaticInfo

---@class QueryRandomAwardStartArg
---@field from_scene RandomAwardSceneType @
---@field item_id number @抽奖券的id

---@class QueryRandomAwardStartRes
---@field result ErrorCode @
---@field item_id number @
---@field item_count number @

---@class WaBaoAwardIdNtfData
---@field award_id number @
---@field item_id number @
---@field item_count number @
---@field award_level number @奖励等级
---@field is_free boolean @是否是免费的挖宝

---@class SevenLoginInfo
---@field cur_reward number @
---@field reward_get_list PBint32__Array @
---@field last_refresh_time int64 @

---@class LifeSkillInfo
---@field type LifeSkillType @类型
---@field level number @等级
---@field exp number @经验

---@class LifeSkillRecord
---@field info LifeSkillInfo__Array @生活技能汇总
---@field gather_buff_end_time uint64 @自动采集buff结束时间
---@field mining_buff_end_time uint64 @自动挖矿buff结束时间

---@class YuanQiRequestArg
---@field type LifeSkillType @元气枚举
---@field recipe_id number @获得id
---@field count number @获得数量
---@field wall_id uint64 @容器id
---@field entity_id uint64 @使用者id

---@class YuanQiRequestRes
---@field result ErrorCode @返回码

---@class LifeSkillFishingArg
---@field option FishingType @选择操作
---@field wall_uuid uint64 @对应的鱼池
---@field player_face number @坐下来的时候的朝向
---@field auto_fish_item ItemCostInfo @自动钓鱼使用的道具
---@field is_auto_use_item boolean @自动钓鱼到期自动续时

---@class LifeSkillFishingRes
---@field result ErrorCode @返回码
---@field intro_info LifeSkillFishingIntroRes @进入操作返回值, 预留给鱼影
---@field throw_info LifeSkillFishingThrowRes @抛竿操作返回数据
---@field left_time number @剩余免费次数

---@class LifeSkillFishingThrowRes
---@field upper_time int64 @起竿的时间戳
---@field reflex_time number @玩家反应时间

---@class LifeSkillFishingIntroRes

---@class LifeEquipInfo
---@field type LifeEquipType @所属类型
---@field equip_id number @生活装备id

---@class LifeEquipData
---@field equip LifeEquipInfo__Array @装备
---@field got_equip LifeEquipAddInfo__Array @拥有装备

---@class LifeEquipAddInfo
---@field type LifeEquipType @类型
---@field equip_ids PBint32__Array @拥有生活装备id

---@class LifeSkillEndData
---@field result ErrorCode @返回码
---@field type LifeSkillType @类型

---@class LifeEquipItem
---@field type LifeEquipType @装备位置
---@field equip_id number @装备id

---@class RoleTempRecord
---@field mini_uids PBuint64__Array @
---@field mvp_uids PBuint64__Array @
---@field auto_battle RoleAutoBattleInfo @
---@field setup_info SetupInfoData @设置信息
---@field first_item_count PBint32__Array @首次获得道具
---@field client_info ClientInfo @客户端登录信息
---@field offline_item_unique_ids PBuint64__Array @离线删除物品唯一删除标识列表
---@field frequent_words FreqWords__Array @星标常用语
---@field pearsonal_setting PearsonalSetting @个人设置
---@field photo_data FashionPhotoData @时尚杂志最高分的数据

---@class BanRoleArg
---@field account_id string @
---@field server_id number @
---@field role_uid uint64 @角色uid
---@field rpc_id number @
---@field operate BanRoleOperate @
---@field ban_info BanRoleInfo__Array @
---@field read_unique_id number @
---@field is_operate_account boolean @是否封本区账号
---@field ban_account PlatBanAccount @
---@field mtime uint64 @

---@class BanRoleRes
---@field result ErrorCode @
---@field isban boolean @
---@field ban_info BanRoleInfo__Array @
---@field ban_account BanAccount @
---@field ban_list BanRoleDataList @封禁列表，查询的时候用.
---@field account string @账号，查询的时候用

---@class RelationData
---@field guild_id int64 @

---@class LogOutData
---@field logout_type LogoutType @
---@field last_error ErrorCode @登出原因
---@field sesson_id uint64 @
---@field ban_info BanRoleInfo @

---@class PhotoFlow
---@field role_id uint64 @
---@field operate_type PhotoOperateType @拍照模式
---@field scene_id number @
---@field position Vec3 @拍照时候的地点
---@field sticker_id PBuint32__Array @使用贴纸的id
---@field frame_id number @使用边框的id
---@field emoji_id number @使用表情的id
---@field action_id number @动作的id
---@field message string @照片留言记录，如果没有传特殊字符
---@field result SavePhotoType @照片结果
---@field entity_id uint64__Array @npc或怪物的id

---@class DebugLogData
---@field log string @

---@class ShowAction
---@field no_use_parameter boolean @没用的变量可以删掉

---@class AchievementStepInfo
---@field targettype number @目标类型AchievementTargetType
---@field step number @当前进度
---@field maxstep number @最大进度
---@field arg number @具体的参数

---@class AchievementRecord
---@field achievementpoint number @当前总的成就点数
---@field badgelevel number @成就勋章等级
---@field achievements Achievement__Array @成就条目
---@field complete_info CompleteInfo__Array @记录角色完成信息
---@field point_reward_list PBint32__Array @已领取成就点奖励
---@field badge_level_reward_list PBint32__Array @已领取的成就等级奖励

---@class Achievement
---@field achievementid number @id
---@field steps AchievementStepInfo__Array @分阶段步骤
---@field finishtime uint64 @完成时间戳
---@field isfocus boolean @true表示关注中
---@field updatetime uint64 @更新时间戳
---@field is_get_reward boolean @是否已领奖

---@class TssSdkAntiData
---@field data string @
---@field len number @

---@class JudgeTextForbidArg
---@field text string @

---@class JudgeTextForbidRes
---@field result ErrorCode @
---@field text string @过滤后的文本

---@class Illustration
---@field monster MonsterPlate @魔物
---@field yahh YaHahaData @呀哈哈
---@field kill_monster_count MapInt32Int32__Array @野外怪击杀统计
---@field single_info MonsterSingleInfo__Array @单个怪物信息
---@field group_info MonsterGroupInfo__Array @分组信息
---@field research_info MonsterResearchInfo @总体研究进度

---@class MonsterPlate
---@field first_kill PBint32__Array @
---@field already_kill PBint32__Array @

---@class Health
---@field extra_base_experience int64 @今日额外的base经验
---@field extra_job_experience int64 @今日额外的job经验
---@field extra_fight_time number @
---@field today_revenue RevenueStatisticsPbInfo__Array @今日野外战斗收益
---@field bless_exp_list BlessExpNode__Array @祈福经验列表
---@field last_refresh_bless_exp_day number @上次计算祈福经验的日期
---@field today_basic_exp RevenueStatisticsPbInfo @基础经验(加成衰减不算)
---@field reve_item_list ReveItemContainerPb @每日统计

---@class PlatformRecord
---@field win_times number @胜场
---@field lose_times number @输场
---@field draw_times number @平局场
---@field cur_floor number @当前层

---@class RoleAutoBattleInfo
---@field hp_progress number @hp进度条值
---@field sp_progress number @
---@field is_open_hp boolean @
---@field is_open_sp boolean @
---@field hp_item_list PBint32__Array @
---@field sp_item_list PBint32__Array @
---@field pick_up_progress number @
---@field is_open_pick_up boolean @
---@field auto_battle_state number @挂机状态(1全自动，2半自动)
---@field auto_battle_range number @挂机范围(1自定义，2半屏，3全屏，4全图)
---@field auto_battle_range_num number @挂机范围具体值

---@class SaveAutoBattleData
---@field auto_battle RoleAutoBattleInfo @

---@class TaskSyncTeam
---@field taskid number @
---@field targetid number @
---@field targettype number @
---@field x number @
---@field z number @
---@field addnewtaskid number @优先处理新增任务id
---@field count number @变化数量
---@field fixedsceneid number @指定的场景内才同步

---@class SyncTaskInTeamReq
---@field tasksync TaskSyncTeam @同步任务update操作
---@field excluderoleid uint64 @

---@class SyncTaskInTeamNotify
---@field tasksync TaskSyncTeam @

---@class RoleWorldEvent
---@field todaycount number @今日完成次数
---@field currentfathertaskid PBint32__Array @当前任务的父任务
---@field todaymax number @本日最多次数
---@field weekcount number @本周次数
---@field weekmax number @本周最多次数
---@field currentfinishedtaskid PBint32__Array @当前已经完成的任务
---@field event_sign_pair RoleWorldEventSignPair__Array @事件是否存在标记
---@field task_new_player RoleWorldEventNewPair__Array @队伍有萌新/回流玩家标记

---@class RoleWorldEventDBNtf
---@field roleworldeventdbinfo RoleWorldEvent @世界事件数据库更新

---@class PlatformUnit
---@field floor number @

---@class CatTradeDbInfo
---@field train_list CatTradeTrainDbInfo__Array @
---@field is_get_reward boolean @
---@field need_fresh boolean @为了防止早上5点一起刷lua脚本,这里只记刷新标记,到客户端请求的时候真正刷新
---@field prestige_count number @声望产出有上限

---@class CatTradeTrainDbInfo
---@field seat_list CatTradeTrainSeatDbInfo__Array @

---@class CatTradeTrainSeatDbInfo
---@field item_id number @
---@field item_count number @
---@field is_full boolean @
---@field price number @

---@class HeroChallengeSingleRecord
---@field id number @
---@field best_grade number @最好成绩
---@field is_pass boolean @是否通关
---@field pass_time number @通关时间

---@class HeroChallengeRecord
---@field records HeroChallengeSingleRecord__Array @过卡记录

---@class MedalRecord
---@field medals MedalInfo__Array @勋章列表

---@class MedalInfo
---@field medal_id number @
---@field medal_type MedalType @
---@field is_activate boolean @是否被激活
---@field level number @
---@field attr_pos number @属性位置（神圣勋章专用）
---@field prestige_progress number @声望进度（光辉勋章专用）
---@field active_progress number @激活进度

---@class CompleteInfo
---@field type number @
---@field value number @

---@class BanRoleInfo
---@field type number @封号类型
---@field reason string @封号原因
---@field endtime uint64 @封号截止时间
---@field recover_info RecoverInfo__Array @追缴信息

---@class BanRoleDataList
---@field ban_data BanRoleData__Array @
---@field ban_account BanAccount @

---@class BanRoleData
---@field role_uid uint64 @角色uid
---@field ban_info BanRoleInfo__Array @

---@class ItemTemplate
---@field item_id number @道具id
---@field is_bind boolean @绑定
---@field modify_count number @数量
---@field equip_data EquipTemplate @

---@class EquipTemplate
---@field refine_data IdipEquipRefineData @
---@field enchant_data IdipEquipEnchantData @
---@field hole_data IdipEquipEnchantData @

---@class PayRecord
---@field consume_bill_list ConsumeBillData__Array @消费订单列表
---@field total_recharge number @累计充值

---@class ConsumeBillData
---@field bill_no string @
---@field create_time uint64 @

---@class PostcardDisplay
---@field table_ids PBint32__Array @目标id
---@field chapter_award number @
---@field chapter_ids number__Array @已领取奖励的章节

---@class ArrowPair
---@field pos ArrowPos @
---@field arrow_id number @

---@class DelegationRecord
---@field last_refresh_time uint64 @最后刷新时间
---@field last_award_time uint64 @最后达到领奖条件时间
---@field delegations DelegationData__Array @委托
---@field expired_delegations DelegationData__Array @过期委托
---@field cost_delegation number @消耗的委托证明
---@field left_award_times number @剩余可抽奖次数

---@class DelegationData
---@field id number @委托id
---@field finish_times number @完成次数
---@field status number @当前状态
---@field task_id number @
---@field accept_npc TaskNpc @
---@field finish_npc TaskNpc @

---@class DelegationSetData
---@field delegations DelegationData__Array @
---@field cost_delegation number @消耗的委托证明
---@field left_award_times number @剩余抽奖次数

---@class ThirtySignInfo
---@field cur_reward number @
---@field max_reward_index number @
---@field last_refresh_time int64 @
---@field is_end boolean @

---@class Sticker
---@field own_stickers PBint32__Array @
---@field grid PBint32__Array @
---@field grid_unlock_status PBint32__Array @格子解锁状态

---@class Suit
---@field suit_entrys Entry__Array @

---@class IdipEntryTableId
---@field table_id number @
---@field percent number @

---@class IdipEquipEnchantData
---@field entrys IdipEntryTableId__Array @

---@class BattleVehicleInfo
---@field driver_uuid uint64 @
---@field vehicle_id number @
---@field is_get_on boolean @
---@field position Vec3 @

---@class MerchantRecord
---@field start_time int64 @

---@class ArenaRoomStateData
---@field type ArenaSyncType @同步类型
---@field camp_info ArenaRoomChangeCampData @改变阵营/玩家进入房间
---@field owner_info ArenaRoomChangeOwnerData @改变房主
---@field mode_info ArenaRoomChangeModeData @改变模式
---@field leave_info ArenaRoomLeaveData @离开房间
---@field invite_info ArenaRoomMemberInviteData @成员邀请权限

---@class ArenaRoomChangeCampData
---@field role_id uint64 @
---@field new_camp ArenaPvpFightGroup @

---@class ArenaRoomChangeModeData
---@field new_mode ArenaRoomPlayMode @

---@class ArenaCustomRoomInfo
---@field member ScenePartFightGroup__Array @

---@class ArenaInviteRequetArg
---@field role_id uint64 @被邀请者uid

---@class ArenaInviteRequetRes
---@field result ErrorCode @

---@class ArenaInviteNtfData
---@field sender RoleBriefInfo @邀请者
---@field room_id number @

---@class ArenaSetMemberInviteRes
---@field result ErrorCode @

---@class ArenaRoomLeaveData
---@field role_id uint64 @

---@class ArenaRoomMemberInviteData
---@field can boolean @true 为可以邀请， false 取消

---@class IdipItemExtraInfoPb
---@field serial_num string @流水号
---@field cmd string @命令符
---@field source_id number @渠道号

---@class RoleLuaActivityData
---@field level_gift LevelGiftData @等级礼包

---@class LevelGiftData
---@field level_gift_id MapInt32Int32__Array @

---@class LimitedTimeOfferRecord
---@field is_opened boolean @功能是否开启
---@field opened_time number @功能开启时间
---@field role_continue_time number @累计持续时间
---@field role_continue_time_start number @累计起始时间
---@field is_active boolean @角色是否在活动状态
---@field is_started boolean @活动是否已开启
---@field has_first_pay boolean @本次活动是否有首充
---@field is_ended boolean @活动是否已经结束
---@field next_start_time number @下次活动开启时间
---@field activity_open_times number @活动累积开启次数

---@class LimitedOfferStatus
---@field status_type LimitedOfferStatusType @
---@field rest_time number @仅在活动开始时有效
---@field is_start boolean @是否为本次开启周期的首次通知[非上线通知]

---@class MallRecord
---@field records EachMallRecord__Array @

---@class MallServerItem
---@field seq_id number @
---@field bought_times number @
---@field money_type number @
---@field origin_price int64 @
---@field now_price int64 @

---@class EachMallRecord
---@field mall_id number @
---@field pools EachPoolRecord__Array @
---@field last_refresh_time int64 @
---@field manual_refresh_count number @手动刷新计数
---@field last_buy_timestamp int64 @最后一次购买道具的时间戳

---@class EachPoolRecord
---@field pool_id number @
---@field items MallServerItem__Array @

---@class TaskReportPhoto
---@field task_id number @
---@field photo_id number @

---@class ProfessionLevelPair
---@field profession_id number @
---@field level number @

---@class RevenueStatisticsPbInfo
---@field type RevenueStatisticsType @
---@field base_exp int64 @
---@field job_exp int64 @
---@field items RevenueItemPbInfo__Array @

---@class RevenueItemPbInfo
---@field item_id number @
---@field item_count int64 @
---@field time uint64 @

---@class TakeBattleVehicleArg
---@field is_get_on boolean @
---@field cur_status number @客户端需要，用于表示自动导航等

---@class TakeBattleVehicleRes
---@field result ErrorCode @
---@field is_get_on boolean @
---@field cur_status number @

---@class GuildAuctionRecordPerson
---@field itemid number @
---@field cost number @
---@field issuccess boolean @是否购买成功
---@field time uint64 @发生时间

---@class RoleGuildAuctionRecord
---@field records GuildAuctionRecordPerson__Array @竞拍记录无论失败成功,最多100条.按时间最新排序

---@class SkillPlan
---@field slots SkillSlots__Array @技能孔
---@field skills ProfessionSkill__Array @技能
---@field name string @方案名

---@class FrequentWordsArg
---@field freq_words FreqWords__Array @

---@class FrequentWordsRes
---@field error_code ErrorCode @
---@field freq_words FreqWords__Array @查询用

---@class ChatShareM2AArg
---@field share_type ShareType @
---@field uid uint64 @查询用
---@field role_id uint64 @
---@field rpc_id number @

---@class ChatShareM2ARes
---@field error_code ErrorCode @
---@field achievement Achievement @查询用
---@field quality_point_page_info QualityPointPageInfo @查询用
---@field skill_plan_share SkillPlanShare @查询用
---@field wardrobe_share WardrobeShare @查询用
---@field fashion_photo FashionPhotoShareData @时尚杂志分享照片

---@class ChatShareC2MArg
---@field share_type ShareType @
---@field uid uint64 @查询用

---@class ChatShareC2MRes
---@field error_code ErrorCode @
---@field achievement Achievement @查询用
---@field quality_point_page_info QualityPointPageInfo @查询用
---@field skill_plan_share SkillPlanShare @查询用
---@field wardrobe_share WardrobeShare @查询用
---@field fashion_photo FashionPhotoShareData @时尚杂志照片

---@class FreqWords
---@field uid uint64 @
---@field frequent_words_op FrequentWordsOper @
---@field words string @
---@field extra_param ExtraParam__Array @
---@field client_id number @透传客户端字段
---@field msg_forbid_flag MsgForbidFlag @脏词屏蔽类型

---@class ChatShareData
---@field share_type ShareType @
---@field plan_id number @
---@field role_id uint64 @
---@field uid uint64 @
---@field achievement Achievement @
---@field quality_point_page_info QualityPointPageInfo @
---@field skill_plan_share SkillPlanShare @
---@field wardrobe_share WardrobeShare @
---@field fashion_photo FashionPhotoShareData @时尚杂志照片

---@class ChatSyncDataArg
---@field delay_rpc number @
---@field role_uid uint64 @
---@field item_id number @道具扣除的id
---@field item_count number @道具扣除的数量
---@field share_type ShareType @分享类型
---@field plan_id number @分享方案id

---@class ChatSyncDataRes
---@field error_code ErrorCode @
---@field achievement Achievement @
---@field quality_point_page_info QualityPointPageInfo @
---@field skill_plan_share SkillPlanShare @
---@field wardrobe_share WardrobeShare @
---@field fashion_photo FashionPhotoShareData @时尚杂志照片

---@class SkillPlanShare
---@field plan_id number @
---@field skill_plan SkillPlan @
---@field role_name string @
---@field role_type RoleType @
---@field used_point number @
---@field unused_point number @

---@class EquipRefineAttachLuckyArg
---@field item_uid uint64 @

---@class EquipRefineAttachLuckyRes
---@field result ErrorCode @
---@field attach_lucky number @黑盒兜底附加成功率

---@class BarterItemArg
---@field items_brief ItemBrief__Array @

---@class BarterItemRes
---@field error_code ErrorCode @

---@class PearsonalSetting
---@field hit_outlook_when_bewatched boolean @被观战时隐藏外观

---@class WardrobeShare
---@field collection number @典藏值
---@field head number @
---@field face number @
---@field mouth number @
---@field back number @
---@field tail number @
---@field fashion number @时装

---@class VehicleRecord
---@field using_vehicle_id number @启用的载具ID
---@field pro_id number @职业载具ID
---@field pro_level number @职业载具等级
---@field pro_cur_exp number @职业载具当前经验值
---@field cur_level_critical_times number @当前经验暴击事件次数[有限制]
---@field dev_info VehicleDevInfo @职业载具素质培养信息
---@field special_permanent_list PBint32__Array @特色固定载具[职业载具不是特色载具,id不在此中]
---@field special_temp_vehicle TempVehicleExpireTime__Array @特色临时载具过期时间[id在里面]
---@field perment_outlook_list VehicleOutlook__Array @永久载具外观[id在里面,职业载具也是固定载具]

---@class EnableVehicleArg
---@field vehicle_op VehicleOperation @操作类型[启用/停用]
---@field vehicle_id number @载具ID

---@class EnableVehicleRes
---@field error_code ErrorCode @

---@class UpgradeVehicleArg
---@field item_id number @秘籍id
---@field count number @个数

---@class UpgradeVehicleRes
---@field error_code ErrorCode @
---@field used_times number @本周升级次数
---@field cur_level number @当前等级
---@field cur_exp number @当前经验值
---@field crit_times number @暴击次数
---@field crit_exp number @暴击经验值[base*times]

---@class UpgradeVehicleLimitArg

---@class UpgradeVehicleLimitRes
---@field error_code ErrorCode @
---@field quality_limit VehicleAttr @素质上限

---@class VehicleAttr
---@field attrs KeyValue32__Array @

---@class DevelopVehicleQualityArg
---@field type VehicleQualityDevelopType @培养类型

---@class DevelopVehicleQualityRes
---@field error_code ErrorCode @
---@field increment VehicleAttr @增量,正值为增加,负值为减少

---@class AddOrnamentDyeArg
---@field vehicle_id number @
---@field type VehicleOutlookType @配饰/染色
---@field id number @配饰/染色ID

---@class AddOrnamentDyeRes
---@field error_code ErrorCode @

---@class UseOrnamentDyeArg
---@field vehicle_id number @
---@field type VehicleOutlookType @配饰/染色
---@field id number @配饰/染色ID

---@class UseOrnamentDyeRes
---@field error_code ErrorCode @

---@class ConfirmVehicleQualityArg
---@field type VehicleQualityDevelopType @

---@class ConfirmVehicleQualityRes
---@field error_code ErrorCode @
---@field vehicle_attr VehicleAttr @确认后载具素质属性

---@class ExchangeSpecialVehicleArg
---@field item_id number @也即载具id

---@class ExchangeSpecialVehicleRes
---@field error_code ErrorCode @

---@class VehicleDevInfo
---@field entrys VehicleAttr @
---@field cache_entrys_junior VehicleAttr @
---@field cache_entrys_senior VehicleAttr @
---@field pro_quality_level number @职业载具素质等级
---@field pro_quality_break_times number @素质突破次数
---@field pro_quality_limit VehicleAttr @载具素质上限值
---@field junior_develop_times number @
---@field senior_develop_times number @

---@class VehicleOutlookUnit
---@field cur_equip number @
---@field own_list PBint32__Array @

---@class VehicleOutlook
---@field vehicle_id number @
---@field ornament VehicleOutlookUnit @配饰
---@field dye VehicleOutlookUnit @染色

---@class TempVehicleExpireTime
---@field vehicle_id number @
---@field expire_time number @

---@class KeyValue32
---@field key number @
---@field value number @

---@class ReappearErrorRoleNotFoundData
---@field session_id uint64 @

---@class AddTempVehicleData
---@field vehicle_id number @
---@field expire_time number @

---@class UpdateVehicleAttrsData
---@field ability VehicleAttr @能力
---@field quality VehicleAttr @素质
---@field quality_limit VehicleAttr @素质上限
---@field break_type VehicleQualityBreakType @如果有素质突破,此字段还表示类型

---@class SendRedEnvelopeG2MRes
---@field error_code ErrorCode @

---@class UpdateVehicleRecordForGMData
---@field vehicle_record VehicleRecord @

---@class NtfGuildHuntRewardData
---@field times number @

---@class GetTaskRecordArg

---@class GetTaskRecordRes
---@field result ErrorCode @
---@field task_triggers TaskTriggerAllNotifyData @
---@field task_record TaskRecord @

---@class RareGuildGiftData
---@field item_id number @
---@field count number @

---@class RoleVitalData
---@field vital_data VitalData__Array @

---@class VitalData
---@field type VitalDataType @
---@field mill_second uint64 @
---@field virtual_item VirtualItemData @虚拟物品

---@class CommondataPair
---@field commondata_key int64 @通用数据type<<32 | id
---@field commondata_value int64 @通用数据数值

---@class Commondata
---@field commondata_map CommondataPair__Array @通用数据map

---@class CommondataRepeated
---@field commondata_map CommondataPair__Array @通用数据map

---@class GuildMatchDungeonsRecord
---@field win_times number @
---@field lose_times number @
---@field draw_times number @

---@class FetchMirrorRoleDataRes
---@field equip_data Equips @所有装备数据
---@field fashion_record FashionRecord @时装外观
---@field guild_info RoleGuildInfo @公会信息
---@field result ErrorCode @
---@field name string @名字
---@field base_level number @等级
---@field role_type RoleType @职业
---@field sex SexType @性别

---@class FetchMirrorRoleDataArg
---@field roleid uint64 @获取对应玩家id的数据
---@field op_type number @公会镜像用(1新建/2删除/3更新)
---@field guild_id int64 @公会镜像用

---@class FashionEvaMirrorRoleData
---@field rank number @排名
---@field role_id uint64 @玩家id
---@field role_data FetchMirrorRoleDataRes @玩家数据

---@class RoleInfoOnFm
---@field account_id string @
---@field server_id number @
---@field role_id uint64 @
---@field role_name string @
---@field base_level number @
---@field job_level number @
---@field role_type RoleType @
---@field sex_type SexType @
---@field create_time uint64 @
---@field login_time uint64 @
---@field logout_time uint64 @
---@field vip_level number @
---@field charge_gold number @
---@field device_token string @
---@field open_system_id number__Array @

---@class ItemDataList
---@field item_data_list Ro_Item__Array @道具存储数据

---@class ItemDataList_0
---@field item_data_list ItemDataList @

---@class ItemDataList_1
---@field item_data_list ItemDataList @

---@class ItemDataList_2
---@field item_data_list ItemDataList @

---@class ItemDataList_3
---@field item_data_list ItemDataList @

---@class ItemDataList_4
---@field item_data_list ItemDataList @

---@class Commondata_0
---@field commondata_list Commondata @

---@class Commondata_1
---@field commondata_list Commondata @

---@class Commondata_2
---@field commondata_list Commondata @

---@class Commondata_3
---@field commondata_list Commondata @

---@class VitalCommondata
---@field commondata_list Commondata @

---@class ThemeStoryDungeonsRecord
---@field dungeon_list ThemeDungeonsInfo__Array @

---@class BlessExpNode
---@field base_exp int64 @
---@field job_exp int64 @
---@field calc_day number @计算日期
---@field exprire_day number @过期日期

---@class MonsterGroupInfo
---@field element_id number @元素ID
---@field group_id number @组ID
---@field research_sign uint64 @手动领取奖励标记[64位]

---@class MonsterSingleInfo
---@field monster_id number @怪物ID
---@field is_enable_drop boolean @是否启用掉落特权
---@field killed_num number @杀怪的数量
---@field kill_progress number @到达下一等级的杀怪进度
---@field next_level_num number @达到下一等级需要的杀怪数量
---@field research_sign uint64 @领取研究进度奖励标记
---@field award_sign uint64 @发放奖励标记

---@class MonsterResearchInfo
---@field research_sign string @手动领取奖励标记[128位0101字符]

---@class GetMonsterAwardArg
---@field op_type MonsterAwardType @1:单怪奖励,2:组怪物奖励,3:总进度奖励
---@field param1 number @对于1:怪物ID;对于2:元素类型;
---@field param2 number @对于2:组ID
---@field level number @想要领取的奖励的等级

---@class GetMonsterAwardRes
---@field error_code ErrorCode @
---@field research_sign uint64 @领取研究进度奖励标记[type为1/2时使用]
---@field award_sign uint64 @发放奖励标记[type为1时使用]
---@field total_research_sign string @总体研究进度[type为3时使用]

---@class UpdateMonsterKilledNumData
---@field monster_num MapInt32Int32__Array @怪物ID<--->数量

---@class UpdateTeamProfessionsData
---@field start_time uint64 @开始时间戳
---@field professions number__Array @

---@class ReveItemContainerPb
---@field type_common_list ReveItemPb__Array @
---@field type_bless_list ReveItemPb__Array @

---@class ReveItemPb
---@field monster_type number @
---@field item_list RevenueItemPbInfo__Array @

---@class RoFashionRecordPb
---@field own_fashion PBuint64__Array @拥有的时装
---@field wear_fashion_uid uint64 @穿着的时装
---@field own_ornament PBuint64__Array @衣橱中的饰品
---@field wear_ornament PBuint64__Array @穿着的饰品
---@field current_hair_id number @头发id
---@field eye_id number @眼睛id
---@field eye_style_id number @
---@field fashion_count number @时尚度
---@field fashion_count_history number @
---@field own_head_portrait PBuint64__Array @拥有的头像
---@field wear_head_portraut_uid uint64 @当前穿着的头像
---@field equip_ornament PBuint64__Array @装备页当中的饰品
---@field fashion_count_award RepeatPairIntInt @典藏值领奖
---@field own_hairs number__Array @解锁的发型
---@field own_eyes number__Array @解锁的美瞳
---@field portrait_frame number @头像框
---@field chat_frame number @气泡框
---@field fashion_level_history number @历史最高时尚等级
---@field fashion_level number @当前时尚等级

---@class ExchangeCDKeyArg
---@field cdk_value string @

---@class ExchangeCDKeyRes
---@field result ErrorCode @

---@class RoleDeadNtfData
---@field killer_uuid uint64 @
---@field killer_table_id number @
---@field killer_level number @
---@field killer_owner_uid uint64 @

---@class AwardsInfo
---@field reason ItemChangeReason @道具变动原因
---@field item_id number @道具id
---@field item_count number @道具数量

---@class BuyRebateCardArg
---@field RebateCardType number @购买的卡片类型，1是普通返利月卡，2是超级返利月卡。
---@field BuyType number @购买的类型：1购买月卡，2一次性领取所有月卡奖励

---@class BuyRebateCardRes
---@field error_code ErrorCode @错误码

---@class ChatTagRecord
---@field chat_frame number @聊天框
---@field cur_tag number @使用中的聊天标签id
---@field get_rank int64 @上次请求排行时间
---@field own_tags number__Array @拥有的聊天标签

---@class ExtraCardDropRecord
---@field extra_card_info ExtraCardInfoRecord__Array @
---@field last_fresh_fight_day_stamp int64 @上次刷新打卡天数时间,防止重复增加打卡天数

---@class ExtraCardInfoRecord
---@field card_type number @卡的类型
---@field random_fight_days number @随机出的打卡天数
---@field total_fight_days number @当前总共打卡天数
---@field random_monsters number @随机出的需要打怪数量
---@field total_monsters number @达到打卡天数后累计杀怪数量
---@field random_cd_days number @随机出的CD天数
---@field cd_timestamp int64 @进入CD时的时间戳

---@class WatchDungeonTeam
---@field team_name string @
---@field captain MemberBaseInfo @
---@field members WatchDungeonMember__Array @

---@class WatchUnitInfo
---@field room_uid number @
---@field dungeon_id number @
---@field create_time int64 @
---@field watch_times number @
---@field like_times number @
---@field life_time number @
---@field team WatchDungeonTeam__Array @
---@field sequence_uid number @

---@class WatchDungeonMember
---@field uid uint64 @
---@field type RoleType @
---@field is_hit_outlook boolean @

---@class GetWatchRoomListArgs
---@field spectator_type number @
---@field page number @
---@field is_refresh boolean @

---@class GetWatchRoomListRes
---@field rooms WatchUnitInfo__Array @
---@field result ErrorCode @

---@class LikeWatchRoomArgs
---@field room_uid number @

---@class LikeWatchRoomRes
---@field result ErrorCode @

---@class SearchWatchRoomArgs
---@field name string @

---@class SearchWatchRoomRes
---@field rooms WatchUnitInfo__Array @
---@field result ErrorCode @

---@class RequestWatchDungeonArgs
---@field seq_id number @

---@class RequestWatchDungeonRes
---@field result ErrorCode @

---@class WatchedRoleBoardInfo
---@field type RoleType @
---@field name string @
---@field avatar_info MemberBaseInfo @
---@field role_id uint64 @
---@field team_id int64 @
---@field brief WatchedRoleBrief @
---@field is_hit_outlook boolean @

---@class WatchRoomBoardInfo
---@field room_uid number @
---@field dungeon_id number @
---@field beliked_times number @
---@field spectators_num number @
---@field create_time int64 @
---@field role_infos WatchedRoleBoardInfo__Array @
---@field camp_flower CampFlower__Array @

---@class WatchedRoleBrief
---@field role_id uint64 @
---@field is_in_dungeon boolean @
---@field hp number @
---@field sp number @
---@field kill number @
---@field dead number @
---@field assist number @

---@class DungeonWatchBriefData
---@field role_infos WatchedRoleBrief__Array @
---@field camp1_score number @
---@field camp2_score number @
---@field camp1_id int64 @
---@field camp2_id int64 @

---@class UpdateRoomWatchInfoData
---@field beliked_times number @
---@field spectators_num number @
---@field camp_flower CampFlower__Array @
---@field round_id number @第0,1,2局
---@field fight_history FightHistory @

---@class WatchSwitchData
---@field switch_player_uuid uint64 @

---@class RoleWatchRecord
---@field total_watched_times number @
---@field total_liked_times number @
---@field total_bewatched_times number @
---@field total_beliked_times number @
---@field watched_history WatchUnitInfo__Array @
---@field most_bewatched_record WatchUnitInfo @
---@field most_beliked_record WatchUnitInfo @

---@class GetRoleWatchRecordRes
---@field record RoleWatchRecord @
---@field result ErrorCode @

---@class WatcherSwitchPlayerArg
---@field player_uuid uint64 @

---@class WatcherSwitchPlayerRes
---@field result ErrorCode @
---@field player_uuid uint64 @

---@class UpdateMsDungeonWatchInfo
---@field type UpdateWatchType @
---@field room WatchUnitInfo @
---@field room_uid number @
---@field belike_times number @
---@field bewatched_times number @
---@field role_uid uint64 @
---@field is_first_enter boolean @
---@field now_watcher_count number @
---@field guild_id int64 @
---@field flower_num number @

---@class GetWatchRoomInfoArgs
---@field owner_uid uint64 @
---@field seq_id number @

---@class GetWatchRoomInfoRes
---@field result ErrorCode @
---@field room WatchUnitInfo @

---@class MirrorRoleDeleteData
---@field role_id uint64 @
---@field origin_gs_line number @

---@class RequestWatchDungeonsToMsArgs
---@field delay_rpc number @
---@field seq_id number @

---@class CampFlower
---@field guild_id int64 @
---@field guild_name string @
---@field num number @

---@class SyncWeatherToGsArg
---@field weather_data AllSceneWeather @
---@field line number @

---@class SyncWeatherToGsRes
---@field result ErrorCode @

---@class HourWeatherData
---@field hour number @
---@field weather WeatherType @
---@field temperature number @

---@class SceneWeather
---@field scene_id number @
---@field weathers HourWeatherData__Array @

---@class GMWeatherData
---@field scene_id number @
---@field weather WeatherType @
---@field temperature number @
---@field time_part number @

---@class SyncGMWeatherData
---@field weathers GMWeatherData__Array @

---@class GetWeatherArg

---@class GetWeatherRes
---@field result ErrorCode @
---@field weather_data AllSceneWeather @

---@class AllSceneWeather
---@field weathers SceneWeather__Array @

---@class SyncWeatherEventArg
---@field hour number @
---@field weather_events WeatherEventData__Array @
---@field line number @

---@class SyncWeatherEventRes
---@field result ErrorCode @
---@field line number @

---@class WeatherEventData
---@field scene_id number @
---@field is_weather_changed boolean @
---@field before_weather number @
---@field after_weather number @
---@field is_temperature_changed boolean @
---@field before_temperature number @
---@field after_temperature number @

---@class WorldEventDB
---@field worldeventid number @事件id
---@field event_level number @事件难度
---@field sceneid number @刷出事件的场景
---@field x number @刷出事件的动态坐标
---@field y number @刷出事件的动态坐标
---@field z number @刷出事件的动态坐标
---@field r number @刷出事件的动态坐标 半径
---@field father_task_id number @父任务id
---@field eventtype number @事件展示类型, npc还是触发器
---@field eventobjid number @要刷新的对象id
---@field end_time uint64 @本次事件截止时间
---@field point_index number @

---@class AllWorldEventDB
---@field all_events WorldEventDB__Array @

---@class WorldEventNtf
---@field is_add_event boolean @是否新增事件,true:新增,false:删除
---@field allworldeventdb AllWorldEventDB @

---@class SaveWorldPveEventNtf
---@field key string @master的一个key
---@field worldpve AllWorldEventDB @
---@field mtime uint64 @

---@class DelEventData
---@field event_id number__Array @

---@class Achievement__Array_
local Achievement__Array_ =  {}
---@return Achievement
function Achievement__Array_:add()end
---@alias Achievement__Array Achievement__Array_ | Achievement[]

---@class PBuint32__Array_
local PBuint32__Array_ =  {}
---@return PBuint32
function PBuint32__Array_:add()end
---@alias PBuint32__Array PBuint32__Array_ | PBuint32[]

---@class number__Array_
local number__Array_ =  {}
---@return number
function number__Array_:add()end
---@alias number__Array number__Array_ | number[]

---@class int64__Array_
local int64__Array_ =  {}
---@return int64
function int64__Array_:add()end
---@alias int64__Array int64__Array_ | int64[]

---@class PBdouble__Array_
local PBdouble__Array_ =  {}
---@return PBdouble
function PBdouble__Array_:add()end
---@alias PBdouble__Array PBdouble__Array_ | PBdouble[]

---@class DailyActivityData__Array_
local DailyActivityData__Array_ =  {}
---@return DailyActivityData
function DailyActivityData__Array_:add()end
---@alias DailyActivityData__Array DailyActivityData__Array_ | DailyActivityData[]

---@class PBint32__Array_
local PBint32__Array_ =  {}
---@return PBint32
function PBint32__Array_:add()end
---@alias PBint32__Array PBint32__Array_ | PBint32[]

---@class BlessMonsterData__Array_
local BlessMonsterData__Array_ =  {}
---@return BlessMonsterData
function BlessMonsterData__Array_:add()end
---@alias BlessMonsterData__Array BlessMonsterData__Array_ | BlessMonsterData[]

---@class CatTradeTrainInfo__Array_
local CatTradeTrainInfo__Array_ =  {}
---@return CatTradeTrainInfo
function CatTradeTrainInfo__Array_:add()end
---@alias CatTradeTrainInfo__Array CatTradeTrainInfo__Array_ | CatTradeTrainInfo[]

---@class CatTradeTrainSeatInfo__Array_
local CatTradeTrainSeatInfo__Array_ =  {}
---@return CatTradeTrainSeatInfo
function CatTradeTrainSeatInfo__Array_:add()end
---@alias CatTradeTrainSeatInfo__Array CatTradeTrainSeatInfo__Array_ | CatTradeTrainSeatInfo[]

---@class PBuint64__Array_
local PBuint64__Array_ =  {}
---@return PBuint64
function PBuint64__Array_:add()end
---@alias PBuint64__Array PBuint64__Array_ | PBuint64[]

---@class DelegateData__Array_
local DelegateData__Array_ =  {}
---@return DelegateData
function DelegateData__Array_:add()end
---@alias DelegateData__Array DelegateData__Array_ | DelegateData[]

---@class MapInt32Int32__Array_
local MapInt32Int32__Array_ =  {}
---@return MapInt32Int32
function MapInt32Int32__Array_:add()end
---@alias MapInt32Int32__Array MapInt32Int32__Array_ | MapInt32Int32[]

---@class PairIntInt__Array_
local PairIntInt__Array_ =  {}
---@return PairIntInt
function PairIntInt__Array_:add()end
---@alias PairIntInt__Array PairIntInt__Array_ | PairIntInt[]

---@class BackstageActScoreLimitNode__Array_
local BackstageActScoreLimitNode__Array_ =  {}
---@return BackstageActScoreLimitNode
function BackstageActScoreLimitNode__Array_:add()end
---@alias BackstageActScoreLimitNode__Array BackstageActScoreLimitNode__Array_ | BackstageActScoreLimitNode[]

---@class BackstageAct2ClientNode__Array_
local BackstageAct2ClientNode__Array_ =  {}
---@return BackstageAct2ClientNode
function BackstageAct2ClientNode__Array_:add()end
---@alias BackstageAct2ClientNode__Array BackstageAct2ClientNode__Array_ | BackstageAct2ClientNode[]

---@class BackstageActFatherData__Array_
local BackstageActFatherData__Array_ =  {}
---@return BackstageActFatherData
function BackstageActFatherData__Array_:add()end
---@alias BackstageActFatherData__Array BackstageActFatherData__Array_ | BackstageActFatherData[]

---@class PairInt64Int64__Array_
local PairInt64Int64__Array_ =  {}
---@return PairInt64Int64
function PairInt64Int64__Array_:add()end
---@alias PairInt64Int64__Array PairInt64Int64__Array_ | PairInt64Int64[]

---@class BackstageActGSData__Array_
local BackstageActGSData__Array_ =  {}
---@return BackstageActGSData
function BackstageActGSData__Array_:add()end
---@alias BackstageActGSData__Array BackstageActGSData__Array_ | BackstageActGSData[]

---@class BackstageAct2GSFatherNode__Array_
local BackstageAct2GSFatherNode__Array_ =  {}
---@return BackstageAct2GSFatherNode
function BackstageAct2GSFatherNode__Array_:add()end
---@alias BackstageAct2GSFatherNode__Array BackstageAct2GSFatherNode__Array_ | BackstageAct2GSFatherNode[]

---@class SupplyItemInfo__Array_
local SupplyItemInfo__Array_ =  {}
---@return SupplyItemInfo
function SupplyItemInfo__Array_:add()end
---@alias SupplyItemInfo__Array SupplyItemInfo__Array_ | SupplyItemInfo[]

---@class ActivityTimeInfo__Array_
local ActivityTimeInfo__Array_ =  {}
---@return ActivityTimeInfo
function ActivityTimeInfo__Array_:add()end
---@alias ActivityTimeInfo__Array ActivityTimeInfo__Array_ | ActivityTimeInfo[]

---@class AuctionBillBrief__Array_
local AuctionBillBrief__Array_ =  {}
---@return AuctionBillBrief
function AuctionBillBrief__Array_:add()end
---@alias AuctionBillBrief__Array AuctionBillBrief__Array_ | AuctionBillBrief[]

---@class AuctionItemPbInfo__Array_
local AuctionItemPbInfo__Array_ =  {}
---@return AuctionItemPbInfo
function AuctionItemPbInfo__Array_:add()end
---@alias AuctionItemPbInfo__Array AuctionItemPbInfo__Array_ | AuctionItemPbInfo[]

---@class AuctionBillInfo__Array_
local AuctionBillInfo__Array_ =  {}
---@return AuctionBillInfo
function AuctionBillInfo__Array_:add()end
---@alias AuctionBillInfo__Array AuctionBillInfo__Array_ | AuctionBillInfo[]

---@class AuctionItemDBInfo__Array_
local AuctionItemDBInfo__Array_ =  {}
---@return AuctionItemDBInfo
function AuctionItemDBInfo__Array_:add()end
---@alias AuctionItemDBInfo__Array AuctionItemDBInfo__Array_ | AuctionItemDBInfo[]

---@class AuctionItemBrief__Array_
local AuctionItemBrief__Array_ =  {}
---@return AuctionItemBrief
function AuctionItemBrief__Array_:add()end
---@alias AuctionItemBrief__Array AuctionItemBrief__Array_ | AuctionItemBrief[]

---@class RoleAuctionItemFinishedPb__Array_
local RoleAuctionItemFinishedPb__Array_ =  {}
---@return RoleAuctionItemFinishedPb
function RoleAuctionItemFinishedPb__Array_:add()end
---@alias RoleAuctionItemFinishedPb__Array RoleAuctionItemFinishedPb__Array_ | RoleAuctionItemFinishedPb[]

---@class RoleDepositInfo__Array_
local RoleDepositInfo__Array_ =  {}
---@return RoleDepositInfo
function RoleDepositInfo__Array_:add()end
---@alias RoleDepositInfo__Array RoleDepositInfo__Array_ | RoleDepositInfo[]

---@class SelfServerData__Array_
local SelfServerData__Array_ =  {}
---@return SelfServerData
function SelfServerData__Array_:add()end
---@alias SelfServerData__Array SelfServerData__Array_ | SelfServerData[]

---@class LoginGateData__Array_
local LoginGateData__Array_ =  {}
---@return LoginGateData
function LoginGateData__Array_:add()end
---@alias LoginGateData__Array LoginGateData__Array_ | LoginGateData[]

---@class RevenueItemPbInfo__Array_
local RevenueItemPbInfo__Array_ =  {}
---@return RevenueItemPbInfo
function RevenueItemPbInfo__Array_:add()end
---@alias RevenueItemPbInfo__Array RevenueItemPbInfo__Array_ | RevenueItemPbInfo[]

---@class InfluenceGroup__Array_
local InfluenceGroup__Array_ =  {}
---@return InfluenceGroup
function InfluenceGroup__Array_:add()end
---@alias InfluenceGroup__Array InfluenceGroup__Array_ | InfluenceGroup[]

---@class MSInfluence__Array_
local MSInfluence__Array_ =  {}
---@return MSInfluence
function MSInfluence__Array_:add()end
---@alias MSInfluence__Array MSInfluence__Array_ | MSInfluence[]

---@class SceneInfluenceEvt__Array_
local SceneInfluenceEvt__Array_ =  {}
---@return SceneInfluenceEvt
function SceneInfluenceEvt__Array_:add()end
---@alias SceneInfluenceEvt__Array SceneInfluenceEvt__Array_ | SceneInfluenceEvt[]

---@class Item__Array_
local Item__Array_ =  {}
---@return Item
function Item__Array_:add()end
---@alias Item__Array Item__Array_ | Item[]

---@class AnnounceMsg__Array_
local AnnounceMsg__Array_ =  {}
---@return AnnounceMsg
function AnnounceMsg__Array_:add()end
---@alias AnnounceMsg__Array AnnounceMsg__Array_ | AnnounceMsg[]

---@class ExtraParam__Array_
local ExtraParam__Array_ =  {}
---@return ExtraParam
function ExtraParam__Array_:add()end
---@alias ExtraParam__Array ExtraParam__Array_ | ExtraParam[]

---@class PrivateDetailChatInfo__Array_
local PrivateDetailChatInfo__Array_ =  {}
---@return PrivateDetailChatInfo
function PrivateDetailChatInfo__Array_:add()end
---@alias PrivateDetailChatInfo__Array PrivateDetailChatInfo__Array_ | PrivateDetailChatInfo[]

---@class UnReadMessageCountInfo__Array_
local UnReadMessageCountInfo__Array_ =  {}
---@return UnReadMessageCountInfo
function UnReadMessageCountInfo__Array_:add()end
---@alias UnReadMessageCountInfo__Array UnReadMessageCountInfo__Array_ | UnReadMessageCountInfo[]

---@class uint64__Array_
local uint64__Array_ =  {}
---@return uint64
function uint64__Array_:add()end
---@alias uint64__Array uint64__Array_ | uint64[]

---@class ObjectMessagePbInfo__Array_
local ObjectMessagePbInfo__Array_ =  {}
---@return ObjectMessagePbInfo
function ObjectMessagePbInfo__Array_:add()end
---@alias ObjectMessagePbInfo__Array ObjectMessagePbInfo__Array_ | ObjectMessagePbInfo[]

---@class ChatMsg__Array_
local ChatMsg__Array_ =  {}
---@return ChatMsg
function ChatMsg__Array_:add()end
---@alias ChatMsg__Array ChatMsg__Array_ | ChatMsg[]

---@class ChatRecord__Array_
local ChatRecord__Array_ =  {}
---@return ChatRecord
function ChatRecord__Array_:add()end
---@alias ChatRecord__Array ChatRecord__Array_ | ChatRecord[]

---@class PBint64__Array_
local PBint64__Array_ =  {}
---@return PBint64
function PBint64__Array_:add()end
---@alias PBint64__Array PBint64__Array_ | PBint64[]

---@class TalkCDOffset__Array_
local TalkCDOffset__Array_ =  {}
---@return TalkCDOffset
function TalkCDOffset__Array_:add()end
---@alias TalkCDOffset__Array TalkCDOffset__Array_ | TalkCDOffset[]

---@class TalkForbid__Array_
local TalkForbid__Array_ =  {}
---@return TalkForbid
function TalkForbid__Array_:add()end
---@alias TalkForbid__Array TalkForbid__Array_ | TalkForbid[]

---@class TalkForbidList__Array_
local TalkForbidList__Array_ =  {}
---@return TalkForbidList
function TalkForbidList__Array_:add()end
---@alias TalkForbidList__Array TalkForbidList__Array_ | TalkForbidList[]

---@class ChatCD__Array_
local ChatCD__Array_ =  {}
---@return ChatCD
function ChatCD__Array_:add()end
---@alias ChatCD__Array ChatCD__Array_ | ChatCD[]

---@class CheckText__Array_
local CheckText__Array_ =  {}
---@return CheckText
function CheckText__Array_:add()end
---@alias CheckText__Array CheckText__Array_ | CheckText[]

---@class MemberBaseInfo__Array_
local MemberBaseInfo__Array_ =  {}
---@return MemberBaseInfo
function MemberBaseInfo__Array_:add()end
---@alias MemberBaseInfo__Array MemberBaseInfo__Array_ | MemberBaseInfo[]

---@class RedPoint__Array_
local RedPoint__Array_ =  {}
---@return RedPoint
function RedPoint__Array_:add()end
---@alias RedPoint__Array RedPoint__Array_ | RedPoint[]

---@class string__Array_
local string__Array_ =  {}
---@return string
function string__Array_:add()end
---@alias string__Array string__Array_ | string[]

---@class CommonMultiParam__Array_
local CommonMultiParam__Array_ =  {}
---@return CommonMultiParam
function CommonMultiParam__Array_:add()end
---@alias CommonMultiParam__Array CommonMultiParam__Array_ | CommonMultiParam[]

---@class LocalizationName__Array_
local LocalizationName__Array_ =  {}
---@return LocalizationName
function LocalizationName__Array_:add()end
---@alias LocalizationName__Array LocalizationName__Array_ | LocalizationName[]

---@class TableHashData__Array_
local TableHashData__Array_ =  {}
---@return TableHashData
function TableHashData__Array_:add()end
---@alias TableHashData__Array TableHashData__Array_ | TableHashData[]

---@class TlogCloseInfo__Array_
local TlogCloseInfo__Array_ =  {}
---@return TlogCloseInfo
function TlogCloseInfo__Array_:add()end
---@alias TlogCloseInfo__Array TlogCloseInfo__Array_ | TlogCloseInfo[]

---@class TimeGiftInfo__Array_
local TimeGiftInfo__Array_ =  {}
---@return TimeGiftInfo
function TimeGiftInfo__Array_:add()end
---@alias TimeGiftInfo__Array TimeGiftInfo__Array_ | TimeGiftInfo[]

---@class CountItemInfo__Array_
local CountItemInfo__Array_ =  {}
---@return CountItemInfo
function CountItemInfo__Array_:add()end
---@alias CountItemInfo__Array CountItemInfo__Array_ | CountItemInfo[]

---@class CountItemAllInfo__Array_
local CountItemAllInfo__Array_ =  {}
---@return CountItemAllInfo
function CountItemAllInfo__Array_:add()end
---@alias CountItemAllInfo__Array CountItemAllInfo__Array_ | CountItemAllInfo[]

---@class DungeonsAttrData__Array_
local DungeonsAttrData__Array_ =  {}
---@return DungeonsAttrData
function DungeonsAttrData__Array_:add()end
---@alias DungeonsAttrData__Array DungeonsAttrData__Array_ | DungeonsAttrData[]

---@class CookResultData__Array_
local CookResultData__Array_ =  {}
---@return CookResultData
function CookResultData__Array_:add()end
---@alias CookResultData__Array CookResultData__Array_ | CookResultData[]

---@class CounterIntPair__Array_
local CounterIntPair__Array_ =  {}
---@return CounterIntPair
function CounterIntPair__Array_:add()end
---@alias CounterIntPair__Array CounterIntPair__Array_ | CounterIntPair[]

---@class AwardsInfo__Array_
local AwardsInfo__Array_ =  {}
---@return AwardsInfo
function AwardsInfo__Array_:add()end
---@alias AwardsInfo__Array AwardsInfo__Array_ | AwardsInfo[]

---@class Order__Array_
local Order__Array_ =  {}
---@return Order
function Order__Array_:add()end
---@alias Order__Array Order__Array_ | Order[]

---@class BattlefieldTeamInfo__Array_
local BattlefieldTeamInfo__Array_ =  {}
---@return BattlefieldTeamInfo
function BattlefieldTeamInfo__Array_:add()end
---@alias BattlefieldTeamInfo__Array BattlefieldTeamInfo__Array_ | BattlefieldTeamInfo[]

---@class BattlefieldTeam__Array_
local BattlefieldTeam__Array_ =  {}
---@return BattlefieldTeam
function BattlefieldTeam__Array_:add()end
---@alias BattlefieldTeam__Array BattlefieldTeam__Array_ | BattlefieldTeam[]

---@class BattlefieldTeamInfoInScene__Array_
local BattlefieldTeamInfoInScene__Array_ =  {}
---@return BattlefieldTeamInfoInScene
function BattlefieldTeamInfoInScene__Array_:add()end
---@alias BattlefieldTeamInfoInScene__Array BattlefieldTeamInfoInScene__Array_ | BattlefieldTeamInfoInScene[]

---@class SeedPair__Array_
local SeedPair__Array_ =  {}
---@return SeedPair
function SeedPair__Array_:add()end
---@alias SeedPair__Array SeedPair__Array_ | SeedPair[]

---@class PerDungeonMonsterData__Array_
local PerDungeonMonsterData__Array_ =  {}
---@return PerDungeonMonsterData
function PerDungeonMonsterData__Array_:add()end
---@alias PerDungeonMonsterData__Array PerDungeonMonsterData__Array_ | PerDungeonMonsterData[]

---@class SummonInfo__Array_
local SummonInfo__Array_ =  {}
---@return SummonInfo
function SummonInfo__Array_:add()end
---@alias SummonInfo__Array SummonInfo__Array_ | SummonInfo[]

---@class CommandSpellCD__Array_
local CommandSpellCD__Array_ =  {}
---@return CommandSpellCD
function CommandSpellCD__Array_:add()end
---@alias CommandSpellCD__Array CommandSpellCD__Array_ | CommandSpellCD[]

---@class ServantInfo__Array_
local ServantInfo__Array_ =  {}
---@return ServantInfo
function ServantInfo__Array_:add()end
---@alias ServantInfo__Array ServantInfo__Array_ | ServantInfo[]

---@class ThemeDungonResult__Array_
local ThemeDungonResult__Array_ =  {}
---@return ThemeDungonResult
function ThemeDungonResult__Array_:add()end
---@alias ThemeDungonResult__Array ThemeDungonResult__Array_ | ThemeDungonResult[]

---@class DungeonAffixData__Array_
local DungeonAffixData__Array_ =  {}
---@return DungeonAffixData
function DungeonAffixData__Array_:add()end
---@alias DungeonAffixData__Array DungeonAffixData__Array_ | DungeonAffixData[]

---@class RolesBattleInfo__Array_
local RolesBattleInfo__Array_ =  {}
---@return RolesBattleInfo
function RolesBattleInfo__Array_:add()end
---@alias RolesBattleInfo__Array RolesBattleInfo__Array_ | RolesBattleInfo[]

---@class FriendInfo__Array_
local FriendInfo__Array_ =  {}
---@return FriendInfo
function FriendInfo__Array_:add()end
---@alias FriendInfo__Array FriendInfo__Array_ | FriendInfo[]

---@class FriendDegreeStatistic__Array_
local FriendDegreeStatistic__Array_ =  {}
---@return FriendDegreeStatistic
function FriendDegreeStatistic__Array_:add()end
---@alias FriendDegreeStatistic__Array FriendDegreeStatistic__Array_ | FriendDegreeStatistic[]

---@class FriendPbInfo__Array_
local FriendPbInfo__Array_ =  {}
---@return FriendPbInfo
function FriendPbInfo__Array_:add()end
---@alias FriendPbInfo__Array FriendPbInfo__Array_ | FriendPbInfo[]

---@class GsFriendInfo__Array_
local GsFriendInfo__Array_ =  {}
---@return GsFriendInfo
function GsFriendInfo__Array_:add()end
---@alias GsFriendInfo__Array GsFriendInfo__Array_ | GsFriendInfo[]

---@class FriendDegreeUid__Array_
local FriendDegreeUid__Array_ =  {}
---@return FriendDegreeUid
function FriendDegreeUid__Array_:add()end
---@alias FriendDegreeUid__Array FriendDegreeUid__Array_ | FriendDegreeUid[]

---@class MapKeyValue__Array_
local MapKeyValue__Array_ =  {}
---@return MapKeyValue
function MapKeyValue__Array_:add()end
---@alias MapKeyValue__Array MapKeyValue__Array_ | MapKeyValue[]

---@class RoleBattleBriefInfo__Array_
local RoleBattleBriefInfo__Array_ =  {}
---@return RoleBattleBriefInfo
function RoleBattleBriefInfo__Array_:add()end
---@alias RoleBattleBriefInfo__Array RoleBattleBriefInfo__Array_ | RoleBattleBriefInfo[]

---@class DynamicDisplayNPCInfo__Array_
local DynamicDisplayNPCInfo__Array_ =  {}
---@return DynamicDisplayNPCInfo
function DynamicDisplayNPCInfo__Array_:add()end
---@alias DynamicDisplayNPCInfo__Array DynamicDisplayNPCInfo__Array_ | DynamicDisplayNPCInfo[]

---@class RandomWaveData__Array_
local RandomWaveData__Array_ =  {}
---@return RandomWaveData
function RandomWaveData__Array_:add()end
---@alias RandomWaveData__Array RandomWaveData__Array_ | RandomWaveData[]

---@class SkillInfo__Array_
local SkillInfo__Array_ =  {}
---@return SkillInfo
function SkillInfo__Array_:add()end
---@alias SkillInfo__Array SkillInfo__Array_ | SkillInfo[]

---@class AttrInfo__Array_
local AttrInfo__Array_ =  {}
---@return AttrInfo
function AttrInfo__Array_:add()end
---@alias AttrInfo__Array AttrInfo__Array_ | AttrInfo[]

---@class SkillStartInfo__Array_
local SkillStartInfo__Array_ =  {}
---@return SkillStartInfo
function SkillStartInfo__Array_:add()end
---@alias SkillStartInfo__Array SkillStartInfo__Array_ | SkillStartInfo[]

---@class SyncSkillInfo__Array_
local SyncSkillInfo__Array_ =  {}
---@return SyncSkillInfo
function SyncSkillInfo__Array_:add()end
---@alias SyncSkillInfo__Array SyncSkillInfo__Array_ | SyncSkillInfo[]

---@class MemberBriefInfo__Array_
local MemberBriefInfo__Array_ =  {}
---@return MemberBriefInfo
function MemberBriefInfo__Array_:add()end
---@alias MemberBriefInfo__Array MemberBriefInfo__Array_ | MemberBriefInfo[]

---@class TeamMercenaryBriefInfo__Array_
local TeamMercenaryBriefInfo__Array_ =  {}
---@return TeamMercenaryBriefInfo
function TeamMercenaryBriefInfo__Array_:add()end
---@alias TeamMercenaryBriefInfo__Array TeamMercenaryBriefInfo__Array_ | TeamMercenaryBriefInfo[]

---@class SkillDataInfo__Array_
local SkillDataInfo__Array_ =  {}
---@return SkillDataInfo
function SkillDataInfo__Array_:add()end
---@alias SkillDataInfo__Array SkillDataInfo__Array_ | SkillDataInfo[]

---@class ReplacerInfo__Array_
local ReplacerInfo__Array_ =  {}
---@return ReplacerInfo
function ReplacerInfo__Array_:add()end
---@alias ReplacerInfo__Array ReplacerInfo__Array_ | ReplacerInfo[]

---@class QteSkillSyncInfo__Array_
local QteSkillSyncInfo__Array_ =  {}
---@return QteSkillSyncInfo
function QteSkillSyncInfo__Array_:add()end
---@alias QteSkillSyncInfo__Array QteSkillSyncInfo__Array_ | QteSkillSyncInfo[]

---@class RORoleBuffEffect__Array_
local RORoleBuffEffect__Array_ =  {}
---@return RORoleBuffEffect
function RORoleBuffEffect__Array_:add()end
---@alias RORoleBuffEffect__Array RORoleBuffEffect__Array_ | RORoleBuffEffect[]

---@class RORoleBuff__Array_
local RORoleBuff__Array_ =  {}
---@return RORoleBuff
function RORoleBuff__Array_:add()end
---@alias RORoleBuff__Array RORoleBuff__Array_ | RORoleBuff[]

---@class MapUint32ToUint64__Array_
local MapUint32ToUint64__Array_ =  {}
---@return MapUint32ToUint64
function MapUint32ToUint64__Array_:add()end
---@alias MapUint32ToUint64__Array MapUint32ToUint64__Array_ | MapUint32ToUint64[]

---@class AttrBlock__Array_
local AttrBlock__Array_ =  {}
---@return AttrBlock
function AttrBlock__Array_:add()end
---@alias AttrBlock__Array AttrBlock__Array_ | AttrBlock[]

---@class HoleAndCardBlock__Array_
local HoleAndCardBlock__Array_ =  {}
---@return HoleAndCardBlock
function HoleAndCardBlock__Array_:add()end
---@alias HoleAndCardBlock__Array HoleAndCardBlock__Array_ | HoleAndCardBlock[]

---@class MapInt32ListMap32__Array_
local MapInt32ListMap32__Array_ =  {}
---@return MapInt32ListMap32
function MapInt32ListMap32__Array_:add()end
---@alias MapInt32ListMap32__Array MapInt32ListMap32__Array_ | MapInt32ListMap32[]

---@class ItemCostInfo__Array_
local ItemCostInfo__Array_ =  {}
---@return ItemCostInfo
function ItemCostInfo__Array_:add()end
---@alias ItemCostInfo__Array ItemCostInfo__Array_ | ItemCostInfo[]

---@class EnchantEntryBlock__Array_
local EnchantEntryBlock__Array_ =  {}
---@return EnchantEntryBlock
function EnchantEntryBlock__Array_:add()end
---@alias EnchantEntryBlock__Array EnchantEntryBlock__Array_ | EnchantEntryBlock[]

---@class ROBuffExtraParam__Array_
local ROBuffExtraParam__Array_ =  {}
---@return ROBuffExtraParam
function ROBuffExtraParam__Array_:add()end
---@alias ROBuffExtraParam__Array ROBuffExtraParam__Array_ | ROBuffExtraParam[]

---@class ROBuffInfo__Array_
local ROBuffInfo__Array_ =  {}
---@return ROBuffInfo
function ROBuffInfo__Array_:add()end
---@alias ROBuffInfo__Array ROBuffInfo__Array_ | ROBuffInfo[]

---@class TeamBriefInfo__Array_
local TeamBriefInfo__Array_ =  {}
---@return TeamBriefInfo
function TeamBriefInfo__Array_:add()end
---@alias TeamBriefInfo__Array TeamBriefInfo__Array_ | TeamBriefInfo[]

---@class SceneWeatherData__Array_
local SceneWeatherData__Array_ =  {}
---@return SceneWeatherData
function SceneWeatherData__Array_:add()end
---@alias SceneWeatherData__Array SceneWeatherData__Array_ | SceneWeatherData[]

---@class BlessingMonsterList__Array_
local BlessingMonsterList__Array_ =  {}
---@return BlessingMonsterList
function BlessingMonsterList__Array_:add()end
---@alias BlessingMonsterList__Array BlessingMonsterList__Array_ | BlessingMonsterList[]

---@class GuildBuildInfo__Array_
local GuildBuildInfo__Array_ =  {}
---@return GuildBuildInfo
function GuildBuildInfo__Array_:add()end
---@alias GuildBuildInfo__Array GuildBuildInfo__Array_ | GuildBuildInfo[]

---@class Entry__Array_
local Entry__Array_ =  {}
---@return Entry
function Entry__Array_:add()end
---@alias Entry__Array Entry__Array_ | Entry[]

---@class ScenePartFightGroup__Array_
local ScenePartFightGroup__Array_ =  {}
---@return ScenePartFightGroup
function ScenePartFightGroup__Array_:add()end
---@alias ScenePartFightGroup__Array ScenePartFightGroup__Array_ | ScenePartFightGroup[]

---@class boolean__Array_
local boolean__Array_ =  {}
---@return boolean
function boolean__Array_:add()end
---@alias boolean__Array boolean__Array_ | boolean[]

---@class MapUint64ToInt32__Array_
local MapUint64ToInt32__Array_ =  {}
---@return MapUint64ToInt32
function MapUint64ToInt32__Array_:add()end
---@alias MapUint64ToInt32__Array MapUint64ToInt32__Array_ | MapUint64ToInt32[]

---@class GameRoleSkillInfo__Array_
local GameRoleSkillInfo__Array_ =  {}
---@return GameRoleSkillInfo
function GameRoleSkillInfo__Array_:add()end
---@alias GameRoleSkillInfo__Array GameRoleSkillInfo__Array_ | GameRoleSkillInfo[]

---@class GameRoleSkillGroupInfo__Array_
local GameRoleSkillGroupInfo__Array_ =  {}
---@return GameRoleSkillGroupInfo
function GameRoleSkillGroupInfo__Array_:add()end
---@alias GameRoleSkillGroupInfo__Array GameRoleSkillGroupInfo__Array_ | GameRoleSkillGroupInfo[]

---@class PVPCounter__Array_
local PVPCounter__Array_ =  {}
---@return PVPCounter
function PVPCounter__Array_:add()end
---@alias PVPCounter__Array PVPCounter__Array_ | PVPCounter[]

---@class DistortedLightData__Array_
local DistortedLightData__Array_ =  {}
---@return DistortedLightData
function DistortedLightData__Array_:add()end
---@alias DistortedLightData__Array DistortedLightData__Array_ | DistortedLightData[]

---@class AutoFishResultInfo__Array_
local AutoFishResultInfo__Array_ =  {}
---@return AutoFishResultInfo
function AutoFishResultInfo__Array_:add()end
---@alias AutoFishResultInfo__Array AutoFishResultInfo__Array_ | AutoFishResultInfo[]

---@class MapInt32String__Array_
local MapInt32String__Array_ =  {}
---@return MapInt32String
function MapInt32String__Array_:add()end
---@alias MapInt32String__Array MapInt32String__Array_ | MapInt32String[]

---@class BigWorldActivity__Array_
local BigWorldActivity__Array_ =  {}
---@return BigWorldActivity
function BigWorldActivity__Array_:add()end
---@alias BigWorldActivity__Array BigWorldActivity__Array_ | BigWorldActivity[]

---@class MazeSyncData__Array_
local MazeSyncData__Array_ =  {}
---@return MazeSyncData
function MazeSyncData__Array_:add()end
---@alias MazeSyncData__Array MazeSyncData__Array_ | MazeSyncData[]

---@class SceneDeliverInfo__Array_
local SceneDeliverInfo__Array_ =  {}
---@return SceneDeliverInfo
function SceneDeliverInfo__Array_:add()end
---@alias SceneDeliverInfo__Array SceneDeliverInfo__Array_ | SceneDeliverInfo[]

---@class BoliInfo__Array_
local BoliInfo__Array_ =  {}
---@return BoliInfo
function BoliInfo__Array_:add()end
---@alias BoliInfo__Array BoliInfo__Array_ | BoliInfo[]

---@class BoliAwardIdCountInfo__Array_
local BoliAwardIdCountInfo__Array_ =  {}
---@return BoliAwardIdCountInfo
function BoliAwardIdCountInfo__Array_:add()end
---@alias BoliAwardIdCountInfo__Array BoliAwardIdCountInfo__Array_ | BoliAwardIdCountInfo[]

---@class SingleScriptEnum__Array_
local SingleScriptEnum__Array_ =  {}
---@return SingleScriptEnum
function SingleScriptEnum__Array_:add()end
---@alias SingleScriptEnum__Array SingleScriptEnum__Array_ | SingleScriptEnum[]

---@class DungeonsTargetData__Array_
local DungeonsTargetData__Array_ =  {}
---@return DungeonsTargetData
function DungeonsTargetData__Array_:add()end
---@alias DungeonsTargetData__Array DungeonsTargetData__Array_ | DungeonsTargetData[]

---@class MercenaryInfo__Array_
local MercenaryInfo__Array_ =  {}
---@return MercenaryInfo
function MercenaryInfo__Array_:add()end
---@alias MercenaryInfo__Array MercenaryInfo__Array_ | MercenaryInfo[]

---@class MercenaryEquipSingle__Array_
local MercenaryEquipSingle__Array_ =  {}
---@return MercenaryEquipSingle
function MercenaryEquipSingle__Array_:add()end
---@alias MercenaryEquipSingle__Array MercenaryEquipSingle__Array_ | MercenaryEquipSingle[]

---@class MercenarySkillSingle__Array_
local MercenarySkillSingle__Array_ =  {}
---@return MercenarySkillSingle
function MercenarySkillSingle__Array_:add()end
---@alias MercenarySkillSingle__Array MercenarySkillSingle__Array_ | MercenarySkillSingle[]

---@class MercenaryTalentSingle__Array_
local MercenaryTalentSingle__Array_ =  {}
---@return MercenaryTalentSingle
function MercenaryTalentSingle__Array_:add()end
---@alias MercenaryTalentSingle__Array MercenaryTalentSingle__Array_ | MercenaryTalentSingle[]

---@class MercenaryAttrInfo__Array_
local MercenaryAttrInfo__Array_ =  {}
---@return MercenaryAttrInfo
function MercenaryAttrInfo__Array_:add()end
---@alias MercenaryAttrInfo__Array MercenaryAttrInfo__Array_ | MercenaryAttrInfo[]

---@class GuildBriefInfo__Array_
local GuildBriefInfo__Array_ =  {}
---@return GuildBriefInfo
function GuildBriefInfo__Array_:add()end
---@alias GuildBriefInfo__Array GuildBriefInfo__Array_ | GuildBriefInfo[]

---@class PVPResult__Array_
local PVPResult__Array_ =  {}
---@return PVPResult
function PVPResult__Array_:add()end
---@alias PVPResult__Array PVPResult__Array_ | PVPResult[]

---@class Ro_Item_Attr_List__Array_
local Ro_Item_Attr_List__Array_ =  {}
---@return Ro_Item_Attr_List
function Ro_Item_Attr_List__Array_:add()end
---@alias Ro_Item_Attr_List__Array Ro_Item_Attr_List__Array_ | Ro_Item_Attr_List[]

---@class Ro_Item_Attr__Array_
local Ro_Item_Attr__Array_ =  {}
---@return Ro_Item_Attr
function Ro_Item_Attr__Array_:add()end
---@alias Ro_Item_Attr__Array Ro_Item_Attr__Array_ | Ro_Item_Attr[]

---@class PBfloat__Array_
local PBfloat__Array_ =  {}
---@return PBfloat
function PBfloat__Array_:add()end
---@alias PBfloat__Array PBfloat__Array_ | PBfloat[]

---@class PBString__Array_
local PBString__Array_ =  {}
---@return PBString
function PBString__Array_:add()end
---@alias PBString__Array PBString__Array_ | PBString[]

---@class RoleFashionKeyValData__Array_
local RoleFashionKeyValData__Array_ =  {}
---@return RoleFashionKeyValData
function RoleFashionKeyValData__Array_:add()end
---@alias RoleFashionKeyValData__Array RoleFashionKeyValData__Array_ | RoleFashionKeyValData[]

---@class DBFashionScore__Array_
local DBFashionScore__Array_ =  {}
---@return DBFashionScore
function DBFashionScore__Array_:add()end
---@alias DBFashionScore__Array DBFashionScore__Array_ | DBFashionScore[]

---@class FashionScoreForSave__Array_
local FashionScoreForSave__Array_ =  {}
---@return FashionScoreForSave
function FashionScoreForSave__Array_:add()end
---@alias FashionScoreForSave__Array FashionScoreForSave__Array_ | FashionScoreForSave[]

---@class FashionPhotoData__Array_
local FashionPhotoData__Array_ =  {}
---@return FashionPhotoData
function FashionPhotoData__Array_:add()end
---@alias FashionPhotoData__Array FashionPhotoData__Array_ | FashionPhotoData[]

---@class FashionHistoryNode__Array_
local FashionHistoryNode__Array_ =  {}
---@return FashionHistoryNode
function FashionHistoryNode__Array_:add()end
---@alias FashionHistoryNode__Array FashionHistoryNode__Array_ | FashionHistoryNode[]

---@class FashionEvaRecord__Array_
local FashionEvaRecord__Array_ =  {}
---@return FashionEvaRecord
function FashionEvaRecord__Array_:add()end
---@alias FashionEvaRecord__Array FashionEvaRecord__Array_ | FashionEvaRecord[]

---@class GiftTimesPair__Array_
local GiftTimesPair__Array_ =  {}
---@return GiftTimesPair
function GiftTimesPair__Array_:add()end
---@alias GiftTimesPair__Array GiftTimesPair__Array_ | GiftTimesPair[]

---@class GiftLimitTimesPb__Array_
local GiftLimitTimesPb__Array_ =  {}
---@return GiftLimitTimesPb
function GiftLimitTimesPb__Array_:add()end
---@alias GiftLimitTimesPb__Array GiftLimitTimesPb__Array_ | GiftLimitTimesPb[]

---@class ItemUidPair__Array_
local ItemUidPair__Array_ =  {}
---@return ItemUidPair
function ItemUidPair__Array_:add()end
---@alias ItemUidPair__Array ItemUidPair__Array_ | ItemUidPair[]

---@class GiftLimitInfo__Array_
local GiftLimitInfo__Array_ =  {}
---@return GiftLimitInfo
function GiftLimitInfo__Array_:add()end
---@alias GiftLimitInfo__Array GiftLimitInfo__Array_ | GiftLimitInfo[]

---@class GiftTimes__Array_
local GiftTimes__Array_ =  {}
---@return GiftTimes
function GiftTimes__Array_:add()end
---@alias GiftTimes__Array GiftTimes__Array_ | GiftTimes[]

---@class ItemCountInfo__Array_
local ItemCountInfo__Array_ =  {}
---@return ItemCountInfo
function ItemCountInfo__Array_:add()end
---@alias ItemCountInfo__Array ItemCountInfo__Array_ | ItemCountInfo[]

---@class GiftLimitPbInfo__Array_
local GiftLimitPbInfo__Array_ =  {}
---@return GiftLimitPbInfo
function GiftLimitPbInfo__Array_:add()end
---@alias GiftLimitPbInfo__Array GiftLimitPbInfo__Array_ | GiftLimitPbInfo[]

---@class ItemTemplate__Array_
local ItemTemplate__Array_ =  {}
---@return ItemTemplate
function ItemTemplate__Array_:add()end
---@alias ItemTemplate__Array ItemTemplate__Array_ | ItemTemplate[]

---@class BanRoleInfo__Array_
local BanRoleInfo__Array_ =  {}
---@return BanRoleInfo
function BanRoleInfo__Array_:add()end
---@alias BanRoleInfo__Array BanRoleInfo__Array_ | BanRoleInfo[]

---@class AnnouneceInfo__Array_
local AnnouneceInfo__Array_ =  {}
---@return AnnouneceInfo
function AnnouneceInfo__Array_:add()end
---@alias AnnouneceInfo__Array AnnouneceInfo__Array_ | AnnouneceInfo[]

---@class ARole__Array_
local ARole__Array_ =  {}
---@return ARole
function ARole__Array_:add()end
---@alias ARole__Array ARole__Array_ | ARole[]

---@class RoleAllInfo__Array_
local RoleAllInfo__Array_ =  {}
---@return RoleAllInfo
function RoleAllInfo__Array_:add()end
---@alias RoleAllInfo__Array RoleAllInfo__Array_ | RoleAllInfo[]

---@class IdipItemModifyData__Array_
local IdipItemModifyData__Array_ =  {}
---@return IdipItemModifyData
function IdipItemModifyData__Array_:add()end
---@alias IdipItemModifyData__Array IdipItemModifyData__Array_ | IdipItemModifyData[]

---@class SingelRoleFriends__Array_
local SingelRoleFriends__Array_ =  {}
---@return SingelRoleFriends
function SingelRoleFriends__Array_:add()end
---@alias SingelRoleFriends__Array SingelRoleFriends__Array_ | SingelRoleFriends[]

---@class RoleGiftLimitPbInfo__Array_
local RoleGiftLimitPbInfo__Array_ =  {}
---@return RoleGiftLimitPbInfo
function RoleGiftLimitPbInfo__Array_:add()end
---@alias RoleGiftLimitPbInfo__Array RoleGiftLimitPbInfo__Array_ | RoleGiftLimitPbInfo[]

---@class RoleMessageInfo__Array_
local RoleMessageInfo__Array_ =  {}
---@return RoleMessageInfo
function RoleMessageInfo__Array_:add()end
---@alias RoleMessageInfo__Array RoleMessageInfo__Array_ | RoleMessageInfo[]

---@class RoleMailInfo__Array_
local RoleMailInfo__Array_ =  {}
---@return RoleMailInfo
function RoleMailInfo__Array_:add()end
---@alias RoleMailInfo__Array RoleMailInfo__Array_ | RoleMailInfo[]

---@class GuildInfo__Array_
local GuildInfo__Array_ =  {}
---@return GuildInfo
function GuildInfo__Array_:add()end
---@alias GuildInfo__Array GuildInfo__Array_ | GuildInfo[]

---@class BanInfo__Array_
local BanInfo__Array_ =  {}
---@return BanInfo
function BanInfo__Array_:add()end
---@alias BanInfo__Array BanInfo__Array_ | BanInfo[]

---@class GMMessage__Array_
local GMMessage__Array_ =  {}
---@return GMMessage
function GMMessage__Array_:add()end
---@alias GMMessage__Array GMMessage__Array_ | GMMessage[]

---@class ARoleForbidTalkInfo__Array_
local ARoleForbidTalkInfo__Array_ =  {}
---@return ARoleForbidTalkInfo
function ARoleForbidTalkInfo__Array_:add()end
---@alias ARoleForbidTalkInfo__Array ARoleForbidTalkInfo__Array_ | ARoleForbidTalkInfo[]

---@class BanAccount__Array_
local BanAccount__Array_ =  {}
---@return BanAccount
function BanAccount__Array_:add()end
---@alias BanAccount__Array BanAccount__Array_ | BanAccount[]

---@class QueryRoleData__Array_
local QueryRoleData__Array_ =  {}
---@return QueryRoleData
function QueryRoleData__Array_:add()end
---@alias QueryRoleData__Array QueryRoleData__Array_ | QueryRoleData[]

---@class GuildListInfo__Array_
local GuildListInfo__Array_ =  {}
---@return GuildListInfo
function GuildListInfo__Array_:add()end
---@alias GuildListInfo__Array GuildListInfo__Array_ | GuildListInfo[]

---@class IdipPushAdImageNode__Array_
local IdipPushAdImageNode__Array_ =  {}
---@return IdipPushAdImageNode
function IdipPushAdImageNode__Array_:add()end
---@alias IdipPushAdImageNode__Array IdipPushAdImageNode__Array_ | IdipPushAdImageNode[]

---@class PushAdDbData__Array_
local PushAdDbData__Array_ =  {}
---@return PushAdDbData
function PushAdDbData__Array_:add()end
---@alias PushAdDbData__Array PushAdDbData__Array_ | PushAdDbData[]

---@class GuildMemberDbInfo__Array_
local GuildMemberDbInfo__Array_ =  {}
---@return GuildMemberDbInfo
function GuildMemberDbInfo__Array_:add()end
---@alias GuildMemberDbInfo__Array GuildMemberDbInfo__Array_ | GuildMemberDbInfo[]

---@class AnnounceData__Array_
local AnnounceData__Array_ =  {}
---@return AnnounceData
function AnnounceData__Array_:add()end
---@alias AnnounceData__Array AnnounceData__Array_ | AnnounceData[]

---@class GuildPermissionDbInfo__Array_
local GuildPermissionDbInfo__Array_ =  {}
---@return GuildPermissionDbInfo
function GuildPermissionDbInfo__Array_:add()end
---@alias GuildPermissionDbInfo__Array GuildPermissionDbInfo__Array_ | GuildPermissionDbInfo[]

---@class GuildApplicationItemDbInfo__Array_
local GuildApplicationItemDbInfo__Array_ =  {}
---@return GuildApplicationItemDbInfo
function GuildApplicationItemDbInfo__Array_:add()end
---@alias GuildApplicationItemDbInfo__Array GuildApplicationItemDbInfo__Array_ | GuildApplicationItemDbInfo[]

---@class GuildPermissionInfo__Array_
local GuildPermissionInfo__Array_ =  {}
---@return GuildPermissionInfo
function GuildPermissionInfo__Array_:add()end
---@alias GuildPermissionInfo__Array GuildPermissionInfo__Array_ | GuildPermissionInfo[]

---@class GuildRedEnvelopeInfo__Array_
local GuildRedEnvelopeInfo__Array_ =  {}
---@return GuildRedEnvelopeInfo
function GuildRedEnvelopeInfo__Array_:add()end
---@alias GuildRedEnvelopeInfo__Array GuildRedEnvelopeInfo__Array_ | GuildRedEnvelopeInfo[]

---@class GuildDetailInfo__Array_
local GuildDetailInfo__Array_ =  {}
---@return GuildDetailInfo
function GuildDetailInfo__Array_:add()end
---@alias GuildDetailInfo__Array GuildDetailInfo__Array_ | GuildDetailInfo[]

---@class GuildMemberDetailInfo__Array_
local GuildMemberDetailInfo__Array_ =  {}
---@return GuildMemberDetailInfo
function GuildMemberDetailInfo__Array_:add()end
---@alias GuildMemberDetailInfo__Array GuildMemberDetailInfo__Array_ | GuildMemberDetailInfo[]

---@class GuildBuildingInfo__Array_
local GuildBuildingInfo__Array_ =  {}
---@return GuildBuildingInfo
function GuildBuildingInfo__Array_:add()end
---@alias GuildBuildingInfo__Array GuildBuildingInfo__Array_ | GuildBuildingInfo[]

---@class GuildCrystalPbInfo__Array_
local GuildCrystalPbInfo__Array_ =  {}
---@return GuildCrystalPbInfo
function GuildCrystalPbInfo__Array_:add()end
---@alias GuildCrystalPbInfo__Array GuildCrystalPbInfo__Array_ | GuildCrystalPbInfo[]

---@class GuildCrystalBuffPbInfo__Array_
local GuildCrystalBuffPbInfo__Array_ =  {}
---@return GuildCrystalBuffPbInfo
function GuildCrystalBuffPbInfo__Array_:add()end
---@alias GuildCrystalBuffPbInfo__Array GuildCrystalBuffPbInfo__Array_ | GuildCrystalBuffPbInfo[]

---@class GuildCrystalAttrInfo__Array_
local GuildCrystalAttrInfo__Array_ =  {}
---@return GuildCrystalAttrInfo
function GuildCrystalAttrInfo__Array_:add()end
---@alias GuildCrystalAttrInfo__Array GuildCrystalAttrInfo__Array_ | GuildCrystalAttrInfo[]

---@class RoleItemChangeInfo__Array_
local RoleItemChangeInfo__Array_ =  {}
---@return RoleItemChangeInfo
function RoleItemChangeInfo__Array_:add()end
---@alias RoleItemChangeInfo__Array RoleItemChangeInfo__Array_ | RoleItemChangeInfo[]

---@class GuildPersonAwardList__Array_
local GuildPersonAwardList__Array_ =  {}
---@return GuildPersonAwardList
function GuildPersonAwardList__Array_:add()end
---@alias GuildPersonAwardList__Array GuildPersonAwardList__Array_ | GuildPersonAwardList[]

---@class GuildHuntGuildDbInfo__Array_
local GuildHuntGuildDbInfo__Array_ =  {}
---@return GuildHuntGuildDbInfo
function GuildHuntGuildDbInfo__Array_:add()end
---@alias GuildHuntGuildDbInfo__Array GuildHuntGuildDbInfo__Array_ | GuildHuntGuildDbInfo[]

---@class GuildHuntDungeonPbInfo__Array_
local GuildHuntDungeonPbInfo__Array_ =  {}
---@return GuildHuntDungeonPbInfo
function GuildHuntDungeonPbInfo__Array_:add()end
---@alias GuildHuntDungeonPbInfo__Array GuildHuntDungeonPbInfo__Array_ | GuildHuntDungeonPbInfo[]

---@class GuildHuntScorePbInfo__Array_
local GuildHuntScorePbInfo__Array_ =  {}
---@return GuildHuntScorePbInfo
function GuildHuntScorePbInfo__Array_:add()end
---@alias GuildHuntScorePbInfo__Array GuildHuntScorePbInfo__Array_ | GuildHuntScorePbInfo[]

---@class GuildHuntMemberDbInfo__Array_
local GuildHuntMemberDbInfo__Array_ =  {}
---@return GuildHuntMemberDbInfo
function GuildHuntMemberDbInfo__Array_:add()end
---@alias GuildHuntMemberDbInfo__Array GuildHuntMemberDbInfo__Array_ | GuildHuntMemberDbInfo[]

---@class GuildStoneCarverInfo__Array_
local GuildStoneCarverInfo__Array_ =  {}
---@return GuildStoneCarverInfo
function GuildStoneCarverInfo__Array_:add()end
---@alias GuildStoneCarverInfo__Array GuildStoneCarverInfo__Array_ | GuildStoneCarverInfo[]

---@class GuildStoneInfo__Array_
local GuildStoneInfo__Array_ =  {}
---@return GuildStoneInfo
function GuildStoneInfo__Array_:add()end
---@alias GuildStoneInfo__Array GuildStoneInfo__Array_ | GuildStoneInfo[]

---@class GuildRepoAuctionRoleInfo__Array_
local GuildRepoAuctionRoleInfo__Array_ =  {}
---@return GuildRepoAuctionRoleInfo
function GuildRepoAuctionRoleInfo__Array_:add()end
---@alias GuildRepoAuctionRoleInfo__Array GuildRepoAuctionRoleInfo__Array_ | GuildRepoAuctionRoleInfo[]

---@class GuildRepoCell__Array_
local GuildRepoCell__Array_ =  {}
---@return GuildRepoCell
function GuildRepoCell__Array_:add()end
---@alias GuildRepoCell__Array GuildRepoCell__Array_ | GuildRepoCell[]

---@class GuildAuctionRecordPublic__Array_
local GuildAuctionRecordPublic__Array_ =  {}
---@return GuildAuctionRecordPublic
function GuildAuctionRecordPublic__Array_:add()end
---@alias GuildAuctionRecordPublic__Array GuildAuctionRecordPublic__Array_ | GuildAuctionRecordPublic[]

---@class GuildAuctionItem__Array_
local GuildAuctionItem__Array_ =  {}
---@return GuildAuctionItem
function GuildAuctionItem__Array_:add()end
---@alias GuildAuctionItem__Array GuildAuctionItem__Array_ | GuildAuctionItem[]

---@class GuildRepoCellRoleView__Array_
local GuildRepoCellRoleView__Array_ =  {}
---@return GuildRepoCellRoleView
function GuildRepoCellRoleView__Array_:add()end
---@alias GuildRepoCellRoleView__Array GuildRepoCellRoleView__Array_ | GuildRepoCellRoleView[]

---@class GuildAuctionItemRoleView__Array_
local GuildAuctionItemRoleView__Array_ =  {}
---@return GuildAuctionItemRoleView
function GuildAuctionItemRoleView__Array_:add()end
---@alias GuildAuctionItemRoleView__Array GuildAuctionItemRoleView__Array_ | GuildAuctionItemRoleView[]

---@class GuildHuntFindMemberInfo__Array_
local GuildHuntFindMemberInfo__Array_ =  {}
---@return GuildHuntFindMemberInfo
function GuildHuntFindMemberInfo__Array_:add()end
---@alias GuildHuntFindMemberInfo__Array GuildHuntFindMemberInfo__Array_ | GuildHuntFindMemberInfo[]

---@class GuildMatchPbInfo__Array_
local GuildMatchPbInfo__Array_ =  {}
---@return GuildMatchPbInfo
function GuildMatchPbInfo__Array_:add()end
---@alias GuildMatchPbInfo__Array GuildMatchPbInfo__Array_ | GuildMatchPbInfo[]

---@class GuildMatchPair__Array_
local GuildMatchPair__Array_ =  {}
---@return GuildMatchPair
function GuildMatchPair__Array_:add()end
---@alias GuildMatchPair__Array GuildMatchPair__Array_ | GuildMatchPair[]

---@class GuildTeamRoundResult__Array_
local GuildTeamRoundResult__Array_ =  {}
---@return GuildTeamRoundResult
function GuildTeamRoundResult__Array_:add()end
---@alias GuildTeamRoundResult__Array GuildTeamRoundResult__Array_ | GuildTeamRoundResult[]

---@class CandidateTeamInfo__Array_
local CandidateTeamInfo__Array_ =  {}
---@return CandidateTeamInfo
function CandidateTeamInfo__Array_:add()end
---@alias CandidateTeamInfo__Array CandidateTeamInfo__Array_ | CandidateTeamInfo[]

---@class GuildBattleInfo__Array_
local GuildBattleInfo__Array_ =  {}
---@return GuildBattleInfo
function GuildBattleInfo__Array_:add()end
---@alias GuildBattleInfo__Array GuildBattleInfo__Array_ | GuildBattleInfo[]

---@class RoleIdAndName__Array_
local RoleIdAndName__Array_ =  {}
---@return RoleIdAndName
function RoleIdAndName__Array_:add()end
---@alias RoleIdAndName__Array RoleIdAndName__Array_ | RoleIdAndName[]

---@class CanditateTeamBrief__Array_
local CanditateTeamBrief__Array_ =  {}
---@return CanditateTeamBrief
function CanditateTeamBrief__Array_:add()end
---@alias CanditateTeamBrief__Array CanditateTeamBrief__Array_ | CanditateTeamBrief[]

---@class GuildScorePair__Array_
local GuildScorePair__Array_ =  {}
---@return GuildScorePair
function GuildScorePair__Array_:add()end
---@alias GuildScorePair__Array GuildScorePair__Array_ | GuildScorePair[]

---@class GuildStoneHelper__Array_
local GuildStoneHelper__Array_ =  {}
---@return GuildStoneHelper
function GuildStoneHelper__Array_:add()end
---@alias GuildStoneHelper__Array GuildStoneHelper__Array_ | GuildStoneHelper[]

---@class GuildGmMemberBaseInfo__Array_
local GuildGmMemberBaseInfo__Array_ =  {}
---@return GuildGmMemberBaseInfo
function GuildGmMemberBaseInfo__Array_:add()end
---@alias GuildGmMemberBaseInfo__Array GuildGmMemberBaseInfo__Array_ | GuildGmMemberBaseInfo[]

---@class GuildRankScoreUnitData__Array_
local GuildRankScoreUnitData__Array_ =  {}
---@return GuildRankScoreUnitData
function GuildRankScoreUnitData__Array_:add()end
---@alias GuildRankScoreUnitData__Array GuildRankScoreUnitData__Array_ | GuildRankScoreUnitData[]

---@class GuildMemberOrganizationList__Array_
local GuildMemberOrganizationList__Array_ =  {}
---@return GuildMemberOrganizationList
function GuildMemberOrganizationList__Array_:add()end
---@alias GuildMemberOrganizationList__Array GuildMemberOrganizationList__Array_ | GuildMemberOrganizationList[]

---@class GuildItemOrganizationList__Array_
local GuildItemOrganizationList__Array_ =  {}
---@return GuildItemOrganizationList
function GuildItemOrganizationList__Array_:add()end
---@alias GuildItemOrganizationList__Array GuildItemOrganizationList__Array_ | GuildItemOrganizationList[]

---@class MemberOrganization__Array_
local MemberOrganization__Array_ =  {}
---@return MemberOrganization
function MemberOrganization__Array_:add()end
---@alias MemberOrganization__Array MemberOrganization__Array_ | MemberOrganization[]

---@class GuildDinnerMenuPbInfo__Array_
local GuildDinnerMenuPbInfo__Array_ =  {}
---@return GuildDinnerMenuPbInfo
function GuildDinnerMenuPbInfo__Array_:add()end
---@alias GuildDinnerMenuPbInfo__Array GuildDinnerMenuPbInfo__Array_ | GuildDinnerMenuPbInfo[]

---@class NamePair__Array_
local NamePair__Array_ =  {}
---@return NamePair
function NamePair__Array_:add()end
---@alias NamePair__Array NamePair__Array_ | NamePair[]

---@class GuildDinnerCompetitionRes__Array_
local GuildDinnerCompetitionRes__Array_ =  {}
---@return GuildDinnerCompetitionRes
function GuildDinnerCompetitionRes__Array_:add()end
---@alias GuildDinnerCompetitionRes__Array GuildDinnerCompetitionRes__Array_ | GuildDinnerCompetitionRes[]

---@class GuildDinnerPersonRes__Array_
local GuildDinnerPersonRes__Array_ =  {}
---@return GuildDinnerPersonRes
function GuildDinnerPersonRes__Array_:add()end
---@alias GuildDinnerPersonRes__Array GuildDinnerPersonRes__Array_ | GuildDinnerPersonRes[]

---@class ItemBrief__Array_
local ItemBrief__Array_ =  {}
---@return ItemBrief
function ItemBrief__Array_:add()end
---@alias ItemBrief__Array ItemBrief__Array_ | ItemBrief[]

---@class ItemChangeInfo__Array_
local ItemChangeInfo__Array_ =  {}
---@return ItemChangeInfo
function ItemChangeInfo__Array_:add()end
---@alias ItemChangeInfo__Array ItemChangeInfo__Array_ | ItemChangeInfo[]

---@class VirtualItemChangeInfo__Array_
local VirtualItemChangeInfo__Array_ =  {}
---@return VirtualItemChangeInfo
function VirtualItemChangeInfo__Array_:add()end
---@alias VirtualItemChangeInfo__Array VirtualItemChangeInfo__Array_ | VirtualItemChangeInfo[]

---@class ExpItemChangeInfo__Array_
local ExpItemChangeInfo__Array_ =  {}
---@return ExpItemChangeInfo
function ExpItemChangeInfo__Array_:add()end
---@alias ExpItemChangeInfo__Array ExpItemChangeInfo__Array_ | ExpItemChangeInfo[]

---@class LoadInfo__Array_
local LoadInfo__Array_ =  {}
---@return LoadInfo
function LoadInfo__Array_:add()end
---@alias LoadInfo__Array LoadInfo__Array_ | LoadInfo[]

---@class RevenueItemChangeInfo__Array_
local RevenueItemChangeInfo__Array_ =  {}
---@return RevenueItemChangeInfo
function RevenueItemChangeInfo__Array_:add()end
---@alias RevenueItemChangeInfo__Array RevenueItemChangeInfo__Array_ | RevenueItemChangeInfo[]

---@class BuyShopItem__Array_
local BuyShopItem__Array_ =  {}
---@return BuyShopItem
function BuyShopItem__Array_:add()end
---@alias BuyShopItem__Array BuyShopItem__Array_ | BuyShopItem[]

---@class SellShopItem__Array_
local SellShopItem__Array_ =  {}
---@return SellShopItem
function SellShopItem__Array_:add()end
---@alias SellShopItem__Array SellShopItem__Array_ | SellShopItem[]

---@class ItemPair__Array_
local ItemPair__Array_ =  {}
---@return ItemPair
function ItemPair__Array_:add()end
---@alias ItemPair__Array ItemPair__Array_ | ItemPair[]

---@class AwardItem__Array_
local AwardItem__Array_ =  {}
---@return AwardItem
function AwardItem__Array_:add()end
---@alias AwardItem__Array AwardItem__Array_ | AwardItem[]

---@class AwardContent__Array_
local AwardContent__Array_ =  {}
---@return AwardContent
function AwardContent__Array_:add()end
---@alias AwardContent__Array AwardContent__Array_ | AwardContent[]

---@class LifeEquipItem__Array_
local LifeEquipItem__Array_ =  {}
---@return LifeEquipItem
function LifeEquipItem__Array_:add()end
---@alias LifeEquipItem__Array LifeEquipItem__Array_ | LifeEquipItem[]

---@class AwardExpData__Array_
local AwardExpData__Array_ =  {}
---@return AwardExpData
function AwardExpData__Array_:add()end
---@alias AwardExpData__Array AwardExpData__Array_ | AwardExpData[]

---@class MapKeyIntValue__Array_
local MapKeyIntValue__Array_ =  {}
---@return MapKeyIntValue
function MapKeyIntValue__Array_:add()end
---@alias MapKeyIntValue__Array MapKeyIntValue__Array_ | MapKeyIntValue[]

---@class RecycleCardData__Array_
local RecycleCardData__Array_ =  {}
---@return RecycleCardData
function RecycleCardData__Array_:add()end
---@alias RecycleCardData__Array RecycleCardData__Array_ | RecycleCardData[]

---@class PreviewOrnamentData__Array_
local PreviewOrnamentData__Array_ =  {}
---@return PreviewOrnamentData
function PreviewOrnamentData__Array_:add()end
---@alias PreviewOrnamentData__Array PreviewOrnamentData__Array_ | PreviewOrnamentData[]

---@class RollItem__Array_
local RollItem__Array_ =  {}
---@return RollItem
function RollItem__Array_:add()end
---@alias RollItem__Array RollItem__Array_ | RollItem[]

---@class ArrowPair__Array_
local ArrowPair__Array_ =  {}
---@return ArrowPair
function ArrowPair__Array_:add()end
---@alias ArrowPair__Array ArrowPair__Array_ | ArrowPair[]

---@class AwardPreviewResult__Array_
local AwardPreviewResult__Array_ =  {}
---@return AwardPreviewResult
function AwardPreviewResult__Array_:add()end
---@alias AwardPreviewResult__Array AwardPreviewResult__Array_ | AwardPreviewResult[]

---@class ItemDemandChangeInfo__Array_
local ItemDemandChangeInfo__Array_ =  {}
---@return ItemDemandChangeInfo
function ItemDemandChangeInfo__Array_:add()end
---@alias ItemDemandChangeInfo__Array ItemDemandChangeInfo__Array_ | ItemDemandChangeInfo[]

---@class OfflineItemPb__Array_
local OfflineItemPb__Array_ =  {}
---@return OfflineItemPb
function OfflineItemPb__Array_:add()end
---@alias OfflineItemPb__Array OfflineItemPb__Array_ | OfflineItemPb[]

---@class RoleOfflineItemPb__Array_
local RoleOfflineItemPb__Array_ =  {}
---@return RoleOfflineItemPb
function RoleOfflineItemPb__Array_:add()end
---@alias RoleOfflineItemPb__Array RoleOfflineItemPb__Array_ | RoleOfflineItemPb[]

---@class PreviewMagicEquipExtractData__Array_
local PreviewMagicEquipExtractData__Array_ =  {}
---@return PreviewMagicEquipExtractData
function PreviewMagicEquipExtractData__Array_:add()end
---@alias PreviewMagicEquipExtractData__Array PreviewMagicEquipExtractData__Array_ | PreviewMagicEquipExtractData[]

---@class MapKey64Value32__Array_
local MapKey64Value32__Array_ =  {}
---@return MapKey64Value32
function MapKey64Value32__Array_:add()end
---@alias MapKey64Value32__Array MapKey64Value32__Array_ | MapKey64Value32[]

---@class RoItemAndReason__Array_
local RoItemAndReason__Array_ =  {}
---@return RoItemAndReason
function RoItemAndReason__Array_:add()end
---@alias RoItemAndReason__Array RoItemAndReason__Array_ | RoItemAndReason[]

---@class AuctionItemInfo__Array_
local AuctionItemInfo__Array_ =  {}
---@return AuctionItemInfo
function AuctionItemInfo__Array_:add()end
---@alias AuctionItemInfo__Array AuctionItemInfo__Array_ | AuctionItemInfo[]

---@class ItemAndReason__Array_
local ItemAndReason__Array_ =  {}
---@return ItemAndReason
function ItemAndReason__Array_:add()end
---@alias ItemAndReason__Array ItemAndReason__Array_ | ItemAndReason[]

---@class Ro_Item__Array_
local Ro_Item__Array_ =  {}
---@return Ro_Item
function Ro_Item__Array_:add()end
---@alias Ro_Item__Array Ro_Item__Array_ | Ro_Item[]

---@class AskGsBuffBrief__Array_
local AskGsBuffBrief__Array_ =  {}
---@return AskGsBuffBrief
function AskGsBuffBrief__Array_:add()end
---@alias AskGsBuffBrief__Array AskGsBuffBrief__Array_ | AskGsBuffBrief[]

---@class AskGsOpItemInfo__Array_
local AskGsOpItemInfo__Array_ =  {}
---@return AskGsOpItemInfo
function AskGsOpItemInfo__Array_:add()end
---@alias AskGsOpItemInfo__Array AskGsOpItemInfo__Array_ | AskGsOpItemInfo[]

---@class GrapResult__Array_
local GrapResult__Array_ =  {}
---@return GrapResult
function GrapResult__Array_:add()end
---@alias GrapResult__Array GrapResult__Array_ | GrapResult[]

---@class MagicPaperInfo__Array_
local MagicPaperInfo__Array_ =  {}
---@return MagicPaperInfo
function MagicPaperInfo__Array_:add()end
---@alias MagicPaperInfo__Array MagicPaperInfo__Array_ | MagicPaperInfo[]

---@class EnvelopeInfo__Array_
local EnvelopeInfo__Array_ =  {}
---@return EnvelopeInfo
function EnvelopeInfo__Array_:add()end
---@alias EnvelopeInfo__Array EnvelopeInfo__Array_ | EnvelopeInfo[]

---@class PaperBrief__Array_
local PaperBrief__Array_ =  {}
---@return PaperBrief
function PaperBrief__Array_:add()end
---@alias PaperBrief__Array PaperBrief__Array_ | PaperBrief[]

---@class MailBaseInfo__Array_
local MailBaseInfo__Array_ =  {}
---@return MailBaseInfo
function MailBaseInfo__Array_:add()end
---@alias MailBaseInfo__Array MailBaseInfo__Array_ | MailBaseInfo[]

---@class SMailInfo__Array_
local SMailInfo__Array_ =  {}
---@return SMailInfo
function SMailInfo__Array_:add()end
---@alias SMailInfo__Array SMailInfo__Array_ | SMailInfo[]

---@class MailItemData__Array_
local MailItemData__Array_ =  {}
---@return MailItemData
function MailItemData__Array_:add()end
---@alias MailItemData__Array MailItemData__Array_ | MailItemData[]

---@class MallItem__Array_
local MallItem__Array_ =  {}
---@return MallItem
function MallItem__Array_:add()end
---@alias MallItem__Array MallItem__Array_ | MallItem[]

---@class TradeItemPriceInfo__Array_
local TradeItemPriceInfo__Array_ =  {}
---@return TradeItemPriceInfo
function TradeItemPriceInfo__Array_:add()end
---@alias TradeItemPriceInfo__Array TradeItemPriceInfo__Array_ | TradeItemPriceInfo[]

---@class MultiMallItems__Array_
local MultiMallItems__Array_ =  {}
---@return MultiMallItems
function MultiMallItems__Array_:add()end
---@alias MultiMallItems__Array MultiMallItems__Array_ | MultiMallItems[]

---@class MallTimestamp__Array_
local MallTimestamp__Array_ =  {}
---@return MallTimestamp
function MallTimestamp__Array_:add()end
---@alias MallTimestamp__Array MallTimestamp__Array_ | MallTimestamp[]

---@class MercenaryBrief__Array_
local MercenaryBrief__Array_ =  {}
---@return MercenaryBrief
function MercenaryBrief__Array_:add()end
---@alias MercenaryBrief__Array MercenaryBrief__Array_ | MercenaryBrief[]

---@class MerchantShopItemInfo__Array_
local MerchantShopItemInfo__Array_ =  {}
---@return MerchantShopItemInfo
function MerchantShopItemInfo__Array_:add()end
---@alias MerchantShopItemInfo__Array MerchantShopItemInfo__Array_ | MerchantShopItemInfo[]

---@class MerchantEventPbInfo__Array_
local MerchantEventPbInfo__Array_ =  {}
---@return MerchantEventPbInfo
function MerchantEventPbInfo__Array_:add()end
---@alias MerchantEventPbInfo__Array MerchantEventPbInfo__Array_ | MerchantEventPbInfo[]

---@class MerchantEventRoleDbInfo__Array_
local MerchantEventRoleDbInfo__Array_ =  {}
---@return MerchantEventRoleDbInfo
function MerchantEventRoleDbInfo__Array_:add()end
---@alias MerchantEventRoleDbInfo__Array MerchantEventRoleDbInfo__Array_ | MerchantEventRoleDbInfo[]

---@class MerchantEventNpcDbInfo__Array_
local MerchantEventNpcDbInfo__Array_ =  {}
---@return MerchantEventNpcDbInfo
function MerchantEventNpcDbInfo__Array_:add()end
---@alias MerchantEventNpcDbInfo__Array MerchantEventNpcDbInfo__Array_ | MerchantEventNpcDbInfo[]

---@class ListenAddressPair__Array_
local ListenAddressPair__Array_ =  {}
---@return ListenAddressPair
function ListenAddressPair__Array_:add()end
---@alias ListenAddressPair__Array ListenAddressPair__Array_ | ListenAddressPair[]

---@class DBListenInfo__Array_
local DBListenInfo__Array_ =  {}
---@return DBListenInfo
function DBListenInfo__Array_:add()end
---@alias DBListenInfo__Array DBListenInfo__Array_ | DBListenInfo[]

---@class LimitedTimeOfferItem__Array_
local LimitedTimeOfferItem__Array_ =  {}
---@return LimitedTimeOfferItem
function LimitedTimeOfferItem__Array_:add()end
---@alias LimitedTimeOfferItem__Array LimitedTimeOfferItem__Array_ | LimitedTimeOfferItem[]

---@class PayTsslist__Array_
local PayTsslist__Array_ =  {}
---@return PayTsslist
function PayTsslist__Array_:add()end
---@alias PayTsslist__Array PayTsslist__Array_ | PayTsslist[]

---@class PaySubscribeInfo__Array_
local PaySubscribeInfo__Array_ =  {}
---@return PaySubscribeInfo
function PaySubscribeInfo__Array_:add()end
---@alias PaySubscribeInfo__Array PaySubscribeInfo__Array_ | PaySubscribeInfo[]

---@class PayPresentInfo__Array_
local PayPresentInfo__Array_ =  {}
---@return PayPresentInfo
function PayPresentInfo__Array_:add()end
---@alias PayPresentInfo__Array PayPresentInfo__Array_ | PayPresentInfo[]

---@class PayConsumeInfo__Array_
local PayConsumeInfo__Array_ =  {}
---@return PayConsumeInfo
function PayConsumeInfo__Array_:add()end
---@alias PayConsumeInfo__Array PayConsumeInfo__Array_ | PayConsumeInfo[]

---@class PayBuyGoodInfo__Array_
local PayBuyGoodInfo__Array_ =  {}
---@return PayBuyGoodInfo
function PayBuyGoodInfo__Array_:add()end
---@alias PayBuyGoodInfo__Array PayBuyGoodInfo__Array_ | PayBuyGoodInfo[]

---@class HttpParam__Array_
local HttpParam__Array_ =  {}
---@return HttpParam
function HttpParam__Array_:add()end
---@alias HttpParam__Array HttpParam__Array_ | HttpParam[]

---@class LimitedTimeOfferRecharge__Array_
local LimitedTimeOfferRecharge__Array_ =  {}
---@return LimitedTimeOfferRecharge
function LimitedTimeOfferRecharge__Array_:add()end
---@alias LimitedTimeOfferRecharge__Array LimitedTimeOfferRecharge__Array_ | LimitedTimeOfferRecharge[]

---@class OrderInfo__Array_
local OrderInfo__Array_ =  {}
---@return OrderInfo
function OrderInfo__Array_:add()end
---@alias OrderInfo__Array OrderInfo__Array_ | OrderInfo[]

---@class PayGoodBrief__Array_
local PayGoodBrief__Array_ =  {}
---@return PayGoodBrief
function PayGoodBrief__Array_:add()end
---@alias PayGoodBrief__Array PayGoodBrief__Array_ | PayGoodBrief[]

---@class PayParamIntNode__Array_
local PayParamIntNode__Array_ =  {}
---@return PayParamIntNode
function PayParamIntNode__Array_:add()end
---@alias PayParamIntNode__Array PayParamIntNode__Array_ | PayParamIntNode[]

---@class OutsideOrder__Array_
local OutsideOrder__Array_ =  {}
---@return OutsideOrder
function OutsideOrder__Array_:add()end
---@alias OutsideOrder__Array OutsideOrder__Array_ | OutsideOrder[]

---@class PushMsgRecord__Array_
local PushMsgRecord__Array_ =  {}
---@return PushMsgRecord
function PushMsgRecord__Array_:add()end
---@alias PushMsgRecord__Array PushMsgRecord__Array_ | PushMsgRecord[]

---@class PushInformationInfo__Array_
local PushInformationInfo__Array_ =  {}
---@return PushInformationInfo
function PushInformationInfo__Array_:add()end
---@alias PushInformationInfo__Array PushInformationInfo__Array_ | PushInformationInfo[]

---@class RankBriefRole__Array_
local RankBriefRole__Array_ =  {}
---@return RankBriefRole
function RankBriefRole__Array_:add()end
---@alias RankBriefRole__Array RankBriefRole__Array_ | RankBriefRole[]

---@class BoardRowData__Array_
local BoardRowData__Array_ =  {}
---@return BoardRowData
function BoardRowData__Array_:add()end
---@alias BoardRowData__Array BoardRowData__Array_ | BoardRowData[]

---@class RankMemberInfo__Array_
local RankMemberInfo__Array_ =  {}
---@return RankMemberInfo
function RankMemberInfo__Array_:add()end
---@alias RankMemberInfo__Array RankMemberInfo__Array_ | RankMemberInfo[]

---@class RankRowData__Array_
local RankRowData__Array_ =  {}
---@return RankRowData
function RankRowData__Array_:add()end
---@alias RankRowData__Array RankRowData__Array_ | RankRowData[]

---@class RankRoelInfo__Array_
local RankRoelInfo__Array_ =  {}
---@return RankRoelInfo
function RankRoelInfo__Array_:add()end
---@alias RankRoelInfo__Array RankRoelInfo__Array_ | RankRoelInfo[]

---@class SyncguildInfo2RankData__Array_
local SyncguildInfo2RankData__Array_ =  {}
---@return SyncguildInfo2RankData
function SyncguildInfo2RankData__Array_:add()end
---@alias SyncguildInfo2RankData__Array SyncguildInfo2RankData__Array_ | SyncguildInfo2RankData[]

---@class DbRankData__Array_
local DbRankData__Array_ =  {}
---@return DbRankData
function DbRankData__Array_:add()end
---@alias DbRankData__Array DbRankData__Array_ | DbRankData[]

---@class LeaderBoardTimeInfo__Array_
local LeaderBoardTimeInfo__Array_ =  {}
---@return LeaderBoardTimeInfo
function LeaderBoardTimeInfo__Array_:add()end
---@alias LeaderBoardTimeInfo__Array LeaderBoardTimeInfo__Array_ | LeaderBoardTimeInfo[]

---@class RoleLeaderBoardRank__Array_
local RoleLeaderBoardRank__Array_ =  {}
---@return RoleLeaderBoardRank
function RoleLeaderBoardRank__Array_:add()end
---@alias RoleLeaderBoardRank__Array RoleLeaderBoardRank__Array_ | RoleLeaderBoardRank[]

---@class MailAwardNode__Array_
local MailAwardNode__Array_ =  {}
---@return MailAwardNode
function MailAwardNode__Array_:add()end
---@alias MailAwardNode__Array MailAwardNode__Array_ | MailAwardNode[]

---@class GuildLeaderBoardRowData__Array_
local GuildLeaderBoardRowData__Array_ =  {}
---@return GuildLeaderBoardRowData
function GuildLeaderBoardRowData__Array_:add()end
---@alias GuildLeaderBoardRowData__Array GuildLeaderBoardRowData__Array_ | GuildLeaderBoardRowData[]

---@class LevelRankChangeParam__Array_
local LevelRankChangeParam__Array_ =  {}
---@return LevelRankChangeParam
function LevelRankChangeParam__Array_:add()end
---@alias LevelRankChangeParam__Array LevelRankChangeParam__Array_ | LevelRankChangeParam[]

---@class ErrorCode__Array_
local ErrorCode__Array_ =  {}
---@return ErrorCode
function ErrorCode__Array_:add()end
---@alias ErrorCode__Array ErrorCode__Array_ | ErrorCode[]

---@class GrabGuildRedEnvelopeResult__Array_
local GrabGuildRedEnvelopeResult__Array_ =  {}
---@return GrabGuildRedEnvelopeResult
function GrabGuildRedEnvelopeResult__Array_:add()end
---@alias GrabGuildRedEnvelopeResult__Array GrabGuildRedEnvelopeResult__Array_ | GrabGuildRedEnvelopeResult[]

---@class DbOpType__Array_
local DbOpType__Array_ =  {}
---@return DbOpType
function DbOpType__Array_:add()end
---@alias DbOpType__Array DbOpType__Array_ | DbOpType[]

---@class RedEnvelopeReceiver__Array_
local RedEnvelopeReceiver__Array_ =  {}
---@return RedEnvelopeReceiver
function RedEnvelopeReceiver__Array_:add()end
---@alias RedEnvelopeReceiver__Array RedEnvelopeReceiver__Array_ | RedEnvelopeReceiver[]

---@class GuildRedEnvelopeAllInfo__Array_
local GuildRedEnvelopeAllInfo__Array_ =  {}
---@return GuildRedEnvelopeAllInfo
function GuildRedEnvelopeAllInfo__Array_:add()end
---@alias GuildRedEnvelopeAllInfo__Array GuildRedEnvelopeAllInfo__Array_ | GuildRedEnvelopeAllInfo[]

---@class ReturnPrizeTaskInfo__Array_
local ReturnPrizeTaskInfo__Array_ =  {}
---@return ReturnPrizeTaskInfo
function ReturnPrizeTaskInfo__Array_:add()end
---@alias ReturnPrizeTaskInfo__Array ReturnPrizeTaskInfo__Array_ | ReturnPrizeTaskInfo[]

---@class ReturnTaskInfo__Array_
local ReturnTaskInfo__Array_ =  {}
---@return ReturnTaskInfo
function ReturnTaskInfo__Array_:add()end
---@alias ReturnTaskInfo__Array ReturnTaskInfo__Array_ | ReturnTaskInfo[]

---@class ReturnPrizeWelcomeGuild__Array_
local ReturnPrizeWelcomeGuild__Array_ =  {}
---@return ReturnPrizeWelcomeGuild
function ReturnPrizeWelcomeGuild__Array_:add()end
---@alias ReturnPrizeWelcomeGuild__Array ReturnPrizeWelcomeGuild__Array_ | ReturnPrizeWelcomeGuild[]

---@class ReadRoleBriefInfo__Array_
local ReadRoleBriefInfo__Array_ =  {}
---@return ReadRoleBriefInfo
function ReadRoleBriefInfo__Array_:add()end
---@alias ReadRoleBriefInfo__Array ReadRoleBriefInfo__Array_ | ReadRoleBriefInfo[]

---@class RecentMateInfo__Array_
local RecentMateInfo__Array_ =  {}
---@return RecentMateInfo
function RecentMateInfo__Array_:add()end
---@alias RecentMateInfo__Array RecentMateInfo__Array_ | RecentMateInfo[]

---@class MsRoleModuleFlag__Array_
local MsRoleModuleFlag__Array_ =  {}
---@return MsRoleModuleFlag
function MsRoleModuleFlag__Array_:add()end
---@alias MsRoleModuleFlag__Array MsRoleModuleFlag__Array_ | MsRoleModuleFlag[]

---@class MsRoleModuleData__Array_
local MsRoleModuleData__Array_ =  {}
---@return MsRoleModuleData
function MsRoleModuleData__Array_:add()end
---@alias MsRoleModuleData__Array MsRoleModuleData__Array_ | MsRoleModuleData[]

---@class SingleCountInfo__Array_
local SingleCountInfo__Array_ =  {}
---@return SingleCountInfo
function SingleCountInfo__Array_:add()end
---@alias SingleCountInfo__Array SingleCountInfo__Array_ | SingleCountInfo[]

---@class PayRolePbInfo__Array_
local PayRolePbInfo__Array_ =  {}
---@return PayRolePbInfo
function PayRolePbInfo__Array_:add()end
---@alias PayRolePbInfo__Array PayRolePbInfo__Array_ | PayRolePbInfo[]

---@class RoleSmallPhotoData__Array_
local RoleSmallPhotoData__Array_ =  {}
---@return RoleSmallPhotoData
function RoleSmallPhotoData__Array_:add()end
---@alias RoleSmallPhotoData__Array RoleSmallPhotoData__Array_ | RoleSmallPhotoData[]

---@class CrossSceneInfo__Array_
local CrossSceneInfo__Array_ =  {}
---@return CrossSceneInfo
function CrossSceneInfo__Array_:add()end
---@alias CrossSceneInfo__Array CrossSceneInfo__Array_ | CrossSceneInfo[]

---@class SceneLineData__Array_
local SceneLineData__Array_ =  {}
---@return SceneLineData
function SceneLineData__Array_:add()end
---@alias SceneLineData__Array SceneLineData__Array_ | SceneLineData[]

---@class EasyPath__Array_
local EasyPath__Array_ =  {}
---@return EasyPath
function EasyPath__Array_:add()end
---@alias EasyPath__Array EasyPath__Array_ | EasyPath[]

---@class ListenAddress__Array_
local ListenAddress__Array_ =  {}
---@return ListenAddress
function ListenAddress__Array_:add()end
---@alias ListenAddress__Array ListenAddress__Array_ | ListenAddress[]

---@class SceneStatInfo__Array_
local SceneStatInfo__Array_ =  {}
---@return SceneStatInfo
function SceneStatInfo__Array_:add()end
---@alias SceneStatInfo__Array SceneStatInfo__Array_ | SceneStatInfo[]

---@class ProxyAddr__Array_
local ProxyAddr__Array_ =  {}
---@return ProxyAddr
function ProxyAddr__Array_:add()end
---@alias ProxyAddr__Array ProxyAddr__Array_ | ProxyAddr[]

---@class TreasureChestInfo__Array_
local TreasureChestInfo__Array_ =  {}
---@return TreasureChestInfo
function TreasureChestInfo__Array_:add()end
---@alias TreasureChestInfo__Array TreasureChestInfo__Array_ | TreasureChestInfo[]

---@class SceneEventInstanceInfo__Array_
local SceneEventInstanceInfo__Array_ =  {}
---@return SceneEventInstanceInfo
function SceneEventInstanceInfo__Array_:add()end
---@alias SceneEventInstanceInfo__Array SceneEventInstanceInfo__Array_ | SceneEventInstanceInfo[]

---@class MVPInfo__Array_
local MVPInfo__Array_ =  {}
---@return MVPInfo
function MVPInfo__Array_:add()end
---@alias MVPInfo__Array MVPInfo__Array_ | MVPInfo[]

---@class MVPMemberInfo__Array_
local MVPMemberInfo__Array_ =  {}
---@return MVPMemberInfo
function MVPMemberInfo__Array_:add()end
---@alias MVPMemberInfo__Array MVPMemberInfo__Array_ | MVPMemberInfo[]

---@class MVPRecordRolePbInfo__Array_
local MVPRecordRolePbInfo__Array_ =  {}
---@return MVPRecordRolePbInfo
function MVPRecordRolePbInfo__Array_:add()end
---@alias MVPRecordRolePbInfo__Array MVPRecordRolePbInfo__Array_ | MVPRecordRolePbInfo[]

---@class MVPRecordPbInfo__Array_
local MVPRecordPbInfo__Array_ =  {}
---@return MVPRecordPbInfo
function MVPRecordPbInfo__Array_:add()end
---@alias MVPRecordPbInfo__Array MVPRecordPbInfo__Array_ | MVPRecordPbInfo[]

---@class MvpTeamResultInfo__Array_
local MvpTeamResultInfo__Array_ =  {}
---@return MvpTeamResultInfo
function MvpTeamResultInfo__Array_:add()end
---@alias MvpTeamResultInfo__Array MvpTeamResultInfo__Array_ | MvpTeamResultInfo[]

---@class MVPConfigData__Array_
local MVPConfigData__Array_ =  {}
---@return MVPConfigData
function MVPConfigData__Array_:add()end
---@alias MVPConfigData__Array MVPConfigData__Array_ | MVPConfigData[]

---@class MvpRoleResult__Array_
local MvpRoleResult__Array_ =  {}
---@return MvpRoleResult
function MvpRoleResult__Array_:add()end
---@alias MvpRoleResult__Array MvpRoleResult__Array_ | MvpRoleResult[]

---@class OpenSystemSyncInfo__Array_
local OpenSystemSyncInfo__Array_ =  {}
---@return OpenSystemSyncInfo
function OpenSystemSyncInfo__Array_:add()end
---@alias OpenSystemSyncInfo__Array OpenSystemSyncInfo__Array_ | OpenSystemSyncInfo[]

---@class AgreementToFmData__Array_
local AgreementToFmData__Array_ =  {}
---@return AgreementToFmData
function AgreementToFmData__Array_:add()end
---@alias AgreementToFmData__Array AgreementToFmData__Array_ | AgreementToFmData[]

---@class MaintainServerInfo__Array_
local MaintainServerInfo__Array_ =  {}
---@return MaintainServerInfo
function MaintainServerInfo__Array_:add()end
---@alias MaintainServerInfo__Array MaintainServerInfo__Array_ | MaintainServerInfo[]

---@class StallMarkPbInfo__Array_
local StallMarkPbInfo__Array_ =  {}
---@return StallMarkPbInfo
function StallMarkPbInfo__Array_:add()end
---@alias StallMarkPbInfo__Array StallMarkPbInfo__Array_ | StallMarkPbInfo[]

---@class StallSecondMarkPbInfo__Array_
local StallSecondMarkPbInfo__Array_ =  {}
---@return StallSecondMarkPbInfo
function StallSecondMarkPbInfo__Array_:add()end
---@alias StallSecondMarkPbInfo__Array StallSecondMarkPbInfo__Array_ | StallSecondMarkPbInfo[]

---@class StallItemPbInfo__Array_
local StallItemPbInfo__Array_ =  {}
---@return StallItemPbInfo
function StallItemPbInfo__Array_:add()end
---@alias StallItemPbInfo__Array StallItemPbInfo__Array_ | StallItemPbInfo[]

---@class StallBasePriceDbInfo__Array_
local StallBasePriceDbInfo__Array_ =  {}
---@return StallBasePriceDbInfo
function StallBasePriceDbInfo__Array_:add()end
---@alias StallBasePriceDbInfo__Array StallBasePriceDbInfo__Array_ | StallBasePriceDbInfo[]

---@class StallItemRecordDbInfo__Array_
local StallItemRecordDbInfo__Array_ =  {}
---@return StallItemRecordDbInfo
function StallItemRecordDbInfo__Array_:add()end
---@alias StallItemRecordDbInfo__Array StallItemRecordDbInfo__Array_ | StallItemRecordDbInfo[]

---@class StallItemSellDbInfo__Array_
local StallItemSellDbInfo__Array_ =  {}
---@return StallItemSellDbInfo
function StallItemSellDbInfo__Array_:add()end
---@alias StallItemSellDbInfo__Array StallItemSellDbInfo__Array_ | StallItemSellDbInfo[]

---@class StallItemStockInfo__Array_
local StallItemStockInfo__Array_ =  {}
---@return StallItemStockInfo
function StallItemStockInfo__Array_:add()end
---@alias StallItemStockInfo__Array StallItemStockInfo__Array_ | StallItemStockInfo[]

---@class StallItemPrice__Array_
local StallItemPrice__Array_ =  {}
---@return StallItemPrice
function StallItemPrice__Array_:add()end
---@alias StallItemPrice__Array StallItemPrice__Array_ | StallItemPrice[]

---@class PosToStickerId__Array_
local PosToStickerId__Array_ =  {}
---@return PosToStickerId
function PosToStickerId__Array_:add()end
---@alias PosToStickerId__Array PosToStickerId__Array_ | PosToStickerId[]

---@class SystemOpenRoleDbInfo__Array_
local SystemOpenRoleDbInfo__Array_ =  {}
---@return SystemOpenRoleDbInfo
function SystemOpenRoleDbInfo__Array_:add()end
---@alias SystemOpenRoleDbInfo__Array SystemOpenRoleDbInfo__Array_ | SystemOpenRoleDbInfo[]

---@class TaskInfo__Array_
local TaskInfo__Array_ =  {}
---@return TaskInfo
function TaskInfo__Array_:add()end
---@alias TaskInfo__Array TaskInfo__Array_ | TaskInfo[]

---@class TaskTargetInfo__Array_
local TaskTargetInfo__Array_ =  {}
---@return TaskTargetInfo
function TaskTargetInfo__Array_:add()end
---@alias TaskTargetInfo__Array TaskTargetInfo__Array_ | TaskTargetInfo[]

---@class CheckResult__Array_
local CheckResult__Array_ =  {}
---@return CheckResult
function CheckResult__Array_:add()end
---@alias CheckResult__Array CheckResult__Array_ | CheckResult[]

---@class TriggerInfo__Array_
local TriggerInfo__Array_ =  {}
---@return TriggerInfo
function TriggerInfo__Array_:add()end
---@alias TriggerInfo__Array TriggerInfo__Array_ | TriggerInfo[]

---@class RoleWorldEventSignPair__Array_
local RoleWorldEventSignPair__Array_ =  {}
---@return RoleWorldEventSignPair
function RoleWorldEventSignPair__Array_:add()end
---@alias RoleWorldEventSignPair__Array RoleWorldEventSignPair__Array_ | RoleWorldEventSignPair[]

---@class TeamMatchInfo__Array_
local TeamMatchInfo__Array_ =  {}
---@return TeamMatchInfo
function TeamMatchInfo__Array_:add()end
---@alias TeamMatchInfo__Array TeamMatchInfo__Array_ | TeamMatchInfo[]

---@class MemberAttrChangeInfo__Array_
local MemberAttrChangeInfo__Array_ =  {}
---@return MemberAttrChangeInfo
function MemberAttrChangeInfo__Array_:add()end
---@alias MemberAttrChangeInfo__Array MemberAttrChangeInfo__Array_ | MemberAttrChangeInfo[]

---@class TeamMemberPos__Array_
local TeamMemberPos__Array_ =  {}
---@return TeamMemberPos
function TeamMemberPos__Array_:add()end
---@alias TeamMemberPos__Array TeamMemberPos__Array_ | TeamMemberPos[]

---@class RoleDungeonInfo__Array_
local RoleDungeonInfo__Array_ =  {}
---@return RoleDungeonInfo
function RoleDungeonInfo__Array_:add()end
---@alias RoleDungeonInfo__Array RoleDungeonInfo__Array_ | RoleDungeonInfo[]

---@class TeamMemberSyncToGameDataInfo__Array_
local TeamMemberSyncToGameDataInfo__Array_ =  {}
---@return TeamMemberSyncToGameDataInfo
function TeamMemberSyncToGameDataInfo__Array_:add()end
---@alias TeamMemberSyncToGameDataInfo__Array TeamMemberSyncToGameDataInfo__Array_ | TeamMemberSyncToGameDataInfo[]

---@class MemberStatusInfo__Array_
local MemberStatusInfo__Array_ =  {}
---@return MemberStatusInfo
function MemberStatusInfo__Array_:add()end
---@alias MemberStatusInfo__Array MemberStatusInfo__Array_ | MemberStatusInfo[]

---@class MemberWatchStatus__Array_
local MemberWatchStatus__Array_ =  {}
---@return MemberWatchStatus
function MemberWatchStatus__Array_:add()end
---@alias MemberWatchStatus__Array MemberWatchStatus__Array_ | MemberWatchStatus[]

---@class ThemePartyRoleInfo__Array_
local ThemePartyRoleInfo__Array_ =  {}
---@return ThemePartyRoleInfo
function ThemePartyRoleInfo__Array_:add()end
---@alias ThemePartyRoleInfo__Array ThemePartyRoleInfo__Array_ | ThemePartyRoleInfo[]

---@class LoveHeartGiveRecord__Array_
local LoveHeartGiveRecord__Array_ =  {}
---@return LoveHeartGiveRecord
function LoveHeartGiveRecord__Array_:add()end
---@alias LoveHeartGiveRecord__Array LoveHeartGiveRecord__Array_ | LoveHeartGiveRecord[]

---@class ThemePartyPrizeMember__Array_
local ThemePartyPrizeMember__Array_ =  {}
---@return ThemePartyPrizeMember
function ThemePartyPrizeMember__Array_:add()end
---@alias ThemePartyPrizeMember__Array ThemePartyPrizeMember__Array_ | ThemePartyPrizeMember[]

---@class ThemePartyLotteryTypePrizeMember__Array_
local ThemePartyLotteryTypePrizeMember__Array_ =  {}
---@return ThemePartyLotteryTypePrizeMember
function ThemePartyLotteryTypePrizeMember__Array_:add()end
---@alias ThemePartyLotteryTypePrizeMember__Array ThemePartyLotteryTypePrizeMember__Array_ | ThemePartyLotteryTypePrizeMember[]

---@class ThemePartyEachLotteryInfo__Array_
local ThemePartyEachLotteryInfo__Array_ =  {}
---@return ThemePartyEachLotteryInfo
function ThemePartyEachLotteryInfo__Array_:add()end
---@alias ThemePartyEachLotteryInfo__Array ThemePartyEachLotteryInfo__Array_ | ThemePartyEachLotteryInfo[]

---@class ThemePartyRoleLotteryInfo__Array_
local ThemePartyRoleLotteryInfo__Array_ =  {}
---@return ThemePartyRoleLotteryInfo
function ThemePartyRoleLotteryInfo__Array_:add()end
---@alias ThemePartyRoleLotteryInfo__Array ThemePartyRoleLotteryInfo__Array_ | ThemePartyRoleLotteryInfo[]

---@class TradeDbBuyBill__Array_
local TradeDbBuyBill__Array_ =  {}
---@return TradeDbBuyBill
function TradeDbBuyBill__Array_:add()end
---@alias TradeDbBuyBill__Array TradeDbBuyBill__Array_ | TradeDbBuyBill[]

---@class TradeDbBuyBillResult__Array_
local TradeDbBuyBillResult__Array_ =  {}
---@return TradeDbBuyBillResult
function TradeDbBuyBillResult__Array_:add()end
---@alias TradeDbBuyBillResult__Array TradeDbBuyBillResult__Array_ | TradeDbBuyBillResult[]

---@class TradeItemDbInfo__Array_
local TradeItemDbInfo__Array_ =  {}
---@return TradeItemDbInfo
function TradeItemDbInfo__Array_:add()end
---@alias TradeItemDbInfo__Array TradeItemDbInfo__Array_ | TradeItemDbInfo[]

---@class TradeItemMarkDbInfo__Array_
local TradeItemMarkDbInfo__Array_ =  {}
---@return TradeItemMarkDbInfo
function TradeItemMarkDbInfo__Array_:add()end
---@alias TradeItemMarkDbInfo__Array TradeItemMarkDbInfo__Array_ | TradeItemMarkDbInfo[]

---@class TradeBillInfo__Array_
local TradeBillInfo__Array_ =  {}
---@return TradeBillInfo
function TradeBillInfo__Array_:add()end
---@alias TradeBillInfo__Array TradeBillInfo__Array_ | TradeBillInfo[]

---@class TradeItemPbInfo__Array_
local TradeItemPbInfo__Array_ =  {}
---@return TradeItemPbInfo
function TradeItemPbInfo__Array_:add()end
---@alias TradeItemPbInfo__Array TradeItemPbInfo__Array_ | TradeItemPbInfo[]

---@class TradeItemMarkPbInfo__Array_
local TradeItemMarkPbInfo__Array_ =  {}
---@return TradeItemMarkPbInfo
function TradeItemMarkPbInfo__Array_:add()end
---@alias TradeItemMarkPbInfo__Array TradeItemMarkPbInfo__Array_ | TradeItemMarkPbInfo[]

---@class TradeRolePbInfo__Array_
local TradeRolePbInfo__Array_ =  {}
---@return TradeRolePbInfo
function TradeRolePbInfo__Array_:add()end
---@alias TradeRolePbInfo__Array TradeRolePbInfo__Array_ | TradeRolePbInfo[]

---@class TradeRoleTlogInfo__Array_
local TradeRoleTlogInfo__Array_ =  {}
---@return TradeRoleTlogInfo
function TradeRoleTlogInfo__Array_:add()end
---@alias TradeRoleTlogInfo__Array TradeRoleTlogInfo__Array_ | TradeRoleTlogInfo[]

---@class TradeBalanceRoleBillPb__Array_
local TradeBalanceRoleBillPb__Array_ =  {}
---@return TradeBalanceRoleBillPb
function TradeBalanceRoleBillPb__Array_:add()end
---@alias TradeBalanceRoleBillPb__Array TradeBalanceRoleBillPb__Array_ | TradeBalanceRoleBillPb[]

---@class TradeBalanceBillPb__Array_
local TradeBalanceBillPb__Array_ =  {}
---@return TradeBalanceBillPb
function TradeBalanceBillPb__Array_:add()end
---@alias TradeBalanceBillPb__Array TradeBalanceBillPb__Array_ | TradeBalanceBillPb[]

---@class SkillSlot__Array_
local SkillSlot__Array_ =  {}
---@return SkillSlot
function SkillSlot__Array_:add()end
---@alias SkillSlot__Array SkillSlot__Array_ | SkillSlot[]

---@class RecoverInfo__Array_
local RecoverInfo__Array_ =  {}
---@return RecoverInfo
function RecoverInfo__Array_:add()end
---@alias RecoverInfo__Array RecoverInfo__Array_ | RecoverInfo[]

---@class Tutorial__Array_
local Tutorial__Array_ =  {}
---@return Tutorial
function Tutorial__Array_:add()end
---@alias Tutorial__Array Tutorial__Array_ | Tutorial[]

---@class ServerInfo__Array_
local ServerInfo__Array_ =  {}
---@return ServerInfo
function ServerInfo__Array_:add()end
---@alias ServerInfo__Array ServerInfo__Array_ | ServerInfo[]

---@class ServerState__Array_
local ServerState__Array_ =  {}
---@return ServerState
function ServerState__Array_:add()end
---@alias ServerState__Array ServerState__Array_ | ServerState[]

---@class UnitAppearance__Array_
local UnitAppearance__Array_ =  {}
---@return UnitAppearance
function UnitAppearance__Array_:add()end
---@alias UnitAppearance__Array UnitAppearance__Array_ | UnitAppearance[]

---@class VirtualItemData__Array_
local VirtualItemData__Array_ =  {}
---@return VirtualItemData
function VirtualItemData__Array_:add()end
---@alias VirtualItemData__Array VirtualItemData__Array_ | VirtualItemData[]

---@class ServerIdInfo__Array_
local ServerIdInfo__Array_ =  {}
---@return ServerIdInfo
function ServerIdInfo__Array_:add()end
---@alias ServerIdInfo__Array ServerIdInfo__Array_ | ServerIdInfo[]

---@class ClientInfo__Array_
local ClientInfo__Array_ =  {}
---@return ClientInfo
function ClientInfo__Array_:add()end
---@alias ClientInfo__Array ClientInfo__Array_ | ClientInfo[]

---@class RoleBriefInfo__Array_
local RoleBriefInfo__Array_ =  {}
---@return RoleBriefInfo
function RoleBriefInfo__Array_:add()end
---@alias RoleBriefInfo__Array RoleBriefInfo__Array_ | RoleBriefInfo[]

---@class ChangeSceneRole__Array_
local ChangeSceneRole__Array_ =  {}
---@return ChangeSceneRole
function ChangeSceneRole__Array_:add()end
---@alias ChangeSceneRole__Array ChangeSceneRole__Array_ | ChangeSceneRole[]

---@class PayBaseInfo__Array_
local PayBaseInfo__Array_ =  {}
---@return PayBaseInfo
function PayBaseInfo__Array_:add()end
---@alias PayBaseInfo__Array PayBaseInfo__Array_ | PayBaseInfo[]

---@class PayAileenRecord__Array_
local PayAileenRecord__Array_ =  {}
---@return PayAileenRecord
function PayAileenRecord__Array_:add()end
---@alias PayAileenRecord__Array PayAileenRecord__Array_ | PayAileenRecord[]

---@class PayAwardRecord__Array_
local PayAwardRecord__Array_ =  {}
---@return PayAwardRecord
function PayAwardRecord__Array_:add()end
---@alias PayAwardRecord__Array PayAwardRecord__Array_ | PayAwardRecord[]

---@class PayMemberRecord__Array_
local PayMemberRecord__Array_ =  {}
---@return PayMemberRecord
function PayMemberRecord__Array_:add()end
---@alias PayMemberRecord__Array PayMemberRecord__Array_ | PayMemberRecord[]

---@class PayconsumeBrief__Array_
local PayconsumeBrief__Array_ =  {}
---@return PayconsumeBrief
function PayconsumeBrief__Array_:add()end
---@alias PayconsumeBrief__Array PayconsumeBrief__Array_ | PayconsumeBrief[]

---@class EffectMultiParams__Array_
local EffectMultiParams__Array_ =  {}
---@return EffectMultiParams
function EffectMultiParams__Array_:add()end
---@alias EffectMultiParams__Array EffectMultiParams__Array_ | EffectMultiParams[]

---@class SpActivityTask__Array_
local SpActivityTask__Array_ =  {}
---@return SpActivityTask
function SpActivityTask__Array_:add()end
---@alias SpActivityTask__Array SpActivityTask__Array_ | SpActivityTask[]

---@class DEStageProgress__Array_
local DEStageProgress__Array_ =  {}
---@return DEStageProgress
function DEStageProgress__Array_:add()end
---@alias DEStageProgress__Array DEStageProgress__Array_ | DEStageProgress[]

---@class StageAssistOne__Array_
local StageAssistOne__Array_ =  {}
---@return StageAssistOne
function StageAssistOne__Array_:add()end
---@alias StageAssistOne__Array StageAssistOne__Array_ | StageAssistOne[]

---@class RiskGridInfo__Array_
local RiskGridInfo__Array_ =  {}
---@return RiskGridInfo
function RiskGridInfo__Array_:add()end
---@alias RiskGridInfo__Array RiskGridInfo__Array_ | RiskGridInfo[]

---@class RiskBoxInfo__Array_
local RiskBoxInfo__Array_ =  {}
---@return RiskBoxInfo
function RiskBoxInfo__Array_:add()end
---@alias RiskBoxInfo__Array RiskBoxInfo__Array_ | RiskBoxInfo[]

---@class IdipPunishData__Array_
local IdipPunishData__Array_ =  {}
---@return IdipPunishData
function IdipPunishData__Array_:add()end
---@alias IdipPunishData__Array IdipPunishData__Array_ | IdipPunishData[]

---@class PlatNotice__Array_
local PlatNotice__Array_ =  {}
---@return PlatNotice
function PlatNotice__Array_:add()end
---@alias PlatNotice__Array PlatNotice__Array_ | PlatNotice[]

---@class TeamCountInfo__Array_
local TeamCountInfo__Array_ =  {}
---@return TeamCountInfo
function TeamCountInfo__Array_:add()end
---@alias TeamCountInfo__Array TeamCountInfo__Array_ | TeamCountInfo[]

---@class CampTaskInfo__Array_
local CampTaskInfo__Array_ =  {}
---@return CampTaskInfo
function CampTaskInfo__Array_:add()end
---@alias CampTaskInfo__Array CampTaskInfo__Array_ | CampTaskInfo[]

---@class SpriteInfo__Array_
local SpriteInfo__Array_ =  {}
---@return SpriteInfo
function SpriteInfo__Array_:add()end
---@alias SpriteInfo__Array SpriteInfo__Array_ | SpriteInfo[]

---@class SpActivityOne__Array_
local SpActivityOne__Array_ =  {}
---@return SpActivityOne
function SpActivityOne__Array_:add()end
---@alias SpActivityOne__Array SpActivityOne__Array_ | SpActivityOne[]

---@class ProfessionSkill__Array_
local ProfessionSkill__Array_ =  {}
---@return ProfessionSkill
function ProfessionSkill__Array_:add()end
---@alias ProfessionSkill__Array ProfessionSkill__Array_ | ProfessionSkill[]

---@class ProfessionLevelPair__Array_
local ProfessionLevelPair__Array_ =  {}
---@return ProfessionLevelPair
function ProfessionLevelPair__Array_:add()end
---@alias ProfessionLevelPair__Array ProfessionLevelPair__Array_ | ProfessionLevelPair[]

---@class SkillPlan__Array_
local SkillPlan__Array_ =  {}
---@return SkillPlan
function SkillPlan__Array_:add()end
---@alias SkillPlan__Array SkillPlan__Array_ | SkillPlan[]

---@class RiskOneMapInfo__Array_
local RiskOneMapInfo__Array_ =  {}
---@return RiskOneMapInfo
function RiskOneMapInfo__Array_:add()end
---@alias RiskOneMapInfo__Array RiskOneMapInfo__Array_ | RiskOneMapInfo[]

---@class EquipPage__Array_
local EquipPage__Array_ =  {}
---@return EquipPage
function EquipPage__Array_:add()end
---@alias EquipPage__Array EquipPage__Array_ | EquipPage[]

---@class WarehousePage__Array_
local WarehousePage__Array_ =  {}
---@return WarehousePage
function WarehousePage__Array_:add()end
---@alias WarehousePage__Array WarehousePage__Array_ | WarehousePage[]

---@class ShortcutData__Array_
local ShortcutData__Array_ =  {}
---@return ShortcutData
function ShortcutData__Array_:add()end
---@alias ShortcutData__Array ShortcutData__Array_ | ShortcutData[]

---@class Buff__Array_
local Buff__Array_ =  {}
---@return Buff
function Buff__Array_:add()end
---@alias Buff__Array Buff__Array_ | Buff[]

---@class BuffItem__Array_
local BuffItem__Array_ =  {}
---@return BuffItem
function BuffItem__Array_:add()end
---@alias BuffItem__Array BuffItem__Array_ | BuffItem[]

---@class MapIntItem__Array_
local MapIntItem__Array_ =  {}
---@return MapIntItem
function MapIntItem__Array_:add()end
---@alias MapIntItem__Array MapIntItem__Array_ | MapIntItem[]

---@class OneLiveRecordInfo__Array_
local OneLiveRecordInfo__Array_ =  {}
---@return OneLiveRecordInfo
function OneLiveRecordInfo__Array_:add()end
---@alias OneLiveRecordInfo__Array OneLiveRecordInfo__Array_ | OneLiveRecordInfo[]

---@class IBShopOneRecord__Array_
local IBShopOneRecord__Array_ =  {}
---@return IBShopOneRecord
function IBShopOneRecord__Array_:add()end
---@alias IBShopOneRecord__Array IBShopOneRecord__Array_ | IBShopOneRecord[]

---@class IBGiftOrder__Array_
local IBGiftOrder__Array_ =  {}
---@return IBGiftOrder
function IBGiftOrder__Array_:add()end
---@alias IBGiftOrder__Array IBGiftOrder__Array_ | IBGiftOrder[]

---@class PushInfo__Array_
local PushInfo__Array_ =  {}
---@return PushInfo
function PushInfo__Array_:add()end
---@alias PushInfo__Array PushInfo__Array_ | PushInfo[]

---@class PushConfig__Array_
local PushConfig__Array_ =  {}
---@return PushConfig
function PushConfig__Array_:add()end
---@alias PushConfig__Array PushConfig__Array_ | PushConfig[]

---@class PandoraDrop__Array_
local PandoraDrop__Array_ =  {}
---@return PandoraDrop
function PandoraDrop__Array_:add()end
---@alias PandoraDrop__Array PandoraDrop__Array_ | PandoraDrop[]

---@class ShopRecordOne__Array_
local ShopRecordOne__Array_ =  {}
---@return ShopRecordOne
function ShopRecordOne__Array_:add()end
---@alias ShopRecordOne__Array ShopRecordOne__Array_ | ShopRecordOne[]

---@class ExpFindBackInfo__Array_
local ExpFindBackInfo__Array_ =  {}
---@return ExpFindBackInfo
function ExpFindBackInfo__Array_:add()end
---@alias ExpFindBackInfo__Array ExpFindBackInfo__Array_ | ExpFindBackInfo[]

---@class ItemFindBackInfo__Array_
local ItemFindBackInfo__Array_ =  {}
---@return ItemFindBackInfo
function ItemFindBackInfo__Array_:add()end
---@alias ItemFindBackInfo__Array ItemFindBackInfo__Array_ | ItemFindBackInfo[]

---@class UnlockSealFindBackData__Array_
local UnlockSealFindBackData__Array_ =  {}
---@return UnlockSealFindBackData
function UnlockSealFindBackData__Array_:add()end
---@alias UnlockSealFindBackData__Array UnlockSealFindBackData__Array_ | UnlockSealFindBackData[]

---@class OnlyOnceGuildBonusData__Array_
local OnlyOnceGuildBonusData__Array_ =  {}
---@return OnlyOnceGuildBonusData
function OnlyOnceGuildBonusData__Array_:add()end
---@alias OnlyOnceGuildBonusData__Array OnlyOnceGuildBonusData__Array_ | OnlyOnceGuildBonusData[]

---@class atlasdata__Array_
local atlasdata__Array_ =  {}
---@return atlasdata
function atlasdata__Array_:add()end
---@alias atlasdata__Array atlasdata__Array_ | atlasdata[]

---@class FirstPassStageInfo__Array_
local FirstPassStageInfo__Array_ =  {}
---@return FirstPassStageInfo
function FirstPassStageInfo__Array_:add()end
---@alias FirstPassStageInfo__Array FirstPassStageInfo__Array_ | FirstPassStageInfo[]

---@class RoleSmallInfo__Array_
local RoleSmallInfo__Array_ =  {}
---@return RoleSmallInfo
function RoleSmallInfo__Array_:add()end
---@alias RoleSmallInfo__Array RoleSmallInfo__Array_ | RoleSmallInfo[]

---@class LiveNameInfo__Array_
local LiveNameInfo__Array_ =  {}
---@return LiveNameInfo
function LiveNameInfo__Array_:add()end
---@alias LiveNameInfo__Array LiveNameInfo__Array_ | LiveNameInfo[]

---@class HeroBattleOneGame__Array_
local HeroBattleOneGame__Array_ =  {}
---@return HeroBattleOneGame
function HeroBattleOneGame__Array_:add()end
---@alias HeroBattleOneGame__Array HeroBattleOneGame__Array_ | HeroBattleOneGame[]

---@class LoginReward__Array_
local LoginReward__Array_ =  {}
---@return LoginReward
function LoginReward__Array_:add()end
---@alias LoginReward__Array LoginReward__Array_ | LoginReward[]

---@class PkOneRec__Array_
local PkOneRec__Array_ =  {}
---@return PkOneRec
function PkOneRec__Array_:add()end
---@alias PkOneRec__Array PkOneRec__Array_ | PkOneRec[]

---@class WeekReportData__Array_
local WeekReportData__Array_ =  {}
---@return WeekReportData
function WeekReportData__Array_:add()end
---@alias WeekReportData__Array WeekReportData__Array_ | WeekReportData[]

---@class GuildSkill__Array_
local GuildSkill__Array_ =  {}
---@return GuildSkill
function GuildSkill__Array_:add()end
---@alias GuildSkill__Array GuildSkill__Array_ | GuildSkill[]

---@class StcDesignationInfo__Array_
local StcDesignationInfo__Array_ =  {}
---@return StcDesignationInfo
function StcDesignationInfo__Array_:add()end
---@alias StcDesignationInfo__Array StcDesignationInfo__Array_ | StcDesignationInfo[]

---@class StcAchieveInfo__Array_
local StcAchieveInfo__Array_ =  {}
---@return StcAchieveInfo
function StcAchieveInfo__Array_:add()end
---@alias StcAchieveInfo__Array StcAchieveInfo__Array_ | StcAchieveInfo[]

---@class STC_ACHIEVE_POINT_REWARD__Array_
local STC_ACHIEVE_POINT_REWARD__Array_ =  {}
---@return STC_ACHIEVE_POINT_REWARD
function STC_ACHIEVE_POINT_REWARD__Array_:add()end
---@alias STC_ACHIEVE_POINT_REWARD__Array STC_ACHIEVE_POINT_REWARD__Array_ | STC_ACHIEVE_POINT_REWARD[]

---@class PvpOneRec__Array_
local PvpOneRec__Array_ =  {}
---@return PvpOneRec
function PvpOneRec__Array_:add()end
---@alias PvpOneRec__Array PvpOneRec__Array_ | PvpOneRec[]

---@class PayPrivilegeShop__Array_
local PayPrivilegeShop__Array_ =  {}
---@return PayPrivilegeShop
function PayPrivilegeShop__Array_:add()end
---@alias PayPrivilegeShop__Array PayPrivilegeShop__Array_ | PayPrivilegeShop[]

---@class PkOneRecord__Array_
local PkOneRecord__Array_ =  {}
---@return PkOneRecord
function PkOneRecord__Array_:add()end
---@alias PkOneRecord__Array PkOneRecord__Array_ | PkOneRecord[]

---@class DragonRecord__Array_
local DragonRecord__Array_ =  {}
---@return DragonRecord
function DragonRecord__Array_:add()end
---@alias DragonRecord__Array DragonRecord__Array_ | DragonRecord[]

---@class PvpRoleBrief__Array_
local PvpRoleBrief__Array_ =  {}
---@return PvpRoleBrief
function PvpRoleBrief__Array_:add()end
---@alias PvpRoleBrief__Array PvpRoleBrief__Array_ | PvpRoleBrief[]

---@class PetSingle__Array_
local PetSingle__Array_ =  {}
---@return PetSingle
function PetSingle__Array_:add()end
---@alias PetSingle__Array PetSingle__Array_ | PetSingle[]

---@class RewardInfo__Array_
local RewardInfo__Array_ =  {}
---@return RewardInfo
function RewardInfo__Array_:add()end
---@alias RewardInfo__Array RewardInfo__Array_ | RewardInfo[]

---@class AbsPartyBase__Array_
local AbsPartyBase__Array_ =  {}
---@return AbsPartyBase
function AbsPartyBase__Array_:add()end
---@alias AbsPartyBase__Array AbsPartyBase__Array_ | AbsPartyBase[]

---@class TShowRoleDailyVoteData__Array_
local TShowRoleDailyVoteData__Array_ =  {}
---@return TShowRoleDailyVoteData
function TShowRoleDailyVoteData__Array_:add()end
---@alias TShowRoleDailyVoteData__Array TShowRoleDailyVoteData__Array_ | TShowRoleDailyVoteData[]

---@class CrossRoleInfo__Array_
local CrossRoleInfo__Array_ =  {}
---@return CrossRoleInfo
function CrossRoleInfo__Array_:add()end
---@alias CrossRoleInfo__Array CrossRoleInfo__Array_ | CrossRoleInfo[]

---@class RoleSummaryStored__Array_
local RoleSummaryStored__Array_ =  {}
---@return RoleSummaryStored
function RoleSummaryStored__Array_:add()end
---@alias RoleSummaryStored__Array RoleSummaryStored__Array_ | RoleSummaryStored[]

---@class RoleBuff__Array_
local RoleBuff__Array_ =  {}
---@return RoleBuff
function RoleBuff__Array_:add()end
---@alias RoleBuff__Array RoleBuff__Array_ | RoleBuff[]

---@class PkRoleInfo__Array_
local PkRoleInfo__Array_ =  {}
---@return PkRoleInfo
function PkRoleInfo__Array_:add()end
---@alias PkRoleInfo__Array PkRoleInfo__Array_ | PkRoleInfo[]

---@class PayMember__Array_
local PayMember__Array_ =  {}
---@return PayMember
function PayMember__Array_:add()end
---@alias PayMember__Array PayMember__Array_ | PayMember[]

---@class TeamSynMember__Array_
local TeamSynMember__Array_ =  {}
---@return TeamSynMember
function TeamSynMember__Array_:add()end
---@alias TeamSynMember__Array TeamSynMember__Array_ | TeamSynMember[]

---@class RoleArenaRecordInfo__Array_
local RoleArenaRecordInfo__Array_ =  {}
---@return RoleArenaRecordInfo
function RoleArenaRecordInfo__Array_:add()end
---@alias RoleArenaRecordInfo__Array RoleArenaRecordInfo__Array_ | RoleArenaRecordInfo[]

---@class PvpRoleInfo__Array_
local PvpRoleInfo__Array_ =  {}
---@return PvpRoleInfo
function PvpRoleInfo__Array_:add()end
---@alias PvpRoleInfo__Array PvpRoleInfo__Array_ | PvpRoleInfo[]

---@class PkMatchStage__Array_
local PkMatchStage__Array_ =  {}
---@return PkMatchStage
function PkMatchStage__Array_:add()end
---@alias PkMatchStage__Array PkMatchStage__Array_ | PkMatchStage[]

---@class SceneGardenSlot__Array_
local SceneGardenSlot__Array_ =  {}
---@return SceneGardenSlot
function SceneGardenSlot__Array_:add()end
---@alias SceneGardenSlot__Array SceneGardenSlot__Array_ | SceneGardenSlot[]

---@class GCFGuildGroup__Array_
local GCFGuildGroup__Array_ =  {}
---@return GCFGuildGroup
function GCFGuildGroup__Array_:add()end
---@alias GCFGuildGroup__Array GCFGuildGroup__Array_ | GCFGuildGroup[]

---@class SkyCityTeamBaseInfo__Array_
local SkyCityTeamBaseInfo__Array_ =  {}
---@return SkyCityTeamBaseInfo
function SkyCityTeamBaseInfo__Array_:add()end
---@alias SkyCityTeamBaseInfo__Array SkyCityTeamBaseInfo__Array_ | SkyCityTeamBaseInfo[]

---@class SCRoleStatistics__Array_
local SCRoleStatistics__Array_ =  {}
---@return SCRoleStatistics
function SCRoleStatistics__Array_:add()end
---@alias SCRoleStatistics__Array SCRoleStatistics__Array_ | SCRoleStatistics[]

---@class LeagueBattleRoleBrief__Array_
local LeagueBattleRoleBrief__Array_ =  {}
---@return LeagueBattleRoleBrief
function LeagueBattleRoleBrief__Array_:add()end
---@alias LeagueBattleRoleBrief__Array LeagueBattleRoleBrief__Array_ | LeagueBattleRoleBrief[]

---@class KMatchRole__Array_
local KMatchRole__Array_ =  {}
---@return KMatchRole
function KMatchRole__Array_:add()end
---@alias KMatchRole__Array KMatchRole__Array_ | KMatchRole[]

---@class ResWarTeamBaseInfo__Array_
local ResWarTeamBaseInfo__Array_ =  {}
---@return ResWarTeamBaseInfo
function ResWarTeamBaseInfo__Array_:add()end
---@alias ResWarTeamBaseInfo__Array ResWarTeamBaseInfo__Array_ | ResWarTeamBaseInfo[]

---@class InvFightUnit__Array_
local InvFightUnit__Array_ =  {}
---@return InvFightUnit
function InvFightUnit__Array_:add()end
---@alias InvFightUnit__Array InvFightUnit__Array_ | InvFightUnit[]

---@class SkyCraftRoleBrief__Array_
local SkyCraftRoleBrief__Array_ =  {}
---@return SkyCraftRoleBrief
function SkyCraftRoleBrief__Array_:add()end
---@alias SkyCraftRoleBrief__Array SkyCraftRoleBrief__Array_ | SkyCraftRoleBrief[]

---@class KMatchUnit__Array_
local KMatchUnit__Array_ =  {}
---@return KMatchUnit
function KMatchUnit__Array_:add()end
---@alias KMatchUnit__Array KMatchUnit__Array_ | KMatchUnit[]

---@class BMRoleEnter__Array_
local BMRoleEnter__Array_ =  {}
---@return BMRoleEnter
function BMRoleEnter__Array_:add()end
---@alias BMRoleEnter__Array BMRoleEnter__Array_ | BMRoleEnter[]

---@class RoleInfoOnMs__Array_
local RoleInfoOnMs__Array_ =  {}
---@return RoleInfoOnMs
function RoleInfoOnMs__Array_:add()end
---@alias RoleInfoOnMs__Array RoleInfoOnMs__Array_ | RoleInfoOnMs[]

---@class AccountRole__Array_
local AccountRole__Array_ =  {}
---@return AccountRole
function AccountRole__Array_:add()end
---@alias AccountRole__Array AccountRole__Array_ | AccountRole[]

---@class FMWhiteRoleData__Array_
local FMWhiteRoleData__Array_ =  {}
---@return FMWhiteRoleData
function FMWhiteRoleData__Array_:add()end
---@alias FMWhiteRoleData__Array FMWhiteRoleData__Array_ | FMWhiteRoleData[]

---@class MercenaryStatusToMsData__Array_
local MercenaryStatusToMsData__Array_ =  {}
---@return MercenaryStatusToMsData
function MercenaryStatusToMsData__Array_:add()end
---@alias MercenaryStatusToMsData__Array MercenaryStatusToMsData__Array_ | MercenaryStatusToMsData[]

---@class TargetHurtInfo__Array_
local TargetHurtInfo__Array_ =  {}
---@return TargetHurtInfo
function TargetHurtInfo__Array_:add()end
---@alias TargetHurtInfo__Array TargetHurtInfo__Array_ | TargetHurtInfo[]

---@class SkillPointData__Array_
local SkillPointData__Array_ =  {}
---@return SkillPointData
function SkillPointData__Array_:add()end
---@alias SkillPointData__Array SkillPointData__Array_ | SkillPointData[]

---@class PerSkillPoint__Array_
local PerSkillPoint__Array_ =  {}
---@return PerSkillPoint
function PerSkillPoint__Array_:add()end
---@alias PerSkillPoint__Array PerSkillPoint__Array_ | PerSkillPoint[]

---@class AttrCompareInfo__Array_
local AttrCompareInfo__Array_ =  {}
---@return AttrCompareInfo
function AttrCompareInfo__Array_:add()end
---@alias AttrCompareInfo__Array AttrCompareInfo__Array_ | AttrCompareInfo[]

---@class AttrAddInfo__Array_
local AttrAddInfo__Array_ =  {}
---@return AttrAddInfo
function AttrAddInfo__Array_:add()end
---@alias AttrAddInfo__Array AttrAddInfo__Array_ | AttrAddInfo[]

---@class QualityPointInfo__Array_
local QualityPointInfo__Array_ =  {}
---@return QualityPointInfo
function QualityPointInfo__Array_:add()end
---@alias QualityPointInfo__Array QualityPointInfo__Array_ | QualityPointInfo[]

---@class QualityPointPageInfo__Array_
local QualityPointPageInfo__Array_ =  {}
---@return QualityPointPageInfo
function QualityPointPageInfo__Array_:add()end
---@alias QualityPointPageInfo__Array QualityPointPageInfo__Array_ | QualityPointPageInfo[]

---@class TaskDoneInfo__Array_
local TaskDoneInfo__Array_ =  {}
---@return TaskDoneInfo
function TaskDoneInfo__Array_:add()end
---@alias TaskDoneInfo__Array TaskDoneInfo__Array_ | TaskDoneInfo[]

---@class ArenaRoomInfo__Array_
local ArenaRoomInfo__Array_ =  {}
---@return ArenaRoomInfo
function ArenaRoomInfo__Array_:add()end
---@alias ArenaRoomInfo__Array ArenaRoomInfo__Array_ | ArenaRoomInfo[]

---@class CounterUIntPair__Array_
local CounterUIntPair__Array_ =  {}
---@return CounterUIntPair
function CounterUIntPair__Array_:add()end
---@alias CounterUIntPair__Array CounterUIntPair__Array_ | CounterUIntPair[]

---@class ShopItemBrief__Array_
local ShopItemBrief__Array_ =  {}
---@return ShopItemBrief
function ShopItemBrief__Array_:add()end
---@alias ShopItemBrief__Array ShopItemBrief__Array_ | ShopItemBrief[]

---@class ShopItems__Array_
local ShopItems__Array_ =  {}
---@return ShopItems
function ShopItems__Array_:add()end
---@alias ShopItems__Array ShopItems__Array_ | ShopItems[]

---@class SysOpenRecord__Array_
local SysOpenRecord__Array_ =  {}
---@return SysOpenRecord
function SysOpenRecord__Array_:add()end
---@alias SysOpenRecord__Array SysOpenRecord__Array_ | SysOpenRecord[]

---@class ThemeDungeonsInfo__Array_
local ThemeDungeonsInfo__Array_ =  {}
---@return ThemeDungeonsInfo
function ThemeDungeonsInfo__Array_:add()end
---@alias ThemeDungeonsInfo__Array ThemeDungeonsInfo__Array_ | ThemeDungeonsInfo[]

---@class MemberPosInfo__Array_
local MemberPosInfo__Array_ =  {}
---@return MemberPosInfo
function MemberPosInfo__Array_:add()end
---@alias MemberPosInfo__Array MemberPosInfo__Array_ | MemberPosInfo[]

---@class AttributeInfo__Array_
local AttributeInfo__Array_ =  {}
---@return AttributeInfo
function AttributeInfo__Array_:add()end
---@alias AttributeInfo__Array AttributeInfo__Array_ | AttributeInfo[]

---@class CookDungeonsInfo__Array_
local CookDungeonsInfo__Array_ =  {}
---@return CookDungeonsInfo
function CookDungeonsInfo__Array_:add()end
---@alias CookDungeonsInfo__Array CookDungeonsInfo__Array_ | CookDungeonsInfo[]

---@class SkillResultSyncInfo__Array_
local SkillResultSyncInfo__Array_ =  {}
---@return SkillResultSyncInfo
function SkillResultSyncInfo__Array_:add()end
---@alias SkillResultSyncInfo__Array SkillResultSyncInfo__Array_ | SkillResultSyncInfo[]

---@class ModuleModifyTime__Array_
local ModuleModifyTime__Array_ =  {}
---@return ModuleModifyTime
function ModuleModifyTime__Array_:add()end
---@alias ModuleModifyTime__Array ModuleModifyTime__Array_ | ModuleModifyTime[]

---@class UnitDisappear__Array_
local UnitDisappear__Array_ =  {}
---@return UnitDisappear
function UnitDisappear__Array_:add()end
---@alias UnitDisappear__Array UnitDisappear__Array_ | UnitDisappear[]

---@class GuaranteeClass__Array_
local GuaranteeClass__Array_ =  {}
---@return GuaranteeClass
function GuaranteeClass__Array_:add()end
---@alias GuaranteeClass__Array GuaranteeClass__Array_ | GuaranteeClass[]

---@class MapPairKeyIntValue__Array_
local MapPairKeyIntValue__Array_ =  {}
---@return MapPairKeyIntValue
function MapPairKeyIntValue__Array_:add()end
---@alias MapPairKeyIntValue__Array MapPairKeyIntValue__Array_ | MapPairKeyIntValue[]

---@class LifeSkillInfo__Array_
local LifeSkillInfo__Array_ =  {}
---@return LifeSkillInfo
function LifeSkillInfo__Array_:add()end
---@alias LifeSkillInfo__Array LifeSkillInfo__Array_ | LifeSkillInfo[]

---@class LifeEquipInfo__Array_
local LifeEquipInfo__Array_ =  {}
---@return LifeEquipInfo
function LifeEquipInfo__Array_:add()end
---@alias LifeEquipInfo__Array LifeEquipInfo__Array_ | LifeEquipInfo[]

---@class LifeEquipAddInfo__Array_
local LifeEquipAddInfo__Array_ =  {}
---@return LifeEquipAddInfo
function LifeEquipAddInfo__Array_:add()end
---@alias LifeEquipAddInfo__Array LifeEquipAddInfo__Array_ | LifeEquipAddInfo[]

---@class FreqWords__Array_
local FreqWords__Array_ =  {}
---@return FreqWords
function FreqWords__Array_:add()end
---@alias FreqWords__Array FreqWords__Array_ | FreqWords[]

---@class CompleteInfo__Array_
local CompleteInfo__Array_ =  {}
---@return CompleteInfo
function CompleteInfo__Array_:add()end
---@alias CompleteInfo__Array CompleteInfo__Array_ | CompleteInfo[]

---@class AchievementStepInfo__Array_
local AchievementStepInfo__Array_ =  {}
---@return AchievementStepInfo
function AchievementStepInfo__Array_:add()end
---@alias AchievementStepInfo__Array AchievementStepInfo__Array_ | AchievementStepInfo[]

---@class MonsterSingleInfo__Array_
local MonsterSingleInfo__Array_ =  {}
---@return MonsterSingleInfo
function MonsterSingleInfo__Array_:add()end
---@alias MonsterSingleInfo__Array MonsterSingleInfo__Array_ | MonsterSingleInfo[]

---@class MonsterGroupInfo__Array_
local MonsterGroupInfo__Array_ =  {}
---@return MonsterGroupInfo
function MonsterGroupInfo__Array_:add()end
---@alias MonsterGroupInfo__Array MonsterGroupInfo__Array_ | MonsterGroupInfo[]

---@class RevenueStatisticsPbInfo__Array_
local RevenueStatisticsPbInfo__Array_ =  {}
---@return RevenueStatisticsPbInfo
function RevenueStatisticsPbInfo__Array_:add()end
---@alias RevenueStatisticsPbInfo__Array RevenueStatisticsPbInfo__Array_ | RevenueStatisticsPbInfo[]

---@class BlessExpNode__Array_
local BlessExpNode__Array_ =  {}
---@return BlessExpNode
function BlessExpNode__Array_:add()end
---@alias BlessExpNode__Array BlessExpNode__Array_ | BlessExpNode[]

---@class RoleWorldEventNewPair__Array_
local RoleWorldEventNewPair__Array_ =  {}
---@return RoleWorldEventNewPair
function RoleWorldEventNewPair__Array_:add()end
---@alias RoleWorldEventNewPair__Array RoleWorldEventNewPair__Array_ | RoleWorldEventNewPair[]

---@class CatTradeTrainDbInfo__Array_
local CatTradeTrainDbInfo__Array_ =  {}
---@return CatTradeTrainDbInfo
function CatTradeTrainDbInfo__Array_:add()end
---@alias CatTradeTrainDbInfo__Array CatTradeTrainDbInfo__Array_ | CatTradeTrainDbInfo[]

---@class CatTradeTrainSeatDbInfo__Array_
local CatTradeTrainSeatDbInfo__Array_ =  {}
---@return CatTradeTrainSeatDbInfo
function CatTradeTrainSeatDbInfo__Array_:add()end
---@alias CatTradeTrainSeatDbInfo__Array CatTradeTrainSeatDbInfo__Array_ | CatTradeTrainSeatDbInfo[]

---@class HeroChallengeSingleRecord__Array_
local HeroChallengeSingleRecord__Array_ =  {}
---@return HeroChallengeSingleRecord
function HeroChallengeSingleRecord__Array_:add()end
---@alias HeroChallengeSingleRecord__Array HeroChallengeSingleRecord__Array_ | HeroChallengeSingleRecord[]

---@class MedalInfo__Array_
local MedalInfo__Array_ =  {}
---@return MedalInfo
function MedalInfo__Array_:add()end
---@alias MedalInfo__Array MedalInfo__Array_ | MedalInfo[]

---@class BanRoleData__Array_
local BanRoleData__Array_ =  {}
---@return BanRoleData
function BanRoleData__Array_:add()end
---@alias BanRoleData__Array BanRoleData__Array_ | BanRoleData[]

---@class ConsumeBillData__Array_
local ConsumeBillData__Array_ =  {}
---@return ConsumeBillData
function ConsumeBillData__Array_:add()end
---@alias ConsumeBillData__Array ConsumeBillData__Array_ | ConsumeBillData[]

---@class DelegationData__Array_
local DelegationData__Array_ =  {}
---@return DelegationData
function DelegationData__Array_:add()end
---@alias DelegationData__Array DelegationData__Array_ | DelegationData[]

---@class IdipEntryTableId__Array_
local IdipEntryTableId__Array_ =  {}
---@return IdipEntryTableId
function IdipEntryTableId__Array_:add()end
---@alias IdipEntryTableId__Array IdipEntryTableId__Array_ | IdipEntryTableId[]

---@class EachMallRecord__Array_
local EachMallRecord__Array_ =  {}
---@return EachMallRecord
function EachMallRecord__Array_:add()end
---@alias EachMallRecord__Array EachMallRecord__Array_ | EachMallRecord[]

---@class EachPoolRecord__Array_
local EachPoolRecord__Array_ =  {}
---@return EachPoolRecord
function EachPoolRecord__Array_:add()end
---@alias EachPoolRecord__Array EachPoolRecord__Array_ | EachPoolRecord[]

---@class MallServerItem__Array_
local MallServerItem__Array_ =  {}
---@return MallServerItem
function MallServerItem__Array_:add()end
---@alias MallServerItem__Array MallServerItem__Array_ | MallServerItem[]

---@class GuildAuctionRecordPerson__Array_
local GuildAuctionRecordPerson__Array_ =  {}
---@return GuildAuctionRecordPerson
function GuildAuctionRecordPerson__Array_:add()end
---@alias GuildAuctionRecordPerson__Array GuildAuctionRecordPerson__Array_ | GuildAuctionRecordPerson[]

---@class SkillSlots__Array_
local SkillSlots__Array_ =  {}
---@return SkillSlots
function SkillSlots__Array_:add()end
---@alias SkillSlots__Array SkillSlots__Array_ | SkillSlots[]

---@class TempVehicleExpireTime__Array_
local TempVehicleExpireTime__Array_ =  {}
---@return TempVehicleExpireTime
function TempVehicleExpireTime__Array_:add()end
---@alias TempVehicleExpireTime__Array TempVehicleExpireTime__Array_ | TempVehicleExpireTime[]

---@class VehicleOutlook__Array_
local VehicleOutlook__Array_ =  {}
---@return VehicleOutlook
function VehicleOutlook__Array_:add()end
---@alias VehicleOutlook__Array VehicleOutlook__Array_ | VehicleOutlook[]

---@class KeyValue32__Array_
local KeyValue32__Array_ =  {}
---@return KeyValue32
function KeyValue32__Array_:add()end
---@alias KeyValue32__Array KeyValue32__Array_ | KeyValue32[]

---@class VitalData__Array_
local VitalData__Array_ =  {}
---@return VitalData
function VitalData__Array_:add()end
---@alias VitalData__Array VitalData__Array_ | VitalData[]

---@class CommondataPair__Array_
local CommondataPair__Array_ =  {}
---@return CommondataPair
function CommondataPair__Array_:add()end
---@alias CommondataPair__Array CommondataPair__Array_ | CommondataPair[]

---@class ReveItemPb__Array_
local ReveItemPb__Array_ =  {}
---@return ReveItemPb
function ReveItemPb__Array_:add()end
---@alias ReveItemPb__Array ReveItemPb__Array_ | ReveItemPb[]

---@class ExtraCardInfoRecord__Array_
local ExtraCardInfoRecord__Array_ =  {}
---@return ExtraCardInfoRecord
function ExtraCardInfoRecord__Array_:add()end
---@alias ExtraCardInfoRecord__Array ExtraCardInfoRecord__Array_ | ExtraCardInfoRecord[]

---@class WatchDungeonMember__Array_
local WatchDungeonMember__Array_ =  {}
---@return WatchDungeonMember
function WatchDungeonMember__Array_:add()end
---@alias WatchDungeonMember__Array WatchDungeonMember__Array_ | WatchDungeonMember[]

---@class WatchDungeonTeam__Array_
local WatchDungeonTeam__Array_ =  {}
---@return WatchDungeonTeam
function WatchDungeonTeam__Array_:add()end
---@alias WatchDungeonTeam__Array WatchDungeonTeam__Array_ | WatchDungeonTeam[]

---@class WatchUnitInfo__Array_
local WatchUnitInfo__Array_ =  {}
---@return WatchUnitInfo
function WatchUnitInfo__Array_:add()end
---@alias WatchUnitInfo__Array WatchUnitInfo__Array_ | WatchUnitInfo[]

---@class WatchedRoleBoardInfo__Array_
local WatchedRoleBoardInfo__Array_ =  {}
---@return WatchedRoleBoardInfo
function WatchedRoleBoardInfo__Array_:add()end
---@alias WatchedRoleBoardInfo__Array WatchedRoleBoardInfo__Array_ | WatchedRoleBoardInfo[]

---@class CampFlower__Array_
local CampFlower__Array_ =  {}
---@return CampFlower
function CampFlower__Array_:add()end
---@alias CampFlower__Array CampFlower__Array_ | CampFlower[]

---@class WatchedRoleBrief__Array_
local WatchedRoleBrief__Array_ =  {}
---@return WatchedRoleBrief
function WatchedRoleBrief__Array_:add()end
---@alias WatchedRoleBrief__Array WatchedRoleBrief__Array_ | WatchedRoleBrief[]

---@class HourWeatherData__Array_
local HourWeatherData__Array_ =  {}
---@return HourWeatherData
function HourWeatherData__Array_:add()end
---@alias HourWeatherData__Array HourWeatherData__Array_ | HourWeatherData[]

---@class GMWeatherData__Array_
local GMWeatherData__Array_ =  {}
---@return GMWeatherData
function GMWeatherData__Array_:add()end
---@alias GMWeatherData__Array GMWeatherData__Array_ | GMWeatherData[]

---@class SceneWeather__Array_
local SceneWeather__Array_ =  {}
---@return SceneWeather
function SceneWeather__Array_:add()end
---@alias SceneWeather__Array SceneWeather__Array_ | SceneWeather[]

---@class WeatherEventData__Array_
local WeatherEventData__Array_ =  {}
---@return WeatherEventData
function WeatherEventData__Array_:add()end
---@alias WeatherEventData__Array WeatherEventData__Array_ | WeatherEventData[]

---@class WorldEventDB__Array_
local WorldEventDB__Array_ =  {}
---@return WorldEventDB
function WorldEventDB__Array_:add()end
---@alias WorldEventDB__Array WorldEventDB__Array_ | WorldEventDB[]


