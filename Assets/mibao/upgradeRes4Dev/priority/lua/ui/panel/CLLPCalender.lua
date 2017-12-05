do
    local csSelf = nil;
    local transform = nil;
    local gameObject = nil;
    local grid = nil;

    local LabelYY = nil;
    local LabelMM = nil;
    local curYear = nil;
    local curMonth = nil;
    local TimeRoot;
    local ButtonRoot;
    local InputHH;
    local InputMM;
    local InputSS;

    local LabelSelectDate;

    local callback = nil;

    local selectedYear;
    local selectedMonth;
    local selectedDay;

    local oldSelectedCell;
    local isNeedTime = false;
    local curIndex = 0;

    PanelCalender = {};
    function PanelCalender.init(_cs)
        csSelf = _cs;
        transform = csSelf.transform;
        gameObject = csSelf.gameObject;

        local content = getChild(transform, "content");
        LabelYY = getChild(content, "Title", "LabelYY"):GetComponent("UILabel");
        LabelMM = getChild(content, "Title", "LabelMM"):GetComponent("UILabel");
        grid = getChild(content, "PanelDay/GridPage"):GetComponent("UIGridPage");
        LabelSelectDate = getChild(content, "LabelSelectDate"):GetComponent("UILabel");

        ButtonRoot = getChild(content, "ButtonRoot");
        TimeRoot = getChild(content, "TimeRoot");
        InputHH = getChild(TimeRoot, "InputHH"):GetComponent("UIPopupList");
        InputMM = getChild(TimeRoot, "InputMM"):GetComponent("UIPopupList");
        InputSS = getChild(TimeRoot, "InputSS"):GetComponent("UIPopupList");
    end

    function PanelCalender.setData(pars)
        curYear = pars[0];
        curMonth = pars[1];
        callback = pars[2];
        if (pars.Count > 3) then
            isNeedTime = pars[3];
        else
            isNeedTime = false;
        end
    end

    function PanelCalender.getData()
        return curYear, curMonth;
    end

    function PanelCalender.show()
        csSelf.panel.depth = CLPanelManager.self.depth + 80;

        oldSelectedCell = nil;
        selectedYear = nil;
        selectedMonth = nil;
        selectedDay = nil;
        if (isNeedTime) then
            NGUITools.SetActive(TimeRoot.gameObject, true);
            InputHH.value = NumEx.nStrForLen(DateTime.Now.Hour, 2);
            InputMM.value = NumEx.nStrForLen(DateTime.Now.Minute, 2);
            InputSS.value = NumEx.nStrForLen(DateTime.Now.Second, 2);
            ButtonRoot.localPosition = Vector3(0, -470, 0);
        else
            NGUITools.SetActive(TimeRoot.gameObject, false);
            ButtonRoot.localPosition = TimeRoot.localPosition;
        end
    end

    function PanelCalender.refresh()
        PanelCalender.showCalender(curYear, curMonth);
        if (selectedYear ~= nil) then
            local dataStr = PStr.b():a(tostring(selectedYear)):a("-"):a(NumEx.nStrForLen(selectedMonth, 2)):a("-"):a(NumEx.nStrForLen(selectedDay, 2)):e();
            LabelSelectDate.text = dataStr;
        else
            LabelSelectDate.text = "";
        end
    end


    function PanelCalender.getYYHH_ByaddMonth(_year, _month, addMonth)
        local date = DateTime(_year, _month, 1);

        date = date:AddMonths(addMonth);

        return date.Year, date.Month;
    end

    function PanelCalender.showCalender(year, month)
        LabelYY.text = year .. "年";
        LabelMM.text = month .. "月";

        local months = ArrayList();
        local d;
        local yy, mm;
        for i = 1, 6 do
            yy, mm = PanelCalender.getYYHH_ByaddMonth(year, month, -(7 - i));
            d = Hashtable();
            d.year = yy;
            d.month = mm;
            months:Add(d);
        end

        d = Hashtable();
        d.year = year;
        d.month = month;
        months:Add(d);

        for i = 1, 6 do
            yy, mm = PanelCalender.getYYHH_ByaddMonth(year, month, i);
            d = Hashtable();
            d.year = yy;
            d.month = mm;
            months:Add(d);
        end

        grid:init(months, PanelCalender.onRefreshCurrent, 6);
    end

    function PanelCalender.onRefreshCurrent(index, data, cell)
        curIndex = index;
        local cellLua = cell:GetComponent("CLCellLua");
        local d = cellLua.luaTable.getData();
        if (d ~= nil) then
            LabelYY.text = d.year .. "年";
            LabelMM.text = d.month .. "月";
        end
    end

    function PanelCalender.getSelectDate()
        return selectedYear, selectedMonth, selectedDay;
    end

    function PanelCalender.setDefalutSelectDate(cell, year, month, day)
        if (oldSelectedCell == nil) then
            oldSelectedCell = cell;
        end
        if (selectedDay == nil) then
            selectedDay = day;
            selectedYear = year;
            selectedMonth = month;
        end
    end

    function PanelCalender.setSelectDate(cell, year, month, day)
        selectedDay = day;
        selectedYear = year;
        selectedMonth = month;
        local dataStr = PStr.b():a(tostring(selectedYear)):a("-"):a(NumEx.nStrForLen(selectedMonth, 2)):a("-"):a(NumEx.nStrForLen(selectedDay, 2)):e();
        LabelSelectDate.text = dataStr;


        if (oldSelectedCell ~= nil) then
            oldSelectedCell.luaTable.refreshState(false);
        end
        oldSelectedCell = cell;
        oldSelectedCell.luaTable.refreshState(true);
    end

    --    function PanelCalender.addMonth(m)
    --        oldSelectedCell = nil;
    --
    --        local yearOffset = (curMonth + m) / 13;
    --        curMonth = (curMonth + m) % 13;
    --        if (curMonth == 0) then
    --            if (m < 0) then
    --                curMonth = 12;
    --                yearOffset = -1;
    --            else
    --                curMonth = 1;
    --            end
    --        end
    --
    --        curYear = curYear + math.floor(yearOffset);
    --        PanelCalender.showCalender(curYear, curMonth);
    --        return curYear, curMonth;
    --    end

    function PanelCalender.hide()
    end

    function PanelCalender.procNetwork(cmd, succ, msg, paras)
    end

    function PanelCalender.uiEventDelegate(go)
        PanelCalender.onClickBtn(go.name);
    end

    function PanelCalender.onClickBtn(btnName)
        if (btnName == "ButtonPrevMM") then
            --            PanelCalender.addMonth(-1);
            grid:moveTo(curIndex - 1);
        elseif (btnName == "ButtonNextMM") then
            --            PanelCalender.addMonth(1);
            grid:moveTo(curIndex + 1);
        elseif (btnName == "ButtonPrevYY") then
            --            PanelCalender.addMonth(-13);
            grid:moveTo(curIndex - 12);
        elseif (btnName == "ButtonNextYY") then
            --            PanelCalender.addMonth(13);
            grid:moveTo(curIndex + 12);
        elseif (btnName == "SpriteClose" or btnName == "ButtonClose") then
            CLPanelManager.hidePanel(csSelf);
        elseif btnName == "ButtonToday" then
            oldSelectedCell = nil;
            curYear = DateTime.Now.Year;
            curMonth = DateTime.Now.Month;
            csSelf:show();
        elseif btnName == "ButtonOkay" then
            CLPanelManager.hidePanel(csSelf);
            local dataStr = "";
            if (selectedYear ~= nil) then
                dataStr = PStr.b():a(tostring(selectedYear)):a("-"):a(NumEx.nStrForLen(selectedMonth, 2)):a("-"):a(NumEx.nStrForLen(selectedDay, 2)):e();
                if (isNeedTime) then
                    dataStr = PStr.b():a(dataStr):a(" "):a(NumEx.nStrForLen(InputHH.value, 2)):a(":"):a(NumEx.nStrForLen(InputMM.value, 2)):a(":"):a(NumEx.nStrForLen(InputSS.value, 2)):e();
                end
            end
            Utl.doCallback(callback, dataStr);
        end
    end

    return PanelCalender;
end
