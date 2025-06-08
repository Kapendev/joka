/// This example shows how allocate and free memory with Joka.

import joka;

void main() {
    // Allocate a single number.
    auto x = jokaMake!int(999);
    scope (exit) jokaFree(x);
    trace(*x);

    // Allocate an array of 16 numbers.
    auto slice = jokaMakeSlice!int(16);
    scope (exit) jokaFree(slice.ptr);
    trace(slice.length);

    // Allocate 1KB of memory using an arena.
    auto arena = Arena(1024);
    scope (exit) arena.free();
    auto a = arena.make!char('D');
    auto b = arena.make!long(4);
    trace(*a, *b);
    arena.clear();
}
