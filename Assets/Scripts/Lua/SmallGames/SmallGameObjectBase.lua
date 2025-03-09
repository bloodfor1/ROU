require("SmallGames/SGameStep")

module("SGame", package.seeall)

SmallGameObjectBase=class("SmallGameObjectBase")

function SmallGameObjectBase:ctor(infoStr)
    self.steps={}
    self.objectName="";
    self:ParseObjectStr(infoStr);
end
function SmallGameObjectBase:ParseObjectStr(infoStr)
    local l_stepArray=Common.Utils.ParseString(infoStr,"|",2);
    if l_stepArray==nil then
        self:LoadErrorLog("find error object Info!");
        return;
    end
    self:ParseObjectInfo(l_stepArray[1]);

    for i = 2, #l_stepArray do
        SGameStep.new(l_stepArray[i]);
    end
end
function SmallGameObjectBase:ParseObjectInfo(infoStr)

end
