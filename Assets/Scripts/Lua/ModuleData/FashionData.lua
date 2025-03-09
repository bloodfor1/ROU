--
-- @Description:
-- @Author: dingshanchen
-- @Date: 2019-11-28 22:22:22
---@module FashionData
--

--lua model
module("ModuleData.FashionData", package.seeall)
--lua model end
EUIOpenType = {
    SHOW = 1,
    HISTORY = 2,
    RATING_PHOTO = 3,
    RATING_PHOTO_INCLUDE = 4,
    FASHION_PHOTO = 5,
    COUNTDOWN_CAMERA = 6,
    SPECIAL_PHOTO = 7
}
DataLis = {}    --积分排行榜数据
History = {}    --历史第一名
JournalRound = 0
TotalNum = 0    --典藏排行目前获得的数据总量
CurPoint = 0    --当前分数
MaxPoint = 0    --最高分數
CollectScore = 0     --典藏值
CollectRank = 0      --典藏值排名
NpcData = {sceneId = 0, x = 0, y = 0, z = 0}    --动态npc位置
PhotoData = {}      --玩家照片数据
MaxCount = TableUtil.GetCountTable().GetRowById(110).Limit
GradeCount = 0  --剩余评分次数
JournalTheme = 0
NowChooseTheme = 0  --当前选择的历史期数

--lua functions
function Init()

end --func end
--next--
function UnInit()

end
--lua functions end

--lua custom scripts
function SetHistoryMagazine(data)

    local l_data = {}
    History = data
    for i = 1, #History do
        l_data = History[i].fashion_score_data
        l_data.args = l_data.photo.args
        l_data.action = l_data.photo.action
        l_data.outlook = l_data.photo.outlook
        l_data.equip_ids = l_data.photo.equip_ids
        l_data.type = l_data.photo.type
        l_data.sex = l_data.photo.sex and l_data.photo.sex or SexType.SEX_MALE
        l_data.photo = nil
        l_data.HasPhotoInfo = HasPhotoInfo
        l_data.GetMatData = GetMatData
        l_data.GetAnimInfo = GetAnimInfo
        l_data.GetPSR = GetPSR
        l_data.GetEmotion = GetEmotion
    end
    local l_flip = {}
    for i = #History, 1, -1 do
        table.insert(l_flip, History[i])
    end
    History = l_flip

end

function SetNewData(newDataLis)
    DataLis = newDataLis
end

--获取排名数据
function GetSortData()

    local l_datas = {}
    for k, v in pairs(DataLis) do
        l_datas[#l_datas + 1] = v
    end
    if #l_datas <= 1 then
        return l_datas
    end
    table.sort(l_datas,function(a, b)
        return b.rank > a.rank
    end)
    return l_datas

end

function SetEvaluationInfo(info)

    GradeCount = info.left_times
    MaxPoint = info.max_score
    CurPoint = info.max_score
    CollectScore = info.fashion_collect_score
    PhotoData = info.photo_data
    PhotoData.HasPhotoInfo = HasPhotoInfo
    PhotoData.GetMatData = GetMatData
    PhotoData.GetAnimInfo = GetAnimInfo
    PhotoData.GetPSR = GetPSR
    PhotoData.GetEmotion = GetEmotion
    JournalTheme = info.theme

end

function SetSharePhotoInfo(info)

    l_data = {}
    l_data.args = info.photo_data.args
    l_data.action = info.photo_data.action
    l_data.outlook = info.photo_data.outlook
    l_data.equip_ids = info.photo_data.equip_ids
    l_data.type = info.photo_data.type
    l_data.sex = info.photo_data.sex and info.photo_data.sex or SexType.SEX_MALE
    l_data.HasPhotoInfo = HasPhotoInfo
    l_data.GetMatData = GetMatData
    l_data.GetAnimInfo = GetAnimInfo
    l_data.GetPSR = GetPSR
    l_data.GetEmotion = GetEmotion
    l_data.score = info.score
    l_data.name = info.name
    return l_data

end

function SetRoleFashionScore(info, arg)

    local l_data = {}
    for j = 1, #DataLis do
        if DataLis[j].rid == info.role_id then
            for _, v in pairs(arg) do
                if v.rid == info.role_id and (v.rank == -1 or v.rank == DataLis[j].rank) then
                    l_data = DataLis[j]
                    l_data.is_click_link = v.is_click_link -- 公会聊天里面点击查看照片，不显示文字信息
                    break
                end
            end
        end
    end
    if l_data then
        l_data.score = info.score
        l_data.name = info.name
        l_data.args = info.photo.args
        l_data.action = info.photo.action
        l_data.outlook = info.photo.outlook
        l_data.equip_ids = info.photo.equip_ids
        l_data.type = info.photo.type
        l_data.sex = info.photo.sex and info.photo.sex or SexType.SEX_MALE
        l_data.HasPhotoInfo = HasPhotoInfo
        l_data.GetMatData = GetMatData
        l_data.GetAnimInfo = GetAnimInfo
        l_data.GetPSR = GetPSR
        l_data.GetEmotion = GetEmotion
        return l_data
        --EventDispatcher:Dispatch(Event.DetailData, l_data)
    else
        logError("找不到对应角色数据 => uid = {0}", info.role_id)
        return nil
    end
    
end

function HasPhotoInfo(data)

    return data and data.action and data.args
        and #data.action > 0 and #data.args > 0

end

function GetAnimInfo(data)

    if not HasPhotoInfo(data) then
        return nil
    end
    return data.action[1].value, data.action[2].value, data.args[42].value

end

function GetEmotion(data)

    if not HasPhotoInfo(data) then
        return nil
    end
    local l_id1 = data.args[43]
    local l_id2 = data.args[44]
    return l_id1 and l_id1.value or nil, l_id2 and l_id2.value or nil

end

function GetPSR(data)

    if not HasPhotoInfo(data) then
        return nil
    end
    local v1 = {x = data.args[33].value, y = data.args[34].value, z = data.args[35].value}
    local v2 = {x = data.args[36].value, y = data.args[37].value, z = data.args[38].value}
    local v3 = {x = data.args[39].value, y = data.args[40].value, z = data.args[41].value}
    return v1, v2, v3

end

function GetMatData(data)

    local l_vMat = _getMatData(data, 0)
    local l_pMat = _getMatData(data, 16)
    return l_vMat, l_pMat

end

function _getMatData(data, index)

    if not HasPhotoInfo(data) then
        return nil
    end
    local l_mM = UnityEngine.Matrix4x4.New()
    l_mM.m00 = data.args[index + 1].value
    l_mM.m01 = data.args[index + 2].value
    l_mM.m02 = data.args[index + 3].value
    l_mM.m03 = data.args[index + 4].value
    l_mM.m10 = data.args[index + 5].value
    l_mM.m11 = data.args[index + 6].value
    l_mM.m12 = data.args[index + 7].value
    l_mM.m13 = data.args[index + 8].value
    l_mM.m20 = data.args[index + 9].value
    l_mM.m21 = data.args[index + 10].value
    l_mM.m22 = data.args[index + 11].value
    l_mM.m23 = data.args[index + 12].value
    l_mM.m30 = data.args[index + 13].value
    l_mM.m31 = data.args[index + 14].value
    l_mM.m32 = data.args[index + 15].value
    l_mM.m33 = data.args[index + 16].value
    return l_mM

end
--lua custom scripts end
return FashionData