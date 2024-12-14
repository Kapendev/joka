// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.13
// ---

/// The `faults` module provides data structures and codes for error handling.
module joka.faults;

import joka.ascii;
import joka.traits;

@safe @nogc nothrow:

enum Fault : ubyte {
    none,
    some,
    invalid,
    overflow,
    cantFind,
    cantOpen,
    cantClose,
    cantRead,
    cantWrite,
}

struct Result(T) {
    static if (isNumberType!T) {
        T value = 0;
    } else {
        T value;
    }
    Fault fault = Fault.some;

    @safe @nogc nothrow:

    this(T value) {
        this.value = value;
        this.fault = Fault.none;
    }

    this(Fault fault) {
        this.fault = fault;
    }

    this(T value, Fault fault) {
        if (fault) {
            this.fault = fault;
        } else {
            this.value = value;
            this.fault = Fault.none;
        }
    }

    pragma(inline, true)
    bool opCast(T: bool)() {
        return isSome;
    }

    T get() {
        if (fault) {
            assert(0, "Fault `{}` was detected.".format(fault));
        }
        return value;
    }

    T getOr(T other) {
        if (fault) {
            return other;
        } else {
            return value;
        }
    }

    T getOr() {
        return value;
    }

    bool isNone() {
        return fault != 0;
    }

    bool isSome() {
        return fault == 0;
    }
}

Fault toFault(bool value, Fault other = Fault.some) {
    return value ? other : Fault.none;
}

// Function test.
unittest {
    assert(toFault(false) == Fault.none);
    assert(toFault(true) == Fault.some);
    assert(toFault(false, Fault.invalid) == Fault.none);
    assert(toFault(true, Fault.invalid) == Fault.invalid);
}

// Result test.
unittest {
    assert(Result!int().isNone == true);
    assert(Result!int().isSome == false);
    assert(Result!int().getOr() == 0);
    assert(Result!int(0).isNone == false);
    assert(Result!int(0).isSome == true);
    assert(Result!int(0).getOr() == 0);
    assert(Result!int(69).isNone == false);
    assert(Result!int(69).isSome == true);
    assert(Result!int(69).getOr() == 69);
    assert(Result!int(Fault.none).isNone == false);
    assert(Result!int(Fault.none).isSome == true);
    assert(Result!int(Fault.none).getOr() == 0);
    assert(Result!int(Fault.some).isNone == true);
    assert(Result!int(Fault.some).isSome == false);
    assert(Result!int(Fault.some).getOr() == 0);
    assert(Result!int(69, Fault.none).isNone == false);
    assert(Result!int(69, Fault.none).isSome == true);
    assert(Result!int(69, Fault.none).getOr() == 69);
    assert(Result!int(69, Fault.some).isNone == true);
    assert(Result!int(69, Fault.some).isSome == false);
    assert(Result!int(69, Fault.some).getOr() == 0);
}
