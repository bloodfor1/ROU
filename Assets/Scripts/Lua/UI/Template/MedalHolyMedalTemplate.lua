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
--缓存一个MedalData的引用
local l_medalData = DataMgr:GetData("MedalData")
local l_medalMgr = MgrMgr:GetMgr("MedalMgr")
--lua fields end

--lua class define
---@class MedalHolyMedalTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockLv MoonClient.MLuaUICom
---@field TxtUnlockLv MoonClient.MLuaUICom
---@field MedalOpenedBg MoonClient.MLuaUICom
---@field MedalOpened MoonClient.MLuaUICom
---@field MedalName MoonClient.MLuaUICom
---@field MedalLv MoonClient.MLuaUICom
---@field MedalLocked MoonClient.MLuaUICom
---@field MedalImage MoonClient.MLuaUICom
---@field MedalEffect MoonClient.MLuaUICom
---@field MedalCanActive MoonClient.MLuaUICom
---@field MedalBgEffect MoonClient.MLuaUICom
---@field MedalActivate MoonClient.MLuaUICom
---@field HolyMedalPrefab MoonClient.MLuaUICom
---@field ActiveMedal MoonClient.MLuaUICom

---@class MedalHolyMedalTemplate : BaseUITemplate
---@field Parameter MedalHolyMedalTemplateParameter

MedalHolyMedalTemplate = class("MedalHolyMedalTemplate", super)
--lua class define end

--lua functions
function MedalHolyMedalTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MedalHolyMedalTemplate:OnDeActive()
	
	    --已激活特效清除
	    if self.EffectID then
	        self:DestroyUIEffect(self.EffectID)
	        self.EffectID = nil
	    end
	    --已激活背景特效清除
	    if self.EffectBgID then
	        self:DestroyUIEffect(self.EffectBgID)
	        self.EffectBgID = nil
	    end
	
end --func end
--next--
function MedalHolyMedalTemplate:OnSetData(data)
	
	        self:ShowHolyMedal(data)
	
end --func end
--next--
function MedalHolyMedalTemplate:OnDestroy()
	
	
end --func end
--next--
function MedalHolyMedalTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MedalHolyMedalTemplate:ShowHolyMedal(medalData)
    self.Parameter.ActiveMedal:SetActiveEx(false)
    self.Parameter.MedalCanActive:SetActiveEx(false)
    self.Parameter.UnlockLv:SetActiveEx(false)
    --开放状态
    if medalData.MaxLv == 0 then
        self.Parameter.MedalLocked:SetActiveEx(true)
        self.Parameter.MedalOpened:SetActiveEx(false)
    else
        self.Parameter.MedalLocked:SetActiveEx(false)
        self.Parameter.MedalOpened:SetActiveEx(true)
        --图片
        self.Parameter.MedalImage:SetSprite(medalData.Atlas, medalData.Spt)
        --可激活状态
        local isCanActivate = false
        if not medalData.isActivate then
            --未激活状态 判断可否手动激活
            isCanActivate = l_medalMgr.CheckMedalState(medalData.activeProgress,medalData.Activition.Length)
        else
            isCanActivate = false
            --已激活前置特效清除
            if self.EffectID then
                self:DestroyUIEffect(self.EffectID)
                self.EffectID = nil
            end
            --已激活特效
            self.Parameter.MedalEffect.RawImg.enabled = false
            local l_fxData = {}
            l_fxData.rawImage = self.Parameter.MedalEffect.RawImg
            self.EffectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Medallighting_0"..medalData.MedalId, l_fxData)
            
            --已激活背景特效清除
            if self.EffectBgID then
                self:DestroyUIEffect(self.EffectBgID)
                self.EffectBgID = nil
            end
            --已激活背景特效
            self.Parameter.MedalBgEffect.RawImg.enabled = false
            local l_fxData_bg = {}
            l_fxData_bg.rawImage = self.Parameter.MedalBgEffect.RawImg
            self.EffectBgID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Medallighting_04", l_fxData_bg)
        end
        --激活状态
        self:SetActivateState(medalData.isActivate, isCanActivate)
        --可激活状态
        if medalData.isActivate then
            self.Parameter.MedalActivate:SetActiveEx(false)
            self.Parameter.ActiveMedal:SetActiveEx(true)
            self.Parameter.MedalName.LabText = medalData.Name
            self.Parameter.MedalLv.LabText = StringEx.Format(Common.Utils.Lang("LEVEL"), medalData.level)
        else
            if isCanActivate then
                self.Parameter.MedalActivate:SetActiveEx(true)
                self.Parameter.MedalCanActive:SetActiveEx(true)
            else
                self.Parameter.MedalActivate:SetActiveEx(false)
                self.Parameter.UnlockLv:SetActiveEx(true)
                self.Parameter.TxtUnlockLv.LabText = Common.Utils.Lang("MEDAL_UNLOCK",l_medalMgr.GetMedalActiveLevel(medalData))--medalData.Name
            end
        end
        --按钮
        self.Parameter.HolyMedalPrefab:AddClick(function()
            if isCanActivate then
                l_medalMgr.SetMedalAdvanceImage(self.Parameter.MedalImage)
                l_medalMgr.ShowMedalOperateDlg(2, l_medalData.EMedalOperate.Activate, medalData, -1,Common.Utils.Lang("MEDAL_HOLY"))
            else
                local l_medalOpenData = 
                {
                    openType = l_medalData.EMedalOpenType.RefreshShowInfo,
                    medalData = medalData,
                }
                UIMgr:ActiveUI(UI.CtrlNames.MedalTips,l_medalOpenData)
            end
        end)
    end
end

function MedalHolyMedalTemplate:SetActivateState(state, isCanActivate)
    if state then
        self.Parameter.MedalOpenedBg:SetSprite("Medal", "UI_Medal_Bg_Orange_Normal.png")
        local color = Color.New(1, 1, 1, 1)
        self.Parameter.MedalImage.Img.color = color
    else
        if isCanActivate then
            self.Parameter.MedalOpenedBg:SetSprite("Medal", "UI_Medal_Bg_Orange_Unreaches.png")
            local color = Color.New(0, 0, 0, 1)
            self.Parameter.MedalImage.Img.color = color
        else
            self.Parameter.MedalOpenedBg:SetSprite("Medal", "UI_Medal_Bg_Orange_Unreaches.png")
            local color = Color.New(0, 0, 0, 0.4)
            self.Parameter.MedalImage.Img.color = color
        end
    end
end
--lua custom scripts end
return MedalHolyMedalTemplate