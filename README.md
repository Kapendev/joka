# 🃏 Joka

A nogc utility library for the [D programming language](https://dlang.org/).
Joka provides data structures and functions that work without garbage collection, offering precise memory control.
It is designed to complement the D standard library, not replace it.

## Modules

* `joka.ascii`: ASCII string utilities
* `joka.cli`: Command-line parsing utilities
* `joka.containers`: General-purpose containers
* `joka.io`: Input and output functions
* `joka.math`: Mathematical data structures and functions
* `joka.memory`: Functions for dealing with memory
* `joka.types`: Type definitions and compile-time utilities

## Versions

* `JokaCustomMemory`: Allows the declaration of custom memory allocation functions
* `JokaGcMemory`: Like `JokaCustomMemory`, but preconfigured to use the D garbage collector

## WebAssembly

WebAssembly is supported with the `betterC` flag, but something like [Emscripten](https://emscripten.org/) is needed to make it work.
If you encounter errors, try using: `-betterC -i`

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
* Friendly: Memory-safety features and many examples

### Does Joka have an allocator API?

No. Joka is designed to feel a bit like the C standard library because that's easier for most people to understand and keeps the library simple.
This approach also lets memory-safety features, like allocation tracking, work more effectively than they would with a generic allocator API.

### Why aren't some functions `@nogc`?

Because the D garbage collector can be used as a global allocator.

### Why are you supporting the D garbage collector?

Because I can and it's useful sometimes.

### What are you using Joka for?

Primarily for [Parin](https://github.com/Kapendev/parin), a game engine I'm working on.

## TODO

* Maybe think about IO.
* Maybe "copy-paste" this thing: [subprocess.h](https://github.com/sheredom/subprocess.h)
