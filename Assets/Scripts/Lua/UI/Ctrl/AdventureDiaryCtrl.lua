--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AdventureDiaryPanel"
require "UI/Template/AdventureSectionItemTemplate"
require "UI/Template/AdventureMissionItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl

local l_adventureMgr = nil
local l_adventureData = nil
--next--
--lua fields end

--lua class define
AdventureDiaryCtrl = class("AdventureDiaryCtrl", super)
--lua class define end

--lua functions
function AdventureDiaryCtrl:ctor()
    
    super.ctor(self, CtrlNames.AdventureDiary, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true
    
end --func end
--next--
function AdventureDiaryCtrl:Init()

    self.panel = UI.AdventureDiaryPanel.Bind(self)
    super.Init(self)

    l_adventureData = DataMgr:GetData("AdventureDiaryData")
    l_adventureMgr = MgrMgr:GetMgr("AdventureDiaryMgr")

    --冒险日记章节项的池创建
    self.adventureSectionTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AdventureSectionItemTemplate,
        TemplatePrefab = self.panel.AdventureSectionItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.SectionView.LoopScroll
    })
    --self.adventureSectionTemplatePool:SetDragEndCallBack(function()
    --    self:SectionScrollTipArrowControl()
    --end)
    self.panel.SectionView.LoopScroll:SetOnValueChangedMethod(function(value)
        self:SectionScrollTipArrowControl()
    end)
    --冒险日记子任务项的池创建
    self.adventureMissionTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AdventureMissionItemTemplate,
        TemplatePrefab = self.panel.AdventureMissionItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.MissionView.LoopScroll
    })
    --拖拽后回调
    self.adventureMissionTemplatePool:SetDragEndCallBack(function()
            self:MissionScrollTipArrowControl()
        end)
    --设置箭头点击事件
    self.panel.MissionView:SetLoopScrollGameObjListener(self.panel.BtnPre.gameObject, self.panel.BtnNext.gameObject, nil, nil)

    local l_handleAwardBtnClicked = function()
        if l_adventureData.GetIsChapterAwardGeted() then
        --已领取
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AWARD_IS_ALREADY_GET"))
        else
        --未领取
        UIMgr:ActiveUI(UI.CtrlNames.AdventureChapterAward)
        end
    end

    --章节奖励宝箱按钮
    self.panel.BtnAward:AddClick(l_handleAwardBtnClicked)
    self.panel.AwardPart:AddClick(l_handleAwardBtnClicked)
    --退出按钮
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiary)
    end)

    --cbt2 临时修改 关闭总奖励领取
    self.panel.AwardPart.UObj:SetActiveEx(false)

end --func end
--next--
function AdventureDiaryCtrl:Uninit()

    self.adventureSectionTemplatePool = nil
    self.adventureMissionTemplatePool = nil

    if l_adventureData then
        l_adventureData.ReleaseAdventureData()
        l_adventureData = nil
    end
    l_adventureMgr = nil
    
    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function AdventureDiaryCtrl:OnActive()
    --打开类型判断
    local l_aimSectionIndex = nil  --指定章节索引
    local l_aimMissionIndex = nil  --指定任务索引
    if self.uiPanelData then
        if self.uiPanelData.type == l_adventureData.EUIOpenType.AdventureDiaryByAimIndex then
            l_aimSectionIndex = self.uiPanelData.aimSectionIndex
            l_aimMissionIndex = self.uiPanelData.aimMissionIndex
        end
    end
    
    --更新冒险日记数据
    l_adventureData.UpdateAdventureData()

    --章节奖励宝箱状态
    self.panel.AwardProcess.Slider.value = l_adventureData.chapterAwardIdFinishCount / l_adventureData.chapterAwardIdCount
    self.panel.AwardProcessText.LabText = l_adventureData.chapterAwardIdFinishCount.."/"..l_adventureData.chapterAwardIdCount
    if l_adventureData.GetIsChapterAwardGeted() then
        --已领取
        self.panel.IsCanTake.UObj:SetActiveEx(false)
    elseif l_adventureData.chapterAwardIdFinishCount < l_adventureData.chapterAwardIdCount then
        --未完成
        self.panel.IsCanTake.UObj:SetActiveEx(false)
    else
        --已完成
        self.panel.IsCanTake.UObj:SetActiveEx(true)
    end

    --展示冒险日记章节数据
    self.adventureSectionTemplatePool:ShowTemplates({Datas = l_adventureData.adventureDiaryInfo,
        Method = function(item, showIndex)
            self.adventureSectionTemplatePool:SelectTemplate(item.ShowIndex)
            self:SelectOneSection(item.data)
        end})

    if not l_aimSectionIndex then
        --如果没有指定任务ID则走默认规则
        --默认选中列表中第一个【已解锁】且【未全部完成】的页签，如果所有已解锁的页签，目标已经全部完成，则选中【已解锁】且【ID】最大的页签
        for i = 1, #l_adventureData.adventureDiaryInfo do
            local l_sectionInfo = l_adventureData.adventureDiaryInfo[i]
            if l_sectionInfo.isUnlock then
                l_aimSectionIndex = i
                if not l_adventureData.CheckSectionCanGetAward(l_sectionInfo) then break end
            else 
                break
            end
        end
    end
    l_aimSectionIndex = l_aimSectionIndex or 1  --容错
    
    --默认选中的页签显示展示
    self.adventureSectionTemplatePool:SelectTemplate(l_aimSectionIndex)
    self:SelectOneSection(l_adventureData.adventureDiaryInfo[l_aimSectionIndex], l_aimMissionIndex)

    --强制刷新content大小
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.SectionView.LoopScroll.content.transform)
    --箭头控制
    self:SectionScrollTipArrowControl()

end --func end
--next--
function AdventureDiaryCtrl:OnDeActive()
    --关闭的时候更新红点
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.AdventureDiary)
    
end --func end
--next--
function AdventureDiaryCtrl:Update()
    
    
end --func end

--next--
function AdventureDiaryCtrl:BindEvents()
    --获取冒险日记最终总章节奖励后的事件
    self:BindEvent(l_adventureMgr.EventDispatcher,l_adventureMgr.ON_GET_ADVENTURE_DIARY_FINAL_AWARD,function(self)
        --修改宝箱的图标
        self.panel.IsCanTake.UObj:SetActiveEx(false)
    end)
    --获取冒险日记单个子任务或小章节奖励后的事件
    self:BindEvent(l_adventureMgr.EventDispatcher, l_adventureMgr.ON_GET_ADVENTURE_DIARY_AWARD,function(self)
        self.adventureSectionTemplatePool:RefreshCells()
        self.adventureMissionTemplatePool:RefreshCells()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
--选中某一章节
--sectionData  章节数据
function AdventureDiaryCtrl:SelectOneSection(sectionData, aimMissionIndex)
    --展示冒险日记子任务数据
    self.adventureMissionTemplatePool:ShowTemplates({Datas = sectionData.missionInfos})

    if aimMissionIndex then
        --存在指定任务索引则滑动到指定位置
        self.adventureMissionTemplatePool:ScrollToCell(aimMissionIndex, 2000)
    else
        --无指定任务索引则滑动第一个有红点的页签
        for i, data in ipairs(sectionData.missionInfos) do
            if data.isFinish and not data.isGetAward then
                self.adventureMissionTemplatePool:ScrollToCell(i, 2000)
                break
            end
        end
    end

    local l_timer = self:NewUITimer(function()
        --左右箭头显示控制 需要等一帧 列表加载完
        self:MissionScrollTipArrowControl()
    end, 0)
    l_timer:Start()
end
--章节列表拖拽上下提示箭头控制
function AdventureDiaryCtrl:SectionScrollTipArrowControl()
    if not self.adventureSectionTemplatePool then
        return
    end

    self.panel.SectionTipUp.UObj:SetActiveEx(false)
    self.panel.SectionTipDown.UObj:SetActiveEx(false)
    if self.panel.SectionView.LoopScroll.content.rect.height > self.panel.SectionView.LoopScroll.viewport.rect.height then
        local l_verticalNormalizedPosition = self.panel.SectionView.LoopScroll:GetNormalizedPosition()
        --logError("l_verticalNormalizedPosition: " .. l_verticalNormalizedPosition)
        --值没有完全归0或者1，会有误差
        if l_verticalNormalizedPosition > 0.01 then
            self.panel.SectionTipUp.UObj:SetActiveEx(true)
            MLuaClientHelper.PlayFxHelper(self.panel.SectionTipUp.UObj)
        end
        if l_verticalNormalizedPosition < 0.99 then
            self.panel.SectionTipDown.UObj:SetActiveEx(true)
            MLuaClientHelper.PlayFxHelper(self.panel.SectionTipDown.UObj)
        end
    end
end

--章节列表拖拽上下提示箭头控制
function AdventureDiaryCtrl:MissionScrollTipArrowControl()
    
    if not self.adventureSectionTemplatePool then
        return
    end
    
    if self.panel.MissionView.LoopScroll.content.rect.width 
        > self.panel.MissionView.LoopScroll.viewport.rect.width then

        local l_horizontalNormalizedPosition = self.panel.MissionView.LoopScroll:GetNormalizedPosition()
        
        --值没有完全归0或者1，会有误差
        if l_horizontalNormalizedPosition > 0.05 then
            self.panel.BtnPre.UObj:SetActiveEx(true)
        else
            self.panel.BtnPre.UObj:SetActiveEx(false)
        end

        if l_horizontalNormalizedPosition < 0.95 then
            self.panel.BtnNext.UObj:SetActiveEx(true)
        else
            self.panel.BtnNext.UObj:SetActiveEx(false)
        end
    else
        self.panel.BtnPre.UObj:SetActiveEx(false)
        self.panel.BtnNext.UObj:SetActiveEx(false)
    end


end
--lua custom scripts end
return AdventureDiaryCtrl