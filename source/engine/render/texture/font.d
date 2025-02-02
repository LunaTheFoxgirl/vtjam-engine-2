/*
    Copyright © 2020, Luna Nielsen
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
module engine.render.texture.font;
import bindbc.freetype;
import std.exception;
import std.conv : text;
import std.string;
import std.format;
import engine;

private {
    FT_Library lib;
    Shader fontShader;
    Camera2D fontCamera;

    // VAO and VP can be reused
    GLuint vao;
    GLint vp;

    /// How many entries in a Font batch
    enum EntryCount = 10_000;

    // Various variables that make it easier to reference sizes
    enum VecSize = 2;
    enum UVSize = 2;
    enum ColorSize = 4;
    enum VertsCount = 6;
    enum DataLength = VecSize+UVSize+ColorSize;
    enum DataSize = DataLength*VertsCount;

    vec2 transformVerts(vec2 position, mat4 matrix) {
        return vec2(matrix*vec4(position.x, position.y, 0, 1));
    }

    vec2 transformVertsR(vec2 position, mat4 matrix) {
        return vec2(vec4(position.x, position.y, 0, 1)*matrix);
    }
}

private string chosenFont;

/**
    Public instance of Kosugi Maru
*/
Font[string] GameFonts;

/**
    The "default" font
*/
Font GameFont;

/**
    Data of Kosugi Maru
*/
ubyte[] KOSUGI_MARU = cast(ubyte[])import("fonts/KosugiMaru.ttf");

/**
    Data of Pixel MPlus 10
*/
ubyte[] PIXEL_M_PLUS_10 = cast(ubyte[])import("fonts/PixelMPlus10.ttf");

/**
    Initialize the font subsystem
*/
void initFontSystem() {
    int err = FT_Init_FreeType(&lib);
    if (err != FT_Err_Ok) {
        AppLog.fatal("Font System", "FreeType returned error %s", err);
    }

    // Set up batching
    glGenVertexArrays(1, &vao);

    fontCamera = new Camera2D();
    fontShader = new Shader(import("shaders/font.vert"), import("shaders/font.frag"));
    vp = fontShader.getUniformLocation("vp");

    // The game's font
    GameFonts["KosugiMaru"] = new Font("Kosugi Maru", KOSUGI_MARU, 24);
    GameFonts["PixelMPlus10"] = new Font("PixelM+ 10", PIXEL_M_PLUS_10, 10);

    kmSwitchFont("PixelMPlus10");
}

/**
    Get the default size for the specified font
*/
int kmGetDefaultFontSizeFor(string name) {
    switch(name) {
        case "KosugiMaru": return 24;
        case "PixelMPlus10": return 10;
        default: return 16;
    }
}

/**
    Gets the default size for the current default font
*/
int kmGetDefaultFontSize() {
    switch(chosenFont) {
        case "kosugimaru": return 24;
        case "pixelmplus": return 10;
        default: return 16;
    }
}

/**
    Switch the default font
*/
void kmSwitchFont(string name) {
    chosenFont = name;
    switch(name) {
        case "kosugimaru": 
            GameFont = GameFonts["KosugiMaru"];
            break;
        
        case "pixelmplus":
            GameFont = GameFonts["PixelMPlus10"];
            break;

        default: 
            GameFont = GameFonts["PixelMPlus10"];
            chosenFont = "pixelmplus";
            break;
    }
}

/**
    A font
*/
class Font {
private:
    //
    //    Glyph managment
    //
    struct Glyph {
        vec4i area;
        vec2 advance;
        vec2 bearing;
    }

    struct GlyphIndex {
        dchar c;
        int size;
    }

    vec2 metrics;

    ubyte[] faceMemory;

    FT_Face fontFace;
    TexturePacker fontPacker;
    Texture fontTexture;
    Glyph[GlyphIndex] glyphs;
    int size;
    float scale = 1;
    bool hasVertical;

    string name;

    // Generates glyph for the specified character
    bool genGlyphFor(dchar c) {

        // Find the character's index in the font
        uint index = FT_Get_Char_Index(fontFace, c);

        // Load it if possible, otherwise tell the outside code
        FT_Load_Glyph(fontFace, index, FT_LOAD_RENDER);
        if (fontFace.glyph is null) return false;

        // Get width/height of character
        immutable(uint) width = fontFace.glyph.bitmap.width;
        immutable(uint) height = fontFace.glyph.bitmap.rows;

        // Get length of pixel data, then get it in to a slice
        size_t dataLength = fontFace.glyph.bitmap.pitch*fontFace.glyph.bitmap.rows;
        ubyte[] pixData = fontFace.glyph.bitmap.buffer[0..dataLength];

        // Find space in the texture and pack the glyph in there
        vec4i area = fontPacker.packTexture(vec2i(width, height));
        fontTexture.setDataRegion(pixData, area.x, area.y, width, height);

        // Add glyph to listing
        glyphs[GlyphIndex(c, size)] = Glyph(
            // Area (in texture)
            area, 

            // Advance
            vec2(fontFace.glyph.advance.x >> 6, fontFace.glyph.advance.y >> 6), 

            // Bearing
            vec2(fontFace.glyph.bitmap_left, fontFace.glyph.bitmap_top)
        );
        return true;
    }

    //
    //    Font Batching
    //
    float[DataSize*EntryCount] data;
    size_t dataOffset;
    size_t tris;

    GLuint buffer;

    void addVertexData(vec2 position, vec2 uvs, vec4 color) {
        data[dataOffset..dataOffset+DataLength] = [position.x, position.y, uvs.x, uvs.y, color.x, color.y, color.z, color.w];
        dataOffset += DataLength;
    }

    void init_(int canvasSize) {

        // Select unicode so we can render i18n text
        FT_Select_Charmap(fontFace, FT_ENCODING_UNICODE);

        // Create the texture
        fontTexture = new Texture(canvasSize, canvasSize, 1, 1);
        fontPacker = new TexturePacker(vec2i(canvasSize, canvasSize));
        
        // Make sure they are point filtered
        fontTexture.setFiltering(Filtering.Point);

        glBindVertexArray(vao);
        glGenBuffers(1, &buffer);
        glBindBuffer(GL_ARRAY_BUFFER, buffer);
        glBufferData(GL_ARRAY_BUFFER, float.sizeof*data.length, data.ptr, GL_DYNAMIC_DRAW);
    }

public:

    /**
        Gets the font metrics
    */
    vec2 getMetrics() {
        return metrics;
    }

    /**
        Destroys the font
    */
    ~this() {
        destroy(fontTexture);
        FT_Done_Face(fontFace);
        glDeleteBuffers(1, &buffer);

        // Destroy face memory if we loaded it from memory
        if (faceMemory !is null) {
            destroy(faceMemory);
        }
    }

    /**
        Constructs a new font

        canvasSize specifies how big the texture for the font will be.
    */
    this(string name, string file, int size, int canvasSize = 4096) {
        this.name = name;
        
        AppLog.info("FontLoader", "Loading [%s] from file [%s]...", name, file);
        int err = FT_New_Face(lib, file.toStringz, 0, &fontFace);

        enforce(err != FT_Err_Unknown_File_Format, "Unknown file format for %s".format(file));
        enforce(err == FT_Err_Ok, "Error %s while loading font file".format(err));

        // Check whether font supports vertical text
        hasVertical = FT_HAS_VERTICAL(fontFace);
        if (!hasVertical) AppLog.warn("FontLoader", "[%s] does not have vertical font metrics! Font metrics will be estimated, this may be innacurate.", name);

        // Change size of text
        this.setSize(size);

        // Initializes the texture
        this.init_(canvasSize);
    }

    /**
        Constructs a new font

        canvasSize specifies how big the texture for the font will be.
    */
    this(string name, ubyte[] memFace, int size, int canvasSize = 4096) {
        this.name = name;

        // Copy data from memFace
        import std.algorithm.mutation : copy;
        faceMemory = new ubyte[memFace.length];
        copy(memFace, faceMemory);

        AppLog.info("FontLoader", "Loading [%s] from memory with size %s", name, memFace.length);
        int err = FT_New_Memory_Face(lib, faceMemory.ptr, cast(int)faceMemory.length, 0, &fontFace);

        enforce(err != FT_Err_Unknown_File_Format, "Unknown file format");
        enforce(err == FT_Err_Ok, "Error %s while loading font file".format(err));

        // Check whether font supports vertical text
        hasVertical = FT_HAS_VERTICAL(fontFace);
        if (!hasVertical) AppLog.warn("FontLoader", "[%s] does not have vertical font metrics! Font metrics will be estimated, this may be innacurate.", name);

        // Change size of text
        this.setSize(size);

        // Initializes the texture
        this.init_(canvasSize);
    }


    //
    //    Glyph managment
    //

    /**
        Sets size of font
    */
    final void setSize(int size) {

        // Don't try to change size when it's the same
        if (size == this.size) return;

        // Set the size of the font
        FT_Set_Pixel_Sizes(fontFace, size, 0);
        metrics = vec2(size, fontFace.size.metrics.height >> 6);
        this.size = size;
    }

    final void setScale(float scale=1) {
        this.scale = scale;
    }

    /**
        Gets the advance of a glyph
    */
    vec2 advance(dchar glyph) {
        
        // Newline is special
        if (glyph == '\n') return vec2(0);

        auto idx = GlyphIndex(glyph, size);

        // Make sure glyph is present
        if (idx !in glyphs) enforce(genGlyphFor(glyph), "Could not find glyph for character %s".format(glyph));
        
        // Return the advance of the glyphs
        return glyphs[idx].advance*scale;
    }

    /**
        Measure size (width, height) of rectangle needed to contain the specified text
    */
    vec2 measure(dstring text) {

        int lines = 1;
        float curLineLen = 0;
        vec2 size = vec2(0);
        
        foreach(dchar c; text) {
            if (c == '\n') {
                lines++;
                curLineLen = 0;
                continue;
            }

            auto idx = GlyphIndex(c, this.size);

            // Try to generate glyph if not present
            if (idx !in glyphs) {
                genGlyphFor(c);

                // At this point if the glyph does not exist, skip it
                if (idx !in glyphs) continue;
            }

            // Bitshift the X advance to make it be in pixels.
            curLineLen += glyphs[idx].advance.x;

            // Update the bounding box if the length extends
            if (curLineLen > size.x) size.x = curLineLen;
        }
        size.y = metrics.y*lines;
        return size*scale;
    }


    //
    //    Font Batching
    //

    /**
        Basic string draw function for right-to-left vertical text

        If font does not have vertical metrics the implementation will try to estimate some
        rounded to the nearest pixel

        This only works for languages where text is monspaced (Japanese and Chinese for example)
        As well only languages that are read right-to-left when vertical.
    */
    void drawVertical(bool outline=false)(dstring text, vec2 position, vec4 color=vec4(1), vec4 outlineColor=vec4(0,0,0,1)) {
        
        position.x -= metrics.x;
        
        vec2 next = position;
        size_t line;

        foreach(dchar c; text) {  

            // Skip newline
            if (c == '\n') {
                line++;
                next.x -= metrics.x;
                next.y = position.y;
                continue;
            }

            auto idx = GlyphIndex(c, size);
                  
            // Load character if neccesary
            if (idx !in glyphs) {
                genGlyphFor(c);

                // At this point if the glyph does not exist, skip it
                if (idx !in glyphs) continue;
            }

            static if (outline) drawOutline(c, next, vec2(0), 0, outlineColor);
            draw(c, next, vec2(0), 0, color);
            
            if (hasVertical) {
                next.y += glyphs[idx].advance.y;
            } else {
                next.y += round(metrics.y*1.05);
            }
        }
    }
    alias drawVerticalWithOutline = drawVertical!true;

    /**
        Basic string draw function
    */
    void draw(bool outline=false)(dstring text, vec2 position, vec4 color=vec4(1), vec4 outlineColor=vec4(0,0,0,1)) {
        vec2 next = position;
        size_t line;

        foreach(dchar c; text) {  

            // Skip newline
            if (c == '\n') {
                line++;
                next.x = position.x;
                next.y += metrics.y;
                continue;
            }

            auto idx = GlyphIndex(c, size);
                  
            // Load character if neccesary
            if (idx !in glyphs) {
                genGlyphFor(c);

                // At this point if the glyph does not exist, skip it
                if (idx !in glyphs) continue;
            }

            static if (outline) drawOutline(c, next, vec2(0), 0, outlineColor);
            draw(c, next, vec2(0), 0, color);
            next.x += glyphs[idx].advance.x;
        }
    }
    
    alias drawWithOutline = draw!true;

    /**
        Draws a character with a 1x1 outline
    */
    void drawOutline(dchar c, vec2 position, vec2 origin=vec2(0), float rotation=0, vec4 outlineColor=vec4(0,0,0,1)) {
        draw(c, vec2(position.x-1, position.y), origin, rotation, outlineColor);
        draw(c, vec2(position.x+1, position.y), origin, rotation, outlineColor);
        draw(c, vec2(position.x, position.y-1), origin, rotation, outlineColor);
        draw(c, vec2(position.x, position.y+1), origin, rotation, outlineColor);
    }

    /**
        draws a character
    */
    void draw(dchar c, vec2 position, vec2 origin=vec2(0), float rotation=0, vec4 color=vec4(1)) {
        
        auto idx = GlyphIndex(c, size);

        // Load character if neccesary
        if (idx !in glyphs) {
            genGlyphFor(c);

            // At this point if the glyph does not exist, skip it
            if (idx !in glyphs) return;
        }

        // Flush if neccesary
        if (dataOffset == DataSize*EntryCount) flush();
        vec4 area = glyphs[idx].area;
        vec2 bearing = glyphs[idx].bearing;

        vec2 pos = vec2(
            position.x + bearing.x,
            (position.y - bearing.y)+metrics.y
        );

        pos *= scale;

        mat4 transform =
            mat4.translation(-origin.x, -origin.y, 0) *
            mat4.translation(pos.x, pos.y, 0) *
            mat4.translation(origin.x, origin.y, 0) *
            mat4.zrotation(rotation) * 
            mat4.translation(-origin.x, -origin.y, 0) *
            mat4.scaling(area.z*scale, area.w*scale, 0);


        vec4 uvArea = vec4(
            (area.x)+0.25,
            (area.y)+0.25,
            (area.x+area.z)-0.25,
            (area.y+area.w)-0.25,
        );

        // Triangle 1
        addVertexData(vec2(0, 1).transformVerts(transform), vec2(uvArea.x, uvArea.w), color);
        addVertexData(vec2(1, 0).transformVerts(transform), vec2(uvArea.z, uvArea.y), color);
        addVertexData(vec2(0, 0).transformVerts(transform), vec2(uvArea.x, uvArea.y), color);
        
        // Triangle 2
        addVertexData(vec2(0, 1).transformVerts(transform), vec2(uvArea.x, uvArea.w), color);
        addVertexData(vec2(1, 1).transformVerts(transform), vec2(uvArea.z, uvArea.w), color);
        addVertexData(vec2(1, 0).transformVerts(transform), vec2(uvArea.z, uvArea.y), color);

        tris += 2;
    }

    /**
        Flush font rendering
    */
    void flush() {

        // Disable depth testing for the batcher
        glDisable(GL_DEPTH_TEST);
        // Bind VAO
        glBindVertexArray(vao);

        // Bind just in case some shennanigans happen
        glBindBuffer(GL_ARRAY_BUFFER, buffer);

        // Update with this draw round's data
        glBufferSubData(GL_ARRAY_BUFFER, 0, dataOffset*float.sizeof, data.ptr);

        // Bind the texture
        fontTexture.bind();

        // Use our sprite batcher shader
        fontShader.use();
        fontShader.setUniform(vp, fontCamera.matrix);

        // Vertex Buffer
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(
            0,
            VecSize,
            GL_FLOAT,
            GL_FALSE,
            DataLength*GLfloat.sizeof,
            null,
        );

        // UV Buffer
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(
            1,
            UVSize,
            GL_FLOAT,
            GL_FALSE,
            DataLength*GLfloat.sizeof,
            cast(GLvoid*)(UVSize*GLfloat.sizeof),
        );

        // UV Buffer
        glEnableVertexAttribArray(2);
        glVertexAttribPointer(
            2,
            ColorSize,
            GL_FLOAT,
            GL_FALSE,
            DataLength*GLfloat.sizeof,
            cast(GLvoid*)((VecSize+UVSize)*GLfloat.sizeof),
        );

        // Draw the triangles
        glDrawArrays(GL_TRIANGLES, 0, cast(int)(tris*3));

        // Reset the batcher's state
        glDisableVertexAttribArray(0);
        glDisableVertexAttribArray(1);
        glDisableVertexAttribArray(2);
        dataOffset = 0;
        tris = 0;

        // Re-enable depth test Clear depth buffer
        glEnable(GL_DEPTH_TEST);
    }

}