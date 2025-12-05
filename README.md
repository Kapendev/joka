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

### Why aren't some functions `@nogc`?

Because the D garbage collector can be used to allocate memory with the `JokaGcMemory` version.

### Why are you supporting the D garbage collector?

It's another tool for memory management.
Joka normally uses a tracking allocator in debug builds to help identify mistakes, but the `JokaGcMemory` version exists for people who prioritize safety.
This approach is similar to the one used in [Fil-C](https://fil-c.org/).

### What is Joka used for?

It's primarily used for [Parin](https://github.com/Kapendev/parin), a game engine.
