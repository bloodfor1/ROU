module("ModuleData", package.seeall)
---@module ModuleData.DataMgr
DataMgr = class("DataMgr")

local cacheModuleDatas = {}

function DataMgr:ctor()
    self._initMap = {
        ["ChatData"] = 1,
        ["BeiluzCoreData"] = 1,
    }
end

--生命周期 DataMgr数据初始化
function DataMgr:Init()
    if nil == self._initMap then
        return
    end

    for mgrName, value in pairs(self._initMap) do
        self:regist(mgrName)
    end
end

--生命周期 账号登出
function DataMgr:OnLogout()
    self:ResetAllModuleData()
end

--重置数据
function DataMgr:ResetAllModuleData()
    for moduleDataName, moduleDataContainer in pairs(cacheModuleDatas) do
        self:resetMgrData(moduleDataName)
    end
end

--对外接口 获取数据
---@return ModuleData.usefirststring
function DataMgr:GetData(moduleDataName)
    self:regist(moduleDataName)
    return cacheModuleDatas[moduleDataName]
end

--私有函数 重置某一个Mgr数据
function DataMgr:resetMgrData(moduleDataName)
    local l_moduleData = cacheModuleDatas[moduleDataName]
    if l_moduleData and l_moduleData.Logout ~= nil then
        l_moduleData.Logout()
    end
end

--私有函数 对DataMgr数据做统一管理
function DataMgr:regist(moduleDataName)
    if cacheModuleDatas[moduleDataName] == nil then
        require("ModuleData/" .. moduleDataName)
        local moduleData = ModuleData[moduleDataName]
        if moduleData == nil then
            logError("没有此ModuleData：" .. tostring(moduleDataName))
            return
        end
        cacheModuleDatas[moduleDataName] = moduleData
        if moduleData.Init ~= nil then
            moduleData.Init()
        end
    end
end

declareGlobal("DataMgr", DataMgr.new())