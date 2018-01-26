do
    NetProtoMibao = {}
    local table = table
    require("bio.BioUtl")

    NetProtoMibao.__sessionID = 0; -- 会话ID
    NetProtoMibao.dispatch = {}
    --==============================
    -- public toMap
    NetProtoMibao._toMap = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for k,v in pairs(m) do
            ret[k] = stuctobj.toMap(v)
        end
        return ret
    end
    -- public toList
    NetProtoMibao._toList = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for i,v in ipairs(m) do
            table.insert(ret, stuctobj.toMap(v))
        end
        return ret
    end
    -- public parse
    NetProtoMibao._parseMap = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for k,v in pairs(m) do
            ret[k] = stuctobj.parse(v)
        end
        return ret
    end
    -- public parse
    NetProtoMibao._parseList = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for i,v in ipairs(m) do
            table.insert(ret, stuctobj.parse(v))
        end
        return ret
    end
  --==================================
  --==================================
    -- 返回信息
    NetProtoMibao.ST_retInfor = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[10] = m.msg  -- 返回消息 string
            r[11] = m.code  -- 返回值 int
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.msg = m[10] --  string
            r.code = m[11] --  int
            return r;
        end,
    }
    -- 密码信息
    NetProtoMibao.ST_psdInfor = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[30] = m.platform  -- 平台、网站等，作为key用 string
            r[31] = m.user  -- 账号 string
            r[32] = m.time  -- 修改时间 int
            r[33] = m.psd  -- 密码 string
            r[34] = m.desc  -- 备注 string
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.platform = m[30] --  string
            r.user = m[31] --  string
            r.time = m[32] --  int
            r.psd = m[33] --  string
            r.desc = m[34] --  string
            return r;
        end,
    }
    --==============================
    NetProtoMibao.send = {
    -- 数据同步
    syndata = function(psdInfors)
        local ret = {}
        ret[0] = 22
        ret[1] = NetProtoMibao.__sessionID
        ret[35] = NetProtoMibao._toList(NetProtoMibao.ST_psdInfor, psdInfors)  -- 数据信息
        return ret
    end,
    }
    --==============================
    NetProtoMibao.recive = {
    syndata = function(map)
        local ret = {}
        ret.cmd = "syndata"
        ret.retInfor = NetProtoMibao.ST_retInfor.parse(map[2]) -- 返回信息
        ret.newData = map[25]-- 新数据
        return ret
    end,
    }
    --==============================
    NetProtoMibao.dispatch[22]={onReceive = NetProtoMibao.recive.syndata, send = NetProtoMibao.send.syndata}
    --==============================
    NetProtoMibao.cmds = {
        syndata = "syndata"
    }
    --==============================
    return NetProtoMibao
end