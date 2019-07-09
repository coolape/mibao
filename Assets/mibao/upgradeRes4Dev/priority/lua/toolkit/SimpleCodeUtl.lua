SimpleCodeUtl = {}

local strLen = string.len
local strSub = string.sub
local strPack = string.pack
local strbyte = string.byte
local strchar = string.char
local insert = table.insert
local concat = table.concat
--============================================================
local secretKey = ""
---@public 加密
function SimpleCodeUtl.encrypt(bytes, key)
    return SimpleCodeUtl.xor(bytes, key)
end

---@public 解密
function SimpleCodeUtl.decrypt(bytes, key)
    return SimpleCodeUtl.xor(bytes, key)
end

function SimpleCodeUtl.xor(bytes, key)
    key = key or secretKey
    if key == nil or key == "" then
        return bytes
    end
    local len = #bytes
    local keyLen = #key
    local byte, byte2
    local keyIdx = 0
    local result = {}
    for i = 1, len do
        byte = strbyte(bytes, i)
        keyIdx = i % keyLen + 1
        byte2 = BitUtl.xorOp(byte, strbyte(key, keyIdx))
        insert(result, strchar(byte2))
    end
    return concat(result)
end
return SimpleCodeUtl

