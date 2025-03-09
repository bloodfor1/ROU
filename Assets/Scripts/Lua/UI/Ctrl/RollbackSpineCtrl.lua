--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RollbackSpinePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class RollbackSpineCtrl : UIBaseCtrl
RollbackSpineCtrl = class("RollbackSpineCtrl", super)
--lua class define end

--lua functions
function RollbackSpineCtrl:ctor()
	
	super.ctor(self, CtrlNames.RollbackSpine, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function RollbackSpineCtrl:Init()
	
	self.panel = UI.RollbackSpinePanel.Bind(self)
	super.Init(self)
	

end --func end
--next--
function RollbackSpineCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function RollbackSpineCtrl:OnActive()

	Timer.New(function()
		self:DoMove()
	end, 0.1):Start()
end --func end
--next--
function RollbackSpineCtrl:OnDeActive()
	
	if self.tweenMove then
		self.tweenMove:DOKill()
		self.tweenMove = nil
	end

	if self.tweenScaleLast then
		self.tweenScaleLast:DOKill()
		self.tweenScaleLast = nil
	end

	MgrMgr:GetMgr("TimeLimitPayMgr").IsOnOpenPanel = false
end --func end
--next--
function RollbackSpineCtrl:Update()
	
	
end --func end
--next--
function RollbackSpineCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function RollbackSpineCtrl:DoMove()

	local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")

	local l_openTable = TableUtil.GetOpenSystemTable().GetRowById(l_openSystemMgr.eSystemId.TimeLimitPay)
	if not l_openTable then
		logError("[RollbackSpineCtrl]OpenSystemTable配置问题，喵喵来了未配置")
		self:ClosePanel()
		return
	end

	local l_btn = self:GetButton(l_openSystemMgr.eSystemId.Welfare)
	if not l_btn then
		logError("[RollbackSpineCtrl]未找到对应的按钮")
		self:ClosePanel()
		return
	end	

	if not self.panel then
		return
	end

	self.tweenMove = self.panel.TweenMove.UObj:GetComponent("DOTweenAnimation")
	self.tweenMove.endValueTransform = l_btn:transform()
	self.tweenMove:CreateTween()
	self.tweenMove:DORestart()
	self.tweenMove.tween.onPlay = function()
		if not self.panel then
			return
		end
		--执行TweenScale
		self.tweenScaleLast= self.panel.TweenScale.UObj:GetComponent("DOTweenAnimation")
		self.tweenScaleLast:CreateTween()
		self.tweenScaleLast:DORestart()
		self.tweenScaleLast.tween.onComplete = function()
			self:ClosePanel()
		end
	end
end


function RollbackSpineCtrl:ClosePanel()

	MgrMgr:GetMgr("TimeLimitPayMgr").SetVisible(true)

	UIMgr:DeActiveUI(self.name)
end

function RollbackSpineCtrl:GetButton(openSystemId)
	local buttonTransform = nil
	if openSystemId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Camera then --照相
		local mainChatCtrl = UIMgr:GetOrInitUI(UI.CtrlNames.MainChat)
		buttonTransform = mainChatCtrl and mainChatCtrl:GetButton(openSystemId)
	else
		local mainCtrl = UIMgr:GetOrInitUI(UI.CtrlNames.Main)
		buttonTransform = mainCtrl and mainCtrl:GetButton(openSystemId)
	end
	return buttonTransform
end

--lua custom scripts end
return RollbackSpineCtrl