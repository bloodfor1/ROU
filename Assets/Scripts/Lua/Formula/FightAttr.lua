---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by richardjiang.
--- DateTime: 2018/8/28 9:49
---

module("Fight", package.seeall)

FightAttr = class("FightAttr")
local FLOAT_ONE_HUNDRED_PERCENT = 10000

--==============================--
--@Description: 根据skilleffect静态数据计算固定吟唱时间, 可变吟唱时间, 技能产生公共冷却时间
--@Date: 2018/8/28
--@Param: [args]
--@Return:
--==============================--
function FightAttr.GetSingingTimeByAttr(effectDetail)
    local sfixedSingTime = effectDetail.PVEFixSingingTime--固定吟唱时间
    local sVarSingTime = effectDetail.PVEFloatSingingTime--可变吟唱时间
    local sPVEGroupCoolTime = effectDetail.PVEGroupCoolTime--技能产生公共冷却时间

    local fixedSingTime, fixedSingTimePresent, varSingTime, varSingTimePresent = 0, 0, 0, 0
    fixedSingTime = MEntityMgr:GetMyPlayerAttr(AttrType.ATTR_BASIC_CT_FIXED_FINAL) / FLOAT_ONE_HUNDRED_PERCENT
    fixedSingTimePresent = MEntityMgr:GetMyPlayerAttr(AttrType.ATTR_PERCENT_CT_FIXED_FINAL) / FLOAT_ONE_HUNDRED_PERCENT
    varSingTime = MEntityMgr:GetMyPlayerAttr(AttrType.ATTR_BASIC_CT_CHANGE_FINAL) / FLOAT_ONE_HUNDRED_PERCENT
    varSingTimePresent = MEntityMgr:GetMyPlayerAttr(AttrType.ATTR_PERCENT_CT_CHANGE_FINAL) / FLOAT_ONE_HUNDRED_PERCENT
    return math.max(0,fixedSingTime + sfixedSingTime) * math.max(0, (1 + fixedSingTimePresent)),
    math.max(0,varSingTime + sVarSingTime) *  math.max(0, (1 + varSingTimePresent)),
    math.max(0,sPVEGroupCoolTime)
end
