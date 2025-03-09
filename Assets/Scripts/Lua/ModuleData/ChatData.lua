--lua model
---@class EChannel
---@field TeamChat
---@field GuildChat
---@field CurSceneChat
---@field WorldChat
---@field SystemChat
---@field ProfessionChat
---@field ChatRoomChat
---@field WatchChat
---@field FriendChat
---@field AllChat

---@class  EChatPrefabType
---@field Self
---@field Other
---@field System
---@field TimeSpace
---@field Hint
---@field Box
---@field Time
---@field RedEnvelopeOther
---@field RedEnvelopeSelf
---@field TaskPhotoOther
---@field TaskPhotoSelf
---@field StickerShareOther
---@field StickerShareSelf
---@field MagicLetterSelf
---@field MagicLetterOther

---@class EChannelSys
---@field System
---@field Private
---@field Help
---@field Hint

---@module ChatData
module("ModuleData.ChatData", package.seeall)
--lua model end
require "UI/Template/ChatHistoryPrefab"
require "UI/Template/ChatHintChatLinePrefab"
require "UI/Template/ChatOtherChatLinePrefab"
require "UI/Template/ChatPlayerChatLinePrefab"
require "UI/Template/ChatSystemChatLinePrefab"
require "UI/Template/ChatLineTimePrefab"
require "UI/Template/ChatLineBoxPrefab"
require "UI/Template/ChatLineRedEnvelopeOther"
require "UI/Template/ChatLineRedEnvelopeSelf"
require "UI/Template/ChatLineTaskPhotoOther"
require "UI/Template/ChatLineTaskPhotoSelf"
require "UI/Template/ChatLineStickerShareOther"
require "UI/Template/ChatLineStickerShareSelf"
require "UI/Template/ChatLineMagicLetterOther"
require "UI/Template/ChatLineMagicLetterSelf"
--region 枚举
EChannel = {
	TeamChat = 2, --队伍
	GuildChat = 3, --工会
	CurSceneChat = 4, --附近
	WorldChat = 5, --世界
	SystemChat = 6, --系统
	ProfessionChat = 7, --职业
	ChatRoomChat = 10, --聊天室
	WatchChat = 11, --观战
	FriendChat = 20, --好友
	AllChat = 100--所有
}

EChatWhoType = {
	ISaid = 1,
	OtherSaid = 2,
	ISaidDefault = 3,
	ServerSaid = 4
}

EChatPrefabType = {
	Self = 1, --自己发的消息
	Other = 2, --别人发的消息
	System = 3, --系统消息
	TimeSpace = 4, --用在公会的历史消息-以上为历史消息
	Hint = 5, --提示
	Box = 6, --用在好友消息的提示
	Time = 7, --用在好友消息的时间间隔
	RedEnvelopeOther = 10, --别人发的红包
	RedEnvelopeSelf = 11, --自己发的红包
	TaskPhotoOther = 12, --别人发的拍照任务
	TaskPhotoSelf = 13, --自己发的拍照任务
    StickerShareOther = 14,   -- 自己的贴纸
    StickerShareSelf = 15,  -- 别人的贴纸
	MagicLetterSelf = 16, --自己的魔法信笺
	MagicLetterOther = 17, --别人的魔法信笺
}
--系统消息子类型
EChannelSys = {
	System = Lang("CHAT_SYSTEM"),
	Private = Lang("CHAT_PRIVATE"),
	Help = Lang("CHAT_HELP"),
	Hint = Lang("CHAT_HINT"),
}
--对话系统设置的某项
ESysSettingSwitch = {
	MainToWorld = 1, --主界面-世界开关
	MainToGuild = 2, --主界面-工会开关
	MainToTeam = 3, --主界面-队伍开关
	MainToCurrent = 4, --主界面-当前开关
	MainToSystem = 5, --主界面-系统开关
}
--超链接类型
ChatHrefType = {
	Prop = 1, --道具链接
	AchievementDetails = 2, --成就详情
	AchievementBadge = 3, --成就勋章
	StoneSculpture = 4, --原石雕刻链接
	PVP = 5, --PVP
	Cooking = 6, --品尝烹饪
	AttributePlan = 7, --6维属性方案
	SkillPlan = 8, --技能方案
	ClothPlan = 9, --衣橱方案
	Watch = 12, -- 观战
	FashionRating = 13, -- 时尚评分
    Title = 14,        --称号分享
    Sticker = 15,       -- 贴纸分享
    ThemeChallengeConfirm = 16,     -- 剧情挑战本战前确认
    GuildNews = 17,	   --公会新闻分享
	FriendMagicLetter = 18,--好友处魔法信笺
	MagicLetter = 19, --魔法信笺
    CapraFAQ = 20,
	TaskPhoto=21,
    TreasureHunterAward = 22,
	ShowServerLevel = 23,  --显示服务器等级
}
declareGlobal("ChatHrefType",ModuleData.ChatData.ChatHrefType)
--特例类型(已废弃，即将删除，TaskPhoto已挪至ChatHrefType)
EException = {
	TaskPhoto = 100,
}
EEventType = {
    ResetMainChat = 1, --？？？
	ClearChat = 2, --任意频道清除某人的聊天内容
	ClearChannelChat = 3, --在某频道清除某人的聊天内容
	Modification = 4, --消息改变
	SystemIndexChange = 5, --聊天系统设置改变
	ChatSettingIndexChange = 6, --聊天设置改变
	MsgRead = 7, --消息已读
	ViewModeChange = 8, --视角模式变化
	UpdateQuickTalk = 9, --更新常用语
	EnterChatPanel = 10, --进入chatpanel聊天模式
	ClearChatPanelSetting = 11,
    ECloseZDNews = 12,--关闭置顶消息
    UpdateForbidPlayerInfo = 13, --更新屏蔽玩家的数据
    GetForbidPlayerInfoList = 14, --获得屏蔽玩家数据
}
--endregion

--region variable
local systemSettingSwichData = {}
local noticeRollingCD
local historySearchAchi = ""  --聊天历史搜索成就
local chatInfoCacheTable = {}
local worldChatCost = 0 --世界聊天元气消耗
local privateChatFilterRoleLevel=0 --私聊消息过滤等级
local chatMaxNum = {}  --聊天输入最大数
local localCacheNum = {} --本地缓存数
local sendChatContentConfigCD = {} --各个频道配置默认cd
local sendChatContentCD={}  --各个频道真实时间
local largeChatCacheQueue=nil --大消息量情况缓存队列
local chatHandleInterval = 150 --聊天消息处理间隔，避免同时处理造成卡顿,单位时间ms
local quickTalkInfos = {}  --常用语信息
local quickTalkSysParam = --常用语参数
{
	maxQuickTalkNum = 12, --最大常用语个数
	maxStarQuickTalkNum = 5, --最大星标常用语个数
	curStarTalkInfoNum = 0, --星标常用语个数
	isInitClientInfos = false,
	hasGetServerInfos = false,
	starInfoDirty = false,
	QUICK_PARAM_SEPARATOR = "=qtis=",
	needRemoveTalkUids = {}
}
local specialShareInfoCache = {
	skillPlanInfos = {},
	attPlanInfos = {},
	clothPlanInfos = {}
}
local forbidPlayerUIDs = {} --屏蔽的玩家的UID列表
local enabledForbidPlayerChannels = nil --开启屏蔽玩家消息的频道
--endregion

--region 生命周期
--初始化
function Init( ... )
	initDataInfo()
	initTableData()
end

--登出重置
function Logout( ... )
	historySearchAchi=""
	forbidPlayerUIDs = {}
	ClearChatCache()
	clearSpecialShareCache()
	HandleQuickTalkInfosOnLogout()
end
--endregion

--region 数据读取
function GetChatHandleInterval()
     return chatHandleInterval
end
--对话系统的某个设置是否激活
function GetNoticeRollingCD()
    return noticeRollingCD
end
function GetSystemSwich(index)
	local l_Index = MPlayerSetting.ChatSystemIndex
	--默认设置
	if l_Index < 0 then
		if index >= ESysSettingSwitch.MainToWorld and index <= ESysSettingSwitch.MainToSystem then
			return getMiniDefSet(index) ~= 0
		end
	end
	local l_curIndex = Common.Bit32.Lshift(1, index)
	local value = Common.Bit32.And(l_Index, l_curIndex)
	return value ~= 0
end
function GetHistorySearchAchievement()
    return historySearchAchi
end
function GetWorldChatCost()
	return worldChatCost
end
--获取本地缓存的对话数
function GetLocalCacheNum(channel)
	return localCacheNum[channel] or 0
end
--获取输入字数上限
function GetChatMaxNum(channel)
	return chatMaxNum[channel] or 0
end
function SetHistorySearchAchievement(value)
	if value==nil then
		value=""
	end
	historySearchAchi=value
end
--获取聊天发送的cd
function GetSendChatContentConfigCD(channel)
	return sendChatContentConfigCD[channel] or 0
end
function GetSendChatContentCD(channel)
	sendChatContentCD = sendChatContentCD or {}
	return sendChatContentCD[channel]
end
function SetSendChatContentCD(channel, cd)
	sendChatContentCD = sendChatContentCD or {}
	if cd == nil or cd <= 0 then
		sendChatContentCD[channel] = nil
	else
		sendChatContentCD[channel] = Time.realtimeSinceStartup + cd
	end
end
function GetPrivateChatFilterLevel()
    return privateChatFilterRoleLevel
end
function GetQuickTalkParamInfo()
    return quickTalkSysParam
end
function GetQuickTalkInfo(needSort)
	if quickTalkInfos == nil then
		quickTalkInfos = {}
		logError("fatal error quickTalkInfos is nil!")
	end
	if not quickTalkSysParam.hasGetServerInfos then
		logWarn("获取常用语信息时扔未收到星标常用语信息！")
	end
	initClientQuickTalkInfos()
	if needSort then
		sortQuickTalkInfos()
	end
	return quickTalkInfos
end
---@param playerUids PBint64[]
function SetForbidPlayerInfos(playerUids)
    forbidPlayerUIDs = {}
    for i = 1, #playerUids do
        table.insert(forbidPlayerUIDs,playerUids[i].value)
    end
    MgrMgr:GetMgr("ChatMgr").EventDispatcher:Dispatch(EEventType.GetForbidPlayerInfoList)
end

function GetForbidPlayerInfos()
	---@type ModuleMgr.OpenSystemMgr
	local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
	--如果聊天屏蔽被禁止了，则返回空的table
	if not l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.ChatForbid) then
		if #forbidPlayerUIDs>0 then
			forbidPlayerUIDs = {}
		end
	end
	return forbidPlayerUIDs
end

function IsForbidPlayer(uid)
	local l_forbidPlayers = GetForbidPlayerInfos()
	return table.ro_contains(l_forbidPlayers,uid)
end

function IsEnableForbidPlayerChatChannel(channel)
	if enabledForbidPlayerChannels==nil then
		local l_fobidChannelList = MGlobalConfig:GetSequenceOrVectorInt("ChatForbidChannels")
		enabledForbidPlayerChannels = Common.Functions.VectorToTable(l_fobidChannelList)
	end
	return table.ro_contains(enabledForbidPlayerChannels,channel)
end

function CanAddForbidPlayer(showTip)
	local l_canForbidPlayerMaxNum = MGlobalConfig:GetInt("ChatForbidLimit")
	if #forbidPlayerUIDs >= l_canForbidPlayerMaxNum then
		if showTip then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Chat_Forbid_Limit"))
		end
		return false
	end
	return true
end

function ChangeForbidPlayerInfo(playerUID,isAdd)
	if isAdd then
		table.insert(forbidPlayerUIDs,playerUID)
	else
		table.ro_removeValue(forbidPlayerUIDs,playerUID)
	end
    MgrMgr:GetMgr("ChatMgr").EventDispatcher:Dispatch(EEventType.UpdateForbidPlayerInfo)
end

---@Description:从收到的聊天消息pb过滤消息
---@param msg ChatMsg
function FilterForbidChatMsg(msg)
	if msg == nil or msg.msg_head == nil then
		return true
	end

	if not IsEnableForbidPlayerChatChannel(msg.msg_head.msg_type) then
		return false
	end

	if IsForbidPlayer(msg.msg_head.sender_uid) then
		return true
	end
	return false
end

---@Description:从已缓存的pack后的聊天数据中过滤数据
---@param msg ChatMsgPack
function FilterForbidChatMsgPack(msg)
	if not IsEnableForbidPlayerChatChannel(msg.channel) then
		return false
	end

	if IsForbidPlayer(msg.uid) then
		return true
	end
	return false
end
--获取频道内的信息缓存
function GetChannelCache(channelType)
	return chatInfoCacheTable[channelType]
end

local l_tempChatMsgQueue=nil
function GetTempChatMsgQueue()
	if l_tempChatMsgQueue == nil then
		l_tempChatMsgQueue = Common.queue.LinkedListQueue.create()
	end
	return l_tempChatMsgQueue
end
function ReplaceOldTempChatMsgQueue(msgQueue)
	l_tempChatMsgQueue = msgQueue
end
function GetFilterChannelCache(channelType)
	local l_channelCache = GetChannelCache(channelType)
	local l_existForbidMsg = false
	if l_channelCache==nil then
		return l_channelCache,l_existForbidMsg
	end
	if not IsEnableForbidPlayerChatChannel(channelType) and channelType~=EChannel.AllChat then
		return l_channelCache,l_existForbidMsg
	end
	local l_tempCacheQueue = GetTempChatMsgQueue()

	for i = 1, l_channelCache:size() do
		---@type ChatMsg 
		local l_chatMsg = l_channelCache:dequeue()
		if FilterForbidChatMsgPack(l_chatMsg) then
			l_existForbidMsg = true
		else
			l_tempCacheQueue:enqueue(l_chatMsg)
		end
	end
	l_channelCache:clear()
	ReplaceOldTempChatMsgQueue(l_channelCache)
	SetChannelCache(channelType,l_tempCacheQueue)
	return l_tempCacheQueue,l_existForbidMsg
end

function SetChannelCache(channelType,value)
	if value==nil then
		value=Common.queue.LinkedListQueue.create()
	end
	chatInfoCacheTable[channelType]=value
end
--返回频道标签代表的颜色
function GetChannelColor(channel)
	if channel == EChannel.WorldChat then
		return Color.New(213 / 255.0, 123 / 255.0, 57 / 255.0)
	elseif channel == EChannel.TeamChat then
		return Color.New(84 / 255.0, 159 / 255.0, 212 / 255.0)
	elseif channel == EChannel.GuildChat then
		return Color.New(111 / 255.0, 199 / 255.0, 169 / 255.0)
	elseif channel == EChannel.ProfessionChat then
		return Color.New(201 / 255.0, 168 / 255.0, 137 / 255.0)
	elseif channel == EChannel.CurSceneChat then
		return Color.New(193 / 255.0, 159 / 255.0, 138 / 255.0)
	elseif channel == EChannel.SystemChat then
		return Color.New(206 / 255.0, 160 / 255.0, 61 / 255.0)
	elseif channel == EChannel.WatchChat then
		return Color.New(239 / 255.0, 237 / 255.0, 40 / 255.0)
	end
end
--返回频道名
function GetChannelName(channel)
	if channel == EChannel.WorldChat then
		return Lang("CHAT_CHANNEL_WORLD")
	elseif channel == EChannel.TeamChat then
		return Lang("CHAT_CHANNEL_TEAM")
	elseif channel == EChannel.GuildChat then
		return Lang("CHAT_CHANNEL_GUILD")
	elseif channel == EChannel.CurSceneChat then
		return Lang("CHAT_CHANNEL_CUR_SCENE")
	elseif channel == EChannel.SystemChat then
		return Lang("CHAT_CHANNEL_SYSTEM")
	elseif channel == EChannel.WatchChat then
		return Lang("WATCHWAR")
	end
end
function GetChannelLineTemInfo(msg)
	if msg.isNpc then
		return
	end
	local l_prefab = nil
	local l_class = nil
	if msg.lineType == EChatPrefabType.Self then
		l_class = UITemplate.ChatPlayerChatLinePrefab
		l_prefab = "UI/Prefabs/ChatLine/ChatLinePlayerPrefab"
	elseif msg.lineType == EChatPrefabType.Other then
		l_class = UITemplate.ChatOtherChatLinePrefab
		l_prefab = "UI/Prefabs/ChatLine/ChatLineOtherPrefab"
	elseif msg.lineType == EChatPrefabType.System then
		l_class = UITemplate.ChatSystemChatLinePrefab
		l_prefab = "UI/Prefabs/ChatLine/ChatLineSystemPrefab"
	elseif msg.lineType == EChatPrefabType.TimeSpace then
		l_class = UITemplate.ChatHistoryPrefab
		l_prefab = "UI/Prefabs/ChatLine/ChatLineHistoryPrefab"
	elseif msg.lineType == EChatPrefabType.Hint then
		l_class = UITemplate.ChatHintChatLinePrefab
		l_prefab = "UI/Prefabs/ChatLine/ChatLineHintPrefab"
	elseif msg.lineType == EChatPrefabType.Time then
		l_class = UITemplate.ChatLineTimePrefab
		l_prefab = "UI/Prefabs/ChatLine/ChatLineTimePrefab"
	elseif msg.lineType == EChatPrefabType.Box then
		l_class = UITemplate.ChatLineBoxPrefab
		l_prefab = "UI/Prefabs/ChatLine/ChatLineBoxPrefab"
	elseif msg.lineType == EChatPrefabType.RedEnvelopeOther then
		l_class = UITemplate.ChatLineRedEnvelopeOther
		l_prefab = "UI/Prefabs/ChatLine/ChatLineRedEnvelopeOther"
	elseif msg.lineType == EChatPrefabType.RedEnvelopeSelf then
		l_class = UITemplate.ChatLineRedEnvelopeSelf
		l_prefab = "UI/Prefabs/ChatLine/ChatLineRedEnvelopeSelf"
	elseif msg.lineType == EChatPrefabType.TaskPhotoOther then
		l_class = UITemplate.ChatLineTaskPhotoOther
		l_prefab = "UI/Prefabs/ChatLine/ChatLineTaskPhotoOther"
	elseif msg.lineType == EChatPrefabType.TaskPhotoSelf then
		l_class = UITemplate.ChatLineTaskPhotoSelf
		l_prefab = "UI/Prefabs/ChatLine/ChatLineTaskPhotoSelf"
    elseif msg.lineType == EChatPrefabType.StickerShareOther then
        l_class = UITemplate.ChatLineStickerShareOther
        l_prefab = "UI/Prefabs/ChatLine/ChatLineStickerShareOther"
    elseif msg.lineType == EChatPrefabType.StickerShareSelf then
        l_class = UITemplate.ChatLineStickerShareSelf
        l_prefab = "UI/Prefabs/ChatLine/ChatLineStickerShareSelf"
	elseif msg.lineType == EChatPrefabType.StickerShareOther then
		l_class = UITemplate.ChatLineStickerShareOther
		l_prefab = "UI/Prefabs/ChatLine/ChatLineStickerShareOther"
	elseif msg.lineType == EChatPrefabType.StickerShareSelf then
		l_class = UITemplate.ChatLineStickerShareSelf
		l_prefab = "UI/Prefabs/ChatLine/ChatLineStickerShareSelf"
	elseif msg.lineType == EChatPrefabType.MagicLetterSelf then
		l_class = UITemplate.ChatLineMagicLetterSelf
		l_prefab = "UI/Prefabs/ChatLine/ChatLineMagicLetterSelf"
	elseif msg.lineType == EChatPrefabType.MagicLetterOther then
		l_class = UITemplate.ChatLineMagicLetterOther
		l_prefab = "UI/Prefabs/ChatLine/ChatLineMagicLetterOther"
	end
	return l_class, l_prefab
end
--获取世界频道发言等级
function GetWorldSendLv()
	local l_St = TableUtil.GetSocialGlobalTable().GetRowByName("ChatWorldLevel").Value
	return tonumber(l_St)
end
function initTableData()
	local l_table = TableUtil.GetSocialGlobalTable()
	--聊天设置默认值
	local l_OrgMiniSt = l_table.GetRowByName("OrgMiniSetting")
	local l_infos = string.ro_split(l_OrgMiniSt.Value, '|')
	systemSettingSwichData[ESysSettingSwitch.MainToWorld] = tonumber(l_infos[1])
	systemSettingSwichData[ESysSettingSwitch.MainToGuild] = tonumber(l_infos[2])
	systemSettingSwichData[ESysSettingSwitch.MainToTeam] = tonumber(l_infos[3])
	systemSettingSwichData[ESysSettingSwitch.MainToCurrent] = tonumber(l_infos[4])
	systemSettingSwichData[ESysSettingSwitch.MainToSystem] = tonumber(l_infos[5])

	noticeRollingCD = MGlobalConfig:GetFloat("NoticeRollingCD")

	--解析获取世界发言消耗
	local l_globalSt = l_table.GetRowByName("ChatWorldConsume")
	if l_globalSt ~= nil then
		local l_sts = string.ro_split(l_globalSt.Value, "=")
		if #l_sts >= 2 then
			worldChatCost = tonumber(l_sts[2])
		end
	else
		logError("[SocialGlobalTable]缺损数据 => ChatWorldConsume")
		worldChatCost = 0
	end

	--解析获取世界发言消耗
	local l_privateChatFilterRoleLevel = l_table.GetRowByName("FilterChatLimitLevel")
	if l_privateChatFilterRoleLevel ~= nil then
		privateChatFilterRoleLevel = tonumber(l_privateChatFilterRoleLevel.Value)
	else
		logError("[SocialGlobalTable]缺损数据 => FilterChatLimitLevel")
		privateChatFilterRoleLevel = 10
	end

	--聊天输入上限
	chatMaxNum = {}
	local l_chatMaxNumSt = l_table.GetRowByName("ChatMaxNum").Value
	local l_infos = string.ro_split(l_chatMaxNumSt, '|')
	chatMaxNum[EChannel.WorldChat] = tonumber(l_infos[1])
	chatMaxNum[EChannel.GuildChat] = tonumber(l_infos[2])
	chatMaxNum[EChannel.TeamChat] = tonumber(l_infos[3])
	chatMaxNum[EChannel.CurSceneChat] = tonumber(l_infos[4])
	local l_roomMaxNum = l_table.GetRowByName("RoomChatMaxNum")
	l_roomMaxNum = l_roomMaxNum and tonumber(l_roomMaxNum.Value) or 0
	chatMaxNum[EChannel.ChatRoomChat] = l_roomMaxNum
	chatMaxNum[EChannel.WatchChat] = tonumber(l_infos[5])

	--本地缓存数
	localCacheNum = {}
	local l_St = l_table.GetRowByName("ChatSaveMaxNum").Value
	local l_infos = string.ro_split(l_St, '|')
	localCacheNum[EChannel.WorldChat] = tonumber(l_infos[1])
	localCacheNum[EChannel.GuildChat] = tonumber(l_infos[2])
	localCacheNum[EChannel.TeamChat] = tonumber(l_infos[3])
	localCacheNum[EChannel.CurSceneChat] = tonumber(l_infos[4])
	localCacheNum[EChannel.SystemChat] = tonumber(l_infos[5])
	localCacheNum[EChannel.AllChat] = tonumber(l_table.GetRowByName("ChatSaveMaxMini").Value)
	localCacheNum[EChannel.WatchChat] = tonumber(l_infos[6])

	local l_roomMaxNum = l_table.GetRowByName("RoomChatSaveMaxNum")
	l_roomMaxNum = l_roomMaxNum and tonumber(l_roomMaxNum.Value) or 20
	localCacheNum[EChannel.ChatRoomChat] = l_roomMaxNum

	sendChatContentConfigCD = {}
	local l_St = TableUtil.GetSocialGlobalTable().GetRowByName("ChatTimeLimit").Value
	if l_St then
		local l_infos = string.ro_split(l_St, '|')
		sendChatContentConfigCD[EChannel.WorldChat] = tonumber(l_infos[1])
		sendChatContentConfigCD[EChannel.GuildChat] = tonumber(l_infos[2])
		sendChatContentConfigCD[EChannel.TeamChat] = tonumber(l_infos[3])
		sendChatContentConfigCD[EChannel.CurSceneChat] = tonumber(l_infos[4])
		sendChatContentConfigCD[EChannel.WatchChat] = tonumber(l_infos[5])
	end

	local l_fwNum = TableUtil.GetSocialGlobalTable().GetRowByName("FrequentWordsNum").Value
	if l_fwNum then
		quickTalkSysParam.maxQuickTalkNum = tonumber(l_fwNum)
	end
	local l_starFwNum = TableUtil.GetSocialGlobalTable().GetRowByName("CollectFrequentWordsNum").Value
	if l_starFwNum then
		quickTalkSysParam.maxStarQuickTalkNum = tonumber(l_starFwNum)
	end
end
function initDataInfo()
	largeChatCacheQueue = Common.queue.LinkedListQueue.create()
	for k, v in pairs(EChannel) do
		chatInfoCacheTable[v] = Common.queue.LinkedListQueue.create()
	end
end
function getMiniDefSet(index)
	return systemSettingSwichData[index] or 0
end

--endregion

--region 聊天信息缓存
--获得大消息量缓存队列已缓存的聊天消息数量
function GetLargeChatCacheQueueSize()
	if largeChatCacheQueue==nil then
		return 0
	end
	return largeChatCacheQueue:size()
end
function EnqueueLargeChatCacheQueue(chatMsg)
	if largeChatCacheQueue==nil then
		return
	end
	return largeChatCacheQueue:enqueue(chatMsg)
end
function DequeueLargeChatCacheQueue()
	if largeChatCacheQueue==nil then
		return
	end
	return largeChatCacheQueue:dequeue()
end
--清除某一个聊天频道的聊天缓存
function ClearChatInfoCacheByChannel(channelEnum)
	if channelEnum then
		if chatInfoCacheTable[channelEnum]:size() > 0 then
			chatInfoCacheTable[channelEnum]:clear()
		end
	end
end
function ClearChatCache()
	if largeChatCacheQueue~=nil then
		largeChatCacheQueue:clear()
	end
	for k, v in pairs(EChannel) do
		local l_cacheQueueInfo=chatInfoCacheTable[v]
		if l_cacheQueueInfo~=nil then
			ClearChatInfoCacheByChannel(v)
		else
			SetChannelCache(v,nil)
		end
	end
end
--修改聊天内容
function ModificationChat(condition)
	for channel, cacheTable in pairs(chatInfoCacheTable) do
		if channel ~= EChannel.AllChat then
			cacheTable = cacheTable:enumerate()
			for _, msg in pairs(cacheTable) do
				local l_change, l_continue = condition(msg)
				if l_change then
					MgrMgr:GetMgr("ChatMgr").EventDispatcher:Dispatch(EEventType.Modification, msg)
					if not l_continue then
						return
					end
				end
			end
		end
	end
end
--endregion

--region QuickTalk处理
function SaveServerQuickTalkInfos()
	MgrMgr:GetMgr("ChatMgr").SendFrequensWordMsg()
end
function UpdateQuickTalkInfo(chatMsg, param)
	if isRepeatTalkInfo(chatMsg, param) then
		sortQuickTalkInfos()
		return
	end
	local l_quickChatInfosNum = #quickTalkInfos
	--全星标无法添加新常用语
	if l_quickChatInfosNum >= quickTalkSysParam.maxQuickTalkNum and quickTalkSysParam.curStarTalkInfoNum >= quickTalkSysParam.maxQuickTalkNum then
		return
	end
	local l_newTalkInfo = createTalkInfo(false, MLuaClientHelper.GetNowTicks(), chatMsg, param, false)

	table.insert(quickTalkInfos, l_newTalkInfo)
	sortQuickTalkInfos()

	if l_quickChatInfosNum >= quickTalkSysParam.maxQuickTalkNum then
		local l_talkInfo = quickTalkInfos[quickTalkSysParam.maxQuickTalkNum + 1]
		if l_talkInfo.uid ~= "0" then
			--移除消息如果之前为星标语，加入移除列表
			table.insert(quickTalkSysParam.needRemoveTalkUids, l_talkInfo.uid)
		end
		table.remove(quickTalkInfos, quickTalkSysParam.maxQuickTalkNum + 1)
	end

	MgrMgr:GetMgr("ChatMgr").EventDispatcher:Dispatch(EEventType.UpdateQuickTalk)
end
function ChangeQuickTalkInfoStarState(data)
	if data == nil then
		return false
	end
	if data.isStar then
		data.isStar = false
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CANCEL_STAR_TALK"))
		data.lastUseTime = MLuaClientHelper.GetNowTicks()
		quickTalkSysParam.curStarTalkInfoNum = quickTalkSysParam.curStarTalkInfoNum - 1
		quickTalkSysParam.starInfoDirty = true
		return true
	end

	if quickTalkSysParam.curStarTalkInfoNum >= quickTalkSysParam.maxStarQuickTalkNum then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STAR_TALK_OVERFLOW"))
		return false
	end
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ADD_STAR_TALK"))
	data.isStar = true
	quickTalkSysParam.starInfoDirty = true
	data.lastUseTime = MLuaClientHelper.GetNowTicks()
	quickTalkSysParam.curStarTalkInfoNum = quickTalkSysParam.curStarTalkInfoNum + 1
	return true
end
function UpdateServerQuickTalkInfos(fwResData)
	if fwResData == nil then
		return
	end
	for i = 1, #fwResData.freq_words do
		local l_fwWord = fwResData.freq_words[i]
		if l_fwWord.frequent_words_op == 3 then
			--查询返回数据
			local l_param = transformExtraParam(l_fwWord.extra_param)
			quickTalkSysParam.curStarTalkInfoNum = quickTalkSysParam.curStarTalkInfoNum + 1
			local l_talkInfo = createTalkInfo(true, MLuaClientHelper.GetNowTicks(), l_fwWord.words, l_param)
			l_talkInfo.uid = l_fwWord.uid
			table.insert(quickTalkInfos, l_talkInfo)
		elseif l_fwWord.frequent_words_op == 1 then
			--新增返回数据
			updateSingleServerTalkInfo(l_fwWord)
		end
	end
	quickTalkSysParam.hasGetServerInfos = true
	initClientQuickTalkInfos()
end
function HandleQuickTalkInfosOnLogout()
	saveClientQuickTalkInfos()
	quickTalkInfos = {}
	quickTalkSysParam.isInitClientInfos = false
	quickTalkSysParam.hasGetServerInfos = false
	quickTalkSysParam.curStarTalkInfoNum = 0
	quickTalkSysParam.needRemoveTalkUids = {}
end
function saveClientQuickTalkInfos()
	MPlayerSetting:DeleteQuickTalkInfos()
	local l_clientQTInfoNums = 0
	for i = 1, #quickTalkInfos do
		local l_talkInfo = quickTalkInfos[i]
		if not l_talkInfo.isStar then
			l_clientQTInfoNums = l_clientQTInfoNums + 1
			MPlayerSetting:StoreQuickTalkInfos(l_clientQTInfoNums, quickTalkInfoToString(l_talkInfo))
		end
	end
	MPlayerSetting.QuickInfoNum = l_clientQTInfoNums
end
function updateSingleServerTalkInfo(fwResData)
	if fwResData == nil then
		return
	end
	local quickTalkInfos = GetQuickTalkInfo()
	for i = 1, #quickTalkInfos do
		local l_talkInfo = quickTalkInfos[i]
		if l_talkInfo.tempId == fwResData.client_id then
			l_talkInfo.uid = fwResData.uid
			l_talkInfo.tempId = 0
		end
	end
end
function transformExtraParam(param)
	if param == nil then
		return
	end
	local l_paramNum = #param
	if l_paramNum < 1 then
		return
	end
	local l_params = {}
	for i = 1, l_paramNum do
		local l_data = param[i]
		local l_param = {}
		l_param.type = l_data.type
		if l_data.param32 ~= nil then
			l_param.param32 = {}
			for i = 1, #l_data.param32 do
				table.insert(l_param.param32, l_data.param32[i])
			end
		end
		if l_data.param64 ~= nil then
			l_param.param64 = {}
			for i = 1, #l_data.param64 do
				table.insert(l_param.param64, l_data.param64[i])
			end
		end
		if l_data.name ~= nil then
			l_param.name = {}
			for i = 1, #l_data.name do
				table.insert(l_param.name, l_data.name[i])
			end
		end
		table.insert(l_params, l_param)
	end
	return l_params
end
function initClientQuickTalkInfos()
	if quickTalkSysParam.isInitClientInfos then
		return
	end
	local l_curQuickTalkInfoNum = MPlayerSetting.QuickInfoNum
	local l_nowTime=MLuaClientHelper.GetNowTicks()
	for i = 1, l_curQuickTalkInfoNum do
		local l_quickTalkStr = MPlayerSetting:GetQuickTalkInfos(i)
		local l_talkInfo = parseQuickTalkInfo(l_quickTalkStr, l_nowTime-i)
		if l_talkInfo ~= nil then
			table.insert(quickTalkInfos, l_talkInfo)
		end
	end
	quickTalkSysParam.isInitClientInfos = true
end
function parseHrefInfo(talkInfo)
	if talkInfo == nil or talkInfo.param == nil then
		return
	end
	local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
	talkInfo.hrefStr, talkInfo.inputStr = l_linkInputMgr.PackToTag(talkInfo.content, talkInfo.param, false, true)
	if talkInfo.hrefStr ~= nil and talkInfo.inputStr ~= nil then
		talkInfo.hasHref = true
	end
end
function parseQuickTalkInfo(infoStr, lastTime)
	if infoStr == nil then
		return
	end
	local l_splitStr = MCommonFunctions.StringSplit(infoStr, quickTalkSysParam.QUICK_PARAM_SEPARATOR)
	if l_splitStr == nil then
		return
	end
	local l_splitLen = l_splitStr.Length
	if l_splitLen < 1 then
		return
	end
	local l_newTalkInfo = createTalkInfo(false, lastTime, l_splitStr[0], nil, false)
	if l_splitLen < 2 then
		return l_newTalkInfo
	end
	local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
	l_newTalkInfo.param = l_linkInputMgr.StringToPack(l_splitStr[1])
	parseHrefInfo(l_newTalkInfo)
	return l_newTalkInfo
end
function quickTalkInfoToString(talkInfo)
	if talkInfo == nil then
		return ""
	end
	local l_quickInfoStr = talkInfo.content
	if talkInfo.param == nil then
		return l_quickInfoStr
	end
	local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
	l_quickInfoStr = l_quickInfoStr .. quickTalkSysParam.QUICK_PARAM_SEPARATOR .. l_linkInputMgr.PackToString(talkInfo.param)
	return l_quickInfoStr
end
function createTalkInfo(isStar, lastUseTime, content, param)
	local l_newTalkInfo = {
		isStar = isStar,
		lastUseTime = lastUseTime,
		content = content,
		param = param,
		hasHref = false,
		uid = "0",
		dirty = false,
		tempId = 0,
	}
	parseHrefInfo(l_newTalkInfo)
	return l_newTalkInfo
end
function sortQuickTalkInfos()
	if quickTalkInfos == nil or #quickTalkInfos < 2 then
		return
	end
	table.sort(quickTalkInfos, function(a, b)
		if a.isStar ~= b.isStar then
			if a.isStar then
				return true
			end
			return false
		else
			if a.lastUseTime > b.lastUseTime then
				return true
			end
		end
		return false
	end)
end
function isRepeatTalkInfo(newMsg, newParam)
	local l_quickChatInfosNum = #quickTalkInfos
	if l_quickChatInfosNum < 1 then
		return false
	end

	for i = 1, l_quickChatInfosNum do
		local l_talkInfo = quickTalkInfos[i]
		if isSameTalkInfo(l_talkInfo, newMsg, newParam) then
			l_talkInfo.lastUseTime = MLuaClientHelper.GetNowTicks()
			return true
		end
	end
	return false
end
function isSameTalkInfo(oldTalkInfo, newMsg, newParam)
	if oldTalkInfo == nil or newMsg == nil then
		logError("isSameTalkInfo oldTalkInfo==nil or newMsg==nil!")
		return false
	end
	if oldTalkInfo.content == newMsg and isSameTalkInfoParam(oldTalkInfo.param, newParam) then
		return true
	end
	return false
end
function isSameTalkInfoParam(oldParam, newParam)
	if oldParam == nil and newParam == nil then
		return true
	end
	if oldParam ~= nil and newParam ~= nil then
		local l_oldParamNum = #oldParam
		local l_newParamNum = #newParam

		if l_oldParamNum ~= l_newParamNum then
			return false
		end
		for i = 1, l_oldParamNum do
			local l_oldParam = oldParam[i]
			local l_newParam = newParam[i]

			if l_oldParam.type ~= l_newParam.type then
				return false
			end
			--比较32位参数
			if not isSameParamList(l_oldParam.param32, l_newParam.param32, true) then
				return false
			end
			--比较64位参数
			if not isSameParamList(l_oldParam.param64, l_newParam.param64, true) then
				return false
			end
			--比较name参数
			if not isSameParamList(l_oldParam.name, l_newParam.name, false) then
				return false
			end
		end
		return true
	end
	return false
end
function isSameParamList(sourceList, targetList, isCompareParam)
	if sourceList == nil and targetList == nil then
		return true
	end
	local l_isSame = false
	if sourceList ~= nil and targetList ~= nil then
		local l_sourceLen = #sourceList
		local l_targetLen = #targetList
		if l_sourceLen == l_targetLen then
			l_isSame = true
			for i = 1, l_sourceLen do
				if isCompareParam then
					if sourceList[i].value ~= targetList[i].value then
						l_isSame = false
						break ;
					end
				else
					if sourceList[i] ~= targetList[i] then
						l_isSame = false
						break ;
					end
				end
			end
		end
	end
	return l_isSame
end
--endregion

--region 特殊分享内容
function GetShareSkillPlanInfo(uid)
	return specialShareInfoCache.skillPlanInfos[uid]
end
function GetShareClothPlanInfo(uid)
	return specialShareInfoCache.clothPlanInfos[uid]
end
function GetShareAttributePlanInfo(uid)
	return specialShareInfoCache.attPlanInfos[uid]
end
function SetShareSkillPlanInfo(uid,data)
	if data==nil then
		return
	end
	specialShareInfoCache.skillPlanInfos[uid]=data
end
function SetShareClothPlanInfo(uid,data)
	if data==nil then
		return
	end
	specialShareInfoCache.clothPlanInfos[uid]=data
end
function SetShareAttributePlanInfo(uid,data)
	if data==nil then
		return
	end
	specialShareInfoCache.attPlanInfos[uid]=data
end
function clearSpecialShareCache()
	specialShareInfoCache.skillPlanInfos = {}
	specialShareInfoCache.attPlanInfos = {}
	specialShareInfoCache.clothPlanInfos = {}
end
--endregion

return ModuleData.ChatData