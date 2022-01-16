module runtime.ingame;
import runtime.scripting;
import runtime.elements;
import engine;

public {
    Texture kmBackground;
    Texture kmActiveCG;
    DialogueRenderer kmText;

    bool hideTextbox;
    enum VISIBLE_ANIM_SPEED = 0.1;
}

class InGameState : GameState {
private:
    KeyboardState* lastState;
    KeyboardState* currState;

public:
    /**
        Constructor
    */
    this() {
        kmText = new DialogueRenderer();
        kmLuaStartGame();
        AppLog.info("Runtime", "Game started...");

        lastState = new KeyboardState;
        currState = new KeyboardState;

        GameAtlas.add("ui/speechbox", ShallowTexture(kmPakGetResource("ui/speechbox"), "ui/speechbox"));
    }

    /**
        Update the game state
    */
    override
    void update() {
        kmSceneUpdate();
        
        currState = Keyboard.getState();

        hideTextbox = false;
        if (currState.isKeyDown(Key.KeyLeftControl)) hideTextbox = true;
        
        if (!hideTextbox) {

            if (kmText.isQuestion()) {
                if (!lastState.isKeyDown(Key.KeyDown) && currState.isKeyUp(Key.KeyDown)) kmText.selNext();
                if (!lastState.isKeyDown(Key.KeyUp) && currState.isKeyUp(Key.KeyUp)) kmText.selPrev();
            }

            // Next dialog entry
            if (!lastState.isKeyDown(Key.KeySpace) && currState.isKeyUp(Key.KeySpace)) {
                if (!kmText.isDone) kmText.skip();
                else {
                    if (kmText.isQuestion()) {
                        kmLuaScene.push(kmText.selToLua());
                        kmLuaResume(kmLuaScene, 1);
                    } else kmLuaResume(kmLuaScene);
                }
            }
        }
            
        foreach(key, _; kmCharacters) {
            if (kmCharacters[key].yOffset > 0) {
                kmCharacters[key].yOffset -= 0.5f;
            }
        }

        kmText.update();

        lastState = currState;
    }

    /**
        Draw the game state
    */
    override
    void draw() {
        if (kmActiveCG) {
            GameBatch.draw(kmActiveCG, vec4(0, 0, kmCameraViewWidth(), kmCameraViewHeight()));
            GameBatch.flush();
        } else {
            if (kmBackground) {
                GameBatch.draw(kmBackground, vec4(0, 0, kmCameraViewWidth(), kmCameraViewHeight()));
                GameBatch.flush();
            }
        
            foreach(key, character; kmCharacters) {
                // Skip non-visible characters
                if (character.expressions.length == 0) continue;

                if (!character.shown) {
                    if (character.alpha > 0) kmCharacters[key].alpha = clamp(character.alpha-VISIBLE_ANIM_SPEED, 0, 1);
                    if (character.alpha == 0) continue;
                } else {
                    if (character.alpha < 1) kmCharacters[key].alpha = clamp(character.alpha+VISIBLE_ANIM_SPEED, 0, 1);
                }

                auto area = GameAtlas[character.currentTexture].area;
                auto size = vec2(area.z/2, area.w/2);
                
                float pos = 128;
                switch(character.position) {
                    case 0:
                        pos = 128;
                        break;
                    case 1:
                        pos = kmCameraViewWidth/2;
                        break;
                    case 2:
                        pos = kmCameraViewWidth-128;
                        break;
                    default: pos = kmCameraViewWidth/2; break;
                }

                GameBatch.draw(character.currentTexture, vec4(
                        pos,
                        (kmCameraViewHeight+128)-character.yOffset,
                        size.x/2, size.y/2
                    ), 
                    vec4.init, 
                    vec2(size.x/4, size.y/2), 
                    0, 
                    SpriteFlip.None, 
                    vec4(1, 1, 1, character.alpha)
                );
            }
            GameBatch.flush();
        }

        // Textbox
        if (!hideTextbox) {
            enum TextboxHeight = (20*5)+16;
            GameBatch.draw("ui/speechbox", vec4(64, kmCameraViewHeight-TextboxHeight-48, GameAtlas["ui/speechbox"].area.z, GameAtlas["ui/speechbox"].area.w));
            GameBatch.flush();
            kmText.draw(vec2(96, kmCameraViewHeight-TextboxHeight-16));
        }
    }
}