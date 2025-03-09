---@module ModuleMgr.AntiAdditionMgr
module("ModuleMgr.AntiAdditionMgr", package.seeall)

AntiAddictionType = {
    Notice = 4205,
    Fobbiden = 4207,
    Verify = 4209,
}

local m_beginTime = -1
local m_endTime = -1

function OnInit()
end

function OnUnInit()
end

function ProcessAntiAddictionMsg(msg)
    local resInfo = ParseProtoBufToTable("AntiAddictionData", msg)
    if resInfo ~= nil then
        if resInfo.cmd_id == AntiAddictionType.Notice then
            CommonUI.Dialog.ShowOKDlg(true, nil, resInfo.msg_content, nil)
        elseif resInfo.cmd_id == AntiAddictionType.Fobbiden then
            if resInfo.begin_time ~= nil and resInfo.end_time ~= nil then
                m_beginTime = resInfo.begin_time
                m_endTime = resInfo.end_time
            end

            CommonUI.Dialog.ShowOKDlg(true, nil, resInfo.msg_content, function ()
                if m_beginTime > 0 and m_endTime > 0 then
                    local curTime = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
                    if curTime > m_beginTime and curTime < m_endTime then
                        --退出到登陆界面
                        game:GetAuthMgr():LogoutToAccount()
                    end
                end

                m_beginTime = -1
                m_endTime = -1
            end)
        elseif resInfo.cmd_id == AntiAddictionType.Verify then
            --打开浏览器界面
            if resInfo.json_str ~= nil then
                MLogin.OpenFullScreenWebViewWithJson(CJson.encode({json = resInfo.json_str}))
            end
        end

        if resInfo.trace_id ~= nil then
            MLogin.ReportPrajna(CJson.encode({serialnumber = resInfo.trace_id}))
        end
    end
end