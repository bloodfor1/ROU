---@module CommonUI.Dialog
module("CommonUI.Dialog", package.seeall)
----------------------------------------------   对话框相关   ---------------------------------------------------------
--对话框模式枚举
DialogModel = {
    NORMAL = 0, --普通对话框/点赞对话框
    INPUT = 1, --文本输入对话框
    DROPDOWN = 2, --下拉选择对话框
    CONSUME = 3, --物品消耗对话框
    CONSUMECHOOSE = 4, --物品消耗选择对话框
    COSTCHECK = 5, --文字提示确认对话框（两行）
    COMMONREWARD = 6, --通用奖励对话框
}
--对话框的内容类型
---@class DialogTopic
DialogTopic = {
    ALL = 0, --所有对话框
    NORMAL = 1, --没有特殊意义的对话框
    DUNGEON_QUIT = 2, --副本退出确认的对话框
    GUILD = 3, --公会
    GUILD_DEPOSITORY_MGR = 4, --公会仓库管理对话框
    GUILD_DEPOSITORY_SALE = 5, --公会仓库拍卖对话框
}

--对话框类型枚举
DialogType = {
    NONE = 0, --？
    OK = 1, --单按钮对话框
    YES_NO = 2, --双按钮对话框
    PRAISE = 3, --点赞专用对话框（仅限普通对话框）
    PaymentConfirm = 4, -- 消耗真实货币确认框（多了提示文本和链接）
}

DontShowTable = {} --本次登录不再提示的Dlg标识
--对话框主题设置状态表（用于某些情况下需要关闭关联的所有对话框 同时防止误关别的功能的对话框）
local l_DialogTopicState = {
    [DialogModel.NORMAL] = DialogTopic.NORMAL,
    [DialogModel.INPUT] = DialogTopic.NORMAL,
    [DialogModel.DROPDOWN] = DialogTopic.NORMAL,
    [DialogModel.CONSUME] = DialogTopic.NORMAL,
    [DialogModel.CONSUMECHOOSE] = DialogTopic.NORMAL,
    [DialogModel.COSTCHECK] = DialogTopic.NORMAL,
    [DialogModel.COMMONREWARD] = DialogTopic.NORMAL,
}

--单按钮对话框(只有确定按钮)
--autoHide          bool       点击按钮后是否自动关闭
--title            string      对话框标题 默认为“提示”
--txt              string      对话框显示的内容
--onConfirm                    按钮绑定的点击事件
--delayConfirm      int        对话框持续时间 不大于0或为空则不倒计时 对话框一直存在 倒计时结束直接触发点击效果 并关闭对话框
--togType           int        勾选框 类型  0无勾选框  1不再提示(本次登录)  2今日不再提示  3双向不再提示(勾选后无论确定还是取消都会记录操作) 4本机本号永远不再提示
--showHideTogName  string      对话框的key 类型3的勾选框选中后 以后该值相同的对话框不再显示 默认为当次的选择
--activeCallback               对话框激活后的回调
--dialogTopic                  对话框的主题类型 请用枚举 DialogTopic
function ShowOKDlg(autoHide, title, txt, onConfirm, delayConfirm, togType, showHideTogName, activeCallback, dialogTopic, allowRepeat, inputStr)
    local l_confirm = Common.Utils.Lang("DLG_BTN_OK")
    ShowDlg(DialogType.OK, autoHide, title, txt, l_confirm, "", onConfirm, nil, delayConfirm, togType, showHideTogName, activeCallback, dialogTopic, allowRepeat, nil, nil, inputStr)
end

--支付确认对话框
function ShowPayConfirmDlg(autoHide, title, txt, onConfirm, onCancel, delayConfirm, togType, showHideTogName, activeCallback, dialogTopic, allowRepeat, anchor, extraData)
    local l_confirm = Common.Utils.Lang("DLG_BTN_YES")
    local l_cancel = Common.Utils.Lang("DLG_BTN_NO")
    ShowDlg(DialogType.PaymentConfirm, autoHide, title, txt, l_confirm, l_cancel, onConfirm, onCancel, delayConfirm, togType, showHideTogName, activeCallback, dialogTopic, allowRepeat, anchor, extraData)
end

--双按钮对话框(确定和取消)
--autoHide          bool       点击按钮后是否自动关闭
--title            string      对话框标题 默认为“提示”
--txt              string      对话框显示的内容
--onConfirm                    确定按钮绑定的点击事件
--onCancel                     取消按钮绑定的点击事件
--delayConfirm      int        对话框持续时间 不大于0或为空则不倒计时 对话框一直存在 倒计时结束直接触发确认按钮点击效果 并关闭对话框
--togType           int        勾选框 类型  0无勾选框  1不再提示(本次登录)  2今日不再提示  3双向不再提示(勾选后无论确定还是取消都会记录操作) 4本机本号永远不再提示
--showHideTogName  string      对话框的key 类型3的勾选框选中后 以后该值相同的对话框不再显示 默认为当次的选择
--activeCallback               对话框激活后的回调
--dialogTopic                  对话框的主题类型 请用枚举 DialogTopic
--extraData                    对话框所需的额外的数据，比如图片点击相关信息
function ShowYesNoDlg(autoHide, title, txt, onConfirm, onCancel, delayConfirm, togType, showHideTogName, activeCallback, dialogTopic, allowRepeat, anchor, extraData, inputStr)
    local l_confirm = Common.Utils.Lang("DLG_BTN_YES")
    local l_cancel = Common.Utils.Lang("DLG_BTN_NO")
    ShowDlg(DialogType.YES_NO, autoHide, title, txt, l_confirm, l_cancel, onConfirm, onCancel, delayConfirm, togType, showHideTogName, activeCallback, dialogTopic, allowRepeat, anchor, extraData, inputStr)
end
--点赞框
--targetId               点赞目标的ID
--title        string    对话框标题 默认为“提示”
--txt          string    需要显示的文本
--delayConfirm  int      对话框持续时间 不大于0或为空则不倒计时 对话框一直存在 倒计时结束直接触发确认按钮点击效果 并关闭对话框
function ShowPraiseDlg(targetId, title, txt, delayConfirm)
    local l_cancel = Common.Utils.Lang("DLG_BTN_NO")
    ShowDlg(DialogType.PRAISE, false, title, txt, "", l_cancel, function()
        MgrMgr:GetMgr("ThemeDungeonMgr").SendDungeonsEncourage(targetId)
        MgrMgr:GetMgr("TeamMgr").GetUserInTeamOrNot(targetId)
    end, function()
        UIMgr:DeActiveUI(UI.CtrlNames.Dialog)
    end, delayConfirm)
end
-- 自定义对话框(撑死两个按钮 三个按钮是不存在的)
-- dlgType                      对话框类型 请用枚举 DialogType
-- autoHide          bool       点击按钮后是否自动关闭
-- title            string      对话框标题 默认为“提示”
-- txt              string      需要显示的文本
-- txtConfirm       string      确定按钮的自定义文字
-- txtCancel        string      取消按钮的自定义文字
-- onConfirm                    确定按钮绑定的点击事件
-- onCancel                     取消按钮绑定的点击事件
-- delayConfirm      int        对话框持续时间 不大于0或为空则不倒计时 对话框一直存在 倒计时结束直接触发确认按钮点击效果 并关闭对话框
-- togType           int        勾选框 类型  0无勾选框  1不再提示(本次登录)  2今日不再提示  3双向不再提示(勾选后无论确定还是取消都会记录操作)  4本机本号永远不再提示
-- showHideTogName  string      对话框的key 类型3的勾选框选中后 以后该值相同的对话框不再显示 默认为当次的选择
-- activeCallback               对话框激活后的回调
-- dialogTopic                  对话框的主题类型 请用枚举 DialogTopic
-- allowRepeat      bool        是否允许有重复的内容出现
function ShowDlg(dlgType, autoHide, title, txt, txtConfirm, txtCancel, onConfirm, onCancel, delayConfirm, togType, showHideTogName, activeCallback, dialogTopic, allowRepeat, anchor, extraData, inputStr)

    --检查是否不再提示类型
    if togType and togType > 0 and showHideTogName ~= nil then
        --不再提示(本次登录)
        if togType == 1 and DontShowTable[showHideTogName] then
            if onConfirm then
                onConfirm()
            end
            return
        end
        --今日不再提示
        if togType == 2 then
            local l_dateStr = tostring(os.date("!%Y%m%d", Common.TimeMgr.GetLocalNowTimestamp()))
            local l_dateStrSave = UserDataManager.GetStringDataOrDef(showHideTogName, MPlayerSetting.PLAYER_SETTING_GROUP, "")
            if l_dateStr == l_dateStrSave then
                if onConfirm then
                    onConfirm()
                end
                return
            end
        end
        --双向不再提示(勾选后无论确定还是取消都会记录操作)
        if togType == 3 then
            if DontShowTable[showHideTogName] then
                if onConfirm then
                    onConfirm()
                end
                return
            elseif DontShowTable[showHideTogName] == false then
                if onCancel then
                    onCancel()
                end
                return
            end
        end
        --本机本号永远不再提示
        if togType == 4 then
            local l_dateStrSave = UserDataManager.GetStringDataOrDef(showHideTogName, MPlayerSetting.PLAYER_SETTING_GROUP, "")
            if not string.ro_isEmpty(tostring(l_dateStrSave)) then
                if onConfirm then
                    onConfirm()
                end
                return
            end
        end
    end

    --开启对话框
    local l_ui = UIMgr:GetUI(UI.CtrlNames.Dialog)
    if l_ui then
        if l_ui then
            l_ui:SetTextAnchor(anchor or UnityEngine.TextAnchor.MiddleCenter)
            l_ui:SetDlgInfo(dlgType, autoHide, title, txt, txtConfirm, txtCancel, onConfirm, onCancel, delayConfirm, togType, showHideTogName, activeCallback, allowRepeat, extraData, inputStr)
            l_ui:UpdateUI()
        end
    else
        UIMgr:ActiveUI(UI.CtrlNames.Dialog, {
            anchor = anchor,
            dlgType = dlgType,
            autoHide = autoHide,
            title = title,
            txt = txt,
            txtConfirm = txtConfirm,
            txtCancel = txtCancel,
            onConfirm = onConfirm,
            onCancel = onCancel,
            delayConfirm = delayConfirm,
            togType = togType,
            showHideTogName = showHideTogName,
            activeCallback = activeCallback,
            allowRepeat = allowRepeat,
            extraData = extraData,
            inputStr = inputStr
        })
    end

    --设置对话框主题
    l_DialogTopicState[DialogModel.NORMAL] = dialogTopic or DialogTopic.NORMAL
end

----------------------------------------------END  对话框相关---------------------------------------------------------



----------------------------------------------  输入对话框相关  ---------------------------------------------------------
--单按钮输入对话框
--autoHide          bool     点击按钮后是否自动关闭
--title            string    输入框的标题
--txtPlaceHolder   string    输入框的默认内容
--txtConfirm       string    按钮的文字 为空默认为"确定"
--onConfirm                  按钮绑定的点击事件
--dialogTopic                对话框的主题类型 请用枚举 DialogTopic
function ShowOKInputDlg(autoHide, title, txtPlaceHolder, txtConfirm, onConfirm, dialogTopic)
    local l_confirm = txtConfirm or Common.Utils.Lang("DLG_BTN_OK")
    ShowInputDlg(DialogType.OK, autoHide, title, txtPlaceHolder, l_confirm, nil, onConfirm, nil, dialogTopic)
end
--双按钮输入对话框
--autoHide          bool     点击按钮后是否自动关闭
--title            string    输入框的标题
--txtPlaceHolder   string    输入框的默认内容
--txtConfirm       string    确定按钮的文字 为空默认为"确定"
--txtCancel        string    取消按钮的文字 为空默认为"取消"
--onConfirm                  确定按钮绑定的点击事件
--onCancel                   取消按钮绑定的点击事件
--dialogTopic                对话框的主题类型 请用枚举 DialogTopic
function ShowYesNoInputDlg(autoHide, title, txtPlaceHolder, txtConfirm, txtCancel, onConfirm, onCancel, dialogTopic)
    local l_confirm = txtConfirm or Common.Utils.Lang("DLG_BTN_YES")
    local l_cancel = txtCancel or Common.Utils.Lang("DLG_BTN_NO")
    ShowInputDlg(DialogType.YES_NO, autoHide, title, txtPlaceHolder, l_confirm, l_cancel, onConfirm, onCancel, dialogTopic)
end
--自定义输入对话框
--dlgType                    输入框框类型 请用枚举 DialogType
--autoHide          bool     点击按钮后是否自动关闭
--title            string    输入框的标题
--txtPlaceHolder   string    输入框的默认内容
--txtConfirm       string    确定按钮的文字
--txtCancel        string    取消按钮的文字
--onConfirm                  确定按钮绑定的点击事件
--onCancel                   取消按钮绑定的点击事件
--dialogTopic                对话框的主题类型 请用枚举 DialogTopic
function ShowInputDlg(dlgType, autoHide, title, txtPlaceHolder, txtConfirm, txtCancel, onConfirm, onCancel, dialogTopic)
    UIMgr:ActiveUI(UI.CtrlNames.InputDialog, function(ctrl)
        ctrl:SetDlgInfo(dlgType, autoHide, title, txtPlaceHolder, txtConfirm, txtCancel, onConfirm, onCancel)
    end)
    --设置对话框主题
    l_DialogTopicState[DialogModel.INPUT] = dialogTopic or DialogTopic.NORMAL
end
----------------------------------------------END  输入对话框相关---------------------------------------------------------



----------------------------------------------  选择对话框相关  ---------------------------------------------------------
--单按钮选择对话框
--autoHide          bool     点击按钮后是否自动关闭
--title            string    输入框的标题
--optionTable      table     下拉框内部数据表
--txtConfirm       string    确定按钮的文字
--onConfirm                  确定按钮绑定的点击事件
--dialogTopic                对话框的主题类型 请用枚举 DialogTopic
function ShowOKDropDownDlg(autoHide, title, optionTable, txtConfirm, onConfirm, dialogTopic)
    local l_confirm = txtConfirm or Common.Utils.Lang("DLG_BTN_OK")
    ShowDropDownDlg(DialogType.OK, autoHide, title, optionTable, l_confirm, nil, onConfirm, nil, dialogTopic)
end
--双按钮选择对话框
--autoHide          bool     点击按钮后是否自动关闭
--title            string    输入框的标题
--optionTable      table     下拉框内部数据表
--txtConfirm       string    确定按钮的文字
--txtCancel        string    取消按钮的文字
--onConfirm                  确定按钮绑定的点击事件
--onCancel                   取消按钮绑定的点击事件
--dialogTopic                对话框的主题类型 请用枚举 DialogTopic
function ShowYesNoDropDownDlg(autoHide, title, optionTable, txtConfirm, txtCancel, onConfirm, onCancel, dialogTopic)
    local l_confirm = txtConfirm or Common.Utils.Lang("DLG_BTN_YES")
    local l_cancel = txtCancel or Common.Utils.Lang("DLG_BTN_NO")
    ShowDropDownDlg(DialogType.YES_NO, autoHide, title, optionTable, l_confirm, l_cancel, onConfirm, onCancel, dialogTopic)
end
--自定义选择对话框
--dlgType                    输入框框类型 请用枚举 DialogType
--autoHide          bool     点击按钮后是否自动关闭
--title            string    输入框的标题
--optionTable      table     下拉框内部数据表
--txtConfirm       string    确定按钮的文字
--txtCancel        string    取消按钮的文字
--onConfirm                  确定按钮绑定的点击事件
--onCancel                   取消按钮绑定的点击事件
--dialogTopic                  对话框的主题类型 请用枚举 DialogTopic
function ShowDropDownDlg(dlgType, autoHide, title, optionTable, txtConfirm, txtCancel, onConfirm, onCancel, dialogTopic)
    UIMgr:ActiveUI(UI.CtrlNames.DrapDownDialog, function(l_ui)
        l_ui:SetDlgInfo(dlgType, autoHide, title, optionTable, txtConfirm, txtCancel, onConfirm, onCancel)
    end)
    --设置对话框主题
    l_DialogTopicState[DialogModel.DROPDOWN] = dialogTopic or DialogTopic.NORMAL
end

----------------------------------------------END  选择对话框相关---------------------------------------------------------


----------------------------------------------  物品消耗对话框相关  ---------------------------------------------------------

--通用消耗提示框
-- title            string      标题
-- content          string      内容
-- onConfirm                    确定按钮绑定的点击事件
-- onCancel                     取消按钮绑定的点击事件
-- consume          table       消耗物品信息列表  子项参数： ID(int)  IsShowCount(bool)  IsShowRequire(bool)  RequireCount(int)
-- togType           int        勾选框 类型  0无勾选框  1不再提示(本次登录)  2今日不再提示  3双向不再提示(勾选后无论确定还是取消都会记录操作)
-- showHideTogName  string      对话框的key 类型3的勾选框选中后 以后该值相同的对话框不再显示 默认为当次的选择
-- delayConfirmEx               对话框确认按钮点击后回调
-- dialogTopic                  对话框的主题类型 请用枚举 DialogTopic
-- attrChangeData               属性变化
-- keepOpen                     点确认后是否不关闭Dialog，默认关闭
function ShowConsumeDlg(title, content, onConfirm, onCancel, consume, togType, showHideTogName, delayConfirmEx, dialogTopic, hrefFunc)
    --检查是否不再提示类型
    if togType and togType > 0 and showHideTogName ~= nil then
        --不再提示(本次登录)
        if togType == 1 and DontShowTable[showHideTogName] then
            if onConfirm then
                onConfirm()
            else
                logError("不再提示 且 未设置确认事件")
            end
            return
        end
        --今日不再提示
        if togType == 2 then
            local l_dateStr = tostring(os.date("!%Y%m%d", Common.TimeMgr.GetLocalNowTimestamp()))
            local l_dateStrSave = UserDataManager.GetStringDataOrDef(showHideTogName, MPlayerSetting.PLAYER_SETTING_GROUP, "")
            if l_dateStr == l_dateStrSave then
                if onConfirm then
                    onConfirm()
                else
                    logError("不再提示 且 未设置确认事件")
                end
                return
            end
        end
        --双向不再提示(勾选后无论确定还是取消都会记录操作)
        if togType == 3 then
            if DontShowTable[showHideTogName] then
                if onConfirm then
                    onConfirm()
                else
                    logError("不再提示 且 未设置确认事件")
                end
                return
            elseif DontShowTable[showHideTogName] == false then
                if onCancel then
                    onCancel()
                end
                return
            end
        end
    end

    UIMgr:ActiveUI(UI.CtrlNames.ComsumeDialog, function(ctrl)
        ctrl:SetDlgInfo(title, content, onConfirm, onCancel, consume, togType, showHideTogName, delayConfirmEx, hrefFunc)
    end)

    --设置对话框主题
    l_DialogTopicState[DialogModel.CONSUME] = dialogTopic or DialogTopic.NORMAL
end

--通用消耗选择提示框
-- title            string      标题
-- onConfirm                    确定按钮绑定的点击事件
-- onCancel                     取消按钮绑定的点击事件
-- consumeOne                   选项一消耗物品信息列表
-- consumeTwo                   选项二消耗物品信息列表
-- toggleOneText                选项一显示文字
-- toggleTwoText                选项二显示文字
-- titleText                    标题文字
-- dialogTopic                  对话框的主题类型 请用枚举 DialogTopic
function ShowConsumeChooseDlg(titleOne, titleTwo, onCancel, onConfirmOne, onConfirmTwo, consumeOne, consumeTwo, toggleOneText, toggleTwoText, titleText, dialogTopic)
    UIMgr:ActiveUI(UI.CtrlNames.ConsumeChooseDialog, function(ctrl)
        ctrl:SetDlgInfo(titleOne, titleTwo, onCancel, onConfirmOne, onConfirmTwo, consumeOne, consumeTwo, toggleOneText, toggleTwoText, titleText)
    end)
    --设置对话框主题
    l_DialogTopicState[DialogModel.CONSUMECHOOSE] = dialogTopic or DialogTopic.NORMAL
end

----------------------------------------------END  物品消耗对话框相关---------------------------------------------------------

----------------------------------------------  文字型物品消耗确认对话框相关  ---------------------------------------------------------

-- 文字型物品消耗确认对话框
-- autoHide          bool       点击按钮后是否自动关闭
-- title            string      对话框标题
-- costTxt          string      消耗内容的文本
-- haveTxt          string      当前拥有的文本
-- onConfirm                    确定按钮绑定的点击事件
-- onCancel                     取消按钮绑定的点击事件
-- delayConfirm      int        对话框持续时间 不大于0或为空则不倒计时 对话框一直存在 倒计时结束直接触发确认按钮点击效果 并关闭对话框
-- dialogTopic                  对话框的主题类型 请用枚举 DialogTopic
function ShowCostCheckDlg(autoHide, title, costTxt, haveTxt, onConfirm, onCancel, delayConfirm, dialogTopic, needPayConfirm)
    UIMgr:ActiveUI(UI.CtrlNames.CostCheckDialog, function(ctrl)
        ctrl:SetDlgInfo(autoHide, title, costTxt, haveTxt, onConfirm, onCancel, delayConfirm, needPayConfirm)
    end)
    --设置对话框主题
    l_DialogTopicState[DialogModel.COSTCHECK] = dialogTopic or DialogTopic.NORMAL
end

----------------------------------------------END  文字型物品消耗确认对话框相关---------------------------------------------------------


----------------------------------------------  奖励对话框相关  ---------------------------------------------------------

--通用奖励框
--title 标题
--rewardDatas 奖励
--onConfirm 确定事件
--delayConfirm 取消事件
--dialogTopic 对话框的主题类型 请用枚举 DialogTopic
function ShowCommonRewardDlg(title, rewardDatas, onConfirm, delayConfirm, dialogTopic)
    UIMgr:ActiveUI(UI.CtrlNames.CommonReward, function(ctrl)
        ctrl:SetDlgInfo(title, rewardDatas, onConfirm, delayConfirm)
    end)
    --设置对话框主题
    l_DialogTopicState[DialogModel.COMMONREWARD] = dialogTopic or DialogTopic.NORMAL
end

----------------------------------------------END  奖励对话框相关---------------------------------------------------------


----------------------------------------------  删除对话框相关  ---------------------------------------------------------

--角色删除对话框
--strtext 文本
--roleInfo RoleBriefInfo
--onConfirm 确定事件
--delayConfirm 取消事件
--deleteTxt 删除文本
function ShowDeleteDlg(strtext, roleInfo, onConfirm, onCancel, deleteTxt)
    UIMgr:ActiveUI(UI.CtrlNames.DialogDeleteChar, function(ctrl)
        ctrl:ShowDialog(roleInfo, strtext, onConfirm, onCancel, deleteTxt)
    end)
end

----------------------------------------------END  删除对话框相关---------------------------------------------------------


--关闭对应主题所有对话框
function CloseDlgByTopic(dlgTopic)
    if not dlgTopic then
        return
    end
    --普通对话框/点赞对话框
    if l_DialogTopicState[DialogModel.NORMAL] == dlgTopic or dlgTopic == DialogTopic.ALL then
        UIMgr:DeActiveUI(UI.CtrlNames.Dialog)
        l_DialogTopicState[DialogModel.NORMAL] = DialogTopic.NORMAL
    end
    --文本输入对话框
    if l_DialogTopicState[DialogModel.INPUT] == dlgTopic or dlgTopic == DialogTopic.ALL then
        UIMgr:DeActiveUI(UI.CtrlNames.InputDialog)
        l_DialogTopicState[DialogModel.INPUT] = DialogTopic.NORMAL
    end
    --下拉选择对话框
    if l_DialogTopicState[DialogModel.DROPDOWN] == dlgTopic or dlgTopic == DialogTopic.ALL then
        UIMgr:DeActiveUI(UI.CtrlNames.DrapDownDialog)
        l_DialogTopicState[DialogModel.DROPDOWN] = DialogTopic.NORMAL
    end
    --物品消耗对话框
    if l_DialogTopicState[DialogModel.CONSUME] == dlgTopic or dlgTopic == DialogTopic.ALL then
        UIMgr:DeActiveUI(UI.CtrlNames.ComsumeDialog)
        l_DialogTopicState[DialogModel.CONSUME] = DialogTopic.NORMAL
    end
    --物品消耗选择对话框
    if l_DialogTopicState[DialogModel.CONSUMECHOOSE] == dlgTopic or dlgTopic == DialogTopic.ALL then
        UIMgr:DeActiveUI(UI.CtrlNames.ConsumeChooseDialog)
        l_DialogTopicState[DialogModel.CONSUMECHOOSE] = DialogTopic.NORMAL
    end
    --文字提示确认对话框（两行）
    if l_DialogTopicState[DialogModel.COSTCHECK] == dlgTopic or dlgTopic == DialogTopic.ALL then
        UIMgr:DeActiveUI(UI.CtrlNames.CostCheckDialog)
        l_DialogTopicState[DialogModel.COSTCHECK] = DialogTopic.NORMAL
    end
    --通用奖励对话框
    if l_DialogTopicState[DialogModel.COMMONREWARD] == dlgTopic or dlgTopic == DialogTopic.ALL then
        UIMgr:DeActiveUI(UI.CtrlNames.CommonReward)
        l_DialogTopicState[DialogModel.COMMONREWARD] = DialogTopic.NORMAL
    end
end

--#region Connecting & Waiting
function ShowReConnecting(delayShowTime, isMaskHide)
    delayShowTime = tonumber(delayShowTime) or 0

    UIMgr:ActiveUI(UI.CtrlNames.Connecting, {
        TimeOut = 30,
        DelayShow = delayShowTime,
        MaskHide = not not isMaskHide
    })

end

function HideReConnecting()
    UIMgr:DeActiveUI(UI.CtrlNames.Connecting)
end

function ShowWaiting(delayShowTime, isMaskHide, timeOut)
    delayShowTime = tonumber(delayShowTime) or 0

    UIMgr:ActiveUI(UI.CtrlNames.Waiting, {
        TimeOut = timeOut or 30,
        DelayShow = delayShowTime,
        MaskHide = not not isMaskHide
    })
end

function HideWaiting()
    logRed("HideWaiting")
    UIMgr:DeActiveUI(UI.CtrlNames.Waiting)
end
--#endregion Connecting & Waiting

function ShowPaying(timeOut)
    logRed("ShowPaying")
    UIMgr:ActiveUI(UI.CtrlNames.MallPay, {
        TimeOut = timeOut or 45,
    })
end

function HidePaying()

    logRed("HidePaying")
    UIMgr:DeActiveUI(UI.CtrlNames.MallPay)
end

return CommonUI.Dialog