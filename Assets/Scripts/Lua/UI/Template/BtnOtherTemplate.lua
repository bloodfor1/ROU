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
---@class BtnOtherTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtName MoonClient.MLuaUICom
---@field TxtJob MoonClient.MLuaUICom
---@field ScoreNum MoonClient.MLuaUICom
---@field MvpScoreNum MoonClient.MLuaUICom
---@field MVP MoonClient.MLuaUICom
---@field KillNum MoonClient.MLuaUICom
---@field HelpNum MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field DeadNum MoonClient.MLuaUICom
---@field BtnPlayer MoonClient.MLuaUICom
---@field BtnLike MoonClient.MLuaUICom
---@field BtnFriend MoonClient.MLuaUICom

---@class BtnOtherTemplate : BaseUITemplate
---@field Parameter BtnOtherTemplateParameter

BtnOtherTemplate = class("BtnOtherTemplate", super)
--lua class define end

--lua functions
function BtnOtherTemplate:Init()
    super.Init(self)
end --func end
--next--
function BtnOtherTemplate:OnDestroy()
    self.head2d = nil
    if self.co then
        ModuleMgr.CoroutineMgr:removeCo(self.co)
        self.co = nil
    end
end --func end
--next--
function BtnOtherTemplate:OnSetData(data)
    self.Parameter.Head.UObj:SetActiveEx(true)
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
			TemplateParent = self.Parameter.Head.transform,
			TemplatePath = "UI/Prefabs/HeadWrapTemplate"
		})
    end

	---@type HeadTemplateParam
	local param = {
		EquipData = data.attr.EquipData,
	}

	self.head2d:SetData(param)
    self.Parameter.TxtName.LabText = data.name or ""
    self.Parameter.TxtJob.LabText = data.jobName or ""
    self.Parameter.KillNum.LabText = data.kill or "0"
    self.Parameter.HelpNum.LabText = data.help or "0"
    self.Parameter.DeadNum.LabText = data.beKill or "0"
    self.Parameter.ScoreNum:SetActiveEx(not data.isMvp)
    self.Parameter.MVP:SetActiveEx(data.isMvp)
    if data.isMvp then
        self.Parameter.MvpScoreNum.LabText = data.score or "0"
    else
        self.Parameter.ScoreNum.LabText = data.score or "0"
    end
    self.Parameter.BtnLike:AddClick(function()
        if self.Parameter.BtnLike.Img.color == Color.New(0, 0, 0, 0.5) then
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Like_SuccessText"))
        self.Parameter.BtnLike.Img.color = Color.New(0, 0, 0, 0.5)
        MgrMgr:GetMgr("ThemeDungeonMgr").SendDungeonsEncourage(data.roleId)
    end)
    self.Parameter.BtnFriend:AddClick(function()
        if self.Parameter.BtnFriend.Img.color == Color.New(0, 0, 0) then
            return
        end
        self.Parameter.BtnFriend.Img.color = Color.New(0, 0, 0)
        MgrMgr:GetMgr("FriendMgr").RequestAddFriend(data.roleId)
    end)
    self.Parameter.BtnFriend.gameObject:SetActiveEx(tostring(data.roleId) ~= tostring(MPlayerInfo.UID) and
            not MgrMgr:GetMgr("FriendMgr").IsFriend(data.roleId))
    if self.co then
        ModuleMgr.CoroutineMgr:removeCo(self.co)
        self.co = nil
    end
    self.co = ModuleMgr.CoroutineMgr:addCo(function()
        AwaitTime((self.ShowIndex - 1) * 0.3)
        self.Parameter.BtnPlayer:PlayFx()
    end)

end --func end
--next--
function BtnOtherTemplate:OnDeActive()


end --func end
--next--
function BtnOtherTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return BtnOtherTemplate