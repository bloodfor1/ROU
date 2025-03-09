--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MazeEnterPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_mazeMgr = nil  
local l_teamTargetId = 8000  --在组队目标表中的ID   TeamTargetTable
--next--
--lua fields end

--lua class define
MazeEnterCtrl = class("MazeEnterCtrl", super)
--lua class define end

--lua functions
function MazeEnterCtrl:ctor()
    
    super.ctor(self, CtrlNames.MazeEnter, UILayer.Function, nil, ActiveType.Exclusive)
    
end --func end
--next--
function MazeEnterCtrl:Init()
    
    self.panel = UI.MazeEnterPanel.Bind(self)
    super.Init(self)

    l_mazeMgr = MgrMgr:GetMgr("MazeDungeonMgr")  

    --获取迷宫副本在委托活动表的具体数据
    local l_entrustRow = TableUtil.GetEntrustActivitiesTable().GetRow(GameEnum.Delegate.activity_Maze)
    if not l_entrustRow then
        logError("迷宫在委托表的ID 有误请检查")
        return
    end

    --副本数据获取
    local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_entrustRow.DungeonID)
    if not l_dungeonRow then
        logError("迷宫的副本ID配置错误 DungeonID = "..tostring(l_entrustRow.DungeonID))
        return
    end

    --副本描述
    self.panel.Describe.LabText = Lang("MAZE_DUNGEON_DESCRIBE")
    --参与等级
    local l_levelLimit = l_dungeonRow.LevelLimit
    local l_minLevel = l_levelLimit:get_Item(0)
    self.panel.LvTxt.LabText = "Lv."..l_minLevel
    --活动消耗
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_entrustRow.Cost[0][0])
    if not l_itemRow then
        logError("迷宫的副本活动消耗ID配置错误 ID = "..tostring(l_entrustRow.Cost[0][0]))
        return
    end
    self.panel.CostIcon:SetSprite(l_itemRow.ItemAtlas, l_itemRow.ItemIcon)
    self.panel.CostTxt.LabText = l_entrustRow.Cost[0][1]
    --参与人数
    local l_numLimit = l_dungeonRow.NumbersLimit
    self.panel.MemberTxt.LabText = StringEx.Format(Lang("RECOMMEND_MEMBER_NUM"), l_numLimit[0], l_numLimit[1])
    --奖励次数
    local finishTime, maxTime = MgrMgr:GetMgr("DelegateModuleMgr").GetDelegateTimesInfo(GameEnum.Delegate.activity_Maze)
    self.panel.AwardCountTxt.LabText = StringEx.Format("{0}/{1}", finishTime, maxTime)
    
    --奖励列表项的池创建
    self.awardTemplatePool=self:NewTemplatePool({
        UITemplateClass=UITemplate.ItemTemplate,
        ScrollRect=self.panel.AwardView.LoopScroll
    })

    --奖励预览请求
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_entrustRow.RewardID)

    --关闭按钮
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.MazeEnter)
    end)
    --快速组队按钮
    self.panel.BtnTeam:AddClick(function()
        if DataMgr:GetData("TeamData").myTeamInfo.isInTeam then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_HAVE_A_TEAM"))
        else
            UIMgr:ActiveUI(UI.CtrlNames.TeamSearch, function(ctrl)
                ctrl:SetTeamTargetPre(l_teamTargetId)
            end)
        end
    end)
    --开始试炼按钮
    self.panel.BtnStart:AddClick(function()
        MgrMgr:GetMgr("DelegateModuleMgr").EnterDungeonAccordDelegate(GameEnum.Delegate.activity_Maze, function()
            MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_entrustRow.DungeonID, 0, 0)
        end)
    end)

end --func end
--next--
function MazeEnterCtrl:Uninit()
    
    --奖励列表池释放
    self.awardTemplatePool = nil
    l_mazeMgr = nil  
    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function MazeEnterCtrl:OnActive()
    
    
end --func end
--next--
function MazeEnterCtrl:OnDeActive()
    
    
end --func end
--next--
function MazeEnterCtrl:Update()
    
    
end --func end

--next--
function MazeEnterCtrl:BindEvents()
    --奖励预览回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,function(object, ...)
        self:RefreshPreviewAwards(...)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--奖励预览显示
function MazeEnterCtrl:RefreshPreviewAwards(...)

    local l_awardPreviewRes = ...
    local l_awardList = l_awardPreviewRes and l_awardPreviewRes.award_list
    local l_previewCount = l_awardPreviewRes.preview_count == -1 and #l_awardList or l_awardPreviewRes.preview_count
    local l_previewnum = l_awardPreviewRes.preview_num
    if l_awardList then
        local l_rewardDatas={}
        for i, v in ipairs(l_awardList) do
            table.insert(l_rewardDatas, {ID = v.item_id, Count = v.count, IsShowCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(l_previewnum, v.count)})
            if i >= l_previewCount then break end
        end
        --奖励显示
        self.awardTemplatePool:ShowTemplates({Datas = l_rewardDatas})
    end

end
--lua custom scripts end
