---@module ModuleMgr.TransmissionMgr
module("ModuleMgr.TransmissionMgr", package.seeall)

IsUseButterfly = false
local lastEffectId = -1
local lastFxId = -1
g_currentWeapon = 0
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function ReceiveEffectShow(msg)
    ---@type EffectShowData
    local l_info = ParseProtoBufToTable("EffectShowData", msg)
    ShowEffectWithPlayerUid(l_info.target_uuid, l_info.effect_id)
end

-- todo 这个是播放蝴蝶翅膀使用特效的，应该在收到使用道具成功的回包时候播放特效，而不是通过道具的使用来播放特效
---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[TransmissionMgr] invalid param")
        return
    end

    local showEffect = false
    for i = 1, #itemUpdateDataList do
        local singleUpdateInfo = itemUpdateDataList[i]
        if ItemChangeReason.ITEM_REASON_USE_BUTTERFLY == singleUpdateInfo.Reason then
            showEffect = true
            break
        end
    end

    if showEffect then
        IsUseButterfly = true
        ShowEffectWithPlayerSelf(104)
    end
end

function ShowEffectWithPlayerUid(playerUid, effectId, effectLayer)
    local l_entity = MEntityMgr:GetEntity(playerUid)
    if l_entity ~= nil then
        ShowEffectWithPlayerEntity(l_entity, effectId, effectLayer)
    end
end

function ShowEffectWithPlayerEntity(entity, effectId, effectLayer)
    if entity ~= nil then
        local l_fxData = MFxMgr:GetDataFromPool()
        if effectLayer then
            l_fxData.layer = effectLayer
        end

        --如果播放相同的特效，则删除
        if lastFxId > 0 and astEffectId == effectId then
            MFxMgr:DestroyFx(lastFxId)
        end

        lastEffectId = effectId
        lastFxId = entity.VehicleOrModel:CreateFx(effectId, EModelBone.ERoot, l_fxData)
        MFxMgr:ReturnDataToPool(l_fxData)
    end
end

function ShowEffectWithPlayerSelf(effectId)
    local l_player = MEntityMgr.PlayerEntity
    if l_player ~= nil then
        ShowEffectWithPlayerEntity(l_player, effectId)
    end
end
--根据职业改变任务模型
function ChangeRoleModel(profressionId)
    local l_player = MEntityMgr.PlayerEntity
    if l_player ~= nil then
        l_player:ChangeProfessionInfo(profressionId)
    end

end