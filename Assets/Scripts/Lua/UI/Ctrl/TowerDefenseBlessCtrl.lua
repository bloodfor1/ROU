--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TowerDefenseBlessPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TowerDefenseBlessCtrl = class("TowerDefenseBlessCtrl", super)
--lua class define end

--lua functions
function TowerDefenseBlessCtrl:ctor()
	
	super.ctor(self, CtrlNames.TowerDefenseBless, UILayer.Function, nil, ActiveType.None)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Dark
	
end --func end
--next--
function TowerDefenseBlessCtrl:Init()
	
	self.panel = UI.TowerDefenseBlessPanel.Bind(self)
	super.Init(self)

	self._mgr=MgrMgr:GetMgr("TowerDefenseMgr")

	self._skillType=self._mgr.ESkillType.AttackBless

	self.panel.ButtonClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.TowerDefenseBless)
	end)

	self.panel.DetermineButton:AddClick(function()
		self:_onDetermineButton()
	end)

	self._tdBlessTemplatePool = self:NewTemplatePool({
		TemplateClassName="TDBlessTemplate",
		ScrollRect=self.panel.TDBlessScroll.LoopScroll,
		TemplatePrefab=self.panel.TDBlessPrefab.gameObject,
		Method = function(index)
			self:_onBlessTemplateButton(index)
		end
	})
	
end --func end
--next--
function TowerDefenseBlessCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self._mgr=nil
	
end --func end
--next--
function TowerDefenseBlessCtrl:OnActive()

	local l_typeText
	local l_currentSkillId
	if self.uiPanelData then
		self._skillType= self._mgr.ESkillType.AttackBless
		l_currentSkillId=self._mgr.GetAttackBlessSkillId()
		l_typeText=Lang("TowerDefense_AttackBlessType")
	else
		self._skillType= self._mgr.ESkillType.DefenseBless
		l_currentSkillId=self._mgr.GetDefenseBlessSkillId()
		l_typeText=Lang("TowerDefense_DefenseBlessType")
	end

	self.panel.BlessPresentation.LabText = StringEx.Format(Lang("TowerDefense_BlessPresentation"), l_typeText)

	local l_skillDatas= self._mgr.GetSkillTableInfoWithType(self._skillType)

	local l_selectIndex=-1
	if l_currentSkillId then
		for i = 1, #l_skillDatas do
			if l_skillDatas[i].ID==l_currentSkillId then
				l_selectIndex=i
				break
			end
		end
	end

	table.insert(l_skillDatas,{ID=0})

	if l_selectIndex < 0 then
		l_selectIndex=#l_skillDatas
	end

	self._tdBlessTemplatePool:ShowTemplates({
		Datas = l_skillDatas,
		AdditionalData=l_currentSkillId
	})

	self._tdBlessTemplatePool:SelectTemplate(l_selectIndex)
	
end --func end
--next--
function TowerDefenseBlessCtrl:OnDeActive()
	
	
end --func end
--next--
function TowerDefenseBlessCtrl:Update()
	
	
end --func end
--next--
function TowerDefenseBlessCtrl:BindEvents()

	
end --func end
--next--
--lua functions end

--lua custom scripts
function TowerDefenseBlessCtrl:_onBlessTemplateButton(index)
	self._tdBlessTemplatePool:SelectTemplate(index)
end

function TowerDefenseBlessCtrl:_onDetermineButton()
	local l_currentData= self._tdBlessTemplatePool:GetCurrentSelectTemplateData()

	if l_currentData then

		local l_attackId
		local l_defenseId

		if self._skillType == self._mgr.ESkillType.AttackBless then
			l_attackId=l_currentData.ID
			l_defenseId=self._mgr.GetDefenseBlessSkillId()
		else
			l_attackId=self._mgr.GetAttackBlessSkillId()
			l_defenseId=l_currentData.ID
		end

		MgrMgr:GetMgr("TowerDefenseMgr").RequestSetTowerDefenseBless(l_attackId,l_defenseId)
		UIMgr:DeActiveUI(UI.CtrlNames.TowerDefenseBless)
	end
end
--lua custom scripts end
return TowerDefenseBlessCtrl