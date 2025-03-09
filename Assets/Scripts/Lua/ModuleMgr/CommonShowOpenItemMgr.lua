module("ModuleMgr.CommonShowOpenItemMgr", package.seeall)

--通用展示开启强制提示面板
--obj 你想用的对象
--targetPos 飞向的目标地点 可空
--clone 是否复制该对象 可空 默认为true
--onStart 开始播放的函数，可返回一个自定义数据
--onEnd 结束播放的函数，onStart的自定义数据将被传入
ShowSkillItemtimer = nil

function ShowCommonOpenItem(obj, targetPos, clone, onStart, onEnd, onCallback)
    UIMgr:ActiveUI(UI.CtrlNames.CommonShowOpenItem, function(ctrl)
        ctrl:ShowWithObject(obj, targetPos, clone, onStart, onEnd, onCallback)
    end)
end


function ShowSkillItem(skillId, targetPos, tutorialId)

    local l_icon = MResLoader:CreateObjFromPool("UI/Prefabs/SkillIcon")
    local l_rawImg = l_icon.transform:Find("RawImage").gameObject:GetComponent("RawImage")
    local l_com = l_icon.transform:Find("Icon").gameObject:GetComponent("MLuaUICom")
    local l_skillData = TableUtil.GetSkillTable().GetRowById(skillId)

    if l_skillData ~= nil then

        l_com:SetSprite(l_skillData.Atlas, l_skillData.Icon)
        ShowCommonOpenItem(l_icon, targetPos, false, function()
            local l_fxPath = "Effects/Prefabs/Creature/Ui/Fx_Ui_JiNengYinDao_01"
            local l_fxData = MFxMgr:GetDataFromPool()
            l_fxData.rawImage = l_rawImg
            l_fxData.playTime = -1
            l_fxData.scaleFac = Vector3.New(1, 1, 1)
            local l_fx = MFxMgr:CreateFxForRT(l_fxPath, l_fxData)
            MFxMgr:ReturnDataToPool(l_fxData)
            return {
                Fx = l_fx
            }
        end, function(customData)
            if l_fx ~= nil then
                MFxMgr:DestroyFx(customData.Fx)
            end
        end, function()
            if tutorialId > 0 then
                MgrMgr:GetMgr("BeginnerGuideMgr").ShowBeginnerGuide(tutorialId)
                logRed("BeginnerGuide", tutorialId)
            end
        end)
    end
end

----------------------------UIEvent------------------------------------

function OnShowBuffSkill(luaType, skillId, slotId, tutorialId)

    local l_skillController = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()

    local l_showSkillItem = function ()
        local l_targetPos = nil
        if l_skillController == nil or not l_skillController.IsActived then
            l_targetPos = Vector3.New(3.79, -3.98, 0)
        else
            l_targetPos = l_skillController:GetSlotPosition(slotId)
        end
        ShowSkillItem(skillId, l_targetPos, tutorialId)
    end

    if l_skillController == nil then
        l_showSkillItem()
    else
        if ShowSkillItemtimer then
            ShowSkillItemtimer:Stop()
            ShowSkillItemtimer = nil
        end
        ShowSkillItemtimer = Timer.New(function ()
            if not l_skillController.IsTweening then
                l_showSkillItem()
                ShowSkillItemtimer:Stop()
            end
        end,0.1,-1)
    end
end