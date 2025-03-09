module("ModuleMgr.SkillControllerMgr", package.seeall)

local isSwitchMainSkill = true

function GetSkillController()
    return MUIManager:GetUI(MUIManager.SKILL_CONTORLLER)
end

function ActiveSkillController()
    UIMgr:ActiveUI(UI.CtrlNames.SkillControllerContainer)
end

function DeActiveSkillController()
    UIMgr:DeActiveUI(UI.CtrlNames.SkillControllerContainer)
end

function ShowSkillController()
    UIMgr:ShowUI(UI.CtrlNames.SkillControllerContainer)
end

function HideSkillController()
    UIMgr:HideUI(UI.CtrlNames.SkillControllerContainer)
end

function SetSwitchMainSkill(isSwitchSkill)

    if isSwitchMainSkill ~= isSwitchSkill then
        isSwitchMainSkill = isSwitchSkill

        if isSwitchMainSkill then
            local player = MEntityMgr.PlayerEntity
            if player then
                if (not player.IsFly) and (not player.IsFishing) then
                    UIMgr:CancelPanelForceHide(UI.CtrlNames.SkillControllerContainer)
                end
            end

        else
            UIMgr:SetPanelForceHide(UI.CtrlNames.SkillControllerContainer)
        end
    end
end

function GetSwitchMainSkill()
    return isSwitchMainSkill
end

function RefreshSkillUI()
    local player = MEntityMgr.PlayerEntity
    if player == nil then
        return
    end

    if player.IsFly or player.IsFishing then
        UIMgr:SetPanelForceHide(UI.CtrlNames.SkillControllerContainer)
        HideSkillController(true)
    else
        UIMgr:CancelPanelForceHide(UI.CtrlNames.SkillControllerContainer)
        if GetSwitchMainSkill() then
            if UIMgr:IsActiveUI(UI.CtrlNames.SkillControllerContainer) then
                ShowSkillController()
            else
                ActiveSkillController()
            end

        end
    end
end

function MainPanelShowSkill()
    if not GetSwitchMainSkill() then
        MgrMgr:GetMgr("MainUIMgr").ShowSkill(true)
    end
end

function OnLogout()
    isSwitchMainSkill = true
    UIMgr:CancelPanelForceHide(UI.CtrlNames.SkillControllerContainer)
end

return SkillControllerMgr