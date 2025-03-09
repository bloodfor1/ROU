--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RedEnvelopePanel"
require "UI/Template/RedEnvelopeRecordItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl

local l_redOpenEffectPath = "Effects/Prefabs/Creature/Ui/Fx_ui_RedPacket"  
local l_redUnlockEffectPath = "Effects/Prefabs/Creature/Ui/Fx_ui_RedPacket2"
local l_redSendEffectPath = "Effects/Prefabs/Creature/Ui/Fx_ui_RedPacket3"

--next--
--lua fields end

--lua class define
RedEnvelopeCtrl = class("RedEnvelopeCtrl", super)
--lua class define end

--lua functions
function RedEnvelopeCtrl:ctor()

    super.ctor(self, CtrlNames.RedEnvelope, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function RedEnvelopeCtrl:Init()

    self.panel = UI.RedEnvelopePanel.Bind(self)
    super.Init(self)

    self.redMgr = MgrMgr:GetMgr("RedEnvelopeMgr")
    self.redMgr.IsBlockTextChecking = false  --重置正在进行屏蔽字检测标志
    self.redMgr.CanReqSendRed = true  --重置可发送红包请求标志
    self.redLevelData = nil  --红包等级数据
    self.redEnvelopeRecordTemplatePool = nil  --红包记录列表池
    self.RecordObj = nil  --录音组件  

    --模块初始化确保隐藏 防止美术误操作
    self.panel.GetPart.UObj:SetActiveEx(false)
    self.panel.SendPart.UObj:SetActiveEx(false)
    self.panel.LockPart.UObj:SetActiveEx(false)

    --获取语音系统是否开启
    self.isVoiceSystemOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ChatVoice)

    --遮罩设置
    self.mask=self:NewPanelMask(BlockColor.Dark, nil, function()
        if self.showMode == self.redMgr.ERedEnvelopeShowMode.Unlock then
            UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelope)
        elseif self.showMode == self.redMgr.ERedEnvelopeShowMode.Get then
            self.panel.GetPart.Animatior:Play("UI_Redenvelope_out", function ()
                UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelope)
            end)
        elseif self.showMode == self.redMgr.ERedEnvelopeShowMode.Send or self.showMode == self.redMgr.ERedEnvelopeShowMode.Sending then
            --发送模式有单独关闭按钮 点击背景无效果
            --发送中因为动画展示 点击背景无效果
        else
            UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelope)
        end
        
    end)

end --func end
--next--
function RedEnvelopeCtrl:Uninit()

    if self.effect ~= nil then
        self:DestroyUIEffect(self.effect)
        self.effect = nil
        self.panel.FxRTImg.UObj:SetActiveEx(false)
    end

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

    if self.RecordObj ~= nil then
        self.RecordObj:Unint()
        self.RecordObj = nil
    end

    self.redEnvelopeRecordTemplatePool = nil

    self.redLevelData = nil
    self.redMgr.CanReqSendRed = true  --重置可发送红包请求标志
    self.redMgr = nil
    
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function RedEnvelopeCtrl:OnActive()

    if self.uiPanelData ~= nil then
        if self.uiPanelData.showMode == self.redMgr.ERedEnvelopeShowMode.Unlock then
            self:ShowUnlockModel(self.uiPanelData.redId, self.uiPanelData.pwd)
        elseif self.uiPanelData.showMode == self.redMgr.ERedEnvelopeShowMode.Get then 
            local l_fxPath = l_redOpenEffectPath
            local l_waitTime = 1
            if self.showMode == self.redMgr.ERedEnvelopeShowMode.Unlock then
                l_fxPath = l_redUnlockEffectPath
                self.isUnlocking = true
            end
            self:CreateUIFx(l_fxPath)
            self:SetTimerShow(l_waitTime, function ()
                self.panel.FxRTImg.UObj:SetActiveEx(false)
                self:ShowGetModel(self.uiPanelData.redType, self.uiPanelData.words, self.uiPanelData.selfGetRecord, self.uiPanelData.recordList)
                self.isUnlocking = false
            end)
        else
            self:CreateUIFx(l_redOpenEffectPath)
            self:SetTimerShow(1, function ()
                self.panel.FxRTImg.UObj:SetActiveEx(false)
                self:ShowSendMode(self.uiPanelData.redType, self.uiPanelData.guildMemberNum)
            end)
        end
        self.showMode = self.uiPanelData.showMode
    end

end --func end
--next--
function RedEnvelopeCtrl:OnDeActive()


end --func end
--next--
function RedEnvelopeCtrl:Update()
    --录音
    if self.RecordObj ~= nil then
        self.RecordObj:Update()
    end

end --func end

--next--
function RedEnvelopeCtrl:BindEvents()
    --选择红包等级ID后事件
    self:BindEvent(self.redMgr.EventDispatcher, self.redMgr.ON_SELECT_REDENVELOPE_LEVEL_ID, function(self, redLevelId)
        self.redLevelData = TableUtil.GetRedPacketLevelMapTable().GetRowByID(redLevelId)
        if self.redLevelData then
            local l_item = TableUtil.GetItemTable().GetRowByItemID(self.redLevelData.RedPacketGetType)
            if l_item then
                self.panel.MoneyIcon.UObj:SetActiveEx(true)
                self.panel.MoneyIcon:SetSprite(l_item.ItemAtlas, l_item.ItemIcon)
            else
                self.panel.MoneyIcon.UObj:SetActiveEx(false)
            end
            self.panel.TotalMoneyNum.LabText = MNumberFormat.GetNumberFormat(self.redLevelData.GetCoin)
            self.panel.TotalRedEnvelopeNum.LabText = tostring(self.redLevelData.DefaultNum)
            --红包数量显示为默认值 还原按钮显示
            self.panel.BtnAdd.UObj:SetActiveEx(true)
            self.panel.BtnReduce.UObj:SetActiveEx(true)
            --消耗展示
            self.panel.CostPart.UObj:SetActiveEx(true)
            self.panel.CostText.LabText = Lang("REDENVELOPE_SEND_COST", self.redLevelData.SpendDiamond)
            local l_costItem = TableUtil.GetItemTable().GetRowByItemID(self.redLevelData.RedPacketSendType)
            if l_costItem then
                self.panel.CostIcon.UObj:SetActiveEx(true)
                self.panel.CostIcon:SetSprite(l_costItem.ItemAtlas, l_costItem.ItemIcon)
            else
                self.panel.CostIcon.UObj:SetActiveEx(false)
            end
        end
    end)

    --发送红包成功后事件
    self:BindEvent(self.redMgr.EventDispatcher, self.redMgr.ON_SEND_SUCCESS, function(self)
        --设置展示状态未发送中
        self.showMode = self.redMgr.ERedEnvelopeShowMode.Sending
        --播放特效
        self:CreateUIFx(l_redSendEffectPath, function ()
            self.panel.SendPart.Animatior:Play("UI_Redenvelope_sent_out02", function ()
                if self.panel then
                    self.panel.SendPart.UObj:SetActiveEx(false)
                end
            end)
        end)
        self:SetTimerShow(1.2, function ()
            UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelope)
        end)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--开启和关闭的特效加载
--effectPath  特效路径
function RedEnvelopeCtrl:CreateUIFx(effectPath, loadCallBack)

    --原本特效销毁
    if self.effect ~= nil then
        self:DestroyUIEffect(self.effect)
        self.effect = nil
        self.panel.FxRTImg.UObj:SetActiveEx(false)
    end

    local l_fxData = {}
    l_fxData.rawImage = self.panel.FxRTImg.RawImg
    l_fxData.position = Vector3.New(-0.1, 0, 0)
    l_fxData.scaleFac = Vector3.New(1.76, 1.76, 1)
    l_fxData.loadedCallback = function(a) 
        if self.panel then
            self.panel.FxRTImg.UObj:SetActiveEx(true) 
            if loadCallBack then
                loadCallBack()
            end
        end
    end
    l_fxData.destroyHandler = function ()
        if self.panel then
            self.effect = nil
            self.panel.FxRTImg.UObj:SetActiveEx(false)
        end
    end
    self.effect = self:CreateUIEffect(effectPath, l_fxData)

end

--设置延迟展示
--delayTime  延迟时间
--callback  延迟结束后回调事件
function RedEnvelopeCtrl:SetTimerShow(delayTime, callback)
    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    self.timer = self:NewUITimer(function()
        if self.panel and callback then
            callback()
        end
    end, delayTime, 1, true)
    self.timer:Start()
end

--设置输入框规则
--inputCom  对应输入框的com组件
--lengthLimit 长度限制
--isNeedEmoji 是否需要表情
--placeholderCom  空白输入框提示文本com组件
--placeholderStr  空白输入框提示文本字符串
function RedEnvelopeCtrl:SetInputFieldRule(inputCom, lengthLimit, isNeedEmoji, placeholderCom, placeholderStr)
    --长度限制
    inputCom.Input.characterLimit = lengthLimit

    --输入事件
    inputCom:OnInputFieldChange(function(value)
        --去除输入法的系统Emoji表情和富文本
        local l_value = StringEx.DeleteEmoji(value)
        l_value = StringEx.DeleteRichText(l_value)
        --需要处理游戏内文本表情则 需要动态计算长度限制
        if isNeedEmoji then
            local l_emojExLength = MoonClient.DynamicEmojHelp.GetInputTextEmojiLength(l_value)
            inputCom.Input.characterLimit = lengthLimit + l_emojExLength
        end
        --处理后文本赋给输入框
        inputCom.Input.text = l_value
    end)

    --空白输入框提示文本处理
    placeholderCom.LabText = placeholderStr
    inputCom.Input.onSelect = function(eventData)
        placeholderCom.LabText = ""
    end
    inputCom.Input.onDeselect = function(eventData)
        placeholderCom.LabText = placeholderStr
    end
end

--创建录音组件按钮
--btnCom  对应按钮的com组件
--inputCom  对应输入框的com组件
function RedEnvelopeCtrl:CreateVioceRecordBtn(btnCom, inputCom)
    --初始化录音功能组件
    if self.RecordObj ~= nil then
        self.RecordObj:Unint()
        self.RecordObj = nil
    end
    --判断录音系统是否开启 如果关闭状态直接返回 且隐藏按钮
    btnCom.UObj:SetActiveEx(self.isVoiceSystemOpen)
    if not self.isVoiceSystemOpen then return end
    --创建录音功能组件
    self.RecordObj = UI.ChatRecordObj.new()
    self.RecordObj:Init(btnCom):SetSendAction(function(audioID, translate, time, channel)
        if not self:IsActive() then
            return
        end
        inputCom.Input.text = translate
    end):SetChannel(DataMgr:GetData("ChatData").EChannel.GuildChat)
end

--发送红包模式界面
--redType  红包类型 枚举
--guildMemberNum  公会人数
function RedEnvelopeCtrl:ShowSendMode(redType, guildMemberNum)
    --模块选择
    self.panel.GetPart.UObj:SetActiveEx(false)
    self.panel.SendPart.UObj:SetActiveEx(true)
    self.panel.LockPart.UObj:SetActiveEx(false)

    --初始化数据
    self.redLevelData = nil
    self.panel.MoneyIcon.UObj:SetActiveEx(false)
    self.panel.TotalMoneyNum.LabText = ""
    self.panel.TotalRedEnvelopeNum.LabText = 0
    if guildMemberNum then
        self.panel.GuildMemberNum.UObj:SetActiveEx(true)
        self.panel.GuildMemberNum.LabText = Lang("SELF_GUILD_MEMBER_NUM", guildMemberNum)
    else
        self.panel.GuildMemberNum.UObj:SetActiveEx(false)
    end
    self.panel.CostPart.UObj:SetActiveEx(false)

    --初始化通用按钮
    self:InitSendModeCommonBtn(redType)

    --类型区分
    if redType == self.redMgr.RED_TYPE.PASSWORD then
        self:ShowSendMode_Pwd()
    else  --if redType == self.redMgr.RED_TYPE.LUCKY then
        self:ShowSendMode_Lucky()
    end

    --关闭按钮
    self.panel.BtnClose.UObj:SetActiveEx(true)
    self.panel.BtnClose:AddClick(function ()
        self.panel.BtnClose.UObj:SetActiveEx(false)
        self.panel.SendPart.Animatior:Play("UI_Redenvelope_sent_out", function ()
            UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelope)
        end)
    end)

    --判断退款提示是否开启 及 动态调整布局
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.PaymentTips) then
        local paymentTips = self:NewTemplate("PaymentInstructionsTemplate",
                {
                    TemplateInstanceGo = self.panel.PaymentInstructions.gameObject,
                    TemplateParent = self.panel.PaymentInstructions.transform.parent
                }
        )
        paymentTips:SetData({})
        self.panel.PaymentInstructions.gameObject:SetActiveEx(true)
        MLuaCommonHelper.SetRectTransformHeight(self.panel.ControllPart.UObj, 110)
        MLuaCommonHelper.SetRectTransformPosY(self.panel.CostPart.UObj, 92)
    else
        self.panel.PaymentInstructions.gameObject:SetActiveEx(false)
        MLuaCommonHelper.SetRectTransformHeight(self.panel.ControllPart.UObj, 125)
        MLuaCommonHelper.SetRectTransformPosY(self.panel.CostPart.UObj, 105)
    end
    
end

--初始化发送模式通用按钮
--redType 红包类型
function RedEnvelopeCtrl:InitSendModeCommonBtn(redType)
    --红包金额选择按钮
    self.panel.BtnOpenSelectMoney:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.RedEnvelopeSelectLevel)
    end)
    --增加红包数按钮
    self.panel.BtnAdd:AddClick(function()
        self:ModifyRedEnvelopeNum(1)
    end)
    --减少红包数按钮
    self.panel.BtnReduce:AddClick(function()
        self:ModifyRedEnvelopeNum(2)
    end)
    --随机红包数按钮
    self.panel.BtnRandom:AddClick(function()
        self:ModifyRedEnvelopeNum(0)
    end)
    --发送红包按钮
    self.panel.BtnSend:AddClick(function()
        self:SendRedEnvelope(redType)
    end)
end

--红包发送模式界面展示 口令红包特殊部分
function RedEnvelopeCtrl:ShowSendMode_Pwd()
    --标题
    self.panel.SendTitle.LabText = Lang("PASSWORD_RED_ENVELOPE")
    --输入模块显示控制
    self.panel.PwdInputPart.UObj:SetActiveEx(true)
    self.panel.MsgInputPart.UObj:SetActiveEx(false)

    --发送红包口令输入框规则设定
    local l_lengthLimit = MGlobalConfig:GetInt("RedPacketPasswordMaxLen")
    local l_placeholderStr = self.isVoiceSystemOpen and Lang("INPUT_OR_SHOUT_REDENVELOP_COMMAND") or Lang("INPUT_REDENVELOP_COMMAND") 
    self:SetInputFieldRule(self.panel.PwdInput_Send, l_lengthLimit, false,
        self.panel.Placeholder_PwdInputSend, l_placeholderStr)
    --创建录音组件按钮
    self:CreateVioceRecordBtn(self.panel.BtnVoice_Pwd_Send, self.panel.PwdInput_Send)
end

--红包发送模式界面展示 手气红包特殊部分
function RedEnvelopeCtrl:ShowSendMode_Lucky()
    --标题
    self.panel.SendTitle.LabText = Lang("LUCK_RED_ENVELOPE")
    --输入模块显示控制
    self.panel.PwdInputPart.UObj:SetActiveEx(false)
    self.panel.MsgInputPart.UObj:SetActiveEx(true)

    --发送红包寄语输入框规则设定
    local l_lengthLimit = MGlobalConfig:GetInt("RedPacketTextMaxLen")
    local l_placeholderStr = self.isVoiceSystemOpen and Lang("INPUT_OR_SHOUT_REDENVELOP_MSG") or Lang("INPUT_REDENVELOP_MSG") 
    self:SetInputFieldRule(self.panel.MsgInput, l_lengthLimit, true,
        self.panel.Placeholder_MsgInput, l_placeholderStr)
    --创建录音组件按钮
    self:CreateVioceRecordBtn(self.panel.BtnVoice_Msg_Send, self.panel.MsgInput)

    --表情按钮
    self.panel.BtnExpression:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Multitool)
        local l_openPanelParam = {
            onlyShowEmojMode = true,
            inputActionData = {
                inputFunc = function(st)
                    --獲取增加表情後的字符串
                    local l_newMsg = self.panel.MsgInput.Input.text .. st
                    --計算增加后字符串的長度
                    local l_msgLength = string.ro_len_normalize(l_newMsg)
                    local l_emojExLength = MoonClient.DynamicEmojHelp.GetInputTextEmojiLength(l_newMsg)
                    --判斷是否超出 長度限制 超出則提示超出 並且無法輸入  未超出則根據表情的額外長度增加長度限制 並且將新字符串寫入
                    if l_msgLength > MGlobalConfig:GetInt("RedPacketTextMaxLen") + l_emojExLength then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BEYOND_RED_ENVELOPE_MESSAGE_LIMIT"))
                    else
                        self.panel.MsgInput.Input.characterLimit = MGlobalConfig:GetInt("RedPacketTextMaxLen") + l_emojExLength
                        self.panel.MsgInput.Input.text = l_newMsg
                    end
                end,
            },
        }
        UIMgr:ActiveUI(UI.CtrlNames.Multitool, l_openPanelParam)
    end)
end

--口令红包解锁模式界面展示 
--redId  红包ID
--pwd  红包口令
function RedEnvelopeCtrl:ShowUnlockModel(redId, pwd)
    --模块选择
    self.panel.GetPart.UObj:SetActiveEx(false)
    self.panel.SendPart.UObj:SetActiveEx(false)
    self.panel.LockPart.UObj:SetActiveEx(true)

    --口令提示
    self.panel.PwdTip.LabText = pwd or ""

    --开启红包口令输入框规则设定
    local l_lengthLimit = MGlobalConfig:GetInt("RedPacketPasswordMaxLen")
    local l_placeholderStr = self.isVoiceSystemOpen and Lang("INPUT_OR_SHOUT_REDENVELOP_COMMAND") or Lang("INPUT_REDENVELOP_COMMAND") 
    self:SetInputFieldRule(self.panel.PwdInput_Get, l_lengthLimit, false,
        self.panel.Placeholder_PwdInputGet, l_placeholderStr)
    --创建录音组件按钮
    self:CreateVioceRecordBtn(self.panel.BtnVoice_Pwd_Get, self.panel.PwdInput_Get)

    --重置正在解锁标志
    self.isUnlocking = false

    --开启红包按钮
    self.panel.BtnOpenPwd:AddClick(function()
        if not self.isUnlocking then
            local l_pwd = self.panel.PwdInput_Get.Input.text
            self.redMgr.ReqGetRedEnvelope(redId, l_pwd)
        end
    end)
end

--展示红包获取记录模式
--redType  红包类型 枚举
--words   寄语或口令
--selfGetRecord  自己获取的记录
--recordList  红包获取记录
function RedEnvelopeCtrl:ShowGetModel(redType, words, selfGetRecord, recordList)
    --模块选择
    self.panel.GetPart.UObj:SetActiveEx(true)
    self.panel.SendPart.UObj:SetActiveEx(false)
    self.panel.LockPart.UObj:SetActiveEx(false)
    --标题
    self.panel.GetTitle.LabText = redType == self.redMgr.RED_TYPE.PASSWORD and Lang("PASSWORD_RED_ENVELOPE") or Lang("LUCK_RED_ENVELOPE")
    --口令或寄语
    local l_words = words or ""
    l_words = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_words)  --动态表情替换
    self.panel.MsgText.LabText = redType == self.redMgr.RED_TYPE.PASSWORD and Lang("PASSWARD_HEAD_TEXT", l_words) or Lang("MSG_HEAD_TEXT", l_words)
    --自己获得
    if not selfGetRecord then
        self.panel.SelfGetRecord.LabText = Lang("YOU_DO_NOT_GET_MONEY_OF_RED_ENVELOPE")
    else
        local l_contentItem = TableUtil.GetItemTable().GetRowByItemID(selfGetRecord.itemId)
        if l_contentItem then
            local l_iconStr = Lang("RICH_IMAGE", l_contentItem.ItemIcon, l_contentItem.ItemAtlas, 20, 1)
            self.panel.SelfGetRecord.LabText = Lang("YOU_GET_MONEY_OF_RED_ENVELOPE", l_iconStr, selfGetRecord.itemNum)
        else
            self.panel.SelfGetRecord.LabText = ""
        end
    end
    --红包记录
    if not self.redEnvelopeRecordTemplatePool then
        self.redEnvelopeRecordTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.RedEnvelopeRecordItemTemplate,
            TemplatePrefab = self.panel.RedEnvelopeRecordItemPrefab.gameObject,
            ScrollRect = self.panel.RecordView.LoopScroll
        })
    end
    self.redEnvelopeRecordTemplatePool:ShowTemplates({ Datas = recordList })
end

--修改发送的红包数量
--modifyType  修改类型 0随机 1增加 2减少
function RedEnvelopeCtrl:ModifyRedEnvelopeNum(modifyType)
    --检查是否选择红包金额
    if not self.redLevelData then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_RED_ENVELOPE_TOTAL_MONEY"))
        return
    end
    --获取当前的数量
    local l_curNum = tonumber(self.panel.TotalRedEnvelopeNum.LabText)
    --根据类型计算
    if modifyType == 0 then
        --随机
        l_curNum = math.random(self.redLevelData.SendMin, self.redLevelData.SendMax)
    elseif modifyType == 1 then
        --增加
        l_curNum = l_curNum + 1 > self.redLevelData.SendMax and self.redLevelData.SendMax or l_curNum + 1
    elseif modifyType == 2 then
        --减少
        l_curNum = l_curNum - 1 < self.redLevelData.SendMin and self.redLevelData.SendMin or l_curNum - 1
    end

    --到达档位上/下限时，加/减消失
    if l_curNum == self.redLevelData.SendMax then
        self.panel.BtnAdd.UObj:SetActiveEx(false)
        self.panel.BtnReduce.UObj:SetActiveEx(true)
    elseif l_curNum == self.redLevelData.SendMin then
        self.panel.BtnReduce.UObj:SetActiveEx(false)
        self.panel.BtnAdd.UObj:SetActiveEx(true)
    else
        self.panel.BtnAdd.UObj:SetActiveEx(true)
        self.panel.BtnReduce.UObj:SetActiveEx(true)
    end

    self.panel.TotalRedEnvelopeNum.LabText = tostring(l_curNum)
end

--发送红包
--redType  红包类型 枚举
function RedEnvelopeCtrl:SendRedEnvelope(redType)
    --发送屏蔽字检测中
    --已发送发红包请求后
    --发送中的动画期间 
    --以上三种情况 点击发送按钮直接返回 防止佛手无影手的躁郁症患者攻击发送按钮
    if self.redMgr.IsBlockTextChecking or
        (not self.redMgr.CanReqSendRed) or
        self.showMode == self.redMgr.ERedEnvelopeShowMode.Sending then
        return
    end
    --检查是否选择红包金额
    if not self.redLevelData then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_RED_ENVELOPE_TOTAL_MONEY"))
        return
    end
    --判断消耗金额是否充足
    if Data.BagModel:GetCoinOrPropNumById(self.redLevelData.RedPacketSendType) < self.redLevelData.SpendDiamond then
        local l_costItem = TableUtil.GetItemTable().GetRowByItemID(self.redLevelData.RedPacketSendType)
        if l_costItem then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MATERIAL_NOT_ENOUGH", l_costItem.ItemName))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COIN_NOT_ENOUGH"))
        end

        return
    end
    --获取口令或寄语
    local l_msg = nil
    if redType == self.redMgr.RED_TYPE.PASSWORD then
        l_msg = self.panel.PwdInput_Send.Input.text
        local l_pwdLength = string.ro_len_normalize(l_msg)
        --口令不能为空检测
        if l_pwdLength == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("RED_ENVELOPE_PASSWORD_EMPTY"))
            return
        end
        --口令长度检测
        if l_pwdLength > MGlobalConfig:GetInt("RedPacketPasswordMaxLen") then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("RED_ENVELOPE_PASSWORD_TOO_LONG"))
            return
        end
    elseif redType == self.redMgr.RED_TYPE.LUCKY then
        l_msg = self.panel.MsgInput.Input.text
        local l_msgLength = string.ro_len_normalize(l_msg)
        local l_emojExLength = MoonClient.DynamicEmojHelp.GetInputTextEmojiLength(l_msg)
        --寄语不能为空检测
        if l_msgLength == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("RED_ENVELOPE_MESSAGE_EMPTY"))
            return
        end
        --寄语长度检测
        if l_msgLength > MGlobalConfig:GetInt("RedPacketTextMaxLen") + l_emojExLength then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("RED_ENVELOPE_MESSAGE_TOO_LONG"))
            return
        end
    end
    --红包数获取
    local l_redNum = tonumber(self.panel.TotalRedEnvelopeNum.LabText)
    --屏蔽字检测
    self.redMgr.IsBlockTextChecking = true  --设置正在检测屏蔽字标志（防弱网连点）
    MgrMgr:GetMgr("ForbidTextMgr").RequestJudgeTextForbid(l_msg, function(checkInfo)
        self.redMgr.IsBlockTextChecking = false  --重置正在检测屏蔽字标志
        local l_resultCode = checkInfo.result
        if l_resultCode ~= 0 then
            --判断服务器是否判断失败 如果失败什么都不发生
            if l_resultCode == ErrorCode.ERR_FAILED then
                return
            end
            --含有屏蔽字则提示
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resultCode))
            --将原文本替换成过滤后字符串
            if redType == self.redMgr.RED_TYPE.PASSWORD then
                self.panel.PwdInput_Send.Input.text = checkInfo.text
            elseif redType == self.redMgr.RED_TYPE.LUCKY then
                self.panel.MsgInput.Input.text = checkInfo.text
            end
            return
        end
        --不含屏蔽字则请求发送红包
        if self.panel ~= nil then
            self.redMgr.ReqSendRedEnvelope(redType, l_msg, self.redLevelData.ID, l_redNum)
        end
    end)
end

--lua custom scripts end
return RedEnvelopeCtrl