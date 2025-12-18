package main

import "core:fmt"
import "core:os"
import "core:strconv"

main :: proc() {
    args := os.args
    n: i32 = len(args) > 1 ? i32(strconv.atoi(args[1])) : 0
    if n == 0 {
        fmt.println("Usage: array_append_remove <count>")
        return
    }

    array: [dynamic]i32
    for i in 0 ..< n {
        append(&array, i)
    }
    for len(array) > 0 {
        pop(&array)
    }
}
