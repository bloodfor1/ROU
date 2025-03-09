--管理邮件信息
---@module ModuleMgr.EmailMgr
module("ModuleMgr.EmailMgr", package.seeall)

--邮件数据
Datas = {}
--事件
EventDispatcher = EventDispatcher.new()
EventType = {
    Init = "Init",
    Remove = "Remove",
    Reset = "Reset",
    WorldMsg = "WorldMsg",
}

ShowWorldMsg = false
CurrentSelectIndex = 0
local _needSegmentationMailId = MGlobalConfig:GetSequenceOrVectorInt("CurrencySegmentationMail")

function OnLogout()
    ShowWorldMsg = false
end

--清除数据
function ClearData()
    Datas = {}
end

function _isNeedSegmentationMailWithId(mailId)
    if _needSegmentationMailId == nil then
        return false
    end
    for i = 1, _needSegmentationMailId.Length do
        if _needSegmentationMailId[i - 1] == mailId then
            return true
        end
    end
    return false
end

--请求拉取email简要信息
function RequestGetMailList()
    local l_msgId = Network.Define.Rpc.GetMailList
    ---@type GetMailListArg
    local l_sendInfo = GetProtoBufSendTable("GetMailListArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function GetMail(id)
    local l_idst = tostring(id)
    local l_count = #Datas
    for i = 1, l_count do
        if Datas[i].id == l_idst then
            return Datas[i]
        end
    end
end

--接收email简要信息
function OnGetMailList(msg)
    ---@type GetMailListRes
    local l_resInfo = ParseProtoBufToTable("GetMailListRes", msg)
    Datas = {}
    for i = 1, #l_resInfo.mails do
        local l_baseInfo = l_resInfo.mails[i]
        local l_data = {}
        l_data.id = tostring(l_baseInfo.mail_uid)
        l_data.baseInfo = l_baseInfo
        l_data.detail = nil --详情
        l_data.title = ""
        l_data.content = ""
        l_data.npcData = nil --npc信息
        l_data.raw = TableUtil.GetMailTable().GetRowById(l_data.baseInfo.mail_id)
        --剩余时间
        l_data.residueTime = MLuaCommonHelper.Long2Int(l_baseInfo.expire_time) - MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)

        if l_data.raw ~= nil and l_data.residueTime > 0 then
            Datas[#Datas + 1] = l_data

            if l_data.raw.Sender ~= 0 then
                l_data.npcData = TableUtil.GetNpcTable().GetRowById(l_data.raw.Sender)
            end

            --非临时邮件填充内容
            if l_data.raw.IsTemplate then
                l_data.title = l_data.raw.Title
                l_data.content = l_data.raw.Content

            elseif l_baseInfo.extra_info ~= nil then
                l_data.title = l_baseInfo.extra_info.title or "nil"
            else
                l_data.title = "?"
            end

            --标题的参数
            if l_baseInfo.match_title ~= nil and l_baseInfo.match_title ~= "" then
                local l_matchs = {}
                for k, v in ipairs(l_baseInfo.match_title.local_name_list) do
                    table.insert(l_matchs, Lang(v))
                end

                l_data.title = StringEx.Format(l_data.title, unpack(l_matchs))
            end

            --标题长度限制
            local l_clampSt = GetNumberClamp("MailTitleLenMax")
            if l_clampSt > 0 then
                if string.ro_len(l_data.title) > l_clampSt then
                    l_data.title = string.ro_cut(l_data.title, l_clampSt);
                end
            end
        else
            if l_data.raw == nil then
                logError("接收到未知模板类型的邮件,忽略显示 id=>" .. tostring(l_data.baseInfo.mail_id))
            end
        end
    end

    --排序优先级：未读>发送时间
    table.sort(Datas, function(a, b)
        if a.baseInfo.is_read ~= b.baseInfo.is_read then
            return GetBoolValue(b.baseInfo.is_read) > GetBoolValue(a.baseInfo.is_read)
        else
            --- 未阅读情况下，重要邮件优先排列
            if not a.baseInfo.is_read and a.raw.ImportantMail ~= b.raw.ImportantMail then
                return a.raw.ImportantMail > 0
            end
        end
        return a.baseInfo.create_time > b.baseInfo.create_time
    end)

    EventDispatcher:Dispatch(EventType.Init, nil)
end

function GetBoolValue(b)
    if b then
        return 1
    else
        return 0
    end
end

--请求email详细信息
function RequestGetOneMail(data)
    local l_msgId = Network.Define.Rpc.GetOneMail
    ---@type GetOneMailArg
    local l_sendInfo = GetProtoBufSendTable("GetOneMailArg")
    l_sendInfo.mail_uid = data.id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收email详细信息
function OnGetOneMail(msg)
    ---@type GetOneMailRes
    local l_resInfo = ParseProtoBufToTable("GetOneMailRes", msg)
    local l_baseInfo = l_resInfo.mail_info.base_info

    local l_data = GetMail(l_baseInfo.mail_uid)
    if l_data == nil then
        logError("接收到不存在的email详细信息 => id=" .. tostring(l_baseInfo.mail_uid))
        return
    end

    l_data.detail = l_resInfo.mail_info.content_info
    --非模板数据填充
    if not l_data.raw.IsTemplate then
        --正文
        l_data.content = l_data.detail.content or ""
        l_data.content = string.gsub(l_data.content, "\\n", "\n")
    end

    --判断是否需要匹配参数  2018/07/18 cmd
    l_data.content = l_data.content or ""
    if l_data.detail.match_content ~= nil then
        local l_matchs = {}
        if l_data.baseInfo.mail_id == 1008 then
            --公会拍卖不定数个物品名称连接成一个
            local l_strMultiple = "\r\n"
            for k, v in ipairs(l_data.detail.match_content.local_name_list) do
                l_strMultiple = l_strMultiple .. Lang(v) .. "\r\n"
            end
            --多名称拼接放在参数列表的最后
            table.insert(l_matchs, l_strMultiple)
        else
            for k, v in ipairs(l_data.detail.match_content.local_name_list) do
                local text = Lang(v)
                if _isNeedSegmentationMailWithId(l_baseInfo.mail_id) then
                    text = MNumberFormat.GetNumberFormat(text)
                end
                table.insert(l_matchs, text)
            end
        end

        l_data.content = StringEx.Format(l_data.content, unpack(l_matchs))
    end

    --发送者名字
    local l_sendName
    if string.ro_isEmpty(l_data.detail.send_name) then
        if l_data.npcData then
            l_sendName = l_data.npcData.Name
        end
    else
        l_sendName = l_data.detail.send_name
    end

    if l_sendName == nil then
        l_sendName = l_data.raw.SendName
    end
    l_data.SendName = l_sendName

    --发送者名字匹配参数
    local l_sendNameMatch = l_data.detail.match_send_name
    if l_sendNameMatch and l_sendNameMatch.local_name_list and #l_sendNameMatch.local_name_list > 0 then
        local l_matchs = {}
        for k, v in ipairs(l_sendNameMatch.local_name_list) do
            table.insert(l_matchs, Lang(v))
        end
        l_data.SendName = StringEx.Format(l_data.SendName, unpack(l_matchs))
    end

    --约束内容长度
    local l_clampSt = GetNumberClamp("MailContentLenMax")
    if l_clampSt > 0 then
        local l_expand = MoonClient.DynamicEmojHelp.GetInputTextEmojiLength(l_data.content);
        if string.ro_len(l_data.content) > l_clampSt + l_expand then
            l_data.content = string.ro_cut(l_data.content, l_clampSt + l_expand);
        end
    end

    --来自协议的道具数据
    local l_rewards = {}
    l_data.raward = l_rewards

    --奖励数据来源之一：道具列表
    local l_items = l_data.detail.mail_items
    if l_items ~= nil and #l_items > 0 then
        for i = 1, #l_items do
            ---@type Item
            local l_item = l_items[i]
            if l_item.uid ~= nil and l_item.uid ~= 0 then
                l_rewards[#l_rewards + 1] = {
                    PropInfo = Data.BagModel:CreateLocalItemData(l_item)
                }
            elseif l_item.ItemID ~= nil and l_item.ItemID ~= 0 then
                ---@type ItemData
                local itemData = Data.BagModel:CreateItemWithTid(l_item.ItemID)
                itemData.ItemCount = ToInt64(l_item.ItemCount)
                itemData.IsBind = l_item.is_bind
                itemData.CreateTime = l_item.create_time
                l_rewards[#l_rewards + 1] = {
                    PropInfo = itemData
                }
            else
                logError("收到来自服务的错误道具ID => id=" .. tostring(l_item.item_id))
            end
        end
    end

    --实例道具
    local l_ro_items = l_data.detail.ro_items
    if l_ro_items and #l_ro_items > 0 then
        for i = 1, #l_ro_items do
            local l_item = l_ro_items[i]
            if l_item.uid ~= nil and l_item.uid ~= 0 then
                l_rewards[#l_rewards + 1] = {
                    PropInfo = Data.BagApi:CreateFromRoItemData(l_item)
                }
            end
        end
    end

    --奖励数据来源之一：awardID
    if l_data.detail.award_id ~= nil and l_data.detail.award_id ~= 0 then
        local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(l_data.detail.award_id)
        if l_awardData ~= nil then
            for i = 0, l_awardData.PackIds.Length - 1 do
                local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
                if l_packData ~= nil then
                    for j = 0, l_packData.GroupContent.Count - 1 do
                        l_rewards[#l_rewards + 1] = {
                            ID = tonumber(l_packData.GroupContent:get_Item(j, 0)),
                            Count = tonumber(l_packData.GroupContent:get_Item(j, 1))
                        }
                    end
                end
            end
        end
    end

    EventDispatcher:Dispatch(EventType.Reset, l_data)
end

--请求操作邮件状态：领取，删除
function RequestMailOp(data, opType)
    --logError(StringEx.Format("请求邮件操作 => {0}",opType))

    local l_msgId = Network.Define.Rpc.MailOp
    ---@type MailOpArg
    local l_sendInfo = GetProtoBufSendTable("MailOpArg")
    l_sendInfo.op_type = opType
    if data ~= nil then
        l_sendInfo.mail_uid = data.id
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--邮件操作返回消息
function OnMailOp(msg)
    ---@type MailOpRes
    local l_resInfo = ParseProtoBufToTable("MailOpRes", msg)
    local l_error = l_resInfo.error
    local l_errorNo = l_error.errorno or ErrorCode.ERR_SUCCESS
    MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_error)

    local l_mailID = tostring(l_resInfo.mail_uid)
    local l_data = GetMail(l_mailID)
    if l_errorNo == ErrorCode.ERR_SUCCESS then

        --删除邮件
        if l_resInfo.op_type == MailOpType.Mail_Del then
            if l_data == nil then
                logWarn("接收到不存在的email操作信息 => id=" .. tostring(l_resInfo.mail_uid))
                return
            end

            for i = 1, #Datas do
                if Datas[i].id == l_mailID then
                    table.remove(Datas, i)
                    EventDispatcher:Dispatch(EventType.Remove, i)
                    return
                end
            end

            --读取邮件
        elseif l_resInfo.op_type == MailOpType.Mail_Read then
            if l_data == nil then
                logWarn("接收到不存在的email操作信息 => id=" .. tostring(l_resInfo.mail_uid))
                return
            end
            l_data.baseInfo.is_read = true
            EventDispatcher:Dispatch(EventType.Reset, l_data)
            --一键删除邮件
        elseif l_resInfo.op_type == MailOpType.Mail_DelAll then
            RequestGetMailList()
        end
    end

    --一键读取所有邮件
    if l_resInfo.op_type == MailOpType.Mail_ReadAll then
        if l_resInfo.read_mail_uids ~= nil then
            for i = 1, #l_resInfo.read_mail_uids do
                local l_mail = GetMail(l_resInfo.read_mail_uids[i].value)
                if l_mail ~= nil then
                    l_mail.baseInfo.is_read = true
                    EventDispatcher:Dispatch(EventType.Reset, l_mail)
                end
            end
        end
    end
end

function GetNumberClamp(st)
    return MGlobalConfig:GetFloat(st)
end

--邮件状态同步
function OnUpdateMailNtf(msg)
    ---@type UpdateMailData
    local l_resInfo = ParseProtoBufToTable("UpdateMailData", msg)
end

function OnActivityMailTipNtf(msg)
    ---@type ActivityMailTipData
    local l_info = ParseProtoBufToTable("ActivityMailTipData", msg)
    if ShowWorldMsg == l_info.is_hint then
        return
    end
    ShowWorldMsg = l_info.is_hint
    EventDispatcher:Dispatch(EventType.WorldMsg, ShowWorldMsg)
end

function ReadWorldMsg()
    if not ShowWorldMsg then
        return
    end
    ShowWorldMsg = false
    EventDispatcher:Dispatch(EventType.WorldMsg, ShowWorldMsg)
end

function OpenEmail()
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isEmailOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Email)
    if not l_isEmailOpen then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.Community, function(ctrl)
        ctrl:SelectOneHandler(UI.HandlerNames.Email)
    end)
end

return ModuleMgr.EmailMgr