#include <opus/opus.h>

#include <stdio.h>

const opus_int32 SampleRate = 48000;
const int ChannelCount = 2;

int main (int argc, char* argv [])
{
    int error = OPUS_OK;
    OpusDecoder* opusDecoder = opus_decoder_create (
        SampleRate,
        ChannelCount,
        &error
    );
    if (OPUS_OK != error)
    {
        printf ("Opus decoder failed to initilize...");

        return error;
    }

    printf ("Opus decoder initialized...");

    opus_decoder_destroy (opusDecoder);
}
