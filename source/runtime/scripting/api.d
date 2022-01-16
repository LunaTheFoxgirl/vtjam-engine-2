module runtime.scripting.api;
import runtime.elements;
import runtime.scripting;
import runtime.ingame;
import engine;
import std.stdio : writeln;
import taggedalgebraic.taggedunion;
import std.format;

void kmVNRegisterCharacterAPI() {
    kmLuaState.push((string name, string[string] expressions) {

        // Set it in the global characters store
        kmCharacters[name] = Character(name, expressions, expressions["neutral"], false);
        foreach(expr, path; expressions) {
            GameAtlas.add(
                path,
                ShallowTexture(kmPakGetResource(path), expr)
            );
        }

        auto t = LuaTable.makeNew(kmLuaState);
        t["expressions"] = expressions;
        t["name"] = name;
        t["hide"] = (LuaTable table) {
            kmCharacters[table.get!string("name")].shown = false;
        };

        t["show"] = (LuaTable table) {
            kmCharacters[table.get!string("name")].shown = true;
        };

        t["destroy"] = (LuaTable table) {
            kmCharacters.remove(table.get!string("name"));
        };

        t["move"] = (LuaTable table, int position) {
            kmCharacters[table.get!string("name")].position = position;
        };

        t["expr"] = (LuaTable table, string expression) {
            kmCharacters[table.get!string("name")].currentTexture =
                kmCharacters[table.get!string("name")].expressions[expression];
        };

        t["jump"] = (LuaTable table, float height) { 
            kmCharacters[table.get!string("name")].yOffset = height;
        };

        auto mt = LuaTable.makeNew(kmLuaState);
        mt["__call"] = (LuaState* state, LuaTable table, string dialogue) {
            kmText.push(table.get!string("name"), dialogue);
            kmCharacters[table.get!string("name")].yOffset = 8f;
            kmLuaYield(state);
        };
        t.setMetatable(mt);
        return t;
    });
    kmLuaState.setGlobal("define");

    kmLuaState.push((string dialogue) {
        kmText.push("", dialogue);
    });
    kmLuaState.setGlobal("think");

    kmLuaState.push((LuaState* state) {
        kmLuaYield(state);
    });
    kmLuaState.setGlobal("yield");
}

void kmVNRegisterSceneAPI() {
    kmLuaState.register!(
        "bg", (string bg) {
            kmBackground = new Texture(kmPakGetResource(bg), bg);
        },
        "cg", (string cg) {
            kmActiveCG = new Texture(kmPakGetResource(cg), cg);
        },
        "popcg", () {
            kmActiveCG = null;
        },
        "change", (LuaState* state, string scene) {
            kmSwitchScene(scene.idup);
            kmLuaYield(state);
        }
    )("scene");
}

void kmVNRegisterBootstrap() {
    kmLuaState.push((string scene) {
        kmExecuteScene(scene);

        // Ensure we don't accidentally break anything
        kmLuaState.push(null);
        kmLuaState.setGlobal("start_scene");
    });
    kmLuaState.setGlobal("start_scene");
}

void kmExecuteScene(string scene) {
    kmLuaScene = kmLuaCreateThread(kmLuaState);
    kmLuaScene.loadString(cast(const(char)[])kmPakGetResource("scenes/"~scene));
    kmLuaResume(kmLuaScene);
}

//
// SCENE SWITCHING
//
private string sceneSwitchRequest;
void kmSwitchScene(string scene) {
    sceneSwitchRequest = scene;
}

void kmSceneUpdate() {
    if (sceneSwitchRequest) {
        kmLuaScene = kmLuaCreateThread(kmLuaState);
        kmLuaScene.loadString(cast(const(char)[])kmPakGetResource("scenes/"~sceneSwitchRequest));
        kmLuaResume(kmLuaScene);

        sceneSwitchRequest = null;
    }
}