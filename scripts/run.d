#!/bin/env -S dmd -i -run

/// A helper script that runs an example from the examples folder.
/// The script depends on the DMD compiler.

import std.stdio;
import std.file;
import std.process;

enum isBetterC = true;

int main(string[] args) {
    if (args.length == 1) {
        writeln("Provide an example from the examples folder.");
        writeln("Usage: run examples/hello.d");
        return 0;
    }
    foreach (arg; args[1 .. $]) {
        if (!arg.exists) {
            writeln("Example \"", arg, "\" doesn't exist.");
            return 0;
        }
        if (isBetterC) {
            if (spawnProcess(["dmd", "-Isource", "-i", "-betterC", "-run", arg]).wait()) return 1;
        } else {
            if (spawnProcess(["dmd", "-Isource", "-i", "-run", arg]).wait()) return 1;
        }
    }
    return 0;
}
