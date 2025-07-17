/// This example shows how to use Joka's math library.

import joka;

void main() {
    // Create vectors.
    auto a = IVec2(2, 4);
    auto b = IVec3(a * a, 8);
    auto c = IVec4(b + b, 16);
    println(c);

    // Loop over the components of a vector.
    auto e = IVec4(2, 3, 4, 5);
    e[][] *= 2;
    foreach (ref item; e) item *= 2;
    foreach (i; 0 .. e.length) e[i] *= 2;
    println(e);

    // Create a rectangle and change its position and size.
    auto rect = IRect(a, 30, 32);
    rect.position.x += 1;
    rect.x += 1;
    rect.size.x += 1;
    rect.w += 1;
    println(rect);
}
