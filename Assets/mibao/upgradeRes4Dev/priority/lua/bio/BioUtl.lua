-- bio 工具
do
    require("public.class")
    BioUtl = {}
    -- bio的类型定义
    B2Type = {
        --//null
        NULL = 0,
        --//bool
        BOOLEAN_TRUE = 1,
        BOOLEAN_FALSE = 2,
        --// byte
        BYTE_0 = 3,
        BYTE = 4,
        --// short
        SHORT_0 = 5,
        SHORT_8B = 6,
        SHORT_16B = 7,
        --//int b32 b24 b16 b8
        INT_0 = 8,
        INT_8B = 9,
        INT_16B = 10,
        INT_32B = 11,
        INT_N1 = 12,
        INT_1 = 13,
        INT_2 = 14,
        INT_3 = 15,
        INT_4 = 16,
        INT_5 = 17,
        INT_6 = 18,
        INT_7 = 19,
        INT_8 = 20,
        INT_9 = 21,
        INT_10 = 22,
        INT_11 = 23,
        INT_12 = 24,
        INT_13 = 25,
        INT_14 = 26,
        INT_15 = 27,
        INT_16 = 28,
        INT_17 = 29,
        INT_18 = 30,
        INT_19 = 31,
        INT_20 = 32,
        INT_21 = 33,
        INT_22 = 34,
        INT_23 = 35,
        INT_24 = 36,
        INT_25 = 37,
        INT_26 = 38,
        INT_27 = 39,
        INT_28 = 40,
        INT_29 = 41,
        INT_30 = 42,
        INT_31 = 43,
        INT_32 = 44,
        --//long b64 b56 b48 b40 b32 b24 b16 b8
        LONG_0 = 45,
        LONG_8B = 46,
        LONG_16B = 47,
        LONG_32B = 48,
        LONG_64B = 49,
        --//double b64 b56 b48 b40 b32 b24 b16 b8
        DOUBLE_0 = 50,
        --//    DOUBLE_8B = 51,
        --//    DOUBLE_16B = 52,
        --//    DOUBLE_32B = 53,
        DOUBLE_64B = 54,
        --//STR [bytes]
        STR_0 = 55,
        STR = 56,
        STR_1 = 57,
        STR_2 = 58,
        STR_3 = 59,
        STR_4 = 60,
        STR_5 = 61,
        STR_6 = 62,
        STR_7 = 63,
        STR_8 = 64,
        STR_9 = 65,
        STR_10 = 66,
        STR_11 = 67,
        STR_12 = 68,
        STR_13 = 69,
        STR_14 = 70,
        STR_15 = 71,
        STR_16 = 72,
        STR_17 = 73,
        STR_18 = 74,
        STR_19 = 75,
        STR_20 = 76,
        STR_21 = 77,
        STR_22 = 78,
        STR_23 = 79,
        STR_24 = 80,
        STR_25 = 81,
        STR_26 = 82,
        --//Bytes [int len, byte[]]
        BYTES_0 = 83,
        BYTES = 84,
        --//VECTOR [int len, v...]
        VECTOR_0 = 85,
        VECTOR = 86,
        VECTOR_1 = 87,
        VECTOR_2 = 88,
        VECTOR_3 = 89,
        VECTOR_4 = 90,
        VECTOR_5 = 91,
        VECTOR_6 = 92,
        VECTOR_7 = 93,
        VECTOR_8 = 94,
        VECTOR_9 = 95,
        VECTOR_10 = 96,
        VECTOR_11 = 97,
        VECTOR_12 = 98,
        VECTOR_13 = 99,
        VECTOR_14 = 100,
        VECTOR_15 = 101,
        VECTOR_16 = 102,
        VECTOR_17 = 103,
        VECTOR_18 = 104,
        VECTOR_19 = 105,
        VECTOR_20 = 106,
        VECTOR_21 = 107,
        VECTOR_22 = 108,
        VECTOR_23 = 109,
        VECTOR_24 = 110,
        --//HASHTABLE [int len, k, v...]
        HASHTABLE_0 = 111,
        HASHTABLE = 112,
        HASHTABLE_1 = 113,
        HASHTABLE_2 = 114,
        HASHTABLE_3 = 115,
        HASHTABLE_4 = 116,
        HASHTABLE_5 = 117,
        HASHTABLE_6 = 118,
        HASHTABLE_7 = 119,
        HASHTABLE_8 = 120,
        HASHTABLE_9 = 121,
        HASHTABLE_10 = 122,
        HASHTABLE_11 = 123,
        HASHTABLE_12 = 124,
        HASHTABLE_13 = 125,
        HASHTABLE_14 = 126,
        HASHTABLE_15 = 127,
        --// int[]
        INT_ARRAY = -9,
        INT_ARRAY_0 = -10,
        INT_ARRAY_1 = -11,
        INT_ARRAY_2 = -12,
        INT_ARRAY_3 = -13,
        INT_ARRAY_4 = -14,
        INT_ARRAY_5 = -15,
        INT_ARRAY_6 = -16,
        INT_ARRAY_7 = -17,
        INT_ARRAY_8 = -18,
        INT_ARRAY_9 = -19,
        INT_ARRAY_10 = -20,
        INT_ARRAY_11 = -21,
        INT_ARRAY_12 = -22,
        INT_ARRAY_13 = -23,
        INT_ARRAY_14 = -24,
        INT_ARRAY_15 = -25,
        INT_ARRAY_16 = -26,
        --// int[][]
        INT_2D_ARRAY = -29,
        INT_2D_ARRAY_0 = -30,

        JAVA_DATE = -31,

        JAVA_OBJECT = -32,
        --//b2int
        INT_B2 = -33,
    }
    local IntB2TypeList = {
        B2Type.INT_0,
        B2Type.INT_1,
        B2Type.INT_2,
        B2Type.INT_3,
        B2Type.INT_4,
        B2Type.INT_5,
        B2Type.INT_6,
        B2Type.INT_7,
        B2Type.INT_8,
        B2Type.INT_9,
        B2Type.INT_10,
        B2Type.INT_11,
        B2Type.INT_12,
        B2Type.INT_13,
        B2Type.INT_14,
        B2Type.INT_15,
        B2Type.INT_16,
        B2Type.INT_17,
        B2Type.INT_18,
        B2Type.INT_19,
        B2Type.INT_20,
        B2Type.INT_21,
        B2Type.INT_22,
        B2Type.INT_23,
        B2Type.INT_24,
        B2Type.INT_25,
        B2Type.INT_26,
        B2Type.INT_27,
        B2Type.INT_28,
        B2Type.INT_29,
        B2Type.INT_30,
        B2Type.INT_31,
        B2Type.INT_32,
    }

    local StringB2TypeList = {
        B2Type.STR_0,
        B2Type.STR_1,
        B2Type.STR_2,
        B2Type.STR_3,
        B2Type.STR_4,
        B2Type.STR_5,
        B2Type.STR_6,
        B2Type.STR_7,
        B2Type.STR_8,
        B2Type.STR_9,
        B2Type.STR_10,
        B2Type.STR_11,
        B2Type.STR_12,
        B2Type.STR_13,
        B2Type.STR_14,
        B2Type.STR_15,
        B2Type.STR_16,
        B2Type.STR_17,
        B2Type.STR_18,
        B2Type.STR_19,
        B2Type.STR_20,
        B2Type.STR_21,
        B2Type.STR_22,
        B2Type.STR_23,
        B2Type.STR_24,
        B2Type.STR_25,
        B2Type.STR_26,
    }

    -- 原始数据类型
    BioUtl.DataType = {
        NIL = "nil",
        BOOLEAN = "boolean",
        STRING = "string",
        NUMBER = "number",
        LONG = "long",
        DOUBLE = "double",
        USERDATA = "userdata",
        FUNCTION = "function",
        THREAD = "thread",
        TABLE = "table",
        INT4B = "int4b",
        INT16N = "int16b",
        INT32B = "int32b",
    }

    -- 取得数据的类型，主要是对number做了处理
    function BioUtl.getDataType(obj)
        --nil, boolean, number, string, userdata, function, thread, table
        local val = nil;
        local t = type(obj);
        val = BioUtl.DataType[string.upper(type(obj))];
        if val == nil then
            val = "undefined";
        end
        return val;
    end

    function BioUtl.getNumberType(obj)
        local val = nil;
        local t = type(obj);
        if t == "number" then
            local minInt = math.floor(obj);
            if minInt == obj then
                -- 说明是整数
                if (obj >= -128 and obj <= 127) then
                    val = BioUtl.DataType.INT4B
                elseif (obj >= -32768 and obj <= 32767) then
                    val = BioUtl.DataType.INT16B
                elseif (obj >= -2147483648 and obj <= 2147483647) then
                    val = BioUtl.DataType.INT32B
                else
                    val = BioUtl.DataType.LONG
                end
            else
                val = BioUtl.DataType.DOUBLE
            end
        end
        return val;
    end

    --===================================================
    -- 数据流
    LuaB2OutputStream = class("LuaB2OutputStream");
    function LuaB2OutputStream:ctor(v)
        self.content = {}
    end

    function LuaB2OutputStream:writeByte(v)
        table.insert(self.content, string.char(v))
    end

    function LuaB2OutputStream:writeString(v)
        table.insert(self.content, v)
    end

    function LuaB2OutputStream:toString()
        local ret = "";
        for i, v in ipairs(self.content) do
            ret = ret .. v;
        end
        return ret;
    end
    function LuaB2OutputStream:release()
        self.content = {};
    end
    --===================================================
    ---public Void writeObject (LuaB2OutputStream os, obj)
    ---@param optional LuaB2OutputStream os
    ---@param optional object obj
    function BioUtl.writeObject (os, obj)
        if os == nil then
            os = LuaB2OutputStream:new();
        end
        local objType = BioUtl.getDataType(obj)
        if (objType == BioUtl.DataType.NIL) then
            BioUtl.writeNil(os)
        elseif (objType == BioUtl.DataType.TABLE) then
            BioUtl.writeMap(os, obj);
        elseif (objType == BioUtl.DataType.NUMBER) then
            BioUtl.writeNumber(os, obj);
        elseif (objType == BioUtl.DataType.STRING) then
            BioUtl.writeString(os, obj);
        elseif (objType == BioUtl.DataType.BOOLEAN) then
            BioUtl.writeBoolean(os, obj);
            --} else if (B2Type.isByte (obj)) {
            --int v = ((Byte)obj);
            --writeByte (os, v);
            --} else if (B2Type.isBytes (obj)) {
            --byte[] v = (byte[])obj;
            --writeBytes (os, v);
            --} else if (B2Type.isList (obj)) {
            --ArrayList v = (ArrayList)obj;
            --writeVector (os, v);
            --} else if (B2Type.isShort (obj)) {
            --int v = (Int16)obj;
            --writeShort (os, v);
            --} else if (B2Type.isLong (obj)) {
            --long v = ((Int64)obj);
            --writeLong (os, v);
            --} else if (B2Type.isDouble (obj)) {
            --double v = ((Double)obj);
            --writeDouble (os, v);
            --} else if (B2Type.isIntArray (obj)) {
            --int[] v = (int[])obj;
            --writeIntArray (os, v);
            --//			} else if(obj instanceof int[][]){
            --//				int[][] v = (int[][]) obj;
            --//				writeInt2DArray(os, v);
            --} else if (B2Type.isB2Int (obj)) {
            --B2Int v = (B2Int)obj;
            --writeB2Int (os, v);
        else
            --//throw new IOException("unsupported obj:" + obj);
            print("B2IO unsupported error: type=[" .. objType .. "] val=[" + obj .. "]");
        end
    end

    function BioUtl.writeNil(os)
        BioUtl.WriteByte(os, B2Type.NULL);
        return os;
    end

    function BioUtl.WriteByte(os, v)
        local v2 = v;
        if v < 0 then
            v2 = v + 256;
        end
        os:writeByte(v2)
        return os;
    end

    function BioUtl.writeNumber(os, v)
        local numType = BioUtl.getNumberType(v)
        if numType == BioUtl.DataType.INT4B or
        numType == BioUtl.DataType.INT16N or
        numType == BioUtl.DataType.INT32N then
            BioUtl.writeInt(os, v)
        elseif numType == BioUtl.DataType.LONG then
            BioUtl.writeLong(os, v);
        elseif numType == BioUtl.DataType.DOUBLE then
            BioUtl.writeDouble(os, v);
        end
        return os;
    end

    function BioUtl.writeInt(os, v)
        if v == -1 then
            BioUtl.WriteByte(os, B2Type.INT_N1);
        elseif v >= 0 and v <= 32 then
            local t = BioUtl.IntB2TypeList[v + 1]
            BioUtl.WriteByte(os, t);
        else
            if (v >= -128 and v <= 127) then
                BioUtl.WriteByte(os, B2Type.INT_8B);
                BioUtl.WriteByte(os, v);
            elseif (v >= -32768 and v <= 32767) then
                BioUtl.WriteByte(os, B2Type.INT_16B);
                if v < 0 then
                    BioUtl.WriteByte(os, math.floor((v + 65536) / 256));
                    BioUtl.WriteByte(os, (v + 65536) % 256);
                else
                    BioUtl.WriteByte(os, math.floor(v / 256));
                    BioUtl.WriteByte(os, v % 256);
                end
            else
                BioUtl.WriteByte(os, B2Type.INT_32B);
                local v2 = v;
                if v < 0 then
                    v2 = v + 4294967296
                end
                BioUtl.WriteByte(os, math.floor(v2 / 16777216));
                v2 = v2 % 16777216
                BioUtl.WriteByte(os, math.floor(v2 / 65536));
                v2 = v2 % 65536
                BioUtl.WriteByte(os, math.floor(v2 / 256));
                BioUtl.WriteByte(os, v2 % 256);
            end
        end
        return os;
    end

    function BioUtl.writeLong(os, v)
        BioUtl.WriteByte(os, B2Type.LONG_64B);
        BioUtl.writeString(os, tostring(v));
        return os;
    end

    function BioUtl.writeDouble(os, v)
        BioUtl.WriteByte(os, B2Type.DOUBLE_64B);
        BioUtl.writeString(os, tostring(v));
        return os;
    end

    function BioUtl.writeString(os, v)
        if (v == nil) then
            BioUtl.writeNil(os);
            return os;
        end

        local len = #v;
        local t = BioUtl.StringB2TypeList[len + 1]
        if t then
            BioUtl.WriteByte(os, t);
            os:writeString(v);
        else
            BioUtl.WriteByte(os, B2Type.STR);
            BioUtl.writeInt(os, len);
            os:writeString(v);
        end
    end
    --------------------------------------------
    return BioUtl;
end
