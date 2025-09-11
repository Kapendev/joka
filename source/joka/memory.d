// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// ---

/// The `memory` module provides functions for dealing with memory.
module joka.memory;

import joka.types;
import stdc = joka.stdc;

@system nothrow:

debug {
    version (D_BetterC) {
        enum _isTrackingMemory = false;
    } else {
        enum _isTrackingMemory = true;

        struct _MallocInfo {
            IStr file;
            Sz line;
            Sz size;
        }

        _MallocInfo[void*] _mallocInfoTable;
        _MallocInfo[] _mallocInvalidFreeTable;
    }
} else {
    enum _isTrackingMemory = false;
}

version (JokaCustomMemory) {
    pragma(msg, "Joka: Using custom allocator.");

    extern(C) void* jokaMalloc(Sz size);
    extern(C) void* jokaRealloc(void* ptr, Sz size);
    extern(C) @nogc void jokaFree(void* ptr);
} else version (JokaGcMemory) {
    pragma(msg, "Joka: Using GC allocator.");

    extern(C)
    void* jokaMalloc(Sz size) {
        auto result = cast(void*) new ubyte[](size).ptr;
        return result;
    }

    extern(C)
    void* jokaRealloc(void* ptr, Sz size) {
        auto result = jokaMalloc(size);
        if (ptr == null || result == null) return result;
        jokaMemcpy(result, ptr, size);
        return result;
    }

    extern(C) @nogc
    void jokaFree(void* ptr) {
        // Nothing to see here.
    }
} else {
    extern(C)
    void* jokaMalloc(Sz size, IStr file = __FILE__, Sz line = __LINE__) {
        auto result = stdc.malloc(size);
        static if (_isTrackingMemory) {
            if (result) _mallocInfoTable[result] = _MallocInfo(file, line, size);
        }
        return result;
    }

    extern(C)
    void* jokaRealloc(void* ptr, Sz size, IStr file = __FILE__, Sz line = __LINE__) {
        void* result;
        if (ptr) {
            static if (_isTrackingMemory) {
                if (auto info = ptr in _mallocInfoTable) {
                    result = stdc.realloc(ptr, size);
                    if (result) {
                        _mallocInfoTable.remove(ptr);
                        _mallocInfoTable[result] = _MallocInfo(file, line, size);
                    }
                } else {
                    _mallocInvalidFreeTable ~= _MallocInfo(file, line, size);
                }
            } else {
                result = stdc.realloc(ptr, size);
            }
        } else {
            result = jokaMalloc(size, file, line);
        }
        return result;
    }

    extern(C) @nogc
    void jokaFree(void* ptr, IStr file = __FILE__, Sz line = __LINE__) {
        if (ptr == null) return; // I know you don't need it, but might be nice for copy-pasting.
        static if (_isTrackingMemory) {
            if (auto info = ptr in _mallocInfoTable) {
                stdc.free(ptr);
                debug { _mallocInfoTable.remove(ptr); }
            } else {
                debug { _mallocInvalidFreeTable ~= _MallocInfo(file, line, 0); }
            }
        } else {
            stdc.free(ptr);
        }
    }
}

extern(C) @nogc
void* jokaMemset(void* ptr, int value, Sz size) {
    return stdc.memset(ptr, value, size);
}

extern(C) @nogc
void* jokaMemcpy(void* ptr, const(void)* source, Sz size) {
    return stdc.memcpy(ptr, source, size);
}

@trusted
T* jokaMakeBlank(T)(IStr file = __FILE__, Sz line = __LINE__) {
    return cast(T*) jokaMalloc(T.sizeof, file, line);
}

@trusted
T* jokaMake(T)(const(T) value = T.init, IStr file = __FILE__, Sz line = __LINE__) {
    auto result = jokaMakeBlank!T(file, line);
    *result = cast(T) value;
    return result;
}

@trusted
T[] jokaMakeSliceBlank(T)(Sz length, IStr file = __FILE__, Sz line = __LINE__) {
    return (cast(T*) jokaMalloc(T.sizeof * length, file, line))[0 .. length];
}

@trusted
T[] jokaMakeSlice(T)(Sz length, const(T) value = T.init, IStr file = __FILE__, Sz line = __LINE__) {
    auto result = jokaMakeSliceBlank!T(length, file, line);
    foreach (ref item; result) item = value;
    return result;
}
