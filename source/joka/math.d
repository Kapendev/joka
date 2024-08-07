// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com

/// The `math` module provides mathematical data structures and functions.
module joka.math;

import joka.ascii;
import joka.stdc;
import joka.traits;
import joka.types;

@safe @nogc nothrow:

enum pi      = 3.1415f;
enum epsilon = 0.0001f;

enum Hook : ubyte {
    topLeft,
    top,
    topRight,
    left,
    center,
    right,
    bottomLeft,
    bottom,
    bottomRight,
}

struct IVec2 {
    int x;
    int y;

    @safe @nogc nothrow:

    enum length = 2;
    enum zero = IVec2(0, 0);
    enum one = IVec2(1, 1);

    pragma(inline, true)
    this(int x, int y) {
        this.x = x;
        this.y = y;
    }

    pragma(inline, true)
    this(int x) {
        this(x, x);
    }

    mixin addXyzwOps!(IVec2, length);

    IStr toStr() {
        return "({} {})".format(x, y);
    }
}

struct IVec3 {
    int x;
    int y;
    int z;

    enum length = 3;
    enum zero = IVec3(0, 0, 0);
    enum one = IVec3(1, 1, 1);

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

    mixin addXyzwOps!(IVec3, length);

    IStr toStr() {
        return "({} {})".format(x, y);
    }
}

struct IVec4 {
    int x;
    int y;
    int z;
    int w;

    enum length = 4;
    enum zero = IVec4(0, 0, 0, 0);
    enum one = IVec4(1, 1, 1, 1);

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

    mixin addXyzwOps!(IVec4, length);

    IStr toStr() {
        return "({} {})".format(x, y);
    }
}

struct Vec2 {
    float x = 0.0f;
    float y = 0.0f;

    enum length = 2;
    enum zero = Vec2(0.0f, 0.0f);
    enum one = Vec2(1.0f, 1.0f);

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

    mixin addXyzwOps!(Vec2, length);

    float magnitude() {
        return sqrt(x * x + y * y);
    }

    Vec2 normalize() {
        auto m = magnitude;
        if (m == 0.0f) {
            return Vec2();
        } else {
            return this / Vec2(m);
        }
    }

    float distanceTo(Vec2 to) {
        return (to - this).magnitude;
    }

    Vec2 directionTo(Vec2 to) {
        return (to - this).normalize();
    }

    IStr toStr() {
        return "({} {})".format(x, y);
    }
}

struct Vec3 {
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;

    enum length = 3;
    enum zero = Vec3(0.0f, 0.0f, 0.0f);
    enum one = Vec3(1.0f, 1.0f, 1.0f);

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

    mixin addXyzwOps!(Vec3, length);

    float magnitude() {
        return sqrt(x * x + y * y + z * z);
    }

    Vec3 normalize() {
        auto m = magnitude;
        if (m == 0.0f) {
            return Vec3();
        } else {
            return this / Vec3(m);
        }
    }

    float distanceTo(Vec3 to) {
        return (to - this).magnitude;
    }

    Vec3 directionTo(Vec3 to) {
        return (to - this).normalize();
    }

    IStr toStr() {
        return "({} {} {})".format(x, y, z);
    }
}

struct Vec4 {
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float w = 0.0f;

    enum length = 4;
    enum zero = Vec4(0.0f, 0.0f, 0.0f, 0.0f);
    enum one = Vec4(1.0f, 1.0f, 1.0f, 1.0f);

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

    mixin addXyzwOps!(Vec4, length);

    float magnitude() {
        return sqrt(x * x + y * y + z * z + w * w);
    }

    Vec4 normalize() {
        auto m = magnitude;
        if (m == 0.0f) {
            return Vec4();
        } else {
            return this / Vec4(m);
        }
    }

    float distanceTo(Vec4 to) {
        return (to - this).magnitude;
    }

    Vec4 directionTo(Vec4 to) {
        return (to - this).normalize();
    }

    IStr toStr() {
        return "({} {} {} {})".format(x, y, z, w);
    }
}

struct Rect {
    Vec2 position;
    Vec2 size;

    enum zero = Rect(0.0f, 0.0f, 0.0f, 0.0f);
    enum one = Rect(1.0f, 1.0f, 1.0f, 1.0f);

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
            case Hook.topLeft: return size * Vec2(0.0f, 0.0f);
            case Hook.top: return size * Vec2(0.5f, 0.0f);
            case Hook.topRight: return size * Vec2(1.0f, 0.0f);
            case Hook.left: return size * Vec2(0.0f, 0.5f);
            case Hook.center: return size * Vec2(0.5f, 0.5f);
            case Hook.right: return size * Vec2(1.0f, 0.5f);
            case Hook.bottomLeft: return size * Vec2(0.0f, 1.0f);
            case Hook.bottom: return size * Vec2(0.5f, 1.0f);
            case Hook.bottomRight: return size * Vec2(1.0f, 1.0f);
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

    bool hasPoint(Vec2 point) {
        return (
            point.x > position.x &&
            point.x < position.x + size.x &&
            point.y > position.y &&
            point.y < position.y + size.y
        );
    }

    bool hasIntersection(Rect area) {
        return (
            position.x + size.x > area.position.x &&
            position.x < area.position.x + area.size.x &&
            position.y + size.y > area.position.y &&
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

    IStr toStr() {
        return "({} {} {} {})".format(position.x, position.y, size.x, size.y);
    }
}

struct Circ {
    Vec2 position;
    float radius = 0.0f;

    enum zero = Circ(0.0f, 0.0f, 0.0f);
    enum one = Circ(1.0f, 1.0f, 1.0f);

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

    IStr toStr() {
        return "({} {} {})".format(position.x, position.y, radius);
    }
}

struct Line {
    Vec2 a;
    Vec2 b;

    enum zero = Line(0.0f, 0.0f, 0.0f, 0.0f);
    enum one = Line(1.0f, 1.0f, 1.0f, 1.0f);

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

    IStr toStr() {
        return "({} {} {} {})".format(a.x, a.y, b.x, b.y);
    }
}

T min(T)(T a, T b) {
    return a < b ? a : b;
}

T max(T)(T a, T b) {
    return a < b ? b : a;
}

T sign(T)(T x) {
    return x < 0 ? -1 : 1;
}

T abs(T)(T x) {
    return x < 0 ? -x : x;
}

IVec2 abs(IVec2 vec) {
    return IVec2(vec.x.abs, vec.y.abs);
}

IVec3 abs(IVec3 vec) {
    return IVec3(vec.x.abs, vec.y.abs, vec.z.abs);
}

IVec4 abs(IVec4 vec) {
    return IVec4(vec.x.abs, vec.y.abs, vec.z.abs, vec.w.abs);
}

Vec2 abs(Vec2 vec) {
    return Vec2(vec.x.abs, vec.y.abs);
}

Vec3 abs(Vec3 vec) {
    return Vec3(vec.x.abs, vec.y.abs, vec.z.abs);
}

Vec4 abs(Vec4 vec) {
    return Vec4(vec.x.abs, vec.y.abs, vec.z.abs, vec.w.abs);
}

Rect abs(Rect rect) {
    return Rect(rect.position.abs, rect.size.abs);
}

float floor(float x) {
    auto xx = cast(float) cast(int) x;
    return (x <= 0.0f && xx != x) ? xx - 1.0f : xx;
}

double floor(double x) {
    auto xx = cast(double) cast(long) x;
    return (x <= 0.0 && xx != x) ? xx - 1.0 : xx;
}

Vec2 floor(Vec2 vec) {
    return Vec2(vec.x.floor, vec.y.floor);
}

Vec3 floor(Vec3 vec) {
    return Vec3(vec.x.floor, vec.y.floor, vec.z.floor);
}

Vec4 floor(Vec4 vec) {
    return Vec4(vec.x.floor, vec.y.floor, vec.z.floor, vec.w.floor);
}

Rect floor(Rect rect) {
    return Rect(rect.position.floor, rect.size.floor);
}

float ceil(float x) {
    auto xx = cast(float) cast(int) x;
    return (x <= 0.0f || xx == x) ? xx : xx + 1.0f;
}

double ceil(double x) {
    auto xx = cast(double) cast(long) x;
    return (x <= 0.0 || xx == x) ? xx : xx + 1.0;
}

Vec2 ceil(Vec2 vec) {
    return Vec2(vec.x.ceil, vec.y.ceil);
}

Vec3 ceil(Vec3 vec) {
    return Vec3(vec.x.ceil, vec.y.ceil, vec.z.ceil);
}

Vec4 ceil(Vec4 vec) {
    return Vec4(vec.x.ceil, vec.y.ceil, vec.z.ceil, vec.w.ceil);
}

Rect ceil(Rect rect) {
    return Rect(rect.position.ceil, rect.size.ceil);
}

float round(float x) {
    return x <= 0.0f ? cast(float) cast(int) (x - 0.5f) : cast(float) cast(int) (x + 0.5f);
}

double round(double x) {
    return x <= 0.0 ? cast(double) cast(long) (x - 0.5) : cast(double) cast(long) (x + 0.5);
}

Vec2 round(Vec2 vec) {
    return Vec2(vec.x.round, vec.y.round);
}

Vec3 round(Vec3 vec) {
    return Vec3(vec.x.round, vec.y.round, vec.z.round);
}

Vec4 round(Vec4 vec) {
    return Vec4(vec.x.round, vec.y.round, vec.z.round, vec.w.round);
}

Rect round(Rect rect) {
    return Rect(rect.position.round, rect.size.round);
}

@trusted
float sqrt(float x) {
    return sqrtf(x);
}

@trusted
double sqrt(double x) {
    return .sqrt(x);
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
    return sinf(x);
}

@trusted
double sin(double x) {
    return .sin(x);
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
    return cosf(x);
}

@trusted
double cos(double x) {
    return .cos(x);
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

T clamp(T)(T x, T a, T b) {
    return x <= a ? a : x >= b ? b : x;
}

T wrap(T)(T x, T a, T b) {
    auto result = x;
    while (result < a) {
        result += b - a;
    }
    while (result >= b) {
        result -= b - a;
    }
    return result;
}

float lerp(float from, float to, float weight) {
    return from + (to - from) * weight;
}

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

float moveTo(float from, float to, float delta) {
    if (abs(to - from) > abs(delta)) return from + sign(to - from) * delta;
    else return to;
}

double moveTo(double from, double to, double delta) {
    if (abs(to - from) > abs(delta)) return from + sign(to - from) * delta;
    else return to;
}

Vec2 moveTo(Vec2 from, Vec2 to, Vec2 delta) {
    Vec2 result = void;
    Vec2 offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) {
        result.x = from.x + offset.x;
    } else {
        result.x = to.x;
    }
    if (abs(to.y - from.y) > abs(offset.y)) {
        result.y = from.y + offset.y;
    } else {
        result.y = to.y;
    }
    return result;
}

Vec3 moveTo(Vec3 from, Vec3 to, Vec3 delta) {
    Vec3 result = void;
    Vec3 offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) {
        result.x = from.x + offset.x;
    } else {
        result.x = to.x;
    }
    if (abs(to.y - from.y) > abs(offset.y)) {
        result.y = from.y + offset.y;
    } else {
        result.y = to.y;
    }
    if (abs(to.z - from.z) > abs(offset.z)) {
        result.z = from.z + offset.z;
    } else {
        result.z = to.z;
    }
    return result;
}

Vec4 moveTo(Vec4 from, Vec4 to, Vec4 delta) {
    Vec4 result = void;
    Vec4 offset = from.directionTo(to) * delta;
    if (abs(to.x - from.x) > abs(offset.x)) {
        result.x = from.x + offset.x;
    } else {
        result.x = to.x;
    }
    if (abs(to.y - from.y) > abs(offset.y)) {
        result.y = from.y + offset.y;
    } else {
        result.y = to.y;
    }
    if (abs(to.z - from.z) > abs(offset.z)) {
        result.z = from.z + offset.z;
    } else {
        result.z = to.z;
    }
    if (abs(to.w - from.w) > abs(offset.w)) {
        result.w = from.w + offset.w;
    } else {
        result.w = to.w;
    }
    return result;
}

float moveToWithSlowdown(float from, float to, float delta, float slowdown) {
    auto target = ((from * (slowdown - 1.0f)) + to) / slowdown;
    auto offset = target - from;
    if (abs(offset) > abs(delta)) return from + offset * delta;
    else return to;
}

double moveToWithSlowdown(double from, double to, double delta, double slowdown) {
    auto target = ((from * (slowdown - 1.0)) + to) / slowdown;
    auto offset = target - from;
    if (abs(offset) > abs(delta)) return from + offset * delta;
    else return to;
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

bool equals(float a, float b) {
    return abs(a - b) < epsilon;
}

bool equals(double a, double b) {
    return abs(a - b) < epsilon;
}

bool equals(Vec2 a, Vec2 b) {
    return equals(a.x, b.x) && equals(a.y, b.y);
}

bool equals(Vec3 a, Vec3 b) {
    return equals(a.x, b.x) && equals(a.y, b.y) && equals(a.z, b.z);
}

bool equals(Vec4 a, Vec4 b) {
    return equals(a.x, b.x) && equals(a.y, b.y) && equals(a.z, b.z) && equals(a.w, b.w);
}

IVec2 toIVec(Vec2 vec) {
    return IVec2(cast(int) vec.x, cast(int) vec.y);
}

IVec3 toIVec(Vec3 vec) {
    return IVec3(cast(int) vec.x, cast(int) vec.y, cast(int) vec.z);
}

IVec4 toIVec(Vec4 vec) {
    return IVec4(cast(int) vec.x, cast(int) vec.y, cast(int) vec.z, cast(int) vec.w);
}

Vec2 toVec(IVec2 vec) {
    return Vec2(vec.x, vec.y);
}

Vec3 toVec(IVec3 vec) {
    return Vec3(vec.x, vec.y, vec.z);
}

Vec4 toVec(IVec4 vec) {
    return Vec4(vec.x, vec.y, vec.z, vec.w);
}