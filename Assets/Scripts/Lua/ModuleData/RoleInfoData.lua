--lua model
module("ModuleData.RoleInfoData", package.seeall)
--lua model end

--lua custom scripts
ERoleInfoOpenType = 
{
    ShowBeginnerGuide = 1,
    ResetRoleAttr = 2,
    AutoCalulateCom = 3,
    OpenAddAttrSchools = 4
}

--属性来源
ATTR_SOURCE_TYPE_INIT = 0
ATTR_SOURCE_TYPE_QUALITY_POINT = 1
ATTR_SOURCE_TYPE_BUFF = 2
ATTR_SOURCE_TYPE_EQUIPMENT = 3

--属性ID
ATTR_BASIC_STR = 13
ATTR_BASIC_INT = 15
ATTR_BASIC_AGI = 17
ATTR_BASIC_DEX = 19
ATTR_BASIC_VIT = 21
ATTR_BASIC_LUK = 23

--特判的ID
ATTR_BASIC_MOVE_SPD_FINAL = 116
ATTR_BASIC_CT_FIXED = 81
ATTR_PERCENT_CT_FIXED = 82
ATTR_BASIC_CT_FIXED_FINAL = 125
ATTR_PERCENT_CT_FIXED_FINAL = 301
ATTR_BASIC_CT_CHANGE = 83
ATTR_PERCENT_CT_CHANGE = 84
ATTR_BASIC_CT_CHANGE_FINAL = 126
ATTR_PERCENT_CT_CHANGE_FINAL = 302
ATTR_BASIC_GROUP_CD_CHANGE = 101
ATTR_PERCENT_GROUP_CD_CHANGE = 102
ATTR_BASIC_CD_CHANGE = 85
ATTR_BASIC_MAX_HP_FINAL = 127
ATTR_BASIC_MAX_SP_FINAL = 128

--属性内容
ATTR_MGR_TYPE_BASIC = 0
ATTR_MGR_TYPE_QUALITY_POINT = 1
ATTR_MGR_TYPE_BUFF = 2
ATTR_MGR_TYPE_EQUIP = 3
ATTR_MGR_TYPE_COUNT = 4

BasicAttrList = {}      --存储玩家的基础属性列表 也就是显示面板右侧的6个属性 存储了AttrInfoTable Base是素质属性Id Equip是装备属性Id
SecondLevelList = {}    --依据AttrInfoTable 本地存储一张玩家属性信息的Table Base是素质属性Id Equip是装备属性Id 对玩家具体属性值做了存储
PlayerAttr = {}         --用来存储玩家的所有属性的具体值
SeverLevelData = {}     --用于存储服务器的等级的一些数据

SecondAttrTypeList = {} --按照属性的二级类型存储的属性列表
AttrBaseLvTable = {}    --存储玩家等级相关数据
AttrPointNeedTable = {}
IsNeedShowRoleInfoGuide=false

local l_original_vigour_limit --元气相关
local l_vigour_lev_increase   --元气相关

Attr_Icon_Table = 
{
    [13] = {AttrAtlas = "Common",AttrIcon = "UI_Common_AttributeIcon_02.png"},
    [17] = {AttrAtlas = "Common",AttrIcon = "UI_Common_AttributeIcon_05.png"},
    [21] = {AttrAtlas = "Common",AttrIcon = "UI_Common_AttributeIcon_03.png"},
    [15] = {AttrAtlas = "Common",AttrIcon = "UI_Common_AttributeIcon_04.png"},
    [19] = {AttrAtlas = "Common",AttrIcon = "UI_Common_AttributeIcon_01.png"},
    [23] = {AttrAtlas = "Common",AttrIcon = "UI_Common_AttributeIcon_06.png"},
}

--Require 初始化全局数据 
function Init( ... )
    InitServerLevelData()
    InitVigourLimit()
    InitAttrBaseLvTable()
    InitAttrPointNeedTable()
    InitAttrInfoTable()
end

--Logout重置动态数据
function Logout( ... )

end

function InitServerLevelData()
    SeverLevelData = {}
    SeverLevelData.serverDay = 0
    SeverLevelData.serverlevel = 0
    SeverLevelData.basebonus = 0
    SeverLevelData.jobbonus = 0
    SeverLevelData.nextrefreshtime = 0
    SeverLevelData.hiddenbaselevel = 0
end

function SetServerLevel(level)
    if SeverLevelData == nil then
        SeverLevelData={}
    end
    SeverLevelData.serverlevel = level
end

function GetServerLevel()
    if SeverLevelData == nil then
        return 0
    end
    return SeverLevelData.serverlevel
end

function InitVigourLimit()
    l_original_vigour_limit = MGlobalConfig:GetInt("VigourOriginalValueMaxLimit")
    l_vigour_lev_increase = MGlobalConfig:GetInt("VigourPerLevIncrease")
end

function InitAttrBaseLvTable()
    local lvTable = TableUtil.GetAttrPointBaseLvTable().GetTable()
    local totalPoint = 0
    for i = 1, table.maxn(lvTable) do
        totalPoint = totalPoint + lvTable[i].Attrpoint
        local lv = lvTable[i].BaseLv
        if lv then
            AttrBaseLvTable[lv] = totalPoint
        end
    end
end

function InitAttrPointNeedTable()
    local needTable = TableUtil.GetAttrPointNeed().GetTable()
    local totalPoint = 0
    for i = 1, table.maxn(needTable) do
        totalPoint = totalPoint + needTable[i].Pointneed
        local statPoint = needTable[i].Statpoint
        if statPoint then
            AttrPointNeedTable[statPoint] = totalPoint
        end
    end
end

function InitAttrInfoTable()
    local infoTable = TableUtil.GetAttrInfoTable().GetTable()
    BasicAttrList = {}
    SecondLevelList = {}
    SecondAttrTypeList = {}
    for i = 1, table.maxn(infoTable) do
        local attrType = infoTable[i].Type
        local oneLineInfo = {}
        oneLineInfo.attrTableData = infoTable[i]
        if attrType == 1 then
            oneLineInfo.base = infoTable[i].Id
            oneLineInfo.equip = infoTable[i].EquipId
            oneLineInfo.name = infoTable[i].AttrName
            oneLineInfo.atlas = Attr_Icon_Table[infoTable[i].Id].AttrAtlas
            oneLineInfo.icon = Attr_Icon_Table[infoTable[i].Id].AttrIcon
            oneLineInfo.attrType = infoTable[i].TypeId
            table.insert(BasicAttrList, oneLineInfo)
        elseif attrType == 2 then
            oneLineInfo.base = infoTable[i].Id
            oneLineInfo.equip = infoTable[i].EquipId
            oneLineInfo.name = infoTable[i].AttrName
            oneLineInfo.showDetail = infoTable[i].ShowDetail
            oneLineInfo.isPercent = IsPercentAttr(oneLineInfo.base)
            oneLineInfo.attrType = infoTable[i].TypeId
            table.insert(SecondLevelList, oneLineInfo)
        end
        --因为对属性又做了一个二级的分类 所以保存了这样一个表
        if SecondAttrTypeList[infoTable[i].TypeId] == nil then
            SecondAttrTypeList[infoTable[i].TypeId] = {}
        end
        table.insert(SecondAttrTypeList[infoTable[i].TypeId],oneLineInfo)
    end

    for k,v in pairs(SecondAttrTypeList) do
        table.sort(v,function (x,y)
            return x.attrTableData.ShortId < y.attrTableData.ShortId
        end)
    end
end

--记录加点之前的属性
function CalulatePreSecondAttr()
    for i = 1, table.maxn(SecondLevelList) do
        if not PlayerAttr[SecondLevelList[i].base] then
            PlayerAttr[SecondLevelList[i].base] = {}
        end
        PlayerAttr[SecondLevelList[i].base].preBaseAttr = MEntityMgr:GetMyPlayerAttr(SecondLevelList[i].base)
        PlayerAttr[SecondLevelList[i].base].preEquipAttr = MEntityMgr:GetMyPlayerAttr(SecondLevelList[i].equip)
    end
end

--模拟增加属性
function AddPlusAttrToPlayer()
    MEntityMgr:BeginCaluelateAttr()
    for i = 1, table.maxn(BasicAttrList) do
        if PlayerAttr[BasicAttrList[i].base] then
            local plusAttr = PlayerAttr[BasicAttrList[i].base].plusAttr
            local baseAttr = PlayerAttr[BasicAttrList[i].base].baseAttr
            MEntityMgr:SetAttrToCalulateByType(BasicAttrList[i].base, plusAttr + baseAttr, ATTR_MGR_TYPE_QUALITY_POINT)
        end
    end
    MEntityMgr:EndCaluelateAttr()
end

--取出算好之后的属性 用来做显示
function CalulateAfterSecondAttr()
    for i = 1, table.maxn(SecondLevelList) do
        --创建UI
        if SecondLevelList[i].base ~= -1 then
            PlayerAttr[SecondLevelList[i].base].afterBaseAttr = MEntityMgr:GetCalulatedAttr(SecondLevelList[i].base)
        else
            PlayerAttr[SecondLevelList[i].base].afterBaseAttr = 0
        end
        if SecondLevelList[i].equip ~= -1 then
            PlayerAttr[SecondLevelList[i].base].afterEquipAttr = MEntityMgr:GetCalulatedAttr(SecondLevelList[i].equip)
        else
            PlayerAttr[SecondLevelList[i].base].afterEquipAttr = 0
        end
    end
end

function IsPercentAttr(attrId)
    local attrInfo = TableUtil.GetAttrDecision().GetRowById(attrId)
    return attrInfo and attrInfo.TipParaEnum == 1
end

function GetOriginalvigourlimit()
    return l_original_vigour_limit
end

function GetVigourIncrease()
    return l_vigour_lev_increase
end

return ModuleData.RoleInfoData