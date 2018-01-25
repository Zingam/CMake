#include <AL/al.h>
#include <AL/alc.h>

#include <stdio.h>

int main (int argc, char **argv)
{
    ALCdevice *device;
    ALCcontext *ctx;

    ALCboolean enumeration = alcIsExtensionPresent (NULL, "ALC_ENUMERATION_EXT");
    if (AL_FALSE == enumeration)
    {
        printf ("[%s] enumeration extension not available", __func__);
    }

    // Retrieve a list of available devices. Each device name is separated by a
    // single NULL character and the list is terminated with 2 NULL characters
    const ALchar* deviceNameList = alcGetString (NULL, ALC_DEVICE_SPECIFIER);

    // Retrieve the default device name
    const ALchar* defaultDeviceName = alcGetString (NULL, ALC_DEFAULT_DEVICE_SPECIFIER);

    // Open the default device
    device = alcOpenDevice (defaultDeviceName);
    if (!device) {
        printf ("[%s] unable to open default device", __func__);

        return 1;
    }

    printf ("[%s] Device: %s ", __func__, alcGetString (device, ALC_DEVICE_SPECIFIER));

    ctx = alcCreateContext (device, NULL);
    alcMakeContextCurrent (ctx);
    if (!ctx)
    {
        printf ("[%s] unable to create context", __func__);

        return 1;
    }

    alcMakeContextCurrent (NULL);
    alcDestroyContext (ctx);
    alcCloseDevice (device);
}
