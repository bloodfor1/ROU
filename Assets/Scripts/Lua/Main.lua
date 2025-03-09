-- lua垃圾回收设置
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 5000)

-- MGameContext = MoonCommonLib.MGameContext
-- local old_require = require

-- require = function(module)
--     old_require(module)
--     old_require(tostring(MGameContext.CurrentChannel).."/"..module)
-- end

require "Common/define"
require "Common/Log"
require "Common/class"
require "Common/Bit32"
require "Common/Functions"
require "Common/Utils"
require "Common/Expand"
require "Common/TimeMgr"
require "Table/TableMgr"
require "3rd/lua_hotupdate-master/luahotupdate"
require "Network/Network_Pb"

local reloadLua = true

-- 准备配表
function PrepairTable()
    local l_tables = {
        "GlobalTable",
        "SpecialDeviceTable",
        "EquipEnchantConsumeTable",
        "TdWaveTable",
        "TdRatingTable",
        "TdQuestTable",
        "TdManaDropAmountTable",

        "BasePackageTable",
        "JobAwardTable",
        "DefaultEquipTable",
        "PresentTable",
        "EmotionTable",
        "ProfessionTable",
        "NpcTable",
        "EntityTable",
        "ProfessionTextTable",
        "BaseLvTable",
        "JobLvTable",
        "TdLvRangeTable",
        "TdOrderTable",
        "TdTable",
        "TdUnitTable",
        "DotHudTable",
        "KnowledgeTable",
        "NewPlayerGiftTable",

        "BigPicTipTable",
        "BuffTable",
        "BuffPVPTable",
        "BuffEffectTable",
        "BuffEffectPVPTable",
        "ReturnLoginReward",

        "SceneTable",
        "SceneObjTable",

        "CookFoodTable",
        "CookLevelTable",
        "CookMenuTable",
        "NewPlayerPrivilege",
        "RandomNameTable",
        "BarrowTable",
        "AudioCommonTable",
        "AudioStoryTable",
        "TipsTable",
        "ErrorTable",
        "EnvironmentWeatherModeTable",
        "EnvironmentWeatherTable",
        "EnvironmentWeatherTypeTable",
        "EnvironmentWeatherAudioTable",
        "EnvironmentWeatherEnumTable",
        "TemperatureRangeTable",
        "EnvironmentWeatherIconTable",
        "DummyMutual",
        "SkillTable",
        "SkillEffectTable",
        "BuffTable",
        "BuffPVPTable",
        "BuffEffectTable",
        "BuffEffectPVPTable",
        "RaceEnum",
        "HitTypeEnum",
        "BuffStateEnum",
        "FightGroupTable",
        "AttrPointBaseLvTable",
        "AttrPointNeed",
        "AttraddRecomTable",
        "AttributeAttrLimit",
        "AttrInfoTable",
        "AttrDecision",
        "ElementAttr",
        "ItemTable",
        "ItemUseCountTable",
        "PassivitySkillEffectTable",
        "TaskTable",
        "TaskTargetLibrary",
        "TaskDropTable",
        "TaskTypeTable",
        "TaskSceneInteractionTable",
        "TaskFlyAcceptTable",
        "TaskCameraTarget",
        "TaskAcceptTable",
        "TaskConditionTable",
        "TaskActivityTable",
        "SameScreenShowTable",
        "SpecialSceneEffectTable",
        "RecipeTable",
        "EquipTable",
        "EquipTipsTable",
        "WeaponPositionTable",
        "EquipWeaponTable",
        "EquipStationTable",
        "MvpTable",
        "FashionTable",
        "OrnamentTable",
        "BarberTable",
        "BarberStyleTable",
        "CreateRole",
        "EffectTable",
        "ItemFunctionTable",
        "ItemGroupCDTable",
        "TaskItemUseTable",
        "EyeTable",
        "EyeStyleTable",
        "OpenSystemTable",
        "DungeonsTable",
        "VehicleTable",
        "VehicleColorationTable",
        "VehicleQualityTable",
        "VehicleOrnamentTable",
        "VehicleQualityRandomTable",
        "VehicleLvTable",
        "VehicleAttrTable",
        "VehicleQualityAttrTable",
        "BlackCurtainTable",
        "BlackCurtainContentTable",
        --UI
        "RateApp",
        "StoryBoard",

        "BlackWord",
        "CutSceneTalkTable",
        "ChatSystemTable",
        "MessageTable",
        "MapTable",
        "NpcFunctionTable",
        "ShowActionTable",
        "ShowBorderTable",
        "ShowDecalTable",
        "ShowExpressionTable",
        "ShowFaceExpressionTable",
        "ThemeDungeonTable",
        "DungeonsTable",
        "EndlessTowerTable",
        "EndlessTowerJumpTable",
        "ShopCommoditTable",
        "ShopTable",
        "AwardTable",
        "AwardPackTable",
        "EquipForgeTable",
        "AutoAddSkillPointTable",
        "AutoAddSkilPointDetailTable",
        "CarryItemTable",
        "VehiclePublicTable",
        "DailyActivitiesTable",
        "NoticeLoadTable",
        "NoticeTable",
        "AnimationTable",
        "QTESkillTable",
        "CollectTable",
        "CameraAngleTable",
        "TeamTargetTable",
        "TeamExpBonus",
        "EquipRefineTable",
        "AccessoryTable",
        "MainUiTable",
        "CommoditTable",
        "CountTable",
        "MerchantGuildTable",
        "MiniMapIconTable",
        "ClimbAnimTable",
        "BattleVehicleTable",
        "CameraContrailTable",

        "SocialGlobalTable",
        "ExpressionTable",

        "StoryWordTypeTable",
        "GuildSettingTable",
        "GuildIconTable",
        "GuildNewsTable",
        "GuildUpgradingTable",
        "GuildBuildingTable",
        "GuildCrystalTable",
        "GuildCrystalLevelTable",
        "GuildContentTable",
        "GuildHuntConfigTable",
        "GuildHuntBuffTable",
        "GuildManualTable",

        "StateExclusionTable",
        "BubbleStyleTable",
        "CutSceneTable",
        "EquipEnchantTable",
        "OrnamentBarterTable",

        "HSFxConfigTable",
        "HSMonsterNumTable",
        "HSRandomEventTable",
        "DoodadTable",

        "NpcTable",
        "MailTable",
        "OpenSkillTable",
        "ProfessionPreviewTable",
        "SkillClassRecommandTable",

        "StallRefreshTable",
        "StallIndexTable",
        "StallIndexDescTable",
        "StallDetailTable",
        "StallExpandTable",
        "EquipConsumeTable",
        "EquipCardTable",
        "EquipResolveTable",
        "TimeAxisLuaTable",
        "CameraConfigTable",

        "CraftingSkillTable",
        "CraftingSkillLvUpPriceTable",
        "GatheringTable",
        "FishTable",
        "RedDotIndex",
        "RedDotCheckTable",
        "EquipPositionTable",
        "TaskChangeJobTable",
        "RichTextImageTable",

        "ItemUseLimitTable",
        "ServerLevelTable",

        "ComposeTable",
        "DanceActionTable",
        "DanceActionGroupTable",
        "ComposeClassifyTable",
        "AffixTable",
        "EquipText",
        "EquipMapStringInt",
        "BattleGroundLvRangeTable",

        "CardAttrListTable",
        "CardAttrTable",
        "FarmInfoTable",
        "SkillTipsLinkTable",

        "AchievementBadgeTable",
        "AchievementDetailTable",
        "AchievementIndexTable",

        "RefineTransfer",
        "CartRemouldTable",

        "EnchantReborn",
        "EquipJuniorEnchantLevel",
        "EquipSeniorEnchantLevel",

        "MerchantMakeMaterialsTable",
        "MerchantMakeEnchantTable",
        "DeviceTable",
        "ChooseDescTable",
        "GuildActivityTable",

        "TutorialConfigTable",
        "TutorialIndexTable",
        "TutorialMarkTable",
        "TutorialTaskTable",
        "PrivilegeSystemDesTable",
        "QTEGuideTable",
        "GameTipsTable",
        "DungeonAnnouncementTable",
        "StickersTable",
        "StickersColumnTable",
        "DungeonTargetTable",

        "MedalTable",
        "MedalConsumeTable",
        "MedalAttrTable",
        "SuperMedalTable",
        "SuperMedalAttrTable",
        "SmallGameTable",
        "RecycleTable",
        "HeroChallengeTable",
        "TutorialSkillTable",
        "PostcardDisplayTable",
        "PostcardStringTable",
        "EntrustActivitiesTable",
        "EntrustLevelTable",
        "EntrustPhotoTextTable",
        "CollectPresentTable",

        "MouthAttendanceTable",
        "WelfareFunctionTable",
        "PhotoWallGroupTable",
        "AchievementPointsAwardTable",
        "EnvironmentWeatherConditionTable",
        "ProfilePhotoTable",
        "CareerPreviewTable",
        "GreatSecretTable",
        "BGMHouseTable",
        "EquipHoleTable",
        "RouletteTable",
        "MazeRoomTable",
        "MazeOperationTable",
        "ReturnPrivilege",

        "RedPacketLevelMapTable",
        "ElfTable",
        "ElfTypeTable",
        "RegionTable",

        "FashionThemeTable",
        "SuitTable",
        "GreatSecretDifficultyMap",
        "CommoditSortTable",
        "WorldEventTable",

        "ItemSubclassTable",
        "EntityComponentTable",
        "StateExclusionErrorTable",
        "CheckInCameraTable",

        "ChargePreferenceTable",

        "CheckInViewPortTable",

        "BusinessPriceTable",
        "BusinessSellTable",
        "BusinessGlobalTable",
        "BusinessEventTable",
        "BusinessNpcInfoTable",
        "ThemePartyTable",

        "MallTable",
        "MallInterfaceTable",
        "MallRefreshTable",
        "RechargeTable",
        "PaymentTable",
        "PaymentSignalTable",

        -- 累充返利
        "TotalRechargeTable",

        "OpenWorldMapTable",
        "OpenWorldMapEventTable",
        "OpenWorldMapEventDescTable",
        "OpenWorldInfluenceTable",
        "MultiTalentTable",
        "DeathGuideTable",
        "ServerLvTable",
        "SpectatorSettingsTable",
        "SpectatorTypeTable",
        "DanceBGMTable",
        "ThemePartyBGMTable",
        "GarderobeAwardTable",

        --佣兵
        "MercenaryTable",
        "MercenaryEquipTable",
        "MercenaryTalentTable",
        "MercenaryLevelTable",
        "MercenaryAttrInfoTable",
        "TaskGuideNpcTable",
        "DailyActivitiesPushTable",

        -- 称号
        "TitleIndexTable",
        "TitleTable",

        "ConvenientAccountTable",

        "LabelTable",
        --排行榜
        "LeaderBoardTable",
        "LeaderBoardFrameTable",
        "LeaderBoardComponentTable",
        "LeaderBoardColumnInfoTable",

        -- 首领攻略
        "LeaderMethodDetailTable",
        "LeaderMethodSkillTable",
        "LeaderMethodTabTable",
        --养成
        "RoleNurturanceTable",
        -- 魔法信笺
        "MagicPaperGiftTable",
        "MagicPaperTypeTable",
        -- 商会
        "ExpectPriceTable",
        -- 节日活动签到
        "ActivityTimeScheduleDiceTable",

        -- 拍卖
        "AuctionTable",
        "AuctionIndexTable",
        -- 贝鲁兹核心
        "WheelAttrTable",
        "WheelSkillTable",
        "WheelResetConsume",
        "WheelEffects",
        "WheelSlotUnlock",
        --月卡
        "MonthCardTable",
        "GiftPackageTable",
        --推送
        "PushInformationTable",

        "TheaterTable",
        "DungeonLevelTable",
        "AttraddMatchTable",
        "SkillMatchTable",
        -- 卡片解封
        "EquipCardSeal",
        "EquipReformTable",
        --魔物图鉴
        "EntityHandBookTable",
        "EntityHandBookLvTable",
        "EntityPrivilegeTable",
        "EntityGroupTable",
        "MatchDutyTable",
        "ItemTopTable",
        --支付
        "PaymentTable",
        --返利月卡
        "RebateMonthlyCard",
        --概率显示
        "ProbabilityDetails",
        "ProbabilityInterface",
        -- 赠送
        "GiftTable",
        --线下分享
        "ShareTable",
        "ItemAchievingTypeTable",
        "ItemAchieveBlackList",
        "PhotoFrameTable",
        "DialogBgTable",
        "DialogTabTable",
        -- 回归
        "ReturnTask",
        "DeviceDetailTable",
        "PayGlobalTable",
        "ItemResolveTable",
        "NewKingActivity",

        "ActivitySceneTable",
    }

    MPreloadConfig:PreloadTables(l_tables)
end

--主入口函数。从这里开始lua逻辑
function Start()

    declareGlobal("VideoPlayerMgr", MoonClient.VideoPlayerMgr.Instance)

    require "Game"
    declareGlobal("game", Game.new())
    game:Init()
    if MGameContext.IsUnityEditor and reloadLua then
        HU.Open()
    end
end

-- 预加载一些大lua
function PreloadCommonLua()
    require "GameEnum"

    require "Common/RestrictGlobal"
    require "Common/array"
    require "Common/Serialization"
    require "Common/Utils"
    require "Common/DataStructure/DataStructure"
    require "Common/UI_TemplatePool"
    require "Common/CommonUIFunc"
    require "CommonUI/Dialog"
    require "CommonUI/ModelAlarm"
    require "CommonUI/Color"
    require "CommonUI/Quality"

    require "Event/EventDispacher"
    require "Event/MUIEvent"
    require "Event/EventConst"

    require "Table/TableUtil"
    --require "UI/UIManager"
    require "Framework/UIManager/UIManager"
    require "Network/Network_Init"

    require "Framework/DataMgr"
    require "Formula/FightAttr"
    --require "Data/Model/DeadDlgModel"
    require "ModuleMgr/FightEventMgr"
    require "ModuleMgr/MgrMgr"
    require "ModuleMgr/MgrProxy"
    require "Stage/StageMgr"
    require "eRedSignKey"

    declareGlobal("GlobalEventBus", EventDispatcher.new())
    declareGlobal("MgrMgr", ModuleMgr.MgrMgr.new())
    declareGlobal("MgrProxy", ModuleMgr.MgrProxy.new())
    declareGlobal("StageMgr", Stage.StageMgr.new())
    declareGlobal("array", Common.array)
    declareGlobal("Serialization", Common.Serialization)
    declareGlobal("Lang", Common.Utils.Lang)
    declareGlobal("DumpTable", Common.Functions.DumpTable)
    declareGlobal("ToString", Common.Functions.ToString)
    declareGlobal("ToUInt64", Common.Functions.ToUInt64)
    declareGlobal("ToInt64", Common.Functions.ToInt64)
    declareGlobal("switch", Common.Functions.switch)
    declareGlobal("handler", Common.Functions.handler)
    declareGlobal("IsNil", Common.Functions.IsNil)
    declareGlobal("IsEmptyOrNil", Common.Functions.IsEmptyOrNil)
    declareGlobal("GetColorText", RoColor.GetColorText)
    declareGlobal("GetImageText", Common.CommonUIFunc.GetImageText)
    declareGlobal("GetItemText", MgrMgr:GetMgr("ItemMgr").GetItemText)
    declareGlobal("GetItemIconText", MgrMgr:GetMgr("ItemMgr").GetItemIconText)
    declareGlobal("Dialog", CommonUI.Dialog)
    declareGlobal("EPlatform", GameEnum.EPlatform)
    declareGlobal("EFlag", GameEnum.EFlag)
    declareGlobal("ParseString", Common.Utils.ParseString)
end

function PreloadBigLua()
    require "lua_game_header"
    require "PriceFunction"

    require "ModuleMgr/RoleInfoMgr"
    require "ModuleMgr/PropMgr"
    require "ModuleMgr/TaskMgr"
    require "ModuleMgr/ChatMgr"
    require "Table/TaskTable"
    require "Table/ItemTable"
    require "TableEx/ItemSearchTable"
    require "TableEx/BuffIgnoreHashSet"

    require "Data/Model/BagApi"

    MgrMgr:GetMgr("SettingMgr")
end

function Close()
    if game then
        game:Uninit()
    end
end

--场景切换通知
function OnLevelWasLoaded(level)
    collectgarbage("collect")
    Time.timeSinceLevelLoad = 0
end

function AddCo(f, name)
    return MgrMgr:GetMgr("CoroutineMgr"):addCo(f, name)
end

function RemoveCo(co)
    MgrMgr:GetMgr("CoroutineMgr"):removeCo(co)
end
