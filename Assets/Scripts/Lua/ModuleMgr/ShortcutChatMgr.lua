module("ModuleMgr.ShortcutChatMgr", package.seeall)

-----------------------------------数据
FriendLis = nil --标记为快捷聊天的好友列表
StaticFriendData = {}
DataLis = {} --所有快捷聊天的数据
EventDispatcher = EventDispatcher.new()
Event = {
    AddData = "AddData", --添加一个小窗口数据
    RemoveData = "RemoveData", --移除一个小窗口数据
}
FriendIntimacyDegree = 5    --好友请密度超过该值则可设置快捷聊天
FriendTagMax = 3            --快捷聊天最大数量
LongClickTime = 0.5           --长按的时长：录音\拖动位移
MiniNameLenght = 10         --快捷聊天小框的名字显示长度

QUICK_CHAT_BIT = {
    TEAM = 1,
    GUILD = 2,
    WATCH = 3,
}

---@return ShortCutChatData
function CreatData(data)
    if nil == data then
        logError("[ShortcutChatMgr] data got nil")
        return nil
    end

    -- 这边是一个缓存机制，不重复创建数据
    local l_data = GetData(data.uid, data.channel)
    if nil ~= l_data then
        return l_data
    end

    ---@class ShortCutChatData
    l_data = data
    l_data.uid = l_data.uid or nil
    l_data.channel = l_data.channel or nil
    l_data.friendInfo = l_data.friendInfo or nil
    l_data.mini = (l_data.mini == nil) or true
    l_data.SetMini = function(self, b)
        if self.mini == b then
            return false
        end
        self.mini = b
        return true
    end

    --位置
    l_data.originalPos = l_data.originalPos or Vector2.zero --原始位置
    l_data.pos = nil                    --当前位置
    l_data.moved = nil                  --是否移动过
    l_data.SetPos = function(self, pos)
        --设置位置入口
        if self.pos == pos then
            return false
        end
        l_data.pos = pos
        l_data.moved = true
        RemoveStaticFriendData(self)
        return true
    end
    l_data.ResetPos = function(self)
        --重新获取--归位
        local l_downPos = MUIManager.UIRoot.transform.sizeDelta.y / 2.0
        if self.uid then
            RemoveStaticFriendData(self)
            local l_fixPos = { x = -155.2719, y = 144.4 - l_downPos }
            local l_fixInterval = 30
            local l_set = false
            local l_getStaticPosX = function(index)
                return l_fixPos.x + (index - 1) * l_fixInterval
            end
            for i = 1, #StaticFriendData do
                local l_sData = StaticFriendData[i]
                if l_sData.pos.x ~= l_getStaticPosX(i) then
                    table.insert(StaticFriendData, i, self)
                    l_data.originalPos = { x = l_getStaticPosX(i), y = l_fixPos.y }
                    l_set = true
                end
            end
            if not l_set then
                StaticFriendData[#StaticFriendData + 1] = self
                l_data.originalPos = { x = l_getStaticPosX(#StaticFriendData), y = l_fixPos.y }
            end
        elseif self.channel then
            local l_hasTeam = TeamData.myTeamInfo.isInTeam
            local l_hasGuild = GuildMgr.IsSelfHasGuild()
            local l_pos = {
                { x = -155.2719, y = 94.3 - l_downPos },
                { x = -108.2719, y = 94.3 - l_downPos },
                { x = 112, y = 94.3 - l_downPos }
            }
            if self.channel == chatDataMgr.EChannel.TeamChat then
                l_data.originalPos = l_hasGuild and l_pos[2] or l_pos[1]
            elseif self.channel == chatDataMgr.EChannel.GuildChat then
                l_data.originalPos = l_pos[1]
            elseif self.channel == chatDataMgr.EChannel.WatchChat then
                l_data.originalPos = l_pos[3]
            end
        end

        l_data.pos = l_data.originalPos
        l_data.moved = false
        return true
    end

    l_data:ResetPos()
    table.insert(DataLis, l_data)
    EventDispatcher:Dispatch(Event.AddData, l_data)
    return l_data
    --logError("添加数据：uid=%s, channel=%s",tostring(l_data.uid),tostring(l_data.channel))
end

function RemoveData(uid, channel)
    for i = 1, #DataLis do
        local l_data = DataLis[i]
        if (uid and l_data.uid == uid)
                or (channel and l_data.channel == channel) then
            table.remove(DataLis, i)
            RemoveStaticFriendData(l_data)
            EventDispatcher:Dispatch(Event.RemoveData, l_data)
            --logError("删除数据 id=%s; channel=%s",tostring(l_data.uid),tostring(l_data.channel))
            return true
        end
    end
end

function GetData(uid, channel)
    if nil == uid or nil == channel then
        return nil
    end

    for i = 1, #DataLis do
        ---@type ShortCutChatData
        local l_data = DataLis[i]
        if l_data.uid == uid and l_data.channel == channel then
            return l_data
        end
    end
    return nil
end

function HasData(uid, channel)
    return DataLis and GetData(uid, channel)
end

function ExistChannelData(channel)
    if DataLis==nil then return false end
    for i = 1, #DataLis do
        local l_data = DataLis[i]
        if l_data.channel == channel then
            return true
        end
    end
    return false
end

function GetStaticFriendDataIndex(data)
    for i = 1, #StaticFriendData do
        if StaticFriendData[i] == data then
            return i
        end
    end
end

function RemoveStaticFriendData(data)
    local l_index = GetStaticFriendDataIndex(data)
    if l_index then
        table.remove(StaticFriendData, l_index)
    end
end

-----------------------------------生命周期
function OnInit()
    GuildMgr = MgrMgr:GetMgr("GuildMgr")
    TeamMgr = MgrMgr:GetMgr("TeamMgr")
    TeamData = DataMgr:GetData("TeamData")
    FriendMgr = MgrMgr:GetMgr("FriendMgr")
    ChatMgr = MgrMgr:GetMgr("ChatMgr")
    chatDataMgr= DataMgr:GetData("ChatData")
    GuildMgr.EventDispatcher:Add(GuildMgr.ON_GET_GUILD_INFO_CHANGE, ResetChannel)
    TeamMgr.EventDispatcher:Add(TeamData.ON_TEAM_INFO_UPDATE, ResetChannel)
    FriendMgr.EventDispatcher:Add(FriendMgr.ChangeFriendDataEvent, ResetFriend)
    ChatMgr.EventDispatcher:Add(chatDataMgr.EEventType.ChatSettingIndexChange, ResetChannel)
    FriendMgr.EventDispatcher:Add(FriendMgr.ResetFriendInfoEvent, ResetFriend)
    MgrMgr:GetMgr("WatchWarMgr").EventDispatcher:Add(MgrMgr:GetMgr("WatchWarMgr").ON_STAGE_CHANGED, ResetWatchChannel)

    local l_row = TableUtil.GetSocialGlobalTable().GetRowByName("ShortcutChatFriendsRelation")
    FriendIntimacyDegree = l_row and tonumber(l_row.Value) or FriendIntimacyDegree

    local l_chatRow = TableUtil.GetSocialGlobalTable().GetRowByName("ShortcutChatMaxNum")
    FriendTagMax = l_chatRow and tonumber(l_chatRow.Value) or FriendTagMax
end

function OnLogout()
    while #DataLis > 0 do
        local l_data = DataLis[1]
        RemoveData(l_data.uid, l_data.channel)
    end
    FriendLis = nil
    StaticFriendData = {}
end

function OnReconnected(reconnectData)

end

function OnSelectRoleNtf(roleInfo)
    --角色登陆成功
    FriendLis = MPlayerSetting.ChatQuickLis

    --同步组队频道、公会频道
    ResetChannel()
    --ResetFriend() --等待好友数据的消息

end

-----------------------------------
--添加好友为快捷聊天
function AddFriendTag(uid)
    if not FriendLis or FriendLis:Contains(uid) then
        return false
    end
    if FriendLis.Count >= FriendTagMax then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ShortcutChat_MaxCount")) --快捷聊天数量已到达上限
        return false
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ShortcutChat_Open"))--已开启快捷聊天

    FriendLis:Add(uid)
    MPlayerSetting.ChatQuickLis = FriendLis
    CreatData({
        uid = uid,
        channel = chatDataMgr.EChannel.FriendChat,
        friendInfo = FriendMgr.GetContactsDatas(uid)
    })
    return true
end
function RemoveFriendTag(uid)
    if not FriendLis or not FriendLis:Contains(uid) then
        return false
    end

    FriendLis:Remove(uid)

    MPlayerSetting.ChatQuickLis = FriendLis
    RemoveData(uid)
    return true
end
function ContainsFriend(uid)
    return FriendLis and FriendLis:Contains(uid)
end

--同步频道数据
function ResetChannel()

    local l_showTeam = Common.Bit32.And(MPlayerSetting.ChatQuickIndex, Common.Bit32.Lshift(1, QUICK_CHAT_BIT.TEAM)) ~= 0
            and TeamData.myTeamInfo.isInTeam
    local l_showGuild = Common.Bit32.And(MPlayerSetting.ChatQuickIndex, Common.Bit32.Lshift(1, QUICK_CHAT_BIT.GUILD)) ~= 0
            and GuildMgr.IsSelfHasGuild()

    if l_showTeam then
        if not ExistChannelData(chatDataMgr.EChannel.TeamChat) then
            CreatData({
                channel = chatDataMgr.EChannel.TeamChat,
            })
        end
    else
        RemoveData(nil, chatDataMgr.EChannel.TeamChat)
    end
    if l_showGuild then
        if not ExistChannelData(chatDataMgr.EChannel.GuildChat) then
            CreatData({
                channel = chatDataMgr.EChannel.GuildChat
            })
        end
    else
        RemoveData(nil, chatDataMgr.EChannel.GuildChat)
    end
    ResetWatchChannel()
end

--同步好友列表里所有有标记的数据
function ResetFriend()

    if FriendMgr.ContactsDatas and FriendLis then
        --删除已经被删除好友的标记
        for i = FriendLis.Count - 1, 0, -1 do
            local l_uid = FriendLis[i]
            local l_has = false
            for j = 1, #FriendMgr.ContactsDatas do
                local l_friendInfo = FriendMgr.ContactsDatas[j]
                if l_friendInfo.uid == l_uid and l_friendInfo.intimacy_degree >= FriendIntimacyDegree then
                    l_has = true
                    break
                end
            end
            if not l_has then
                RemoveFriendTag(l_uid)
            end
        end

        for i = 1, #FriendMgr.ContactsDatas do
            local l_info = FriendMgr.ContactsDatas[i]
            if l_info.uid then
                if ContainsFriend(l_info.uid) and not HasData(l_info.uid) then
                    CreatData({
                        uid = l_info.uid,
                        channel = chatDataMgr.EChannel.FriendChat,
                        friendInfo = l_info,
                    })
                end
            end
        end
    end
end

function ReGetOriginalPos(self)
    --重新获取

end

function ResetWatchChannel()

    local l_showWatch = Common.Bit32.And(MPlayerSetting.ChatQuickIndex, Common.Bit32.Lshift(1, QUICK_CHAT_BIT.WATCH)) ~= 0
            and MgrMgr:GetMgr("WatchWarMgr").IsInSpectator()
    if l_showWatch then
        if not ExistChannelData(chatDataMgr.EChannel.WatchChat) then
            CreatData({
                channel = chatDataMgr.EChannel.WatchChat
            })
        end
    else
        RemoveData(nil, chatDataMgr.EChannel.WatchChat)
    end
end

return ModuleMgr.ShortcutChatMgr
