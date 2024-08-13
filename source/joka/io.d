// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.3
// ---

/// The `io` module provides input and output functions such as file reading.
module joka.io;

import joka.ascii;
import joka.traits;
import joka.types;
import stdc = joka.stdc;
public import joka.containers;
public import joka.faults;

@safe @nogc nothrow:

@trusted
void printf(A...)(IStr text, A args) {
    stdc.fputs(format("{}\0", format(text, args)).ptr, stdc.stdout);
}

@trusted
void printfln(A...)(IStr text, A args) {
    stdc.fputs(format("{}\n\0", format(text, args)).ptr, stdc.stdout);
}

void print(A...)(A args) {
    static foreach (arg; args) {
        printf("{}", arg);
    }
}

void println(A...)(A args) {
    static foreach (arg; args) {
        printf("{}", arg);
    }
    printf("\n");
}

@trusted
Fault readTextIntoBuffer(IStr path, ref LStr text) {
    auto file = stdc.fopen(toCStr(path).unwrapOr(), "rb");
    if (file == null) {
        return Fault.cantOpen;
    }
    if (stdc.fseek(file, 0, stdc.SEEK_END) != 0) {
        stdc.fclose(file);
        return Fault.cantRead;
    }

    auto fileSize = stdc.ftell(file);
    if (fileSize == -1) {
        stdc.fclose(file);
        return Fault.cantRead;
    }
    if (stdc.fseek(file, 0, stdc.SEEK_SET) != 0) {
        stdc.fclose(file);
        return Fault.cantRead;
    }

    text.resize(fileSize);
    stdc.fread(text.items.ptr, fileSize, 1, file);
    if (stdc.fclose(file) != 0) {
        return Fault.cantClose;
    }
    return Fault.none;
}

Result!LStr readText(IStr path) {
    LStr value;
    return Result!LStr(value, readTextIntoBuffer(path, value));
}

@trusted
Fault writeText(IStr path, IStr text) {
    auto file = stdc.fopen(toCStr(path).unwrapOr(), "w");
    if (file == null) {
        return Fault.cantOpen;
    }
    stdc.fwrite(text.ptr, char.sizeof, text.length, file);
    if (stdc.fclose(file) != 0) {
        return Fault.cantClose;
    }
    return Fault.none;
}

// Function test.
unittest {
    assert(readText("").isSome == false);
    assert(writeText("", "") != Fault.none);
}
