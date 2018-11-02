-- xx单元
do
    local _cell = {}
    local csSelf = nil;
    local transform = nil;
    local mData = nil;
    local uiobjs = {}

    -- 初始化，只调用一次
    function _cell.init (csObj)
        csSelf = csObj;
        transform = csSelf.transform;
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider");
        --]]
        uiobjs.Label = getCC(transform, "Label", "UILabel")
        uiobjs.LabelCheck = getCC(transform, "LabelCheck", "UILabel")
        uiobjs.boxCollider = csSelf:GetComponent("BoxCollider")
    end

    -- 显示，
    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.show (go, data)
        mData = data;
        uiobjs.Label.text = mData.name
        uiobjs.LabelCheck.text = mData.name
        uiobjs.boxCollider.center = Vector3.zero
        uiobjs.boxCollider.size = Vector3(mData.width, 150, 0)
    end

    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.refresh(paras)
        --[[
        if(paras == 1) then   -- 刷新血
          -- TODO:
        elseif(paras == 2) then -- 刷新状态
          -- TODO:
        end
        --]]
    end

    -- 取得数据
    function _cell.getData ()
        return mData;
    end

    --------------------------------------------
    return _cell;
end
