﻿-- xx界面
do
    MBPPasswordSave = {}

    local csSelf = nil;
    local transform = nil;
    local objs = {}
    local isShowingSearch = false;

    -- 初始化，只会调用一次
    function MBPPasswordSave.init(csObj)
        csSelf = csObj;
        transform = csObj.transform;
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider");
        --]]
        ---@type Coolape.CLUILoopGrid
        objs.grid = getCC(transform, "PanelList/Grid", "CLUILoopGrid")
        ---@type TweenPosition
        objs.search = getCC(transform, "AnchorTop/search", "TweenPosition")
        objs.InputSearchKey = getCC(objs.search.transform, "InputSearchKey", "UIInput")

        objs.Content = getCC(transform, "PanelList", "UIPanel")
        objs.Content.transform.localPosition = Vector3.zero
        objs.Content.clipOffset = Vector2.zero;
        objs.Content.baseClipRegion = MBPMain.contentRect;
        ---@type UIScrollView
        objs.scrollView = objs.Content:GetComponent("UIScrollView");
        objs.grid:setOldClip(objs.Content.clipOffset, objs.Content.transform.localPosition, objs.grid.transform.localPosition)
    end

    -- 设置数据
    function MBPPasswordSave.setData(paras)
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPPasswordSave.show()
        --objs.search:ResetToBeginning();
        MBPPasswordSave.hideSearch()
        --csSelf:invoke4Lua(function()
        --    objs.scrollView:ResetPosition();
        --end, 0.1);
        objs.grid:setList(MBDBPassword.getData(), MBPPasswordSave.initCell);
        --objs.scrollView:ResetPosition()
    end

    function MBPPasswordSave.initCell(cell, data)
        cell:init(data, MBPPasswordSave.onClickCell);
    end

    function MBPPasswordSave.onClickCell(cell)
        MBPPasswordSave.hideSearch()
        local data = cell.luaTable.getData();
        getPanelAsy("PanelPasswordSaveEditor", onLoadedPanelTT, data)
    end

    -- 刷新
    function MBPPasswordSave.refresh()
        objs.grid:refreshContentOnly(MBDBPassword.getData());
    end

    -- 关闭页面
    function MBPPasswordSave.hide()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPPasswordSave.procNetwork (cmd, succ, msg, datas)
        if (succ == 1) then
            if (cmd == NetProtoMibao.cmds.syndata) then
                hideHotWheel()
                MBDBPassword.setData(datas.newData);
                MBPPasswordSave.refresh()
                CLAlert.add("success");
            end
        end
    end

    -- 处理ui上的事件，例如点击等
    function MBPPasswordSave.uiEventDelegate( go )
        local goName = go.name;
        if (goName == "ButtonBack") then
            hideTopPanel();
        elseif (goName == "ButtonAdd") then
            getPanelAsy("PanelPasswordSaveEditor", onLoadedPanelTT, nil)
        elseif goName == "ButtonSearch" then
            isShowingSearch = not isShowingSearch;
            objs.search:Play(isShowingSearch)
        elseif goName == "InputSearchKey" then
            objs.InputSearchKey.value = trim(objs.InputSearchKey.value)
            if isNilOrEmpty( objs.InputSearchKey.value) then
                objs.grid:setList(MBDBPassword.getData(), MBPPasswordSave.initCell);
                return
            end
            MBPPasswordSave.search(objs.InputSearchKey.value)
        elseif goName == "SpriteBg" then
            MBPPasswordSave.hideSearch()
        elseif goName == "ButtonSyn" then
            local data = MBDBPassword.getData()
            showHotWheel()
            CLLNet.httpPostMibao(NetProtoMibao.send.syndata(data))
        elseif goName == "ButtonUp" then
            MBPPasswordSave.hideSearch()
        end
    end
    function MBPPasswordSave.hideSearch()
        if isShowingSearch then
            isShowingSearch = false;
            objs.search:Play(isShowingSearch)
        end
    end

    function MBPPasswordSave.search(key)
        local ret = {}
        local list = MBDBPassword.getData();
        if list then
            for i, v in ipairs(list) do
                if string.find(string.upper(v.platform), string.upper(key))
                        or string.find(string.upper(v.desc), string.upper(key)) then
                    table.insert(ret, v)
                end
            end
        end

        if #ret == 0 then
            CLAlert.add("无数据");
        end
        objs.grid:setList(ret, MBPPasswordSave.initCell);
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPPasswordSave.hideSelfOnKeyBack( )
        return true;
    end

    --------------------------------------------
    return MBPPasswordSave;
end
