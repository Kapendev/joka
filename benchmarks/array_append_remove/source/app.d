
void main(string[] args) {
    auto N = args.length > 1 ? cast(int) args[1].toSigned().getOr(0) : 0;
    if (N == 0) { writeln("Usage: array_append_remove <count>"); return; }

    {
        int[] dArray;
        with (Benchmark()) {
            foreach (i; 0 .. N) dArray ~= i;
        }
        writeln("Append ", N, " items with `int[]`: ", ms, " ms");
        with (Benchmark()) {
            while (dArray.length) dArray.length -= 1;
        }
        writeln("Remove ", N, " items with `int[]`: ", ms, " ms");
    }

    {
        import std.container.array;
        Array!int arrayArray;
        with (Benchmark()) {
            foreach (i; 0 .. N) arrayArray ~= i;
        }
        writeln("Append ", N, " items with `Array!int`: ", ms, " ms");
        with (Benchmark()) {
            while (arrayArray.length) arrayArray.removeBack();
        }
        writeln("Remove ", N, " items with `Array!int`: ", ms, " ms");
    }

    {
        import std.array;
        Appender!(int[]) appenderArray;
        with (Benchmark()) {
            foreach (i; 0 .. N) appenderArray ~= i;
        }
        writeln("Append ", N, " items with `Appender!int`: ", ms, " ms");
        with (Benchmark()) {
            while (appenderArray.length) appenderArray.shrinkTo(appenderArray.length - 1);
        }
        writeln("Remove ", N, " items with `Appender!int`: ", ms, " ms");
    }

    {
        import nulib.collections.vector;
        vector!int nulibArray;
        with (Benchmark()) {
            foreach (i; 0 .. N) nulibArray ~= i;
        }
        writeln("Append ", N, " items with `nulib`: ", ms, " ms");
        with (Benchmark()) {
            while (nulibArray.length) nulibArray.popBack();
        }
        writeln("Remove ", N, " items with `nulib`: ", ms, " ms");
    }

    {
        import containers.dynamicarray;
        DynamicArray!int emsiArray;
        with (Benchmark()) {
            foreach (i; 0 .. N) emsiArray ~= i;
        }
        writeln("Append ", N, " items with `emsi`: ", ms, " ms");
        with (Benchmark()) {
            while (emsiArray.length) emsiArray.removeBack();
        }
        writeln("Remove ", N, " items with `emsi`: ", ms, " ms");
    }

    {
        import memutils.vector;
        Vector!int memutilsArray;
        with (Benchmark()) {
            foreach (i; 0 .. N) memutilsArray ~= i;
        }
        writeln("Append ", N, " items with `memutils`: ", ms, " ms");
        with (Benchmark()) {
            while (memutilsArray.length) memutilsArray.removeBack();
        }
        writeln("Remove ", N, " items with `memutils`: ", ms, " ms");
    }

    {
        import automem.vector;
        Vector!int automemArray;
        with (Benchmark()) {
            foreach (i; 0 .. N) automemArray ~= i;
        }
        writeln("Append ", N, " items with `automem`: ", ms, " ms");
        with (Benchmark()) {
            while (automemArray.length) automemArray.popBack();
        }
        writeln("Remove ", N, " items with `automem`: ", ms, " ms");
    }

    {
        import joka.containers;
        List!int jokaArray;
        with (Benchmark()) {
            foreach (i; 0 .. N) jokaArray.push(i);
        }
        writeln("Append ", N, " items with `joka`: ", ms, " ms");
        with (Benchmark()) {
            while (jokaArray.length) jokaArray.drop();
        }
        writeln("Remove ", N, " items with `joka`: ", ms, " ms");
    }
}

// --- The "don't look" part.

import std.stdio;
import std.datetime.stopwatch;
import joka.ascii;

auto _w = StopWatch();

struct _Benchmark {
    this(bool lol) {
        _w.reset();
        _w.start();
    }

    ~this() {
        _w.stop();
    }
}

_Benchmark Benchmark() {
    return _Benchmark(true);
}

long ms() {
    return _w.peek.total!"msecs";
}
