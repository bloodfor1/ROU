--- 针对装备图鉴获取装备描述获取的管理器
---@module ModuleMgr.IllustrationEquipAttrMgr
module("ModuleMgr.IllustrationEquipAttrMgr", package.seeall)

local equipAttrCache = {}

function equipAttrCache:Init()
    ---@type table<number, string[]>
    self._cache = {}
    self._itemCache = Data.ItemLocalDataCache.new(2)
    ---@type table<number, ForgeItemData[]>
    self._forgeMatItemList = {}
end

--- 这个函数当中直接返回配置好的参数，道具数据缓存；现在道具数据创建消耗为0.1毫秒左右
---@return ItemTemplateParam[]
function equipAttrCache:GetEquipForgeMatList(id)
    if nil == id then
        logError("[EquipBookAttrMgr] invalid param")
        return {}
    end

    if nil == self._forgeMatItemList[id] then
        self:_tryAddItemMatList(id)
    end

    local ret = {}
    local targetList = self._forgeMatItemList[id]
    for i = 1, #targetList do
        local currentCount = Data.BagModel:GetCoinOrPropNumById(targetList[i].Item.TID)
        ---@type ItemTemplateParam
        local singleParam = {
            PropInfo = targetList[i].Item,
            IsShowCount = false,
            IsShowRequire = true,
            RequireCount = targetList[i].Count,
            Count = currentCount
        }

        table.insert(ret, singleParam)
    end

    return ret
end

function equipAttrCache:_tryAddItemMatList(id)
    if nil == id then
        logError("[EquipBookAttrMgr] invalid param")
        return {}
    end

    if nil == self._forgeMatItemList[id] then
        self._forgeMatItemList[id] = {}
    end

    local config = TableUtil.GetEquipForgeTable().GetRowById(id, true)
    if nil == config then
        return {}
    end

    for i = 0, config.ForgeMaterials.Length - 1 do
        local equipID = config.ForgeMaterials[i][0]
        local requireCount = config.ForgeMaterials[i][1]
        local itemData = Data.BagApi:CreateLocalItemData(equipID)
        ---@type ForgeItemData
        local newData = {
            Item = itemData,
            Count = requireCount
        }

        table.insert(self._forgeMatItemList[id], newData)
    end
end

---@return string[]
function equipAttrCache:GetAttrStrs(id)
    if nil ~= self._cache[id] then
        return self._cache[id]
    end

    local localItemData = self._itemCache:GetItemData(id)
    local ret = {}
    local baseAttrList = localItemData:GetAttrsByType(GameEnum.EItemAttrModuleType.Base)
    local styleAttrList = localItemData:GetAttrsByType(GameEnum.EItemAttrModuleType.School)
    local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
    for i = 1, #baseAttrList do
        local singleAttr = baseAttrList[i]
        local str = attrUtil.GetAttrStr(singleAttr).FullValue
        table.insert(ret, str)
    end

    for i = 1, #styleAttrList do
        local singleAttr = styleAttrList[i]
        local str = attrUtil.GetAttrStr(singleAttr).FullValue
        table.insert(ret, str)
    end

    self._cache[id] = ret
    self._itemCache:RecycleItemData(localItemData)
    localItemData = nil
    return ret
end

MgrObj = equipAttrCache

function OnInit()
    MgrObj:Init()
end

---@return string[]
function GetAttrStrsByID(id)
    local ret = MgrObj:GetAttrStrs(id)
    return ret
end

return ModuleMgr.IllustrationEquipAttrMgr