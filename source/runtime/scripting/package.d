module runtime.scripting;
import engine;
public import lumars;
public import runtime.scripting.api;
public import runtime.scripting.utils;
import bindbc.lua;

public LuaState* kmLuaState;
public LuaState* kmLuaScene;

void kmLuaInit() {
    import bindbc.lua : luaL_newstate;
    kmLuaState = new LuaState(luaL_newstate());
    kmVNRegisterCharacterAPI();
    kmVNRegisterSceneAPI();
    kmVNRegisterAudioAPI();
    kmVNRegisterBootstrap();
    kmVNRegisterUtilsAPI();
    kmVNRegisterFlagsAPI();
}

void kmLuaStartGame() {
    kmLuaState.doString(cast(const(char)[])kmPakGetResource("bootstrap"));
    kmLuaState.getGlobal("bootstrap");
    kmLuaState.call(0, 0);
}