--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local lastSelectIdx = -1
--lua fields end

--lua class define
---@class ArrowItemSelectTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectBoard MoonClient.MLuaUICom
---@field ImgSelect MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom

---@class ArrowItemSelectTemplate : BaseUITemplate
---@field Parameter ArrowItemSelectTemplateParameter

ArrowItemSelectTemplate = class("ArrowItemSelectTemplate", super)
--lua class define end

--lua functions
function ArrowItemSelectTemplate:Init()
    super.Init(self)
    self.data = nil
end --func end
--next--
function ArrowItemSelectTemplate:OnDestroy()
    self.data = nil
end --func end
--next--
function ArrowItemSelectTemplate:OnSetData(data)

    self.chooseIdx = nil
    self.data = nil
    local itemSdata = TableUtil.GetItemTable().GetRowByItemID(data.propId)
    if not itemSdata then
        logError("dont find item sdata ", data.propId)
        return
    end

    self.data = data
    self.Parameter.Count.LabText = tostring(data.count)
    self.Parameter.Image:SetSprite(itemSdata.ItemAtlas, itemSdata.ItemIcon)
    self:RefreshChoose(data.chooseIdx)
    self.Parameter.Image:AddClick(function()
        local arrowMgr = MgrMgr:GetMgr("ArrowMgr")
        arrowMgr.EventDispatcher:Dispatch(arrowMgr.SELECT_ITEM, data.propId, data.chooseIdx, self.showIdx)
        local ui = UIMgr:GetUI(UI.CtrlNames.ArrowSetup)
        if ui then
            ui:OnClickItem(lastSelectIdx)
        end

        self:RefreshSelect(self.ShowIndex)
        lastSelectIdx = self.ShowIndex
    end)

end --func end
--next--
function ArrowItemSelectTemplate:BindEvents()


end --func end
--next--
function ArrowItemSelectTemplate:OnDeActive()


end --func end
--next--
--lua functions end

--lua custom scripts
function ArrowItemSelectTemplate:RefreshSelect(showIdx)

    if showIdx then
        self.Parameter.ImgSelect:SetActiveEx(showIdx == self.ShowIndex)
    else
        self.Parameter.ImgSelect:SetActiveEx(false)
    end

end

function ArrowItemSelectTemplate:SetEquipIdx()
end

function ArrowItemSelectTemplate:OnClickItem()

end

function ArrowItemSelectTemplate:GetChooseIdx()
    return self.data and self.data.chooseIdx
end

function ArrowItemSelectTemplate:GetPropId()
    return self.data and self.data.propId
end

local selectBoards = {
    "UI_Common_Identification_009.png",
    "UI_Common_Identification_010.png",
    "UI_Common_Identification_011.png"
}

function ArrowItemSelectTemplate:RefreshChoose(chooseIdx)

    if chooseIdx and chooseIdx > 0 then
        self.Parameter.SelectBoard:SetActiveEx(chooseIdx > 0)
        if not selectBoards[chooseIdx] then
            logError("invalid select board idx ", chooseIdx)
            self.Parameter.SelectBoard:SetActiveEx(false)
            return
        end
        self.Parameter.SelectBoard:SetSprite("Common", selectBoards[chooseIdx])
    else
        self.Parameter.SelectBoard:SetActiveEx(false)
    end
    if self.data then
        self.data.chooseIdx = chooseIdx
    end

end

function ArrowItemSelectTemplate.GetLastSelectIdx()
    return lastSelectIdx
end
--lua custom scripts end
return ArrowItemSelectTemplate