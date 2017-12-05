-- xx单元
do
    local _cell = {}
    local csSelf = nil;
    local transform = nil;
    local grid;
    local dayPrefab = nil;
    local mData = nil;

    -- 初始化，只调用一次
    function _cell.init(csObj)
        csSelf = csObj;
        transform = csSelf.transform;
        grid = getChild(transform, "Grid"):GetComponent("UIGrid");
        dayPrefab = getChild(grid.transform, "00000").gameObject;
    end

    -- 显示，
    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.show(go, data)
    end

    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.refresh(data, pageIndex)
        mData = data;
        if (mData == nil) then
            mData = Hashtable();
            local curYear, curMonth = PanelCalender.getData();
            if (pageIndex < 0) then
                mData.year, mData.month = PanelCalender.getYYHH_ByaddMonth(curYear, curMonth, -6 + pageIndex);
            else
                mData.year, mData.month = PanelCalender.getYYHH_ByaddMonth(curYear, curMonth, -6 + pageIndex);
            end
        end

        CLUIUtl.resetList4Lua(grid, dayPrefab,
            _cell.resetCalender(mData.year, mData.month),
            _cell.initCellDay);
    end

    -- 取得数据
    function _cell.getData()
        return mData;
    end

    function _cell.initCellDay(cell, day)
        local data = Hashtable();
        data.day = day;
        --        print(mData.year);
        --        print(mData.month);
        --        print(day);
        --        print("=================");
        if (mData.year == DateTime.Now.Year and
                mData.month == DateTime.Now.Month and
                day == DateTime.Now.Day) then
            data.isToday = true;
            PanelCalender.setDefalutSelectDate(cell, mData.year, mData.month, day);
        else
            data.isToday = false;
            data.isSelected = false;
        end
        local selectedYear, selectedMonth, selectedDay = PanelCalender.getSelectDate();
        if (mData.year == selectedYear and mData.month == selectedMonth and selectedDay == data.day) then
            data.isSelected = true;
        end
        cell:init(data, _cell.onClickDay);
    end

    function _cell.onClickDay(cell)
        local d = cell.luaTable.getData();
        if (d.day == -1) then
            return;
        end

        local selectedDay = cell.luaTable.getData().day;
        local selectedMonth = mData.month;
        local selectedYear = mData.year;

        PanelCalender.setSelectDate(cell, selectedYear, selectedMonth, selectedDay);
    end

    function _cell.resetCalender(year, month)
        local list = ArrayList();
        local dayCount = DateEx.getMothDays(year, month);
        local week = DateEx.getWeek(year, month, 1);
        for i = 0, week - 1 do
            list:Add(-1);
        end
        for i = week, dayCount - 1 + week do
            -- print(i .. "-" .. week .. "+1");
            list:Add(i - week + 1);
        end
        for i = dayCount + week, 41 do
            list:Add(-1);
        end
        return list;
    end

    --------------------------------------------
    return _cell;
end
