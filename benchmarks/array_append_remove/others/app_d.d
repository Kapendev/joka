import joka;

void main(string[] args) {
    auto n = args.length > 1 ? cast(int) args[1].toSigned().getOr(0) : 0;
    if (n == 0) {
        println("Usage: array_append_remove <count>");
        return;
    }

    List!int jokaArray;
    foreach (i; 0 .. n) {
        jokaArray.push(i);
    }
    while (jokaArray.length) {
        jokaArray.drop();
    }
}
