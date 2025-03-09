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
---@class ForbidPlayerInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_playerName MoonClient.MLuaUICom
---@field Txt_PlayerID MoonClient.MLuaUICom
---@field Txt_Lv MoonClient.MLuaUICom
---@field Img_Profession MoonClient.MLuaUICom
---@field Img_HeadBg MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Btn_Del MoonClient.MLuaUICom

---@class ForbidPlayerInfoTemplate : BaseUITemplate
---@field Parameter ForbidPlayerInfoTemplateParameter

ForbidPlayerInfoTemplate = class("ForbidPlayerInfoTemplate", super)
--lua class define end

--lua functions
function ForbidPlayerInfoTemplate:Init()
    super.Init(self)

    self._head2d = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.Img_HeadBg.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function ForbidPlayerInfoTemplate:BindEvents()
    ---@type ModuleMgr.PlayerInfoMgr
    local l_playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
    self:BindEvent(l_playerInfoMgr.EventDispatcher, l_playerInfoMgr.GET_SINGLE_PLAYERINFO_FROM_SERVER,
            self.refreshPlayerInfo, self)
end --func end
--next--
function ForbidPlayerInfoTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function ForbidPlayerInfoTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function ForbidPlayerInfoTemplate:OnSetData(data)
    if data == nil then
        return
    end

    self.currentShowPlayerUID = data
    self.Parameter.Txt_PlayerID.LabText = StringEx.Format("ID：{0}", MLuaCommonHelper.Int(self.currentShowPlayerUID))
    self.Parameter.Btn_Del:AddClickWithLuaSelf(self.onClickRemoveForbidPlayerBtn, self, true)
    self.playerInfo = MgrMgr:GetMgr("PlayerInfoMgr").GetCachePlayerInfo(data)
    if self.playerInfo == nil then
        MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(self.currentShowPlayerUID)
        return
    end

    self:refreshPlayerInfo(self.currentShowPlayerUID, self.playerInfo)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param playerInfo playerInfo
function ForbidPlayerInfoTemplate:refreshPlayerInfo(uid, playerInfo)
    if uid ~= self.currentShowPlayerUID or playerInfo == nil then
        return
    end

    self.playerInfo = playerInfo
    ---@type HeadTemplateParam
    local param = {
        ShowProfession = true,
        Profession = playerInfo.type,
        ShowLv = true,
        Level = playerInfo.level,
        EquipData = playerInfo:GetEquipData(),
    }

    self._head2d:SetData(param)
    self.Parameter.Txt_playerName.LabText = playerInfo.name
end

function ForbidPlayerInfoTemplate:onClickRemoveForbidPlayerBtn()
    if self.playerInfo == nil then
        return
    end

    MgrMgr:GetMgr("ChatMgr").ReqChangeChatForbid(self.currentShowPlayerUID, false, self.playerInfo.name)
end

--lua custom scripts end
return ForbidPlayerInfoTemplate