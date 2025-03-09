--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildGiftBoxGrantPanel"
require "UI/Template/GuildMemberGiftSendItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_guildMgr = nil
local l_guildData = nil
local l_guildWelfareMgr = nil
local l_allMemberDataList = nil --全数据列表
local l_curMemberDataList = nil  --当前展示的列表内容
local l_joinDayLimit = 5  --发送的最少加入事件
local l_sortType = nil --当前界面需要用到的公会成员排序类型列表
local l_curSortIndex = 0   --当前排序的索引
--next--
--lua fields end

--lua class define
GuildGiftBoxGrantCtrl = class("GuildGiftBoxGrantCtrl", super)
--lua class define end

--lua functions
function GuildGiftBoxGrantCtrl:ctor()

    super.ctor(self, CtrlNames.GuildGiftBoxGrant, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GuildGiftBoxGrantCtrl:Init()

    self.panel = UI.GuildGiftBoxGrantPanel.Bind(self)
    super.Init(self)

    l_curMemberDataList = {}
    l_allMemberDataList = {}
    
    l_guildData = DataMgr:GetData("GuildData")
    l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    l_guildWelfareMgr = MgrMgr:GetMgr("GuildWelfareMgr")
    l_joinDayLimit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("SendBoxTimeLimit").Value)

    --本界面需要用到的公会排序类型设置
    l_sortType = {
        l_guildData.EMemberSortType.Name,
        l_guildData.EMemberSortType.Level,
        l_guildData.EMemberSortType.Job,
        l_guildData.EMemberSortType.Position,
        l_guildData.EMemberSortType.Contribution,
        l_guildData.EMemberSortType.Achievement,
        l_guildData.EMemberSortType.ActivityChat,
        l_guildData.EMemberSortType.ActivityFight,
        l_guildData.EMemberSortType.NormalBox,  --设定Normal的排序必须在最后 前面的Index对应箭头的UI
    }
    l_curSortIndex = #l_sortType   --设定Normal的排序必须在最后

    --按钮点击事件绑定
    self:ButtonClickEventBind()

    --成员列表项的池创建
    self.guildMemberPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildMemberGiftSendItemTemplate,
        TemplatePrefab = self.panel.GuildMemberGiftSendItemPrefab.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })

    --断线重连标志
    self.isReconnect = false

end --func end
--next--
function GuildGiftBoxGrantCtrl:Uninit()

    if l_guildData then
        l_guildData.ReleaseGuildMemberList()
    end

    self.guildMemberPool = nil
    l_curMemberDataList = nil
    l_allMemberDataList = nil

    l_guildWelfareMgr = nil
    l_guildMgr = nil
    l_guildData = nil

    l_sortType = nil 
    l_curSortIndex = 0 

    self.isReconnect = false

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildGiftBoxGrantCtrl:OnActive()

    l_guildData.guildGiftSendMemberIds = {}
    self.grantClicked = false  --发放礼盒防连点
    --请求成员列表
    l_guildMgr.ReqGuildMemberList()
    --请求礼盒信息
    l_guildWelfareMgr.ReqGuildGiftInfo()

end --func end
--next--
function GuildGiftBoxGrantCtrl:OnDeActive()

    l_guildData.guildGiftSendMemberIds = nil

end --func end
--next--
function GuildGiftBoxGrantCtrl:Update()


end --func end

--next--
function GuildGiftBoxGrantCtrl:BindEvents()
    --成员列表数据传回后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_MEMBERLIST_SHOW,function(self)
        --如果是断线重连且之前已经有成员数据则不刷新列表
        if self.isReconnect then
            self.isReconnect = false
            if l_curMemberDataList and #l_curMemberDataList > 0 then
                return
            end
        end 
        --重置选中列表
        l_guildData.guildGiftSendMemberIds = {}
        --刷新成员列表
        self:ShowGuildMemberList()
    end)
    --礼盒信息传回后事件
    self:BindEvent(l_guildWelfareMgr.EventDispatcher,l_guildWelfareMgr.ON_GET_GUILD_GIFT_INFO,function(self)
        self:ShowGuildGiftInfo()
        self.grantClicked = false  
    end)
    --公会重连回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_RECONNECT,function(self)
        --设置重连标志 防止清空已选操作
        self.isReconnect = true
        --请求成员列表
        l_guildMgr.ReqGuildMemberList()
        --请求礼盒信息
        l_guildWelfareMgr.ReqGuildGiftInfo()
    end)
    --公会礼盒发放成功事件
    self:BindEvent(l_guildWelfareMgr.EventDispatcher,l_guildWelfareMgr.ON_GRANT_GIFT_SUCCESSFULLY, function(self)
        --更新列表数据
        for i = 1, #l_curMemberDataList do
            local l_tempData = l_curMemberDataList[i]
            if l_guildData.guildGiftSendMemberIds[l_tempData.baseInfo.roleId] then
                l_tempData.giftIsGet = true
            end
        end
        --重置选中列表
        l_guildData.guildGiftSendMemberIds = {}
        --刷新列表展示
        self.guildMemberPool:RefreshCells()
    end)
    --公会礼盒发放失败事件
    self:BindEvent(l_guildWelfareMgr.EventDispatcher,l_guildWelfareMgr.ON_GRANT_GIFT_FAILED,function(self)
        self.grantClicked = false  
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--展示公会礼盒信息
function GuildGiftBoxGrantCtrl:ShowGuildGiftInfo()
    --库存
    local l_textColor = nil
    if l_guildData.guildGiftInfo.have == l_guildData.guildGiftInfo.max then
        --库存满了
        --self.panel.StockNum.LabColor = Color.New(235/255.0, 76/255.0, 78/255.0)
        self.panel.BtnFull.Btn.interactable = true
        l_textColor = RoColorTag.Red
    else
        --未满
        --self.panel.StockNum.LabColor = Color.New(50/255.0, 50/255.0, 50/255.0)
        self.panel.BtnFull.Btn.interactable = false
        l_textColor = RoColorTag.Blue
    end
    self.panel.StockNum.LabText = Lang("GUILD_GIFT_STOCK", l_textColor,
        l_guildData.guildGiftInfo.have, l_guildData.guildGiftInfo.max)
    --说明的文字内容
    self.panel.ExplainStockText.LabText = Lang("EXPLAIN_GUILD_GIFT_STOCK", l_joinDayLimit)
    local l_getGiftBoxNumThisWeek = l_guildData.guildGiftInfo.guildHunt+l_guildData.guildGiftInfo.guildOrganizeContribution
    --获取
    self.panel.GetNum.LabText = Lang("GUILD_GIFT_GET", RoColorTag.Blue,
            l_getGiftBoxNumThisWeek)
    self.panel.ExplainGetText.LabText = Lang("EXPLAIN_GUILD_GIFT_GET",
        l_getGiftBoxNumThisWeek,
        l_guildData.guildGiftInfo.guildHunt,
        l_guildData.guildGiftInfo.guildOrganizeContribution)
end

--按钮点击事件绑定
function GuildGiftBoxGrantCtrl:ButtonClickEventBind()
    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildGiftBoxGrant)
    end)
    --库存已满提示点击
    self.panel.BtnFull:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_GIFT_STOCK_IS_FULL"))
    end)
    --库存说明按钮点击
    self.panel.BtnStockInfo:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(true)
        self.panel.ExplainBubbleStock:SetActiveEx(true)
    end)
    --获取说明按钮点击
    self.panel.BtnGetInfo:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(true)
        self.panel.ExplainBubbleGet:SetActiveEx(true)
    end)
    --说明界面点击
    self.panel.ExplainPanel:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(false)
        self.panel.ExplainBubbleStock:SetActiveEx(false)
        self.panel.ExplainBubbleGet:SetActiveEx(false)
    end)
    --发放按钮点击
    self.panel.BtnGrant:AddClick(function()
        if not self.grantClicked then
            --判断你是否有选择
            if table.ro_size(l_guildData.guildGiftSendMemberIds) == 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_GUILD_MEMBER_TO_SEND"))
                return
            end
            --请求发放
            l_guildWelfareMgr.ReqGuildGiftGrant()
            self.grantClicked = true
        end
    end)

    --排序按钮
    for i = 1, table.ro_size(l_sortType) - 1 do
        self.panel.BtnLetter[i]:AddClick(function()
            self:SortMemberList(i)
        end)
    end
end

--成员列表展示
--guildDataList 获取的公会数据列表
function GuildGiftBoxGrantCtrl:ShowGuildMemberList(memberDataList)
    --全数据获取
    l_allMemberDataList = l_guildData.guildMemberList
    --重置排序并展示
    self:SortMemberList(#l_sortType)
end

--成员列表排序
function GuildGiftBoxGrantCtrl:SortMemberList(sortTypeIndex)
    --临时数据表申明
    local l_tempList = {}
    --判断是否是已排序类型再次点击 取反序列
    --判断是否是已排序类型再次点击 取反序列
    if sortTypeIndex ~= #l_sortType and sortTypeIndex == l_curSortIndex then
        self:ReverseCurList()
        return
    end
    --初始化所有表头排序标志
    for i = 1, table.ro_size(l_sortType) - 1 do
        self.panel.SortIcon[i].UObj:SetActiveEx(false)
    end
    --数据源获取
    l_tempList = l_guildData.SortMemberList(l_allMemberDataList, l_sortType[sortTypeIndex])
    l_curSortIndex = sortTypeIndex
    l_curMemberDataList = l_tempList

    --展示对应排序标志
    if sortTypeIndex ~= #l_sortType then
        self.panel.SortIcon[l_curSortIndex].UObj:SetActiveEx(true)
        MLuaCommonHelper.SetLocalScaleX(self.panel.SortIcon[l_curSortIndex].UObj, 1)
    end
    --数据展示
    self.guildMemberPool:ShowTemplates({Datas = l_curMemberDataList,
        Method = function(memberItem, clickType, isOn)
            return self:OnClickGuildMemberItem(memberItem, clickType, isOn)
        end})
end

--倒序翻转当前列表
function GuildGiftBoxGrantCtrl:ReverseCurList()
    --获取反序列表
    l_curMemberDataList = l_guildData.ReverseMemberList(l_curMemberDataList)
    --对应排序标志翻转
    local l_scaleX = self.panel.SortIcon[l_curSortIndex].Transform.transform.localScale.x
    MLuaCommonHelper.SetLocalScaleX(self.panel.SortIcon[l_curSortIndex].UObj, l_scaleX * -1)
    --数据展示 并直接返回
    self.guildMemberPool:ShowTemplates({Datas = l_curMemberDataList,
        Method = function(memberItem, clickType, isOn)
            return self:OnClickGuildMemberItem(memberItem, clickType, isOn)
        end})
end

--选中某个成员的点击事件
--clickType  点击的类型 0：查看玩家详细  1：勾选玩家
--isOn  原本的勾选情况
function GuildGiftBoxGrantCtrl:OnClickGuildMemberItem(memberItem, clickType, isOn)

    if clickType == 0 then
        l_guildMgr.ShowMemberDetailInfo(memberItem.data)
    else
        if not self.grantClicked then  --如果请求发送没有消息返回的间隔期间 不可勾选和取消勾选
            local l_operateId = memberItem.data.baseInfo.roleId
            if isOn then
                --取消勾选
                --判断是否已经发放过
                if memberItem.data.giftIsGet then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_GRANT_GIFT_THIS_WEEK"))
                    return true  --保持勾选
                end
                --从选中表中去除
                l_guildData.guildGiftSendMemberIds[l_operateId] = nil
                return false
            else
                --勾选
                --判断加入天数是否满足要求
                local l_curTime = tonumber(tostring(MServerTimeMgr.UtcSeconds))
                local l_joinDays = math.floor((l_curTime - memberItem.data.joinTime) / 86400)
                if l_joinDays < l_joinDayLimit then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_JOIN_DAYS_NOT_ENOUGH", l_joinDayLimit))
                    return false
                end
                --判断数量是否足够
                if table.ro_size(l_guildData.guildGiftSendMemberIds) >= l_guildData.guildGiftInfo.have then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_GIFT_NOT_ENOUGH"))
                    return false
                end
                --加入选中表
                l_guildData.guildGiftSendMemberIds[l_operateId] = true
                return true
            end
        else
            return isOn
        end
    end

end
--lua custom scripts end
return GuildGiftBoxGrantCtrl