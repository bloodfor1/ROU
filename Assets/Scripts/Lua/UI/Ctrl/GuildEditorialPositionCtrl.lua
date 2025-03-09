--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildEditorialPositionPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildEditorialPositionCtrl = class("GuildEditorialPositionCtrl", super)
--lua class define end

local l_guildData = nil
local l_memberTitleLengthMin = 4
local l_memberTitleLengthMax = 10
local l_originalName01
local l_originalName02

--lua functions
function GuildEditorialPositionCtrl:ctor()

    super.ctor(self, CtrlNames.GuildEditorialPosition, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function GuildEditorialPositionCtrl:Init()

    self.panel = UI.GuildEditorialPositionPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")

    --输入框的最大 最小 长度限制获取
    local l_memberTitleLength = TableUtil.GetGuildSettingTable().GetRowBySetting("MemberTitleLength").Value
    local l_memberTitleLengthValues = string.ro_split(l_memberTitleLength, "=")
    l_memberTitleLengthMin = tonumber(l_memberTitleLengthValues[1])
    l_memberTitleLengthMax = tonumber(l_memberTitleLengthValues[2])

    --输入框最大字符数限制设置
    self.panel.NameInput_01.Input.characterLimit = l_memberTitleLengthMax
    self.panel.NameInput_02.Input.characterLimit = l_memberTitleLengthMax

    --原有的自定义值设置
    l_originalName01 = l_guildData.GetPositionName(l_guildData.EPositionType.Special_1)
    l_originalName02 = l_guildData.GetPositionName(l_guildData.EPositionType.Special_2)
    self.panel.NameInput_01.Input.text = l_originalName01
    self.panel.NameInput_02.Input.text = l_originalName02

    --输入框有操作则隐藏输入提示图标 虽然非运行时 提示图片的index为0 但是运行时会增加一个光标 所以index用1
    self.panel.NameInput_01:OnInputFieldChange(function()
        self.panel.NameInput_01.Transform:GetChild(1).gameObject:SetActiveEx(false)
    end)
    self.panel.NameInput_02:OnInputFieldChange(function()
        self.panel.NameInput_02.Transform:GetChild(1).gameObject:SetActiveEx(false)
    end)

    --权限限制 执事和魅力担当和成员不可操作
    if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.Director then
        self.panel.NameInput_01.Input.interactable = false
        self.panel.NameInput_02.Input.interactable = false
        --不可操作按钮激活
        self.panel.BtnNoEdit01.UObj:SetActiveEx(true)
        self.panel.BtnNoEdit02.UObj:SetActiveEx(true)
        self.panel.BtnNoEdit01:AddClick(function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_RIGHT_TO_EDIT"))
        end)
        self.panel.BtnNoEdit02:AddClick(function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_RIGHT_TO_EDIT"))
        end)
    end

    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildEditorialPosition)
    end)
    --确定按钮点击
    self.panel.BtnSure:AddClick(function()
        self:EditPositionName()
    end)


end --func end
--next--
function GuildEditorialPositionCtrl:Uninit()

    l_guildData = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildEditorialPositionCtrl:OnActive()


end --func end
--next--
function GuildEditorialPositionCtrl:OnDeActive()


end --func end
--next--
function GuildEditorialPositionCtrl:Update()


end --func end



--next--
function GuildEditorialPositionCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function GuildEditorialPositionCtrl:EditPositionName()
    local l_positionName01 = self.panel.NameInput_01.Input.text
    local l_positionName02 = self.panel.NameInput_02.Input.text
    local l_nameLength01 = string.ro_len_normalize(l_positionName01)
    local l_nameLength02 = string.ro_len_normalize(l_positionName02)
    local l_originalNameLength01 = string.ro_len_normalize(l_originalName01)
    local l_originalNameLength02 = string.ro_len_normalize(l_originalName02)

    -- 一个中文长度算2的方法 暂时保留
    -- local l_nameLength01 = string.ro_len(l_positionName01)
    -- local l_nameLength02 = string.ro_len(l_positionName02)
    -- local l_originalNameLength01 = string.ro_len(l_originalName01)
    -- local l_originalNameLength02 = string.ro_len(l_originalName02)

    --如果输入内容和原来值 没有变化 则直接关闭
    if l_positionName01 == l_originalName01 and l_positionName02 == l_originalName02 then
        UIMgr:DeActiveUI(UI.CtrlNames.GuildEditorialPosition)
        return
    end

    if l_nameLength01 > l_memberTitleLengthMax or l_nameLength02 > l_memberTitleLengthMax or
        ((l_originalNameLength01 > 0 or l_nameLength01 > 0 ) and l_nameLength01 < l_memberTitleLengthMin) or
        ((l_originalNameLength02 > 0 or l_nameLength02 > 0 ) and l_nameLength02 < l_memberTitleLengthMin) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_NAME_LENGTH_ERROR"))
        return
    end

    --判断是否是全数字
    local l_numName01 = tonumber(l_positionName01)
    local l_numName02 = tonumber(l_positionName02)
    if l_numName01 or l_numName02 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_NAME_CAN_NOT_ALL_NUM"))
        return
    end

    --判断是否有非法字符
    if string.ro_isLegal(l_positionName01) or string.ro_isLegal(l_positionName02) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("INPUT_ILLEGAL_TYPE2"))
        return
    end

    local newNameList = {}
    newNameList[l_guildData.EPositionType.Special_1] = l_positionName01
    newNameList[l_guildData.EPositionType.Special_2] = l_positionName02
    MgrMgr:GetMgr("GuildMgr").ReqEditPositionName(newNameList)
    UIMgr:DeActiveUI(UI.CtrlNames.GuildEditorialPosition)
end
--lua custom scripts end
