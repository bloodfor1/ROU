--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TransferControllerPanel"
require "UI/Template/TransferControllerNpcTemplate"
require "UI/Template/TransferControllerRumorTemplate"
require "UI/Template/MerchantPathTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
TransferControllerCtrl = class("TransferControllerCtrl", super)
--lua class define end

--lua functions
function TransferControllerCtrl:ctor()
    
    super.ctor(self, CtrlNames.TransferController, UILayer.Function, UITweenType.Left, ActiveType.Exclusive)
    self.stopMoveOnActive = false
    --是否需要展示新手指引标志
    self.needShowGuide = false

end --func end
--next--
function TransferControllerCtrl:Init()
    
    self.panel = UI.TransferControllerPanel.Bind(self)
    super.Init(self)
    
    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

    for i = 1, #self.panel.citys do
        local l_com = self.panel.citys[i]
        local l_sceneId = tonumber(l_com.gameObject.name)
        if l_sceneId then
            if l_com.Btn then
                l_com:AddClick(function()
                    self:Teleport(l_sceneId)
                    UIMgr:DeActiveUI(self.name)
                end)
            end
        end
    end

    self.panel.TitleText.LabText = Lang("TRANSFER_TITLE")
    self.panel.MerchantInfo.gameObject:SetActiveEx(false)
    self.merchantNpcTemplate = nil
    self.normalShow = true
    self.panel.ImageWenhao:SetActiveEx(not self.normalShow)
    local l_listener = MUIEventListener.Get(self.panel.ImageWenhao.gameObject)
    l_listener.onClick = function(go,data)
        if self.normalShow then
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MERCHANT_QUESTION"), data, Vector2(0, 1))
    end
end --func end
--next--
function TransferControllerCtrl:Uninit()
    
    self.merchantNpcTemplate = nil
    self.merchantRumorTemplate = nil
    self.merchantPathTemplatePool = nil
    self.normalShow = true
    self.needShowGuide = false

    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function TransferControllerCtrl:OnActive()

    if self.uiPanelData ~= nil and self.uiPanelData.showMerchant then
        self:ShowMerchantNpc()
    end

    self:TransferControllerRefresh()

    --新手指引相关
    if self.needShowGuide then
        local l_beginnerGuideChecks = {"Business"}
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end
end --func end
--next--
function TransferControllerCtrl:OnDeActive()
    
    
end --func end
--next--
function TransferControllerCtrl:Update()
    
    
end --func end


--next--
function TransferControllerCtrl:OnShow()
    
    
    
    self:TransferControllerRefresh()
    
end --func end

--next--
function TransferControllerCtrl:BindEvents()
    local l_mgr = MgrMgr:GetMgr("MerchantMgr")
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.ON_SCENE_ENTER, self.TransferControllerRefresh)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.MERCHANT_EVENT_UPDATE, self.RefreshRumorInfo)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.ON_NAVIGATE_UPDATE, self.ShowPath)
end --func end
--next--
--lua functions end

--lua custom scripts
function TransferControllerCtrl:TransferControllerRefresh()
    if not self.normalShow then
        self:ShowMerchantPanel()
    end
end

function TransferControllerCtrl:Teleport(sceneId)
    
    local l_msgId = Network.Define.Ptc.TeleportItem
    ---@type TeleportItemData
    local l_sendInfo = GetProtoBufSendTable("TeleportItemData")
    l_sendInfo.itemid   = MgrMgr:GetMgr("PropMgr").ButterflyWingsID
    l_sendInfo.mapid    = sceneId
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function TransferControllerCtrl:GetNpcPosBySceneId(sceneId)

    local l_trans = self.panel.MainCities.transform:Find(tostring(sceneId))
    if l_trans then
        return l_trans.localPosition.x * 0.8, l_trans.localPosition.y * 0.8
    end
end

function TransferControllerCtrl:GotoMerchantNpc(npcId, sceneId)

    DataMgr:GetData("MerchantData").MerchantTargetScene = sceneId
    DataMgr:GetData("MerchantData").MerchantTargetNpcId = npcId

    local l_sceneRow = TableUtil.GetSceneTable().GetRowByID(sceneId)
    if l_sceneRow then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_MAP_FORWARD_FORMAT", l_sceneRow.MapEntryName))
    end

    self:MoveToNpc()

    self:ShowDesInfo()
end

function TransferControllerCtrl:ShowMerchantNpc()
    
    self.normalShow = false
    self.panel.ImageWenhao:SetActiveEx(true)
    --是否需要展示新手指引
    self.needShowGuide = true

end

function TransferControllerCtrl:ShowMerchantPanel()

    for i, v in ipairs(self.panel.Image) do
        v.gameObject:SetActiveEx(false)
    end

    for i, v in ipairs(self.panel.IconMask) do
        v.gameObject:SetActiveEx(true)
    end

    local l_merchantMgr = MgrMgr:GetMgr("MerchantMgr")
    l_merchantMgr.CloseBusinessInterruptSessionTimer()

    self.panel.TitleText.LabText = Lang("MERCHANT_TRANSFER_TITLE")
    self.panel.MerchantInfo.gameObject:SetActiveEx(true)
    self.panel.TransferControllerNpcTemplate.gameObject:SetActiveEx(false)

    self.merchantNpcTemplate = self:NewTemplatePool({
        UITemplateClass = UITemplate.TransferControllerNpcTemplate,
        TemplateParent = self.panel.NPCs.transform,
        TemplatePrefab = self.panel.TransferControllerNpcTemplate.gameObject,
    })
    
    self.panel.TransferControllerRumorTemplate.gameObject:SetActiveEx(false)
    self.merchantRumorTemplate = self:NewTemplatePool({
        UITemplateClass = UITemplate.TransferControllerRumorTemplate,
        TemplateParent = self.panel.Rumors.transform,
        TemplatePrefab = self.panel.TransferControllerRumorTemplate.gameObject,
    })

    local l_showDatas = {}
    for i, v in ipairs(TableUtil.GetBusinessNpcInfoTable().GetTable()) do
        local l_sceneId = v.sceneId
        local l_posX, l_posY = self:GetNpcPosBySceneId(l_sceneId)
        if l_posX and l_posY then
            table.insert(l_showDatas, {
                npcId = v.ID,
                posx = l_posX,
                posy = l_posY,
                sceneId = l_sceneId,
            })
        end
    end

    self.merchantNpcTemplate:ShowTemplates({Datas = l_showDatas, Method = function(npcId, sceneId)
        self:GotoMerchantNpc(npcId, sceneId)
    end})

    self:RefreshRumorInfo()

    local l_posX, l_posY = self:GetNpcPosBySceneId(MScene.SceneID)
    if l_posX and l_posY then
        MLuaCommonHelper.SetRectTransformPos(self.panel.ImgNowMap.gameObject, l_posX + 15, l_posY + 20)
        self.panel.ImgNowMap.gameObject:SetActiveEx(true)
    else
        self.panel.ImgNowMap.gameObject:SetActiveEx(false)
    end
    self:ShowPath({})
    -- 状态恢复  任务点击跑商任务不再清理行为队列 所以这里不需要再状态恢复了  cmd  20200716
    -- if MTransferMgr.IsTransing == false and DataMgr:GetData("MerchantData").MerchantTargetNpcId and DataMgr:GetData("MerchantData").MerchantTargetScene then
    --     self:MoveToNpc()
    -- end
    
    self:ShowDesInfo()
end

function TransferControllerCtrl:MoveToNpc()

    MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
    local l_targetNpcId = DataMgr:GetData("MerchantData").MerchantTargetNpcId
    local l_targetScene = DataMgr:GetData("MerchantData").MerchantTargetScene
    MgrMgr:GetMgr("ActionTargetMgr").MoveToNpc(l_targetScene, l_targetNpcId, function()
        DataMgr:GetData("MerchantData").MerchantTargetScene = nil
        DataMgr:GetData("MerchantData").MerchantTargetNpcId = nil
        MgrMgr:GetMgr("ActionTargetMgr").TalkWithNpc(l_targetScene, l_targetNpcId)
    end, function()
        MgrMgr:GetMgr("MerchantMgr").UpdateBusinessInterruptSession()
    end)
    MgrMgr:GetMgr("MerchantMgr").CloseBusinessInterruptSessionTimer()

    self:ShowPath({})

end


function TransferControllerCtrl:ShowPath(paths)

    if not self.panel then
        return
    end
    if not self.merchantPathTemplatePool then
        self.merchantPathTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.MerchantPathTemplate,
            TemplateParent = self.panel.Paths.transform,
            TemplatePrefab = self.panel.MerchantPathTemplate.gameObject,
        })
    end

    local l_paths = {}
    for i, v in ipairs(paths) do
        table.insert(l_paths, {
            value = v.value,
        })
    end
    local l_datas = {}
    local l_count = #l_paths
    local l_mark = {}
    for i, v in ipairs(l_paths) do
        local l_curScene = (i > 1) and (l_paths[i - 1].value) or MScene.SceneID
        local l_nextScene = v.value
        if not l_mark[l_nextScene] then
            local l_fromX, l_fromY = self:GetNpcPosBySceneId(l_curScene)
            local l_toX, l_toY = self:GetNpcPosBySceneId(l_nextScene)
            if l_fromX and l_fromY and l_toX and l_toY then
                table.insert(l_datas, {
                    from = {l_fromX, l_fromY},
                    to = {l_toX, l_toY},
                })
            end
            l_mark[l_nextScene] = true
        end
    end
    self.merchantPathTemplatePool:ShowTemplates({Datas = l_datas})
end

function TransferControllerCtrl:ShowDesInfo()

    local l_visible = false

    local l_targetScene = DataMgr:GetData("MerchantData").MerchantTargetScene
    local l_targetNpcId = DataMgr:GetData("MerchantData").MerchantTargetNpcId
    if l_targetScene ~= nil then
        if MScene.SceneID ~= l_targetScene then

            local l_targetX, l_targetY = self:GetNpcPosBySceneId(l_targetScene)

            if l_targetX and l_targetY then
                MLuaCommonHelper.SetRectTransformPos(self.panel.Selected.gameObject, l_targetX, l_targetY)
                l_visible = true
                
                local l_row = TableUtil.GetBusinessNpcInfoTable().GetRowByID(l_targetNpcId)
                MgrMgr:GetMgr("TaskMgr").RequestTaskNavigation(l_targetScene, Vector3.New(l_row.X, l_row.Y, l_row.Z), function(info)
                    MgrMgr:GetMgr("MerchantMgr").OnNavigateUpdate(info)
                end, true)
            end
        end
    end

    if not l_visible then
        self:ShowPath({})
    end

    self.panel.Selected.gameObject:SetActiveEx(l_visible)
end

function TransferControllerCtrl:RefreshRumorInfo()

    if not self.merchantRumorTemplate then
        return
    end

    local l_showDatas = {}
    local l_merchantMgr = MgrMgr:GetMgr("MerchantMgr")
    local l_data = DataMgr:GetData("MerchantData")
    local l_eventRumors = l_data.MerchantEventRumor or {}
    for i, v in ipairs(l_eventRumors) do
        local l_sceneId = l_data.GetNpcSceneByNpcId(v.value)
        if l_sceneId then
            local l_posX, l_posY = self:GetNpcPosBySceneId(l_sceneId)
            if l_posX and l_posY then
                table.insert(l_showDatas, {
                    posx = l_posX,
                    posy = l_posY,
                })
            end
        end
    end

    self.merchantRumorTemplate:ShowTemplates({Datas = l_showDatas})
end

--lua custom scripts end
return TransferControllerCtrl