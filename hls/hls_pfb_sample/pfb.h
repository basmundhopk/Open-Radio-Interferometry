#ifndef PFB_H
#define PFB_H

#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>
#include <complex>
#include "hls_fft.h"

#define NUM_CHANNELS 4
#define FFT_LEN 1024
#define TAPS 4
#define TOTAL_SAMPLES (FFT_LEN * TAPS)

typedef ap_fixed<16, 1, AP_TRN, AP_SAT_SYM> data_t;
typedef ap_fixed<16, 1> fft_data_t;
typedef ap_fixed<16, 1, AP_TRN, AP_WRAP> coeff_t;
typedef ap_fixed<40, 4, AP_TRN, AP_WRAP> accum_fixed_t;

struct iq_sample_t {
    data_t i;
    data_t q;
};

struct parallel_sample_t {
    iq_sample_t ch[NUM_CHANNELS];
};

void read_inputs(
    hls::stream<data_t> &din_i0, hls::stream<data_t> &din_q0,
    hls::stream<data_t> &din_i1, hls::stream<data_t> &din_q1,
    hls::stream<data_t> &din_i2, hls::stream<data_t> &din_q2,
    hls::stream<data_t> &din_i3, hls::stream<data_t> &din_q3,
    hls::stream<parallel_sample_t> &internal_out
);

void write_outputs(
    hls::stream<parallel_sample_t> &internal_out,
    hls::stream<data_t> &dout_i0, hls::stream<data_t> &dout_q0,
    hls::stream<data_t> &dout_i1, hls::stream<data_t> &dout_q1,
    hls::stream<data_t> &dout_i2, hls::stream<data_t> &dout_q2,
    hls::stream<data_t> &dout_i3, hls::stream<data_t> &dout_q3
);

void compute_pfb(
    hls::stream<parallel_sample_t> &internal_in,
    hls::stream<parallel_sample_t> &internal_out,
    const coeff_t coeff[TOTAL_SAMPLES]
);

void pfb_multichannel(
    hls::stream<data_t> &din_data_i0, hls::stream<data_t> &din_data_q0,
    hls::stream<data_t> &din_data_i1, hls::stream<data_t> &din_data_q1,
    hls::stream<data_t> &din_data_i2, hls::stream<data_t> &din_data_q2,
    hls::stream<data_t> &din_data_i3, hls::stream<data_t> &din_data_q3,

     hls::stream<data_t> &dout_data_i0, hls::stream<data_t> &dout_data_q0,
    hls::stream<data_t> &dout_data_i1, hls::stream<data_t> &dout_data_q1,
    hls::stream<data_t> &dout_data_i2, hls::stream<data_t> &dout_data_q2,
    hls::stream<data_t> &dout_data_i3, hls::stream<data_t> &dout_data_q3,

    const coeff_t coeff[TOTAL_SAMPLES] 
);

#endif