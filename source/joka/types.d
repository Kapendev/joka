// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.20
// ---

/// The `types` module provides basic type definitions and compile-time functions such as type checking.
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

alias AliasArgs(A...) = A;
alias VariantType = ubyte;

/// A type representing error values.
enum Fault : ubyte {
    none,      /// Not an error.
    some,      /// A generic error.
    bug,       /// An implementation error.
    invalid,   /// An invalid data error.
    overflow,  /// An overflow error.
    assertion, /// An assertion error.
    cantParse, /// A parse error.
    cantFind,  /// A wrong path error.
    cantOpen,  /// An open permissions error.
    cantClose, /// A close permissions error.
    cantRead,  /// A read permissions error.
    cantWrite, /// A write permissions error.
}

/// Represents a result of a procedure.
struct Result(T) {
    static if (isNumberType!T) T value = 0;
    else T value;             /// The value of the result.
    Fault fault = Fault.some; /// The error of the result.

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

    /// Returns the result value. Asserts when the result is an error.
    T get() {
        if (fault) assert(0, "Fault was detected.");
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

union VariantValue(A...) {
    static assert(A.length != 0, "Arguments must contain at least one element.");

    static foreach (i, T; A) {
        static if (i == 0 && isNumberType!T) {
            mixin("T m", toCleanNumber!i, "= 0;");
        }  else {
            mixin("T m", toCleanNumber!i, ";");
        }
    }

    alias Types = A;
}

struct Variant(A...) {
    VariantValue!A value;
    VariantType type;

    alias Types = A;

    @safe @nogc nothrow:

    static foreach (i, T; A) {
        @trusted
        this(T value) {
            auto temp = VariantValue!A();
            *(cast(T*) &temp) = value;
            this.value = temp;
            this.type = i;
        }
    }

    static foreach (i, T; A) {
        @trusted
        void opAssign(T rhs) {
            auto temp = VariantValue!A();
            *(cast(T*) &temp) = rhs;
            value = temp;
            type = i;
        }
    }

    IStr typeName() {
        static foreach (i, T; A) {
            if (type == i) {
                return T.stringof;
            }
        }
        assert(0, "WTF!");
    }

    bool isType(T)() {
        static assert(isInAliasArgs!(T, A), "Type `" ~ T.stringof ~ "` is not part of the variant.");
        return type == findInAliasArgs!(T, A);
    }

    @trusted
    ref T get(T)() {
        if (isType!T) {
            mixin("return value.m", findInAliasArgs!(T, A), ";");
        } else {
            static foreach (i, TT; A) {
                if (i == type) {
                    assert(0, "Value is `" ~ A[i].stringof ~ "` and not `" ~ T.stringof ~ "`.");
                }
            }
            assert(0, "WTF!");
        }
    }

    @trusted
    auto call(IStr func, AA...)(AA args) {
        switch (type) {
            static foreach (i, T; A) {
                static assert(hasMember!(T, func), funcImplementationErrorMessage!(T, func));
                mixin("case ", i, ": return value.m", toCleanNumber!i, ".", func, "(args);");
            }
            default: assert(0, "WTF!");
        }
    }

    template typeOf(T) {
        static assert(isInAliasArgs!(T, A), "Type `" ~ T.stringof ~ "` is not part of the variant.");
        enum typeOf = findInAliasArgs!(T, A);
    }

    template typeNameOf(T) {
        static assert(isInAliasArgs!(T, A), "Type `" ~ T.stringof ~ "` is not part of the variant.");
        enum typeNameOf = T.stringof;
    }
}

/// Converts the value to a fault.
Fault toFault(bool value, Fault other = Fault.some) {
    return value ? other : Fault.none;
}

T toVariant(T)(VariantType type) {
    static assert(isVariantType!T, "Type `" ~ T.stringof  ~ "` is not a variant.");

    T result;
    static foreach (i, Type; T.Types) {
        if (i == type) {
            static if (isNumberType!Type) {
                result = cast(Type) 0;
            } else {
                result = Type.init;
            }
            goto loopExit;
        }
    }
    loopExit:
    return result;
}

T toVariant(T)(IStr typeName) {
    static assert(isVariantType!T, "Type `" ~ T.stringof  ~ "` is not a variant.");

    T result;
    static foreach (i, Type; T.Types) {
        if (Type.stringof == typeName) {
            static if (isNumberType!Type) {
                result = cast(Type) 0;
            } else {
                result = Type.init;
            }
            goto loopExit;
        }
    }
    loopExit:
    return result;
}

bool isVariantType(T)() {
    return is(T : Variant!A, A...);
}

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
}

// Function test.
unittest {
    alias Number = Variant!(float, double);

    assert(toFault(false) == Fault.none);
    assert(toFault(true) == Fault.some);
    assert(toFault(false, Fault.invalid) == Fault.none);
    assert(toFault(true, Fault.invalid) == Fault.invalid);

    assert(isInAliasArgs!(int, AliasArgs!(float)) == false);
    assert(isInAliasArgs!(int, AliasArgs!(float, int)) == true);
    assert(isArrayType!(int[3]) == true);
    assert(isArrayType!(typeof(toStaticArray!([1, 2, 3]))));

    assert(toVariant!Number(Number.typeOf!float).get!float() == 0);
    assert(toVariant!Number(Number.typeOf!double).get!double() == 0);
    assert(toVariant!Number(Number.typeNameOf!float).get!float() == 0);
    assert(toVariant!Number(Number.typeNameOf!double).get!double() == 0);
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

// Variant test.
unittest {
    alias Number = Variant!(float, double);

    assert(Number().typeName == "float");
    assert(Number().isType!float == true);
    assert(Number().isType!double == false);
    assert(Number().get!float() == 0);
    assert(Number(0.0f).typeName == "float");
    assert(Number(0.0f).isType!float == true);
    assert(Number(0.0f).isType!double == false);
    assert(Number(0.0f).get!float() == 0);
    assert(Number(0.0).isType!float == false);
    assert(Number(0.0).isType!double == true);
    assert(Number(0.0).typeName == "double");
    assert(Number(0.0).get!double() == 0);
    assert(Number.typeOf!float == 0);
    assert(Number.typeOf!double == 1);
    assert(Number.typeNameOf!float == "float");
    assert(Number.typeNameOf!double == "double");

    auto number = Number();
    number = 0.0;
    assert(number.get!double() == 0);
    number = 0.0f;
    assert(number.get!float() == 0);
    number.get!float() += 69.0f;
    assert(number.get!float() == 69);

    auto numberPtr = &number.get!float();
    *numberPtr *= 10;
    assert(number.get!float() == 690);
}
