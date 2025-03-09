--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RankPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
RankCtrl = class("RankCtrl", super)
--lua class define end

local l_LeaderBoardTable = TableUtil.GetLeaderBoardTable()


--lua functions
function RankCtrl:ctor()

    super.ctor(self, CtrlNames.Rank, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent
    self.ClosePanelNameOnClickMask = UI.CtrlNames.Rank
end --func end
--next--
function RankCtrl:Init()
    self.panel = UI.RankPanel.Bind(self)
    super.Init(self)
    self.RowsInfo = {}
    --左侧按钮用于style == 1 or 3
    self.RankDetailTem = nil
    --右侧时间显示 用于style == 1 or 2
    self.RankTimeStampTem = nil
    --排行榜每列名字
    self.RankTitleTem = nil
    --排行榜每行
    self.RankRowTem = nil
    --自己榜
    self.MyRowTems = {}
    --记录左侧选中第几个
    self.detailIndex = 1
    --记录右下角下拉框选中第几个
    self.dropdownIndex = 0
    --是否需要显示进行中页签 与frame表中ShowTagDuringEvent字段有关
    self.needCurrentTab = false
    --排行榜对应的活动ID
    self.EventID = 0
    --样式Id 对应Frame表中Style字段
    self.StyleId = 0
    --选择仅显示好友时发给服务器的数据
    self.friendChoose = 0

    --是否拥有左侧多榜页签
    self.haveDetail = false
    --是否拥有右侧时间页签
    self.haveTimeStamp = false
    --是否拥有仅显示好友按钮
    self.haveShowFriend = false
    --是否拥有右下角下拉列表
    self.haveDropdown = false


    --对应LeaderBoardFrameTable
    self.RankFrameId = nil
    --对应LeaderBoardTable
    self.RankBoardId = nil
    --对应LeaderBoardComponentTable
    self.RankCompomentId = nil


    --获取数据用
    self.RankType = 0
    self.ShowFriendOrGuild = 2
    self.RankTime = 0
    self.Page = 0
    --获取数据用end


    --缓存对应的frame表行
    self.myRow = nil

    ---@type ModuleMgr.RankMgr
    self.mgr = MgrMgr:GetMgr("RankMgr")
    ---@type ModuleData.RankData
    self.data = DataMgr:GetData("RankData")
    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Rank)
    end)
end --func end
--next--
function RankCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.data.TotalNum = 0
    self.data.totalPage = 0
end --func end
--next--
function RankCtrl:OnActive()
    self.panel.Icon_Choice:SetActiveEx(false)

    self.panel.RankNode:SetActiveEx(false)

    if self.uiPanelData.openType ~= nil then
        self.RankFrameId = self.uiPanelData.RankMainType
        self:OnInit()
        self:TryToGetInfo()
    end

    self.panel.Btn_Choice:AddClick(function()
        if self.panel.Icon_Choice.UObj.activeSelf then
            self.panel.Icon_Choice:SetActiveEx(false)
            self.ShowFriendOrGuild = 2
        else
            self.panel.Icon_Choice:SetActiveEx(true)
            if self.friendChoose == 0 then
                self.friendChoose = 2
            end
            self.ShowFriendOrGuild = self.friendChoose
        end
        self:TryToGetInfo()
    end)


end --func end
--next--
function RankCtrl:OnDeActive()
    self.RowsInfo = {}

end --func end
--next--
function RankCtrl:Update()


end --func end
--next--

function RankCtrl:OnInit()
    self.Page = 0
    self.RankTime = 0
    self.RankType = self.RankFrameId
    self.dropdownIndex = 0

    self.detailIndex = 1

    self.RankBoardId = self.RankFrameId
    self.RankCompomentId = self.RankBoardId
    self.myRow = TableUtil.GetLeaderBoardFrameTable().GetRowByID(self.RankFrameId)
    self.panel.Txt_FuncName.LabText = self.myRow.Name
    self.StyleId = self.myRow.Style
    self.EventID = self.myRow.EventID
    self:SetShowFriend()
    self:SetStyle()

    self:SetRankDetail()
    self:SetTimeStampPanel()
    self:SetDropDown()
    self:RefreshTitle()

    self.panel.RankNode:SetActiveEx(true)

end

--初始化仅显示好友字段
function RankCtrl:SetShowFriend()
    local l_friendType = Common.Functions.VectorToTable(l_LeaderBoardTable.GetRowByID(self.RankBoardId).PermissionLevel)
    self.haveShowFriend = #l_friendType > 1 and l_friendType[1] == self.data.BoardViewType.kBoardViewTypeAll
    self.friendChoose = 0
    for i = 1, #l_friendType do
        if l_friendType[i] ~= 1 then
            self.friendChoose = self.friendChoose + self.data.ShowFriendType[l_friendType[i]]
        end
    end
    if self.friendChoose == 0 then
        self.friendChoose = 2
    end
    if not self.haveShowFriend then
        self.ShowFriendOrGuild = self.friendChoose
    end
end

function RankCtrl:BindEvents()
    local Referesh = function(self, strKey, targetRankList)
        local l_key = self.RankType .. "_" .. self.ShowFriendOrGuild .. "_" .. self.RankTime
        if l_key == strKey then
            self:AddPageInfo(targetRankList)
            self:RefreshAll()
        end
    end
    self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_IS_READY, Referesh)
    self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_NIL, function(self)
        self.RowsInfo = {}
        self.data.TotalNum = 0
        self:RefreshAll()
    end)
    self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_NEXT_PAGE, function(self, strKey, targetRankList)
        local l_key = self.RankType .. "_" .. self.ShowFriendOrGuild .. "_" .. self.RankTime
        if l_key == strKey then
            self:AddPageInfo(targetRankList)
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

function RankCtrl:SetRankDetail()
    if not self.haveDetail then
        self.RankBoardId = self.RankFrameId
        return
    end
    if self.RankDetailTem == nil then
        self.RankDetailTem = self:NewTemplatePool({
            TemplateClassName = "RankDetailTem",
            TemplatePrefab = self.panel.RankDetailTem.gameObject,
            ScrollRect = self.panel.ScrollRect_RankDetail.LoopScroll,
            Method = function(index, pickIndex)
                self:SelectRankDetail(index, pickIndex)
            end
        })
    end
    local detailDatas = {}
    local details = Common.Functions.VectorToTable(self.myRow.LeaderBoards)
    for i = 1, table.maxn(details) do
        local data = {}
        local l_row = l_LeaderBoardTable.GetRowByID(details[i])
        data.name = l_row.Name
        data.Index = details[i]
        table.insert(detailDatas, data)
    end
    self.RankDetailTem:ShowTemplates({ Datas = detailDatas })
    self.RankDetailTem:SelectTemplate(self.detailIndex)
end

function RankCtrl:SelectRankDetail(index, pickIndex)
    if self.RankDetailTem then
        if index ~= self.detailIndex then
            self.detailIndex = index
            self.RankDetailTem:SelectTemplate(self.detailIndex)
            self.RankBoardId = pickIndex
            self:SetDropDown()
            self:HaveClick()
        end
    end
end

function RankCtrl:SetTimeStampPanel()
    if not self.haveTimeStamp then
        self.RankTime = 0
        return
    end
    self.needCurrentTab = self.myRow.ShowTagDuringEvent == 1
    local isCurrent = MgrMgr:GetMgr("DailyTaskMgr").IsActivityOpend(self.EventID)
    if self.RankTimeStampTem == nil then
        self.RankTimeStampTem = self:NewTemplatePool({
            TemplateClassName = "RankTimeStampTem",
            TemplatePrefab = self.panel.RankTimeStampTem.gameObject,
            TemplateParent = self.panel.TogGroup_TimeStampParent.Transform,
            Method = function(index, timeStamp)
                self:SelectRankTimeStamp(index, timeStamp)
            end
        })
    end
    self.RankTimeStampTem:ShowTemplates()
    local l_TimeStamps = self.mgr.GetTimeStampsByType(self.RankType)
    local TimeStampDatas = {}
    if l_TimeStamps then
        for i = 1, table.maxn(l_TimeStamps) do
            local l_data = {}

            local l_timeTable = Common.TimeMgr.GetTimeTable(Common.TimeMgr.GetLocalTimestamp(l_TimeStamps[i].severstamp.value))
            l_data.name = Lang("DATE_M_D", l_timeTable.month, l_timeTable.day)
            l_data.isCurrent = i == 1 and self.needCurrentTab and isCurrent
            l_data.timeStamp = l_TimeStamps[i].severstamp.value
            table.insert(TimeStampDatas, l_data)
        end
    end
    if #TimeStampDatas == 0 then
        table.insert(TimeStampDatas, { name = "", isCurrent = self.needCurrentTab and isCurrent })
    end
    self.RankTimeStampTem:ShowTemplates({ Datas = TimeStampDatas })
    self.RankTimeStampTem:SelectTemplate(self.RankTime + 1)
end

function RankCtrl:SelectRankTimeStamp(index, timeStamp)
    --使用标签传递从0开始，若后续需要改为使用时间戳传递改为使用第二个参数记录，使用时间戳请解决第一次初始化没有时间戳数据的问题
    if self.RankTimeStampTem then
        if self.RankTime ~= index - 1 then
            self.RankTimeStampTem:SelectTemplate(index)
            self.RankTime = index - 1
            self:HaveClick()
        end
    end
end

function RankCtrl:RefreshTitle()
    if self.RankTitleTem == nil then
        self.RankTitleTem = self:NewTemplatePool({
            TemplateClassName = "RankNameTextTem",
            TemplatePath = "UI/Prefabs/RankNameTextTem",
            TemplateParent = self.panel.Title_Bg.Transform,
        })
    end
    self.RankTitleTem:ShowTemplates()
    local titleDatas = {}
    local l_info = self.mgr.GetPbVarInExcelByType(self.RankType)
    for _, v in pairs(l_info) do
        local l_data = {}
        l_data.value = v.name
        l_data.columnWidth = v.columnWidth
        l_data.color = nil
        table.insert(titleDatas, l_data)
    end
    self.RankTitleTem:ShowTemplates({ Datas = titleDatas })
end

function RankCtrl:RefreshRank()
    self:RefreshTitle()
    if self.RankRowTem == nil then
        self.RankRowTem = self:NewTemplatePool({
            TemplateClassName = "RankRowTem",
            TemplatePrefab = self.panel.RankRowTem.gameObject,
            ScrollRect = self.panel.RankRowScroll.LoopScroll,
            GetDatasMethod = function()
                return self:GetNowPage()
            end
        })
    end
    self.panel.None:SetActiveEx(self.data.TotalNum == 0)
    self.RankRowTem:ShowTemplates()

    local l_ownRankInfo = self.mgr.GetOwnRankInfo()
    if l_ownRankInfo ~= nil and #l_ownRankInfo > 1 then
        self.panel.MyRowBg:SetActiveEx(true)
        self.panel.MyRow:SetActiveEx(true)
        if self.MyRowTems then
            for k, v in pairs(self.MyRowTems) do
                self:UninitTemplate(v)
            end
        end
        self.MyRowTems = {}
        local l_rowName = self.mgr.GetPbVarInExcelByType(self.RankType)
        local count = 0
        local maxCount = #l_rowName
        for k, v in pairs(l_rowName) do
            local l_data = { value = l_ownRankInfo[k].value, color = v.ownColor, columnWidth = v.columnWidth, isMine = true and v.var == "score", showMemberType = l_ownRankInfo[k].showMemberType, membersInfo = l_ownRankInfo[k].membersInfo }
            local l_tem = self:NewTemplate(tostring(v.templateName), {
                TemplatePath = "UI/Prefabs/" .. tostring(v.templateName),
                TemplateParent = self.panel.MyRow.Transform,
                Data = l_data
            })
            l_tem:AddLoadCallback(function()
                count = count + 1
                if count == maxCount then
                    self:SortTem()
                end
            end)
            table.insert(self.MyRowTems, l_tem)
        end
    else
        self.panel.MyRowBg:SetActiveEx(false)
        self.panel.MyRow:SetActiveEx(false)
    end
end

function RankCtrl:TryToGetInfo()
    self.RowsInfo = {}
    self.data.TotalNum = 0
    self.mgr.TryToGetRankListInfo(self.RankType, self.ShowFriendOrGuild, self.RankTime, self.Page)
end

function RankCtrl:SetStyle()
    self:RefreshTitle()
    if self.StyleId == 1 then
        self.haveDetail = true
        self.haveTimeStamp = true
    elseif self.StyleId == 2 then
        self.haveDetail = false
        self.haveTimeStamp = true
    elseif self.StyleId == 3 then
        self.haveDetail = true
        self.haveTimeStamp = false
    elseif self.StyleId == 4 then
        self.haveDetail = false
        self.haveTimeStamp = false
    end
    local l_components = Common.Functions.VectorToTable(l_LeaderBoardTable.GetRowByID(self.RankFrameId).Components)
    self.haveDropdown = #l_components > 1
    self.panel.Obj_RankDetail:SetActiveEx(self.haveDetail)
    self.panel.TogGroup_TimeStampParent:SetActiveEx(self.haveTimeStamp)
    self.panel.Img_AlphaBg:SetActiveEx(self.haveTimeStamp)
    self.panel.Obj_Rank_List_Bg:SetActiveEx(true)
    self.panel.Obj_ShowFriend:SetActiveEx(self.haveShowFriend)
    self.panel.Dropdown_Root:SetActiveEx(self.haveDropdown)
    --self:RefreshRank()
end

function RankCtrl:SetTipsAndRewardBtn()
    local compomentInfo = TableUtil.GetLeaderBoardComponentTable().GetRowByID(self.RankCompomentId)
    local tipsStr = compomentInfo.RankTips
    if tipsStr and tipsStr ~= "" then
        self.panel.RefreshTips.LabText = tipsStr
        self.panel.RefreshTips:SetActiveEx(true)
    else
        self.panel.RefreshTips:SetActiveEx(false)
    end
    local reward = compomentInfo.Reward
    if reward and reward.Length > 0 then
        self.panel.Btn_ShowReward:SetActiveEx(true)
        local nameStr = self.panel.Txt_FuncName.LabText
        self.panel.Btn_ShowReward:AddClickWithLuaSelf(function()
            UIMgr:ActiveUI(UI.CtrlNames.RankReward, { rewardInfo = Common.Functions.VectorSequenceToTable(reward), rankName = nameStr })
        end, self)
    else
        self.panel.giftlook:SetActiveEx(false)
    end
end

--初始化右下角下拉框信息
function RankCtrl:SetDropDown()
    if not self.haveDropdown then
        self.RankCompomentId = self.RankBoardId
        self.RankType = self.RankCompomentId
        self:SetTipsAndRewardBtn()
        return
    end
    self:SetTipsAndRewardBtn()
    local l_components = Common.Functions.VectorToTable(l_LeaderBoardTable.GetRowByID(self.RankBoardId).Components)
    local l_dropdownStrs = {}
    ---@type LeaderBoardComponentTable
    local l_table = TableUtil.GetLeaderBoardComponentTable()
    for i = 1, table.maxn(l_components) do
        table.insert(l_dropdownStrs, l_table.GetRowByID(l_components[i]).Name)
    end
    self.panel.Dropdown.DropDown:ClearOptions()
    self.panel.Dropdown:SetDropdownOptions(l_dropdownStrs)
    local l_onValueChanged = function(index)
        if self.RankCompomentId ~= l_components[index + 1] then
            self.dropdownIndex = index
            self.RankCompomentId = l_components[index + 1]
            self.RankType = self.RankCompomentId
            self:SetTipsAndRewardBtn()
            self:HaveClick()
        end
    end
    -- 初始化
    self.panel.Dropdown.DropDown.value = self.dropdownIndex
    self.panel.Dropdown.DropDown.onValueChanged:AddListener(l_onValueChanged)

end

function RankCtrl:RefreshAll()
    self.myRow = TableUtil.GetLeaderBoardFrameTable().GetRowByID(self.RankFrameId)
    if self.myRow == nil then
        logError("未正确传入数据，请检查调用")
        return
    end
    self:RefreshRank()
    self:SetTimeStampPanel()
end

function RankCtrl:GetNowPage()
    return self.RowsInfo
end

function RankCtrl:AddPageInfo(newRowTb)
    local l_tabs = table.ro_deepCopy(newRowTb)
    local l_info = self.mgr.GetPbVarInExcelByType(self.RankType)
    local rowDatas = {}
    local changeTot = #self.RowsInfo
    for k, v in pairs(l_tabs) do
        ---@class RankRowTemData
        local l_data = {}
        l_data.index = k
        l_data.rowValue = v
        l_data.rowName = l_info
        table.insert(rowDatas, l_data)
    end
    table.ro_insertRange(self.RowsInfo, rowDatas)
    self.data.TotalNum = #self.RowsInfo
    if changeTot ~= 0 then
        self.panel.RankRowScroll.LoopScroll:ChangeTotalCount(self.data.TotalNum)
    end
end

function RankCtrl:SortTem()
    for i = 1, #self.MyRowTems do
        self.MyRowTems[i]:transform():SetSiblingIndex(i - 1)
    end
end

function RankCtrl:HaveClick()
    self:TryToGetInfo()
end
--lua custom scripts end
return RankCtrl