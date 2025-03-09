---@module Common.eRedSignKey
module("Common.eRedSignKey", package.seeall)
declareGlobal("eRedSignKey", Common.eRedSignKey)

StatusPoint = 1
Friend = 2
Email = 3
Stall = 4
DailyTask = 7
GuildApply = 9
Garderobe = 18
LifeProfession = 20
FriendAndEmail = 22
Switch = 23
LandingAward = 24
SkillLearningSkill = 10
SkillLearningSetting = 11
MainSkill = 25
Activity = 26
ExpelMonster = 27
TeamApply = 6
Team = 29
TeamAndTask = 28
CatCaravan = 30
GuildWelfare = 31
GuildWelfareTog = 32
MainRoleInfoStatusPoint = 33
SweaterStall = 34
StallHandler = 35
SignIn = 36
Welfare = 37
Achievement = 38
BeginnerBook = 39  --主界面手册
Delegate = 40
FriendHelper = 41  --好友助手，卡普拉
FriendAndHelper = 42 --好友+助手
GuildRedEnvelope = 43 --公会红包
Guild = 44 --公会
LevelReward = 45 -- 等级礼包
TimeLimitPay = 46
WelfareTimeLimitPay = 114
SkillLearningJobAward = 47
AdventureDiary = 48  --冒险日记
EquipMultiTalentRedSign = 53
SkillMultiTalentRedSign = 54
GuildMember = 55
DelegateAward = 56
DelegateButton = 157            --暂时废弃，后面可以删除主键后删了
GuildHuntReward = 58

--佣兵
MercenaryLevelUp = 59
MercenaryInformation = 60
MercenaryEquipLevelUp = 61
Mercenary = 62
MercenaryTalent = 63

-- 贴纸
StickerCheck = 65
TitleTag = 66
StickerButton = 67
Personal = 68

--波利团
PollyTypeAward = 69
PollyNote = 70
PollySingleAward = 71
PollyRegionAward = 72  
PollyRecord = 73
PollyManual = 74
GuildStone = 75
GuildStoneButton = 76
GuildStoneButton2 = 77
MonthCard = 80
MonthCardBtn = 81
MonthCardSmallGift = 82
Bag = 84       -- 背包
BagPotionSetting = 85 -- 获得全自动守护设备后的红点
GuildCrystalOneLv = 86
GuildBook = 87 --公会组织手册
GuildActivity = 88 --公会活动
PlayerPlanQ = 89
SkillPlanQ = 90
BagPlanQ = 91
BagGetGift = 5
DelegateButtonEx = 57
ImportantMail = 116
FriendAndEmailEx = 122
Vigour = 92
BeiluzBag = 93
TimeActivityPoint = 200
ActivityCheckInPoint1 = 201
ActivityCheckInPoint2 = 202
TotalRechargeAwardPoint = 260 -- 累计充值奖励
Shop = 250
Recharge = 261
BingoPoint1 = 203
BingoPoint2 = 204
TowerReward = 94
GuildSale = 95
FashionAward = 19
FirstRechargeOuter = 96
FirstRechargeInner = 97
MonsterHandBook = 49
GiftPackage = 98
MailOfShop = 251
Return = 111
ReBackLogin = 112
ReBackTask = 113
RedSignPro1 = 12
RedSignPro2 = 13
RedSignProHint1 = 14
RedSignProHint2 = 15
RedSignMall = 270
RedSignMallGold = 271
RedSignMallGoldGift = 280
RedSignMallMystery = 272
FirstRechargeButtonEffect = 115
NewPlayer = 300
FatherShop = 240
ImportantMail = 116
BattleFieldHintEffect = 120
NewKingPoint1 = 205
NewKingPoint2 = 206

function _updateRedSignKey()

    --此方法只在编辑器下运行，用来更新红点的key
    if not Application.isEditor then
        return
    end
    local l_path = Application.dataPath .. "\\Scripts\\Lua\\eRedSignKey.lua"
    local l_fileText = MoonCommonLib.FileEx.ReadText(l_path)
    local l_redTable = TableUtil.GetRedDotIndex().GetTable()
    local l_insertText = ""
    for i = 1, #l_redTable do
        if not string.ro_isEmpty(l_redTable[i].RedSignKey) then
            if eRedSignKey[l_redTable[i].RedSignKey] == nil then
                eRedSignKey[l_redTable[i].RedSignKey] = l_redTable[i].ID
                l_insertText = l_insertText .. "\n" .. l_redTable[i].RedSignKey .. " = " .. tostring(l_redTable[i].ID)
            end
        else
            logError("当前红点没有key，id：" .. tostring(l_redTable[i].ID))
        end
    end
    if not string.ro_isEmpty(l_insertText) then
        l_insertText = l_insertText .. "\n\n"
        l_fileText = ExtensionByQX.StringHelper.InsertWithStartValue(l_fileText, "function _updateRedSignKey()", l_insertText)
        MoonCommonLib.FileEx.SaveText(l_fileText, l_path)
    end
    _redSignTableCorrectnessCheck()

end

--红点表配置的正确性检测
function _redSignTableCorrectnessCheck()

    local l_redTable = TableUtil.GetRedDotIndex().GetTable()
    for i = 1, #l_redTable do
        _checkRedSignTableInfo(l_redTable[i])
    end
    local l_redTestTable = TableUtil.GetRedDotCheckTable().GetTable()
    for i = 1, #l_redTestTable do
        _checkRedSignTestTableInfo(l_redTestTable[i])
    end
    
end

function _checkRedSignTestTableInfo(tableInfo)

    if string.ro_isEmpty(tableInfo.MgrName) then
        if not string.ro_isEmpty(tableInfo.CheckMethodName) then
            logError("此系统配了Mgr名字，但没有配检测方法名字，id：" .. tostring(tableInfo.ID))
        end
    end
    if string.ro_isEmpty(tableInfo.CheckMethodName) then
        if not string.ro_isEmpty(tableInfo.MgrName) then
            logError("此系统配了检测方法，但没有配检测方法所在的Mgr名字，id：" .. tostring(tableInfo.ID))
        end
    end

end

function _checkRedSignTableInfo(tableInfo)

    if tableInfo.OffSet.Length == 0 then
        logError("表的OffSet没有配，id：" .. tostring(tableInfo.ID))
    end
    if tableInfo.Size.Length == 0 then
        logError("表的Size没有配，id：" .. tostring(tableInfo.ID))
    end
    if tableInfo.ShowType == 4 and string.ro_isEmpty(tableInfo.EffectPath) then
        logError("该红点为特效红点，但是却没有特效路径，id：" .. tostring(tableInfo.ID))
    end
    if tableInfo.ShowType == 5 and string.ro_isEmpty(tableInfo.EffectPath) then
        logError("该红点为自定义图片红点，但是却没有图片路径，id：" .. tostring(tableInfo.ID))
    end
end

_updateRedSignKey()



