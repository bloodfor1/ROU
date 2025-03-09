--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InfinityTowerPanel"
require "CommonUI/Color"
require "UI/Template/InfinityTowerTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
InfinityTowerCtrl = class("InfinityTowerCtrl", super)
--lua class define end

--lua functions
function InfinityTowerCtrl:ctor()

    super.ctor(self, CtrlNames.InfinityTower, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function InfinityTowerCtrl:Init()

    self.panel = UI.InfinityTowerPanel.Bind(self)
    super.Init(self)
    self.timer = nil
    self.tweenId = 0
    --塔
    self.InfinityTowerItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.InfinityTowerTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.InfinityTowerPrefab.LuaUIGroup.gameObject
    })

    self.rewardRedSignProcessor = self:NewRedSign({
        Key = eRedSignKey.TowerReward,
        ClickButton = self.panel.BtnReward
    })
    self.panel.BtnClose:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.InfinityTower)
    end)

    local l_openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isRewardOpen = l_openMgr.IsSystemOpen(l_openMgr.eSystemId.TowerReward)
    self.panel.BtnReward.gameObject:SetActiveEx(l_isRewardOpen)
    self.panel.BtnReward:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.InfinityTowerFirstReward)
    end)

    local l_towerData = {}
    local l_baseBlockSplit = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").g_towerBlockSplit
    local l_blocks = math.ceil((MgrMgr:GetMgr("InfiniteTowerDungeonMgr").g_saveTowerLevel + 1) / l_baseBlockSplit) + 1

    local l_height
    if l_blocks <= 3 then
        l_blocks = 4
        l_height = 832
    else
        l_blocks = l_blocks + 1
        l_height = 532 + 100 * (l_blocks - 1) + 200
    end

    for i = 1, l_blocks do
        table.insert(l_towerData, {
            block = i,
            btn = self.panel.InfinityTowerBtn.LuaUIGroup.gameObject,
            parent = self
        })
    end

    self.InfinityTowerItemPool:ShowTemplates({Datas = l_towerData})
    self.rectTransform = self.panel.Content.gameObject:GetComponent("RectTransform")
    self.rectTransform.sizeDelta = Vector2.New(0, l_height)

    MgrMgr:GetMgr("DungeonMgr").RequestDungeonsMonster()

end --func end
--next--
function InfinityTowerCtrl:Uninit()
    self.InfinityTowerItemPool = nil
    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end
    if self.timer ~= nil then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    if self.fxData ~= nil then
        self:DestroyUIEffect(self.fxData)
        self.fxData = nil
    end
    if self.fxData1 ~= nil then
        self:DestroyUIEffect(self.fxData1)
        self.fxData1 = nil
    end
    if self.rectTransform ~= nil then
        self.rectTransform = nil
    end
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function InfinityTowerCtrl:OnActive()
    self.timer = self:NewUITimer(function()
        local l_contentHeight = self.rectTransform.sizeDelta.y
        local l_oldPos = self.panel.Content.RectTransform.localPosition
        local l_time = l_contentHeight / MGlobalConfig:GetInt("TowerLevelUiPanningSpeed")
        self.tweenId = MUITweenHelper.TweenPos(self.panel.Content.gameObject, l_oldPos, Vector3.New(l_oldPos.x, -l_contentHeight, l_oldPos.z), l_time)
    end,0.1,0,true)
    self.timer:Start()
    --云朵特效
    local l_fxData = {}
    l_fxData.rawImage = self.panel.RawImage.RawImg
    self.fxData = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_yunduo_01", l_fxData)
    
    local l_fxData1 = {}
    l_fxData1.rawImage = self.panel.RawImage1.RawImg
    self.fxData1 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_yunduo_01", l_fxData1)

    UIMgr:ActiveUI(UI.CtrlNames.InfinityTowerStageInfo, function(ctrl)
        local saved = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").GetSavedLevel()
        if saved == 0 then
            ctrl:InitWithTowerLevel(1)
        else
            ctrl:InitWithTowerLevel(saved)
        end
        
    end)

    --新手指引相关
    local l_beginnerGuideChecks = {"EndlessTower"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName(), UILayerSort[self.GroupContainerType] + 1)
    
end --func end
--next--
function InfinityTowerCtrl:OnDeActive()


end --func end
--next--
function InfinityTowerCtrl:Update()

end --func end



--next--
function InfinityTowerCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("InfiniteTowerDungeonMgr").EventDispatcher,MgrMgr:GetMgr("InfiniteTowerDungeonMgr").ON_SELECT_TOWER, self.UpdateBtnSelectState)
end --func end
--next--
--lua functions end

--lua custom scripts

function InfinityTowerCtrl:UpdateBtnSelectState(id)
    
    local l_items = self.InfinityTowerItemPool:GetItems()
    if l_items then
        for k, v in pairs(l_items) do
            v:UpdateSelectState(id)
        end
    end
end

--lua custom scripts end
