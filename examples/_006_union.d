/// This example shows how to use Joka's union type.

import joka;

// Create the union types.
struct Fahrenheit { float degrees; }
struct Celsius    { float degrees; }
struct Kelvin     { float degrees; }

// Create the union.
alias Temperature = Union!(float, Fahrenheit, Celsius, Kelvin);

void freeze(ref Temperature t) {
    // The `as` function will cast without type checking.
    // Use the `to` function if you want safer access.
    with (t) switch (type) {
        case typeOf!Fahrenheit:
            as!Fahrenheit.degrees = 32; break;
        case typeOf!Celsius:
            as!Celsius.degrees = 0; break;
        case typeOf!Kelvin:
            as!Kelvin.degrees = 273; break;
        default:
    }
}

void main() {
    Temperature t = Kelvin(98);
    freeze(t);
    // If all types share the same base (e.g. `float`), use the `base` function to access it.
    println("Temperature: ", t.base);
    println("Type: ", t.typeName);
}
