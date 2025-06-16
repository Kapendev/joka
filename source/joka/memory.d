// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.28
// ---

/// The `memory` module provides functions for dealing with memory.
module joka.memory;

import joka.types;
import stdc = joka.stdc;

version (JokaCustomMemory) {
    @system nothrow @nogc:
    pragma(msg, "Joka: Using custom allocator.");

    extern(C) void* jokaMalloc(Sz size);
    extern(C) void* jokaRealloc(void* ptr, Sz size);
    extern(C) void jokaFree(void* ptr);
    extern(C) void* jokaMemset(void* ptr, int value, Sz size);
    extern(C) void* jokaMemcpy(void* ptr, const(void)* source, Sz size);

    @trusted
    T* jokaMakeBlank(T)() {
        return cast(T*) jokaMalloc(T.sizeof);
    }

    @trusted
    T* jokaMake(T)(const(T) value = T.init) {
        auto result = jokaMakeBlank!T();
        *result = cast(T) value;
        return result;
    }

    @trusted
    T[] jokaMakeSliceBlank(T)(Sz length) {
        return (cast(T*) jokaMalloc(T.sizeof * length))[0 .. length];
    }

    @trusted
    T[] jokaMakeSlice(T)(Sz length, const(T) value = T.init) {
        auto result = jokaMakeSliceBlank!T(length);
        foreach (ref item; result) item = value;
        return result;
    }
} else version (JokaGcMemory) {
    @system nothrow:
    pragma(msg, "Joka: Using GC allocator.");

    extern(C) void* jokaMalloc(Sz size) {
        return cast(void*) new ubyte[](size).ptr;
    }

    extern(C) void* jokaRealloc(void* ptr, Sz size) {
        auto result = jokaMalloc(size);
        if (ptr == null) return result;
        if (result == null) return null;
        jokaMemcpy(result, ptr, size);
        return result;
    }

    extern(C) @nogc void jokaFree(void* ptr) {
        // Nothing to see here.
    }

    extern(C) @nogc void* jokaMemset(void* ptr, int value, Sz size) {
        return stdc.memset(ptr, value, size);
    }

    extern(C) @nogc void* jokaMemcpy(void* ptr, const(void)* source, Sz size) {
        return stdc.memcpy(ptr, source, size);
    }

    @trusted
    T* jokaMakeBlank(T)() {
        return cast(T*) jokaMalloc(T.sizeof);
    }

    @trusted
    T* jokaMake(T)(const(T) value = T.init) {
        auto result = jokaMakeBlank!T();
        *result = cast(T) value;
        return result;
    }

    @trusted
    T[] jokaMakeSliceBlank(T)(Sz length) {
        return (cast(T*) jokaMalloc(T.sizeof * length))[0 .. length];
    }

    @trusted
    T[] jokaMakeSlice(T)(Sz length, const(T) value = T.init) {
        auto result = jokaMakeSliceBlank!T(length);
        foreach (ref item; result) item = value;
        return result;
    }
} else {
    @system nothrow @nogc:

    extern(C) void* jokaMalloc(Sz size) {
        return stdc.malloc(size);
    }

    extern(C) void* jokaRealloc(void* ptr, Sz size) {
        return stdc.realloc(ptr, size);
    }

    extern(C) void jokaFree(void* ptr) {
        stdc.free(ptr);
    }

    extern(C) void* jokaMemset(void* ptr, int value, Sz size) {
        return stdc.memset(ptr, value, size);
    }

    extern(C) void* jokaMemcpy(void* ptr, const(void)* source, Sz size) {
        return stdc.memcpy(ptr, source, size);
    }

    @trusted
    T* jokaMakeBlank(T)() {
        return cast(T*) jokaMalloc(T.sizeof);
    }

    @trusted
    T* jokaMake(T)(const(T) value = T.init) {
        auto result = jokaMakeBlank!T();
        *result = cast(T) value;
        return result;
    }

    @trusted
    T[] jokaMakeSliceBlank(T)(Sz length) {
        return (cast(T*) jokaMalloc(T.sizeof * length))[0 .. length];
    }

    @trusted
    T[] jokaMakeSlice(T)(Sz length, const(T) value = T.init) {
        auto result = jokaMakeSliceBlank!T(length);
        foreach (ref item; result) item = value;
        return result;
    }
}
