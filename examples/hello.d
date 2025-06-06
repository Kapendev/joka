/// This example serves as a classic hello-world program.

import joka;

struct Person {
    // An `IStr` is a `const(char)[]`.
    IStr name;
    int age;

    // This method will be used by the print functions.
    IStr toStr() {
        return "({}, {})".fmt(name, age);
    }
}

void main() {
    println("Hellooo!");
    printfln("Person: {}", Person("Joka", 40));
    foreach (i; 0 .. 3) {
        trace(333 * (i + 1));
    }
}
