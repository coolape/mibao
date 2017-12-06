-- xx界面
do
    MBPSecretKey = {}

    local csSelf = nil;
    local transform = nil;
    local objs = {}
    local mData;  -- mData.cmd="set", mData.callback=nil

    -- 初始化，只会调用一次
    function MBPSecretKey.init(csObj)
        csSelf = csObj;
        transform = csObj.transform;
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider");
        --]]
        ---@type UIGrid
        objs.grid = getCC(transform, "content/Grid", "UIGrid")
        objs.InputPassword = getCC(objs.grid.transform, "InputPassword", "UIInput")
        objs.InputPassword2 = getCC(objs.grid.transform, "InputPassword2", "UIInput")
    end

    -- 设置数据
    function MBPSecretKey.setData(paras)
        mData = paras
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPSecretKey.show()
        objs.InputPassword.value = "";
        objs.InputPassword2.value = "";
        if mData.cmd == "set" then
            SetActive(objs.InputPassword2.gameObject, true)
        else
            SetActive(objs.InputPassword2.gameObject, false)
        end
        objs.grid:Reposition();
    end

    -- 刷新
    function MBPSecretKey.refresh()
    end

    -- 关闭页面
    function MBPSecretKey.hide()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPSecretKey.procNetwork (cmd, succ, msg, paras)
        --[[
        if(succ == 1) then
          if(cmd == "xxx") then
            -- TODO:
          end
        end
        --]]
    end

    -- 处理ui上的事件，例如点击等
    function MBPSecretKey.uiEventDelegate( go )
        local goName = go.name;
        if (goName == "ButtonClose") then
            hideTopPanel();
        elseif goName == "ButtonOkay" then
            objs.InputPassword.value = trim(objs.InputPassword.value)
            local key = objs.InputPassword.value
            if isNilOrEmpty(key) then
                CLAlert.add("请输入密钥", Color.yellow, 1);
                return;
            end

            if havUtf8Char(key) then
                CLAlert.add("密钥只能是英文、数字、及当用符号", Color.yellow, 1);
                return;
            end

            if mData.cmd == "set" then
                if key ~= objs.InputPassword2.value then
                    CLAlert.add("密钥两次输入不一致", Color.yellow, 1);
                    return
                end
            end

            hideTopPanel();
            Utl.doCallback(mData.callback, key);
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPSecretKey.hideSelfOnKeyBack( )
        return true;
    end

    --------------------------------------------
    return MBPSecretKey;
end
