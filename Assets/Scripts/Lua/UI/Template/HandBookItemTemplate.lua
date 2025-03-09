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
---@class HandBookItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field LockTxt MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class HandBookItemTemplate : BaseUITemplate
---@field Parameter HandBookItemTemplateParameter

HandBookItemTemplate = class("HandBookItemTemplate", super)
--lua class define end

--lua functions
function HandBookItemTemplate:Init()

    super.Init(self)

end --func end
--next--
function HandBookItemTemplate:OnDestroy()


end --func end
--next--
function HandBookItemTemplate:OnDeActive()

    if self.RedSignBook then
        self.RedSignBook:Uninit()
        self.RedSignBook = nil
    end

end --func end
--next--
function HandBookItemTemplate:OnSetData(data)

    local systemSdata = TableUtil.GetOpenSystemTable().GetRowById(data.systemId)
    if not systemSdata then
        return
    end
    self.Parameter.Icon:SetSpriteAsync(systemSdata.SystemAtlas, systemSdata.SystemIcon)
    self.Parameter.Name.LabText = systemSdata.Title
    local isOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(data.systemId)
    self.Parameter.Lock:SetActiveEx(not isOpen)
    if not isOpen then
        self.Parameter.LockTxt.LabText = Lang("ILLUSTRATION_LOCK_TEXT", systemSdata.BaseLevel)
    end
    self.Parameter.Icon:AddClick(function()
        if data.ctrl then
            data.ctrl:OpenHandBook(data.systemId)
        end
    end)
    --红点相关
    local l_redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    local l_resSignKey = nil
    if data.systemId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.AdventureDiary then
        --冒险日记
        l_resSignKey = eRedSignKey.AdventureDiary
    elseif data.systemId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Personal then
        -- 个性化图鉴
        l_resSignKey = eRedSignKey.Personal
    elseif data.systemId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BoliHandBook then
        --波利
        l_resSignKey = eRedSignKey.PollyManual
    elseif data.systemId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.IllustratorMonster then
        l_resSignKey = eRedSignKey.MonsterHandBook
    end
    if l_resSignKey then
        self.RedSignBook = self:NewRedSign({
            Key = l_resSignKey,
            ClickButton = self.Parameter.Icon,
        })
    end
end --func end
--next--
function HandBookItemTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return HandBookItemTemplate