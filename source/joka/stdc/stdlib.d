// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/joka
// Version: v0.0.24
// ---

module joka.stdc.stdlib;

@nogc nothrow extern(C):

void* malloc(size_t size);
void* realloc(void* ptr, size_t size);
void free(void* ptr);
void abort();
void exit(int code);
char* getenv(const(char)* name);
int system(const(char)* command);
