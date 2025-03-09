--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TitlegetPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TitlegetCtrl = class("TitlegetCtrl", super)
--lua class define end

--lua functions
function TitlegetCtrl:ctor()
	
	super.ctor(self, CtrlNames.Titleget, UILayer.Tips, nil, ActiveType.Standalone)
	
end --func end
--next--
function TitlegetCtrl:Init()
	
	self.panel = UI.TitlegetPanel.Bind(self)
	super.Init(self)

    -- 4.5秒后关闭界面
    self.closeDuration = 4.5

    self.titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")
    self.titleId = nil

    self.panel.BackBtn:AddClick(function()
        self:TryClose()
    end)

    self.panel.CloseBtn:AddClick(function()
        self:TryClose()
    end)
	
end --func end
--next--
function TitlegetCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function TitlegetCtrl:OnActive()

    self:TryClose()
end --func end
--next--
function TitlegetCtrl:OnDeActive()
    if self.closeTimer then
        self:StopUITimer(self.closeTimer)
        self.closeTimer = nil
    end
	
end --func end
--next--
function TitlegetCtrl:Update()
	
	
end --func end
--next--
function TitlegetCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function TitlegetCtrl:RefreshTimer()
    if self.closeTimer then
        self:StopUITimer(self.closeTimer)
    end
    self.closeTimer = self:NewUITimer(function()
        self:TryClose()
    end, self.closeDuration)
    self.closeTimer:Start()
end

function TitlegetCtrl:SetTitle(titleId)
    self.titleId = titleId
    self:RefreshTimer()
    self:RefreshDetail()
end

function TitlegetCtrl:TryClose()
    local l_titleId = self.titleStickerMgr.DequeueNewTitleId()
    if l_titleId then
        self:SetTitle(l_titleId)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.Titleget)
    end
end

function TitlegetCtrl:RefreshDetail()
    if not self.titleId then return end

    local l_titleRow = TableUtil.GetTitleTable().GetRowByTitleID(self.titleId)
    if l_titleRow then
        self.panel.TitleName.LabText = StringEx.Format("[{0}]", l_titleRow.TitleName)
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(self.titleId)
        if l_itemRow then
            self.panel.TitleName.LabColor = self.titleStickerMgr.GetQualityColor(l_itemRow.ItemQuality)
        end

        self.panel.Sticker:SetActiveEx(l_titleRow.StickersID ~= 0)
        if l_titleRow.StickersID ~= 0 then
            local l_stickerRow = TableUtil.GetStickersTable().GetRowByStickersID(l_titleRow.StickersID)
            if l_stickerRow then
                self.panel.StickerIcon:SetSpriteAsync(l_stickerRow.StickersAtlas, l_stickerRow.StickersIcon, nil, true)
            end
        end
    end
end


--lua custom scripts end
return TitlegetCtrl