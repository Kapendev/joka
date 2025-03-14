# Joka

Joka is a nogc utility library for the D programming language.
It provides data structures and functions that work without garbage collection, offering precise memory control and minimal runtime overhead.

## Modules

* joka.ascii: ASCII string utilities
* joka.containers: Heap-allocated data structures
* joka.io: Input and output functions
* joka.math: Mathematical data structures and functions
* joka.types: Type definitions and compile-time utilities

## Data Structures

* Dynamic Array: `List`
* Flattened 2D Array: `Grid`
* Arena Allocator: `Arena`
* ...and more!

## WebAssembly

This project supports WebAssembly with BetterC, but you'll need something like Emscripten to make it work.
If you encounter errors with BetterC, try using the `-i` flag.

## Questions

### Why nogc?

Because I can do manual memory management.

### Why are you not using X feature?

Because I prefer to support older compilers and keep my code C-like.

### Why are you not using X library?

Because I like code that looks like C, whereas most people write code that looks like C++.
And compile times. Joka compiles **blazingly fast** compared to similar libraries!
