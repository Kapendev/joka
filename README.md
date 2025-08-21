# 🃏 Joka

A nogc utility library for the [D programming language](https://dlang.org/).
Joka provides data structures and functions that work without garbage collection, offering precise memory control.
It is designed to complement the D standard library, not replace it.

## Modules

* `joka.ascii`: ASCII string utilities
* `joka.cli`: Command-line parsing utilities
* `joka.containers`: Heap-allocated data structures
* `joka.io`: Input and output functions
* `joka.math`: Mathematical data structures and functions
* `joka.memory`: Functions for dealing with memory
* `joka.types`: Type definitions and compile-time utilities

## Versions

* `JokaCustomMemory`: Allows the declaration of custom memory allocation functions
* `JokaGcMemory`: Like `JokaCustomMemory`, but preconfigured to use the D garbage collector

## WebAssembly

WebAssembly is supported with BetterC, but something like [Emscripten](https://emscripten.org/) is needed to make it work.
If you encounter errors with BetterC, try using the `-i` flag.

## Documentation

Start with the [examples](./examples/) folder for a quick overview.
To try an example, run:

```sh
./scripts/run_example examples/_001_hello.d
# Or: .\scripts\run_example.bat examples\_001_hello.d
# Or: ./scripts/run_example examples/_001_hello.d ldc2
```

## Frequently Asked Questions

### Why aren't you using X library?

Here are a few things I like about Joka that I don't see in other libraries:

* Minimalistic: Avoids abstractions
* Focused: Doesn't try to support every use case
* Simple: Uses a single global allocator, set at compile time
* Fast: Compile times are **blazingly fast**
* Friendly: Includes many examples

### Why aren't some functions `@nogc`?

Because the D garbage collector can be used as a global allocator.

### Why are you supporting the D garbage collector?

Because I can and it's useful sometimes.

### What are you using Joka for?

Primarily for [Parin](https://github.com/Kapendev/parin), a game engine I'm working on.

## TODO

* Maybe think about IO.
* Maybe "copy-paste" this thing: [subprocess.h](https://github.com/sheredom/subprocess.h)
