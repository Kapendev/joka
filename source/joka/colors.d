// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.10
// ---

/// The `colors` module provides color-related data structures and functions.
module joka.colors;

import joka.ascii;
import joka.math;
import joka.traits;
import joka.types;

@safe @nogc nothrow:

enum blank   = Color();
enum black   = Color(0);
enum white   = Color(255);

enum red     = Color(255, 0, 0);
enum green   = Color(0, 255, 0);
enum blue    = Color(0, 0, 255);
enum yellow  = Color(255, 255, 0);
enum magenta = Color(255, 0, 255);
enum cyan    = Color(0, 255, 255);

enum gray1   = toRgb(0x202020);
enum gray2   = toRgb(0x606060);
enum gray3   = toRgb(0x9f9f9f);
enum gray4   = toRgb(0xdfdfdf);

alias gray = gray2;

struct Color {
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a;

    enum length = 4;
    enum zero = Color(0, 0, 0, 0);
    enum one = Color(1, 1, 1, 1);

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

    mixin addRgbaOps!(Color, length);

    Color alpha(ubyte a) {
        return Color(r, g, b, a);
    }

    IStr toStr() {
        return "({} {} {} {})".format(r, g, b, a);
    }
}

Color toRgb(uint rgb) {
    return Color(
        (rgb & 0xFF0000) >> 16,
        (rgb & 0xFF00) >> 8,
        (rgb & 0xFF),
    );
}

Color toRgba(uint rgba) {
    return Color(
        (rgba & 0xFF000000) >> 24,
        (rgba & 0xFF0000) >> 16,
        (rgba & 0xFF00) >> 8,
        (rgba & 0xFF),
    );
}

Color toColor(Vec3 vec) {
    return Color(
        cast(ubyte) clamp(vec.x, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.y, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.z, 0.0f, 255.0f),
        255,
    );
}

Color toColor(Vec4 vec) {
    return Color(
        cast(ubyte) clamp(vec.x, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.y, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.z, 0.0f, 255.0f),
        cast(ubyte) clamp(vec.w, 0.0f, 255.0f),
    );
}

Vec4 toVec(Color color) {
    return Vec4(color.r, color.g, color.b, color.a);
}

unittest {
    assert(toRgb(0xff0000) == red);
    assert(toRgb(0x00ff00) == green);
    assert(toRgb(0x0000ff) == blue);

    assert(toRgba(0xff0000ff) == red);
    assert(toRgba(0x00ff00ff) == green);
    assert(toRgba(0x0000ffff) == blue);

    assert(black.toStr() == "(0 0 0 255)");
    assert(black.alpha(69).toStr() == "(0 0 0 69)");
}
