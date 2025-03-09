--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuideDescribePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuideDescribeCtrl = class("GuideDescribeCtrl", super)
--lua class define end

--lua functions
function GuideDescribeCtrl:ctor()

    super.ctor(self, CtrlNames.GuideDescribe, UILayer.Guiding, nil, ActiveType.Standalone)

end --func end
--next--
function GuideDescribeCtrl:Init()

    self.panel = UI.GuideDescribePanel.Bind(self)
    super.Init(self)

    self.stepInfo = nil  --对应的新手引导步骤信息
    self.guideNpcSpine = nil --NPC的Spine动画
    self.dragTweenId = 0 --拖拽动画索引

    self.parentPanelName=nil
    self.customSortingOrder = nil

    self.stepId = 0  --步骤Id
    self.isNeedClose = true  --点击后是否需要关闭
    self.isClick = false --是否点击

    self.mask=self:NewPanelMask(BlockColor.Transparent,nil,function()
        --因为加了延时展示功能 所有展示至少1帧延迟 加判断防止连点
        if not self.isClick then
            self.isClick = true
            if MgrMgr:GetMgr("BeginnerGuideMgr").OnOneGuideOver(false, self.stepId, self.parentPanelName, self.customSortingOrder) or self.isNeedClose then
                UIMgr:DeActiveUI(UI.CtrlNames.GuideDescribe)
            end
        end
    end)


end --func end
--next--
function GuideDescribeCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuideDescribeCtrl:OnActive()

    
end --func end
--next--
function GuideDescribeCtrl:OnDeActive()

    if self.guideNpcSpine then
        self:UninitTemplate(self.guideNpcSpine)
        self.guideNpcSpine = nil
    end

    if self.dragTweenId > 0 then
        MUITweenHelper.KillTween(self.dragTweenId, false)
        self.dragTweenId = 0
    end
    self.dragTweenFun = nil

    self.stepInfo = nil
    self.panel.NoNpcArrowPart.UObj:SetActiveEx(false)
    self.panel.NpcArrowPart.UObj:SetActiveEx(false)
    self.panel.DragArrow.UObj:SetActive(false)
    --如果不是玩家自己点击关闭 则强制停止
    if not self.isClick then
        MgrMgr:GetMgr("BeginnerGuideMgr").OnOneGuideOver(true)
    end

    self.parentPanelName = nil
    self.customSortingOrder = nil

end --func end

-- 显示
function GuideDescribeCtrl:OnShow()
    
    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("BeginnerGuideData").EUIOpenType.GuideDescribeShow then
            --自定义层级设置
            self.customSortingOrder = self.uiPanelData.CustomSortingOrder
            self:SetOverrideSortLayer(self.customSortingOrder)
            --内容展示
            self:GuideDescribeShow(self.uiPanelData.stepInfo, self.uiPanelData.isNeedClose)
        end
        self.parentPanelName = self.uiPanelData.ParentPanelName
    end

end

-- 隐藏
function GuideDescribeCtrl:OnHide()

    self.panel.AttrTipBorder.UObj:SetActive(false)
    self.panel.NoNpcArrowPart.UObj:SetActive(false)
    self.panel.NpcArrowPart.UObj:SetActive(false)
    self.panel.EffectPart.UObj:SetActive(false)
    
end



--next--
function GuideDescribeCtrl:Update()


end --func end



--next--
function GuideDescribeCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function GuideDescribeCtrl:GuideDescribeShow(stepInfo, isNeedClose)
    self:SetContentAndPos(stepInfo, isNeedClose)
    if stepInfo.dragData[0] == 1 then
        self:SetDragGuide(stepInfo.dragData)
    end
end


--设置讲解的内容和坐标
function GuideDescribeCtrl:SetContentAndPos(stepInfo, isNeedClose)

    --记录是否显示属性框
    self.stepInfo = stepInfo

    self.isClick = false
    self.stepId = stepInfo.ID
    self.isNeedClose = isNeedClose

    --设置卡普拉与描述的展示类型
    if (not stepInfo.NpcShowModel) or stepInfo.NpcShowModel < 0 then
        --既不展示卡普拉 也不展示文字
        self.panel.NoNpcArrowPart.UObj:SetActiveEx(false)
        self.panel.NpcArrowPart.UObj:SetActiveEx(false)
    else
        --卡普拉与描述的展示
        self:SetDescription(stepInfo.NpcShowModel, stepInfo.UIText, stepInfo.UIOffset, stepInfo.arrowType)
    end
    
    --设置属性标识框
    self:SetAttrTip(stepInfo.AttrTip)

    --特效展示
    self:SetEffect(stepInfo.EffectData)

end

--设置卡普拉描述
function GuideDescribeCtrl:SetDescription(npcShowModel, content, posInfo, arrowType)
    local l_showArrowPart = nil
    local l_guideLab = nil
    local l_arrows = nil
    --区分展示模式
    if npcShowModel == 0 then
        --不展示卡普拉时
        l_showArrowPart = self.panel.NoNpcArrowPart
        self.panel.NoNpcArrowPart.UObj:SetActiveEx(true)
        self.panel.NpcArrowPart.UObj:SetActiveEx(false)
        --文本框选择
        l_guideLab = self.panel.InfoText
        --箭头组选择
        l_arrows = self.panel.Arrow
        --spine动画清理
        if self.guideNpcSpine then
            self:UninitTemplate(self.guideNpcSpine)
            self.guideNpcSpine = nil
        end
    else
        --展示卡普拉模式 1左边 2右边
        l_showArrowPart = self.panel.NpcArrowPart
        self.panel.NoNpcArrowPart.UObj:SetActiveEx(false)
        self.panel.NpcArrowPart.UObj:SetActiveEx(true)
        --文本框选择
        l_guideLab = self.panel.TalkText
        --箭头组选择
        l_arrows = self.panel.NpcArrow
        --人物头像位置
        if npcShowModel == 1 then
            --人像在左
            MLuaCommonHelper.SetLocalPosX(self.panel.NpcHead.UObj, -160)
            MLuaCommonHelper.SetLocalPosX(self.panel.NpcNameBox.UObj, -2)
            MLuaCommonHelper.SetLocalScaleX(self.panel.NpcHead.UObj, 1)
            MLuaCommonHelper.SetLocalScaleX(self.panel.NpcTalkBg.UObj, 1)
            MLuaCommonHelper.SetLocalScaleX(self.panel.TalkText.UObj, 1)
            MLuaCommonHelper.SetLocalScaleX(self.panel.NpcNameBox.UObj, 1)
            MLuaCommonHelper.SetLocalScaleX(self.panel.NpcArrowGroup.UObj, 1)
        else
            --人像在右
            MLuaCommonHelper.SetLocalPosX(self.panel.NpcHead.UObj, 160)
            MLuaCommonHelper.SetLocalPosX(self.panel.NpcNameBox.UObj, 30)
            MLuaCommonHelper.SetLocalScaleX(self.panel.NpcHead.UObj, -1)
            MLuaCommonHelper.SetLocalScaleX(self.panel.NpcTalkBg.UObj, -1)
            MLuaCommonHelper.SetLocalScaleX(self.panel.TalkText.UObj, -1)
            MLuaCommonHelper.SetLocalScaleX(self.panel.NpcNameBox.UObj, -1)
            MLuaCommonHelper.SetLocalScaleX(self.panel.NpcArrowGroup.UObj, -1)
        end
        --Npc的Spine动画设置
        local l_layer = 0
        if self.customSortingOrder then
            l_layer = self.customSortingOrder + 1
        else
            local l_groupContainerType=UIMgr:GetGroupContainerTypeAccordingToActivePanelName(self:GetPanelName())
            if l_groupContainerType == nil then
                l_groupContainerType = self.GroupContainerType
            end
            l_layer = UI.UILayerSort[l_groupContainerType] + 1
        end
        --不存在则创建
        if not self.guideNpcSpine then
            self.guideNpcSpine = self:NewTemplate("GuideSpineTemplate", { 
                IsActive = true,
                TemplateParent = self.panel.NpcSpineSlot.Transform
            })
            --异步加载后位置设置
            self.guideNpcSpine:AddLoadCallback(function()
                MLuaCommonHelper.SetLocalPos(self.guideNpcSpine:gameObject(),
                15.4, -96, 0)
            end)
        end
        --层级设置
        self.guideNpcSpine:SetData({
            layer = l_layer,
        })
        --动画的前置遮罩层级设置
        local l_zhezhao = self.panel.Img_Zhezhao.UObj:GetComponent("Canvas")
        if l_zhezhao then
            l_zhezhao.sortingOrder = l_layer + 1
        end
    end
    --位置设置
    MLuaCommonHelper.SetRectTransformPos(l_showArrowPart.UObj, posInfo[1], posInfo[2])
    self:SetArchors(l_showArrowPart, posInfo[0])
    --文本赋值
    l_guideLab.LabText = content
    --箭头初始化
    for i = 1, 6 do
        self.panel.Arrow[i].UObj:SetActiveEx(false)
        self.panel.NpcArrow[i].UObj:SetActiveEx(false)
    end
    --箭头展示
    if arrowType and arrowType ~= 0 then
        if arrowType > 6 or arrowType < 0 then
            logError("arrowType is error @阿黛尔 arrowType = "..tostring(arrowType))
            return
        end
        l_arrows[arrowType].UObj:SetActiveEx(true)
        MLuaClientHelper.PlayFxHelper(l_arrows[arrowType].UObj)
    end
end

--设置属性标识框
function GuideDescribeCtrl:SetAttrTip(attrTip)
    if attrTip ~= 0 then
        self.panel.AttrTipBorder.UObj:SetActiveEx(true)
        for i = 1, 3 do
            self.panel.AttrTip[i].UObj:SetActiveEx(i == attrTip)
        end
    else
        self.panel.AttrTipBorder.UObj:SetActiveEx(false)
    end
end

--特效设置
function GuideDescribeCtrl:SetEffect(effectData, parentTrans)
    if effectData[0] ~= 0 then
        self.panel.EffectPart.UObj:SetActiveEx(true)
        --获取 X Y W H S
        local l_posX = effectData[1]
        local l_posY = effectData[2]
        local l_width = effectData[3]
        local l_height = effectData[4]
        local l_scale = effectData[5]
        --设置位置 缩放
        MLuaCommonHelper.SetRectTransformPos(self.panel.EffectPart.UObj, l_posX, l_posY)
        MLuaCommonHelper.SetLocalScale(self.panel.EffectPart.UObj, l_scale, l_scale, 1)
        --判断是否需要自适应父节点的宽高
        if l_width == -1 or l_height == -1 then
            local l_parentSize
            if parentTrans then
                local l_rect = parentTrans:GetComponent("RectTransform")
                if l_rect then
                    l_parentSize = l_rect.sizeDelta
                end
            end
            if l_width == -1 then l_width = l_parentSize and l_parentSize.x or 0 end
            if l_height == -1 then l_height = l_parentSize and l_parentSize.y or 0 end
        end
        --特效选择与展示
        for i = 1, #self.panel.Effect do
            if i == effectData[0] then
                self.curShowEffectObj = self.panel.Effect[i].UObj
                self.curShowEffectObj:SetActiveEx(true)
                MLuaCommonHelper.SetRectTransformSize(self.curShowEffectObj, l_width, l_height)
                MLuaClientHelper.PlayFxHelper(self.curShowEffectObj)
            else
                self.panel.Effect[i].UObj:SetActiveEx(false)
            end
        end
    else
        self.panel.EffectPart.UObj:SetActiveEx(false)
    end
end

--设置锚点
--ArchorsType    1左上 2上 3又上 4左 5中间 6右 7左下 8下 9右下
function GuideDescribeCtrl:SetArchors(showArrow, ArchorsType)
    local l_rect = showArrow.RectTransform
    local l_x, l_y = 0.5, 0.5
    
    if ArchorsType == 1 then
        l_x, l_y = 0, 1
    elseif ArchorsType == 2 then
        l_x, l_y = 0.5, 1
    elseif ArchorsType == 3 then
        l_x, l_y = 1, 1
    elseif ArchorsType == 4 then
        l_x, l_y = 0, 0.5
    elseif ArchorsType == 5 then
        --默认值
    elseif ArchorsType == 6 then
        l_x, l_y = 1, 0.5
    elseif ArchorsType == 7 then
        l_x, l_y = 0, 0
    elseif ArchorsType == 8 then
        l_x, l_y = 0.5, 0
    elseif ArchorsType == 9 then
        l_x, l_y = 1, 0
    end
    l_rect.anchorMin = Vector2.New(l_x, l_y)
    l_rect.anchorMax = Vector2.New(l_x, l_y)
end

--拖拽箭头展示设置
function GuideDescribeCtrl:SetDragGuide(dragData)
    --参数获取
    local l_startPosX = dragData[1]
    local l_startPosY = dragData[2]
    local l_endPosX = dragData[3]
    local l_endPosY = dragData[4]
    --展示拖拽箭头
    self.panel.DragArrow.UObj:SetActive(true)
    MLuaCommonHelper.SetRectTransformPos(self.panel.DragArrow.UObj, l_startPosX, l_startPosY)
    --角度设置 距离获取
    local l_initDirection = Vector2.New(0, 1)
    local l_startPos = Vector2.New(l_startPosX, l_startPosY)
    local l_endPos = Vector2.New(l_endPosX, l_endPosY)
    local l_distance = MLuaCommonHelper.GetDistance2D(l_startPos, l_endPos)
    local l_angle = MLuaCommonHelper.GetAngle2D(l_initDirection, l_endPos - l_startPos)
    l_angle = l_endPosX > l_startPosX and -l_angle or l_angle
    MLuaCommonHelper.SetLocalRotEulerZ(self.panel.DragArrow.UObj, l_angle)
    --动画设置
    self.dragTweenFun = function()
            if self.panel.DragArrow.UObj.activeSelf then
                self.dragTweenId = MUITweenHelper.TweenRectTrans(self.panel.DragArrow.UObj,
                    90, 90, 100, l_distance, 1.25, function ()
                        if self.dragTweenFun then
                            self.dragTweenFun()
                        end
                    end)
            end
        end
    self.dragTweenFun()
end


--lua custom scripts end
