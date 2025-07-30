/// This example shows how to use Joka's maybe type.

import joka;

// Create the result.
alias Number = Maybe!int;

Number foo(int a) {
    // A default result is by default none.
    return a > 0 ? Number(50) : Number();
}

Number boo(int a, int b) {
    with (Number) {
        // Both `none` and `some` are static functions of the result.
        Fault trap;
        auto x = foo(a).get(trap); if (trap) return none;
        auto y = foo(b).get(trap); if (trap) return none;
        return some(x + y);
    }
}

void main() {
    Number[4] numbers = [
        foo(1),
        foo(-2),
        boo(3, 3),
        boo(-4, -4),
    ];

    println("Numbers:");
    foreach (i, number; numbers) {
        // The `value` member will return something without fault checking.
        // Use the `get` function if you want safer access.
        if (number.isSome) {
            printfln(" [{}]: {}", i, number.value);
        } else {
            printfln(" [{}]: Fault.{}", i, number.fault);
        }
    }
}
