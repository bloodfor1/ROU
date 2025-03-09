--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FullScreenCGPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
FullScreenCGCtrl = class("FullScreenCGCtrl", super)
--lua class define end

--lua functions
function FullScreenCGCtrl:ctor()
	
	super.ctor(self, CtrlNames.FullScreenCG, UILayer.Top, nil, ActiveType.Standalone)
	self.lastBGMVol = 0
	
end --func end
--next--
function FullScreenCGCtrl:Init()
	
	self.panel = UI.FullScreenCGPanel.Bind(self)
	super.Init(self)
	
	self.panel.BtnSkip:AddClick(function()
		UIMgr:DeActiveUI(self.name)
	end)

end --func end
--next--
function FullScreenCGCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function FullScreenCGCtrl:OnActive()
    MgrMgr:GetMgr("SettingMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("SettingMgr").ENTER_CG_EVENT)

    VideoPlayerMgr:BindMediaPlayer(self.panel.MovieView.gameObject, true)

    self:Play("CG.mp4")
end --func end
--next--
function FullScreenCGCtrl:OnDeActive()
    MgrMgr:GetMgr("SettingMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("SettingMgr").EXIST_CG_EVENT)

	VideoPlayerMgr:BindMediaPlayer(self.panel.MovieView.gameObject, false)
	VideoPlayerMgr:Stop()
end --func end
--next--
function FullScreenCGCtrl:Update()
	
	
end --func end





--next--
function FullScreenCGCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

function FullScreenCGCtrl:Play(location, event)
	local l_finalVol

	local l_rootRectTran = MUIManager.RectTransformuiRoot

	local l_screenX = l_rootRectTran.sizeDelta.x * 1.0
	local l_screenY = l_rootRectTran.sizeDelta.y * 1.0
	local l_originX = self.panel.MovieView.RectTransform.sizeDelta.x * 1.0
	local l_originY = self.panel.MovieView.RectTransform.sizeDelta.y * 1.0

	local l_resultX
	local l_resultY

	-- 更宽的情况，采用屏幕宽度
	if l_screenX / l_screenY > l_originX / l_screenY then
		l_resultX = l_screenX
		l_resultY = l_screenX / l_originX * l_originY
	else
		l_resultY = l_screenY
		l_resultX = l_screenY / l_originY * l_originX
	end

	self.panel.MovieView.RectTransform.sizeDelta.x = l_resultX
	self.panel.MovieView.RectTransform.sizeDelta.y = l_resultY

	local l_endFunc = function()
		UIMgr:DeActiveUI(self.name)
	end

	if not VideoPlayerMgr:Prepare(location, true, nil, nil, l_endFunc) then
		UIMgr:DeActiveUI(self.name)
		return
	end
end

--lua custom scripts end
return FullScreenCGCtrl