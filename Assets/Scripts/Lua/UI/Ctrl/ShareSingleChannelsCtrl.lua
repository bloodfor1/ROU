--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ShareSingleChannelsPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
ShareSingleChannelsCtrl = class("ShareSingleChannelsCtrl", super)
--lua class define end

local Mgr = MgrMgr:GetMgr("ShareMgr")
--lua functions
function ShareSingleChannelsCtrl:ctor()
	
	super.ctor(self, CtrlNames.ShareSingleChannels, UILayer.Top, nil, ActiveType.Exclusive)
end --func end
--next--
function ShareSingleChannelsCtrl:Init()
	
	self.panel = UI.ShareSingleChannelsPanel.Bind(self)
	super.Init(self)
	self:Bind()
	
end --func end

--next--
function ShareSingleChannelsCtrl:Bind()
	self.panel.Close:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.ShareSingleChannels)
	end)
	self.panel.Facebook:AddClick(function()
		Mgr.SendFacebook(Mgr.ShareStyle.Link,self.rowdata.ShareLink,self.rowdata.ShareId,function()

		end)
	end)
	self.panel.Kakaotalk:AddClick(function()
		Mgr.SendKakao(Mgr.ShareStyle.Link,self.rowdata.ShareLink,self.rowdata.ShareId,function()

		end)
	end)
end--func end

--next--
function ShareSingleChannelsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ShareSingleChannelsCtrl:OnActive()
	for i = 0, self.panel.PanelRef.Canvases.Length -1 do
		self.panel.PanelRef.Canvases[i].gameObject.layer = MLayer.ID_CutSceneUI
	end
	self.panel.Facebook.gameObject:SetActive(Mgr.ShareSDKFBIsOn)
	self.panel.Kakaotalk.gameObject:SetActive(Mgr.ShareSDKKaKaoIsOn)
	--self.panelMask.gameObject.layer = MLayer.ID_CutSceneUI
end --func end

function ShareSingleChannelsCtrl:SetShareInfo(shareid,Model,type,paramID)
	local row = TableUtil.GetShareTable().GetRowByShareId(shareid,false)
	self.sharetype = type
	self.rowdata = row
end
--next--
function ShareSingleChannelsCtrl:OnDeActive()
	Timer.New(function()
		MCutSceneMgr:Resume()
	end, 0.1):Start()
	
end --func end
--next--
function ShareSingleChannelsCtrl:Update()
	
	
end --func end
--next--
function ShareSingleChannelsCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ShareSingleChannelsCtrl