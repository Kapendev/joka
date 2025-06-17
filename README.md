# 🃏 Joka

A nogc utility library for the [D programming language](https://dlang.org/).
Joka provides data structures and functions that work without garbage collection, offering precise memory control and minimal runtime overhead.

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

This project supports WebAssembly with BetterC, but you'll need something like Emscripten to make it work.
If you encounter errors with BetterC, try using the `-i` flag.

## Documentation

Start with the [examples](./examples/) folder for a quick overview.
To try an example, run:

```cmd
rdmd -Isource examples/_001_hello.d
```

## Frequently Asked Questions

### Why aren't you using X library?

Here are a few things I like about Joka that I don't see in other libraries:

* Minimalistic: Avoids unnecessary abstractions.
* Focused: Doesn't try to support every use case.
* Simple: Uses a single global allocator, set at compile time.
* Fast: Compile times are **blazingly fast**!

### Why don't you use feature X?

I prioritize supporting older compilers to ensure broader compatibility.

### Why aren't some functions `@nogc`?

Because the D garbage collector can be used as a global allocator.

## TODO

* Add float16 type.
* Add utf8 stuff.
* Maybe think about IO.
* Maybe "copy-paste" this thing: [subprocess.h](https://github.com/sheredom/subprocess.h)
