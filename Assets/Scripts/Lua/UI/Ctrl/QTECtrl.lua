--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/QTEPanel"
require "SmallGames/SGameDefine"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
QTECtrl = class("QTECtrl", super)
--lua class define end

--lua functions
function QTECtrl:ctor()
	
	super.ctor(self, CtrlNames.QTE, UILayer.Function, nil, ActiveType.Standalone)
	self.currentQTE=nil;
	self.qteTable={};
	self.qteCallBack=nil;
end --func end
--next--

function QTECtrl:Init()
	self.currentQTE=nil;
	self.qteCallBack=nil;

	self.panel = UI.QTEPanel.Bind(self)
	super.Init(self)

	self.panel.EventButton.Listener.onClick=function(uobj,event)
		if self.currentQTE~=nil then
			self.currentQTE:OnClick(uobj,event);
		end
	end
	self.panel.EventButton.Listener.beginDrag=function(uobj,event)
		if self.currentQTE~=nil then
			self.currentQTE:OnBeginDrag(uobj,event);
		end
	end
	self.panel.EventButton.Listener.onDrag=function(uobj,event)
		if self.currentQTE~=nil then
			self.currentQTE:OnDrag(uobj,event);
		end
	end
	self.panel.EventButton.Listener.endDrag=function(uobj,event)
		if self.currentQTE~=nil then
			self.currentQTE:OnEndDrag(uobj,event);
		end
	end
end --func end

function QTECtrl:ExecuteQTE(qteType,argData,qteCallBack)
	if self.currentQTE~=nil then
		logError("当前存在正在进行中的QTE！");
		return;
	end
	self.currentQTE=self.qteTable[qteType];
	self.qteCallBack=qteCallBack;
	local l_argData=nil;
	if self.currentQTE~=nil then
		l_argData=self.currentQTE:ParseArg(argData);
		self.currentQTE:Init(l_argData);
		return;
	end
	if qteType==SGame.QTEType.Drag_QTE then
		require "SmallGames/QTEOperates/DragQTE"
		self.currentQTE=SGame.DragQTE.new(self);
		self.qteTable[qteType]=self.currentQTE;
	elseif qteType==SGame.QTEType.Rotate_QTE then
		require "SmallGames/QTEOperates/RotateQTE"
		self.currentQTE=SGame.RotateQTE.new(self);
		self.qteTable[qteType]=self.currentQTE;
	elseif qteType==SGame.QTEType.Shake_QTE then
		require "SmallGames/QTEOperates/ShakeQTE"
		self.currentQTE=SGame.ShakeQTE.new(self);
		self.qteTable[qteType]=self.currentQTE;
	elseif qteType==SGame.QTEType.Click_QTE then
		require "SmallGames/QTEOperates/ClickQTE"
		self.currentQTE=SGame.ClickQTE.new(self);
		self.qteTable[qteType]=self.currentQTE;
	else
		logError("QTECtrl:ExecuteQTE error!QTEType:"..tostring(qteType));
		return;
	end
	l_argData=self.currentQTE:ParseArg(argData);
	self.currentQTE:Init(l_argData);
end
function QTECtrl:NotifyShake(shakeDegree)
	if self.currentQTE==nil then
		return;
	end
	self.currentQTE:NotifyShakeDegree(shakeDegree)
end
function QTECtrl:SendResultInfo(data)
	local l_qteCallBack=self.qteCallBack

	if data.finished then
		if self.currentQTE~=nil then
			self.currentQTE:Clear();
			self.currentQTE=nil;
		end
		MgrMgr:GetMgr("SmallGameMgr"):CloseQTE();
	end
	if l_qteCallBack~=nil then
		l_qteCallBack(data);
	end
end
--next--
function QTECtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function QTECtrl:OnActive()
	
	
end --func end
--next--
function QTECtrl:OnDeActive()
	if self.currentQTE~=nil then
		self.currentQTE:Clear();
		self.currentQTE=nil;
	end
	self.qteCallBack=nil;
	
end --func end
--next--
function QTECtrl:Update()
	
	
end --func end





--next--
function QTECtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function QTECtrl:EventDeliver(event,eventType)  --QTE模块独立化代价，对于某些需要立即响应的需求(如拖拽)需要传递
	if not self:IsShowing() then
		return;
	end
	if SGame.EventDeliverType.BeginDrag==eventType then
		MLuaCommonHelper.ExecuteBeginDragEvent(self.panel.EventButton.UObj,event);
	elseif SGame.EventDeliverType.Drag==eventType then
		MLuaCommonHelper.ExecuteDragEvent(self.panel.EventButton.UObj,event);
	elseif SGame.EventDeliverType.EndDrag==eventType then
		MLuaCommonHelper.ExecuteEndDragEvent(self.panel.EventButton.UObj,event);
	else
		logError("QTECtrl:EventDeliver error:not support "..tostring(eventType))
	end

end
--lua custom scripts end
return QTECtrl