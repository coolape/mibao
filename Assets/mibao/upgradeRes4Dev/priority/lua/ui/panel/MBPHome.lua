-- xx界面
do
    local MBPHome = {}

    local csSelf = nil
    local transform = nil
    MBPHome.sizeAdjust = 1
    MBPHome.contentRect = Vector4.zero
    local objs = {}

    -- 初始化，只会调用一次
    function MBPHome.init(csObj)
        csSelf = csObj
        transform = csObj.transform
        MBPHome.contentRect = MBPMain.contentRect
        objs.Content = getCC(transform, "PanelContent", "UIPanel")
        objs.Content.transform.localPosition = Vector3.zero
        objs.Content.clipOffset = Vector2.zero
        objs.Content.baseClipRegion = MBPHome.contentRect
        ---@type UIScrollView
        objs.scrollView = objs.Content:GetComponent("UIScrollView")
    end

    -- 设置数据
    function MBPHome.setData(paras)
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPHome.show()
        objs.scrollView:ResetPosition()
    end

    function MBPHome.onClickBottonBtn(cell)

    end

    -- 刷新
    function MBPHome.refresh()
    end

    -- 关闭页面
    function MBPHome.hide()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPHome.procNetwork (cmd, succ, msg, paras)
        --[[
        if(succ == 1) then
          if(cmd == "xxx") then
            -- TODO:
          end
        end
        --]]
    end

    -- 处理ui上的事件，例如点击等
    function MBPHome.uiEventDelegate(go)
        local goName = go.name
        if (goName == "Button01") then
            getPanelAsy("PanelPasswordSave", onLoadedPanelTT)
            --[[
            if isNilOrEmpty(__uid__) then
                getPanelAsy("PanelLogin", onLoadedPanelTT, {function (uid)
                    if uid then
                        getPanelAsy("PanelPasswordSave", onLoadedPanelTT)
                    end
                end}
                )
            else
                -- 密码保护
                getPanelAsy("PanelPasswordSave", onLoadedPanelTT)
            end
            --]]
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPHome.hideSelfOnKeyBack()
        return false
    end

    --------------------------------------------
    return MBPHome
end
