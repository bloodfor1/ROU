--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ThemeDungeonRewardPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ThemeDungeonRewardCtrl = class("ThemeDungeonRewardCtrl", super)
--lua class define end

--lua functions
function ThemeDungeonRewardCtrl:ctor()

    super.ctor(self, CtrlNames.ThemeDungeonReward, UILayer.Function, nil, ActiveType.Exclusive)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function ThemeDungeonRewardCtrl:Init()

    self.panel = UI.ThemeDungeonRewardPanel.Bind(self)
    super.Init(self)

    self.CreatEntity = nil
    self.fx = 0
end --func end
--next--
function ThemeDungeonRewardCtrl:Uninit()

    if self.closeTimer then
        self:StopUITimer(self.closeTimer)
        self.closeTimer = nil
    end

    if self.coProcess then
        coroutine.stop(self.coProcess)
        self.coProcess = nil
    end

    if self.CreatEntity ~= nil then
        self:DestroyUIModel(self.CreatEntity)
        self.CreatEntity = nil
    end

    if self.fx ~= 0 then
        self:DestroyUIEffect(self.fx)
        self.fx = 0
    end

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ThemeDungeonRewardCtrl:OnActive()

    MEntityMgr.HideNpcAndRole = true

    if MEntityMgr.PlayerEntity then
        MEntityMgr.PlayerEntity.IsVisible = false
    end

    self.closeTimer = self:NewUITimer(function()
        self:CloseUI()
    end, 6)

    self.closeTimer:Start()

    self:ShowGetReward()
end --func end
--next--
function ThemeDungeonRewardCtrl:OnDeActive()

    MEntityMgr.HideNpcAndRole = false
    if MEntityMgr.PlayerEntity then
        MEntityMgr.PlayerEntity.IsVisible = true
    end
end --func end
--next--
function ThemeDungeonRewardCtrl:Update()


end --func end





--next--
function ThemeDungeonRewardCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function ThemeDungeonRewardCtrl:CloseUI()
    UIMgr:DeActiveUI(self.name)

    MgrMgr:GetMgr("ThemeDungeonMgr").ShowDungeonWeekAwardNotice()
end

function ThemeDungeonRewardCtrl:ShowGetReward()
    local l_boxID = DataMgr:GetData("ThemeDungeonData").ThemeDungeonBoxId
    local l_npcEntity = MNpcMgr:FindNpcInViewport(l_boxID)
    if not l_npcEntity then
        self:CloseUI()
        return
    end

    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitNpcAttr(l_tempId, "", l_boxID)
    if self.CreatEntity ~= nil then
        self:DestroyUIModel(self.CreatEntity)
        self.CreatEntity = nil
    end
    local l_modelData = {}
    l_modelData.rawImage = self.panel.ImageRT.RawImg
    l_modelData.attr = l_attr
    l_modelData.useOutLine = false
    l_modelData.defaultAnim = "Anims/Collection/Item_Collect_MaoTouYing/Item_Collect_MaoTouYing_DaKai"

    if self.fx ~= 0 then
        self:DestroyUIEffect(self.fx)
        self.fx = 0
    end

    if self.coProcess then
        coroutine.stop(self.coProcess)
        self.coProcess = nil
    end

    self.panel.ImageRT.gameObject:SetActiveEx(false)

    self.CreatEntity = self:CreateUIModel(l_modelData)
    self.CreatEntity:AddLoadModelCallback(function(m)
        self.CreatEntity.Trans:SetPos(0, 0.4, 0)
        self.CreatEntity.Trans:SetLocalScale(0.5, 0.5, 0.5)
        
        local l_childFx1 = self.CreatEntity.Trans:Find("Fx_Scene_MaoTouYing_BaoXiang_01")
        if l_childFx1 then
            l_childFx1.gameObject:SetActive(false)
        end

        self.panel.ImageRT.gameObject:SetActiveEx(true)

        local l_effectFxData = {}
        l_effectFxData.parent = self.CreatEntity.Trans
        l_effectFxData.rotation = Quaternion.Euler(0, 0, 0)
        l_effectFxData.position = Vector3.New(0, 0, 0.04)

        l_effectFxData.loadedCallback = function()
            MUIModelManagerEx:RefreshModel(self.CreatEntity)
        end
        l_effectFxData.destroyHandler = function ()
            self.fx = 0
        end

        self.fx = self:CreateEffect("Effects/Prefabs/Scene/Fx_Scene_MaoTouYing_BaoXiang_DaKai_01", l_effectFxData)

        self.coProcess = coroutine.start(function()
            coroutine.wait(2)
            self.CreatEntity.Ator:OverrideAnim("Idle", "Anims/Collection/Item_Collect_MaoTouYing/Item_Collect_MaoTouYing_QiFei")
            self.CreatEntity.Ator:Play("Idle", 0)
            coroutine.wait(0.8)
        end)
    end)
end

--lua custom scripts end
return ThemeDungeonRewardCtrl