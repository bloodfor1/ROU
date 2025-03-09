--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CommonShowOpenItemPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CommonShowOpenItemCtrl = class("CommonShowOpenItemCtrl", super)
--lua class define end

--lua functions
function CommonShowOpenItemCtrl:ctor()

	super.ctor(self, CtrlNames.CommonShowOpenItem, UILayer.Function, nil, ActiveType.Standalone)
	self.showActionQueue = Common.ActionQueue.new()
	self.currentCoroutineTimer = nil
	self.currentActionQueue = nil
	self.canClose = true
	self.showObj = nil
	self.callbackList = {}
end --func end
--next--
function CommonShowOpenItemCtrl:Init()

	self.panel = UI.CommonShowOpenItemPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function CommonShowOpenItemCtrl:Uninit()

	self.showActionQueue:Clear()
	if self.currentCoroutineTimer ~= nil then
		self:StopUITimer(self.currentCoroutineTimer)
		self.currentCoroutineTimer = nil
	end
	self.currentActionQueue = nil

	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function CommonShowOpenItemCtrl:OnActive()

	self.canClose = true
	self.panel.SkipButton:AddClick(function()
		if self.canClose == false then
		 	return
		end
		if self.currentActionQueue ~= nil then
			self.currentActionQueue:Clear()
		else
			UIMgr:DeActiveUI(UI.CtrlNames.CommonShowOpenItem)
		end

	end)

end --func end
--next--
function CommonShowOpenItemCtrl:OnDeActive()
	if self.showObj ~= nil then
		MResLoader:DestroyObj(self.showObj)
		self.showObj = nil
	end
	self.canClose = true

	for _,callback in ipairs(self.callbackList) do
		if callback ~= nil then
			callback()
		end
	end

	self.callbackList = {}
end --func end
--next--
function CommonShowOpenItemCtrl:Update()


end --func end



--next--
function CommonShowOpenItemCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--obj 你想用的对象
--targetPos 飞向的目标地点 可空
--clone 是否复制该对象 可空 默认为true
--onStart 每个显示之前的行为
--onEnd 每个显示之后的行为
--onCallback 所有播放完毕的行为
function CommonShowOpenItemCtrl:ShowWithObject(obj, targetPos, clone, onStart, onEnd, onCallback)
	if clone == nil then
	 	clone = true
	end
	self.showActionQueue:AddAciton(function (cb)

		if self.showObj ~= nil then
			MResLoader:DestroyObj(self.showObj)
			self.showObj = nil
		end

		local l_customData = onStart()
		self:DoShowWithObject(obj, targetPos, clone, function()
			if onEnd ~= nil then
				onEnd(l_customData)
			end
			cb()
		end)
	end)
	self.callbackList[#self.callbackList+1] = onCallback
end

function CommonShowOpenItemCtrl:DoShowWithObject(obj, targetPos, clone, callback)

	if clone == nil then
		clone = true
	end

	self.canClose = false
	local actionQueue =  Common.ActionQueue.new()
	self.currentActionQueue = actionQueue

	self.showObj = obj
	if clone then
		self.showObj = self:CloneObj(obj)
	end

	self.showObj.transform:SetParent(self.panel.ObjectContainer.transform)
	self.showObj.transform:SetLocalPosZero()
	self.showObj.transform:SetLocalScale(0, 0, 0)
	actionQueue:SetCallback(function()
		if self:IsShowing() and self.showActionQueue:IsEmpty() then
			UIMgr:DeActiveUI(UI.CtrlNames.CommonShowOpenItem)
		end
		if not MLuaCommonHelper.IsNull(self.showObj) then
			MResLoader:DestroyObj(self.showObj)
			self.showObj = nil
		end
		callback()
	end)


	actionQueue:AddAciton(function(cb)
		if not MLuaCommonHelper.IsNull(self.showObj) then
			self.showObj.transform:DOScale(Vector3.New(1, 1, 1), 0.5):OnComplete(function()
				cb()
			end)
		end
	end, function()
		if not MLuaCommonHelper.IsNull(self.showObj) then
			MResLoader:DestroyObj(self.showObj)
			self.showObj = nil
		end
	end):AddAciton(function(cb)
		if self.currentCoroutineTimer ~= nil then
			self:StopUITimer(self.currentCoroutineTimer)
			self.currentCoroutineTimer = nil
		end
		self.currentCoroutineTimer = self:NewUITimer(function()
			cb()
			self.currentCoroutineTimer = nil
		end, 1)
		self.currentCoroutineTimer:Start()
		self.canClose = true
	end, function()
		if self.currentCoroutineTimer ~= nil then
			self:StopUITimer(self.currentCoroutineTimer)
			self.currentCoroutineTimer = nil
		end
		self.canClose = true
	end)

	if targetPos ~= nil then
		actionQueue:AddAciton(function(cb)
			if not MLuaCommonHelper.IsNull(self.showObj) then
				self.showObj.transform:DOScale(Vector3.New(1.2, 1.2, 1.2), 0.3)
				self.showObj.transform:DOMove(targetPos, 0.5):OnComplete(function()
					cb()
				end)
			end
		end, function()
			if not MLuaCommonHelper.IsNull(self.showObj) then
				MResLoader:DestroyObj(self.showObj)
				self.showObj = nil
			end
		end):AddAciton(function(cb)
			if not MLuaCommonHelper.IsNull(self.showObj) then
				self.showObj.transform:DOScale(Vector3.New(1, 1, 1), 0.1):OnComplete(function()
					cb()
				end)
			end
		end, function()
			if not MLuaCommonHelper.IsNull(self.showObj) then
				MResLoader:DestroyObj(self.showObj)
				self.showObj = nil
			end
		end)
	end

	actionQueue:AddAciton(function(cb)
		if self.currentCoroutineTimer ~= nil then
			self:StopUITimer(self.currentCoroutineTimer)
			self.currentCoroutineTimer = nil
		end
		self.currentCoroutineTimer = self:NewUITimer(function()
			cb()
			self.currentCoroutineTimer = nil
		end, 1)
		self.currentCoroutineTimer:Start()
	end, function()
		if self.currentCoroutineTimer ~= nil then
			self:StopUITimer(self.currentCoroutineTimer)
			self.currentCoroutineTimer = nil
		end
	end)

end

--lua custom scripts end
