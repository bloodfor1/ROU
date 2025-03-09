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
---@class BtnPlayerRightParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field WidgetTagParent MoonClient.MLuaUICom
---@field WidgetNormalScore MoonClient.MLuaUICom
---@field WidgetMVP MoonClient.MLuaUICom
---@field TxtNormalScore MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field TxtMvpScore MoonClient.MLuaUICom
---@field TxtKillNum MoonClient.MLuaUICom
---@field TxtJob MoonClient.MLuaUICom
---@field TxtAssistNum MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field BtnPlayer2 MoonClient.MLuaUICom
---@field BtnLike2 MoonClient.MLuaUICom
---@field BtnFriend2 MoonClient.MLuaUICom
---@field TagRight MoonClient.MLuaUIGroup

---@class BtnPlayerRight : BaseUITemplate
---@field Parameter BtnPlayerRightParameter

BtnPlayerRight = class("BtnPlayerRight", super)
--lua class define end

--lua functions
function BtnPlayerRight:Init()
    super.Init(self)
    self._onLikeClickFunc = nil
    self._onLikeClickSelf = nil
    self._onAddFriendClickFunc = nil
    self._onAddFriendClickSelf = nil
    self._targetPlayerUid = nil
    self._playerName = nil
    self._playerProfession = 0
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function BtnPlayerRight:BindEvents()
    -- do nothing
end --func end
--next--
function BtnPlayerRight:OnDestroy()
    -- do nothing
end --func end
--next--
function BtnPlayerRight:OnDeActive()
    -- do nothing
end --func end
--next--
function BtnPlayerRight:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function BtnPlayerRight:_initConfig()
    self._headTemplateConfig = {
        name = "HeadWrapTemplate",
        config = {
            TemplateParent = self.Parameter.HeadDummy.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate",
        }
    }

    self._tagListConfig = {
        TemplateClassName = "TagRight",
        TemplatePrefab = self.Parameter.TagRight.gameObject,
        TemplateParent = self.Parameter.WidgetTagParent.Transform,
    }
end

function BtnPlayerRight:_initWidgets()
    self._headTemplate = self:NewTemplate(self._headTemplateConfig.name, self._headTemplateConfig.config)
    self._tagTemplatePool = self:NewTemplatePool(self._tagListConfig)
    self.Parameter.BtnLike2:AddClickWithLuaSelf(self._onLikeClick, self)
    self.Parameter.BtnFriend2:AddClickWithLuaSelf(self._onAddFriendClick, self)
end

--- 设置数据总入口
---@param data BattleFieldEndSinglePlayerData
function BtnPlayerRight:_onSetData(data)
    if nil == data then
        logError("[BattleSinglePlayerLeft] invalid data")
        return
    end

    self._targetPlayerUid = data.PlayerUID
    self._onLikeClickFunc = data.OnLikeClick
    self._onLikeClickSelf = data.OnLikeClickSelf
    self._onAddFriendClickFunc = data.OnAddFriendClick
    self._onAddFriendClickSelf = data.OnAddFriendClickSelf
    self.Parameter.TxtKillNum.LabText = data.KillNum
    self.Parameter.TxtAssistNum.LabText = data.AssistNum
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
    self.Parameter.TxtMvpScore.LabText = data.Score
    self.Parameter.TxtNormalScore.LabText = data.Score
    self.Parameter.WidgetMVP:SetActiveEx(data.IsMvp)
    self.Parameter.WidgetNormalScore:SetActiveEx(not data.IsMvp)
    self.Parameter.TxtName.LabText = data.PlayerName
    local professionTable = TableUtil.GetProfessionTable().GetRowById(data.PlayerPro)
    if nil ~= professionTable then
        self.Parameter.TxtJob.LabText = professionTable.Name
    end

    self:_setHeadData(data.PlayerEquipData, data.PlayerPro)
end

function BtnPlayerRight:_onAddFriendClick()
    if nil == self._onAddFriendClickFunc then
        return
    end

    self._onAddFriendClickFunc(self._onAddFriendClickSelf, self._targetPlayerUid)
end

function BtnPlayerRight:_onLikeClick()
    if nil == self._onLikeClickFunc then
        return
    end

    self._onLikeClickFunc(self._onLikeClickSelf, self._targetPlayerUid, self._playerName)
end

function BtnPlayerRight:_setHeadData(equipData, profession)
    ---@type HeadTemplateParam
    local param = {
        EquipData = equipData,
        ShowProfession = true,
        Profession = profession,
    }

    self._headTemplate:SetData(param)
end

--lua custom scripts end
return BtnPlayerRight