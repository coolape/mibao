-- bio 工具
do
    require("bio.BioInputStream")
    require("bio.BioOutputStream")
    BioUtl = {}

    function BioUtl.writeObject(obj)
        local os = LuaB2OutputStream.new();
        local status = pcall(BioOutputStream.writeObject, os, obj);
        if status then
            local bytes = os:toBytes();
            os:release();
            os = nil;
            return bytes;
        else
            return nil;
        end
    end

    function BioUtl.readObject(bytes)
        local is = LuaB2InputStream.new(bytes);
        local status, result = pcall(BioInputStream.readObject, is);
        if status then
            is:release();
            is = nil;
            return result;
        else
            return nil;
        end
    end
    --------------------------------------------
    return BioUtl;
end
