--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Theme_InformationPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
Theme_InformationCtrl = class("Theme_InformationCtrl", super)
--lua class define end

--lua functions
function Theme_InformationCtrl:ctor()
	
	super.ctor(self, CtrlNames.Theme_Information, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function Theme_InformationCtrl:Init()
	
	self.panel = UI.Theme_InformationPanel.Bind(self)
	super.Init(self)

    self.themeDungeonMgr = MgrMgr:GetMgr("ThemeDungeonMgr")

    self.panel.BackBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.Theme_Information)
    end)

    self.panel.InformationScroll:SetScrollRectGameObjListener(nil, self.panel.DownArrow.gameObject, nil, nil)

    self:InitEffect()
end --func end
--next--
function Theme_InformationCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function Theme_InformationCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.themeDungeonId then
        self:SetInfo(self.uiPanelData.themeDungeonId, self.uiPanelData.isThemeChallengeFirst)
    end
end --func end
--next--
function Theme_InformationCtrl:OnDeActive()
	-- 打开新任务界面
    if self.isThemeChallengeFirst then
        self.themeDungeonMgr.CheckNewTask()
    end

    self:DestroyEffect()
end --func end
--next--
function Theme_InformationCtrl:Update()

end --func end
--next--
function Theme_InformationCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function Theme_InformationCtrl:InitEffect()
    --local l_fxData = {}
    --l_fxData.rawImage = self.panel.Effect.RawImg
    --l_fxData.position = Vector3.New(3, 1.24,0)
    --l_fxData.scaleFac = Vector3.New(4, 4, 4)
    --if self.effect then
    --    self:DestroyUIEffect(self.effect)
    --end
    --self.effect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Challenge3", l_fxData)
    --
end

function Theme_InformationCtrl:DestroyEffect()
    --if self.effect then
    --    self:DestroyUIEffect(self.effect)
    --end
end

-- themeDungeonId -1表示挑战模式，是统一的文本
function Theme_InformationCtrl:SetInfo(themeDungeonId, isThemeChallengeFirst)
    self.isThemeChallengeFirst = isThemeChallengeFirst
    if themeDungeonId ~= -1 then
        self.panel.TitleName.LabText = Lang("PUBLIC_INFORMATION")
        ---@type ThemeDungeonTable
        local l_themeDungeonRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(themeDungeonId)
        if l_themeDungeonRow then
            self.panel.InformationText.LabText = l_themeDungeonRow.ChapterContent
        end
    else
        self.panel.TitleName.LabText = Lang("HELRAM_TITLE")
        self.panel.InformationText.LabText = Lang("HELRAM_INFORMATION")
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.InformationScroll.transform)
    self.panel.InformationScroll.Scroll.verticalNormalizedPosition = 1
    self.panel.InformationScroll:SetScrollRectDownAndUpState(nil, self.panel.DownArrow.gameObject)
end

--lua custom scripts end
return Theme_InformationCtrl