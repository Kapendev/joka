/// This example shows how to use Joka's math library.

import joka;

void main() {
    // Create vectors.
    auto a1 = IVec2(2, 4);
    auto a2 = IVec3(a1 * a1, 8);
    auto a3 = IVec4(a2 + a2, 16);
    auto a4 = a3.chop().chop();
    trace(a1, a2, a3, a4);

    // Loop over the components of a vector.
    auto b = IVec4(2, 3, 4, 5);
    b += 2;
    b[][] += 2;
    foreach (ref item; b) item += 2;
    foreach (i; 0 .. b.length) b[i] += 2;
    trace(b);

    // Swizzle operations.
    auto c = IVec3(2, 0, 4);
    trace(c.swizzle(2, 0, 1), c.swizzle("zxy"));

    // Create a rectangle and change its position and size.
    auto rect = IRect(a1, 30, 32);
    rect.position += IVec2(1);
    rect.size += IVec2(1);
    trace(rect.x, rect.y, rect.w, rect.h);
}
