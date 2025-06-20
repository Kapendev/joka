/// This example shows how to use Joka's math library.

import joka;

void main() {
    // Create vectors.
    auto a = IVec2(2, 4);
    auto b = IVec3(a * a, 8);
    auto c = IVec4(b + b, 16);
    trace(c);

    // Loop over the components of a vector.
    foreach (ref item; c) item *= 2;
    trace(c);
    foreach (i; 0 .. c.length) c[i] *= 2;
    trace(c);

    // Create a rectangle and change its position and size.
    auto rect = IRect(a, 30, 32);
    rect.position.x += 1;
    rect.x += 1;
    rect.size.x += 1;
    rect.w += 1;
    trace(rect);
}
