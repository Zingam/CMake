#include <vpx/vp8dx.h>
#include <vpx/vpx_decoder.h>

#include <cstdio>

struct VP8
{
    vpx_codec_ctx Context;
    vpx_codec_iface_t* Interface = vpx_codec_vp8_dx ();
    vpx_codec_dec_cfg* DecoderConfiguration = nullptr;
    vpx_codec_flags_t Flags = 0;
} codec_VP8;

struct VP9
{
    vpx_codec_ctx Context;
    vpx_codec_iface_t* Interface = vpx_codec_vp9_dx ();
    vpx_codec_dec_cfg* DecoderConfiguration = nullptr;
    vpx_codec_flags_t Flags = 0;
} codec_VP9;

int main (int argc, char* argv []) 
{
    // VP8
    auto result = vpx_codec_dec_init (
        &codec_VP8.Context,
        codec_VP8.Interface,
        codec_VP8.DecoderConfiguration,
        codec_VP8.Flags
    );
    if (VPX_CODEC_OK != result)
    {
        printf ("VP8 decoder failed to initilize...");

        return result;
    }

    // VP9
    result = vpx_codec_dec_init (
        &codec_VP9.Context,
        codec_VP9.Interface,
        codec_VP9.DecoderConfiguration,
        codec_VP9.Flags
    );
    if (VPX_CODEC_OK != result)
    {
        printf ("VP9 decoder failed to initilize...");

        return result;
    }

    printf ("VP8/VP9 decoders initilized...");
}
