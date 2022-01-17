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
        kmCharacters[name] = Character(
            name, 
            expressions, 
            expressions.length == 0 ? null : expressions["neutral"], 
            false
        );
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
            try {
                kmCharacters[table.get!string("name")].shown = false;
            } catch (Exception ex) {
                AppLog.error(table.get!string("name")~"->hide", ex.msg);
            }
        };

        t["show"] = (LuaTable table) {
            try {
                kmCharacters[table.get!string("name")].shown = true;
            } catch (Exception ex) {
                AppLog.error(table.get!string("name")~"->show", ex.msg);
            }
        };

        t["destroy"] = (LuaTable table) {
            try {
                kmCharacters.remove(table.get!string("name"));
            } catch (Exception ex) {
                AppLog.error(table.get!string("name")~"->destroy", ex.msg);
            }
        };

        t["move"] = (LuaTable table, int position) {
            try {
                kmCharacters[table.get!string("name")].position = position;
            } catch (Exception ex) {
                AppLog.error(table.get!string("name")~"->move", ex.msg);
            }
        };

        t["expr"] = (LuaTable table, string expression) {
            try {
                kmCharacters[table.get!string("name")].currentTexture =
                    kmCharacters[table.get!string("name")].expressions[expression];
                kmCharacters[table.get!string("name")].yOffset = 8f;
            } catch (Exception ex) {
                AppLog.error(table.get!string("name")~"->expr", ex.msg);
            }
        };

        t["jump"] = (LuaTable table, float height) { 
            kmCharacters[table.get!string("name")].yOffset = height;
        };

        auto mt = LuaTable.makeNew(kmLuaState);
        mt["__call"] = (LuaState* state, LuaTable table, string dialogue) {
            try {
                kmText.push(table.get!string("name"), dialogue);
                kmCharacters[table.get!string("name")].yOffset = 8f;
                kmLuaYield(state);
            } catch (Exception ex) {
                AppLog.error(table.get!string("name")~"->__call", ex.msg);
            }
        };
        t.setMetatable(mt);
        return t;
    });
    kmLuaState.setGlobal("define");

    kmLuaState.push((LuaState* state, string dialogue) {
        try {
            kmText.push("", dialogue);
            kmLuaYield(state);
        } catch (Exception ex) {
            AppLog.error("CharAPI->think", ex.msg);
        }
    });
    kmLuaState.setGlobal("think");

    kmLuaState.push((LuaState* state, string dialogue, string[] choices) {
        try {
            kmText.pushQuestions(dialogue, choices);
            kmLuaYield(state);
        } catch (Exception ex) {
            AppLog.error("CharAPI->choice", ex.msg);
        }
    });
    kmLuaState.setGlobal("choice");
}

void kmVNRegisterSceneAPI() {
    kmLuaState.register!(
        "bg", (string bg) {
            try {
                kmChangeBG(bg.length == 0 ? null : new Texture(kmPakGetResource(bg), bg), bg);
            } catch (Exception ex) {
                AppLog.error("SceneAPI->bg", ex.msg);
            }
        },
        "cg", (string cg) {
            try {
                kmChangeCG(new Texture(kmPakGetResource(cg), cg));
            } catch (Exception ex) {
                AppLog.error("SceneAPI->cg", ex.msg);
            }
        },
        "popcg", () {
            try {
                kmChangeCG(null);
            } catch (Exception ex) {
                AppLog.error("SceneAPI->popcg", ex.msg);
            }
        },
        "change", (LuaState* state, string scene) {
            try {
                kmSwitchScene(scene.idup);
                kmLuaYield(state);
            } catch (Exception ex) {
                AppLog.error("SceneAPI->change", ex.msg);
            }
        }
    )("scene");
}

bool[string] kmFlags;
void kmVNRegisterFlagsAPI() {
    kmLuaState.register!(
        "set", (string flag) {
            kmFlags[flag] = true;
        },
        "unset", (string flag) {
            kmFlags[flag] = false;
        },
        "hasflag", (string flag) {
            return (flag in kmFlags) !is null ? kmFlags[flag] : false;
        },
    )("flags");
}

void kmVNRegisterUtilsAPI() {
    kmLuaState.push((LuaState* state) {
        kmLuaYield(state);
    });
    kmLuaState.setGlobal("yield");

    kmLuaState.push((LuaState* state, string title) {
        GameWindow.title = title;
    });
    kmLuaState.setGlobal("set_title");

    kmLuaState.push((LuaState* state) {
        // Exit the game
        GameWindow.close();
        kmLuaYield(state);
    });
    kmLuaState.setGlobal("exit");

    // Create persistant storage
    LuaTable t = LuaTable.makeNew(kmLuaState);
    t.push();
    kmLuaState.setGlobal("_STORE");
}

void kmVNRegisterAudioAPI() {
    kmLuaState.push((LuaState* state, string sfx) {

        // Load sound if need be
        if (sfx !in kmLoadedSFX) {
            try {
                kmLoadedSFX[sfx] = new Sound(kmPakGetResource(sfx));
            } catch (Exception ex) {
                AppLog.error("AudioEngine", "%s: %s", sfx, ex.msg);
            }
        }
    });
    kmLuaState.setGlobal("load_sfx");

    kmLuaState.push((LuaState* state, string sfx, bool looping) {
        
        kmLoadedSFX[sfx].setLooping(looping);
        kmLoadedSFX[sfx].play(0.65f);
    });
    kmLuaState.setGlobal("play_sfx");

    kmLuaState.push((LuaState* state, string sfx) {
        kmLoadedSFX[sfx].stop();
    });
    kmLuaState.setGlobal("stop_sfx");

    kmLuaState.push((LuaState* state, string sfx) {
        
        // Load sound if need be
        if (sfx in kmLoadedSFX) kmLoadedSFX.remove(sfx);
    });
    kmLuaState.setGlobal("unload_sfx");

    kmLuaState.push((LuaState* state, string bgm) {
        if (kmPlayingMusic) kmPlayingMusic.stop();
        if (bgm.length > 0) {
            kmPlayingMusic = new Music(kmPakGetResource(bgm));
            kmPlayingMusic.setLooping(true);
            kmPlayingMusic.play(0.5f);
        } else kmPlayingMusic = null;
    });
    kmLuaState.setGlobal("play_bgm");
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