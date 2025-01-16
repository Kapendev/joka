// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.17
// ---

/// The `faults` module provides data structures and codes for error handling.
module joka.faults;

import joka.ascii;
import joka.traits;

@safe @nogc nothrow:

/// A type representing error values.
enum Fault : ubyte {
    none,      /// Not an error.
    some,      /// A generic error.
    invalid,   /// An invalid value error.
    overflow,  /// An overflow error.
    cantFind,  /// A wrong path error.
    cantOpen,  /// An open permissions error.
    cantClose, /// A close permissions error.
    cantRead,  /// A read permissions error.
    cantWrite, /// A write permissions error.
}

/// Represents a result of a procedure.
struct Result(T) {
    static if (isNumberType!T) {
        T value = 0;
    } else {
        T value;              /// The value of the result.
    }
    Fault fault = Fault.some; /// The error code of the result.

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

    /// Returns the result value. Asserts when the result is an error.
    T get() {
        if (fault) {
            assert(0, "Fault `{}` was detected.".format(fault));
        }
        return value;
    }

    /// Returns the result value. Returns a default value when the result is an error.
    T getOr(T other) {
        if (fault) {
            return other;
        } else {
            return value;
        }
    }

    /// Returns the result value. Returns a default value when the result is an error.
    T getOr() {
        return value;
    }

    /// Returns true when the result is an error.
    bool isNone() {
        return fault != 0;
    }

    /// Returns true when the result is a value.
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
