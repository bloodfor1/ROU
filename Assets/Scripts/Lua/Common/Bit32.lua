--File	 	  : Bit.lua
--Author 	  : tmtan
--Date   	  : 2017/08/28
--Description : 32位位运算 

module("Common.Bit32")

local data32 = {}
for i = 1, 32 do 
    data32[i] = 2^(32-i)
end

--10转2
function D2b(arg)
    local tr = {}
    for i = 1, 32 do
        if arg >= data32[i] then
        	tr[i] = 1
        	arg = arg - data32[i]
        else
        	tr[i] = 0
        end
    end
    return tr
end

--2转10
function B2d(arg)
    local nr = 0
    for i = 1, 32 do
        if arg[i] == 1 then
        	nr = nr + 2^(32-i)
        end
    end
    return nr
end

--异或
function Xor(a, b)
    local op1 = D2b(a)
    local op2 = D2b(b)
    local r = {}
  
    for i = 1, 32 do
        if op1[i] == op2[i] then
            r[i] = 0
        else
            r[i] = 1
        end
    end
    return B2d(r)
end

--与
function And(a, b)
    local op1 = D2b(a)
    local op2 = D2b(b)
    local r = {}
    
    for i = 1, 32 do
        if op1[i] == 1 and op2[i] == 1 then
            r[i] = 1
        else
            r[i] = 0
        end
    end
    return B2d(r)
end

--或
function Or(a, b)
    local op1 = D2b(a)
    local op2 = D2b(b)
    local r = {}
    
    for i = 1, 32 do
        if  op1[i] == 1 or op2[i] == 1 then
            r[i] = 1
        else
            r[i] = 0
        end
    end
    return B2d(r)
end

--非
function Not(a)
    local op1 = D2b(a)
    local r = {}

    for i = 1, 32 do
        if op1[i] == 1 then
            r[i] = 0
        else
            r[i] = 1
        end
    end
    return B2d(r)
end

--右移
function Rshift(a, n)
    local op1 = D2b(a)
    local r = D2b(0)
    
    if n < 32 and n > 0 then
        for i = 1, n do
            for i = 31, 1, -1 do
                op1[i+1] = op1[i]
            end
            op1[1] = 0
        end
    	r = op1
    end
    return B2d(r)
end

--左移
function Lshift(a, n)
    local op1 = D2b(a)
    local r = D2b(0)
    
    if n < 32 and n > 0 then
        for i = 1, n do
            for i = 1, 31 do
                op1[i] = op1[i+1]
            end
            op1[32] = 0
        end
    	r = op1
    end
    return B2d(r)
end

--endregion