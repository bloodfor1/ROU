module("Stage", package.seeall)

require "Stage/StageBase"

local super = Stage.StageBase
StageSelectChar = class("StageSelectChar", super)

local l_sceneEnterData = DataMgr:GetData("SceneEnterData")
local string_format = StringEx.Format
local l_stepEnum                            -- 显示类型(0:选角  1:创角)
local l_mgr                                 -- mgr
local l_curSexSelected = -1                 -- 选角性别(-1:无选择 0:男 1:女)
local l_createRoleCache = {}                -- 创角角色缓存
local l_currentStep                         -- 当前显示类型(0:选角  1:创角)
local l_canOpTime = 0                       -- 内部事件处理间隔
local l_roleEntitys = {}                    -- 选角entity
local l_baoziEntity
local l_data

local l_vignetteIntensity = 0.6
local l_vignetteSmoothness = 1
local l_vignetteRoundness = 0
local l_vignetteTotalTime = 1
local l_dofFocalDistance = 7
local l_dofBlurScale = 500
local l_dofBlurTotalTime = 1

local fashionType = GameEnum.EFashionType
-- 时装部位互斥表
local C_REPLACE_FASHION_TYPE = {
    [fashionType.Back] = fashionType.Tail,
    [fashionType.Tail] = fashionType.Back,
}

function StageSelectChar:ctor()
    super.ctor(self, MStageEnum.SelectChar)
end

function StageSelectChar:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)

    require "create_char_config"
    
    l_mgr = MgrMgr:GetMgr("SelectRoleMgr")
    l_data = DataMgr:GetData("SelectRoleData")
    
    self:SetCameraByConfig()
    
    l_stepEnum = l_data.ESelectCharStep

    l_curSexSelected = -1
    l_canOpTime = 0
    l_currentStep = nil
    l_roleEntitys = {}
    self.firstPlay = true
    l_data.RersetCachedConfig()

    self.delayInitTimers = {}

    l_mgr.EventDispatcher:Add(l_mgr.ON_SELECT_STEP_CHANGE_EVENT, function(self, step)
        self:RefreshStep(step)
    end, self)

    l_mgr.EventDispatcher:Add(l_mgr.ON_SELECT_TOG_EVENT, function(self)
        self:OnClickEntityModel()
    end, self)

    l_mgr.EventDispatcher:Add(l_mgr.SELECT_HAIR_STYLE_EVENT, function(self, hair)
        self:ChangeHairStyle(hair)
    end, self)

    l_mgr.EventDispatcher:Add(l_mgr.SELECT_EYE_STYLE_EVENT, function(self, eye, color)
        self:ChangeEyeStyle(eye, color)
    end, self)

    l_mgr.EventDispatcher:Add(l_mgr.SHAKE_EVENT, function(self, left, heavy, callback)
        self:OnShakeEvent(left, heavy, callback)
    end, self)

    l_mgr.EventDispatcher:Add(l_mgr.CHANGE_ROLE, function(self)
        self:UpdateRoleEntities()
    end, self)

    l_mgr.EventDispatcher:Add(l_mgr.ON_DATA_CHANGED, function(self)
        self:OnDataChanged()
    end, self)

    self.underShakeAnim = false

    self:InitNpcEntitys()

end

-- 加载场景界面
function StageSelectChar:InitMainPanel(sceneId)
    super.InitMainPanel(self, sceneId)
    --lua
    l_sceneEnterData.InsertDataToEnterScenePanels(UI.CtrlNames.SelectChar)
end

function StageSelectChar:OnLeaveStage()
    super.OnLeaveStage(self)
    self:ClearAll()

    l_mgr.EventDispatcher:RemoveObjectAllFunc(l_mgr.ON_SELECT_STEP_CHANGE_EVENT, self)
    l_mgr.EventDispatcher:RemoveObjectAllFunc(l_mgr.ON_SELECT_TOG_EVENT, self)
    l_mgr.EventDispatcher:RemoveObjectAllFunc(l_mgr.SELECT_HAIR_STYLE_EVENT, self)
    l_mgr.EventDispatcher:RemoveObjectAllFunc(l_mgr.SELECT_EYE_STYLE_EVENT, self)
    l_mgr.EventDispatcher:RemoveObjectAllFunc(l_mgr.SHAKE_EVENT, self)
    l_mgr.EventDispatcher:RemoveObjectAllFunc(l_mgr.CHANGE_ROLE, self)
    l_mgr.EventDispatcher:RemoveObjectAllFunc(l_mgr.ON_DATA_CHANGED, self)

    self.underShakeAnim = false

end

function StageSelectChar:OnEnterScene(sceneId)
    super.OnEnterScene(self, sceneId)

    MEventMgr:LuaFireEvent(MEventType.MEvent_CameraSetFovImmediately, MScene.GameCamera, MoonClient.MCameraState.SelectChar, 35);
end

--[[
    @Description:创建MRole
    @param id uid
    @param name 名字
    @param sex 性别
    @param proId 职业
    @param config 配置(create_char_config)
    @param click 点击回调
    @param drag 拖动回调
    @param forCreateChar 为创角(添加特殊组件)
    @Return entity
]]
function StageSelectChar:CreateRole(id, name, sex, proId, config, click, drag, forCreateChar)

    local l_attr = MAttrMgr:InitRoleAttr(id, name, proId, sex == 0)
    local l_pos = Vector3.New(config.pos[1], config.pos[2], config.pos[3])
    local l_rot = Quaternion.Euler(config.rot[1], config.rot[2], config.rot[3])
    local l_entity = MEntityMgr:CreateEntity(l_attr, l_pos, l_rot, true)
    l_entity.Model.FollowShadowPoint = true
    l_entity.Model:AddLoadGoCallback(function(go)
        if forCreateChar then
            MLuaClientHelper.AddEntityColliderAdapter(go)
        end
        self:AttachListener2Entity(l_entity, go, sex, click, drag)
        if config.scaleFac then
            l_entity.Model.Scale = Vector3.New(config.scaleFac, config.scaleFac, config.scaleFac)
            l_entity.Model.LocalRotation = l_rot
            l_entity.Model.Position = l_pos
        end

        if forCreateChar and sex == 0 then
            local l_tbl = {}
            local l_baoziConfig = CreateCharConfig.BaoZiConfig
            self:InitOneEntity(l_baoziConfig, l_tbl, function(entity)
                l_baoziEntity = l_tbl[l_baoziConfig.key]
            end)
        end
    end)

    l_entity.Model:AddResetGoCallback(function(go)
        MLuaUIListener.Destroy(go)
        if forCreateChar then
            MLuaClientHelper.RemoveEntityColliderAdapter(l_entity.Model.UObj)
        end
        l_entity.Model.ColCenter = Vector3(0, 1, 0)
    end)

    return l_entity
end

-- 清理
function StageSelectChar:ClearAll()

    for k, v in pairs(l_createRoleCache) do
        if v.timer then
            v.timer:Stop()
            v.timer = nil
        end
    end

    l_createRoleCache = {}

    l_roleEntitys = nil

    if l_baoziEntity and l_baoziEntity.timer then
        l_baoziEntity.timer:Stop()
        l_baoziEntity.timer = nil
    end

    l_baoziEntity = nil

    if self.npcEntities then
        for k, v in pairs(self.npcEntities) do
            if v.timer then
                v.timer:Stop()
                v.timer = nil
            end
        end
    end
    self.npcEntities = {}

    if self.currentFxId then
        MFxMgr:DestroyFx(self.currentFxId)
        self.currentFxId = nil
    end

    l_canOpTime = 0

    if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end

    if self.delayInitTimers then
        for k, v in pairs(self.delayInitTimers) do
            v:Stop()
        end
        self.delayInitTimers = {}
    end

    if self.shakeTween then
        self.shakeTween:Kill()
        self.shakeTween = nil
    end

    if self.moveTween then
        self.moveTween:Kill()
        self.moveTween = nil
    end

	if self.dofTween then
		self.dofTween:Kill()
		self.dofTween = nil
	end

	if self.vignetteTween then
		self.vignetteTween:Kill()
		self.vignetteTween = nil
	end

    self.firstPlay = nil

    l_data.RersetCachedConfig()
end

-- 隐藏创角玩家entity和装饰物entity
function StageSelectChar:HideAllFakeEntities()

    for k, v in pairs(l_createRoleCache) do
        v.entity.IsVisible = false
    end

    if l_baoziEntity then
        l_baoziEntity.entity.IsVisible = false
    end

    self:StopAllAnim()
end

function StageSelectChar:GetFirstRoleEntity()

    local l_key, l_value = next(l_roleEntitys or {})

    return l_value
end

-- 显示类型刷新
function StageSelectChar:RefreshStep(step)

    if l_currentStep == step then
        log("Same Step", step)
        return
    end
    l_currentStep = step
    switch(step) {
        [l_stepEnum.SelectChar] = function()
            self:HideAllFakeEntities()
            l_data.RersetCachedConfig()
            self:UpdateRoleEntities()

            self:MoveCamera("Select", false, self:GetFirstRoleEntity())
        end,
        [l_stepEnum.CreateChar] = function()
            l_curSexSelected = l_data.SexSelected

            self:UpdateOneEntity(l_data.MALE)
            self:UpdateOneEntity(l_data.FEMALE)
            self:UpdateRoleEntities(true)

            if l_baoziEntity then
                l_baoziEntity.entity.IsVisible = true
                l_baoziEntity.entity:OverrideAnim("Idle", l_baoziEntity.config.idleAnim)
                l_baoziEntity.entity.Model.Ator:Play("Idle", 0)
                self:RoundSwitchAnimation(l_baoziEntity, l_baoziEntity.config.idleAnim, 2, l_baoziEntity.config.idleSpecialAnim, 1)
            end

            self:MoveCamera("None", false, self:GetSelectedEntity())
        end,
    }
end

-- 更新单个创角角色entity
function StageSelectChar:UpdateOneEntity(sex)

    local l_config = CreateCharConfig.GetRoleConfig(sex)
    local l_key = string_format("SelectChar_{0}", sex)
    if l_createRoleCache[sex] then
        local l_entity = l_createRoleCache[sex].entity
        l_entity.IsVisible = true
        l_entity.Position = Vector3(l_config.pos[1], l_config.pos[2], l_config.pos[3])
        l_entity.Rotation = Quaternion.Euler(l_config.rot[1], l_config.rot[2], l_config.rot[3])

        local l_styleConfig = l_data.GetCachedOrDefaultConfig(sex)
        l_entity.AttrComp:SetHair(l_styleConfig.BarberStyleID)
        l_entity.AttrComp:SetEye(l_styleConfig.Eye)
        l_entity.AttrComp:SetEyeColor(l_styleConfig.EyeColor)
        self:SetDefaultAnim(sex)
    else
        local l_entity = self:CreateRole(MUIModelManagerEx:GetTempUID(), l_key, sex, l_config.pro_id, l_config, function(_, sex)
            if l_data.SexSelected == -1 or (l_curSexSelected ~= sex) then
                l_mgr.SelectModelEvent(sex)
                l_data.SexSelected = sex
                self:OnClickEntityModel()
                return
            end
            if l_canOpTime > Time.time then
                return
            end
            self:OnClickEntityModel()
        end, function(entity, sex, delta)
            if entity.Model.Trans and l_curSexSelected == sex then
                if l_canOpTime > Time.time then
                    return
                end
                entity.Model.Trans:Rotate(Vector3.New(0, delta, 0))
            end
        end, true)

        l_createRoleCache[sex] = {
            config = l_config,
            entity = l_entity,
        }

        self:SetDefaultAnim(sex)
    end
end


-- 创角entity点击处理
function StageSelectChar:OnFakeEntityClick()
end

-- 播放表情
function StageSelectChar:PlayExpression(id, entity)

    if self.currentFxId then
        MFxMgr:DestroyFx(self.currentFxId)
        self.currentFxId = nil
    end

    local l_originData = MFxMgr:GetDataFromPool()
    local l_offset = CreateCharConfig.ROLE_EXPRESSION_OFFSET
    l_originData.position = Vector3(l_offset[1], l_offset[2], l_offset[3])
    local l_scale = CreateCharConfig.ROLE_EXPRESSION_SCALE
    l_originData.scaleFac = Vector3(l_scale, l_scale, l_scale)
    l_originData.playTime = 2
    self.currentFxId = entity.VehicleOrModel:CreateFx(id, EModelBone.ERoot, l_originData)

    MFxMgr:ReturnDataToPool(l_originData)
end

-- 入场动画
function StageSelectChar:DoEnterAnim()

    local l_cache = l_createRoleCache[l_data.SexSelected]
    if not l_cache then
        logError("null l_entity")
        return
    end
    local l_sex = l_data.SexSelected
    local l_animation = l_cache.config.animation

    self:StopAllAnim(l_sex)

    if self.currentFxId then
        MFxMgr:DestroyFx(self.currentFxId)
        self.currentFxId = nil
    end

    if l_cache.timer then
        l_cache.timer:Stop()
        l_cache.timer = nil
    end

    local l_animator = l_cache.entity.Model.Ator
    local l_animClip = l_cache.entity:OverrideAnim("Special", l_animation.Enter[1])
    l_animator:Play("Special", 0)
    l_canOpTime = l_animClip.Length + Time.time
    if l_sex == 0 then
        if l_baoziEntity then
            if l_baoziEntity.timer then
                l_baoziEntity.timer:Stop()
                l_baoziEntity.timer = nil
            end
            l_baoziEntity.entity:OverrideAnim("Idle", l_baoziEntity.config.standAnim)
            l_baoziEntity.entity.Model.Ator:Play("Idle", 0)
        end
    end

    local l_enterAnimTime = l_animClip.Length * l_animation.Enter[2]

    -- 入场动画播放完后切换idle
    self:WaitToIdle(function()

        l_cache.entity:OverrideAnim("Idle", l_animation.Stand[1])
        l_animator:Play("Idle", 0)
        self:RoundSwitchAnimation(l_cache, l_animation.Stand[1], l_animation.Stand[2], l_animation.SpecialStand[1], l_animation.SpecialStand[2])
        l_canOpTime = 0

    end, l_enterAnimTime)

    l_mgr.DoEnterAnim(l_enterAnimTime)

    self:MoveCamera(l_sex == 0 and "Male" or "Famele", false, self:GetSelectedEntity())
end

-- 点击entity事件处理
function StageSelectChar:OnClickEntityModel()

    if l_currentStep ~= l_stepEnum.CreateChar then
        logError("CurrentStep not create char")
        return
    end

    local l_temp = l_curSexSelected
    l_curSexSelected = l_data.SexSelected
    if l_temp == l_data.SexSelected then
        if l_temp ~= -1 then
            self:OnFakeEntityClick()
        end
        return
    end

    self:DoEnterAnim()
end

-- 停止所有动画
function StageSelectChar:StopAllAnim(selectSex)

    for k, v in pairs(l_createRoleCache) do
        if v.entity and k ~= selectSex then
            local l_animator = v.entity.Model.Ator

            self:SetDefaultAnim(k, selectSex)
            v.entity.Rotation = Quaternion.Euler(0, v.config.rot[2], 0)

            local l_config = l_data.GetCachedOrDefaultConfig(k)
            v.entity.AttrComp:SetEye(l_config.Eye)
            v.entity.AttrComp:SetEyeColor(l_config.EyeColor)
            v.entity.AttrComp:SetHair(l_config.BarberStyleID)
        end
    end

    if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end

    self.underShakeAnim = false

    if l_baoziEntity then
        l_baoziEntity.entity:OverrideAnim("Idle", l_baoziEntity.config.idleAnim)
        l_baoziEntity.entity.Model.Ator:Play("Idle", 0)

        self:RoundSwitchAnimation(l_baoziEntity, l_baoziEntity.config.idleAnim, 2, l_baoziEntity.config.idleSpecialAnim, 1)
    end
end

-- 获取创角entity
function StageSelectChar:GetSelectedEntity()

    local l_cached = l_createRoleCache[l_data.SexSelected]
    if not l_cached then
        return
    end

    return l_cached.entity, l_cached.config
end

-- 修改角色发型
function StageSelectChar:ChangeHairStyle(hair)

    local l_entity = self:GetSelectedEntity()
    if not l_entity then
        return
    end
    l_entity.AttrComp:SetHair(hair)
end

-- 修改角色美瞳
function StageSelectChar:ChangeEyeStyle(eye, color)

    local l_entity = self:GetSelectedEntity()
    if not l_entity then
        return
    end

    if Time.time < l_canOpTime then
        return
    end

    l_entity.AttrComp:SetEye(eye)
    l_entity.AttrComp:SetEyeColor(color)
end

-- 获取特殊动作的时长
function StageSelectChar:GetAnimTimeByActionId(action_id)
    local l_row = TableUtil.GetAnimationTable().GetRowByID(action_id)
    if not l_row then
        logError("cannot find AnimationTable", action_id)
        return 0
    end

    if l_row.MaxTime < 0 then
        return CreateCharConfig.ROLE_EXPRESSION_OFFSET
    end

    return l_row.MaxTime
end

-- 设置相机默认位置
function StageSelectChar:SetCameraByConfig(config)

    self:MoveCamera("Select", true, self:GetFirstRoleEntity())

    if not l_mgr.ForceUpdateCameraPosWhenStageEnter then return end

    l_mgr.ForceUpdateCameraPosWhenStageEnter = false

    if MScene.GameCamera and MScene.GameCamera.UCam then
        local l_key
        if l_data.RoleInfos ~= nil and next(l_data.RoleInfos) then
            l_key = "Select"
        else
            l_key = "None"
        end
        local l_config = CreateCharConfig.CameraFocusConfig[l_key] 
        if l_config then
            MLuaCommonHelper.SetLocalPos(MScene.GameCamera.UCam.gameObject, l_config[1][1], l_config[1][2], l_config[1][3])
            MLuaCommonHelper.SetLocalRotEuler(MScene.GameCamera.UCam.gameObject, l_config[2][1], l_config[2][2], l_config[2][3])
        end
    end
    
end

-- 延时函数
function StageSelectChar:WaitToIdle(func, duration)

    if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end

    self.delayTimer = Timer.New(func, duration)
    self.delayTimer:Start()
end

--[[
    @Description: 晃动回调
    @Param: left 左晃?
    @Param: heavy 晃动幅度
    @Param: callback 回调
    @Return 无
--]]
function StageSelectChar:OnShakeEvent(left, heavy, callback)

    if l_stepEnum.CreateChar ~= l_currentStep then
        log("l_currentStep", l_currentStep)
        return
    end

    if l_canOpTime > Time.time then
        log("wait enter anim")
        return
    end

    local l_anim = CreateCharConfig.GetShakeAction(l_curSexSelected, left, heavy > 0.8)
    if not l_anim then
        log("cannot get anim", l_curSexSelected, left, heavy > 0.8)
        return
    end

    local l_entity = self:GetSelectedEntity()
    if not l_entity then
        log("cannot find entity")
        return
    end

    local l_animator = l_entity.Model.Ator
    local l_animClip = l_entity:OverrideAnim("Special", l_anim)
    l_animator:Play("Special", 0)
    self.underShakeAnim = true

    if callback then
        callback(l_animClip.Length + 0.1)
    end

    self:WaitToIdle(function()
        l_animator:Play("Idle", 0)
        self.underShakeAnim = false
    end, l_animClip.Length)
end


-- 初始化场景npc entities
function StageSelectChar:InitNpcEntitys()

    local l_configs = CreateCharConfig.NpcEntityConfig
    if not l_configs then
        return
    end

    self.npcEntities = {}

    for i, v in ipairs(l_configs) do
        self:InitOneEntity(v, self.npcEntities)
    end
end

function StageSelectChar:InitOneEntity(config, tbl, callback)

    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitNpcAttr(l_tempId, config.key, config.entity_id)
    local l_quaternion = Quaternion.Euler(config.rot[1], config.rot[2], config.rot[3])
    local l_pos = Vector3(config.pos[1], config.pos[2], config.pos[3])
    tbl[config.key] = {}
    tbl[config.key].config = config
    tbl[config.key].entity = MEntityMgr:CreateEntity(l_attr, l_pos, l_quaternion, true)
    tbl[config.key].entity.Model.FollowShadowPoint = true
    tbl[config.key].entity.Model.UpdateWhenOffScreen = true
    tbl[config.key].entity.Model:AddLoadGoCallback(function(go)
        local l_entity = tbl[config.key].entity
        if config.idleAnim then
            l_entity:OverrideAnim("Idle", config.idleAnim)
            l_entity.Model.Ator:Play("Idle", 0)

            if config.delay then
                l_entity.Model.Ator.Speed = 0
                local l_timer = Timer.New(function()
                    l_entity.Model.Ator.Speed = 1
                    self.delayInitTimers[config.key] = nil
                end, config.delay)
                l_timer:Start()
                self.delayInitTimers[config.key] = l_timer
            end
        end
        if config.scaleFac then
            l_entity.Model.Scale = Vector3.New(config.scaleFac, config.scaleFac, config.scaleFac)
            l_entity.Model.LocalRotation = l_quaternion
            l_entity.Model.Position = l_pos
        end

        if config.idleFac and config.specialAnim and config.specialFac then
            self:RoundSwitchAnimation(self.npcEntities[config.key], config.idleAnim, config.idleFac, config.specialAnim, config.specialFac)
        end

        if callback then
            callback(l_entity)
        end
    end)
end

-- 给entity添加事件处理
function StageSelectChar:AttachListener2Entity(l_entity, go, sex, clickCallback, dragCallback)

    local l_listener = MLuaUIListener.Get(go)

    -- 通过点击位置和松手位置判定点击
    local l_cachePos = nil
    l_listener.onDown = function()
        l_cachePos = Input.mousePosition
    end

    l_listener.onUp = function()
        if not l_cachePos then
            return
        end
        local l_new = Input.mousePosition

        if math.abs(l_new.x - l_cachePos.x) <= 5 and
                math.abs(l_new.y - l_cachePos.y) <= 5 then
            clickCallback(l_entity, sex)
        end

        l_cachePos = nil
    end

    l_listener.onDrag = function(g, e)
        if l_entity and l_entity.Model.Trans then
            dragCallback(l_entity, sex, -e.delta.x)
        end
    end

end

-- 更新选角entity
function StageSelectChar:UpdateRoleEntities(hide)

    local l_markTable = {}
    local l_selectedIdx = l_data.RoleSelectedIndex
    for k, v in pairs(l_data.RoleInfos) do
        if not l_roleEntitys[k] then
            l_roleEntitys[k] = self:CreateRoleByRoleInfo(v)
            -- clone装备信息，给设置界面用
            if v.equipData ~= nil then
                v.equipData:Copy(l_roleEntitys[k].AttrComp.EquipData)
            else
                v.equipData = l_roleEntitys[k].AttrComp.EquipData:Clone()
            end
        end

        if hide or (v.role_index ~= l_selectedIdx) then
            l_roleEntitys[k].IsVisible = false
        else
            l_roleEntitys[k].IsVisible = true
        end

        l_markTable[k] = true
    end

    for k, v in pairs(l_roleEntitys) do
        if not l_markTable[k] then
            v.IsVisible = false
        end
    end
end

-- 根据玩家信息创建MRole
function StageSelectChar:CreateRoleByRoleInfo(info)

    local l_entity = self:CreateRole(info.roleID, info.name, info.sex or 0, info.type,
            CreateCharConfig.SelectCharConfig, function(entity)
                if entity.Model.Trans then
                    local l_anim = CreateCharConfig.GetRoleActionConfig(entity.AttrRole.IsMale)
                    if l_anim then
                        local l_animator = entity.Model.Ator
                        local l_anim_clip = entity:OverrideAnim("Special", l_anim)
                        l_animator:Play("Special", 0)
                        self:WaitToIdle(function()
                            if l_animator then
                                l_animator:Play("Idle", 0)
                            end
                        end, l_anim_clip.Length)
                    end
                end
            end, function(entity, _, delta)
                if entity.Model.Trans then
                    entity.Model.Trans:Rotate(0, delta, 0)
                end
            end)

    self:SetEntityWithRoleInfo(l_entity, info)

    return l_entity
end

-- 根据玩家信息设置entity显示
function StageSelectChar:SetEntityWithRoleInfo(entity, roleInfo)
    entity.Rotation = Quaternion.Euler(0, CreateCharConfig.SelectCharConfig.rot[2], 0)
    entity.AttrComp:SetHair(roleInfo.outlook.hair_id)
    entity.AttrComp:SetEye(roleInfo.outlook.eye.eye_id)
    entity.AttrComp:SetEyeColor(roleInfo.outlook.eye.eye_style_id)
    if roleInfo.outlook.wear_fashion ~= nil and roleInfo.outlook.wear_fashion.ItemID ~= 0 then
        entity.AttrComp:SetFashion(roleInfo.outlook.wear_fashion.ItemID)
    elseif roleInfo.outlook.wear_fashion ~= nil then
        --检测装备位是否装有时装
        local hav = false
        if roleInfo.equip_ids then
            for i, v in pairs(roleInfo.equip_ids) do
                if v ~= nil and 0 ~= v.value then
                    local config = TableUtil.GetFashionTable().GetRowByFashionID(v.value, true)
                    if nil ~= config then
                        hav = true
                        entity.AttrComp:SetFashion(v.value)
                        break
                    end
                end
            end
        end
        if hav == false then
            entity.AttrComp:SetFashion(0)
        end
    else
        entity.AttrComp:SetFashion(0)
    end

    local l_head = roleInfo.outlook.wear_head_portrait
    local l_headId = l_head and l_head.ItemID or 0
    entity.AttrComp:SetHead(l_headId)

    --- 五个部位的映射表
    local equipEntityMap = {
        [fashionType.Head] = 0,
        [fashionType.Mouth] = 0,
        [fashionType.Face] = 0,
        [fashionType.Back] = 0,
        [fashionType.Tail] = 0,
    }

    --- 角色需要显示的部位全部置空
    for i = fashionType.None, fashionType.Max do
        if i ~= fashionType.None and i ~= fashionType.Max then
            entity.AttrComp:SetOrnamentByIntType(i, 0)
        end
    end

    --- 如果是时装数据，就全量显示
    if roleInfo.outlook.wear_ornament then
        for i, v in pairs(roleInfo.outlook.wear_ornament) do
            if v.ItemID ~= 0 then
                local config = TableUtil.GetOrnamentTable().GetRowByOrnamentID(v.ItemID, true)
                if nil ~= config then
                    equipEntityMap[config.OrnamentType] = v.ItemID
                end
            end
        end
    end

    --- 如果是装备数据，需要判断是否已经产生了互斥，如果没有互斥，才可以应用
    if roleInfo.equip_ids then
        for i, v in pairs(roleInfo.equip_ids) do
            if v ~= nil and 0 ~= v.value then
                local config = TableUtil.GetOrnamentTable().GetRowByOrnamentID(v.value, true)
                if nil ~= config then
                    if 0 == equipEntityMap[config.OrnamentType] then
                        if nil == C_REPLACE_FASHION_TYPE[config.OrnamentType] then
                            equipEntityMap[config.OrnamentType] = v.value
                        else
                            local replaceType = C_REPLACE_FASHION_TYPE[config.OrnamentType]
                            if 0 == equipEntityMap[replaceType] and 0 == equipEntityMap[config.OrnamentType] then
                                equipEntityMap[config.OrnamentType] = v.value
                            end
                        end
                    end
                end
            end
        end
    end

    --- 角色需要显示的部位全部置空
    for i = fashionType.None, fashionType.Max do
        if i ~= fashionType.None and i ~= fashionType.Max then
            entity.AttrComp:SetOrnament(equipEntityMap[i])
        end
    end
end

function StageSelectChar:OnDataChanged()
    if l_currentStep == l_stepEnum.CreateChar then
        return
    end

    if not next(l_data.RoleInfos) then
        self:RefreshStep(l_stepEnum.CreateChar)
        return
    end

    self:UpdateRoleEntities()
end

function StageSelectChar:MoveCamera(key, immediately, target)

    self:MoveCameraInDirectly(key, immediately, target)
end

function StageSelectChar:MoveCameraInDirectly(key, immediately, target)

    if self.firstPlay then
        immediately = true
        self.firstPlay = nil
    end

    self:MoveCameraDirectly(key, immediately, target)
end

function StageSelectChar:MoveCameraDirectly(key, immediately, target)

    if self.shakeTween then
        self.shakeTween:Kill()
        self.shakeTween = nil
    end

    if self.moveTween then
        self.moveTween:Kill()
        self.moveTween = nil
    end

    if self.firstPlay then
        immediately = true
        self.firstPlay = nil
    end

    local l_cameraRefConfig = CreateCharConfig.CameraFocusConfig1[key]
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamSelectChar, MScene.GameCamera,
            target, l_cameraRefConfig[1], l_cameraRefConfig[2], l_cameraRefConfig[3])
    
    local l_config = CreateCharConfig.CameraFocusConfig[key]
    local l_pos = Vector3.New(unpack(l_config[1]))
    local l_rot = Vector3.New(unpack(l_config[2]))
    if not immediately then
        local l_cameraTrans = MScene.GameCamera.UCam.transform
        l_cameraTrans:DOMove(l_pos, 1)
        self.moveTween = l_cameraTrans:DOLocalRotate(l_rot, 1)
        self.moveTween.onComplete = function()
            self:ShakeCamera()
        end
    else
        local l_cameraGo = MScene.GameCamera.UCam.gameObject
        MLuaCommonHelper.SetLocalRotEuler(l_cameraGo, l_rot.x, l_rot.y, l_rot.z)
        MLuaCommonHelper.SetLocalPos(l_cameraGo, l_pos)
        self:ShakeCamera()
    end

	if not MQualityGradeSetting.IsGreaterOrEqual(MoonSerializable.QualityGradeType.Middle) then
		return
	end

	--暗角插值
	local l_uber = MoonClient.MPostEffectMgr.UberInstance
	if self.vignetteTween then
		self.vignetteTween:Kill()
		self.vignetteTween = nil
	end
	if not immediately then
		self.vignetteTween = DG.Tweening.DOTween.To(DG.Tweening.Core.DOSetter_float(function(value)
			self.vignetteIntensity = value
			l_uber:SetVignette(self.vignetteIntensity, Color.New(0.1, 0.1, 0.1), l_vignetteSmoothness, l_vignetteRoundness, false, Vector2.New(0.5, 0.5))
		end), self.vignetteIntensity, key == "None" and 0.01 or l_vignetteIntensity, l_vignetteTotalTime)
	else
		self.vignetteIntensity = key == "None" and 0.01 or l_vignetteIntensity
		l_uber:SetVignette(self.vignetteIntensity, Color.New(0.1, 0.1, 0.1), l_vignetteSmoothness, l_vignetteRoundness, false, Vector2.New(0.5, 0.5))
	end

	--封胜凯(怀中抱妹杀，单手劈高达。) 5-15 15:21:18
    --凯爷，先把模糊关掉吧，陈敏下周要给别人看版本，有些人说看着晕 - -
	do return end

	-- 切换NPC描边
	if self.npcEntities then
		if key == "None" then
			for k, v in pairs(self.npcEntities) do
				v.entity.Model.OutlineType = MoonClient.EOutlineColorType.Black
			end
		else
			for k, v in pairs(self.npcEntities) do
				local l_distance = Vector3.Distance(l_pos, v.entity.Model.Position)
				v.entity.Model.OutlineType = l_distance < l_dofFocalDistance and MoonClient.EOutlineColorType.Black or MoonClient.EOutlineColorType.None
			end
		end
	end

	-- 景深插值
	if self.dofTween then
		self.dofTween:Kill()
		self.dofTween = nil
	end
	if not immediately then
		self.dofTween = DG.Tweening.DOTween.To(DG.Tweening.Core.DOSetter_float(function(value)
			self.dofBlurScale = value
			l_uber.farBlurScale = self.dofBlurScale
		end), self.dofBlurScale, key == "None" and 0 or l_dofBlurScale, l_dofBlurTotalTime)
	else
		self.dofBlurScale = key == "None" and 0 or l_dofBlurScale
		l_uber.focalDistance = l_dofFocalDistance
		l_uber.nearBlurScale = 0
		l_uber.farBlurScale = self.dofBlurScale
		l_uber:SetVignette(self.vignetteIntensity, Color.New(0.1, 0.1, 0.1), l_vignetteSmoothness, l_vignetteRoundness, false, Vector2.New(0.5, 0.5))
	end
end

function StageSelectChar:SetDefaultAnim(sex, selectSex)

    local l_cache = l_createRoleCache[sex]
    if not l_cache then
        return
    end

    local l_animation = l_cache.config.animation

    l_cache.entity:OverrideAnim("Idle", l_animation.Idle[1])
    l_cache.entity.Model.Ator:Play("Idle")

    if l_cache.timer then
        l_cache.timer:Stop()
        l_cache.timer = nil
    end

    if sex == l_data.MALE and selectSex == l_data.FEMALE then
        return
    end

    self:RoundSwitchAnimation(l_cache, l_animation.Idle[1], l_animation.Idle[2], l_animation.SpecialIdle[1], l_animation.SpecialIdle[2])
end

function StageSelectChar:RoundSwitchAnimation(data, idleAnim, idleFac, specialAnim, specialFac)

    if data.timer then
        data.timer:Stop()
        data.timer = nil
    end

    local l_idleTime = data.entity:OverrideAnim("Idle", idleAnim).Length * idleFac
    local l_specialTime = data.entity:OverrideAnim("Special", specialAnim).Length * specialFac

    local l_curIsIdle = true

    local l_startTime = Time.realtimeSinceStartup
    data.timer = Timer.New(function()
        local l_flag = false
        if l_curIsIdle then
            l_flag = (Time.realtimeSinceStartup - l_startTime) >= l_idleTime
        else
            l_flag = (Time.realtimeSinceStartup - l_startTime) >= l_specialTime
        end

        if l_curIsIdle and l_flag then
            if l_data.IsModifyStyle then
                return
            end
        end

        if l_flag then
            l_startTime = Time.realtimeSinceStartup
            l_curIsIdle = not l_curIsIdle
            if l_curIsIdle then
                data.entity.Model.Ator:Play("Idle")
            else
                data.entity.Model.Ator:Play("Special")
            end
        end
    end, 0.033, -1, true)
    data.timer:Start()
end

function StageSelectChar:ShakeCamera()
    do
        return
    end
    if self.shakeTween then
        self.shakeTween:Kill()
        self.shakeTween = nil
    end

    local l_camera = MScene.GameCamera.UCam
    local l_cameraTrans = l_camera.transform

    local l_baseY = l_cameraTrans.position.y

    self.shakeTween = l_camera.transform:DOMoveY(l_baseY + 0.01, 1)
    self.shakeTween:SetEase(DG.Tweening.Ease.InOutSine)
    self.shakeTween:SetLoops(-1, DG.Tweening.LoopType.Yoyo)
end

return StageSelectChar