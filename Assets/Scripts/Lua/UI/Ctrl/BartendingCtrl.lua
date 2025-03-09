--this file is gen by script
--you can edit this file in custom part


--lua requires
require "SmallGames/SGameUIBase"
require "UI/Panel/BartendingPanel"
require "SmallGames/SGameDefine"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = SGame.SGameUIBase
--next--
--lua fields end

--lua class define
BartendingCtrl = class("BartendingCtrl", super)
--lua class define end

--lua functions
function BartendingCtrl:ctor()
	
	super.ctor(self, CtrlNames.Bartending, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function BartendingCtrl:Init()

	self.panel = UI.BartendingPanel.Bind(self)
	super.Init(self)
	self.LiqOpenCapID=0
	self.LiqPourWineID=0
	self.BlueOpenCapID=0
	self.BluePourWineID=0
	self.ShakeBottleID=0
	self.WinLightID=0
	self:RegisteOperableObject("Liqueur",self.panel.Liqueur)
	self:RegisteOperableObject("ShakeGlass",self.panel.ShakeGlass)
	self:RegisteOperableObject("BlueberryJuice",self.panel.BlueberryJuice)

	self:RegisteOperableObject("Bar",self.panel.Bar)
	self:RegisteOperableObject("Shake",self.panel.Shake)
	self:RegisteOperableObject("SliderHp",self.panel.SliderHp)
	self:RegisteOperableObject("Complete",self.panel.Complete)
	self:RegisteOperableObject("ShakeBottle",self.panel.ShakeBottle)

	self:RegisteOperableObject("GuideArrow",self.panel.GuideArrow)
	self:RegisteOperableObject("GuideArrow2",self.panel.GuideArrow2)
	self:RegisteOperableObject("GuideArrow3",self.panel.GuideArrow3)
	self:RegisteOperableObject("GuideArrow4",self.panel.GuideArrow4)

	self:RegisteOperableObject("BlueOpenCap",self.panel.BlueOpenCap)
	self:RegisteOperableObject("LiqueurOpenCap",self.panel.LiqueurOpenCap)

	self.panel.Liqueur.Listener.onDown=function(uobj,event)
		self:ExecuteOneStep("Liqueur")
	end
	self.panel.Liqueur.Listener.beginDrag=function(uobj,event)  --需要传递拖拽QTE的对象实现
		self:DeliverEvent(event,SGame.EventDeliverType.BeginDrag)
	end
	self.panel.Liqueur.Listener.onDrag=function(uobj,event)
		self:DeliverEvent(event,SGame.EventDeliverType.Drag)
	end
	self.panel.Liqueur.Listener.endDrag=function(uobj,event)
		self:DeliverEvent(event,SGame.EventDeliverType.EndDrag)
	end

	self.panel.ShakeGlass.Listener.onDown=function(uobj,event)
		self:ExecuteOneStep("ShakeGlass")
	end
	self.panel.ShakeGlass.Listener.beginDrag=function(uobj,event)  --需要传递拖拽QTE的对象实现
		self:DeliverEvent(event,SGame.EventDeliverType.BeginDrag)
	end
	self.panel.ShakeGlass.Listener.onDrag=function(uobj,event)
		self:DeliverEvent(event,SGame.EventDeliverType.Drag)
	end
	self.panel.ShakeGlass.Listener.endDrag=function(uobj,event)
		self:DeliverEvent(event,SGame.EventDeliverType.EndDrag)
	end

	self.panel.BlueberryJuice.Listener.onDown=function(uobj,event)
		self:ExecuteOneStep("BlueberryJuice")
	end
	self.panel.BlueberryJuice.Listener.beginDrag=function(uobj,event)  --需要传递拖拽QTE的对象实现
		self:DeliverEvent(event,SGame.EventDeliverType.BeginDrag)
	end
	self.panel.BlueberryJuice.Listener.onDrag=function(uobj,event)
		self:DeliverEvent(event,SGame.EventDeliverType.Drag)
	end
	self.panel.BlueberryJuice.Listener.endDrag=function(uobj,event)
		self:DeliverEvent(event,SGame.EventDeliverType.EndDrag)
	end
	self.panel.BtnClose:AddClick(function()
		self:CloseSmallGame()
	end)
end --func end
--next--
function BartendingCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BartendingCtrl:OnActive()
	local l_anim = self.panel.StartAnim:GetComponent("DOTweenAnimation")
	l_anim:DOPlay()
end --func end
--next--
function BartendingCtrl:OnDeActive()
	self:DestroyEffect()
	self:CloseSmallGame()
end --func end
--next--
function BartendingCtrl:Update()
	
	
end --func end





--next--
function BartendingCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function BartendingCtrl:ShowEffect(effectName)
	local l_fxData = {}
	if "LiqueurOpenCap"==effectName then
		if self.LiqOpenCapID and self.LiqOpenCapID > 0 then
			self:DestroyUIEffect(self.LiqOpenCapID)
			self.LiqOpenCapID = 0
		end
		l_fxData.rawImage = self.panel.LiqueurOpenCap.RawImg
		l_fxData.destroyHandler = function()
			self.LiqOpenCapID = 0
		end
		l_fxData.scaleFac = Vector3.New(0.9,0.9,0.9)
		self.LiqOpenCapID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_LangMuJiu_01", l_fxData)
	elseif "LiqueurPourWine"==effectName then
		if self.LiqPourWineID and self.LiqPourWineID > 0 then
			self:DestroyUIEffect(self.LiqPourWineID)
			self.LiqPourWineID = 0
		end
		l_fxData.rawImage = self.panel.LiqueurPourWine.RawImg
		l_fxData.destroyHandler = function()
			self.LiqPourWineID = 0
		end
		l_fxData.scaleFac = Vector3.New(2,1,1)
		self.LiqPourWineID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_DaoJiu_01", l_fxData)
	elseif "BluePourWine"==effectName then
		if self.BluePourWineID and self.BluePourWineID > 0 then
			self:DestroyUIEffect(self.BluePourWineID)
			self.BluePourWineID = 0
		end
		l_fxData.rawImage = self.panel.BluePourWine.RawImg
		l_fxData.destroyHandler = function()
			self.BluePourWineID=0
		end
		l_fxData.scaleFac = Vector3.New(2,1,1)
		self.BluePourWineID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_DaoJiu_02", l_fxData)
	elseif "BlueOpenCap"==effectName then
		if self.BlueOpenCapID and self.BlueOpenCapID > 0 then
			self:DestroyUIEffect(self.BlueOpenCapID)
			self.BlueOpenCapID = 0
		end
		l_fxData.rawImage = self.panel.BlueOpenCap.RawImg
		l_fxData.destroyHandler = function()
			self.BlueOpenCapID=0
		end
		l_fxData.scaleFac = Vector3.New(0.86,0.86,0.86)
		self.BlueOpenCapID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_LangMuJiu_02", l_fxData)
	elseif "ShakeBottle"==effectName then
		if self.ShakeBottleID and self.ShakeBottleID > 0 then
			self:DestroyUIEffect(self.ShakeBottleID)
			self.ShakeBottleID = 0
		end
		l_fxData.rawImage = self.panel.ShakeBottle.RawImg
		l_fxData.destroyHandler = function()
			self.ShakeBottleID=0
		end
		l_fxData.scaleFac = Vector3.New(0.94,0.94,0.94)
		self.ShakeBottleID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_TiaoJiuPing_01", l_fxData)
	elseif "WinLightEffect"==effectName then
		if self.WinLightID and self.WinLightID > 0 then
			self:DestroyUIEffect(self.WinLightID)
			self.WinLightID = 0
		end
		l_fxData.rawImage = self.panel.WinLightEffect.RawImg
		l_fxData.destroyHandler = function()
			self.WinLightID=0
		end
		l_fxData.scaleFac = Vector3.New(1,1,1)
		l_fxData.position = Vector3.New(0, -3.2, 0)
		self.WinLightID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_MedalGlow_01", l_fxData)
	else
		logError("试图播放不存在的特效！"..tostring(effectName))
	end
	
end

function BartendingCtrl:DestroyEffect()
	if self.LiqOpenCapID and self.LiqOpenCapID>0 then
		self:DestroyUIEffect(self.LiqOpenCapID)
		self.LiqOpenCapID=0
	end
	if self.LiqPourWineID and self.LiqPourWineID>0 then
		self:DestroyUIEffect(self.LiqPourWineID)
		self.LiqPourWineID=0
	end
	if self.BlueOpenCapID and self.BlueOpenCapID>0 then
		self:DestroyUIEffect(self.BlueOpenCapID)
		self.BlueOpenCapID=0
	end
	if self.BluePourWineID and self.BluePourWineID>0 then
		self:DestroyUIEffect(self.BluePourWineID)
		self.BluePourWineID=0
	end
	if self.ShakeBottleID and self.ShakeBottleID>0 then
		self:DestroyUIEffect(self.ShakeBottleID)
		self.ShakeBottleID=0
	end
	if self.WinLightID and self.WinLightID>0 then
		self:DestroyUIEffect(self.WinLightID)
		self.WinLightID=0
	end
end
function BartendingCtrl:NoticeShowEffect(effectName,showState)
	if not showState then
		return
	end
	self:ShowEffect(effectName)
end
--lua custom scripts end
return BartendingCtrl