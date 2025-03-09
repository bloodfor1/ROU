-- 事件机制
---@module ModuleMgr.GameEventMgr
module("ModuleMgr.GameEventMgr", package.seeall)

l_eventDispatcher = EventDispatcher.new()

function RaiseEvent(event, param)
    l_eventDispatcher:Dispatch(event, param)
end

function Register(event, callBack, callBackSelf)
    l_eventDispatcher:Add(event, callBack, callBackSelf)
end

function UnRegister(event, eventSelf)
    l_eventDispatcher:RemoveObjectAllFunc(event, eventSelf)
end

-- 玩家数据完成同步
OnPlayerDataSync = "OnPlayerDataSync"
-- 背包数据同步结束
OnBagSync = "OnBagSync"
-- 背包数据第一次更新
OnBagEarlyUpdate = "OnBagEarlyUpdate"
-- 背包数据更新
OnBagUpdate = "OnBagUpdate"
-- 快速使用同步结束了
OnShortCutItemSync = "OnShortCutItemSync"
-- 快速使用更新结束了
OnShortCutItemUpdate = "OnShortCutItemUpdate"
-- 服务器确认继承操作成功
OnEnchantInheritConfirmed = "OnEnchantInheritConfirmed"
-- 因为现在UI模板不支持传self进去，所以想要层层回调传进去会出错；这里就用了消息机制来解决这个问题
OnEnchantInheritStoneSelected = "OnEnchantInheritStoneSelected"
-- 附魔继承当中选择了武器
OnEnchantInheritEquipItemSelected = "OnEnchantInheritEquipItemSelected"
-- 确认精炼转移
OnRefineTransferConfirm = "OnRefineTransferConfirm"
-- 准备上行换装备消息
OnChangeEquipRequest = "OnChangeEquipRequest"
-- 收到了服务器的回包，表示已经确定更新了
OnChangeEquipConfirm = "OnChangeEquipConfirm"
-- 助手模块用的，确认完成了完美提炼之后进行下一步
OnRecvPerfectExtract = "OnRecvPerfectExtract"
-- 选择装备的地方选择了装备
OnEquipCellSelected = "OnEquipCellSelected"
-- 收到了服务器的回包
OnPerfectExtractDone = "OnPerfectExtractDone"
-- 当点击了特效提示的确认之后
OnClosePerfectExtractTip = "OnClosePerfectExtractTip"
-- 自动战斗设置保存
OnAutoBattleSettingsConfirmed = "OnAutoBattleSettingsConfirmed"
--通用协议数据同步
OnCommonBroadcast = "OnCommonBroadcast"
-- 工会排行榜数据更新结束
OnRefreshGuildRank = "OnRefreshGuildRank"
-- 强制刷新工会排名体系相关数据
ForceRefreshGuildRank = "ForceRefreshGuildRank"
-- 开启了锻造过滤
ForgeFiltrateSet = "ForgeFiltrateSet"
-- 确认完成了装备改造
OnEquipReformComplete = "OnEquipReformComplete"
-- 同名继承成功了
EquipAttrSwapConfirm = "EquipAttrSwapConfirm"
-- 一次记录系统完成了同步或者更新
OnOnceDataUpdate = "OnOnceDataUpdate"
-- 当背包或者小推车负重发生了变化
OnW8ChangeConfirm = "OnW8ChangeConfirm"
-- 合成界面产生了切页操作
OnCompoundHandlerSwitch = "OnCompoundHandlerSwitch"
-- 背包页开启的情况下开仓库页
OnOpenWareHousePage = "OnOpenWareHousePage"
-- 贝鲁兹外显特效变化
OnBeiluzEffectChange = "OnBeiluzEffectChange"
-- 祈福经验变化
OnBlessExpChanged = "OnBlessExpChanged"
-- OnItemUpdate次级消息，需要只监听单个道具数量的时候监听这个消息
OnItemCountUpdate = "OnItemCountUpdate"
-- 战斗时间变化
OnExtraFightTimeChanged = "OnExtraFightTimeChanged"
-- 头像框数据发生了变化
OnIconFrameUpdate = "OnIconFrameUpdate"
-- 聊天气泡背景发生变化
OnDialogBgUpdate = "OnDialogBgUpdate"
-- 聊天标签发生了变化
OnChatLabelUpdate = "OnChatLabelUpdate"
-- 装备碎片材料发生变化
OnShardMatCountUpdate = "OnShardMatCountUpdate"
-- 单个道具CD结束
OnItemCdOver = "OnItemCdOver"
-- 道具组CD结束
OnItemGroupCdOver = "OnItemGroupCdOver"
-- 精炼触发断线重连
OnRefineReconnected = "OnRefineReconnected"
-- 角色数据同步更新
OnPlayerAttrUpdate = "OnPlayerAttrUpdate"
-- 日常任务界面关闭
OnDailyTaskClose = "OnDailyTaskClose"
-- 提示系统角色登出通知
TipsOnSysLogout = "TipsOnSysLogout"
-- 礼包和充值相关，用来刷新小红点的消息
ItemPurchaseInfoUpdated = "ItemPurchaseInfoUpdated"
-- 活动数据更新
FestivalDataUpdate = "FestivalDataUpdate"
-- 当战场击杀数发生了变化
OnBattleFieldKDAUpdated = "OnBattleFieldKDAUpdated"