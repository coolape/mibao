-- 白名单
do
    KKWhiteList = {}
    local uidx = "";
    ---@type System.Collections.ArrayList
    local whiteList;
    local whiteListLocPath = joinStr( CLPathCfg.persistentDataPath, "/", "whiteList.josn");

    -- 初始化，只会调用一次
    function KKWhiteList.init(_uidx)
        uidx = _uidx;
        --print(joinStr("uidx==", uidx))
        local url = PStr.b():a(CLVerManager.self.baseUrl):a("/whiteList.json"):e();
        local loginError = function(...)
            printe("get White List error");
        end

        WWWEx.newWWW(CLVerManager.self,
        url, --Utl.urlAddTimes(url),
        CLAssetType.text,
        5, 10,
        KKWhiteList.onGetWhiteList,
        loginError,
        loginError, nil);
    end

    function KKWhiteList.onGetWhiteList(content, orgs)
        if not CLCfgBase.self.isEditMode then
            File.WriteAllText(whiteListLocPath, content)
        end
        if not isNilOrEmpty(content) then
            whiteList = JSON.DecodeList(content)
        end
    end

    -- 是否白名单
    function KKWhiteList.isWhiteName()
        if CLCfgBase.self.isEditMode then
            ___isLogNetCmd___ = true;
            return true;
        end
        local ret = false;
        if whiteList == nil or whiteList.Count == 0 then
            if File.Exists(whiteListLocPath) then
                local content = File.ReadAllText(whiteListLocPath);
                if not isNilOrEmpty(content) then
                    whiteList = JSON.DecodeList(content)
                end
            else
                KKWhiteList.init();
            end
        end

        if whiteList == nil then
            ___isLogNetCmd___ = false;
            return false;
        end

        local ret1 = false;
        if not isNilOrEmpty(uidx) then
            ret1 = whiteList:Contains(uidx)
        end
        local ret2 = whiteList:Contains(Utl.uuid)
        ret = ret1 or ret2;
        ___isLogNetCmd___ = ret;
        return ret;
    end

    --------------------------------------------
    return KKWhiteList;
end
