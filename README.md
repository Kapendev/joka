# Joka

Joka is a simple nogc utility library for the D programming language.
It provides data structures and functions that work without garbage collection, offering precise memory control and minimal runtime overhead.

> [!WARNING]  
> This is alpha software. Use it only if you are very cool.

## Data Structures

* [x] Dynamic Array (`List`)
* [x] Sparse Array (`SparseList`)
* [x] Generational Array (`GenerationalList`)
* [x] Flattened 2D Array (`Grid`)
* [x] Tagged Union (`Variant`)
* [ ] Hash Table
* [ ] Arena Allocator

## Attributes and BetterC Support

This project offers support for the `@safe` attribute and aims for good compatibility with BetterC.
If you encounter errors with BetterC, try using the `-i` flag.

## Web Support

This project can be compiled to WebAssembly as it doesn't use the D standard library.
However, since it relies on the C standard library, you will need something like Emscripten to make it work.

## Note

I add things to Joka when I need them.

## License

The project is released under the terms of the MIT License.
Please refer to the LICENSE file.
