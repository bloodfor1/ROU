--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BoliIllustrationPanel"
require "UI/Template/BoliSelectItemTemplate"
require "UI/Template/BoliFindRecordItemTemplate"
require "UI/Template/BoliAchieveRewardItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl

local l_boliModel = nil  --波利的模型
local l_curAchievementId = nil  --当前的成就ID（点击前往成就按钮打开的成就）
local l_boliFindAchievementList = nil  --发现波利成就的信息列表
local l_achievementAwardIds = nil   --成就组对应的奖励预览ID表
--next--
--lua fields end

--lua class define
BoliIllustrationCtrl = class("BoliIllustrationCtrl", super)
--lua class define end

--lua functions
function BoliIllustrationCtrl:ctor()
    
    super.ctor(self, CtrlNames.BoliIllustration, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true
    
end --func end
--next--
function BoliIllustrationCtrl:Init()
    
    self.panel = UI.BoliIllustrationPanel.Bind(self)
    super.Init(self)


    --关闭按钮
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.BoliIllustration)
    end)
    --玩法说明
    self.panel.BtnInfo:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
            ctrl:ShowPanel(MGlobalConfig:GetInt("ElfGameTips"))
        end)
    end)
    --前往成就按钮
    self.panel.BtnAchievement:AddClick(function()
        if l_curAchievementId then
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(l_curAchievementId)
            --UIMgr:DeActiveUI(UI.CtrlNames.BoliIllustration)
        end
    end)

    --波利选择项的池创建
    self.boliSelectTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BoliSelectItemTemplate,
        TemplatePrefab = self.panel.BoliSelectItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.BoliSelectView.LoopScroll
    })
    --波利发现项的池创建
    self.findRecordTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BoliFindRecordItemTemplate,
        TemplatePrefab = self.panel.BoliFindRecordItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.FindRecordView.LoopScroll
    })
    --成就奖励项的池创建
    self.achievementAwardTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BoliAchieveRewardItemTemplate,
        TemplatePrefab = self.panel.BoliAchieveRewardItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.AchievementRewardView.LoopScroll
    })
    
end --func end
--next--
function BoliIllustrationCtrl:Uninit()

    self.boliSelectTemplatePool = nil
    self.findRecordTemplatePool = nil
    self.achievementAwardTemplatePool = nil

    --波利模型销毁
    if l_boliModel ~= nil then
        self:DestroyUIModel(l_boliModel)
        l_boliModel = nil
    end

    l_curAchievementId = nil
    l_boliFindAchievementList = nil
    l_achievementAwardIds = nil

    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function BoliIllustrationCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("BoliGroupData").EUIOpenType.BoliIllustration then
            self:ShowBoliSelectTab(self.uiPanelData.index)
        end
    end

    --新手指引相关 玩法说明关闭后的
    local l_beginnerGuideChecks = {"Elf1", "Elf2"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    
end --func end
--next--
function BoliIllustrationCtrl:OnDeActive()
    
    
end --func end
--next--
function BoliIllustrationCtrl:Update()
    
    
end --func end

--next--
function BoliIllustrationCtrl:BindEvents()
    
    --奖励预览回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,function(object, previewResult, awardIdList)
        self:RefreshPreviewAwards(previewResult, awardIdList)
    end)

    --玩法说明界面关闭回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher,MgrMgr:GetMgr("BeginnerGuideMgr").HOW_TO_PLAY_PANEL_CLOSE,function(object)
        --新手指引相关 玩法说明关闭后的
        local l_beginnerGuideChecks = {"Elf2"}
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end)
    
end --func end
--next--
--lua functions end

--lua custom scripts
--展示boli选择列表
--initShowIndex  初始展示的索引
function BoliIllustrationCtrl:ShowBoliSelectTab(initShowIndex)

    --获取初始展示的数据和索引
    local l_initShowIndex = initShowIndex or 1
    --展示数据
    self.boliSelectTemplatePool:ShowTemplates({Datas = DataMgr:GetData("BoliGroupData").BoliFindDatas,
        StartScrollIndex = l_initShowIndex,
        Method = function(item)
            self:SelectOneBoli(item.data)
        end})
    --默认选中
    self.boliSelectTemplatePool:SelectTemplate(l_initShowIndex)

end

--选中一个波利
function BoliIllustrationCtrl:SelectOneBoli(boliFindData)

    local l_aimBoliData = TableUtil.GetElfTypeTable().GetRowByID(boliFindData.typeId)

    if l_aimBoliData then 
        self:ShowBoliDetail(l_aimBoliData, boliFindData)
    end

end

--展示波利详细界面
function BoliIllustrationCtrl:ShowBoliDetail(boliTypeData, boliFindData)
    
    if boliFindData.findNum > 0 then
        --展示详细介绍部分 关闭未发现
        self.panel.BoliShowPart.UObj:SetActiveEx(true)
        self.panel.BoliFindDetailPart.UObj:SetActiveEx(true)
        self.panel.BoliNotFind.UObj:SetActiveEx(false)

        --名字和描述
        self.panel.BoliDescribe.LabText = boliTypeData.Description
        self.panel.BoliName.LabText = boliTypeData.Name

        --不同波利的背景
        self.panel.BoliBg:SetRawTexAsync(boliTypeData.ShowBG, function()
            self.panel.BoliBg.UObj:SetActiveEx(true)
        end, true)
        
        --原本的波利模型销毁
        if l_boliModel ~= nil then
            self:DestroyUIModel(l_boliModel)
            l_boliModel = nil
            self.panel.BoliView.UObj:SetActiveEx(false)
        end

        --不同波利的模型
        local l_tempId = MUIModelManagerEx:GetTempUID()
        local l_attr = MAttrMgr:InitMonsterAttr(l_tempId, "BoliElf", boliTypeData.EntityID)

        local l_fxData = {}
        l_fxData.rawImage = self.panel.BoliView.RawImg
        l_fxData.attr = l_attr
        l_fxData.defaultAnim = boliTypeData.ShowAnim

        l_boliModel = self:CreateUIModel(l_fxData)
        l_boliModel:AddLoadModelCallback(function(m)
            MLuaCommonHelper.SetRotEuler(m.UObj, 0, 180, 0)
            MLuaCommonHelper.SetLocalScale(m.UObj, 1.35, 1.35, 1.35)
            MLuaCommonHelper.SetLocalPos(m.UObj, 0, 0.3, 0)
            self.panel.BoliView.UObj:SetActiveEx(true)
        end)
        
        --各场景发现情况展示
        self:ShowFindDeatail(boliFindData)
    else
        --关闭波利模型展示界面
        self.panel.BoliShowPart.UObj:SetActiveEx(false)
        --关闭发现记录
        self.panel.FindRecordPart.UObj:SetActiveEx(false)
        --展示未发现照片
        self.panel.BoliNotFind.UObj:SetActiveEx(true)
        --未发现波利的波利介绍
        self.panel.NotFindDescribe.LabText = boliTypeData.Description
        --波利未解锁样式展示
        self.panel.UnlockBoliImg:SetSprite(boliTypeData.Atlas2, boliTypeData.Icon2)
    end
    --成就奖励获取情况
    self:ShowAchievementInfo(boliTypeData, boliFindData)

end

--展示发现的详细信息
function BoliIllustrationCtrl:ShowFindDeatail(boliFindData)

    --展示发现记录界面
    self.panel.FindRecordPart.UObj:SetActiveEx(true)
    --发现数据获取
    local l_findData = {}
    for i = 1, #boliFindData.findList do
        local l_temp = {}
        l_temp.sceneId = boliFindData.findList[i].sceneId
        l_temp.num = boliFindData.findList[i].num
        table.insert(l_findData, l_temp)
    end
    --在最后插入一条无用数据用于显示？？？
    local l_temp = {}
    l_temp.sceneId = -1
    l_temp.num = 0
    table.insert(l_findData, l_temp)
    --展示
    self.findRecordTemplatePool:ShowTemplates({Datas = l_findData})

end

--展示成就相关信息
function BoliIllustrationCtrl:ShowAchievementInfo(boliTypeData, boliFindData)
    
    local l_nextNeedNum = 0   --距离下一阶成就完成还需获取数量重置
    l_curAchievementId = nil  --点击前往的成就ID重置

    --获取对应的成就组信息
    local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")
    local l_achievementGroup = l_achievementMgr.GetAchievementWithGroup(boliTypeData.AchievementID)
    --初始化波利发现成就信息缓存表 和 对应奖励ID组
    l_boliFindAchievementList = {} 
    l_achievementAwardIds = {}
    --遍历成就组获取相关数据
    for i = 1, #l_achievementGroup do
        local l_tempAchievement = l_achievementGroup[i]
        local l_isCanGetAward = l_achievementMgr.IsAchievementCanAward(l_tempAchievement)  --是否可领奖
        local l_isGetAward = l_achievementMgr.IsAchievementAwardedWithId(l_tempAchievement.achievementid)  --是否已领奖
        local l_isLast = i == #l_achievementGroup  --是否是该组最后一个成就
        local l_achievementTableData = l_tempAchievement:GetDetailTableInfo()  --成就表数据
        --波利图鉴界面需要的数据缓存制作
        local l_temp = {
            achievementId = l_achievementTableData.ID,
            needNum = l_achievementTableData.Target[0][1],
            awardId = l_achievementTableData.Award,
            isCanGetAward = l_isCanGetAward,
            isGetAward = l_isGetAward,
            isLast = l_isLast,
            awardDatas = {}
        }
        --数据插入波利发现成就信息缓存表 和 对应奖励ID组
        table.insert(l_boliFindAchievementList, l_temp)
        table.insert(l_achievementAwardIds, l_achievementTableData.Award)
        --找出成就组中第一个未领取奖励的成就 或 最后一个成就 (点击前往成就按钮去的成就)
        if not l_curAchievementId and (not l_isGetAward or l_isLast) then
            l_curAchievementId = l_achievementTableData.ID
        end
        --计算距离下一阶成就完成还需获取数量
        if l_nextNeedNum == 0 and boliFindData.findNum < l_temp.needNum then
            l_nextNeedNum = l_temp.needNum - boliFindData.findNum
        end
    end

    --已探索数量 和 下一阶成就所需数量显示
    self.panel.FindNum.LabText = Lang("ALREADY_FIND_BOLI_NUM", boliFindData.findNum)
    if l_nextNeedNum > 0 then
        self.panel.NextStageNum.LabText = Lang("FIND_BOLI_NEXT_STAGE_NEED", l_nextNeedNum)
        self.panel.NextStageNum.UObj:SetActiveEx(true)
    else
        self.panel.NextStageNum.UObj:SetActiveEx(false)
    end

    --打包请求全部成就的奖励预览
    MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(l_achievementAwardIds)

end

--奖励预览显示
function BoliIllustrationCtrl:RefreshPreviewAwards(previewResult, awardIdList)
    
    --比对奖励id列表 确认是否是有效数据
    if not l_achievementAwardIds or not awardIdList or #l_achievementAwardIds ~= #awardIdList then return end
    for i = 1, #l_achievementAwardIds do
        local l_check = false
        for j = 1, #awardIdList do
            if l_achievementAwardIds[i] == awardIdList[j].value then
                l_check = true
                break
            end
        end
        if not l_check then return end
    end
    
    --解析预览奖励
    for i = 1, #previewResult do
        local l_awardPreviewRes = previewResult[i]
        local l_awardList = l_awardPreviewRes.award_list
        local l_previewCount = l_awardPreviewRes.preview_count == -1 and #l_awardList or l_awardPreviewRes.preview_count
        local l_previewnum = l_awardPreviewRes.preview_num
        if l_awardList then
            --获取对应的成就信息
            for j = 1, #l_boliFindAchievementList do 
                if l_boliFindAchievementList[j].awardId == l_awardPreviewRes.award_id then
                    for k, v in ipairs(l_awardList) do
                        table.insert(l_boliFindAchievementList[j].awardDatas, {ID = v.item_id, Count = v.count, IsShowCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(l_previewnum, v.count)})
                        if k >= l_previewCount then break end
                    end
                end
            end
        end
    end

    --获取初始展示的索引 第一个可领取奖励的位置
    local l_initShowIndex = 1
    for i = 1, #l_boliFindAchievementList do
        if l_boliFindAchievementList[i].isCanGetAward then
            l_initShowIndex = i
            break
        end
    end

    --数据展示
    self.achievementAwardTemplatePool:ShowTemplates({Datas = l_boliFindAchievementList,
        StartScrollIndex = l_initShowIndex,
        Method = function(item)
            local l_data = item.data
            if l_data.isCanGetAward and l_curAchievementId then
                MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(l_curAchievementId)
                UIMgr:DeActiveUI(UI.CtrlNames.BoliIllustration)
            end
        end})

end
--lua custom scripts end
return BoliIllustrationCtrl