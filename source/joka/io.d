// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.24
// ---

/// The `io` module provides input and output functions such as file reading.
module joka.io;

import joka.ascii;
import joka.containers;
import joka.types;
import stdc = joka.stdc.stdio;

@trusted
void printf(A...)(IStr text, A args) {
    stdc.fputs(fmt("{}\0", fmt(text, args)).ptr, stdc.stdout);
}

@trusted
void printfln(A...)(IStr text, A args) {
    printf(text, args);
    printf("\n");
}

@safe
void print(A...)(A args) {
    static foreach (arg; args) {
        printf("{}", arg);
    }
}

@safe
void println(A...)(A args) {
    print(args);
    print("\n");
}

@safe @nogc nothrow:

@trusted
Fault readTextIntoBuffer(IStr path, ref LStr buffer) {
    auto file = stdc.fopen(toCStr(path).getOr(), "r+b");
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

    buffer.resize(fileSize);
    stdc.fread(buffer.items.ptr, fileSize, 1, file);
    if (stdc.fclose(file) != 0) {
        return Fault.cantClose;
    }
    return Fault.none;
}

Result!LStr readText(IStr path) {
    LStr value;
    auto fault = readTextIntoBuffer(path, value);
    return Result!LStr(value, fault);
}

@trusted
Fault writeText(IStr path, IStr text) {
    auto file = stdc.fopen(toCStr(path).getOr(), "w");
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
