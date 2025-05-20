// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.24
// ---

/// The `memory` module provides functions for dealing with memory.
module joka.memory;

import joka.types;

@nogc nothrow extern(C) {
    version(JokaCustomMemory) {
        void* jokaMalloc(Sz size);
        void* jokaRealloc(void* ptr, Sz size);
        void jokaFree(void* ptr);
        void* jokaMemset(void* ptr, int value, Sz size);
        void* jokaMemcpy(void* ptr, const(void)* source, Sz size);
    } else {
        import stdc = joka.stdc;

        void* jokaMalloc(Sz size) {
            return stdc.malloc(size);
        }

        void* jokaRealloc(void* ptr, Sz size) {
            return stdc.realloc(ptr, size);
        }

        void jokaFree(void* ptr) {
            stdc.free(ptr);
        }

        void* jokaMemset(void* ptr, int value, Sz size) {
            return stdc.memset(ptr, value, size);
        }

        void* jokaMemcpy(void* ptr, const(void)* source, Sz size) {
            return stdc.memcpy(ptr, source, size);
        }
    }
}

@trusted @nogc nothrow:

T* jokaMakeBlank(T)() {
    return cast(T*) jokaMalloc(T.sizeof);
}

T* jokaMake(T)(const(T) value = T.init) {
    auto result = jokaMakeBlank!T();
    *result = cast(T) value;
    return result;
}

T[] jokaMakeSliceBlank(T)(Sz length) {
    return (cast(T*) jokaMalloc(T.sizeof * length))[0 .. length];
}

T[] jokaMakeSlice(T)(Sz length, const(T) value = T.init) {
    auto result = jokaMakeSliceBlank!T(length);
    foreach (ref item; result) item = value;
    return result;
}
