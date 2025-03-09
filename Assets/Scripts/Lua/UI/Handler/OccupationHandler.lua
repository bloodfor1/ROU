--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/OccupationPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
OccupationHandler = class("OccupationHandler", super)
--lua class define end

--lua functions
function OccupationHandler:ctor()

    super.ctor(self, HandlerNames.Occupation, 0)

end --func end
--next--
function OccupationHandler:Init()

    self.panel = UI.OccupationPanel.Bind(self)
    super.Init(self)

end --func end
--next--
function OccupationHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function OccupationHandler:OnActive()
    self:SetPanel()
end --func end
--next--
function OccupationHandler:OnDeActive()
    self:DestoryModel()
    self:ClearData()
end --func end
--next--
function OccupationHandler:Update()


end --func end


--next--
function OccupationHandler:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
NOVICE_LEVEL = 10
function OccupationHandler:SetPanel()
    self.professionList = Common.CommonUIFunc.GetPlayerProfessionList(MPlayerInfo.ProfessionId)
    self:SetProfessionScrollView()
end

--初始化 职业天赋书
function OccupationHandler:SetProfessionScrollView()
    self.ProfessionItemTable = {}
    for i = 1, table.maxn(self.panel.ProfessionItem) do
        self.ProfessionItemTable[i] = {}
        self.ProfessionItemTable[i].ui = self.panel.ProfessionItem[i]
        self:SetProfessionItemElement(self.ProfessionItemTable[i])
        if self.professionList[i] == nil then
            self.ProfessionItemTable[i].close.gameObject:SetActiveEx(true)
            self.ProfessionItemTable[i].open.gameObject:SetActiveEx(false)
        else
            self.ProfessionItemTable[i].open.gameObject:SetActiveEx(true)
            self.ProfessionItemTable[i].close.gameObject:SetActiveEx(false)
        end
        self:SetProfessionItemInfo(self.ProfessionItemTable[i], self.professionList[i], i)
    end

    local professionItemNum = table.maxn(self.professionList)
    for i = 1, professionItemNum do
        local curData = self.ProfessionItemTable[i]
        local nextData = nil
        if i + 1 <= professionItemNum then
            nextData = self.ProfessionItemTable[i + 1]
        end
        curData.toggle.Tog.interactable = true
        curData.toggle:OnToggleChanged(function(on)
            curData.select.gameObject:SetActiveEx(on)
            if on then
                self:DestoryModel()
                self:SetModelPanel(curData, nextData)
                self:SetText(curData, nextData)
                self:setAttrData(curData, nextData)
            else

            end
        end)
        curData.toggle.Tog.isOn = curData.professionData.Id == MPlayerInfo.ProfessionId
    end

    self.panel.proTreeScrollView:SetScrollRectGameObjListener(self.panel.ImageUp.gameObject, self.panel.ImageDown.gameObject, nil, nil)
end

--职业Id UI数据文件
function OccupationHandler:SetProfessionItemInfo(uiData, professionId, professionNum)
    if professionId == nil then
        return
    end

    local l_professionData = TableUtil.GetProfessionTable().GetRowById(professionId)
    if l_professionData then
        uiData.professionData = l_professionData
        uiData.ProfessionName.LabText = l_professionData.Name
        uiData.Letter.LabText = l_professionData.EnglishName
        local l_attr = self:CreateOccupationEntity(professionId)
        if l_attr then
            ---@type HeadTemplateParam
            local param = {
                EquipData = l_attr.EquipData,
                FrameID = MgrMgr:GetMgr("HeadFrameMgr").GetDefault(),
                ShowProfession = true,
                Profession = professionId
            }

            uiData.HeadIcon:SetData(param)
            uiData.attr = l_attr
        end
    end

    uiData.ProfessionNumOpen.LabText = Lang("PROFESSION_NUM_" .. professionNum)
end

function OccupationHandler:CreateOccupationEntity(professionId)
    local l_professionId = professionId or MPlayerInfo.ProID
    local l_isMail = MPlayerInfo.IsMale
    local l_attr = MAttrMgr:InitRoleAttr(MUIModelManagerEx:GetTempUID(), "OccupationHandler", l_professionId, l_isMail, nil)
    l_attr:SetHair(MPlayerInfo.HairStyle)
    l_attr:SetEyeColor(MPlayerInfo.EyeColorID)
    l_attr:SetEye(MPlayerInfo.EyeID)
    return l_attr
end

function OccupationHandler:ClearData()
    if self.ProfessionItemTable then
        for k, v in pairs(self.ProfessionItemTable) do
            if v.attr then
                v.attr = nil
            end
        end
    end
end

function OccupationHandler:SetModelPanel(beforDate, nextData)
    self.beforModelData = {}
    self.nextModelData = {}

    if beforDate and beforDate.professionData then
        self.panel.BgBefor.gameObject:SetActiveEx(true)
        self.panel.BgBeforDontExist.gameObject:SetActiveEx(false)

        self.beforModelData.ui = self.panel.BgBefor
        self:SetModelElement(self.beforModelData)
        self.beforModelData.chineseName.LabText = beforDate.professionData.Name
        self.beforModelData.englishName.LabText = beforDate.professionData.EnglishName
        self.beforModelData.model = self:CreateModelEntity(beforDate, self.beforModelData)
    else
        self.panel.BgBefor.gameObject:SetActiveEx(false)
        self.panel.BgBeforDontExist.gameObject:SetActiveEx(true)
    end
    if nextData and nextData.professionData then
        self.panel.BgAfter.gameObject:SetActiveEx(true)
        self.panel.BgAfterDontExist.gameObject:SetActiveEx(false)

        self.nextModelData.ui = self.panel.BgAfter
        self:SetModelElement(self.nextModelData)
        self.nextModelData.chineseName.LabText = nextData.professionData.Name
        self.nextModelData.englishName.LabText = nextData.professionData.EnglishName
        self.nextModelData.model = self:CreateModelEntity(nextData, self.nextModelData)

        self.panel.ChangeNeedBaseLv.gameObject:SetActiveEx(true)
        self.panel.ChangeNeedJobLv.gameObject:SetActiveEx(true)
        self.panel.ChangeNeedBaseLv.LabText = "BaseLv" .. nextData.professionData.BaseLvRequired
        local realJobLv, _ = Common.CommonUIFunc.GetShowJobLevelAndProByLv(nextData.professionData.JobLvRequired, beforDate.professionData.Id)
        self.panel.ChangeNeedJobLv.LabText = "JobLv" .. realJobLv
    else
        self.panel.BgAfter.gameObject:SetActiveEx(false)
        self.panel.BgAfterDontExist.gameObject:SetActiveEx(true)
        self.panel.ChangeNeedBaseLv.gameObject:SetActiveEx(false)
        self.panel.ChangeNeedJobLv.gameObject:SetActiveEx(false)
    end
end

function OccupationHandler:DestoryModel()
    if self.beforModelData and self.beforModelData.model then
        self:DestroyUIModel(self.beforModelData.model)
        self.beforModelData.model = nil
    end
    if self.nextModelData and self.nextModelData.model then
        self:DestroyUIModel(self.nextModelData.model)
        self.nextModelData.model = nil
    end
end

function OccupationHandler:setAttrData(beforDate, nextData)
    local isExist = not (nextData == nil or nextData.professionData == nil)
    local l_attrNames = { "STR", "VIT", "AGI", "INT", "DEX", "LUCK", "HP", "SP" }
    local l_attrObj = {
        self.panel.Attr_3,
        self.panel.Attr_4,
        self.panel.Attr_5,
        self.panel.Attr_6,
        self.panel.Attr_7,
        self.panel.Attr_8,
        self.panel.Attr_1,
        self.panel.Attr_2,
    }

    local setEmpty = function()
        for i = 1, table.maxn(l_attrNames) do
            local name = MLuaClientHelper.GetOrCreateMLuaUICom(l_attrObj[i].transform:Find("Bg/Text").gameObject)
            local attrValue = MLuaClientHelper.GetOrCreateMLuaUICom(l_attrObj[i].transform:Find("Text").gameObject)
            name.LabText = "???"
            attrValue.LabText = "???"
            self.panel.TitleProfessionText.LabText = Lang("PROFESSION_ADD", "???")
        end
    end

    if isExist then
        local previewData = TableUtil.GetProfessionPreviewTable().GetRowByProfessionId(nextData.professionData.Id)
        if previewData == nil or nextData.professionData == nil then
            setEmpty()
            return
        end
        for i = 1, table.maxn(l_attrNames) do
            local name = MLuaClientHelper.GetOrCreateMLuaUICom(l_attrObj[i].transform:Find("Bg/Text").gameObject)
            local attrValue = MLuaClientHelper.GetOrCreateMLuaUICom(l_attrObj[i].transform:Find("Text").gameObject)
            name.LabText = Lang(StringEx.Format("ATTR_{0}", l_attrNames[i]))
            attrValue.LabText = previewData.ProfessionGain[i - 1]
        end
        local realJobLv, _ = Common.CommonUIFunc.GetShowJobLevelAndProByLv(nextData.professionData.JobLvRequired, beforDate.professionData.Id)
        self.panel.TitleProfessionText.LabText = Lang("PROFESSION_ADD", (realJobLv))
    else
        setEmpty()
    end

    local curProType = DataMgr:GetData("SkillData").CurrentProTypeAndId()
    self.panel.BtnShowProfession.gameObject:SetActiveEx(beforDate.professionData ~= nil and curProType == DataMgr:GetData("SkillData").ProfessionList.PRO_ONE)
    self.panel.BtnShowProfession:AddClick(function()
        local l_skillData = {
            openType = DataMgr:GetData("SkillData").OpenType.DirectOpenPreview
        }
        UIMgr:ActiveUI(UI.CtrlNames.SkillLearning, l_skillData)
    end)
end

function OccupationHandler:SetText(beforDate, nextData)
    local isShow = (beforDate and nextData) and true or false
    self.panel.LevelCheck.gameObject:SetActiveEx(isShow)
    self.panel.TaskCheck.gameObject:SetActiveEx(isShow)
    self.panel.BtnShowProfession.gameObject:SetActiveEx(isShow)
    self.panel.NotExist.gameObject:SetActiveEx(not isShow)
    if not isShow then
        return
    end

    local nextProType = nextData.professionData.ProfessionType
    local l_currentProName = beforDate.professionData.Name
    local l_baseLv, l_jobLv = DataMgr:GetData("SkillData").GetNeedBaseAndJobLvByProType(nextProType)
    local realJobLv, _ = Common.CommonUIFunc.GetShowJobLevelAndProByLv(MPlayerInfo.JobLv, beforDate.professionData.Id)
    local l_canGotoNext = MPlayerInfo.JobLv >= l_jobLv and MPlayerInfo.Lv >= l_baseLv
    local passColor, failColor = RoColorTag.Green, RoColorTag.Red
    self.panel.FinishLv.gameObject:SetActiveEx(l_canGotoNext)
    self.panel.NotFinishLv.gameObject:SetActiveEx(not l_canGotoNext)
    self.panel.ButtonLevel.gameObject:SetActiveEx(not (MPlayerInfo.Lv >= l_baseLv)) --玩家等级大于目标 等级隐藏Go按钮
    local baseLvColor = MPlayerInfo.Lv >= l_baseLv and passColor or failColor
    local jobLvColor = realJobLv >= l_jobLv and passColor or failColor
    local str1 = GetColorText(l_baseLv, baseLvColor)
    local str2 = GetColorText(l_jobLv, jobLvColor)
    self.panel.TextLevel.LabText = Lang("SKILLLEARNING_JOBLV_ENOUGH_TOGOTO_NEXT_NEW", str1, l_currentProName, str2)
    local hlayoutTrans = self.panel.TextLevel.transform.parent:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(hlayoutTrans)
    self.panel.ButtonLevel:AddClick(function()
        if not l_canGotoNext then
            local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
            if openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.Delegate) then
                MgrMgr:GetMgr("SystemFunctionEventMgr").DelegateEvent()
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILLLEARNING_DELEGATE_OPEN_TIP"))
            end
        end
    end)

    ----任务判定
    local taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_targetProfessionRow = TableUtil.GetTaskChangeJobTable().GetRowByTargetJobId(nextData.professionData.Id)
    if l_targetProfessionRow then
        local l_finish = taskMgr.CheckTaskFinished(l_targetProfessionRow.LimitTaskId)
        self.panel.FinishTask.gameObject:SetActiveEx(l_finish)
        self.panel.NotFinishTask.gameObject:SetActiveEx(not l_finish)
        self.panel.ButtonTask.gameObject:SetActiveEx(not l_finish and (taskMgr.CheckTaskCanAcceptByTaskId(l_targetProfessionRow.LimitTaskId))) --未完成且可接取 才显示Go按钮
        self.panel.TextTask.LabText = Lang("SKILLLEARNING_TRANSFER_TASK_NAME", GetColorText(taskMgr.GetTaskNameByTaskId(l_targetProfessionRow.LimitTaskId), RoColorTag.Yellow))
        self.panel.ButtonTask:AddClick(function()
            if not l_finish then
                if l_targetProfessionRow then
                    taskMgr.OnQuickTaskClickWithTaskId(l_targetProfessionRow.FirstLimitTaskId)
                else
                    logError("TaskChangeJobTable未找到proId：", beforDate.professionData.Id, l_targetProfessionRow.FirstLimitTaskId)
                end
            end
        end)
    end
end

function OccupationHandler:CreateModelEntity(date, uidate)
    local attr = date.attr
    local l_fxData = {}
    l_fxData.rawImage = uidate.modelImage.RawImg
    l_fxData.attr = attr
    l_fxData.defaultAnim = attr.CommonIdleAnimPath

    local model = self:CreateUIModel(l_fxData)
    model:AddLoadModelCallback(function(m)
        uidate.modelImage.gameObject:SetActiveEx(true)
    end)

    local listener = uidate.modelImage:GetComponent("MLuaUIListener")
    listener.onDrag = function(uobj, event)
        if model and model.Trans then
            model.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
        end
    end

    return model
end

function OccupationHandler:SetProfessionItemElement(element)
    element.toggle = element.ui.transform:GetComponent("MLuaUICom")
    element.open = element.ui.transform:Find("Open"):GetComponent("MLuaUICom")
    element.close = element.ui.transform:Find("Close"):GetComponent("MLuaUICom")
    element.select = element.ui.transform:Find("Open/Select"):GetComponent("MLuaUICom")
    element.head = element.ui.transform:Find("Open/HeadDummy"):GetComponent("MLuaUICom")
    element.HeadIcon = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = element.head.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    element.ProfessionName = element.ui.transform:Find("Open/ProfessionName"):GetComponent("MLuaUICom")
    element.Letter = element.ui.transform:Find("Open/Letter"):GetComponent("MLuaUICom")
    element.ProfessionNumOpen = element.ui.transform:Find("Open/Image/ProfessionNum"):GetComponent("MLuaUICom")
    element.ProfessionNumClose = element.ui.transform:Find("Open/Image/ProfessionNum"):GetComponent("MLuaUICom")
    element.select.gameObject:SetActiveEx(false)
    element.toggle.Tog.interactable = false
end

function OccupationHandler:SetModelElement(element)
    element.chineseName = element.ui.transform:Find("NameObj/NameC"):GetComponent("MLuaUICom")
    element.englishName = element.ui.transform:Find("NameObj/NameC/NameE"):GetComponent("MLuaUICom")
    element.icon = element.ui.transform:Find("NameObj/Icon"):GetComponent("MLuaUICom")
    element.modelImage = element.ui.transform:Find("NameObj/ModelImage"):GetComponent("MLuaUICom")
    element.modelImage.gameObject:SetActiveEx(false)
end
--lua custom scripts end

return OccupationHandler