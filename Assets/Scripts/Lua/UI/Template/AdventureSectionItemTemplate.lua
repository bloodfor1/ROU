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
---@class AdventureSectionItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SectionName MoonClient.MLuaUICom[]
---@field SectionBoxFxView MoonClient.MLuaUICom
---@field SectionBG MoonClient.MLuaUICom[]
---@field Prefab MoonClient.MLuaUICom
---@field LockMask MoonClient.MLuaUICom
---@field IsHasMissionGet MoonClient.MLuaUICom
---@field BtnSectionBoxImg MoonClient.MLuaUICom[]
---@field BtnSectionBox MoonClient.MLuaUICom[]
---@field BtnOn MoonClient.MLuaUICom
---@field BtnOff MoonClient.MLuaUICom

---@class AdventureSectionItemTemplate : BaseUITemplate
---@field Parameter AdventureSectionItemTemplateParameter

AdventureSectionItemTemplate = class("AdventureSectionItemTemplate", super)
--lua class define end

--lua functions
function AdventureSectionItemTemplate:Init()
    
        super.Init(self)
        self.sectionBoxFx = nil
    
end --func end
--next--
function AdventureSectionItemTemplate:OnDestroy()
    
    
end --func end
--next--
function AdventureSectionItemTemplate:OnDeActive()
    
        self:CloseScetionBoxFx()
    
end --func end
--next--
function AdventureSectionItemTemplate:OnSetData(data)
    
    self.data = data
    self.Parameter.SectionBG[1]:SetSprite(data.sectionData.Atlas, data.sectionData.Icon)
    self.Parameter.SectionBG[2]:SetSprite(data.sectionData.Atlas, data.sectionData.Icon)
    self.Parameter.SectionName[1].LabText = data.sectionData.Name
    self.Parameter.SectionName[2].LabText = data.sectionData.Name
    self.Parameter.LockMask.UObj:SetActiveEx(not data.isUnlock)
    --红点控制
    local l_isNeedShowRed = false
    for i,v in pairs(data.missionInfos) do
        if v.isFinish and not v.isGetAward then
            l_isNeedShowRed = true
            break
        end
    end
    self.Parameter.IsHasMissionGet.UObj:SetActiveEx(l_isNeedShowRed)
    --点击事件
    self.Parameter.BtnOff:AddClick(function ()
        if data.isUnlock then
            self:MethodCallback(self.ShowIndex)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BASE_ACHIEVE_TO_UNLOCK", data.sectionData.UnlockLevel))
        end
    end)
    --章节宝箱点击事件
    local l_sectionBoxClickFunc = function ()
        UIMgr:ActiveUI(UI.CtrlNames.AdventureDiarySectionAward, {
            type = DataMgr:GetData("AdventureDiaryData").EUIOpenType.AdventureDiarySectionAward,
            data = data
        })
    end
    self.Parameter.BtnSectionBox[1]:AddClick(l_sectionBoxClickFunc)
    self.Parameter.BtnSectionBox[2]:AddClick(l_sectionBoxClickFunc)

    --如果章节已解锁 判断是否需要展示章节宝箱特效
    local l_sectionAwardBoxImgPath = "UI_icon_item_baoxiang_02.png"  --章节宝箱图标（宝箱关闭）
    self:CloseScetionBoxFx()
    if data.isUnlock then
        local l_adventureData = DataMgr:GetData("AdventureDiaryData")
        --判断奖励宝箱是否可领取
        local l_isSectionBoxCanGet = l_adventureData.CheckSectionCanGetAward(data)
        --判断奖励宝箱是否已领取
        local l_isSectionBoxGeted = l_adventureData.CheckSectionIsGetAward(data)
        --全解锁 且 未领取 则展示特效
        if l_isSectionBoxCanGet and (not l_isSectionBoxGeted) then
            self:ShowScetionBoxFx()
        end
        --已领取的宝箱突变修改为打开图标
        if l_isSectionBoxGeted then
            l_sectionAwardBoxImgPath = "UI_icon_item_baoxiang_03.png"  --宝箱打开
        end
    end
    --章节宝箱图标设置
    self.Parameter.BtnSectionBoxImg[1]:SetSprite("Icon_ItemConsumables02", l_sectionAwardBoxImgPath, true)
    self.Parameter.BtnSectionBoxImg[2]:SetSprite("Icon_ItemConsumables02", l_sectionAwardBoxImgPath, true)
    
end --func end
--next--
function AdventureSectionItemTemplate:BindEvents()
    
    
end --func end
--next--
--lua functions end

--lua custom scripts
--展示章节宝箱奖励可领取特效
function AdventureSectionItemTemplate:ShowScetionBoxFx()
    self:CloseScetionBoxFx()
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.SectionBoxFxView.RawImg
    l_fxData.scaleFac = Vector3.New(6, 6, 1)
    l_fxData.loadedCallback = function(a) 
        self.Parameter.SectionBoxFxView.gameObject:SetActiveEx(true) 
    end
    l_fxData.destroyHandler = function ()
        self.sectionBoxFx = nil
        self.Parameter.SectionBoxFxView.gameObject:SetActiveEx(false) 
    end
    self.sectionBoxFx = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_UI_MaoXianShouCe_BaoXiang", l_fxData)
end

--关闭章节宝箱奖励可领取特效
function AdventureSectionItemTemplate:CloseScetionBoxFx()
    if self.sectionBoxFx ~= nil then
        self:DestroyUIEffect(self.sectionBoxFx)
        self.sectionBoxFx = nil
        self.Parameter.SectionBoxFxView.gameObject:SetActiveEx(false) 
    end
end


function AdventureSectionItemTemplate:OnSelect()
    self.Parameter.BtnOff.UObj:SetActiveEx(false)
    self.Parameter.BtnOn.UObj:SetActiveEx(true)
end

function AdventureSectionItemTemplate:OnDeselect()
    self.Parameter.BtnOff.UObj:SetActiveEx(true)
    self.Parameter.BtnOn.UObj:SetActiveEx(false)
end
--lua custom scripts end
return AdventureSectionItemTemplate