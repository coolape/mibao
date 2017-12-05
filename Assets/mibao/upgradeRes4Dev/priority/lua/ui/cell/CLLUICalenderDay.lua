-- 单元
do

    local uiCell = {}

    local csSelf = nil;
    local transform = nil;
    local gameObject = nil;
    local Background = nil;
    local Label = nil;

    local mData = nil;

    function uiCell.init(go)
        gameObject = go;
        transform = go.transform;
        csSelf = gameObject:GetComponent("CLCellLua");

        Background = getChild(transform, "Background"):GetComponent("UISprite");
        Label = getChild(transform, "Label"):GetComponent("UILabel");
    end

    function uiCell.show(go, data)
        mData = data;
        if (mData.day < 0) then
            Label.text = "";
        else
            Label.text = tostring(mData.day);
        end
        local isSelected = MapEx.getBool(mData, "isSelected");
        uiCell.refreshState(isSelected);
    end

    function uiCell.refreshState(isSelected)
        if(mData == nil) then return end
        mData.isSelected = isSelected;
        if (mData.isToday) then
            Background.color = ColorEx.getColor(133, 255, 133);
            Label.color = Color.black;
        else
            Background.color = ColorEx.getColor(242, 242, 242);
            Label.color = Color.black;
        end

        if (isSelected) then
            Background.color = ColorEx.getColor(7, 145, 148);
            Label.color = Color.white;
        end
    end

    function uiCell.refresh(flag)
    end

    function uiCell.getData()
        return mData;
    end

    return uiCell;
end
