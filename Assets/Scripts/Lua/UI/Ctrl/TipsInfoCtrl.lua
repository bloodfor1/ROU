--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TipsInfoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TipsInfoCtrl = class("TipsInfoCtrl", super)
--lua class define end

--lua functions
function TipsInfoCtrl:ctor()

	super.ctor(self, CtrlNames.TipsInfo, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function TipsInfoCtrl:Init()

	self.panel = UI.TipsInfoPanel.Bind(self)
	super.Init(self)

	self.params = nil

	self.panel.Mask:AddClick(function()
		self:CloseUI()
	end)
end --func end
--next--
function TipsInfoCtrl:Uninit()

	self.params = nil

	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function TipsInfoCtrl:OnActive()
	self:CustomRefresh()
end --func end
--next--
function TipsInfoCtrl:OnDeActive()


end --func end
--next--
function TipsInfoCtrl:Update()


end --func end


--next--
function TipsInfoCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function TipsInfoCtrl:CloseUI()

	UIMgr:DeActiveUI(UI.CtrlNames.TipsInfo)
end

function TipsInfoCtrl:SetParams(params)
	self.params = params
end

function TipsInfoCtrl:CustomRefresh()
	if not self.params then
		logError("TipsInfoCtrl没有设置参数，自动关闭")
		self:CloseUI()
		return
	end

	self.panel.Tittle.LabText = self.params.title
	self.panel.Text.LabText = self.params.content

	if self.params.horizontalFit then
		self.panel.BG.Fitter.horizontalFit = self.params.horizontalFit
	end

	if self.params.relativeTransform then
		local l_bg_transform = self.panel.BG.transform
		local l_pos = CoordinateHelper.WorldPositionToLocalPosition(self.params.relativeTransform.position, l_bg_transform)

		if self.params.relativeOffsetX then
			l_pos.x = l_pos.x + self.params.relativeOffsetX
		end
		if self.params.relativeOffsetY then
			l_pos.y = l_pos.y + self.params.relativeOffsetY
		end

		l_bg_transform.anchoredPosition = l_pos
		-- MLuaCommonHelper.SetLocalPos(l_bg_transform, l_pos)
	end

	if self.params.hideTitle then
		self.panel.Tittle.gameObject:SetActiveEx(false)
	else
		self.panel.Tittle.gameObject:SetActiveEx(false)
	end

	
end

--lua custom scripts end
return TipsInfoCtrl