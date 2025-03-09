--- 主要用于保存一些定义过的类的注解

---@class ItemConvertedData @有的地方需要转换背包道具数据，还不知道为什么需要转换这部分数据
---@field id number
---@field name string
---@field uid string
---@field num number
---@field is_bind boolean

---@class ItemTipsParam @itemTips当中使用的数据参数类型
---@field baseData ItemData,
---@field equipTableData EquipTable
---@field itemTableData ItemTable
---@field itemFunctionData ItemFunctionTable
---@field equipStatus number
---@field buttonStatus number

---@class BaseTemplateParam @BaseTemp的的参数
---@field TemplatePrefab
---@field TemplatePath
---@field TemplateParent
---@field IsActive
---@field Data
---@field LoadCallback
---@field IsUsePool

---@class GiftItemData @礼物数据
---@field Item ItemData
---@field count number

---@class SingleContDataConfig @背包系统用的同步类
---@field ContType string
---@field ItemTable Item[]

--- 商店用的数据
---@class SellData
---@field propInfo ItemData
---@field count number

---@class RangePair
---@field startPos number
---@field endPos number

---@class SkillUIData
---@field openType number
---@field position table
---@field data SkillUIAttrData

---@class SkillUIAttrData
---@field type number
---@field id number

--- 属性相关的UI显示数据
---@class AttrDisplayData
---@field name string
---@field value string

--- 附魔属性显示的颜色配置
---@class EnchantAttrColorConfig
---@field colorTag string
---@field showStar boolean
---@field isBuff boolean

---@class EnchantPreviewAttrConfig
---@field EquipEnchantTableInfos EquipEnchantTable[]
---@field IsCommonEnchant boolean

--- 工会排名积分需要的数据
---@class GuildRankScoreData
---@field rank number
---@field score number
---@field atlasName string
---@field spriteName string
---@field desc string
---@field name string @名字显示
---@field isOpening boolean

--- 工会排名奖杯需要的数据，主要是UI上p
---@class GuildRankTrophyData
---@field rank number
---@field desc string
---@field spName string
---@field atlasName string
---@field rankDesc string

--- 工会排行榜页面根据页面当前状态组合成的参数
---@class GuildRankPageState
---@field pageState number
---@field typeState number
---@field needRefresh boolean

---@class GuildRankDataWrap
---@field guildRankData GuildRankData @工会排名数据
---@field onSetDataCb function(table, number) @回调方法
---@field onSetDataSelf table @ 回调方法的self

---@class CountDownUtilParam
---@field totalTime number
---@field interval number
---@field callback function
---@field callbackSelf function
---@field clearCallback function
---@field clearCallbackSelf function

---@class ItemIdCountPair @道具ID，数量对
---@field id number
---@field count number

---@class CookingUpdateItemData
---@field ID number
---@field Count number

---@class RefineTransTargetData
---@field targetItem ItemData
---@field currentSelectTid number

---@class RoColor
---@field r number
---@field g number
---@field b number
---@field a number

---@class CardRecastUIParam
---@field itemData ItemData
---@field targetIdx number

---@class ForgeSchoolTemplateParam
---@field config ProfessionTextTable
---@field onSelectItem function<number>
---@field onSelectItemSelf table
---@field currentSelectedID number
---@field matchState number

---@class EnchantAttrPair
---@field pos number
---@field attr ItemAttrData

---@class AttrCompareListParam @对比属性用的面板的参数
---@field attrs string[]
---@field showType number
---@field showName string
---@field showStar boolean

---@class RefineAttrParam @精炼属性
---@field name string
---@field value string
---@field desc string

---@class EquipAttrPair @词条属性
---@field desc string
---@field isRare boolean
---@class TeamMatchParam
---@field state number @页面状态，主要是区分是通过什么东西进来的
---@field dungeonID number @副本ID
---@field profession number @传入进来的职业
---@field memberInfoList number[] @玩家数据
---@field wantKLeader boolean @是否愿意成为队长

---@class TeamDutyShowPair @ 记录职责和显示状态对应关系
---@field dutyID number
---@field active boolean

---@class TeamPlayerOptionRecord @ 记录角色的UID和创建时间
---@field playerUidStr string
---@field createTime number

---@class TeamDutyTemplateParam @UI模板参数
---@field dutyOption TeamDutyShowPair
---@field onTogChange function<number>
---@field onTogChangeSelf table
---@field canPick boolean

---@class TeamIconParam @队伍当中职责和头像数据
---@field iconData TeamMemberBriefInfo
---@field dutyID number
---@field onDutyChangeCb function<number, number>
---@field onDutyChangeCbSelf table
---@field isEmptyPos boolean
---@field canpick boolean

---@class TeamMemberBriefInfo @队员的简要信息
---@field roleBriefInfo table
---@field roleLevel number
---@field roleName number

---@class TeamSingleSlotOption @对队伍的空位选择弹出对话框后的参数
---@field showIdx number
---@field onDutySelected function<number, number>
---@field onDutySelectSelf table

---@class ROPos @位置
---@field x number
---@field y number
---@field z number

---@class ContainerWeightPair @背包重量对
---@field currentWeight number
---@field maxWeight number

---@class IdxPair
---@field idxLeft number
---@field idxRight number

---@class EquipSlotUICache @背包页上的缓存数据
---@field slotType number
---@field itemData ItemData
---@field showSlot boolean

---@class ItemUpdateCompareData
---@field uid uint64
---@field id number
---@field count int64

---@class EquipAssistBgParam
---@field mainPageType string
---@field isDefault boolean
---@field HandlerName string
---@field pageConfig table

---@class FrameShowData @头像框数据
---@field config PhotoFrameTable
---@field state number @表示状态，有三种的，未激活，已激活，正在使用
---@field newIconFrame boolean @是否显示新
---@field timeLimited boolean @是否是限时道具
---@field expireTime number @过期时间

---@class FrameShowDataWrap @头像数据包装，主要是包装方法和数据
---@field showData FrameShowData
---@field onHeadFrameSelected function<table, number, number>
---@field onSelectedSelf table

---@class DialogBgShowData @气泡框显示数据
---@field config DialogBgTable
---@field state number @表示状态，有三种的，未激活，已激活，正在使用
---@field newTag boolean @是否是新的标记
---@field timeLimited boolean @是否是限时道具
---@field expireTime number @过期时间

---@class DialogBgShowDataWrap @数据包装
---@field showData DialogBgShowData
---@field onSelected function<number>
---@field onSelectedSelf table

---@class HandlerConfig
---@field systemID number
---@field handlerName string
---@field handlerTitle string
---@field ctrlName string
---@field selectSpName string
---@field unSelectSpName string

---@class ChatTagData @聊天标签的数据类型
---@field config DialogTabTable
---@field state number

---@class ChatTagDataWrap @聊天标签的UI包装
---@field data ChatTagData
---@field onClick function
---@field onClickSelf table

---@class HeadTemplateParam @头像相关的参数
---@field ShowName boolean
---@field ShowMask boolean
---@field ShowLv boolean
---@field ShowProfession boolean
---@field ShowBg boolean
---@field ShowFrame boolean
---@field IsPlayerSelf boolean
---@field Name string
---@field Level number
---@field Profession number
---@field IsMale boolean
---@field HeadIconID number
---@field EyeID number
---@field EyeColorID number
---@field HairID number
---@field FashionID number
---@field FrameID number
---@field HelmetID number
---@field FaceMaskID number
---@field MouthGearID number
---@field Entity userdata
---@field EquipData userdata
---@field MonsterHeadID number
---@field NpcHeadID number
---@field OnClick function
---@field OnClickSelf table
---@field OnClickEvent table

---@class TitleNameColorGroup
---@field TxtColor string
---@field OutLineColor string

---@class EquipRange
---@field LowLv number
---@field HighLv number

---@class EquipRangeCondData @装备碎片兑换筛选的参数
---@field EquipRangeData EquipRange
---@field EquipID number

---@class EquipShardRequireData
---@field Item ItemData
---@field CurrentCount int64
---@field RequireCount number

---@class EquipShardDataWrap @商店碎片的数据包装，主要是再UI当中使用的
---@field EquipShardData EquipShardDataPack
---@field OnSelected function<EquipShardDataPack, number>
---@field OnSelectedSelf table

---@class EquipShardDataPack
---@field MainData ItemData
---@field ShopItemID number
---@field RequireItems EquipShardRequireData[]

---@class MonsterBookUpdateParam
---@field Type number
---@field MonsterID number
---@field MonsterGroup number
---@field MonsterType number

---@class MonsterRedSignData
---@field Type number
---@field Group number
---@field CanGetLv number

---@class ForgeItemData
---@field Item ItemData
---@field Count number

---@class BattleFieldKDA @战场击杀数数据
---@field PlayerID uint64
---@field Kill number
---@field Death number
---@field AssistKill number

---@class GameHelpData @GameHelp界面上对应的数据
---@field title string
---@field content string
---@field btnName string
---@field onClick function

---@class VideoPlayerData
---@field title string
---@field path string
---@field eventName string

---@class BattleFieldTagData @ 战场结算界面的标签类型
---@field tagType number

---@class BattleFieldEndSinglePlayerData @ 战场结算界面单个玩家显示数据
---@field PlayerPro number
---@field PlayerName string
---@field TagList number[]
---@field KillNum number
---@field AssistNum number
---@field IsMvp boolean
---@field Score number
---@field OnAddFriendClick function
---@field OnAddFriendClickSelf table
---@field OnLikeClick function
---@field OnLikeClickSelf table
---@field PlayerUID uint64
---@field PlayerEquipData MoonClient.MEquipData

---@class BattleFieldResultData @ 界面上的东西
---@field id uint64
---@field score number
---@field kill number
---@field help number
---@field damage number
---@field heal number

---@class BattleFieldResultDataPack @ 战场结算数据包装
---@field teamA BattleFieldResultData[]
---@field teamB BattleFieldResultData[]

---@class ResultPanelData @ 副本或者战场结算通用界面数据
---@field Win boolean
---@field IsAssist boolean
---@field ItemDataList ItemData[]
---@field CanClickSkip boolean
---@field OnClick function
---@field OnClickSelf table
---@field DefaultCloseTime number
---@field PassTime number @ 结算界面上有一个显示时间

---@class EnchantInheritNewEquipPanelData @ 附魔解成界面当中点击右侧选择新装备的时候弹窗所需要的数据
---@field ItemList ItemData[]
---@field OnClose function
---@field OnCloseSelf table

--- 商店数据离线表
---@type table<number, table<number, ShopDataPack>>
ShopOffLineMap = {}

--- 装备图纸兑换材料离线表
---@type table<number, number>
EquipShardMatOffLineMap = {}

--- 道具ID 对职业离线表
---@type table<number, table<number, number>>
ItemProOffLineMap = {}

--- 魔物图鉴全数据离线表
---@type table<number, table<number, SingleMonsterFullData[]>>
MonsterBookFullData = {}

--- 根据父职业ID匹配子职业
---@type table<number, table<number, number>>
ProOfflineMap = {}

--- 根据子职业匹配父职业
---@type table<number, table<number, number>>
ProOfflineReverseMap = {}

---@class AttrOfflineExtraParam
---@field ID number
---@field Value number
---@field MaxValue number
---@field RareValue number
---@field RandomType number
---@field Name string

---@class AttrOfflineData
---@field Type number
---@field ID number
---@field Value number
---@field MaxValue number
---@field RareValue number
---@field AttrIdx number
---@field EquipTextID number
---@field OverrideType number
---@field RandomType number
---@field ParamList AttrOfflineExtraParam[]

---@type table<number, table<number, AttrOfflineData[]>>
ItemAttrOffLineData = {}