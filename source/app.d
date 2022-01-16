module app;
import engine;
import rt = runtime;
import std.path;
import std.file;
import std.array;
import std.datetime;
import std.stdio : writefln;

int main(string[] args) {

    if (args.length > 2 && args[1] == "--compile") {
        if (!exists("kmpak/")) mkdir("kmpak");
        foreach(arg; args[2..$]) {
            PakEntryBinding[] bindings;

            auto startTime = Clock.currStdTime();
            string fileName = buildPath("kmpak", baseName(arg)~".pak");
            foreach(DirEntry file; dirEntries(arg, SpanMode.depth, false)) {
                if (file.isSymlink()) continue;
                if (file.isDir()) continue;

                string entryPath = stripExtension(file.name());
                // Skip the first path entry
                entryPath = buildPath(entryPath.split(dirSeparator)[1..$]);

                // Create a binding from the file
                bindings ~= PakEntryBinding(0, entryPath, file.name());
            }

            auto endTime = Clock.currStdTime()-startTime;

            kmPakWriteToFile(bindings, fileName);
            writefln("Built %s in %s ms", fileName, cast(float)endTime/1000f);
        }
        return 0;
    }

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