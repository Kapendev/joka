/// This example shows how to use Joka's dynamic arrays.

import joka;

void main() {
    // Create a dynamic array.
    auto numbers = List!int(2, 4, 6);
    scope (exit) numbers.free();
    println("Length: ", numbers.length);
    println("Capacity: ", numbers.capacity);
    println("Items: ");
    foreach (i, number; numbers) printfln(" [{}]: {}", i, number);

    // Add and remove from the array.
    numbers.push(9);
    printfln("One of my favorite movies is {}.", numbers[$ - 1]);
    numbers.pop();

    // A `LStr` is a `List!char` and it doesn't append a zero at the end.
    auto text = LStr("D is... ");
    scope (exit) text.free();
    text.append("really cool!");
    println(text);
}
