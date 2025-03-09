--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TalkDlg2Panel"
require "UI/Template/TalkDlgBtnTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TalkDlg2Ctrl = class("TalkDlg2Ctrl", super)
--lua class define end

--lua functions
function TalkDlg2Ctrl:ctor()

    super.ctor(self, CtrlNames.TalkDlg2, UILayer.Function, nil, ActiveType.Exclusive)
    self.cacheGrade = EUICacheLv.VeryLow
    self.talkList = {}
    self.locked = false
    self.forceSelect = false
    self.stopMoveOnActive = true

    --对话显示的角色模型
    self.roleRTFeature = nil
    --所属的CommandBlock（如果不是由Command系统打开则为空）
    self.ownerBlock = nil

    self.talkMgr = MgrMgr:GetMgr("NpcTalkDlgMgr")
    self.npcMgr = MgrMgr:GetMgr("NpcMgr")
end --func end
--next--
function TalkDlg2Ctrl:Init()

    self.panel = UI.TalkDlg2Panel.Bind(self)
    super.Init(self)

    self.mask = self:NewPanelMask(BlockColor.Transparent, nil, function()
        self:TryCallback(true)
    end)

    self.panel.SelectList.gameObject:SetActiveEx(false)
    self.panel.btnClick:AddClick(function()
        self:TryCallback(true)
    end)

    self.panel.CloseBtn:AddClick(function()
        self.talkMgr.SkipTaskBlock()
        self:RealClose()
    end)

    self.panel.Raycast:AddClick(function()
        self:TryCallback(true)
    end)

    self:InitTemplatePools()

end --func end
--next--
function TalkDlg2Ctrl:Uninit()

    self.normalSelectListPool = nil
    self.funcSelectListPool = nil
    self.taskSelectListPool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function TalkDlg2Ctrl:OnActive()

    self.templateBtnCount = 0

    self.selectInfos = {}

    self:InitArrowFx()

    self.panel.Btn_next.gameObject:SetActiveEx(true)

    self.talkMgr.FirstTalkStatus = true

    self:ClearTalk()
    self:DeActiveAllTemplate()

    self.panel.CloseBtn:SetActiveEx(self.forceSelect and self.talkMgr.HasSelect(self.npcMgr.NPC_SELECT_TYPE.NORMAL) and self.currentTalkNumber > 1)

    self.panel.ImgUp:SetActiveEx(false)
    self.panel.ImgDown:SetActiveEx(false)

    -- 初始化外接数据
    self:OnInitWithData(self.uiPanelData)

    -- 初始化选项
    for _,info in ipairs(self.talkMgr.GetSelectInfos()) do
        self:HandleSelectInfo(info)
    end

    -- 初始化显示内容
    local showInfo = self.talkMgr.GetSelectShowInfo()
    self.ownerBlock = showInfo.block

    local l_hasSetTalk = false
    if self.talkMgr.IsShowSelect() then
        l_hasSetTalk = self:ShowSelect(showInfo)
    end
    
    if not l_hasSetTalk and showInfo then
        self:SetTalk(showInfo.isPlayer, showInfo.content)
    end

    -- 可能时序不一样，这边的变量需要再次判定
    if self.uiPanelData and self.uiPanelData.commandType == self.talkMgr.ECommandType.NpcSelect then
        self:SetForceSelect(self.uiPanelData.isNewPlot or self.talkMgr.IsTalked())
    end

    -- 显示npc半身像
    self:ShowNpcModel()

    MPlayerInfo.IsTalking = true
    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.NPC_TALK, false)

    self:TryShowAnim()

    self:BeginTalk()

    self.quitBtnTimer = nil
end --func end
--next--
function TalkDlg2Ctrl:OnDeActive()
    
    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.NPC_TALK, true)
    MPlayerInfo.IsTalking = false

    self.panel.SelectList.gameObject:SetActiveEx(false)
    self.panel.RoleImg.gameObject:SetActiveEx(false)
    if self.roleRTFeature ~= nil then
        self.roleRTFeature:Uninit()
        self.roleRTFeature = nil
    end
    self.callback = nil
    self:SetForceSelect(false)
    self:UnlockWithoutRetry()
    self:DeActiveAllTemplate()

    GlobalEventBus:Dispatch(EventConst.Names.TalkDlgClosed)
    self.talkMgr:ResetSelectInfo()

    self:DestroyArrowFx()

    MAudioMgr:StopCV()
    self.talkMgr.FirstTalkStatus = false

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    if self.moveTween then
        self.moveTween:Kill()
        self.moveTween = nil
    end

    if self.quitBtnTimer then
        self:StopUITimer(self.quitBtnTimer)
        self.quitBtnTimer = nil
    end

    self.selectInfos = {}
end --func end
--next--

--next--
function TalkDlg2Ctrl:OnReconnected()
    if not self:IsShowing() or self.talkMgr.GetCurrentNpcId() == nil then
        return
    end
    super.OnReconnected(self)
    local l_showModel = TableUtil.GetNpcTable().GetRowById(self.talkMgr.GetCurrentNpcId()).ShowModel
    if self.talkMgr.GetCurrentNpcId() ~= nil and self:IsShowing() and l_showModel then
        self:ShowNpcModel(self.talkMgr.GetCurrentNpcId())
    end
end --func end
--next--
function TalkDlg2Ctrl:BindEvents()

    --dont override this function
    -- 增加选项
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.ADD_SELECT_INFO, self.OnAddSelectInfo)
    -- 批量增加选项
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.BATCH_ADD_SELECT_INFO, self.OnBatchAddSelectInfo)
    -- 移出所有选项
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.REMOVE_ALL_SELECT_INFO, self.OnClearSelect)
    -- 显示选项
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.SHOW_SELECT_INFO, self.OnShowSelect)
    -- 显示对话
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.SHOW_TALK_INFO, self.OnShowTalk)
    -- Command关闭对话框
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.COMMAND_TRY_CLOSE, self.TryClose)
    -- Command选择
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.COMMAND_NPC_SELECT_FORWARD, self.OnCommandNpcSelectForward)
    -- 关闭
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.COMMAND_NPC_SELECT_QUIT, self.OnCommandNpcSelectCancel)
    -- npc消失
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.ON_NPC_DISAPPEAR, self.OnNpcDisappear)
    -- 锁定对话框
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.ON_LOCK_EVENT, self.OnLockEvent)
    -- 强制选择事件
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.ON_FORCE_SELECT_EVENT, self.SetForceSelect)
    -- 尝试触发回调
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.ON_TRY_CALLBACK, self.TryCallback)
    -- 数据更新
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.ON_DATA_UPDATE, self.OnDataUpdate)
    -- npc更新
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.ON_UPDATE_SELECT_NPC, self.SetNPC)
    --退出场景关闭界面
    self:BindEvent(GlobalEventBus,EventConst.Names.LeaveScene, self.RealClose)
    -- npc销毁
    self:BindEvent(self.npcMgr.EventDispatcher,self.npcMgr.ON_NPC_DESTORY, self.OnNpcDestroy)
    -- 设置对话
    self:BindEvent(self.talkMgr.EventDispatcher,self.talkMgr.ON_SET_TALK, self.SetTalk)
    -- 替换选项
    self:BindEvent(self.talkMgr.EventDispatcher, self.talkMgr.ON_REPLACE_SELECT_INFO, self.OnReplaceSelectInfo)
    --新手指引
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher, MgrMgr:GetMgr("BeginnerGuideMgr").TALKDLG_OPTION_BUTTON_GUIDE_EVENT, 
        function(self, guideStepInfo)
            self:ShowBeginnerGuide(guideStepInfo)
        end)

end --func end
--next--
--lua functions end

--lua custom scripts
---------------------------选择相关------------------------------------------------
-- 添加选项
function TalkDlg2Ctrl:OnAddSelectInfo(info)

    self:HandleSelectInfo(info)
end

-- 批量增加选项
function TalkDlg2Ctrl:OnBatchAddSelectInfo(infos)

    for i, v in ipairs(infos) do
        self:HandleSelectInfo(v)
    end
end

-- 清理选项
function TalkDlg2Ctrl:OnClearSelect(command)

    if command then
        self.ownerBlock = command.Block
    end
    self:ClearSelect()
end

-- 显示选项
function TalkDlg2Ctrl:OnShowSelect(showInfo)

    self:ShowSelect(showInfo)
end

-- 显示对话
function TalkDlg2Ctrl:OnShowTalk(showInfo)

    self:SetTalk(showInfo.isPlayer, showInfo.content)
end

-- 处理一个选项数据
function TalkDlg2Ctrl:HandleSelectInfo(selectInfo)

    local l_isPlot = selectInfo.isPlot or false
    if l_isPlot then return end

    local l_name = selectInfo.name
    local l_callback = selectInfo.callback
    local l_closeAfterClick = selectInfo.closeAfterClick
    local l_type = selectInfo.type
    local l_sequence = selectInfo.sequenceId
    local l_important = selectInfo.important

    self:AddSelect(l_name, function() 
        if l_callback then
            self:ClearSelect()
            l_callback()
        end
    end, l_closeAfterClick, l_type, l_sequence, l_important)

    self.panel.Btn_next.gameObject:SetActiveEx(false)
end

function TalkDlg2Ctrl:GetTemplatePoolByNpcSelectType(selectType)

    local NPC_SELECT_TYPE = self.npcMgr.NPC_SELECT_TYPE
    if selectType == NPC_SELECT_TYPE.TASK then
        return self.taskSelectListPool
    elseif selectType == NPC_SELECT_TYPE.FUNC then
        return self.funcSelectListPool
    else
        return self.normalSelectListPool
    end
end

-- 增加一个选项实体
function TalkDlg2Ctrl:AddSelect(selectName, selectCallback, hideAfterSelect, selectType, sequenceId, important)

    selectType = selectType or NPC_SELECT_TYPE.NORMAL
    hideAfterSelect = hideAfterSelect or false

    local info = {
        selectType = selectType,
        selectName = selectName,
        hideAfterSelect = hideAfterSelect,
        sequenceId = sequenceId,
        callback = function ()
            MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
            if selectCallback then
                selectCallback()
            end
        end,
        important = important,
    }

    table.insert(self.selectInfos, info)

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    if self.moveTween then
        self.moveTween:Kill()
        self.moveTween = nil
    end
    self.timer = self:NewUITimer(function()
        self:ShowTemplates()
    end, 0.001)
    self.timer:Start()
end

function TalkDlg2Ctrl:ShowTemplates()

    if self.quitBtnTimer then
        self:StopUITimer(self.quitBtnTimer)
        self.quitBtnTimer = nil
    end

    if not self.selectInfos then 
        self.panel.CloseBtn.gameObject:SetActiveEx(true)
        return 
    end

    self:DeActiveAllTemplate()

    -- check important task count https://www.tapd.cn/20332331/prong/stories/view/1120332331001053740
    local l_importantTask = {}
    for i, v in ipairs(self.selectInfos) do
        if v.important then
            table.insert(l_importantTask, v)
        end
    end

    if #l_importantTask == 1 then
        MgrMgr:GetMgr("NpcTalkDlgMgr").DoSelectAction(l_importantTask[1].callback, l_importantTask[1].hideAfterSelect)        
        return
    end

    local l_hasFuncBtn = false
    local l_mark = {}
    for i, v in ipairs(self.selectInfos) do
        local l_pool = self:GetTemplatePoolByNpcSelectType(v.selectType)
        l_pool:AddTemplate({
            selectName = v.selectName,
            selectType = v.selectType,
            callback = v.callback,
            hideAfterSelect = v.hideAfterSelect,
        })

        if v.selectType ~= self.npcMgr.NPC_SELECT_TYPE.NORMAL then
            l_hasFuncBtn = true
        end

        self.templateBtnCount = self.templateBtnCount + 1
        l_mark[v.selectType] = true

    end

    local NPC_SELECT_TYPE = self.npcMgr.NPC_SELECT_TYPE

    self.panel.TaskSelectList.gameObject:SetActiveEx(l_mark[NPC_SELECT_TYPE.TASK] or false)
    self.panel.FuncSelectList.gameObject:SetActiveEx(l_mark[NPC_SELECT_TYPE.FUNC] or false)
    self.panel.NormalSelectList.gameObject:SetActiveEx(l_mark[NPC_SELECT_TYPE.NORMAL] or false)

    if #self.selectInfos < 5 then
        MLuaCommonHelper.SetRectTransformPosY(self.panel.SelectList.gameObject, 0)
    else
        local l_y = -69.5 * (#self.selectInfos - 5) - 17.4
        MLuaCommonHelper.SetRectTransformPosY(self.panel.SelectList.gameObject, l_y)
        self.moveTween = self.panel.SelectList.transform:DOMoveY(l_y, 0.1)
    end

    if self.talkMgr.FirstTalkStatus then

        self.panel.CloseBtn.gameObject:SetActiveEx(not self.talkMgr.FirstTalkStatus)
    end


    --特判展示新手指引 第一次对话按钮的指引提示 防小白用户卡死
    local l_npcId = self.talkMgr.GetCurrentNpcId()
    if l_npcId then  --判断一次l_npcId是否为空 防止 两边都是nil的情况
        if l_npcId == self.talkMgr.FirstTalkTaskNpcID then
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "FirstTalkTaskGuide" })
        elseif l_npcId == self.talkMgr.SecondTalkTaskNpcID and #self.selectInfos > 1 then
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "SecondTalkTaskGuide" })
        end
    end
end

function TalkDlg2Ctrl:InitTemplatePools()

    self.taskSelectListPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.TalkDlgBtnTemplate,
        TemplateParent = self.panel.TaskSelectList.transform,
        TemplatePrefab = self.panel.TalkDlgBtnTemplate.LuaUIGroup.gameObject
    })

    self.funcSelectListPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.TalkDlgBtnTemplate,
        TemplateParent = self.panel.FuncSelectList.transform,
        TemplatePrefab = self.panel.TalkDlgBtnTemplate.LuaUIGroup.gameObject
    })

    self.normalSelectListPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.TalkDlgBtnTemplate,
        TemplateParent = self.panel.NormalSelectList.transform,
        TemplatePrefab = self.panel.TalkDlgBtnTemplate.LuaUIGroup.gameObject
    })
end

function TalkDlg2Ctrl:DeActiveAllTemplate()

    if self.taskSelectListPool then
        self.taskSelectListPool:DeActiveAll()
    end
    if self.funcSelectListPool then
        self.funcSelectListPool:DeActiveAll()
    end
    if self.normalSelectListPool then
        self.normalSelectListPool:DeActiveAll()
    end

    self.templateBtnCount = 0
end

-- 显示选项
function TalkDlg2Ctrl:ShowSelect(showInfo)
    
    if not showInfo then return end

    self.ownerBlock = showInfo.block
    local l_setTalk = showInfo.isPlayer ~= nil and showInfo.content ~= nil
    if l_setTalk then
        self:SetTalk(showInfo.isPlayer, showInfo.content)
    end
    self.panel.SelectList.gameObject:SetActiveEx(true)

    return l_setTalk
end

-- 清理选项实体
function TalkDlg2Ctrl:ClearSelect()
    
    self:DeActiveAllTemplate()

    self.panel.Btn_next.gameObject:SetActiveEx(true)

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    if self.moveTween then
        self.moveTween:Kill()
        self.moveTween = nil
    end

    self.selectInfos = {}
end

-- 设置强制选择
function TalkDlg2Ctrl:SetForceSelect(on)

    self.forceSelect = on
end

---------------------------选择相关------------------------------------------------

---------------------------对话相关------------------------------------------------

--清除对话
function TalkDlg2Ctrl:ClearTalk()

    self.talkList = {}
    self.currentTalkNumber = 0
end

function TalkDlg2Ctrl:SetTalkName(isPlayer)

    local l_nameTxt
    local l_name
    if isPlayer then
        l_nameTxt = self.panel.playerTalkName
        l_name = MEntityMgr.PlayerEntity.Name
        self.panel.ImageNpc.gameObject:SetActiveEx(false)
        if l_name == nil or l_name == "" then
            self.panel.ImagePlayer.gameObject:SetActiveEx(false)
        else
            self.panel.ImagePlayer.gameObject:SetActiveEx(true)
        end
    else
        l_nameTxt = self.panel.talkName
        local l_row = TableUtil.GetNpcTable().GetRowById(self.talkMgr.GetCurrentNpcId(), true)
        l_name = l_row and l_row.Name or ""
        self.panel.ImagePlayer.gameObject:SetActiveEx(false)
        if l_name == nil or l_name == "" then
            self.panel.ImageNpc.gameObject:SetActiveEx(false)
        else
            self.panel.ImageNpc.gameObject:SetActiveEx(true)
        end

    end

    self.isPlayer = isPlayer

    l_nameTxt.LabText = l_name
end

--设置对话
function TalkDlg2Ctrl:SetTalk(isPlayer, content, clearSelect)
    
    self.talkMgr.Talk()

    if clearSelect == nil then
        clearSelect = false
    end
    if clearSelect then
        self:ClearSelect()
    end

    self:SetTalkName(isPlayer)
    
    self.panel.talkContent.LabText = content

    local l_lab = self.panel.talkContent:GetText()
    self.panel.Raycast.gameObject:SetActiveEx(l_lab.preferredHeight >= 60)
    MLuaCommonHelper.SetRectTransformPosY(self.panel.talkContent.gameObject, 0)
    MLuaCommonHelper.SetRectTransformPosY(self.panel.Anchor.gameObject, 23 - l_lab.preferredHeight)
    MLuaCommonHelper.SetRectTransformPosY(self.panel.Content.gameObject, 0)
    MLuaCommonHelper.SetRectTransformHeight(self.panel.Content.gameObject, l_lab.preferredHeight + 23)

    if self.quitBtnTimer then
        self:StopUITimer(self.quitBtnTimer)
        self.quitBtnTimer = nil
    end

    if self.talkMgr.FirstTalkStatus then
        self.quitBtnTimer = self:NewUITimer(function()
            if self.talkMgr.FirstTalkStatus and self.selectInfos then
                for i, v in ipairs(self.selectInfos) do
                    if v.selectType ~= self.npcMgr.NPC_SELECT_TYPE.NORMAL then
                        self.panel.CloseBtn.gameObject:SetActiveEx(false)
                        return
                    end
                end
            end
            self.panel.CloseBtn.gameObject:SetActiveEx(true)
        end, 0.01):Start()
    else
        self.panel.CloseBtn.gameObject:SetActiveEx(true)
    end
    
end

--开始对话
function TalkDlg2Ctrl:BeginTalk()
  
    self.currentTalkNumber = 0
    self:NextTalk()
end

function TalkDlg2Ctrl:OnReplaceSelectInfo(sequenceId)

    local l_index 
    for i, v in ipairs(self.selectInfos) do
        if v.sequenceId == sequenceId then
            l_index = i
        end
    end
    if l_index == nil then return end

    table.remove(self.selectInfos, l_index)    
end

--下一句
function TalkDlg2Ctrl:NextTalk()
    
    self.currentTalkNumber = self.currentTalkNumber + 1
    local l_currentTalk = self.talkList[self.currentTalkNumber]
    if l_currentTalk == nil then
        return
    end
    self:SetTalk(l_currentTalk.isPlayer, l_currentTalk.content)
end

---------------------------对话相关------------------------------------------------
-- 设置对话点击回调
function TalkDlg2Ctrl:SetCallback(callback)

    self.callback = callback
end

-- 设置npcid
function TalkDlg2Ctrl:SetNPC(focus)

    if focus == nil then
        focus = true
    end
    local l_npcId = self.talkMgr.GetCurrentNpcId()
    local l_showModel = TableUtil.GetNpcTable().GetRowById(l_npcId).ShowModel
    if focus and l_showModel then
        self:ShowNpcModel(l_npcId)
    end
end

-- 锁定
function TalkDlg2Ctrl:Lock()

    self.locked = true
end

-- 解锁
function TalkDlg2Ctrl:UnlockWithoutRetry()

    self.locked = false
end

-- 解锁并带有回调
function TalkDlg2Ctrl:Unlock()

    self.locked = false
    self:TryCallback()
end

--尝试回调，回调失败后关闭界面
function TalkDlg2Ctrl:TryCallback(needTry)

    if needTry and self.selectInfos ~= nil then
        local l_count = #self.selectInfos
        if l_count == 1 and self.talkMgr.HasAnySelect({self.npcMgr.NPC_SELECT_TYPE.FUNC, self.npcMgr.NPC_SELECT_TYPE.TASK}) == false then
            local l_callback = self.selectInfos[1].callback
            self.selectInfos[1].callback = nil
            MgrMgr:GetMgr("NpcTalkDlgMgr").DoSelectAction(l_callback, self.selectInfos[1].hideAfterSelect)
            return
        elseif l_count > 1 and self.forceSelect then
            self:ShowShakeAnim()
            return
        end
    end

    if self.forceSelect and self.selectInfos ~= nil and #self.selectInfos > 0 then
        return
    end

    if self.talkMgr.FirstTalkStatus and self.talkMgr.HasAnySelect({self.npcMgr.NPC_SELECT_TYPE.FUNC, self.npcMgr.NPC_SELECT_TYPE.TASK}) and self.currentTalkNumber < 2 then
        -- 打开只有normal时直接关闭
        self.talkMgr.SkipTaskBlock()
        self:RealClose()
        return
    end
    
    self.talkMgr.FirstTalkStatus = false

    if self.currentTalkNumber >= #self.talkList then
        self:ClearTalk()
        if type(self.callback) == "function" then
            -- 这里的逻辑：在callback调用后，self.callback有可能被重新赋值
            local l_callback = self.callback
            self.callback = nil
            l_callback()
            if not self.locked then
                if self.callback == nil then
                    self:RealClose()
                elseif self.ownerBlock ~= nil and not self.ownerBlock.Running then
                    self:RealClose()
                end
            end
            
        else
            self:RealClose()
        end
    --下一句话
    else
        self:NextTalk()
    end
end

--尝试关闭 如果没有剧本或者下一句话则关闭
function TalkDlg2Ctrl:TryClose()

    if self.forceSelect then
        return
    end
    --如果说完了
    if self.currentTalkNumber >= #self.talkList then
        if type(self.callback) == "function" then
            if not self.locked then
                if self.callback == nil then
                    self:RealClose()
                elseif self.ownerBlock ~= nil and not self.ownerBlock.Running then
                    self:RealClose()
                end
            end
        else
            self:RealClose()
        end
    end
end

-- 显示npc半身像
function TalkDlg2Ctrl:ShowNpcModel()
    
    local l_npcId = self.talkMgr.GetCurrentNpcId()
    local l_row = TableUtil.GetNpcTable().GetRowById(l_npcId, true)
    if not l_row then return end

    local l_showModel = l_row.ShowModel
    if not l_showModel then return end

    if self.roleRTFeature ~= nil then
        --如果目前已经是这个npc则不再重复显示
        if self.roleRTFeature.Npc ~= nil and self.roleRTFeature.Npc.AttrNPC ~= nil and self.roleRTFeature.Npc.AttrNPC.NpcID == npcid then
            return
        end
        self.roleRTFeature:Uninit()
        self.roleRTFeature = nil
    end
    local l_width = self.panel.RoleImg.RectTransform.rect.width
    local l_height = self.panel.RoleImg.RectTransform.rect.height
    local l_offset = l_row.TalkRTOffset
    self.roleRTFeature = MUICameraRTManager:CreateNpcRTCamera(512 * 1.5, 512 * 1.5, l_npcId, Vector3.New(l_offset[0], l_offset[1], l_offset[2])):SetNeedUpdate(true)
    self.panel.RoleImg.RawImg.texture = self.roleRTFeature.RTCamera.targetTexture
    self.panel.RoleImg.gameObject:SetActiveEx(true)

    self:SetTalkName(self.isPlayer)
end

--编辑器模式下调节offset,策划配表用，无逻辑意义
function TalkDlg2Ctrl:SetNpcOffset(x, y, z)

    if Application.isEditor then
        self.roleRTFeature.Offset = Vector3.New(x, y, z)
    end
end

-- 播放npc speacial动作
function TalkDlg2Ctrl:TryShowAnim()
    
    local l_npcId = self.talkMgr.GetCurrentNpcId()
    local l_npcRow = TableUtil.GetNpcTable().GetRowById(l_npcId, true)
    if l_npcRow and l_npcRow.DialogAnim and l_npcRow.DialogAnim > 0 then
        local l_npc = MNpcMgr:FindNpcInViewport(l_npcId)
        if l_npc then
            MEventMgr:LuaFireEvent(MEventType.MEvent_Special, l_npc, ROGameLibs.kEntitySpecialType_Action, l_npcRow.DialogAnim)
        end
    end
end

-- 开始对话
function TalkDlg2Ctrl:OnStartTalk(data)

    self.ownerBlock = data.command.Block
end

-- 对话
function TalkDlg2Ctrl:OnTalkNpc(data)

    local l_command = data.command
    self.ownerBlock = data.command.Block
    self:SetCallback(function() 
        l_command:FinishCommand() 
    end)
end

-- 选中npc
function TalkDlg2Ctrl:OnNpcSelect(data)

    local l_command = data.command
    local l_isNewPlot = data.isNewPlot

    self.ownerBlock = l_command.Block

    self:SetForceSelect(l_isNewPlot or self.talkMgr.IsTalked())

    self:SetCallback(function()
        l_command:FinishCommand()
    end)

    if l_isNewPlot then
        self:Lock()
        UIMgr:ActiveUI(UI.CtrlNames.NewPlotBranch)
    end
end

-- 初始化
function TalkDlg2Ctrl:OnInitWithData(data)

    if not data then return end

    if data.commandType == self.talkMgr.ECommandType.StartTalk then
        self:OnStartTalk(data)
    elseif  data.commandType == self.talkMgr.ECommandType.TalkNpc then
        self:OnTalkNpc(data)
    elseif  data.commandType == self.talkMgr.ECommandType.NpcSelect then
        self:OnNpcSelect(data)
    end
end

-- Command选中
function TalkDlg2Ctrl:OnCommandNpcSelectForward(command, tag)

    self:SetForceSelect(false)
    if command.Block then
        command.Block:GotoTag(tag)
    end
end

-- 取消
function TalkDlg2Ctrl:OnCommandNpcSelectCancel(command)

    if command.Block then
        command.Block:Quit(false)
    end
    self:RealClose()
end

-- npc消失
function TalkDlg2Ctrl:OnNpcDisappear(npcId)

    if self:GetCurrentNpcId() == npcId then
        self:RealClose()
    end
end

-- 锁定
function TalkDlg2Ctrl:OnLockEvent(lock, notRetry)

    if lock then
        self:Lock()
    else
        if notRetry then
            self:UnlockWithoutRetry()
        else
            self:Unlock()
        end
    end
end

-- 数据更新
function TalkDlg2Ctrl:OnDataUpdate(data)

    self:OnInitWithData(data)
end

-- 关闭界面
function TalkDlg2Ctrl:RealClose()

    UIMgr:DeActiveUI(self.name)
end

-- npc销毁
function TalkDlg2Ctrl:OnNpcDestroy(npcId)

    if npcId and self.talkMgr.GetCurrentNpcId() == npcId then
        if npcId == tonumber(TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetSocialTaskNpc").Value) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LOVE_GOD_HAS_GONE"))
        end
        self:RealClose()
    end
end

function TalkDlg2Ctrl:InitArrowFx()

    if self.arrowFx then return end

    local l_effectFxData = {}
    l_effectFxData.rawImage = self.panel.Fx.RawImg
    l_effectFxData.position = Vector3.New(0, 0.4, 0)
    l_effectFxData.scaleFac = Vector3.New(3, 3, 3)
    self.panel.Fx.gameObject:SetActiveEx(false)
    l_effectFxData.loadedCallback = function(go)
        self.panel.Fx.gameObject:SetActiveEx(true)
    end
    l_effectFxData.destroyHandler = function ()
        self.arrowFx = nil
    end

    self.arrowFx = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/FX_Ui_TalkDlg2", l_effectFxData)
end

function TalkDlg2Ctrl:DestroyArrowFx()

    if self.arrowFx then
        self:DestroyUIEffect(self.arrowFx)
        self.arrowFx = nil
    end
end


function TalkDlg2Ctrl:ShowShakeAnim()
    
    MgrMgr:GetMgr("NpcTalkDlgMgr").NotifyBtnShake()
end

--NPC对话界面选项按钮点击的新手指引展示
function TalkDlg2Ctrl:ShowBeginnerGuide(guideStepInfo)
    
    local l_aimWorldPos = self.panel.SelectList.transform.position
    MgrMgr:GetMgr("BeginnerGuideMgr").SetGuideArrowForLuaBtn(self, l_aimWorldPos,
        self.panel.PanelRef.transform, guideStepInfo)
end

--lua custom scripts end
return TalkDlg2Ctrl
