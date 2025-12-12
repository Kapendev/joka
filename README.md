# 🃏 Joka

A nogc utility library for the [D programming language](https://dlang.org/).
Joka provides data structures and functions that can work without garbage collection, offering precise memory control.
It is designed to complement the D standard library, not replace it.

```d
/// Vectors, printing, and string interpolation.

import joka;

void main() {
    auto a = IVec3(9, 4, 6);
    auto b = a.swizzle("zxx").chop();
    println(i"From $(a) to $(b)."); // From (9 4 6) to (6 9).
}
```

## Why Joka

- Minimalistic: Avoids many abstractions
- Focused: Doesn't try to support every use case
- Simple: Uses a single global allocator set at compile time
- Friendly: Memory-safety features and many examples
- WebAssembly: It just works

> [!NOTE]
> The project is still early in development.
> If something is missing, it will probably be added when someone (usually the main developer) needs it.

## WebAssembly Support

WebAssembly is supported with the `betterC` flag, but a tool like [Emscripten](https://emscripten.org/) is required.
In case of errors, the `i` flag may help. The combination `-betterC -i` works in most cases.

## Memory Tracking

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

## Core Types

Containers tend to be configurable through these types, giving full control over how memory is allocated and avoiding the need for a complicated allocator API:

- `List`: Dynamic array using the global allocator
- `FixedList`: Dynamic array allocated on the stack
- `BufferList`: Dynamic array backed by caller-provided memory
- `Arena`: Bump allocator backed by caller-provided memory or the global allocator
- `GrowingArena`: Bump allocator that expands dynamically using the global allocator

## Modules

- `joka.algo`: Range utilities
- `joka.ascii`: ASCII string utilities
- `joka.cli`: Command-line parsing utilities
- `joka.containers`: General-purpose containers
- `joka.interpolation`: [IES](https://dlang.org/spec/istring.html) support
- `joka.io`: Input and output functions
- `joka.math`: Mathematical data structures and functions
- `joka.memory`: Functions for dealing with memory
- `joka.types`: Common type definitions
- `joka.stdc`: C standard library functions

## Versions

- `JokaCustomMemory`: Allows the declaration of custom memory allocation functions
- `JokaGcMemory`: Like `JokaCustomMemory`, but preconfigured to use the D garbage collector

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

## Frequently Asked Questions

### Does Joka have an allocator API?

No. Joka is designed to feel a bit like the C standard library because that's easier for most people to understand and keeps the library simple. The lack of them isn't a problem thanks to how Joka's core types handle allocation.

### Does Joka have a global context like Jai?

No. A public global context tends to make generic low-level APIs fragile.
That doesn't mean it's a bad idea. It can be useful for libraries with a specific purpose, such as UI frameworks.

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

Oops! To sum up, Joka is trying to be simple and safe about this.

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
What this shows is that attributes in D are a design tool, not a memory management tool.

For what it's worth, I (Kapendev) don't use attributes in my own projects except for libraries.
I recommend avoiding them most of the time, especially if you're new to D.

### Why are you supporting the D garbage collector?

It's another tool for memory management.
Joka normally uses a tracking allocator in debug builds to help identify mistakes, but the `JokaGcMemory` version exists for people who prioritize safety.
This approach is similar to the one used in [Fil-C](https://fil-c.org/).

### What is Joka used for?

It's primarily used for [Parin](https://github.com/Kapendev/parin), a game engine.

### What are common `betterC` errors and how do I fix them?

1. Using `betterC` as a global `@nogc` attribute.
    This flag does more than just remove the garbage collector and adds extra checks that can sometimes be overly restrictive.
    If writing GC-free code is important and compiler assistance is really needed, then add `@nogc:` at the top of every file.

2. Using `betterC` without the `i` flag.
    The combination `-betterC -i` works in most cases and is recommended for anyone still learning D.

3. Using `struct[N]`.
    Some parts of the D runtime (`_memsetn`, ...) are needed when using types like this and they can be missing due to how `betterC` works.
    The solution is to implement the missing functions or use a custom static array type ([./source/joka/types.d:61](https://github.com/Kapendev/joka/blob/main/source/joka/types.d#L61)).

4. `TypeInfo` errors. Search for `new` in the source code and remove it.

### Why use D without the GC?

Because manual memory management is fun!

### The end?

[Yes.](https://youtu.be/jqKCwHHZH98?si=tWS3I68b8CaDzy-V)
