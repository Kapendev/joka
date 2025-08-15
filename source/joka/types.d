// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// ---

/// The `types` module provides basic type definitions and compile-time functions such as type checking.
module joka.types;

@safe nothrow @nogc:

alias Sz      = size_t;         /// The result of sizeof.
alias Pd      = ptrdiff_t;      /// The result of pointer math.

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

alias UnionType = ubyte;
alias AliasArgs(A...) = A;

/// A type representing error values.
// NOTE: Should cantParse be cannotParse? Who cares? We already write Rgba instead of RGBA for example.
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

/// A static array.
// It exists mainly because of weird BetterC stuff.
struct Array(T, Sz N) {
    align(T.alignof) ubyte[T.sizeof * N] data;

    enum length = N;
    enum capacity = N;

    pragma(inline, true) @trusted nothrow @nogc:

    mixin addSliceOps!(Array!(T, N), T);

    this(const(T)[] items...) {
        if (items.length > N) assert(0, "Too many items.");
        auto me = this.items;
        foreach (i; 0 .. N) me[i] = cast(T) items[i];
    }

    /// Returns the items of the array.
    T[] items() {
        return (cast(T*) data.ptr)[0 .. N];
    }

    /// Returns the pointer of the array.
    T* ptr() {
        return cast(T*) data.ptr;
    }
}

/// Represents a result of a function.
deprecated("Will be replaced with `Maybe`.")
alias Result(T) = Maybe!T;

/// Represents an optional value.
struct Maybe(T) {
    static if (isNumberType!T) {
        T value = 0;
    } else {
        T value;              /// The value.
    }
    Fault fault = Fault.some; /// The error code.

    pragma(inline, true) @safe nothrow @nogc:

    this(const(T) value) {
        opAssign(value);
    }

    this(Fault fault) {
        opAssign(fault);
    }

    this(const(T) value, Fault fault) {
        if (fault) this(fault);
        else this(value);
    }

    void opAssign(Maybe!T rhs) {
        value = rhs.value;
        fault = rhs.fault;
    }

    @trusted
    void opAssign(const(T) rhs) {
        value = cast(T) rhs;
        fault = Fault.none;
    }

    void opAssign(Fault rhs) {
        fault = rhs;
    }

    static Maybe!T some(T newValue) {
        return Maybe!T(newValue);
    }

    static Maybe!T none(Fault newFault = Fault.some) {
        return Maybe!T(newFault);
    }

    /// Returns the value and traps the error if it exists.
    ref T get(ref Fault trap) {
        trap = fault;
        return value;
    }

    /// Returns the value, or asserts if an error exists.
    ref T get() {
        if (fault) assert(0, "Fault was detected.");
        return value;
    }

    /// Returns the value. Returns a default value when there is an error.
    T getOr(T other) {
        return fault ? other : value;
    }

    /// Returns the value. Returns a default value when there is an error.
    T getOr() {
        return value;
    }

    /// Returns true when there is an error.
    bool isNone() {
        return fault != 0;
    }

    /// Returns true when there is a value.
    bool isSome() {
        return fault == 0;
    }
}

union UnionData(A...) {
    static assert(A.length != 0, "Arguments must contain at least one element.");

    static foreach (i, T; A) {
        static if (i == 0 && isNumberType!T) {
            mixin("T m", toCleanNumber!i, "= 0;");
        }  else {
            mixin("T m", toCleanNumber!i, ";");
        }
    }

    alias Types = A;
    alias Base = A[0];
}

struct Union(A...) {
    UnionData!A data;
    UnionType type;

    alias Types = A;
    alias Base = A[0];

    @trusted
    auto call(IStr func, AA...)(AA args) {
        switch (type) {
            static foreach (i, T; A) {
                static assert(hasMember!(T, func), funcImplementationErrorMessage!(T, func));
                mixin("case ", i, ": return data.m", toCleanNumber!i, ".", func, "(args);");
            }
            default: assert(0, "WTF!");
        }
    }

    @safe nothrow @nogc:

    static foreach (i, T; A) {
        pragma(inline, true)
        this(const(T) value) {
            opAssign(value);
        }

        pragma(inline, true) @trusted
        void opAssign(const(T) rhs) {
            auto temp = UnionData!A();
            *(cast(T*) &temp) = cast(T) rhs;
            data = temp;
            type = i;
        }
    }

    IStr typeName() {
        static foreach (i, T; A) {
            if (type == i) return T.stringof;
        }
        assert(0, "WTF!");
    }

    pragma(inline, true)
    bool isType(T)() {
        static assert(isInAliasArgs!(T, A), "Type `" ~ T.stringof ~ "` is not part of the variant.");
        return type == findInAliasArgs!(T, A);
    }

    pragma(inline, true) @trusted
    ref Base base() {
        return data.m0;
    }

    pragma(inline, true) @trusted
    ref T as(T)() {
        mixin("return data.m", findInAliasArgs!(T, A), ";");
    }

    ref T to(T)() {
        if (isType!T) {
            return as!T;
        } else {
            static foreach (i, TT; A) {
                if (i == type) {
                    assert(0, "Value is `" ~ A[i].stringof ~ "` and not `" ~ T.stringof ~ "`.");
                }
            }
            assert(0, "WTF!");
        }
    }

    deprecated("Will be replaced with `to`.")
    alias get = to;

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
pragma(inline, true)
Fault toFault(bool value, Fault other = Fault.some) {
    return value ? other : Fault.none;
}

T toUnion(T)(UnionType type) {
    static assert(isUnionType!T, "Type `" ~ T.stringof  ~ "` is not a variant.");

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

T toUnion(T)(IStr typeName) {
    static assert(isUnionType!T, "Type `" ~ T.stringof  ~ "` is not a variant.");

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

bool isUnionType(T)() {
    return is(T : Union!A, A...);
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

bool isFloatType(T)() {
    return is(T == float) ||
        is(T == const(float)) ||
        is(T == immutable(float));
}

bool isDoubleType(T)() {
    return is(T == double) ||
        is(T == const(double)) ||
        is(T == immutable(double));
}

bool isFloatingType(T)() {
    return isFloatType!T || isDoubleType!T;
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
        isNumberType!T ||
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
    return "Type `" ~ T.stringof ~ "` doesn't implement the `" ~ func ~ "` function.";
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

pragma(inline, true) @trusted
Sz offsetOf(T, IStr member)() {
    static assert(hasMember!(T, member), "Member doesn't exist.");
    T temp = void;
    return (cast(ubyte*) mixin("&temp.", member)) - (cast(ubyte*) &temp);
}

template toStaticArray(alias slice) {
    enum toStaticArray = cast(typeof(slice[0])[slice.length]) slice;
}

mixin template addSliceOps(T, TT) {
    static assert(hasMember!(T, "items"), "Slice must implement the `" ~ TT.stringof ~ "[] items()` function or have a member called that.");

    pragma(inline, true) @trusted nothrow @nogc {
        TT[] opSlice(Sz dim)(Sz i, Sz j) {
            return items[i .. j];
        }

        TT[] opIndex() {
            return items[];
        }

        TT[] opIndex(TT[] slice) {
            return slice;
        }

        ref TT opIndex(Sz i) {
            return items[i];
        }

        void opIndexAssign(const(TT) rhs, Sz i) {
            items[i] = cast(TT) rhs;
        }

        void opIndexOpAssign(const(char)[] op)(const(TT) rhs, Sz i) {
            mixin("items[i]", op, "= cast(TT) rhs;");
        }

        Sz opDollar(Sz dim)() {
            return items.length;
        }
    }
}

mixin template addXyzwOps(T, TT, Sz N, IStr form = "xyzw") {
    static assert(N >= 2 && N <= 4, "Vector must have a dimension between 2 and 4.");
    static assert(N == form.length, "Vector must have a dimension that is equal to the given form length.");
    static assert(hasMember!(T, "items"), "Vector must implement the `" ~ TT.stringof ~ "[] items()` function or have a member called that.");

    pragma(inline, true) @trusted nothrow @nogc {
        T opUnary(IStr op)() {
            static if (N == 2) {
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

        T opBinary(IStr op)(T rhs) {
            static if (N == 2) {
                return T(
                    cast(TT) mixin(form[0], op, "rhs.", form[0]),
                    cast(TT) mixin(form[1], op, "rhs.", form[1]),
                );
            } else static if (N == 3) {
                return T(
                    cast(TT) mixin(form[0], op, "rhs.", form[0]),
                    cast(TT) mixin(form[1], op, "rhs.", form[1]),
                    cast(TT) mixin(form[2], op, "rhs.", form[2]),
                );
            } else static if (N == 4) {
                return T(
                    cast(TT) mixin(form[0], op, "rhs.", form[0]),
                    cast(TT) mixin(form[1], op, "rhs.", form[1]),
                    cast(TT) mixin(form[2], op, "rhs.", form[2]),
                    cast(TT) mixin(form[3], op, "rhs.", form[3]),
                );
            }
        }

        void opOpAssign(IStr op)(T rhs) {
            static if (N == 2) {
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

        TT[] opSlice(Sz dim)(Sz i, Sz j) {
            return items[i .. j];
        }

        TT[] opIndex() {
            return items;
        }

        TT[] opIndex(TT[] slice) {
            return slice;
        }

        ref TT opIndex(Sz i) {
            return items[i];
        }

        void opIndexAssign(const(TT) rhs, Sz i) {
            items[i] = cast(TT) rhs;
        }

        void opIndexOpAssign(IStr op)(const(TT) rhs, Sz i) {
            mixin("items[i]", op, "= cast(TT) rhs;");
        }

        Sz opDollar(Sz dim)() {
            return N;
        }
    }

    @trusted nothrow @nogc {
        T _swizzle_n(G)(const(G)[] args...) {
            if (args.length != N) assert(0, "Wrong swizzle length.");
            T result;
            foreach (i, arg; args) result.items[i] = items[arg];
            return result;
        }

        T _swizzle_c(IStr args...) {
            if (args.length != N) assert(0, "Wrong swizzle length.");
            Sz[N] data = void;
            foreach (i, arg; args) {
                auto hasBadArg = true;
                foreach (j, c; form) if (c == arg) { data[i] = j; hasBadArg = false; break; }
                if (hasBadArg) assert(0, "Invalid swizzle component.");
            }
            return swizzle(data);
        }

        T swizzle(G)(const(G)[] args...) {
            static if (isCharType!G) {
                return _swizzle_c(args);
            } else {
                return _swizzle_n(args);
            }
        }
    }
}

// Function test.
unittest {
    alias Number = Union!(float, double);
    struct Foo { int x; byte y; byte z; int w; }

    assert(toFault(false) == Fault.none);
    assert(toFault(true) == Fault.some);
    assert(toFault(false, Fault.invalid) == Fault.none);
    assert(toFault(true, Fault.invalid) == Fault.invalid);

    assert(toUnion!Number(Number.typeOf!float).as!float == 0);
    assert(toUnion!Number(Number.typeOf!double).as!double == 0);
    assert(toUnion!Number(Number.typeNameOf!float).as!float == 0);
    assert(toUnion!Number(Number.typeNameOf!double).as!double == 0);

    assert(isInAliasArgs!(int, AliasArgs!(float)) == false);
    assert(isInAliasArgs!(int, AliasArgs!(float, int)) == true);

    assert(isArrayType!(int[3]) == true);
    assert(isArrayType!(typeof(toStaticArray!([1, 2, 3]))));

    assert(offsetOf!(Foo, "x") == 0);
    assert(offsetOf!(Foo, "y") == 4);
    assert(offsetOf!(Foo, "z") == 5);
    assert(offsetOf!(Foo, "w") == 8);
}

// Maybe test.
unittest {
    assert(Maybe!int().isNone == true);
    assert(Maybe!int().isSome == false);
    assert(Maybe!int().getOr() == 0);
    assert(Maybe!int(0).isNone == false);
    assert(Maybe!int(0).isSome == true);
    assert(Maybe!int(0).getOr() == 0);
    assert(Maybe!int(69).isNone == false);
    assert(Maybe!int(69).isSome == true);
    assert(Maybe!int(69).getOr() == 69);
    assert(Maybe!int(Fault.none).isNone == false);
    assert(Maybe!int(Fault.none).isSome == true);
    assert(Maybe!int(Fault.none).getOr() == 0);
    assert(Maybe!int(Fault.some).isNone == true);
    assert(Maybe!int(Fault.some).isSome == false);
    assert(Maybe!int(Fault.some).getOr() == 0);
    assert(Maybe!int(69, Fault.none).isNone == false);
    assert(Maybe!int(69, Fault.none).isSome == true);
    assert(Maybe!int(69, Fault.none).getOr() == 69);
    assert(Maybe!int(69, Fault.some).isNone == true);
    assert(Maybe!int(69, Fault.some).isSome == false);
    assert(Maybe!int(69, Fault.some).getOr() == 0);
}

// Variant test.
unittest {
    alias Number = Union!(float, double);

    assert(Number().typeName == "float");
    assert(Number().isType!float == true);
    assert(Number().isType!double == false);
    assert(Number().as!float == 0);
    assert(Number(0.0f).typeName == "float");
    assert(Number(0.0f).isType!float == true);
    assert(Number(0.0f).isType!double == false);
    assert(Number(0.0f).as!float == 0);
    assert(Number(0.0).isType!float == false);
    assert(Number(0.0).isType!double == true);
    assert(Number(0.0).typeName == "double");
    assert(Number(0.0).as!double == 0);
    assert(Number.typeOf!float == 0);
    assert(Number.typeOf!double == 1);
    assert(Number.typeNameOf!float == "float");
    assert(Number.typeNameOf!double == "double");

    auto number = Number();
    number = 0.0;
    assert(number.as!double == 0);
    number = 0.0f;
    assert(number.as!float == 0);
    number.as!float += 69.0f;
    assert(number.as!float == 69);

    auto numberPtr = &number.as!float();
    *numberPtr *= 10;
    assert(number.as!float == 690);
}
