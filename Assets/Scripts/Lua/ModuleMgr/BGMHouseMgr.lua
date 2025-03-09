module("ModuleMgr.BGMHouseMgr", package.seeall)

-- 不在对应任务流程中走的函数
function OpenBGMHousePlayer(luatype, command, args)
    local idstrs = string.ro_split(args[1].Value, ",")
    local ids = {}
    for i, v in ipairs(idstrs) do
        table.insert(ids, tonumber(idstrs[i]))
    end
    game:ShowMainPanel()
    UIMgr:ActiveUI(UI.CtrlNames.BgmHouse, function(ctrl)
        ctrl:InitWithBGMId(ids)
    end)
end

function OnEnterScene(sceneId)
    local l_ui = UIMgr:GetUI(UI.CtrlNames.BgmHouse)
    if l_ui == nil then
        return
    end
    l_ui.originBGMPath = nil
    l_ui:OnStop()
end

-- 任务流程中走的函数，只会进一次
function OpenBGMHousePlayerWithAllMusic()
    local l_table = TableUtil.GetBGMHouseTable().GetTable()
    local ids = {}
    if l_table then
        for c, v in pairs(l_table) do
            table.insert(ids, v.Id)
        end
    end
    game:ShowMainPanel()
    UIMgr:ActiveUI(UI.CtrlNames.BgmHouse, function(ctrl)
        ctrl:InitWithBGMId(ids)
    end)
end

