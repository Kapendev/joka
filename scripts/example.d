#!/bin/env rdmd

/// A helper script that runs an example from the examples folder.
/// The script depends on the ldc compiler.

import std;

/// Get the object files in the current folder.
string[] objectFiles() {
    string[] result;
    foreach (item; dirEntries(".", SpanMode.shallow)) {
        if (item.name.endsWith(".o")) {
            result ~= item.name;
        }
    }
    return result;
}

/// Delete object files in the current folder.
void deleteObjectFiles() {
    foreach (file; objectFiles) {
        std.file.remove(file);
    }
}

int main(string[] args) {
    if (args.length != 2) {
        writeln("Provide an example from the examples folder.");
        writeln("Usage: example hello");
        return 0;
    }

    // Basic error checking.
    auto examplesDir = buildPath(".", "examples");
    if (!examplesDir.exists) {
        writeln("Path `%s` does not exist.".format(examplesDir));
        writeln("Create an examples folder.");
        return 1;
    }
    auto exampleName = args[1].endsWith(".d") ? args[1][0 .. $ - 2] : args[1];
    auto exampleFile = buildPath(examplesDir, exampleName);
    exampleFile ~= ".d";
    if (!exampleFile.exists) {
        writeln("Example `%s` does not exist.".format(exampleName));
        return 0;
    }
    // Run example.
    version(Windows) {
        auto exampleApp = ".\\" ~ exampleName ~ ".exe";
    } else {
        auto exampleApp = "./" ~ exampleName;
    }
    if (spawnProcess(["ldc2", "-betterC", "-i", "-Isource", exampleFile]).wait()) { return 1; }
    if (spawnProcess(exampleApp).wait()) { deleteObjectFiles(); return 1; }
    std.file.remove(exampleApp);
    deleteObjectFiles();
    return 0;
}
