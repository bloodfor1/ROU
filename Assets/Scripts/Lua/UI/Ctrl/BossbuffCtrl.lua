--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BossbuffPanel"
require "UI/Template/AffxCell"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
BossbuffCtrl = class("BossbuffCtrl", super)
--lua class define end

--lua functions
function BossbuffCtrl:ctor()
	
	super.ctor(self, CtrlNames.Bossbuff, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function BossbuffCtrl:Init()
	self.panel = UI.BossbuffPanel.Bind(self)
	super.Init(self)

    self.panel.CloseBtn:AddClickWithLuaSelf(function(self_param)
        self_param:ClosePanel()
    end, self)

    -- 10秒后关闭界面
    self.closeTimer = self:NewUITimer(function()
        self:ClosePanel()
    end, 10)
    self.closeTimer:Start()

    local l_affixIds = MgrMgr:GetMgr("DungeonMgr").DungeonAffixIds
    local l_affixDatas = {}
    for i, id in ipairs(l_affixIds) do
        table.insert(l_affixDatas, {
            id = id,
            isLast = i == #l_affixIds
        })
    end
    self.affixPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AffxCell,
        TemplatePrefab = self.panel.AffxCell.LuaUIGroup.gameObject,
        ScrollRect = self.panel.AffixScroll.LoopScroll,
    })
    self.affixPool:ShowTemplates({ Datas = l_affixDatas })
end --func end
--next--
function BossbuffCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BossbuffCtrl:OnActive()
	
	
end --func end
--next--
function BossbuffCtrl:OnDeActive()
	self:KillTweens()
	
end --func end
--next--
function BossbuffCtrl:Update()
	
	
end --func end
--next--
function BossbuffCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function BossbuffCtrl:ClosePanel()
    self.scaleTween = MUITweenHelper.TweenScale(self.panel.Panel.gameObject, Vector3.New(1, 1, 1), Vector3.New(0.1, 0.1, 0.1), 0.2, function()
        local l_endPosition = Vector3(0, 0, 0)
        local l_mapCtrl = UIMgr:GetUI(UI.CtrlNames.Map)
        if l_mapCtrl then
            l_endPosition = l_mapCtrl:GetAffixBtnPosition()
        end

        self.posTween = MUITweenHelper.TweenWorldPos(self.panel.Panel.gameObject, self.panel.Panel.transform.position, l_endPosition, 0.8, function()
            UIMgr:DeActiveUI(UI.CtrlNames.Bossbuff)
        end)
    end)
end

function BossbuffCtrl:KillTweens()
    if self.scaleTween then
        MUITweenHelper.KillTween(self.scaleTween)
        self.scaleTween = nil
    end
    if self.posTween then
        MUITweenHelper.KillTween(self.posTween)
        self.posTween = nil
    end
end

--lua custom scripts end
return BossbuffCtrl