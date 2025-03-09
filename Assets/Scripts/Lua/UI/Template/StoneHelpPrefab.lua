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
---@class StoneHelpPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field HelpImg MoonClient.MLuaUICom
---@field Help MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field BtnToTxt MoonClient.MLuaUICom
---@field BtnTo MoonClient.MLuaUICom
---@field BtnHelpTxt MoonClient.MLuaUICom
---@field BtnHelp MoonClient.MLuaUICom

---@class StoneHelpPrefab : BaseUITemplate
---@field Parameter StoneHelpPrefabParameter

StoneHelpPrefab = class("StoneHelpPrefab", super)
--lua class define end

--lua functions
function StoneHelpPrefab:Init()
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("StoneSculptureMgr")
    self.roleId = -1
    self.head2D = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadDummy.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function StoneHelpPrefab:BindEvents()
    -- do nothing
end --func end
--next--
function StoneHelpPrefab:OnDestroy()
    -- do nothing
end --func end
--next--
function StoneHelpPrefab:OnDeActive()
    -- do nothing
end --func end
--next--
function StoneHelpPrefab:OnSetData(data)
    self.roleId = data.carver_id
    if self.mgr.DetailIsNow then
        self.Parameter.Help.LabText = Lang("STONE_CARVE_TOYOU")
        self.Parameter.BtnHelp:SetActiveEx(false)
        self.Parameter.HelpImg:SetActiveEx(false)
    else
        self.Parameter.Help.LabText = Lang("STONE_CARVE_TOYOU_COUNT", self.mgr.StoneCarveHelpLimitDay, #data.carve_time)
        self.Parameter.BtnHelp:SetActiveEx(true)
        self.Parameter.HelpImg:SetActiveEx(false)
        if #data.carve_time >= self.mgr.StoneCarveGoodManTime then
            self.Parameter.HelpImg:SetActiveEx(true)
        end
    end

    if not self.mgr.DetailIsNow then
        self:SetHelpState(data.is_asked_help)
    end

    self:SetToHelpState(data.is_helped)
    self.Parameter.HelpImg:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STONE_HELP_HINT"))        --TA15天之内帮助你雕刻了5次，多请他帮你雕刻吧！
    end)

    self.Parameter.BtnTo:AddClick(function()
        --帮TA雕琢
        if data.is_helped then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("HAVE_BEEN_TAKE"))
            return
        end
        local l_openData = {
            type = DataMgr:GetData("GuildData").EUIOpenType.GuildStone,
            roleId = data.carver_id
        }
        UIMgr:DeActiveUI(UI.CtrlNames.GuildStone)
        UIMgr:ActiveUI(UI.CtrlNames.GuildStone, l_openData)
    end)

    self.Parameter.BtnHelp:AddClick(function()
        --求助TA帮你雕琢
        if data.is_asked_help then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("HAVE_BEEN_HELP"))
            return
        end
        self.mgr.SendAskForPersonalCarveStone(data.carver_id)
    end)

    self.Parameter.Name.LabText = data.carver_name
    self.Parameter.Count.LabText = Lang("HIS_STONE_PROGRESS") .. "：" .. data.carve_progress .. "/" .. self.mgr.ProgressMax
    data.equip_ids = {}
    ---@type HeadTemplateParam
    local param = {
        OnClick = self._onHeadClick,
        OnClickSelf = self,
        ShowProfession = true,
        Profession = data.profession,
        EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data)
    }

    self.head2D:SetData(param)
end --func end
--next--
--lua functions end

--lua custom scripts
function StoneHelpPrefab:_onHeadClick()
    Common.CommonUIFunc.RefreshPlayerMenuLByUid(self.roleId)
end

function StoneHelpPrefab:SetHelpState(isHelp)
    self.Parameter.BtnHelp:SetGray(isHelp)
    if isHelp then
        self.Parameter.BtnHelpTxt.LabText = Lang("HAVE_BEEN_HELP")
    else
        self.Parameter.BtnHelpTxt.LabText = Lang("STONE_HELP")
    end
end

function StoneHelpPrefab:SetToHelpState(isToHelp)
    self.Parameter.BtnTo:SetGray(isToHelp)
    if isToHelp then
        self.Parameter.BtnToTxt.LabText = Lang("HAVE_BEEN_TAKE")
    else
        self.Parameter.BtnToTxt.LabText = Lang("STONE_HELP_TO")
    end
end
--lua custom scripts end
return StoneHelpPrefab