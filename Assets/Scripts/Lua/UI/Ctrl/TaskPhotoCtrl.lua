--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TaskPhotoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
TaskPhotoCtrl = class("TaskPhotoCtrl", super)
--lua class define end

--lua functions
function TaskPhotoCtrl:ctor()

    super.ctor(self, CtrlNames.TaskPhoto, UILayer.Normal, nil, ActiveType.Standalone)
    self.IsCloseOnSwitchScene = true

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent
    self.ClosePanelNameOnClickMask=UI.CtrlNames.TaskPhoto

end --func end
--next--
function TaskPhotoCtrl:Init()
	self.panel = UI.TaskPhotoPanel.Bind(self)
	super.Init(self)
	self.viewportId = nil
	self.sceneId = nil
 	--self:SetBlockOpt(BlockColor.Transparent, function()
  	--	UIMgr:DeActiveUI(UI.CtrlNames.TaskPhoto)
  	--end)
	self.panel.Btn_N_S01:AddClick(function()
        if self.viewportId == nil then
            return
        end
        local l_charMgr = MgrMgr:GetMgr("ChatMgr")
        local l_cdTime = l_charMgr.GetTaskPhotoTime()
        if l_cdTime > 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("TASK_PHOTO_SOS_CD"),math.ceil(l_cdTime)))
            return
        end
        if not MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
            UIMgr:ActiveUI(UI.CtrlNames.GuildList)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_PHOTO_NOT_IN_GUILD"))
            return
        end
        l_charMgr.SendTaskPhotoChat(self.viewportId)
    end)
    self.panel.GMBtn.gameObject:SetActiveEx(MGameContext.IsOpenGM)

    self.panel.GMBtn:AddClick(function ( ... )
        if self.viewportId == nil and not MGameContext.IsOpenGM then
            return
        end
        local l_photoAimRow = TableUtil.GetCheckInViewPortTable().GetRowById(self.viewportId)
        if l_photoAimRow then
            local l_position = l_photoAimRow.Position
            local l_scene = l_photoAimRow.SceneId
            MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("goto {0} {1} {2} {3}",tostring(l_scene),tostring(l_position[0]),tostring(l_position[1]),tostring(l_position[2])))
        end
    end)
end --func end
--next--
function TaskPhotoCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
    self.viewportId = nil
end --func end
--next--
function TaskPhotoCtrl:OnActive()
    local l_charMgr = MgrMgr:GetMgr("ChatMgr")
    self.panel.Btn_N_S01:SetGray(l_charMgr.GetTaskPhotoTime() > 0)
    --新手指引相关
    local l_beginnerGuideChecks = {"Photograph"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
end --func end
--next--
function TaskPhotoCtrl:OnDeActive()
    self.viewportId = nil
end --func end
--next--
function TaskPhotoCtrl:Update()
    local l_charMgr = MgrMgr:GetMgr("ChatMgr")
    self.panel.Btn_N_S01:SetGray(l_charMgr.GetTaskPhotoTime() > 0)
end --func end





--next--
function TaskPhotoCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function TaskPhotoCtrl:SetViewportId(viewportId)
    if viewportId == nil then
        return
    end
    if self.viewportId == viewportId then
        return
    end
    self.viewportId = viewportId
    local l_viewPortPath = "ViewPort/Viewport"..tostring(self.viewportId)
    self.panel.Picture:SetRawTex(l_viewPortPath..".jpg")
    local l_viewportData = TableUtil.GetCheckInViewPortTable().GetRowById(self.viewportId)
    if l_viewportData == nil then
        logError(self.viewportId.."not exists in CheckInViewPortTable @张博榕")
        return
    end
    self.sceneId = l_viewportData.SceneId

    local l_textData = TableUtil.GetEntrustPhotoTextTable().GetRowBySceneId(self.sceneId)
    if l_textData == nil then
        logError(self.sceneId.."not exists in EntrustPhotoTextTable @张博榕")
        return
    end

    self.panel.Description.LabText = l_textData.SceneText
end

--lua custom scripts end
return TaskPhotoCtrl