do
    MBDBPassword = {}
    local path = Utl.chgToSDCard(joinStr(Application.persistentDataPath, "/coolape/mibao/", __uid__, "_", "psdSave.d"));
    ---@type System.Collections.ArrayList
    local mData = nil;

    function MBDBPassword.init()
        if mData ~= nil then
            return
        end
        mData = Utl.fileToObj(path)
        if mData == nil then
            mData = ArrayList();
        end
    end

    function MBDBPassword.clean()
        mData = nil;
    end

    function MBDBPassword.save()
        if mData == nil then
            return
        end
        local ms = MemoryStream();
        B2OutputStream.writeObject(ms, mData);
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        FileEx.WriteAllBytes(path, ms:ToArray());
    end

    function MBDBPassword.getData()
        MBDBPassword.init();
        return mData;
    end

    function MBDBPassword.addOrUpdate(oldKey, data)
        MBDBPassword.init();
        if not isNilOrEmpty(oldKey) then
            for i = 0, mData.Count - 1 do
                if MapEx.getString(mData[i], "platform") == oldKey then
                    mData:RemoveAt(i);
                    break
                end
            end
        end

        local isUpgrade = false
        for i = 0, mData.Count - 1 do
            if MapEx.getString(mData[i], "platform") == MapEx.getString(data, "platform") then
                mData[i] = data;
                isUpgrade = true;
                break;
            end
        end
        if not isUpgrade then
            mData:Add(data);
        end
        MBDBPassword.save();
    end

    function MBDBPassword.remove(key)
        if isNilOrEmpty(key) then
            return;
        end

        MBDBPassword.init();
        for i = 0, mData.Count - 1 do
            if MapEx.getString(mData[i], "platform") == key then
                mData:RemoveAt(i);
                break
            end
        end
        MBDBPassword.save();
    end
    --------------------------------------------
    return MBDBPassword;
end
