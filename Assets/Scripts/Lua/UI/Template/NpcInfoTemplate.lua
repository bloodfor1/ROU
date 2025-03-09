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
---@class NpcInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_NpcJobInfo MoonClient.MLuaUICom
---@field Txt_NpcInfo MoonClient.MLuaUICom
---@field Img_NpcInfo MoonClient.MLuaUICom
---@field Img_Head MoonClient.MLuaUICom
---@field Img_CheckMark MoonClient.MLuaUICom
---@field BG_npc MoonClient.MLuaUICom

---@class NpcInfoTemplate : BaseUITemplate
---@field Parameter NpcInfoTemplateParameter

NpcInfoTemplate = class("NpcInfoTemplate", super)
--lua class define end

--lua functions
function NpcInfoTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function NpcInfoTemplate:OnDestroy()
	
	    self.head2d = nil
	
end --func end
--next--
function NpcInfoTemplate:OnDeActive()
	
	    -- do nothing
	
end --func end
--next--
function NpcInfoTemplate:OnSetData(data)
	
	    self.data = data
	    if not self.head2d then
	        self.head2d = self:NewTemplate("HeadWrapTemplate", {
	            TemplateParent = self.Parameter.Img_Head.transform,
	            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	        })
	    end
	    ---@type HeadTemplateParam
	    local param = {
	        NpcHeadID = data.npcData.Id,
	        OnClick = self._onIconClick,
	        OnClickSelf = self,
	    }
	    self.head2d:SetData(param)
	    self.Parameter.Txt_NpcInfo.LabText = data.npcData.Name
	    if string.ro_isEmpty(data.npcData.Function) then
	        self.Parameter.Txt_NpcJobInfo.UObj:SetActiveEx(false)
	    else
	        self.Parameter.Txt_NpcJobInfo.UObj:SetActiveEx(true)
	        self.Parameter.Txt_NpcJobInfo.LabText = data.npcData.Function
	    end
	    if string.ro_isEmpty(data.spName) then
	        if string.ro_isEmpty(data.npcData.NpcMapIcon) then
	            self.Parameter.Img_NpcInfo.Img.enabled = false
	        else
	            self.Parameter.Img_NpcInfo.Img.enabled = true
	            self.Parameter.Img_NpcInfo:SetSprite("Map", data.npcData.NpcMapIcon, true)
	        end
	    else
	        self.Parameter.Img_NpcInfo.Img.enabled = true
	        self.Parameter.Img_NpcInfo:SetSprite("Map", data.spName, true)
	    end
	     self.Parameter.BG_npc:AddClick(function ()
             self:_onIconClick()
         end)
	
end --func end
--next--
function NpcInfoTemplate:BindEvents()
	
	    -- do nothing
	
end --func end
--next--
--lua functions end

--lua custom scripts
function NpcInfoTemplate:_onIconClick()
    if not self._isSelect then
        --find npc path
        local l_pos = self.data.pos
        if MTransferMgr.IsActiveWorldMap then
            UIMgr:DeActiveUI(UI.CtrlNames.WorldMap)
        end
        if l_pos.x > 0 then
            MTransferMgr:GotoPosition(self.data.sceneId, l_pos)
        else
            MTransferMgr:GotoNpc(self.data.sceneId, self.data.npcData.Id)
        end
    end

    local l_mapInfoMgr = MgrMgr:GetMgr("MapInfoMgr")
    l_mapInfoMgr.EventDispatcher:Dispatch(l_mapInfoMgr.EventType.UpdateNpcInfoSelectState, not self._isSelect, self.ShowIndex)
end

function NpcInfoTemplate:OnSelect()
    self.Parameter.Img_CheckMark:SetActiveEx(true)
end

function NpcInfoTemplate:OnDeselect()
    self.Parameter.Img_CheckMark:SetActiveEx(false)
end
--lua custom scripts end
return NpcInfoTemplate