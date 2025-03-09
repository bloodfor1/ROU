--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildListPanel"
require "UI/Template/GuildItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildListCtrl = class("GuildListCtrl", super)
--lua class define end

local l_guildMgr = nil
local l_guildData = nil
local l_selectedGuildId = 0  --当前选中的公会编号
local l_listType = 0 --当前展示的列表类型  0:列表展示(可下拉请求新页) 1:搜索结果不可下拉  默认为0
local l_curDataList = {}  --当前展示的列表内容
local l_lastGuildId = 0 -- 当前列表最后一个公会的编号(搜索结果不放入)
local l_isNoGuild = false  --是否是没有任何公会
local l_guildNameLengthMaxLimit = 7  --公会名长度最长限制  中文长度算1

--lua functions
function GuildListCtrl:ctor()

    super.ctor(self, CtrlNames.GuildList, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function GuildListCtrl:Init()

    self.panel = UI.GuildListPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildMgr = MgrMgr:GetMgr("GuildMgr")

    self:InitSelectedState()  -- 初始化选中状态(未选择公会)
    self:ButtonClickEventAdd()  -- 按钮点击事件统一添加

    --公会名长度最长限制  中文长度算1
    l_guildNameLengthMaxLimit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NameLengthMaxLimit").Value)
    --搜索框最大数量限制
    self.panel.SearchInput.Input.characterLimit = l_guildNameLengthMaxLimit
    --搜索框增加点击事件(个人觉得这个需求很鸡肋)
    self.panel.SearchInput.Listener.onClick = (function()
        if l_isNoGuild then  --没有任何公会时 点击输入框 提示没有公会 并且 不能输入
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CAN_NOT_SEARCH"))
        end
    end)
    --搜索框起始设置为不可用 有公会时设置为空用 防止无公会点击后无效的情况下再点击动画不统一情况
    self.panel.SearchInput.Input.interactable = false

    --公会列表项的池创建
    self.guildTemplatePool=self:NewTemplatePool({
        UITemplateClass=UITemplate.GuildItemTemplate,
        TemplatePrefab=self.panel.GuildItemPrefab.Prefab.gameObject,
        --TemplateParent=self.panel.GuildItemParent.transform
        ScrollRect=self.panel.ScrollView.LoopScroll
    })
    self.curSelectedItem = nil  --当前选中项

    --列表下拉请求新页
    self.panel.ScrollView.Listener.endDrag = (function()
        -- 仅列表展示模式可下拉获取新页
        if l_listType == 0 then
            local l_viewportHeight = self.panel.ScrollView.RectTransform.sizeDelta.y  -- 获取视口的高度
            local l_itemParentRect = self.panel.GuildItemParent.RectTransform  -- 获取滑动内容块的Rect
            -- 内容长度超过视口 且 下拉超过一个item高度 出发请求新页
            if l_itemParentRect.sizeDelta.y > l_viewportHeight
                and l_itemParentRect.localPosition.y + l_viewportHeight * 0.5 - l_itemParentRect.sizeDelta.y >= 45
            then
                l_guildMgr.ReqGetGuildList(l_lastGuildId)
            end
        end
    end
    )

    --如果已经有公会了 则不显示申请 一键申请 创建 三个按钮
    if l_guildMgr.IsSelfHasGuild() then
        self.panel.BtnApply.UObj:SetActiveEx(false)
        self.panel.BtnApplyAll.UObj:SetActiveEx(false)
        self.panel.BtnCreate.UObj:SetActiveEx(false)
    end

    --请求公会列表
    l_guildMgr.ReqGetGuildList(l_lastGuildId)

end --func end
--next--
function GuildListCtrl:Uninit()

    self.guildTemplatePool = nil

    self.curSelectedItem = nil

    l_guildData = nil
    l_guildMgr = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildListCtrl:OnActive()


end --func end
--next--
function GuildListCtrl:OnDeActive()


end --func end
--next--
function GuildListCtrl:Update()


end --func end



--next--
function GuildListCtrl:BindEvents()

    --列表展示
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_LIST_SHOW,function(self, listType, guildDataList)
        --销毁时生命周期引起的小概率异常容错
        if not self.panel.PanelRef then
            return
        end
        self:ShowGuildList(listType, guildDataList)
    end)
    --申请加入回调
    self:BindEvent(l_guildMgr.EventDispatcher, l_guildMgr.ON_GUILD_APPLY, function(self, appliedList)
        self:SetGuildListApplied(appliedList)
    end)
    --申请加入的公会不存在事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_APPLY_NO_EXIST_GUILD, function(self, ghostId)
        self:OnApplyNoExistGuild(ghostId)
    end)
    --被踢出回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_KICKOUT,function(self)
        UIMgr.DeActiveUI(UI.CtrlNames.GuildList)
    end)
    --公会重连回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_RECONNECT,function(self)
        if l_guildMgr and l_guildMgr.IsSelfHasGuild() then
            if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CREATE_SUCCESS"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_WELCOME_NEW_MEMBER", l_guildData.selfGuildMsg.name))
            end
            UIMgr.DeActiveUI(UI.CtrlNames.GuildIconSelect)
            UIMgr.DeActiveUI(UI.CtrlNames.GuildCreate)
            UIMgr.DeActiveUI(UI.CtrlNames.GuildList)
        end 
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

--初始化选中状态(未选择公会)
function GuildListCtrl:InitSelectedState()
    l_selectedGuildId = 0  -- 重置选中的公会ID
    l_lastGuildId = 0  -- 重置列表最后一个公会的编号
    l_curDataList = {}  -- 重置列表展示的记录信息
    -- 招募宣言清空
    self.panel.RecruitWords.LabText = ""
    -- 申请加入置灰
    --self.panel.BtnApply.Btn.interactable = false  --需求改为可点击
    self.panel.BtnApply:SetGray(true)
    self.panel.BtnApplyText:SetOutLineColor(Color.New(118/255.0, 118/255.0, 118/255.0, 0.5))  -- 选中时颜色201 150 69 255
    -- 联系会长按钮不显示
    --self.panel.BtnContact.UObj:SetActiveEx(false)
    -- 如果之前存在选中项则清除原有选中效果 并且重置
    if self.curSelectedItem~=nil then self.curSelectedItem:SetSelect(false) end
    self.curSelectedItem = nil
end

--按钮点击事件添加
function GuildListCtrl:ButtonClickEventAdd()

    -- 关闭按钮
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildList)
    end)
    -- 搜索按钮
    self.panel.BtnSearch:AddClick(function()
        self:BtnSearchClick()
    end)
    -- 搜索取消按钮
    self.panel.BtnSearchCancel:AddClick(function()
        l_guildMgr.ReqGetGuildList(l_lastGuildId)
        self.panel.SearchInput.Input.text = ""
        self.panel.BtnSearchCancel.UObj:SetActiveEx(false)
    end)
    -- 申请加入按钮
    self.panel.BtnApply:AddClick(function()
        if l_isNoGuild then  --没有任何公会时 提示不能一键申请和别的按钮统一
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CAN_NOT_APPLY"))
        elseif l_selectedGuildId == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_ONE_GUILD"))
        else
            l_guildMgr.ReqApply(l_selectedGuildId)
        end
    end)
    -- 一键申请按钮
    self.panel.BtnApplyAll:AddClick(function()
        if l_isNoGuild then
            --没有任何公会时 提示不能一键申请
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CAN_NOT_APPLY"))
            return
        end
        l_guildMgr.ReqApply(0)
    end)
    --[[-- 联系会长按钮 暂时不做
    self.panel.BtnContact:AddClick(function()
        return
    end)--]]
    -- 公会创建按钮
    self.panel.BtnCreate:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.GuildCreate)
    end)

end

--公会列表搜索按钮点击
function GuildListCtrl:BtnSearchClick()

    --木有人创建公会的时候不让搜索
    if l_isNoGuild then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CAN_NOT_SEARCH"))
        return
    end

    --内容和长度获取
    local l_keyWord = self.panel.SearchInput.Input.text
    local l_keyWordLength = string.ro_len_normalize(l_keyWord)
    --长度为0 则不搜索
    if l_keyWordLength == 0 then
        return
    end
    --长度超过7个字 或者 含有非法字符
    if l_keyWordLength > l_guildNameLengthMaxLimit then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("INPUT_TOO_LONG"))
        return
    end

    l_guildMgr.ReqSearchGuild(l_keyWord)
end

--公会列表展示
--listType 当前展示的列表类型  0:列表展示(可下拉请求新页) 1:搜索结果不可下拉
--guildDataList 获取的公会数据列表
function GuildListCtrl:ShowGuildList(listType, guildDataList)
    l_listType = listType -- 获取列表类型
    if l_listType == 0 then
        self.panel.BtnGroup.UObj:SetActiveEx(true) --按钮组显示
        local l_isFirstPage = false  -- 是否是第一页
        --如果请求到全新的重头开始的列表 则初始化选中状态(从搜索取消回来)
        if l_lastGuildId == 0 then
            self:InitSelectedState()
            l_isFirstPage = true
        end
        --若返回的结果为空
        if #guildDataList == 0 then
            if l_isFirstPage then --如果是第一页
                l_isNoGuild = true  --无公会标志设置
                self.panel.InfoTitle.UObj:SetActiveEx(false)  --招募信息标题不显示
                self.panel.TipNoCreate.UObj:SetActiveEx(true)
                self.panel.TipText.LabText = Lang("NO_GUILD_EXIST")
                --没有任何公会时 一键申请变为灰色
                self.panel.BtnApplyAll:SetGray(true)
                self.panel.BtnApplyAllText:SetOutLineColor(Color.New(118/255.0, 118/255.0, 118/255.0, 0.5))
                self.guildTemplatePool:ShowTemplates({Datas = l_curDataList})
            end
            --无论第几页 没有结果就直接返回
            return
        end
        l_isNoGuild = false  --无公会标志设置为否
        self.panel.SearchInput.Input.interactable = true  --输入框设置可用
        self.panel.InfoTitle.UObj:SetActiveEx(true) --招募信息标题显示
        self.panel.TipNoCreate.UObj:SetActiveEx(false)  --无内容提示关闭
        --防网络不佳时重复请求
        if MLuaCommonHelper.Long(guildDataList[#guildDataList].id) <= MLuaCommonHelper.Long(l_lastGuildId) then return end
        --新页内容拼接到原有的数据列表中
        table.ro_insertRange(l_curDataList, guildDataList)
        --记录列表最后一个公会的编号
        l_lastGuildId = l_curDataList[#l_curDataList].id
        --如果是第一页则重新展示数据
        if l_isFirstPage then
            self.guildTemplatePool:ShowTemplates({Datas=l_curDataList,Method=function(guildItem)
                self:OnSelectGuildItem(guildItem)
            end})
        else
            --数据列表加入新内容后 更新scroll的展示数量
            self.panel.ScrollView.LoopScroll:ChangeTotalCount(#l_curDataList)
        end
    else
        --关闭没有任何公会的图片 防止有人在没有公会的时候搜索再取消搜索的时候刚好有别人创建公会的问题
        self.panel.TipNoCreate.UObj:SetActiveEx(false)
        --重置选中状态
        self:InitSelectedState()
        --搜索取消按钮显示
        self.panel.BtnSearchCancel.UObj:SetActiveEx(true)
        -- 如果没有搜索结果则提示 找不到对应公会
        if #guildDataList == 0 then
            self.panel.InfoTitle.UObj:SetActiveEx(false)  --招募信息标题不显示
            self.panel.BtnGroup.UObj:SetActiveEx(false)  --按钮组不显示
            --提示波利显示
            self.panel.TipNoCreate.UObj:SetActiveEx(true)
            self.panel.TipText.LabText = Lang("GUILD_CAN_NOT_FIND")
        else
            self.panel.InfoTitle.UObj:SetActiveEx(true)  --招募信息标题显示
            self.panel.BtnGroup.UObj:SetActiveEx(true)  --按钮组显示
            --提示波利不显示
            self.panel.TipNoCreate.UObj:SetActiveEx(false)
        end
        -- 获取新内容的数据
        table.ro_insertRange(l_curDataList, guildDataList)
        --展示搜索结果的列表内容 如果列表为空则TemplatePool会将原来的子项全部设置不显示
        self.guildTemplatePool:ShowTemplates({Datas=l_curDataList,Method=function(guildItem)
            self:OnSelectGuildItem(guildItem)
        end})
    end

end


--选中某个公会的点击事件
function GuildListCtrl:OnSelectGuildItem(guildItem)
    local guildData = guildItem.data
    -- 设置选中的公会ID
    l_selectedGuildId = guildData.id
    -- 设置招募宣言 这里是带表情的富文本
    local l_text = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(guildData.declaration)
    self.panel.RecruitWords.LabText = l_text
    -- 设置申请加入可点击 且 取消置灰
    --self.panel.BtnApply.Btn.interactable = true
    self.panel.BtnApply:SetGray(false)
    self.panel.BtnApplyText:SetOutLineColor(Color.New(84/255.0, 134/255.0, 197/255.0))
    -- 联系会长按钮显示
    --self.panel.BtnContact.UObj:SetActiveEx(true)
    -- 如果之前存在选中项则清除原有选中效果
    if self.curSelectedItem ~= nil then self.curSelectedItem:SetSelect(false) end
    -- 更新当前选中项 且 设置选中效果
    self.curSelectedItem = guildItem
    self.curSelectedItem:SetSelect(true)
end

--申请后刷新列表
function GuildListCtrl:SetGuildListApplied(appliedList)
    --应对极端情况 如果只有一个公会 并且一键申请的时候这个公会被解散了 此时认为申请操作成功 但是没有具体申请的公会ID
    if #appliedList == 0 and #l_curDataList <= 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_EXIST_GUILD"))
        self:OnApplyNoExistGuild()
        return
    end
    --接收到的数据进行类型转变
    local l_appliedIdStrList = {}
    for i=1,#appliedList do
        table.insert(l_appliedIdStrList,tostring(appliedList[i].value))
    end
    --遍历本地储存的列表数据 对于已申请的设置已申请标志
    for i=1,#l_curDataList do
        if table.ro_contains(l_appliedIdStrList, tostring(l_curDataList[i].id)) then
            l_curDataList[i].is_apply = true
        end
    end
    --刷新列表
    self.guildTemplatePool:RefreshCells()
end

--请求的公会已解散的情况
function GuildListCtrl:OnApplyNoExistGuild(ghostGuildId)
    --如果当前结果展示较少 则重新请求数据 保证仅有的数据全是新的
    if #l_curDataList <= 5 then
        if l_listType == 0 then
            self:InitSelectedState()
            l_guildMgr.ReqGetGuildList(l_lastGuildId)
        else
            l_guildMgr.ReqSearchGuild(l_keyWord)
        end
    elseif ghostGuildId then
        --如果当前展示数据较多并且知道具体ID 则直接删除本地中的脏数据 保证滑动条位置不重置
        local l_ghostData = nil
        for i = #l_curDataList, 1, -1 do
            if l_curDataList[i].id == ghostGuildId then
                l_ghostData = l_curDataList[i]
                break
            end
        end
        self.guildTemplatePool:RemoveTemplate(l_ghostData)
    end
end
--lua custom scripts end
