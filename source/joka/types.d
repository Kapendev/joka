// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.20
// ---

/// The `types` module provides a collection of type definitions.
module joka.types;

@safe @nogc nothrow:

alias Sz      = size_t;         /// The result of sizeof, ...

alias Str     = char[];         /// A string slice of chars.
alias Str16   = wchar[];        /// A string slice of wchars.
alias Str32   = dchar[];        /// A string slice of dchars.

alias IStr    = const(char)[];  /// A string slice of constant chars.
alias IStr16  = const(wchar)[]; /// A string slice of constant wchars.
alias IStr32  = const(dchar)[]; /// A string slice of constant dchars.

alias CStr    = char*;          /// A C string of chars.
alias CStr16  = wchar*;         /// A C string of wchars.
alias CStr32  = dchar*;         /// A C string of dchars.

alias ICStr   = const(char)*;   /// A C string of constant chars.
alias ICStr16 = const(wchar)*;  /// A C string of constant wchars.
alias ICStr32 = const(dchar)*;  /// A C string of constant dchars.

// A half float.
//struct Float16 {
//    ushort data;
//
//    alias toFloat this;
//
//    @safe @nogc nothrow:
//
//    this(float value) {
//        data = f16FloatToShort(value);
//    }
//
//    float toFloat() {
//        return f16ShortToFloat(data);
//    }
//}
//
//float f16ShortToFloat(ushort value) {
//    float result = 0.0f;
//    return result;
//}
//
//ushort f16FloatToShort(float value) {
//    ushort result = 0;
//    return result;
//}
//
//template f16(float value) {
//    enum f16 = Float16(value);
//}
//
// Function test.
//unittest {
//    assert(f16ShortToFloat(1) == 1);
//
//    assert(f16!0 == 0);
//    assert(f16!0.0 == 0.0);
//    assert(f16!0.0f == 0.0f);
//}
