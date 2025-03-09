--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Theme_ConfirmationPanel"
require "UI/Template/SceneElementCell"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
Theme_ConfirmationCtrl = class("Theme_ConfirmationCtrl", super)
--lua class define end

--lua functions
function Theme_ConfirmationCtrl:ctor()
	
	super.ctor(self, CtrlNames.Theme_Confirmation, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function Theme_ConfirmationCtrl:Init()
	
	self.panel = UI.Theme_ConfirmationPanel.Bind(self)
	super.Init(self)

    self.themeDungeonMgr = MgrMgr:GetMgr("ThemeDungeonMgr")

    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.Theme_Confirmation)
    end)

    self.panel.EquipTog.TogEx.onValueChanged:AddListener(function(isOn)
        self.panel.RecommendEquipmentScroll:SetActiveEx(isOn)
    end)

    self.panel.SceneTog.TogEx.onValueChanged:AddListener(function(isOn)
        self.panel.SceneElement:SetActiveEx(isOn)
    end)
    self.panel.RecommendEquipmentScroll:SetActiveEx(true)
    self.panel.SceneElement:SetActiveEx(false)
    self.panel.EquipTog.TogEx.isOn = true

    -- 场景元素
    self.sceneElementPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SceneElementCell,
        TemplatePrefab = self.panel.SceneElementCell.LuaUIGroup.gameObject,
        ScrollRect = self.panel.SceneElementScroll.LoopScroll,
    })

    self.panel.SceneElementCell.LuaUIGroup.gameObject:SetActiveEx(false)
end --func end
--next--
function Theme_ConfirmationCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function Theme_ConfirmationCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.dungeonId then
        self:SetInfo(self.uiPanelData.dungeonId, self.uiPanelData.hardLevel, self.uiPanelData.isFromHref)
    end
	
end --func end
--next--
function Theme_ConfirmationCtrl:OnDeActive()
	
	
end --func end
--next--
function Theme_ConfirmationCtrl:Update()
	
	
end --func end
--next--
function Theme_ConfirmationCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

-- 0 普通，1 困难
function Theme_ConfirmationCtrl:SetInfo(dungeonId, hardLevel, isFromHref)
    -- 战前确认分享
    if not isFromHref then
        self.themeDungeonMgr.ShareChallengeConfirm(dungeonId, hardLevel)
    end

    local l_serverDay = MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData.serverDay
    local l_dungeonLevelRow = TableUtil.GetDungeonLevelTable().GetRowByBeginDay(l_serverDay, true)
    if not l_dungeonLevelRow then
        -- 获取最后一行
        local l_table = TableUtil.GetDungeonLevelTable().GetTable()
        l_dungeonLevelRow = l_table[#l_table]
    end
    if l_dungeonLevelRow then
        local l_levelLimit = {
            {l_dungeonLevelRow.WeaponLv[hardLevel][0], l_dungeonLevelRow.WeaponLv[hardLevel][1]},
            {l_dungeonLevelRow.ArmourLv[hardLevel][0], l_dungeonLevelRow.ArmourLv[hardLevel][1]},
            {l_dungeonLevelRow.CloakLv[hardLevel][0], l_dungeonLevelRow.CloakLv[hardLevel][1]},
            {l_dungeonLevelRow.ShoesLv[hardLevel][0], l_dungeonLevelRow.ShoesLv[hardLevel][1]},
            {l_dungeonLevelRow.OrnamentLv[hardLevel][0], l_dungeonLevelRow.OrnamentLv[hardLevel][1]},
            {l_dungeonLevelRow.OffHandLv[hardLevel][0], l_dungeonLevelRow.OffHandLv[hardLevel][1]}
        }
        for i = 1, 6 do
            self.panel.EquipLevel[i].LabText = RoColor.FormatWordDark(Lang("RECOMMEND_EUIQP_LEVEL", l_levelLimit[i][1]))
            self.panel.EquipRefineLevel[i].LabText = RoColor.FormatWordDark(Lang("RECOMMEND_EUIQP_REFINE_LEVEL", l_levelLimit[i][2]))
        end
    end
    local l_affixDatas = MgrMgr:GetMgr("ThemeDungeonMgr").GetDungeonAffix(dungeonId)
    self.panel.SceneEmpty:SetActiveEx(#l_affixDatas==0)
    self.sceneElementPool:ShowTemplates({Datas = l_affixDatas})
end


--lua custom scripts end
return Theme_ConfirmationCtrl