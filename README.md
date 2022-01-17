# VTGameJam Engine 2
Engine used for VTuber Game Jam 2022

&nbsp;  
&nbsp;  

## Dependencies
The Kitsunemimi engine requires the following dependencies to be present to work:
 * OpenAL Driver ([OpenAL-Soft included on Windows](https://github.com/kcat/openal-soft))
   * Driver REQUIRES support for the FLOAT32 OAL extension and audio files may only be mono or stereo.
 * OpenGL Driver
 * SDL2 2.0.12 or above
 * FreeType
 * Lua 5.2
 * Kosugi Maru Font (in [`res/fonts`](/res/fonts) w/ license)
 * PixelMPlus 10 Font (in [`res/fonts`](/res/fonts) w/ license)

On Windows these libraries are copied from the included libs/ folder.

&nbsp;  
&nbsp;  

## Compiling with LDC2
Compilation will fail with LDC2 on Windows due to difficulty finding the library files to link against,  
take the lib files from dangel and drop them in to this project's lib folder for LDC2 to work.