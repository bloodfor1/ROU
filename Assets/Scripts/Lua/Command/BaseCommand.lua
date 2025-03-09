module("Command", package.seeall)

BaseCommand = class("BaseCommand")

function BaseCommand:ctor()
    
end

function BaseCommand:HandleCommand(command, block, args)

end

function BaseCommand:FinishCommand(command, block, args)

end

function BaseCommand:CheckCommand(...)
    return true
end

function BaseCommand:UninitCommand(...)

end