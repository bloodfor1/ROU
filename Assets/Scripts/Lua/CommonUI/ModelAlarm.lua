module("CommonUI.ModelAlarm", package.seeall)

ModelType = {
	Player = 1,
	NPC = 2,
	Monster = 3
}

-- 显示模型提示
-- modelType 模型类型 ModelType
-- hostId 引用ID
-- content 文本内容
-- scale 缩放（不填，1）
-- offset 偏移（不填，0,0,0）
-- duration 延迟多久消失（不填，自己控制消失）
function ShowAlarm(modelType, hostId, content, scale, offset, duration)

	--UIMgr:ActiveUI(UI.CtrlNames.ModelAlarm, function (ui)
	--	ui:ShowInfo(modelType, hostId, content, scale, offset, duration)
	--end)
    local l_openData = {
        openType = 1,
        ModelType = modelType,
        HostId = hostId,
        Content = content,
        Scale = scale,
        Offset = offset,
        Duration = duration,
    }
    UIMgr:ActiveUI(UI.CtrlNames.ModelAlarm, l_openData)
end

function ShowAlarmByCommand(_, args)
    local modeType = tonumber(args[0].Value)
    local hostId = tonumber(args[1].Value)
    local content = args[2].Value
    local duration = tonumber(args[3].Value)
    local scale = 1
    local offset =  { [0] = 0, [1] = 0, [2] = 0 }
    if args.Count > 4 then
        scale = tonumber(args[4].Value)
    end
    if args.Count > 5 then
        local offsetArr = string.ro_split(args[5].Value, ',')
        offset = { [0] = tonumber(offsetArr[0]), [1] = tonumber(offsetArr[1]), [2] = tonumber(offsetArr[2]) }
    end

    CommonUI.ModelAlarm.ShowAlarm(modeType, hostId, content, scale, offset, duration)
end

function HideAlarm()
	UIMgr:DeActiveUI(UI.CtrlNames.ModelAlarm)
end
