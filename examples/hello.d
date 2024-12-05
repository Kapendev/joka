/// This example serves as a classic hello-world program.
import joka;

struct Person {
    // An `IStr` is a `const(char)[]`.
    IStr name;

    // This method will be used by the print functions.
    IStr toStr() {
        return "My name is {}.".format(name);
    }
}

extern(C)
void main() {
    println("Hello Ghadius!");
    println(Person("Joka"), " Hee hee!");

    printfln("Number:    {}", toStr(9));
    printfln("Vector:    {}", Vec2(1));
    printfln("Rectangle: {}", Rect(160, 144));
}
