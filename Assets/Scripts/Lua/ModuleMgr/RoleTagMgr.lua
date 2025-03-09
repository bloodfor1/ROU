-- 用户标签管理
module("ModuleMgr.RoleTagMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
RoleTagChangeEvent = "RoleTagChangeEvent"

---@type RoleTagData
roleTagData = DataMgr:GetData("RoleTagData")


function OnRoleTagCommonData(tagId, value)
    -- logError(StringEx.Format("{0}: {1}", tagId, value))
    value = tonumber(value)
    local l_tagInfo = GetTagInfoById(tagId)
    if l_tagInfo then
        -- 称号收回后弹提示
        if l_tagInfo.isActive and value == 0 then
            local l_tipStr = "TAG_DISAPPEAR_" .. l_tagInfo.id
            -- 判断是否存在
            if l_tipStr ~= Lang(l_tipStr) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang(l_tipStr))
            end
        end
        l_tagInfo.isActive = value > 0
    end

    RefreshShownTagId()
end

function RefreshShownTagId()
    MPlayerInfo.ShownTagId = GetActiveTagId()
    EventDispatcher:Dispatch(RoleTagChangeEvent)
end

function OnInit()
    -- 通用数据协议处理称号
    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_ROLE_TAG,
        Callback = OnRoleTagCommonData,
    })

    l_commonData:Init(l_data)
end

-- 通过协议中的数据设置用户标签
function SetTag(tagImgCom, tagId)
    tagId = tagId or 0
    tagImgCom:SetActiveEx(tagId ~= 0)
    LayoutRebuilder.ForceRebuildLayoutImmediate(tagImgCom.transform.parent)
    if tagId ~= 0 then
        local l_labelRow = TableUtil.GetLabelTable().GetRowByLabelId(tagId)
        if l_labelRow then
            tagImgCom:SetSpriteAsync(l_labelRow.LabelAtlas, l_labelRow.LabelIcon, nil, true)
        end
    end
end


return ModuleMgr.RoleTagMgr