--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FunctionPreviewPanel"
require "UI/Template/FunctionPreviewTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
FunctionPreviewCtrl = class("FunctionPreviewCtrl", super)
--lua class define end

local l_openSystemMgr = nil
local l_currentSelectIndex = 1;
local l_bgTexPath = "FunctionPreview/{0}"
--lua functions
function FunctionPreviewCtrl:ctor()

    super.ctor(self, CtrlNames.FunctionPreview, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function FunctionPreviewCtrl:Init()

    self.panel = UI.FunctionPreviewPanel.Bind(self)
    super.Init(self)

    l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")

    self:InitToggleInfo()

    self.serverLevelTipsTemplate = self:NewTemplate("ServerLevelTipsTemplate", {
        TemplateParent = self.panel.ServerLevelTipsParent.transform
    })

    self.panel.CloseSeverLevelButton:SetActiveEx(false)
    self.panel.ServerLevelTipsParent:SetActiveEx(false)

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.FunctionPreview)
    end)
    self.panel.BtnPlay:AddClick(function()
        self:PlayMovie()
    end)
    self.panel.CloseMovie:AddClick(function()
        self:CloseMovie()
    end)

    self.panel.CloseSeverLevelButton:AddClick(function()
        self.panel.CloseSeverLevelButton.gameObject:SetActiveEx(false)
        self.panel.ServerLevelTipsParent:SetActiveEx(false)
    end)

    self.panel.ShowServerTipsButton:AddClick(function()
        MgrMgr:GetMgr("RoleInfoMgr").GetServerLevelBonusInfo()
        self.panel.CloseSeverLevelButton.gameObject:SetActiveEx(true)
    end)
end --func end
--next--
function FunctionPreviewCtrl:Uninit()

    self.serverLevelTipsTemplate = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function FunctionPreviewCtrl:OnActive()

    VideoPlayerMgr:BindMediaPlayer(self.panel.funcMovie.gameObject, true)
end --func end
--next--
function FunctionPreviewCtrl:OnDeActive()
    l_currentSelectIndex = 1
    VideoPlayerMgr:BindMediaPlayer(self.panel.funcMovie.gameObject, false)
    VideoPlayerMgr:Stop()
end --func end
--next--
function FunctionPreviewCtrl:Update()


end --func end

--next--
function FunctionPreviewCtrl:BindEvents()

    local l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")

    self:BindEvent(l_roleInfoMgr.EventDispatcher, l_roleInfoMgr.ON_SERVER_LEVEL_UPDATE, function()
        self:SetServerLevel()
    end)

end --func end

--next--
--lua functions end

--lua custom scripts
function FunctionPreviewCtrl:PlayMovie()
    local openItemID = l_openSystemMgr.OpenSystemPreviewTable[l_currentSelectIndex]
    local tempOpenItem = TableUtil.GetOpenSystemTable().GetRowById(openItemID)
    if MLuaCommonHelper.IsNull(tempOpenItem) then
        return
    end

    local location = StringEx.Format("FunctionPreview/Preview{0}.mp4", openItemID)
    if not VideoPlayerMgr.IsMovieExist(location) then
        logError("电影资源不存在！")
        self:CloseMovie()
        return
    end

    local _onPlay = function()
       if self.panel ~= nil then
            if self.panel ~= nil then
                self.panel.CloseMovie:SetActiveEx(true)
                self.panel.funcMovie:SetActiveEx(true)
            end
        end 
    end

    VideoPlayerMgr:Prepare(location, true, nil, _onPlay)
end
function FunctionPreviewCtrl:CloseMovie()
    self.panel.CloseMovie:SetActiveEx(false)
    self.panel.funcMovie:SetActiveEx(false)
    VideoPlayerMgr:Stop()
end
function FunctionPreviewCtrl:InitToggleInfo()
    local preivewFuncNum = #l_openSystemMgr.OpenSystemPreviewTable
    local l_maxShowFuncNum = MGlobalConfig:GetInt("FunctionPreviewTabNum",1)
    local l_showPreviewFunc = {}
    for i = 1, preivewFuncNum do
        if i>l_maxShowFuncNum then
            break
        end
        table.insert(l_showPreviewFunc,l_openSystemMgr.OpenSystemPreviewTable[i])
    end
    self.previewFunctionPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.FunctionPreviewTemplate,
        TemplatePrefab = self.panel.Toggle_FunctionBtn.gameObject,
        TemplateParent = self.panel.ToggleGroup_ChooseFunc.Transform,
        Method = function(id)
            self:ShowFuncInfoByID(id)
        end
    })
    self.previewFunctionPool:ShowTemplates({ Datas = l_showPreviewFunc })
    local l_firstItem = self.previewFunctionPool:GetItem(1)
    if l_firstItem~=nil then
        l_firstItem:ChooseFunction()
    end
end
function FunctionPreviewCtrl:ShowFuncInfoByID(openSystemID)
    if openSystemID == nil then
        return
    end
    local funcItem = TableUtil.GetOpenSystemTable().GetRowById(openSystemID)
    if funcItem == nil then
        return
    end
    self.panel.BGa:SetRawTexAsync(StringEx.Format(l_bgTexPath, funcItem.NoticeTitlePhoto .. ".png"))
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.DescTxt.RectTransform)

    self.panel.NoticeTitleText.LabText = Lang(funcItem.NoticeTitleText1)
    self.panel.NoticeTitle2Text.LabText = Lang(funcItem.NoticeTitleText2)

    self:_showFunctionOpenCondition(funcItem)
end

function FunctionPreviewCtrl:_showFunctionOpenCondition(tableInfo)
    self:_showFunctionOpenServerLevel(tableInfo)
    self:_showFunctionOpenBaseLevel(tableInfo)
    self:_showFunctionOpenTask(tableInfo)

end

function FunctionPreviewCtrl:_showFunctionOpenServerLevel(tableInfo)
    if tableInfo.ServerDescLv == 0 then
        self.panel.ServerLevelPreview:SetActiveEx(false)
        return
    end
    self.panel.ServerLevelPreview:SetActiveEx(true)

    local l_colorTag
    if MPlayerInfo.ServerLevel >= tableInfo.ServerDescLv then
        l_colorTag = self:_getShowFunctionOpenColorTag(true)
        self.panel.ServerLevelPreviewFinish:SetActiveEx(true)
    else
        l_colorTag = self:_getShowFunctionOpenColorTag(false)
        self.panel.ServerLevelPreviewFinish:SetActiveEx(false)
    end

    local levelText = RoColor.GetTextWithDefineColor(tableInfo.ServerDescLv, l_colorTag)

    self.panel.ServerLevelPreview.LabText = StringEx.Format(Lang("FunctionOpen_ServerLv"), levelText)
end

function FunctionPreviewCtrl:_showFunctionOpenBaseLevel(tableInfo)

    if tableInfo.NoticeDescLv == 0 then
        self.panel.BaseLevelPreview:SetActiveEx(false)
        return
    end
    self.panel.BaseLevelPreview:SetActiveEx(true)

    local l_colorTag
    if MPlayerInfo.Lv >= tableInfo.NoticeDescLv then
        l_colorTag = self:_getShowFunctionOpenColorTag(true)
        self.panel.BaseLevelPreviewFinish:SetActiveEx(true)
    else
        l_colorTag = self:_getShowFunctionOpenColorTag(false)
        self.panel.BaseLevelPreviewFinish:SetActiveEx(false)
    end

    local levelText = RoColor.GetTextWithDefineColor(tableInfo.NoticeDescLv, l_colorTag)

    self.panel.BaseLevelPreview.LabText = StringEx.Format(Lang("FunctionOpen_SingleLv"), levelText)

end

function FunctionPreviewCtrl:_showFunctionOpenTask(tableInfo)
    if tableInfo.TaskId.Length == 0 then
        self.panel.TaskPreview:SetActiveEx(false)
        return
    end
    self.panel.TaskPreview:SetActiveEx(true)

    local l_colorTag
    local taskText
    if self:_isTaskFinish(tableInfo) then
        l_colorTag = self:_getShowFunctionOpenColorTag(true)

        taskText = Lang(tableInfo.NoticeDescTask)
        if not string.ro_isEmpty(tableInfo.NoticeDescTask2) then
            taskText = taskText .. Lang(tableInfo.NoticeDescTask2)
        end
        taskText = RoColor.GetTextWithDefineColor(taskText, l_colorTag)
        self.panel.TaskPreviewFinish:SetActiveEx(true)
    else
        taskText = RoColor.GetTextWithDefineColor(Lang(tableInfo.NoticeDescTask), RoColor.UIDefineColorValue.WaringColor)
        if not string.ro_isEmpty(tableInfo.NoticeDescTask2) then
            local taskText2 = RoColor.GetTextWithDefineColor(Lang(tableInfo.NoticeDescTask2), RoColor.UIDefineColorValue.NumericalColor)
            taskText = taskText .. taskText2
        end

        self.panel.TaskPreviewFinish:SetActiveEx(false)
    end

    self.panel.TaskPreviewText.LabText = taskText
end

function FunctionPreviewCtrl:_getShowFunctionOpenColorTag(isFinish)

    if isFinish then
        return "458861"
    end

    return RoColor.UIDefineColorValue.WaringColor
end

function FunctionPreviewCtrl:_isTaskFinish(tableInfo)
	local l_length=tableInfo.TaskId.Length
	if l_length == 0 then
		return true
	end
	for i = 1, l_length do
		if MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(tableInfo.TaskId[i-1]) then
			return true
		end
	end
	return false
end

function FunctionPreviewCtrl:SetServerLevel()
    local l_data = MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData
    self.panel.ServerLevelTipsParent:SetActiveEx(true)
    self.serverLevelTipsTemplate:SetData(l_data)
end
--lua custom scripts end
return FunctionPreviewCtrl