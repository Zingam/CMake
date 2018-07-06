// Third party libraries
#define _CRT_SECURE_NO_WARNINGS
#include <AL/alc.h>
#include <SDL.h>
#include <steam/steam_api.h>
#undef _CRT_SECURE_NO_WARNINGS
// C++ Standard Library
#include <iostream>

int main (int argc, char *argv [])
{
    auto device = alcOpenDevice (NULL);
    if (nullptr == device)
    {
        std::cout << "Unable to initialize OpenAL\n";
    }

    auto sdlResult = SDL_Init (SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    if (0 != sdlResult)
    {
        SDL_Log ("Unable to initialize SDL: %s", SDL_GetError ());
    }

    auto isSteamInitialized = SteamAPI_Init ();
    if (!isSteamInitialized)
    {
        std::cout << "Unable to initialize Steam\n";
    }

    return 0;
}
