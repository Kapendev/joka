# 🃏 Joka

A nogc utility library for the [D programming language](https://dlang.org/).
Joka provides data structures and functions that can work without garbage collection, offering precise memory control.
It is designed to complement the D standard library, not replace it.

```d
/// Arrays, printing, and string interpolation.
import joka;

void main() {
    auto numbers = List!int(4, 6, 8);
    scope (exit) numbers.free();
    foreach (i, number; numbers) {
        println(i"[$(i)]: $(number)");
    }
}
```

## Why Joka

- **Minimalistic**: Avoids many abstractions
- **Focused**: Doesn't try to support every use case
- **Simple**: Uses a single global allocator set at compile time
- **Friendly**: Memory-safety features and many examples
- **BetterC**: Fully compatible via `-betterC -i`

### Performance Benchmark

Here's a [comparison](benchmarks/array_append_remove) of Joka's dynamic array versus other popular libraries when appending and removing 100,000,000 integers on a **Ryzen 3 2200G** with **16 GB of memory**:

```d
Append 100000000 items with `int[]`: 2495 ms
Remove 100000000 items with `int[]`: 258 ms
Append 100000000 items with `Array!int`: 514 ms
Remove 100000000 items with `Array!int`: 0 ms
Append 100000000 items with `Appender!int`: 498 ms
Remove 100000000 items with `Appender!int`: 0 ms
Append 100000000 items with `nulib`: 16812 ms
Remove 100000000 items with `nulib`: 423 ms
Append 100000000 items with `emsi`: 16077 ms
Remove 100000000 items with `emsi`: 246 ms
Append 100000000 items with `memutils`: 332 ms
Remove 100000000 items with `memutils`: 0 ms
Append 100000000 items with `automem`: 629 ms
Remove 100000000 items with `automem`: 0 ms
Append 100000000 items with `joka`: 140 ms
Remove 100000000 items with `joka`: 0 ms
```

Below are also some high-level cross-language results using a similar workload.
These are **not direct benchmarks** and are intended only as a point of reference:

```py
Appending and removing 100000000 items...
Testing: ./app_d
real 0.16
Testing: ./app_zig
real 0.18
Testing: ./app_odin
real 0.27
```

> [!NOTE]
> The project is still early in development.
> If something is missing, it will probably be added when someone (usually the main developer) needs it.

## Quick Start

This guide shows how to install Joka using [DUB](https://dub.pm/).
Create a new folder and run inside the following commands:

```sh
dub init -n
dub add joka
```

That's it. Copy-paste one of the [examples](./examples/) to make sure everything is set up correctly.

## Documentation

Start with the [examples](./examples/) folder for a quick overview.

### Modules

- [`joka.io`](./source/joka/io.d): Input and output procedures.
- [`joka.math`](./source/joka/math.d): Mathematics.
- [`joka.memory`](./source/joka/memory.d): Memory utilities and containers.
- [`joka.ranges`](./source/joka/ranges.d): Range utilities.
- [`joka.types`](./source/joka/types.d): Common type definitions and ASCII strings.
- [`joka.stdc`](./source/joka/stdc.d): C standard library functions.

### Versions

- `JokaCustomMemory`: Allows the declaration of custom allocation functions.
- `JokaGcMemory`: Like `JokaCustomMemory`, but preconfigured to use the D garbage collector.
- `JokaPhobosStdc`: Uses the Phobos libc bindings instead of Joka's `stdc.d` module when possible.
- `JokaGlobalTracking`: Disables thread-local storage for `_memoryTrackingState`.
- `JokaSmallFootprint`: Uses less memory for some static buffers in Joka.
- `JokaNoTypes`: Disables the dependency on `types.d` for some modules and uses internal stubs instead.
- `JokaRuntimeSymbols`: Allows defining required runtime symbols when they are missing.

### Memory Tracking

Joka includes a lightweight memory tracking system that can detect leaks or invalid frees in debug builds.
By default, the helper function `memoryTrackingInfo` produces output like this:

```
Memory Leaks: 4 (total 699 bytes, 5 ignored)
  1 leak, 20 bytes, source/app.d:24
  1 leak, 53 bytes, source/app.d:31
  2 leak, 32 bytes, source/app.d:123
```

The leak summary above can be filtered, showing only leaks with paths containing the filter string.
For example, `memoryTrackingInfo("app.d")` shows only leaks with `"app.d"` in the path.
Specific allocations can be ignored with `ignoreLeak` like this:

```d
// struct Game { int hp; int mp; }
// Game* game;
game = jokaMake!Game().ignoreLeak();
```

Allocations can also be grouped to make it easier to understand what each allocation is used for with `AllocationGroup` like this:

```d
// This can also be done with the `beginAllocationGroup` and `endAllocationGroup` functions.
with (AllocationGroup("World")) {
    allocateMonsters();
    allocateActors();
    with (AllocationGroup("Contents")) {
        allocateItems();
        allocateEvents();
    }
}
allocateText(); // Not part of any group.
```

You can check whether memory tracking is active with `static if (isTrackingMemory)`, and if it is, you can inspect the current tracking state via `_memoryTrackingState`.
`_memoryTrackingState` is thread-local, so each thread has its own separate tracking state.

### Standalone `memory.d`

It's possible to just use the allocation part of the code without a full dependency on Joka.
To do this, copy `memory.d` and `types.d` into a project and use one of the following versions:

- `JokaPhobosStdc`: Recommended for "just works" things.
- `JokaCustomMemory`: Recommended for when total control is needed.
- `JokaGcMemory`: Like `JokaCustomMemory`, but preconfigured to use the D garbage collector.

### Standalone `math.d`

It's also possible to just use the math part without a full dependency on Joka.
Copy `math.d` and `types.d` (optional with `JokaNoTypes`) into a project and use `JokaPhobosStdc`.

## Frequently Asked Questions

### Does Joka have an allocator API?

No. Joka is designed to feel a bit like the C standard library because that's easier for most people to understand and keeps the library simple.
The lack of it isn't a problem thanks to how Joka's containers handle allocation.

### Does Joka have a global context like Jai?

No. A public global context tends to make generic low-level APIs fragile.
One cited reason for such a system is the ability to [intercept third-party code](https://odin-lang.org/docs/faq/#what-is-the-context-system-for) and change its behavior.
Joka deliberately avoids this because APIs are designed with specific assumptions and breaking those from the outside can introduce subtle bugs.

The terms "intercept" and "third-party" are often used loosely from what I have seen.
For example, the communities around the Odin and C3 languages frequently rely on context changes even within their own APIs, treating them as part of the public interface.
Calling this system "interception" is a bit misleading when it is [the intended way](https://www.gingerbill.org/article/2025/12/15/odins-most-misunderstood-feature-context/#user_ptr-and-user_index) to use the API.

### Why aren't some functions `@nogc`?

Because the D garbage collector can be used to allocate memory with the `JokaGcMemory` version.
The `@nogc` attribute is just a hint to the compiler, telling it to check that called functions also carry that hint.
It can be helpful but not essential for writing GC-free code.

For example, consider this function:

```d
char[] temporaryString() {
    static char[64][32] buffers = void;
    static currentBuffer = 0;

    currentBuffer = (currentBuffer + 1) % buffers.length;
    return buffers[currentBuffer][];
}
```

This function uses a static buffer to create a temporary string at runtime.
It never allocates with the GC, so it is a nogc function in practice, but it is not a `@nogc` function.
If you try to call it from a `@nogc` function, the compiler will reject it simply because the attribute is missing.
What this shows is that attributes in D are not a memory management tool.

For what it's worth, I don't use attributes in my own projects except for libraries.
I recommend avoiding them most of the time, especially if you're new to D.

### Why are you supporting the D garbage collector?

It's another tool for memory management.
Joka normally uses a tracking allocator in debug builds to help identify mistakes, but the `JokaGcMemory` version exists for people who prioritize safety.
This approach is similar to the one used in [Fil-C](https://fil-c.org/).

### Is it hard to mix Joka with other D libraries?

No. Joka doesn't impose arbitrary restrictions on code, so it works smoothly with Phobos or other libraries.
Some libraries choose to be `@safe`, `@nogc`, or `nothrow` only, but those are their constraints, not Joka's.

I avoid the "attribute-oriented" style of structuring a project entirely.

### Is WebAssembly supported?

Yes. WebAssembly is supported with the `betterC` flag, but a tool like [Emscripten](https://emscripten.org/) is required.
In case of errors, the `i` flag may help. The combination `-betterC -i` works in most cases.

### Why isn't there a `jokaFreeSlice` function?

Because slices are meant to be used like arrays, not pointers.
They also show up everywhere in D code, meaning it would be far too easy to free the wrong one by accident.
Using `jokaFree(slice.ptr)` avoids that. It makes the unsafe part obvious and helps prevent mistakes.
Another benefit is that it's easier to reason about.
Joka has only one function that frees memory.

For context, the Odin language has three functions for freeing memory:

- `free`
- `free_all`
- `delete`

It might be hard to tell what each one does just from the name if you are new to Odin.
The one that frees memory using slices is `delete`. It looks like this when used:

```odin
main :: proc() {
    buffer: [256]u8    // Create a buffer on the stack.
    slice := buffer[:] // Take a slice from the buffer.
    // ...
    delete(slice)      // Try to free the memory.
}
```

To sum up, Joka is trying to be simple and safe about this.

### What are common `betterC` errors?

1. Using `betterC` as a global `@nogc` attribute.
    This flag does more than just remove the garbage collector and adds extra checks that can sometimes be overly restrictive.
    If writing GC-free code is important and compiler assistance is really needed, then add `@nogc:` at the top of every file.

2. Using `betterC` without the `i` flag.
    The combination `-betterC -i` works in most cases and is recommended for anyone still learning D.

3. `TypeInfo` errors. Search for `new` in the source code and remove it.

4. Using `struct[N]`.
    Some parts of the D runtime (`_memsetn`, ...) are needed when using types like this and they can be missing due to how `betterC` works.
    The solution for static arrays is to implement the missing functions or use a custom static array type (`StaticArray` in `joka.types`).

5. String errors.
    It's common to want to use functions to create strings at compile time, but this gets harder to do because of some extra checks added by the `betterC` flag.
    Below is a function that creates a string the "normal" way, followed by an alternative that works with the flag:

    ```d
    // Works without `betterC`.
    // The parameter can come from runtime or compile time.
    string createString(string value) {
        return value ~ ";\n";
    }

    // Works with `betterC`.
    // The parameter must be known at compile time.
    string createString(string value)() {
        return value ~ ";\n";
    }
    ```

### What is Joka used for?

It's primarily used for [Parin](https://github.com/Kapendev/parin), a game engine.

### Why use D without the GC?

Because manual memory management is fun!

### The end?

[Yes.](https://youtu.be/jqKCwHHZH98?si=tWS3I68b8CaDzy-V)
