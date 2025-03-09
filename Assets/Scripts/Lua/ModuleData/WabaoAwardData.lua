--
-- @Description: 
-- @Author: haiyaojing
-- @Date: 2019-10-12 11:27:25
--

module("ModuleData.WabaoAwardData", package.seeall)

EWabaoAwardLevel = {
    Normal = 3,
    Middle = 2,
    High = 1,
}

WabaoRewardCount = 10

CacheAwardResult = nil

IsAction = false

local cachedTips = {}

function HandleWabaoPreview(info)

    local l_itemId, l_itemCount = CacheAwardResult.itemId, CacheAwardResult.itemCount

    -- 缓存
    local l_finded = false
    local l_index
    CacheAwardResult.item_list = {}
    for i, v in ipairs(info.award_list) do
        CacheAwardResult.item_list[i] = v.item_id
        if v.item_id == l_itemId then
            if not l_finded then
                l_finded = true
                l_index = i
            end
        end
    end

    -- 替换
    if not l_finded then
        l_index = math.random(1, WabaoRewardCount)
        local l_old_item = CacheAwardResult.item_list[l_index]
        CacheAwardResult.item_list[l_index] = l_itemId
        log(StringEx.Format("replace old:{0} new:{1}", l_old_item, l_itemId))
    end
end

function CacheTips(str)

    table.insert(cachedTips, str)
end

function PopCacheTips()

    local l_ret = cachedTips
    cachedTips = {}
    return l_ret
end

return ModuleData.WabaoAwardData