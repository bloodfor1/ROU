---@class MagicletterParam
---@field letterUid int64
---@field receiveRoleUid int64
---@field receiveRoleName string

---@module LinkInputMgr
module("ModuleMgr.LinkInputMgr", package.seeall)
require "Data/Model/BagModel"
require "Common/Serialization"

curHrefInfo = nil
curInputHrefStr = nil

--[li]
local LinkPlaceholder = MoonClient.DynamicEmojHelp.LinkPlaceholder
--%[li%]
local MatchLinkPlaceholder = string.gsub(LinkPlaceholder, "%[", "%%%[")
MatchLinkPlaceholder = string.gsub(MatchLinkPlaceholder, "%]", "%%%]")

--region 获取超链接参数
--@Description:获取超链接数据包
function getHrefPack()
    if curHrefInfo == nil then
        return
    end
    local l_tempPack = nil
    if curHrefInfo.type == ChatHrefType.Prop then
        l_tempPack = getPropPack(curHrefInfo.param)
    elseif curHrefInfo.type == ChatHrefType.AchievementDetails then
        _, l_tempPack = GetAchievementDPack("", curHrefInfo.param.id, curHrefInfo.param.rid,  curHrefInfo.param.time)
    elseif curHrefInfo.type == ChatHrefType.AchievementBadge then
        _, l_tempPack = GetAchievementBPack("", curHrefInfo.param.id, curHrefInfo.param.point, curHrefInfo.param.level, curHrefInfo.param.rid)
    elseif curHrefInfo.type == ChatHrefType.SkillPlan then
        _, l_tempPack = getSkillPlanPack("", curHrefInfo.param.planId, curHrefInfo.param.name)
    elseif curHrefInfo.type == ChatHrefType.AttributePlan then
        _, l_tempPack = getAttPlanPack("", curHrefInfo.param.planId, curHrefInfo.param.name)
    elseif curHrefInfo.type == ChatHrefType.ClothPlan then
        _, l_tempPack = getClothPlanPack("", curHrefInfo.param.planId)
    elseif curHrefInfo.type == ChatHrefType.Title then
        _, l_tempPack = GetTitlePack("")
    elseif curHrefInfo.type == ChatHrefType.ThemeChallengeConfirm then
        _, l_tempPack = GetThemeChallengeConfirmPack("")
    end
    return l_tempPack
end
function getPropPack(param)
    if param == nil then
        return
    end
    if MgrMgr:GetMgr("ItemMgr").GetSelfItemInfo(param.propUID) == nil then
        return
    end
    local _, l_pack = GetItemPack(nil, param.itemID, param.propLevel, param.propUID)
    return l_pack
end
function GetAchievementDPack(msg, id, rid, time)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = 2,
            param32 = {
                [1] = { value = id },
            },
            param64 = {
                [1] = { value = tostring(rid) },
                [2] = { value = tostring(time) },
            },
        }
    }
end
function GetAchievementBPack(msg, id, point, level, rid)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = 3,
            param32 = {
                [1] = { value = id },
                [2] = { value = point },
                [3] = { value = level },
            },
            param64 = {
                [1] = { value = tostring(rid) },
            },
        }
    }
end
function GetTreasureHunterAwardPack(msg, pos, line, sceneId)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = ChatHrefType.TreasureHunterAward,
            param32 = {
                [1] = { value = pos.x },
                [2] = { value = pos.y },
                [3] = { value = pos.z },
                [4] = { value = line },
                [5] = { value = sceneId }
            }
        }
    }
end
function getSkillPlanPack(msg, planId, name)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = 8,
            param32 = {
                [1] = { value = planId },
            },
            name = {
                [1] = name
            }
        }
    }
end
function getAttPlanPack(msg, planId, name)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = 7,
            param32 = {
                [1] = { value = planId },
            },
            name = {
                [1] = name,
            }
        }
    }
end
function getClothPlanPack(msg, planId)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = ChatHrefType.ClothPlan,
            param32 = {
                [1] = { value = planId },
            }
        }
    }
end
function GetItemPack(msg, itemID, level, uid, count, hideIcon)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = 1,
            param32 = {
                [1] = { value = itemID },
                [2] = { value = level },
            },
            param64 = {
                [1] = { value = tostring(uid) },
            },
            showInfo = {
                count = count or 0,
                hideIcon = hideIcon
            }
        }
    }
end

--公会原石
function GetStonSculpturePack(msg, guildId, iid, time, rid, st)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = 4,
            param32 = {},
            param64 = {
                [1] = { value = guildId },
                [2] = { value = iid },
                [3] = { value = time },
                [4] = { value = MLuaCommonHelper.Long(rid) },
            },
            name = {st}
        }
    }
end

--pvp的结构
function GetPvpPack(msg, id)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, { { type = 5, param32 = { [1] = { value = id }, }, param64 = {}, } }
end
--品尝烹饪的结构
function GetCookingPack(msg, id)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, { { type = 6, param32 = { [1] = { value = id }, }, param64 = {}, } }
end
--品尝烹饪的结构
function GetWatchPack(msg, id)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, { { type = ChatHrefType.Watch, param32 = {}, param64 = { [1] = { value = id } }, } }
end
--时尚评分分享至工会聊天
function GetFashionRatingPack(msg, rid, id)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, {
        {
            type = ChatHrefType.FashionRating,
            param32 = {
                [1] = { value = 0},
            },
        }
    }
end
-- 称号分享
-- isOwn，1拥有，0未拥有
function GetTitlePack(msg, titleId, titleName, isOwned, roleName)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, { { type = ChatHrefType.Title, name = {titleName, roleName}, param32 = { [1] = { value = titleId }, [2] = { value = isOwned}}, param64 = {}, } }
end

-- 主题挑战本战前确认
function GetThemeChallengeConfirmPack(msg, dungeonName, dungeonId, hardLevel)
    msg = msg or ""
    msg = msg .. LinkPlaceholder
    return msg, { { type = ChatHrefType.ThemeChallengeConfirm, name = {dungeonName}, param32 = { [1] = { value = dungeonId }, [2] = { value = hardLevel }}} }
end
--endregion

--region 向聊天输入框发送超链接信息
function AddInputHref(original, hrefData, hrefType)
    local l_hrefInfo = { type = hrefType }
    local l_inputStr = nil
    if hrefType == ChatHrefType.Prop then
        l_inputStr = AddPropHref(original, hrefData, l_hrefInfo)
    elseif hrefType == ChatHrefType.AchievementDetails then
        l_inputStr = AddAchievementDetailHref(original, hrefData, l_hrefInfo)
    elseif hrefType == ChatHrefType.AchievementBadge then
        l_inputStr = AddAchievementBadgeHref(original, hrefData, l_hrefInfo)
    elseif hrefType == ChatHrefType.SkillPlan then
        l_inputStr = AddSkillPlanHref(original, hrefData, l_hrefInfo)
    elseif hrefType == ChatHrefType.AttributePlan then
        l_inputStr = AddAttPlanHref(original, hrefData, l_hrefInfo)
    elseif hrefType == ChatHrefType.ClothPlan then
        l_inputStr = AddClothPlanHref(original, hrefData, l_hrefInfo)
    else
        logError("聊天输入占不支持的超链接类型：" .. tostring(hrefType))
    end
    if l_inputStr ~= nil then
        curHrefInfo = l_hrefInfo
        return l_inputStr
    end
    return original
end
function AddAchievementDetailHref(original, item, hrefInfo)
    if item == nil then
        return original
    end
    local l_achiDetailItem = item:GetDetailTableInfo()
    if MLuaCommonHelper.IsNull(l_achiDetailItem) then
        return original
    end

    local l_oldHrefStr = curInputHrefStr
    curInputHrefStr = StringEx.Format("[{0}]", l_achiDetailItem.Name)
    hrefInfo.param = { id = item.achievementid, rid = MPlayerInfo.UID, time = item.finishtime }
    ----干掉上一个
    return replaceOldHref(original, l_oldHrefStr, curInputHrefStr)
end
function AddSkillPlanHref(original, item, hrefInfo)
    if item == nil then
        return original
    end
    local l_oldHrefStr = curInputHrefStr

    local multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
    local l_showName = multiMgr.GetTalentNameWithFunctionAndIndex(multiMgr.l_skillMultiTalent, item.planId)
    curInputHrefStr = StringEx.Format("[{0}]", l_showName)

    hrefInfo.param = { planId = item.planId, name = l_showName }
    ----干掉上一个
    return replaceOldHref(original, l_oldHrefStr, curInputHrefStr)
end
function AddAttPlanHref(original, item, hrefInfo)
    if item == nil then
        return original
    end
    local l_oldHrefStr = curInputHrefStr

    local multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
    local l_showName = multiMgr.GetTalentNameWithFunctionAndIndex(multiMgr.l_attrMultiTalent, item.planId)
    curInputHrefStr = StringEx.Format("[{0}]", l_showName)

    hrefInfo.param = { planId = item.planId, name = l_showName }
    ----干掉上一个
    return replaceOldHref(original, l_oldHrefStr, curInputHrefStr)
end
function AddClothPlanHref(original, param, hrefInfo)
    local l_oldHrefStr = curInputHrefStr

    local l_showName = Lang("WARDROBE_HREF_STR")
    curInputHrefStr = l_showName
    hrefInfo.param = { planId = 0 }
    ----干掉上一个
    return replaceOldHref(original, l_oldHrefStr, curInputHrefStr)
end
function AddAchievementBadgeHref(original, item, hrefInfo)
    if item == nil then
        return original
    end
    local l_oldHrefStr = curInputHrefStr
    curInputHrefStr = StringEx.Format("[{0}]", item.Name)
    hrefInfo.param = { id = item.Level, rid = MPlayerInfo.UID, point = item.Point, level = item.Level }
    ----干掉上一个
    return replaceOldHref(original, l_oldHrefStr, curInputHrefStr)
end

--添加输入框里的道具内容
---@param item ItemData
function AddPropHref(original, item, hrefInfo)
    if item == nil then
        return original
    end
    local l_row = item.ItemConfig
    if l_row == nil then
        return original
    end

    local l_oldHrefStr = curInputHrefStr
    local l_propUID = tostring(item.UID)
    local l_propLevel = item.RefineLv
    curInputHrefStr = IDToTag(item.TID, l_propLevel)
    hrefInfo.param = { propUID = l_propUID, propLevel = l_propLevel, itemID = item.TID }

    ----干掉上一个
    return replaceOldHref(original, l_oldHrefStr, curInputHrefStr)
end
function AddWatchHref(original, param, hrefInfo)
    hrefInfo.param = { sequence_uid = param }
    return original
end
--endregion

--region 数据转换
-- id => [金矿]
function IDToTag(itemID, level)
    local l_row = TableUtil.GetItemTable().GetRowByItemID(itemID)
    if l_row == nil then
        return nil
    end
    if level <= 0 then
        return StringEx.Format("[{0}]", StringEx.DeleteEmoji(l_row.ItemName))
    else
        return StringEx.Format("[{0}+{1}]", StringEx.DeleteEmoji(l_row.ItemName), level)
    end
end
--@Description:将超链接pack数据转化为图文混排组件能识别的数据
--@param:content 字符内容
--@param:params 超链接pack数据
--@param:hasLink 是否转化为超链接格式
--@param:needInputStr 是否返回inputfield展示用的字符串
--@param:fontSize 道具超链接使用，用于控制图标宽度
function PackToTag(content, params, hasLink, needInputStr, fontSize)
    local l_inputStr = nil
    if content == nil or content == "" then
        return content, l_inputStr
    end

    if params == nil or #params <= 0 then
        return content, l_inputStr
    end
    for i = 1, #params do
        local l_param = params[i]
        if l_param.type == ChatHrefType.Prop then
            content, l_inputStr = propPackToTag(content, l_param, hasLink, needInputStr, fontSize)
        elseif l_param.type == ChatHrefType.AchievementDetails then
            content, l_inputStr = achieveDetailPackToTag(content, l_param, hasLink, needInputStr)
        elseif l_param.type == ChatHrefType.AchievementBadge then
            content, l_inputStr = achieveBadgePackToTag(content, l_param, hasLink, needInputStr)
        elseif l_param.type == ChatHrefType.StoneSculpture then
            content, l_inputStr = stoneSculpturePackToTag(content, l_param, hasLink)
        elseif l_param.type == ChatHrefType.PVP then
            content, l_inputStr = pvpPackToTag(content, l_param, hasLink)
        elseif l_param.type == ChatHrefType.Cooking then
            content, l_inputStr = cookingPackToTag(content, l_param, hasLink)
        elseif l_param.type == ChatHrefType.AttributePlan then
            content, l_inputStr = attrPlanPackToTag(content, l_param, hasLink, needInputStr)
        elseif l_param.type == ChatHrefType.SkillPlan then
            content, l_inputStr = skillPlanPackToTag(content, l_param, hasLink, needInputStr)
        elseif l_param.type == ChatHrefType.ClothPlan then
            content, l_inputStr = clothPlanPackToTag(content, l_param, hasLink, needInputStr)
        elseif l_param.type == ChatHrefType.Watch then
            content, l_inputStr = watchPackToTag(content, l_param, hasLink)
        elseif l_param.type == ChatHrefType.FashionRating then
            content, l_inputStr = fashionRatingPackToTag(content, l_param, hasLink)
        elseif l_param.type == ChatHrefType.Title then
            content, l_inputStr = titlePackToTag(content, l_param, hasLink)
        elseif l_param.type == ChatHrefType.ThemeChallengeConfirm then
            content, l_inputStr = themeChallengeConfirmPackToTag(content, l_param, hasLink)
        elseif l_param.type == ChatHrefType.TreasureHunterAward then
            content, l_inputStr = treasureHunterAwardPackToTag(content, l_param, hasLink)
        end
    end
    return content, l_inputStr
end
--@Description:道具链接
function propPackToTag(content, param, hasLink, needInputStr, fontSize)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.Prop then
        return content, l_inputStr
    end
    if (param.param32 == nil or #param.param32 < 2) or
            (param.param64 == nil or #param.param64 < 1) then
        return content, l_inputStr
    end
    local l_itemID = param.param32[1].value
    local l_level = param.param32[2].value
    local l_count = param.showInfo and param.showInfo.count or 0
    local l_hideIcon = param.showInfo and param.showInfo.hideIcon or false
    local l_uid = param.param64[1].value

    -- todo CLX: 做个标注，这个地方不应该这么传参数
    local l_iconData = {}
    if not l_hideIcon and nil ~= fontSize then
        l_iconData = {
            size = fontSize,
            width = 1,
            anim = false
        }
    end
    local l_itemTextParamData = {
        level = l_level,
        prefix = "[", suffix = "]",
        icon = l_iconData,
        num = Common.Utils.Long2Num(l_count)
    }
    if needInputStr then
        --道具超链接会带图标，Inputfield无法处理，此处需要特殊处理
        local l_row = TableUtil.GetItemTable().GetRowByItemID(l_itemID)
        if l_row ~= nil then
            local l_inputCutStr = StringEx.Format("[{0}]", l_row.ItemName)
            _, l_inputStr = ReplaceFirst(content, MatchLinkPlaceholder, l_inputCutStr)
        end
    end
    l_cutSt = GetItemText(l_itemID, l_itemTextParamData)
    if hasLink then
        l_cutSt = StringEx.Format("<a href=ItemInfoLink|{0}|{1}|{2}>{3}</a>",
                l_itemID, l_level, tostring(l_uid), l_cutSt)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    return content, l_inputStr
end
function achieveDetailPackToTag(content, param, hasLink, needInputStr)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.AchievementDetails then
        return content, l_inputStr
    end
    --成就 lid
    if param.param32 == nil or #param.param32 < 1 or
            param.param64 == nil and #param.param64 < 2 then
        return content, l_inputStr
    end
    local l_inputStr
    local l_id = param.param32[1].value
    local l_rid = param.param64[1].value
    local l_time = param.param64[2].value
    local l_itemRow = TableUtil.GetAchievementDetailTable().GetRowByID(l_id)
    local l_cutSt = ""
    if l_itemRow ~= nil then
        l_cutSt = StringEx.Format("[{0}]", l_itemRow.Name)
        if needInputStr then
            _, l_inputStr = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
        end
        if hasLink then
            l_cutSt = StringEx.Format("<a href=LinkAchievementD|{0}|{1}|{2}>{3}</a>",
                    l_id, tostring(l_rid), tostring(l_time), l_cutSt)
        else
            l_cutSt = GetColorText(l_cutSt, RoColorTag.Blue)
        end
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    return content, l_inputStr
end
function achieveBadgePackToTag(content, param, hasLink, needInputStr)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.AchievementBadge then
        return content, l_inputStr
    end
    --成就 lid
    if param.param32 == nil or #param.param32 < 3 or
            param.param64 == nil or #param.param64 < 1 then
        return content, l_inputStr
    end
    local l_id = param.param32[1].value
    local l_point = param.param32[2].value
    local l_level = param.param32[3].value
    local l_rid = param.param64[1].value
    local l_itemRow = TableUtil.GetAchievementBadgeTable().GetRowByLevel(l_id)
    local l_cutSt = ""
    if l_itemRow == nil then
        return content, l_inputStr
    end
    l_cutSt = StringEx.Format("[{0}]", l_itemRow.Name)
    if needInputStr then
        _, l_inputStr = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    end
    if hasLink then
        l_cutSt = StringEx.Format("<a href=LinkAchievementB|{0}|{1}|{2}|{3}>{4}</a>",
                l_id, l_point, l_level, tostring(l_rid), l_cutSt)
    else
        l_cutSt = GetColorText(l_cutSt, RoColorTag.Blue)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    return content, l_inputStr
end
function treasureHunterAwardPackToTag(content, param, hasLink)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.TreasureHunterAward then
        return content, l_inputStr
    end
    if param.param32 == nil or #param.param32 < 4 then
        return content, l_inputStr
    end
    local posX = param.param32[1].value
    local posY = param.param32[2].value
    local posZ = param.param32[3].value
    local line = param.param32[4].value
    local sceneId = param.param32[5].value
    local l_st = Common.Utils.Lang("GOTO_HELP")
    local l_cutSt = nil

    if hasLink then
        l_cutSt = StringEx.Format("<a href=TreasureHunterAward|{0}|{1}|{2}|{3}|{4}>{5}</a>",
                tostring(posX), tostring(posY), tostring(posZ), tostring(line),tostring(sceneId), l_st)
    else
        l_cutSt = GetColorText(l_st, RoColorTag.Blue)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    return content, l_inputStr
end
function stoneSculpturePackToTag(content, param, hasLink)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.StoneSculpture then
        return content, l_inputStr
    end
    --原石雕刻链接
    if param.param64 == nil or #param.param64 < 3 then
        return content, l_inputStr
    end
    local l_guildId = param.param64[1].value
    local l_iid = param.param64[2].value
    local l_time = param.param64[3].value
    local l_rid = param.param64[4].value
    local l_st = param.name[1]
    local l_cutSt = nil

    if hasLink then
        l_cutSt = StringEx.Format("<a href=LinkStoneSculpture|{0}|{1}|{2}|{3}>{4}</a>",
                tostring(l_guildId), tostring(l_iid), tostring(l_time), tostring(l_rid), l_st)
    else
        l_cutSt = GetColorText(l_st, RoColorTag.Blue)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    return content, l_inputStr
end
function pvpPackToTag(content, param, hasLink)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.PVP then
        return content, l_inputStr
    end
    --PVP
    if param.param32 == nil or #param.param32 < 1 then
        return
    end
    local l_id = param.param32[1].value
    local l_cutSt = nil
    local l_st = Common.Utils.Lang("LINK_PVP_ROOM")
    if hasLink then
        l_cutSt = StringEx.Format("<a href=LinkPvp|{0}>{1}</a>", tostring(l_id), l_st)
    else
        l_cutSt = GetColorText(l_st, RoColorTag.Blue)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    return content, l_inputStr
end
function cookingPackToTag(content, param, hasLink)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.Cooking then
        return content, l_inputStr
    end
    --品尝烹饪
    if param.param32 == nil or #param.param32 < 1 then
        return
    end
    local l_id = param.param32[1].value
    local l_cutSt = nil
    local l_st = Lang("TASTE_DISH")
    if hasLink then
        l_cutSt = StringEx.Format("<a href=LinkCooking|{0}>{1}</a>", tostring(l_id), l_st)
    else
        l_cutSt = GetColorText(l_st, RoColorTag.Blue)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    return content, l_inputStr
end
function attrPlanPackToTag(content, param, hasLink, needInputStr)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.AttributePlan then
        return content, l_inputStr
    end
    --属性方案
    local l_planUUID = nil
    local l_localPlan = 1
    local l_localPlanId = 0

    if param.param64 and #param.param64 == 1 then
        --param64为服务器更新uuid ，param32为客户端更新本地方案id
        l_planUUID = param.param64[1].value
        l_localPlan = 0
    end
    if param.param32 and #param.param32 == 1 then
        l_localPlanId = param.param32[1].value
    end
    if l_planUUID ~= 0 or l_localPlanId ~= 0 then
        local l_name = (param.name and { param.name[1] } or "")[1]
        local l_cutSt = nil
        local l_st = StringEx.Format("[{0}]", l_name)
        if needInputStr then
            _, l_inputStr = ReplaceFirst(content, MatchLinkPlaceholder, l_st)
        end
        if hasLink then
            l_cutSt = StringEx.Format("<a href=AttPlan|{0}|{1}|{2}>{3}</a>", tostring(l_localPlan), tostring(l_planUUID), tostring(l_localPlanId), l_st)
        else
            l_cutSt = GetColorText(l_st, RoColorTag.Blue)
        end

        _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    end
    return content, l_inputStr
end
function skillPlanPackToTag(content, param, hasLink, needInputStr)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.SkillPlan then
        return content, l_inputStr
    end
    --技能方案
    local l_planUUID = 0
    local l_localPlan = 1
    local l_localPlanId = 0
    if param.param64 and #param.param64 == 1 then
        --param64为服务器更新uuid ，param32为客户端更新本地方案id
        l_planUUID = param.param64[1].value
        l_localPlan = 0
    end
    if param.param32 and #param.param32 == 1 then
        l_localPlanId = param.param32[1].value
    end
    if l_planUUID ~= 0 or l_localPlanId ~= 0 then
        local l_cutSt = nil
        local l_name = (param.name and { param.name[1] } or "")[1]
        local l_st = StringEx.Format("[{0}]", l_name)
        if needInputStr then
            _, l_inputStr = ReplaceFirst(content, MatchLinkPlaceholder, l_st)
        end
        if hasLink then
            l_cutSt = StringEx.Format("<a href=SkillPlan|{0}|{1}|{2}>{3}</a>", tostring(l_localPlan), tostring(l_planUUID), tostring(l_localPlanId), l_st)
        else
            l_cutSt = GetColorText(l_st, RoColorTag.Blue)
        end
        _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    end
    return content, l_inputStr
end
function clothPlanPackToTag(content, param, hasLink, needInputStr)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.ClothPlan then
        return content, l_inputStr
    end
    --衣橱展示
    local l_planUUID = 0
    local l_localPlan = 1
    local l_localPlanId = 1
    if param.param64 and #param.param64 == 1 then
        --param64为服务器更新uuid ，param32为客户端更新本地方案id
        l_planUUID = param.param64[1].value
        l_localPlan = 0
    end
    if l_planUUID ~= 0 or l_localPlanId ~= 0 then
        local l_cutSt = nil
        local l_st = Lang("WARDROBE_HREF_STR")
        if needInputStr then
            _, l_inputStr = ReplaceFirst(content, MatchLinkPlaceholder, l_st)
        end
        if hasLink then
            l_cutSt = StringEx.Format("<a href=ClothPlan|{0}|{1}|{2}>{3}</a>", tostring(l_localPlan), tostring(l_planUUID), tostring(l_localPlanId), l_st)
        else
            l_cutSt = GetColorText(l_st, RoColorTag.Blue)
        end
        _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    end
    return content, l_inputStr
end
function watchPackToTag(content, param, hasLink)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.Watch then
        return content, l_inputStr
    end
    if param.param64 == nil or #param.param64 < 1 then
        return
    end
    local l_id = param.param64[1].value
    local l_cutSt = nil
    local l_st = Lang("ENTER_WATCH_ROOM")
    if hasLink then
        l_cutSt = StringEx.Format("<a href=LinkWatch|{0}>{1}</a>", l_id, l_st)
    else
        l_cutSt = GetColorText(l_st, RoColorTag.Blue)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)

    return content, l_inputStr
end
function fashionRatingPackToTag(content, param, hasLink)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.FashionRating then
        return content, l_inputStr
    end
    if param.param64 == nil or #param.param64 < 1 or
            param.param32 == nil and #param.param32 < 1 then
        return
    end
    --时尚评分
    local l_rid = param.param64[1].value
    local l_photoid = param.param32[1].value
    local l_cutSt = nil
    local l_st = StringEx.Format("[{0}]", Lang("FashionRatingTapToViewPic"))
    if needInputStr then
        _, l_inputStr = ReplaceFirst(content, MatchLinkPlaceholder, l_st)
    end
    if hasLink then
        l_cutSt = StringEx.Format("<a href=LinkFashionRating|{0}|{1}>{2}</a>", tostring(l_rid), tostring(l_photoid), l_st)
    else
        l_cutSt = GetColorText(l_st, RoColorTag.Blue)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)
    return content, l_inputStr
end

function titlePackToTag(content, param, hasLink)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.Title then
        return content, l_inputStr
    end
    if param.param32 == nil or #param.param32 < 1 then
        return
    end
    local l_titleId = param.param32[1].value
    local l_isOwned = param.param32[2].value
    local l_titleName = param.name[1]
    local l_roleName = param.name[2]
    local l_cutSt = nil
    if hasLink then
        l_cutSt = StringEx.Format("<a href=Title|{0}|{1}|{2}>{3}</a>", l_titleId, l_isOwned, l_roleName, l_titleName)
    else
        l_cutSt = GetColorText(l_titleName, RoColorTag.Blue)
    end
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)

    return content, l_inputStr
end

function themeChallengeConfirmPackToTag(content, param, hasLink)
    local l_inputStr = nil
    if param.type ~= ChatHrefType.ThemeChallengeConfirm then
        return content, l_inputStr
    end
    if #param.name == 0 or #param.param32 == 0 then
        return
    end
    local l_dungeonName = param.name[1]
    local l_dungeonId = param.param32[1].value
    local l_hardLevel = param.param32[2].value
    local l_cutSt = nil
    if hasLink then
        l_cutSt = StringEx.Format("<a href=ThemeChallengeConfirm|{0}|{1}>{2}</a>", l_dungeonId, l_hardLevel, Lang("POWER_RECOMMEND"))
    else
        l_cutSt = GetColorText(Lang("POWER_RECOMMEND"), RoColorTag.Blue)
    end
    l_cutSt = Lang("THEME_CHALLENGE_CONFIRM", l_dungeonName, l_cutSt)
    _, content = ReplaceFirst(content, MatchLinkPlaceholder, l_cutSt)

    return content, l_inputStr
end

function PackToString(pack)
    if pack == nil or #pack <= 0 then
        return nil
    end
    local l_data = {}
    for i = 1, #pack do
        local l_cur = {
            type = pack[i].type,
            param32 = {},
            param64 = {},
            name = {},
        }
        l_data[#l_data + 1] = l_cur
        local l_pack = pack[i]
        if l_pack ~= nil then
            if l_pack.param32 ~= nil then
                for j = 1, #l_pack.param32 do
                    l_cur.param32[j] = {
                        value = l_pack.param32[j].value
                    }
                end
            end
            if l_pack.param64 ~= nil then
                for j = 1, #l_pack.param64 do
                    l_cur.param64[j] = {
                        value = tostring(l_pack.param64[j].value)
                    }
                end
            end
            if l_pack.name ~= nil then
                for j = 1, #l_pack.name do
                    l_cur.name[j] = l_pack.name[j]
                end
            end
        end
    end
    return Common.Serialization.Serialize(l_data)
end
function StringToPack(str)
    if str == nil or type(str) ~= "string" or str == "" then
        return
    end
    return Common.Serialization.Deserialize(str)
end
--获取玩家名字超链接的字符串
function GetPlayerInfoLinkStr(playerName)
    local l_linkStr = "<a href=ShowPlayerDetail>{0}</a>"
    if playerName then
        l_linkStr = StringEx.Format(l_linkStr, playerName)
    end
    return l_linkStr
end

---@param param ExtraParam[]
---@return MagicletterParam
function GetMagicLetterInfoByExtraParam(param)
    for i = 1, #param do
        local l_magicParam = param[i]
        if l_magicParam.type == ChatHrefType.MagicLetter then
            local l_letterInfo=
            {
                letterUid = l_magicParam.param64[1].value,
                receiveRoleUid = l_magicParam.param64[2].value,
                receiveRoleName = l_magicParam.name[1]
            }
            return l_letterInfo
        end
    end
end
--endregion

--region 通用方法
function UpdateCurHrefInfo(param)
    if param == nil then
        return
    end
    local l_curParam = param[1]
    if l_curParam == nil then
        return
    end
    local l_hrefInfo = GetHrefInfoByPack(l_curParam)
    if l_hrefInfo == nil then
        logError("UpdateCurHrefInfo failed!")
        return
    end
    curHrefInfo = l_hrefInfo
end
function GetHrefInfoByPack(pack)
    if pack == nil then
        return
    end
    local l_hrefInfo = {
        type = pack.type,
        param = {}
    }
    local l_inputHrefStr = nil
    if pack.type == ChatHrefType.Prop then
        --道具链接
        if (pack.param32 ~= nil and #pack.param32 >= 2) and
                (pack.param64 ~= nil and #pack.param64 >= 1) then
            l_hrefInfo.param.itemID = pack.param32[1].value
            l_hrefInfo.param.propLevel = pack.param32[2].value
            l_hrefInfo.param.propUID = pack.param64[1].value
            l_inputHrefStr = IDToTag(l_hrefInfo.param.itemID, l_hrefInfo.param.propLevel)
        end
    elseif pack.type == ChatHrefType.AchievementDetails then
        --成就 lid
        if (pack.param32 ~= nil and #pack.param32 >= 1) and
                (pack.param64 ~= nil and #pack.param64 >= 2) then
            l_hrefInfo.param.id = pack.param32[1].value
            l_hrefInfo.param.rid = pack.param64[1].value
            l_hrefInfo.param.time = pack.param64[2].value
            local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")
            local l_achiDetailItem = l_achievementMgr.GetAchievementTableInfoWithId(l_hrefInfo.param.id)
            if not MLuaCommonHelper.IsNull(l_achiDetailItem) then
                l_inputHrefStr = StringEx.Format("[{0}]", l_achiDetailItem.Name)
            end
        end
    elseif pack.type == ChatHrefType.AchievementBadge then
        --成就 lid
        if (pack.param32 ~= nil and #pack.param32 > 2) and
                (pack.param64 ~= nil and #pack.param64 >= 1) then
            l_hrefInfo.param.id = pack.param32[1].value
            l_hrefInfo.param.point = pack.param32[2].value
            l_hrefInfo.param.level = pack.param32[3].value
            l_hrefInfo.param.rid = pack.param64[1].value
            local l_itemRow = TableUtil.GetAchievementBadgeTable().GetRowByLevel(l_hrefInfo.param.id)
            if not MLuaCommonHelper.IsNull(l_itemRow) then
                l_inputHrefStr = StringEx.Format("[{0}]", l_itemRow.Name)
            end
        end
    elseif pack.type == ChatHrefType.SkillPlan then
        --技能方案
        local l_name
        if pack.param32 ~= nil and #pack.param32 >= 1 then
            l_hrefInfo.param.planId = pack.param32[1].value
            if pack.name ~= nil then
                l_name = pack.name[1]
                l_hrefInfo.param.name = l_name
                l_inputHrefStr = StringEx.Format("[{0}]", l_name)
            end
        end
    elseif pack.type == ChatHrefType.AttributePlan then
        --属性方案
        local l_name
        if pack.param32 ~= nil and #pack.param32 >= 1 then
            l_hrefInfo.param.planId = pack.param32[1].value
            if pack.name ~= nil then
                l_name = pack.name[1]
                l_hrefInfo.param.name = l_name
                l_inputHrefStr = StringEx.Format("[{0}]", l_name)
            end
        end
    elseif pack.type == ChatHrefType.Watch then
        local l_name
        if pack.param64 ~= nil and #pack.param64 >= 1 then
            l_hrefInfo.param.sequence_uid = pack.param64[1].value
            if pack.name ~= nil then
                l_name = pack.name[1]
                l_hrefInfo.param.name = l_name
                l_inputHrefStr = StringEx.Format("[{0}]", l_name)
            end
        end
    elseif pack.type == ChatHrefType.ClothPlan then
        --衣橱方案
        if pack.param32 ~= nil and #pack.param32 >= 1 then
            l_hrefInfo.param.planId = pack.param32[1].value
            l_inputHrefStr = Lang("WARDROBE_HREF_STR")
        end

    end
    if l_inputHrefStr == nil then
        return nil
    end
    curInputHrefStr = l_inputHrefStr
    return l_hrefInfo
end
--发送时替换文本
function ReplaceSendMsg(original)
    if Common.Utils.IsNilOrEmpty(original) or curHrefInfo == nil then
        return original, nil
    end

    local l_pack = getHrefPack()
    if l_pack == nil then
        return original, nil
    end
    local l_CurInputItemSt = curInputHrefStr
    l_CurInputItemSt = string.sub(l_CurInputItemSt, 2, -2)
    l_CurInputItemSt = string.gsub(l_CurInputItemSt, "%[", "%%%[")
    l_CurInputItemSt = string.gsub(l_CurInputItemSt, "%]", "%%%]")
    l_CurInputItemSt = string.gsub(l_CurInputItemSt, "%+", "%%%+")
    l_CurInputItemSt = string.gsub(l_CurInputItemSt, "%-", "%%%-")
    l_CurInputItemSt = "%[" .. l_CurInputItemSt .. "%]"
    local l_has, l_newSt = ReplaceFirst(original, l_CurInputItemSt, LinkPlaceholder)
    if l_has then
        return l_newSt, l_pack
    else
        return original, nil
    end
end
function clickPropItemHrefInfo(param, paramLength)
    if paramLength < 4 then
        return
    end
    local l_id = param[2]
    local l_level = param[3]
    local l_uid = param[4] or 0

    l_uid= ToUInt64(l_uid)

    local l_extraData = extraData
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_id)
    if l_itemRow and (l_uid:equals(0) or not needShowItemDetailInfoByType(l_itemRow.TypeTab)) then
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_id, nil, nil, nil, false, l_extraData)
    else
        MgrMgr:GetMgr("ItemMgr").GetItemByUniqueId(l_uid, function(itemInfo, error)
            if itemInfo ~= nil then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(itemInfo, nil, nil, nil, nil, l_extraData)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LinkInput_Miss")) --道具已经不存在
            end
        end)
    end
end

function needShowItemDetailInfoByType(type)
    return type == GameEnum.EItemType.Equip or type == GameEnum.EItemType.BelluzGear
end

function clickAchievementDetailHrefInfo(param, paramLength)
    if paramLength < 4 then
        return
    end
    local l_id = tonumber(param[2])
    local l_rid = param[3]
    local l_time = param[4]
    UIMgr:ActiveUI(UI.CtrlNames.AchievementDetails, function(ctrl)
        local l_isAchievementDetailsShowShare = false
        if extraData ~= nil then
            l_isAchievementDetailsShowShare = extraData.IsAchievementDetailsShowShare
        end
        ctrl:ShowDetails(l_id, l_rid, l_time, l_isAchievementDetailsShowShare)
    end)
end
function clickAchievementBadgeHrefInfo(param, paramLength)
    if paramLength < 5 then
        return
    end
    local l_id = tonumber(param[2])
    local l_point = tonumber(param[3])
    local l_level = tonumber(param[4])
    local l_rid = param[5]
    UIMgr:ActiveUI(UI.CtrlNames.AchievementBadge, function(ctrl)
        ctrl:ShowBadge(l_point, l_level, l_rid)
    end)
end
function clickOpenSystemHrefInfo(param,paramLength)
    if paramLength <2 then
        return
    end
    local l_openSystemID = tonumber(param[2])
    Common.CommonUIFunc.InvokeFunctionByFuncId(l_openSystemID)
end
function clickTreasureHunterAwardHrefInfo(param,paramLength)
    if paramLength <6 then
        return
    end
    local posX = tonumber(param[2])
    local posY = tonumber(param[3])
    local posZ = tonumber(param[4])
    local line = tonumber(param[5])
    local sceneID = tonumber(param[6])
    local pos = Vector3.New(posX,posY,posZ)
    MTransferMgr:GotoPosition(sceneID, pos, function()
        if MScene.SceneLine ~= line then
            MgrMgr:GetMgr("SettingMgr").ChangeLine(line)
        end
    end)
end
function clickStoneSculptureHrefInfo(param, paramLength)
    if paramLength < 5 then
        return
    end
    local l_guildId = param[2]
    local l_time = param[4]
    local l_rid = param[5]
    --[[if MServerTimeMgr.UtcSeconds >= MLuaCommonHelper.Long(l_time)
        or tostring(DataMgr:GetData("GuildData").selfGuildMsg.id) ~= l_guildId then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LINK_LOSE")) --道具已经不存在
    else]]
    MgrMgr:GetMgr("StoneSculptureMgr").TryHelp(l_rid)
    --end
end
function clickSkillPlanHrefInfo(param, paramLength,chatData)
    if paramLength < 4 then
        return
    end
    local l_localPlan = param[2] == "1"
    local l_planId = param[3]
    local l_localPlanId = param[4]
    if not l_localPlan then
        --超链接这里接收不到playerInfo.data中的数据都以本地数据展示
        local l_isSelf = chatData == nil or chatData.playerInfo == nil or chatData.playerInfo.data == nil
        if l_isSelf then
            l_localPlan = true
            l_planId = l_localPlanId
        end
    end
    MgrMgr:GetMgr("ChatMgr").ShowSpecialShareInfo(l_planId, l_localPlanId, ChatHrefType.SkillPlan, chatData, l_localPlan)
end
function clickAttributePlanHrefInfo(param, paramLength,chatData)
    if paramLength < 4 then
        return
    end
    local l_localPlan = param[2] == "1"
    local l_planId = param[3]
    local l_localPlanId = param[4]
    if not l_localPlan then
        local l_isSelf = chatData == nil or chatData.playerInfo == nil or chatData.playerInfo.data == nil
        if l_isSelf then
            l_localPlan = true
            l_planId = l_localPlanId
        end
    end
    MgrMgr:GetMgr("ChatMgr").ShowSpecialShareInfo(l_planId, l_localPlanId, ChatHrefType.AttributePlan, chatData, l_localPlan)
end

function clickClothPlanHrefInfo(param, paramLength,chatData)
    if paramLength < 4 then
        return
    end
    local l_localPlan = param[2] == "1"
    local l_planId = param[3]
    local l_localPlanId = param[4]
    if not l_localPlan then
        --超链接这里接收不到playerInfo.data中的数据都以本地数据展示
        local l_isSelf = chatData == nil or chatData.playerInfo == nil or chatData.playerInfo.data == nil
        if l_isSelf then
            l_localPlan = true
            l_planId = l_localPlanId
        end
    end
    MgrMgr:GetMgr("ChatMgr").ShowSpecialShareInfo(l_planId, l_localPlanId, ChatHrefType.ClothPlan, chatData, l_localPlan)
end
--点击超连接的回调，并解析其内容
function ClickHrefInfo(key, extraData, chatData)

    local l_infos = string.ro_split(key, "|")
    if #l_infos < 1 then
        return
    end
    local l_tag = l_infos[1]
    local l_infoNum = #l_infos
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_chatDataMgr=DataMgr:GetData("ChatData")
    --道具链接
    if l_tag == "ItemInfoLink" then
        clickPropItemHrefInfo(l_infos, l_infoNum)
        --玩家名字链接
    elseif l_tag == "ShowPlayerDetail" then
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(MLuaCommonHelper.Long(chatData.aimPlayerId))
        --成就链接Details
    elseif l_tag == "LinkAchievementD" then
        clickAchievementDetailHrefInfo(l_infos, l_infoNum)
        --成就链接Badge
    elseif l_tag == "LinkAchievementB" then
        clickAchievementBadgeHrefInfo(l_infos, l_infoNum)
        --原石雕琢链接
    elseif l_tag == "LinkStoneSculpture" then
        clickStoneSculptureHrefInfo(l_infos, l_infoNum)
        --pvp
    elseif l_tag == "LinkPvp" then
        if l_infoNum >= 2 then
            local l_id = l_infos[2]
            MgrMgr:GetMgr("PvpArenaMgr").ActiveJoinArenaRoom({ id = l_id })
        end
        --公会参与建设
    elseif key == "AttenGuildBuild" then
        MgrMgr:GetMgr("GuildBuildMgr").OpenGuildAttendBuildPanel(chatData.guildBuildActiveId)
        --前往祈福（华丽水晶）
    elseif key == "GoToPray" then
        MgrMgr:GetMgr("GuildCrystalMgr").ReqCheckCrystalChargeAnnounce(chatData.guildCrystalChargeAnnounceId)
        --品尝烹饪
    elseif l_tag == "LinkCooking" then
        if l_infoNum >= 2 then
            local l_id = l_infos[2]
            MgrMgr:GetMgr("GuildDinnerMgr").ClickLinkToTasteDish(l_id)
        end
        --技能方案
    elseif l_tag == "SkillPlan" then
        clickSkillPlanHrefInfo(l_infos, l_infoNum,chatData)
        --属性方案
    elseif l_tag == "AttPlan" then
        clickAttributePlanHrefInfo(l_infos, l_infoNum,chatData)
        --衣橱方案
    elseif l_tag == "ClothPlan" then
        clickClothPlanHrefInfo(l_infos, l_infoNum,chatData)
        --观战
    elseif l_tag == "LinkWatch" then
        if l_infoNum >= 2 then
            local l_id = tonumber(l_infos[2])
            MgrMgr:GetMgr("WatchWarMgr").RequestGetWatchRoomInfo(0, l_id)
        elseif chatData.roomID ~= nil then
            MgrMgr:GetMgr("WatchWarMgr").RequestGetWatchRoomInfo(0, chatData.roomID)
        end
        --时尚评分
    elseif l_tag == "LinkFashionRating" then
        if l_infoNum >= 3 then
            MgrMgr:GetMgr("FashionRatingMgr").ClickLinkToShowPhoto(l_infos[2], tonumber(l_infos[3]))
        end
    elseif l_tag == "Title" then
        if l_infoNum >= 4 then
            local l_titleId = tonumber(l_infos[2])
            local l_isOwned = tonumber(l_infos[3])
            local l_roleName = l_infos[4]
            MgrMgr:GetMgr("TitleStickerMgr").OnTitleShareClicked(l_titleId, l_isOwned, l_roleName)
        end
    elseif l_tag == "ThemeChallengeConfirm" then            -- 挑战副本战前确认
        if l_infoNum >= 2 then
            local l_dungeonId = tonumber(l_infos[2])
            local l_hardLevel = tonumber(l_infos[3])
            MgrMgr:GetMgr("ThemeDungeonMgr").OnShareChallengeConfirmClicked(l_dungeonId, l_hardLevel)
        end
        --公会会匹配赛结果
    elseif l_tag == "GuildMatchResult" then
        MgrMgr:GetMgr("GuildMatchMgr").GetGuildBattleResult()
        --公会匹配赛观战分享
    elseif l_tag == "GuildMatchShare" then
        MgrMgr:GetMgr("WatchWarMgr").RequestWatchRoom(chatData.roomID)
    elseif l_tag == "LinkCapraFAQ" then
        MgrMgr:GetMgr("CapraFAQMgr").OpenConsultationPanel(l_infos[2])
    elseif l_tag == "GuildLake" then
        local labStr = extraData.originText.LabText
        local data = l_chatMgr.chatNewsZdTable[l_chatMgr.currentChannel] and l_chatMgr.chatNewsZdTable[l_chatMgr.currentChannel].otherInfo
        local l_txtTitle = ""
        local l_content = ""
        local l_default = ""
        local l_announceData = nil
        if data then
            l_txtTitle = Lang(data.CongratulationTitle)
            l_content = l_chatMgr.chatNewsZdTable[l_chatMgr.currentChannel].zdNewsText
            l_default = Lang(data.CongratulationTalk)
            l_announceData = l_chatMgr.chatNewsZdTable[l_chatMgr.currentChannel].announceData
        end
        ----字符串处理 找到和我们存储的一样的
        local l_mainInfo = string.gsub(labStr, Lang("GUILD_LAKE_R"), "")
        local saveText = string.gsub(l_mainInfo, ' ', "")
        ----
        local likesData = l_chatMgr.chatNewsLikesTable[saveText] and l_chatMgr.chatNewsLikesTable[saveText].otherInfo
        if likesData then
            l_txtTitle = Lang(likesData.CongratulationTitle)
            l_content = l_chatMgr.chatNewsLikesTable[saveText].zdNewsText
            l_default = Lang(likesData.CongratulationTalk)
            l_announceData = l_chatMgr.chatNewsLikesTable[saveText].announceData
        end
        local l_additionData = {announceData = l_announceData}
        if data or likesData then
            --是否是自己判定--
            local a,b = string.find(labStr,MPlayerInfo.Name)
            if a and b then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CAN_NOT_LIKES"))
                return
            end
            -------------
            if MgrMgr:GetMgr("GuildMgr").GuildNewsGetLakeState(l_content) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_LAKED"))
                return
            end
            MgrMgr:GetMgr("TipsMgr").ShowLikesDialog(l_txtTitle,l_content,l_default,l_additionData,function (sendMsg)
                if MgrMgr:GetMgr("GuildMgr").SendGuildNewsMsg(sendMsg) then
                    extraData.originText.LabText = MgrMgr:GetMgr("GuildMgr").ShowAlreadyLaked(labStr)
                end
            end)
        end
    elseif l_tag == "GuildAgree" then --公会附议
        local l_showText = string.gsub(l_infos[2],"&&"," ")
        local l_isSelf = l_infos[3] and l_infos[3] == tostring(MPlayerInfo.UID)
        if l_isSelf then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CAN_NOT_AGREE"))
            return
        end
        l_chatMgr.SendChatMsg(MPlayerInfo.UID, l_showText, l_chatDataMgr.EChannel.GuildChat)
    elseif l_tag == "TreasureHunterAward" then
        clickTreasureHunterAwardHrefInfo(l_infos, l_infoNum)
    elseif l_tag == "OpenSystem" then
        clickOpenSystemHrefInfo(l_infos, l_infoNum)
    elseif l_tag == "ShowServerLevelInfo" then
        UIMgr:ActiveUI(UI.CtrlNames.HrefTipCollect,{ hrefType = ChatHrefType.ShowServerLevel})
    end
end

function replaceOldHref(original, oldHrefStr, newHrefStr)
    if oldHrefStr ~= nil then
        oldHrefStr = string.sub(oldHrefStr, 2, -2)
        oldHrefStr = string.gsub(oldHrefStr, "%[", "%%%[")
        oldHrefStr = string.gsub(oldHrefStr, "%]", "%%%]")
        oldHrefStr = string.gsub(oldHrefStr, "%+", "%%%+")
        oldHrefStr = string.gsub(oldHrefStr, "%-", "%%%-")
        oldHrefStr = "%[" .. oldHrefStr .. "%]"
        local l_has, l_newSt = ReplaceFirst(original, oldHrefStr, newHrefStr)
        if l_has then
            return l_newSt
        end
    end
    return original .. curInputHrefStr
end
--替换第一个
function ReplaceFirst(original, Ast, Bst)
    Ast = "(" .. Ast .. ")"
    local l_indexA, l_indexB, _ = string.find(original, Ast, 1)
    if l_indexA ~= nil and l_indexB ~= nil then
        return true, string.sub(original, 1, l_indexA - 1) .. Bst .. string.sub(original, l_indexB + 1, -1)
    else
        return false, original
    end
end
--endregion

return LinkInputMgr