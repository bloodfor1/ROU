--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RedEnvelopeSelectLevelPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_curSelectId = 0  --当前选中的ID
--next--
--lua fields end

--lua class define
RedEnvelopeSelectLevelCtrl = class("RedEnvelopeSelectLevelCtrl", super)
--lua class define end

--lua functions
function RedEnvelopeSelectLevelCtrl:ctor()

    super.ctor(self, CtrlNames.RedEnvelopeSelectLevel, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent
    self.ClosePanelNameOnClickMask=UI.CtrlNames.RedEnvelopeSelectLevel

end --func end
--next--
function RedEnvelopeSelectLevelCtrl:Init()

    self.panel = UI.RedEnvelopeSelectLevelPanel.Bind(self)
    super.Init(self)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Transparent, function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelopeSelectLevel)
    --end)

    --红包等级选择池
    self.redEnvelopeLevelSelectPool = self:NewTemplatePool(
    {
        TemplateClassName = "RedEnvelopeLevelItemTemplate",
        TemplatePrefab = self.panel.RedEnvelopeLevelItemPrefab.LuaUIGroup.gameObject,
        TemplateParent = self.panel.RedEnvelopeLevelItemParent.Transform,
        Method = function(index)
            self:_onBoxCellTemplate(index)
        end
    })
    local l_tableDatas = TableUtil.GetRedPacketLevelMapTable().GetTable()
    local l_showDatas = {}
    for i= 1, #l_tableDatas do
        if l_tableDatas[i].IsOn then
            table.insert(l_showDatas, l_tableDatas[i])
        end
    end
    self.redEnvelopeLevelSelectPool:ShowTemplates({Datas = l_showDatas})

    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelopeSelectLevel)
    end)
    --取消按钮点击
    self.panel.BtnCancel:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelopeSelectLevel)
    end)
    --确定按钮点击
    self.panel.BtnSure:AddClick(function()
        if l_curSelectId ~= 0 then
            MgrMgr:GetMgr("RedEnvelopeMgr").SelectRedEnvelopeLevelType(l_curSelectId)
            UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelopeSelectLevel)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_RED_ENVELOPE_TOTAL_MONEY"))
        end
    end)

end --func end
--next--
function RedEnvelopeSelectLevelCtrl:Uninit()

    l_curSelectId = 0
    self.redEnvelopeLevelSelectPool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function RedEnvelopeSelectLevelCtrl:OnActive()


end --func end
--next--
function RedEnvelopeSelectLevelCtrl:OnDeActive()


end --func end
--next--
function RedEnvelopeSelectLevelCtrl:Update()


end --func end





--next--
function RedEnvelopeSelectLevelCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function RedEnvelopeSelectLevelCtrl:_onBoxCellTemplate(index)

    local l_selectData = self.redEnvelopeLevelSelectPool:getData(index)
    l_curSelectId = l_selectData.ID
    self.redEnvelopeLevelSelectPool:SelectTemplate(index)

end
--lua custom scripts end
return RedEnvelopeSelectLevelCtrl