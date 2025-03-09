--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PlayerMenuLPanel"
require "UI/Template/StickerWallTemplent"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
PlayerMenuLCtrl = class("PlayerMenuLCtrl", super)
--lua class define end
local l_attr = nil

--lua functions
function PlayerMenuLCtrl:ctor()

    super.ctor(self, CtrlNames.PlayerMenuL, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function PlayerMenuLCtrl:Init()
    ---@type PlayerMenuLPanel
    self.panel = UI.PlayerMenuLPanel.Bind(self)
    self.stickers = nil
    super.Init(self)

    self.panel.TargetIcon:SetActiveEx(false)
    ---@type ModuleMgr.OpenSystemMgr
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    --初始化邀请入会是否可见
    self:SetGuildInviteVisible(true)

    --按钮显隐初始化
    self.panel.FriendBtn:SetActiveEx(false)
    self.panel.QqSpeakBtn:SetActiveEx(false)
    self.panel.BadListBtn:SetActiveEx(false)
    self.panel.InfoBtn:SetActiveEx(false)
    self.panel.ButtonInviteTeam:SetActiveEx(false)
    self.panel.ButtonApplyTeam:SetActiveEx(false)
    self.panel.BtnGuildInvite:SetActiveEx(false)
    self.panel.BtnGuildApply:SetActiveEx(false)
    self.panel.BtAskVehicle:SetActiveEx(false)

end --func end
--next--
function PlayerMenuLCtrl:Uninit()

    if self.CreatEntity ~= nil then
        self:DestroyUIModel(self.CreatEntity);
        self.CreatEntity = nil
    end

    self.WaitTeamMsg = nil
    self.stickers = nil

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function PlayerMenuLCtrl:OnActive()
    self.panel.ButtonInviteTeamTxt.LabText = Common.Utils.Lang("INVATE_IN_TEAM")
    --如果点的是自己则好友按钮不显示
    if tostring(self.uid) == tostring(MPlayerInfo.UID) then
        self.panel.FriendBtn.gameObject:SetActiveEx(false)
    end

    self.panel.ButtonInviteTeam:AddClick(function()
        local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
        if self.uid and self.uid ~= -1 then
            if selfInTeam and not selfIsCaptain then
                --如果玩家有组队 但是不是队长 那么发出推荐组队
                MgrMgr:GetMgr("TeamMgr").RecommandMember(self.uid)
            else
                if self.curPlayerinfo ~= nil then
                    MgrMgr:GetMgr("TeamMgr").InviteJoinTeam(self.uid, self.curPlayerinfo.level)
                else
                    MgrMgr:GetMgr("TeamMgr").InviteJoinTeam(self.uid)
                end
            end
            UIMgr:DeActiveUI(CtrlNames.PlayerMenuL)
        end
    end)
    self.panel.ButtonApplyTeam:AddClick(function()
        if self.uid and self.uid ~= -1 then
            MgrMgr:GetMgr("TeamMgr").BegInTeam(self.uid)
            UIMgr:DeActiveUI(CtrlNames.PlayerMenuL)
        end
    end)

    self.panel.Btn_ForbidPlayer:AddClickWithLuaSelf(self.OnForbidPlayerClick,self,true)
    self.panel.Btn_CancelForbidPlayer:AddClickWithLuaSelf(self.OnCancelForbidPlayerClick,self,true)

    self.panel.Bg.gameObject:SetActiveEx(true)
    self.panel.Bg.Listener.onClick = function(obj, data)
        self.panel.Bg.gameObject:SetActiveEx(false)
        UIMgr:DeActiveUI(CtrlNames.PlayerMenuL)
        MLuaClientHelper.ExecuteClickEvents(data.position, CtrlNames.PlayerMenuL)
    end
    if self.uiPanelData ~= nil then
        if self.uiPanelData.openType == DataMgr:GetData("TeamData").ETeamOpenType.RefreshHeadIconByUid then
            self:RefreshHeadIconByUid(self.uiPanelData.Uid)
        elseif self.uiPanelData.openType == DataMgr:GetData("GuildData").EUIOpenType.GuildRefreshPlayerMenuL then
            self:GuildRefreshPlayerMenuL(self.uiPanelData.MemberData)
        end
        if self.uiPanelData.relativeScreenPos ~=nil then
            local l_screenPos = self.uiPanelData.relativeScreenPos
            local _, l_relativePos = RectTransformUtility.ScreenPointToLocalPointInRectangle(
                    self.panel.Offset.RectTransform,l_screenPos , MUIManager.UICamera, nil)
            --是否仅需改动Y轴坐标
            if self.uiPanelData.onlyChangePosY then
                l_relativePos.y = self.panel.Panel.RectTransform.anchoredPosition.y
            end
            self.panel.Panel.RectTransform.anchoredPosition = l_relativePos
        end
    end
    
    -- 双人动作
    if MgrMgr:GetMgr("MultipleActionMgr").CheckEntityInView(self.uid) then
        self:AddButton(Lang("MULTIPLE_ACTION"), function()
            if not self.curPlayerinfo then
                return
            end

            if MgrMgr:GetMgr("MultipleActionMgr").CheckEntityInView(self.curPlayerinfo.uid) then
                MgrMgr:GetMgr("MultipleActionMgr").OpenActionHandler(self.curPlayerinfo.uid, self.curPlayerinfo.level)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTIPLE_ACTION_VIEW"))
            end
            UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)
        end, nil)
    end
    self:refreshPlayerForbidState()
    self:refreshButtonsPos()
end --func end
--next--
function PlayerMenuLCtrl:OnDeActive()
    self.uid = nil
    self.curPlayerinfo = nil
    self:ClearStickers()
end --func end
--next--
function PlayerMenuLCtrl:Update()


end --func end

--next--
function PlayerMenuLCtrl:BindEvents()
    --确认目标组队信息和好友信息的事件绑定
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_GET_PLAYER_TEAM_FRIEND_INFO, function(self, teamFriendInfo)
        self:RefreshPlayerMenuTeam(teamFriendInfo)
    end)
    self:BindEvent(self.openMgr.EventDispatcher,self.openMgr.OpenSystemUpdate, self.refreshPlayerForbidState,self)

    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    self:BindEvent(l_chatMgr.EventDispatcher,l_chatDataMgr.EEventType.UpdateForbidPlayerInfo,self.refreshPlayerForbidState,self)
    self:BindEvent(l_chatMgr.EventDispatcher,l_chatDataMgr.EEventType.GetForbidPlayerInfoList,self.refreshPlayerForbidState,self)
end --func end
--next--
--lua functions end

--lua custom scripts
function PlayerMenuLCtrl:OnForbidPlayerClick()
    if self.curPlayerinfo == nil then
        return
    end
    MgrMgr:GetMgr("ChatMgr").ReqChangeChatForbid(self.uid,true,self.curPlayerinfo.name)
    self:Close()
end
function PlayerMenuLCtrl:OnCancelForbidPlayerClick()
    if self.curPlayerinfo == nil then
        return
    end
    MgrMgr:GetMgr("ChatMgr").ReqChangeChatForbid(self.uid,false,self.curPlayerinfo.name)
end
function PlayerMenuLCtrl:refreshPlayerForbidState()
    local l_isChatForbidSysOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatForbid)
    local l_isForbid = DataMgr:GetData("ChatData").IsForbidPlayer(MLuaCommonHelper.ULong(self.uid))
    self.panel.Btn_CancelForbidPlayer:SetActiveEx(l_isForbid and l_isChatForbidSysOpen)
    self.panel.Btn_ForbidPlayer:SetActiveEx(not l_isForbid and l_isChatForbidSysOpen and tostring(self.uid) ~= tostring(MPlayerInfo.UID))
end
function PlayerMenuLCtrl:refreshButtonsPos()
    --屏蔽按钮始终放在最好
    self.panel.Btn_CancelForbidPlayer.Transform:SetAsLastSibling()
    self.panel.Btn_ForbidPlayer.Transform:SetAsLastSibling()
end
--接收组队信息，依据玩家自身有无队伍 是否是队长 刷新界面按钮显示
function PlayerMenuLCtrl:RefreshPlayerMenuTeam(data)
    if not self.WaitTeamMsg then
        return
    end
    self.WaitTeamMsg = nil

    -- 称号
    self:RefreshTitle(data.title_id)

    -- 贴纸
    self:RefreshSticker(data.sticker)

    --如果点的是自己则好友按钮和组队按钮均不显示
    if tostring(self.uid) == tostring(MPlayerInfo.UID) then
        self.panel.ButtonInviteTeam.gameObject:SetActiveEx(false)
        self.panel.ButtonApplyTeam.gameObject:SetActiveEx(false)
        self.panel.FriendBtn.gameObject:SetActiveEx(false)
        return
    end

    local requestUserIsCaptain = data.is_captain    --请求玩家是否是队长
    local requestUserInTeam = data.is_in_team   --请求玩家是否有队伍
    local l_isFriend = data.is_friend

    local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()

    --目标组队人数
    local l_teamNum = data.member_count or 0
    if l_teamNum <= 0 then
        self.panel.TeamText.LabText = Lang("TEAM_MENU_NIL")
    else
        self.panel.TeamText.LabText = Lang("TEAM_MENU_NUM", l_teamNum, 5)
    end

    --先判断自己有无组队
    if selfInTeam then
        self.panel.ButtonApplyTeam.gameObject:SetActiveEx(false)
        if selfIsCaptain then
            --设置邀请按钮    邀请玩家入队
            self.panel.ButtonInviteTeam.gameObject:SetActiveEx(true)
            self.panel.ButtonInviteTeamTxt.LabText = Common.Utils.Lang("INVATE_IN_TEAM")
        else
            --设置邀请按钮提示 自己不是队长 没有邀请权限
            self.panel.ButtonInviteTeam.gameObject:SetActiveEx(true)
            self.panel.ButtonInviteTeamTxt.LabText = Common.Utils.Lang("RECOMMEND_IN_TEAM")
        end
        --如果自己没有组队在判断路人的情况
    else
        if requestUserInTeam then
            self.panel.ButtonInviteTeam.gameObject:SetActiveEx(false)
            self.panel.ButtonApplyTeam.gameObject:SetActiveEx(true)
            if requestUserIsCaptain then
                --设置申请入队 发出申请入队请求
            else
                --对方不是队长
            end
        else
            --双方都没有队伍 邀请组队
            self.panel.ButtonInviteTeam.gameObject:SetActiveEx(true)
            self.panel.ButtonApplyTeam.gameObject:SetActiveEx(false)
        end
    end

    if l_isFriend then
        local text = MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.FriendBtn.gameObject.transform:Find("Text"))
        text.LabText = Common.Utils.Lang("Friend_DeleteFriend")
        self.panel.FriendBtn.gameObject:SetActiveEx(true)
        self.panel.FriendBtn:AddClick(function()
            local l_playerInfo = self.curPlayerinfo
            if not l_playerInfo then
                logError("不存在角色信息")
                return
            end
            UIMgr:ActiveUI(UI.CtrlNames.Dialog04, function(ctrl)
                ctrl:ShowPlayer(l_playerInfo)
            end)
            UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)
        end)
    else
        local text = MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.FriendBtn.gameObject.transform:Find("Text"))
        text.LabText = Common.Utils.Lang("Friend_AddFriend")
        self.panel.FriendBtn.gameObject:SetActiveEx(true)
        self.panel.FriendBtn:AddClick(function()
            MgrMgr:GetMgr("FriendMgr").RequestAddFriend(self.uid)
            UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)
        end)
    end

    --赠送礼物按钮
    self:AddButton(Common.Utils.Lang("GIFT_FRIEND"), function()
        if not self.curPlayerinfo then
            logError("不存在角色信息")
            return
        end
        MgrMgr:GetMgr("GiftMgr").TouchPlayer(self.curPlayerinfo.uid)
        UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)
    end, nil)

    --临时联系人
    self:AddButton(Lang("PlayerMenuL_SendMsg"), function()
        --发送消息
        local l_playerInfo = self.curPlayerinfo
        if l_playerInfo ~= nil then
            MgrMgr:GetMgr("FriendMgr").AddTemporaryContacts(l_playerInfo.data)
            UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)

            MgrMgr:GetMgr("FriendMgr").OpenFriendAndSetUID(l_playerInfo.uid)
        end
    end, nil)
end

--接收角色信息
function PlayerMenuLCtrl:SetInfoById(playinfo)
    ---@type playerInfo
    self.curPlayerinfo = playinfo

    local l_attr = playinfo:GetAttribData()
    if MLuaCommonHelper.IsNull(l_attr) then
        self:Close()
        logError("PlayerMenuLCtrl:SetInfoById 获得的属性数据为null!需要关闭！")
        return
    end

    local l_fxData = {}
    l_fxData.rawImage = self.panel.TargetIcon.RawImg
    l_fxData.attr = l_attr
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)
    l_fxData.position = Vector3.New(0, -1.51, -0.17)
    l_fxData.scale = Vector3.New(1.9, 1.9, 1.9)
    l_fxData.rotation = Quaternion.Euler(-10.295, 180, 0)

    if self.CreatEntity ~= nil then
        self:DestroyUIModel(self.CreatEntity);
        self.CreatEntity = nil
    end
    self.CreatEntity = self:CreateUIModel(l_fxData)
    

    --半身像处理
    self.CreatEntity:AddLoadModelCallback(function(m)
        self.panel.TargetIcon:SetActiveEx(true)
    end)
    self.panel.TextName.LabText = playinfo.name
    self.panel.Guild.LabText = StringEx.Format(Lang("PLAYER_DETAIL_GUILD"), playinfo.guildName)
    self.panel.LvText.LabText = "Lv." .. tostring(playinfo.level)
    self.panel.LvClass.LabText = DataMgr:GetData("TeamData").GetProfessionNameById(playinfo.type)
    local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(playinfo.type)
    if imageName then
        self.panel.Job:SetSpriteAsync("Common", imageName)
    end

    --公会等级限制获取
    local l_guildLvLimit = TableUtil.GetOpenSystemTable().GetRowById(111).BaseLevel
    --公会邀请可见 且 自己达到公会等级需求 且 选中目标不是自己时 判断公会按钮
    if self.guildInviteVisible and MPlayerInfo.Lv >= l_guildLvLimit and tostring(MPlayerInfo.UID) ~= tostring(playinfo.uid) then
        if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() or playinfo.guildId == 0 then
            --自己有公会 或者 对方和自己都无公会 显示邀请入会
            self.panel.BtnGuildInvite.UObj:SetActiveEx(true)
            self.panel.BtnGuildInvite:AddClick(function()
                UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)
                --判断自己是否有公会 无则提示创建工会
                if not MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_ENTER_A_GUILD"))
                    return
                end
                --判断对方等级是否足够
                if playinfo.level < l_guildLvLimit then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("OTHER_LEVEL_NOT_ENOUGH"))
                    return
                end
                --判断对方是否有公会
                if playinfo.guildId ~= 0 then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("OTHER_ALREADY_IN_GUILD"))
                    return
                end
                --请求邀请对方
                MgrMgr:GetMgr("GuildMgr").ReqInviteJoin(playinfo.uid)
            end)
        else
            --自己无公会 对方有公会 显示 申请公会
            self.panel.BtnGuildApply.UObj:SetActiveEx(true)
            self.panel.BtnGuildApply:AddClick(function()
                UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)
                --判断自己是否有公会 有则提示已有公会
                if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_IN_GUILD"))
                    return
                end
                --请求加入对方公会
                MgrMgr:GetMgr("GuildMgr").ReqApply(playinfo.guildId)
            end)
        end
    end
    self:SetVehicleButton(playinfo)
end

function PlayerMenuLCtrl:SetVehicleButton(targetInfo)
    -- 设置载具按钮
    if self.uid ~= nil and self.uid ~= -1 then
        local player = MEntityMgr.PlayerEntity
        local target = MEntityMgr:GetEntity(self.uid)
        if target == nil then
            self.panel.BtAskVehicle.gameObject:SetActiveEx(false)
            self.panel.BtAskVehicle:AddClick(nil)
        else
            local l_tmpTargetId = self.uid
            local playerVehicle = player.VehicleCtrlComp
            local targetVehicle = target.VehicleCtrlComp
            -- player是司机，且还有座位
            if player.IsRideAnyVehicle and not player.IsPassenger and playerVehicle and playerVehicle.SeatNumLeft > 0 then
                self.panel.BtAskVehicle.gameObject:SetActiveEx(true)
                self.panel.TxAskVehicle.LabText = Common.Utils.Lang("VEHICLE_BUTTON_INVITE")
                self.panel.BtAskVehicle:AddClick(function()
                    if target.IsRideAnyVehicle then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("VEHICLE_TARGET_ALREADY_RIDE"))
                    else
                        if targetInfo.level < MgrMgr:GetMgr("OpenSystemMgr").GetSystemOpenBaseLv(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.VehicleAbility) then
                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Vehicle_LevelNotEnougth"))
                        else
                            MgrMgr:GetMgr("VehicleMgr").RequestAskTakeVehicle(tostring(player.UID), tostring(l_tmpTargetId),target.Name)
                        end
                    end
                    UIMgr:DeActiveUI(CtrlNames.PlayerMenuL)
                end)
                -- target是司机，且还有座位
            elseif target.IsRideAnyVehicle and not target.IsPassenger and targetVehicle and targetVehicle.SeatNumLeft > 0 then
                self.panel.BtAskVehicle.gameObject:SetActiveEx(true)
                self.panel.TxAskVehicle.LabText = Common.Utils.Lang("VEHICLE_BUTTON_ASK")
                self.panel.BtAskVehicle:AddClick(function()
                    if player.IsRideAnyVehicle then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("VEHICLE_SELF_ALREADY_RIDE"))
                    else
                        if MPlayerInfo.Lv < MgrMgr:GetMgr("OpenSystemMgr").GetSystemOpenBaseLv(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.VehicleAbility) then
                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Vehicle_LevelNotEnougth_Self"))
                        else
                            MgrMgr:GetMgr("VehicleMgr").RequestAskTakeVehicle(tostring(l_tmpTargetId), tostring(player.UID),target.Name)
                        end
                    end
                    UIMgr:DeActiveUI(CtrlNames.PlayerMenuL)
                end)
            else
                self.panel.BtAskVehicle.gameObject:SetActiveEx(false)
            end
        end
    end
end

function PlayerMenuLCtrl:SetSelfPos(pos)
    if pos then
        self.panel.Offset.RectTransform.anchoredPosition = pos
    end
end

function PlayerMenuLCtrl:OnReconnected()
    super.OnReconnected(self)
    if self.uid then
        self:RefreshHeadIconByUid(self.uid, self.curPlayerinfo)
    end
end

--入口
function PlayerMenuLCtrl:RefreshHeadIconByUid(uid, oldPlayerInfo)
    self.uid = tostring(uid)
    
    self.panel.TargetIcon:SetActiveEx(false)
    self.curPlayerinfo = oldPlayerInfo
    local l_empty = ""
    if oldPlayerInfo ~= nil then
        self:SetInfoById(oldPlayerInfo)
    else
        self.panel.TextName.LabText = l_empty
        self.panel.LvText.LabText = l_empty
        self.panel.LvClass.LabText = l_empty
    end
    self.panel.TeamText.LabText = ""

    if self.uid then
        --发送获取组队信息
        self.WaitTeamMsg = true
        MgrMgr:GetMgr("TeamMgr").GetUserInTeamOrNot(self.uid)

        --发送获取角色名字/外观等
        if self.curPlayerinfo == nil then
            MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(self.uid, function(obj)
                if self.panel == nil then
                    return
                end
                self:SetInfoById(obj)
            end)
        end
    end

end

--新按钮添加
--name 按钮的名字
--method 点击事件
--siblingIndex 按钮的顺序
function PlayerMenuLCtrl:AddButton(name, method, siblingIndex)

    local gameObject = self:CloneObj(self.panel.BtnPrefab.gameObject, false)
    gameObject:SetActiveEx(true)

    local transform = gameObject.transform

    transform:SetParent(self.panel.Panel.transform, false)
    if siblingIndex ~= nil then
        transform:SetSiblingIndex(siblingIndex)
    end

    local text = MLuaClientHelper.GetOrCreateMLuaUICom(transform:Find("BtnPrefabText"))
    text.LabText = name

    local button = gameObject:GetComponent("MLuaUICom")
    button:AddClick(method)
    self:refreshButtonsPos()
end

function PlayerMenuLCtrl:ClearStickers()
    if self.stickers then
        for i, v in ipairs(self.stickers) do
            MResLoader:DestroyObj(v)
        end
        self.stickers = nil
    end
end

function PlayerMenuLCtrl:RefreshTitle(titleId)
    if titleId ~= 0 then
        local l_titleRow = TableUtil.GetTitleTable().GetRowByTitleID(titleId)
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(titleId)
        if l_titleRow then
            self.panel.TitleName.LabText = StringEx.Format("[{0}]", l_titleRow.TitleName)
        end
        if l_itemRow then
            self.panel.TitleName.LabColor = MgrMgr:GetMgr("TitleStickerMgr").GetQualityColor(l_itemRow.ItemQuality)
        end
    else
        self.panel.TitleName.LabText = Lang("TITLE_EMPTY")
        self.panel.TitleName.LabColor = MgrMgr:GetMgr("TitleStickerMgr").GetQualityColor(0)
    end
end


function PlayerMenuLCtrl:RefreshSticker(stickerInfo)
    self.stickersTemplate = self:NewTemplate("StickerWallTemplent",{
        TemplateParent = self.panel.Sticker.transform,
    })

    local l_gridInfos  = MgrMgr:GetMgr("TitleStickerMgr").ParseStickersPB(stickerInfo)
    self.stickersTemplate:SetData({bgType = "none", gridInfos = l_gridInfos})
end

function PlayerMenuLCtrl:GuildRefreshPlayerMenuL(memberData)
    self:SetGuildInviteVisible(false)
    self:RefreshHeadIconByUid(MLuaCommonHelper.Long(memberData.baseInfo.roleId))
    --GuildChangePosition界面开启的数据包
    local l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    local l_guildData = DataMgr:GetData("GuildData")

    local l_openData = {
        type = l_guildData.EUIOpenType.GuildChangePosition,
        memberData = memberData
    }
    --自身职位获取
    local l_selfGuildPostion = l_guildData.GetSelfGuildPosition()
    --根据职位区分显示按钮
    if l_selfGuildPostion == l_guildData.EPositionType.Chairmen then
        --会长对自己无操作 对于其他人均可操作
        if memberData.position > l_guildData.EPositionType.Chairmen then
            --职位更改按钮
            self:AddButton(Lang("GUILD_SET_POSITION"), function()
                UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL, l_openData)
                UIMgr:ActiveUI(UI.CtrlNames.GuildChangePosition, l_openData)
            end, 1)
        end
        --会长对执事和成员显示该按钮
        if memberData.position > l_guildData.EPositionType.Director and
            memberData.position ~= l_guildData.EPositionType.Beauty then
            --踢出按钮
            self:AddButton(Lang("GUILD_KICKOUT_TEXT"), function()
                l_guildMgr.KickoutMember(memberData)
            end, 2)
        end
    elseif (l_selfGuildPostion == l_guildData.EPositionType.ViceChairman and memberData.position > l_guildData.EPositionType.Director) or
            (l_selfGuildPostion == l_guildData.EPositionType.Director and memberData.position > l_guildData.EPositionType.Deacon) then
        --副会长 可以对理事以下的人员显示职位操作 对执事和成员显示踢出
        --理事 可以对成员显示操作 和 踢出
        --职位更改按钮
        self:AddButton(Lang("GUILD_SET_POSITION"), function()
            UIMgr:ActiveUI(UI.CtrlNames.GuildChangePosition, l_openData)
        end, 1)
        --踢出按钮，公会魅力担当不显示此按钮
        if memberData.position ~= l_guildData.EPositionType.Beauty then
            self:AddButton(Lang("GUILD_KICKOUT_TEXT"), function()
                l_guildMgr.KickoutMember(memberData)
            end, 2)
        end
    end
end
--设置公会邀请按钮是否可见
function PlayerMenuLCtrl:SetGuildInviteVisible(isVisible)
    self.guildInviteVisible = isVisible
end
--lua custom scripts end
return PlayerMenuLCtrl