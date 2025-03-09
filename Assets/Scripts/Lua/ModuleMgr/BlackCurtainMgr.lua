---@module ModuleMgr.BlackCurtainMgr
module("ModuleMgr.BlackCurtainMgr", package.seeall)
--任务框架实现文档wiki地址 ：https://www.tapd.cn/20332331/markdown_wikis/view/#1120332331001005044

local l_currentBlackCurtainId = 0
local l_currentBlackCurtainData = {}
local l_callBack = nil
local l_fadeInCallBack = nil
local l_fadeOutCallBack = nil
local l_lineTime = 1
local l_currentIndex = 0
local l_fadeInTime = 2
local l_showTime = 2
local l_fadeOutTime = 1

function OnLogout()
	ResetData()
end

function IsInBlackCurtain( ... )
	return l_currentBlackCurtainId ~= 0
end

function GetCurrentId()
	return l_currentBlackCurtainId
end

function GetTimeData()
	local l_timeData = {}
	l_timeData.fadeIn = l_fadeInTime
	l_timeData.show = l_showTime
	l_timeData.fadeOut = l_fadeOutTime
	return l_timeData
end

function OnPlayBlackCurtainByServer(msg)
	---@type CallBlackCurtainData
	local l_info = ParseProtoBufToTable("CallBlackCurtainData", msg)
    if l_info.id == 0 then
    	return
    end
    PlayBlackCurtain(l_info.id)
end

--==============================--
--desc:播放黑幕
--@callBack:播放完回调(可缺省)
--@fadeInCallBack:黑幕完全呈现时回调(可缺省)
--@fadeInTime:黑幕淡入时间(可缺省)
--@showTime:黑幕呈现时间(可缺省)
--@fadeOutTime:黑幕淡出时间(可缺省)
--return 是否播放成功
function BlackCurtain(callBack,fadeInCallBack,fadeOutCallBack,fadeInTime,showTime,fadeOutTime, isNormalLayer)

	l_currentBlackCurtainId = -1
	l_callBack = callBack
	l_fadeInCallBack = fadeInCallBack
	l_fadeOutCallBack = fadeOutCallBack
	l_fadeInTime = fadeInTime or l_fadeInTime
	l_showTime = showTime or l_showTime
	l_fadeOutTime = fadeOutTime or l_fadeOutTime
	if isNormalLayer then
		UIMgr:ActiveUI(UI.CtrlNames.BlackCurtainNormal)
	else
		UIMgr:ActiveUI(UI.CtrlNames.BlackCurtain)
	end
end


--==============================--
--desc:播放黑幕
--@blackCurtainId:黑幕ID
--@callBack:播放完回调(可缺省)
--@fadeInCallBack:黑幕完全呈现时回调(可缺省)
--@fadeOutCallBack:黑幕完全消失时回调(可缺省)
--@fadeInTime:黑幕完全呈现时间(可缺省)
--@showTime:黑幕显示时间(可缺省)
--@fadeOutTime:黑幕完全消失时间(可缺省)
--@loadCallBack:加载回调(可缺省)
--return 是否播放成功
--==============================--
function PlayBlackCurtain(blackCurtainId,callBack,fadeInCallBack,fadeOutCallBack,fadeInTime,showTime,fadeOutTime, loadCallBack)
	if l_currentBlackCurtainId == blackCurtainId then
		return false
	end
	if IsInBlackCurtain() then
		return false
	end
    local l_tableData = TableUtil.GetBlackCurtainTable().GetRowById(blackCurtainId)
    if l_tableData == nil then
    	logError("BlackCurtain Id:<"..blackCurtainId.."> not exists in Table Blackcurtain !@王倩雯")
    	return false
    end
    MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
    MgrMgr:GetMgr("ActionTargetMgr").StopAutoBattle()
    ParseBlackCurtainData(l_tableData.Content, l_tableData.Time)
	l_currentBlackCurtainId = blackCurtainId
	l_callBack = callBack
	l_fadeInCallBack = fadeInCallBack
	l_fadeOutCallBack = fadeOutCallBack
	l_currentIndex = 0
	l_fadeInTime = fadeInTime or l_fadeInTime
	l_showTime = showTime or l_showTime
	l_fadeOutTime = fadeOutTime or l_fadeOutTime
	UIMgr:ActiveUI(UI.CtrlNames.BlackCurtain, function(ctrl)
		if loadCallBack then
			loadCallBack(ctrl)
		end
	end)
    return true
end

function PlayBlackCurtainByCutScene(blackCurtainId, fadeInTime,showTime,fadeOutTime)

	PlayBlackCurtain(blackCurtainId, nil, nil, nil, fadeInTime,showTime,fadeOutTime, function(ctrl)
		if ctrl and ctrl.uObj then
			for i = 0, ctrl.panel.PanelRef.Canvases.Length -1 do
                ctrl.panel.PanelRef.Canvases[i].gameObject.layer = MLayer.ID_CutSceneUI
			end
			ctrl.uObj.transform:SetAsFirstSibling()
			ctrl:_setRaycaster(false)
		end
	end)
end

function DeActiveByCutScene()

	UIMgr:DeActiveUI(UI.CtrlNames.BlackCurtain)
end

function DebugBlackCurtainData()
	for i=1,#l_currentBlackCurtainData do
		logGreen("paragraph idx:"..i)
		local l_paragraph = l_currentBlackCurtainData[i]
		for j=1,#l_paragraph.content do
			local l_line = l_paragraph.content[j]
			logGreen("line idx:"..j..", content:"..l_line.content..",time:"..l_line.time)
		end
	end
end

function GetNextParagraph()
	l_currentIndex = l_currentIndex + 1
	if l_currentIndex > #l_currentBlackCurtainData then
		return nil	
	end
	return l_currentBlackCurtainData[l_currentIndex]
end

function CheckShowCompleted()
	if l_fadeInCallBack ~= nil then
		l_fadeInCallBack()
		l_fadeInCallBack = nil
	end
end

function CheckFadeOut( ... )
	if l_fadeOutCallBack ~= nil then
		l_fadeOutCallBack()
		l_fadeOutCallBack = nil
	end
end

function CheckPlayCompleted( ... )
	if l_callBack ~= nil then
		l_callBack()
		l_callBack = nil
	end
end

function PlayCompleted()
	if l_currentBlackCurtainId ~= -1 then
		GlobalEventBus:Dispatch(EventConst.Names.OnPlayBlackCurtainCompleted,l_currentBlackCurtainId)
	end
	CheckShowCompleted()
	CheckFadeOut()
	CheckPlayCompleted()
	ResetData()
end

function ResetData( ... )
	l_currentBlackCurtainId = 0
	l_currentBlackCurtainData = {}
	l_callBack = nil
	l_fadeInCallBack = nil
	l_fadeOutCallBack = nil
	l_currentIndex = 0
	l_fadeInTime = 2
	l_showTime = 2
	l_fadeOutTime = 1
end

function ParseBlackCurtainData(dataStr, time)
	l_currentBlackCurtainData = {}
	local l_paragraphs = string.ro_split(dataStr,"@")
	for i=1, #l_paragraphs do
		local l_lines = string.ro_split(l_paragraphs[i],"|")
		local l_blackCurtainData = {}
		l_blackCurtainData.content = ParseParagraph(l_lines)
		l_blackCurtainData.time = time
		table.insert(l_currentBlackCurtainData,l_blackCurtainData)
	end
end

function ParseParagraph(lines)
	local l_paragraph = {}
	for i=1, #lines do
		local l_lineData = ParseLineData(lines[i])
		if l_lineData then
			table.insert(l_paragraph, l_lineData)
		end
	end
	return l_paragraph
end

function ParseLineData(lineId)
	local l_row = TableUtil.GetBlackCurtainContentTable().GetRowById(lineId)
	local l_lineData = {}
	l_lineData.content = l_row.Content
	l_lineData.time = l_row.Time
	l_lineData.cv = l_row.CV
	return l_lineData
end

return BlackCurtainMgr