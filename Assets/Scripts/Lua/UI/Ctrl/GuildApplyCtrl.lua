--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildApplyPanel"
require "UI/Template/GuildApplyItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildApplyCtrl = class("GuildApplyCtrl", super)
--lua class define end

local l_guildMgr = nil
local l_guildData = nil
local l_isAutoAgree = false  -- 是否自动同意
local l_sortType = nil --当前界面需要用到的公会成员排序类型列表
local l_curSortIndex = 0   --当前排序的索引
local l_applyList = nil  --申请者列表
local l_reverse = false  --是否是倒序

--lua functions
function GuildApplyCtrl:ctor()

    super.ctor(self, CtrlNames.GuildApply, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function GuildApplyCtrl:Init()

    self.panel = UI.GuildApplyPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildMgr = MgrMgr:GetMgr("GuildMgr")

    --本界面需要用到的公会排序类型设置
    l_sortType = {
        l_guildData.EMemberSortType.Name,
        l_guildData.EMemberSortType.Level,
        l_guildData.EMemberSortType.Job,
        l_guildData.EMemberSortType.None,  --设定None的排序必须在最后 前面的Index对应箭头的UI
    }
    l_curSortIndex = #l_sortType   --设定None的排序必须在最后
    l_reverse = false

    if DataMgr:GetData("GuildData").GetSelfGuildPosition() > l_guildData.EPositionType.Deacon then
        --普通成员魅力担当不显示操作按钮
        --self.panel.BtnAgreeAll.UObj:SetActiveEx(false)
        self.panel.BtnIgnoreAll.UObj:SetActiveEx(false)
        self.panel.TogAutoBtn.UObj:SetActiveEx(false)
        self.panel.TogAuto.UObj:SetActiveEx(false)
    end

    --按钮点击事件绑定
    self:ButtonClickEventAdd()

    --申请者列表项的池创建
    self.guildApplyTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildApplyItemTemplate,
        TemplatePrefab = self.panel.GuildApplyItemPrefab.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })

    --请求列表
    l_guildMgr.ReqApplyList()

end --func end
--next--
function GuildApplyCtrl:Uninit()

    self.guildApplyTemplatePool = nil

    if l_guildData then
        l_guildData.ReleaseGuildApplyList()
    end

    l_reverse = false
    l_sortType = nil 
    l_curSortIndex = 0 
    l_applyList = nil

    super.Uninit(self)
    l_guildMgr = nil
    l_guildData = nil
    self.panel = nil

end --func end
--next--
function GuildApplyCtrl:OnActive()


end --func end
--next--
function GuildApplyCtrl:OnDeActive()


end --func end
--next--
function GuildApplyCtrl:Update()


end --func end

--next--
function GuildApplyCtrl:BindEvents()
    --列表展示事件绑定
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_APPLYLIST_SHOW,function(self, isAuto)
        l_applyList = l_guildData.guildApplyList or {}
        --如果列表为空则展示提示 不为空则不展示提示(全部清空会导致刷新)
        if #l_applyList == 0 then
            self.panel.TipNoApply.UObj:SetActiveEx(true)
        else
            self.panel.TipNoApply.UObj:SetActiveEx(false)
        end
        self:ShowApplyList(l_curSortIndex, false)
        --自动同意
        l_isAutoAgree = isAuto
        self.panel.TogAuto.Tog.isOn = isAuto
    end)
 
    --开关自动同意事件绑定
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_APPLY_SWITCH_AUTO,function(self, isAuto)
        l_isAutoAgree = isAuto
        self.panel.TogAuto.Tog.isOn = isAuto
    end)
    --被踢出回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_KICKOUT,function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildApply)
    end)
    --批准操作回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_CHECK_APPLY,function(self, memberId)
        if memberId == 0 then
            --忽略全部
            l_applyList = {}
            self.guildApplyTemplatePool:ShowTemplates({Datas = l_applyList})
            self.panel.TipNoApply.UObj:SetActiveEx(true)
        else
            --单个角色同意
            local aimData = nil
            for i = #l_applyList, 1, -1 do
                if l_applyList[i].baseInfo.roleId == memberId then
                    aimData = l_applyList[i]
                    break
                end
            end
            self.guildApplyTemplatePool:RemoveTemplate(aimData)
        end
    end)
    --公会重连回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_RECONNECT,function(self)
        l_guildMgr.ReqApplyList()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildApplyCtrl:GuildApplyShow()
    -- body
end

--按钮功能绑定
function GuildApplyCtrl:ButtonClickEventAdd()
    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        --如果成员列表界面展示为正常列表则需要刷新 是搜索结果则不需要刷新
        if l_guildData.curGuildMemberListType == l_guildData.EMemberListType.AllList then
            l_guildMgr.ReqGuildMemberList()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.GuildApply)
    end)
    --[[--全部同意按钮点击
    self.panel.BtnAgreeAll:AddClick(function()
        l_guildMgr.ReqCheckApply(0, true)
    end)--]]
    --全部忽略按钮点击
    self.panel.BtnIgnoreAll:AddClick(function()
        l_guildMgr.ReqCheckApply(0, false)
    end)
    --自动收人开关点击
    self.panel.TogAutoBtn:AddClick(function()
        l_guildMgr.ReqSetAutoCheck(not l_isAutoAgree)
    end)
    --排序按钮组
    for i = 1, #self.panel.BtnLetter do
        self.panel.BtnLetter[i]:AddClick(function()
            self:ShowApplyList(i, true)
        end)
    end
end

--申请者列表排序
--sortTypeIndex  排序类型索引 
--isClickSort  是否是点击排序
function GuildApplyCtrl:ShowApplyList(sortTypeIndex, isClickSort)
    --索引错误则返回
    if sortTypeIndex == 0 or sortTypeIndex > #l_sortType then
        return
    end
    --判断是否是已排序类型再次点击 取反序列
    if isClickSort and sortTypeIndex == l_curSortIndex then
        self:SortReverseOrder(sortTypeIndex, isClickSort)
        return
    end
    --重置排序标志
    for i = 1, #self.panel.SortIcon do
        self.panel.SortIcon[i].UObj:SetActiveEx(false)
    end
    --排序
    l_applyList = l_guildData.SortMemberList(l_applyList, l_sortType[sortTypeIndex])
    --展示对应排序标志
    if sortTypeIndex ~= #l_sortType then
        self.panel.SortIcon[sortTypeIndex].UObj:SetActiveEx(true)
        MLuaCommonHelper.SetLocalScaleX(self.panel.SortIcon[sortTypeIndex].UObj, 1)
    end
    --判断是否需要刷新数据为倒序
    if sortTypeIndex == l_curSortIndex and l_reverse then
        --原本是倒序 保持倒序展示
        self:SortReverseOrder(sortTypeIndex, isClickSort)
    else
        --列表展示
        self.guildApplyTemplatePool:ShowTemplates({Datas = l_applyList})
        l_reverse = false
    end
    --修改当前的排序类型
    l_curSortIndex = sortTypeIndex
end

--反转当前排序
--sortTypeIndex  排序类型索引 
--isClickSort  是否是点击排序 用于判断是否修改l_reverse
function GuildApplyCtrl:SortReverseOrder(sortTypeIndex, isClickSort)
    --取反序列
    l_applyList = l_guildData.ReverseMemberList(l_applyList)
    --排序标志翻转
    local l_scaleX = self.panel.SortIcon[sortTypeIndex].Transform.transform.localScale.x
    MLuaCommonHelper.SetLocalScaleX(self.panel.SortIcon[sortTypeIndex].UObj, l_scaleX * -1)
    --列表展示
    self.guildApplyTemplatePool:ShowTemplates({Datas = l_applyList})
    --倒序标志设置
    if isClickSort then
        l_reverse = not l_reverse
    end
end

--lua custom scripts end
