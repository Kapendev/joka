# Joka

Joka is a nogc utility library for the D programming language.
It provides data structures and functions that work without garbage collection, offering precise memory control and minimal runtime overhead.
The code is rather C-like, so be prepared for that.

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

## Helper Functions

* String Formatting: `format`
* String Concatenation: `concat`
* Printing: `println`
* ...and more!

## Attributes and BetterC Support

This project offers support for the `@safe` attribute and aims for good compatibility with BetterC.
If you encounter errors with BetterC, try using the `-i` flag.

## Web Support

This project can be compiled to WebAssembly as it doesn't use the D standard library.
However, since it relies on the C standard library, you will need something like Emscripten to make it work.

## Documentation

Start with the [examples](./examples/) folder for a quick overview.

## Questions

### Why nogc?

Because I can do manual memory management.

### Why are you not using X feature?

Because I prefer to support older compilers and keep my code C-like.

### Why not use X nogc library?

Because it's one less dependency for me to manage.
I also prefer code that looks like C, whereas most people write code that looks like C++.

* Most of them love RAII. I don't.
* Most of them love templates. I don't.
* Most of them love compile time flags. I don't.

I like to complain about things, so yeah.
If you love templates, then use them. I support you.
