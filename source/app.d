module app;
import engine;
import rt = runtime;

int main(string[] args) {

    // Set the function pointers
    kmInit = &rt._init;
    kmUpdate = &rt._update;
    kmCleanup = &rt._cleanup;
    kmBorder = &rt._border;
    kmPostUpdate = &rt._postUpdate;

    // Init engine start the game and then close the engine once the game quits
    initEngine();
    startGame(args[1..$], vec2i(1920/2, 1080/2));
    closeEngine();
    return 0;
}