--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SelectCharPanel"
require "Stage/StageMgr"
require "Data/Model/BagModel"
require "UI/Template/SelectCharHeadTemplate"
require "UI/Template/CreateCharTogTemplate"
require "UI/Template/BarberColorTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SelectCharCtrl = class("SelectCharCtrl", super)
--lua class define end

local l_mgr = MgrMgr:GetMgr("SelectRoleMgr")
local l_data = DataMgr:GetData("SelectRoleData")
local ESelectCharStep = l_data.ESelectCharStep

MaxRoleCount = 4
MaxEditTogCount = 6

local l_tweenEyeKey = "tweenEyeId"
local l_tweenHairKey = "tweenHairId"

local l_barberTables
local l_allBarberInfo

local l_dontNeedResetHairPanelPos
local l_dontNeedResetEyePanelPos

--lua functions
function SelectCharCtrl:ctor()
    super.ctor(self, CtrlNames.SelectChar, UILayer.Function, nil, ActiveType.Normal)
    -- self.selectIdx = 1
    self.curStep = 0
    self:ResetEditor()

    local l_table = TableUtil.GetBarberStyleTable().GetTable()
    self.hairIndexTable = {}
    for k, v in ipairs(l_table) do
        local l_styleId = v.BarberStyleID
        local l_barberId = v.BarberID
        local l_colorIdx = v.Colour
        if self.hairIndexTable[l_barberId] == nil then
            self.hairIndexTable[l_barberId] = {}
        end
        self.hairIndexTable[l_barberId][l_colorIdx] = l_styleId
    end

end --func end
--next--
function SelectCharCtrl:Init()
    self.panel = UI.SelectCharPanel.Bind(self)
    super.Init(self)

    self[l_tweenEyeKey] = 0
    self[l_tweenHairKey] = 0

    self.fxs = {}

    -- 进入游戏
    self.panel.BtnStartGame:AddClick(function()
        l_mgr.RequestSelectRole()
    end)
    -- 回到选择服务器界面
    self.panel.BtnReturnLogin:AddClick(function()
        log("LOGIN state=>从选择角色界面返回")
        l_data.FirstRegisterTips = true
        self:ClearTimers()
        game:GetAuthMgr():LogoutToGame()
    end)
    -- 确认创角
    self.panel.BtnVerifyChar:AddClick(function()
        self:VerifyChar()
    end)
    self.panel.BtnVerifyChar.gameObject:SetActiveEx(false)

    self.panel.BtnReturnGender:AddClick(function()
        l_data.SexSelected = -1
        if l_data.RoleInfos ~= nil and next(l_data.RoleInfos) then
            self:RefreshStep(ESelectCharStep.SelectChar)
        else
            l_data.FirstRegisterTips = true
            self:ClearTimers()
            game:GetAuthMgr():LogoutToGame()
        end
    end)

    -- 换性别
    self.panel.ButtonMale:AddClick(function()
        self:OnClickSexBtn(true)
    end)
    self.panel.ButtonFemale:AddClick(function()
        self:OnClickSexBtn(false)
    end)

    self.panel.BtnHair:AddClick(function()
        self:OnClickHairBtn()
    end)

    self.panel.BtnEye:AddClick(function()
        self:OnClickEyeBtn()
    end)

    self.panel.ButtonDelete:AddClick(function()
        self:OnClickDelete()
    end)

    self.panel.ButtonRevert:AddClick(function()
        self:OnClickResume()
    end)

    l_barberTables = TableUtil.GetBarberTable().GetTable()

    l_allBarberInfo = MgrMgr:GetMgr("BeautyShopMgr").GetAllEyeData()

    self.panel.ImageHair.RawImg.enabled = false
    self.panel.ImageEye.RawImg.enabled = false

    self.comGyro = self.uObj:GetComponent("MCreateCharGryo")

    self.oriHairPanelPos = self.panel.PanelEditHair.Transform.localPosition
    self.oriEyePanelPos = self.panel.PanelEditEye.Transform.localPosition

    self.panel.RePanel:SetActiveEx(false)
    self.panel.PanelEditHair.RectTransform.anchoredPosition = Vector2(-31.04, 31.09)
    self.panel.PanelEditEye.RectTransform.anchoredPosition = Vector2(2.14, 31.09)

    self.headTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SelectCharHeadTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.SelectCharHeadTemplate.gameObject,
    })

    self.hairTogTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.CreateCharTogTemplate,
        TemplateParent = self.panel.HairTogs.transform,
        TemplatePrefab = self.panel.CreateCharTogTemplate.gameObject,
    })

    self.eyeTogTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.CreateCharTogTemplate,
        TemplateParent = self.panel.EyeTogs.transform,
        TemplatePrefab = self.panel.CreateCharTogTemplate.gameObject,
    })

    local l_row = TableUtil.GetGlobalTable().GetRowByName("BaseSpecialTips")
    if not l_row then
        logError("Delete role fail, global表没配置BaseSpecialTips @廖萧萧")
    else
        local l_notifyLevel = tonumber(l_row.Value)
        if not l_notifyLevel then
            logError("Delete role fail, global表BaseSpecialTips配置格式错误 @廖萧萧")
        else
            self.deleteNotifyLevel = l_notifyLevel
        end
    end

    self.fmodInstance = nil
    self.lastWaitResumeUid = nil

    l_data.SexSelected = -1
    l_data.IsModifyStyle = false

    l_dontNeedResetHairPanelPos = nil
    l_dontNeedResetEyePanelPos = nil

    self.panel.EyeScrolls:SetScrollRectGameObjListener(self.panel.ImageUp1.gameObject, self.panel.ImageDown1.gameObject, nil, nil)

    self.panel.HairScrolls:SetScrollRectGameObjListener(self.panel.ImageUp2.gameObject, self.panel.ImageDown2.gameObject, nil, nil)


end --func end
--next--
function SelectCharCtrl:Uninit()

    if self[l_tweenEyeKey] and self[l_tweenEyeKey] > 0 then
        MUITweenHelper.KillTween(self[l_tweenEyeKey])
        self[l_tweenEyeKey] = 0
    end

    if self[l_tweenHairKey] and self[l_tweenHairKey] > 0 then
        MUITweenHelper.KillTween(self[l_tweenHairKey])
        self[l_tweenHairKey] = 0
    end

    if self.fxs then
        for k, v in pairs(self.fxs) do
            self:DestroyUIEffect(v)
        end
        self.fxs = nil
    end

    self:ControlStyleButton()
    self:ClearTimers()

    l_allBarberInfo = nil
    l_dontNeedResetEyePanelPos = nil
    l_dontNeedResetHairPanelPos = nil

    self.comGyro = nil

    self.oriHairPanelPos = nil
    self.oriEyePanelPos = nil
    self.deleteNotifyLevel = nil
    self.headTemplatePool = nil
    self.lastWaitResumeUid = nil
    self.eyeTogTemplatePool = nil
    self.hairTogTemplatePool = nil
    self.eyeColorTemplatePool = nil
    self.hairColorTemplatePool = nil

    self:ReleastFmod()

    super.Uninit(self)
    self.panel = nil
end --func end
--next--

function SelectCharCtrl:OnActive()
    
    MoonClient.MSceneObjectEvent.SendEvent(1)
    MoonClient.MSceneObjectEvent.SendStopEvent(1)
    
    if table.maxn(l_data.RoleInfos) > 0 then
        self.curStep = 0
    else
        self.curStep = 1
        l_data.SexSelected = -1
    end

    self:RefreshStep()

    self:InitGyro()
end --func end
--next--
function SelectCharCtrl:OnDeActive()

    local l_scroll = self.panel.HairColors.gameObject:GetComponent("UIBarberScroll")
    if l_scroll then
        l_scroll.OnValueChanged = nil
    end
    l_scroll = self.panel.EyeColorBar.gameObject:GetComponent("UIBarberScroll")
    if l_scroll then
        l_scroll.OnValueChanged = nil
    end
end --func end
--next--
function SelectCharCtrl:Update()

end --func end

--next--
function SelectCharCtrl:BindEvents()
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_SELECT_MODEL_EVENT, function(self, isMale)
        self:UpdateTogState(isMale)
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_ENTER_ANIM_EVENT, function(self, ...)
        self:OnEnterAnim(...)
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_DATA_CHANGED, function(self, ...)
        self:OnDataChanged(...)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts


function SelectCharCtrl:RefreshStep(step)

    if step ~= nil then
        self.curStep = step
    end
    self.panel.PanelSelectChar.gameObject:SetActiveEx(self.curStep == ESelectCharStep.SelectChar)
    self.panel.PanelCreateChar.gameObject:SetActiveEx(self.curStep == ESelectCharStep.CreateChar)

    if self.curStep == ESelectCharStep.CreateChar then
        MStatistics.DoStatistics(CJson.encode({
            tag = MLuaCommonHelper.Enum2Int(TagPoint.BeginCreateRole),
            status = true,
            msg = "",
            authorize = false,
            finish = false
        }))
        self:RefreshCreateCharStep()
        if l_data.RegisterResult == l_data.ERegisterResult.REGISTER_RESULT_PRE_FAILED and l_data.FirstRegisterTips
            and tonumber(TableUtil.GetGlobalTable().GetRowByName("LetsDressUpTips").Value) == 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DressHintDefault"))
        end
        self.panel.RePanel:SetActiveEx(false)
    elseif self.curStep == ESelectCharStep.SelectChar then
        MStatistics.DoStatistics(CJson.encode({
            tag = MLuaCommonHelper.Enum2Int(TagPoint.BeginSelectRole),
            status = true,
            msg = "",
            authorize = false,
            finish = false
        }))
        self:RefreshESelectCharStep()
    end
    l_data.FirstRegisterTips = false
    l_mgr.SelectStepChangeEvent(self.curStep)
    l_data.IsModifyStyle = false
end

function SelectCharCtrl:UpdateTogState(isMale)

    self:CloseEditUI()
end

function SelectCharCtrl:ControlStyleButton(show, duration)

    if self.delay_timer then
        self:StopUITimer(self.delay_timer)
        self.delay_timer = nil
    end

    if self.appear_timer then
        self:StopUITimer(self.appear_timer)
        self.appear_timer = nil
    end

    if not show then
        return
    end

    self.appear_timer = self:NewUITimer(function()

        self:CreateButtonFxForRT("button_hair1", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_07", self.panel.ImageHair1.RawImg, 1, 0, 0, 0)
        self:CreateButtonFxForRT("button_eye1", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_07", self.panel.ImageEye1.RawImg, 1, 0, 0, 0)
    end, duration - 0.7)
    self.appear_timer:Start()

    self.delay_timer = self:NewUITimer(function()
        self.panel.ObjHairButton.gameObject:SetActiveEx(true)
        self.panel.ObjEyeButton.gameObject:SetActiveEx(true)

        self:CreateButtonFxForRT("button_hair", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_04", self.panel.ImageHair.RawImg, 2.2, 0, 0, 0)
        self:CreateButtonFxForRT("button_eye", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_04", self.panel.ImageEye.RawImg, 2.2, 0, 0, 0)
        self:DelayDestroyStyleButtonAppearFx()
        if not self.panel.BtnVerifyChar.gameObject.activeSelf then
            self.panel.BtnVerifyChar.gameObject:SetActiveEx(true)
        end

        self:OnClickHairBtn()
        self:OnClickEyeBtn()
    end, duration)
    self.delay_timer:Start()
end

function SelectCharCtrl:CloseEditUI()

    self:HideStyleButtons()
    self.panel.PanelEditHair.gameObject:SetActiveEx(false)
    self.panel.PanelEditEye.gameObject:SetActiveEx(false)

    self:DestroyFxByKey("ImageEyePanel1")
    self:DestroyFxByKey("ImageEyePanel")
    self:DestroyFxByKey("ImageHairPanel1")
    self:DestroyFxByKey("ImageHairPanel")

    self.panel.ImageHair.RawImg.enabled = false
    self.panel.ImageEye.RawImg.enabled = false
end

function SelectCharCtrl:InitGyro()

    if not self.comGyro then
        return
    end

    self.comGyro.target = MScene.GameCamera.TransCam.gameObject
    self.comGyro:InitCameraInfo(0, 0, function(left, offset)
        l_mgr.ShakeEvent(left, offset, function(interval)
            if self.comGyro and interval then
                self.comGyro:SetCheckInterval(interval)
            end
        end)
    end)
end

function SelectCharCtrl:CreateButtonFxForRT(key, path, parent, scale, rotx, roty, rotz, func, posy)
    if self.fxs[key] then
        self:DestroyUIEffect(self.fxs[key])
    end

    parent.gameObject:SetActiveEx(false)

    local l_origin_data = {}
    l_origin_data.rawImage = parent
    l_origin_data.scaleFac = Vector3(scale, scale, scale)
    l_origin_data.rotation = Quaternion.Euler(rotx, roty, rotz)
    if posy then
        l_origin_data.position = Vector3(0, posy, 0)
    end
    l_origin_data.loadedCallback = function()
        if not func then
            parent.gameObject:SetActiveEx(true)
        else
            if func() then
                parent.gameObject:SetActiveEx(true)
            end
        end
    end

    self.fxs[key] = self:CreateUIEffect(path, l_origin_data)
end

function SelectCharCtrl:DestroyFxByKey(key)
    if self.fxs[key] then
        self:DestroyUIEffect(self.fxs[key])
    end

    if self.panel[key] then
        self.panel[key].RawImg.enabled = false
    end

    self.fxs[key] = nil
end

function SelectCharCtrl:DestroyFxsByKeys(keys)

    for i, v in ipairs(keys) do
        self:DestroyFxByKey(v)
    end
end

function SelectCharCtrl:OnEnterAnim(anim_length)

    self:UpdateToggleState()

    self:ControlStyleButton(true, 3)

    self:PlayEnterFmod()
end

function SelectCharCtrl:WaitAutoSelectRole()

    if self.auto_timer then
        self:StopUITimer(self.auto_timer)
        self.auto_timer = nil
    end

    self.auto_timer = self:NewUITimer(function()

        if l_data.SexSelected == -1 then
            l_data.SexSelected = 1
            l_mgr.SelectTogEvent()
            self:PlayEnterFmod()
            self:UpdateToggleState()
        end
    end, 30, -1, 1)
    self.auto_timer:Start()
end

function SelectCharCtrl:UpdateToggleState()
    if l_data.SexSelected == -1 then
        self.panel.FemaleImage1.gameObject:SetActiveEx(false)
        self.panel.FemaleImage2.gameObject:SetActiveEx(false)
        self.panel.FemaleImage3.gameObject:SetActiveEx(true)
        self.panel.MaleImage1.gameObject:SetActiveEx(false)
        self.panel.MaleImage2.gameObject:SetActiveEx(false)
        self.panel.MaleImage3.gameObject:SetActiveEx(true)
    elseif l_data.SexSelected == 0 then
        self.panel.FemaleImage1.gameObject:SetActiveEx(true)
        self.panel.FemaleImage2.gameObject:SetActiveEx(false)
        self.panel.FemaleImage3.gameObject:SetActiveEx(false)
        self.panel.MaleImage1.gameObject:SetActiveEx(false)
        self.panel.MaleImage2.gameObject:SetActiveEx(true)
        self.panel.MaleImage3.gameObject:SetActiveEx(false)
    else
        self.panel.FemaleImage1.gameObject:SetActiveEx(false)
        self.panel.FemaleImage2.gameObject:SetActiveEx(true)
        self.panel.FemaleImage3.gameObject:SetActiveEx(false)
        self.panel.MaleImage1.gameObject:SetActiveEx(true)
        self.panel.MaleImage2.gameObject:SetActiveEx(false)
        self.panel.MaleImage3.gameObject:SetActiveEx(false)
    end
end

function SelectCharCtrl:FadeAction(com)

    self.fadeAction = DOTween.Sequence()
    local l_act_move = com.RectTransform:DOAnchorPosY()
end

function SelectCharCtrl:HideStyleButtons()
    self:DestroyFxByKey("button_hair")
    self:DestroyFxByKey("button_eye")

    self:DestroyFxByKey("button_hair1")
    self:DestroyFxByKey("button_eye1")

    self.panel.ObjHairButton.gameObject:SetActiveEx(false)
    self.panel.ObjEyeButton.gameObject:SetActiveEx(false)
end

function SelectCharCtrl:DelayDestroyStyleButtonAppearFx()

    if self.appear_timer then
        self:StopUITimer(self.appear_timer)
        self.appear_timer = nil
    end

    self.appear_timer = self:NewUITimer(function()
        self:DestroyFxByKey("button_hair1")
        self:DestroyFxByKey("button_eye1")
    end, 1, -1, 1)
    self.appear_timer:Start()
end

function SelectCharCtrl:ResetEditor()

    self.selectHairIndex = 1
    self.selectHairColorIndex = 1
    self.selectEyeIndex = 1
    self.selectEyeColorIndex = 1
    self.selectEyeId = 0
    self.selectBarberId = 0
    self.selectBarberStyleId = 0
end

function SelectCharCtrl:GetHairBarberStyleId(barberId, index)

    local l_tmp = self.hairIndexTable[barberId]
    if l_tmp then
        if not l_tmp[index] then
            logError("GetHairBarberStyleId se", barberId, index)
        end
        return l_tmp[index]
    else
        logError("GetHairBarberStyleId", barberId, index)
    end
end

function SelectCharCtrl:ResetHairEditor()

    local l_config = l_data.GetCachedOrDefaultConfig(l_data.SexSelected)

    local l_barberStyleRow = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(l_config.BarberStyleID)

    local l_group = self.panel.HairTogs.TogGroup

    local l_index = 0
    local l_datas = {}
    local l_selectIndex = 0
    for i, v in ipairs(l_barberTables) do
        if v.SexLimit == l_data.SexSelected and v.UsedForCreate then
            l_index = l_index + 1
            local l_selected = l_barberStyleRow.BarberID == v.BarberID
            table.insert(l_datas, {
                id = v.BarberID,
                index = l_index,
                selected = l_selected,
                atlas = v.BarberAtlas,
                icon = v.BarberIcon,
                name = v.BarberName,
                group = l_group,
            })
            if l_selected then
                l_selectIndex = l_index
            end
        end
    end

    self.hairTogTemplatePool:ShowTemplates({ Datas = l_datas, Method = function(barberId, idx)

        local l_config = l_data.GetCachedOrDefaultConfig(l_data.SexSelected)
        local l_barberStyleRow = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(l_config.BarberStyleID)
        l_config.BarberStyleID = self:GetHairBarberStyleId(barberId, l_barberStyleRow.Colour)
        l_data.SaveCacheConfig(l_data.SexSelected, l_config)
        self:RefreshRoleHair()
    end })

    if not l_dontNeedResetHairPanelPos then
        local l_row = math.ceil(l_selectIndex / 3)
        if l_row >= 3 then
            MLuaCommonHelper.SetRectTransformPosY(self.panel.HairTogs.gameObject, 114 * (l_row - 2))
        else
            MLuaCommonHelper.SetRectTransformPosY(self.panel.HairTogs.gameObject, -1)
        end
        l_dontNeedResetHairPanelPos = true
    end

    local l_scroll = self.panel.HairColors.gameObject:GetComponent("UIBarberScroll")
    l_scroll.OnValueChanged = function(idx1)
        local l_config = l_data.GetCachedOrDefaultConfig(l_data.SexSelected)
        local l_barberStyleRow = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(l_config.BarberStyleID)
        l_config.BarberStyleID = self:GetHairBarberStyleId(l_barberStyleRow.BarberID, idx1 + 1)
        l_data.SaveCacheConfig(l_data.SexSelected, l_config)
        self:RefreshRoleHair()
    end

    local l_index = l_barberStyleRow.Colour - 1
    l_scroll.CurrentIndex = l_index

    self.panel.Notice1.gameObject:SetActiveEx(#l_datas > 6)
end

function SelectCharCtrl:RefreshRoleHair()

    local l_config = l_data.GetCachedOrDefaultConfig(l_data.SexSelected)

    l_mgr.SelectHairStyleEvent(l_config.BarberStyleID)
end

function SelectCharCtrl:ResetEyeEditor()

    local l_config = l_data.GetCachedOrDefaultConfig(l_data.SexSelected)

    local l_group = self.panel.EyeTogs.TogGroup
    local l_count = 0
    local l_datas = {}
    local l_selectIndex = 0
    for i, v in ipairs(l_allBarberInfo) do
        if v.SexLimit == l_data.SexSelected and v.UsedForCreate then
            l_count = l_count + 1
            local l_selected = v.EyeID == l_config.Eye
            table.insert(l_datas, {
                id = v.EyeID,
                index = l_count,
                selected = l_selected,
                atlas = v.EyeAtlas,
                icon = v.EyeIcon,
                name = v.EyeName,
                group = l_group,
            })
            if l_selected then
                l_selectIndex = l_count
            end
        end
    end

    self.eyeTogTemplatePool:ShowTemplates({ Datas = l_datas, Method = function(eyeId, idx)
        local l_config = l_data.GetCachedOrDefaultConfig(l_data.SexSelected)
        l_config.Eye = eyeId
        l_data.SaveCacheConfig(l_data.SexSelected, l_config)

        self:RefreshRoleEye()
    end })

    if not l_dontNeedResetEyePanelPos then
        local l_row = math.ceil(l_selectIndex / 3)
        if l_row >= 3 then
            MLuaCommonHelper.SetRectTransformPosY(self.panel.EyeTogs.gameObject, 114 * (l_row - 2))
        else
            MLuaCommonHelper.SetRectTransformPosY(self.panel.EyeTogs.gameObject, -1)
        end
        l_dontNeedResetEyePanelPos = true
    end

    local l_scroll = self.panel.EyeColorBar.gameObject:GetComponent("UIBarberScroll")
    l_scroll.OnValueChanged = function(idx)
        l_config.EyeColor = idx + 1
        l_data.SaveCacheConfig(l_data.SexSelected, l_config)

        self:RefreshRoleEye()
    end
    local l_index = l_config.EyeColor - 1
    l_scroll.CurrentIndex = l_index

    self.panel.Notice2.gameObject:SetActiveEx(#l_datas > 6)

end

function SelectCharCtrl:RefreshRoleEye()

    local l_config = l_data.GetCachedOrDefaultConfig(l_data.SexSelected)
    l_mgr.SelectEyeStyleEvent(l_config.Eye, l_config.EyeColor)
end

function SelectCharCtrl:DoTweenHair(show, force, callBack)

    self:CustomDoTween(l_tweenHairKey, self.panel.PanelEditHair.gameObject, self.oriHairPanelPos.x + 80, self.oriHairPanelPos.x, show, force, callBack)
end

function SelectCharCtrl:DoTweenEye(show, force, callBack)

    self:CustomDoTween(l_tweenEyeKey, self.panel.PanelEditEye.gameObject, self.oriEyePanelPos.x - 80, self.oriEyePanelPos.x, show, force, callBack)
end

function SelectCharCtrl:CustomDoTween(key, go, from_x, to_x, show, force, callback)
    self[key] = self[key] or 0
    if force then
        if self[key] > 0 then
            MUITweenHelper.KillTween(self[key])
            self[key] = 0
        end
    end

    if self[key] > 0 then
        log("need finish last tween")
        return
    end

    local l_from_pos, l_desc_pos = Vector3(from_x, 0, 0), Vector3(to_x, 0, 0)
    local l_from_alpha, l_to_alpha = 0, 1
    if show then
    else
        l_from_pos, l_desc_pos = l_desc_pos, l_from_pos
        l_from_alpha, l_to_alpha = l_to_alpha, l_from_alpha
    end

    self[key] = MUITweenHelper.TweenPosAlpha(go, l_from_pos, l_desc_pos, l_from_alpha, l_to_alpha, 0.5, function()
        self[key] = 0
        if not show then
            go:SetActiveEx(false)
        end
        if callback then
            callback()
        end
    end)
end

-- 确认创角
function SelectCharCtrl:VerifyChar()

    if l_data.SexSelected == -1 then
        logError("选择性别")
        return
    end

    if l_mgr.CreateCharCount and l_mgr.CreateCharCount > 0 then
        l_mgr.RequestSelectRole()
        return
    end

    l_mgr.roleName = ""
    l_mgr.roleProId = 1000

    local l_config = l_data.GetCachedOrDefaultConfig(l_data.SexSelected)

    l_mgr.RequestCreateRoleNew(l_config.BarberStyleID, l_config.Eye, l_config.EyeColor)
end

function SelectCharCtrl:OnClickSexBtn(isMale)

    local l_hasChange = false

    if (isMale and l_data.SexSelected ~= 0) or ((not isMale) and l_data.SexSelected ~= 1) then
        l_hasChange = true
        l_dontNeedResetHairPanelPos = nil
        l_dontNeedResetEyePanelPos = nil
    end

    if l_hasChange then
        l_data.SexSelected = isMale and 0 or 1
        l_mgr.SelectTogEvent()

        self:PlayEnterFmod()

        self:CloseEditUI()
        self:UpdateToggleState()
        self:HideStyleButtons()
    end
end

function SelectCharCtrl:OnClickHairBtn()

    if self.panel.PanelEditHair.gameObject.activeSelf then
        self:DoTweenHair(false)
        self.panel.ImageHair.RawImg.enabled = false
        self:DestroyFxsByKeys({ "ImageHairPanel1", "button_hair", "ImageHairPanel" })
        self:CreateButtonFxForRT("button_hair", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_04", self.panel.ImageHair.RawImg, 2.2, 0, 0, 0)
        l_data.IsModifyStyle = self.panel.PanelEditEye.gameObject.activeSelf
    else
        self.panel.PanelEditHair.gameObject:SetActiveEx(true)
        self:ResetHairEditor()
        self:DoTweenHair(true, false, function()
            self:CreateButtonFxForRT("ImageHairPanel1", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_03", self.panel.ImageHairPanel1.RawImg, 18, -90, 0, 0)
        end)
        self:CreateButtonFxForRT("button_hair", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_02", self.panel.ImageHair.RawImg, 2.2, 0, 0, 0)
        self:CreateButtonFxForRT("ImageHairPanel", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_01", self.panel.ImageHairPanel.RawImg, 18, 0, 0, 0)
        self.panel.ImageHair.RawImg.enabled = true
        l_data.IsModifyStyle = true
    end
end

function SelectCharCtrl:OnClickEyeBtn()

    if self.panel.PanelEditEye.gameObject.activeSelf then
        self:DoTweenEye(false)
        self.panel.ImageEye.RawImg.enabled = false
        self:DestroyFxsByKeys({ "ImageEyePanel1", "button_eye", "ImageEyePanel" })
        self:CreateButtonFxForRT("button_eye", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_04", self.panel.ImageEye.RawImg, 2.2, 0, 0, 0)
        l_data.IsModifyStyle = self.panel.PanelEditHair.gameObject.activeSelf
    else
        self.panel.PanelEditEye.gameObject:SetActiveEx(true)
        self:ResetEyeEditor()
        self:DoTweenEye(true, false, function()
            self:CreateButtonFxForRT("ImageEyePanel1", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_03", self.panel.ImageEyePanel1.RawImg, 18, -90, 0, 0)
        end)
        self:CreateButtonFxForRT("button_eye", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_02", self.panel.ImageEye.RawImg, 2.2, 0, 0, 0)
        self:CreateButtonFxForRT("ImageEyePanel", "Effects/Prefabs/Creature/Ui/Fx_Ui_Role_01", self.panel.ImageEyePanel.RawImg, 18, 0, 0, 0)
        self.panel.ImageEye.RawImg.enabled = true
        l_data.IsModifyStyle = true
    end
end

-- 清理Timer
function SelectCharCtrl:ClearTimers()

    if self.wait_enter_timer then
        self:StopUITimer(self.wait_enter_timer)
        self.wait_enter_timer = nil
    end

    if self.auto_timer then
        self:StopUITimer(self.auto_timer)
        self.auto_timer = nil
    end

    if self.appear_timer then
        self:StopUITimer(self.appear_timer)
        self.appear_timer = nil
    end

    if self.wait_action_timer then
        self:StopUITimer(self.wait_action_timer)
        self.wait_action_timer = nil
    end

    if self.delay_timer then
        self:StopUITimer(self.delay_timer)
        self.delay_timer = nil
    end
end

-- 刷新创角
function SelectCharCtrl:RefreshCreateCharStep()
    l_mgr.ClearCreateCharCount()

    self:ClearTimers()

    self:HideStyleButtons()
    self:WaitAutoSelectRole()
    self:UpdateToggleState()

    self:UpdateColorSelect()

    self.panel.PanelEditHair.gameObject:SetActiveEx(false)
    self.panel.PanelEditEye.gameObject:SetActiveEx(false)
    self.panel.BtnVerifyChar.gameObject:SetActiveEx(false)
    self:DestroyFxsByKeys({ "ImageHairPanel1", "ImageHairPanel", "ImageEyePanel1", "ImageEyePanel" })
end

-- 刷新选角
function SelectCharCtrl:RefreshESelectCharStep()

    self:ClearTimers()

    self:ReleastFmod()

    local l_roleCount = 0
    local l_headsData = {}
    local l_selectIndex
    for i = 1, table.maxn(l_data.RoleInfos) do
        if l_roleCount >= MaxRoleCount then
            break
        end
        if l_data.RoleInfos[i] then
            l_roleCount = l_roleCount + 1
            table.insert(l_headsData, {
                roleIndex = i,
                selected = l_data.RoleSelectedIndex == i,
                roleInfo = l_data.RoleInfos[i],
                index = l_roleCount
            })

            if l_data.RoleSelectedIndex == i then
                l_selectIndex = l_roleCount
            end
        end
    end

    self:UpdateSelectRoleInfo(l_selectIndex)

    if l_roleCount < MaxRoleCount then
        table.insert(l_headsData, { empty = true })
    end
    self.headTemplatePool:ShowTemplates({ Datas = l_headsData, Method = function(...)
        self:OnHeadTogSelected(...)
    end })

    if l_roleCount <= 0 then
        self.panel.ButtonDelete.gameObject:SetActiveEx(false)
    else
        local l_flag = true
        local l_roleInfo = l_data.RoleInfos[l_data.RoleSelectedIndex]
        if l_roleInfo and l_roleInfo.status == RoleStatusType.Role_Status_Deleting then
            l_flag = false
        end
        self.panel.ButtonDelete.gameObject:SetActiveEx(l_flag)
    end
end

-- 玩家头像点击事件
function SelectCharCtrl:OnHeadTogSelected(empty, roleIndex, index)
    if empty then
        local l_createRoleCount = DataMgr:GetData("SelectRoleData").GetCreateRoleCount()
        if l_createRoleCount >= 20 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CREATE_ROLE_MAX"))
            return
        end

        l_data.SexSelected = -1
        l_dontNeedResetEyePanelPos = nil
        l_dontNeedResetHairPanelPos = nil
        self:RefreshStep(ESelectCharStep.CreateChar)
    else
        l_data.RoleSelectedIndex = roleIndex
        self:UpdateSelectRoleInfo(index)
        l_mgr.ChangeRoleEvent()

        local items = self.headTemplatePool:GetItems()
        for i, v in ipairs(items) do
            v:UpdateCurInfo(i == index)
        end
    end
end

-- 更新玩家信息
function SelectCharCtrl:UpdateSelectRoleInfo(index)

    local l_roleInfo = l_data.RoleInfos[l_data.RoleSelectedIndex]
    if not l_roleInfo then
        logError("SelectCharCtrl:UpdateSelectRoleInfo() fail, 找不到数据", l_data.RoleSelectedIndex)
        return
    end

    if l_roleInfo.status == RoleStatusType.Role_Status_Deleting then
        self.panel.ButtonRevert.gameObject:SetActiveEx(true)
        self.panel.BtnStartGame.gameObject:SetActiveEx(false)
        self.panel.ButtonDelete.gameObject:SetActiveEx(false)
    else
        self.panel.ButtonRevert.gameObject:SetActiveEx(false)
        self.panel.BtnStartGame.gameObject:SetActiveEx(true)
        self.panel.ButtonDelete.gameObject:SetActiveEx(true)
    end
    self.panel.RePanel:SetActiveEx(l_data.RegisterResult == l_data.ERegisterResult.REGISTER_RESULT_PRE_SUCCESS
            and tonumber(TableUtil.GetGlobalTable().GetRowByName("LetsDressUpTips").Value) == 1
            and index == 1 and l_roleInfo.level <= 1)
    self.panel.ReText.LabText = Lang("DressHint")

end

function SelectCharCtrl:FirstStepConfirm(txt)

    local l_roleInfo = l_data.RoleInfos[l_data.RoleSelectedIndex]
    CommonUI.Dialog.ShowDeleteDlg(Lang("DELETE_CHAR_NOTIFY_FORMAT", txt), l_roleInfo, function()
        self:SecondStepConfirm()
    end)
end

function SelectCharCtrl:SecondStepConfirm()

    local l_roleInfo = l_data.RoleInfos[l_data.RoleSelectedIndex]
    local l_desc
    if l_roleInfo.level < self.deleteNotifyLevel then
        l_desc = Lang("ENSURE_DELETE_CHAR_DESC1", self.deleteNotifyLevel, Lang("DELETE_CHAR"))
    else
        local l_timeStr
        local l_totalCountTime = MGlobalConfig:GetFloat("DeleteCountdown") + 2
        local l_hour = math.floor(l_totalCountTime / 3600)
        if l_hour > 0 then
            l_timeStr = StringEx.Format("{0}{1}", l_hour, Lang("HOURS"))
        else
            local l_min = math.floor(l_totalCountTime / 60)
            if l_min > 0 then
                l_timeStr = StringEx.Format("{0}{1}", l_min, Lang("MINUTE"))
            else
                l_timeStr = StringEx.Format("{0}{1}", l_totalCountTime, Lang("SECOND"))
            end
        end
        l_desc = Lang("ENSURE_DELETE_CHAR_DESC2", self.deleteNotifyLevel, l_timeStr, Lang("DELETE_CHAR"))
    end

    CommonUI.Dialog.ShowDeleteDlg(l_desc, l_roleInfo, function()
        self:ThirdStepConfirm(l_roleInfo.roleID)
    end, nil, Lang("DELETE_IMMEDIATELY"))
end

function SelectCharCtrl:ThirdStepConfirm(roleID)

    local l_createRoleCount = DataMgr:GetData("SelectRoleData").GetCreateRoleCount()
    if l_createRoleCount < 20 then
        l_mgr.DeleteRole(roleID)
    else
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("NOT_SUGGEST_DELETE_ROLE"), function()
            l_mgr.DeleteRole(roleID)
        end)
    end
end

-- 点击删除角色按钮
function SelectCharCtrl:OnClickDelete()

    if not self.deleteNotifyLevel then
        logError("self.deleteNotifyLevel未能初始化")
        return
    end

    local l_roleInfo = l_data.RoleInfos[l_data.RoleSelectedIndex]
    if not l_roleInfo then
        logError("Delete role fail, 未知错误")
        return
    end

    -- 小于M级，直接进入确认界面
    if l_roleInfo.level < self.deleteNotifyLevel then
        self:SecondStepConfirm()
        return
    end

    -- 判断角色是否唯一
    local l_roleCount, l_maxLevel = self:GetAccountRoleCountAndMaxLevel()
    if l_roleCount <= 1 then
        self:FirstStepConfirm(Lang("UNIQUE"))
    else
        -- 如果是最高等级角色
        if l_roleInfo.level == l_maxLevel then
            self:FirstStepConfirm(Lang("LEVEL_MAX"))
        else
            self:SecondStepConfirm()
        end
    end
end

function SelectCharCtrl:GetAccountRoleCountAndMaxLevel()

    local l_roleCount = 0
    local l_maxLevel = -1
    for k, v in pairs(l_data.RoleInfos) do
        l_roleCount = l_roleCount + 1
        if v.level > l_maxLevel then
            l_maxLevel = v.level
        end
    end

    return l_roleCount, l_maxLevel
end

function SelectCharCtrl:OnClickResume()

    local l_roleInfo = l_data.RoleInfos[l_data.RoleSelectedIndex]
    if not l_roleInfo then
        logError("Delete role fail, 未知错误")
        return
    end

    self.lastWaitResumeUid = l_roleInfo.roleID

    CommonUI.Dialog.ShowDeleteDlg(Lang("RESUME_ROLE"), l_roleInfo, function()
        l_mgr.ResumeRole(l_roleInfo.roleID, l_roleInfo.role_index)
        self.lastWaitResumeUid = nil
    end, function()
        self.lastWaitResumeUid = nil
    end)
end

function SelectCharCtrl:OnDataChanged(...)

    if self.lastWaitResumeUid ~= nil then
        if not l_data.RoleInfos[self.lastWaitResumeUid] then
            if UIMgr:IsActiveUI(UI.CtrlNames.DialogDeleteChar) then
                UIMgr:DeActiveUI(UI.CtrlNames.DialogDeleteChar)
            end
            self.lastWaitResumeUid = nil
        end
    end

    if next(l_data.RoleInfos) then
        self:RefreshStep()
    else
        self:RefreshStep(ESelectCharStep.CreateChar)
    end
end

function SelectCharCtrl:PlayEnterFmod()

    self:ReleastFmod()

    if l_data.SexSelected == l_data.MALE then
        self.fmodInstance = MAudioMgr:StartFModInstance("event:/CutScene/SelectMale")
    elseif l_data.SexSelected == l_data.FEMALE then
        self.fmodInstance = MAudioMgr:StartFModInstance("event:/CutScene/SelectFemale")
    end
end

function SelectCharCtrl:ReleastFmod()
    if self.fmodInstance then
        MAudioMgr:StopFModInstance(self.fmodInstance)
        self.fmodInstance = nil
    end
end

function SelectCharCtrl:UpdateColorSelect()
    if not self.eyeColorTemplatePool then
        self.eyeColorTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.BarberColorTemplate,
            TemplateParent = self.panel.EyeColorBar.transform,
            TemplatePrefab = self.panel.BarberColorTemplate.gameObject,
        })
        local l_datas = {1, 2, 3, 10, 17, 7, 16, 5, 15, 16}
        local l_result = {}
        for i, v in ipairs(l_datas) do
            table.insert(l_result, {
                index = i,
                colorIndex = v,
            })
        end
        self.eyeColorTemplatePool:ShowTemplates({ Datas = l_result })
    end

    if not self.hairColorTemplatePool then
        self.hairColorTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.BarberColorTemplate,
            TemplateParent = self.panel.HairColors.transform,
            TemplatePrefab = self.panel.BarberColorTemplate.gameObject,
        })
        local l_datas = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
        local l_result = {}
        for i, v in ipairs(l_datas) do
            table.insert(l_result, {
                index = i,
                colorIndex = v,
            })
        end
        self.hairColorTemplatePool:ShowTemplates({ Datas = l_result })
    end
end

--lua custom scripts end
return SelectCharCtrl