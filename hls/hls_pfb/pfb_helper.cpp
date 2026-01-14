#include "pfb.h"

void capture_status(
    hls::stream<status_t> &s0_in,
    hls::stream<status_t> &s1_in,
    hls::stream<status_t> &s2_in,
    hls::stream<status_t> &s3_in,
    bool* status_out
) {
    #pragma HLS INTERFACE ap_ctrl_hs port=return

    status_t s0 = s0_in.read();
    status_t s1 = s1_in.read();
    status_t s2 = s2_in.read();
    status_t s3 = s3_in.read();
    
    *status_out = s0.getOvflo() || s1.getOvflo() || s2.getOvflo() || s3.getOvflo();
}

void init_fft_config(
    hls::stream<config_t> &cfg0_s,
    hls::stream<config_t> &cfg1_s,
    hls::stream<config_t> &cfg2_s,
    hls::stream<config_t> &cfg3_s
) {
    #pragma HLS INTERFACE ap_ctrl_hs port=return

    config_t cfg0, cfg1, cfg2, cfg3;
    
    cfg0.setDir(1); cfg0.setSch(0x2AB);
    cfg1.setDir(1); cfg1.setSch(0x2AB);
    cfg2.setDir(1); cfg2.setSch(0x2AB);
    cfg3.setDir(1); cfg3.setSch(0x2AB);

    cfg0_s.write(cfg0);
    cfg1_s.write(cfg1);
    cfg2_s.write(cfg2);
    cfg3_s.write(cfg3);
}