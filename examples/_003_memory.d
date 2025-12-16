/// This example shows how allocate and free memory with Joka.

import joka;

void main() {
    // Joka uses a tracking allocator for debug builds.
    scope (exit) print(memoryTrackingInfo);

    // Allocate a single number.
    auto x = jokaMake!int(999);
    scope (exit) jokaFree(x);
    trace(*x);

    // Allocate an array of 16 numbers.
    auto slice = jokaMakeSlice!int(16);
    scope (exit) jokaFree(slice.ptr);
    trace(slice.length);

    // Group allocations to make memory tracking clearer and more organized.
    with (AllocationGroup("Part 3")) {
        jokaMakeSlice!char("I like D.").ptr.jokaFree();
        jokaMakeSlice!char("I also like C.").ptr.jokaFree();
    }

    // Allocate 1KB of memory using an arena.
    auto arena1 = Arena(1024);
    scope (exit) arena1.free();
    auto a = arena1.make!char('D');
    auto b = arena1.make!long(4);
    trace(*a, *b);
    arena1.clear();

    // Arenas can also use external memory.
    ubyte[1024] buffer = void;
    auto arena2 = Arena(buffer);
    a = arena2.make!char('C');
    b = arena2.make!long(99);
    trace(*a, *b);
    arena2.clear();

    // A scoped version of an arena clears its memory automatically at the end of the block.
    auto arena3 = Arena(buffer);
    with (ScopedArena(arena3)) {
        make!char('C');
        with (ScopedArena(arena3)) {
            make!short(2);
            make!char('D');
            trace(arena3.offset == 5);
        }
        trace(arena3.offset == 1);
    }
    trace(arena3.offset == 0);
}
