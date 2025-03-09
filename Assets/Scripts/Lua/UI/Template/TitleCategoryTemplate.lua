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
--lua fields end

--lua class define
---@class TitleCategoryTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TittleCategory MoonClient.MLuaUICom
---@field TitleContent MoonClient.MLuaUICom
---@field CategoryTog MoonClient.MLuaUICom
---@field CategoryText MoonClient.MLuaUICom

---@class TitleCategoryTemplate : BaseUITemplate
---@field Parameter TitleCategoryTemplateParameter

TitleCategoryTemplate = class("TitleCategoryTemplate", super)
--lua class define end

--lua functions
function TitleCategoryTemplate:Init()

    super.Init(self)

    self.titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")
    self.titleStickerData = DataMgr:GetData("TitleStickerData")
    self.Parameter.CategoryTog.TogEx.onValueChanged:AddListener(function(isOn)
        self.Parameter.TitleContent:SetActiveEx(not isOn)
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.TitleContent.transform.parent)
    end)

end --func end
--next--
function TitleCategoryTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function TitleCategoryTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function TitleCategoryTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function TitleCategoryTemplate:OnSetData(data)
    self.titleIndexInfo = data.titleIndexInfo
    self.titleCellGo = data.titleCellGo
    self.titleHandler = data.titleHandler
    self.canTitleShownFunc = data.canTitleShownFunc
    self.titlePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.TitleCellTemplate,
        TemplateParent = self.Parameter.TitleContent.transform,
        TemplatePrefab = self.titleCellGo,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })

    local l_titleInfos = self.titleStickerData.GetTitleInfosByIndex(self.titleIndexInfo.index)
    local l_allNum = #l_titleInfos
    local l_ownNum = 0
    local l_datas = {}
    local l_shownNum = 0
    for i = 1, #l_titleInfos do
        if l_titleInfos[i].isOwned then
            l_ownNum = l_ownNum + 1
        end
        if self.titleHandler:CanTitleShow(l_titleInfos[i]) then
            table.insert(l_datas, { titleInfo = l_titleInfos[i], titleHandler = self.titleHandler })
            l_shownNum = l_shownNum + 1
        end
    end
    self.titlePool:ShowTemplates({ Datas = l_datas })
    self.Parameter.CategoryText.LabText = StringEx.Format("{0}({1}/{2})", self.titleIndexInfo.tableInfo.Name, l_ownNum, l_allNum)

    self.Parameter.TittleCategory:SetActiveEx(l_shownNum ~= 0)
end --func end
--next--
--lua functions end

--lua custom scripts

function TitleCategoryTemplate:GetTitleItems()
    return self.titlePool:GetItems()
end

function TitleCategoryTemplate:_onTemplatePoolUpdate()
    if self.titlePool then
        self.titlePool:OnUpdate()
    end
end


--lua custom scripts end
return TitleCategoryTemplate