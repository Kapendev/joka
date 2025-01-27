// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.19
// ---

/// The `traits` module provides compile-time functions such as type checking.
module joka.traits;

import joka.types;

@safe @nogc nothrow:

alias AliasArgs(A...) = A;

bool isBoolType(T)() {
    return is(T == bool) ||
        is(T == const(bool)) ||
        is(T == immutable(bool));
}

bool isUnsignedType(T)() {
    return is(T == ubyte) ||
        is(T == const(ubyte)) ||
        is(T == immutable(ubyte)) ||
        is(T == ushort) ||
        is(T == const(ushort)) ||
        is(T == immutable(ushort)) ||
        is(T == uint) ||
        is(T == const(uint)) ||
        is(T == immutable(uint)) ||
        is(T == ulong) ||
        is(T == const(ulong)) ||
        is(T == immutable(ulong));
}

bool isSignedType(T)() {
    return is(T == byte) ||
        is(T == const(byte)) ||
        is(T == immutable(byte)) ||
        is(T == short) ||
        is(T == const(short)) ||
        is(T == immutable(short)) ||
        is(T == int) ||
        is(T == const(int)) ||
        is(T == immutable(int)) ||
        is(T == long) ||
        is(T == const(long)) ||
        is(T == immutable(long));
}

bool isIntegerType(T)() {
    return isUnsignedType!T || isSignedType!T;
}

bool isFloatingType(T)() {
    return is(T == float) ||
        is(T == const(float)) ||
        is(T == immutable(float)) ||
        is(T == double) ||
        is(T == const(double)) ||
        is(T == immutable(double));
}

bool isNumberType(T)() {
    return isIntegerType!T || isFloatingType!T;
}

bool isCharType(T)() {
    return is(T == char) ||
        is(T == const(char)) ||
        is(T == immutable(char));
}

bool isPrimaryType(T)() {
    return isBoolType!T ||
        isUnsignedType!T ||
        isSignedType!T ||
        isDoubleType!T ||
        isCharType!T;
}

bool isArrayType(T)() {
    return is(T : const(A)[N], A, Sz N);
}

bool isPtrType(T)() {
    return is(T : const(void)*);
}

bool isSliceType(T)() {
    return is(T : const(A)[], A);
}

bool isEnumType(T)() {
    return is(T == enum);
}

bool isStructType(T)() {
    return is(T == struct);
}

bool isStrType(T)() {
    return is(T : IStr);
}

bool isCStrType(T)() {
    return is(T : ICStr);
}

bool hasMember(T, IStr name)() {
    return __traits(hasMember, T, name);
}

int findInAliasArgs(T, A...)() {
    int result = -1;
    static foreach (i, TT; A) {
        static if (is(T == TT)) {
            result = i;
        }
    }
    return result;
}

bool isInAliasArgs(T, A...)() {
    return findInAliasArgs!(T, A) != -1;
}

IStr funcImplementationErrorMessage(T, IStr func)() {
    return "Type `" ~ T.stringof ~ "` does not implement the `" ~ func ~ "` function.";
}

IStr toCleanNumber(alias i)() {
    enum str = i.stringof;
    static if (str.length >= 3 && (((str[$ - 1] == 'L' || str[$ - 1] == 'l') && (str[$ - 2] == 'U' || str[$ - 2] == 'u')) || ((str[$ - 1] == 'U' || str[$ - 1] == 'u') && (str[$ - 2] == 'L' || str[$ - 2] == 'l')))) {
        return str[0 .. $ - 2];
    } else static if (str.length >= 2 && (str[$ - 1] == 'U' || str[$ - 1] == 'u')) {
        return str[0 .. $ - 1];
    } else static if (str.length >= 2 && (str[$ - 1] == 'L' || str[$ - 1] == 'l')) {
        return str[0 .. $ - 1];
    } else {
        return str;
    }
}

template toStaticArray(alias slice) {
    auto toStaticArray = cast(typeof(slice[0])[slice.length]) slice;
}

mixin template addXyzwOps(T, Sz N, IStr form = "xyzw") {
    static assert(N >= 1 && N <= 4, "Vector `" ~ T.stringof ~ "`  must have a dimension between 1 and 4.");

    pragma(inline, true)
    T opUnary(IStr op)() {
        static if (N == 1) {
            return T(
                mixin(op, form[0]),
            );
        } else static if (N == 2) {
            return T(
                mixin(op, form[0]),
                mixin(op, form[1]),
            );
        } else static if (N == 3) {
            return T(
                mixin(op, form[0]),
                mixin(op, form[1]),
                mixin(op, form[2]),
            );
        } else static if (N == 4) {
            return T(
                mixin(op, form[0]),
                mixin(op, form[1]),
                mixin(op, form[2]),
                mixin(op, form[3]),
            );
        }
    }

    pragma(inline, true)
    T opBinary(IStr op)(T rhs) {
        static if (N == 1) {
            return T(
                mixin(form[0], op, "rhs.", form[0]),
            );
        } else static if (N == 2) {
            return T(
                mixin(form[0], op, "rhs.", form[0]),
                mixin(form[1], op, "rhs.", form[1]),
            );
        } else static if (N == 3) {
            return T(
                mixin(form[0], op, "rhs.", form[0]),
                mixin(form[1], op, "rhs.", form[1]),
                mixin(form[2], op, "rhs.", form[2]),
            );
        } else static if (N == 4) {
            return T(
                mixin(form[0], op, "rhs.", form[0]),
                mixin(form[1], op, "rhs.", form[1]),
                mixin(form[2], op, "rhs.", form[2]),
                mixin(form[3], op, "rhs.", form[3]),
            );
        }
    }

    pragma(inline, true)
    void opOpAssign(IStr op)(T rhs) {
        static if (N == 1) {
            mixin("x", op, "=rhs.x;");
            mixin(form[0], op, "=rhs.", form[0], ";");
        } else static if (N == 2) {
            mixin(form[0], op, "=rhs.", form[0], ";");
            mixin(form[1], op, "=rhs.", form[1], ";");
        } else static if (N == 3) {
            mixin(form[0], op, "=rhs.", form[0], ";");
            mixin(form[1], op, "=rhs.", form[1], ";");
            mixin(form[2], op, "=rhs.", form[2], ";");
        } else static if (N == 4) {
            mixin(form[0], op, "=rhs.", form[0], ";");
            mixin(form[1], op, "=rhs.", form[1], ";");
            mixin(form[2], op, "=rhs.", form[2], ";");
            mixin(form[3], op, "=rhs.", form[3], ";");
        }
    }

    pragma(inline, true)
    bool opCast(T: bool)() {
        static if (N == 1) {
            return mixin(form[0], "!= 0");
        } else static if (N == 2) {
            return mixin(form[0], "!= 0 ||", form[1], "!= 0");
        } else static if (N == 3) {
            return mixin(form[0], "!= 0 ||", form[1], "!= 0 ||", form[2], "!= 0");
        } else static if (N == 4) {
            return mixin(form[0], "!= 0 ||", form[1], "!= 0 ||", form[2], "!= 0 ||", form[3], "!= 0");
        }
    }
}

// Function test.
unittest {
    assert(isInAliasArgs!(int, AliasArgs!(float)) == false);
    assert(isInAliasArgs!(int, AliasArgs!(float, int)) == true);
    assert(isArrayType!(int[3]) == true);
    assert(isArrayType!(typeof(toStaticArray!([1, 2, 3]))));
}
