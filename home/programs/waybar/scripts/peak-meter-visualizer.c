/* PipeWire */
/* SPDX-FileCopyrightText: Copyright © 2022 Wim Taymans */
/* SPDX-License-Identifier: MIT */

/* Maxi's Notes */
/* i'm going to be so real i have no clue how any of this
 * works i kind of just kept adjusting things until it did...
 *
 * this is all based on the audio-capture example in the
 * pipewire project. i'm sure it is possible to make this
 * much more efficient but at this point it does what
 * i want it to and i don't really care. :( */

/*
 [title]
 Audio capture using \ref pw_stream "pw_stream".
 [title]
 */

#include <stdio.h>
#include <errno.h>
#include <math.h>
#include <signal.h>

#include <spa/param/audio/format-utils.h>

#include <pipewire/pipewire.h>

#define MIN_DB -120.0f  // Minimum dB Value
static float peak = 0.0f;
static float decay_factor = 0.95;

static char stars[] = "*************************************************************";

struct data {
        struct pw_main_loop *loop;
        struct pw_stream *stream;

        struct spa_audio_info format;
        unsigned move:1;
};

static float linear_to_db(float linear_amplitude) {
    // Avoid log of zero, return minimum dB if amplitude is zero
    if (linear_amplitude <= 0.0f) {
        return MIN_DB;
    }
    return 20.0f * log10f(linear_amplitude);
}

/* our data processing function is in general:
 *
 *  struct pw_buffer *b;
 *  b = pw_stream_dequeue_buffer(stream);
 *
 *  .. consume stuff in the buffer ...
 *
 *  pw_stream_queue_buffer(stream, b);
 */
static void on_process(void *userdata)
{
        struct data *data = userdata;
        struct pw_buffer *b;
        struct spa_buffer *buf;
        float *samples, max;
        float peak_db;
        uint32_t n, n_channels, n_samples, peak_adj;

        if ((b = pw_stream_dequeue_buffer(data->stream)) == NULL) {
                pw_log_warn("out of buffers: %m");
                return;
        }

        buf = b->buffer;
        if ((samples = buf->datas[0].data) == NULL)
                return;

        n_channels = data->format.info.raw.channels;
        n_samples = buf->datas[0].chunk->size / sizeof(float);

        max = 0.0f;
        // WARN: we are only capturing the first channel here!!!
        for (n = 0; n < n_samples; n += n_channels)
                max = fmaxf(max, samples[n]);

        peak = fmaxf(max, peak * decay_factor);
        peak_db = linear_to_db(peak);
        peak_adj = (uint32_t)SPA_CLAMPF(peak_db + 60, 0.f, 59.f);

        char* peak_class;

        if (peak_db > -10)
                peak_class = "peak";
        else if (peak_db > -20)
                peak_class = "warn";
        else
                peak_class = "safe";


        fprintf(stdout, "{\"text\":\"|%.*s%*s|\",\"class\":\"%s\"}\n",
                peak_adj+1, stars, 60 - peak_adj, "", peak_class);

        data->move = true;
        fflush(stdout);

        pw_stream_queue_buffer(data->stream, b);
}

/* Be notified when the stream param changes. We're only looking at the
 * format changes.
 */
static void
on_stream_param_changed(void *_data, uint32_t id, const struct spa_pod *param)
{
        struct data *data = _data;

        /* NULL means to clear the format */
        if (param == NULL || id != SPA_PARAM_Format)
                return;

        if (spa_format_parse(param, &data->format.media_type, &data->format.media_subtype) < 0)
                return;

        /* only accept raw audio */
        if (data->format.media_type != SPA_MEDIA_TYPE_audio ||
            data->format.media_subtype != SPA_MEDIA_SUBTYPE_raw)
                return;

        /* call a helper function to parse the format for us. */
        spa_format_audio_raw_parse(param, &data->format.info.raw);
}

static const struct pw_stream_events stream_events = {
        PW_VERSION_STREAM_EVENTS,
        .param_changed = on_stream_param_changed,
        .process = on_process,
};

static void do_quit(void *userdata, int signal_number)
{
        struct data *data = userdata;
        pw_main_loop_quit(data->loop);
}

int main(int argc, char *argv[])
{
        struct data data = { 0, };
        const struct spa_pod *params[1];
        uint8_t buffer[1024];
        struct pw_properties *props;
        struct spa_pod_builder b = SPA_POD_BUILDER_INIT(buffer, sizeof(buffer));

        pw_init(&argc, &argv);

        /* make a main loop. If you already have another main loop, you can add
         * the fd of this pipewire mainloop to it. */
        data.loop = pw_main_loop_new(NULL);

        pw_loop_add_signal(pw_main_loop_get_loop(data.loop), SIGINT, do_quit, &data);
        pw_loop_add_signal(pw_main_loop_get_loop(data.loop), SIGTERM, do_quit, &data);

        /* Create a simple stream, the simple stream manages the core and remote
         * objects for you if you don't need to deal with them.
         *
         * If you plan to autoconnect your stream, you need to provide at least
         * media, category and role properties.
         *
         * Pass your events and a user_data pointer as the last arguments. This
         * will inform you about the stream state. The most important event
         * you need to listen to is the process event where you need to produce
         * the data.
         */
        props = pw_properties_new(PW_KEY_MEDIA_TYPE, "Audio",
                        PW_KEY_CONFIG_NAME, "client-rt.conf",
                        PW_KEY_MEDIA_CATEGORY, "Capture",
                        PW_KEY_MEDIA_ROLE, "Music",
                        NULL);
        if (argc > 1)
                /* Set stream target if given on command line */
                pw_properties_set(props, PW_KEY_TARGET_OBJECT, argv[1]);

        /* uncomment if you want to capture from the sink monitor ports */
        /* pw_properties_set(props, PW_KEY_STREAM_CAPTURE_SINK, "true"); */

        data.stream = pw_stream_new_simple(
                        pw_main_loop_get_loop(data.loop),
                        "audio-capture",
                        props,
                        &stream_events,
                        &data);

        /* Make one parameter with the supported formats. The SPA_PARAM_EnumFormat
         * id means that this is a format enumeration (of 1 value).
         * We leave the channels and rate empty to accept the native graph
         * rate and channels. */
        params[0] = spa_format_audio_raw_build(&b, SPA_PARAM_EnumFormat,
                        &SPA_AUDIO_INFO_RAW_INIT(
                                .format = SPA_AUDIO_FORMAT_F32));
                                // .rate   = 8000));

        /* Now connect this stream. We ask that our process function is
         * called in a realtime thread. */
        pw_stream_connect(data.stream,
                          PW_DIRECTION_INPUT,
                          PW_ID_ANY,
                          PW_STREAM_FLAG_AUTOCONNECT |
                          PW_STREAM_FLAG_MAP_BUFFERS |
                          PW_STREAM_FLAG_RT_PROCESS,
                          params, 1);

        /* and wait while we let things run */
        pw_main_loop_run(data.loop);

        pw_stream_destroy(data.stream);
        pw_main_loop_destroy(data.loop);
        pw_deinit();

        return 0;
}
