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
---@class BtnPlayerLeftParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field WidgetTagParent MoonClient.MLuaUICom
---@field WidgetParentNormal MoonClient.MLuaUICom
---@field WidgetMVP MoonClient.MLuaUICom
---@field TxtNormalScore MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field TxtMVPScore MoonClient.MLuaUICom
---@field TxtKill MoonClient.MLuaUICom
---@field TxtJob MoonClient.MLuaUICom
---@field TxtAssist MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field BtnPlayerSelf MoonClient.MLuaUICom
---@field BtnPlayer MoonClient.MLuaUICom
---@field BtnLike MoonClient.MLuaUICom
---@field BtnFriend MoonClient.MLuaUICom
---@field PlayeLeftTag MoonClient.MLuaUIGroup

---@class BtnPlayerLeft : BaseUITemplate
---@field Parameter BtnPlayerLeftParameter

BtnPlayerLeft = class("BtnPlayerLeft", super)
--lua class define end

--lua functions
function BtnPlayerLeft:Init()
    super.Init(self)
    self._onLikeClickFunc = nil
    self._onLikeClickSelf = nil
    self._onAddFriendClickFunc = nil
    self._onAddFriendClickSelf = nil
    self._targetPlayerUid = nil
    self._playerName = nil
    self._playerProfession = 0
    self._playerEquipData = nil
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function BtnPlayerLeft:BindEvents()
    -- do nothing
end --func end
--next--
function BtnPlayerLeft:OnDestroy()
    -- do nothing
end --func end
--next--
function BtnPlayerLeft:OnDeActive()
    -- do nothing
end --func end
--next--
function BtnPlayerLeft:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function BtnPlayerLeft:_initConfig()
    self._headTemplateConfig = {
        name = "HeadWrapTemplate",
        config = {
            TemplateParent = self.Parameter.HeadDummy.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate",
        }
    }

    self._tagListConfig = {
        TemplateClassName = "PlayeLeftTag",
        TemplatePrefab = self.Parameter.PlayeLeftTag.gameObject,
        TemplateParent = self.Parameter.WidgetTagParent.Transform,
    }
end

function BtnPlayerLeft:_initWidgets()
    self._headTemplate = self:NewTemplate(self._headTemplateConfig.name, self._headTemplateConfig.config)
    self._tagTemplatePool = self:NewTemplatePool(self._tagListConfig)
    self.Parameter.BtnLike:AddClickWithLuaSelf(self._onLikeClick, self)
    self.Parameter.BtnFriend:AddClickWithLuaSelf(self._onAddFriendClick, self)
end

--- 设置数据总入口
---@param data BattleFieldEndSinglePlayerData
function BtnPlayerLeft:_onSetData(data)
    if nil == data then
        logError("[BattleSinglePlayerLeft] invalid data")
        return
    end

    self._targetPlayerUid = data.PlayerUID
    self._onLikeClickFunc = data.OnLikeClick
    self._onLikeClickSelf = data.OnLikeClickSelf
    self._onAddFriendClickFunc = data.OnAddFriendClick
    self._onAddFriendClickSelf = data.OnAddFriendClickSelf
    self.Parameter.TxtKill.LabText = data.KillNum
    self.Parameter.TxtAssist.LabText = data.AssistNum
    self._playerName = data.PlayerName
    local paramList = {}
    if nil ~= data.TagList then
        for i = 1, #data.TagList do
            local singleTag = data.TagList[i]
            local singleData = { tagType = singleTag }
            table.insert(paramList, singleData)
        end
    end

    self._tagTemplatePool:ShowTemplates({ Datas = paramList })
    local isPlayerSelf = uint64.equals(MPlayerInfo.UID, data.PlayerUID)
    self.Parameter.BtnPlayerSelf:SetActiveEx(isPlayerSelf)
    self.Parameter.TxtMVPScore.LabText = data.Score
    self.Parameter.TxtNormalScore.LabText = data.Score
    self.Parameter.WidgetMVP:SetActiveEx(data.IsMvp)
    self.Parameter.WidgetParentNormal:SetActiveEx(not data.IsMvp)
    local professionTable = TableUtil.GetProfessionTable().GetRowById(data.PlayerPro)
    if nil ~= professionTable then
        self.Parameter.TxtJob.LabText = professionTable.Name
    end

    self.Parameter.TxtName.LabText = data.PlayerName
    self:_setHeadData(data.PlayerEquipData, data.PlayerPro)
end

function BtnPlayerLeft:_onAddFriendClick()
    if nil == self._onAddFriendClickFunc then
        return
    end

    self._onAddFriendClickFunc(self._onAddFriendClickSelf, self._targetPlayerUid)
end

function BtnPlayerLeft:_onLikeClick()
    if nil == self._onLikeClickFunc then
        return
    end

    self._onLikeClickFunc(self._onLikeClickSelf, self._targetPlayerUid, self._playerName)
end

function BtnPlayerLeft:_setHeadData(equipData, profession)
    ---@type HeadTemplateParam
    local param = {
        EquipData = equipData,
        ShowProfession = true,
        Profession = profession,
    }

    self._headTemplate:SetData(param)
end

--lua custom scripts end
return BtnPlayerLeft