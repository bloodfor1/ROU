module("ModuleData.SceneEnterData", package.seeall)

local enterScenePanels = {}
local individualPanelNames = {}

function Init()

end

function Logout()
    enterScenePanels = {}
    individualPanelNames = {}
end

function ResetEnterSceneData(...)
    enterScenePanels = {}
    individualPanelNames = {}
end

function GetEnterScenePanels(...)
    return enterScenePanels
end

function InsertDataToEnterScenePanels(data)
    if data then
        table.insert(enterScenePanels, data)
    end
end

function IsPanelCanShowAtScene(panelName)
    if string.ro_isEmpty(panelName) then
        logError("界面名字是空的")
        return false
    end
    return table.ro_contains(enterScenePanels,panelName)
end

function GetIndividualPanelNames()
    return individualPanelNames
end

function InsertDataToIndividualPanelNames(uiName)
    if uiName then
        table.insert(individualPanelNames, uiName)
    end
end
