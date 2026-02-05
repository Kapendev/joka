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
    ubyte[1024] buffer = void;
    auto arena = Arena(buffer);
    auto a = arena.make!char('C');
    auto b = arena.make!long(99);
    trace(*a, *b);
    arena.clear();

    // A scoped version of an arena clears its memory automatically at the end of the block.
    arena = Arena(buffer);
    with (ScopedArena(arena)) {
        make!char('C');
        with (ScopedArena(arena)) {
            make!short(2);
            make!char('D');
            trace(arena.offset == 5);
        }
        trace(arena.offset == 1);
    }
    trace(arena.offset == 0);
}
