module runtime.elements.character;
import engine;

public Character[string] kmCharacters;

struct Character {
public:

    /**
        Display name of the character
    */
    string displayName;

    /**
        List of expressions a character can have.
        Expressions map directly to the file name
    */
    string[string] expressions;

    /**
        Currently assigned expression
    */
    string currentTexture;

    /**
        Whether the character is shown
    */
    bool shown = false;

    /**
        Onscreen position
    */
    int position;

    /**
        Offset to apply when someone is talking
    */
    float yOffset;
}