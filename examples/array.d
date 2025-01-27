/// This example shows how to use Joka's dynamic arrays.
import joka;

extern(C)
void main() {
    // Simple array example.
    auto numbers = List!int(2, 4, 6);
    print("Items: [");
    foreach (i, number; numbers) {
        if (i != numbers.length - 1) printf("{}, ", i, number);
        else printfln("{}]", i, number);
    }
    println("Length: ", numbers.length);
    println("Capacity: ", numbers.capacity);

    numbers.append(9);
    printfln("One of my favorite movies is {}.", numbers.pop());
    numbers.free();

    // Simple string example.
    // A `LStr` is a `List!char` and it does not append a zero at the end.
    auto text = LStr("D is... ");
    text.append("really cool!");
    println(text[]);
    text.free();
}
