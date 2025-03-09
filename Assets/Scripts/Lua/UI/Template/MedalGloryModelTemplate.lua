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
---@class MedalGloryModelTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockLv MoonClient.MLuaUICom
---@field TxtUnlockLv MoonClient.MLuaUICom
---@field MedalUpgrade MoonClient.MLuaUICom
---@field MedalOpenedBg MoonClient.MLuaUICom
---@field MedalOpened MoonClient.MLuaUICom
---@field MedalName MoonClient.MLuaUICom
---@field MedalLv MoonClient.MLuaUICom
---@field MedalLocked MoonClient.MLuaUICom
---@field MedalImage MoonClient.MLuaUICom
---@field MedalCanActive MoonClient.MLuaUICom
---@field GloryModelPrefab MoonClient.MLuaUICom
---@field ActiveMedal MoonClient.MLuaUICom

---@class MedalGloryModelTemplate : BaseUITemplate
---@field Parameter MedalGloryModelTemplateParameter

MedalGloryModelTemplate = class("MedalGloryModelTemplate", super)
--lua class define end

--lua functions
function MedalGloryModelTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MedalGloryModelTemplate:OnDeActive()
	
	
end --func end
--next--
function MedalGloryModelTemplate:OnSetData(data)
	
	    self:ShowGloryMedal(data)
	
end --func end
--next--
function MedalGloryModelTemplate:OnDestroy()
	
	
end --func end
--next--
function MedalGloryModelTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MedalGloryModelTemplate:ShowGloryMedal(medalData)
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

        --激活状态
        self:SetActivateState(medalData.isActivate, isCanActivate)

        --可激活判断
        local isCanActivate = false
        if not medalData.isActivate then
            isCanActivate = l_medalMgr.CheckMedalState(medalData.activeProgress,medalData.Activition.Length)
        end
        --可激活状态
        if medalData.isActivate then
            self.Parameter.ActiveMedal:SetActiveEx(true)
            self.Parameter.MedalName.LabText = medalData.Name
            self.Parameter.MedalLv.LabText = StringEx.Format(Common.Utils.Lang("LEVEL"), medalData.level)
        else
            if isCanActivate then
                self.Parameter.MedalCanActive:SetActiveEx(true)
            else
                --显示多少级解锁
                self.Parameter.UnlockLv:SetActiveEx(true)
                self.Parameter.TxtUnlockLv.LabText = Common.Utils.Lang("MEDAL_UNLOCK",l_medalMgr.GetMedalActiveLevel(medalData))--medalData.Name
            end
        end
        --按钮
        self.Parameter.GloryModelPrefab:AddClick(function()
            if isCanActivate then
                l_medalMgr.SetMedalAdvanceImage(self.Parameter.MedalImage)
                --激活
                l_medalMgr.RequestMedalOperate(1, l_medalData.EMedalOperate.Activate, medalData.MedalId, -1)
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

function MedalGloryModelTemplate:SetActivateState(state, isCanActivate)
    if state then
        self.Parameter.MedalOpenedBg:SetSprite("Medal", "UI_Medal_Bg_Blue_Normal.png")
        local color = Color.New(1, 1, 1, 1)
        self.Parameter.MedalImage.Img.color = color
    else
        if isCanActivate then
            self.Parameter.MedalOpenedBg:SetSprite("Medal", "UI_Medal_Bg_Blue_Unreaches.png")
            local color = Color.New(0, 0, 0, 1)
            self.Parameter.MedalImage.Img.color = color
        else
            self.Parameter.MedalOpenedBg:SetSprite("Medal", "UI_Medal_Bg_Blue_Unreaches.png")
            local color = Color.New(0, 0, 0, 0.4)
            self.Parameter.MedalImage.Img.color = color
        end
    end
end
--lua custom scripts end
return MedalGloryModelTemplate