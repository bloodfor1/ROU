--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildMemberPanel"
require "UI/Template/GuildMemberItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
GuildMemberHandler = class("GuildMemberHandler", super)
--lua class define end

local l_guildMgr = nil
local l_guildData = nil
local l_curMemberDataList = {}  --当前展示的列表内容
local l_allMemberDataList = {} --全数据列表
local l_searchMemberDataList = {}  --搜索结果数据表
local l_playerNameLengthMaxLimit = MGlobalConfig:GetInt("RoleNameLenMax")
local l_sortType = nil --当前界面需要用到的公会成员排序类型列表
local l_curSortIndex = 0   --当前排序的索引
local l_selectSingleRedFlag = false  --选中的红包列表是否是单个
--全成员操作类型枚举
local l_EMemberOperateType={
    Modify = 0,  --职位修改操作
    Remove = 1,  --人员请出
}

--lua functions
function GuildMemberHandler:ctor()

    super.ctor(self, HandlerNames.GuildMember, 0)

end --func end
--next--
function GuildMemberHandler:Init()
    local redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    self.panel = UI.GuildMemberPanel.Bind(self)
    super.Init(self)

    l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    l_guildData = DataMgr:GetData("GuildData")

    --本界面需要用到的公会排序类型设置
    l_sortType = {
        l_guildData.EMemberSortType.Name,
        l_guildData.EMemberSortType.Level,
        l_guildData.EMemberSortType.Job,
        l_guildData.EMemberSortType.Position,
        l_guildData.EMemberSortType.Contribution,
        l_guildData.EMemberSortType.Achievement,
        l_guildData.EMemberSortType.Activity,
        l_guildData.EMemberSortType.StateOfflineTime,
        l_guildData.EMemberSortType.Normal,  --设定Normal的排序必须在最后 前面的Index对应箭头的UI
    }
    l_curSortIndex = #l_sortType   --设定Normal的排序必须在最后

    --当前成员列表类型设置
    l_guildData.curGuildMemberListType = l_guildData.EMemberListType.AllList

    --按钮点击事件绑定
    self:ButtonClickEventAdd()

    --申请列表按钮红点
    self.RedSignProcessorApply = self:NewRedSign({
        Key = eRedSignKey.GuildApply,
        ClickButton = self.panel.BtnApplyList
    })

    --搜索框输入长度限制
    self.panel.SearchInput.Input.characterLimit = l_playerNameLengthMaxLimit
    self.panel.BeautyToggle:SetActiveEx(false)      --TODO：暂时屏蔽公会魅力方案相关
    --成员列表项的池创建
    self.guildMemberTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildMemberItemTemplate,
        TemplatePrefab = self.panel.GuildMemberItemPrefab.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })

end --func end
--next--
function GuildMemberHandler:Uninit()
    self.RedSignProcessorApply = nil
    self.guildMemberTemplatePool = nil
    if l_guildData then
        l_guildData.ReleaseGuildMemberList()
    end

    l_selectSingleRedFlag = false
    l_guildMgr = nil
    l_guildData = nil

    l_sortType = nil 
    l_curSortIndex = 0 

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildMemberHandler:OnActive()


end --func end
--next--
function GuildMemberHandler:OnDeActive()


end --func end

--next--
function GuildMemberHandler:OnShow()

    --请求成员列表
    l_guildMgr.ReqGuildMemberList()

    self.panel.BeautyChoose:SetActiveEx(false)

    --如果是会长或者副会长显示群发消息按钮
    if l_guildData.GetSelfGuildPosition() < l_guildData.EPositionType.Director then
        self.panel.BtnSendMsgToAll.UObj:SetActiveEx(true)
    else
        self.panel.BtnSendMsgToAll.UObj:SetActiveEx(false)
    end
    --会长 副会长 理事 可以看到在线人数
    if l_guildData.GetSelfGuildPosition() < l_guildData.EPositionType.Deacon then
        self.panel.OnlineNumberBox.UObj:SetActiveEx(true)
    else
        self.panel.OnlineNumberBox.UObj:SetActiveEx(false)
    end

end --func end


--next--
function GuildMemberHandler:Update()


end --func end


--next--
function GuildMemberHandler:BindEvents()

    --成员列表数据传回后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_MEMBERLIST_SHOW,function(self)
        self:ShowGuildMemberList()
    end)

    --可任命魅力担当成员数据传回后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_BEAUTYOK_SHOW, function(self, memberList)
        self:WhoIsBeauty(memberList)
    end)

    --成员职位修改后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_MEMBER_POSITION_MODIFY,function(self, memberId, memberPosition)
        self:SetMemberPosition(memberId, memberPosition)
    end)

    --成员自定义职位名编辑后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_MEMBER_EDIT_POSITION,function(self)
        self:ReflashList()
    end)

    --成员踢出后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_MEMBER_KICKOUT,function(self, memberId)
        self:RemoveMember(memberId)
    end)

    --如果自身职位被修改为会长且自己正打开成员列表则刷新
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_POSITION_CHANGED,function(self)
        if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
            l_guildMgr.ReqGuildMemberList()
        end
    end)
    
    --公会红包列表关闭时更新成员列表红包标志的显示
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_CLOSE_GUILD_RED_ENVELOPE_LIST,function(self, memberId, redInfoList)
        self:SetMemberRedListState(memberId, redInfoList)
    end)
    --选择红包等级ID后事件
    self:BindEvent(MgrMgr:GetMgr("RedEnvelopeMgr").EventDispatcher,MgrMgr:GetMgr("RedEnvelopeMgr").ON_OPEN_REDENVELOPE,function(self, redInfo)
        if l_selectSingleRedFlag then
            local l_redInfoList = {}
            table.insert(l_redInfoList, redInfo)
            self:SetMemberRedListState(redInfo.sender_role_id, l_redInfoList)
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
--按钮点击事件绑定
function GuildMemberHandler:ButtonClickEventAdd()
    --搜索取消按钮
    self.panel.BtnSearchCancel:AddClick(function()
        l_guildMgr.ReqGuildMemberList()
        self.panel.SearchInput.Input.text = ""
        self.panel.BtnSearchCancel.UObj:SetActiveEx(false)
    end)
    --搜索按钮
    self.panel.BtnSearch:AddClick(function()
        self:BtnSearchClick()
    end)
    --申请列表按钮
    self.panel.BtnApplyList:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.GuildApply)
        l_guildMgr.ReqApplyList()
    end)
    --退出公公会按钮
    self.panel.BtnQuit:AddClick(function()
        if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
            --判断除了会长 是否还有其他人
            if #l_allMemberDataList > 1 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CHARMAN_QUIT_CLICK"))
            else
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("GUILD_CHAIRMAN_QUICK_AND_DISBAND_TIP"),
                    function()
                        if l_guildMgr then
                            l_guildMgr.ReqQuit()
                        end
                    end)
            end
        else
            --提示扣除的道具名获取
            local l_crystalItem = TableUtil.GetItemTable().GetRowByItemID(MGlobalConfig:GetInt("CrystalItemID"))  --公会之心
            local l_unitySculpture = TableUtil.GetItemTable().GetRowByItemID(MGlobalConfig:GetInt("UnitySculptureID")) --纪念纹章
            local l_certificateItem = TableUtil.GetItemTable().GetRowByItemID(MGlobalConfig:GetInt("CertificateItemID"))  --时空之证
            local l_crystalItemName = l_crystalItem and l_crystalItem.ItemName or ""
            local l_unitySculptureName = l_unitySculpture and l_unitySculpture.ItemName or ""
            local l_certificateItemName  = l_certificateItem and l_certificateItem.ItemName or ""
            --提示展示
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("GUILD_QUIT", l_crystalItemName, l_unitySculptureName, l_certificateItemName),
                function()
                    if l_guildMgr then
                        l_guildMgr.ReqQuit()
                    end
                end, nil, nil, nil, nil, nil, CommonUI.Dialog.DialogTopic.GUILD)
        end
    end)
    --公会魅力担当筛选按钮点击
    self.panel.BeautyOnlyBtn:AddClick(function()
        if self.panel.BeautyChoose.gameObject.activeSelf then
            self.panel.BeautyChoose:SetActiveEx(false)
            l_guildMgr.ReqGuildMemberList()
        else
            self.panel.BeautyChoose:SetActiveEx(true)
            l_guildMgr.FindGuildBeautyCandidate()
        end
    end)
    --职位编辑按钮点击
    self.panel.BtnEdit:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.GuildEditorialPosition)
    end)
    --群发消息按钮
    self.panel.BtnSendMsgToAll:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.GuildEmail)
    end)
    --根据排序设置的分类 设置可点击表头的点击功能
    for i = 1, table.ro_size(l_sortType) - 1 do
        self.panel.BtnLetter[i]:AddClick(function()
            self:SortMemberList(i)
        end)
    end
end

--成员列表搜索按钮点击
function GuildMemberHandler:BtnSearchClick()
    local l_keyWord = self.panel.SearchInput.Input.text
    local l_keyWordLength = string.ro_len(l_keyWord)
    --长度为0 则不搜索
    if l_keyWordLength == 0 then
        return
    end
    --长度超过7个字 或者 含有非法字符
    if l_keyWordLength > l_playerNameLengthMaxLimit then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("INPUT_TOO_LONG"))
        return
    end

    MgrMgr:GetMgr("ForbidTextMgr").RequestJudgeTextForbid(l_keyWord, function(checkInfo)
        local l_resultCode = checkInfo.result
        if l_resultCode ~= 0 then
            --判断服务器是否判断失败 如果失败什么都不发生
            if l_resultCode == ErrorCode.ERR_FAILED then
                return
            end
            --含有屏蔽字则提示
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resultCode))
            return
        end
        --不含屏蔽字则搜索
        if self.panel ~= nil then
            self:SearchMember(checkInfo.text)
        end
    end)
end

--成员搜索
function GuildMemberHandler:SearchMember(keyword)
    l_guildData.curGuildMemberListType = l_guildData.EMemberListType.SearchList -- 获取列表类型 搜索类型
    l_searchMemberDataList = {}
    for i = 1, #l_allMemberDataList do
        if string.find(l_allMemberDataList[i].baseInfo.name, keyword) then
            table.insert(l_searchMemberDataList, l_allMemberDataList[i])
        end
    end
    --搜索无结果提示的展示控制
    if #l_searchMemberDataList == 0 then
        self.panel.TipNoResult.UObj:SetActiveEx(true)
    else
        self.panel.TipNoResult.UObj:SetActiveEx(false)
    end
    --重置排序并展示
    self:SortMemberList(#l_sortType)
    --取消搜索按钮显示
    self.panel.BtnSearchCancel.UObj:SetActiveEx(true)
end

--成员列表展示
--guildDataList 获取的公会数据列表
function GuildMemberHandler:ShowGuildMemberList()
    self.panel.TipNoResult.UObj:SetActiveEx(false)  --无搜素结果提示关闭
    l_guildData.curGuildMemberListType = l_guildData.EMemberListType.AllList -- 设置列表类型
    l_allMemberDataList = l_guildData.guildMemberList
    l_searchMemberDataList = {} --清空搜索数据的缓存
    --重置排序并展示
    self:SortMemberList(#l_sortType)
    --在线人数显示
    self.panel.OnlineNumber.LabText = string.format("%d/%d", l_guildData.curOnlineNum, #l_allMemberDataList)
end

--成员职位筛选
function GuildMemberHandler:WhoIsBeauty(info)

    local l_guildMemberList = {}
    for i = 1, #info do
        local l_member = l_guildData.AnalysisMemberInfo(info[i])
        if l_member then
            table.insert(l_guildMemberList, l_member)
        end
    end
    l_searchMemberDataList = l_guildMemberList
    l_curMemberDataList = l_searchMemberDataList

    self.panel.TipNoResult.UObj:SetActiveEx(#l_curMemberDataList == 0)
    l_guildData.curGuildMemberListType = l_guildData.EMemberListType.SearchList
    self.guildMemberTemplatePool:ShowTemplates({Datas = l_curMemberDataList,
        Method = function(memberItem, clickType)
            if clickType == 0 then
                --头像点击
                l_guildMgr.ShowMemberDetailInfo(memberItem.data)
            elseif clickType == 1 then
                --红包点击
                self:RedEnvelopeFlagClick(memberItem.data)
            end
        end})
end

--成员列表排序
function GuildMemberHandler:SortMemberList(sortTypeIndex)
    --索引错误则返回
    if sortTypeIndex == 0 or sortTypeIndex > #l_sortType then
        return
    end
    --临时数据表申明
    local l_tempList = {}
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
    if l_guildData.curGuildMemberListType == l_guildData.EMemberListType.AllList then
        l_tempList = l_allMemberDataList
    else
        l_tempList = l_searchMemberDataList
    end
    --排序
    l_tempList = l_guildData.SortMemberList(l_tempList, l_sortType[sortTypeIndex],
        l_guildData.curGuildMemberListType == l_guildData.EMemberListType.AllList)
    l_curSortIndex = sortTypeIndex
    l_curMemberDataList = l_tempList

    --展示对应排序标志
    if sortTypeIndex ~= #l_sortType then
        self.panel.SortIcon[l_curSortIndex].UObj:SetActiveEx(true)
        MLuaCommonHelper.SetLocalScaleX(self.panel.SortIcon[l_curSortIndex].UObj, 1)
    end
    --数据展示
    self.guildMemberTemplatePool:ShowTemplates({Datas = l_curMemberDataList,
        Method = function(memberItem, clickType)
            if clickType == 0 then
                --头像点击
                l_guildMgr.ShowMemberDetailInfo(memberItem.data)
            elseif clickType == 1 then
                --红包点击
                self:RedEnvelopeFlagClick(memberItem.data)
            end
        end})
end

--倒序翻转当前列表
function GuildMemberHandler:ReverseCurList()
    --获取反序列表
    l_curMemberDataList = l_guildData.ReverseMemberList(l_curMemberDataList)
    --对应排序标志翻转
    local l_scaleX = self.panel.SortIcon[l_curSortIndex].Transform.transform.localScale.x
    MLuaCommonHelper.SetLocalScaleX(self.panel.SortIcon[l_curSortIndex].UObj, l_scaleX * -1)
    --数据展示 并直接返回
    self.guildMemberTemplatePool:ShowTemplates({Datas = l_curMemberDataList,
        Method = function(memberItem, clickType)
            if clickType == 0 then
                --头像点击
                l_guildMgr.ShowMemberDetailInfo(memberItem.data)
            elseif clickType == 1 then
                --红包点击
                self:RedEnvelopeFlagClick(memberItem.data)
            end
        end})
end

--修改职位操作后在列表中修改成员的职位
--memberId  被修改的成员编号
--memberPosition  新的职位编号
function GuildMemberHandler:SetMemberPosition(memberId, memberPosition)
    --修改全部成员数据表中的数据 因为本地搜索所以全员表必须改  不用管当前展示表 那个是临时表 每次搜索会自动从全员表中更新
    if memberPosition ~= 1 then --非会长转移直接刷新列表数据
        for i = 1, #l_curMemberDataList do
            local member = l_curMemberDataList[i]
            if member.baseInfo.roleId == memberId then
                member.position = memberPosition
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(
                    StringEx.Format(Lang("GUILD_POSITION_MODIFY_SUCCESS"), member.baseInfo.name, l_guildData.GetPositionName(memberPosition)))
                break
            end
        end
        self.guildMemberTemplatePool:RefreshCells()
        --全数据中修改 并且重新统计管理人员数量
        self:AllMemberListOperate(l_EMemberOperateType.Modify, memberId, memberPosition)
    else  --会长转移 自身职位修改为普通成员 并关闭窗口
        l_guildData.selfGuildMsg.position = l_guildData.EPositionType.Member
        UIMgr:DeActiveUI(UI.CtrlNames.Guild)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CHAIRMAN_CHANGE_SUCCESS"))
    end
end

--关闭红包列表后更新成员列表的标志状态
--memberId  被修改的成员编号
--redInfoList  该成员的红包信息列表
function GuildMemberHandler:SetMemberRedListState(memberId, redInfoList)

    --当前展示表修改
    for i = 1, #l_curMemberDataList do
        local member = l_curMemberDataList[i]
        if member.baseInfo.roleId == memberId then
            member.redEnvelopeList = redInfoList
            break
        end
    end
    self.guildMemberTemplatePool:RefreshCells()
    --全成员表修改
    for i = 1, #l_allMemberDataList do
        local member = l_allMemberDataList[i]
        if member.baseInfo.roleId == memberId then
            member.redEnvelopeList = redInfoList
            break
        end
    end

end

--刷新列表
function GuildMemberHandler:ReflashList()
    self.guildMemberTemplatePool:RefreshCells()
end

--踢出操作后在列表中删除被踢出成员信息
--memberId  被踢出的成员编号
function GuildMemberHandler:RemoveMember(memberId)
    --删除全员表中的指定数据 因为本地搜索所以全员表必须改  不用管当前展示表 那个是临时表 每次搜索会自动从全员表中更新
    local aimData = nil
    for i = #l_curMemberDataList, 1, -1 do
        if l_curMemberDataList[i].baseInfo.roleId == memberId then
            aimData = l_curMemberDataList[i]
            break
        end
    end
    self.guildMemberTemplatePool:RemoveTemplate(aimData)
    --全数据中删除 
    self:AllMemberListOperate(l_EMemberOperateType.Remove, memberId)
end

--成员列表红包标志点击
function GuildMemberHandler:RedEnvelopeFlagClick(memberData)
    if #memberData.redEnvelopeList > 1 then
        l_selectSingleRedFlag = false
        local l_openData = {
            type = l_guildData.EUIOpenType.GuildRedEnvelopeList,
            roleId = memberData.baseInfo.roleId,
            redEnvelopeList = memberData.redEnvelopeList
        }
        UIMgr:ActiveUI(UI.CtrlNames.GuildRedEnvelopeList, l_openData)
    else
        l_selectSingleRedFlag = true
        local l_redInfo = memberData.redEnvelopeList[1]
        if l_redInfo.is_received or l_redInfo.is_finished then
            --如果已经领取过 或者 已经是领取完的红包 则直接请求红包的结果
            MgrMgr:GetMgr("RedEnvelopeMgr").ReqGetRedEnvelopeResultRecord(l_redInfo.guild_red_envelope_id)
            --如果原本是未接收的则更新列表显示
            if not l_redInfo.is_received then
                l_redInfo.is_received = true
                self:SetMemberRedListState(memberData.baseInfo.roleId, memberData.redEnvelopeList)
            end
        else
            --如果没有领过也不是被领完的红包则 请求确认红包状态
            local l_redIds = {}
            table.insert(l_redIds, l_redInfo.guild_red_envelope_id)
            MgrMgr:GetMgr("RedEnvelopeMgr").ReqCheckRedEnvelopeState(l_redIds)
        end
    end
end

--全数据操作
--operateType 0职位修改 1玩家请出
--memberId 玩家的ID 
--position 新职位
function GuildMemberHandler:AllMemberListOperate(operateType, memberId, position)
    --初始化统计数据
    l_guildData.InitCountData()
    for i = #l_allMemberDataList, 1, -1 do
        local l_member = l_allMemberDataList[i]
        --删除成员操作 删除的人不参与统计
        if operateType == l_EMemberOperateType.Remove and l_member.baseInfo.roleId == memberId then
            table.remove(l_allMemberDataList, i)
        else
            --职位修改操作
            if operateType == l_EMemberOperateType.Modify and l_member.baseInfo.roleId == memberId then
                l_member.position = position
            end
            l_guildData.GuildMemberCount(l_member)
        end
    end
    self.panel.OnlineNumber.LabText = string.format("%d/%d", l_guildData.curOnlineNum, #l_allMemberDataList)
end
--lua custom scripts end
return GuildMemberHandler