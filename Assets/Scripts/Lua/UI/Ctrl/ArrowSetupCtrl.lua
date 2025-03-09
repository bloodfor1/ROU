--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ArrowSetupPanel"
require "UI/Template/ArrowItemSelectTemplate"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ArrowSetupCtrl = class("ArrowSetupCtrl", super)
--lua class define end

--lua functions
function ArrowSetupCtrl:ctor()

    super.ctor(self, CtrlNames.ArrowSetup, UILayer.Normal, nil, ActiveType.Normal)
    self.mgr = MgrMgr:GetMgr("ArrowMgr")
    self.chooseInfo = {}
    self.lastCancleIdx = nil
    self.overrideSortLayer = UILayerSort.Normal + 2

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent

end --func end
--next--
function ArrowSetupCtrl:Init()

    self.panel = UI.ArrowSetupPanel.Bind(self)
    super.Init(self)
    self.panel.BtnClose:AddClick(handler(self, self.OnClose))

    self.arrowPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ArrowItemSelectTemplate,
        ScrollRect = self.panel.ScrollProp.LoopScroll,
        TemplatePrefab = self.panel.ArrowItemSelectTemplate.gameObject,
    })

end --func end
--next--
function ArrowSetupCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
---@param a ItemData
---@param b ItemData
function _propComp(a, b)
    if a.ItemConfig.SortID == b.ItemConfig.SortID then
        if not int64.equals(a.ItemCount, b.ItemCount) then
            return a.ItemCount > b.ItemCount
        end

        return a.UID > b.UID
    end

    return a.ItemConfig.SortID > b.ItemConfig.SortID
end

function ArrowSetupCtrl:OnActive()

    self.arrows = self.mgr.GetBagArrowsList()
    local arrows = {}
    local equipPos
    table.sort(self.arrows, _propComp)
    for i, v in ipairs(self.arrows) do
        equipPos = self.mgr.GetEquipArrowPos(v.TID)
        table.insert(arrows, { propId = v.TID, count = v.ItemCount, chooseIdx = equipPos })
        if equipPos then
            self.chooseInfo[equipPos] = v.TID
        end
    end
    self.panel.info:SetActiveEx(#arrows > 0)
    self.panel.noObject:SetActiveEx(#arrows == 0)
    self.arrowPool:ShowTemplates({ Datas = arrows })
    self.panel.MountBtn:AddClick(function()
        local lastSelectIdx = UITemplate.ArrowItemSelectTemplate.GetLastSelectIdx()
        local item = self.arrowPool:GetItem(lastSelectIdx)
        if item then
            local chooseIdx = item:GetChooseIdx()
            if chooseIdx then
                self.chooseInfo[chooseIdx] = nil
                item:RefreshChoose()
                self.panel.equipBtnText.LabText = Lang("ARROW_SETUP")
            else
                if self:IsFull() then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ARROW_LIMIT"))
                    return
                end
                chooseIdx = self:GetEmptyPos()
                if chooseIdx > 0 then
                    self.chooseInfo[chooseIdx] = item:GetPropId()
                    item:RefreshChoose(chooseIdx)
                    self.panel.equipBtnText.LabText = Lang("ARROW_CANCLE_SETUP")
                end
            end
        end
        self:Save()
    end)
    if #arrows > 0 then
        self:OnSelectItem(arrows[1].propId)
        self.panel.MountBtn:SetActiveEx(false)
    end

end --func end
--next--
function ArrowSetupCtrl:OnDeActive()

    self.chooseInfo = {}
    self.lastCancleIdx = nil

end --func end
--next--
function ArrowSetupCtrl:Update()
    -- do nothing
end --func end
--next--
function ArrowSetupCtrl:BindEvents()

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self.RefreshArrow)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.SELECT_ITEM, self.OnSelectItem)

end --func end
--next--
--lua functions end

--lua custom scripts
function ArrowSetupCtrl:OnClose()

    UIMgr:DeActiveUI(UI.CtrlNames.ArrowSetup)

end

function ArrowSetupCtrl:Save()
    self.mgr.Save(self.chooseInfo)
end

function ArrowSetupCtrl:DescribeCut(data)

    local l_index = string.find(data, "|")
    if not l_index then
        return data, ""
    end
    return string.sub(data, 1, l_index - 1), string.sub(data, l_index + 1)

end

function ArrowSetupCtrl:OnSelectItem(propId, chooseIdx)

    local itemFuncSdata = TableUtil.GetItemFunctionTable().GetRowByItemId(propId)
    if not itemFuncSdata then
        logError("find itemfunc Sdata error ", propId)
        return
    end
    local itemSdata = TableUtil.GetItemTable().GetRowByItemID(propId)
    if not itemSdata then
        logError("find item sdata error ", propId)
        return
    end
    self.panel.title.LabText = itemFuncSdata.ItemName
    self.panel.tip.LabText, self.panel.effTip.LabText = self:DescribeCut(itemFuncSdata.ArrowDesc)
    self.panel.MountBtn:SetActiveEx(true)
    if chooseIdx then
        self.panel.equipBtnText.LabText = Lang("ARROW_CANCLE_SETUP")
        self.panel.MountBtn:SetGray(false)
    else
        self.panel.MountBtn:SetGray(self:IsFull())
        self.panel.equipBtnText.LabText = Lang("ARROW_SETUP")
    end

end

function ArrowSetupCtrl:OnClickItem(showIdx)

    if showIdx > 0 then
        local item = self.arrowPool:GetItem(showIdx)
        if item then
            item:RefreshSelect()
        end
    end

end

function ArrowSetupCtrl:GetEmptyPos()

    local ret = -1
    for i = 1, 3 do
        if not self.chooseInfo[i] or self.chooseInfo[i] == 0 then
            ret = i
            break
        end
    end
    return ret

end

function ArrowSetupCtrl:IsFull()

    local ret = true
    for i = 1, 3 do
        if not self.chooseInfo[i] or self.chooseInfo[i] == 0 then
            ret = false
            break
        end
    end
    return ret

end

function ArrowSetupCtrl:RefreshArrow()

    local equipArrowId = self.mgr.GetEquipArrowId()
    if equipArrowId > 0 then
        local num = Data.BagModel:GetBagItemCountByTid(equipArrowId)
        local item = self.arrowPool:FindShowTem(function(v)
            return v.data and v.data.TID == equipArrowId
        end)
        if item then
            item:SetData({ propId = equipArrowId, count = num, chooseIdx = self.mgr.GetEquipArrowPos(equipArrowId) })
        end
    end

end
--lua custom scripts end

return ArrowSetupCtrl