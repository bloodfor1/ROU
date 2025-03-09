--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class GuideArrowPointTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalkText MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field NpcTalkBg MoonClient.MLuaUICom
---@field NpcNameText MoonClient.MLuaUICom
---@field NpcNameBox MoonClient.MLuaUICom
---@field NpcHead MoonClient.MLuaUICom
---@field NpcArrowPart MoonClient.MLuaUICom
---@field NpcArrowGroup MoonClient.MLuaUICom
---@field NpcArrow MoonClient.MLuaUICom[]
---@field NpcAnim MoonClient.MLuaUICom
---@field NoNpcArrowPart MoonClient.MLuaUICom
---@field InfoText MoonClient.MLuaUICom
---@field InfoBg MoonClient.MLuaUICom
---@field Img_Zhezhao MoonClient.MLuaUICom
---@field HeadImg MoonClient.MLuaUICom
---@field EffectPart MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom[]
---@field Arrow MoonClient.MLuaUICom[]

---@class GuideArrowPointTemplate : BaseUITemplate
---@field Parameter GuideArrowPointTemplateParameter

GuideArrowPointTemplate = class("GuideArrowPointTemplate", super)
--lua class define end

--lua functions
function GuideArrowPointTemplate:Init()
    
    super.Init(self)
    --当前展示的特效Obj
    self.curShowEffectObj = nil 
    
end --func end
--next--
function GuideArrowPointTemplate:OnDeActive()
    
    self.curShowEffectObj = nil
    
end --func end
--next--
function GuideArrowPointTemplate:OnSetData(data)
    
    -- data.npcShowModel  int  卡普拉展示类型 -1文本相关不显示 0不展示 1在左边 2在右边
    -- data.infoText  string  显示的文本
    -- data.arrowType  int  箭头展示类型 0不展示 1左上 2左 3左下 4右下 5右 6右上
    -- data.effectData  seq[int]  特效相关数据
    -- data.aimCtrl  lua  对应功能的UICtrl
    -- data.parentTrans  transform  父节点trans
    --文字描述显示
    if data.npcShowModel ~= -1 then
        self:SetDescription(data.npcShowModel, data.infoText, data.arrowType, data.aimCtrl)
    else
        self.Parameter.NoNpcArrowPart.UObj:SetActiveEx(false)
        self.Parameter.NpcArrowPart.UObj:SetActiveEx(false)
    end
    --特效展示控制
    self:SetEffect(data.effectData, data.parentTrans)
    
end --func end
--next--
function GuideArrowPointTemplate:OnDestroy()
    
    
end --func end
--next--
function GuideArrowPointTemplate:BindEvents()
    
    
end --func end
--next--
--lua functions end

--lua custom scripts
function GuideArrowPointTemplate:ctor(data)
    if data==nil then
        data={}
    end
    data.TemplatePath = "UI/Prefabs/GuideArrowPoint"
    super.ctor(self,data)
end

function GuideArrowPointTemplate:OnSetVisible(visible)
    self.Parameter.NpcAnim.UObj:SetActiveEx(visible or false)
end

--设置锚点
--ArchorsType    1左上 2上 3又上 4左 5中间 6右 7左下 8下 9右下
function GuideArrowPointTemplate:SetArchors(ArchorsType)

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
    
    self.Parameter.Prefab.UObj:SetRectTransformAnchor(l_x, l_y, l_x, l_y);
end

--设置描述文字
function GuideArrowPointTemplate:SetDescription(npcShowModel, infoText, arrowType, aimCtrl)
    local l_guideLab = nil
    local l_arrows = nil
    --区分展示模式
    if (not npcShowModel) or npcShowModel == 0 then
        --不展示卡普拉时
        self.Parameter.NoNpcArrowPart.UObj:SetActiveEx(true)
        self.Parameter.NpcArrowPart.UObj:SetActiveEx(false)
        --文本框选择
        l_guideLab = self.Parameter.InfoText
        --箭头组选择
        l_arrows = self.Parameter.Arrow
    else
        --展示卡普拉模式
        self.Parameter.NoNpcArrowPart.UObj:SetActiveEx(false)
        self.Parameter.NpcArrowPart.UObj:SetActiveEx(true)
        --文本框选择
        l_guideLab = self.Parameter.TalkText
        --箭头组选择
        l_arrows = self.Parameter.NpcArrow
        --人物头像位置
        if npcShowModel == 1 then
            --人像在左
            MLuaCommonHelper.SetLocalPosX(self.Parameter.NpcHead.UObj, -160)
            MLuaCommonHelper.SetLocalPosX(self.Parameter.NpcNameBox.UObj, -2)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.NpcHead.UObj, 1)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.NpcTalkBg.UObj, 1)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.TalkText.UObj, 1)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.NpcNameBox.UObj, 1)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.NpcArrowGroup.UObj, 1)
        else
            --人像在右
            MLuaCommonHelper.SetLocalPosX(self.Parameter.NpcHead.UObj, 160)
            MLuaCommonHelper.SetLocalPosX(self.Parameter.NpcNameBox.UObj, 30)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.NpcHead.UObj, -1)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.NpcTalkBg.UObj, -1)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.TalkText.UObj, -1)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.NpcNameBox.UObj, -1)
            MLuaCommonHelper.SetLocalScaleX(self.Parameter.NpcArrowGroup.UObj, -1)
        end
        --卡普拉层级设置
        local l_layer = UI.UILayerSort[aimCtrl.GroupContainerType] + 1
        local l_spineMesh = self.Parameter.NpcAnim.UObj:GetComponent("MeshRenderer")
        if l_spineMesh then
            l_spineMesh.sortingOrder = l_layer
        end
        local l_zhezhao = self.Parameter.Img_Zhezhao.UObj:GetComponent("Canvas")
        if l_zhezhao then
            l_zhezhao.sortingOrder = l_layer + 1
        end
    end
    --文本赋值
    l_guideLab.LabText = infoText
    --箭头初始化
    for i = 1, 6 do
        self.Parameter.Arrow[i].UObj:SetActiveEx(false)
        self.Parameter.NpcArrow[i].UObj:SetActiveEx(false)
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

--特效设置
function GuideArrowPointTemplate:SetEffect(effectData, parentTrans)
    if effectData[0] ~= 0 then
        self.Parameter.EffectPart.UObj:SetActiveEx(true)
        --获取 X Y W H S
        local l_posX = effectData[1]
        local l_posY = effectData[2]
        local l_width = effectData[3]
        local l_height = effectData[4]
        local l_scale = effectData[5]
        --设置位置 缩放
        MLuaCommonHelper.SetRectTransformPos(self.Parameter.EffectPart.UObj, l_posX, l_posY)
        MLuaCommonHelper.SetLocalScale(self.Parameter.EffectPart.UObj, l_scale, l_scale, 1)
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
        for i = 1, #self.Parameter.Effect do
            if i == effectData[0] then
                self.curShowEffectObj = self.Parameter.Effect[i].UObj
                self.curShowEffectObj:SetActiveEx(true)
                MLuaCommonHelper.SetRectTransformSize(self.curShowEffectObj, l_width, l_height)
                MLuaClientHelper.PlayFxHelper(self.curShowEffectObj)
            else
                self.Parameter.Effect[i].UObj:SetActiveEx(false)
            end
        end
    else
        self.Parameter.EffectPart.UObj:SetActiveEx(false)
    end
end

--刷新特效展示
function GuideArrowPointTemplate:RefreshEffect()
    if self.curShowEffectObj ~= nil then
        MLuaClientHelper.PlayFxHelper(self.curShowEffectObj)
    end
end
--lua custom scripts end
return GuideArrowPointTemplate