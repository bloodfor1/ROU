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
local l_guildMgr = nil
local l_guildWelfareMgr = nil
local l_guildData = nil
--next--
--lua fields end

--lua class define
GuildWelfareCellTemplate = class("GuildWelfareCellTemplate", super)
--lua class define end

--lua functions
function GuildWelfareCellTemplate:Init()

    super.Init(self)

end --func end
--next--
function GuildWelfareCellTemplate:OnDestroy()

    l_guildData = nil
    l_guildMgr = nil
    l_guildWelfareMgr = nil
    self.RedSignProcessorWelfare = nil
    self.RedSignStone = nil
    self.RedSignStone2 = nil
    self.RedSignCrystalOneLv = nil
    self.RedSignGuildBook = nil
    self.RedSignSale = nil
end --func end
--next--
function GuildWelfareCellTemplate:OnSetData(data)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    l_guildWelfareMgr = MgrMgr:GetMgr("GuildWelfareMgr")
    self:RefreshWelfareItem(data)

end --func end
--next--
function GuildWelfareCellTemplate:OnDeActive()


end --func end

--next--
--lua functions end

--lua custom scripts
function GuildWelfareCellTemplate:RefreshWelfareItem(contentData)

    if contentData.IsOpen == 1 then
        --已开放内容
        self.Parameter.WelfareItem_None.gameObject:SetActiveEx(false)
        self.Parameter.WelfareItemImage.gameObject:SetActiveEx(true)
        --底图
        self.Parameter.WelfareItemImage:SetSprite(contentData.PicAtlas, contentData.PicIcon)
        --标题
        self.Parameter.WelfareItemTitle.LabText = contentData.ContentName
        --描述
        self.Parameter.WelfareItemDesc.LabText = contentData.TextualDescription
        --详细说明
        self:SetTipsContent(contentData)
        --主按钮文字设置
        self:SetMainButtonText(contentData)
        --红点设置
        self:SetRedSign(contentData)
        --主功能按钮点击功能设置
        self:SetMainButtonClick(contentData)
    elseif contentData.IsOpen == 0 then
        --未开放内容
        self.Parameter.WelfareItem_None.gameObject:SetActiveEx(true)
        self.Parameter.WelfareItemImage.gameObject:SetActiveEx(false)
    end
end

--详细的提示说明设置
function GuildWelfareCellTemplate:SetTipsContent(contentData)
    --点击非主功能按钮的其他地方显示详细说明 如果有的话
    self.Parameter.BtnTip:AddClick(function()
        if not string.ro_isEmpty(contentData.TipsContent) then
            self:MethodCallback(contentData.ContentName, contentData.TipsContent)
        end
    end)
end

--主按钮文字设置
function GuildWelfareCellTemplate:SetMainButtonText(contentData)
    if contentData.ButtonTextType == l_guildData.EGuildContentBtnText.Goto then
        --前往
        self:ModifyMainButtonText(Common.Utils.Lang("GUILD_WELFARE_CELL_GOTO"))
    elseif contentData.ButtonTextType == l_guildData.EGuildContentBtnText.LookAt then
        --查看
        self:ModifyMainButtonText(Common.Utils.Lang("GUILD_WELFARE_CELL_VIEW"))
        --公会福利领取时特判
        if contentData.ContentID == l_guildData.EGuildContent.WeeklyWelfare
            and l_guildData.guildWelfareState == l_guildData.EWelfareStateType.CanGet then
            self:ModifyMainButtonText(Common.Utils.Lang("GUILD_WELFARE_CELL_GET"))
        end
    elseif contentData.ButtonTextType == l_guildData.EGuildContentBtnText.Grant then
        --会长显示发放 其他人显示查看
        if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
            self:ModifyMainButtonText(Common.Utils.Lang("GRANT"))
        else
            self:ModifyMainButtonText(Common.Utils.Lang("GUILD_WELFARE_CELL_VIEW"))
        end
    end
end

--红点设置
function GuildWelfareCellTemplate:SetRedSign(contentData)
    if contentData.ContentID == l_guildData.EGuildContent.WeeklyWelfare then
        if not self.RedSignProcessorWelfare then
            self.RedSignProcessorWelfare = self:NewRedSign({
                Key = eRedSignKey.GuildWelfare,
                ClickButton = self.Parameter.WelfareItemButton,
            })
        end
    elseif contentData.ContentID == l_guildData.EGuildContent.Crystal then           --公会华丽水晶1级红点
        if not self.RedSignCrystalOneLv then
            self.RedSignCrystalOneLv = self:NewRedSign({
                Key = eRedSignKey.GuildCrystalOneLv,
                ClickButton = self.Parameter.WelfareItemButton,
            })
        end
    elseif contentData.ContentID == l_guildData.EGuildContent.MemorialStone then          --公会原石雕琢红点
        if not self.RedSignStone then
            self.RedSignStone = self:NewRedSign({
                Key = eRedSignKey.GuildStoneButton,
                ClickButton = self.Parameter.WelfareItemButton,
            })
        end
        if not self.RedSignStone2 then
            self.RedSignStone2 = self:NewRedSign({
                Key = eRedSignKey.GuildStoneButton2,
                ClickButton = self.Parameter.WelfareItemButton,
            })
        end
    elseif contentData.ContentID == l_guildData.EGuildContent.Manual then          --公会组织手册
        if not self.RedSignGuildBook then
            self.RedSignGuildBook = self:NewRedSign({
                Key = eRedSignKey.GuildBook,
                ClickButton = self.Parameter.WelfareItemButton,
            })
        end
    elseif contentData.ContentID == l_guildData.EGuildContent.Depository then
        if not self.RedSignSale then
            self.RedSignSale = self:NewRedSign({
                Key = eRedSignKey.GuildSale,
                ClickButton = self.Parameter.WelfareItemButton,
            })
        end
    end
end


--设置主要按钮
function GuildWelfareCellTemplate:SetMainButtonClick(contentData)
    --按钮点击事件绑定
    self.Parameter.WelfareItemButton:AddClick(function()
        if contentData.ContentID == l_guildData.EGuildContent.SaleMechine then
            --公会贩卖机
            l_guildMgr.GuildFindPath_FuncId(l_guildData.EGuildFunction.GuildShop)

        elseif contentData.ContentID == l_guildData.EGuildContent.WeeklyWelfare then
            --公会分红
            if l_guildData.guildWelfareState == l_guildData.EWelfareStateType.CanGet then
                l_guildData.guildWelfareIsClick = true
            end
            l_guildData.guildWelfareClick = true
            l_guildWelfareMgr.ReqGetWelfare()

        elseif contentData.ContentID == l_guildData.EGuildContent.Dinner then
            --公会宴会
            local isInTime = false
            local nowTime = MServerTimeMgr.ServerTime.Hour * 100 + MServerTimeMgr.ServerTime.Minute
            local openTime = TableUtil.GetDailyActivitiesTable().GetRowById(11).TimePass
            for k = 0, openTime.Length - 1 do
                if (nowTime >= openTime[k][0]) and (nowTime < openTime[k][1]) then
                    isInTime = true
                    break
                end
            end
            if isInTime then
                if StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_U_BackToGuild) then
                    l_guildMgr.GuildFindPath_FuncId(l_guildData.EGuildFunction.GuildDinnerDescribe)
                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ACTIVITY_BOLI_NOT_OPEN"))
            end

        elseif contentData.ContentID == l_guildData.EGuildContent.Crystal then
            --华丽水晶
            --如果1级华丽水晶红点展示时点击则记录对应的公会ID
            if MgrMgr:GetMgr("GuildCrystalMgr").CheckOneLvRedSignMethod() == 1 then
                UserDataManager.SetDataFromLua(l_guildData.GUILD_CRYSTAL_ONE_LEVEL_RED, MPlayerSetting.PLAYER_SETTING_GROUP, tostring(l_guildData.selfGuildMsg.id))
            end
            --前往华丽水晶
            l_guildMgr.GuildFindPath_FuncId(l_guildData.EGuildFunction.GuildCrystal)

        elseif contentData.ContentID == l_guildData.EGuildContent.Gift then
            --公会礼盒
            --会长打开发放界面 其他人打开查看界面
            if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
                UIMgr:ActiveUI(UI.CtrlNames.GuildGiftBoxGrant)
            else
                l_guildWelfareMgr.ReqGuildGiftInfo(function()
                    CommonUI.Dialog.ShowOKDlg(true, nil, Lang("GUILD_GIFT_BOX_COUNT",
                            l_guildData.guildGiftInfo.have,
                            l_guildData.guildGiftInfo.max,
                            l_guildData.guildGiftInfo.weekGet,
                            l_guildData.guildGiftInfo.guildHunt))
                end)
            end

        elseif contentData.ContentID == l_guildData.EGuildContent.Hunt then
            --公会狩猎
            --打开公会狩猎信息界面
            UIMgr:ActiveUI(UI.CtrlNames.GuildHuntInfo)

        elseif contentData.ContentID == l_guildData.EGuildContent.Depository then
            --公会仓库
            MgrMgr:GetMgr("GuildDepositoryMgr").OpenGuildDepository()

        elseif contentData.ContentID == l_guildData.EGuildContent.Match then
            --公会匹配赛
            l_guildMgr.GuildFindPath_FuncId(l_guildData.EGuildFunction.GuildMatch)

        elseif contentData.ContentID == l_guildData.EGuildContent.MemorialStone then
            --公会原石雕琢
            local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
            if l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.GuildStoneOpenId) then
                local l_openData =
                {
                    type = l_guildData.EUIOpenType.GuildStone,
                    roleId = MPlayerInfo.UID
                }
                UIMgr:ActiveUI(UI.CtrlNames.GuildStone, l_openData)
            else
                l_openSysMgr = TableUtil.GetOpenSystemTable().GetRowById(l_openSysMgr.eSystemId.GuildStoneOpenId)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_LEVEL_HINT", l_openSysMgr.BaseLevel))
            end

        elseif contentData.ContentID == l_guildData.EGuildContent.Manual then
            --公会组织手册
            UIMgr:ActiveUI(UI.CtrlNames.GuildBook)

        elseif contentData.ContentID == GameEnum.EGuildContentID.RoyalMatch then
            --皇室竞赛
            MgrMgr:GetMgr("GuildRankMgr").TryUpdateInfo(true)

        elseif contentData.ContentID == l_guildData.EGuildContent.InvestigationTeam then
            --时空调查团
            UIMgr:ActiveUI(UI.CtrlNames.Spacetimemission)

        else
            logError("没有添加功能接口 ContentID => " .. contentData.ContentID)
        end
    end)
end

--设置主按钮文字
function GuildWelfareCellTemplate:ModifyMainButtonText(text)
    self.Parameter.WelfareItemButtonText.LabText = text
end
--lua custom scripts end
return GuildWelfareCellTemplate