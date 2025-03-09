--- 包装一层API
--- 业务逻辑无关，只负责流派映射
require "Data/Model/RecommendMapApi"

---@module ModuleMgr.RecommendMapMgr
module("ModuleMgr.RecommendMapMgr", package.seeall)

RecommendMapApi = nil

function OnInit()
    RecommendMapApi = Data.RecommendMapApi.new()
    RecommendMapApi:Init()
end

---@return boolean
function ItemMatchesSchool(schoolID, itemID)
    local ret = RecommendMapApi:ItemMatchesSchool(schoolID, itemID)
    return ret
end

--- 返回两个道具ID有没有重合的流派
---@return number
function ItemMatchItemSchool(itemIDLeft, itemIDRight)
    local ret = RecommendMapApi:ItemsSameSchool(itemIDLeft, itemIDRight)
    return #ret
end