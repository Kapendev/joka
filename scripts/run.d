#!/bin/env -S dmd -i -run

/// A helper script that runs an example from the examples folder.
/// The script depends on the ldc compiler.

import std.stdio;
import std.file;
import std.process;

int main(string[] args) {
    if (args.length != 2) {
        writeln("Provide an example from the examples folder.");
        writeln("Usage: example hello");
        return 0;
    }
    if (!args[1].exists) {
        writeln("Example \"", args[1], "\" doesn't exist.");
        return 0;
    }
    if (spawnProcess(["dmd", "-Isource", "-betterC", "-i", "-run", args[1]]).wait()) return 1;
    return 0;
}
