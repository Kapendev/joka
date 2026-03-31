/// This is a really basic (and bad) example of using the UI library.
/// WASM-4 is needed to make it work.
/// Check the `scripts/wasm4_template` folder for more information about WASM-4.

import w4 = joka.wasm4;
import joka.types;
import joka.math;
import joka.ui;

UiContext ui;
UiCommand[64] uiCommandsBuffer;
char[256] uiCharDataBuffer;

extern(C)
void update() {
    static isFirstFrame = true;
    if (isFirstFrame) {
        ui = UiContext(null, uiCommandsBuffer, uiCharDataBuffer, null);
        w4.palette[0] = 0xc4f0c2;
        w4.palette[1] = 0x5ab9a8;
        w4.palette[2] = 0x1e606e;
        w4.palette[3] = 0x2d1b00;
        isFirstFrame = false;
    }

    ui.handleUiInput();
    ui.begin();

    auto screen = IRect(w4.screenSize, w4.screenSize);
    screen.subAll(4);
    with (ui.captureFocus()) {
        auto menu = ui.rowItems(screen.subTop(13), 3, 8);
        if (ui.button(menu.pop(), "One"))   w4.trace("1!");
        if (ui.button(menu.pop(), "Two"))   w4.trace("2!");
        if (ui.button(menu.pop(), "Three")) w4.trace("3!");
    }
    if (ui.button(IRect(40, 55, 30, 30), "OwO")) w4.trace("OOO!");
    if (ui.button(IRect(90, 85, 30, 30), "UwU")) w4.trace("UUU!");

    ui.end();
    ui.drawUiState();
}

void handleUiInput(ref UiContext ui) {
    ui.input.mousePosition = IVec2(*w4.mouseX, *w4.mouseY);

    static previousMouseButtonDown = false;
    bool mouseButtonDown = (*w4.mouseButtons & w4.mouseLeft) != 0;
    ui.input.mouseButtonDown = mouseButtonDown;
    ui.input.mouseButtonPressed = !previousMouseButtonDown && mouseButtonDown;
    ui.input.mouseButtonReleased = previousMouseButtonDown && !mouseButtonDown;
    previousMouseButtonDown = mouseButtonDown;

    auto tempKeyDown = false;
    {
        static previousKeyDownTab = false;
        tempKeyDown = (*w4.gamepad1 & w4.buttonDown) != 0;
        ui.input.keyPressed |= (!previousKeyDownTab && tempKeyDown) ? UiKeyFlag.tab : UiKeyFlag.none;
        previousKeyDownTab = tempKeyDown;
    }
    {
        static previousKeyDownLeft = false;
        tempKeyDown = (*w4.gamepad1 & w4.buttonLeft) != 0;
        ui.input.keyPressed |= (!previousKeyDownLeft && tempKeyDown) ? UiKeyFlag.left : UiKeyFlag.none;
        ui.input.keyPressed |= (!previousKeyDownLeft && tempKeyDown) ? UiKeyFlag.up : UiKeyFlag.none;
        previousKeyDownLeft = tempKeyDown;
    }
    {
        static previousKeyDownRight = false;
        tempKeyDown = (*w4.gamepad1 & w4.buttonRight) != 0;
        ui.input.keyPressed |= (!previousKeyDownRight && tempKeyDown) ? UiKeyFlag.right : UiKeyFlag.none;
        ui.input.keyPressed |= (!previousKeyDownRight && tempKeyDown) ? UiKeyFlag.down : UiKeyFlag.none;
        previousKeyDownRight = tempKeyDown;
    }
    {
        static previousKeyDownEnter = false;
        tempKeyDown = (*w4.gamepad1 & w4.button1) != 0;
        ui.input.keyPressed |= (!previousKeyDownEnter && tempKeyDown) ? UiKeyFlag.enter : UiKeyFlag.none;
        previousKeyDownEnter = tempKeyDown;
    }
}

void drawUiState(ref UiContext ui) {
   foreach (i, ref command; ui.commands) {
        *w4.drawColors = 2;
        with (UiCommandType) final switch (command.type) {
            case none:
            case icon:
                break;
            case rect:
                if (command.rect.flags & UiCommandFlag.border) {
                    auto hasDarkColor =
                        ui.commands.nextIsRectWith(i, UiCommandFlag.hover) ||
                        ui.commands.nextIsRectWith(i, UiCommandFlag.active) ||
                        ui.commands.nextIsRectWith(i, UiCommandFlag.focus);
                    *w4.drawColors = hasDarkColor ? 4 : 3;
                }
                if (command.rect.flags & UiCommandFlag.hover)  *w4.drawColors = 2;
                if (command.rect.flags & UiCommandFlag.active) *w4.drawColors = 3;
                if (command.rect.flags & UiCommandFlag.focus)  *w4.drawColors = 3;
                w4.rect(command.rect.x, command.rect.y, command.rect.w, command.rect.h);
                break;
            case text:
                *w4.drawColors = 4;
                w4.text(command.text.ptr, command.text.area.x, command.text.area.y);
                break;
        }
    }
}
