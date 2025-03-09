--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/RoleInfoPanel"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
RoleInfoHandler = class("RoleInfoHandler", super)
local l_eventSystem = nil
local l_pointEventData = nil
local l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
local l_roleShareID = 10002
--lua class define end

--lua functions
function RoleInfoHandler:ctor()

    super.ctor(self, HandlerNames.RoleInfo, 0)

end --func end
--next--
function RoleInfoHandler:Init()
    self.panel = UI.RoleInfoPanel.Bind(self)
    super.Init(self)

    ---@type table<number, TitleNameColorGroup>
    self.C_TITLE_COLOR_MAP = {
        [GameEnum.ETitleQuality.Grey] = { TxtColor = "7e86a1", OutLineColor = "dce6f7" },
        [GameEnum.ETitleQuality.Green] = { TxtColor = "b5ff9b", OutLineColor = "318050" },
        [GameEnum.ETitleQuality.Blue] = { TxtColor = "9bd6ff", OutLineColor = "496cbd" },
        [GameEnum.ETitleQuality.Purple] = { TxtColor = "d297ff", OutLineColor = "733995" },
        [GameEnum.ETitleQuality.Gold] = { TxtColor = "ffd576", OutLineColor = "955739" },
    }

    l_eventSystem = EventSystem.current
    l_pointEventData = PointerEventData.New(l_eventSystem)
    self.RefreshRoleInfoNum = 100
    self.cSliderBaseExp = self.panel.Slider_Base.gameObject:GetComponent("Slider")
    self.cSliderJobExp = self.panel.Slider_Job.gameObject:GetComponent("Slider")
    self.cSliderHp = self.panel.Slider_Hp.gameObject:GetComponent("Slider")
    self.cSliderSp = self.panel.Slider_Sp.gameObject:GetComponent("Slider")
    self.cClickAutoFight = false
    self.RedSignProcessor = self:NewRedSign({
        Key = eRedSignKey.StatusPoint,
        ClickButton = self.panel.RedPromptParent
    })
    self.panel.ButtonVigour:AddClick(function()
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("VIGOUR_USE_JUMP"),
                function()
                    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LifeProfession) then
                        UIMgr:ActiveUI(CtrlNames.LifeProfessionMain)
                    else
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("LIFE_PROFESSION_NOT_OPEN"))
                    end
                end, nil, -1, 0, nil,
                function(ctrl)
                    ctrl:SetAlignmentHorizontal(UnityEngine.TextAnchor.MiddleLeft)
                end)
    end)
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LifeProfession) then
        self.vigourRedSign = self:NewRedSign({
            Key = eRedSignKey.Vigour,
            ClickButton = self.panel.ButtonVigour
        })
    end

    self.serverLevelTipsTemplate = self:NewTemplate("ServerLevelTipsTemplate", {
        TemplateParent = self.panel.ServerLevelParent.transform
    })
    self.serverLevelTipsTemplate:SetGameObjectActive(false)
    self.panel.Common.gameObject:SetActiveEx(true)
    self.panel.Detail.gameObject:SetActiveEx(false)
    self.panel.btn_change_icon:AddClickWithLuaSelf(self._onSwitchIconClick, self)
    self.panel.btn_change_title:AddClickWithLuaSelf(self._onSwitchTitleClick, self)
end --func end

--next--
function RoleInfoHandler:Uninit()
    self.head2d = nil
    self.vigourRedSign = nil
    self.RedSignProcessor = nil
    self.serverLevelTipsTemplate = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function RoleInfoHandler:OnActive()
    self:InitMainRoleInfo()
    --self:InitLeftInfo()
    self:SetBtnStateByLevel()
    self:RefreshHead()
    self:RoleInfoHandlerRefresh()
    self:CheckGuide()
    self:_setIconState()
    self:_onTitleSwitch()

end --func end
--next--
function RoleInfoHandler:OnDeActive()
    self.inStateAutoAdd = false
    self.inStateAutoSub = false
    l_roleInfoMgr.ResetPlusAttr()
end --func end
--next--
function RoleInfoHandler:Update()
    if self.inStateAutoAdd then
        local addTime = math.max(math.floor(self.stateAddTime / 20) + 1, 1)
        for i = 1, addTime do
            self.stateAddTime = self.stateAddTime + 1
            if self.stateAddTime >= 0 and self.stateAddTime % 10 == 0 then
                if not self:AddAttr(self.addId) then
                    self.inStateAutoAdd = false
                    break
                end
            end
        end
    end
    if self.inStateAutoSub then
        local addTime = math.max(math.floor(self.stateSubTime / 20) + 1, 1)
        for i = 1, addTime do
            self.stateSubTime = self.stateSubTime + 1
            if self.stateSubTime >= 0 and self.stateSubTime % 10 == 0 then
                if not self:SubAttr(self.subId) then
                    self.inStateAutoSub = false
                    break
                end
            end
        end
    end

    if self.RefreshRoleInfoNum then
        if self.RefreshRoleInfoNum < 0 then
            self:RefreshRoleInfo()
            self.RefreshRoleInfoNum = 100
        else
            self.RefreshRoleInfoNum = self.RefreshRoleInfoNum - 1
        end
    end
end --func end

--next--
function RoleInfoHandler:BindEvents()

    --新手指引
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher, MgrMgr:GetMgr("BeginnerGuideMgr").OX_BUTTON_GUIDE_EVENT, function(self, guideStepInfo)
        self:ShowBeginnerGuide_OX(guideStepInfo)
    end)

    self:BindEvent(l_roleInfoMgr.EventDispatcher, l_roleInfoMgr.ON_SERVER_LEVEL_UPDATE, function()
        self:SetServerLevel()
    end)

    self:BindEvent(MgrMgr:GetMgr("RoleInfoMgr").EventDispatcher, MgrMgr:GetMgr("RoleInfoMgr").ON_SERVER_LEVEL_UPDATE, function()
        self:CheckGuide()
    end)

    self:BindEvent(l_roleInfoMgr.EventDispatcher, l_roleInfoMgr.ROLE_INFO_SAVE_STATE, self.SetRoleInfoSavePanelState)
    self:BindEvent(l_roleInfoMgr.EventDispatcher, l_roleInfoMgr.ROLE_INFO_REFRESH, self.RoleInfoHandlerRefresh)
    self:BindEvent(l_roleInfoMgr.EventDispatcher, l_roleInfoMgr.CHANGE_TO_DETAIL, self.ChangeToDetail)
    self:BindEvent(l_roleInfoMgr.EventDispatcher, l_roleInfoMgr.RESET_ROLE_ATTRS, self.ResetRoleAttrs)
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onTitleSwitch)
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagSync, self._onTitleSwitch)
end --func end
--next--
--lua functions end

--lua custom scripts
function RoleInfoHandler:_setIconState()
    local sysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local iconOpen = sysMgr.IsSystemOpen(sysMgr.eSystemId.HeadBook)
    local titleOpen = sysMgr.IsSystemOpen(sysMgr.eSystemId.TitleBook)
    self.panel.btn_change_icon:SetActiveEx(iconOpen)
    self.panel.btn_change_title:SetActiveEx(titleOpen)
    self.panel.titleName:SetActiveEx(titleOpen)
end

function RoleInfoHandler:_onTitleSwitch()
    local targetItem = self:_getCurrentTitle()
    local targetData = self.C_TITLE_COLOR_MAP[GameEnum.ETitleQuality.Grey]
    if nil == targetItem then
        self.panel.titleName.LabText = Common.Utils.Lang("C_NO_TITLE")
    else
        local titleConfig = TableUtil.GetTitleTable().GetRowByTitleID(targetItem.TID)
        self.panel.titleName.LabText = titleConfig.TitleName
        targetData = self.C_TITLE_COLOR_MAP[targetItem.ItemConfig.ItemQuality]
    end

    local txtColor = CommonUI.Color.Hex2Color(targetData.TxtColor)
    local outLineColor = CommonUI.Color.Hex2Color(targetData.OutLineColor)
    self.panel.titleName.LabColor = txtColor
    self.panel.titleName:SetOutLineColor(outLineColor)
end

function RoleInfoHandler:_onSwitchTitleClick()
    UIMgr:ActiveUI(UI.CtrlNames.Personal, { titleId = 0 })
end

---@return ItemData
function RoleInfoHandler:_getCurrentTitle()
    local targetContainers = { GameEnum.EBagContainerType.TitleUsing }
    local targetItems = Data.BagApi:GetItemsByTypesAndConds(targetContainers, nil)
    return targetItems[1]
end

function RoleInfoHandler:_onSwitchIconClick()
    UIMgr:ActiveUI(UI.CtrlNames.Personal, { photoId = 0 })
end

function RoleInfoHandler:CheckGuide()
    --新手指引相关
    if l_roleInfoMgr.IsNeedShowRoleInfoGuide then
        local l_beginnerGuideChecks = { "QualityPoint", "ServerLevel", "ProfQualityPoint", "NewRoleGuide" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self.ctrlRef:GetPanelName())
    end
end

function RoleInfoHandler:RoleInfoHandlerRefresh()
    l_roleInfoMgr.RefreshData()
    self:RefreshUI()
    self:RefreshRoleInfo()
    self:RefreshPolygon()
end

function RoleInfoHandler:UpdateInput(touchItem)
    local l_pos = touchItem.Position
    l_pointEventData.position = l_pos
end

function RoleInfoHandler:SetBtnStateByLevel()
    local l_proType = MgrMgr:GetMgr("ProfessionMgr").GetProfessionType(MPlayerInfo.ProID)
    if tonumber(MPlayerInfo.Lv) >= tonumber(TableUtil.GetGlobalTable().GetRowByName("AddAttr_Auto").Value) and l_proType > MgrMgr:GetMgr("ProfessionMgr").PROFESSIONTYPE.ONE then
        self.panel.Btn_tuijian.gameObject:SetActiveEx(true)
        self:SetSavePanelState(false)
        self.panel.Btn_AutoAdd.gameObject:SetActiveEx(false)
    else
        self.panel.Btn_tuijian.gameObject:SetActiveEx(false)
        self:SetSavePanelState(false)
        self.panel.Btn_AutoAdd.gameObject:SetActiveEx(true)
    end
end

function PlayAnimation(cObj)
    local cAni = cObj:GetComponent("DOTweenAnimation")
    if cAni then
        cAni:DORestart(true)
    end
end

function RoleInfoHandler:InitMainRoleInfo()
    -- 头像
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.panel.Img_PlayerHead.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    --初始化基本人物信息
    self.panel.TxtPlayerName.LabText = MPlayerInfo.Name
    self.panel.TxtPlayerID.LabText = tostring(MPlayerInfo.UID)
    self.panel.TxtPlayerProfession.LabText = DataMgr:GetData("TeamData").GetProfessionNameById(MPlayerInfo.ProID)
    local cShowLv, cProNum = Common.CommonUIFunc.GetShowJobLevelAndProByLv(MPlayerInfo.JobLv, MPlayerInfo.ProfessionId)
    self.panel.Txt_BaseLv.LabText = "Lv" .. MPlayerInfo.Lv
    self.panel.Txt_JobLv.LabText = "Lv" .. cShowLv
    self.panel.RoleInfoDetail.gameObject:SetActiveEx(true)
    self.firstLevelAttr = {}
    local attrList = l_roleInfoMgr.GetSortTable()
    --初始化右面板
    for i = 1, table.maxn(attrList) do
        --创建UI
        self.firstLevelAttr[i] = {}
        self.firstLevelAttr[i].ui = self:CloneObj(self.panel.AttrTpl.gameObject)
        self.firstLevelAttr[i].ui.transform:SetParent(self.panel.AttrTpl.transform.parent)
        self.firstLevelAttr[i].ui.transform:SetLocalScaleOne()
        self:ExportFirstLevelElement(self.firstLevelAttr[i])
        --初始化
        local name = attrList[i].name
        self.firstLevelAttr[i].name.LabText = name
        self.firstLevelAttr[i].attrIcon:SetSprite(attrList[i].atlas, attrList[i].icon, true)
        self.firstLevelAttr[i].btnAdd:AddClick(function()
            l_roleInfoMgr.l_RecommendAttrId = 0
            self:AddAttr(attrList[i].base)
        end)
        self.firstLevelAttr[i].btnSub:AddClick(function()
            l_roleInfoMgr.l_RecommendAttrId = 0
            self:SubAttr(attrList[i].base)
        end)
        self.firstLevelAttr[i].btnAddVip.onDown = function()
            self.inStateAutoAdd = true
            self.stateAddTime = -40
            self.addId = attrList[i].base
        end
        self.firstLevelAttr[i].btnAddVip.onUp = function()
            self.inStateAutoAdd = false
        end
        self.firstLevelAttr[i].btnSubVip.onDown = function()
            self.inStateAutoSub = true
            self.stateSubTime = -40
            self.subId = attrList[i].base
        end
        self.firstLevelAttr[i].btnSubVip.onUp = function()
            self.inStateAutoSub = false
        end

        self.firstLevelAttr[i].btnAttrTips:AddClick(function()
            if attrList[i].attrTableData.AttrTips and attrList[i].attrTableData.AttrTips ~= "" then
                MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(attrList[i].attrTableData.AttrTips, l_pointEventData, Vector2(0.5, 0), false, nil, MUIManager.UICamera, true)
            end
        end)
    end

    self.panel.AttrTpl.gameObject:SetActiveEx(false)
    self.panel.DlgPanel.gameObject:SetActiveEx(false)
    self.panel.Btn_CloseSeverLevel.gameObject:SetActiveEx(false)
    
    --普通信息
    self.panel.BtnMiddle_A:OnToggleExChanged(function(value)
        if value then
            PlayAnimation(self.panel.Detail.gameObject)
            self.panel.Common.gameObject:SetActiveEx(true)
            self.panel.Detail.gameObject:SetActiveEx(false)
        end
    end)

    --详细信息
    self.panel.BtnMiddle_B:OnToggleExChanged(function(value)
        if value then
            PlayAnimation(self.panel.Common.gameObject)
            self.panel.Common.gameObject:SetActiveEx(false)
            self.panel.Detail.gameObject:SetActiveEx(true)
            if not self.isInitLeftInfo then
                self:InitLeftInfo()
                self.isInitLeftInfo = true
            end
            self:RefreshUI()
            LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.ScrollContent.transform)
        end
    end)

    self.panel.BtnMiddle_A.TogEx.isOn = true

    self.panel.Btn_CloseSeverLevel:AddClick(function()
        self.panel.Btn_CloseSeverLevel.gameObject:SetActiveEx(false)
    end)

    self.panel.BtnServerLv:AddClick(function()
        l_roleInfoMgr.GetServerLevelBonusInfo()
        self.panel.Btn_CloseSeverLevel.gameObject:SetActiveEx(true)
    end)

    self.panel.BtnInfo:AddClick(function()
        self.panel.DlgPanel.gameObject:SetActiveEx(true)
        self:ForceUpdate(self.panel.Content)
    end)

    self.panel.Btn_AutoAdd:AddClick(function()
        local hasAddAttr = l_roleInfoMgr.AutoAddPoint()
        if hasAddAttr then
            self:SetSavePanelState(hasAddAttr)
            self.cClickAutoFight = true
            self.panel.BtnMiddle_B.TogEx.isOn = true
        end
    end)

    self.panel.BtnCancelInfo:AddClick(function()
        l_roleInfoMgr.ResetPlusAttrAndRefresh()
        self:SetSavePanelState(false)
    end)

    self.panel.ButtonCloseDilog:AddClick(function()
        self.panel.DlgPanel.gameObject:SetActiveEx(false)
    end)

    self.panel.Tittle_1.Tog.isOn = true
    self.panel.Tittle_2.Tog.isOn = true
    self.panel.Tittle_3.Tog.isOn = true
    self.panel.Tittle_1.Tog.onValueChanged:AddListener(function(value)
        self.panel.AbilityGrp_1.gameObject:SetActiveEx(value)
        self.panel.Arrow[1].transform:SetLocalScale(value and 1 or -1, 1, 1)
    end)

    self.panel.Tittle_2.Tog.onValueChanged:AddListener(function(value)
        self.panel.AbilityGrp_2.gameObject:SetActiveEx(value)
        self.panel.Arrow[2].transform:SetLocalScale(value and 1 or -1, 1, 1)
    end)

    self.panel.Tittle_3.Tog.onValueChanged:AddListener(function(value)
        self.panel.AbilityGrp_3.gameObject:SetActiveEx(value)
        self.panel.Arrow[3].transform:SetLocalScale(value and 1 or -1, 1, 1)
    end)

    local careerrow
    if MPlayerInfo.ProfessionId then
        careerrow = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
    end
    
    local l_careerImgPath
    if careerrow then
        l_careerImgPath = MPlayerInfo.IsMale and careerrow.ProfessionSharePic[0] or careerrow.ProfessionSharePic[1]
    end

    if string.ro_isEmpty(l_careerImgPath) or MgrMgr:GetMgr("ShareMgr").CanShare_merge() == false then
        self.panel.ShareButton.gameObject:SetActive(false)
    else
        self.panel.ShareButton.gameObject:SetActive(true)
    end
    self.panel.ShareButton:AddClick(function()
        if string.ro_isEmpty(l_careerImgPath) then
            return
        end
        MgrMgr:GetMgr("ShareMgr").OpenShareUI(l_roleShareID, nil,MgrMgr:GetMgr("ShareMgr").ShareID.RoleShare, nil)
    end)

    self.panel.BtnApplyInfo:AddClick(function()
        -- 变身期间不能加点
        if MEntityMgr.PlayerEntity.IsTransfigured then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_ATTR_POINT"))
            self:SetSavePanelState(false)
            return
        end

        local attrAddList = {}
        local attrList = l_roleInfoMgr.GetSortTable() --l_roleInfoMgr.BasicAttrList
        local hasAddAttr = false
        for i = 1, table.maxn(attrList) do
            local plusAttr = l_roleInfoMgr.PlayerAttr[attrList[i].base].plusAttr
            if plusAttr >= 0.01 then
                table.insert(attrAddList, { attr_type = attrList[i].base, attr_value = plusAttr })
                if plusAttr > 0 then
                    hasAddAttr = true
                end
            end
        end

        if hasAddAttr then
            l_roleInfoMgr.RequestAttrAdd(attrAddList)
            self.panel.RoleInfoDetail.gameObject:SetActiveEx(true)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_NOT_PLUS_ATTR"))
        end
        --self:SetSavePanelState(false)
    end)
    --推荐按钮
    self.panel.Btn_tuijian:AddClick(function()
        -- 变身期间不能加点
        if MEntityMgr.PlayerEntity.IsTransfigured then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_ATTR_POINT"))
            return
        end

        l_roleInfoMgr.ResetPlusAttrAndRefresh()
        self:SetSavePanelState(false)

        UIMgr:ActiveUI(CtrlNames.AddAttrSchools, function(ctrl)
            ctrl:InitWithAttrTypeId(tonumber(MPlayerInfo.ProID))
        end)
    end)
    --洗点按钮
    self.panel.Btn_xidian:AddClick(function()
        --判定又没有过加点操作
        if l_roleInfoMgr.PlayerAttr and l_roleInfoMgr.PlayerAttr.totalQualityPoint and l_roleInfoMgr.PlayerAttr.totalQualityPoint >= l_roleInfoMgr.GetTotalQualityPoint() then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_NOT_NEED_CLEAR_TIPS"))
        else
            self:ResetRoleAttrs()
        end
    end)

    if MgrMgr:GetMgr("MultiTalentMgr").IsMultiTalentMgrOpen(GameEnum.MultiTaltentType.Attr) then
        if self.multiTalentsSelectTemplate == nil then
            self.multiTalentsSelectTemplate = self:NewTemplate("MultiTalentsSelectTemplate", {
                TemplateParent = self.panel.AttrParent.transform
            })
        end
        self.multiTalentsSelectTemplate:SetData(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.AttrMultiTalent)
    end

    self.panel.Btn_BaseLVTips:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MARK_TIPS_BASELV"), l_pointEventData, Vector2(0, 0.5), false, nil, MUIManager.UICamera, true)
    end)
    self.panel.Btn_JobLVTips:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MARK_TIPS_JOBLV"), l_pointEventData, Vector2(0, 0.5), false, nil, MUIManager.UICamera, true)
    end)
    self.panel.Btn_BaseTips:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MARK_TIPS_BASE"), l_pointEventData, Vector2(0.5, 0.5), false, nil, MUIManager.UICamera, true)
    end)
    self.panel.Btn_JobTips:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MARK_TIPS_JOB"), l_pointEventData, Vector2(0.5, 0.5), false, nil, MUIManager.UICamera, true)
    end)
    self.panel.Btn_HpTips:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MARK_TIPS_HP"), l_pointEventData, Vector2(0, 0.5), false, nil, MUIManager.UICamera, true)
    end)
    self.panel.Btn_SpTips:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MARK_TIPS_SP"), l_pointEventData, Vector2(0, 0.5), false, nil, MUIManager.UICamera, true)
    end)
    self.panel.Btn_VigourTips:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MARK_TIPS_VIGOUR"), l_pointEventData, Vector2(0, 0.5), false, nil, MUIManager.UICamera, true)
    end)

    self.panel.BtnMiddle_A.TogEx.isOn = true
    self.panel.Explain.LabText = Lang("ADDATTR_OPERATION_INTRODUCE")

    self.panel.AttrScrollRect:SetScrollRectGameObjListener(self.panel.ImageUp.gameObject, self.panel.ImageDown.gameObject, nil, nil)
end

--重置技能
function RoleInfoHandler:ResetRoleAttrs()
    --变身期间不能加点
    if MEntityMgr.PlayerEntity.IsTransfigured then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_ATTR_POINT"))
        return
    end

    if not l_roleInfoMgr.HasBaseAttrAdded() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_NOT_NEED_CLEAR_TIPS"))
        return
    end

    if TableUtil.GetGlobalTable().GetRowByName("ResetPropertyPointCost") == nil then
        logError("GlobalTable ResetPropertyPointCost is nil @沈天考")
        return
    end

    local leftAttrCount = MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ATTR_RESET, '0')

    if leftAttrCount > 0 then
        local l_txt = Lang("ATTR_LIMIT_WORDS", leftAttrCount)
        local l_txtConfirm = Lang("DLG_BTN_YES")--"确定"
        local l_txtCancel = Lang("DLG_BTN_NO")--"取消"
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
            l_roleInfoMgr.RequestAttrClear()
        end)
        return
    end

    --消耗
    local l_consume = MGlobalConfig:GetVectorSequence("ResetPropertyPointCost")
    local l_consumeDatas = {}
    for i = 0, l_consume.Length - 1 do
        local l_data = {}
        l_data.ID = tonumber(l_consume[i][0])
        l_data.IsShowCount = false
        l_data.IsShowRequire = true
        l_data.RequireCount = tonumber(l_consume[i][1])
        table.insert(l_consumeDatas, l_data)
    end

    CommonUI.Dialog.ShowConsumeDlg("", Common.Utils.Lang("ATTRLEARNING_RESET_SKILL_NEED_ITEM"),
            function()
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("ATTRLEARNING_CONFIRM_RESET_SKILL"), function()
                    l_roleInfoMgr.RequestAttrClear()
                end, function()
                end)
            end, nil, l_consumeDatas)

end

function RoleInfoHandler:ChangeToDetail()
    if self.panel ~= nil and self.cClickAutoFight then
        self.panel.BtnMiddle_B.TogEx.isOn = true
        self.cClickAutoFight = false
    end
end

function RoleInfoHandler:SetRoleInfoSavePanelState(state)
    if state then
        self:SetSavePanelState(state)
    end
end

function RoleInfoHandler:ForceUpdate(obj)
    if obj then
        LayoutRebuilder.ForceRebuildLayoutImmediate(obj.transform)
    end
end

--设置服务器等级
function RoleInfoHandler:SetServerLevel()
    local l_data = MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData
    self.panel.Btn_CloseSeverLevel:SetActiveEx(true)
    self.serverLevelTipsTemplate:SetGameObjectActive(true)
    self.serverLevelTipsTemplate:SetData(l_data)
end

--获取配置表里的base等级上限
function RoleInfoHandler:GetBaseLevelUpperLimitByServerLevel(serverLv)
    local l_rows = TableUtil.GetServerLevelTable().GetTable()
    local l_rowCount = #l_rows
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        if l_row.ServeLevel == serverLv then
            return l_row.BaseLevelUpperLimit
        end
    end
    return 0
end

function RoleInfoHandler:RefreshPolygon()
    local cSetPolygon = self.panel.Liubianxing.gameObject:GetComponent("MUISetPolygon")
    local cArr = l_roleInfoMgr.GetSortTable()

    local cLevelAllPoint = l_roleInfoMgr.GetQualityPointByLevel(MPlayerInfo.Lv)   --当前等级可以获得的所有素质点
    local cLevelStatePoint = l_roleInfoMgr.GetStatPointByAllPoint(cLevelAllPoint) --当前的所有素质点可以加的属性值

    local cValueTable = { 0.4, 0.4, 0.4, 0.4, 0.4, 0.4 }
    if MPlayerInfo.Lv > 1 then
        for i = 1, table.maxn(cArr) do
            local baseAttr = l_roleInfoMgr.PlayerAttr[cArr[i].base].baseAttr
            local nowValueTb = l_roleInfoMgr.l_qualityPointPageInfo and l_roleInfoMgr.l_qualityPointPageInfo[l_roleInfoMgr.l_curPage] or nil
            local showValue = nowValueTb and nowValueTb.point_list[cArr[i].base] or baseAttr
            --为什么-1 之前默认是0点 现在服务器默认给了1点 但是表现要求还是按照0点表现
            local cFinValue = ((showValue - 1) / cLevelStatePoint)
            local cNum = tonumber(0.4 + (0.6 * cFinValue))
            if cNum > 1 then
                cValueTable[i] = 1
            elseif cNum < 0 then
                cValueTable[i] = 0.4
            else
                cValueTable[i] = cNum
            end
            cSetPolygon:SetValueByIndex(i - 1, cValueTable[i])
            if i == 1 then
                self.panel.AttrValue[1].LabText = showValue
            elseif i == 2 then
                self.panel.AttrValue[2].LabText = showValue
            elseif i == 3 then
                self.panel.AttrValue[6].LabText = showValue
            elseif i == 4 then
                self.panel.AttrValue[4].LabText = showValue
            elseif i == 5 then
                self.panel.AttrValue[3].LabText = showValue
            elseif i == 6 then
                self.panel.AttrValue[5].LabText = showValue
            end
        end
    end

    --马之力需求关闭变身重置六维图
    --[[
    if MEntityMgr.PlayerEntity.IsTransfigured then
        cValueTable = {0.4,0.4,0.4,0.4,0.4,0.4}
    end
    ]]--

    cSetPolygon:SetValueByIndex(0, cValueTable[1])
    cSetPolygon:SetValueByIndex(1, cValueTable[2])
    cSetPolygon:SetValueByIndex(2, cValueTable[5])
    cSetPolygon:SetValueByIndex(3, cValueTable[4])
    cSetPolygon:SetValueByIndex(4, cValueTable[6])
    cSetPolygon:SetValueByIndex(5, cValueTable[3])
    cSetPolygon.enabled = false
    cSetPolygon.enabled = true
end

--刷新玩家基本信息
function RoleInfoHandler:RefreshRoleInfo()
    if self.panel ~= nil then
        local l_player = MEntityMgr.PlayerEntity
        if l_player == nil then
            return
        end
        if self.cSliderBaseExp == nil or self.cSliderJobExp == nil or self.cSliderHp == nil or self.cSliderSp == nil then
            self.cSliderBaseExp = self.panel.Slider_Base.gameObject:GetComponent("Slider")
            self.cSliderJobExp = self.panel.Slider_Job.gameObject:GetComponent("Slider")
            self.cSliderHp = self.panel.Slider_Hp.gameObject:GetComponent("Slider")
            self.cSliderSp = self.panel.Slider_Sp.gameObject:GetComponent("Slider")
        end
        self.cSliderBaseExp.value = MPlayerInfo.ExpRate
        self.cSliderJobExp.value = MPlayerInfo.JobExpRate
        self.cSliderHp.value = (l_player.AttrComp.HP / l_player.AttrComp.MaxHP >= 0 and l_player.AttrComp.HP / l_player.AttrComp.MaxHP <= 1) and l_player.AttrComp.HP / l_player.AttrComp.MaxHP or 0
        self.cSliderSp.value = (l_player.AttrComp.SP / l_player.AttrComp.MaxSP >= 0 and l_player.AttrComp.SP / l_player.AttrComp.MaxSP <= 1) and l_player.AttrComp.SP / l_player.AttrComp.MaxSP or 0
        self.panel.Txt_Base.LabText = tostring(MPlayerInfo.Exp) .. "/" .. tostring(l_roleInfoMgr.GetLevelExp(MPlayerInfo.Lv))
        self.panel.Txt_Job.LabText = tostring(MPlayerInfo.JobExp) .. "/" .. tostring(l_roleInfoMgr.GetJobLvExp(MPlayerInfo.JobLv))
        self.panel.Txt_Hp.LabText = l_player.AttrComp.HP .. "/" .. l_player.AttrComp.MaxHP
        self.panel.Txt_Sp.LabText = l_player.AttrComp.SP .. "/" .. l_player.AttrComp.MaxSP

        --依据服务器等级处理下BaseExp Slider显示
        local l_data = l_roleInfoMgr.SeverLevelData
        if l_data.serverlevel ~= nil then
            local serverBaseLimit = self:GetBaseLevelUpperLimitByServerLevel(l_data.serverlevel)
            self.cSliderBaseExp.value = MPlayerInfo.Lv >= serverBaseLimit and 1 or MPlayerInfo.ExpRate
            self.panel.Txt_Base.LabText = MPlayerInfo.Lv >= serverBaseLimit and tostring(MPlayerInfo.Exp) .. "/--" or tostring(MPlayerInfo.Exp) .. "/" .. tostring(l_roleInfoMgr.GetLevelExp(MPlayerInfo.Lv))
            if MPlayerInfo.Lv >= serverBaseLimit then
                self.panel.ColliderExp.Listener.onDown = function(b)
                    MgrMgr:GetMgr("TipsMgr").ShowTipsInfo({
                        title = Common.Utils.Lang("EXP_UPPERLIMIT_TITLE"),
                        content = Common.Utils.Lang("EXP_UPPERLIMIT_DETAIL"),
                        relativeTransform = self.panel.ColliderExp.transform,
                        relativeOffsetX = 35,
                        relativeOffsetY = 20,
                    })
                end

                self.panel.ColliderExp.Listener.onUp = function()
                    MgrMgr:GetMgr("TipsMgr").HideTipsInfo()
                end
            end
        end

        self:RefreshVigourInfo()
    end
end

--初始化左边面板
function RoleInfoHandler:InitLeftInfo()
    self.secondLevelAttr = {}
    table.sort(l_roleInfoMgr.SecondLevelList, function(x, y)
        local l_tableX = TableUtil.GetAttrInfoTable().GetRowById(x.base)
        local l_tableY = TableUtil.GetAttrInfoTable().GetRowById(y.base)
        return l_tableX.ShortId < l_tableY.ShortId
    end)

    local secondTypeAttr = l_roleInfoMgr.SecondAttrTypeList
    for k, v in pairs(secondTypeAttr) do
        if k ~= 1 then
            self.secondLevelAttr[k] = {}
            for i = 1, table.maxn(v) do
                self.secondLevelAttr[k][i] = {}
                --创建UI
                if k == 4 then
                    self.secondLevelAttr[k][i].ui = self:CloneObj(self.panel.AttrInfoTpl_1.gameObject)
                else
                    self.secondLevelAttr[k][i].ui = self:CloneObj(self.panel.AttrInfoTpl.gameObject)
                end
                self.secondLevelAttr[k][i].ui.transform:SetParent(self:GetParentByAttrType(k))
                self.secondLevelAttr[k][i].ui.transform:SetLocalScaleOne()
                self:ExportSecondLevelElement(self.secondLevelAttr[k][i])
                --初始化
                self.secondLevelAttr[k][i].name.LabText = v[i].name
                --长度大于一定长度 开启跑马灯
                if self.secondLevelAttr[k][i].marquee and #v[i].name > 18 then
                    self.secondLevelAttr[k][i].marquee:CheckStartMarquee()
                end
                self.secondLevelAttr[k][i].bgImageListener.onDown = function()
                    self.secondLevelAttr[k][i].detail.gameObject:SetActiveEx(true)
                end
                self.secondLevelAttr[k][i].bgImageListener.onUp = function()
                    self.secondLevelAttr[k][i].detail.gameObject:SetActiveEx(false)
                end
            end
        end
    end

    self.panel.AttrInfoTpl.gameObject:SetActiveEx(false)
    self.panel.AttrInfoTpl_1.gameObject:SetActiveEx(false)
end

--找不同类型的属性的父节点
function RoleInfoHandler:GetParentByAttrType(attrType)
    if attrType == 2 then
        return self.panel.AbilityGrp_1.transform
    end
    if attrType == 3 then
        return self.panel.AbilityGrp_2.transform
    end
    if attrType == 4 then
        return self.panel.AbilityGrp_3.transform
    end
end

function RoleInfoHandler:HideRoleAttrByType(attrType)
    if attrType == 2 then
        self.panel.AbilityGrp_1.gameObject:SetActiveEx(false)
    end
    if attrType == 3 then
        self.panel.AbilityGrp_2.gameObject:SetActiveEx(false)
    end
    if attrType == 4 then
        self.panel.AbilityGrp_3.gameObject:SetActiveEx(false)
    end
end

function RoleInfoHandler:RefreshUI()
    --用属性去刷UI
    local isShow = false
    if not self.uObj then
        return
    end
    local attrList = l_roleInfoMgr.GetSortTable() --l_roleInfoMgr.BasicAttrList
    for i = 1, table.maxn(attrList) do
        if self.firstLevelAttr and self.firstLevelAttr[i].ui then
            local baseAttr = l_roleInfoMgr.PlayerAttr[attrList[i].base].baseAttr
            local equipAttr = l_roleInfoMgr.PlayerAttr[attrList[i].base].equipAttr
            local plusAttr = l_roleInfoMgr.PlayerAttr[attrList[i].base].plusAttr
            local nextCost = l_roleInfoMgr.PlayerAttr[attrList[i].base].nextCost
            local nowValueTb = l_roleInfoMgr.l_qualityPointPageInfo and l_roleInfoMgr.l_qualityPointPageInfo[l_roleInfoMgr.l_curPage] or nil
            --[[if MEntityMgr.PlayerEntity.IsTransfigured then
                self.firstLevelAttr[i].baseAttr.LabText = "0"
                self.firstLevelAttr[i].equipAttr.LabText = "0"
                self.firstLevelAttr[i].plusAttr.LabText = "+0"
                self.firstLevelAttr[i].costAttr.LabText = "0"
            else]]--
            --默认数据读取从服务器传过来的数据 假如服务器数据为空 再以自己计算的为显示
            self.firstLevelAttr[i].baseAttr.LabText = nowValueTb and nowValueTb.point_list[attrList[i].base] or baseAttr
            self.firstLevelAttr[i].equipAttr.LabText = equipAttr
            self.firstLevelAttr[i].plusAttr.LabText = "+" .. plusAttr
            self.firstLevelAttr[i].costAttr.LabText = MEntityMgr.PlayerEntity.IsTransfigured and 0 or nextCost
            --end
            if isShow == false then
                isShow = plusAttr > 0
            end
            self.firstLevelAttr[i].plusAttr.gameObject:SetActiveEx(plusAttr > 0)
        end
    end
    self:SetSavePanelState(isShow)
    if MEntityMgr.PlayerEntity.IsTransfigured then
        self.panel.Txt_Point.LabText = "0"
    else
        self.panel.Txt_Point.LabText = l_roleInfoMgr.PlayerAttr.totalQualityPoint
    end

    local secondTypeAttr = l_roleInfoMgr.SecondAttrTypeList
    for k, secondAttr in pairs(secondTypeAttr) do
        if k ~= 1 then
            for i = 1, table.maxn(secondAttr) do
                if self.secondLevelAttr and self.secondLevelAttr[k] and self.secondLevelAttr[k][i] and self.secondLevelAttr[k][i].ui then
                    local preBaseAttr = l_roleInfoMgr.PlayerAttr[secondAttr[i].base].preBaseAttr or 0
                    local preEquipAttr = l_roleInfoMgr.PlayerAttr[secondAttr[i].base].preEquipAttr or 0
                    local afterBaseAttr = l_roleInfoMgr.PlayerAttr[secondAttr[i].base].afterBaseAttr or 0
                    local afterEquipAttr = l_roleInfoMgr.PlayerAttr[secondAttr[i].base].afterEquipAttr or 0
                    local addedAttr = (afterBaseAttr + afterEquipAttr) - (preBaseAttr + preEquipAttr)
                    local l_table = secondAttr[i].attrTableData
                    if not l_table then
                        return
                    end

                    --是否显示这一条属性
                    local isShow = l_roleInfoMgr.GetIsNeedShowSpecialAttr(l_table)
                    self.secondLevelAttr[k][i].ui:SetActiveEx(isShow)

                    local curBaseAttr = preBaseAttr + afterEquipAttr
                    self.secondLevelAttr[k][i].bgImage.gameObject:SetActiveEx(false)
                    self.secondLevelAttr[k][i].plusAttr.gameObject:SetActiveEx(addedAttr > 0)
                    self.secondLevelAttr[k][i].btnAttrTips:AddClick(function()
                        if l_table.AttrTips and l_table.AttrTips ~= "" then
                            MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_table.AttrTips, l_pointEventData, Vector2(0, 0.5), false, nil, MUIManager.UICamera, true)
                        end
                    end)

                    --特判移动速度
                    if secondAttr[i].base == l_roleInfoMgr.ATTR_BASIC_MOVE_SPD_FINAL then
                        --要根据职业拿出来对应的基础移动速度
                        local moveSpeed = l_roleInfoMgr.GetMyPlayerMoveSpeed()
                        if moveSpeed == 0 then
                            moveSpeed = 1
                        end
                        --统一保留小数点后两位精度
                        local l_preAttr =  math.floor(preBaseAttr / moveSpeed * 100) / 100
                        local l_addedAttr = math.floor(addedAttr / moveSpeed * 100) / 100
                        --logError("保留两位精度后的速度: " .. l_preAttr .. "," .. l_addedAttr)
                        -- 四舍五入
                        if l_table.FloorNum == 0 then
                            l_preAttr = math.floor(l_preAttr + 0.5)
                            l_addedAttr = math.floor(l_addedAttr + 0.5)
                            --logError("四舍五入速度: " .. l_preAttr .. "," .. l_addedAttr)
                        end
                        self.secondLevelAttr[k][i].baseAttr.LabText = l_roleInfoMgr.GetAttrNum(l_preAttr, l_table.FloorNum) .. "%"
                        self.secondLevelAttr[k][i].plusAttr.LabText = "+" .. l_roleInfoMgr.GetAttrNum(l_addedAttr, l_table.FloorNum) .. "%"
                        --固定吟唱 可变吟唱 特殊判断
                    elseif (secondAttr[i].base == l_roleInfoMgr.ATTR_BASIC_CT_FIXED
                            or secondAttr[i].base == l_roleInfoMgr.ATTR_BASIC_CT_FIXED_FINAL
                            or secondAttr[i].base == l_roleInfoMgr.ATTR_BASIC_CT_CHANGE
                            or secondAttr[i].base == l_roleInfoMgr.ATTR_BASIC_CT_CHANGE_FINAL
                            or secondAttr[i].base == l_roleInfoMgr.ATTR_BASIC_CD_CHANGE
                            or secondAttr[i].base == l_roleInfoMgr.ATTR_BASIC_GROUP_CD_CHANGE) then
                        if l_table.EquipId > 0 then
                            self.secondLevelAttr[k][i].detailBase.LabText = l_roleInfoMgr.GetAttrNum((preBaseAttr / 10000), l_table.FloorNum) .. " + " .. l_roleInfoMgr.GetAttrNum((afterEquipAttr / 10000), l_table.FloorNum)
                        end
                        self.secondLevelAttr[k][i].baseAttr.LabText = l_roleInfoMgr.GetAttrNum((curBaseAttr / 10000), l_table.FloorNum)
                        self.secondLevelAttr[k][i].plusAttr.LabText = l_roleInfoMgr.GetAttrNum((addedAttr / 10000), l_table.FloorNum)
                    elseif (secondAttr[i].isPercent
                            and secondAttr[i].base ~= l_roleInfoMgr.ATTR_BASIC_MAX_HP_FINAL
                            and secondAttr[i].base ~= l_roleInfoMgr.ATTR_BASIC_MAX_SP_FINAL) then
                        if l_table.EquipId > 0 then
                            self.secondLevelAttr[k][i].detailBase.LabText = l_roleInfoMgr.GetAttrNum(preBaseAttr / 100, l_table.FloorNum) .. "%" .. " + " .. l_roleInfoMgr.GetAttrNum(afterEquipAttr / 100, l_table.FloorNum) .. "%"
                        end
                        self.secondLevelAttr[k][i].baseAttr.LabText = l_roleInfoMgr.GetAttrNum(curBaseAttr / 100, l_table.FloorNum) .. "%"
                        local str = addedAttr > 0 and "+" .. l_roleInfoMgr.GetAttrNum(addedAttr / 100, l_table.FloorNum) .. "%" or l_roleInfoMgr.GetAttrNum(addedAttr / 100, l_table.FloorNum) .. "%"
                        self.secondLevelAttr[k][i].plusAttr.LabText = str
                        if (addedAttr ~= 0 and math.abs(addedAttr) > 100
                                and (secondAttr[i].base == l_roleInfoMgr.ATTR_PERCENT_CT_FIXED
                                or secondAttr[i].base == l_roleInfoMgr.ATTR_PERCENT_CT_FIXED_FINAL
                                or secondAttr[i].base == l_roleInfoMgr.ATTR_PERCENT_CT_CHANGE
                                or secondAttr[i].base == l_roleInfoMgr.ATTR_PERCENT_CT_CHANGE_FINAL)) then
                            self.secondLevelAttr[k][i].plusAttr.gameObject:SetActiveEx(true)
                        end
                    else
                        if l_table.EquipId > 0 then
                            self.secondLevelAttr[k][i].detailBase.LabText = tostring(preBaseAttr) .. " + " .. tostring(afterEquipAttr)
                        end
                        self.secondLevelAttr[k][i].baseAttr.LabText = tostring(curBaseAttr)
                        self.secondLevelAttr[k][i].plusAttr.LabText = tostring("+" .. addedAttr)
                    end
                end
            end
        end
    end
end

function RoleInfoHandler:AddAttr(attrId)
    -- 变身期间不能加点
    if MEntityMgr.PlayerEntity.IsTransfigured then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_ATTR_POINT"))
        return
    end

    local ret = false
    local maxAttrPoint = l_roleInfoMgr.GetAttrLimit(attrId)
    local baseAttr = l_roleInfoMgr.PlayerAttr[attrId].baseAttr
    local equipAttr = l_roleInfoMgr.PlayerAttr[attrId].equipAttr
    local plusAttr = l_roleInfoMgr.PlayerAttr[attrId].plusAttr
    local nextCost = l_roleInfoMgr.PlayerAttr[attrId].nextCost
    local totalPoint = l_roleInfoMgr.PlayerAttr.totalQualityPoint
    if baseAttr + plusAttr >= maxAttrPoint then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_MAX_ADDED"))
    elseif totalPoint < nextCost then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_NOT_ENOUGH"))
    end

    if (baseAttr + plusAttr < maxAttrPoint) and totalPoint >= nextCost then
        self.panel.BtnMiddle_B.TogEx.isOn = true
        self:SetSavePanelState(true)

        l_roleInfoMgr.PlayerAttr[attrId].plusAttr = plusAttr + 1
        self:RoleInfoHandlerRefresh()
        ret = true
    end
    return ret
end

function RoleInfoHandler:SubAttr(attrId)
    -- 变身期间不能加点
    if MEntityMgr.PlayerEntity.IsTransfigured then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_ATTR_POINT"))
        return
    end

    local ret = false
    local maxAttrPoint = l_roleInfoMgr.GetAttrLimit(attrId)
    local baseAttr = l_roleInfoMgr.PlayerAttr[attrId].baseAttr
    local equipAttr = l_roleInfoMgr.PlayerAttr[attrId].equipAttr
    local plusAttr = l_roleInfoMgr.PlayerAttr[attrId].plusAttr
    local nextCost = l_roleInfoMgr.PlayerAttr[attrId].nextCost
    local totalPoint = l_roleInfoMgr.PlayerAttr.totalQualityPoint
    if plusAttr > 0 then
        self.panel.BtnMiddle_B.TogEx.isOn = true
        self:SetSavePanelState(true)

        l_roleInfoMgr.PlayerAttr[attrId].plusAttr = plusAttr - 1
        self:RoleInfoHandlerRefresh()
        ret = true
    end
    return ret
end

function RoleInfoHandler:RefreshHead()
    ---@type HeadTemplateParam
    local param = {
        ShowProfession = true,
        IsPlayerSelf = true,
    }

    self.head2d:SetData(param)
end

function RoleInfoHandler:Close()
    l_roleInfoMgr.ResetPlusAttr()
    UIMgr:DeActiveUI("RoleInfo")
end

function RoleInfoHandler:ExportFirstLevelElement(element)
    element.baseAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Base"))
    element.equipAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Equip"))
    element.plusAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Plus"))
    element.costAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Cost"))
    element.btnAdd = element.ui.transform:Find("Btn_jia"):GetComponent("MLuaUICom")
    element.btnSub = element.ui.transform:Find("Btn_jian"):GetComponent("MLuaUICom")
    element.btnAddVip = element.ui.transform:Find("Btn_jia"):GetComponent("MLuaUIListener")
    element.btnSubVip = element.ui.transform:Find("Btn_jian"):GetComponent("MLuaUIListener")
    element.name = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("AttrName"))
    element.attrIcon = element.ui.transform:Find("AttrIcon"):GetComponent("MLuaUICom")
    element.attrImg = element.ui.transform:Find("AttrIcon"):GetComponent("Image")
    element.btnAttrTips = element.ui.transform:Find("Btn_AttrTips"):GetComponent("MLuaUICom")
end

function RoleInfoHandler:ExportSecondLevelElement(element)
    element.bgImage = element.ui.transform:Find("Image"):GetComponent("MLuaUICom")
    element.bgImageListener = element.ui.transform:Find("Image"):GetComponent("MLuaUIListener")
    element.baseAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Num"))
    element.plusAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Plus"))
    element.name = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("NameParent/Name"))
    element.marquee = element.ui.transform:Find("NameParent/Name"):GetComponent("UIMarquee")
    element.detail = element.ui.transform:Find("Detail")
    element.detailBase = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Detail/attrBase"))
    element.btnAttrTips = element.ui.transform:Find("AttrInfoBtn"):GetComponent("MLuaUICom")
end

function RoleInfoHandler:ExportRecommendElement(element)
    element.imageIcon = element.ui.transform:Find("Image"):GetComponent("MLuaUICom")
    element.tips1 = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Tips1"))
    element.tips2 = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Tips2"))
    element.tips3 = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Tips3"))
    element.btnSelected = element.ui.transform:Find("Background"):GetComponent("MLuaUICom")
end

function RoleInfoHandler:RefreshVigourInfo()
    local l_cur_vigour = Data.BagModel:GetCoinOrPropNumById(MgrMgr:GetMgr("PropMgr").l_virProp.Yuanqi)
    local l_max_vigour = l_roleInfoMgr.GetVigourLimit()
    self.panel.Txt_Vigour.LabText = StringEx.Format("{0}/{1}", tostring(l_cur_vigour), l_max_vigour)
    local l_vigour_percent = (l_max_vigour <= 0) and 1 or (l_cur_vigour / l_max_vigour)
    l_vigour_percent = (l_vigour_percent > 1) and 1 or l_vigour_percent
    self.panel.Slider_Vigour.Slider.value = tonumber(l_vigour_percent)
    self.panel.VigourCollider.Listener.onDown = function(b)
        MgrMgr:GetMgr("TipsMgr").ShowTipsInfo({
            title = Common.Utils.Lang("VIGOUR_DESC"),
            content = Common.Utils.Lang("VIGOUR_USE_TIP"),
            relativeTransform = self.panel.VigourCollider.transform,
            relativeOffsetX = 35,
            relativeOffsetY = 20,
        })
    end

end

--人物属性界面的OX按钮的新手指引
function RoleInfoHandler:ShowBeginnerGuide_OX(guideStepInfo)

    if self.panel.RoleInfoSavePanel.UObj.activeSelf then

        local l_guideMgr = MgrMgr:GetMgr("BeginnerGuideMgr")
        --OX按钮类型需要单独重新设置当前步骤
        DataMgr:GetData("BeginnerGuideData").SetCurGuideId(guideStepInfo.ID)

        local l_aimBtn = self.panel.BtnApplyInfo
        l_guideMgr.SetGuideArrowForLuaBtn(self, l_aimBtn.transform.position,
                l_aimBtn.transform, guideStepInfo)

        l_aimBtn:AddClick(function()
            l_guideMgr.LuaBtnGuideClickEvent(self)
        end, false)

    end

end

--设置OX按钮面板状态
function RoleInfoHandler:SetSavePanelState(setState)
    --与原状态不符才做修改
    if self.panel.RoleInfoSavePanel.UObj.activeSelf ~= setState then
        self.panel.RoleInfoSavePanel.UObj:SetActiveEx(setState)
        if setState then
            --开启时触发新手指引检测
            local l_beginnerGuideChecks = { "QualityPointConfirm" }
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks)
        else
            --关闭时检测是否需要关闭新手指引 只是面板关闭不认为完成指引 只是清除原纪录
            if self.guideArrow ~= nil then
                self:UninitTemplate(self.guideArrow)
                self.guideArrow = nil
                DataMgr:GetData("BeginnerGuideData").SetCurGuideId(nil)
            end
        end
    end
end

return RoleInfoHandler
--lua custom scripts end
