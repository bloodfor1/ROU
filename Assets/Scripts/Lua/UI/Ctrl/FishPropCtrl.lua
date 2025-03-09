--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FishPropPanel"
require "UI/Template/FishPropItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FishPropCtrl = class("FishPropCtrl", super)
--lua class define end

local l_fishMgr = MgrMgr:GetMgr("FishMgr")

--lua functions
function FishPropCtrl:ctor()

    super.ctor(self, CtrlNames.FishProp, UILayer.Function, nil, ActiveType.Standalone)
    self.overrideSortLayer = UILayerSort.Function + 1
end --func end
--next--
function FishPropCtrl:Init()

    self.panel = UI.FishPropPanel.Bind(self)
	super.Init(self)

    self.panel.BtnClose:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.FishProp)
    end)

    --道具列表池创建
    self.fishPropTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.FishPropItemTemplate,
        TemplatePrefab = self.panel.FishPropItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })
    self.curSelectedItem = nil

    --显示的格子总数设置
    local l_minCount = 12
    if #l_fishMgr.g_seatDatas > 12 then
        --超过12个 每次加一行
        l_minCount = math.ceil(#l_fishMgr.g_seatDatas / 4) * 4
    end
    --显示内容
    self.fishPropTemplatePool:ShowTemplates({
        Datas = l_fishMgr.g_seatDatas,
        ShowMinCount = l_minCount,
        Method=function(propItem)
            -- 选中相关逻辑
            if self.curSelectedItem ~= nil then self.curSelectedItem:SetSelect(false) end
            self.curSelectedItem = propItem
            self.curSelectedItem:SetSelect(true)
        end})
end --func end
--next--
function FishPropCtrl:Uninit()

    self.curSelectedItem = nil

    self.fishPropTemplatePool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function FishPropCtrl:OnActive()


end --func end
--next--
function FishPropCtrl:OnDeActive()


end --func end
--next--
function FishPropCtrl:Update()


end --func end



--next--
function FishPropCtrl:BindEvents()
    --物品栏内容刷新
    self:BindEvent(l_fishMgr.EventDispatcher,l_fishMgr.ON_REFRESH_FISH_PROP_PANEL,function(self)
        self.fishPropTemplatePool:RefreshCells()
    end)
end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
