module("ModuleMgr.SelectEquipMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

SelectEquipCellEvent = "SelectEquipCellEvent"
SelectEquipShowEquipEvent = "SelectEquipShowEquipEvent"

eSelectEquipShowType = {
    Default = 0,
    Refine = 1,
    RefineTransfer = 2,
}

NeedSelectUid = nil


---@param propInfo ItemData
function SetNeedSelectWithPropInfo(propInfo)
    if propInfo then
        NeedSelectUid = propInfo.UID
    else
        NeedSelectUid = nil
    end
end
function SetNeedSelectUid(uid)
    NeedSelectUid = uid
end

--以上是新的选择装备的数据

--选择装备所对应的系统
EquipSystem = {
    Refine = 0, --精炼
    Enchant = 1, --附魔
    Card = 2, --插卡
    Forge = 3, --打造
    Transfer = 4, --转移
    Unseal = 5, --解除封印
    EnchantmentExtract = 6,
    None = 7,
}
--事件
EquipDataChange = "EquipDataChange" --回调
RefineShowEquipInfo = "RefineShowEquipInfo"     --展示精炼装备属性
RefineShowEquipDetails = "RefineShowEquipDetails" --精炼成功后属性
EnchantmentExtractShowEquipInfo = "EnchantmentExtractShowEquipInfo"
EnchantShowEquipInfo = "EnchantShowEquipInfo"     --展示附魔装备属性
EnchantShowEquipDetails = "EnchantShowEquipDetails" --附魔成功后属性
RefineTransferShowEquipInfo = "RefineTransferShowEquipInfo" -- 展示精炼转移装备
RefineUnsealEquipInfo = "RefineUnsealEquipInfo" --暂时封印解除装备
--当前选中的装备UID
g_currentSelectUID = 0
--当前选中的装备索引
g_currentSelectIndex = 0
--是否在精炼系统
g_equipSystem = EquipSystem.None