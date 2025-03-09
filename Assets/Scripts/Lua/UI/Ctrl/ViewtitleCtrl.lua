--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ViewtitlePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
ViewtitleCtrl = class("ViewtitleCtrl", super)
--lua class define end

--lua functions
function ViewtitleCtrl:ctor()
	
	super.ctor(self, CtrlNames.Viewtitle, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function ViewtitleCtrl:Init()
	
	self.panel = UI.ViewtitlePanel.Bind(self)
	super.Init(self)

    self:InitPanel()

end --func end
--next--
function ViewtitleCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ViewtitleCtrl:OnActive()
	
	
end --func end
--next--
function ViewtitleCtrl:OnDeActive()

    self:DestroySelfModel()
end --func end
--next--
function ViewtitleCtrl:Update()
	
	
end --func end
--next--
function ViewtitleCtrl:Refresh()
	
	
end --func end
--next--
function ViewtitleCtrl:OnLogout()
	
	
end --func end
--next--
function ViewtitleCtrl:OnReconnected(roleData)
	
	
end --func end
--next--
function ViewtitleCtrl:Show(withTween)
	
	if not super.Show(self, withTween) then return end
	
end --func end
--next--
function ViewtitleCtrl:Hide(withTween)
	
	if not super.Hide(self, withTween) then return end
	
end --func end
--next--
function ViewtitleCtrl:BindEvents()
	
	
end --func end
--next--
function ViewtitleCtrl:UnBindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function ViewtitleCtrl:InitPanel()
    self.panel.Bg:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Viewtitle)
        MLuaClientHelper.ExecuteClickEvents(Input.mousePosition)
    end)


    local l_titleId = self.uiPanelData.titleId

    local l_titleRow = TableUtil.GetTitleTable().GetRowByTitleID(l_titleId)
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_titleId)
    if l_titleRow then
        self.panel.TitleName.LabText = StringEx.Format("[{0}]", l_titleRow.TitleName)
    end
    if l_itemRow then
        self.panel.TitleName.LabColor = MgrMgr:GetMgr("TitleStickerMgr").GetQualityColor(l_itemRow.ItemQuality)
    end
    
    self:CreateSelfModel(self.panel.TargetIcon.RawImg)
end

-- 创建自身角色模型
function ViewtitleCtrl:CreateSelfModel(rawImg)
    self:DestroySelfModel()

    local l_attr = Common.CommonUIFunc.GetMyselfRoleAttr()
    local l_fxData = {}
    l_fxData.rawImage = rawImg
    l_fxData.attr = l_attr
    l_fxData.useShadow = false
    l_fxData.width = 1024
    l_fxData.height = 1024
    l_fxData.enablePostEffect = true
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)

    self.model = self:CreateUIModel(l_fxData)
    self.model:AddLoadModelCallback(function(m)
        rawImg.gameObject:SetActiveEx(true)
    end)
    
end

function ViewtitleCtrl:DestroySelfModel()
    if self.model ~= nil then
        self:DestroyUIModel(self.model)
        self.model = nil
    end
end


--lua custom scripts end
return ViewtitleCtrl