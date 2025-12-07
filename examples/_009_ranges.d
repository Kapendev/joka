/// This example shows how to use Joka's range utilities.

import joka;

void main(string[] args) {
    // Create a range from 1 to 10, stepping by 3, and iterate over it.
    foreach (i; range(1, 10, 3)) {
        println("Range value: ", i);
    }

    // Create a range from 1 to 5, then:
    // 1. Double each value.
    // 2. Keep only values greater than 4.
    // 3. Sum the remaining values.
    auto result = range(1, 5)
        .map((int x) => x * 2)
        .filter((int x) => x > 4)
        .reduce((int a, int b) => a + b);
    println("The result is: ", result);
}
