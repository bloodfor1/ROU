--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MarkTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MarkTipsCtrl = class("MarkTipsCtrl", super)
--lua class define end

--lua functions
function MarkTipsCtrl:ctor()
	super.ctor(self, CtrlNames.MarkTips, UILayer.Tips, nil, ActiveType.Standalone)
	self.IsCloseOnSwitchScene = true
end --func end
--next--
function MarkTipsCtrl:Init()
	
	self.panel = UI.MarkTipsPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function MarkTipsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MarkTipsCtrl:OnActive()
	
	
end --func end
--next--
function MarkTipsCtrl:OnDeActive()
	
	
end --func end
--next--
function MarkTipsCtrl:Update()
	
	
end --func end





--next--
function MarkTipsCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function MarkTipsCtrl:SetMarkTips( title,infoText,eventData,pivot,pressCamera,isPassThrouth)
	self.panel.Parent.gameObject:SetActiveEx(false)
    self.panel.CloseBtn.Listener.onClick=function(obj,data)
		UIMgr:DeActiveUI(UI.CtrlNames.MarkTips)
		if isPassThrouth then
			MLuaClientHelper.ExecuteClickEvents(data.position,UI.CtrlNames.MarkTips)
		end
    end
	self.panel.TittleTxt.LabText = title or ""
	self.panel.InfoText.LabText = infoText or ""
    if eventData then
        pressCamera = pressCamera
        local ret, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.Parent.RectTransform, eventData.position, pressCamera, nil)
        if ret and pos then
            self.panel.Parent.RectTransform.anchoredPosition = self:GetPos(pos)
            self.panel.Parent.RectTransform.pivot = pivot or Vector2(0.5, 0)
        end
	end
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Parent.RectTransform)
	self.panel.Parent.gameObject:SetActiveEx(true)
end

function MarkTipsCtrl:GetPos(targetPos)
	local screenSize = MUIManager:GetCanvasScalerReferenceResolution()
	local xPos = targetPos.x
	local yPos = targetPos.y
	local finX = targetPos.x
	local finY = targetPos.y
	local halfX = 640/2
	local halfY = 1136/2
	if xPos > halfX then
		finX = halfX - 10
	end
	if xPos < -halfX then
		finX = -halfX + 10
	end
	if yPos > halfY then
		finY = yPos - 10
	end
	if yPos < -halfY then
		finY = -yPos + 10
	end
	return Vector2(finX,finY)
end

--lua custom scripts end
return MarkTipsCtrl