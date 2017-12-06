﻿-- xx界面
do
    MBPPasswordSaveEditor = {}

    local csSelf = nil;
    local transform = nil;
    local objs = {}
    local oldPlatform = "";
    local mData;

    -- 初始化，只会调用一次
    function MBPPasswordSaveEditor.init(csObj)
        csSelf = csObj;
        transform = csObj.transform;
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider");
        --]]

        ---@type CLUIInputRoot
        objs.inputRoot = getCC(transform, "PanelList/Grid", "CLUIInputRoot")
        objs.InputPassword = getCC(transform, "PanelList/Grid/InputPassword", "UIInput")
        objs.ButtonDel = getChild(transform, "AnchorTop/offset/ButtonDel").gameObject;
    end

    -- 设置数据
    function MBPPasswordSaveEditor.setData(paras)
        mData = paras;
        if mData then
            oldPlatform = MapEx.getString(mData, "platform");
        else
            oldPlatform = nil;
        end
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPPasswordSaveEditor.show()
        objs.inputRoot:setValue(mData)
        objs.InputPassword.value = "";
        if mData == nil then
            SetActive(objs.ButtonDel, false)
        else
            SetActive(objs.ButtonDel, true)
        end
    end

    -- 刷新
    function MBPPasswordSaveEditor.refresh()
    end

    -- 关闭页面
    function MBPPasswordSaveEditor.hide()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPPasswordSaveEditor.procNetwork (cmd, succ, msg, paras)
        --[[
        if(succ == 1) then
          if(cmd == "xxx") then
            -- TODO:
          end
        end
        --]]
    end

    -- 处理ui上的事件，例如点击等
    function MBPPasswordSaveEditor.uiEventDelegate( go )
        local goName = go.name;
        if (goName == "ButtonBack") then
            hideTopPanel();
        elseif goName == "ButtonShowPsd" then
            getPanelAsy("PanelSecretKey", onLoadedPanelTT, { cmd = "get",
                callback = function(key)
                    objs.InputPassword.value = EnAndDecryption.decoder(MapEx.getString(mData, "psd"), key);
                end })
        elseif goName == "ButtonAdd" then
            local msg = objs.inputRoot:checkValid();
            if not isNilOrEmpty(msg) then
                CLAlert.add(msg);
                return;
            end

            getPanelAsy("PanelSecretKey", onLoadedPanelTT, { cmd = "set",
                callback = function(key)
                    local m = objs.inputRoot:getValue();
                    MapEx.set(m, "psd", EnAndDecryption.encoder(objs.InputPassword.value, key));
                    MBDBPassword.addOrUpdate(oldPlatform, m)
                    hideTopPanel();
                end })
        elseif goName == "ButtonDel" then
            CLUIUtl.showConfirm("确定要删除该记录？",
            function()
                MBDBPassword.remove(oldPlatform);
            end, nil);
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPPasswordSaveEditor.hideSelfOnKeyBack( )
        return true;
    end

    --------------------------------------------
    return MBPPasswordSaveEditor;
end