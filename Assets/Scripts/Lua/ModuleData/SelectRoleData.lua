--
-- @Description:
-- @Author: haiyaojing
-- @Date: 2019-10-09 10:08:01
--
module("ModuleData.SelectRoleData", package.seeall)

-- 选角枚举
ESelectCharStep = {
    SelectChar = 0, -- 选举
    CreateChar = 1, -- 创角
}
ERegisterResult = {
    REGISTER_RESULT_DEFAULT = 0,
    REGISTER_RESULT_PRE_SUCCESS = 1,
    REGISTER_RESULT_PRE_FAILED = 2
}

-- 选角协议通知Mgr名列表
ESelectRoleNotify = {
    "BeginnerGuideMgr",
    "RoleInfoMgr",
    "WorldPveMgr",
    "HeroChallengeMgr",
    "HeadSelectMgr",
    "BattleMgr",
    "SkillLearningMgr",
    "DailyTaskMgr",
    "GarderobeMgr",
    "BarberShopMgr",
    "BeautyShopMgr",
    "TradeMgr",
    "ArenaMgr",
    "EquipMgr",
    "ThemeDungeonMgr",
    "VehicleMgr",
    "ClimbMgr",
    "FishMgr",
    "LifeProfessionMgr",
    "TeamMgr",
    "ChatMgr",
    "GuildSDKMgr",
    "GuildMgr",
    "IllustrationMgr",
    "IllustrationMonsterMgr",
    "BoliGroupMgr",
    "MedalMgr",
    "SettingMgr",
    "WeakGuideMgr",
    "LandingAwardMgr",
    "AdventureDiaryMgr",
    "AchievementMgr",
    "FightAutoMgr",
    "CatCaravanMgr",
    "ArrowMgr",
    "DelegateModuleMgr",
    "FriendMgr",
    "ChatRoomMgr",
    "ChatRoomBubbleMgr",
    "StickerMgr",
    "SignInMgr",
    "WorldMapInfoMgr",
    "StoneSculptureMgr",
    "FashionRatingMgr",
    "PostCardMgr",
    "ActivityCheckInMgr",
    "ShortcutChatMgr",
    "PropMgr",
    "TimeLimitPayMgr",
    "MerchantMgr",
    "LevelRewardMgr",
    "InfiniteTowerDungeonMgr",
    "ForgeMgr",
    "MercenaryMgr",
    "WatchWarMgr",
    "VehicleInfoMgr",
    "TaskGuideNpcMgr",
    "StallMgr",
    "TitleStickerMgr",
    "LimitMgr",
    "ChatTagMgr",
    "MallMgr",
    "MonthCardMgr",
}

-- 男
MALE = 0
-- 女
FEMALE = 1
-- 创角次数
CreateCharCount = 0
-- 角色信息
RoleInfos = {}
-- 是否正在修改造型
IsModifyStyle = false
-- 当前选中角色Index
RoleSelectedIndex = 0
-- 是否预注册成功
RegisterResult = 0
-- 角色是否是预注册
IsPreRegister = false             
-- 创角数据Index映射
local roleCreateCache = {}
-- 创角造型数据设置缓存
local cachedCreateRoleConfig = nil

function Init()

end

-- 登出
function Logout()

    CreateCharCount = 0
    RoleInfos = {}
    roleCreateCache = {}
    --清理玩家信息
    if Data.PlayerInfoModel then
        Data.PlayerInfoModel:Logout()
    end

end

---@param info RoleAllInfo
function SetPlayerInfo(info)
    local l_brief = info.brief
    MPlayerInfo.UID = l_brief.roleid
    MPlayerInfo.Name = Common.Utils.PlayerName(l_brief.name)
    MPlayerInfo.ProID = l_brief.type
    IsPreRegister = l_brief.is_pre_register  --是否是预注册
    if l_brief.sex == nil then
        MPlayerInfo.IsMale = true
    else
        MPlayerInfo.IsMale = l_brief.sex == 0
    end

    MPlayerInfo.ChangeNameCount = l_brief.changenamecount
    SetPlayerLevelByRoleAllInfo(info)
    _setPlayerExp(info)

    MgrMgr:GetMgr("CrashReportMgr").SetPlayerInfo()
end

---@param info RoleAllInfo
function SetPlayerExp(info)
    _setPlayerExp(info)
end

---@param info RoleAllInfo
function _setPlayerExp(info)
    local health = info.role_health
    if health then
        if health.bless_exp_list ~= nil then
            local l_blessExp = 0
            local l_blessJpbExp = 0
            for key, value in pairs(health.bless_exp_list) do
                l_blessExp = l_blessExp + value.base_exp
                l_blessJpbExp = l_blessJpbExp + value.job_exp
            end

            MPlayerInfo.BlessExp = l_blessExp
            MPlayerInfo.BlessJobExp = l_blessJpbExp
        end

        if health.extra_fight_time ~= nil then
            Data.PlayerInfoModel:SetExtraFightTime(health.extra_fight_time)
        end
    end
end

-- 设置玩家等级
function SetPlayerLevelByRoleAllInfo(roleAllInfo)

    local l_brief = roleAllInfo.brief
    if l_brief == nil then
        return
    end

    if l_brief.level and l_brief.level > 0 then
        MPlayerInfo.Lv = l_brief.level
    end

    if l_brief.job_level and l_brief.job_level > 0 then
        MPlayerInfo.JobLv = l_brief.job_level
    end
end

--判断是否能进入新手副本
function IsEnterFresher(roleInfo)

    local l_closeFile = io.open(PathEx.GetCachePath() .. "CloseFresher.txt", "r")
    if l_closeFile ~= nil then
        io.close(l_closeFile)
        return false
    end

    if roleInfo.level > 1 then
        return false
    end
    local l_filePath = PathEx.GetCachePath() .. "EnterFresher.txt"
    local l_res = ""
    local l_file = io.open(l_filePath, "r")
    if l_file == nil then
        return true
    end
    io.input(l_file)
    l_res = io.read()
    while l_res ~= nil do
        if l_res == tostring(roleInfo.roleID) then
            io.close(l_file)
            return false
        end
        l_res = io.read()
    end
    io.close(l_file)
    return true
end

--判断新手剧情是否可跳
function IsSkipFresher()

    local l_filePath = PathEx.GetCachePath() .. "EnterFresher.txt"
    local l_file = io.open(l_filePath, "r")
    if l_file ~= nil then
        io.close(l_file)
        return true
    end
    return false
end

--添加进入新手剧情的角色Uid
function AddFresherUid(uid)

    local l_filePath = PathEx.GetCachePath() .. "EnterFresher.txt"
    local l_file = io.open(l_filePath, "a")
    io.output(l_file)
    io.write(uid .. "\n")
    io.close(l_file)
end

-- 修改玩家名称
function OnModifyName(name)

    MPlayerInfo.Name = name
    MPlayerInfo.ChangeNameCount = MPlayerInfo.ChangeNameCount + 1
end

-- 解析pb数据并缓存
function AddRoleData(roleData, createRoleArg)
    local l_brief = roleData.brief
    if RoleInfos == nil then
        RoleInfos = {}
        roleCreateCache = {}
    end

    local l_index = l_brief.role_index
    RoleInfos[l_index] = {}
    roleCreateCache[l_index] = true
    local l_roleInfo = RoleInfos[l_index]
    l_roleInfo.type = l_brief.type
    l_roleInfo.roleID = l_brief.roleid
    l_roleInfo.name = Common.Utils.PlayerName(l_brief.name)
    l_roleInfo.level = 1
    l_roleInfo.sex = l_brief.sex
    l_roleInfo.outlook = {}
    l_roleInfo.outlook.eye = {}
    l_roleInfo.role_index = l_index

    if roleData.fashion then
        -- 设置头发id
        l_roleInfo.outlook.hair_id = roleData.fashion.current_hair_id
        -- 设置美瞳
        l_roleInfo.outlook.eye.eye_id = roleData.fashion.eye.eye_id
        l_roleInfo.outlook.eye.eye_style_id = roleData.fashion.eye.eye_style_id
    else
        -- 默认使用创角的传参
        l_roleInfo.outlook.hair_id = createRoleArg.hair_id
        l_roleInfo.outlook.eye.eye_id = createRoleArg.eye.eye_id
        l_roleInfo.outlook.eye.eye_style_id = createRoleArg.eye.eye_style_id
    end
    --l_roleInfo.equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipDataByRoleBriefInfo(l_brief)

    RoleSelectedIndex = l_index
end

-- 更新当前玩家角色信息
function UpdateCurrentRoleInfo()
    local l_currentRoleInfo = RoleInfos[RoleSelectedIndex]
    if not RoleInfos[RoleSelectedIndex] then
        return
    end

    l_currentRoleInfo.level = MPlayerInfo.Lv
    l_currentRoleInfo.job_level = MPlayerInfo.JobLv
    l_currentRoleInfo.type = MPlayerInfo.ProID
    if not MEntityMgr.PlayerEntity then
        return
    end

    local l_attr = MEntityMgr.PlayerEntity.OriginalAttrComp
    if l_currentRoleInfo.equipData ~= nil then
        l_currentRoleInfo.equipData:Copy(l_attr.EquipData)
    else
        l_currentRoleInfo.equipData = l_attr.EquipData:Clone()
    end
end

-- 更新当前账号角色信息
function UpdateRolesAccountInfo(accountData)
    RoleInfos = {}
    roleCreateCache = {}
    for i, v in ipairs(accountData.all_roles) do
        UpdateRoleInfo(v)
        if tostring(v.roleID) ~= "0" then
            roleCreateCache[v.role_index] = true
        end
    end
    RegisterResult = accountData.register_result
    RoleSelectedIndex = accountData.select_role_index
end

-- 更新角色信息
function UpdateRoleInfo(info)
    if info.status == RoleStatusType.Role_Status_Deleted then
        RoleInfos[info.role_index] = nil
        return
    end

    if tostring(info.roleID) ~= "0" then
        RoleInfos[info.role_index] = info
    end
end

-- 删除角色信息
function OnDeleteRole(info)
    RoleSelectedIndex = info.select_role_index
    UpdateRoleInfo(info.role_brief_data)

    -- fix error index
    if RoleInfos[RoleSelectedIndex] then
        return
    end

    local _, l_roleInfo = next(RoleInfos)
    if l_roleInfo then
        RoleSelectedIndex = l_roleInfo.role_index
    end
end

-- 恢复角色信息
function OnResumeRole(info)
    UpdateRoleInfo(info.role_brief_data)
end

-- 获取当前角色信息
function GetCurRoleInfo()
    UpdateCurrentRoleInfo()
    return RoleInfos[RoleSelectedIndex]
end

-- 账号信息
function OnGetAccountRoleData(info)
    UpdateRolesAccountInfo(info.account_data)
end

-- 获取创角数量
function GetCreateRoleCount()
    local l_count = 0
    for k, v in pairs(roleCreateCache) do
        l_count = l_count + 1
    end

    return l_count
end

-- 更新头像数据
function UpdateHeadInfo(newId)
    if not newId then
        return
    end
    if not RoleInfos then
        return
    end

    local l_selfUID = tostring(MPlayerInfo.UID)
    for k, v in pairs(RoleInfos) do
        if tostring(v.roleID) == l_selfUID then
            if newId == 0 then
                v.outlook.wear_head_portrait = {}
            else
                v.outlook.wear_head_portrait = {
                    uid = newId,
                    ItemID = MPlayerInfo.HeadID,
                }
            end

        end
    end
end

-- 重置造型设置
function RersetCachedConfig()

    cachedCreateRoleConfig = nil
end

-- 获取造型或默认造型
function GetCachedOrDefaultConfig(sex)
    if cachedCreateRoleConfig and cachedCreateRoleConfig[sex] then
        return cachedCreateRoleConfig[sex]
    end

    if not cachedCreateRoleConfig then
        cachedCreateRoleConfig = {}
    end

    local l_default = getDefaultSelectCharConfig(sex)
    cachedCreateRoleConfig[sex] = l_default
    return l_default
end

-- 保存造型设置
function SaveCacheConfig(sex, config)
    cachedCreateRoleConfig = cachedCreateRoleConfig or {}
    cachedCreateRoleConfig[sex] = config
end

-- 获取默认造型
function getDefaultSelectCharConfig(sex)
    require "create_char_config"
    local l_roleConfig = CreateCharConfig.GetRoleConfig(sex)
    if not l_roleConfig then
        logError("CreateRoleDefaultConfig not exist")
        return
    end

    local l_pro = TableUtil.GetProfessionTable().GetRowById(l_roleConfig.pro_id)
    if not l_pro then
        logError("CreateRoleDefaultConfig error profession id")
        return
    end

    local l_equipId = sex == MALE and l_pro.DefaultEquipM or l_pro.DefaultEquipF
    local l_defaultEquip = TableUtil.GetDefaultEquipTable().GetRowById(l_equipId)
    if not l_defaultEquip then
        logError("CreateRoleDefaultConfig equip not exist")
        return
    end

    return {
        BarberStyleID = l_defaultEquip.BarberStyleID,
        Eye = l_defaultEquip.Eye,
        EyeColor = l_defaultEquip.EyeColor,
    }
end

return ModuleData.SelectRoleData