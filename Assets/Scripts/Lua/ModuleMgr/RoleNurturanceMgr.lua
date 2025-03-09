--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleMgr.RoleNurturanceMgr
module("ModuleMgr.RoleNurturanceMgr", package.seeall)
EventDispatcher = EventDispatcher.new()
OnRefreshDataEvent = "OnRefreshDataEvent"

local l_data = DataMgr:GetData("RoleNurturanceData")
local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")

---EEquipSlotType To EEquipSlotIdxType
local C_DESIGN_CLIENT_SLOT_MAP = {
    [GameEnum.EEquipSlotType.Weapon] = {
        main = GameEnum.EEquipSlotIdxType.MainWeapon, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.BackUpHand] = {
        main = GameEnum.EEquipSlotIdxType.BackupWeapon, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.Armor] = {
        main = GameEnum.EEquipSlotIdxType.Armor, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.Cape] = {
        main = GameEnum.EEquipSlotIdxType.Cape, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.Boot] = {
        main = GameEnum.EEquipSlotIdxType.Boots, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.Accessory] = {
        main = GameEnum.EEquipSlotIdxType.Accessory1, backup = GameEnum.EEquipSlotIdxType.Accessory2,
    },
    [GameEnum.EEquipSlotType.HeadWear] = {
        main = GameEnum.EEquipSlotIdxType.Helmet, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.FaceGear] = {
        main = GameEnum.EEquipSlotIdxType.FaceGear, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.MouthGear] = {
        main = GameEnum.EEquipSlotIdxType.MouthGear, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.BackGear] = {
        main = GameEnum.EEquipSlotIdxType.BackGear, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.Vehicle] = {
        main = GameEnum.EEquipSlotIdxType.Vehicle, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.Trolley] = {
        main = GameEnum.EEquipSlotIdxType.Trolley, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.BattleHorse] = {
        main = GameEnum.EEquipSlotIdxType.BattleHorse, backup = GameEnum.EEquipSlotIdxType.None,
    },
    [GameEnum.EEquipSlotType.BattleBird] = {
        main = GameEnum.EEquipSlotIdxType.BattleBird, backup = GameEnum.EEquipSlotIdxType.None,
    },

}

--lua model end

--lua custom scripts

function OnEnterScene(sceneId)
    RefreshData(l_data.REFRESH_TYPE.EnterScene)
end

function OnLogin(...)
end

---添加步骤
---1.实现计算分数函数
---不关心相应逻辑的实现，后续添加所有函数需遵循传参返参原则，具体分数计算方法自己实现
---@param Parameter number[][] RoleNurturanceTable.Parameter分值参数
---@param Score number RoleNurturanceTable.Score标模总分
---@param FunctionParameter number[] RoleNurturanceTable.FunctionParameter目标部位
---@param TargetLevel number RoleNurturanceTable.TargetLevel目标等级
---@return number uint 排序分数
---@return number uint 获得分数
---@return number uint 标模分数总分
---为啥要传三个这么蠢的参数回去，因为有的特么的他配的总分没用，需要动态算总分，而且有的排序分数和获得分数不是简单的总分-获得分数=排序分数 具体为什么，问策划去，别来问我
---2.检查对应OpenSystemID的方法是否实现,SystemFunctionEventMgr.lua
---3.RefreshData()方法里那个GetScoreFunc的表里，把你的实现的这个函数对应好扔进去
---4.骂策划为啥想出来这么反人类的设计全藕在一起


function CheckScoreMercenaryReruitNum(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Mercenary) then
        return -1, 0
    end

    local l_recruitNum = MgrMgr:GetMgr("MercenaryMgr").GetRecruitNum()
    local l_score = Parameter[1][2] * l_recruitNum

    return Score - l_score, l_score, Score
end

function CheckScoreMercenaryLvl(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Mercenary) then
        return -1, 0
    end

    local l_lvls = MgrMgr:GetMgr("MercenaryMgr").GetFightLevels()
    local myLvl = MPlayerInfo.Lv
    local sumLvl = 0
    for _, v in pairs(l_lvls) do
        if v > myLvl then
            sumLvl = sumLvl + myLvl
        else
            sumLvl = sumLvl + v
        end
    end
    local l_score = (myLvl - sumLvl) * Parameter[1][3]

    return l_score, sumLvl * Parameter[1][3], (myLvl * Parameter[1][3])
end

function CheckScoreMercenaryEquip(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Mercenary) then
        return -1, 0
    end

    local l_lvls = MgrMgr:GetMgr("MercenaryMgr").GetFightEquipNumByLevel()
    local myLvl = MPlayerInfo.Lv
    local sumLvl = 0
    for _, v in pairs(l_lvls) do
        if v > myLvl then
            sumLvl = sumLvl + myLvl
        else
            sumLvl = sumLvl + v
        end
    end
    local l_score = (6 * myLvl - sumLvl) * Parameter[1][3]
    return l_score, sumLvl * Parameter[1][3], (6 * myLvl * Parameter[1][3])
end

function CheckScoreEquipForge(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.forgeWeapon) then
        return -1, 0
    end
    local l_score = 0
    for _, v in pairs(FunctionParameter) do
        if v == GameEnum.EEquipSlotIdxType.BackupWeapon then
            ---@type ItemData
            local l_mainWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, GameEnum.EEquipSlotIdxType.MainWeapon)
            if not MgrMgr:GetMgr("ForgeMgr").IsNeedDealWithSecondaryWeapon(l_mainWeapon) then
                if l_mainWeapon.EquipConfig.TypeId == GameEnum.EEquipSourceType.Forge or l_mainWeapon.EquipConfig.TypeId == GameEnum.EEquipSourceType.Instance then
                    local l_level = Common.Functions.SequenceToTable(l_mainWeapon.ItemConfig.LevelLimit)[1]
                    if l_level >= targetLevel then
                        local preScore = CheckPreScoreByLvl(Parameter, l_level)
                        l_score = l_score + preScore
                    end
                end
            else
                --@type ItemData
                local l_equipPos = C_DESIGN_CLIENT_SLOT_MAP[v]
                local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.main)
                --判断是否为锻造装
                if l_equip ~= nil and l_equip.ItemConfig ~= nil then
                    local l_level = Common.Functions.SequenceToTable(l_equip.ItemConfig.LevelLimit)[1]
                    if l_level >= targetLevel then
                        if l_equip.EquipConfig.TypeId == GameEnum.EEquipSourceType.Forge or l_equip.EquipConfig.TypeId == GameEnum.EEquipSourceType.Instance then
                            local preScore = CheckPreScoreByLvl(Parameter, l_level)
                            l_score = l_score + preScore
                        end
                    end
                end
            end
        else
            local l_equipPos = C_DESIGN_CLIENT_SLOT_MAP[v]
            ---@type ItemData
            local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.main)
            --判断是否为锻造装
            if l_equip ~= nil and l_equip.ItemConfig ~= nil then
                local l_level = Common.Functions.SequenceToTable(l_equip.ItemConfig.LevelLimit)[1]
                if l_level >= targetLevel then
                    if l_equip.EquipConfig.TypeId == GameEnum.EEquipSourceType.Forge or l_equip.EquipConfig.TypeId == GameEnum.EEquipSourceType.Instance then
                        local preScore = CheckPreScoreByLvl(Parameter, l_level)
                        l_score = l_score + preScore
                    end
                end
            end
            if l_equipPos.backup ~= GameEnum.EEquipSlotIdxType.None then
                ---@type ItemData
                local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.backup)
                --判断是否为锻造装
                if l_equip ~= nil and l_equip.ItemConfig ~= nil then
                    local l_level = Common.Functions.SequenceToTable(l_equip.ItemConfig.LevelLimit)[1]
                    if l_level >= targetLevel then
                        if l_equip.EquipConfig.TypeId == GameEnum.EEquipSourceType.Forge or l_equip.EquipConfig.TypeId == GameEnum.EEquipSourceType.Instance then
                            local preScore = CheckPreScoreByLvl(Parameter, l_level)
                            l_score = l_score + preScore
                        end
                    end
                end
            end

        end
    end
    return Score - l_score, l_score, Score
end

function CheckScoreEquipRefine(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Refine) then
        return -1, 0
    end
    local perScores = {}
    for _, v in pairs(Parameter) do
        perScores[v[1]] = v[2]
    end
    local l_score = 0
    for _, v in pairs(FunctionParameter) do
        if v == GameEnum.EEquipSlotIdxType.BackupWeapon then

            ---@type ItemData
            local l_mainWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, GameEnum.EEquipSlotIdxType.MainWeapon)
            if not MgrMgr:GetMgr("ForgeMgr").IsNeedDealWithSecondaryWeapon(l_mainWeapon) then
                if l_mainWeapon ~= nil and perScores[l_mainWeapon.RefineLv] and l_mainWeapon.RefineLv >= targetLevel then
                    l_score = l_score + perScores[l_mainWeapon.RefineLv]
                end
            else
                local l_equipPos = C_DESIGN_CLIENT_SLOT_MAP[v]
                local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.main)
                if l_equip ~= nil and perScores[l_equip.RefineLv] and l_equip.RefineLv >= targetLevel then
                    l_score = l_score + perScores[l_equip.RefineLv]
                end
            end
        else
            local l_equipPos = C_DESIGN_CLIENT_SLOT_MAP[v]
            ---@type ItemData
            local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.main)
            if l_equip ~= nil and perScores[l_equip.RefineLv] and l_equip.RefineLv >= targetLevel then
                l_score = l_score + perScores[l_equip.RefineLv]
            end
            if l_equipPos.backup ~= GameEnum.EEquipSlotIdxType.None then
                ---@type ItemData
                local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.backup)
                if l_equip ~= nil and perScores[l_equip.RefineLv] and l_equip.RefineLv >= targetLevel then
                    l_score = l_score + perScores[l_equip.RefineLv]
                end
            end
        end

    end

    return Score - l_score, l_score, Score
end

--- 附魔对应的数据
function CheckScoreEquipEnchant(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Enchant) then
        return -1, 0
    end

    local perScores = {}
    for _, v in pairs(Parameter) do
        perScores[v[1]] = v[2]
    end

    local l_score = 0
    for _, v in pairs(FunctionParameter) do
        if v == GameEnum.EEquipSlotIdxType.BackupWeapon then
            local l_mainWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, GameEnum.EEquipSlotIdxType.MainWeapon)
            if not MgrMgr:GetMgr("ForgeMgr").IsNeedDealWithSecondaryWeapon(l_mainWeapon) then
                if l_mainWeapon ~= nil and perScores[l_mainWeapon.EnchantGrade] and l_mainWeapon.EnchantGrade >= targetLevel then
                    l_score = l_score + perScores[l_mainWeapon.EnchantGrade]
                end
            else
                local l_equipPos = C_DESIGN_CLIENT_SLOT_MAP[v]
                local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.main)
                if l_equip ~= nil and perScores[l_equip.EnchantGrade] and l_equip.EnchantGrade >= targetLevel then
                    l_score = l_score + perScores[l_equip.EnchantGrade]
                end
            end
        else
            local l_equipPos = C_DESIGN_CLIENT_SLOT_MAP[v]
            local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.main)
            if l_equip ~= nil and perScores[l_equip.EnchantGrade] and l_equip.EnchantGrade >= targetLevel then
                l_score = l_score + perScores[l_equip.EnchantGrade]
            end

            if l_equipPos.backup ~= GameEnum.EEquipSlotIdxType.None then
                local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.backup)
                if l_equip ~= nil and perScores[l_equip.EnchantGrade] and l_equip.EnchantGrade >= targetLevel then
                    l_score = l_score + perScores[l_equip.EnchantGrade]
                end
            end
        end
    end

    return Score - l_score, l_score, Score
end

function CheckScoreEquipCard(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.EquipCard) then
        return -1, 0
    end
    local perScores = {}
    for _, v in pairs(Parameter) do
        perScores[v[1]] = v[2]
    end
    local l_score = 0
    for _, v in pairs(FunctionParameter) do
        if v == GameEnum.EEquipSlotIdxType.BackupWeapon then
            ---@type ItemData
            local l_mainWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, GameEnum.EEquipSlotIdxType.MainWeapon)
            if not MgrMgr:GetMgr("ForgeMgr").IsNeedDealWithSecondaryWeapon(l_mainWeapon) then
                for __, cardInfo in pairs(l_mainWeapon.AttrSet[GameEnum.EItemAttrModuleType.Card]) do
                    if #cardInfo > 0 then
                        local l_quality = Data.BagApi:CreateLocalItemData(cardInfo[1].AttrID).ItemConfig.ItemQuality
                        if l_quality >= targetLevel then
                            l_score = l_score + perScores[l_quality]
                        end
                    end
                end
            else
                local l_equipPos = C_DESIGN_CLIENT_SLOT_MAP[v]
                ---@type ItemData
                local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.main)
                if l_equip ~= nil and l_equip.AttrSet ~= nil then
                    for __, cardInfo in pairs(l_equip.AttrSet[GameEnum.EItemAttrModuleType.Card]) do
                        if #cardInfo > 0 then
                            local l_quality = Data.BagApi:CreateLocalItemData(cardInfo[1].AttrID).ItemConfig.ItemQuality
                            if l_quality >= targetLevel then
                                l_score = l_score + perScores[l_quality]
                            end
                        end
                    end

                end
            end
        else
            local l_equipPos = C_DESIGN_CLIENT_SLOT_MAP[v]
            ---@type ItemData
            local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.main)
            if l_equip ~= nil and l_equip.AttrSet ~= nil and l_equip.AttrSet[GameEnum.EItemAttrModuleType.Card] ~= nil then
                for __, cardInfo in pairs(l_equip.AttrSet[GameEnum.EItemAttrModuleType.Card]) do
                    if #cardInfo > 0 then
                        local l_quality = Data.BagApi:CreateLocalItemData(cardInfo[1].AttrID).ItemConfig.ItemQuality
                        if l_quality >= targetLevel then
                            l_score = l_score + perScores[l_quality]
                        end
                    end
                end
            end
            if l_equipPos.backup ~= GameEnum.EEquipSlotIdxType.None then
                ---@type ItemData
                local l_equip = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_equipPos.backup)
                if l_equip ~= nil and l_equip.AttrSet ~= nil and l_equip.AttrSet[GameEnum.EItemAttrModuleType.Card] ~= nil then
                    for __, cardInfo in pairs(l_equip.AttrSet[GameEnum.EItemAttrModuleType.Card]) do
                        if #cardInfo > 0 then
                            local l_quality = Data.BagApi:CreateLocalItemData(cardInfo[1].AttrID).ItemConfig.ItemQuality
                            if l_quality >= targetLevel then
                                l_score = l_score + perScores[l_quality]
                            end
                        end
                    end
                end
            end
        end

    end

    return Score - l_score, l_score, Score
end

function CheckScoreMedal(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Medal) then
        return -1, 0
    end
    local perScores = {}
    for _, v in pairs(Parameter) do
        perScores[v[1]] = v[2]
    end
    local l_score = 0
    local gloryMedals = DataMgr:GetData("MedalData").GetGloryMedalData()
    local holyMedal = DataMgr:GetData("MedalData").GetHolyMedalData()
    for _, v in pairs(gloryMedals) do
        if v.level ~= 0 and v.level >= targetLevel then
            l_score = l_score + perScores[v.level]
        end
    end
    for _, v in pairs(holyMedal) do
        if v.level ~= 0 and v.level >= targetLevel then
            l_score = l_score + perScores[v.level]
        end
    end
    return Score - l_score, l_score, Score
end

function CheckScoreSkillPoint(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Skill) then
        return -1, 0
    end
    local leftPoint = DataMgr:GetData("SkillData").GetSkillLeftPoint() or 0
    local totalPoint = DataMgr:GetData("SkillData").GetTotalSkillPointByLevel()
    local perScore = CheckPreScoreByLvl(Parameter)
    if leftPoint <= targetLevel then
        leftPoint = 0
    end
    return leftPoint * perScore, (totalPoint - leftPoint) * perScore, totalPoint * perScore
end

function CheckScoreRoleAttrPoint(Parameter, Score, FunctionParameter, targetLevel)
    local totalPoint = MgrMgr:GetMgr("RoleInfoMgr").GetTotalQualityPoint()
    local leftPoint = DataMgr:GetData("RoleInfoData").PlayerAttr.totalQualityPoint or 0
    local perScore = CheckPreScoreByLvl(Parameter)
    if leftPoint <= targetLevel then
        leftPoint = 0
    end
    return leftPoint * perScore, (totalPoint - leftPoint) * perScore, totalPoint * perScore
end

function CheckScoreVehicleLvl(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.VehicleAbility) then
        return -1, 0
    end
    local l_score = 0
    local vehicleLvl, vehicleExp = MgrMgr:GetMgr("VehicleInfoMgr").GetVehicleLevelAndExp()
    if vehicleLvl >= targetLevel then
        for _, v in pairs(Parameter) do
            if vehicleLvl == v[1] then
                l_score = v[2]
                break
            end
        end
    end

    return Score - l_score, l_score, Score
end

function CheckScoreVehicleQuality(Parameter, Score, FunctionParameter, targetLevel)
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.VehicleQuality) then
        return -1, 0
    end
    local perScores = {}
    for _, v in pairs(Parameter) do
        perScores[v[1]] = v[2]
    end
    local l_score = 0
    local vehicleInfos = MgrMgr:GetMgr("VehicleInfoMgr").GetAttrInfoData()
    for _, v in ipairs(vehicleInfos) do
        if v.Id ~= 0 and v.Id >= targetLevel then
            l_score = l_score + perScores[v.Id] * v.trainValue
        end
    end

    return Score - l_score, l_score, Score
end

function CheckScoreAutoMedicine(Parameter, Score, FunctionParameter, targetLevel)
    for i = 0, MPlayerInfo.AutoHpDragItemList.Length - 1 do
        if MPlayerInfo.AutoHpDragItemList[i] ~= 0 then
            return 0, Score, Score
        end
    end
    for i = 0, MPlayerInfo.AutoMpDragItemList.Length - 1 do
        if MPlayerInfo.AutoMpDragItemList[i] ~= 0 then
            return 0, Score, Score
        end
    end
    return Score, 0, Score
end

function CheckPreScoreByLvl(Parameter, targetLvl)
    local myLvl = targetLvl or MPlayerInfo.Lv
    for _, v in pairs(Parameter) do
        if myLvl >= v[1] and myLvl < v[2] then
            return v[3]
        end
    end
    return 0
end

function RefreshData(type, ignoreActiveStatus)
    if type == nil then
        type = l_data.GetNurturanceType()
        ignoreActiveStatus = true
    end
    l_data.SetNurturanceType(type)
    local GetScoreFunc = {
        [GameEnum.ERoleNurtType.Forge] = CheckScoreEquipForge,
        [GameEnum.ERoleNurtType.Refine] = CheckScoreEquipRefine,
        [GameEnum.ERoleNurtType.Enchant] = CheckScoreEquipEnchant,
        [GameEnum.ERoleNurtType.CardInsert] = CheckScoreEquipCard,
        [GameEnum.ERoleNurtType.SkillPoint] = CheckScoreSkillPoint,
        [GameEnum.ERoleNurtType.AttrPoint] = CheckScoreRoleAttrPoint,
        [GameEnum.ERoleNurtType.Madel] = CheckScoreMedal,
        [GameEnum.ERoleNurtType.VehicleLv] = CheckScoreVehicleLvl,
        [GameEnum.ERoleNurtType.VehicleQuality] = CheckScoreVehicleQuality,
        [GameEnum.ERoleNurtType.MercCrew] = CheckScoreMercenaryReruitNum,
        [GameEnum.ERoleNurtType.MercLv] = CheckScoreMercenaryLvl,
        [GameEnum.ERoleNurtType.MercEquip] = CheckScoreMercenaryEquip,
        [GameEnum.ERoleNurtType.AutoMedicine] = CheckScoreAutoMedicine,

    }
    l_data.ClearNurturanceData()
    local myLvl = MPlayerInfo.Lv
    ---@type RoleNurturanceNeedRow[]
    local needrow = l_data.GetCurrentNeedRows(myLvl)
    for _, v in pairs(needrow) do
        ---@class NurturanceRowData
        local rowData = {}
        local l_Parameter = Common.Functions.VectorVectorToTable(v.RowInfo.Parameter)
        local l_FunctionParameter = Common.Functions.VectorToTable(v.RowInfo.FunctionParameter)
        local targetFunc = GetScoreFunc[v.RowInfo.Type]
        if nil == targetFunc then
            logError("[RoleNute] invalid type : " .. tostring(v.RowInfo.Type))
        else
            local SortScore, CurrentScore, MaxScore = targetFunc(l_Parameter, v.RowInfo.Score, l_FunctionParameter, v.RowInfo.TargetLevel)
            if SortScore ~= -1 then
                rowData.CurrentScore = CurrentScore
                rowData.SortScore = SortScore
                rowData.SliderValue = MaxScore and CurrentScore / MaxScore or 0
                rowData.pre = rowData.SliderValue
                if rowData.SliderValue > 1 then
                    rowData.SliderValue = 1
                end
                rowData.RowInfo = v.RowInfo
                rowData.Score = MaxScore or v.RowInfo.Score
                l_data.AddNurturanceData(rowData)
            end
        end
    end
    l_data.SortNurturanceData()
    local NeedShowBtn = false
    local needCount = 0
    if type == l_data.REFRESH_TYPE.Death then
        l_data.IsActiveByDeath = true
        NeedShowBtn = CheckNeedShowDeath()
        needCount = #l_data.GetDeathGuide()
    elseif type == l_data.REFRESH_TYPE.Capra then

    elseif type == l_data.REFRESH_TYPE.EnterScene then
        if l_data.IsActiveByDeath then
            NeedShowBtn = CheckNeedShowDeath()
            needCount = #l_data.GetDeathGuide()
            ignoreActiveStatus = true
        else
            NeedShowBtn = CheckNeedShowNurturance()
            needCount = #l_data.GetRoleNurturanceIndex()
        end
    elseif type == l_data.REFRESH_TYPE.LevelUp then
        NeedShowBtn = CheckNeedShowNurturance(true)
        needCount = #l_data.GetRoleNurturanceIndex()
        l_data.IsActiveByDeath = false
        EventDispatcher:Dispatch(l_data.LEVEL_UP)
    end
    if type ~= l_data.REFRESH_TYPE.Capra and l_data.BtnActive then
        CheckIsNeedEffect(type)
    end
    if ignoreActiveStatus then
        if needCount == 0 then
            l_data.BtnActive = false
        end
    else
        l_data.BtnActive = NeedShowBtn
        EventDispatcher:Dispatch(OnRefreshDataEvent)
    end
    return l_data.GetNurturanceData()
end

function CheckNeedShowDeath()
    local RecommendCondition = MGlobalConfig:GetVectorSequence("DevelopRecommendCondition")
    local index = MGlobalConfig:GetInt("DeathNurturanceIndex") - 1
    local RecommendConditionNum = tonumber(RecommendCondition[index][0])
    local RecommendConditionPre = tonumber(RecommendCondition[index][1] / 10000)
    local l_nurturanceData = l_data.GetNurturanceData()
    l_data.ResetDeathGuide()
    for i = 1, #l_nurturanceData do
        local oneLua = l_nurturanceData[i]
        local cerScore = oneLua.RowInfo.HighScore - oneLua.RowInfo.Score
        local pre = oneLua.CurrentScore / (cerScore + oneLua.Score)
        if pre < RecommendConditionPre then
            l_data.AddDeathGuide(i)
        end
    end
    if #l_data.GetDeathGuide() >= RecommendConditionNum then
        SendRoleNurturanceTlog(3)
        return true
    end
    return false
end

function CheckNeedShowNurturance(islevelUp)
    local RecommendCondition = MGlobalConfig:GetVectorSequence("DevelopRecommendCondition")
    local index = MGlobalConfig:GetInt("RoleNurturanceIndex") - 1
    local RecommendConditionNum = tonumber(RecommendCondition[index][0])
    local RecommendConditionPre = tonumber(RecommendCondition[index][1] / 10000)
    local l_nurturanceData = l_data.GetNurturanceData()
    l_data.ResetRoleNurturanceIndex()
    for i = 1, #l_nurturanceData do
        local oneLua = l_nurturanceData[i]
        if oneLua.SliderValue < RecommendConditionPre then
            l_data.AddRoleNurturanceIndex(i)
        end
    end
    if #l_data.GetRoleNurturanceIndex() >= RecommendConditionNum then
        if islevelUp then
            SendRoleNurturanceTlog(1)
        else
            SendRoleNurturanceTlog(2)
        end
        return true
    end
    return false
end

function CheckIsNeedEffect(type)
    local nowTime = Common.TimeMgr.GetNowTimestamp()
    if type == l_data.REFRESH_TYPE.Death or type == l_data.REFRESH_TYPE.LevelUp then
        PlayerPrefs.SetInt("NurturanceBtnTimeStamp", nowTime)
        l_data.SetFirstFlag(true)
    end
    if not PlayerPrefs.GetInt("NurturanceBtnTimeStamp")
            or PlayerPrefs.GetInt("NurturanceBtnTimeStamp") == 0
            or nowTime > PlayerPrefs.GetInt("NurturanceBtnTimeStamp") + MGlobalConfig:GetSequenceOrVectorInt("DisappearTime")[0] then
        PlayerPrefs.SetInt("NurturanceBtnTimeStamp", nowTime)
        l_data.SetFirstFlag(true)
    end
end

function ClickGoto(SystemID)
    Common.CommonUIFunc.InvokeFunctionByFuncId(SystemID)
end

function OnLogout()
    PlayerPrefs.SetInt("NurturanceBtnTimeStamp", 0)
end

function SendRoleNurturanceTlog(TlogType)
    local l_msgId = Network.Define.Ptc.RoleNurturanceTlog
    ---@type RoleNurturanceTlogData
    local l_sendInfo = GetProtoBufSendTable("RoleNurturanceTlogData")
    l_sendInfo.type = TlogType
    local l_str = ""
    local l_needRow = l_data.GetNurturanceData()
    for _, v in pairs(l_needRow) do
        l_str = l_str .. v.RowInfo.SystemId .. "," .. v.SliderValue .. ";"
    end
    l_sendInfo.Progress = l_str
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function ClickSystemTlog(type, systemIDs, clickID)
    local l_msgId = Network.Define.Ptc.RoleNurturanceTlog
    ---@type RoleNurturanceTlogData
    local l_sendInfo = GetProtoBufSendTable("RoleNurturanceTlogData")
    l_sendInfo.operate_type = type
    local l_str = ""
    for _, v in pairs(systemIDs) do
        l_str = l_str .. "|" .. v
    end
    l_sendInfo.recommend_system_id = l_str
    if clickID then
        l_sendInfo.recommend_type = clickID
    end
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--lua custom scripts end
return ModuleMgr.RoleNurturanceMgr