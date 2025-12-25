const std = @import("std");
const c = @import("c.zig").c;
const OBSEInterface = @import("obse.zig").OBSEInterface;
const PluginInfo = @import("obse.zig").PluginInfo;

pub fn DllMain(
    module: std.os.windows.HINSTANCE,
    reason: u32,
    reserved: *anyopaque,
) callconv(.winapi) c_int {
    _ = module;
    _ = reason;
    _ = reserved;

    return 1;
}

const name = "original-apprentice";
const version: u32 = 1;

pub export fn OBSEPlugin_Query(obse: *const OBSEInterface, info: *PluginInfo) bool {
    _ = obse;

    info.info_version = PluginInfo.version_info;
    info.name = name;
    info.version = version;

    return true;
}

pub export fn OBSEPlugin_Load(obse: *const OBSEInterface) bool {
    // TODO(Sirius902) We only need this if we register commands.
    // obse.setOpcodeBase(0x2B00);
    _ = obse;

    writeRelJump(0x6A2899, @intFromPtr(&magicResistHook));

    return true;
}

fn safeWrite(address: usize, data: anytype) void {
    var old_protect: u32 = undefined;

    const dst: *anyopaque = @ptrFromInt(address);
    _ = c.VirtualProtect(dst, @sizeOf(@TypeOf(data)), c.PAGE_EXECUTE_READWRITE, &old_protect);
    @memcpy(@as([*]u8, @ptrCast(dst)), std.mem.asBytes(&data));
    _ = c.VirtualProtect(dst, @sizeOf(@TypeOf(data)), old_protect, &old_protect);
}

fn writeRelJump(src: usize, target: usize) void {
    comptime {
        if (@sizeOf(usize) != @sizeOf(u32)) {
            @compileError("Only x86 is supported.");
        }
    }

    safeWrite(src, @as(u8, 0xE9));
    safeWrite(src + 1, @as(usize, target - src - 1 - 4));
}

const magic_resist_no_apply: usize = 0x6A2933;
const magic_resist_apply: usize = 0x6A2903;

fn magicResistHook() callconv(.naked) noreturn {
    asm volatile (
        \\movl (%esi), %eax
        \\movl 0x18(%eax), %edx
        \\mov %esi, %ecx
        \\call *%edx
        \\cmpl $4, %eax
        \\jz no_apply_jmp
        \\cmpb $0, 0x17(%esp)
        \\jnz no_apply_jmp
        \\jmp *%[apply]
        \\no_apply_jmp: jmp *%[no_apply]
        :
        : [no_apply] "p" (&magic_resist_no_apply),
          [apply] "p" (&magic_resist_apply),
    );
}
