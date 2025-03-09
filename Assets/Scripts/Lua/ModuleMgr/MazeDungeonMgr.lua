---@module ModuleMgr.MazeDungeonMgr
module("ModuleMgr.MazeDungeonMgr", package.seeall)

local l_mapSize = 357
local l_mapRowSize = 6
local l_mapColSize = 6
local l_map={}
local l_pathSp={}
local l_pathAtlas="PreyMap"
local l_lastRoomId = 0
local l_nowRoomId = 0
local l_entryTable={}
local l_roomEntry={}
local l_selectEntryId = 0
local l_mazeRoomEnterContent
local l_tipTime = 2
local l_wheelTipsContent
local l_hasPassKeyRoom=false
local l_firstPassKeyRoomIndex=-1

local l_mazeWheelOpen=true
local l_keyRoomPos=nil
--房间操作枚举
OperationType = 
{
    CameraSet = 1,    --相机参数设置
    MianUISet = 2,    --主界面UI设置
}



function OnInit()

    l_mazeRoomEnterContent = {}
    l_mazeRoomEnterContent[1] = Lang("MAZE_ROOM_ENTER_CHUSHENGDI")
    l_mazeRoomEnterContent[2] = Lang("MAZE_ROOM_ENTER_BOSS")
    l_mazeRoomEnterContent[3] = Lang("MAZE_ROOM_ENTER_GUAIWU")
    l_mazeRoomEnterContent[4] = Lang("MAZE_ROOM_ENTER_SHIJIAN")
    l_mazeRoomEnterContent[5] = Lang("MAZE_ROOM_ENTER_JUQING")
    l_mazeRoomEnterContent[6] = Lang("MAZE_ROOM_ENTER_JINGYING")
    l_mazeRoomEnterContent[7] = Lang("MAZE_ROOM_ENTER_CAIDAN")
    l_mazeRoomEnterContent[8] = Lang("MAZE_ROOM_ENTER_DUOBIQIU")
    l_mazeRoomEnterContent[9] = Lang("MAZE_ROOM_ENTER_CHASE_BOLI")

    l_roomEntry = {}
    l_entryTable = {}
    local l_rouleTable = TableUtil.GetRouletteTable().GetTable()
    for i=1,#l_rouleTable do
        l_entryTable[i] = l_rouleTable[i].Name
        if l_rouleTable[i].RoomType > 0 then
            l_roomEntry[l_rouleTable[i].RoomType] = i
        end
    end

    l_pathSp={}
    for i=0,1 do
        l_pathSp[i]={}
        for j=0,1 do
            l_pathSp[i][j]={}
            for k=0,1 do
                l_pathSp[i][j][k]={}
            end
        end
    end

    l_pathSp[0][0][0][0]="UI_PreyMap_Img_None.png"

    l_pathSp[1][0][0][0]="UI_PreyMap_Img_One01.png"
    l_pathSp[0][1][0][0]="UI_PreyMap_Img_One03.png"
    l_pathSp[0][0][1][0]="UI_PreyMap_Img_One04.png"
    l_pathSp[0][0][0][1]="UI_PreyMap_Img_One02.png"

    l_pathSp[1][1][0][0]="UI_PreyMap_Img_Two05.png"
    l_pathSp[1][0][1][0]="UI_PreyMap_Img_Two03.png"
    l_pathSp[1][0][0][1]="UI_PreyMap_Img_Two02.png"

    l_pathSp[0][1][1][0]="UI_PreyMap_Img_Two01.png"
    l_pathSp[0][1][0][1]="UI_PreyMap_Img_Two04.png"

    l_pathSp[0][0][1][1]="UI_PreyMap_Img_Two06.png"

    l_pathSp[1][1][1][0]="UI_PreyMap_Img_Three02.png"
    l_pathSp[1][1][0][1]="UI_PreyMap_Img_Three04.png"

    l_pathSp[0][1][1][1]="UI_PreyMap_Img_Three01.png"

    l_pathSp[1][0][1][1]="UI_PreyMap_Img_Three03.png"

    l_pathSp[1][1][1][1]="UI_PreyMap_Img_Four.png"

end

function GetPassPathSp(dir)
    local l_up=0
    if dir.up>0 then
        l_up=1
    end
    local l_left=0
    if dir.left>0 then
        l_left=1
    end
    local l_right=0
    if dir.right>0 then
        l_right=1
    end
    local l_down=0
    if dir.down>0 then
        l_down=1
    end
    local l_res = l_pathSp[l_up][l_down][l_left][l_right]
    if l_res == nil then
        logError("GetPassPathSp error:"..tostring(dir.up)..","..tostring(dir.down)..","..tostring(dir.left)..","..tostring(dir.right))
    end
    return l_res
end

function GetPosByRc(r,c)
    return Vector2.New(l_mapSize/l_mapColSize*(c-0.5),l_mapSize/l_mapRowSize*(r-0.5))
end

function GetPosById(id)
    local l_r,l_c = GetRcById(id)
    return GetPosByRc(l_r,l_c)
end

function AddMapCell(row,col,type,pass,dir)
    local l_cell={}
    l_cell.type = type
    l_cell.pass = pass
    l_cell.pos = GetPosByRc(row,col)
    l_cell.dir = {}
    l_cell.dir.up = dir.up or 0
    l_cell.dir.left = dir.left or 0
    l_cell.dir.right = dir.right or 0
    l_cell.dir.down  = dir.down or 0

    if l_map[row]==nil then
        l_map[row]={}
    end
    l_map[row][col]=l_cell
end

function GetRcById(id)
    local l_r = math.ceil(id/l_mapColSize)
    local l_c = (id-1)%l_mapColSize+1
    l_r = l_mapRowSize-l_r+1
    return l_r,l_c
end

function GetIdByRc(row,col)
    return (l_mapRowSize-row)*l_mapColSize+col
end

function GetDirPathSp(row,col)
    -- if l_lastRoomId>0 then
    --     local l_r,l_c = GetRcById(l_lastRoomId)
    --     if l_r == row then
    --         if l_c == col-1 then
    --             return l_pathSp[0][0][1][0]
    --         elseif l_c == col+1 then
    --             return l_pathSp[0][0][0][1]
    --         end
    --     elseif l_c == col then
    --         if l_r == row-1 then
    --             return l_pathSp[0][1][0][0]
    --         elseif l_r == row+1 then
    --             return l_pathSp[1][0][0][0]
    --         end
    --     end
    -- end
    -- return nil
    return l_pathSp[0][0][0][0]
end

function FreshMapCell()
    MapObjMgr:RmObj(MapObjType.MazeDungRoom)
    MMazeDungeonMgr:RmData()
    for r=1,l_mapRowSize do
        if l_map[r]~=nil then
            for c=1,l_mapColSize do
                local l_cell=l_map[r][c]
                if l_cell~=nil then
                    local l_id = GetIdByRc(r,c)
                    local l_longId = MLuaCommonHelper.ULong(l_id)
                    if l_cell.pass==true then
                        local l_sp = GetPassPathSp(l_cell.dir)
                        if l_sp ~= nil then
                            MMazeDungeonMgr:AddData(l_id,l_cell.pos,l_sp,Vector2.New(0.25,0.25))
                        end
                        if l_cell.type == MazeRoomType.kMazeRoomTypeBornRoom then
                            local l_mazeRow = TableUtil.GetMazeRoomTable().GetRowByTypeId(l_cell.type)
                            if l_mazeRow~=nil then
                                MapObjMgr:AddObj(MapObjType.MazeDungRoom,l_longId,l_cell.pos)
                                MapObjMgr:MdObj(MapObjType.MazeDungRoom,l_longId,l_mazeRow.IconName)
                                MapObjMgr:MdObj(MapObjType.MazeDungRoom,l_longId,5.625)
                            end
                        end
                    else
                        if l_id==l_nowRoomId then
                            local l_sp = GetDirPathSp(r,c)
                            if l_sp~=nil then
                                MMazeDungeonMgr:AddData(l_id,l_cell.pos,l_sp,Vector2.New(0.25,0.25))
                            end
                        end 
                    end
                    
                    if l_cell.type == MazeRoomType.kMazeRoomTypeBossRoom
                            or l_cell.type == MazeRoomType.kMazeRoomTypeKeyRoom then
                        local l_mazeRow = TableUtil.GetMazeRoomTable().GetRowByTypeId(l_cell.type)
                        if l_mazeRow~=nil then
                            MapObjMgr:AddObj(MapObjType.MazeDungRoom,l_longId,l_cell.pos)
                            MapObjMgr:MdObj(MapObjType.MazeDungRoom,l_longId,l_mazeRow.IconName)
                        end
                    end
                end
            end
        end
    end
end

function EnterDungeons(dungeonId)
    MgrMgr:GetMgr("DungeonMgr").EnterDungeons(dungeonId,0,0)
end

function OnMazeDungeonsMapNtf(msg)
    ---@type MazeSyncRoomsData
    local l_info = ParseProtoBufToTable("MazeSyncRoomsData", msg)
    l_map = {}
    local l_isGm = l_info.is_gm
    for i=1,#l_info.datas do
        local l_mapData=l_info.datas[i]

        local l_r,l_c = GetRcById(l_mapData.index)
        local l_pass = l_isGm and true or (l_mapData.status == MazeRoomNtfStatus.kMazeRoomNtfStatusVictory)
        if l_mapData.path_status == MazePathStatus.kMazePathStatusNowRoom then
            l_nowRoomId = l_mapData.index
            MMazeDungeonMgr:SetPlayerPos(GetPosById(l_nowRoomId))
            if l_pass == false then
                UIMgr:ActiveUI(UI.CtrlNames.TipsDlg, function (ctrl)
                    ctrl:ShowDungeonHintsStory(l_mazeRoomEnterContent[l_mapData.type], l_tipTime)
                end)
            end
        elseif l_mapData.path_status == MazePathStatus.kMazePathStatusLastRoom then
            l_lastRoomId = l_mapData.index
        end
        if l_mapData.type == MazeRoomType.kMazeRoomTypeKeyRoom and l_pass then
            if not l_hasPassKeyRoom then
                l_firstPassKeyRoomIndex=l_mapData.index
            end
            l_hasPassKeyRoom=true
        end
        AddMapCell(l_r,l_c,l_mapData.type, l_pass ,l_mapData.directions)
    end
    PrintMazeType(l_isGm,l_info.datas)
    FreshMapCell()
end

--需求 输出日志到控制台
function PrintMazeType(isGm,datas)
    if isGm then
        local l_mazeType = ""
        for i=1,#datas do
            l_mazeType = l_mazeType .. (datas[i].type and datas[i].type or "&") .." | "..(i%6==0 and "\n" or "")
        end
        logError("------------------------".."\n"..l_mazeType)
    end
end

function OnMazeDungeonsIncreaseMapNtf(msg)
    ---@type MazeSyncRoomsData
    local l_info = ParseProtoBufToTable("MazeSyncRoomsData", msg)
    local l_AddPassKeyRoom=false
    local l_keyRoomIndex=0
    for i=1,#l_info.datas do
        local l_mapData=l_info.datas[i]
        local l_r,l_c = GetRcById(l_mapData.index)
        local l_pass = (l_mapData.status==MazeRoomNtfStatus.kMazeRoomNtfStatusVictory)
        if l_mapData.path_status==MazePathStatus.kMazePathStatusNowRoom then
            l_nowRoomId = l_mapData.index
            MMazeDungeonMgr:SetPlayerPos(GetPosById(l_nowRoomId))
            if l_pass == false then
                UIMgr:ActiveUI(UI.CtrlNames.TipsDlg, function (ctrl)
                    ctrl:ShowDungeonHintsStory(l_mazeRoomEnterContent[l_mapData.type], l_tipTime)
                end)
            elseif l_mapData.type==MazeRoomType.kMazeRoomTypeKeyRoom then
                l_AddPassKeyRoom=true
                l_keyRoomIndex=l_mapData.index
            end
        elseif l_mapData.path_status==MazePathStatus.kMazePathStatusLastRoom then
            l_lastRoomId = l_mapData.index
        end

        if l_mapData.type==MazeRoomType.kMazeRoomTypeBornRoom then
            l_hasBornRoom=true
        elseif l_mapData.type==MazeRoomType.kMazeRoomTypeKeyRoom or l_mapData.type==MazeRoomType.kMazeRoomTypeBossRoom then
            if l_keyRoomPos==nil then
                l_keyRoomPos=GetPosByRc(l_r,l_c)
                ShowRadar()
            end
        end

        AddMapCell(l_r,l_c,l_mapData.type, l_pass ,l_mapData.directions)
    end
    if l_AddPassKeyRoom and not l_hasPassKeyRoom then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("UNLOCK_MVP_ROOM"))
        if not l_hasPassKeyRoom then
            l_firstPassKeyRoomIndex=l_keyRoomIndex
        end
        l_hasPassKeyRoom=true
    end
    FreshMapCell()
end
function HasPassKeyRoom()  --仅供钥匙房逻辑配置用
    if not l_hasPassKeyRoom then  --未通关钥匙房
        return 0
    end
    if l_firstPassKeyRoomIndex==l_nowRoomId then --第一次通关的钥匙房
        return 1
    end
    return 2  --第二次通关的钥匙房
end
function ShowRadar(mazeWheelClose)
    if mazeWheelClose then
        l_mazeWheelOpen=false
    end
    if l_mazeWheelOpen or l_keyRoomPos==nil then
        return
    end
    ShowRadarEffect(l_keyRoomPos)
end
function ShowRadarEffect(pos)
    Common.CommonUIFunc.AddMapEffect(pos,"Fx_Ui_XiaoDiTuLeiDa_01",Vector2.New(500,500),nil,3,nil,nil,true)
end
function OnDungeonsResult(msg)
    ---@type DungeonsResultData
    local l_info = ParseProtoBufToTable("DungeonsResultData", msg)
    if l_info.status == DungeonsResultStatus.kResultMazeRoomVictory then
        --房间胜利结算
        local l_mazeRoomRow = TableUtil.GetMazeRoomTable().GetRowByTypeId(tonumber(l_info.room_type))
        if l_mazeRoomRow and l_mazeRoomRow.IsShowSuccessUI then
            if l_mazeRoomRow.SuccessNpcID == 0 then 
                logError("房间配置问题@阿黛尔 房间类型ID = "..tostring(l_info.room_type))
                return 
            end
            local l_strIndex = math.random(0, l_mazeRoomRow.SuccessTips.Count - 1)
            CommonUI.ModelAlarm.ShowAlarm(2, l_mazeRoomRow.SuccessNpcID, l_mazeRoomRow.SuccessTips[l_strIndex])
            local l_timer = Timer.New(function(b)
                --CommonUI.ModelAlarm.HideAlarm()
            end, MGlobalConfig:GetInt("MazeVictoryUICountDown"))
            l_timer:Start()
        end
    elseif l_info.status == DungeonsResultStatus.kResultVictory then
        --如果是最后结算胜利  则和主题副本一样的结算
        MgrMgr:GetMgr("ThemeDungeonMgr").OnDungeonsResult(msg)
    elseif l_info.status == DungeonsResultStatus.kResultLose then
        --团灭显示重置倒计时
        local l_time = tonumber(TableUtil.GetGlobalTable().GetRowByName("MazeRoomReviveTime").Value)
        UIMgr:ActiveUI(UI.CtrlNames.DungenAlarm, function(ctrl)
            ctrl:ShowAlarmByString(Lang("MAZE_DUNGEON_WAIT_FOR_RESET_LEVEL"), true, false, l_time, l_time)
        end)
    end
end

function OnRunRoulette(msg)
    
end

function OnRunRouletteNtf(msg)
    ---@type RouletteInfo
    local l_info = ParseProtoBufToTable("RouletteInfo", msg)
    l_hasPassKeyRoom=false
    l_firstPassKeyRoomIndex=-1
    local l_error = l_info.result or ErrorCode.ERR_SUCCESS
    if l_error == ErrorCode.ERR_SUCCESS then
        l_selectEntryId = l_roomEntry[l_info.room_type]
        if l_selectEntryId == nil then
            l_selectEntryId = 0
        else
            local l_mazeRoomRow = TableUtil.GetMazeRoomTable().GetRowByTypeId(l_info.room_type)
            l_wheelTipsContent = StringEx.Format(Lang("MAZE_WHEEL_FINISH"),l_mazeRoomRow.Name)
            UIMgr:ActiveUI(UI.CtrlNames.MazeDungeonWheel)
        end
    end

    l_mazeWheelOpen=true
    l_keyRoomPos=nil
end

--接收迷雾之森房间开始还是关闭
function OnMazeRoomStartOrEndNtf(msg)
    ---@type MazeRoomStartOrEndData
    local l_info = ParseProtoBufToTable("MazeRoomStartOrEndData", msg)

    if l_info.start_or_end then
        --房间开始
        MgrMgr:GetMgr("DungeonMgr").RoomStartTime = l_info.start_time  --房间开始时间记录

        if l_info.room_type == MazeRoomType.kMazeRoomTypeDuobi then
            --躲避球房间
            MazeAvoidRoomStart(l_info.start_time)
        end
        
    else
        --房间结束
        if l_info.room_type == MazeRoomType.kMazeRoomTypeDuobi then
            --躲避球房间
            MazeAvoidRoomEnd()
        end
    end

end

function GetEntryTable()
    return l_entryTable
end

function GetSelectEntryId()
    return l_selectEntryId
end

function GetWheelTipsContent()
    return l_wheelTipsContent
end

function RequestRunRoulette()
    local l_msgId = Network.Define.Rpc.RunRoulette
    ---@type EmptyMsg
    local l_sendInfo = GetProtoBufSendTable("EmptyMsg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
    l_selectEntryId = 0
end

function ShowTips(str)
    if str==nil then
        logError("str is nil")
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.TipsDlg, function (ctrl)
        ctrl:ShowDungeonHintsStory(str, l_tipTime)
    end)
end

--迷雾之森的躲避球房间开始
function MazeAvoidRoomStart()
    local l_mazeRoomRow = TableUtil.GetMazeRoomTable().GetRowByTypeId(8)
    if l_mazeRoomRow then
        --固有操作进行
        MazeOperate(l_mazeRoomRow.StartOperation)
        if not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
            --躲避球信息界面
            UIMgr:ActiveUI(UI.CtrlNames.AvoidPanel, function (ctrl)
                local l_playerHp = tonumber(TableUtil.GetMazeOperationTable().GetRowByTypeId(10000).Value)
                local l_rage = {}
                local l_rageTimeStr = TableUtil.GetMazeOperationTable().GetRowByTypeId(10001).Value
                local l_rageGroup = string.ro_split(l_rageTimeStr, "|")
                for i = 1, #l_rageGroup do
                    local l_rageArgs = string.ro_split(l_rageGroup[i], "=")
                    table.insert(l_rage, l_rageArgs)
                end
                ctrl:SetData(l_mazeRoomRow.VictoryCondition1[0][1], l_playerHp, l_rage, l_mazeRoomRow.StartCountDown)
            end)
        end
        --躲避球倒计时界面
        UIMgr:ActiveUI(UI.CtrlNames.DungeonCountDown, function(ctrl)
            ctrl:Play(MgrMgr:GetMgr("DungeonMgr").RoomStartTime,
                l_mazeRoomRow.StartCountDown, Lang("DUNGEON_START_BATTLE"))
        end)
        --关闭箭矢选择界面
        UIMgr:DeActiveUI(UI.CtrlNames.MainArrows)
    end
end

function MazeAvoidRoomEnd()

    MazeCameraRestore()

    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        MgrMgr:GetMgr("WatchWarMgr").ResetWatchUI()
        return
    end

    local l_sceneRow = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
    if l_sceneRow then
        MgrMgr:GetMgr("SceneEnterMgr").ResetSceneUIWithId(l_sceneRow.SceneUiId)
    end

end

--迷雾之森固有操作进行
--operateIds  操作的ID列表
function MazeOperate(operateIds)
    for i = 0, operateIds.Count - 1 do
        local l_operationRow = TableUtil.GetMazeOperationTable().GetRowByTypeId(operateIds[i])
        if l_operationRow then
            if l_operationRow.Type == OperationType.CameraSet then
                local l_cameraSetArgGroup = string.ro_split(l_operationRow.Value, "=")
                MazeCameraSet(l_cameraSetArgGroup)
            elseif l_operationRow.Type == OperationType.MianUISet then
                if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
                    MgrMgr:GetMgr("WatchWarMgr").ResetWatchUI()
                else
                MgrMgr:GetMgr("SceneEnterMgr").ResetSceneUIWithId(tonumber(l_operationRow.Value))
                end
            end
        end
    end
end
--迷雾之森相机设置变化
--args  相机设置参数 7个数字 前三位POS 中间三位ROT 末位FOV
function MazeCameraSet(args)
    if #args < 7 then return end
    --关闭拍照模式
    MPlayerInfo.IsPhotoMode = false
    --相机状态修改
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamChangeState, MScene.GameCamera, MoonClient.MCameraState.Fixed)
    --位置数据获取
    local l_pos = Vector3.New(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
    --角度数据获取
    local l_rot = Quaternion.Euler(tonumber(args[4]), tonumber(args[5]), tonumber(args[6]))
    --广角数据获取
    local l_fov = tonumber(args[7])
    --事件发送
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamFixedAction, MScene.GameCamera, l_pos, l_rot, l_fov, 0)
end

--相机还原
function MazeCameraRestore()

    MEventMgr:LuaFireEvent(MEventType.MEvent_CamChangeState, MScene.GameCamera, MoonClient.MCameraState.Normal)

end
return MazeDungeonMgr