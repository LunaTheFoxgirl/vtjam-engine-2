module runtime.elements.textrenderer;
import engine;
import std.conv;
import std.random : uniform01;

class DialogueRenderer {
private:
    dstring currentString;
    dstring speaker;
    dstring[] questions;
    bool done;
    size_t index;

    ptrdiff_t selected = 0;

public:
    void push(string speaker, string dialogue) {
        this.speaker = kmToEngineString(speaker);
        this.currentString = kmToEngineString(dialogue);
        this.questions = null;
        done = false;
        index = 0;

        if (dialogue.length == 0) {
            done = true;
            index = 1;
        }
    }

    void pushQuestions(string dialogue, string[] questions) {
        this.currentString = kmToEngineString(dialogue);
        this.speaker = "";
        done = false;
        index = 0;
        
        foreach(question; questions) {
            this.questions ~= kmToEngineString(question);
        } 
    }

    bool isDone() {
        return done;
    }

    bool isQuestion() {
        return questions.length > 0;
    }

    void skip() {
        done = true;
        index = currentString.length-1;
    }

    void selNext() {
        selected++;
        if (selected >= questions.length) selected = questions.length-1;
    }

    void selPrev() {
        selected--;
        if (selected < 0) selected = 0;
    }

    int selToLua() {
        return cast(int)selected+1;
    }

    ptrdiff_t accum;
    ptrdiff_t accumWait = 4;
    void update() {
        if (currentString.length == 0) return;

        if (accum < accumWait) {
            accum++;
        } else {
            accum = 0;
            if (index+1 <= currentString.length) {

                // Skip whitespace
                while(index+1 < currentString.length && currentString[index+1] == ' ') index++;

                while(currentString[index++] == '§') {
                    dchar cmd = currentString[index];
                    switch(cmd) {
                        case 'r': index++; break;
                        case 'w': index++; break;
                        case 's': index++; break;
                        case 'p': accum = -(accumWait*2); index++; return;
                        case 'c': index += 9; break;
                        default: break;
                    }
                }
            } else done = true;
        }
    }

    void drawFormatted(vec2 position, dstring text, vec4 color = vec4(1, 1, 1, 1)) {
        if (currentString.length == 0) return;
        
        vec2 offset = vec2(0, 0);
        vec2 next = position;
        size_t line;

        size_t i;
        size_t rendered;
        bool shake;
        bool wave;

        void render(dchar c) {

            if (wave) {
                offset.x = 0;
                offset.y = sin((currTime()*2)+cast(float)rendered)*4;
            } else if (shake) {
                offset.x = uniform01()*2;
                offset.y = uniform01()*2;
            } else {
                offset.x = 0;
                offset.y = 0;
            }

            // Skip newline
            if (c == '\n') {
                line++;
                next.x = position.x;
                next.y += GameFont.getMetrics().y;
                return;
            }

            GameFont.drawOutline(c, next+offset);
            GameFont.draw(c, next+offset, vec2(0), 0, color);
            next.x += GameFont.advance(c).x;
            rendered++;
        }

        while (i < text.length) {
            
            dchar c = text[i];
            if (c == '§') {
                dchar cmd = text[i+1];
                switch(cmd) {
                    case 'r': 
                        i += 2;
                        wave = false;
                        shake = false;
                        color = vec4(1, 1, 1, 1);
                        break;

                    case 'w':
                        i += 2;
                        wave = !wave;
                        break;

                    case 's':
                        i += 2;
                        shake = !shake;
                        break;

                    case 'p': i += 2; break; // Skip P as it's a speed adjusting rule
                    
                    case 'c':
                        i += 2;
                        if (i+8 < index) {
                            dstring hexcode = text[i..i+=8];
                            ubyte r = to!ubyte(hexcode[0..2], 16);
                            ubyte g = to!ubyte(hexcode[2..4], 16);
                            ubyte b = to!ubyte(hexcode[4..6], 16);
                            ubyte a = to!ubyte(hexcode[6..8], 16);

                            color = vec4(
                                cast(float)r/255f,
                                cast(float)g/255f,
                                cast(float)b/255f,
                                cast(float)a/255f,
                            );
                        }
                        break;
                    default: 
                        render(cmd);
                        i++;
                        break;
                }
            } else {
                render(c);
                i++;
            }
        }
    }

    void draw(vec2 position) {
        GameFont.setSize(20);
        if (currentString.length == 0) return;
        
        if (isQuestion) {
            this.drawFormatted(position, currentString[0..index]);
            if (isDone) {
                vec2 offset = GameFont.measure(currentString[0..index]);
                foreach(i, question; questions) {
                    this.drawFormatted(
                        position+vec2(64, offset.y), 
                        selected == i ? "> "d~question : "  "d~question, 
                        selected == i ? vec4(1, 1, 0, 1) : vec4(1, 1, 1, 1)
                    );
                    offset.y += GameFont.measure(question).y;
                }
            }
        } else {
            this.drawFormatted(position, currentString[0..index]);
        }

        if (speaker.length > 0) {
            GameFont.draw!true(speaker, vec2(position.x-16, position.y-28));
        }

        GameFont.flush();
    }
}