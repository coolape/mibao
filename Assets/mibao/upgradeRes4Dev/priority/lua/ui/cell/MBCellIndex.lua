﻿-- xx单元
do
    local _cell = {}
    local csSelf = nil;
    local transform = nil;
    local mData = nil;
    local label
    local boxCollider

    -- 初始化，只调用一次
    function _cell.init (csObj)
        csSelf = csObj;
        transform = csSelf.transform;
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider");
        --]]

        label = csSelf:GetComponent("UILabel")
        boxCollider = csSelf:GetComponent("BoxCollider")
    end

    -- 显示，
    -- 注意，c#侧不会在调用show时，调用refresh
    function _cell.show ( go, data )
        mData = data

        boxCollider.center = Vector3(0, 0, 0)
        boxCollider.size = Vector3(mData.width, mData.height, 0)
        label.text = mData.index
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
