--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MercenaryRecommendationPanel"
require "UI/Template/MercenarySelectCell"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
MercenaryRecommendationCtrl = class("MercenaryRecommendationCtrl", super)
--lua class define end

--lua functions
function MercenaryRecommendationCtrl:ctor()
	
	super.ctor(self, CtrlNames.MercenaryRecommendation, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function MercenaryRecommendationCtrl:Init()
	
	self.panel = UI.MercenaryRecommendationPanel.Bind(self)
	super.Init(self)

    -- 需要展示的佣兵
    local l_mercenaryDatas = {}
    local l_mercenaryIds = MGlobalConfig:GetSequenceOrVectorInt("MercenarySelectedID")
    local l_recommendDes = {}
    for i = 0, l_mercenaryIds.Length - 1 do
        table.insert(l_mercenaryDatas, { mercenaryId = l_mercenaryIds[i] })
        if MgrMgr:GetMgr("MercenaryMgr").IsMercenaryRecommend(l_mercenaryIds[i]) then
            table.insert(l_recommendDes, MgrMgr:GetMgr("MercenaryMgr").GetMercenarySomeoneDes(l_mercenaryIds[i]))
        end
    end

    self.panel.DesText.LabText = RoColor.FormatWord(Lang("MERCENARY_SELECTION_DES", table.concat(l_recommendDes, ",")))

    self.mercenaryPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MercenarySelectCell,
        TemplatePrefab = self.panel.MercenarySelectCell.LuaUIGroup.gameObject,
        ScrollRect = self.panel.MercenaryScroll.LoopScroll,
    })

    self.mercenaryPool:ShowTemplates({Datas = l_mercenaryDatas})
end --func end
--next--
function MercenaryRecommendationCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MercenaryRecommendationCtrl:OnActive()
	
	
end --func end
--next--
function MercenaryRecommendationCtrl:OnDeActive()
	
	
end --func end
--next--
function MercenaryRecommendationCtrl:Update()
	
	
end --func end
--next--
function MercenaryRecommendationCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenaryRecommendationCtrl