--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.CordFireMgr", package.seeall)

l_eventDispatcher = EventDispatcher.new()

SIG_CORDFIRE_PAUSE = "SIG_CORDFIRE_PAUSE"

OpenType = {
    Open = 1,           --仅打开，不播放任何特效
    CountDown = 2,      --计时
}



--lua model end

--lua custom scripts

--lua custom scripts end
return ModuleMgr.CordFireMgr