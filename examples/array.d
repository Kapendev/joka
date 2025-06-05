/// This example shows how to use Joka's dynamic arrays.

import joka;

void main() {
    // Simple dynamic array example.
    auto numbers = List!int(2, 4, 6);
    println("Length: ", numbers.length);
    println("Capacity: ", numbers.capacity);
    println("Items: ");
    foreach (i, number; numbers) {
        printfln(" [{}]: {}", i, number);
    }
    numbers.append(9);
    printfln("One of my favorite movies is {}.", numbers.pop());
    numbers.free();

    // Simple dynamic string example.
    // A `LStr` is a `List!char` and it does not append a zero at the end.
    auto text = LStr("D is... ");
    text.append("really cool!");
    println(text[]);
    text.free();
}
