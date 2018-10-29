-- xx界面
do
    local MBPPasswordSave = {}

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
        objs.grid = getCC(transform, "PanelList/Grid", "CLUILoopTable")
        ---@type TweenPosition
        objs.search = getCC(transform, "AnchorTop/search", "TweenPosition")
        objs.InputSearchKey = getCC(objs.search.transform, "InputSearchKey", "UIInput")

        objs.Content = getCC(transform, "PanelList", "UIPanel")
        objs.Content.transform.localPosition = Vector3.zero
        objs.Content.clipOffset = Vector2.zero
        objs.Content.baseClipRegion = MBPMain.contentRect
        ---@type UIScrollView
        objs.scrollView = objs.Content:GetComponent("UIScrollView");
        objs.grid:setOldClip(objs.Content.clipOffset, objs.Content.transform.localPosition, objs.grid.transform.localPosition)

        objs.gridIndex = getCC(transform, "Right/PanelIndexList/Grid", "UIGrid")
        objs.gridIndex.cellHeight = NumEx.getIntPart(MBPMain.contentRect.w / 27)
        objs.indexPrefab = getChild(objs.gridIndex.transform, "00000").gameObject
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
        MBPPasswordSave.showList({})
        MBPPasswordSave.setIndexs()
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

    function MBPPasswordSave.setIndexs()
        CLUIUtl.resetList4Lua(objs.gridIndex, objs.indexPrefab, MBDBPassword.indexList, MBPPasswordSave.initIndexCell)
    end

    function MBPPasswordSave.initIndexCell(cell, data)
        local _d = { index = data, width = objs.gridIndex.cellWidth, height = objs.gridIndex.cellHeight }
        cell:init(_d, MBPPasswordSave.onClickIndexCell)
    end

    function MBPPasswordSave.onClickIndexCell(cell)
        local d = cell.luaTable.getData()
        if d.isIndex then
            return
        end
        local index = d.index
        local pos = MBDBPassword.getPosByChar(index)
        if (pos >= 0) then
            local orgList = MBDBPassword.getDataWithCharIndex()
            local listPart1 = {};
            for i = pos, #orgList do
                table.insert(listPart1, orgList[i]);
            end
            objs.grid:setList(listPart1, MBPPasswordSave.initCell)

            local listPart2 = {}
            for i = 1, pos - 1 do
                table.insert(listPart2, orgList[i])
            end
            objs.grid:insertList(listPart2, false, true)
        end
    end

    -- 刷新
    function MBPPasswordSave.refresh()
        objs.grid:refreshContentOnly(MBDBPassword.getDataWithCharIndex())
    end

    function MBPPasswordSave.showList(list)
        list = list or MBDBPassword.getDataWithCharIndex()
        objs.grid:setList(list, MBPPasswordSave.initCell);
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
                MBPPasswordSave.showList()
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
        local list = MBDBPassword.getDataWithCharIndex();
        if list then
            for i, v in ipairs(list) do
                if  string.find(string.upper(v.platform), string.upper(key))
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
