--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FashionCollectionPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
FashionCollectionCtrl = class("FashionCollectionCtrl", super)
--lua class define end

--lua functions
function FashionCollectionCtrl:ctor()

    super.ctor(self, CtrlNames.FashionCollection, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function FashionCollectionCtrl:Init()

    self.panel = UI.FashionCollectionPanel.Bind(self)
    super.Init(self)

    self.RowsInfo = {}
    ---@type ModuleMgr.FashionRatingMgr
    self.mgr = MgrMgr:GetMgr("FashionRatingMgr")
    self.rankMgr = MgrMgr:GetMgr("RankMgr")
    ---@type FashionData
    self.data = DataMgr:GetData("FashionData")
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.FashionCollection)
    end)

    self.panel.TogFashion.TogEx.isOn = true
    self.panel.TogFashion.TogEx.onValueChanged:AddListener(function(value)
        if value then
            self.panel.PanelRank.Group.gameObject:SetActiveEx(false)
            if self.data.MaxCount - self.data.GradeCount == 0 then
                self.panel.PanelBefore.Group.gameObject:SetActiveEx(true)
                self:SetCountDown(self.panel.PanelBefore.Time)
            else
                self.panel.PanelAfter.Group.gameObject:SetActiveEx(true)
                self:SetCountDown(self.panel.PanelAfter.Time)
            end
            self.RowsInfo = {}
            self.data.TotalNum = 0
        end
    end)
    self.panel.TogRank.TogEx.onValueChanged:AddListener(function(value)
        if value then
            self.panel.PanelBefore.Group.gameObject:SetActiveEx(false)
            self.panel.PanelAfter.Group.gameObject:SetActiveEx(false)
            self.panel.PanelRank.Group.gameObject:SetActiveEx(true)

            self.panel.PanelRank.Choose.gameObject:SetActiveEx(false)
            --2默认显示所有玩家，0默认最新排行，1默认第一页
            self.rankMgr.RequestLeaderBoardInfo(self.mgr.FashionTableID, 2, 0, 0, true)
        end
    end)

    self.panel.BtnTab.gameObject:SetActiveEx(false)
    self.mgr.RequestFashionEvaluationInfo()
    self.mgr.RequestFashionEvaluationNpc()
    --2默认显示所有玩家，0默认最新排行，1默认第一页
    self.rankMgr.RequestLeaderBoardInfo(self.mgr.FashionTableID, 2, 0, 0, true)

end --func end
--next--
function FashionCollectionCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self.scrollRect = nil
    if self.PlayerModel then
        self:DestroyUIModel(self.PlayerModel)
        self.PlayerModel = nil
    end
    if self.playerModel3D ~= nil then
        self:DestroyUIModel(self.playerModel3D)
        self.playerModel3D = nil
    end
    self:StopCountDown()

end --func end
--next--
function FashionCollectionCtrl:OnActive()


end --func end
--next--
function FashionCollectionCtrl:OnDeActive()


end --func end
--next--
function FashionCollectionCtrl:Update()


end --func end
--next--
function FashionCollectionCtrl:BindEvents()

    self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.InvData, self.InitAll)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.RoleData, function(self, role)
        self:ShowModel3D(role)
    end)
    self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_IS_READY, function(self, strKey, targetRankList)
        self.RowsInfo = {}
        self.data.TotalNum = 0
        self:AddPageInfo(targetRankList)
        if self.panel.TogRank.TogEx.isOn then
            self:RankInit(self.panel.PanelRank)
        else
            self:InitAll()
        end
    end)
    self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_NIL, function(self)
        self.RowsInfo = {}
        self.data.TotalNum = 0
        self:RankInit(self.panel.PanelRank)
    end)
    self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_NEXT_PAGE, function(self, strKey, targetRankList)
        self:AddPageInfo(targetRankList)
        self.panel.PanelRank.ScrollView.LoopScroll:ChangeTotalCount(self.data.TotalNum)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function FashionCollectionCtrl:InitAll()

    self:InvInit(self.panel.PanelInv)
    local l_dailyMgr = MgrMgr:GetMgr("DailyTaskMgr")
    if l_dailyMgr.IsActivityInOpenDay(l_dailyMgr.g_ActivityType.activity_Fashion) then
        self:BeforeInit(self.panel.PanelBefore)
        self:AfterInit(self.panel.PanelAfter)
    end

end

function FashionCollectionCtrl:RankInit(panel)

    if self.scrollRect == nil then
        self.scrollRect = self:NewTemplatePool({
            TemplateClassName = "FashionRankTemplate",
            TemplatePrefab = panel.FashionRank.gameObject,
            ScrollRect = panel.ScrollView.LoopScroll,
            GetDatasMethod = function()
                return self:GetNowPage()
            end,
            Method = function(index, id)
                self:SelectRole(index, id)
            end
        })
    end

    self.scrollRect:ShowTemplates()
    if self.data.TotalNum > 0 then
        local l_one = self:GetNowPage()
        local id = l_one[1].rowValue[3].membersInfo[1].id
        self:SelectRole(1, id)
        panel.Model:SetActiveEx(true)
    else
        panel.Model:SetActiveEx(false)
    end

    panel.FashionRankDescribe.LabText = Lang("FASHION_RANK_DESCRIBE")
    panel.BtnQuestion.gameObject:SetActiveEx(false)
    panel.BtnQuestion.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("FASHIONSTAR_QUESTION"), ed, Vector2(1, 1), false)
    end
    panel.None:SetActiveEx(self.data.TotalNum == 0)
    panel.BtnScreen:AddClick(function()
        DataMgr:GetData("RankData").isGetNextPage = false
        if panel.Choose.gameObject.activeSelf then
            panel.Choose.gameObject:SetActiveEx(false)
            self.mgr.RankKey = 2
            self.rankMgr.RequestLeaderBoardInfo(self.mgr.FashionTableID, 2, 0, 0, true)
        else
            panel.Choose.gameObject:SetActiveEx(true)
            self.mgr.RankKey = 12
            self.rankMgr.RequestLeaderBoardInfo(self.mgr.FashionTableID, 12, 0, 0, true)
        end
    end)

end

function FashionCollectionCtrl:InvInit(panel)

    self:SetCountDown(panel.Time)
    panel.Group.gameObject:SetActiveEx(true)
    panel.Describe.LabText = Lang("FASHION_PRETEXT")
    panel.Title.LabText = Lang("FASHION_TITLE")
    panel.BtnOpen:AddClick(function()
        local l_taskMgr = MgrMgr:GetMgr("DailyTaskMgr")
        if l_taskMgr.IsActivityInOpenDay(l_taskMgr.g_ActivityType.activity_Fashion) then
            self.panel.PanelInv.Group.gameObject:SetActiveEx(false)
            if self.data.MaxCount - self.data.GradeCount == 0 then
                self.panel.PanelBefore.Group.gameObject:SetActiveEx(true)
                self:SetCountDown(self.panel.PanelBefore.Time)
            else
                self.panel.PanelAfter.Group.gameObject:SetActiveEx(true)
                self:SetCountDown(self.panel.PanelAfter.Time)
            end
            self.panel.BtnTab.gameObject:SetActiveEx(true)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_IS_ALREADY_OVER"))
        end
    end)

end

function FashionCollectionCtrl:BeforeInit(panel)

    if self.data.JournalTheme == 0 or self.data.NpcData.sceneId == 0 then
        --logError("非法的时尚主题，是否不在活动时间内？")
        return
    end
    local l_theme = TableUtil.GetFashionThemeTable().GetRowByID(self.data.JournalTheme, true)
    local l_sceneData = TableUtil.GetSceneTable().GetRowByID(self.data.NpcData.sceneId)
    panel.Group.gameObject:SetActiveEx(false)
    if l_theme ~= nil then
        if self.data.CollectRank > 0 and self.data.CollectScore > 0 then
            panel.Describe.LabText = Lang("FASHION_BEFORETEXT", l_theme.Name, self.data.CollectScore, self.data.CollectRank, l_sceneData.MapEntryName)
        else
            panel.Describe.LabText = Lang("FASHION_BEFORETEXT_CIVILIAN", l_theme.Name, l_sceneData.MapEntryName)
        end
    end
    panel.BtnQuestion.gameObject:SetActiveEx(false)
    panel.BtnQuestion.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("FASHION_QUESTION"), ed, Vector2(1, 1), false)
    end
    panel.BtnAward:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.FashionAwardPreview)
    end)
    panel.BtnGo:AddClick(function()
        self.mgr.GotoNpc()
    end)

end

function FashionCollectionCtrl:AfterInit(panel)

    if self.data.JournalTheme == 0 or self.data.NpcData.sceneId == 0 then
        --logError("非法的时尚主题，是否不在活动时间内？")
        return
    end
    panel.Group.gameObject:SetActiveEx(false)
    panel.Describe.LabText = Lang("FASHION_AFTERTEXT", self.data.MaxCount - self.data.GradeCount, self.data.GradeCount, self.data.MaxPoint)
    if self.data.MaxCount - self.data.GradeCount ~= 0 and self.data.PhotoData.type ~= 0 then    --已有记录才刷新照片
        self:ShowModel(self.data.PhotoData, panel.Model, true)
    end
    panel.BtnQuestion.gameObject:SetActiveEx(false)
    panel.BtnQuestion.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("FASHION_QUESTION"), ed, Vector2(1, 1), false)
    end
    panel.BtnAward:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.FashionAwardPreview)
    end)
    panel.BtnShare:AddClick(function()
        MgrMgr:GetMgr("FashionRatingMgr").ShareFashionRating()
    end)
    panel.BtnGo:AddClick(function()
        self.mgr.GotoNpc()
    end)

end

function FashionCollectionCtrl:StopCountDown()

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

end

function FashionCollectionCtrl:SetCountDown(timeUI)

    self:SetTime(timeUI)
    self:StopCountDown()
    self.timer = self:NewUITimer(function()
        self:SetTime(timeUI)
    end, 1, -1)
    self.timer:Start()

end

function FashionCollectionCtrl:GetTimeData(time)

    if StringEx.Length(time) == 4 then
        return tonumber(StringEx.SubString(time, 0, 2)) * 60 + tonumber(StringEx.SubString(time, 2, 2))
    elseif StringEx.Length(time) == 3 then
        return tonumber(StringEx.SubString(time, 0, 1)) * 60 + tonumber(StringEx.SubString(time, 1, 2))
    end
    return 0

end

function FashionCollectionCtrl:SetTime(timeUI)

    local l_taskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    local l_table = TableUtil.GetDailyActivitiesTable().GetRowById(l_taskMgr.g_ActivityType.activity_Fashion)
    local l_beginTime = l_taskMgr.GetBattleTime(l_taskMgr.g_ActivityType.activity_Fashion)
    local l_nowTime = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
    local l_lastTime = l_nowTime - l_beginTime

    local l_endTime = self:GetTimeData(l_table.TimePass[0][1])
    l_beginTime = self:GetTimeData(l_table.TimePass[0][0])
    l_lastTime = l_endTime * 60 - l_beginTime * 60 - l_lastTime
    if l_lastTime <= 0 or not l_taskMgr.IsActivityInOpenDay(l_taskMgr.g_ActivityType.activity_Fashion) then
        timeUI.LabText = Lang("ACTIVITY_IS_ALREADY_OVER")
    else
        local l_hour, l_min, l_second = math.floor(l_lastTime / 3600), math.floor((l_lastTime % 3600) / 60), l_lastTime % 60
        if l_hour == 0 then
            if l_min == 0 then
                timeUI.LabText = Lang("ACTIVITY_TIME_REMAINED") .. "：" .. tostring(l_second) .. Lang("SECOND")
            else
                timeUI.LabText = Lang("ACTIVITY_TIME_REMAINED") .. "：" .. tostring(l_min) .. Lang("MINUTE")
                        .. tostring(l_second) .. Lang("SECOND")
            end
        else
            timeUI.LabText = Lang("ACTIVITY_TIME_REMAINED") .. "：" .. tostring(l_hour) .. Lang("HOURS") .. tostring(l_min)
                    .. Lang("MINUTE") .. tostring(l_second) .. Lang("SECOND")
        end
    end

end

function FashionCollectionCtrl:ShowModel(mainData, model, objData)

    if not self.panel then
        return
    end
    objData = objData and mainData
    if self.PlayerModel and not objData then
        self:DestroyUIModel(self.PlayerModel)
        self.PlayerModel = nil
        model:SetActiveEx(false)
    end

    if not self.PlayerModel and objData then
        local l_attr = MgrMgr:GetMgr("PlayerInfoMgr").GetAttribData(mainData)
        local l_pos, l_scale, l_rotation = mainData:GetPSR()  --拍照时玩家的坐标 缩放 旋转获取
        if not l_pos then
            l_pos = { x = 0, y = -1.51, z = -0.17 }
            l_scale = { x = 1.9, y = 1.9, z = 1.9 }
            l_rotation = { x = -10.295, y = 180, z = 0 }
        end
        local l_vMat, l_pMat = mainData:GetMatData()  --拍照时相机的观察矩阵和投影矩阵获取
        local l_fxData = {}
        l_fxData.rawImage = model.RawImg
        l_fxData.attr = l_attr
        l_fxData.useShadow = false
        l_fxData.useOutLine = false
        l_fxData.useCustomLight = true
        l_fxData.isOneFrame = true
        if l_pMat and l_vMat then
            l_fxData.isCameraMatrixCustom = true
            l_fxData.vMatrix = l_vMat
            l_fxData.pMatrix = l_pMat
            local l_rotEul = MUIModelManagerEx:GetRotationEulerByViewMatrix(l_vMat)
            l_fxData.customLightDirX = 0
            l_fxData.customLightDirY = l_rotEul.y - 180
            l_fxData.customLightDirZ = 0
        end
        l_fxData.position = Vector3.New(l_pos.x, l_pos.y, l_pos.z)
        l_fxData.scale = Vector3.New(l_scale.x, l_scale.y, l_scale.z)
        l_fxData.rotation = Quaternion.Euler(l_rotation.x, l_rotation.y, l_rotation.z)

        model:SetActiveEx(false)
        self.PlayerModel = self:CreateUIModel(l_fxData)
        

        local l_animKey, l_animPath, l_animTime = mainData:GetAnimInfo()
        l_animKey = l_animKey or "Idle"
        l_animPath = l_animPath or l_attr.CommonIdleAnimPath
        l_animTime = l_animTime or 0
        self.PlayerModel.Ator:OverrideAnim(l_animKey, l_animPath)
        self.PlayerModel.Ator:Play(l_animKey, l_animTime)
        self.PlayerModel.Ator.Speed = 0

        local l_emotion1, l_emotion2 = mainData:GetEmotion()
        if l_emotion1 and l_emotion2 then
            self.PlayerModel:ChangeEmotion(l_emotion1, l_emotion2, 999999)
        end

        self.PlayerModel:AddLoadModelCallback(function(m)
            model:SetActiveEx(true)
        end)
    end

end

function FashionCollectionCtrl:ShowModel3D(roleInfo)


    if self.playerModel3D ~= nil then
        self:DestroyUIModel(self.playerModel3D)
        self.playerModel3D = nil
    end
    self.playerModel3D = Common.CommonUIFunc.CreateModelEntity(roleInfo, self.panel.PanelRank.Model, true, true)
    self:SaveModelData(self.playerModel3D)
end

function FashionCollectionCtrl:GetNowPage()

    local l_info = self.rankMgr.GetPbVarInExcelByType(self.mgr.FashionTableID)
    local rowDatas = {}
    for k, v in pairs(self.RowsInfo) do
        local l_data = {}
        l_data.index = k
        l_data.rowValue = v
        l_data.rowName = l_info
        table.insert(rowDatas, l_data)
    end
    return rowDatas

end

function FashionCollectionCtrl:AddPageInfo(newRowTb)

    local l_tabs = table.ro_deepCopy(newRowTb)
    table.ro_insertRange(self.RowsInfo, l_tabs)
    self.data.TotalNum = #self.RowsInfo

    local l_ownInfo = DataMgr:GetData("RankData").OwnRankInfo
    local l_ownInfoData = l_ownInfo[self.mgr.FashionTableID .. "_" .. self.mgr.RankKey .. "_" .. "0"]
    if l_ownInfoData[1] == nil or l_ownInfoData[1].value == nil or l_ownInfoData[1].value == 0 then
        self.data.CollectRank = 0
    else
        self.data.CollectScore = l_ownInfoData[2].value
        self.data.CollectRank = l_ownInfoData[1].value
    end

    self.panel.PanelRank.MyScore.LabText = tostring(self.data.CollectScore)
    self.panel.PanelRank.MyName.LabText = MPlayerInfo.Name
    if self.data.CollectRank > 0 then
        self.panel.PanelRank.MyRank.LabText = tostring(self.data.CollectRank)
    else
        self.panel.PanelRank.MyRank.LabText = tostring(self.mgr.RankLimit) .. "+"
    end

end

function FashionCollectionCtrl:SelectRole(index, id)

    self.scrollRect:SelectTemplate(index)
    local l_idTable = {}
    l_idTable[1] = { value = id }
    MgrMgr:GetMgr("TeamMgr").GetRoleInfoListByIds(l_idTable, DataMgr:GetData("TeamData").ERoleInfoType.FashionCollection)

end
--lua custom scripts end
return FashionCollectionCtrl