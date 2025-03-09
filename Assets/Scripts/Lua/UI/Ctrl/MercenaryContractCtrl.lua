--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MercenaryContractPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MercenaryContractCtrl = class("MercenaryContractCtrl", super)
--lua class define end

--lua functions
local _delayClickTime = MGlobalConfig:GetInt("MercenaryRecruitSuccessTime")
function MercenaryContractCtrl:ctor()

    super.ctor(self, CtrlNames.MercenaryContract, UILayer.Function, nil, ActiveType.Exclusive)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent
    self.ClosePanelNameOnClickMask = CtrlNames.MercenaryContract
    self.MaskDelayClickTime = _delayClickTime

end --func end
--next--
function MercenaryContractCtrl:Init()

    self.panel = UI.MercenaryContractPanel.Bind(self)
    super.Init(self)

    self:InitPanel()

end --func end
--next--
function MercenaryContractCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MercenaryContractCtrl:OnActive()

    self.panel.TipsText.LabText = Lang("MercenaryContract_TipsTextWithDelay", _delayClickTime)

    self.timer = self:NewUITimer(function()
        self.panel.TipsText.LabText = Lang("MercenaryContract_TipsText")
    end, _delayClickTime, 1, true)
    self.timer:Start()


end --func end
--next--
function MercenaryContractCtrl:OnDeActive()
    self:DestroyEffect()

end --func end
--next--
function MercenaryContractCtrl:Update()


end --func end





--next--
function MercenaryContractCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts


function MercenaryContractCtrl:InitPanel()
    --self.panel.TipBtn:AddClick(function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.MercenaryContract)
    --end)
end

function MercenaryContractCtrl:SetData(mercenaryId)
    local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(mercenaryId)
    if l_mercenaryRow then
        self.panel.NameText.LabText = l_mercenaryRow.Name
        self.panel.MercenaryImg:SetRawTexAsync(l_mercenaryRow.Picture, nil, true)
        local l_jobRow = TableUtil.GetProfessionTable().GetRowById(l_mercenaryRow.Profession)
        if l_jobRow then
            self.panel.JobText.LabText = l_jobRow.Name
            self.panel.Img_ProfessionIcon:SetSpriteAsync(l_jobRow.SkillTabAtlas,l_jobRow.SkillTabIcon)
        end
    end

    self:PlayContractEffect()
    self:PlayContractCircleEffect()
end

function MercenaryContractCtrl:PlayContractEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.SealEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1, 1, 1)
    if self.contractEffectId then
        self:DestroyUIEffect(self.contractEffectId)
    end
    self.contractEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_YongBing_BG_QiYueDaCheng_01", l_fxData)

end

function MercenaryContractCtrl:PlayContractCircleEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.CircleEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1, 1, 1)
    if self.contractCircleEffectId then
        self:DestroyUIEffect(self.contractCircleEffectId)
    end
    self.contractCircleEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_YongBing_BG_LiuGuang_01", l_fxData)

end

function MercenaryContractCtrl:DestroyEffect()
    if self.contractEffectId then
        self:DestroyUIEffect(self.contractEffectId)
        self.contractEffectId = nil
    end
    if self.contractCircleEffectId then
        self:DestroyUIEffect(self.contractCircleEffectId)
        self.contractCircleEffectId = nil
    end
end


--lua custom scripts end
return MercenaryContractCtrl