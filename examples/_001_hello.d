/// This example serves as a classic hello-world program.

import joka;

struct Person {
    // An `IStr` is a `const(char)[]`.
    IStr name;
    int age;

    // This method will be used by the print functions.
    // The print functions also support `toString` methods.
    IStr toStr() {
        return "({} {})".fmt(name, age);
    }
}

void main() {
    println("Hellooo!");
    printfln("Person: {}", Person("Joka", 40));
    trace(1 + 1);
}
