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

    // Use an arena as the current memory context for types like `List`.
    arena = Arena(buffer);
    with (ScopedMemoryContext(arena)) {
        auto list = List!int(4, 2, 0);
        list.push(6);
        list.push(9);

        auto i = 0;
        trace(list[i++] == 4);
        trace(list[i++] == 2);
        trace(list[i++] == 0);
        trace(list[i++] == 6);
        trace(list[i++] == 9);
        // Don't need to free the list because it's using the arena.
    }
    trace(arena.offset != 0);

    // Sometimes it makes sense to mix a custom memory context with the default one.
    // For example, a function `foo()` needs to allocate things in a specific way.
    // This can be done safely with the `ScopedDefaultMemoryContext` type.
    arena = Arena(buffer);
    with (ScopedMemoryContext(arena)) {
        // Will use the custom memory context in this scope.
        with (ScopedDefaultMemoryContext()) {
            // Will use the default memory context in this scope.
            // This call will leak memory, but it's OK because we want to test things.
            jokaMake!int(999);
        }
    }
}
