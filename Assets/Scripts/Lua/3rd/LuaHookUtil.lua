local LuaHookUtil = {};
local RecordLogs = {};
LuaHookUtil.isPrintingLog = false;
LuaHookUtil.ExcuteCount = 0;

local socket = require("socket")

function LuaHookUtil.Init()
	--collectgarbage("stop");
	LuaHookUtil.MemeryClearAllLog();
	LuaHookUtil.Start();
end

function LuaHookUtil.Record(key, log)
	if LuaHookUtil.isPrintingLog then
		return;
	end
	if not RecordLogs[key] then
		return;
	end
	local runTime = socket.gettime() - RecordLogs[key].startTime;
	local addMemory = collectgarbage("count") - RecordLogs[key].lastMem - LuaHookUtil.ExcuteCount*0.46025;
	RecordLogs[key].totalAdd = RecordLogs[key].totalAdd + addMemory;
	RecordLogs[key].totalTime = RecordLogs[key].totalTime + runTime;
	RecordLogs[key].Average = RecordLogs[key].totalAdd / RecordLogs[key].count;
	RecordLogs[key].averageTime = RecordLogs[key].totalTime / RecordLogs[key].count;
	if RecordLogs[key].MaxAdd < addMemory then
		RecordLogs[key].MaxAdd = addMemory;
	end
	if log then
		error(addMemory);
	end
end

function LuaHookUtil.AddLog(key)
	if LuaHookUtil.isPrintingLog then
		return;
	end
	if not RecordLogs[key] then
		RecordLogs[key] = {key = "", lastMem = 0, totalAdd = 0, MaxAdd = 0, startTime = 0, totalTime = 0, averageTime = 0, count = 0, Average = 0};
		RecordLogs[key].key = key;
	end
	RecordLogs[key].lastMem = collectgarbage("count") - LuaHookUtil.ExcuteCount*0.46025;
	RecordLogs[key].startTime = socket.gettime();
	RecordLogs[key].count = RecordLogs[key].count + 1;
end

function LuaHookUtil.MemeryClearAllLog()
	RecordLogs = {};
	LuaHookUtil.ExcuteCount = 0;
	--LuaGC();
end

local function SortFunc(a, b)
	return a.totalTime > b.totalTime;
end

local RecordLogsArr = {};
function LuaHookUtil.PrintAllLog()
	LuaHookUtil.isPrintingLog = true;
	for key, value in pairs(RecordLogs) do
		table.insert(RecordLogsArr, value);
	end
	table.sort(RecordLogsArr, SortFunc);
	local l_ret = {}
	table.insert(l_ret, string.format("#Count%s#AverageTime%s#TotalTime", string.rep(" ", 8), string.rep(" ", 8)));
	for i, value in ipairs(RecordLogsArr) do
		table.insert(l_ret, string.format("%s\n%-13d%-19f%-17f", value.key, value.count, value.averageTime, value.totalTime));
	end

	local str = table.concat(l_ret, "\n")

	RecordLogsArr = {};
	local date = os.date("!*t",Common.TimeMgr.GetLocalNowTimestamp())
	local affix = string.format("%d%02d%02d%02d%02d%02d", date.year, date.month, date.day, date.hour, date.min, date.sec)
	local fileName = string.format("LuaHookDetail%s.txt", affix)
	File.WriteAllText(fileName, str);
	LuaHookUtil.isPrintingLog = false;
end

function LuaHookUtil.Start()
	debug.sethook(LuaHookUtil.Profiling_Handler, 'cr', 0)
end

function LuaHookUtil.Stop()
	debug.sethook()
end

local funcinfo = nil;
function LuaHookUtil.Profiling_Handler(hooktype)

	LuaHookUtil.ExcuteCount = LuaHookUtil.ExcuteCount +1;
    funcinfo = debug.getinfo(2, 'nS')

    if hooktype == "call" then
        LuaHookUtil.Profiling_Call(funcinfo)
    elseif hooktype == "return" then
        LuaHookUtil.Profiling_Return(funcinfo)
    end
    funcinfo = nil;
end

function LuaHookUtil.Func_Title(funcinfo)
    assert(funcinfo)
    local name = funcinfo.name or 'anonymous'
    local line = string.format("%d", funcinfo.linedefined or 0)
    local source = funcinfo.short_src or 'C_FUNC'
    return name, source, line;
end

-- get the function report
function LuaHookUtil.Func_Report(funcinfo)
    local name, source, line = LuaHookUtil.Func_Title(funcinfo)
    return source .. ":" .. name; 
end

-- profiling call
function LuaHookUtil.Profiling_Call(funcinfo)

    -- get the function report
    local report = LuaHookUtil.Func_Report(funcinfo)
    assert(report)
    LuaHookUtil.AddLog(report);
end

-- profiling return
function LuaHookUtil.Profiling_Return(funcinfo)
    local report = LuaHookUtil.Func_Report(funcinfo)
    assert(report)
    LuaHookUtil.Record(report);
end

function LuaHookUtil.PrintCurrentMem()
	error(collectgarbage("count"));
end

return LuaHookUtil