do
    UsermgrHttpProto = {}
    require("bio.BioUtl")

    UsermgrHttpProto.__sessionID = 0; -- 会话ID
    UsermgrHttpProto.dispatch = {}
    --==============================
    -- public toMap
    UsermgrHttpProto._toMap = function(stName, m)
        local ret = {}
        if m == nil then return ret end
        for k,v in pairs(m) do
            ret[k] = UsermgrHttpProto[stName].toMap(v)
        end
        return ret
    end
    -- public toList
    UsermgrHttpProto._toList = function(stName, m)
        local ret = {}
        if m == nil then return ret end
        for i,v in ipairs(m) do
            table.insert(ret, UsermgrHttpProto[stName].toMap(v))
        end
        return ret
    end
    -- public parse
    UsermgrHttpProto._parseMap = function(stName, m)
        local ret = {}
        if m == nil then return ret end
        for k,v in pairs(m) do
            ret[k] = UsermgrHttpProto[stName].parse(v)
        end
        return ret
    end
    -- public parse
    UsermgrHttpProto._parseList = function(stName, m)
        local ret = {}
        if m == nil then return ret end
        for i,v in ipairs(m) do
            table.insert(ret, UsermgrHttpProto[stName].parse(v))
        end
        return ret
    end
  --==================================
  --==================================
    -- 返回信息
    UsermgrHttpProto.ST_retInfor = {
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
    -- 服务器列表
    UsermgrHttpProto.ST_servers = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[12] = UsermgrHttpProto._toList(UsermgrHttpProto.ST_server, m.list)  -- 服务器列表
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.list = UsermgrHttpProto._parseList(UsermgrHttpProto.ST_server, m.list)  -- 服务器列表
            return r;
        end,
    }
    -- 服务器
    UsermgrHttpProto.ST_server = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[13] = m.idx  -- id int
            r[15] = m.status  -- 状态 0:正常; 1:爆满; 2:维护 int
            r[14] = m.name  -- 名称 string
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.idx = m[13] --  int
            r.status = m[15] --  int
            r.name = m[14] --  string
            return r;
        end,
    }
    -- 用户信息
    UsermgrHttpProto.ST_userInfor = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[13] = m.idx  -- 唯一标识 int
            r[14] = m.name  -- 名字 string
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.idx = m[13] --  int
            r.name = m[14] --  string
            return r;
        end,
    }
    --==============================
    UsermgrHttpProto.send = {
    -- 取得服务器列表
    getServers = function(appid, channceid)
        local ret = {}
        ret[0] = 16
        ret[1] = UsermgrHttpProto.__sessionID
        ret[17] = appid; -- 应用id
        ret[18] = channceid; -- 渠道号
        return ret
    end,
    -- 登陆
    login = function(userId, password)
        local ret = {}
        ret[0] = 20
        ret[1] = UsermgrHttpProto.__sessionID
        ret[21] = userId; -- 用户名
        ret[22] = password; -- 密码
        return ret
    end,
    -- 注册
    regist = function(userId, password, appid, channel, deviceID, deviceInfor)
        local ret = {}
        ret[0] = 24
        ret[1] = UsermgrHttpProto.__sessionID
        ret[21] = userId; -- 用户名
        ret[22] = password; -- 密码
        ret[17] = appid; -- 应用id
        ret[25] = channel; -- 渠道
        ret[26] = deviceID; -- 机器码
        ret[27] = deviceInfor; -- 机器信息
        return ret
    end,
    }
    --==============================
    UsermgrHttpProto.recive = {
    getServers = function(map)
        local ret = {}
        ret.cmd = "getServers"
        ret.retInfor = UsermgrHttpProto.ST_retInfor.parse(map[2]) -- 返回信息
        ret.servers = UsermgrHttpProto.ST_servers.parse(map[19]) -- 服务器列表
        return ret
    end,
    login = function(map)
        local ret = {}
        ret.cmd = "login"
        ret.retInfor = UsermgrHttpProto.ST_retInfor.parse(map[2]) -- 返回信息
        ret.userInfor = UsermgrHttpProto.ST_userInfor.parse(map[23]) -- 用户信息
        return ret
    end,
    regist = function(map)
        local ret = {}
        ret.cmd = "regist"
        ret.retInfor = UsermgrHttpProto.ST_retInfor.parse(map[2]) -- 返回信息
        ret.userInfor = UsermgrHttpProto.ST_userInfor.parse(map[23]) -- 用户信息
        return ret
    end,
    }
    --==============================
    UsermgrHttpProto.dispatch[16]={onReceive = UsermgrHttpProto.recive.getServers, send = UsermgrHttpProto.send.getServers}
    UsermgrHttpProto.dispatch[20]={onReceive = UsermgrHttpProto.recive.login, send = UsermgrHttpProto.send.login}
    UsermgrHttpProto.dispatch[24]={onReceive = UsermgrHttpProto.recive.regist, send = UsermgrHttpProto.send.regist}
    return UsermgrHttpProto
end