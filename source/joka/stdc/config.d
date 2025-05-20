// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.24
// ---

module joka.stdc.config;

@nogc nothrow extern(C):

version (WebAssembly) {
    alias CLong = int;
    alias CULong = uint;
} else {
    alias CLong = long;
    alias CULong = ulong;
}
