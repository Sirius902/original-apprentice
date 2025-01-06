pub const OBSEInterface = extern struct {
    obse_version: u32,
    oblivion_version: u32,
    editor_version: u32,
    is_editor: u32,
    // TODO(Sirius902) *CommandInfo
    registerCommand: *const fn (info: *anyopaque) callconv(.C) bool, // returns true for success, false for failure
    setOpcodeBase: *const fn (opcode: u32) callconv(.C) void,
    queryInterface: *const fn (id: u32) callconv(.C) *anyopaque,

    // TODO(Sirius902) Probably not u32
    // added in v0015, only call if obseVersion >= 15
    // call during your Query or Load functions to get a PluginHandle uniquely identifying your plugin
    // invalid if called at any other time, so call it once and save the result
    getPluginHandle: *const fn () callconv(.C) u32,

    // TODO(Sirius902) Probably not u32
    // added v0018
    // CommandReturnType enum defined in CommandTable.h
    // does the same as RegisterCommand but includes return type; *required* for commands returning arrays
    registerTypedCommand: *const fn (info: *anyopaque, retn_type: u32) callconv(.C) bool,
    // returns a full path the the Oblivion directory
    getOblivionDirectory: *const fn () callconv(.C) [*:0]const u8,

    // added v0021
    // returns true if a plugin with the given name is loaded
    getPluginLoaded: *const fn (name: [*:0]const u8) callconv(.C) bool,
    // returns the version number of the plugin, or zero if it isn't loaded
    getPluginVersion: *const fn (name: [*:0]const u8) callconv(.C) u32,
};

pub const PluginInfo = extern struct {
    info_version: u32 = version_info,
    name: [*:0]const u8,
    version: u32,

    pub const version_info = @as(u32, 3); // incremented 0022. New method to CommandListInterface
};
