-- xx界面
do
    MBPMain = {}

    local csSelf = nil;
    local transform = nil;
    MBPMain.sizeAdjust = 1;
    MBPMain.contentRect = Vector4.zero;
    local objs = {}

    -- 初始化，只会调用一次
    function MBPMain.init(csObj)
        csSelf = csObj;
        transform = csObj.transform;
        MBPMain.contentRect = getUIContent(csSelf)

        --objs.Content = getCC(transform, "PanelContent", "UIPanel")
        --objs.Content.transform.localPosition = Vector3.zero;
        --objs.Content.clipOffset = Vector2.zero;
        --objs.Content.baseClipRegion = MBPMain.contentRect;
        -----@type UIScrollView
        --objs.scrollView = objs.Content:GetComponent("UIScrollView");

        objs.LabelTitle = getCC(transform, "AnchorTop/offset/LabelTitle", "UILabel")

        objs.bottomGrid = getCC(transform, "AnchorBottom/Grid", "UIGrid")
        objs.bottomCellPrefab = getChild(objs.bottomGrid.transform, "00000").gameObject
    end

    -- 设置数据
    function MBPMain.setData(paras)
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPMain.show()
        --objs.scrollView:ResetPosition()
        MBPMain.setBottomBtns()
    end

    function MBPMain.setBottomBtns()
        local bottomBtns = { { id = 1, name = "首页", panel = "PanelHome" },
                             { id = 9, name = "设置", panel = "PanelSetting" } }
        local width = NumEx.getIntPart(MBPMain.contentRect.z / #bottomBtns)
        objs.bottomGrid.cellWidth = width
        CLUIUtl.resetList4Lua(objs.bottomGrid, objs.bottomCellPrefab, bottomBtns, MBPMain.initBottomBtn)
    end

    function MBPMain.initBottomBtn(cell, data)
        data.width = objs.bottomGrid.cellWidth
        cell:init(data, MBPMain.onClickBottonBtn)
        if data.id == 1 then
            MBPMain.onClickBottonBtn(cell)
        end
    end

    function MBPMain.onClickBottonBtn(cell)
        local data = cell.luaTable.getData()
        objs.LabelTitle.text = data.name
        if CLPanelManager.topPanel ~= nil and CLPanelManager.topPanel ~= csSelf then
            hideTopPanel()
        end
        getPanelAsy(data.panel, onLoadedPanelTT)
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
    function MBPMain.uiEventDelegate(go)
        local goName = go.name;
        if (goName == "Button01") then
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPMain.hideSelfOnKeyBack()
        return false;
    end

    --------------------------------------------
    return MBPMain;
end
