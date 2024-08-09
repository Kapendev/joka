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

int main() {
    if (!sourceDir.exists) {
        writeln("Path `%s` does not exist.".format(sourceDir));
        return 1;
    }

    foreach (file; dirEntries(sourceDir, SpanMode.breadth).parallel) {
        if (file.name.endsWith(".d")) {
            auto text = readText(file.name);
            if (text.startsWith(headerSep)) {
                foreach (i, c; text) {
                    if (i <= headerSep.length) continue;
                    if (i == text.length - headerSep.length) {
                        writeln("File `%s` does not have a second header separator.".format(file.name));
                        writeln("A header separator looks like this: `%s`".format(headerSep));
                        break;
                    }
                    if (text[i .. i + headerSep.length] == headerSep) {
                        std.file.write(file.name, header ~ text[i + headerSep.length .. $]);
                        break;
                    }
                }
            } else {
                std.file.write(file.name, header ~ "\n\n" ~ text);
            }
        }
    }
    return 0;
}
