--
-- 禁止隐式声明、访问全局变量
--
function declareGlobal( name, initValue )
    rawset( _G, name, initValue or false )
end

function getGlobal( name )
    return rawget( _G, name )
end

setmetatable( _G, {
    __newindex = function ( table, key, value )
        local calling_func = debug.getinfo(2)
        --对于module进行特殊处理
        if _G.module == calling_func.func then
            declareGlobal(key, value)
        else
            logError( "Attempt to write to undeclared global variable: " .. key )
        end
        
    end,
} )
