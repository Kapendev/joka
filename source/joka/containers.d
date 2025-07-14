// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// ---

/// The `containers` module provides various data structures that allocate on the heap.
module joka.containers;

import joka.ascii;
import joka.memory;
import joka.types;

@safe nothrow:

enum defaultListCapacity = 16; /// The default list capacity. It is also the smallest list capacity.

alias LStr   = List!char;  /// A dynamic string of chars.
alias LStr16 = List!wchar; /// A dynamic string of wchars.
alias LStr32 = List!dchar; /// A dynamic string of dchars.

alias FStr(Sz N)   = FixedList!(char, N);  /// A dynamic string of chars allocated on the stack.
alias FStr16(Sz N) = FixedList!(wchar, N); /// A dynamic string of wchars allocated on the stack.
alias FStr32(Sz N) = FizedList!(dchar, N); /// A dynamic string of dchars allocated on the stack.

/// A dynamic array.
struct List(T) {
    T[] items;
    Sz capacity;

    @safe nothrow:

    mixin addSliceOps!(List!T, T);

    pragma(inline, true)
    this(const(T)[] args...) {
        append(args);
    }

    pragma(inline, true) @nogc
    Sz length() {
        return items.length;
    }

    pragma(inline, true) @trusted @nogc
    T* ptr() {
        return items.ptr;
    }

    @nogc
    bool isEmpty() {
        return length == 0;
    }

    @trusted
    void appendBlank() {
        Sz newLength = length + 1;
        if (newLength > capacity) {
            capacity = jokaFindListCapacity(newLength);
            items = (cast(T*) jokaRealloc(items.ptr, capacity * T.sizeof))[0 .. newLength];
        } else {
            items = items.ptr[0 .. newLength];
        }
    }

    @trusted
    void append(const(T)[] args...) {
        auto oldLength = length;
        resizeBlank(length + args.length);
        jokaMemcpy(ptr + oldLength, args.ptr, args.length * T.sizeof);
    }

    @nogc
    void remove(Sz i) {
        items[i] = items[$ - 1];
        items = items[0 .. $ - 1];
    }

    @nogc
    void removeShift(Sz i) {
        foreach (j; i .. length - 1) items[j] = items[j + 1];
        items = items[0 .. $ - 1];
    }

    @nogc
    T pop() {
        if (length > 0) {
            T temp = items[$ - 1];
            remove(length - 1);
            return temp;
        } else {
            return T.init;
        }
    }

    @nogc
    T popFront() {
        if (length > 0) {
            T temp = items[0];
            removeShift(0);
            return temp;
        } else {
            return T.init;
        }
    }

    @trusted
    void reserve(Sz newCapacity) {
        auto targetCapacity = jokaFindListCapacity(newCapacity);
        if (targetCapacity > capacity) {
            capacity = targetCapacity;
            items = (cast(T*) jokaRealloc(items.ptr, capacity * T.sizeof))[0 .. length];
        }
    }

    @trusted
    void resizeBlank(Sz newLength) {
        if (newLength <= length) {
            items = items[0 .. newLength];
        } else {
            reserve(newLength);
            items = items.ptr[0 .. newLength];
        }
    }

    void resize(Sz newLength) {
        auto oldLength = length;
        resizeBlank(newLength);
        if (newLength > oldLength) {
            foreach (i; 0 .. newLength - oldLength) items[$ - i - 1] = T.init;
        }
    }

    @trusted @nogc
    void fill(const(T) value) {
        foreach (ref item; items) item = cast(T) value;
    }

    @nogc
    void clear() {
        items = items[0 .. 0];
    }

    @trusted @nogc
    void free() {
        jokaFree(items.ptr);
        items = null;
        capacity = 0;
    }
}

/// A dynamic array allocated on the stack.
struct FixedList(T, Sz N) {
    Array!(T, N) data = void;
    Sz length;

    enum capacity = N;

    @safe nothrow @nogc:

    mixin addSliceOps!(FixedList!(T, N), T);

    pragma(inline, true)
    this(const(T)[] args...) {
        append(args);
    }

    pragma(inline, true)
    T[] items() {
        return data.items[0 .. length];
    }

    pragma(inline, true)
    T* ptr() {
        return data.ptr;
    }

    bool isEmpty() {
        return length == 0;
    }

    void appendBlank() {
        length += 1;
        if (length > N) assert(0, "List is full.");
    }

    @trusted
    void append(const(T)[] args...) {
        auto oldLength = length;
        resizeBlank(length + args.length);
        jokaMemcpy(ptr + oldLength, args.ptr, args.length * T.sizeof);
    }

    void remove(Sz i) {
        items[i] = items[$ - 1];
        length -= 1;
    }

    void removeShift(Sz i) {
        foreach (j; i .. items.length - 1) items[j] = items[j + 1];
        length -= 1;
    }

    T pop() {
        if (length > 0) {
            T temp = items[$ - 1];
            remove(length - 1);
            return temp;
        } else {
            return T.init;
        }
    }

    T popFront() {
        if (length > 0) {
            T temp = items[0];
            removeShift(0);
            return temp;
        } else {
            return T.init;
        }
    }

    void resizeBlank(Sz newLength) {
        if (newLength > N) assert(0, "List is full.");
        length = newLength;
    }

    void resize(Sz newLength) {
        auto oldLength = length;
        resizeBlank(newLength);
        if (newLength > oldLength) {
            foreach (i; 0 .. newLength - oldLength) items[$ - i - 1] = T.init;
        }
    }

    @trusted
    void fill(const(T) value) {
        foreach (ref item; items) item = cast(T) value;
    }

    void clear() {
        length = 0;
    }
}

/// A dynamic sparse array.
struct SparseList(T) {
    List!T data;
    List!bool flags;
    Sz hotIndex;
    Sz openIndex;
    Sz length;

    @safe nothrow:

    this(const(T)[] args...) {
        append(args);
    }

    @nogc
    ref T opIndex(Sz i) {
        if (!has(i)) {
            assert(0, "Index `[{}]` does not exist.".fmt(i));
        }
        return data[i];
    }

    @trusted @nogc
    void opIndexAssign(const(T) rhs, Sz i) {
        if (!has(i)) assert(0, "Index `[{}]` does not exist.".fmt(i));
        data[i] = cast(T) rhs;
    }

    @trusted @nogc
    void opIndexOpAssign(IStr op)(const(T) rhs, Sz i) {
        if (!has(i)) assert(0, "Index `[{}]` does not exist.".fmt(i));
        mixin("data[i]", op, "= cast(T) rhs;");
    }

    @nogc
    Sz capacity() {
        return data.capacity;
    }

    @trusted @nogc
    T* ptr() {
        return data.ptr;
    }

    @nogc
    bool isEmpty() {
        return length == 0;
    }

    @nogc
    bool has(Sz i) {
        return i < flags.length && flags[i];
    }

    @trusted
    void append(const(T)[] args...) {
        foreach (arg; args) {
            if (openIndex == flags.length) {
                data.append(arg);
                flags.append(true);
                hotIndex = openIndex;
                openIndex = flags.length;
                length += 1;
            } else {
                auto isFull = true;
                foreach (i; openIndex .. flags.length) {
                    if (!flags[i]) {
                        data[i] = arg;
                        flags[i] = true;
                        hotIndex = i;
                        openIndex = i;
                        isFull = false;
                        break;
                    }
                }
                if (isFull) {
                    data.append(arg);
                    flags.append(true);
                    hotIndex = flags.length - 1;
                    openIndex = flags.length;
                }
                length += 1;
            }
        }
    }

    @nogc
    void remove(Sz i) {
        if (!has(i)) assert(0, "Index `[{}]` does not exist.".fmt(i));
        flags[i] = false;
        hotIndex = i;
        if (i < openIndex) openIndex = i;
        length -= 1;
    }

    void reserve(Sz capacity) {
        data.reserve(capacity);
        flags.reserve(capacity);
    }

    @nogc
    void clear() {
        data.clear();
        flags.clear();
        hotIndex = 0;
        openIndex = 0;
        length = 0;
    }

    @nogc
    void free() {
        data.free();
        flags.free();
        hotIndex = 0;
        openIndex = 0;
        length = 0;
    }

    @nogc
    auto ids() {
        static struct Range {
            bool[] flags;
            Sz id;

            bool empty() {
                return id == flags.length;
            }

            Sz front() {
                return id;
            }

            void popFront() {
                id += 1;
                while (id != flags.length && !flags[id]) id += 1;
            }
        }

        Sz id = 0;
        while (id < flags.length && !flags[id]) id += 1;
        return Range(flags.items, id);
    }

    @nogc
    auto items() {
        static struct Range {
            T[] data;
            bool[] flags;
            Sz id;

            bool empty() {
                return id == flags.length;
            }

            ref T front() {
                return data[id];
            }

            void popFront() {
                id += 1;
                while (id != flags.length && !flags[id]) id += 1;
            }
        }

        Sz id = 0;
        while (id < flags.length && !flags[id]) id += 1;
        return Range(data.items, flags.items, id);
    }
}

deprecated("Will be replaced with GenIndex.")
alias GenerationalIndex = GenIndex;
deprecated("Will be replaced with GenList.")
alias GenerationalList(T) = GenList!(T);

struct GenIndex {
    Sz value;
    Sz generation;
}

struct GenList(T) {
    SparseList!T data;
    List!Sz generations;

    @safe nothrow:

    @nogc
    ref T opIndex(GenIndex i) {
        if (!has(i)) assert(0, "Index `[{}]` with generation `{}` does not exist.".fmt(i.value, i.generation));
        return data[i.value];
    }

    @trusted @nogc
    void opIndexAssign(const(T) rhs, GenIndex i) {
        if (!has(i)) assert(0, "Index `[{}]` with generation `{}` does not exist.".fmt(i.value, i.generation));
        data[i.value] = cast(T) rhs;
    }

    @trusted @nogc
    void opIndexOpAssign(IStr op)(const(T) rhs, GenIndex i) {
        if (!has(i)) assert(0, "Index `[{}]` with generation `{}` does not exist.".fmt(i.value, i.generation));
        mixin("data[i.value]", op, "= cast(T) rhs;");
    }

    @nogc
    Sz length() {
        return data.length;
    }

    @nogc
    Sz capacity() {
        return data.capacity;
    }

    @trusted @nogc
    T* ptr() {
        return data.ptr;
    }

    @nogc
    bool isEmpty() {
        return length == 0;
    }

    @nogc
    bool has(GenIndex i) {
        return data.has(i.value) && generations[i.value] == i.generation;
    }

    GenIndex append(const(T) arg) {
        data.append(arg);
        generations.resize(data.data.length);
        return GenIndex(data.hotIndex, generations[data.hotIndex]);
    }

    @nogc
    void remove(GenIndex i) {
        if (!has(i)) assert(0, "Index `[{}]` with generation `{}` does not exist.".fmt(i.value, i.generation));
        data.remove(i.value);
        generations[data.hotIndex] += 1;
    }

    void reserve(Sz capacity) {
        data.reserve(capacity);
        generations.reserve(capacity);
    }

    @nogc
    void clear() {
        foreach (id; ids) remove(id);
    }

    @nogc
    void free() {
        data.free();
        generations.free();
    }

    @nogc
    auto ids() {
        static struct Range {
            Sz[] generations;
            bool[] flags;
            Sz id;

            bool empty() {
                return id == flags.length;
            }

            GenIndex front() {
                return GenIndex(id, generations[id]);
            }

            void popFront() {
                id += 1;
                while (id != flags.length && !flags[id]) id += 1;
            }
        }

        Sz id = 0;
        while (id < data.flags.length && !data.flags[id]) id += 1;
        return Range(generations.items, data.flags.items, id);
    }

    @nogc
    auto items() {
        static struct Range {
            T[] data;
            bool[] flags;
            Sz id;

            bool empty() {
                return id == flags.length;
            }

            ref T front() {
                return data[id];
            }

            void popFront() {
                id += 1;
                while (id != flags.length && !flags[id]) id += 1;
            }
        }

        Sz id = 0;
        while (id < data.flags.length && !data.flags[id]) id += 1;
        return Range(data.data.items, data.flags.items, id);
    }
}

struct Grid(T) {
    List!T tiles;
    Sz rowCount;
    Sz colCount;

    @safe nothrow:

    this(Sz rowCount, Sz colCount, T value = T.init) {
        resizeBlank(rowCount, colCount);
        fill(value);
    }

    @nogc
    T[] opIndex() {
        return tiles[0 .. length];
    }

    @nogc
    ref T opIndex(Sz row, Sz col) {
        if (!has(row, col)) assert(0, "Tile `[{}, {}]` does not exist.".fmt(row, col));
        return tiles[jokaFindGridIndex(row, col, colCount)];
    }

    @nogc
    void opIndexAssign(T rhs, Sz row, Sz col) {
        if (!has(row, col)) assert(0, "Tile `[{}, {}]` does not exist.".fmt(row, col));
        tiles[jokaFindGridIndex(row, col, colCount)] = rhs;
    }

    @nogc
    void opIndexOpAssign(IStr op)(T rhs, Sz row, Sz col) {
        if (!has(row, col)) assert(0, "Tile `[{}, {}]` does not exist.".fmt(row, col));
        mixin("tiles[colCount * row + col]", op, "= rhs;");
    }

    @nogc
    Sz opDollar(Sz dim)() {
        static if (dim == 0) {
            return rowCount;
        } else static if (dim == 1) {
            return colCount;
        } else {
            assert(0, "WTF!");
        }
    }

    @nogc
    Sz length() {
        return tiles.length;
    }

    @trusted @nogc
    T* ptr() {
        return tiles.ptr;
    }

    @nogc
    Sz capacity() {
        return tiles.capacity;
    }

    @nogc
    bool isEmpty() {
        return tiles.isEmpty;
    }

    @nogc
    bool has(Sz row, Sz col) {
        return row < rowCount && col < colCount;
    }

    void reserve(Sz newCapacity) {
        tiles.reserve(newCapacity);
    }

    void resizeBlank(Sz newRowCount, Sz newColCount) {
        tiles.resizeBlank(newRowCount * newColCount);
        rowCount = newRowCount;
        colCount = newColCount;
    }

    void resize(Sz newRowCount, Sz newColCount) {
        tiles.resizeBlank(newRowCount * newColCount);
        tiles.fill(T.init);
        rowCount = newRowCount;
        colCount = newColCount;
    }

    @trusted @nogc
    void fill(T value) {
        tiles.fill(value);
    }

    @nogc
    void clear() {
        tiles.clear();
        rowCount = 0;
        colCount = 0;
    }

    @trusted @nogc
    void free() {
        tiles.free();
        rowCount = 0;
        colCount = 0;
    }
}

struct Arena {
    ubyte* data;
    Sz capacity;
    Sz offset;

    @safe nothrow:

    this(Sz capacity) {
        mallocSelf(capacity);
    }

    @trusted
    void mallocSelf(Sz newCapacity) {
        free();
        data = cast(ubyte*) jokaMalloc(newCapacity);
        capacity = newCapacity;
        offset = 0;
    }

    @system @nogc
    void* malloc(Sz size, Sz alignment) {
        if (size == 0 || alignment == 0) assert(0, "Size or alignment is zero.");
        Sz alignedOffset = void;
        if (offset == 0) {
            auto ptr = cast(Sz) data;
            alignedOffset = ((ptr + (alignment - 1)) & ~(alignment - 1)) - ptr;
        } else {
            alignedOffset = (offset + (alignment - 1)) & ~(alignment - 1);
        }
        if (alignedOffset + size > capacity) return null;
        offset = alignedOffset + size;
        return cast(void*) (data + alignedOffset);
    }

    @system @nogc
    void* realloc(void* ptr, Sz oldSize, Sz newSize, Sz alignment) {
        if (ptr == null) return malloc(newSize, alignment);
        auto newPtr = malloc(newSize, alignment);
        if (newPtr == null) return null;
        if (oldSize <= newSize) jokaMemcpy(newPtr, ptr, oldSize);
        else jokaMemcpy(newPtr, ptr, newSize);
        return newPtr;
    }

    @trusted @nogc
    T* makeBlank(T)() {
        return cast(T*) malloc(T.sizeof, T.alignof);
    }

    @nogc
    T* make(T)(const(T) value = T.init) {
        auto result = makeBlank!T();
        *result = cast(T) value;
        return result;
    }

    @trusted @nogc
    T[] makeSliceBlank(T)(Sz length) {
        return (cast(T*) malloc(T.sizeof * length, T.alignof))[0 .. length];
    }

    @nogc
    T[] makeSlice(T)(Sz length, const(T) value = T.init) {
        auto result = makeSliceBlank!T(length);
        foreach (ref item; result) item = value;
        return result;
    }

    @nogc
    void clear() {
        offset = 0;
    }

    @trusted @nogc
    free() {
        jokaFree(data);
        data = null;
        capacity = 0;
        offset = 0;
    }
}

pragma(inline, true) extern(C) @nogc
Sz jokaFindListCapacity(Sz length) {
    Sz result = defaultListCapacity;
    while (result < length) result += result;
    return result;
}

pragma(inline, true) extern(C) @nogc
Sz jokaFindGridIndex(Sz row, Sz col, Sz colCount) {
    return colCount * row + col;
}

pragma(inline, true) extern(C) @nogc
Sz jokaFindGridRow(Sz gridIndex, Sz colCount) {
    return gridIndex % colCount;
}

pragma(inline, true) extern(C) @nogc
Sz jokaFindGridCol(Sz gridIndex, Sz colCount) {
    return gridIndex / colCount;
}

deprecated("Use `fmtIntoList` instead. All `format*` functions in Joka will be renamed to `fmt*` to avoid collisions with `std.format`.")
alias formatIntoList = fmtIntoList;

/// Formats a string using a list and returns the resulting formatted string.
/// The list is cleared before writing.
/// For details on formatting behavior, see the `formatIntoBuffer` function in the `ascii` module.
IStr fmtIntoList(A...)(ref LStr buffer, IStr fmtStr, A args) {
    buffer.clear();
    auto fmtStrIndex = 0;
    auto argIndex = 0;
    while (fmtStrIndex < fmtStr.length) {
        auto c1 = fmtStr[fmtStrIndex];
        auto c2 = fmtStrIndex + 1 >= fmtStr.length ? '+' : fmtStr[fmtStrIndex + 1];
        if (c1 == '{' && c2 == '}') {
            if (argIndex >= args.length) assert(0, "A placeholder doesn't have an argument.");
            static foreach (i, arg; args) {
                if (i == argIndex) {
                    auto temp = toStr(arg);
                    buffer.append(temp);
                    fmtStrIndex += 2;
                    argIndex += 1;
                    goto loopExit;
                }
            }
            loopExit:
        } else {
            buffer.append(c1);
            fmtStrIndex += 1;
        }
    }
    if (argIndex != args.length) assert(0, "An argument doesn't have a placeholder.");
    return buffer[];
}

// Function test.
unittest {
    assert(jokaFindListCapacity(0) == defaultListCapacity);
    assert(jokaFindListCapacity(defaultListCapacity) == defaultListCapacity);
    assert(jokaFindListCapacity(defaultListCapacity + 1) == defaultListCapacity * 2);
    assert(jokaFindListCapacity(defaultListCapacity + 1) == defaultListCapacity * 2);
}

// TODO: Write better tests.
// List test.
unittest {
    LStr text;

    text = LStr();
    assert(text.length == 0);
    assert(text.capacity == 0);
    assert(text.ptr == null);

    text = LStr("abc");
    assert(text.length == 3);
    assert(text.capacity == defaultListCapacity);
    assert(text.ptr != null);
    text.free();
    assert(text.length == 0);
    assert(text.capacity == 0);
    assert(text.ptr == null);

    text = LStr("Hello world!");
    assert(text.length == "Hello world!".length);
    assert(text.capacity == defaultListCapacity);
    assert(text.ptr != null);
    assert(text[] == text.items);
    assert(text[0] == text.items[0]);
    assert(text[0 .. $] == text.items[0 .. $]);
    assert(text[0] == 'H');
    text[0] = 'h';
    text[0] += 1;
    text[0] -= 1;
    assert(text[0] == 'h');
    text.append("!!");
    assert(text[] == "hello world!!!");
    assert(text.pop() == '!');
    assert(text.pop() == '!');
    assert(text[] == "hello world!");
    text.resize(0);
    assert(text[] == "");
    assert(text.length == 0);
    assert(text.capacity == defaultListCapacity);
    assert(text.pop() == char.init);
    text.resize(1);
    assert(text[0] == char.init);
    assert(text.length == 1);
    assert(text.capacity == defaultListCapacity);
    text.clear();
    text.reserve(5);
    assert(text.length == 0);
    assert(text.capacity == defaultListCapacity);
    text.reserve(defaultListCapacity + 1);
    assert(text.length == 0);
    assert(text.capacity == defaultListCapacity * 2);
    assert(text.fmtIntoList("Hello {}!", "world") == "Hello world!");
    assert(text.fmtIntoList("({}, {})", -69, -420) == "(-69, -420)");
    text.free();
}

// TODO: Write better tests.
// FixedList test.
unittest {
    FStr!64 text;

    text = FStr!64();
    assert(text.length == 0);
    text.resize(63);
    assert(text.length == 63);
    text.appendBlank();
    assert(text.length == 64);

    text = FStr!64("abc");
    assert(text.length == 3);
    text.clear();
    assert(text.length == 0);

    text = FStr!64("Hello world!");
    assert(text.length == "Hello world!".length);
    assert(text[] == text.items);
    assert(text[0] == text.items[0]);
    assert(text[0 .. $] == text.items[0 .. $]);
    assert(text[0] == 'H');
    text[0] = 'h';
    text[0] += 1;
    text[0] -= 1;
    assert(text[0] == 'h');
    text.append("!!");
    assert(text[] == "hello world!!!");
    assert(text.pop() == '!');
    assert(text.pop() == '!');
    assert(text[] == "hello world!");
    text.resize(0);
    assert(text[] == "");
    assert(text.length == 0);
    assert(text.pop() == char.init);
    text.resize(1);
    assert(text[0] == char.init);
    assert(text.length == 1);
    text.clear();
}

// SparseList test.
unittest {
    SparseList!int numbers;

    numbers = SparseList!int();
    assert(numbers.length == 0);
    assert(numbers.capacity == 0);
    assert(numbers.ptr == null);
    assert(numbers.hotIndex == 0);
    assert(numbers.openIndex == 0);

    numbers = SparseList!int(1, 2, 3);
    assert(numbers.length == 3);
    assert(numbers.capacity == defaultListCapacity);
    assert(numbers.ptr != null);
    assert(numbers.hotIndex == 2);
    assert(numbers.openIndex == 3);
    assert(numbers[0] == 1);
    assert(numbers[1] == 2);
    assert(numbers[2] == 3);
    numbers[0] = 1;
    numbers[0] += 1;
    numbers[0] -= 1;
    assert(numbers.has(0) == true);
    assert(numbers.has(1) == true);
    assert(numbers.has(2) == true);
    assert(numbers.has(3) == false);
    numbers.remove(1);
    assert(numbers.has(0) == true);
    assert(numbers.has(1) == false);
    assert(numbers.has(2) == true);
    assert(numbers.has(3) == false);
    assert(numbers.hotIndex == 1);
    assert(numbers.openIndex == 1);
    numbers.append(1);
    assert(numbers.has(0) == true);
    assert(numbers.has(1) == true);
    assert(numbers.has(2) == true);
    assert(numbers.has(3) == false);
    assert(numbers.hotIndex == 1);
    assert(numbers.openIndex == 1);
    numbers.append(4);
    assert(numbers.has(0) == true);
    assert(numbers.has(1) == true);
    assert(numbers.has(2) == true);
    assert(numbers.has(3) == true);
    assert(numbers.hotIndex == 3);
    assert(numbers.openIndex == 4);
    numbers.clear();
    numbers.append(1);
    assert(numbers.has(0) == true);
    assert(numbers.has(1) == false);
    assert(numbers.has(2) == false);
    assert(numbers.has(3) == false);
    assert(numbers.hotIndex == 0);
    assert(numbers.openIndex == 1);
    numbers.free();
    assert(numbers.length == 0);
    assert(numbers.capacity == 0);
    assert(numbers.ptr == null);
    assert(numbers.hotIndex == 0);
    assert(numbers.openIndex == 0);
}

// GenList test
unittest {
    GenList!int numbers;
    GenIndex index;

    numbers = GenList!int();
    assert(numbers.length == 0);
    assert(numbers.capacity == 0);
    assert(numbers.ptr == null);

    index = numbers.append(1);
    assert(numbers.length == 1);
    assert(numbers.capacity == defaultListCapacity);
    assert(numbers.ptr != null);
    assert(index.value == 0);
    assert(index.generation == 0);
    assert(numbers[index] == 1);

    index = numbers.append(2);
    assert(numbers.length == 2);
    assert(numbers.capacity == defaultListCapacity);
    assert(numbers.ptr != null);
    assert(index.value == 1);
    assert(index.generation == 0);
    assert(numbers[index] == 2);

    index = numbers.append(3);
    assert(numbers.length == 3);
    assert(numbers.capacity == defaultListCapacity);
    assert(numbers.ptr != null);
    assert(index.value == 2);
    assert(index.generation == 0);
    assert(numbers[index] == 3);

    numbers[GenIndex(0, 0)] = 1;
    numbers[GenIndex(0, 0)] += 1;
    numbers[GenIndex(0, 0)] -= 1;
    assert(numbers.has(GenIndex(1, 0)) == true);
    assert(numbers.has(GenIndex(2, 0)) == true);
    assert(numbers.has(GenIndex(3, 0)) == false);
    numbers.remove(GenIndex(1, 0));
    assert(numbers.has(GenIndex(0, 0)) == true);
    assert(numbers.has(GenIndex(1, 0)) == false);
    assert(numbers.has(GenIndex(2, 0)) == true);
    assert(numbers.has(GenIndex(3, 0)) == false);
    numbers.append(1);
    assert(numbers.has(GenIndex(0, 0)) == true);
    assert(numbers.has(GenIndex(1, 1)) == true);
    assert(numbers.has(GenIndex(2, 0)) == true);
    assert(numbers.has(GenIndex(3, 0)) == false);
    numbers.append(4);
    assert(numbers.has(GenIndex(0, 0)) == true);
    assert(numbers.has(GenIndex(1, 1)) == true);
    assert(numbers.has(GenIndex(2, 0)) == true);
    assert(numbers.has(GenIndex(3, 0)) == true);
    numbers.clear();
    numbers.append(1);
    assert(numbers.has(GenIndex(0, 1)) == true);
    assert(numbers.has(GenIndex(1, 0)) == false);
    assert(numbers.has(GenIndex(1, 1)) == false);
    assert(numbers.has(GenIndex(2, 0)) == false);
    assert(numbers.has(GenIndex(3, 0)) == false);
    numbers.free();
    assert(numbers.length == 0);
    assert(numbers.capacity == 0);
    assert(numbers.ptr == null);
}

// Grid test
unittest {
    Grid!int numbers;
    auto rowCount = 64;
    auto colCount = 64;
    auto capacity = rowCount * colCount;

    assert(numbers.length == 0);
    assert(numbers.capacity == 0);
    assert(numbers.ptr == null);
    assert(numbers.rowCount == 0);
    assert(numbers.colCount == 0);

    numbers = Grid!int(rowCount, colCount, -1);
    assert(numbers.length == capacity);
    assert(numbers.capacity == capacity);
    assert(numbers.ptr != null);
    assert(numbers.rowCount == rowCount);
    assert(numbers.colCount == colCount);
    assert(numbers[0, 0] == -1);
    assert(numbers[rowCount - 1, colCount - 1] == -1);
    numbers[0, 0] = 0;
    numbers[0, 0] += 1;
    numbers[0, 0] -= 1;
    assert(numbers.has(7, colCount) == false);
    assert(numbers.has(rowCount, 7) == false);
    assert(numbers.has(rowCount, colCount) == false);
    numbers.free();
    assert(numbers.length == 0);
    assert(numbers.capacity == 0);
    assert(numbers.ptr == null);
    assert(numbers.rowCount == 0);
    assert(numbers.colCount == 0);
}

// Arena test
@trusted
unittest {
    Arena arena;
    int* number;

    arena = Arena(1024);
    assert(arena.capacity == 1024);
    assert(arena.offset == 0);
    assert(arena.data != null);
    number = arena.make(69);
    assert(*number == 69);
    number = arena.make(420);
    assert(*number == 420);
    arena.clear();
    assert(arena.offset == 0);
    assert(arena.data != null);
    assert(arena.malloc(1024, 1) != null);
    assert(arena.malloc(1024, 1) == null);
    arena.free();
    assert(arena.capacity == 0);
    assert(arena.offset == 0);
    assert(arena.data == null);
}
