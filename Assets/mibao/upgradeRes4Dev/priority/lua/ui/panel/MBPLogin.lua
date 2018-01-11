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
        onLoginCallback = paras[1]
        onLoginCallbackParam = paras[2]
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

        Net.self:setLua();
        CLLNet.init();
        Net.self:connectGame("127.0.0.1", 2018)
    end

    -- 刷新
    function MBPLogin.refresh()
    end

    -- 关闭页面
    function MBPLogin.hide()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPLogin.procNetwork (cmd, succ, msg, data)
        if succ == 1 then
            if cmd == "connectCallback" then
                print("send")
                Net.self:send(NetProto.send.login("chenbin", "123."));
            elseif  cmd == "login" then
                print("login")
            end
        else
            print(cmd, succ, msg)
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
            MBPLogin.accountLogin(user, psd)
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
            MBPLogin.accountLogin(user, psd)
        end
    end


    -- 取得系统账号
    function MBPLogin.accountLogin(user, psd)
        MBPLogin.onAccountLogin("{\"errorCode\":1,\"idx\":\"111\"}")
        do return end

        local url = PStr.b():a(__httpBaseUrl):a("/KokAccount/AccountServlet"):e();
        local chnCfg = nil;
        local chlCode = getChlCode();
        local formData = Hashtable();
        formData:Add("accountKey", "") -- 唯一String
        formData:Add("machineid", Utl.uuid); -- 机器码
        formData:Add("userName", user) -- 邮箱 （没有可以不填）	String
        formData:Add("passWord", psd)--密码 （没有可以不填）	String
        formData:Add("type", 2)--登录类型  1;//机器码登陆  2;//邮箱登陆  Int
        formData:Add("channel", chlCode)--渠道号 	String
        if KKWhiteList.isWhiteName() then
            formData:Add("isMax", 0)--是否验证同一机子注册限制 0:不限制 1：限制最多5个
        else
            formData:Add("isMax", 1)--是否验证同一机子注册限制
        end

        local loginError = function(...)
            hideHotWheel();
            CLAlert.add(LGet("UIMsg001"), Color.red, 1);
        end
        WWWEx.newWWW(CLVerManager.self, Utl.urlAddTimes(url),
        formData,
        CLAssetType.text,
        5, 10,
        MBPLogin.onAccountLogin,
        loginError,
        loginError, nil);
    end

    function MBPLogin.onAccountLogin(content, orgs)
        --[[
        public static final int USERNOT = 0;//用户不存在
		public static final int MAPERROR = -1;//参数错误
		public static final int KEYERROR = -2;//机器唯一码为空
		public static final int NAMEERROR = -3;//用户名登陆参数为空
		public static final int PWDERROR = -4;//用户输入密码错误
		public static final int LOGINTYPEERROR = -5;//登陆类型错误
        --]]
        hideHotWheel();
        local d = JSON.DecodeMap(content);
        local user = d;
        local errorCode = MapEx.getInt(d, "errorCode");
        if errorCode == 1 then
            local uid = MapEx.getString(user, "idx");
            if not isNilOrEmpty(uid) then
                hideTopPanel();
                if not isNilOrEmpty(InputUser4Login.value) then
                    Prefs.setUserName(InputUser4Login.value)
                end

                if not isNilOrEmpty(InputPassword4Login.value) then
                    Prefs.setUserPsd(InputPassword4Login.value)
                end

                uid = joinStr("mb_", uid);
                __uid__ = uid;
                Utl.doCallback(onLoginCallback, uid, onLoginCallbackParam);
            else
                printe(content)
                -- 异常
                CLAlert.add(LGet("UIMsg003"), Color.red, 1);
            end
        elseif errorCode == -4 then
            printe(content)
            CLAlert.add("密码错误！", Color.red, 1);
        elseif errorCode == -6 then
            CLAlert.add("同一设备已经超过注册上限！", Color.red, 1);
        else
            printe(content)
            CLAlert.add(LGet("UIMsg002"), Color.red, 1);
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPLogin.hideSelfOnKeyBack( )
        return false;
    end

    --------------------------------------------
    return MBPLogin;
end
