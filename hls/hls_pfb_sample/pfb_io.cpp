#include "pfb.h"

void read_inputs(
    hls::stream<data_t> &din_i0, hls::stream<data_t> &din_q0,
    hls::stream<data_t> &din_i1, hls::stream<data_t> &din_q1,
    hls::stream<data_t> &din_i2, hls::stream<data_t> &din_q2,
    hls::stream<data_t> &din_i3, hls::stream<data_t> &din_q3,
    hls::stream<parallel_sample_t> &internal_out
) {
    #pragma HLS INLINE
    #pragma HLS interface ap_none

    pack.ch[0].i = din_i0.read(); pack.ch[0].q = din_q0.read();
    pack.ch[1].i = din_i1.read(); pack.ch[1].q = din_q1.read();
    pack.ch[2].i = din_i2.read(); pack.ch[2].q = din_q2.read();
    pack.ch[3].i = din_i3.read(); pack.ch[3].q = din_q3.read();
}