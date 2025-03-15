// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.21
// ---

/// The `stdc` module provides access to the C standard library.
module joka.stdc;

@nogc nothrow extern(C):

// [types]

version (WebAssembly) {
    alias CLong = int;
    alias CULong = uint;
} else {
    alias CLong = long;
    alias CULong = ulong;
}

// [string.h]

int memcmp(const(void)* lhs, const(void)* rhs, size_t count);
void* memset(void* dest, int ch, size_t count);
void* memcpy(void* dest, const(void)* src, size_t count);

// [math.h]

int abs(int x);
long labs(long x);

float fabsf(float x);
double fabs(double x);

float fmodf(float x, float y);
double fmod(double x, double y);

float remainderf(float x, float y);
double remainder(double x, double y);

float expf(float x);
double exp(double x);

float exp2f(float x);
double exp2(double x);

float expm1f(float x);
double expm1(double x);

float logf(float x);
double log(double x);

float log10f(float x);
double log10(double x);

float log2f(float x);
double log2(double x);

float log1pf(float x);
double log1p(double x);

float powf(float base, float exponent);
double pow(double base, double exponent);

float sqrtf(float x);
double sqrt(double x);

float cbrtf(float x);
double cbrt(double x);

float hypotf(float x, float y);
double hypot(double x, double y);

float sinf(float x);
double sin(double x);

float cosf(float x);
double cos(double x);

float tanf(float x);
double tan(double x);

float asinf(float x);
double asin(double x);

float acosf(float x);
double acos(double x);

float atanf(float x);
double atan(double x);

float atan2f(float y, float x);
double atan2(double y, double x);

float ceilf(float x);
double ceil(double x);

float floorf(float x);
double floor(double x);

float roundf(float x);
double round(double x);

// [stdlib.h]

void* malloc(size_t size);
void* realloc(void* ptr, size_t size);
void free(void* ptr);
void abort();
void exit(int code);
char* getenv(const(char)* name);
int system(const(char)* command);

// [stdio.h]

alias FILE = void;

enum SEEK_SET = 0;
enum SEEK_CUR = 1;
enum SEEK_END = 2;

enum STDIN_FILENO  = 0;
enum STDOUT_FILENO = 1;
enum STDERR_FILENO = 2;

// NOTE: Code from the D standard library.
version (CRuntime_Microsoft) {
    FILE* __acrt_iob_func(int hnd);     // VS2015+, reimplemented in msvc.d for VS2013-
    FILE* stdin()() { return __acrt_iob_func(0); }
    FILE* stdout()() { return __acrt_iob_func(1); }
    FILE* stderr()() { return __acrt_iob_func(2); }
} else version (CRuntime_Glibc) {
    extern __gshared FILE* stdin;
    extern __gshared FILE* stdout;
    extern __gshared FILE* stderr;
} else version (Darwin) {
    extern __gshared FILE* __stdinp;
    extern __gshared FILE* __stdoutp;
    extern __gshared FILE* __stderrp;
    alias __stdinp  stdin;
    alias __stdoutp stdout;
    alias __stderrp stderr;
} else version (FreeBSD) {
    extern __gshared FILE* __stdinp;
    extern __gshared FILE* __stdoutp;
    extern __gshared FILE* __stderrp;
    alias __stdinp  stdin;
    alias __stdoutp stdout;
    alias __stderrp stderr;
} else version (NetBSD) {
    extern __gshared FILE[3] __sF;
    auto __stdin()() { return &__sF[0]; }
    auto __stdout()() { return &__sF[1]; }
    auto __stderr()() { return &__sF[2]; }
    alias __stdin stdin;
    alias __stdout stdout;
    alias __stderr stderr;
} else version (OpenBSD) {
    extern __gshared FILE[3] __sF;
    auto __stdin()() { return &__sF[0]; }
    auto __stdout()() { return &__sF[1]; }
    auto __stderr()() { return &__sF[2]; }
    alias __stdin stdin;
    alias __stdout stdout;
    alias __stderr stderr;
} else version (DragonFlyBSD) {
    extern __gshared FILE* __stdinp;
    extern __gshared FILE* __stdoutp;
    extern __gshared FILE* __stderrp;
    alias __stdinp  stdin;
    alias __stdoutp stdout;
    alias __stderrp stderr;
} else version (Solaris) {
    extern __gshared FILE[_NFILE] __iob;
    auto stdin()() { return &__iob[0]; }
    auto stdout()() { return &__iob[1]; }
    auto stderr()() { return &__iob[2]; }
} else version (CRuntime_Bionic) {
    extern __gshared FILE[3] __sF;
    auto stdin()() { return &__sF[0]; }
    auto stdout()() { return &__sF[1]; }
    auto stderr()() { return &__sF[2]; }
} else version (CRuntime_Musl) {
    extern __gshared FILE* stdin;
    extern __gshared FILE* stdout;
    extern __gshared FILE* stderr;
} else version (CRuntime_Newlib) {
    __gshared struct _reent {
        int _errno;
        __sFILE* _stdin;
        __sFILE* _stdout;
        __sFILE* _stderr;
    }
    _reent* __getreent();
    pragma(inline, true) {
        auto stdin()() { return __getreent()._stdin; }
        auto stdout()() { return __getreent()._stdout; }
        auto stderr()() { return __getreent()._stderr; }
    }
} else version (CRuntime_UClibc) {
    extern __gshared FILE* stdin;
    extern __gshared FILE* stdout;
    extern __gshared FILE* stderr;
} else version (WASI) {
    extern __gshared FILE* stdin;
    extern __gshared FILE* stdout;
    extern __gshared FILE* stderr;
} else {
    extern __gshared FILE* stdin;
    extern __gshared FILE* stdout;
    extern __gshared FILE* stderr;
}

FILE* fopen(const(char)* filename, const(char)* mode);
CLong ftell(FILE* stream);
int fseek(FILE* stream, CLong offset, int origin);
size_t fread(void* ptr, size_t size, size_t count, FILE* stream);
int fclose(FILE* stream);
int fputs(const(char)* str, FILE* stream);
size_t fwrite(const(void)* buffer, size_t size, size_t count, FILE* stream);
