-- xx界面
do
    MBPPasswordSaveEditor = {}

    local csSelf = nil
    local transform = nil
    local objs = {}
    local oldPlatform = ""
    local mData
    local lastShowPassworldTime = -1

    -- 初始化，只会调用一次
    function MBPPasswordSaveEditor.init(csObj)
        csSelf = csObj
        transform = csObj.transform
        --[[
        上的组件：getChild(transform, "offset", "Progress BarHong"):GetComponent("UISlider")
        --]]

        objs.Content = getCC(transform, "PanelList", "UIPanel")
        objs.Content.clipOffset = Vector2.zero
        objs.Content.baseClipRegion = MBPMain.contentRect
        ---@type UIScrollView
        objs.scrollView = objs.Content:GetComponent("UIScrollView")
        --objs.grid:setOldClip(objs.Content.clipOffset, objs.Content.transform.localPosition, objs.grid.transform.localPosition)

        ---@type CLUIFormRoot
        objs.inputRoot = getCC(transform, "PanelList/Grid", "CLUIFormRoot")
        objs.InputPassword = getCC(transform, "PanelList/Grid/InputPassword", "UIInput")
        objs.ButtonDel = getChild(transform, "AnchorTop/offset/ButtonDel").gameObject
    end

    -- 设置数据
    function MBPPasswordSaveEditor.setData(paras)
        mData = paras
    end

    -- 显示，在c#中。show为调用refresh，show和refresh的区别在于，当页面已经显示了的情况，当页面再次出现在最上层时，只会调用refresh
    function MBPPasswordSaveEditor.show()
        lastShowPassworldTime = -1
        objs.inputRoot:setValue(mData)
        objs.InputPassword.value = ""
        if mData == nil then
            SetActive(objs.ButtonDel, false)
        else
            SetActive(objs.ButtonDel, true)
        end
        objs.scrollView:ResetPosition()
    end

    -- 刷新
    function MBPPasswordSaveEditor.refresh()
    end

    -- 关闭页面
    function MBPPasswordSaveEditor.hide()
        lastShowPassworldTime = -1
        csSelf:cancelInvoke4Lua()
    end

    -- 网络请求的回调；cmd：指命，succ：成功失败，msg：消息；paras：服务器下行数据
    function MBPPasswordSaveEditor.procNetwork (cmd, succ, msg, paras)
        --[[
        if(succ == 1) then
          if(cmd == "xxx") then
            -- TODO:
          end
        end
        --]]
    end

    -- 处理ui上的事件，例如点击等
    function MBPPasswordSaveEditor.uiEventDelegate(go)
        local goName = go.name
        if (goName == "ButtonBack") then
            hideTopPanel()
        elseif goName == "ButtonShowPsd" then
            getPanelAsy("PanelSecretKey", onLoadedPanelTT,
                    { cmd = "get",
                      callback = function(key)
                          objs.InputPassword.value = SimpleCodeUtl.decrypt(mData.psd, key)
                          lastShowPassworldTime = DateEx.nowMS + 30 * 1000
                          csSelf:invoke4Lua(
                                  function()
                                      objs.InputPassword.value = ""
                                  end, 30)
                      end })
        elseif goName == "ButtonAdd" then
            local msg = objs.inputRoot:checkValid()
            if not isNilOrEmpty(msg) then
                CLAlert.add(msg)
                return
            end

            getPanelAsy("PanelSecretKey", onLoadedPanelTT,
                    { cmd = "set",
                      callback = function(key)
                          local m = objs.inputRoot:getValue(true)
                          m.psd = SimpleCodeUtl.encrypt(objs.InputPassword.value, key)
                          MBDBPassword.addOrUpdate(m)
                          hideTopPanel()
                      end })
        elseif goName == "ButtonDel" then
            CLUIUtl.showConfirm("确定要删除该记录？",
                    function()
                        MBDBPassword.remove(mData.platform, mData.user)
                        hideTopPanel()
                    end, nil)
        end
    end

    -- 当按了返回键时，关闭自己（返值为true时关闭）
    function MBPPasswordSaveEditor.hideSelfOnKeyBack()
        return true
    end

    function MBPPasswordSaveEditor.OnApplicationPause(isPause)
        if lastShowPassworldTime > 0
                --and DateEx.nowMS - lastShowPassworldTime > 0
        then
            csSelf:cancelInvoke4Lua()
            objs.InputPassword.value = ""
            lastShowPassworldTime = 0
        end
    end
    --------------------------------------------
    return MBPPasswordSaveEditor
end
