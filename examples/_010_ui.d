/// This is a really basic (and bad) example of using the UI library.
/// Wasm-4 is needed to make it work.
/// Check the `scripts/wasm4_template` folder for more information.

import w4 = joka.wasm4;
import joka.types;
import joka.math;
import joka.ui;

auto ui = UiContext();

extern(C)
void update() {
    static isFirstFrame = true;
    if (isFirstFrame) {
        ui = UiContext(null, null);
        w4.palette[0] = 0x40332f;
        w4.palette[1] = 0x856d52;
        w4.palette[2] = 0x95c798;
        w4.palette[3] = 0xfbffe0;
        isFirstFrame = false;
    }

    auto screen = IRect(w4.screenSize, w4.screenSize);
    screen.subAll(6);

    // Create the UI.
    updateUiInput();
    ui.begin();
    with (ui.captureFocus()) {
        auto menu = ui.rowItems(screen.subTop(15), 3, 11);
        if (ui.button(menu.pop(), "A")) w4.trace("A!");
        if (ui.button(menu.pop(), "B B")) w4.trace("B!");
        if (ui.button(menu.pop(), "CCC")) w4.trace("C!");
    }
    if (ui.button(50, 50, 30, 30, "OwO")) w4.trace("One!");
    if (ui.button(89, 75, 30, 30, "UwU")) w4.trace("Two!");
    ui.end();

    // Draw the UI.
    foreach (i, ref command; ui.commands) {
        *w4.drawColors = 2;
        with (UiCommandType) final switch (command.type) {
            case none:
                break;
            case rect:
                if (command.rect.flags & UiCommandFlag.border) {
                    if (ui.commands.nextIsRectWith(i, UiCommandFlag.active | UiCommandFlag.hover)) {
                        *w4.drawColors = 4;
                    } else {
                        *w4.drawColors = 3;
                    }
                }
                if (command.rect.flags & UiCommandFlag.hover) *w4.drawColors = 2;
                if (command.rect.flags & UiCommandFlag.active) *w4.drawColors = 3;
                if (command.rect.flags & UiCommandFlag.focus) *w4.drawColors = 3;
                w4.rect(command.rect.x, command.rect.y, command.rect.w, command.rect.h);
                break;
            case text:
                *w4.drawColors = 4;
                w4.text(command.text.ptr, command.text.area.x, command.text.area.y);
                break;
            case icon:
                break;
        }
    }
}

void updateUiInput() {
    static previousMouseButtonDown = false;
    static previousKeyDown = false;
    static previousKeyDown2 = false;

    ui.input.mousePosition = IVec2(*w4.mouseX, *w4.mouseY);
    bool mouseDown = (*w4.mouseButtons & w4.mouseLeft) != 0;
    ui.input.mouseButtonDown     = mouseDown;
    ui.input.mouseButtonPressed  = !previousMouseButtonDown && mouseDown;
    ui.input.mouseButtonReleased = previousMouseButtonDown && !mouseDown;
    ui.input.mouseActionOnRelease = false;
    previousMouseButtonDown = mouseDown;

    bool keyDown = (*w4.gamepad1 & w4.buttonLeft) != 0;
    ui.input.keyPressed |= (!previousKeyDown && keyDown) ? UiKeyFlag.tab : UiKeyFlag.none;
    previousKeyDown = keyDown;

    bool keyDown2 = (*w4.gamepad1 & w4.button1) != 0;
    ui.input.keyPressed |= (!previousKeyDown2 && keyDown2) ? UiKeyFlag.enter : UiKeyFlag.none;
    previousKeyDown2 = keyDown2;
}
