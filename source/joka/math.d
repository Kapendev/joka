// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.21
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

enum black   = Color(0);             /// Black black.
enum white   = Color(255);           /// White white.
enum red     = Color(255, 0, 0);     /// Red red.
enum green   = Color(0, 255, 0);     /// Green green.
enum blue    = Color(0, 0, 255);     /// Blue blue.
enum yellow  = Color(255, 255, 0);   /// Yellow yellow.
enum magenta = Color(255, 0, 255);   /// Magenta magenta.
enum pink    = Color(255, 192, 204); /// Pink pink.
enum cyan    = Color(0, 255, 255);   /// Cyan cyan.
enum orange  = Color(255, 165, 0);   /// Orange orange.
enum beige   = Color(240, 235, 210); /// Beige beige.
enum brown   = Color(165, 72, 42);   /// Brown brown.
enum maroon  = Color(128, 0, 0);     /// Maroon maroon.
enum gray1   = Color(32, 32, 32);    /// Gray 1.
enum gray2   = Color(96, 96, 96);    /// Gray 22.
enum gray3   = Color(159, 159, 159); /// Gray 333.
enum gray4   = Color(223, 223, 223); /// Gray 4444.
enum gray    = gray2;                /// Gray gray.

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
struct Color {
    ubyte r; /// The R component of the color.
    ubyte g; /// The G component of the color.
    ubyte b; /// The B component of the color.
    ubyte a; /// The A component of the color.

    enum length = 4;               /// The component count of the color.
    enum form = "rgba";            /// The form of the color.
    enum zero = Color(0, 0, 0, 0); /// The zero value of the color.
    enum one = Color(1, 1, 1, 1);  /// The one value of the color.

    @safe @nogc nothrow:

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

    mixin addXyzwOps!(Color, length, form);

    pragma(inline, true)
    bool isZero() {
        return r == 0 && g == 0 && b == 0 && a == 0;
    }

    /// Returns a color with just the alpha modified.
    Color alpha(ubyte value) {
        return Color(r, g, b, value);
    }
}

/// A 2D vector using ints.
struct IVec2 {
    int x; /// The X component of the vector.
    int y; /// The Y component of the vector.

    enum length = 2;      /// The component count of the vector.
    enum form = "xyzw";   /// The form of the vector.
    enum zero = IVec2(0); /// The zero value of the vector.
    enum one = IVec2(1);  /// The one value of the vector.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(int x, int y) {
        this.x = x;
        this.y = y;
    }

    pragma(inline, true)
    this(int x) {
        this(x, x);
    }

    mixin addXyzwOps!(IVec2, length, form);

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0;
    }
}

/// A 3D vector using ints.
struct IVec3 {
    int x; /// The X component of the vector.
    int y; /// The Y component of the vector.
    int z; /// The Z component of the vector.

    enum length = 3;      /// The component count of the vector.
    enum form = "xyzw";   /// The form of the vector.
    enum zero = IVec3(0); /// The zero value of the vector.
    enum one = IVec3(1);  /// The one value of the vector.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    pragma(inline, true)
    this(int x) {
        this(x, x, x);
    }

    pragma(inline, true)
    this(IVec2 xy, int z) {
        this(xy.x, xy.y, z);
    }

    mixin addXyzwOps!(IVec3, length, form);

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0 && z == 0;
    }
}

/// A 4D vector using ints.
struct IVec4 {
    int x; /// The X component of the vector.
    int y; /// The Y component of the vector.
    int z; /// The Z component of the vector.
    int w; /// The W component of the vector.

    enum length = 4;      /// The component count of the vector.
    enum form = "xyzw";   /// The form of the vector.
    enum zero = IVec4(0); /// The zero value of the vector.
    enum one = IVec4(1);  /// The one value of the vector.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(int x, int y, int z, int w) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    pragma(inline, true)
    this(int x) {
        this(x, x, x, x);
    }

    pragma(inline, true)
    this(IVec2 xy, IVec2 zw) {
        this(xy.x, xy.y, zw.x, zw.y);
    }

    mixin addXyzwOps!(IVec4, length, form);

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0 && z == 0 && w == 0;
    }
}

struct IRect {
    IVec2 position;
    IVec2 size;

    @safe @nogc nothrow:

    pragma(inline, true)
    this(IVec2 position, IVec2 size) {
        this.position = position;
        this.size = size;
    }

    pragma(inline, true)
    this(IVec2 size) {
        this(IVec2(), size);
    }

    pragma(inline, true)
    this(int x, int y, int w, int h) {
        this(IVec2(x, y), IVec2(w, h));
    }

    pragma(inline, true)
    this(int w, int h) {
        this(IVec2(), IVec2(w, h));
    }

    pragma(inline, true)
    this(IVec2 position, int w, int h) {
        this(position, IVec2(w, h));
    }

    pragma(inline, true)
    this(int x, int y, IVec2 size) {
        this(IVec2(x, y), size);
    }

    void fix() {
        if (size.x < 0) {
            position.x = position.x + size.x;
            size.x = -size.x;
        }
        if (size.y < 0) {
            position.y = position.y + size.y;
            size.y = -size.y;
        }
    }

    pragma(inline, true);
    bool hasPoint(IVec2 point) {
        return (
            point.x > position.x &&
            point.x < position.x + size.x &&
            point.y > position.y &&
            point.y < position.y + size.y
        );
    }

    pragma(inline, true);
    bool hasPointInclusive(IVec2 point) {
        return (
            point.x >= position.x &&
            point.x < position.x + size.x &&
            point.y >= position.y &&
            point.y < position.y + size.y
        );
    }

    pragma(inline, true);
    bool hasIntersection(IRect area) {
        return (
            position.x + size.x > area.position.x &&
            position.x < area.position.x + area.size.x &&
            position.y + size.y > area.position.y &&
            position.y < area.position.y + area.size.y
        );
    }

    pragma(inline, true);
    bool hasIntersectionInclusive(IRect area) {
        return (
            position.x + size.x >= area.position.x &&
            position.x < area.position.x + area.size.x &&
            position.y + size.y >= area.position.y &&
            position.y < area.position.y + area.size.y
        );
    }
}

/// A 2D vector using floats.
struct Vec2 {
    float x = 0.0f; /// The X component of the vector.
    float y = 0.0f; /// The Y component of the vector.

    enum length = 2;     /// The component count of the vector.
    enum form = "xyzw";  /// The form of the vector.
    enum zero = Vec2(0); /// The zero value of the vector.
    enum one = Vec2(1);  /// The one value of the vector.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(float x, float y) {
        this.x = x;
        this.y = y;
    }

    pragma(inline, true)
    this(float x) {
        this(x, x);
    }

    mixin addXyzwOps!(Vec2, length, form);

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0;
    }

    float angle() {
        return atan2(y, x);
    }

    float magnitude() {
        return sqrt(x * x + y * y);
    }

    float magnitudeSquared() {
        return x * x + y * y;
    }

    Vec2 normalize() {
        return this / Vec2(magnitude);
    }

    float distanceTo(Vec2 to) {
        return (to - this).magnitude;
    }

    Vec2 directionTo(Vec2 to) {
        return (to - this).normalize();
    }
}

/// A 3D vector using floats.
struct Vec3 {
    float x = 0.0f; /// The X component of the vector.
    float y = 0.0f; /// The Y component of the vector.
    float z = 0.0f; /// The Z component of the vector.

    enum length = 3;     /// The component count of the vector.
    enum form = "xyzw";  /// The form of the vector.
    enum zero = Vec3(0); /// The zero value of the vector.
    enum one = Vec3(1);  /// The one value of the vector.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    pragma(inline, true)
    this(float x) {
        this(x, x, x);
    }

    pragma(inline, true)
    this(Vec2 xy, float z) {
        this(xy.x, xy.y, z);
    }

    mixin addXyzwOps!(Vec3, length, form);

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0 && z == 0;
    }

    float magnitude() {
        return sqrt(x * x + y * y + z * z);
    }

    float magnitudeSquared() {
        return x * x + y * y + z * z;
    }

    Vec3 normalize() {
        return this / Vec3(magnitude);
    }

    float distanceTo(Vec3 to) {
        return (to - this).magnitude;
    }

    Vec3 directionTo(Vec3 to) {
        return (to - this).normalize();
    }
}

/// A 4D vector using floats.
struct Vec4 {
    float x = 0.0f; /// The X component of the vector.
    float y = 0.0f; /// The Y component of the vector.
    float z = 0.0f; /// The Z component of the vector.
    float w = 0.0f; /// The W component of the vector.

    enum length = 4;     /// The component count of the vector.
    enum form = "xyzw";  /// The form of the vector.
    enum zero = Vec4(0); /// The zero value of the vector.
    enum one = Vec4(1);  /// The one value of the vector.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(float x, float y, float z, float w) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    pragma(inline, true)
    this(float x) {
        this(x, x, x, x);
    }

    pragma(inline, true)
    this(Vec2 xy, Vec2 zw) {
        this(xy.x, xy.y, zw.x, zw.y);
    }

    mixin addXyzwOps!(Vec4, length, form);

    pragma(inline, true)
    bool isZero() {
        return x == 0 && y == 0 && z == 0 && w == 0;
    }

    float magnitude() {
        return sqrt(x * x + y * y + z * z + w * w);
    }

    float magnitudeSquared() {
        return x * x + y * y + z * z + w * w;
    }

    Vec4 normalize() {
        return this / Vec4(magnitude);
    }

    float distanceTo(Vec4 to) {
        return (to - this).magnitude;
    }

    Vec4 directionTo(Vec4 to) {
        return (to - this).normalize();
    }
}

/// A 2D Rectangle using floats.
struct Rect {
    Vec2 position; /// The position of the rectangle.
    Vec2 size;     /// The size of the rectangle.

    @safe @nogc nothrow:

    pragma(inline, true)
    this(Vec2 position, Vec2 size) {
        this.position = position;
        this.size = size;
    }

    pragma(inline, true)
    this(Vec2 size) {
        this(Vec2(), size);
    }

    pragma(inline, true)
    this(float x, float y, float w, float h) {
        this(Vec2(x, y), Vec2(w, h));
    }

    pragma(inline, true)
    this(float w, float h) {
        this(Vec2(), Vec2(w, h));
    }

    pragma(inline, true)
    this(Vec2 position, float w, float h) {
        this(position, Vec2(w, h));
    }

    pragma(inline, true)
    this(float x, float y, Vec2 size) {
        this(Vec2(x, y), size);
    }

    void fix() {
        if (size.x < 0.0f) {
            position.x = position.x + size.x;
            size.x = -size.x;
        }
        if (size.y < 0.0f) {
            position.y = position.y + size.y;
            size.y = -size.y;
        }
    }

    Vec2 origin(Hook hook) {
        final switch (hook) {
            case Hook.topLeft: return Vec2();
            case Hook.top: return size * Vec2(0.5f, 0.0f);
            case Hook.topRight: return size * Vec2(1.0f, 0.0f);
            case Hook.left: return size * Vec2(0.0f, 0.5f);
            case Hook.center: return size * Vec2(0.5f, 0.5f);
            case Hook.right: return size * Vec2(1.0f, 0.5f);
            case Hook.bottomLeft: return size * Vec2(0.0f, 1.0f);
            case Hook.bottom: return size * Vec2(0.5f, 1.0f);
            case Hook.bottomRight: return size;
        }
    }

    Rect area(Hook hook) {
        return Rect(
            position - origin(hook),
            size,
        );
    }

    Vec2 point(Hook hook) {
        return position + origin(hook);
    }

    Vec2 topLeftPoint() {
        return point(Hook.topLeft);
    }

    Vec2 topPoint() {
        return point(Hook.top);
    }

    Vec2 topRightPoint() {
        return point(Hook.topRight);
    }

    Vec2 leftPoint() {
        return point(Hook.left);
    }

    Vec2 centerPoint() {
        return point(Hook.center);
    }

    Vec2 rightPoint() {
        return point(Hook.right);
    }

    Vec2 bottomLeftPoint() {
        return point(Hook.bottomLeft);
    }

    Vec2 bottomPoint() {
        return point(Hook.bottom);
    }

    Vec2 bottomRightPoint() {
        return point(Hook.bottomRight);
    }

    Rect topLeftArea() {
        return area(Hook.topLeft);
    }

    Rect topArea() {
        return area(Hook.top);
    }

    Rect topRightArea() {
        return area(Hook.topRight);
    }

    Rect leftArea() {
        return area(Hook.left);
    }

    Rect centerArea() {
        return area(Hook.center);
    }

    Rect rightArea() {
        return area(Hook.right);
    }

    Rect bottomLeftArea() {
        return area(Hook.bottomLeft);
    }

    Rect bottomArea() {
        return area(Hook.bottom);
    }

    Rect bottomRightArea() {
        return area(Hook.bottomRight);
    }

    pragma(inline, true);
    bool hasPoint(Vec2 point) {
        return (
            point.x > position.x &&
            point.x < position.x + size.x &&
            point.y > position.y &&
            point.y < position.y + size.y
        );
    }

    pragma(inline, true);
    bool hasPointInclusive(Vec2 point) {
        return (
            point.x >= position.x &&
            point.x < position.x + size.x &&
            point.y >= position.y &&
            point.y < position.y + size.y
        );
    }

    pragma(inline, true);
    bool hasIntersection(Rect area) {
        return (
            position.x + size.x > area.position.x &&
            position.x < area.position.x + area.size.x &&
            position.y + size.y > area.position.y &&
            position.y < area.position.y + area.size.y
        );
    }

    pragma(inline, true);
    bool hasIntersectionInclusive(Rect area) {
        return (
            position.x + size.x >= area.position.x &&
            position.x < area.position.x + area.size.x &&
            position.y + size.y >= area.position.y &&
            position.y < area.position.y + area.size.y
        );
    }

    Rect intersection(Rect area) {
        if (!this.hasIntersection(area)) {
            return Rect();
        } else {
            auto maxY = max(position.x, area.position.x);
            auto maxX = max(position.y, area.position.y);
            return Rect(
                maxX,
                maxY,
                min(position.x + size.x, area.position.x + area.size.x) - maxX,
                min(position.y + size.y, area.position.y + area.size.y) - maxY,
            );
        }
    }

    Rect merger(Rect area) {
        auto minX = min(position.x, area.position.x);
        auto minY = min(position.y, area.position.y);
        return Rect(
            minX,
            minY,
            max(position.x + size.x, area.position.x + area.size.x) - minX,
            max(position.y + size.y, area.position.y + area.size.y) - minY,
        );
    }

    Rect addLeft(float amount) {
        position.x -= amount;
        size.x += amount;
        return Rect(position.x, position.y, amount, size.y);
    }

    Rect addRight(float amount) {
        auto w = size.x;
        size.x += amount;
        return Rect(w, position.y, amount, size.y);
    }

    Rect addTop(float amount) {
        position.y -= amount;
        size.y += amount;
        return Rect(position.x, position.y, size.x, amount);
    }

    Rect addBottom(float amount) {
        auto h = size.y;
        size.y += amount;
        return Rect(position.x, h, size.x, amount);
    }

    Rect subLeft(float amount) {
        auto x = position.x;
        position.x = min(position.x + amount, position.x + size.x);
        size.x = max(size.x - amount, 0.0f);
        return Rect(x, position.y, amount, size.y);
    }

    Rect subRight(float amount) {
        size.x = max(size.x - amount, 0.0f);
        return Rect(position.x + size.x, position.y, amount, size.y);
    }

    Rect subTop(float amount) {
        auto y = position.y;
        position.y = min(position.y + amount, position.y + size.y);
        size.y = max(size.y - amount, 0.0f);
        return Rect(position.x, y, size.x, amount);
    }

    Rect subBottom(float amount) {
        size.y = max(size.y - amount, 0.0f);
        return Rect(position.x, position.y + size.y, size.x, amount);
    }

    Rect addLeftRight(float amount) {
        this.addLeft(amount);
        this.addRight(amount);
        return this;
    }

    Rect addTopBottom(float amount) {
        this.addTop(amount);
        this.addBottom(amount);
        return this;
    }

    Rect addAll(float amount) {
        this.addLeftRight(amount);
        this.addTopBottom(amount);
        return this;
    }

    Rect subLeftRight(float amount) {
        this.subLeft(amount);
        this.subRight(amount);
        return this;
    }

    Rect subTopBottom(float amount) {
        this.subTop(amount);
        this.subBottom(amount);
        return this;
    }

    Rect subAll(float amount) {
        this.subLeftRight(amount);
        this.subTopBottom(amount);
        return this;
    }

    Rect left(float amount) {
        Rect temp = this;
        return temp.subLeft(amount);
    }

    Rect right(float amount) {
        Rect temp = this;
        return temp.subRight(amount);
    }

    Rect top(float amount) {
        Rect temp = this;
        return temp.subTop(amount);
    }

    Rect bottom(float amount) {
        Rect temp = this;
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

@trusted
float fmod(float x, float y) {
    return stdc.fmodf(x, y);
}

@trusted
double fmod(double x, double y) {
    return stdc.fmod(x, y);
}

@trusted
float remainder(float x, float y) {
    return stdc.remainderf(x, y);
}

@trusted
double remainder(double x, double y) {
    return stdc.remainder(x, y);
}

@trusted
float exp(float x) {
    return stdc.expf(x);
}

@trusted
double exp(double x) {
    return stdc.exp(x);
}

@trusted
float exp2(float x) {
    return stdc.exp2f(x);
}

@trusted
double exp2(double x) {
    return stdc.exp2(x);
}

@trusted
float expm1(float x) {
    return stdc.expm1f(x);
}

@trusted
double expm1(double x) {
    return stdc.expm1(x);
}

@trusted
float log(float x) {
    return stdc.logf(x);
}

@trusted
double log(double x) {
    return stdc.log(x);
}

@trusted
float log10(float x) {
    return stdc.log10f(x);
}

@trusted
double log10(double x) {
    return stdc.log10(x);
}

@trusted
float log2(float x) {
    return stdc.log2f(x);
}

@trusted
double log2(double x) {
    return stdc.log2(x);
}

@trusted
float log1p(float x) {
    return stdc.log1pf(x);
}

@trusted
double log1p(double x) {
    return stdc.log1p(x);
}

@trusted
float pow(float base, float exponent) {
    return stdc.powf(base, exponent);
}

@trusted
double pow(double base, double exponent) {
    return stdc.pow(base, exponent);
}

@trusted
float atan2(float y, float x) {
    return stdc.atan2f(y, x);
}

@trusted
double atan2(double y, double x) {
    return stdc.atan2(y, x);
}

pragma(inline, true)
T abs(T)(T x) {
    return x < 0 ? -x : x;
}

pragma(inline, true)
IVec2 abs(IVec2 vec) {
    return IVec2(vec.x.abs, vec.y.abs);
}

pragma(inline, true)
IVec3 abs(IVec3 vec) {
    return IVec3(vec.x.abs, vec.y.abs, vec.z.abs);
}

pragma(inline, true)
IVec4 abs(IVec4 vec) {
    return IVec4(vec.x.abs, vec.y.abs, vec.z.abs, vec.w.abs);
}

pragma(inline, true)
Vec2 abs(Vec2 vec) {
    return Vec2(vec.x.abs, vec.y.abs);
}

pragma(inline, true)
Vec3 abs(Vec3 vec) {
    return Vec3(vec.x.abs, vec.y.abs, vec.z.abs);
}

pragma(inline, true)
Vec4 abs(Vec4 vec) {
    return Vec4(vec.x.abs, vec.y.abs, vec.z.abs, vec.w.abs);
}

pragma(inline, true)
Rect abs(Rect rect) {
    return Rect(rect.position.abs, rect.size.abs);
}

pragma(inline, true)
float floorx(float x) {
    return (x <= 0.0f && (cast(float) cast(int) x) != x)
        ? (cast(float) cast(int) x) - 1.0f
        : (cast(float) cast(int) x);
}

pragma(inline, true)
double floorx(double x) {
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
double floor(double  x) {
    return stdc.floor(x);
}

pragma(inline, true)
Vec2 floor(Vec2 vec) {
    return Vec2(vec.x.floor, vec.y.floor);
}

pragma(inline, true)
Vec3 floor(Vec3 vec) {
    return Vec3(vec.x.floor, vec.y.floor, vec.z.floor);
}

pragma(inline, true)
Vec4 floor(Vec4 vec) {
    return Vec4(vec.x.floor, vec.y.floor, vec.z.floor, vec.w.floor);
}

pragma(inline, true)
Rect floor(Rect rect) {
    return Rect(rect.position.floor, rect.size.floor);
}

pragma(inline, true)
float ceilx(float x) {
    return (x <= 0.0f || (cast(float) cast(int) x) == x)
        ? (cast(float) cast(int) x)
        : (cast(float) cast(int) x) + 1.0f;
}

pragma(inline, true)
double ceilx(double x) {
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
double ceil(double x) {
    return stdc.ceil(x);
}

pragma(inline, true)
Vec2 ceil(Vec2 vec) {
    return Vec2(vec.x.ceil, vec.y.ceil);
}

pragma(inline, true)
Vec3 ceil(Vec3 vec) {
    return Vec3(vec.x.ceil, vec.y.ceil, vec.z.ceil);
}

pragma(inline, true)
Vec4 ceil(Vec4 vec) {
    return Vec4(vec.x.ceil, vec.y.ceil, vec.z.ceil, vec.w.ceil);
}

pragma(inline, true)
Rect ceil(Rect rect) {
    return Rect(rect.position.ceil, rect.size.ceil);
}

pragma(inline, true)
float roundx(float x) {
    return (x <= 0.0f)
        ? cast(float) cast(int) (x - 0.5f)
        : cast(float) cast(int) (x + 0.5f);
}

pragma(inline, true)
double roundx(double x) {
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
double round(double x) {
    return stdc.round(x);
}

pragma(inline, true)
Vec2 round(Vec2 vec) {
    return Vec2(vec.x.round, vec.y.round);
}

pragma(inline, true)
Vec3 round(Vec3 vec) {
    return Vec3(vec.x.round, vec.y.round, vec.z.round);
}

pragma(inline, true)
Vec4 round(Vec4 vec) {
    return Vec4(vec.x.round, vec.y.round, vec.z.round, vec.w.round);
}

pragma(inline, true)
Rect round(Rect rect) {
    return Rect(rect.position.round, rect.size.round);
}

@trusted
float sqrt(float x) {
    return stdc.sqrtf(x);
}

@trusted
double sqrt(double x) {
    return stdc.sqrt(x);
}

Vec2 sqrt(Vec2 vec) {
    return Vec2(vec.x.sqrt, vec.y.sqrt);
}

Vec3 sqrt(Vec3 vec) {
    return Vec3(vec.x.sqrt, vec.y.sqrt, vec.z.sqrt);
}

Vec4 sqrt(Vec4 vec) {
    return Vec4(vec.x.sqrt, vec.y.sqrt, vec.z.sqrt, vec.w.sqrt);
}

Rect sqrt(Rect rect) {
    return Rect(rect.position.sqrt, rect.size.sqrt);
}

@trusted
float sin(float x) {
    return stdc.sinf(x);
}

@trusted
double sin(double x) {
    return stdc.sin(x);
}

Vec2 sin(Vec2 vec) {
    return Vec2(vec.x.sin, vec.y.sin);
}

Vec3 sin(Vec3 vec) {
    return Vec3(vec.x.sin, vec.y.sin, vec.z.sin);
}

Vec4 sin(Vec4 vec) {
    return Vec4(vec.x.sin, vec.y.sin, vec.z.sin, vec.w.sin);
}

Rect sin(Rect rect) {
    return Rect(rect.position.sin, rect.size.sin);
}

@trusted
float cos(float x) {
    return stdc.cosf(x);
}

@trusted
double cos(double x) {
    return stdc.cos(x);
}

Vec2 cos(Vec2 vec) {
    return Vec2(vec.x.cos, vec.y.cos);
}

Vec3 cos(Vec3 vec) {
    return Vec3(vec.x.cos, vec.y.cos, vec.z.cos);
}

Vec4 cos(Vec4 vec) {
    return Vec4(vec.x.cos, vec.y.cos, vec.z.cos, vec.w.cos);
}

Rect cos(Rect rect) {
    return Rect(rect.position.cos, rect.size.cos);
}

@trusted
float tan(float x) {
    return stdc.tanf(x);
}

@trusted
double tan(double x) {
    return stdc.tan(x);
}

Vec2 tan(Vec2 vec) {
    return Vec2(vec.x.tan, vec.y.tan);
}

Vec3 tan(Vec3 vec) {
    return Vec3(vec.x.tan, vec.y.tan, vec.z.tan);
}

Vec4 tan(Vec4 vec) {
    return Vec4(vec.x.tan, vec.y.tan, vec.z.tan, vec.w.tan);
}

Rect tan(Rect rect) {
    return Rect(rect.position.tan, rect.size.tan);
}

@trusted
float asin(float x) {
    return stdc.asinf(x);
}

@trusted
double asin(double x) {
    return stdc.asin(x);
}

Vec2 asin(Vec2 vec) {
    return Vec2(vec.x.asin, vec.y.asin);
}

Vec3 asin(Vec3 vec) {
    return Vec3(vec.x.asin, vec.y.asin, vec.z.asin);
}

Vec4 asin(Vec4 vec) {
    return Vec4(vec.x.asin, vec.y.asin, vec.z.asin, vec.w.asin);
}

Rect asin(Rect rect) {
    return Rect(rect.position.asin, rect.size.asin);
}

@trusted
float acos(float x) {
    return stdc.acosf(x);
}

@trusted
double acos(double x) {
    return stdc.acos(x);
}

Vec2 acos(Vec2 vec) {
    return Vec2(vec.x.acos, vec.y.acos);
}

Vec3 acos(Vec3 vec) {
    return Vec3(vec.x.acos, vec.y.acos, vec.z.acos);
}

Vec4 acos(Vec4 vec) {
    return Vec4(vec.x.acos, vec.y.acos, vec.z.acos, vec.w.acos);
}

Rect acos(Rect rect) {
    return Rect(rect.position.acos, rect.size.acos);
}

@trusted
float atan(float x) {
    return stdc.atanf(x);
}

@trusted
double atan(double x) {
    return stdc.atan(x);
}

Vec2 atan(Vec2 vec) {
    return Vec2(vec.x.atan, vec.y.atan);
}

Vec3 atan(Vec3 vec) {
    return Vec3(vec.x.atan, vec.y.atan, vec.z.atan);
}

Vec4 atan(Vec4 vec) {
    return Vec4(vec.x.atan, vec.y.atan, vec.z.atan, vec.w.atan);
}

Rect atan(Rect rect) {
    return Rect(rect.position.atan, rect.size.atan);
}

@trusted
float cbrt(float x) {
    return stdc.cbrtf(x);
}

@trusted
double cbrt(double x) {
    return stdc.cbrt(x);
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

T snap(T)(T x, T step) {
    static if (isIntegerType!T) {
        return cast(T) snap!double(cast(double) x, cast(double) step).round();
    } else {
        return (x / step).round() * step;
    }
}

pragma(inline, true)
float lerp(float from, float to, float weight) {
    return from + (to - from) * weight;
}

pragma(inline, true)
double lerp(double from, double to, double weight) {
    return from + (to - from) * weight;
}

float smoothstep(float from, float to, float weight) {
    auto v = weight * weight * (3.0f - 2.0f * weight);
    return (to * v) + (from * (1.0f - v));
}

double smoothstep(double from, double to, double weight) {
    auto v = weight * weight * (3.0 - 2.0 * weight);
    return (to * v) + (from * (1.0 - v));
}

float smootherstep(float from, float to, float weight) {
    auto v = weight * weight * weight * (weight * (weight * 6.0f - 15.0f) + 10.0f);
    return (to * v) + (from * (1.0f - v));
}

double smootherstep(double from, double to, double weight) {
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
double moveTo(double from, double to, double delta) {
    return (abs(to - from) > abs(delta))
        ? from + sign(to - from) * delta
        : to;
}

@trusted
Vec2 moveTo(Vec2 from, Vec2 to, Vec2 delta) {
    Vec2 result = void;
    auto offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) result.x = from.x + offset.x;
    else result.x = to.x;
    if (abs(to.y - from.y) > abs(offset.y)) result.y = from.y + offset.y;
    else result.y = to.y;
    return result;
}

@trusted
Vec3 moveTo(Vec3 from, Vec3 to, Vec3 delta) {
    Vec3 result = void;
    auto offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) result.x = from.x + offset.x;
    else result.x = to.x;
    if (abs(to.y - from.y) > abs(offset.y)) result.y = from.y + offset.y;
    else result.y = to.y;
    if (abs(to.z - from.z) > abs(offset.z)) result.z = from.z + offset.z;
    else result.z = to.z;
    return result;
}

@trusted
Vec4 moveTo(Vec4 from, Vec4 to, Vec4 delta) {
    Vec4 result = void;
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
    if (from.equals(to)) return to;
    auto target = ((from * (slowdown - 1.0f)) + to) / slowdown;
    return from + (target - from) * delta;
}

double moveToWithSlowdown(double from, double to, double delta, double slowdown) {
    if (from.equals(to)) return to;
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

pragma(inline, true)
bool equals(float a, float b, float localEpsilon = epsilon) {
    return abs(a - b) < localEpsilon;
}

pragma(inline, true)
bool equals(double a, double b, double localEpsilon = epsilon) {
    return abs(a - b) < localEpsilon;
}

pragma(inline, true)
bool equals(Vec2 a, Vec2 b, float localEpsilon = epsilon) {
    return equals(a.x, b.x, localEpsilon) && equals(a.y, b.y, localEpsilon);
}

pragma(inline, true)
bool equals(Vec3 a, Vec3 b, float localEpsilon = epsilon) {
    return equals(a.x, b.x, localEpsilon) && equals(a.y, b.y, localEpsilon) && equals(a.z, b.z, localEpsilon);
}

pragma(inline, true)
bool equals(Vec4 a, Vec4 b, float localEpsilon = epsilon) {
    return equals(a.x, b.x, localEpsilon) && equals(a.y, b.y, localEpsilon) && equals(a.z, b.z, localEpsilon) && equals(a.w, b.w, localEpsilon);
}

pragma(inline, true)
float toRadians(float degrees) {
    return degrees * pi180;
}

pragma(inline, true)
double toRadians(double degrees) {
    return degrees * pi180;
}

pragma(inline, true)
float toDegrees(float radians) {
    return radians * dpi180;
}

pragma(inline, true)
double toDegrees(double radians) {
    return radians * dpi180;
}

pragma(inline, true);
Color toRgb(uint rgb) {
    return Color(
        (rgb & 0xFF0000) >> 16,
        (rgb & 0xFF00) >> 8,
        (rgb & 0xFF),
    );
}

pragma(inline, true);
Color toRgba(uint rgba) {
    return Color(
        (rgba & 0xFF000000) >> 24,
        (rgba & 0xFF0000) >> 16,
        (rgba & 0xFF00) >> 8,
        (rgba & 0xFF),
    );
}

pragma(inline, true);
Color toColor(Vec3 vec) {
    return Color(
        cast(ubyte) clamp(vec.x, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.y, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.z, 0.0f, 255.0f),
        255,
    );
}

pragma(inline, true);
Color toColor(Vec4 vec) {
    return Color(
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
Vec4 toVec(Color color) {
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
