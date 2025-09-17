/// This example serves as a classic hello-world program.

import joka;

struct Person {
    // An `IStr` is a `const(char)[]`.
    IStr name;
    // Will be used by the print functions. They also support `toString` methods.
    IStr toStr() => "*{}*".fmt(name);
}

void main() {
    printfln("I am {}.", Person("Ghadius"));
    println("Now, ", "it is simply my turn to reject the world.");
    println(sp, 1, 2, 3, "GO!");
}
