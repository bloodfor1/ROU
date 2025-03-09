--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ExplainPanelTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ExplainPanelTipsCtrl = class("ExplainPanelTipsCtrl", super)

---@class ExplainPanel
---@field obj UnityEngine.GameObject
---@field btnClose MoonClient.MLuaUICom
---@field content MoonClient.UIRichText
---@field background UnityEngine.RectTransform
---@field layout UnityEngine.VerticalLayoutGroup
---@field layout_trans UnityEngine.RectTransform
--lua class define end

--lua functions
function ExplainPanelTipsCtrl:ctor()

	super.ctor(self, CtrlNames.ExplainPanelTips, UILayer.Function, nil, ActiveType.Standalone)

	self.overrideSortLayer = UILayerSort.Function + 2

end --func end
--next--
function ExplainPanelTipsCtrl:Init()

	self.panel = UI.ExplainPanelTipsPanel.Bind(self)
	super.Init(self)

	---@type ExplainPanel
	self.explain_panel = {}
	self.cacheConfig = {}

    --面板是否加载完成
    self.isExplainPanelLoaded = false

	self.loadTaskId =  MResLoader:CreateObjAsync("UI/Prefabs/ExplainPanel", function(uobj, sobj, taskId)
        self.isExplainPanelLoaded = true

        self.loadTaskId = 0

		self.explain_panel.obj = uobj
		local l_transform = self.explain_panel.obj.transform
	    l_transform:SetParent(self.uObj.transform)
		MLuaCommonHelper.SetLocalPos(self.explain_panel.obj, 0, 0, 0)
		MLuaCommonHelper.SetLocalRot(self.explain_panel.obj, 0, 0, 0, 0)
		MLuaCommonHelper.SetLocalScale(self.explain_panel.obj, 1, 1, 1)

		self.explain_panel.btnClose = l_transform:Find("CloseExplainPanelButton"):GetComponent("MLuaUICom")
		self.explain_panel.content = l_transform:Find("Bubble/backgroud/TextMessage"):GetComponent("UIRichText")
		self.explain_panel.background = l_transform:Find("Bubble/backgroud"):GetComponent("RectTransform")
		self.explain_panel.layout = l_transform:Find("Bubble"):GetComponent("VerticalLayoutGroup")
		self.explain_panel.layout_trans = l_transform:Find("Bubble"):GetComponent("RectTransform")

		if self.cacheConfig.content then
			MLuaClientHelper.GetOrCreateMLuaUICom(self.explain_panel.content.gameObject).LabText = self.cacheConfig.content
		end

		if self.cacheConfig.alignment then
			self.explain_panel.layout.childAlignment = self.cacheConfig.alignment
		end

		if self.cacheConfig.x and self.cacheConfig.y then
			self.explain_panel.layout_trans.anchoredPosition = Vector3.New(self.cacheConfig.x, self.cacheConfig.y, 0)
		end

		if self.cacheConfig.width then
			self.explain_panel.layout_trans.sizeDelta = Vector2.New(self.cacheConfig.width, 205)
		end

		self.explain_panel.btnClose:AddClick(function()
			UIMgr:DeActiveUI(CtrlNames.ExplainPanelTips)
		end)

        if self.cacheParams then
            self:SetInfo(self.cacheParams)
            self.cacheParams = nil
        end
    end, self)
end --func end
--next--
function ExplainPanelTipsCtrl:Uninit()
	if self.explain_panel then
		MResLoader:DestroyObj(self.explain_panel.obj)
	end
	if self.loadTaskId ~= 0 then
        MResLoader:CancelAsyncTask(self.loadTaskId)
        self.loadTaskId = 0
	end
	self.explain_panel = nil

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function ExplainPanelTipsCtrl:OnActive()


end --func end
--next--
function ExplainPanelTipsCtrl:OnDeActive()


end --func end
--next--
function ExplainPanelTipsCtrl:Update()


end --func end



--next--
function ExplainPanelTipsCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function ExplainPanelTipsCtrl:SetContent(content)

	if not self.explain_panel.content then
		self.cacheConfig.content = content
	else
		MLuaClientHelper.GetOrCreateMLuaUICom(self.explain_panel.content.gameObject).LabText = content
	end
end

function ExplainPanelTipsCtrl:SetAlignment(alignment)

	if not self.explain_panel.layout then
		self.cacheConfig.alignment = alignment
	else
		self.explain_panel.layout.childAlignment = alignment
	end
end

function ExplainPanelTipsCtrl:SetPosition(x, y)

	if not self.explain_panel.layout_trans then
		self.cacheConfig.x = x
		self.cacheConfig.y = y
	else
		self.explain_panel.layout_trans.anchoredPosition = Vector3.New(x, y, 0)
	end
end

function ExplainPanelTipsCtrl:SetWidth(width)

	if not self.explain_panel.layout_trans then
		self.cacheConfig.width = width
	else
		self.explain_panel.layout_trans.sizeDelta = Vector2.New(width, 205)
	end
end

function ExplainPanelTipsCtrl:SetInfo(params)
    if not self.isExplainPanelLoaded then
        self.cacheParams = params
        return
    end
    if params.content then
        MLuaClientHelper.GetOrCreateMLuaUICom(self.explain_panel.content.gameObject).LabText = params.content
		if params.fontSize then
			self.explain_panel.content.fontSize = params.fontSize
		end
    end
	if params.overideSort then
		self:SetOverrideSortLayer(params.overideSort)
	end

	local l_anchoreMin = Vector2.New(0,0)
	local l_anchoreMax = Vector2.New(0,0)
	if params.anchoreMin and params.anchoreMax then
		l_anchoreMin.x = params.anchoreMin.x
		l_anchoreMin.y = params.anchoreMin.y
		l_anchoreMax.x = params.anchoreMax.x
		l_anchoreMax.y = params.anchoreMax.y
	end
	self.explain_panel.layout_trans.anchorMin = l_anchoreMin
	self.explain_panel.layout_trans.anchorMax = l_anchoreMax

	if params.pivot then
		self.explain_panel.layout_trans.pivot = params.pivot
	else
		self.explain_panel.layout_trans.pivot = Vector2.New(0.5,0.5)
	end
	--内容是否为向下自适应大小（默认向上）
	if params.downwardAdapt then
		self.explain_panel.background.pivot = Vector2.New(0.5,1)
	else
		self.explain_panel.background.pivot = Vector2.New(0.5,0)
	end

    if params.pos then
        self.explain_panel.layout_trans.anchoredPosition = Vector3.New(params.pos.x, params.pos.y, 0)
    end

    if params.alignment then
        self.explain_panel.layout.childAlignment = params.alignment
    end

    if params.width then
        self.explain_panel.layout_trans.sizeDelta = Vector2.New(params.width, 205)
    end

	if params.relativeLeftPos then
		local _, l_pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.explain_panel.layout_trans.parent, params.relativeLeftPos.screenPos, MUIManager.UICamera, nil)
		self.explain_panel.layout_trans.anchoredPosition=Vector2.New(-1000,-1000) --挪到视野外
		local l_delayAdaptTipsFunc= function ()
			if not self:IsShowing() then
				return
			end
			--是否需要自动偏移显示内容的大小（默认不偏移）
			if params.relativeLeftPos.canOffset==nil or params.relativeLeftPos.canOffset then
				local l_contentWidth=self.explain_panel.content.transform.rect.width
				local l_contentHeight=self.explain_panel.content.transform.rect.height
				local l_layoutWidth=self.explain_panel.layout_trans.transform.rect.width
				local l_layoutHeight=self.explain_panel.layout_trans.transform.rect.height
				self.explain_panel.layout_trans.anchoredPosition=l_pos+Vector2(l_layoutWidth-l_contentWidth,l_layoutHeight-l_contentHeight)
			else
				self.explain_panel.layout_trans.anchoredPosition=l_pos
			end
		end
		if self.delayAdaptTipsTimer~=nil then
			self:StopUITimer(self.delayAdaptTipsTimer)
			self.delayAdaptTipsTimer:Reset(l_delayAdaptTipsFunc,0.01,1,false)
		else
			self.delayAdaptTipsTimer = self:NewUITimer(l_delayAdaptTipsFunc,0.001,1,false)
		end
		self.delayAdaptTipsTimer:Start()
	end
end

return ExplainPanelTipsCtrl
--lua custom scripts end
