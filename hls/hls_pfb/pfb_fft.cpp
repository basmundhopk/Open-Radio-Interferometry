#include "pfb.h"

void fft(
    hls::stream<parallel_sample_t> &internal_in,
    hls::stream<parallel_sample_t> &internal_out,
    bool* status
) {
    #pragma HLS INTERFACE ap_ctrl_hs port=return
    #pragma HLS dataflow
    
    hls::stream<std::complex<fft_data_t>> ch0_in("ch0_in"), ch0_out("ch0_out");
    hls::stream<std::complex<fft_data_t>> ch1_in("ch1_in"), ch1_out("ch1_out");
    hls::stream<std::complex<fft_data_t>> ch2_in("ch2_in"), ch2_out("ch2_out");
    hls::stream<std::complex<fft_data_t>> ch3_in("ch3_in"), ch3_out("ch3_out");

    #pragma HLS STREAM variable=ch0_in depth=1024
    #pragma HLS STREAM variable=ch0_out depth=1024
    #pragma HLS STREAM variable=ch1_in depth=1024
    #pragma HLS STREAM variable=ch1_out depth=1024
    #pragma HLS STREAM variable=ch2_in depth=1024
    #pragma HLS STREAM variable=ch2_out depth=1024
    #pragma HLS STREAM variable=ch3_in depth=1024
    #pragma HLS STREAM variable=ch3_out depth=1024

    hls::stream<config_t> cfg0_s, cfg1_s, cfg2_s, cfg3_s;
    hls::stream<status_t> stat0_s, stat1_s, stat2_s, stat3_s;

    init_fft_config(cfg0_s, cfg1_s, cfg2_s, cfg3_s);

    unpack(internal_in, ch0_in, ch1_in, ch2_in, ch3_in);

    hls::fft<config1>(ch0_in, ch0_out, stat0_s, cfg0_s);
    hls::fft<config1>(ch1_in, ch1_out, stat1_s, cfg1_s);
    hls::fft<config1>(ch2_in, ch2_out, stat2_s, cfg2_s);
    hls::fft<config1>(ch3_in, ch3_out, stat3_s, cfg3_s);

    repack(ch0_out, ch1_out, ch2_out, ch3_out, internal_out);

    capture_status(stat0_s, stat1_s, stat2_s, stat3_s, status);

}