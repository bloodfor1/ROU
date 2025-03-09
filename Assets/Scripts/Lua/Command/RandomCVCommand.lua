module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
RandomCVCommand = class("RandomCVCommand", super)

function RandomCVCommand:HandleCommand(command, block, args)
   
   	local l_playCvId
	local l_cvs = string.ro_split(args[0].Value, ",")
	local l_totalCount = #l_cvs
	if l_totalCount <= 0 then
		command:FinishCommand()
		return
	end
	local l_probability
	if args.Count == 2 then
		l_probability = string.ro_split(args[1].Value, ",")
		if #l_probability ~= l_totalCount then
			logError("[RandomCVCommand] 随机CV指令配置出错，id数量和概率数量不一致")
			command:FinishCommand()
			return
		end
	else
		l_probability = {}
		local l_perProbability = 100 / l_totalCount
		for i = 1, l_totalCount do
			table.insert(l_probability, l_perProbability)
		end
	end

   	local l_randomValue = math.random(1, 100)
	local l_value = 0
	for i = 1, l_totalCount do
		l_value = l_value + l_probability[i]
		if l_value > l_randomValue then
			l_playCvId = l_cvs[i]
			break
		end
	end

	if not l_playCvId then
		l_playCvId = l_cvs[l_totalCount]
	end

	MAudioMgr:StopCV()
	MAudioMgr:PlayCV(l_playCvId)

    command:FinishCommand()
end


return RandomCVCommand