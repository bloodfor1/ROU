--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationPandectPanel"
require "UI/Template/HandBookItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
IllustrationPandectCtrl = class("IllustrationPandectCtrl", super)
--lua class define end

--lua functions
function IllustrationPandectCtrl:ctor()

    super.ctor(self, CtrlNames.IllustrationPandect, UILayer.Function, nil, ActiveType.Exclusive)
    self.mgr = MgrMgr:GetMgr("IllustrationMgr")
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")

end --func end
--next--
function IllustrationPandectCtrl:Init()

    self.panel = UI.IllustrationPandectPanel.Bind(self)
    super.Init(self)

    self.bookPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.HandBookItemTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.HandBookItemTemplate.LuaUIGroup.gameObject
    })

    self.panel.CloseBtn:AddClickWithLuaSelf(self._onCloseClick, self)
end --func end
--next--
function IllustrationPandectCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function IllustrationPandectCtrl:OnActive()
    self.panel.Left:SetActiveEx(false)
    self.panel.Right:SetActiveEx(false)
    self.panel.HandBookItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)

    self:ShowBooks()
    self.panel.Scroll:SetScrollRectGameObjListener(self.panel.Left.gameObject, self.panel.Right.gameObject, nil, nil)
end --func end
--next--
function IllustrationPandectCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function IllustrationPandectCtrl:Update()
    -- do nothing
end --func end

--next--
function IllustrationPandectCtrl:BindEvents()
    -- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts
--- 点击关闭触发的回调
function IllustrationPandectCtrl:_onCloseClick()
    UIMgr:DeActiveUI(self.name)
end

function IllustrationPandectCtrl:ShowBooks()
    local sortList = self.mgr.GetHandBookSortList()
    local sortDict = {}
    for i, v in ipairs(sortList) do
        sortDict[v] = i
    end
    local datas = {}
    for i, v in ipairs(sortList) do
        local openSdata = TableUtil.GetOpenSystemTable().GetRowById(v)
        table.insert(datas, {
            systemId = v,
            openLv = openSdata.BaseLevel,
            ctrl = self
        })
    end
    table.sort(datas, function(a, b)
        if a.openLv < b.openLv then
            return true
        end
        if a.openLv > b.openLv then
            return false
        end
        return (sortDict[a.systemId] or 0) < (sortDict[b.systemId] or 0)
    end)
    self.bookPool:ShowTemplates({ Datas = datas })
end

function IllustrationPandectCtrl:OpenHandBook(id)
    local systemFuncMgr = MgrMgr:GetMgr("SystemFunctionEventMgr")
    local openSdata = TableUtil.GetOpenSystemTable().GetRowById(id)
    if not self.openMgr.IsSystemOpen(id) then
        return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ILLUSTRATION_FUNC_CLOSE", openSdata.BaseLevel, openSdata.Title))
    end

    if id == self.openMgr.eSystemId.IllustratorMonster then
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonsterBg)
    elseif id == self.openMgr.eSystemId.IllustratorCard then
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationCard)
    elseif id == self.openMgr.eSystemId.IllustratorEquip then
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationEquipment)
    elseif id == self.openMgr.eSystemId.Personal then
        systemFuncMgr.OpenPersonal()
    elseif id == self.openMgr.eSystemId.BeginnerBook then
        MgrMgr:GetMgr("SystemFunctionEventMgr").OpenAdventureDiary()
    elseif id == self.openMgr.eSystemId.BoliHandBook then
        systemFuncMgr.BoliIllustrationOpenEvent()
    end
end

--lua custom scripts end
return IllustrationPandectCtrl