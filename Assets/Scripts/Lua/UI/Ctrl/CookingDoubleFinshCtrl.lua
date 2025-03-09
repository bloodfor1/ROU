--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CookingDoubleFinshPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CookingDoubleFinshCtrl = class("CookingDoubleFinshCtrl", super)
--lua class define end

--lua functions
function CookingDoubleFinshCtrl:ctor()

	super.ctor(self, CtrlNames.CookingDoubleFinsh, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function CookingDoubleFinshCtrl:Init()

	self.awardObjs = nil
	self.panel = UI.CookingDoubleFinshPanel.Bind(self)
	super.Init(self)
	self.panel.BtnConfirm:AddClick(function ()
		local l_msgId = Network.Define.Ptc.LeaveSceneReq
		---@type NullArg
		local l_sendInfo = GetProtoBufSendTable("NullArg")
	    Network.Handler.SendPtc(l_msgId, l_sendInfo)
	end)

end --func end
--next--
function CookingDoubleFinshCtrl:Uninit()

	self.finishedCount = 0
	self.failedCount = 0
	self.finishScore = 0
	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function CookingDoubleFinshCtrl:OnActive()

	self.panel.TxtFinished.LabText = tostring(self.finishedCount)
	self.panel.Txt_finishScore.LabText = tostring(self.finishScore)
	self.panel.TxtFailed.LabText = tostring(self.failedCount)
	if self.success then
		self.panel.ImgTitle:SetSprite("FontSprite", "UI_Cooking_SuccessfuL.png", true)
	else
		self.panel.ImgTitle:SetSprite("FontSprite", "UI_Cooking_Failed.png", true)
	end

	MgrMgr:GetMgr("CookingDoubleMgr").ShowCachedNotices()
end --func end
--next--
function CookingDoubleFinshCtrl:OnDeActive()

end --func end
--next--
function CookingDoubleFinshCtrl:Update()


end --func end



--next--
function CookingDoubleFinshCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function CookingDoubleFinshCtrl:SetFinishedData(finishedCount, finishScore,failedCount, success)
	self.success = success
	self.finishedCount = finishedCount
	self.failedCount = failedCount
	self.finishScore = finishScore
	if self.panel ~= nil then
		self.panel.TxtFinished.LabText = tostring(finishedCount)
		self.panel.Txt_finishScore.LabText = tostring(finishScore)
		self.panel.TxtFailed.LabText = tostring(failedCount)

		if success then
			self.panel.ImgTitle:SetSprite("Cooking", "UI_Cooking_SuccessfuL.png", true)
		else
			self.panel.ImgTitle:SetSprite("Cooking", "UI_Cooking_Failed.png", true)
		end
	end
end

--lua custom scripts end
