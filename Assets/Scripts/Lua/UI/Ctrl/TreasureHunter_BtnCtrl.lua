--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TreasureHunter_BtnPanel"
--lua requires end

--lua modeltrea
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TreasureHunter_BtnCtrl = class("TreasureHunter_BtnCtrl", super)
--lua class define end

--lua functions
function TreasureHunter_BtnCtrl:ctor()

    super.ctor(self, CtrlNames.TreasureHunter_Btn, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function TreasureHunter_BtnCtrl:Init()

    self.panel = UI.TreasureHunter_BtnPanel.Bind(self)
    super.Init(self)
    self.TotlaCd = MGlobalConfig:GetInt("TreasureHunterSearchCd")
    self.CdLeft = 0
    self.panel.TreasureHunter_btn:AddClick(function()
        if self.panel.maskCd.gameObject.activeSelf then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TREASURE_BTN_IS_IN＿CD"))
            return
        end
        MgrMgr:GetMgr("TreasureHunterMgr").SurveyTreasure()
    end)
end --func end
--next--
function TreasureHunter_BtnCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function TreasureHunter_BtnCtrl:OnActive()
    self.panel.maskCd:SetActiveEx(false)

end --func end
--next--
function TreasureHunter_BtnCtrl:OnDeActive()


end --func end
--next--
function TreasureHunter_BtnCtrl:Update()
    local CdStamp = DataMgr:GetData("TreasureHunterData").GetSurveyBtnCdStamp()
    if CdStamp ~= -1 then
        if self.CdLeft <= 0 then
            self.CdLeft = tonumber(CdStamp - Common.TimeMgr.GetNowTimestamp())
            self.panel.maskCd:SetActiveEx(true)
            if self.CdLeft <= 0 then
                self:l_ResetAll()
            end
        end
    end
    if self.CdLeft > 0 then
        self.CdLeft = self.CdLeft - Time.deltaTime
        if self.CdLeft <= 0.01 then
            self:l_ResetAll()
        else
            self.panel.TextCd.LabText = math.floor(self.CdLeft)
            self.panel.maskCd.Img.fillAmount = self.CdLeft / self.TotlaCd
        end
    end

end --func end

--next--
function TreasureHunter_BtnCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("TreasureHunterMgr").EventDispatcher,
            DataMgr:GetData("TreasureHunterData").END_UPDATE_CD, self.l_ResetPanelCd)

end --func end
--next--
--lua functions end

--lua custom scripts
function TreasureHunter_BtnCtrl:l_ResetPanelCd()
    self.CdLeft = 0
    self.panel.maskCd:SetActiveEx(false)
end

function TreasureHunter_BtnCtrl:l_ResetAll()
    self:l_ResetPanelCd()
    DataMgr:GetData("TreasureHunterData").ResetSurveyBtnCdStamp()
end


--lua custom scripts end
return TreasureHunter_BtnCtrl