const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .os_tag = .windows,
            .cpu_arch = .x86,
        },
    });
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("original_apprentice", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const plugin = b.addLibrary(.{
        .name = "original-apprentice",
        .root_module = mod,
        .linkage = .dynamic,
    });

    b.installArtifact(plugin);

    const plugin_unit_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_plugin_unit_tests = b.addRunArtifact(plugin_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_plugin_unit_tests.step);
}
