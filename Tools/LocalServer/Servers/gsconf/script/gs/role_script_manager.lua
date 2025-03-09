declareGlobal("RoleScriptManager",{})

RoleScriptManager.RegisterHandlers = {}

function RoleScriptManager.Load(role_all_info, role_script_info)
    for i = 1, #(RoleScriptManager.RegisterHandlers) do
        if (RoleScriptManager.RegisterHandlers[i].Load ~= nil) then
            if not RoleScriptManager.RegisterHandlers[i].Load(role_all_info, role_script_info) then
                return false
            end
        end
    end
    return true
end

function RoleScriptManager.Save(role_all_info, role_script_info, changed)
    for i = 1, #(RoleScriptManager.RegisterHandlers) do
        if (RoleScriptManager.RegisterHandlers[i].Save ~= nil) then
            RoleScriptManager.RegisterHandlers[i].Save(role_all_info, role_script_info, changed)
        end
    end
end

function RoleScriptManager.SaveByTime(role_all_info, role_script_info, modify_time)
    for i = 1, #(RoleScriptManager.RegisterHandlers) do
        if (RoleScriptManager.RegisterHandlers[i].SaveByTime ~= nil) then
            RoleScriptManager.RegisterHandlers[i].SaveByTime(role_all_info, role_script_info, modify_time)
        end
    end
end

function RoleScriptManager.Refresh(role_all_info, role_script_info, mark)
    for i = 1, #(RoleScriptManager.RegisterHandlers) do
        if (RoleScriptManager.RegisterHandlers[i].Refresh ~= nil) then
            RoleScriptManager.RegisterHandlers[i].Refresh(role_all_info, role_script_info, mark)
        end
    end
end

function RoleScriptManager.AfterLogin(role_all_info, role_script_info)
    for i = 1, #(RoleScriptManager.RegisterHandlers) do
        if (RoleScriptManager.RegisterHandlers[i].AfterLogin ~= nil) then
            RoleScriptManager.RegisterHandlers[i].AfterLogin(role_all_info, role_script_info)
        end
    end
end