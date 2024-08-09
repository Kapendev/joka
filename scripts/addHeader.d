#!/bin/env rdmd

/// A helper script that adds a header to every source file.

import std;

enum sourceDir = buildPath(".", "source");
enum headerSep = "// ---";

enum header = "// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Version: v0.0.3
// Project: https://github.com/Kapendev/joka
// Email: alexandroskapretsos@gmail.com
// ---";

/// Check if path exists and print an error message if needed.
bool check(const(char)[] path, bool isLoud = true) {
    if (!exists(path)) {
        if (isLoud) writeln("Path `", path, "` does not exist.");
        return true;
    }
    return false;
}

int main() {
    if (sourceDir.check) return 1;

    foreach (item; dirEntries(sourceDir, SpanMode.breadth).parallel) {
        if (item.name.length > 2 && item.name[$ - 2 .. $] == ".d") {
            auto content = readText(item.name);
            if (content.length > headerSep.length && content[0 .. headerSep.length] == headerSep) {
                foreach (i, c; content) {
                    if (i <= headerSep.length) continue;
                    if (i == content.length - 1) {
                        writeln("File `%s` does not have a second header separator.".format(item.name));
                        writeln("An header separator looks like this: `// ---`");
                        break;
                    }
                    if (content.length > i + headerSep.length && content[i .. i + headerSep.length] == headerSep) {
                        std.file.write(item.name, header ~ content[i + headerSep.length .. $]);
                        break;
                    }
                }
            } else {
                std.file.write(item.name, header ~ "\n\n" ~ content);
            }
        }
    }
    return 0;
}
