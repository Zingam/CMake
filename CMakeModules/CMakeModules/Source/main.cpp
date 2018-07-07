// Third party libraries
#include <vpx/vp8dx.h>
#include <vpx/vpx_decoder.h>
#include <AL/alc.h>
#include <opus/opus.h>
#include <SDL.h>
#pragma warning (push)
// Disable warning about unsafe C runtime functions
#   pragma warning (disable: 4996)
#   include <steam/steam_api.h>
#pragma warning (pop)
#include <vorbis/codec.h>
// C++ Standard Library
#include <iostream>
#include <string>
#include <vector>
int main (int argc, char *argv [])
{
    std::vector<std::string> initializedLibraries;
    std::vector<std::string> uninitializedLibraries;

    struct VP8
    {
        vpx_codec_ctx Context;
        vpx_codec_iface_t* Interface = vpx_codec_vp8_dx ();
        vpx_codec_dec_cfg* DecoderConfiguration = nullptr;
        vpx_codec_flags_t Flags = 0;
    } codec_VP8;
    auto vpxResult = vpx_codec_dec_init (
        &codec_VP8.Context,
        codec_VP8.Interface,
        codec_VP8.DecoderConfiguration,
        codec_VP8.Flags
    );
    if (VPX_CODEC_OK == vpxResult)
    {
        initializedLibraries.emplace_back ("LibVPX: VP9 decoder");
    }
    else
    {
        uninitializedLibraries.emplace_back ("LibVPX: VP9 decoder");
    }

    struct VP9
    {
        vpx_codec_ctx Context;
        vpx_codec_iface_t* Interface = vpx_codec_vp9_dx ();
        vpx_codec_dec_cfg* DecoderConfiguration = nullptr;
        vpx_codec_flags_t Flags = 0;
    } codec_VP9;
    vpxResult = vpx_codec_dec_init (
        &codec_VP9.Context,
        codec_VP9.Interface,
        codec_VP9.DecoderConfiguration,
        codec_VP9.Flags
    );
    if (VPX_CODEC_OK == vpxResult)
    {
        initializedLibraries.emplace_back ("LibVPX: VP9 decoder");
    }
    else
    {
        uninitializedLibraries.emplace_back ("LibVPX: VP9 decoder");
    }

    auto device = alcOpenDevice (NULL);
    if (device)
    {
        initializedLibraries.emplace_back ("OpenAL");
    }
    else
    {
        uninitializedLibraries.emplace_back ("OpenAL");
    }

    const opus_int32 SampleRate = 48000;
    const int ChannelCount = 2;
    int opusError = OPUS_OK;
    OpusDecoder* opusDecoder = opus_decoder_create (
        SampleRate,
        ChannelCount,
        &opusError
    );
    if (OPUS_OK == opusError)
    {
        initializedLibraries.emplace_back ("Opus");
    }
    else
    {
        uninitializedLibraries.emplace_back ("Opus");
    }

    auto sdlResult = SDL_Init (SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    if (0 == sdlResult)
    {
        initializedLibraries.emplace_back ("SDL2");
    }
    else
    {
        std::string errorMessage = "SDL2 with error: " + std::string (SDL_GetError ());
        uninitializedLibraries.emplace_back (errorMessage);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Steam API documentation: https://partner.steamgames.com/doc/sdk/api
    ////////////////////////////////////////////////////////////////////////////
    // To initialize the Steam API an App ID is required. To provide an App ID
    // during development create the text file called steam_appid.txt next to
    // the executable containing just the App ID and nothing else.
    ////////////////////////////////////////////////////////////////////////////
    // Generic App ID: 480
    ////////////////////////////////////////////////////////////////////////////
    auto isSteamInitialized = SteamAPI_Init ();
    if (isSteamInitialized)
    {
        initializedLibraries.emplace_back ("Steam");
    }
    else
    {
        uninitializedLibraries.emplace_back ("Steam");
    }

    auto isSteamRunning = SteamAPI_IsSteamRunning ();
    if (isSteamRunning)
    {
        std::cout << "Steam is running...\n";
    }
    else
    {
        std::cout << "Steam is NOT running...\n";
    }

    std::cout << "The following libraries have been initialized:\n";
    for (auto& libraryName : initializedLibraries)
    {
        std::cout << "    " << libraryName << "\n";
    }

    if (0 < uninitializedLibraries.size ())
    {
        std::cout << "\n";
        std::cout << "The following libraries failed to initialize:\n";
        for (auto& libraryName : uninitializedLibraries)
        {
            std::cout << "    " << libraryName << "\n";
        }
    }

    return 0;
}
