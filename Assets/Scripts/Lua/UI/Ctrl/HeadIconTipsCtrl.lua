--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HeadIconTipsPanel"
require "UI/Panel/HeadIconTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
HeadIconTipsCtrl = class("HeadIconTipsCtrl", super)
--lua class define end

--lua functions
function HeadIconTipsCtrl:ctor()

    super.ctor(self, CtrlNames.HeadIconTips, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function HeadIconTipsCtrl:Init()

    self.panel = UI.HeadIconTipsPanel.Bind(self)
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.HeadIconTips)
    end)
    super.Init(self)

end --func end
--next--
function HeadIconTipsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function HeadIconTipsCtrl:OnActive()


end --func end
--next--
function HeadIconTipsCtrl:OnDeActive()


end --func end
--next--
function HeadIconTipsCtrl:Update()


end --func end



--next-
function HeadIconTipsCtrl:OnShow()

end --func end

--next--
function HeadIconTipsCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function HeadIconTipsCtrl:ShowHeadIconTips(itemId)
    local l_item = TableUtil.GetItemTable().GetRowByItemID(itemId)
    self.panel.txtTipName.LabText = l_item.ItemName or ""
    self.panel.txtTipType.LabText = Common.CommonUIFunc.GetEquipTypeName(l_item) or ""
    self.panel.txtTipLevel.LabText = Common.CommonUIFunc.GetLevelStr(l_item.LevelLimit)
    self.panel.txtDes.LabText = l_item.ItemDescription or ""
    self.panel.ItemImg:SetSprite(l_item.ItemAtlas, l_item.ItemIcon)
    local l_richTxt = self.panel.ShowIllustrated
    l_richTxt.LabText = Common.CommonUIFunc.GetRichTextTxt("open", "Blue", Lang("VEHICLE_VIEW"))
    local l_richText = l_richTxt:GetRichText()
    l_richText.raycastTarget = true
    l_richText.onHrefClick:RemoveAllListeners()
    l_richText.onHrefClick:AddListener(function(key)
        if key == "open" then
            UIMgr:ActiveUI(UI.CtrlNames.Personal, function(ctrl)
                ctrl:SetupHandlers()
                ctrl:SelectOneHandler(UI.HandlerNames.HeadSelect)
            end)
        end
    end)
end
--lua custom scripts end
return HeadIconTipsCtrl