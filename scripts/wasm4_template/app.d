import w4 = joka.wasm4;
import joka.types;

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

extern(C) void update() {
    *w4.drawColors = 2;
    w4.text("D + Joka", 14, 14);

    const gamepad = *w4.gamepad1;
    if (gamepad & w4.button1) {
        *w4.drawColors = 4;
    }

    w4.blit(smiley.ptr, 76, 76, 8, 8, w4.blit1Bpp);
    w4.text("Press X to blink", 17, 90);
    w4.text("Mouse: ({} {})\0".fmt(*w4.mouseX, *w4.mouseY).ptr, 17, 110);
}
