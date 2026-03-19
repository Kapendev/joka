import w4 = joka.wasm4;
import joka.types;
import joka.math;

immutable(ubyte)[] smiley = [
    0b11000011,
    0b10000001,
    0b00100100,
    0b00100100,
    0b00000000,
    0b00100100,
    0b10011001,
    0b11000011,
];

enum dt = 1.0f / 60.0f;
auto time = 0.0f;
auto isFirstFrame = true;
auto point = Vec2();
auto size = 8;

extern(C) void update() {
    if (isFirstFrame) {
        // Palette: https://lospec.com/palette-list/mist-gb
        w4.palette[0] = 0xc4f0c2;
        w4.palette[1] = 0x5ab9a8;
        w4.palette[2] = 0x1e606e;
        w4.palette[3] = 0x2d1b00;
        isFirstFrame = false;
    }

    *w4.drawColors = 2;
    w4.text("D + Joka", 14, 14);
    w4.hline(14, 25, cast(uint) (32 + sin(time * 2) * 32));

    const gamepad = *w4.gamepad1;
    if (gamepad & w4.button1) {
        *w4.drawColors = 4;
    }
    w4.blit(smiley.ptr, 76, 76, 8, 8, w4.blit1Bpp);
    w4.text("Press X to blink", 17, 90);
    w4.text("Mouse: ({} {})\0".fmt(*w4.mouseX, *w4.mouseY).ptr, 17, 110);

    point = point.moveToWithSlowdown(
        Vec2(*w4.mouseX - size / 2, *w4.mouseY - size / 2),
        Vec2(dt),
        0.15,
    );
    *w4.drawColors = 2;
    w4.oval(cast(int) point.x, cast(int) point.y, size, size);

    time += dt;
}
