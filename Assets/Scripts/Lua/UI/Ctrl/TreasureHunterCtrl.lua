--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TreasureHunterPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TreasureHunterCtrl = class("TreasureHunterCtrl", super)
--lua class define end

--lua functions
function TreasureHunterCtrl:ctor()

    super.ctor(self, CtrlNames.TreasureHunter, UILayer.Function, nil, ActiveType.Exclusive)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.TreasureHunter
end --func end
--next--
function TreasureHunterCtrl:Init()

    self.panel = UI.TreasureHunterPanel.Bind(self)
    super.Init(self)
    self.isMine = false
    self.data = DataMgr:GetData("TreasureHunterData")
    self.mgr = MgrMgr:GetMgr("TreasureHunterMgr")

    self.PosDeep = self.panel.endPoint.transform.localPosition.y - self.panel.starPoint.transform.localPosition.y
    self.preDeep = self.PosDeep / (MGlobalConfig:GetInt("TreasureMaxDepth"))
    self.startY = self.panel.starPoint.transform.localPosition.y
    self.TroveHeight = 19
    self.ItemPool = nil
    self.panel.Btn_Guild:AddClick(function()
        self.mgr.SendHelpToGuild(self.panelData.treasure_award_id, self.panelData.pos, self.panelData.scene_line)
    end)
    self.panel.Btn_Invite:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.TreasureHunter_invite)
    end)
    self.panel.Btn_Help:AddClick(function()
        self.mgr.HelpTreasure(self.panelData.uid)
    end)
    self.panel.Btn_Wenhao:AddClick(self.OnClickQuestion)
end --func end
--next--
function TreasureHunterCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.ItemPool = nil
end --func end
--next--
function TreasureHunterCtrl:OnActive()
    ---@type SurveyHunter_SelectPanelInfo
    self.panelData = self.data.GetSelectPanelInfo()
    self.isMine = MEntityMgr.PlayerEntity.UID:equals(self.panelData.role_id)
    self.panel.Btn_Help:SetActiveEx(not self.isMine)
    self.panel.Btn_Guild:SetActiveEx(self.isMine)
    self.panel.Btn_Invite:SetActiveEx(self.isMine)
    self.entity = MEntityMgr:GetEntity(self.panelData.uid, true)
    self.data.SetEntityPosInfo(self.entity.Position)
    self.panel.Object_Trove:SetActiveEx(true)
    self:ShowAward()
    self.panel.Object_Trove.transform:SetLocalPosY(self.panel.starPoint.transform.localPosition.y  + self.panelData.total_depth * self.preDeep- 19)
    self.panel.Btn_Help:SetGray(not self.panelData.canHelp)
end --func end
--next--
function TreasureHunterCtrl:OnDeActive()


end --func end
--next--
function TreasureHunterCtrl:Update()
    if not self.entity or not self.entity.AttrComp or self.entity.AttrComp.HP == 0 then
        UIMgr:DeActiveUI(UI.CtrlNames.TreasureHunter)
        return
    end
    self.data.RrefreshCurrentLeftTime(self.entity.AttrComp.HP)
    self:RefreshPanel()
end --func end
--next--
function TreasureHunterCtrl:BindEvents()
    self:BindEvent(self.mgr.EventDispatcher, self.data.IS_HELP, self.SetHelpGray)
end --func end
--next--
--lua functions end

--lua custom scripts

function TreasureHunterCtrl:RefreshPanel()
    self.panel.umberUp.LabText = self.panelData.total_depth
    local nowDeep = self.panelData.total_depth - self.panelData.current_depth
    self.panel.umberdown.LabText = math.floor(nowDeep)
    self.panel.Object_Deep.transform:SetLocalPosY(self.startY + nowDeep * self.preDeep)
    local hour, min, sec;
    sec = self.panelData.current_leftTime
    hour = math.floor(sec / 3600)
    sec = sec % 3600
    min = math.floor(sec / 60)
    sec = sec % 60
    self.panel.Textsecond.LabText = StringEx.Format("{0:00}", sec)
    self.panel.Textminute.LabText = StringEx.Format("{0:00}", min)
    self.panel.Texthour.LabText = StringEx.Format("{0:00}", hour)
end

function TreasureHunterCtrl:ShowAward()
    if self.ItemPool == nil then
        self.ItemPool = self:NewTemplatePool({
            TemplateClassName = "ItemTemplate",
            ScrollRect = self.panel.LoopScroll.LoopScroll,
            TemplatePath = "UI/Prefabs/ItemPrefab",
        })
    end
    local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(self.panelData.treasure_award_id)
    local itemDatas = {}
    if l_awardData ~= nil then
        for i = 0, l_awardData.PackIds.Length - 1 do
            local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
            if l_packData ~= nil then
                for j = 0, l_packData.GroupContent.Count - 1 do
                    table.insert(itemDatas, { ID = tonumber(l_packData.GroupContent:get_Item(j, 0)), Count = tonumber(l_packData.GroupContent:get_Item(j, 1)) })
                end
            end
        end
    end
    self.ItemPool:ShowTemplates({ Datas = itemDatas })
end

function TreasureHunterCtrl:OnClickQuestion()
    local l_content = Common.Utils.Lang("TREASURE_HUNTER_QA")
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_content,
        alignment = UnityEngine.TextAnchor.UpperCenter,
        pos = {
            x = 318,
            y = 271,
        },
        width = 400,
    })
end

function TreasureHunterCtrl:SetHelpGray()
    self.panel.Btn_Help:SetGray(true)
end

--lua custom scripts end
return TreasureHunterCtrl