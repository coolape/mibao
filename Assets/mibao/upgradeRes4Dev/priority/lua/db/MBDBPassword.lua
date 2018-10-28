do
    require("bio.BioUtl")
    MBDBPassword = {}
    local path = "";
    ---@type System.Collections.ArrayList
    local mData = nil;
    MBDBPassword.indexList = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#" };
    MBDBPassword.indexMap = {}
    for i, v in ipairs(MBDBPassword.indexList) do
        MBDBPassword.indexMap[v] = i
    end

    function MBDBPassword.getValByChar(char)
        return MBDBPassword.indexMap[char] or #(MBDBPassword.indexList)
    end

    function MBDBPassword.getPosByChar(Char)
        local indexVal = MBDBPassword.getValByChar(Char)
        if mData == nil then return 0 end
        for i,v in ipairs(mData) do
            if MBDBPassword.getValByChar(v.pyKey) == indexVal then
                return i
            elseif MBDBPassword.getValByChar(v.pyKey) > indexVal then
                return i
            end
        end
        return 0
    end

    function MBDBPassword.init()
        path = Utl.chgToSDCard(joinStr(Application.persistentDataPath, "/coolape/mibao/", "mm_", __uid__, "_", "psdSave.d"));
        if mData ~= nil then
            return
        end
        local bytes = FileEx.ReadAllBytes(path);
        if bytes then
            mData = BioUtl.readObject(bytes)
        end
        mData = mData or {}
        for i, v in ipairs(mData) do
            if v.py == nil then
                v.py = Pinyin.GetInitials(v.platform)
                v.pyKey = v.py:sub(1, 1)
                v.indexVal = MBDBPassword.getValByChar(v.pyKey)
            end
        end
        MBDBPassword.sort()
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
        MBDBPassword.wrapData()
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
        for i, v in ipairs(mData) do
            if v.platform == key and v.user == user then
                table.remove(mData, i)
                break
            end
        end
        MBDBPassword.save();
    end

    function MBDBPassword.sort()
        if mData == nil then
            return
        end
        table.sort(mData,
                function(a, b)
                    return a.indexVal < b.indexVal
                end
        )
    end
    --------------------------------------------
    return MBDBPassword;
end
