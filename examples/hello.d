/// This example serves as a classic hello-world program.

import joka;

struct Person {
    // An `IStr` is a `const(char)[]`.
    IStr name;

    // This method will be used by the print functions.
    IStr toStr() {
        return "My name is {}.".fmt(name);
    }
}

void main() {
    println("Hello Ghadius!");
    println(Person("Joka"), " Hee hee!");

    printfln("Number 1: {}", doubleToStr(69.12345, 0));
    printfln("Number 2: {}", doubleToStr(69.12345, 10));
    printfln("Number 3: {}", toStr(69.12345));
}
