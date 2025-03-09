--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Choosejob_npcPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class Choosejob_npcCtrl : UIBaseCtrl
Choosejob_npcCtrl = class("Choosejob_npcCtrl", super)
--lua class define end

--lua functions
function Choosejob_npcCtrl:ctor()
	
	super.ctor(self, CtrlNames.Choosejob_npc, UILayer.Function, nil, ActiveType.Exclusive)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Dark
	self.ClosePanelNameOnClickMask = UI.CtrlNames.AdventureChapterAward
	
end --func end
--next--
function Choosejob_npcCtrl:Init()
	
	self.panel = UI.Choosejob_npcPanel.Bind(self)
	super.Init(self)
	self.panel.BtnClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.Choosejob_npc)
	end)
	self.data = DataMgr:GetData("SkillData")
	
end --func end
--next--
function Choosejob_npcCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.data = nil

end --func end
--next--
function Choosejob_npcCtrl:OnActive()

	if self.uiPanelData ~= nil and #self.uiPanelData > 1 then
		self:InitUI(self.uiPanelData)
	elseif self.uiPanelData ~= nil then
		MgrMgr:GetMgr("TaskMgr").RequestJobChoice(self.uiPanelData[1])
		UIMgr:DeActiveUI(UI.CtrlNames.Choosejob_npc)
	else
		UIMgr:DeActiveUI(UI.CtrlNames.Choosejob_npc)
	end

end --func end
--next--
function Choosejob_npcCtrl:OnDeActive()
	
	
end --func end
--next--
function Choosejob_npcCtrl:Update()
	
	
end --func end
--next--
function Choosejob_npcCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function Choosejob_npcCtrl:InitUI(proList)

	self.panel.LeftJobChooseBtn:AddClick(function()
		MgrMgr:GetMgr("TaskMgr").RequestJobChoice(proList[1])
		UIMgr:DeActiveUI(UI.CtrlNames.Choosejob_npc)
	end, true)
	self.panel.RightJobChooseBtn:AddClick(function()
		MgrMgr:GetMgr("TaskMgr").RequestJobChoice(proList[2])
		UIMgr:DeActiveUI(UI.CtrlNames.Choosejob_npc)
	end, true)

	local l_previewData = self.data.GetDataFromTable("ProfessionPreviewTable", proList[1])
	local l_preview = self.data.GetDataFromTable("ProfessionTable", proList[1])
	self.panel.LeftJobName.LabText = l_preview.Name
	self.panel.LeftJobImage:SetSprite("Common", l_preview.ProfessionIcon)
	self.panel.LeftJobText.LabText = l_previewData.ProfessionDesc
	self.panel.LeftJobPic:SetRawTex(MPlayerInfo.IsMale and l_preview.ChooseJobPic[0] or l_preview.ChooseJobPic[1], true)
	self.panel.LeftJobShadow:SetRawTex(MPlayerInfo.IsMale and l_preview.ChooseJobPic[0] or l_preview.ChooseJobPic[1], true)
	l_previewData = self.data.GetDataFromTable("ProfessionPreviewTable", proList[2])
	l_preview = self.data.GetDataFromTable("ProfessionTable", proList[2])
	self.panel.RightJobName.LabText = l_preview.Name
	self.panel.RightJobImage:SetSprite("Common", l_preview.ProfessionIcon)
	self.panel.RightJobText.LabText = l_previewData.ProfessionDesc
	self.panel.RightJobPic:SetRawTex(MPlayerInfo.IsMale and l_preview.ChooseJobPic[0] or l_preview.ChooseJobPic[1], true)
	self.panel.RightJobShadow:SetRawTex(MPlayerInfo.IsMale and l_preview.ChooseJobPic[0] or l_preview.ChooseJobPic[1], true)

end
--lua custom scripts end
return Choosejob_npcCtrl