#include "pfb.h"

void pfb_multichannel(
    hls::stream<data_t> &din_data_i0, hls::stream<data_t> &din_data_q0,
    hls::stream<data_t> &din_data_i1, hls::stream<data_t> &din_data_q1,
    hls::stream<data_t> &din_data_i2, hls::stream<data_t> &din_data_q2,
    hls::stream<data_t> &din_data_i3, hls::stream<data_t> &din_data_q3,

    hls::stream<data_32> &dout_data_0,
    hls::stream<data_32> &dout_data_1,
    hls::stream<data_32> &dout_data_2,
    hls::stream<data_32> &dout_data_3,

    const coeff_t coeff[TOTAL_SAMPLES] 
) {
    #pragma HLS INTERFACE axis port=din_data_i0
    #pragma HLS INTERFACE axis port=din_data_q0
    #pragma HLS INTERFACE axis port=din_data_i1
    #pragma HLS INTERFACE axis port=din_data_q1
    #pragma HLS INTERFACE axis port=din_data_i2
    #pragma HLS INTERFACE axis port=din_data_q2
    #pragma HLS INTERFACE axis port=din_data_i3
    #pragma HLS INTERFACE axis port=din_data_q3

    #pragma HLS INTERFACE axis port=dout_data_0
    #pragma HLS INTERFACE axis port=dout_data_1
    #pragma HLS INTERFACE axis port=dout_data_2
    #pragma HLS INTERFACE axis port=dout_data_3

    #pragma HLS INTERFACE m_axi port=coeff offset=slave bundle=gmem depth=4096 latency=64
    #pragma HLS INTERFACE s_axilite port=return bundle=control

    #pragma HLS DATAFLOW
    
    hls::stream<parallel_sample_t> stream_read_to_compute("s_r2c");
    hls::stream<parallel_sample_t> stream_compute_to_fft("s_c2f");
    hls::stream<parallel_sample_t> stream_fft_to_write("s_f2w");
    
    #pragma HLS STREAM variable=stream_read_to_compute depth=16
    #pragma HLS STREAM variable=stream_compute_to_fft depth=16
    #pragma HLS STREAM variable=stream_fft_to_write depth=16

    bool status;

    read_inputs(
        din_data_i0, din_data_q0, din_data_i1, din_data_q1, 
        din_data_i2, din_data_q2, din_data_i3, din_data_q3, 
        stream_read_to_compute
    );

    decimate_pfb(
        stream_read_to_compute,
        stream_compute_to_fft, 
        coeff
    );

    fft(
        stream_compute_to_fft,
        stream_fft_to_write,
        &status
    );

    write_outputs(
        stream_fft_to_write,
        dout_data_0, dout_data_1, dout_data_2, dout_data_3
    );
}