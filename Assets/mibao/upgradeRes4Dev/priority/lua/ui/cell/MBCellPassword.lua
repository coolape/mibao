-- xx单元
do
    local _cell = {}
    local csSelf = nil;
    local transform = nil;
    local objs = {}
    local mData = nil;
    local btnTxt = "查看密码";
    local isShowingPsd = false

    -- 初始化，只调用一次
    function _cell.init (csObj)
        csSelf = csObj;
        transform = csSelf.transform;
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider");
        --]]
        ---@type CLUIInputRoot
        objs.root = csSelf:GetComponent("CLUIInputRoot");
        objs.LabelPlatform = getCC(transform, "LabelPlatform", "UILabel")
        objs.LabelDesc = getCC(transform, "LabelDesc", "UILabel")
        objs.LabelUser = getCC(transform, "LabelUser", "UILabel")
        objs.LabelPassword = getCC(transform, "ButtonPssword/LabelPassword", "UILabel")
    end

    -- 显示，
    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.show ( go, data )
        mData = data;
        isShowingPsd = false;
        objs.root:setValue(mData)
        objs.LabelPassword.text = btnTxt;
    end

    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.refresh( paras )
        --[[
        if(paras == 1) then   -- 刷新血
          -- TODO:
        elseif(paras == 2) then -- 刷新状态
          -- TODO:
        end
        --]]
    end

    -- 取得数据
    function _cell.getData ( )
        return mData;
    end

    function _cell.uiEventDelegate(go)
        local goName = go.name;
        if goName == "ButtonPssword" then
            if not isShowingPsd then
                getPanelAsy("PanelSecretKey", onLoadedPanelTT, { cmd = "get",
                    callback = function(key)
                        isShowingPsd = true;
                        objs.LabelPassword.text = EnAndDecryption.decoder(MapEx.getString(mData, "psd"), key);
                        csSelf:invoke4Lua(_cell.hidePassword, 3);
                    end })
            else
                _cell.hidePassword();
            end
        end
    end

    function _cell.hidePassword()
        isShowingPsd = false
        objs.LabelPassword.text = btnTxt;
    end

    function _cell.OnDisable()
        csSelf:cancelInvoke4Lua();
    end
    --------------------------------------------
    return _cell;
end
