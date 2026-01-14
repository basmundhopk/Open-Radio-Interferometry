#ifndef CORRELATOR_H
#define CORRELATOR_H

#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>
#include <complex>

#define NUM_CHANNELS 4
#define NUM_BASELINES 10
#define FFT_LEN 1024


typedef ap_int<16> data_16_t;

typedef ap_uint<32> input_axis_t;

typedef std::complex<ap_int<64>> complex_64_t;

typedef ap_uint<128> output_axis_t;

typedef std::complex<int> complex_32_t; 

void correlator (
    hls::stream<input_axis_t> &din_data_0,
    hls::stream<input_axis_t> &din_data_1,
    hls::stream<input_axis_t> &din_data_2,
    hls::stream<input_axis_t> &din_data_3,

    hls::stream<output_axis_t> &dout_data_00,
    hls::stream<output_axis_t> &dout_data_11,
    hls::stream<output_axis_t> &dout_data_22,
    hls::stream<output_axis_t> &dout_data_33,
    hls::stream<output_axis_t> &dout_data_01,
    hls::stream<output_axis_t> &dout_data_02,
    hls::stream<output_axis_t> &dout_data_03,
    hls::stream<output_axis_t> &dout_data_12,
    hls::stream<output_axis_t> &dout_data_13,
    hls::stream<output_axis_t> &dout_data_23,

    int integration_time_frames
);

std::complex<data_16_t> unpack(
    input_axis_t packed
);

output_axis_t pack_output(
    complex_64_t acc
);

#endif