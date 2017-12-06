-- xx界面
do
    MBPPasswordSave = {}

    local csSelf = nil;
    local transform = nil;
    local objs = {}

    -- 初始化，只会调用一次
    function MBPPasswordSave.init(csObj)
        csSelf = csObj;
        transform = csObj.transform;
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider");
        --]]
        ---@type Coolape.CLUILoopGrid
        objs.grid = getCC(transform, "PanelList/Grid", "CLUILoopGrid")
    end

    -- 设置数据
    function MBPPasswordSave.setData(paras)
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPPasswordSave.show()
    end

    function MBPPasswordSave.initCell(cell, data)
        cell:init(data, MBPPasswordSave.onClickCell);
    end

    function MBPPasswordSave.onClickCell(cell)
        local data = cell.luaTable.getData();
        getPanelAsy("PanelPasswordSaveEditor", onLoadedPanelTT, data)
    end

    -- 刷新
    function MBPPasswordSave.refresh()
        objs.grid:setList(MBDBPassword.getData(), MBPPasswordSave.initCell);
    end

    -- 关闭页面
    function MBPPasswordSave.hide()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPPasswordSave.procNetwork (cmd, succ, msg, paras)
        --[[
        if(succ == 1) then
          if(cmd == "xxx") then
            -- TODO:
          end
        end
        --]]
    end

    -- 处理ui上的事件，例如点击等
    function MBPPasswordSave.uiEventDelegate( go )
        local goName = go.name;
        if (goName == "ButtonBack") then
            hideTopPanel();
        elseif (goName == "ButtonAdd") then
            getPanelAsy("PanelPasswordSaveEditor", onLoadedPanelTT, nil)
        elseif goName == "ButtonSearch" then
            
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPPasswordSave.hideSelfOnKeyBack( )
        return true;
    end

    --------------------------------------------
    return MBPPasswordSave;
end
