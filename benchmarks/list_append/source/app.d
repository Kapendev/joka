import std.stdio;
import std.datetime.stopwatch;
import joka.ascii;

import std.array;
import joka.containers;
import nulib.collections.vector;

auto sw = StopWatch();

void main(string[] args) {
    auto N = args.length > 1 ? cast(int) args[1].toSigned().getOr(0) : 0;
    if (N == 0) {
        writeln("list_append <count>");
        return;
    }

    sw.start();
    Appender!(int[]) appenderArray;
    foreach (i; 0 .. N) appenderArray ~= i;
    sw.stop();
    writeln("Append ", N, " items in `Appender!int`: ", sw.peek.total!"msecs", " ms");
    sw.reset();

    sw.start();
    int[] dArray;
    foreach (i; 0 .. N) dArray ~= i;
    sw.stop();
    writeln("Append ", N, " items in `int[]`: ", sw.peek.total!"msecs", " ms");
    sw.reset();

    sw.start();
    vector!int nulibArray;
    foreach (i; 0 .. N) nulibArray ~= i;
    sw.stop();
    writeln("Append ", N, " items in `nulib`: ", sw.peek.total!"msecs", " ms");
    sw.reset();

    sw.start();
    List!int jokaArray;
    foreach (i; 0 .. N) jokaArray.push(i);
    sw.stop();
    writeln("Append ", N, " items in `joka`: ", sw.peek.total!"msecs", " ms");
    sw.reset();
}
