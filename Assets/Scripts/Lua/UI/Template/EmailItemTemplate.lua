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
---@class EmailItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SendTime MoonClient.MLuaUICom
---@field ResidueTime MoonClient.MLuaUICom
---@field PlayerIcon MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Img_ImportantMail MoonClient.MLuaUICom
---@field Gift MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom
---@field Alpha MoonClient.MLuaUICom

---@class EmailItemTemplate : BaseUITemplate
---@field Parameter EmailItemTemplateParameter

EmailItemTemplate = class("EmailItemTemplate", super)
--lua class define end

--lua functions
function EmailItemTemplate:Init()

    super.Init(self)

end --func end
--next--
function EmailItemTemplate:OnDeActive()

    self.email = nil

end --func end
--next--
function EmailItemTemplate:OnSetData(email)

    self.email = email
    if self.email == nil then
        return
    end
    self.Parameter.Gift.gameObject:SetActiveEx(email.baseInfo.is_has_item)
    self.Parameter.Gift.TogEx.isOn = email.baseInfo.is_read
    self.Parameter.Btn:AddClick(function()
        self.MethodCallback(self.email, self)
    end, true)
    --邮件icon
    self:ResetHead()
    --标题
    self.Parameter.Name.LabText = email.title
    --发送时间
    local l_time = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds) - MLuaCommonHelper.Long2Int(email.baseInfo.create_time)
    local l_intervalDay = math.floor(l_time / 86400) --间隔天
    --1970年1月1日0点0分0秒时间戳
    local l_startPointOfTime = MServerTimeMgr.TimeZoneOffsetValue
    --如果发送时间为23:59:00, 当前时间为 00：1：00,这种过了一天的情况需要+1天
    --发送时间当天剩余时间
    local l_sendResidue = MLuaCommonHelper.Long2Int(email.baseInfo.create_time)
    l_sendResidue = l_sendResidue - math.floor((l_sendResidue + l_startPointOfTime) / 86400) * 86400
    --当前时间当天剩余时间
    local l_curResidue = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
    l_curResidue = l_curResidue - math.floor((l_curResidue + l_startPointOfTime) / 86400) * 86400
    if l_curResidue < l_sendResidue then
        l_intervalDay = l_intervalDay + 1
    end
    if l_intervalDay == 0 then
        self.Parameter.SendTime.LabText = Lang("EMAIL_SEND_TIME_NOW")--今天
    elseif l_intervalDay == 1 then
        self.Parameter.SendTime.LabText = Lang("EMAIL_SEND_TIME_YESTERDAY")--昨天
    else
        self.Parameter.SendTime.LabText = Lang("EMAIL_SEND_TIME_DAY", l_intervalDay)--n天前
    end
    --剩余时间
    local l_time = email.residueTime
    if l_time > 86400 then
        self.Parameter.ResidueTime.LabText = Lang("EMAIL_EXIRATION_TIME", math.floor(l_time / 86400))
    else
        l_time = l_time - math.floor(l_time / 86400)
        if l_time > 3600 then
            self.Parameter.ResidueTime.LabText = Lang("EMAIL_EXIRATION_TIME_HOUR", math.floor(l_time / 3600))
        else
            self.Parameter.ResidueTime.LabText = Lang("EMAIL_EXIRATION_TIME_MIN")
        end
    end
    --透明度
    self.Parameter.Mask:SetActiveEx(email.baseInfo.is_read)
    self.Parameter.Img_ImportantMail:SetActiveEx(email.raw.ImportantMail > 0)
    self:SetLightActive(MgrMgr:GetMgr("EmailMgr").CurrentSelectIndex == self.ShowIndex)

end --func end
--next--
function EmailItemTemplate:BindEvents()

    -- do nothing

end --func end
--next--
function EmailItemTemplate:OnDestroy()

    self.head2d = nil

end --func end
--next--
--lua functions end

--lua custom scripts
function EmailItemTemplate:ResetHead()
    if self.email == nil then
        return
    end

    --邮件icon
    self.Parameter.PlayerIcon.Img.enabled = false
    if self.email.baseInfo.send_uid ~= nil and tostring(self.email.baseInfo.send_uid) ~= "0" then
        if self.email.playerInfo == nil then
            MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(self.email.baseInfo.send_uid, function(playInfo)
                if nil == self.email then
                    return
                end

                self.email.playerInfo = playInfo
                self:ResetHead()
            end)
        else
            --发送好友头像
            if not self.head2d then
                self.head2d = self:NewTemplate("HeadWrapTemplate", {
                    TemplateParent = self.Parameter.PlayerIcon.transform,
                    TemplatePath = "UI/Prefabs/HeadWrapTemplate"
                })
            end

            ---@type HeadTemplateParam
            local param = {
                EquipData = self.email.playerInfo:GetEquipData()
            }
            self.head2d:SetData(param)
        end
    elseif self.email.npcData ~= nil then
        self.Parameter.PlayerIcon.Img.enabled = true
        ---@type NpcTable
        local npcTable = self.email.npcData
        --发送好友头像
        if not self.head2d then
            self.head2d = self:NewTemplate("HeadWrapTemplate", {
                TemplateParent = self.Parameter.PlayerIcon.transform,
                TemplatePath = "UI/Prefabs/HeadWrapTemplate"
            })
        end

        ---@type HeadTemplateParam
        local param = {
            NpcHeadID = npcTable.Id
        }

        self.head2d:SetData(param)
    end
end

function EmailItemTemplate:SetLightActive(b)
    if self.email == nil then
        return
    end
    self.Parameter.Light.gameObject:SetActiveEx(b)
end
--lua custom scripts end
return EmailItemTemplate