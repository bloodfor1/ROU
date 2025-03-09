--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleMgr.BindAccountMgr
module("ModuleMgr.BindAccountMgr", package.seeall)

--lua model end

--lua custom scripts

-- 事件注册
EventDispatcher = EventDispatcher.new()

IsLogoutToGameOpenBindAccountUI = false     -- 是否是回到选服界面然后打开UI

function LogoutToGameOpenBindAccountUI()
    IsLogoutToGameOpenBindAccountUI = true
    game:GetAuthMgr():LogoutToGame()
end

function IsOpenBindAccountUI()
    if IsLogoutToGameOpenBindAccountUI then
        IsLogoutToGameOpenBindAccountUI = false
        UIMgr:ActiveUI(UI.CtrlNames.BindAccount)
    end
end

--lua custom scripts end
return ModuleMgr.BindAccountMgr