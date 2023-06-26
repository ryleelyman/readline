const std = @import("std");
const Build = std.Build;

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const configure = b.addSystemCommand(&.{"./configure"});
    const readline = b.addStaticLibrary(.{
        .name = "readline",
        .target = target,
        .optimize = optimize,
    });
    readline.step.dependOn(&configure.step);
    readline.addIncludePath("..");
    readline.addIncludePath(".");
    readline.addCSourceFiles(&readline_sources, &.{
        "-DHAVE_CONFIG_H",
        "-DRL_LIBRARY_VERSION=\"8.2\"",
        "-DBRACKETED_PASTE_DEFAULT=1",
    });
    readline.linkLibC();
    readline.linkSystemLibrary("ncurses");
    readline.use_llvm = true;
    b.installArtifact(readline);
    readline.installHeader("readline.h", "readline/readline.h");
    readline.installHeader("history.h", "readline/history.h");
}

const readline_sources = .{
    "readline.c",
    "vi_mode.c",
    "funmap.c",
    "keymaps.c",
    "parens.c",
    "search.c",
    "rltty.c",
    "complete.c",
    "bind.c",
    "isearch.c",
    "display.c",
    "signals.c",
    "util.c",
    "kill.c",
    "undo.c",
    "macro.c",
    "input.c",
    "callback.c",
    "terminal.c",
    "text.c",
    "nls.c",
    "misc.c",
    "history.c",
    "histexpand.c",
    "histfile.c",
    "shell.c",
    "mbutil.c",
    "tilde.c",
    "colors.c",
    "parse-colors.c",
    "xmalloc.c",
    "xfree.c",
    "compat.c",
    "emacs_keymap.c",
    "vi_keymap.c",
    "histsearch.c",
    "savestring.c",
};
