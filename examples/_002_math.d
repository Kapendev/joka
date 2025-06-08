/// This example shows how to use Joka's math library.

import joka;

void main() {
    // Create vectors.
    auto a = IVec2(2, 4);
    auto b = IVec2(6, 8);
    auto c = IVec3(a + b, 16);
    trace(c);

    // Loop over the components of a vector.
    foreach (i; 0 .. c.length) c[i] *= 2;
    trace(c);
    foreach (ref item; c.items) item *= 2;
    trace(c);

    // Create a rectangle and change its position and size.
    auto rect = IRect(a, b);
    rect.position.x += 1;
    rect.x += 1;
    rect.size.x += 1;
    rect.w += 1;
    trace(rect);
}
