--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RateAppPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
RateAppCtrl = class("RateAppCtrl", super)
--lua class define end

local l_gameRateTitle = Common.Utils.Lang(MGlobalConfig:GetString("GameRateTitle"))
local l_gameRateContent=Common.Utils.Lang(MGlobalConfig:GetString("GameRateContent"))
local l_gameRateButtonNow=Common.Utils.Lang(MGlobalConfig:GetString("GameRateButtonNow"))
local l_gameRateButtonNot=Common.Utils.Lang(MGlobalConfig:GetString("GameRateButtonNot"))
local l_gameRateAppThanksForYourComment=Common.Utils.Lang("RateAPP_ThanksForYourComment")
local l_gameRateBgImg=MGlobalConfig:GetString("GameRateBGImg")
local l_gameRateGoogleUrl=MGlobalConfig:GetString("GameRateGoogleUrl")
local l_gameRateAppleUrl=MGlobalConfig:GetString("GameRateAppleUrl")
--lua functions
function RateAppCtrl:ctor()
	
	super.ctor(self, CtrlNames.RateApp, UILayer.Function, nil, ActiveType.Normal)
	
end --func end
--next--
function RateAppCtrl:Init()
	
	self.panel = UI.RateAppPanel.Bind(self)
	super.Init(self)
	self.panel.BtnRateNow:AddClick(function()
		if MGameContext.IsIOS then
			Application.OpenURL(l_gameRateAppleUrl)
		elseif MGameContext.IsAndroid then
			Application.OpenURL(l_gameRateGoogleUrl)
		elseif MGameContext.IsUnityEditorOrPC then
			Application.OpenURL(l_gameRateAppleUrl)
			Application.OpenURL(l_gameRateGoogleUrl)
		end
	        UIMgr:DeActiveUI(self.name)
			--感谢评价消息
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_gameRateAppThanksForYourComment)
			--关闭界面事件
			MgrMgr:GetMgr("RateAppMgr").OnRateDialogClose()
	    end)
	self.panel.BtnNoRate:AddClick(function()
	        UIMgr:DeActiveUI(self.name)
			--关闭界面事件
			MgrMgr:GetMgr("RateAppMgr").OnRateDialogClose()
	    end)
end --func end
--next--
function RateAppCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function RateAppCtrl:OnActive()
	local l_id=self.uiPanelData.rowId
	local l_specialMessage=self.uiPanelData.specialMessage
	self:SetRateContent(l_id,l_specialMessage)
end --func end

function RateAppCtrl:SetRateContent(id,message)
	local l_isRated=MgrMgr:GetMgr("RateAppMgr").IsRated()
	if l_isRated then
        UIMgr:DeActiveUI(self.name)
        return
    end
	local l_message=nil
	--如果存在特殊消息,优先显示消息
	if message~=nil then
		l_message=Common.Utils.Lang(message)
	elseif id~=nil then
		local l_data=TableUtil.GetRateApp().GetRowByID(id)
		if l_data==nil then
			logError("RateApp does not contain id={0}",id)
			UIMgr:DeActiveUI(self.name)
			return
		end
		l_message=Common.Utils.Lang(l_data.Message)
	else 
		logError("参数 id 和 message 不能都为空")
		UIMgr:DeActiveUI(self.name)
		return
	end
	--后续可能需要设置背景图片
	--local l_rateBgImgPath=""
	--self.panel.BGImg:SetRawTex(l_rateBgImgPath,false)
	self.panel.Title.LabText = l_gameRateTitle
	self.panel.Message.LabText=l_message
	self.panel.Content.LabText=l_gameRateContent
	self.panel.TextRateNow.LabText=l_gameRateButtonNow
	self.panel.TextNoRate.LabText=l_gameRateButtonNot
end

--next--
function RateAppCtrl:OnDeActive()
	
end --func end


--next--
function RateAppCtrl:Update()
	
	
end --func end
--next--
function RateAppCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RateAppCtrl