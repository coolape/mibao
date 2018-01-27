do
    require("bio.BioUtl")
    MBDBPassword = {}
    local path = "";
    ---@type System.Collections.ArrayList
    local mData = nil;

    function MBDBPassword.init()
        path = Utl.chgToSDCard(joinStr(Application.persistentDataPath, "/coolape/mibao/", "mm_",  __uid__, "_", "psdSave.d"));
        if mData ~= nil then
            return
        end
        local bytes = FileEx.ReadAllBytes(path);
        if bytes then
            mData = BioUtl.readObject(bytes)
        end
        mData = mData or {}
    end

    function MBDBPassword.clean()
        mData = nil;
    end

    function MBDBPassword.save()
        if mData == nil then
            return
        end
        FileEx.WriteAllBytes(path, BioUtl.writeObject(mData))
    end

    function MBDBPassword.getData()
        MBDBPassword.init();
        return mData;
    end

    function MBDBPassword.setData(d)
        mData = d
        MBDBPassword.save()
    end

    function MBDBPassword.addOrUpdate(data)
        MBDBPassword.init()
        data.time = DateEx.nowMS;
        local isUpgrade = false
        for i, v in ipairs(mData) do
            if v.platform == data.platform then
                mData[i] = data;
                isUpgrade = true;
                break;
            end
        end
        if not isUpgrade then
            table.insert(mData, data)
        end
        MBDBPassword.save();
    end

    function MBDBPassword.remove(key, user)
        if isNilOrEmpty(key) then
            return;
        end

        MBDBPassword.init();
        for i ,v in ipairs(mData) do
            if v.platform == key and v.user == user then
                table.remove(mData, i)
                break
            end
        end
        MBDBPassword.save();
    end
    --------------------------------------------
    return MBDBPassword;
end
