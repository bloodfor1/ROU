--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationMonster_StorageCabinetPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
IllustrationMonster_StorageCabinetCtrl = class("IllustrationMonster_StorageCabinetCtrl", super)
--lua class define end

--lua functions
function IllustrationMonster_StorageCabinetCtrl:ctor()

    super.ctor(self, CtrlNames.IllustrationMonster_StorageCabinet, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function IllustrationMonster_StorageCabinetCtrl:Init()

    self.panel = UI.IllustrationMonster_StorageCabinetPanel.Bind(self)
    super.Init(self)
    self.dollTem = nil
    self.elementTem = nil
    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.IllustrationMonster_StorageCabinet)
    end)
    self.panel.Btn_Exchange:AddClick(function()
        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MGlobalConfig:GetInt("HandBookShopId"))
        if l_result then
            UIMgr:DeActiveUI(UI.CtrlNames.IllustrationMonster_StorageCabinet)
        end
    end)
    self.panel.Btn_Exchange2:AddClick(function()
        local npcId = MGlobalConfig:GetInt("HandBookBarterNpcId")
        local l_sceneId, l_pos = Common.CommonUIFunc.GetNpcSceneIdAndPos(npcId)
        game:ShowMainPanel()
        MTransferMgr:GotoNpc(l_sceneId[1], npcId,function()
            MgrMgr:GetMgr("NpcMgr").TalkWithNpc(l_sceneId[1], npcId)
        end)
    end)
    self.panel.Btn_Wenhao:AddClick(function()
        self:OnClickQuestion()
    end)
end --func end
--next--
function IllustrationMonster_StorageCabinetCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.dollTem = nil
    self.elementTem = nil
end --func end
--next--
function IllustrationMonster_StorageCabinetCtrl:OnActive()
    --两个按钮挪到了外部
    self.panel.Btn_Exchange:SetActiveEx(false)
    self.panel.Btn_Exchange2:SetActiveEx(false)
    self.panel.BTN_A_off:AddClick(function()
        self.panel.GroupDoll:SetActiveEx(true)
        self.panel.GroupElement:SetActiveEx(false)
        self.dollTem:ShowTemplates({ Datas = DataMgr:GetData("IllustrationMonsterData").GetStorageCabineDataByType(1) })
    end)
    self.panel.BTN_B_off:AddClick(function()
        self.panel.GroupDoll:SetActiveEx(false)
        self.panel.GroupElement:SetActiveEx(true)
        self.elementTem:ShowTemplates({ Datas = DataMgr:GetData("IllustrationMonsterData").GetStorageCabineDataByType(2) })
    end)
    if self.dollTem == nil then
        self.dollTem = self:NewTemplatePool({
            TemplateClassName = "IllustrationMonster_StorageCabinet_DollTem",
            TemplatePrefab = self.panel.IllustrationMonster_StorageCabinet_DollTem.gameObject,
            ScrollRect = self.panel.LoopDoll.LoopScroll,
        })
    end
    if self.elementTem == nil then
        self.elementTem = self:NewTemplatePool({
            TemplateClassName = "IllustrationMonster_StorageCabinet_ElementTem",
            TemplatePrefab = self.panel.IllustrationMonster_StorageCabinet_ElementTem.gameObject,
            ScrollRect = self.panel.LoopElement.LoopScroll,
        })
    end

    self.panel.BTN_A_on:SetActiveEx(true)
    self.panel.BTN_A_off:SetActiveEx(false)
    self.panel.BTN_B_on:SetActiveEx(false)
    self.panel.BTN_B_off:SetActiveEx(true)
    self.panel.GroupDoll:SetActiveEx(true)
    self.panel.GroupElement:SetActiveEx(false)
    self.dollTem:ShowTemplates({ Datas = DataMgr:GetData("IllustrationMonsterData").GetStorageCabineDataByType(1) })

    --新手指引相关
    local l_beginnerGuideChecks = {"CollectionReceivedGuide"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())

end --func end
--next--
function IllustrationMonster_StorageCabinetCtrl:OnDeActive()


end --func end
--next--
function IllustrationMonster_StorageCabinetCtrl:Update()


end --func end
--next--
function IllustrationMonster_StorageCabinetCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationMonster_StorageCabinetCtrl:OnClickQuestion()
    local l_content = Common.Utils.Lang("ILLUSTRATION_MONSTER_STORAGE_HELP_DESC")
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_content,
        alignment = UnityEngine.TextAnchor.UpperCenter,
        pos = {
            x = 318,
            y = 298,
        },
        width = 400,
    })
end
--lua custom scripts end
return IllustrationMonster_StorageCabinetCtrl