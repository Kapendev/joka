# 🃏 Joka

A nogc utility library for the [D programming language](https://dlang.org/).
Joka provides data structures and functions that can work without garbage collection, offering precise memory control.
It is designed to complement the D standard library, not replace it.

## Why Joka

* Minimalistic: Avoids abstractions
* Focused: Doesn't try to support every use case
* Simple: Uses a single global allocator, set at compile time
* Friendly: Memory-safety features and many examples

## WebAssembly Support

WebAssembly is supported with the `betterC` flag, but a tool like [Emscripten](https://emscripten.org/) is required. In case of errors, the `i` flag may help. The combination `-betterC -i` works in most cases.

## Modules

* `joka.algo`: Range utilities
* `joka.ascii`: ASCII string utilities
* `joka.cli`: Command-line parsing utilities
* `joka.containers`: General-purpose containers
* `joka.interpolation`: [IES](https://dlang.org/spec/istring.html) support
* `joka.io`: Input and output functions
* `joka.math`: Mathematical data structures and functions
* `joka.memory`: Functions for dealing with memory
* `joka.types`: Common type definitions
* `joka.stdc`: C standard library functions

## Versions

* `JokaCustomMemory`: Allows the declaration of custom memory allocation functions
* `JokaGcMemory`: Like `JokaCustomMemory`, but preconfigured to use the D garbage collector

## Documentation

Start with the [examples](./examples/) folder for a quick overview.

## Frequently Asked Questions

### Does Joka have an allocator API?

No. Joka is designed to feel a bit like the C standard library because that's easier for most people to understand and keeps the library simple.

### Will Joka get a global context like Jai?

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
The one that frees memory using slices is `delete`.

```odin
main :: proc() {
    buffer: [256]u8    // Create a buffer on the stack.
    slice := buffer[:] // Take a slice from the buffer.
    // ...
    delete(slice)      // Try to free the memory.
}
```

Oops. To be fair, Odin does this because the alternative would be more verbose.

```odin
main :: proc() {
    buffer: [256]u8
    slice := buffer[:]
    // ...
    free(raw_data(slice))
}
```

To sum up, Joka is trying to be safe about this.

### Why aren't some functions `@nogc`?

Because the D garbage collector can be used to allocate memory with the `JokaGcMemory` version.
The `@nogc` attribute is just a hint to the compiler, telling it to check that called functions also carry that hint.
It can be helpful but not essential for writing GC-free code.
Attributes are a design tool, not a memory management tool.

### Why are you supporting the D garbage collector?

It's another tool for memory management.
Joka normally uses a tracking allocator in debug builds to help identify mistakes, but the `JokaGcMemory` version exists for people who prioritize safety.
This approach is similar to the one used in [Fil-C](https://fil-c.org/).

### Any examples that use the tracking allocator?

* [Joka examples](./examples/_003_memory.d)
* [Parin](https://github.com/Kapendev/parin/blob/main/TOUR.md#memory-tracking)

### What is Joka used for?

It's primarily used for [Parin](https://github.com/Kapendev/parin), a game engine.

### What are common `betterC` errors and how do I fix them?

1. Using `betterC` as a global `@nogc` attribute.
    This flag does more than just remove the garbage collector and adds extra checks that can sometimes be overly restrictive.
    If writing GC-free code is important and compiler assistance is really needed, then add `@nogc:` at the top of every file.
    To reiterate, the `@nogc` attribute is just a hint to the compiler, telling it to check that called functions also carry that hint.
    It can be helpful but not essential for writing GC-free code.

2. Using `betterC` without the `i` flag.
    The combination `-betterC -i` works in most cases and is recommended for anyone still learning D.

3. Using `struct[N]`.
    Some parts of the D runtime (`_memsetn`, ...) are needed when using types like this and they can be missing due to how `betterC` works.
    The solution is to implement the missing functions or use a custom static array type ([./source/joka/types.d:61](https://github.com/Kapendev/joka/blob/main/source/joka/types.d#L61)).

4. `TypeInfo` errors. Search for `new` in the source code and remove it.
