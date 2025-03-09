--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MapNamePanelPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MapNamePanelCtrl = class("MapNamePanelCtrl", super)
--lua class define end

--lua functions
function MapNamePanelCtrl:ctor()

	super.ctor(self, CtrlNames.MapNamePanel, UILayer.Normal, nil, ActiveType.Standalone)

end --func end
--next--
function MapNamePanelCtrl:Init()

	self.panel = UI.MapNamePanelPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function MapNamePanelCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function MapNamePanelCtrl:OnActive()
	local sceneTable= TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
	self.panel.MapName.LabText=sceneTable.MapEntryName

	local l_PeriodTypeName=MScene.EnvironmentMgr:GetCurPeriodTypeName()
	local l_TemperatureStateName=MScene.EnvironmentMgr:GetCurTemperatureStateName()
	local l_WeatherTypeName=MScene.EnvironmentMgr:GetCurWeatherTypeName()
	if l_PeriodTypeName==nil or l_TemperatureStateName==nil or l_WeatherTypeName==nil then
		self.panel.MapTime.LabText=""
	else
		self.panel.MapTime.LabText=string.ro_concat(l_PeriodTypeName,".", l_TemperatureStateName,".", l_WeatherTypeName)
	end

	local tweenFade= self.panel.MapName.UObj:GetComponent("DOTweenAnimation")
	tweenFade.tween.onComplete = function()
		UIMgr:DeActiveUI(UI.CtrlNames.MapNamePanel)
	end
end --func end
--next--
function MapNamePanelCtrl:OnDeActive()


end --func end
--next--
function MapNamePanelCtrl:Update()


end --func end



--next--
function MapNamePanelCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
