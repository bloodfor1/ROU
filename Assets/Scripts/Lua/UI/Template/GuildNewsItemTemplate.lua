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
local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
local l_chatDataMgr=DataMgr:GetData("ChatData")
--lua fields end

--lua class define
---@class GuildNewsItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field NewsText MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom

---@class GuildNewsItemTemplate : BaseUITemplate
---@field Parameter GuildNewsItemTemplateParameter

GuildNewsItemTemplate = class("GuildNewsItemTemplate", super)
--lua class define end

--lua functions
function GuildNewsItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuildNewsItemTemplate:OnDeActive()
    self:ReleaseData()
end --func end
--next--
function GuildNewsItemTemplate:OnSetData(data)
    if self.tweenAnim then
        self.tweenAnim:DOKill()
        self.tweenAnim = nil
    end
    self.data = data
    self:SetTextHref()
    self.Parameter.NewsText.LabText = data.content
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.NewsText.RectTransform)
    local sizeX = self.Parameter.NewsText.RectTransform.sizeDelta.x
    self.Parameter.NewsText.gameObject:SetRectTransformPos(sizeX/2,0) -- 0,0
    self.Parameter.NewsText.LabRayCastTarget = true
    local l_iconAtlas = data.belongTypeData.belongTypeAtlas  --TableUtil.GetGuildSettingTable().GetRowBySetting("GuildNewsTypeAtlasName").Value
    local l_iconIcons = data.belongTypeData.belongTypeSprite -- string.ro_split(TableUtil.GetGuildSettingTable().GetRowBySetting("GuildNewsTypeIconName").Value, "|")
    self.Parameter.IconImg:SetSprite(l_iconAtlas,l_iconIcons)
    --点赞

    --是否是自己判定--
    local a,b = string.find(data.content,MPlayerInfo.Name)
    local l_isSelf = false
    if a and b then
        l_isSelf = true
    end
    self.Parameter.Btn_Good:SetActiveEx(data.tableData.IsGood == 1 and (not l_isSelf))
    self:SetGoodText()
    self.Parameter.Btn_Good:AddClick(function()
        if MgrMgr:GetMgr("GuildMgr").GuildNewsGetLakeState(data.content) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_LAKED"))
            return
        end
        local l_txtTitle = Lang(data.tableData.CongratulationTitle)
        local l_content = data.content
        local l_default = Lang(data.tableData.CongratulationTalk)
        local l_additionData = {announceData = data.announceData}
        MgrMgr:GetMgr("TipsMgr").ShowLikesDialog(l_txtTitle,l_content,l_default,l_additionData,function (data)
            if MgrMgr:GetMgr("GuildMgr").SendGuildNewsMsg(data) then
                if UIMgr:IsActiveUI(UI.CtrlNames.Guild) then 
                    self:SetGoodText()
                end
            end
        end)
    end)
    self:ReleaseData()
    self.tweenAnim,self.tweenTimer = Common.CommonUIFunc.SetItemTemAnimation(self.Parameter.NewsText,self.Parameter.Empty,false,true,3)
    self:SaveTimerData(self.tweenTimer)
end --func end
--next--
function GuildNewsItemTemplate:BindEvents()
	
	
end --func end
--next--
function GuildNewsItemTemplate:OnDestroy()
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildNewsItemTemplate:SetGoodText()
    self.Parameter.Btn_GoodTxt.LabText = MgrMgr:GetMgr("GuildMgr").GuildNewsGetLakeState(self.data.content) and Lang("NORMAL_ALREADY_LAKE") or Lang("NORMAL_LAKE")
end

function GuildNewsItemTemplate:SetTextHref()
    --先清理再绑定
    self.Parameter.NewsText:GetRichText().onHrefClick:RemoveAllListeners()
    self.Parameter.NewsText:GetRichText().onHrefClick:AddListener(function(key)
		MgrMgr:GetMgr("LinkInputMgr").ClickHrefInfo(key,nil,self.data.extraLinkData)
    end)
    --[[
    self.Parameter.NewsText:GetRichText().onHrefClick:AddListener(function(hrefName)
        if hrefName == "ShowPlayerDetail" then
            Common.CommonUIFunc.RefreshPlayerMenuLByUid(MLuaCommonHelper.Long(self.data.playerId))
        elseif hrefName == "ShowAchievementDetail" then

            UIMgr:ActiveUI(UI.CtrlNames.AchievementDetails,function(ctrl)
                ctrl:ShowDetails(self.data.achievementId, self.data.rid, self.data.time, false)
            end)

        elseif hrefName == "ShowEquipDetail" then

            local l_uid = self.data.uid
            local l_rid = self.data.rid
            MgrMgr:GetMgr("ItemMgr").GetItemByUniqueId(l_uid, function(itemInfo, error)
                if itemInfo ~= nil then
                    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(itemInfo,nil,nil,nil,nil,nil)
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LinkInput_Miss")) --道具已经不存在
                end
            end)

        end
    end)
    ]]--
end

function GuildNewsItemTemplate:ReleaseData()
    if self.tweenAnim then
        self.tweenAnim:DOPause()
        self.tweenAnim:DOKill()
        self.tweenAnim = nil
    end
    if self.tweenTimer then
        self:StopUITimer(self.tweenTimer)
        self.tweenTimer = nil
    end
end

--lua custom scripts end
return GuildNewsItemTemplate