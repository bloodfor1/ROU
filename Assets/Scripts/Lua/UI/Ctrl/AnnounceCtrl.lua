--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AnnouncePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local Mgr = MgrMgr:GetMgr("AnnounceMgr")
--next--
--lua fields end

--lua class define
AnnounceCtrl = class("AnnounceCtrl", super)
--lua class define end

--lua functions
function AnnounceCtrl:ctor()

	super.ctor(self, CtrlNames.Announce, UILayer.Tips, UITweenType.UpAlpha, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function AnnounceCtrl:Init()

    self.panel = UI.AnnouncePanel.Bind(self)
    super.Init(self)
    -- 先隐藏
    --self.panel.Announce.gameObject:SetActiveEx(false)
    --确定按钮
    self.panel.BtnOKAnnounce:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Announce)
    end)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark, function()
    --end)

end --func end
--next--
function AnnounceCtrl:Uninit()

	    super.Uninit(self)
	    self.panel = nil

end --func end
--next--
function AnnounceCtrl:OnActive()
    if self.uiPanelData then
        self:CheckAnnounce(self.uiPanelData.state, self.uiPanelData.data)
    end
    self:UpdateDownArrow()

end --func end
--next--
function AnnounceCtrl:OnDeActive()


end --func end
--next--
function AnnounceCtrl:Update()


end --func end



--next--
function AnnounceCtrl:BindEvents()
    self:BindEvent(Mgr.EventDispatcher, Mgr.CheckAnnounceEvent, function(self, state, data)
        self:CheckAnnounce(state, data)
    end)
end --func end



--next--
--lua functions end

--lua custom scripts
-- 检查公告
function AnnounceCtrl:CheckAnnounce(state, data)
    -- state 1进入时自动弹出 2点击弹出(如果有问题会提示)
    local function NoAnnounce()
        if state == 2 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("LOGIN_NO_ANNOUNCE"))
            UIMgr:DeActiveUI(self.name)
        end
    end

    if data then
        log("ANNOUNCE state=>获取到了数据 | code=>"..data.code)
        if data.code == 200 then
            if MgrMgr:GetMgr("AnnounceMgr").GetIsShow() then
                -- 显示公告
                self.panel.Announce.gameObject:SetActiveEx(true)
                -- 公告内容
                self.panel.RichTextAnnounce.LabText = data.data.content
            else
                UIMgr:DeActiveUI(self.name)
            end
        else
            NoAnnounce()
        end
    else
        log("ANNOUNCE state=>公告获取超时")
        NoAnnounce()
    end
end

function AnnounceCtrl:UpdateDownArrow()
    if self.panel then
        self.panel.AnnounceScrollView:SetScrollRectGameObjListener(nil,self.panel.DownArrow.gameObject,nil,nil)
    end
end
--lua custom scripts end
return AnnounceCtrl