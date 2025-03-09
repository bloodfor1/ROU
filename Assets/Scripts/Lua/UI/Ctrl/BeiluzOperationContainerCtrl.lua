--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BeiluzOperationContainerPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class BeiluzOperationContainerCtrl : UIBaseCtrl
BeiluzOperationContainerCtrl = class("BeiluzOperationContainerCtrl", super)
--lua class define end

local l_mgr = MgrMgr:GetMgr("BeiluzCoreMgr")

--lua functions
function BeiluzOperationContainerCtrl:ctor()
	
	super.ctor(self, CtrlNames.BeiluzOperationContainer, UILayer.Function, nil, ActiveType.Exclusive)

	self.IsGroup = true

	
end --func end
--next--
function BeiluzOperationContainerCtrl:Init()

	self.panel = UI.BeiluzOperationContainerPanel.Bind(self)
	super.Init(self)

	self.panel.ButtonClose:AddClickWithLuaSelf(self._onBtnClose,self)
end --func end
--next--
function BeiluzOperationContainerCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function BeiluzOperationContainerCtrl:OnActive()

	if l_mgr.NeedGuide() then
		UIMgr:DeActiveUI(CtrlNames.BeiluzOperationContainer)
		UIMgr:ActiveUI(CtrlNames.BeiluzCore)
		return
	end

	if self.uiPanelData then
		if self.uiPanelData.opType then
			self:SelectOneHandler(self.uiPanelData.opType)
		end
	end

end --func end
--next--
function BeiluzOperationContainerCtrl:OnDeActive()
	
	
end --func end
--next--
function BeiluzOperationContainerCtrl:Update()
	
	
end --func end
--next--
function BeiluzOperationContainerCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function BeiluzOperationContainerCtrl:SetupHandlers()
	local l_handlerTb = {}

	local OpenSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
	if OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzReset) then
		table.insert(l_handlerTb, { HandlerNames.BeiluzCoreReset, Common.Utils.Lang("MEDAL_TIP_RESET")})
	end
	if OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzCombine) then
		table.insert(l_handlerTb, { HandlerNames.BeiluzCoreSynthesis, Common.Utils.Lang("BAG_TIP_COMPOUND")})
	end
	self:InitHandler(l_handlerTb, self.panel.Tog)
end

function BeiluzOperationContainerCtrl:_onBtnClose()
	UIMgr:DeActiveUI(self.name)
end


function BeiluzOperationContainerCtrl:SetTitle(str)
	self.panel.TxtTitle.LabText = str
end

--lua custom scripts end
return BeiluzOperationContainerCtrl