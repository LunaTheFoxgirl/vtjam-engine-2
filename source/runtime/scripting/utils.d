module runtime.scripting.utils;
import bindbc.lua;
import lumars;
import std.stdio;
import std.string;

/**
    Creates Lua thread
*/
LuaState* kmLuaCreateThread(LuaState* parent) {
    return new LuaState(lua_newthread(parent.handle));
}

/**
    Yields Lua thread
*/
void kmLuaYield(LuaState* state, int args = 0) {
    int status = lua_yield(state.handle, args);
}

/**
    Resumes Lua thread
*/
int kmLuaResume(LuaState* state, int args = 0) {
    int status = lua_resume(state.handle, null, args);
    return status;
}