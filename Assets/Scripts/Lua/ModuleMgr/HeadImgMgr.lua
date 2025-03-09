---
--- Created by cmd(TonyChen).
--- DateTime: 2018/6/24 16:57
---

module("ModuleMgr.HeadImgMgr", package.seeall)

-- todo clx：头像统一替换当中由于魔法信件功能关掉了，所以魔法信件相关的内容有一部分没有替换
function SetHead2DByInfoAndHeadBehaviour(data, headBehaviour)
    if headBehaviour == nil then
        logError("头像Behaviour组件不能为空！")
        return nil
    end

    local l_equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipDataByRoleBriefInfo(data)
    if l_equipData then
        headBehaviour:SetRoleHead(l_equipData)
    end

end

return HeadImgMgr