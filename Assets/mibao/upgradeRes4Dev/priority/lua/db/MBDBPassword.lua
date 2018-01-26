do
    require("bio.BioUtl")
    MBDBPassword = {}
    local path = Utl.chgToSDCard(joinStr(Application.persistentDataPath, "/coolape/mibao/", __uid__, "_", "psdSave.d"));
    ---@type System.Collections.ArrayList
    local mData = nil;

    function MBDBPassword.init()
        if mData ~= nil then
            return
        end
        local bytes = FileEx.ReadAllBytes(path);
        if bytes then
            mData = BioUtl.readObject(bytes)
        end
        mData = mData or {}
        --mData = Utl.fileToObj(path)
        --if mData == nil then
        --    mData = ArrayList();
        --end
    end

    function MBDBPassword.clean()
        mData = nil;
    end

    function MBDBPassword.save()
        if mData == nil then
            return
        end
        --local ms = MemoryStream();
        --B2OutputStream.writeObject(ms, mData);
        --Directory.CreateDirectory(Path.GetDirectoryName(path));
        --FileEx.WriteAllBytes(path, ms:ToArray());
        FileEx.WriteAllBytes(BioUtl.writeObject(mData))
    end

    function MBDBPassword.getData()
        MBDBPassword.init();
        return mData;
    end

    function MBDBPassword.addOrUpdate(data)
        MBDBPassword.init();
        --if not isNilOrEmpty(oldKey) then
        --    for i = 0, mData.Count - 1 do
        --        if MapEx.getString(mData[i], "platform") == oldKey then
        --            mData:RemoveAt(i);
        --            break
        --        end
        --    end
        --end
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
