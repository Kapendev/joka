# Joka

Joka is a simple nogc utility library for the D programming language.
It provides data structures and functions that work without garbage collection, offering precise memory control and minimal runtime overhead.
The code is rather C-like, so be prepared for that.

## Modules

* joka.ascii: ASCII string utilities
* joka.containers: Heap-allocated data structures
* joka.io: Input and output functions
* joka.math: Mathematical data structures and functions
* joka.types: Type definitions and compile-time utilities

## Basic Data Structures

* Dynamic Array: `List`
* Sparse Array: `SparseList`
* Flattened 2D Array: `Grid`
* Tagged Union: `Variant`
* Arena Allocator: `Arena`

## Attributes and BetterC Support

This project offers support for the `@safe` attribute and aims for good compatibility with BetterC.
If you encounter errors with BetterC, try using the `-i` flag.

## Web Support

This project can be compiled to WebAssembly as it doesn't use the D standard library.
However, since it relies on the C standard library, you will need something like Emscripten to make it work.

## Documentation

Start with the [examples](./examples/) folder for a quick overview.
