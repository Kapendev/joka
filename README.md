# 🃏 Joka

Joka is a nogc utility library for the [D programming language](https://dlang.org/).
It provides data structures and functions that work without garbage collection, offering precise memory control and minimal runtime overhead.

## Modules

* joka.ascii: ASCII string utilities
* joka.cli: Command-line parsing utilities
* joka.containers: Heap-allocated data structures
* joka.io: Input and output functions
* joka.math: Mathematical data structures and functions
* joka.memory: Functions for dealing with memory
* joka.types: Type definitions and compile-time utilities

## Versions

* JokaCustomMemory: Allows the declaration of custom memory allocation functions (`jokaMalloc`, ...).

## WebAssembly

This project supports WebAssembly with BetterC, but you'll need something like Emscripten to make it work.
If you encounter errors with BetterC, try using the `-i` flag.

## Documentation

Start with the [examples](./examples/) folder for a quick overview.
To try an example, run:

```cmd
rdmd -Isource examples/hello.d
```

## Why are you not using X library?

Because I like code that looks like C, whereas most people write code that looks like C++.
And compile times. Joka compiles **blazingly fast** compared to similar libraries!
