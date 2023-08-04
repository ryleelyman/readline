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
    readline.addIncludePath(.{ .path = ".." });
    readline.addIncludePath(.{ .path = "." });
    readline.addCSourceFiles(&readline_sources, &.{
        "-DHAVE_CONFIG_H",
        "-DRL_LIBRARY_VERSION=\"8.2\"",
        "-DBRACKETED_PASTE_DEFAULT=1",
    });
    readline.linkLibC();
    readline.linkSystemLibrary("ncurses");
    const t = readline.target_info.target;
    const config_h = switch (t.os.tag) {
        .macos => b.addConfigHeader(.{
            .style = .{ .autoconf = .{ .path = "config.h.in" } },
            .include_path = "config.h",
        }, macos_config_h_vals),
        else => b.addConfigHeader(.{
            .style = .{ .autoconf = .{ .path = "config.h.in" } },
            .include_path = "config.h",
        }, linux_config_h_vals),
    };
    readline.addConfigHeader(config_h);
    readline.installConfigHeader(config_h, .{});
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

const linux_config_h_vals = .{
    .__EXTENSIONS__ = 1,
    ._ALL_SOURCE = 1,
    ._GNU_SOURCE = 1,
    ._POSIX_SOURCE = 0,
    ._POSIX_1_SOURCE = 0,
    ._POSIX_PTHREAD_SEMANTICS = 1,
    ._TANDEM_SOURCE = 1,
    ._MINIX = 0,
    .NO_MULTIBYTE_SUPPORT = 1,
    ._FILE_OFFSET_BITS = 0,
    .PROTOTYPES = 1,
    .__PROTOTYPES = 1,
    .__CHAR_UNSIGNED__ = 1,
    .STAT_MACROS_BROKEN = 0,
    .HAVE_CHOWN = 1,
    .HAVE_FCNTL = 1,
    .HAVE_FNMATCH = 1,
    .HAVE_GETPWENT = 1,
    .HAVE_GETPWNAM = 1,
    .HAVE_GETPWUID = 1,
    .HAVE_GETTIMEOFDAY = 1,
    .HAVE_ISASCII = 1,
    .HAVE_ISWCTYPE = 1,
    .HAVE_ISWLOWER = 1,
    .HAVE_ISWUPPER = 1,
    .HAVE_ISXDIGIT = 1,
    .HAVE_KILL = 1,
    .HAVE_LSTAT = 1,
    .HAVE_MBRLEN = 1,
    .HAVE_MBRTOWC = 1,
    .HAVE_MBSRTOWCS = 1,
    .HAVE_MEMMOVE = 1,
    .HAVE_PSELECT = 1,
    .HAVE_PUTENV = 1,
    .HAVE_READLINK = 1,
    .HAVE_SELECT = 1,
    .HAVE_SETENV = 0,
    .HAVE_SETITIMER = 1,
    .HAVE_SETLOCALE = 1,
    .HAVE_STRCASECMP = 1,
    .STRCOLL_BROKEN = 0,
    .HAVE_STRCOLL = 1,
    .HAVE_STRPBRK = 1,
    .HAVE_SYSCONF = 0,
    .HAVE_TCGETATTR = 1,
    .HAVE_TOWLOWER = 1,
    .HAVE_TOWUPPER = 1,
    .HAVE_VSNPRINTF = 1,
    .HAVE_WCRTOMB = 1,
    .HAVE_WCSCOLL = 1,
    .HAVE_WCTYPE = 1,
    .HAVE_WCWIDTH = 1,
    .WCWIDTH_BROKEN = 0,
    .HAVE_DIRENT_H = 1,
    .HAVE_FCNTL_H = 1,
    .HAVE_LANGINFO_H = 1,
    .HAVE_LIBAUDIT_H = 1,
    .HAVE_LIMITS_H = 1,
    .HAVE_LOCALE_H = 1,
    .HAVE_MEMORY_H = 1,
    .HAVE_NDIR_H = 0,
    .HAVE_NCURSES_TERMCAP_H = 1,
    .HAVE_PWD_H = 1,
    .HAVE_STDARG_H = 1,
    .HAVE_STDBOOL_H = 1,
    .HAVE_STDLIB_H = 1,
    .HAVE_STRING_H = 1,
    .HAVE_STRINGS_H = 1,
    .HAVE_SYS_DIR_H = 0,
    .HAVE_SYS_FILE_H = 1,
    .HAVE_SYS_IOCTL_H = 1,
    .HAVE_SYS_NDIR_H = 0,
    .HAVE_SYS_PTE_H = 0,
    .HAVE_SYS_PTEM_H = 0,
    .HAVE_SYS_SELECT_H = 1,
    .HAVE_SYS_STREAM_H = 0,
    .HAVE_SYS_TIME_H = 1,
    .HAVE_TERMCAP_H = 0,
    .HAVE_TERMIO_H = 1,
    .HAVE_TERMIOS_H = 1,
    .HAVE_UNISTD_H = 1,
    .HAVE_VARARGS_H = 0,
    .HAVE_WCHAR_H = 1,
    .HAVE_WCTYPE_H = 1,
    .HAVE_MBSTATE_T = 1,
    .HAVE_WCHAR_T = 1,
    .HAVE_WCTYPE_T = 1,
    .HAVE_WINT_T = 1,
    .HAVE_LANGINFO_CODESET = 1,
    .HAVE_DECL_AUDIT_USER_TTY = 1,
    .GWINSZ_IN_SYS_IOCTL = 1,
    .STRUCT_WINSIZE_IN_SYS_IOCTL = 1,
    .STRUCT_WINSIZE_IN_TERMIOS = 0,
    .TIOCSTAT_IN_SYS_IOCTL = 0,
    .FIONREAD_IN_SYS_IOCTL = 1,
    .SPEED_T_IN_SYS_TYPES = 0,
    .HAVE_GETPW_DECLS = 1,
    .HAVE_STRUCT_DIRENT_D_INO = 1,
    .HAVE_STRUCT_DIRENT_D_FILENO = 1,
    .HAVE_STRUCT_DIRENT_D_NAMLEN = 0,
    .HAVE_TIMEVAL = 1,
    .HAVE_BSD_SIGNALS = 0,
    .HAVE_POSIX_SIGNALS = 1,
    .HAVE_USG_SIGHOLD = 0,
    .MUST_REINSTALL_SIGHANDLERS = 0,
    .HAVE_POSIX_SIGSETJMP = 1,
    .CTYPE_NON_ASCII = 0,
};

const macos_config_h_vals = .{
    .__EXTENSIONS__ = 1,
    ._ALL_SOURCE = 1,
    ._GNU_SOURCE = 1,
    ._POSIX_SOURCE = 0,
    ._POSIX_1_SOURCE = 0,
    ._POSIX_PTHREAD_SEMANTICS = 1,
    ._TANDEM_SOURCE = 1,
    ._MINIX = 0,
    .NO_MULTIBYTE_SUPPORT = 0,
    ._FILE_OFFSET_BITS = 0,
    .PROTOTYPES = 1,
    .__PROTOTYPES = 1,
    .__CHAR_UNSIGNED__ = 0,
    .STAT_MACROS_BROKEN = 0,
    .HAVE_CHOWN = 1,
    .HAVE_FCNTL = 1,
    .HAVE_FNMATCH = 1,
    .HAVE_GETPWENT = 1,
    .HAVE_GETPWNAM = 1,
    .HAVE_GETPWUID = 1,
    .HAVE_GETTIMEOFDAY = 1,
    .HAVE_ISASCII = 1,
    .HAVE_ISWCTYPE = 1,
    .HAVE_ISWLOWER = 1,
    .HAVE_ISWUPPER = 1,
    .HAVE_ISXDIGIT = 1,
    .HAVE_KILL = 1,
    .HAVE_LSTAT = 1,
    .HAVE_MBRLEN = 1,
    .HAVE_MBRTOWC = 1,
    .HAVE_MBSRTOWCS = 1,
    .HAVE_MEMMOVE = 1,
    .HAVE_PSELECT = 1,
    .HAVE_PUTENV = 1,
    .HAVE_READLINK = 1,
    .HAVE_SELECT = 1,
    .HAVE_SETENV = 0,
    .HAVE_SETITIMER = 1,
    .HAVE_SETLOCALE = 1,
    .HAVE_STRCASECMP = 1,
    .STRCOLL_BROKEN = 0,
    .HAVE_STRCOLL = 1,
    .HAVE_STRPBRK = 1,
    .HAVE_SYSCONF = 0,
    .HAVE_TCGETATTR = 1,
    .HAVE_TOWLOWER = 1,
    .HAVE_TOWUPPER = 1,
    .HAVE_VSNPRINTF = 1,
    .HAVE_WCRTOMB = 1,
    .HAVE_WCSCOLL = 1,
    .HAVE_WCTYPE = 1,
    .HAVE_WCWIDTH = 1,
    .WCWIDTH_BROKEN = 0,
    .HAVE_DIRENT_H = 1,
    .HAVE_FCNTL_H = 1,
    .HAVE_LANGINFO_H = 1,
    .HAVE_LIBAUDIT_H = 0,
    .HAVE_LIMITS_H = 1,
    .HAVE_LOCALE_H = 1,
    .HAVE_MEMORY_H = 1,
    .HAVE_NDIR_H = 0,
    .HAVE_NCURSES_TERMCAP_H = 0,
    .HAVE_PWD_H = 1,
    .HAVE_STDARG_H = 1,
    .HAVE_STDBOOL_H = 1,
    .HAVE_STDLIB_H = 1,
    .HAVE_STRING_H = 1,
    .HAVE_STRINGS_H = 1,
    .HAVE_SYS_DIR_H = 0,
    .HAVE_SYS_FILE_H = 1,
    .HAVE_SYS_IOCTL_H = 1,
    .HAVE_SYS_NDIR_H = 0,
    .HAVE_SYS_PTE_H = 0,
    .HAVE_SYS_PTEM_H = 0,
    .HAVE_SYS_SELECT_H = 1,
    .HAVE_SYS_STREAM_H = 0,
    .HAVE_SYS_TIME_H = 1,
    .HAVE_TERMCAP_H = 1,
    .HAVE_TERMIO_H = 0,
    .HAVE_TERMIOS_H = 1,
    .HAVE_UNISTD_H = 1,
    .HAVE_VARARGS_H = 0,
    .HAVE_WCHAR_H = 1,
    .HAVE_WCTYPE_H = 1,
    .HAVE_MBSTATE_T = 1,
    .HAVE_WCHAR_T = 1,
    .HAVE_WCTYPE_T = 1,
    .HAVE_WINT_T = 1,
    .HAVE_LANGINFO_CODESET = 1,
    .HAVE_DECL_AUDIT_USER_TTY = 0,
    .GWINSZ_IN_SYS_IOCTL = 0,
    .STRUCT_WINSIZE_IN_SYS_IOCTL = 1,
    .STRUCT_WINSIZE_IN_TERMIOS = 0,
    .TIOCSTAT_IN_SYS_IOCTL = 1,
    .FIONREAD_IN_SYS_IOCTL = 1,
    .SPEED_T_IN_SYS_TYPES = 0,
    .HAVE_GETPW_DECLS = 1,
    .HAVE_STRUCT_DIRENT_D_INO = 1,
    .HAVE_STRUCT_DIRENT_D_FILENO = 1,
    .HAVE_STRUCT_DIRENT_D_NAMLEN = 0,
    .HAVE_TIMEVAL = 1,
    .HAVE_BSD_SIGNALS = 0,
    .HAVE_POSIX_SIGNALS = 1,
    .HAVE_USG_SIGHOLD = 0,
    .MUST_REINSTALL_SIGHANDLERS = 0,
    .HAVE_POSIX_SIGSETJMP = 1,
    .CTYPE_NON_ASCII = 0,
};
