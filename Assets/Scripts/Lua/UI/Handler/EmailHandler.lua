--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/EmailPanel"

require "UI/Template/ItemTemplate"
require "UI/Template/EmailItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
EmailHandler = class("EmailHandler", super)
--lua class define end

--lua functions
local Mgr = MgrMgr:GetMgr("EmailMgr")
function EmailHandler:ctor()
    super.ctor(self, HandlerNames.Email, 0)
end --func end
--next--
function EmailHandler:Init()
    self.panel = UI.EmailPanel.Bind(self)
    super.Init(self)
    self.CurEmail = nil
    -- "暂时没有一封邮件"
    self.panel.EMailBg.gameObject:SetActiveEx(false)
    self.panel.Email_Emty.gameObject:SetActiveEx(false)
    --一键领取一键删除
    self.panel.DelAllBtn.gameObject:SetActiveEx(false)
    self.panel.GetAllBtn.gameObject:SetActiveEx(false)
    --右侧 “请从左侧选择一封邮件”
    self.panel.Email_TextEmpty.gameObject:SetActiveEx(false)
    --显示右侧详细信息
    self.panel.DatailObj.gameObject:SetActiveEx(false)

    --道具对象池
    self.ItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.GetItemGroup.transform
    })

    --邮件左侧按钮对象池
    self.EmailPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.EmailItemTemplate,
        TemplatePrefab = self.panel.EmailItemPrefab.gameObject,
        ScrollRect = self.panel.EmailItemScroll.LoopScroll,
        Method = function(email, emailTemp)
            self:OnClickEmail(email, emailTemp)
        end
    })

    --按钮事件
    self.panel.DelAllBtn:AddClickWithLuaSelf(self.OnBtnDelAll,self)
    self.panel.GetAllBtn:AddClickWithLuaSelf(self.OnBtnGetAll,self)
    self.panel.DelBtn:AddClickWithLuaSelf(self.OnBtnDel,self)
    self.panel.GetBtn:AddClickWithLuaSelf(self.OnBtnGet,self)

    local l_emailContentRichTxtCom = self.panel.Email_Content:GetRichText()
    l_emailContentRichTxtCom.onHrefClick:RemoveAllListeners()
    l_emailContentRichTxtCom.onHrefClick:AddListener(MgrMgr:GetMgr("LinkInputMgr").ClickHrefInfo)
    --MgrMgr:GetMgr("WeakGuideMgr").ShowRedSign(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.Email,false)

    MgrMgr:GetMgr("RedSignMgr").DirectUpdateRedSign(eRedSignKey.Email, 0)
    self.panel.Email_Content.transform.pivot = Vector2.New(0.5, 0.5)
end --func end
--next--
function EmailHandler:Uninit()
    self.ItemPool = nil
    self.EmailPool = nil

    self.head2d = nil

    Mgr.ClearData()

    Mgr.CurrentSelectIndex = -1
    self.CurEmail = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function EmailHandler:OnActive()
    --请求第一批数据
    Mgr.RequestGetMailList()

end --func end
--next--
function EmailHandler:OnDeActive()

end --func end
--next--
function EmailHandler:Update()


end --func end


--next--
function EmailHandler:BindEvents()

    --dont override this function
    --事件处理-初始化
    self:BindEvent(Mgr.EventDispatcher, Mgr.EventType.Init, function(self)
        self:OnClickEmail(nil)
        self.EmailPool:ShowTemplates({ Datas = Mgr.Datas })

        if #Mgr.Datas > 0 then
            self:OnClickEmail(Mgr.Datas[1])
        else
            self:OnClickEmail(nil)
        end
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.EventType.Remove, function(self, index)
        self.panel.EmailItemScroll.LoopScroll:DeleteCellWithDataIndex(index - 1)

        if index <= #Mgr.Datas then
            self:OnClickEmail(Mgr.Datas[index])
        elseif #Mgr.Datas > 0 then
            self:OnClickEmail(Mgr.Datas[#Mgr.Datas])
        else
            self:OnClickEmail(nil)
        end
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.EventType.Reset, function(self, data)
        local l_emailTem = self.EmailPool:FindShowTem(function(a)
            return a.email == data
        end)
        if l_emailTem ~= nil then
            l_emailTem:SetData(data)
        end

        if self.CurEmail == data then
            self:OnClickEmail(nil)
            self:OnClickEmail(data)
        end
    end)
end --func end

--next--
--lua functions end

--lua custom scripts
--点击左侧简要邮件
function EmailHandler:OnClickEmail(email, emailTemp)
    --local self = UIMgr:GetUI(CtrlNames.Community)
    --self = self:GetHandlerByName(HandlerNames.Email)

    if self.CurEmail ~= nil and self.CurEmail == email then
        return
    end

    --熄灭上一个
    if self.CurEmail ~= nil then
        local l_emailTem = self.EmailPool:FindShowTem(function(a)
            return a.email == self.CurEmail
        end)
        if l_emailTem ~= nil then
            l_emailTem:SetLightActive(false)
        end
    end

    self.CurEmail = email
    if self.CurEmail == nil then
        Mgr.CurrentSelectIndex = -1
        self:ResetShow()
        return
    end

    if emailTemp == nil then
        emailTemp = self.EmailPool:FindShowTem(function(a)
            return a.email == self.CurEmail
        end)
    end

    if emailTemp ~= nil then
        emailTemp:SetLightActive(true)
        Mgr.CurrentSelectIndex = emailTemp.ShowIndex
    else
        for i = 1, #Mgr.Datas do
            if Mgr.Datas[i] == self.CurEmail then
                Mgr.CurrentSelectIndex = i
                break
            end
        end
    end
    self:ResetShow()

    --请求详细信息
    if self.CurEmail.detail == nil then
        Mgr.RequestGetOneMail(self.CurEmail)
    end

    --请求已读
    if not self.CurEmail.baseInfo.is_read and not self.CurEmail.baseInfo.is_has_item then
        Mgr.RequestMailOp(self.CurEmail, MailOpType.Mail_Read)
    end
end

--刷新邮件显示
function EmailHandler:ResetShow()
    local EmailList = Mgr.Datas
    local CurEmail = self.CurEmail

    -- "暂时没有一封邮件"
    self.panel.EMailBg.gameObject:SetActiveEx(#EmailList > 0)
    self.panel.Email_Emty.gameObject:SetActiveEx(#EmailList <= 0)
    --一键领取一键删除
    self.panel.DelAllBtn.gameObject:SetActiveEx(#EmailList > 0)
    self.panel.GetAllBtn.gameObject:SetActiveEx(#EmailList > 0)
    --右侧 “请从左侧选择一封邮件”
    self.panel.Email_TextEmpty.gameObject:SetActiveEx(#EmailList > 0 and CurEmail == nil)
    --显示右侧详细信息
    self.panel.DatailObj.gameObject:SetActiveEx(CurEmail ~= nil)

    if #EmailList <= 0 then
        --当前没有邮件
    else
        if CurEmail == nil then
            --未选中邮件
        else
            --名字-icon
            self.panel.Email_Name.LabText = CurEmail.SendName

            --头像
            self:ResetHead()

            --标题
            self.panel.Email_Title.LabText = CurEmail.title

            --发送时间

            local l_time = os.date("!*t", Common.TimeMgr.GetLocalTimestamp(CurEmail.baseInfo.create_time))
            local l_minSt = tostring(l_time.min)
            if l_time.min < 10 then
                l_minSt = "0" .. l_minSt
            end
            self.panel.Email_Time.LabText = StringEx.Format("{0}:{1}   {2}-{3}-{4}", l_time.hour, l_minSt, l_time.year, l_time.month, l_time.day)


            --剩余时间
            local l_time = CurEmail.residueTime
            if l_time > 86400 then
                self.panel.Email_TimeResidue.LabText = Lang("EMAIL_EXIRATION_TIME", math.floor(l_time / 86400))
            else
                l_time = l_time - math.floor(l_time / 86400)
                if l_time > 3600 then
                    self.panel.Email_TimeResidue.LabText = Lang("EMAIL_EXIRATION_TIME_HOUR", math.floor(l_time / 3600))
                else
                    self.panel.Email_TimeResidue.LabText = Lang("EMAIL_EXIRATION_TIME_MIN")
                end
            end
            self.panel.Email_TimeResidue.gameObject:SetActiveEx(false)

            --显示已领取标志
            self.panel.Email_GetTag.gameObject:SetActiveEx(CurEmail.baseInfo.is_read)
            --领取按钮
            self.panel.GetBtn.gameObject:SetActiveEx(not CurEmail.baseInfo.is_read and CurEmail.baseInfo.is_has_item)
            --删除按钮
            self.panel.DelBtn.gameObject:SetActiveEx(CurEmail.baseInfo.is_read)
            --显示道具列表
            self.panel.Email_ItemArea.gameObject:SetActiveEx(CurEmail.baseInfo.is_has_item)
            --内容的宽度
            local l_maskSize = self.panel.Email_ItemMask.transform.sizeDelta
            if CurEmail.baseInfo.is_has_item then
                l_maskSize.y = 176
            else
                l_maskSize.y = 300
            end
            self.panel.Email_ItemMask.transform.sizeDelta = l_maskSize

            --详细信息
            if CurEmail.detail ~= nil then
                --邮件详情
                self.panel.Email_Content.LabText = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(CurEmail.content)
            else
                self.panel.Email_Content.LabText = "..."
            end

            --道具显示
            self:ShowEmailItems(CurEmail)

            --调整高度
            LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.ContentRect.transform)
            self.panel.ContentRect.gameObject:SetRectTransformPos(self.panel.ContentRect.transform.anchoredPosition.x, 0)
        end
    end
end

--头像显示
function EmailHandler:ResetHead()
    local email = self.CurEmail
    if email == nil then
        return
    end

    if self.panel == nil then
        return
    end

    --发送好友头像
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.panel.Email_PlayerIcon.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    --邮件icon
    self.panel.Email_PlayerIcon.Img.enabled = false
    if email.baseInfo.send_uid ~= nil and tostring(email.baseInfo.send_uid) ~= "0" then
        if email.playerInfo == nil then
            MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(email.baseInfo.send_uid, function(playInfo)
                email.playerInfo = playInfo
                self:ResetHead()
            end)
        else
            ---@type HeadTemplateParam
            local param = {
                EquipData = email.playerInfo:GetEquipData()
            }

            self.head2d:SetData(param)
            self.head2d:SetGameObjectActive(true)
        end
    elseif email.npcData ~= nil then
        self.head2d:SetGameObjectActive(true)
        self.panel.Email_PlayerIcon.Img.enabled = true
        ---@type NpcTable
        local npcTable = email.npcData
        ---@type HeadTemplateParam
        local param = {
            NpcHeadID = npcTable.Id
        }

        self.head2d:SetData(param)
    end
end

--道具显示
function EmailHandler:ShowEmailItems(email)
    if email.detail == nil then
        self.ItemPool:ShowTemplates({ Datas = {} })
        return
    end

    if not email.baseInfo.is_has_item then
        self.ItemPool:ShowTemplates({ Datas = {} })
        return
    end

    --来自本地表格的数据
    if email.raward == nil then
        self.ItemPool:ShowTemplates({ Datas = {} })
        return
    end

    self.ItemPool:ShowTemplates({ Datas = email.raward })
end

--约束滑动框大小和位置
function EmailHandler:ClampGroupHeight()
    if self.panel == nil then
        return
    end
    local l_maxpos = self.panel.EmailItemParent.transform.sizeDelta.y - self.panel.Viewport.transform.parent.sizeDelta.y
    if l_maxpos <= 0 then
        l_maxpos = 0
    end
    if self.panel.EmailItemParent.transform.anchoredPosition.y > l_maxpos then
        self.panel.EmailItemParent.gameObject:SetRectTransformPos(self.panel.EmailItemParent.transform.anchoredPosition.x, l_maxpos)
    end
end

function EmailHandler:OnBtnGet()
    local tipSystemOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips)
    if self.CurEmail ~=nil then
        if tipSystemOpen and self:CheckNeedPaidItemTip(self.CurEmail) then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("Refund_Instructions_Payment_Mails"), function()
                self:RequestMail(self.CurEmail, MailOpType.Mail_Read)
            end)
        else
            self:RequestMail(self.CurEmail, MailOpType.Mail_Read)
        end
    end
end

function EmailHandler:OnBtnGetAll()
    local hasUnread = false
    local needTip = false
    local tipSystemOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips)
    local l_itemCount=#Mgr.Datas
    for i=1,l_itemCount do
        if not Mgr.Datas[i].baseInfo.is_read then
            hasUnread = true
        end
        if tipSystemOpen then
            if self:CheckNeedPaidItemTip(Mgr.Datas[i]) then
                needTip = true
                break
            end
        end
    end
    if needTip then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("Refund_Instructions_Payment_Mails"), function()
            self:RequestMail(nil, MailOpType.Mail_ReadAll)
        end)
    elseif hasUnread then
        self:RequestMail(nil, MailOpType.Mail_ReadAll)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EMAIL_NOPULL"))
    end
end

function EmailHandler:OnBtnDel()
    if self.CurEmail ~=nil then
        Mgr.RequestMailOp(self.CurEmail, MailOpType.Mail_Del)
    end
end

function EmailHandler:OnBtnDelAll()
    local l_itemCount=#Mgr.Datas
    for i=1,l_itemCount do
        if Mgr.Datas[i].baseInfo.is_read then
            Mgr.RequestMailOp(nil, MailOpType.Mail_DelAll)
            return
        end
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EMAIL_NODELE"))
end

-- 当邮件中包含付费道具且在退款有效期内返回true
function EmailHandler:CheckNeedPaidItemTip(email)
    if not email or email.baseInfo.is_read then return false end
    if email.raw.Payment == 1 then      -- 付费道具处理
        local usageTime = tonumber(MServerTimeMgr.UtcSeconds)- tonumber(email.baseInfo.create_time)
        if usageTime <= MgrMgr:GetMgr("MallMgr").RefundExpirationTime then  -- 在退款期内
            return true
        end
    end
    return false
end

function EmailHandler:RequestMail(email,opType)
    Mgr.RequestMailOp(email, opType)
end

return EmailHandler
--lua custom scripts end
