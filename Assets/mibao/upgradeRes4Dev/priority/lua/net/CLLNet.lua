--- 网络下行数据调度器
do
    require("bio.BioUtl")
    CLLNet = {}
    local csSelf;
    local __maxLen = 1024 * 1024;

    function CLLNet.init()
        csSelf = Net.self;
    end

    -- 组包
    function CLLNet.packMsg(data)
        local bytes = BioUtl.writeObject(data)
        if bytes then
            bytes =  string.pack(">s2", bytes);
        end
        return bytes
    end

    -- 解包
    function CLLNet.unpackMsg(socket, buffer)
        local ret = nil;
        local oldPos = buffer.Position;
        local tatalLen = buffer.Length;
        local needLen = buffer:ReadByte() * 256 + buffer:ReadByte();
        if (needLen <= 0 and needLen > __maxLen) then
            --// 网络Number据错误。断isOpen网络
            socket:close();
            return nil;
        end
        local usedLen = buffer.Position;
        if (usedLen + needLen <= tatalLen) then
            ret = BioUtl.readObject(buffer);
        else
            --说明长度不够
            buffer.Position = oldPos;
        end
        return ret;
    end

    function CLLNet.dispatchSend(map)
        CLLDataProc.procData(map);
    end

    function CLLNet.dispatchGate(map)
        if (map == nil) then
            return
        end

        if type(map) == "string" then
            if map == "connectCallback" then
                CLPanelManager.topPanel:procNetwork("connectCallback", 1, "connectCallback", nil);
            elseif map == "outofNetConnect" then
                CLPanelManager.topPanel:procNetwork("outofNetConnect", -9999, "outofNetConnect", nil);
            end
        else
            PorotocolService.onCallNet.disp(map);
        end
    end

    function CLLNet.dispatchGame(map)
        if (map == nil) then
            return
        end
        if type(map) == "string" then
            if map == "connectCallback" then
                CLPanelManager.topPanel:procNetwork("connectCallback", 1, "connectCallback", nil);
            elseif map == "outofNetConnect" then
                CLPanelManager.topPanel:procNetwork("outofNetConnect", -9999, "outofNetConnect", nil);
            end
        else
            GboGmSvBuilder.onCallNet.disp(map);
        end
    end

    function CLLNet.dispatch(...)
        local paras = { ... };
        local len = table.getn(paras);

        local cmd = paras[1]; -- 接口名
        local retvalue = paras[len]; -- 接口返回结果

        local data = {};
        if (len - 1 > 2) then
            for i = 2, len - 1 do
                -- data:Add(paras[i]);  -- 取得返回数据
                table.insert(data, paras[i]);
            end
        else
            data = paras[2];
        end

        -- 解密bio
        retvalue.succ = NumEx.bio2Int(retvalue.succ);
        local succ = retvalue.succ;
        local msg = retvalue.msg;
        if (succ ~= 0) then
            retvalue.msg = Localization.Get("Error_" .. succ);
            CLAlert.add(msg, Color.red, 1);
        else -- success
            CLLNet.cacheData(cmd, data);
        end

        -- CLPanelManager.topPanel:onNetwork (cmd, retvalue.succ, nil);
        -- 因为c#调用时已经放在主线程里了，因此可以直接调用procNetwork
        -- CLPanelManager.topPanel:procNetwork (cmd, retvalue.succ, retvalue.msg, data);

        -- 通知所有显示的页面
        if (CLPanelManager.panelRetainLayer ~= nil and CLPanelManager.panelRetainLayer.Count > 0) then
            local showingPanels = CLPanelManager.panelRetainLayer:ToArray();
            for i = 0, showingPanels.Length - 1 do
                showingPanels[i]:procNetwork(cmd, succ, msg, data);
            end
            showingPanels = nil;
        else
            if (CLPanelManager.topPanel ~= nil) then
                CLPanelManager.topPanel:procNetwork(cmd, succ, msg, data);
            end
        end
    end

    function CLLNet.cacheData(cmd, data)
        if (cmd == "getMapData") then
            if (data ~= nil and data.list ~= nil) then
                CLLData.onGetMapData(data.list);
            end
        elseif (cmd == "getMapDataOneScreen") then
            if (data ~= nil) then
                CLLData.onGetOneMapPageData(data);
            end
        end
    end

    -- 显示网关公告
    function CLLNet.showGateNotice(paras)
        local data = paras[1];
        if (data ~= nil and data.list ~= nil) then
            local count = data.list.Count;
            local msg = "";
            local notice = nil;
            for i = 1, count do
                notice = data.list[i];
                msg = msg .. notice.title .. "\n" .. notice.cont .. "\n";
            end
            if (msg ~= "") then
                CLUIUtl.showConfirm(msg, nil);
            end
        end
    end

    return CLLNet;
end

