--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AchievementAwardTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
AchievementAwardTipsCtrl = class("AchievementAwardTipsCtrl", super)
--lua class define end

--lua functions
function AchievementAwardTipsCtrl:ctor()
	
	super.ctor(self, CtrlNames.AchievementAwardTips, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function AchievementAwardTipsCtrl:Init()
	
	self.panel = UI.AchievementAwardTipsPanel.Bind(self)
	super.Init(self)

	self.panel.CloseButton:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.AchievementAwardTips)
	end)
	
end --func end
--next--
function AchievementAwardTipsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function AchievementAwardTipsCtrl:OnActive()
	
	
end --func end
--next--
function AchievementAwardTipsCtrl:OnDeActive()
	
	
end --func end
--next--
function AchievementAwardTipsCtrl:Update()
	
	
end --func end





--next--
function AchievementAwardTipsCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function AchievementAwardTipsCtrl:ShowTips(id)
	local l_tableInfo = TableUtil.GetPrivilegeSystemDesTable().GetRowById(id)
	if l_tableInfo==nil then
		return
	end

	self.panel.Name.LabText = l_tableInfo.Name
	self.panel.Descript.LabText = l_tableInfo.SystemDes

	local l_functionId=l_tableInfo.LinkId
	if l_functionId==0 then
		self.panel.GotoButton:SetActiveEx(false)
	else
		self.panel.GotoButton:SetActiveEx(true)
		--self.panel.GoToText.LabText = l_tableInfo.LinkDes

		self.panel.GotoButton:AddClick(function()
			UIMgr:DeActiveUI(UI.CtrlNames.AchievementAwardTips)
			Common.CommonUIFunc.InvokeFunctionByFuncId(l_functionId)
		end)
	end

	self.panel.Icon:SetSpriteAsync(l_tableInfo.SystemAtlas, l_tableInfo.SystemIcon)



end
--lua custom scripts end
return AchievementAwardTipsCtrl