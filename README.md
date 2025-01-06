# Original Apprentice

An
[OBSE](https://github.com/llde/xOBSE)
Plugin to restore the original behavior of the
[Weakness to Magic effect](https://en.uesp.net/wiki/Oblivion:Weakness_to_Magic)
prior to the
[Official Oblivion Patch](https://en.uesp.net/wiki/Oblivion:Patch)
version 1.1.511.

## Installing

Place `original-apprentice.dll` in the `Data/OBSE/Plugins` subdirectory of your
Oblivion installation.

## Building

* Install [Zig](https://ziglang.org/) version 0.13.0.
* Run `zig build -Doptimize=ReleaseSafe` in the project directory.
* The OBSE plugin can now be found at `zig-out/bin/original-apprentice.dll`.
