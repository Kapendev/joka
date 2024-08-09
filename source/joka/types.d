// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Version: v0.0.3
// Project: https://github.com/Kapendev/joka
// Email: alexandroskapretsos@gmail.com
// ---

/// The `types` module provides a collection of type definitions.
module joka.types;

@safe @nogc nothrow:

alias Sz      = size_t;

alias Str     = char[];
alias Str16   = wchar[];
alias Str32   = dchar[];

alias IStr    = const(char)[];
alias IStr16  = const(wchar)[];
alias IStr32  = const(dchar)[];

alias CStr    = char*;
alias CStr16  = wchar*;
alias CStr32  = dchar*;

alias ICStr   = const(char)*;
alias ICStr16 = const(wchar)*;
alias ICStr32 = const(dchar)*;
