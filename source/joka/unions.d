// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.20
// ---

/// The `unions` module provides data structures and functions for working with unions.
module joka.unions;

import joka.types;
import joka.traits;

@safe @nogc nothrow:

alias VariantType = ubyte;

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

// Function test.
unittest {
    alias Number = Variant!(float, double);

    assert(toVariant!Number(Number.typeOf!float).get!float() == 0);
    assert(toVariant!Number(Number.typeOf!double).get!double() == 0);
    assert(toVariant!Number(Number.typeNameOf!float).get!float() == 0);
    assert(toVariant!Number(Number.typeNameOf!double).get!double() == 0);
}
