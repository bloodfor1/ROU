--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/QTEGuidePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_skillSlot = nil --技能槽

--next--
--lua fields end

--lua class define
QTEGuideCtrl = class("QTEGuideCtrl", super)
--lua class define end

--lua functions
function QTEGuideCtrl:ctor()

    super.ctor(self, CtrlNames.QTEGuide, UILayer.Guiding, nil, ActiveType.Standalone)

end --func end
--next--
function QTEGuideCtrl:Init()

    self.panel = UI.QTEGuidePanel.Bind(self)
    super.Init(self)

    self.timer = nil  --计时器
    self.duration = -1 --持续时间

end --func end
--next--
function QTEGuideCtrl:Uninit()


    if l_skillSlot ~= nil then
        MResLoader:DestroyObj(l_skillSlot)
        l_skillSlot = nil
    end

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    self.duration = -1

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function QTEGuideCtrl:OnActive()


end --func end
--next--
function QTEGuideCtrl:OnDeActive()

    --QTE是强指引 所以在关闭的时候再开启切换按钮
    MgrMgr:GetMgr("MainUIMgr").IsSwitchUILock = false

end --func end
--next--
function QTEGuideCtrl:Update()


end --func end




--next--
function QTEGuideCtrl:OnHide()

    

end --func end
--next--
function QTEGuideCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function QTEGuideCtrl:SetSkillGuide(slotGameObj, guideTableDate)

    --必要组件与参数获取
    local l_image = slotGameObj:GetComponent("Image")
    local l_size = slotGameObj:GetComponent("RectTransform").sizeDelta
    local l_skillInfo = TableUtil.GetSkillTable().GetRowById(guideTableDate.SkillId)
    local l_showSkillInfo = guideTableDate.ShowSkillId ~= 0 and TableUtil.GetSkillTable().GetRowById(guideTableDate.ShowSkillId) or nil
    if not l_skillInfo then return end
    --设置根节点位置
    self.panel.Root.Transform:SetPosToOther(slotGameObj)

    --遮罩设置
    if guideTableDate.BlockSet[0] then
        local l_maskColor=guideTableDate.BlockSet[1] and BlockColor.Transparent or BlockColor.Dark

        self.mask=self:NewPanelMask(l_maskColor)

        --self:SetBlockOpt(l_maskColor)
    end
    --介绍面板设置
    self:SetIntroduction(guideTableDate)
    --图片和大小设置
    if l_showSkillInfo then  --如果配置了展示技能id 则用展示技能的图标
        self.panel.ShowImage:SetSprite(l_showSkillInfo.Atlas, l_showSkillInfo.Icon)
    else  --如果没有展示技能的数据 则用指定的技能的图标
        self.panel.ShowImage:SetSprite(l_skillInfo.Atlas, l_skillInfo.Icon)
    end
    self.panel.ShowImage.Img.color = l_image.color
    self.panel.ShowImage.UObj:SetActiveEx(true)
    self.panel.ShowImage.UObj:SetRectTransformSize(l_size.x, l_size.y)
    self.panel.EventButton.UObj:SetRectTransformSize(l_size.x, l_size.y)
    self.panel.EventButton.UObj:SetLocalScale(0.9, 0.9, 0.9)  --技能按钮都是这个缩放
    self.panel.EventButton.UObj:SetActiveEx(true)
    --点击效果设置
    self.panel.EventButton.Listener.onClick = function(uobj, event)
        MLuaClientHelper.ExecutePointUpDownEventsByGameObject(slotGameObj)
        self:FuncAfterClick(guideTableDate.FunctionType)
    end
    --特效设置
    self:SetEffect(guideTableDate.EffectData, l_size)
    
    --自动关闭计时器设置
    self:SetTimer(guideTableDate.Duration)
end

--设置说明面板
function QTEGuideCtrl:SetIntroduction(guideTableDate)
    if guideTableDate.IntroductionSet[0] == 1 then
        --展示介绍面板
        self.panel.IntroductionPart.UObj:SetActiveEx(true)
        MLuaCommonHelper.SetRectTransformPos(self.panel.IntroductionPart.UObj, 
            guideTableDate.IntroductionSet[1], guideTableDate.IntroductionSet[2])
        self.panel.IntroductionText.LabText = guideTableDate.IntroductionText
        --箭头控制
        for i = 1, #self.panel.Arrow do
            self.panel.Arrow[i].UObj:SetActiveEx(false)
        end
        if guideTableDate.IntroductionSet[3] ~= 0 then
            self.panel.Arrow[guideTableDate.IntroductionSet[3]].UObj:SetActiveEx(true)
            MLuaClientHelper.PlayFxHelper(self.panel.Arrow[guideTableDate.IntroductionSet[3]].UObj)
        end
    else
        self.panel.IntroductionPart.UObj:SetActiveEx(false)
    end
end

--特效设置
function QTEGuideCtrl:SetEffect(effectData, fitSize)
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
            if l_width == -1 then l_width = fitSize and fitSize.x or 0 end
            if l_height == -1 then l_height = fitSize and fitSize.y or 0 end
        end
        --特效选择与展示
        for i = 1, #self.panel.Effect do
            if i == effectData[0] then
                local l_showEffectObj = self.panel.Effect[i].UObj
                l_showEffectObj:SetActiveEx(true)
                MLuaCommonHelper.SetRectTransformSize(l_showEffectObj, l_width, l_height)
                MLuaClientHelper.PlayFxHelper(l_showEffectObj)
            else
                self.panel.Effect[i].UObj:SetActiveEx(false)
            end
        end
    else
        self.panel.EffectPart.UObj:SetActiveEx(false)
    end
end

--定时关闭计时器设置
function QTEGuideCtrl:SetTimer(duration)
    --自动关闭计时器设置
    self.duration = duration
    -- -1表示永久显示
    if self.duration == -1 then
        if self.timer then
            self:StopUITimer(self.timer)
            self.timer = nil
        end
    elseif not self.timer then  --不是-1则设置计时器
        self.timer = self:NewUITimer(function()
            self.duration = self.duration - 1
            if self.duration <= 0 then
                --检查并关闭定时器
                if self.timer then
                    self:StopUITimer(self.timer)
                    self.timer = nil
                end
                --关闭界面
                UIMgr:DeActiveUI(UI.CtrlNames.QTEGuide)
            end
        end, 1, -1, true)
        self.timer:Start()
    end
end

--点击后事件
--funcType  事件类型 0关闭 1记录连点
function QTEGuideCtrl:FuncAfterClick(funcType)
    if funcType == 0 then
        UIMgr:DeActiveUI(UI.CtrlNames.QTEGuide)
    end
end
--lua custom scripts end
