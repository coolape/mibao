-- bio 工具
do
    require("bio.BioInputStream")
    require("bio.BioOutputStream")
    BioUtl = {}

    function BioUtl.writeObject(obj)
        local os = LuaB2OutputStream.new();
        BioOutputStream.writeObject(os, obj);
        local bytes = os:toBytes();
        os:release();
        os = nil;
        return bytes;
    end

    function BioUtl.readObject(bytes)
        local is = LuaB2InputStream.new(bytes);
        local result = BioInputStream.readObject(is);
        is:release();
        is = nil;
        return result;
    end
    --------------------------------------------
    return BioUtl;
end
