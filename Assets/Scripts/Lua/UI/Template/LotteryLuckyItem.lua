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
---@class LotteryLuckyItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RawImg_Finish MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field LuckyNum MoonClient.MLuaUICom
---@field IsGetTitle MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom

---@class LotteryLuckyItem : BaseUITemplate
---@field Parameter LotteryLuckyItemParameter

LotteryLuckyItem = class("LotteryLuckyItem", super)
--lua class define end

--lua functions
function LotteryLuckyItem:Init()
    super.Init(self)
    self._playerHead = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadDummy.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function LotteryLuckyItem:OnDestroy()
    self._playerHead = nil
end --func end
--next--
function LotteryLuckyItem:OnDeActive()
    self:DestoryPointFinishEffect()
    self:ShowWinTitle(false)
end --func end
--next--
function LotteryLuckyItem:OnSetData(data)
    -- do nothing
end --func end
--next--
function LotteryLuckyItem:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
LotteryLuckyItem.TemplatePath = "UI/Prefabs/LotteryLuckyItem"

function LotteryLuckyItem:SetItemByData(data)
    self:ShowWinTitle(false)
    self.Parameter.LuckyNum.LabText = "No." .. data.lucky_no
    self.Parameter.PlayerName.LabText = data.member.name
    local onClick = function()
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(MLuaCommonHelper.Long(data.member.role_uid))
    end

    local l_equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.member)
    ---@type HeadTemplateParam
    param = {
        EquipData = l_equipData,
        OnClick = onClick
    }
    self._playerHead:SetData(param)
end

function LotteryLuckyItem:ShowWinTitle(state)
    self.Parameter.IsGetTitle.gameObject:SetActiveEx(state)
end

--创建指针Finish特效
function LotteryLuckyItem:CreateFinishEffect(...)
    self:DestoryPointFinishEffect()
    self.rewardEffectFinish = self.rewardEffectFinish or nil

    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.RawImg_Finish.RawImg
    l_fxData.destroyHandler = function()
        self.rewardEffectFinish = 0
    end
    l_fxData.loadedCallback = function(go)
        go.transform:SetLocalScale(3, 3, 3)
    end
    self.rewardEffectFinish = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ZhuTiPaiDui_XuanZhongXiaoGuo_01", l_fxData)

end

function LotteryLuckyItem:DestoryPointFinishEffect(...)
    if self.rewardEffectFinish == nil then
        return
    end
    if self.rewardEffectFinish ~= 0 then
        self:DestroyUIEffect(self.rewardEffectFinish)
        self.rewardEffectFinish = 0
    end
end
--lua custom scripts end
return LotteryLuckyItem