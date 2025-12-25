pub const c = @cImport({
    @cDefine("WIN32_LEAN_AND_MEAN", "");
    @cInclude("windows.h");
});
