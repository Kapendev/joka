/// This example shows how to use Joka's math library.

import joka;

void main() {
    auto a = IVec2(2, 4);
    auto b = IVec2(6, 8);
    auto c = IVec3(a + b, 16);
    trace(c.x, c.y, c.z);

    foreach (ref item; c.items) item *= 2;
    trace(c.x, c.y, c.z);
    foreach (i; 0 .. c.length) c[i] *= 2;
    trace(c.x, c.y, c.z);
}
