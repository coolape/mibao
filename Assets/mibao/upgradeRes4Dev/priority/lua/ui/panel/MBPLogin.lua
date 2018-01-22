-- xx界面
do
    require("net.NetProtoClient")
    MBPLogin = {}

    local csSelf = nil;
    local transform = nil;
    local contentLogin;
    local contentRegist;
    local InputUser4Login;
    local InputPassword4Login;
    local InputUser4Regist;
    local InputPassword4Regist;
    local InputPassword4Regist2;
    local ButtonShowRegist;

    local onLoginCallback;
    local onLoginCallbackParam;


    -- 初始化，只会调用一次
    function MBPLogin.init(csObj)
        csSelf = csObj;
        transform = csObj.transform;
        contentLogin = getCC(transform, "Panel/contentLogin", "TweenPosition");
        contentRegist = getCC(transform, "Panel/contentRegist", "TweenPosition");
        ButtonShowRegist = getChild(contentLogin.transform, "ButtonShowRegist")

        InputUser4Login = getCC(contentLogin.transform, "InputUser", "UIInput");
        InputPassword4Login = getCC(contentLogin.transform, "InputPassword", "UIInput");
        InputUser4Regist = getCC(contentRegist.transform, "InputUser", "UIInput");
        InputPassword4Regist = getCC(contentRegist.transform, "InputPassword", "UIInput");
        InputPassword4Regist2 = getCC(contentRegist.transform, "InputPassword2", "UIInput");
    end

    -- 设置数据
    function MBPLogin.setData(paras)
        if paras then
            onLoginCallback = paras[1]
            onLoginCallbackParam = paras[2]
        else
            onLoginCallback = nil
            onLoginCallbackParam = nil
        end
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPLogin.show()
        InputUser4Regist.value = "";
        InputPassword4Regist.value = "";
        InputPassword4Regist2.value = "";
        InputUser4Login.value = Prefs.getUserName();
        InputPassword4Login.value = Prefs.getUserPsd();

        contentLogin:Play(true)
        contentRegist:Play(false)
    end

    -- 刷新
    function MBPLogin.refresh()
    end

    -- 关闭页面
    function MBPLogin.hide()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPLogin.procNetwork (cmd, succ, msg, data)
        hideHotWheel()
        if succ == 1 then
            if cmd == "login" or cmd == "regist" then
                local user = data.userInfor

                local uid = user.idx
                if not isNilOrEmpty(uid) then
                    hideTopPanel();
                    if not isNilOrEmpty(InputUser4Login.value) then
                        Prefs.setUserName(InputUser4Login.value)
                    end

                    if not isNilOrEmpty(InputPassword4Login.value) then
                        Prefs.setUserPsd(InputPassword4Login.value)
                    end

                    uid = uid
                    __uid__ = uid;
                    Utl.doCallback(onLoginCallback, uid, onLoginCallbackParam);
                end
            elseif cmd == "getServerInfor" then
                local d = data.server
                for k,v in pairs(d) do
                    print(k,v)
                end
            end
        else
            if succ == 4 then
                CLAlert.add("密码错误！", Color.red, 1);
            elseif succ == 5 then
                CLAlert.add("同一设备已经超过注册上限！", Color.red, 1);
            else
                CLAlert.add(LGet("UIMsg002"), Color.red, 1);
            end
        end
    end

    -- 处理ui上的事件，例如点击等
    function MBPLogin.uiEventDelegate( go )
        local goName = go.name;
        if (goName == "ButtonClose") then
            CLPanelManager.hideTopPanel(csSelf);
        elseif goName == "ButtonShowRegist" then
            contentLogin:Play(false)
            contentRegist:Play(true)
        elseif goName == "ButtonBack" then
            contentLogin:Play(true)
            contentRegist:Play(false)
        elseif goName == "ButtonLogin" then
            local user = trim(InputUser4Login.value);
            local psd = trim(InputPassword4Login.value);
            if isNilOrEmpty(user) or isNilOrEmpty(psd) then
                CLAlert.add("账号密码不能为空！", Color.red, 1);
                return;
            end
            InputUser4Login.value = user;
            InputPassword4Login.value = psd;
            if havUtf8Char(user) then
                CLAlert.add("用户名只能包含英文、数字！", Color.red, 1);
                return;
            end

            showHotWheel();
            --MBPLogin.accountLogin(user, psd)
            CLLNet.httpPostUsermgr(UsermgrHttpProto.send.login(user, psd, CLCfgBase.self.appUniqueID))
        elseif goName == "ButtonRegist" then
            local user = trim(InputUser4Regist.value);
            local psd = trim(InputPassword4Regist.value);
            local psd2 = trim(InputPassword4Regist2.value);
            if isNilOrEmpty(user) or isNilOrEmpty(psd) or isNilOrEmpty(psd2) then
                CLAlert.add("账号密码不能为空！", Color.red, 1);
                return;
            end
            if psd ~= psd2 then
                CLAlert.add("账号或密码错误！", Color.red, 1);
                return
            end
            InputUser4Login.value = user;
            InputPassword4Login.value = psd;
            if havUtf8Char(user) then
                CLAlert.add("用户名只能包含英文、数字！", Color.red, 1);
                return;
            end

            showHotWheel();
            --MBPLogin.accountLogin(user, psd)
            local deviceInfor = {}
            table.insert(deviceInfor, SystemInfo.deviceName)
            table.insert(deviceInfor, SystemInfo.deviceModel)
            table.insert(deviceInfor, SystemInfo.deviceType:ToString())
            table.insert(deviceInfor, SystemInfo.operatingSystem)
            table.insert(deviceInfor, SystemInfo.maxTextureSize)
            CLLNet.httpPostUsermgr(CallHttp.regist(user, psd, CLCfgBase.self.appUniqueID, "0", Utl.uuid, table.concat(deviceInfor, ",")))
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPLogin.hideSelfOnKeyBack( )
        return false;
    end

    --------------------------------------------
    return MBPLogin;
end
