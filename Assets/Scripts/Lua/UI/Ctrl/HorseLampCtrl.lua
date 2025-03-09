--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HorseLampPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
HorseLampCtrl = class("HorseLampCtrl", super)
--lua class define end

--lua functions
function HorseLampCtrl:ctor()
	
	super.ctor(self, CtrlNames.HorseLamp, UILayer.Tips, nil, ActiveType.Standalone)
	
end --func end
--next--
function HorseLampCtrl:Init()
	
	self.panel = UI.HorseLampPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function HorseLampCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function HorseLampCtrl:OnActive()
	
	
end --func end
--next--
function HorseLampCtrl:OnDeActive()
	self:ResetData()
	self:StopTimer()
end --func end
--next--
function HorseLampCtrl:Update()
	self:UpdatePanel()
end --func end

--next--
function HorseLampCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
--1 显示的文字
--2 存在的时间 如果填写了圈数 那就不要填写这个存在时间
--3 速度 默认为100
--4 方向 约定0为向右 1为向左
--5 跑几圈 以时间为主 这个全是就填nil
--6 跑完的回调
local maskLength = 340
function HorseLampCtrl:ShowHorseLamp(showText,existTime,runSpeed,runDirecrt,runCircle,finishFunc)
	self.panel.HorseLampText.transform:SetLocalScale(0,0,0)
	self.panel.HorseLampText.LabText = showText
	self.textLabInfo = showText
	self.existTime = existTime or 60
	self.playTime = 0
	self.runDirect = runDirecrt or 0
	self.runSpeed = runSpeed or 100

	--圈数记录
	self.runCircle = runCircle
	self.nowRunCircle = 0 

	self.finishFunc = finishFunc
	self:StopTimer()
	self.l_time = self:NewUITimer(function()
		self.runPos = self.panel.HorseLampText.RectTransform.sizeDelta.x
		--初始化位置设置
		if runDirecrt == 0 then
			self.panel.HorseLampText.RectTransform.anchoredPosition = Vector2.New(-self.runPos/2-maskLength,0)
		else
			self.panel.HorseLampText.RectTransform.anchoredPosition = Vector2.New(self.runPos/2+maskLength,0)
		end
		self.startSet = true
		self.panel.HorseLampText.transform:SetLocalScaleOne()
	end, 0.1)
	self.l_time:Start()
end

function HorseLampCtrl:UpdatePanel( ... )
	if self.startSet then
		if self.playTime < self.existTime then
			if self.runDirect == 0 then
				if self.panel.HorseLampText.RectTransform.anchoredPosition.x > self.runPos/2+maskLength then
					--跑几圈处理
					if self.runCircle and self.runCircle > 0 then
						self.nowRunCircle = self.nowRunCircle + 1
						if self.nowRunCircle >= self.runCircle then
							if self.finishFunc then
								self.finishFunc()
							end
							UIMgr:DeActiveUI(UI.CtrlNames.HorseLamp)
							return
						end
					end
					self.panel.HorseLampText.RectTransform.anchoredPosition = Vector2.New(-self.runPos/2-maskLength,0)
				end
				self.panel.HorseLampText.RectTransform.anchoredPosition = Vector2.New(self.panel.HorseLampText.RectTransform.anchoredPosition.x + Time.deltaTime*self.runSpeed,0)
			else
				if self.panel.HorseLampText.RectTransform.anchoredPosition.x < -self.runPos/2-maskLength then
					--跑几圈处理
					if self.runCircle and self.runCircle > 0 then
						self.nowRunCircle = self.nowRunCircle + 1
						if self.nowRunCircle >= self.runCircle then
							if self.finishFunc then
								self.finishFunc()
							end
							UIMgr:DeActiveUI(UI.CtrlNames.HorseLamp)
							return
						end
					end
					self.panel.HorseLampText.RectTransform.anchoredPosition = Vector2.New(self.runPos/2+maskLength,0)
				end
				self.panel.HorseLampText.RectTransform.anchoredPosition = Vector2.New(self.panel.HorseLampText.RectTransform.anchoredPosition.x - Time.deltaTime*self.runSpeed,0)
			end
			self.playTime = self.playTime + Time.deltaTime
		else
			if self.finishFunc then
				self.finishFunc()
			end
			UIMgr:DeActiveUI(UI.CtrlNames.HorseLamp)
		end
	end
end

function HorseLampCtrl:StopTimer()
    if self.l_time then
		self:StopUITimer(self.l_time)
        self.l_time = nil
    end
end

function HorseLampCtrl:ResetData( ... )
	self.textLabInfo = ""
	self.existTime = 0
	self.runSpeed = 0
	self.finishFunc = 0
	self.startSet= false
	self.playTime = 0
	self.runPos = 0
	self.panel.HorseLampText.RectTransform.anchoredPosition = Vector2.New(0,0)
	self.panel.HorseLampText.LabText = ""
	self.runCircle = nil
	self.nowRunCircle = 0 
end
--lua custom scripts end
return HorseLampCtrl