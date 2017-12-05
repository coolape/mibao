-- xx单元
do
    local _cell = {}
    local csSelf = nil;
    local transform = nil;
    local objs = {}
    local mData = nil;

    -- 初始化，只调用一次
    function _cell.init (csObj)
        csSelf = csObj;
        transform = csSelf.transform;
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider");
        --]]
        objs.LabelPlatform = getCC(transform, "LabelPlatform", "UILabel")
        objs.LabelDesc = getCC(transform, "LabelDesc", "UILabel")
        objs.LabelUser = getCC(transform, "LabelUser", "UILabel")
        objs.LabelPassword = getCC(transform, "ButtonPssword/LabelPassword", "UILabel")
    end

    -- 显示，
    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.show ( go, data )
        mData = data;
        --[[
        TODO:
        --]]
    end

    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.refresh( paras )
        --[[
        if(paras == 1) then   -- 刷新血
          -- TODO:
        elseif(paras == 2) then -- 刷新状态
          -- TODO:
        end
        --]]
    end

    -- 取得数据
    function _cell.getData ( )
        return mData;
    end

    --------------------------------------------
    return _cell;
end
