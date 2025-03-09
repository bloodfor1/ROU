--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.ProbabilityInfoMgr", package.seeall)

--lua model end

--lua custom scripts

local showDataList = {}
---@type table<number,table<number,ProbabilityDetails>>
local AllDetailInfo = nil

---根据ID查询数据
function GetDetailInfoByInterfaceID(ID)
    if not AllDetailInfo then
        AllDetailInfo = {}
        local tableInfo = TableUtil.GetProbabilityDetails().GetTable()
        for k, v in ipairs(tableInfo) do
            for i = 0, v.ShowInterfaceID.Length - 1 do
                local l_id = v.ShowInterfaceID[i]
                if not AllDetailInfo[l_id] then
                    AllDetailInfo[l_id] = {}
                end
                table.insert(AllDetailInfo[l_id], v)
            end
        end
    end
    if AllDetailInfo[ID] == nil then
        logError("概率按钮数据出错，ProbabilityDetails.csv中无此ID对应的数据,请截图ID = ", ID)
        return {}
    end
    return ClassifyDetailInfo(ID)
end

---@param data ProbabilityDetails
function CheckRule(serverDay, lvl, profession, sex, data)
    if data.LimitSex and data.LimitSex ~= 0 and data.LimitSex ~= sex then
        return false
    end
    if data.ServerDays and data.ServerDays[0] ~= 0 then
        if serverDay < data.ServerDays[0] then
            return false
        end
        if data.ServerDays[1] ~= -1 and serverDay >= data.ServerDays[1] then
            return false
        end
    end
    if data.LimitLevel and data.LimitLevel[0] ~= 0 then
        if lvl < data.LimitLevel[0] then
            return false
        end
        if data.LimitLevel[1] ~= -1 and lvl >= data.LimitLevel[1] then
            return false
        end
    end
    if data.LimitProfession and data.LimitProfession.Length > 0 then
        for i = 0, data.LimitProfession.Length - 1 do
            if profession == data.LimitProfession[i] then
                return true
            end
        end
        return false
    end
    return true
end

---将想要查询的Btn对应的数据根据TypeID进行归类，用于统一显示
function ClassifyDetailInfo(ID)
    local classifyData = {}
    local typeToIndex = {}

    local serverDay = MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData.serverDay
    local lvl = MPlayerInfo.Lv
    local profession = math.floor(MPlayerInfo.ProfessionId / 1000) * 1000
    local sex = MPlayerInfo.IsMale and 1 or 2

    for k, v in pairs(AllDetailInfo[ID]) do
        if CheckRule(serverDay, lvl, profession, sex, v) then
            if not typeToIndex[v.TypeID] then
                typeToIndex[v.TypeID] = #classifyData + 1
                classifyData[typeToIndex[v.TypeID]] = {}
            end
            table.insert(classifyData[typeToIndex[v.TypeID]], v)
        end
    end
    return classifyData
end

function ActivePanel(table, BtnId)
    showDataList = GetDetailInfoByInterfaceID(BtnId)
    local rowInfo = TableUtil.GetProbabilityInterface().GetRowByInterfaceID(BtnId)
    local qaText = rowInfo.ProbabilityInstructions
    local urlName = rowInfo.URLDescribe
    local url = rowInfo.ProbabilityURL
    UIMgr:ActiveUI(UI.CtrlNames.ProbabilityInfo, { showDatas = showDataList, QaText = qaText, UrlName = urlName, Url = url })
end

--lua custom scripts end
return ModuleMgr.ProbabilityInfoMgr