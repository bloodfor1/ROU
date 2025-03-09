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
---@class TransferControllerNpcTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Name MoonClient.MLuaUICom
---@field Npc MoonClient.MLuaUICom
---@field Img_NameBg MoonClient.MLuaUICom

---@class TransferControllerNpcTemplate : BaseUITemplate
---@field Parameter TransferControllerNpcTemplateParameter

TransferControllerNpcTemplate = class("TransferControllerNpcTemplate", super)
--lua class define end

--lua functions
function TransferControllerNpcTemplate:Init()
    super.Init(self)
end --func end
--next--
function TransferControllerNpcTemplate:OnDestroy()
    self.head2d = nil
end --func end
--next--
function TransferControllerNpcTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function TransferControllerNpcTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
function TransferControllerNpcTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function TransferControllerNpcTemplate:CustomSetData(data)
    local l_data = data
    self._data = data
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Npc.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })

        self.Parameter.Img_NameBg.Transform:SetAsLastSibling()
    end

    ---@type HeadTemplateParam
    local param = {
        ShowFrame = false,
        ShowBg = false,
        OnClick = self._onIconClick,
        OnClickSelf = self,
        NpcHeadID = data.npcId,
    }

    self.head2d:SetData(param)
    local l_row = TableUtil.GetNpcTable().GetRowById(l_data.npcId)
    self.Parameter.Txt_Name.LabText = l_row and l_row.Name or ""
    MLuaCommonHelper.SetRectTransformPos(self.Parameter.Npc.gameObject, l_data.posx, l_data.posy)
end

function TransferControllerNpcTemplate:_onIconClick()
    if self.MethodCallback then
        self.MethodCallback(self._data.npcId, self._data.sceneId)
    end
end

--lua custom scripts end
return TransferControllerNpcTemplate