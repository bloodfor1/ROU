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
---@class MagicRecoveTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Panel MoonClient.MLuaUICom
---@field ItemShowPrefab MoonClient.MLuaUICom
---@field ImgBind MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom

---@class MagicRecoveTemplate : BaseUITemplate
---@field Parameter MagicRecoveTemplateParameter

MagicRecoveTemplate = class("MagicRecoveTemplate", super)
--lua class define end

--lua functions
function MagicRecoveTemplate:Init()
    super.Init(self)
    self.item = nil
end --func end
--next--
function MagicRecoveTemplate:OnDestroy()
    self.item = nil
end --func end
--next--
function MagicRecoveTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function MagicRecoveTemplate:OnSetData(data)
    self.data = data
    self.Parameter.ItemShowPrefab:AddClick(function()
        self:MethodCallback(self)
    end)
    self.Parameter.Checkmark.gameObject:SetActiveEx(data.select)
    self.Parameter.ImgBind.gameObject:SetActiveEx(data.bagdata.IsBind)
    ---@type ItemTemplateParam
    local l_TmpData = {}
    l_TmpData.PropInfo = data.bagdata
    l_TmpData.IsShowName = true
    l_TmpData.IsShowCount = false
    l_TmpData.IsShowRequire = false
    l_TmpData.NeedRedMask = data.bagdata:EquipEnhanced()
    l_TmpData.ButtonMethod = function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(data.bagdata, nil, Data.BagModel.WeaponStatus.RECOVE_CARD)
    end

    if self.item == nil then
        self.item = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.Parameter.Panel.transform,
            Data = l_TmpData,
        })

        self.item:gameObject():GetComponent("RectTransform").anchoredPosition = Vector2(0, 10)
    else
        self.item:SetData(l_TmpData)
    end
end --func end
--next--
function MagicRecoveTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MagicRecoveTemplate