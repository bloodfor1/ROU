--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SkillPreviewPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SkillPreviewCtrl = class("SkillPreviewCtrl", super)
--lua class define end

--lua functions
function SkillPreviewCtrl:ctor()

    super.ctor(self, CtrlNames.SkillPreview, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    self.ClosePanelNameOnClickMask=UI.CtrlNames.SkillPreview

end --func end
--next--
function SkillPreviewCtrl:Init()

    self.panel = UI.SkillPreviewPanel.Bind(self)
    super.Init(self)
    self.data = DataMgr:GetData("SkillData")
    --self:SetBlockOpt(BlockColor.Dark, function() UIMgr:DeActiveUI(UI.CtrlNames.SkillPreview) end)

end --func end
--next--
function SkillPreviewCtrl:Uninit()

    self.data = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SkillPreviewCtrl:OnActive()

    VideoPlayerMgr:BindMediaPlayer(self.panel.MovieView.gameObject, true)

    if self.uiPanelData then
        if self.uiPanelData.openType == self.data.OpenType.SetSkillPreviewInfo then
            self:SetSkillPreviewInfo(self.uiPanelData.Id)
        end
    end
    self.panel.BtnReplay.gameObject:SetActiveEx(false)
    self.panel.BtnReplay:AddClick(function()
        self:Replay()
        self.panel.BtnReplay.gameObject:SetActiveEx(false)
    end)
end --func end
--next--
function SkillPreviewCtrl:OnDeActive()

    VideoPlayerMgr:BindMediaPlayer(self.panel.MovieView.gameObject, false)

    VideoPlayerMgr:Stop()
end --func end
--next--
function SkillPreviewCtrl:Update()


end --func end



--next--
function SkillPreviewCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function SkillPreviewCtrl:SetSkillPreviewInfo(skillId)

    self.currentSkillId = skillId

    local l_skillPreviewUrl = MGlobalConfig:GetString("SkillPreviewUrl", "")
    if not l_skillPreviewUrl or string.len(l_skillPreviewUrl) <= 0 then
        return
    end

    local l_location = StringEx.Format("{0}Skill{1}.mp4", l_skillPreviewUrl, skillId)
    local l_skillSimpleDesc = self.data.GetDataFromTable("SkillTable", skillId).SimpleSkillDesc
    
    if not VideoPlayerMgr.IsMovieExist(l_location) then
        --提示没有资源
        self.panel.NoVideoTip.UObj:SetActiveEx(true)
        return
    end

    local _onEnd = function()
       if self.panel ~= nil then
            self.panel.BtnReplay.gameObject:SetActiveEx(true)
        end 
    end
    self.panel.TxtSkillDesc.LabText = l_skillSimpleDesc
    VideoPlayerMgr:Prepare(l_location, true, nil, nil, _onEnd, nil, MoonCommonLib.EFileLocation.AbsolutePathOrURL)

end

function SkillPreviewCtrl:Replay()

    self:SetSkillPreviewInfo(self.currentSkillId)

end
--lua custom scripts end
return SkillPreviewCtrl