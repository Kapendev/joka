/// This example serves as a classic hello-world program.

import joka;

struct Person {
    // An `IStr` is a `const(char)[]`.
    IStr name;
    // Will be used by the print functions. They also support `toString` methods.
    IStr toStr() => "*{}*".fmt(name);
}

void main() {
    auto p = Person("Ghadius");
    printfln("I am {}.", p);
    println(i"Yes, I am the real $(p).");
    println(Sep(" "), 1, 2, 3, "GO!");
}
