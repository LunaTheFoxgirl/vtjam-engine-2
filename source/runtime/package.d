module runtime;
import engine;
import engine.ver;
import runtime.scripting;
import std.format;
import runtime.ingame;

enum NOT_FOUND_MSG = "Game content not found!\nMake sure the runtime executable is in the game directory.";

/**
    Initialize game
*/
void _init(string[] args) {
    GameWindow.setSwapInterval(SwapInterval.VSync);
    GameWindow.title = "VTGameJam2022 Game";

    if (kmPakGetCount() <= 0) {
        AppLog.error("Runtime", "No game content found!");
        throw new Exception(NOT_FOUND_MSG);
    }

    kmLuaInit();
    GameStateManager.push(new InGameState());
}

/**
    Update game
*/
void _update() {
    GameStateManager.update();
    GameStateManager.draw();
}

/**
    Game cleanup
*/
void _cleanup() {

}

/**
    Render border
*/
void _border() {

}

/**
    Post-update
*/
void _postUpdate() {

}