module("SGame", package.seeall)

SmallGameBase=class("SmallGameBase")

function SmallGameBase:ctor(name, sortLayer, tweenType, activeType)

end

function SmallGameBase:ParseGameInfo(infoStr)
    local l_objectArray=Common.Utils.ParseString(infoStr,";",1);
    if l_stepArray==nil then
        self:LoadSmallGameFailed("no object exist!");
        return;
    end

end

function SmallGameBase:LoadErrorLog(error)
    logError(error);
end
function SmallGameBase:LoadSmallGameFailed(reason)
    logError(reason)
end