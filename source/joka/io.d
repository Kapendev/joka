// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// ---

/// The `io` module provides input and output functions such as file reading.
module joka.io;

import joka.ascii;
import joka.containers;
import joka.types;
import joka.memory;
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
    static if (is(A[0] == Sep)) {
        foreach (i, arg; args[1 .. $]) {
            if (i) printf("{}", args[0].value);
            printf("{}", arg);
        }
    } else {
        foreach (arg; args) printf("{}", arg);
    }
}

@safe
void println(A...)(A args) {
    print(args);
    print("\n");
}

@safe
void printMemoryTrackingInfo(IStr filter = "", bool canShowEmpty = false) {
    print(memoryTrackingInfo(filter, canShowEmpty));
}

// Why not.
alias echo  = println;
alias echon = print;

@safe
void tracef(IStr file = __FILE__, Sz line = __LINE__, A...)(IStr text, A args) {
    printf("TRACE({}:{}): {}\n", file, line, text.fmt(args));
}

@safe
void trace(IStr file = __FILE__, Sz line = __LINE__, A...)(A args) {
    printf("TRACE({}:{}):", file, line);
    foreach (arg; args) printf(" {}", arg);
    printf("\n");
}

@safe
void warn(IStr text = "Not implemented.", IStr file = __FILE__, Sz line = __LINE__) {
    printf("WARN({}:{}): {}\n", file, line, text);
}

@safe
noreturn todo(IStr text = "Not implemented.", IStr file = __FILE__, Sz line = __LINE__) {
    assert(0, "TODO({}:{}): {}".fmt(file, line, text));
}

@safe nothrow:

// NOTE: Also maybe think about errno lol.
@trusted
Fault readTextIntoBuffer(L = LStr)(IStr path, ref L listBuffer) {
    auto file = stdc.fopen(toCStr(path).getOr(), "r");
    if (file == null) return Fault.cantOpen;

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

    static if (L.hasFixedCapacity) {
        if (listBuffer.capacity < fileSize) {
            if (stdc.fclose(file) != 0) return Fault.cantClose;
            return Fault.overflow;
        }
    }
    listBuffer.resizeBlank(fileSize);
    stdc.fread(listBuffer.items.ptr, fileSize, 1, file);
    if (stdc.fclose(file) != 0) return Fault.cantClose;
    return Fault.none;
}

Maybe!LStr readText(IStr path) {
    LStr value;
    auto fault = readTextIntoBuffer(path, value);
    return Maybe!LStr(value, fault);
}

// NOTE: Also maybe think about errno lol.
@trusted @nogc
Fault writeText(IStr path, IStr text) {
    auto file = stdc.fopen(toCStr(path).getOr(), "w");
    if (file == null) return Fault.cantOpen;
    stdc.fwrite(text.ptr, char.sizeof, text.length, file);
    if (stdc.fclose(file) != 0) return Fault.cantClose;
    return Fault.none;
}

// Function test.
unittest {
    assert(readText("").isSome == false);
    assert(writeText("", "") != Fault.none);
}
