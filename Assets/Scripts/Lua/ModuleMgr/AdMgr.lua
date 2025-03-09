--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.AdMgr", package.seeall)
--lua model end
OpenUIDelay = 0

function OnInit()
    adData = DataMgr:GetData("AdData")
end

function UnInit()

    CloseTimer()
    adData = nil

end

--lua custom scripts
function CloseTimer()

    if _timer then
        _timer:Stop()
        _timer = nil
    end

end

function ForcesActiveUI(forceInit)

    CloseTimer()
    UIMgr:DeActiveUI(UI.CtrlNames.Announcement)
    if adData.GetLastAd() > 0 then
        if OpenUIDelay == 0 then
            if not forceInit then
                adData.NextAd()
            end
            UIMgr:ActiveUI(UI.CtrlNames.Announcement)
        else
            _timer = Timer.New(function()
                if not forceInit then
                    adData.NextAd()
                end
                UIMgr:ActiveUI(UI.CtrlNames.Announcement)
            end, OpenUIDelay, 1, true)
            _timer:Start()
        end
    end

end

function PushAdData(msg)

    ---@type PushAd2ClientData
    local l_info = ParseProtoBufToTable("PushAd2ClientData", msg)
    if l_info.datas and #l_info.datas > 0 then
        adData.UpdateInfo(l_info.datas)
        if not UIMgr:IsActiveUI(UI.CtrlNames.Announcement) then
            UIMgr:ActiveUI(UI.CtrlNames.Announcement)
        else
            ForcesActiveUI(true)
        end
    end

end
--lua custom scripts end
return ModuleMgr.AdMgr