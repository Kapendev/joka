// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.25
// ---

/// The `math` module provides mathematical data structures and functions.
module joka.math;

import joka.types;
import stdc = joka.stdc.math;

@safe @nogc nothrow:

enum epsilon = 0.000100;                              /// The value of epsilon.
enum euler   = 2.71828182845904523536028747135266249; /// The value of Euler's number.
enum log2e   = 1.44269504088896340735992468100189214; /// The value of log2(e).
enum log10e  = 0.43429448190325182765112891891660508; /// The value of log10(e).
enum ln2     = 0.69314718055994530941723212145817656; /// The value of ln(2).
enum ln10    = 2.30258509299404568401799145468436421; /// The value of ln(10).
enum pi      = 3.14159265358979323846264338327950288; /// The value of PI.
enum pi2     = pi / 2.0;                              /// The value of PI / 2.
enum pi4     = pi / 4.0;                              /// The value of PI / 4.
enum pi180   = pi / 180.0;                            /// The value of PI / 180.
enum dpi     = 1.0 / pi;                              /// The value of 1 / PI.
enum dpi2    = 2.0 / pi;                              /// The value of 2 / PI.
enum dpi180  = 180.0 / pi;                            /// The value of 180 / PI.
enum sqrt2   = 1.41421356237309504880168872420969808; /// The value of sqrt(2).
enum dsqrt2  = 0.70710678118654752440084436210484903; /// The value of 1 / sqrt(2).

enum blank   = Rgba();              /// Not a color.
enum black   = Rgba(0);             /// Black black.
enum white   = Rgba(255);           /// White white.
enum red     = Rgba(255, 0, 0);     /// Red red.
enum green   = Rgba(0, 255, 0);     /// Green green.
enum blue    = Rgba(0, 0, 255);     /// Blue blue.
enum yellow  = Rgba(255, 255, 0);   /// Yellow yellow.
enum magenta = Rgba(255, 0, 255);   /// Magenta magenta.
enum pink    = Rgba(255, 192, 204); /// Pink pink.
enum cyan    = Rgba(0, 255, 255);   /// Cyan cyan.
enum orange  = Rgba(255, 165, 0);   /// Orange orange.
enum beige   = Rgba(240, 235, 210); /// Beige beige.
enum brown   = Rgba(165, 72, 42);   /// Brown brown.
enum maroon  = Rgba(128, 0, 0);     /// Maroon maroon.
enum gray1   = Rgba(32, 32, 32);    /// Gray 1.
enum gray2   = Rgba(96, 96, 96);    /// Gray 22.
enum gray3   = Rgba(159, 159, 159); /// Gray 333.
enum gray4   = Rgba(223, 223, 223); /// Gray 4444.
enum gray    = gray2;               /// Gray gray.

alias Color = Rgba;

alias BVec2 = GVec2!byte;   /// A 2D vector using bytes.
alias IVec2 = GVec2!int;    /// A 2D vector using ints.
alias UVec2 = GVec2!uint;   /// A 2D vector using uints.
alias Vec2 = GVec2!float;   /// A 2D vector using floats.
alias DVec2 = GVec2!double; /// A 2D vector using doubles.

alias BVec3 = GVec3!byte;   /// A 3D vector using bytes.
alias IVec3 = GVec3!int;    /// A 3D vector using ints.
alias UVec3 = GVec3!uint;   /// A 3D vector using uints.
alias Vec3 = GVec3!float;   /// A 3D vector using floats.
alias DVec3 = GVec3!double; /// A 3D vector using doubles.

alias BVec4 = GVec4!byte;   /// A 4D vector using bytes.
alias IVec4 = GVec4!int;    /// A 4D vector using ints.
alias UVec4 = GVec4!uint;   /// A 4D vector using uints.
alias Vec4 = GVec4!float;   /// A 4D vector using floats.
alias DVec4 = GVec4!double; /// A 4D vector using doubles.

alias BRect = GRect!byte;   /// A 2D rectangle using bytes.
alias IRect = GRect!int;    /// A 2D rectangle using ints.
alias URect = GRect!uint;   /// A 2D rectangle using uints.
alias Rect = GRect!float;   /// A 2D rectangle using floats.
alias DRect = GRect!double; /// A 2D rectangle using doubles.

/// A type representing relative points.
enum Hook : ubyte {
    topLeft,     /// The top left point.
    top,         /// The top point.
    topRight,    /// The top right point.
    left,        /// The left point.
    center,      /// The center point.
    right,       /// The right point.
    bottomLeft,  /// The bottom left point.
    bottom,      /// The bottom point.
    bottomRight, /// The bottom right point.
}

/// A RGBA color using ubytes.
struct Rgba {
    ubyte r; /// The R component of the color.
    ubyte g; /// The G component of the color.
    ubyte b; /// The B component of the color.
    ubyte a; /// The A component of the color.

    enum length = 4;              /// The component count of the color.
    enum form = "rgba";           /// The form of the color.
    enum zero = Rgba(0, 0, 0, 0); /// The zero value of the color.
    enum one = Rgba(1, 1, 1, 1);  /// The one value of the color.

    @safe @nogc nothrow:

    mixin addXyzwOps!(Rgba, ubyte, length, form);

    pragma(inline, true)
    this(ubyte r, ubyte g, ubyte b, ubyte a = 255) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    pragma(inline, true)
    this(ubyte r) {
        this(r, r, r, 255);
    }

    pragma(inline, true)
    bool isZero() {
        return r == 0 && g == 0 && b == 0 && a == 0;
    }

    pragma(inline, true)
    bool isOne() {
        return r == 1 && g == 1 && b == 1 && a == 1;
    }

    @trusted
    ubyte[] items() {
        return (cast(ubyte*) &this)[0 .. length];
    }

    /// Returns a color with just the alpha modified.
    Rgba alpha(ubyte value) {
        return Rgba(r, g, b, value);
    }
}

/// A generic 2D vector.
struct GVec2(T) {
    T x = 0; /// The X component of the vector.
    T y = 0; /// The Y component of the vector.

    enum length = 2;        /// The component count of the vector.
    enum form = "xy";       /// The form of the vector.
    enum zero = GVec2!T(0); /// The zero value of the vector.
    enum one = GVec2!T(1);  /// The one value of the vector.

    static if (T.sizeof > float.sizeof) {
        enum is64 = true;
        alias Float = double;
    } else {
        enum is64 = false;
        alias Float = float;
    }

    @safe @nogc nothrow:

    mixin addXyzwOps!(GVec2!T, T, length, form);

    pragma(inline, true)
    this(T x, T y) {
        this.x = x;
        this.y = y;
    }

    pragma(inline, true)
    this(T x) {
        this(x, x);
    }

    T[] opSlice(Sz dim)(Sz i, Sz j) {
        return items[i .. j];
    }

    T[] opIndex() {
        return items;
    }

    // D calls this function when the slice operator is used. Does something but I do not remember what lol.
    T[] opIndex(T[] slice) {
        return slice;
    }

    // D will let you get the pointer of the array item if you return a ref value.
    ref T opIndex(Sz i) {
        return items[i];
    }

    @trusted
    void opIndexAssign(const(T) rhs, Sz i) {
        items[i] = cast(T) rhs;
    }

    @trusted
    void opIndexOpAssign(IStr op)(const(T) rhs, Sz i) {
        mixin("items[i]", op, "= cast(T) rhs;");
    }

    Sz opDollar(Sz dim)() {
        return items.length;
    }

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0;
    }

    pragma(inline, true)
    bool isOne() {
        return x == 1 && y == 1;
    }

    @trusted
    T[] items() {
        return (cast(T*) &this)[0 .. length];
    }

    pragma(inline, true)
    GVec2!T abs() {
        return GVec2!T(x.abs, y.abs);
    }

    pragma(inline, true)
    GVec2!T floor() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec2!T(x.floor64, y.floor64);
            } else {
                return GVec2!T(x.floor, y.floor);
            }
        }
    }

    pragma(inline, true)
    GVec2!T ceil() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec2!T(x.ceil64, y.ceil64);
            } else {
                return GVec2!T(x.ceil, y.ceil);
            }
        }
    }

    pragma(inline, true)
    GVec2!T round() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec2!T(x.round64, y.round64);
            } else {
                return GVec2!T(x.round, y.round);
            }
        }
    }

    pragma(inline, true)
    GVec2!Float sqrt() {
        static if (is64) {
            return GVec2!Float(x.sqrt64, y.sqrt64);
        } else {
            return GVec2!Float(x.sqrt, y.sqrt);
        }
    }

    pragma(inline, true)
    GVec2!Float sin() {
        static if (is64) {
            return GVec2!Float(x.sin64, y.sin64);
        } else {
            return GVec2!Float(x.sin, y.sin);
        }
    }

    pragma(inline, true)
    GVec2!Float cos() {
        static if (is64) {
            return GVec2!Float(x.cos64, y.cos64);
        } else {
            return GVec2!Float(x.cos, y.cos);
        }
    }

    pragma(inline, true)
    GVec2!Float tan() {
        static if (is64) {
            return GVec2!Float(x.tan64, y.tan64);
        } else {
            return GVec2!Float(x.tan, y.tan);
        }
    }

    pragma(inline, true)
    GVec2!Float asin() {
        static if (is64) {
            return GVec2!Float(x.asin64, y.asin64);
        } else {
            return GVec2!Float(x.asin, y.asin);
        }
    }

    pragma(inline, true)
    GVec2!Float acos() {
        static if (is64) {
            return GVec2!Float(x.acos64, y.acos64);
        } else {
            return GVec2!Float(x.acos, y.acos);
        }
    }

    pragma(inline, true)
    GVec2!Float atan() {
        static if (is64) {
            return GVec2!Float(x.atan64, y.atan64);
        } else {
            return GVec2!Float(x.atan, y.atan);
        }
    }

    pragma(inline, true)
    Float angle() {
        return atan2(y, x);
    }

    pragma(inline, true)
    Float magnitude() {
        static if (is64) {
            return (x * x + y * y).sqrt64;
        } else {
            return (x * x + y * y).sqrt;
        }
    }

    pragma(inline, true)
    Float magnitudeSquared() {
        return x * x + y * y;
    }

    GVec2!Float normalize() {
        static if (isIntegerType!T) {
            return GVec2!Float(cast(Float) x, cast(Float) y).normalize();
        } else {
            auto m = magnitude;
            if (m == 0) return GVec2!Float();
            return this / GVec2!Float(m);
        }
    }

    Float distanceTo(GVec2!T to) {
        return (to - this).magnitude;
    }

    GVec2!Float directionTo(GVec2!T to) {
        static if (isIntegerType!T) {
            return (to - this).normalize();
        } else {
            return (to - this).normalize();
        }
    }
}

/// A generic 3D vector.
struct GVec3(T) {
    T x = 0; /// The X component of the vector.
    T y = 0; /// The Y component of the vector.
    T z = 0; /// The Z component of the vector.

    enum length = 3;        /// The component count of the vector.
    enum form = "xyz";      /// The form of the vector.
    enum zero = GVec3!T(0); /// The zero value of the vector.
    enum one = GVec3!T(1);  /// The one value of the vector.

    static if (T.sizeof > float.sizeof) {
        enum is64 = true;
        alias Float = double;
    } else {
        enum is64 = false;
        alias Float = float;
    }

    @safe @nogc nothrow:

    mixin addXyzwOps!(GVec3!T, T, length, form);

    pragma(inline, true)
    this(T x, T y, T z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    pragma(inline, true)
    this(T x) {
        this(x, x, x);
    }

    pragma(inline, true)
    this(GVec2!T xy, T z) {
        this(xy.x, xy.y, z);
    }

    T[] opSlice(Sz dim)(Sz i, Sz j) {
        return items[i .. j];
    }

    T[] opIndex() {
        return items;
    }

    // D calls this function when the slice operator is used. Does something but I do not remember what lol.
    T[] opIndex(T[] slice) {
        return slice;
    }

    // D will let you get the pointer of the array item if you return a ref value.
    ref T opIndex(Sz i) {
        return items[i];
    }

    @trusted
    void opIndexAssign(const(T) rhs, Sz i) {
        items[i] = cast(T) rhs;
    }

    @trusted
    void opIndexOpAssign(IStr op)(const(T) rhs, Sz i) {
        mixin("items[i]", op, "= cast(T) rhs;");
    }

    Sz opDollar(Sz dim)() {
        return items.length;
    }

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0 && z == 0;
    }

    pragma(inline, true)
    bool isOne() {
        return x == 1 && y == 1 && z == 1;
    }

    @trusted
    T[] items() {
        return (cast(T*) &this)[0 .. length];
    }

    pragma(inline, true)
    GVec3!T abs() {
        return GVec3!T(x.abs, y.abs, z.abs);
    }

    pragma(inline, true)
    GVec3!T floor() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec3!T(x.floor64, y.floor64, z.floor64);
            } else {
                return GVec3!T(x.floor, y.floor, z.floor);
            }
        }
    }

    pragma(inline, true)
    GVec3!T ceil() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec3!T(x.ceil64, y.ceil64, z.ceil64);
            } else {
                return GVec3!T(x.ceil, y.ceil, z.ceil);
            }
        }
    }

    pragma(inline, true)
    GVec3!T round() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec3!T(x.round64, y.round64, z.round64);
            } else {
                return GVec3!T(x.round, y.round, z.round);
            }
        }
    }

    pragma(inline, true)
    GVec3!Float sqrt() {
        static if (is64) {
            return GVec3!Float(x.sqrt64, y.sqrt64, z.sqrt64);
        } else {
            return GVec3!Float(x.sqrt, y.sqrt, z.sqrt);
        }
    }

    pragma(inline, true)
    GVec3!Float sin() {
        static if (is64) {
            return GVec3!Float(x.sin64, y.sin64, z.sin64);
        } else {
            return GVec3!Float(x.sin, y.sin, z.sin);
        }
    }

    pragma(inline, true)
    GVec3!Float cos() {
        static if (is64) {
            return GVec3!Float(x.cos64, y.cos64, z.cos64);
        } else {
            return GVec3!Float(x.cos, y.cos, z.cos);
        }
    }

    pragma(inline, true)
    GVec3!Float tan() {
        static if (is64) {
            return GVec3!Float(x.tan64, y.tan64, z.tan64);
        } else {
            return GVec3!Float(x.tan, y.tan, z.tan);
        }
    }

    pragma(inline, true)
    GVec3!Float asin() {
        static if (is64) {
            return GVec3!Float(x.asin64, y.asin64, z.asin64);
        } else {
            return GVec3!Float(x.asin, y.asin, z.asin);
        }
    }

    pragma(inline, true)
    GVec3!Float acos() {
        static if (is64) {
            return GVec3!Float(x.acos64, y.acos64, z.acos64);
        } else {
            return GVec3!Float(x.acos, y.acos, z.acos);
        }
    }

    pragma(inline, true)
    GVec3!Float atan() {
        static if (is64) {
            return GVec3!Float(x.atan64, y.atan64, z.atan64);
        } else {
            return GVec3!Float(x.atan, y.atan, z.atan);
        }
    }

    pragma(inline, true)
    Float magnitude() {
        static if (is64) {
            return (x * x + y * y + z * z).sqrt64;
        } else {
            return (x * x + y * y + z * z).sqrt;
        }
    }

    pragma(inline, true)
    Float magnitudeSquared() {
        return x * x + y * y + z * z;
    }

    GVec3!Float normalize() {
        static if (isIntegerType!T) {
            return GVec3!Float(cast(Float) x, cast(Float) y, cast(Float) z).normalize();
        } else {
            auto m = magnitude;
            if (m == 0.0) return GVec3!Float();
            return this / GVec3!Float(m);
        }
    }

    Float distanceTo(GVec3!T to) {
        return (to - this).magnitude;
    }

    GVec3!Float directionTo(GVec3!T to) {
        return (to - this).normalize();
    }
}

/// A generic 4D vector.
struct GVec4(T) {
    T x = 0; /// The X component of the vector.
    T y = 0; /// The Y component of the vector.
    T z = 0; /// The Z component of the vector.
    T w = 0; /// The W component of the vector.

    enum length = 4;        /// The component count of the vector.
    enum form = "xyzw";     /// The form of the vector.
    enum zero = GVec4!T(0); /// The zero value of the vector.
    enum one = GVec4!T(1);  /// The one value of the vector.

    static if (T.sizeof > float.sizeof) {
        enum is64 = true;
        alias Float = double;
    } else {
        enum is64 = false;
        alias Float = float;
    }

    @safe @nogc nothrow:

    mixin addXyzwOps!(GVec4!T, T, length, form);

    pragma(inline, true)
    this(T x, T y, T z, T w) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    pragma(inline, true)
    this(T x) {
        this(x, x, x, x);
    }

    pragma(inline, true)
    this(GVec2!T xy, GVec2!T zw) {
        this(xy.x, xy.y, zw.x, zw.y);
    }

    pragma(inline, true)
    this(GVec3!T xyz, T w) {
        this(xyz.x, xyz.y, xyz.z, w);
    }

    T[] opSlice(Sz dim)(Sz i, Sz j) {
        return items[i .. j];
    }

    T[] opIndex() {
        return items;
    }

    // D calls this function when the slice operator is used. Does something but I do not remember what lol.
    T[] opIndex(T[] slice) {
        return slice;
    }

    // D will let you get the pointer of the array item if you return a ref value.
    ref T opIndex(Sz i) {
        return items[i];
    }

    @trusted
    void opIndexAssign(const(T) rhs, Sz i) {
        items[i] = cast(T) rhs;
    }

    @trusted
    void opIndexOpAssign(IStr op)(const(T) rhs, Sz i) {
        mixin("items[i]", op, "= cast(T) rhs;");
    }

    Sz opDollar(Sz dim)() {
        return items.length;
    }

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0 && z == 0 && w == 0;
    }

    pragma(inline, true)
    bool isOne() {
        return x == 1 && y == 1 && z == 1 && w == 1;
    }

    @trusted
    T[] items() {
        return (cast(T*) &this)[0 .. length];
    }

    pragma(inline, true)
    GVec4!T abs() {
        return GVec4!T(x.abs, y.abs, z.abs, w.abs);
    }

    pragma(inline, true)
    GVec4!T floor() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec4!T(x.floor64, y.floor64, z.floor64, w.floor64);
            } else {
                return GVec4!T(x.floor, y.floor, z.floor, w.floor);
            }
        }
    }

    pragma(inline, true)
    GVec4!T ceil() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec4!T(x.ceil64, y.ceil64, z.ceil64, w.ceil64);
            } else {
                return GVec4!T(x.ceil, y.ceil, z.ceil, w.ceil);
            }
        }
    }

    pragma(inline, true)
    GVec4!T round() {
        static if (isIntegerType!T) {
            return this;
        } else {
            static if (is64) {
                return GVec4!T(x.round64, y.round64, z.round64, w.round64);
            } else {
                return GVec4!T(x.round, y.round, z.round, w.round);
            }
        }
    }

    pragma(inline, true)
    GVec4!Float sqrt() {
        static if (is64) {
            return GVec4!Float(x.sqrt64, y.sqrt64, z.sqrt64, w.sqrt64);
        } else {
            return GVec4!Float(x.sqrt, y.sqrt, z.sqrt, w.sqrt);
        }
    }

    pragma(inline, true)
    GVec4!Float sin() {
        static if (is64) {
            return GVec4!Float(x.sin64, y.sin64, z.sin64, w.sin64);
        } else {
            return GVec4!Float(x.sin, y.sin, z.sin, w.sin);
        }
    }

    pragma(inline, true)
    GVec4!Float cos() {
        static if (is64) {
            return GVec4!Float(x.cos64, y.cos64, z.cos64, w.cos64);
        } else {
            return GVec4!Float(x.cos, y.cos, z.cos, w.cos);
        }
    }

    pragma(inline, true)
    GVec4!Float tan() {
        static if (is64) {
            return GVec4!Float(x.tan64, y.tan64, z.tan64, w.tan64);
        } else {
            return GVec4!Float(x.tan, y.tan, z.tan, w.tan);
        }
    }

    pragma(inline, true)
    GVec4!Float asin() {
        static if (is64) {
            return GVec4!Float(x.asin64, y.asin64, z.asin64, w.asin64);
        } else {
            return GVec4!Float(x.asin, y.asin, z.asin, w.asin);
        }
    }

    pragma(inline, true)
    GVec4!Float acos() {
        static if (is64) {
            return GVec4!Float(x.acos64, y.acos64, z.acos64, w.acos64);
        } else {
            return GVec4!Float(x.acos, y.acos, z.acos, w.acos);
        }
    }

    pragma(inline, true)
    GVec4!Float atan() {
        static if (is64) {
            return GVec4!Float(x.atan64, y.atan64, z.atan64, w.atan64);
        } else {
            return GVec4!Float(x.atan, y.atan, z.atan, w.atan);
        }
    }

    pragma(inline, true)
    Float magnitude() {
        static if (is64) {
            return (x * x + y * y + z * z + w * w).sqrt64;
        } else {
            return (x * x + y * y + z * z + w * w).sqrt;
        }
    }

    pragma(inline, true)
    Float magnitudeSquared() {
        return x * x + y * y + z * z + w * w;
    }

    GVec4!Float normalize() {
        static if (isIntegerType!T) {
            return GVec4!Float(cast(Float) x, cast(Float) y, cast(Float) z, cast(Float) w).normalize();
        } else {
            auto m = magnitude;
            if (m == 0.0) return GVec4!Float();
            return this / GVec4!Float(m);
        }
    }

    Float distanceTo(GVec4!T to) {
        return (to - this).magnitude;
    }

    GVec4!Float directionTo(GVec4!T to) {
        return (to - this).normalize();
    }
}

/// A generic 2D rectangle.
struct GRect(T) {
    GVec2!T position; /// The position of the rectangle.
    GVec2!T size;     /// The size of the rectangle.

    static if (T.sizeof > float.sizeof) {
        enum is64 = true;
        alias Float = double;
    } else {
        enum is64 = false;
        alias Float = float;
    }

    @safe @nogc nothrow:

    pragma(inline, true)
    this(GVec2!T position, GVec2!T size) {
        this.position = position;
        this.size = size;
    }

    pragma(inline, true)
    this(GVec2!T size) {
        this(GVec2!T(), size);
    }

    pragma(inline, true)
    this(T x, T y, T w, T h) {
        this(GVec2!T(x, y), GVec2!T(w, h));
    }

    pragma(inline, true)
    this(T w, T h) {
        this(GVec2!T(), GVec2!T(w, h));
    }

    pragma(inline, true)
    this(GVec2!T position, T w, T h) {
        this(position, GVec2!T(w, h));
    }

    pragma(inline, true)
    this(T x, T y, GVec2!T size) {
        this(GVec2!T(x, y), size);
    }

    /// The X position of the rectangle.
    pragma(inline, true)
    @trusted ref T x() => position.x;
    /// The Y position of the rectangle.
    pragma(inline, true)
    @trusted ref T y() => position.y;
    /// The width of the rectangle.
    pragma(inline, true)
    @trusted ref T w() => size.x;
    /// The height of the rectangle.
    pragma(inline, true)
    @trusted ref T h() => size.y;

    pragma(inline, true)
    GRect!T abs() {
        return GRect!T(position.abs, size.abs);
    }

    pragma(inline, true)
    GRect!T floor() {
        static if (isIntegerType!T) {
            return this;
        } else {
            return GRect!T(position.floor, size.floor);
        }
    }

    pragma(inline, true)
    GRect!T ceil() {
        static if (isIntegerType!T) {
            return this;
        } else {
            return GRect!T(position.ceil, size.ceil);
        }
    }

    pragma(inline, true)
    GRect!T round() {
        static if (isIntegerType!T) {
            return this;
        } else {
            return GRect!T(position.round, size.round);
        }
    }

    void fix() {
        if (size.x < 0) {
            position.x = cast(T) (position.x + size.x);
            size.x = cast(T) (-size.x);
        }
        if (size.y < 0) {
            position.y = cast(T) (position.y + size.y);
            size.y = cast(T) (-size.y);
        }
    }

    GVec2!T origin(Hook hook) {
        static if (isIntegerType!T) {
            auto temp = GRect!Float(cast(Float) position.x, cast(Float) position.y, cast(Float) size.x, cast(Float) size.y).origin(hook);
            return GVec2!T(cast(T) temp.x, cast(T) temp.y);
        } else {
            final switch (hook) {
                case Hook.topLeft: return GVec2!T();
                case Hook.top: return size * GVec2!T(0.5f, 0.0f);
                case Hook.topRight: return size * GVec2!T(1.0f, 0.0f);
                case Hook.left: return size * GVec2!T(0.0f, 0.5f);
                case Hook.center: return size * GVec2!T(0.5f, 0.5f);
                case Hook.right: return size * GVec2!T(1.0f, 0.5f);
                case Hook.bottomLeft: return size * GVec2!T(0.0f, 1.0f);
                case Hook.bottom: return size * GVec2!T(0.5f, 1.0f);
                case Hook.bottomRight: return size;
            }
        }
    }

    GRect!T area(Hook hook) {
        return GRect!T(
            position - origin(hook),
            size,
        );
    }

    GVec2!T point(Hook hook) {
        return position + origin(hook);
    }

    GVec2!T topLeftPoint() {
        return point(Hook.topLeft);
    }

    GVec2!T topPoint() {
        return point(Hook.top);
    }

    GVec2!T topRightPoint() {
        return point(Hook.topRight);
    }

    GVec2!T leftPoint() {
        return point(Hook.left);
    }

    GVec2!T centerPoint() {
        return point(Hook.center);
    }

    GVec2!T rightPoint() {
        return point(Hook.right);
    }

    GVec2!T bottomLeftPoint() {
        return point(Hook.bottomLeft);
    }

    GVec2!T bottomPoint() {
        return point(Hook.bottom);
    }

    GVec2!T bottomRightPoint() {
        return point(Hook.bottomRight);
    }

    GRect!T topLeftArea() {
        return area(Hook.topLeft);
    }

    GRect!T topArea() {
        return area(Hook.top);
    }

    GRect!T topRightArea() {
        return area(Hook.topRight);
    }

    GRect!T leftArea() {
        return area(Hook.left);
    }

    GRect!T centerArea() {
        return area(Hook.center);
    }

    GRect!T rightArea() {
        return area(Hook.right);
    }

    GRect!T bottomLeftArea() {
        return area(Hook.bottomLeft);
    }

    GRect!T bottomArea() {
        return area(Hook.bottom);
    }

    GRect!T bottomRightArea() {
        return area(Hook.bottomRight);
    }

    pragma(inline, true);
    bool hasPoint(GVec2!T point) {
        return (
            point.x > position.x &&
            point.x < position.x + size.x &&
            point.y > position.y &&
            point.y < position.y + size.y
        );
    }

    pragma(inline, true);
    bool hasPointInclusive(GVec2!T point) {
        return (
            point.x >= position.x &&
            point.x <= position.x + size.x &&
            point.y >= position.y &&
            point.y <= position.y + size.y
        );
    }

    pragma(inline, true);
    bool hasIntersection(GRect!T area) {
        return (
            position.x + size.x > area.position.x &&
            position.x < area.position.x + area.size.x &&
            position.y + size.y > area.position.y &&
            position.y < area.position.y + area.size.y
        );
    }

    pragma(inline, true);
    bool hasIntersectionInclusive(GRect!T area) {
        return (
            position.x + size.x >= area.position.x &&
            position.x <= area.position.x + area.size.x &&
            position.y + size.y >= area.position.y &&
            position.y <= area.position.y + area.size.y
        );
    }

    GRect!T intersection(GRect!T area) {
        if (!this.hasIntersection(area)) {
            return GRect!T();
        } else {
            auto maxY = max(position.x, area.position.x);
            auto maxX = max(position.y, area.position.y);
            return GRect!T(
                maxX,
                maxY,
                cast(T) (min(position.x + size.x, area.position.x + area.size.x) - maxX),
                cast(T) (min(position.y + size.y, area.position.y + area.size.y) - maxY),
            );
        }
    }

    GRect!T merger(GRect!T area) {
        auto minX = min(position.x, area.position.x);
        auto minY = min(position.y, area.position.y);
        return GRect!T(
            minX,
            minY,
            cast(T) (max(position.x + size.x, area.position.x + area.size.x) - minX),
            cast(T) (max(position.y + size.y, area.position.y + area.size.y) - minY),
        );
    }

    GRect!T addLeft(T amount) {
        position.x -= amount;
        size.x += amount;
        return GRect!T(position.x, position.y, amount, size.y);
    }

    GRect!T addRight(T amount) {
        auto w = size.x;
        size.x += amount;
        return GRect!T(w, position.y, amount, size.y);
    }

    GRect!T addTop(T amount) {
        position.y -= amount;
        size.y += amount;
        return GRect!T(position.x, position.y, size.x, amount);
    }

    GRect!T addBottom(T amount) {
        auto h = size.y;
        size.y += amount;
        return GRect!T(position.x, h, size.x, amount);
    }

    GRect!T subLeft(T amount) {
        auto x = position.x;
        position.x = cast(T) min(position.x + amount, position.x + size.x);
        size.x = cast(T) max(size.x - amount, 0);
        return GRect!T(x, position.y, amount, size.y);
    }

    GRect!T subRight(T amount) {
        size.x = cast(T) max(size.x - amount, 0);
        return GRect!T(cast(T) (position.x + size.x), position.y, amount, size.y);
    }

    GRect!T subTop(T amount) {
        auto y = position.y;
        position.y = cast(T) min(position.y + amount, position.y + size.y);
        size.y = cast(T) max(size.y - amount, 0);
        return GRect!T(position.x, y, size.x, amount);
    }

    GRect!T subBottom(T amount) {
        size.y = cast(T) max(size.y - amount, 0);
        return GRect!T(position.x, cast(T) (position.y + size.y), size.x, amount);
    }

    GRect!T addLeftRight(T amount) {
        this.addLeft(amount);
        this.addRight(amount);
        return this;
    }

    GRect!T addTopBottom(T amount) {
        this.addTop(amount);
        this.addBottom(amount);
        return this;
    }

    GRect!T addAll(T amount) {
        this.addLeftRight(amount);
        this.addTopBottom(amount);
        return this;
    }

    GRect!T subLeftRight(T amount) {
        this.subLeft(amount);
        this.subRight(amount);
        return this;
    }

    GRect!T subTopBottom(T amount) {
        this.subTop(amount);
        this.subBottom(amount);
        return this;
    }

    GRect!T subAll(T amount) {
        this.subLeftRight(amount);
        this.subTopBottom(amount);
        return this;
    }

    GRect!T left(T amount) {
        GRect!T temp = this;
        return temp.subLeft(amount);
    }

    GRect!T right(T amount) {
        GRect!T temp = this;
        return temp.subRight(amount);
    }

    GRect!T top(T amount) {
        GRect!T temp = this;
        return temp.subTop(amount);
    }

    GRect!T bottom(T amount) {
        GRect!T temp = this;
        return temp.subBottom(amount);
    }
}

/// A 2D Circle using floats.
struct Circ {
    Vec2 position;       /// The position of the circle.
    float radius = 0.0f; /// The radius of the circle.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(Vec2 position, float radius) {
        this.position = position;
        this.radius = radius;
    }

    pragma(inline, true)
    this(float x, float y, float radius) {
        this(Vec2(x, y), radius);
    }
}

/// A 2D Line using floats.
struct Line {
    Vec2 a; /// The start point of the line.
    Vec2 b; /// The end point of the line.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(Vec2 a, Vec2 b) {
        this.a = a;
        this.b = b;
    }

    pragma(inline, true)
    this(float ax, float ay, float bx, float by) {
        this(Vec2(ax, ay), Vec2(bx, by));
    }

    pragma(inline, true)
    this(Vec2 a, float bx, float by) {
        this(a, Vec2(bx, by));
    }

    pragma(inline, true)
    this(float ax, float ay, Vec2 b) {
        this(Vec2(ax, ay), b);
    }
}

pragma(inline, true)
T abs(T)(T x) {
    return cast(T) (x < 0 ? -x : x);
}

pragma(inline, true)
T min(T)(T a, T b) {
    return a < b ? a : b;
}

pragma(inline, true)
T min3(T)(T a, T b, T c) {
    return min(a, b).min(c);
}

pragma(inline, true)
T min4(T)(T a, T b, T c, T d) {
    return min(a, b).min(c).min(d);
}

pragma(inline, true)
T max(T)(T a, T b) {
    return a < b ? b : a;
}

pragma(inline, true)
T max3(T)(T a, T b, T c) {
    return max(a, b).max(c);
}

pragma(inline, true)
T max4(T)(T a, T b, T c, T d) {
    return max(a, b).max(c).max(d);
}

pragma(inline, true)
T sign(T)(T x) {
    return x < 0 ? -1 : 1;
}

pragma(inline, true)
T clamp(T)(T x, T a, T b) {
    return max(x, a).min(b);
}

T wrap(T)(T x, T a, T b) {
    auto result = x;
    auto range = cast(T) (b - a);
    static if (isUnsignedType!T) {
        result = cast(T) wrap!long(x, a, b);
    } else static if (isFloatingType!T) {
        result = fmod(x - a, range);
        if (result < 0) result += range;
        result += a;
    } else {
        result = cast(T) ((x - a) % range);
        if (result < 0) result += range;
        result += a;
    }
    return result;
}

// TODO: Look at this again because I feel it returns weird values sometimes.
T snap(T)(T x, T step) {
    static if (isIntegerType!T) {
        return cast(T) snap!double(cast(double) x, cast(double) step).round();
    } else {
        return (x / step).round() * step;
    }
}

@trusted
float fmod(float x, float y) {
    return stdc.fmodf(x, y);
}

@trusted
double fmod64(double x, double y) {
    return stdc.fmod(x, y);
}

@trusted
float remainder(float x, float y) {
    return stdc.remainderf(x, y);
}

@trusted
double remainder64(double x, double y) {
    return stdc.remainder(x, y);
}

@trusted
float exp(float x) {
    return stdc.expf(x);
}

@trusted
double exp64(double x) {
    return stdc.exp(x);
}

@trusted
float exp2(float x) {
    return stdc.exp2f(x);
}

@trusted
double exp264(double x) {
    return stdc.exp2(x);
}

@trusted
float expm1(float x) {
    return stdc.expm1f(x);
}

@trusted
double expm164(double x) {
    return stdc.expm1(x);
}

@trusted
float log(float x) {
    return stdc.logf(x);
}

@trusted
double log64(double x) {
    return stdc.log(x);
}

@trusted
float log10(float x) {
    return stdc.log10f(x);
}

@trusted
double log1064(double x) {
    return stdc.log10(x);
}

@trusted
float log2(float x) {
    return stdc.log2f(x);
}

@trusted
double log264(double x) {
    return stdc.log2(x);
}

@trusted
float log1p(float x) {
    return stdc.log1pf(x);
}

@trusted
double log1p64(double x) {
    return stdc.log1p(x);
}

@trusted
float pow(float base, float exponent) {
    return stdc.powf(base, exponent);
}

@trusted
double pow64(double base, double exponent) {
    return stdc.pow(base, exponent);
}

@trusted
float atan2(float y, float x) {
    return stdc.atan2f(y, x);
}

@trusted
double atan264(double y, double x) {
    return stdc.atan2(y, x);
}

pragma(inline, true)
@trusted
float cbrt(float x) {
    return stdc.cbrtf(x);
}

pragma(inline, true)
@trusted
double cbrt64(double x) {
    return stdc.cbrt(x);
}

pragma(inline, true)
float floorX(float x) {
    return (x <= 0.0f && (cast(float) cast(int) x) != x)
        ? (cast(float) cast(int) x) - 1.0f
        : (cast(float) cast(int) x);
}

pragma(inline, true)
double floorX64(double x) {
    return (x <= 0.0 && (cast(double) cast(long) x) != x)
        ? (cast(double) cast(long) x) - 1.0
        : (cast(double) cast(long) x);
}

pragma(inline, true)
@trusted
float floor(float x) {
    return stdc.floorf(x);
}

pragma(inline, true)
@trusted
double floor64(double  x) {
    return stdc.floor(x);
}

pragma(inline, true)
float ceilX(float x) {
    return (x <= 0.0f || (cast(float) cast(int) x) == x)
        ? (cast(float) cast(int) x)
        : (cast(float) cast(int) x) + 1.0f;
}

pragma(inline, true)
double ceilX64(double x) {
    return (x <= 0.0 || (cast(double) cast(long) x) == x)
        ? (cast(double) cast(long) x)
        : (cast(double) cast(long) x) + 1.0;
}

pragma(inline, true)
@trusted
float ceil(float x) {
    return stdc.ceilf(x);
}

pragma(inline, true)
@trusted
double ceil64(double x) {
    return stdc.ceil(x);
}

pragma(inline, true)
float roundX(float x) {
    return (x <= 0.0f)
        ? cast(float) cast(int) (x - 0.5f)
        : cast(float) cast(int) (x + 0.5f);
}

pragma(inline, true)
double roundX64(double x) {
    return (x <= 0.0)
        ? cast(double) cast(long) (x - 0.5)
        : cast(double) cast(long) (x + 0.5);
}

pragma(inline, true)
@trusted
float round(float x) {
    return stdc.roundf(x);
}

pragma(inline, true)
@trusted
double round64(double x) {
    return stdc.round(x);
}

pragma(inline, true)
@trusted
float sqrt(float x) {
    return stdc.sqrtf(x);
}

pragma(inline, true)
@trusted
double sqrt64(double x) {
    return stdc.sqrt(x);
}

pragma(inline, true)
@trusted
float sin(float x) {
    return stdc.sinf(x);
}

pragma(inline, true)
@trusted
double sin64(double x) {
    return stdc.sin(x);
}

pragma(inline, true)
@trusted
float cos(float x) {
    return stdc.cosf(x);
}

pragma(inline, true)
@trusted
double cos64(double x) {
    return stdc.cos(x);
}

pragma(inline, true)
@trusted
float tan(float x) {
    return stdc.tanf(x);
}

pragma(inline, true)
@trusted
double tan64(double x) {
    return stdc.tan(x);
}

pragma(inline, true)
@trusted
float asin(float x) {
    return stdc.asinf(x);
}

pragma(inline, true)
@trusted
double asin64(double x) {
    return stdc.asin(x);
}

pragma(inline, true)
@trusted
float acos(float x) {
    return stdc.acosf(x);
}

pragma(inline, true)
@trusted
double acos64(double x) {
    return stdc.acos(x);
}

pragma(inline, true)
@trusted
float atan(float x) {
    return stdc.atanf(x);
}

pragma(inline, true)
@trusted
double atan64(double x) {
    return stdc.atan(x);
}

pragma(inline, true)
float lerp(float from, float to, float weight) {
    return from + (to - from) * weight;
}

pragma(inline, true)
double lerp64(double from, double to, double weight) {
    return from + (to - from) * weight;
}

float smoothstep(float from, float to, float weight) {
    auto v = weight * weight * (3.0f - 2.0f * weight);
    return (to * v) + (from * (1.0f - v));
}

double smoothstep64(double from, double to, double weight) {
    auto v = weight * weight * (3.0 - 2.0 * weight);
    return (to * v) + (from * (1.0 - v));
}

float smootherstep(float from, float to, float weight) {
    auto v = weight * weight * weight * (weight * (weight * 6.0f - 15.0f) + 10.0f);
    return (to * v) + (from * (1.0f - v));
}

double smootherstep64(double from, double to, double weight) {
    auto v = weight * weight * weight * (weight * (weight * 6.0 - 15.0) + 10.0);
    return (to * v) + (from * (1.0 - v));
}

pragma(inline, true)
float easeInSine(float x) {
    return 1.0f - cos((x * pi) / 2.0f);
}

pragma(inline, true)
float easeOutSine(float x) {
    return sin((x * pi) / 2.0f);
}

pragma(inline, true)
float easeInOutSine(float x) {
    return -(cos(pi * x) - 1.0f) / 2.0f;
}

pragma(inline, true)
float easeInCubic(float x) {
    return x * x * x;
}

pragma(inline, true)
float easeOutCubic(float x) {
    return 1.0f - pow(1.0f - x, 3.0f);
}

pragma(inline, true)
float easeInOutCubic(float x) {
    return x < 0.5f ? 4.0f * x * x * x : 1.0f - pow(-2.0f * x + 2.0f, 3.0f) / 2.0f;
}

pragma(inline, true)
float easeInQuint(float x) {
    return x * x * x * x * x;
}

pragma(inline, true)
float easeOutQuint(float x) {
    return 1.0f - pow(1.0f - x, 5.0f);
}

pragma(inline, true)
float easeInOutQuint(float x) {
    return x < 0.5f ? 16.0f * x * x * x * x * x : 1.0f - pow(-2.0f * x + 2.0f, 5.0f) / 2.0f;
}

pragma(inline, true)
float easeInCirc(float x) {
    return 1.0f - sqrt(1.0f - pow(x, 2.0f));
}

pragma(inline, true)
float easeOutCirc(float x) {
    return sqrt(1.0f - pow(x - 1.0f, 2.0f));
}

pragma(inline, true)
float easeInOutCirc(float x) {
    return x < 0.5f
        ? (1.0f - sqrt(1.0f - pow(2.0f * x, 2.0f))) / 2.0f
        : (sqrt(1.0f - pow(-2.0f * x + 2.0f, 2.0f)) + 1.0f) / 2.0f;
}

pragma(inline, true)
float easeInElastic(float x) {
    enum c4 = (2.0f * pi) / 3.0f;

    return x == 0.0f
        ? 0.0f
        : x == 1.0f
        ? 1.0f
        : -pow(2.0f, 10.0f * x - 10.0f) * sin((x * 10.0f - 10.75f) * c4);
}

pragma(inline, true)
float easeOutElastic(float x) {
    enum c4 = (2.0f * pi) / 3.0f;

    return x == 0.0f
        ? 0.0f
        : x == 1.0f
        ? 1.0f
        : pow(2.0f, -10.0f * x) * sin((x * 10.0f - 0.75f) * c4) + 1.0f;
}

pragma(inline, true)
float easeInOutElastic(float x) {
    enum c5 = (2.0f * pi) / 4.5f;

    return x == 0.0f
        ? 0.0f
        : x == 1.0f
        ? 1.0f
        : x < 0.5f
        ? -(pow(2.0f, 20.0f * x - 10.0f) * sin((20.0f * x - 11.125f) * c5)) / 2.0f
        : (pow(2.0f, -20.0f * x + 10.0f) * sin((20.0f * x - 11.125f) * c5)) / 2.0f + 1.0f;
}

pragma(inline, true)
float easeInQuad(float x) {
    return x * x;
}

pragma(inline, true)
float easeOutQuad(float x) {
    return 1.0f - (1.0f - x) * (1.0f - x);
}

pragma(inline, true)
float easeInOutQuad(float x) {
    return x < 0.5f ? 2.0f * x * x : 1.0f - pow(-2.0f * x + 2.0f, 2.0f) / 2.0f;
}

pragma(inline, true)
float easeInQuart(float x) {
    return x * x * x * x;
}

pragma(inline, true)
float easeOutQuart(float x) {
    return 1.0f - pow(1.0f - x, 4.0f);
}

pragma(inline, true)
float easeInOutQuart(float x) {
    return x < 0.5f ? 8.0f * x * x * x * x : 1.0f - pow(-2.0f * x + 2.0f, 4.0f) / 2.0f;
}

pragma(inline, true)
float easeInExpo(float x) {
    return x == 0.0f ? 0.0f : pow(2.0f, 10.0f * x - 10.0f);
}

pragma(inline, true)
float easeOutExpo(float x) {
    return x == 1.0f ? 1.0f : 1.0f - pow(2.0f, -10.0f * x);
}

pragma(inline, true)
float easeInOutExpo(float x) {
    return x == 0.0f
        ? 0.0f
        : x == 1.0f
        ? 1.0f
        : x < 0.5f ? pow(2.0f, 20.0f * x - 10.0f) / 2.0f
        : (2.0f - pow(2.0f, -20.0f * x + 10.0f)) / 2.0f;
}

pragma(inline, true)
float easeInBack(float x) {
    enum c1 = 1.70158f;
    enum c3 = c1 + 1.0f;

    return c3 * x * x * x - c1 * x * x;
}

pragma(inline, true)
float easeOutBack(float x) {
    enum c1 = 1.70158f;
    enum c3 = c1 + 1.0f;

    return 1.0f + c3 * pow(x - 1.0f, 3.0f) + c1 * pow(x - 1.0f, 2.0f);
}

pragma(inline, true)
float easeInOutBack(float x) {
    enum c1 = 1.70158f;
    enum c2 = c1 * 1.525f;

    return x < 0.5f
        ? (pow(2.0f * x, 2.0f) * ((c2 + 1.0f) * 2.0f * x - c2)) / 2.0f
        : (pow(2.0f * x - 2.0f, 2.0f) * ((c2 + 1.0f) * (x * 2.0f - 2.0f) + c2) + 2.0f) / 2.0f;
}

pragma(inline, true)
float easeInBounce(float x) {
    return 1.0f - easeOutBounce(1.0f - x);
}

pragma(inline, true)
float easeOutBounce(float x) {
    enum n1 = 7.5625f;
    enum d1 = 2.75f;

    return (x < 1.0f / d1)
        ? n1 * x * x
        : (x < 2.0f / d1)
        ? n1 * (x -= 1.5f / d1) * x + 0.75f
        : (x < 2.5f / d1)
        ? n1 * (x -= 2.25f / d1) * x + 0.9375f
        : n1 * (x -= 2.625f / d1) * x + 0.984375f;
}

pragma(inline, true)
float easeInOutBounce(float x) {
    return x < 0.5f
        ? (1.0f - easeOutBounce(1.0f - 2.0f * x)) / 2.0f
        : (1.0f + easeOutBounce(2.0f * x - 1.0f)) / 2.0f;
}

pragma(inline, true)
float moveTo(float from, float to, float delta) {
    return (abs(to - from) > abs(delta))
        ? from + sign(to - from) * delta
        : to;
}

pragma(inline, true)
float moveTo64(double from, double to, double delta) {
    return (abs(to - from) > abs(delta))
        ? from + sign(to - from) * delta
        : to;
}

Vec2 moveTo(Vec2 from, Vec2 to, Vec2 delta) {
    Vec2 result = Vec2();
    auto offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) result.x = from.x + offset.x;
    else result.x = to.x;
    if (abs(to.y - from.y) > abs(offset.y)) result.y = from.y + offset.y;
    else result.y = to.y;
    return result;
}

Vec3 moveTo(Vec3 from, Vec3 to, Vec3 delta) {
    Vec3 result = Vec3();
    auto offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) result.x = from.x + offset.x;
    else result.x = to.x;
    if (abs(to.y - from.y) > abs(offset.y)) result.y = from.y + offset.y;
    else result.y = to.y;
    if (abs(to.z - from.z) > abs(offset.z)) result.z = from.z + offset.z;
    else result.z = to.z;
    return result;
}

Vec4 moveTo(Vec4 from, Vec4 to, Vec4 delta) {
    Vec4 result = Vec4();
    auto offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) result.x = from.x + offset.x;
    else result.x = to.x;
    if (abs(to.y - from.y) > abs(offset.y)) result.y = from.y + offset.y;
    else result.y = to.y;
    if (abs(to.z - from.z) > abs(offset.z)) result.z = from.z + offset.z;
    else result.z = to.z;
    if (abs(to.w - from.w) > abs(offset.w)) result.w = from.w + offset.w;
    else result.w = to.w;
    return result;
}

DVec2 moveTo(DVec2 from, DVec2 to, DVec2 delta) {
    DVec2 result = DVec2();
    auto offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) result.x = from.x + offset.x;
    else result.x = to.x;
    if (abs(to.y - from.y) > abs(offset.y)) result.y = from.y + offset.y;
    else result.y = to.y;
    return result;
}

DVec3 moveTo(DVec3 from, DVec3 to, DVec3 delta) {
    DVec3 result = DVec3();
    auto offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) result.x = from.x + offset.x;
    else result.x = to.x;
    if (abs(to.y - from.y) > abs(offset.y)) result.y = from.y + offset.y;
    else result.y = to.y;
    if (abs(to.z - from.z) > abs(offset.z)) result.z = from.z + offset.z;
    else result.z = to.z;
    return result;
}

DVec4 moveTo(DVec4 from, DVec4 to, DVec4 delta) {
    DVec4 result = DVec4();
    auto offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) result.x = from.x + offset.x;
    else result.x = to.x;
    if (abs(to.y - from.y) > abs(offset.y)) result.y = from.y + offset.y;
    else result.y = to.y;
    if (abs(to.z - from.z) > abs(offset.z)) result.z = from.z + offset.z;
    else result.z = to.z;
    if (abs(to.w - from.w) > abs(offset.w)) result.w = from.w + offset.w;
    else result.w = to.w;
    return result;
}

float moveToWithSlowdown(float from, float to, float delta, float slowdown) {
    if (from.fequals(to)) return to;
    auto target = ((from * (slowdown - 1.0f)) + to) / slowdown;
    return from + (target - from) * delta;
}

float moveToWithSlowdown64(double from, double to, double delta, double slowdown) {
    if (from.fequals64(to)) return to;
    auto target = ((from * (slowdown - 1.0)) + to) / slowdown;
    return from + (target - from) * delta;
}

Vec2 moveToWithSlowdown(Vec2 from, Vec2 to, Vec2 delta, float slowdown) {
    return Vec2(
        moveToWithSlowdown(from.x, to.x, delta.x, slowdown),
        moveToWithSlowdown(from.y, to.y, delta.y, slowdown),
    );
}

Vec3 moveToWithSlowdown(Vec3 from, Vec3 to, Vec3 delta, float slowdown) {
    return Vec3(
        moveToWithSlowdown(from.x, to.x, delta.x, slowdown),
        moveToWithSlowdown(from.y, to.y, delta.y, slowdown),
        moveToWithSlowdown(from.z, to.z, delta.z, slowdown),
    );
}

Vec4 moveToWithSlowdown(Vec4 from, Vec4 to, Vec4 delta, float slowdown) {
    return Vec4(
        moveToWithSlowdown(from.x, to.x, delta.x, slowdown),
        moveToWithSlowdown(from.y, to.y, delta.y, slowdown),
        moveToWithSlowdown(from.z, to.z, delta.z, slowdown),
        moveToWithSlowdown(from.w, to.w, delta.w, slowdown),
    );
}

DVec2 moveToWithSlowdown(DVec2 from, DVec2 to, DVec2 delta, double slowdown) {
    return DVec2(
        moveToWithSlowdown64(from.x, to.x, delta.x, slowdown),
        moveToWithSlowdown64(from.y, to.y, delta.y, slowdown),
    );
}

DVec3 moveToWithSlowdown(DVec3 from, DVec3 to, DVec3 delta, double slowdown) {
    return DVec3(
        moveToWithSlowdown64(from.x, to.x, delta.x, slowdown),
        moveToWithSlowdown64(from.y, to.y, delta.y, slowdown),
        moveToWithSlowdown64(from.z, to.z, delta.z, slowdown),
    );
}

DVec4 moveToWithSlowdown(DVec4 from, DVec4 to, DVec4 delta, double slowdown) {
    return DVec4(
        moveToWithSlowdown64(from.x, to.x, delta.x, slowdown),
        moveToWithSlowdown64(from.y, to.y, delta.y, slowdown),
        moveToWithSlowdown64(from.z, to.z, delta.z, slowdown),
        moveToWithSlowdown64(from.w, to.w, delta.w, slowdown),
    );
}

deprecated("Use `fequals` instead.")
alias equals = fequals;

pragma(inline, true)
bool fequals(float a, float b, float localEpsilon = epsilon) {
    return abs(a - b) < localEpsilon;
}

pragma(inline, true)
bool fequals64(double a, double b, double localEpsilon = epsilon) {
    return abs(a - b) < localEpsilon;
}

pragma(inline, true)
bool fequals(Vec2 a, Vec2 b, float localEpsilon = epsilon) {
    return fequals(a.x, b.x, localEpsilon) && fequals(a.y, b.y, localEpsilon);
}

pragma(inline, true)
bool fequals(Vec3 a, Vec3 b, float localEpsilon = epsilon) {
    return fequals(a.x, b.x, localEpsilon) && fequals(a.y, b.y, localEpsilon) && fequals(a.z, b.z, localEpsilon);
}

pragma(inline, true)
bool fequals(Vec4 a, Vec4 b, float localEpsilon = epsilon) {
    return fequals(a.x, b.x, localEpsilon) && fequals(a.y, b.y, localEpsilon) && fequals(a.z, b.z, localEpsilon) && fequals(a.w, b.w, localEpsilon);
}

pragma(inline, true)
bool fequals(DVec2 a, DVec2 b, double localEpsilon = epsilon) {
    return fequals(a.x, b.x, localEpsilon) && fequals(a.y, b.y, localEpsilon);
}

pragma(inline, true)
bool fequals(DVec3 a, DVec3 b, double localEpsilon = epsilon) {
    return fequals(a.x, b.x, localEpsilon) && fequals(a.y, b.y, localEpsilon) && fequals(a.z, b.z, localEpsilon);
}

pragma(inline, true)
bool fequals(DVec4 a, DVec4 b, double localEpsilon = epsilon) {
    return fequals(a.x, b.x, localEpsilon) && fequals(a.y, b.y, localEpsilon) && fequals(a.z, b.z, localEpsilon) && fequals(a.w, b.w, localEpsilon);
}

pragma(inline, true)
float toRadians(float degrees) {
    return degrees * pi180;
}

pragma(inline, true)
double toRadians64(double degrees) {
    return degrees * pi180;
}

pragma(inline, true)
float toDegrees(float radians) {
    return radians * dpi180;
}

pragma(inline, true)
double toDegrees64(double radians) {
    return radians * dpi180;
}

pragma(inline, true);
Rgba toRgb(uint rgb) {
    return Rgba(
        (rgb & 0xFF0000) >> 16,
        (rgb & 0xFF00) >> 8,
        (rgb & 0xFF),
    );
}

alias toColor = toRgba;

pragma(inline, true);
Rgba toRgba(uint rgba) {
    return Rgba(
        (rgba & 0xFF000000) >> 24,
        (rgba & 0xFF0000) >> 16,
        (rgba & 0xFF00) >> 8,
        (rgba & 0xFF),
    );
}

pragma(inline, true);
Rgba toRgba(Vec3 vec) {
    return Rgba(
        cast(ubyte) clamp(vec.x, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.y, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.z, 0.0f, 255.0f),
        255,
    );
}

pragma(inline, true);
Rgba toRgba(Vec4 vec) {
    return Rgba(
        cast(ubyte) clamp(vec.x, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.y, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.z, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.w, 0.0f, 255.0f),
    );
}

pragma(inline, true);
IVec2 toIVec(Vec2 vec) {
    return IVec2(cast(int) vec.x, cast(int) vec.y);
}

pragma(inline, true);
IVec3 toIVec(Vec3 vec) {
    return IVec3(cast(int) vec.x, cast(int) vec.y, cast(int) vec.z);
}

pragma(inline, true);
IVec4 toIVec(Vec4 vec) {
    return IVec4(cast(int) vec.x, cast(int) vec.y, cast(int) vec.z, cast(int) vec.w);
}

pragma(inline, true);
Vec2 toVec(IVec2 vec) {
    return Vec2(vec.x, vec.y);
}

pragma(inline, true);
Vec3 toVec(IVec3 vec) {
    return Vec3(vec.x, vec.y, vec.z);
}

pragma(inline, true);
Vec4 toVec(IVec4 vec) {
    return Vec4(vec.x, vec.y, vec.z, vec.w);
}

pragma(inline, true);
Vec4 toVec(Rgba color) {
    return Vec4(color.r, color.g, color.b, color.a);
}

pragma(inline, true);
IRect toIRect(Rect rect) {
    return IRect(rect.position.toIVec(), rect.size.toIVec());
}

pragma(inline, true);
Rect toRect(IRect rect) {
    return Rect(rect.position.toVec(), rect.size.toVec());
}

// Function test.
unittest {
    assert(min3(6, 9, 4) == 4);
    assert(max3(6, 9, 4) == 9);
    assert(min4(6, 9, 4, 20) == 4);
    assert(max4(6, 9, 4, 20) == 20);

    assert(clamp(1, 6, 9) == 6);
    assert(clamp(6, 6, 9) == 6);
    assert(clamp(8, 6, 9) == 8);
    assert(clamp(9, 6, 9) == 9);
    assert(clamp(11, 6, 9) == 9);

    assert(wrap!uint(0, 0, 69) == 0);
    assert(wrap!uint(1, 0, 69) == 1);
    assert(wrap!uint(68, 0, 69) == 68);
    assert(wrap!uint(69, 0, 69) == 0);

    assert(wrap!uint(9, 9, 69) == 9);
    assert(wrap!uint(10, 9, 69) == 10);
    assert(wrap!uint(68, 9, 69) == 68);
    assert(wrap!uint(69, 9, 69) == 9);
    assert(wrap!uint(8, 9, 69) == 68);

    assert(cast(int) round(wrap!float(0, 0, 69)) == 0);
    assert(cast(int) round(wrap!float(1, 0, 69)) == 1);
    assert(cast(int) round(wrap!float(68, 0, 69)) == 68);
    assert(cast(int) round(wrap!float(69, 0, 69)) == 0);

    assert(cast(int) round(wrap!float(9, 9, 69)) == 9);
    assert(cast(int) round(wrap!float(10, 9, 69)) == 10);
    assert(cast(int) round(wrap!float(68, 9, 69)) == 68);
    assert(cast(int) round(wrap!float(69, 9, 69)) == 9);
    assert(cast(int) round(wrap!float(8, 9, 69)) == 68);

    assert(wrap!int(0, 0, 69) == 0);
    assert(wrap!int(1, 0, 69) == 1);
    assert(wrap!int(68, 0, 69) == 68);
    assert(wrap!int(69, 0, 69) == 0);

    assert(wrap!int(9, 9, 69) == 9);
    assert(wrap!int(10, 9, 69) == 10);
    assert(wrap!int(68, 9, 69) == 68);
    assert(wrap!int(69, 9, 69) == 9);
    assert(wrap!int(8, 9, 69) == 68);

    assert(snap!int(0, 32) == 0);
    assert(snap!int(-1, 32) == 0);
    assert(snap!int(1, 32) == 0);
    assert(snap!int(-31, 32) == -32);
    assert(snap!int(-32, 32) == -32);
    assert(snap!int(31, 32) == 32);
    assert(snap!int(32, 32) == 32);

    assert(cast(int) round(snap!float(0, 32)) == 0);
    assert(cast(int) round(snap!float(-1, 32)) == 0);
    assert(cast(int) round(snap!float(1, 32)) == 0);
    assert(cast(int) round(snap!float(-31, 32)) == -32);
    assert(cast(int) round(snap!float(-32, 32)) == -32);
    assert(cast(int) round(snap!float(31, 32)) == 32);
    assert(cast(int) round(snap!float(32, 32)) == 32);

    assert(toRgb(0xff0000) == red);
    assert(toRgb(0x00ff00) == green);
    assert(toRgb(0x0000ff) == blue);
    assert(toRgba(0xff0000ff) == red);
    assert(toRgba(0x00ff00ff) == green);
    assert(toRgba(0x0000ffff) == blue);
}

// Vec test.
unittest {
    assert(IVec2(6) + IVec2(4) == IVec2(10));
    assert(IVec3(6) + IVec3(4) == IVec3(10));
    assert(IVec4(6) + IVec4(4) == IVec4(10));

    auto temp2 = IVec2(6);
    auto temp3 = IVec2(6);
    auto temp4 = IVec2(6);
    temp2 += IVec2(4);
    temp3 += IVec2(4);
    temp4 += IVec2(4);
    assert(temp2 == IVec2(10));
    assert(temp3 == IVec2(10));
    assert(temp4 == IVec2(10));
    assert(!temp2.isZero);
    assert(!temp3.isZero);
    assert(!temp4.isZero);
}
