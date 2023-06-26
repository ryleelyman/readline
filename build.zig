const std = @import("std");
const Build = std.Build;

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const readline = b.addStaticLibrary(.{
        .name = "readline",
        .target = target,
        .optimize = optimize,
    });
    readline.defineCMacro("READLINE_LIBRARY", "1");
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
    readline.installHeader("rlstdc.h", "readline/rlstdc.h");
    readline.installHeader("rltypedefs.h", "readline/rltypedefs.h");
    readline.installHeader("keymaps.h", "readline/keymaps.h");
    readline.installHeader("tilde.h", "readline/tilde.h");
    readline.installHeader("chardefs.h", "readline/chardefs.h");
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
