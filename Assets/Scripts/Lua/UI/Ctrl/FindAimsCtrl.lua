--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FindAimsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
FindAimsCtrl = class("FindAimsCtrl", super)
--lua class define end

--lua functions
function FindAimsCtrl:ctor()

	super.ctor(self, CtrlNames.FindAims, UILayer.Tips, nil, ActiveType.None)

end --func end
--next--
function FindAimsCtrl:Init()

	self.panel = UI.FindAimsPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function FindAimsCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function FindAimsCtrl:OnActive()

	for i = 0, self.panel.PanelRef.Canvases.Length -1 do
        self.panel.PanelRef.Canvases[i].gameObject.layer = MLayer.ID_CutSceneUI
	end

end --func end
--next--
function FindAimsCtrl:OnDeActive()


end --func end
--next--
function FindAimsCtrl:Update()


end --func end





--next--
function FindAimsCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function FindAimsCtrl:ShowMapName()
	if  self.panel==nil then
		return
	end
	self.panel.PanelKpl:SetActiveEx(true)
	self.panel.TxtMeshTip1:SetActiveEx(true)
	self.panel.TxtMeshTip:SetActiveEx(true)
	local l_row = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
	self.panel.TxtMeshTip.LabText=l_row.MapEntryName
	self.panel.FxShow.FxAnim:PlayAll()
	self.panel.FxShow1.FxAnim:PlayAll()
end

function FindAimsCtrl:HideMapName()
	if  self.panel==nil then
		return
	end
	self.panel.PanelKpl:SetActiveEx(false)
	self.panel.TxtMeshTip1:SetActiveEx(false)
	self.panel.TxtMeshTip:SetActiveEx(false)
end

function FindAimsCtrl:ShowKpl()
	if  self.panel==nil then
		return
	end
	self.panel.PanelKpl:SetActiveEx(true)
	self.panel.TxtMeshTip1:SetActiveEx(false)
	self.panel.TxtMeshTip:SetActiveEx(true)
	self.panel.TxtMeshTip.LabText=Lang("OPEN_KPL")
	self.panel.FxShow.FxAnim:PlayAll()
	self.panel.FxShow1.FxAnim:PlayAll()
end


--lua custom scripts end
