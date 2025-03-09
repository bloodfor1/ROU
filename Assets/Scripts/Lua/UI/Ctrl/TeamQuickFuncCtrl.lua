--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamQuickFuncPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamQuickFuncCtrl = class("TeamQuickFuncCtrl", super)
--lua class define end

--lua functions
function TeamQuickFuncCtrl:ctor()

	super.ctor(self,CtrlNames.TeamQuickFunc,UILayer.Tips, nil, ActiveType.Standalone)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Transparent
	self.ClosePanelNameOnClickMask = UI.CtrlNames.TeamQuickFunc
end --func end
--next--
function TeamQuickFuncCtrl:Init()
	self.panel = UI.TeamQuickFuncPanel.Bind(self)
	super.Init(self)
	--self.panel.BtnBg:AddClick(function ()
	--	UIMgr:DeActiveUI(UI.CtrlNames.TeamQuickFunc)
	--end)
end --func end
--next--
function TeamQuickFuncCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function TeamQuickFuncCtrl:OnActive()
	self.panel.BtnBg:SetActiveEx(false)
    if self.uiPanelData ~= nil and self.uiPanelData.openType then
        if self.uiPanelData.openType == DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc then
            self:SetQuickPanelByNameAndFunc(self.uiPanelData.nameTb,self.uiPanelData.callbackTb,self.uiPanelData.dataopenPos,self.uiPanelData.dataAnchorMaxPos,self.uiPanelData.dataAnchorMinPos)
        end
    end
end --func end
--next--
function TeamQuickFuncCtrl:OnDeActive()


end --func end
--next--
function TeamQuickFuncCtrl:Update()


end --func end



--next--
function TeamQuickFuncCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function TeamQuickFuncCtrl:SetQuickPanelByNameAndFunc(btnNameTb,btnMethodTb,openPos,anchorMaxPos,anchorMinPos)
	self.teamFuncUI = {}
	self.panel.FucMemberTpl.gameObject:SetActiveEx(true)
	for i=1,table.maxn(btnNameTb) do
		self.teamFuncUI[i] = {}
		self.teamFuncUI[i].ui = self:CloneObj(self.panel.FucMemberTpl.gameObject)
		self.teamFuncUI[i].uiCom = self.teamFuncUI[i].ui.transform:GetComponent("MLuaUICom")
        self.teamFuncUI[i].ui.transform:SetParent(self.panel.FucMemberTpl.transform.parent)
        self.teamFuncUI[i].ui.transform:SetLocalScaleOne()
        MLuaClientHelper.GetOrCreateMLuaUICom(self.teamFuncUI[i].ui.transform:Find("FucMemberTpl_1/Name")).LabText = btnNameTb[i]
		self.teamFuncUI[i].uiCom:AddClick(function ()
			UIMgr:DeActiveUI(UI.CtrlNames.TeamQuickFunc)
			btnMethodTb[i]()
		end)
	end

	self.panel.FucMemberTpl.gameObject:SetActiveEx(false)
	self.panel.FucPanel.RectTransform.anchorMax = anchorMaxPos == nil and Vector2.New(0.5,0.5) or anchorMaxPos
	self.panel.FucPanel.RectTransform.anchorMin = anchorMinPos == nil and Vector2.New(0.5,0.5) or anchorMinPos
	self.panel.FucPanel.RectTransform.anchoredPosition = openPos
end

--lua custom scripts end
