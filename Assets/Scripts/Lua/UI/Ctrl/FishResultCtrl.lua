--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FishResultPanel"




--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FishResultCtrl = class("FishResultCtrl", super)
--lua class define end

local l_fishModel = nil  --鱼模型
local l_effect = nil  --特效
local l_effectPath = "Effects/Prefabs/Creature/Ui/Fx_Ui_DiaoYuxXinWuPin_01"

--lua functions
function FishResultCtrl:ctor()

    super.ctor(self, CtrlNames.FishResult, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function FishResultCtrl:Init()
    self.panel = UI.FishResultPanel.Bind(self)
    super.Init(self)

    self.mask = self:NewPanelMask(BlockColor.Dark, nil, function()
        --关闭结果界面
        UIMgr:DeActiveUI(UI.CtrlNames.FishResult)
    end)

    --等待一定时间后才能关闭
    local l_waitTime = MGlobalConfig:GetFloat("FishingResultWaitTime")
    local l_timer = self:NewUITimer(function()
        UIMgr:DeActiveUI(UI.CtrlNames.FishResult)
    end, tonumber(l_waitTime))
    l_timer:Start()
end --func end
--next--
function FishResultCtrl:Uninit()


    --鱼模型销毁
    if l_fishModel ~= nil then
        self:DestroyUIModel(l_fishModel);
        l_fishModel = nil
    end
    --特效销毁
    if l_effect ~= nil then
        self:DestroyUIEffect(l_effect)
        l_effect = nil
    end

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function FishResultCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("LifeProfessionData").EUIOpenType.FishResult then
            self:ShowFish(self.uiPanelData.itemId, self.uiPanelData.size)
        end
    end

end --func end
--next--
function FishResultCtrl:OnDeActive()


end --func end
--next--
function FishResultCtrl:Update()


end --func end



--next--
function FishResultCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
--钓到的鱼展示
function FishResultCtrl:ShowFish(fishId, fishSize)

    --从表中获取鱼的数据
    local l_fishInfo = TableUtil.GetFishTable().GetRowByID(fishId)
    local l_fishData = TableUtil.GetItemTable().GetRowByItemID(fishId)
    --文本赋值
    self.panel.FishName.LabText = l_fishData.ItemName
    self.panel.FishSize.LabText = StringEx.Format("{0:F1} cm", fishSize)
    self.panel.FishIcon:SetSpriteAsync(l_fishData.ItemAtlas, l_fishData.ItemIcon, nil, true)

    --特效加载
    local l_fxData_effect = {}
    l_fxData_effect.rawImage = self.panel.EffectView.RawImg
    l_fxData_effect.loadedCallback = function(a)
        self.panel.EffectView.gameObject:SetActiveEx(true)
    end
    l_fxData_effect.destroyHandler = function()
        l_effect = nil
    end
    l_effect = self:CreateUIEffect(l_effectPath, l_fxData_effect)

end
--lua custom scripts end
