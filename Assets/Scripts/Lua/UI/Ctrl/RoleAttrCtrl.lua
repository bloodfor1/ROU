--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RoleAttrPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
RoleAttrCtrl = class("RoleAttrCtrl", super)
--lua class define end

--lua functions
function RoleAttrCtrl:ctor()
	
	super.ctor(self, CtrlNames.RoleAttr, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function RoleAttrCtrl:Init()

	self.panel = UI.RoleAttrPanel.Bind(self)
	super.Init(self)
	self.panel.ButtonClose:AddClick(function ()
		local hasAddAttr = self:GetRoleAttrState()
		if hasAddAttr then
			CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("SKILLLEARNING_SKILL_TIP_SAVE_BEFORE_QUIT"), nil, function()
				UIMgr:DeActiveUI(CtrlNames.RoleAttr)
			end)
		else
			UIMgr:DeActiveUI(CtrlNames.RoleAttr)
		end
    end)

end --func end

--next--
function RoleAttrCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function RoleAttrCtrl:OnActive()

	if self.uiPanelData then
		if self.uiPanelData.openType == MgrMgr:GetMgr("RoleInfoMgr").ERoleInfoOpenType.ShowBeginnerGuide then
			MgrMgr:GetMgr("RoleInfoMgr").ShowBeginnerGuide()
        end
		if self.uiPanelData.openType == MgrMgr:GetMgr("RoleInfoMgr").ERoleInfoOpenType.ResetRoleAttr then
			MgrMgr:GetMgr("RoleInfoMgr").ResetRoleAttr()
		end
		if self.uiPanelData.openType == MgrMgr:GetMgr("RoleInfoMgr").ERoleInfoOpenType.AutoCalulateCom then
			MgrMgr:GetMgr("RoleInfoMgr").AutoCalulateCom(self.uiPanelData.id)
		end
		if self.uiPanelData.openType == MgrMgr:GetMgr("RoleInfoMgr").ERoleInfoOpenType.OpenAddAttrSchools then
			UIMgr:ActiveUI(UI.CtrlNames.AddAttrSchools, function(ctrl)
				local _, proId = DataMgr:GetData("SkillData").CurrentProTypeAndId()
				ctrl:InitWithAttrTypeId(proId)
			end)
		end
    end
	self:SelectOneHandler(HandlerNames.RoleInfo)

end --func end
--next--
function RoleAttrCtrl:OnDeActive()
	
end --func end
--next--
function RoleAttrCtrl:Update()

	if self.curHandler then
		self.curHandler:Update()
	end

end --func end


--next--
function RoleAttrCtrl:BindEvents()

end --func end

--next--
--lua functions end

--lua custom scripts
function RoleAttrCtrl:SetupHandlers()

    local l_handlerTb = {
        {HandlerNames.RoleInfo, Lang("WORDS_CHARACTER"), "CommonIcon", "UI_CommonIcon_Tab_shuxing_01.png", "UI_CommonIcon_Tab_shuxing_02.png"},
    }
	if MPlayerInfo.ProfessionId ~= 1000 then
		table.insert(l_handlerTb,{HandlerNames.Occupation, Lang("WORDS_PROFESSION"), "CommonIcon", "UI_CommonIcon_Tab_zhuanzhi_01.png", "UI_CommonIcon_Tab_zhuanzhi_02.png"})
	end
	if MgrMgr:GetMgr("MultiTalentMgr").IsCollocationSysOpen() then
		table.insert(l_handlerTb,{HandlerNames.MultiTalent, Lang("COLLOCATION"), "CommonIcon", "UI_CommonIcon_Tab_zhuanzhi_01.png", "UI_CommonIcon_Tab_zhuanzhi_02.png"})
	end
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl, false)
	local redSignKeys =
	{
		eRedSignKey.RedSignProHint1,
		eRedSignKey.RedSignProHint2
	}
	local l_handler = self:GetHandlerByName(HandlerNames.Occupation)
	if l_handler then
		for i = 1, #redSignKeys do
			local redSign = self:NewRedSign({
				Key = redSignKeys[i],
				ClickTogEx = l_handler.toggle
			})
		end
	end
end

function RoleAttrCtrl:GetRoleAttrState()

	local l_handler = self:GetHandlerByName(HandlerNames.RoleInfo)
	if l_handler ~= nil and l_handler.isActive and l_handler.panel ~= nil then
		return l_handler.panel.RoleInfoSavePanel.gameObject.activeSelf
	end
	return false

end

return RoleAttrCtrl
--lua custom scripts end
