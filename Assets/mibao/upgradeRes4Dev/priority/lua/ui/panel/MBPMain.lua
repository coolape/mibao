﻿-- xx界面
do
    MBPMain = {}

    local csSelf = nil;
    local transform = nil;
    MBPMain.sizeAdjust = 1;
    MBPMain.contentRect = Rect.zero;
    local _BottomHeight_ =150
    local _TopHeight_ = 150
    local objs = {}

    -- 初始化，只会调用一次
    function MBPMain.init(csObj)
        csSelf = csObj;
        transform = csObj.transform;

        MBPMain.sizeAdjust = UIRoot.GetPixelSizeAdjustment(csSelf.gameObject);
        MBPMain.contentRect = Vector4(0, 0,
        Screen.width * MBPMain.sizeAdjust,
        Screen.height * MBPMain.sizeAdjust - (_BottomHeight_ + _TopHeight_));

        objs.Content = getCC(transform, "PanelContent", "UIPanel")
        objs.Content.clipOffset = Vector2.zero;
        objs.Content.baseClipRegion = MBPMain.contentRect;
        ---@type UIScrollView
        objs.scrollView = objs.Content:GetComponent("UIScrollView");
    end

    -- 设置数据
    function MBPMain.setData(paras)
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPMain.show()
        objs.scrollView:ResetPosition()
    end

    -- 刷新
    function MBPMain.refresh()
    end

    -- 关闭页面
    function MBPMain.hide()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPMain.procNetwork (cmd, succ, msg, paras)
        --[[
        if(succ == 1) then
          if(cmd == "xxx") then
            -- TODO:
          end
        end
        --]]
    end

    -- 处理ui上的事件，例如点击等
    function MBPMain.uiEventDelegate( go )
        local goName = go.name;
        if (goName == "Button01") then
            -- 密码保护
            getPanelAsy("PanelPasswordSave", onLoadedPanelTT)
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPMain.hideSelfOnKeyBack( )
        return false;
    end

    --------------------------------------------
    return MBPMain;
end
