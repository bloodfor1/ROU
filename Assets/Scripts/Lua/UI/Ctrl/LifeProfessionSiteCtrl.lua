--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LifeProfessionSitePanel"
require "UI/Template/LifeProfessionSitePrefab"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
LifeProfessionSiteCtrl = class("LifeProfessionSiteCtrl", super)
--lua class define end

--lua functions
function LifeProfessionSiteCtrl:ctor()

    super.ctor(self, CtrlNames.LifeProfessionSite, UILayer.Tips, UITweenType.UpAlpha, ActiveType.Standalone)
    --self:SetParent(CtrlNames.LifeProfession)
    self.InsertPanelName = UI.CtrlNames.LifeProfessionMain

end --func end
--next--
function LifeProfessionSiteCtrl:Init()

    self.panel = UI.LifeProfessionSitePanel.Bind(self)
	super.Init(self)
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.LifeProfessionSite)
    end,true)
    self.panel.Floor:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.LifeProfessionSite)
    end,true)

    self.panel.Prefab.LuaUIGroup.gameObject:SetActiveEx(false)

    self.SitePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.LifeProfessionSitePrefab,
            TemplatePrefab = self.panel.Prefab.LuaUIGroup.gameObject,
            TemplateParent = self.panel.Parent.transform,
            Method = self.OnSelectItem,
        })

end --func end
--next--
function LifeProfessionSiteCtrl:Uninit()

    self.SitePool = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function LifeProfessionSiteCtrl:OnActive()
    if self.uiPanelData~=nil then
        self:SetItem(self.uiPanelData)
    end
end --func end
--next--
function LifeProfessionSiteCtrl:OnDeActive()

end --func end
--next--
function LifeProfessionSiteCtrl:Update()

end --func end
--next--
function LifeProfessionSiteCtrl:BindEvents()
    --dont override this function
end --func end

--next--
--lua functions end

--lua custom scripts
function LifeProfessionSiteCtrl:SetItem(itemData)

    local l_allDatas = {}
    if MSceneMgr.AllLifeSkillGatherPosInfo.gatherPosDic:ContainsKey(itemData.ID) then
        local l_posInfos = MSceneMgr.AllLifeSkillGatherPosInfo.gatherPosDic[itemData.ID]
        if l_posInfos ~= nil then
            for i = 0, l_posInfos.Count - 1 do
                l_allDatas[#l_allDatas + 1] = {
                    data = l_posInfos[i],
                    ctrl = self,
                }
            end
        end
    end
    self.SitePool:ShowTemplates({Datas = l_allDatas})

end

function LifeProfessionSiteCtrl:OnSelectItem(itemData)

    UIMgr:DeActiveUI(CtrlNames.LifeProfessionSite)
    UIMgr:DeActiveUI(CtrlNames.LifeProfessionMain)
    game:ShowMainPanel()
    MTransferMgr:GotoPosition(itemData.sceneID, itemData.pos, nil, nil, 360)

end
--lua custom scripts end
